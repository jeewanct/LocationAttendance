//
//  CheckinSuccessViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 18/04/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit

class CheckinSuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        delayWithSeconds(3.0) {
            self.moveToCheckout()
        }

        // Do any additional setup after loading the view.
    }

    func moveToCheckout(){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "checkout") as? CheckOutViewController
        self.show(controller!, sender: nil)
        
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
