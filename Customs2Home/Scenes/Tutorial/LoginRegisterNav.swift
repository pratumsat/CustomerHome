//
//  LoginRegisterNav.swift
//  Customs2Home
//
//  Created by thanawat on 12/19/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState

class LoginRegisterNav: UINavigationController {
    
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    
    var showLoginRegister = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
}

extension LoginRegisterNav {
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear")
           
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "checkLogin"),
                                        object: nil, userInfo: [:])
    }
    
}

