//
//  C2HViewcontroller.swift
//  Customs2Home
//
//  Created by warodom on 26/9/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit

class C2HViewcontroller: UIViewController {
    
    @IBInspectable var isShowNavBar: Int = -1
    @IBInspectable var isShowBottomBar: Int = -1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (0...1).contains(isShowNavBar) {
            self.navigationController?.setNavigationBarHidden( isShowNavBar == 0 , animated: animated)
        }
        if (0...1).contains(isShowBottomBar) {
          self.tabBarController?.tabBar.isHidden = isShowBottomBar == 0
        }
    }
    
    func setThemeBackButton() -> UIBarButtonItem {
        let backButton = UIBarButtonItem(image: UIImage(named: "icnBack"), style: .plain, target: self, action: #selector(popview))
        return backButton
    }
    
    @objc func popview() {
        navigationController?.popViewController(animated: true)
    }
}
