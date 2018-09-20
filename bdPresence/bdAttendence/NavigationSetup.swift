//
//  NavigationSetup.swift
//  bdPresence
//
//  Created by Raghvendra on 13/07/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import UIKit

extension UINavigationController{
    
    func removeTransparency(){
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
    }
}
