//
//  ViewController.swift
//  movielist2
//
//  Created by Olaf Kroon on 17/11/16.
//  Copyright © 2016 Olaf Kroon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchMovie: UITextField!
    @IBOutlet weak var enterMovie: UIButton!
    var counter = Int()
    
    var titles: [String] = []
    var data = [String: String]()
    var showRating = [String: String]()
    var showImage = [String: String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titles.count
    }
    
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
            print("Download Started")
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
            print("Begin of code")
            if let checkedUrl = URL(string: image) {
                cell.poster.contentMode = .scaleAspectFit
                downloadImage(url: checkedUrl)
            }
            print("End of code. The image will continue downloading in the background and it will be loaded when it ends.")
            
            
        }

        
    
        
        return cell
    }
    
    
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
//                print("JSON)")
//                print(json)
                self.data = json as! [String : String]
//                print(self.data)
//                print("title")
//                print(self.data["Title"]!)
//                print("LINK")
//                print(self.data["Poster"]!)
                
                //HIER NOG IF LET
                
                //Add an item to titles array
                if self.data["Title"] != nil {
                self.titles.append(self.data["Title"]!)
                
                // add a rating to the showRating dictionary with Title as key
                self.showRating[self.data["Title"]!] = self.data["imdbRating"]
                
                //add a image url to the showImage dictionary with Title as key
                self.showImage[self.data["Title"]!] = self.data["Poster"]
                
//                print("THESE ARE THE TITLES: ", self.titles)
//                
//                print("SHOWRATING: ", self.showRating)
                }

                
            }
            
            task.resume()
            self.loadView()
            
            
        }
        

        }
    
    
    
    }



