//
//  StopDetailViewController.swift
//  Tyme
//
//  Created by elev on 29/11/2017.
//  Copyright © 2017 Mads Bock. All rights reserved.
//

import UIKit

class StopDetailViewController: UIViewController {
    @IBOutlet weak var detailLabel: UILabel!
    
    public static var selectedString : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailLabel.text = StopDetailViewController.selectedString
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
