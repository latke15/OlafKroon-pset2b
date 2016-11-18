//
//  SecondViewController.swift
//  movielist2
//
//  Created by Olaf Kroon on 18/11/16.
//  Copyright © 2016 Olaf Kroon. All rights reserved.
// Displays the discription of a movie. 
//

import UIKit

class SecondViewController: UIViewController {
    
    
    var newData = String()

    
    @IBOutlet weak var plot: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("DATA IN SECOND VIEW CONTROLLER")
        print(newData)
        plot.text = newData
        
       
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
