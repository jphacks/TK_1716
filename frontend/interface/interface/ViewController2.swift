//
//  ViewController2.swift
//  interface
//
//  Created by Kento Ohtani on 2017/10/28.
//  Copyright © 2017年 Kento Ohtani. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    
    var setYear : String = ""
    var setDate : String = ""
    
    @IBOutlet var yearLabelText2 : UILabel!
    @IBOutlet var dateLabelText2 : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        yearLabelText2.text = setYear
        dateLabelText2.text = setDate

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
