//
//  NewCheckOutUserScreen.swift
//  bdPresence
//
//  Created by Raghvendra on 11/07/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import UIKit

class NewCheckOutUserScreen: UIViewController{
    
    
    var delegate: HandleUserViewDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.rowHeight = 50
    }
    
}

extension NewCheckOutUserScreen: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
        
        if scrollView.contentOffset.y < -50 {
            tableView.isScrollEnabled = false
            delegate?.handleOnSwipe()
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewCheckOutUserScreenCell", for: indexPath)
        return cell
    }
    
    
    
}
