//
//  SplashViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 20/07/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController{
    
    
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundView.applyGradient(isTopBottom: true, colorArray: [APPColor.BlueGradient,APPColor.GreenGradient])
        
        self.welcomeLabel.font = APPFONT.CHARTINFO
        self.welcomeLabel.textColor = UIColor.white
        self.welcomeLabel.text = "Welcome"
        
        self.aboutLabel.font = APPFONT.FOOTERBODY
        self.aboutLabel.textColor = UIColor.white
        self.aboutLabel.text = "Bluedolphin is the convenient platform for attendance at work.It is very simple.Let's begin now"
        
        self.loginButton.layer.cornerRadius = 15.0
        self.loginButton.applyGradient(isTopBottom: true, colorArray: [APPColor.BlueGradient,APPColor.GreenGradient])
        self.loginButton.clipsToBounds = true
        self.loginButton.titleLabel?.font = APPFONT.FOOTERBODY
        self.loginButton.tintColor = UIColor.white
        self.loginButton.addTarget(self, action: #selector(loginButtonAction), for: UIControlEvents.touchUpInside)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loginButtonAction(){
        
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
