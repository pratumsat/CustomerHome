//
//  FAQHeaderViewCell.swift
//  Customs2Home
//
//  Created by thanawat on 10/31/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit

class FAQHeaderViewCell: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func bind(_ faqResp:FaqResp? = nil){
        titleLabel.text = faqResp?.faqGroupName
    }
}
