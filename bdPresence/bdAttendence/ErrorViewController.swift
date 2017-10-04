//
//  ErrorViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 17/07/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit

class ErrorViewController: UIViewController {

    @IBOutlet weak var transmitButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.textAlignment = .center
        errorLabel.text = "Your session has timed out!"
        errorLabel.font = APPFONT.BODYTEXT
        self.transmitButton.layer.cornerRadius = 15.0
        self.transmitButton.applyGradient(isTopBottom: true, colorArray: [APPColor.BlueGradient,APPColor.GreenGradient])
        self.transmitButton.clipsToBounds = true
        self.transmitButton.titleLabel?.font = APPFONT.FOOTERBODY
        self.transmitButton.tintColor = UIColor.white
        self.transmitButton.addTarget(self, action: #selector(transmitButtonAction), for: UIControlEvents.touchUpInside)
        // Do any additional setup after loading the view.
    }

    func transmitButtonAction(){
        self.dismiss(animated: true, completion: nil)
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
