//
//  NewLoginViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 21/06/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit

class NewLoginViewController: UIViewController {
    @IBOutlet weak var mobileTextfield: UITextField!

    @IBOutlet weak var sendOtpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        self.view.applyGradient(isTopBottom: true, colorArray: [APPColor.BlueGradient,APPColor.GreenGradient])
        self.sendOtpButton.layer.cornerRadius = 10.0
        self.sendOtpButton.clipsToBounds = true
        self.sendOtpButton.addTarget(self, action: #selector(sendOtpAction), for: UIControlEvents.touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    func sendOtpAction(){
        self.performSegue(withIdentifier: "showOtpScreen", sender: nil)
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
