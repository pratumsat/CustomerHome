//
//  StepViewControlller.swift
//  Customs2Home
//
//  Created by warodom on 8/11/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import Foundation
import UIKit

class StepViewControlller: UIView {
    
    @IBOutlet var view1: UIButton!
    @IBOutlet var view2: UIButton!
    @IBOutlet var view3: UIButton!
    @IBOutlet weak var lineleft: UIView!
    @IBOutlet weak var lineRight: UIView!
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */

    override func awakeFromNib() {
        view1.makeRounded()
        view2.makeRounded()
        view3.makeRounded()
    }
}
