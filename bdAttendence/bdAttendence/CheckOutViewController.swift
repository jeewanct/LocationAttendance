//
//  CheckOutViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 18/04/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit

class CheckOutViewController: UIViewController {

    @IBOutlet weak var lastCheckinLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressBar: UICircularProgressRingView!
    override func viewDidLoad() {
        super.viewDidLoad()
       progressBar.maxValue = 540
        let value = 220
     progressBar.setProgress(value: CGFloat(value), animationDuration: 5.0) {
        self.progressLabel.text = "\(value) hours"
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func checkoutAction(_ sender: Any) {
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
