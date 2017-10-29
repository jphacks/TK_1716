//
//  ViewController3.swift
//  interface
//
//  Created by Kento Ohtani on 2017/10/28.
//  Copyright © 2017年 Kento Ohtani. All rights reserved.
//

import UIKit

class ViewController3: UIViewController {
    
    var textVC3 : String = ""
    var URL : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        URL = textVC3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openURL() {
        
        let url = NSURL(string: URL)
        if UIApplication.shared.canOpenURL(url! as URL){
            UIApplication.shared.open(url! as URL)
        }
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
