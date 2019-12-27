//
//  SetPasswordNav.swift
//  Customs2Home
//
//  Created by thanawat on 11/26/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit

class SetPasswordNav: UINavigationController {

    var data:(Int,String)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func getData() -> (Int,String)? {
        return data
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
