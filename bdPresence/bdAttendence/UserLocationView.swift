//
//  UserLocationView.swift
//  bdPresence
//
//  Created by Raghvendra on 10/07/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import UIKit

class UserLocationView: UIView{
    
    @IBOutlet weak var userLocationTableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
            
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
