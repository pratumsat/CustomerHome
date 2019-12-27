//
//  StepView4ViewController.swift
//  Customs2Home
//
//  Created by warodom on 15/11/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit

class StepView4ViewController: UIView {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    
    @IBOutlet weak var viewLeft: UIView!
    @IBOutlet weak var viewCenter: UIView!
    @IBOutlet weak var viewRight: UIView!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        label1.makeRounded()
        label2.makeRounded()
        label3.makeRounded()
        label4.makeRounded()
    }

}
