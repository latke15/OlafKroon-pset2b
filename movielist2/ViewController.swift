//
//  ViewController.swift
//  movielist2
//
//  Created by Olaf Kroon on 17/11/16.
//  Copyright © 2016 Olaf Kroon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchMovie: UITextField!
    @IBOutlet weak var enterMovie: UIButton!
    var counter = Int()
    
    var titles: [String] = []
    var data = [String: String]()
    var showRating = [String: String]()
    var showImage = [String: String]()
    var showPlot = [String: String]()
    var checkTitle = String()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //If cell is pressed. Segue data to a next view.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        checkTitle = titles[indexPath.row]
        print(checkTitle)
        self.performSegue(withIdentifier: "nextView", sender: nil)
        
    }
    
    // Make the rows editable.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    // Enable the user to delete rows. 
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            titles.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    // A segue function that is called when a row is pressed.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination: SecondViewController = segue.destination as! SecondViewController
        destination.newData = self.showPlot[checkTitle]!
    }

    // A function that returns the number of rows in the tableview.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    //  Updata the rows in tableview.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieCell
        
        cell.title.text = titles[indexPath.row]
        
        if let rating = showRating[titles[indexPath.row]]{
            cell.rating.text = rating
        }
        
    
    

    // Functions to download an image with source: http://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
        
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
            URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                completion(data, response, error)
                }.resume()
    }
        
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                cell.poster.image = UIImage(data: data)
            }
        }
    }
        
        // Put an image in the image view of every cell
        if let image = showImage[titles[indexPath.row]] {
            if let checkedUrl = URL(string: image) {
                cell.poster.contentMode = .scaleAspectFit
                downloadImage(url: checkedUrl)
            }
           print("End of code. The image will continue downloading in the background and it will be loaded when it ends.")
        }
        
        // Return the content of the cell.
        return cell
    }
    
    // If the button is clicked get a json from the title the user has given.
    @IBAction func getJson(_ sender: Any) {
        if enterMovie.isTouchInside {
            var searchRequest = String()
            let filler = searchMovie.text?.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
            searchRequest = "https://www.omdbapi.com/?t="+filler!+"&y=&plot=short&r=json"

            
            // Get a json from an URL source: http://stackoverflow.com/questions/38292793/http-requests-in-swift-3
            
            let url = URL(string: searchRequest)
            let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                guard error == nil else {
                    print("error")
                    return
                }
                guard let data = data else {
                    print("Data is empty")
                    return
                }
                
                // Get status code
                let httpResponse = response as! HTTPURLResponse
                print("STATUSCODE: ", httpResponse.statusCode)
                
                // Parse the data into a json
                let json = try! JSONSerialization.jsonObject(with: data, options: [])
                
                // Put the json into a dictionary
                self.data = json as! [String : String]

                
                //Add an item to titles array
                if self.data["Title"] != nil {
                self.titles.append(self.data["Title"]!)
                
                // add a rating to the showRating dictionary with Title as key
                self.showRating[self.data["Title"]!] = self.data["imdbRating"]
                
                //add a image url to the showImage dictionary with Title as key
                self.showImage[self.data["Title"]!] = self.data["Poster"]
                    
                self.showPlot[self.data["Title"]!] = self.data["Plot"]
                    
                self.tableView.reloadData()
                
                }
            }
        task.resume()
        self.loadView()
        }
    }
}



