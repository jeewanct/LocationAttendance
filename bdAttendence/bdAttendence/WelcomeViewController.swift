//
//  WelcomeViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 17/04/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBAction func checkinAction(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "errorView") as? CheckinErrorViewController
        
        self.present(controller!, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

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
