//
//  PaddingLabel.swift
//  Customs2Home
//
//  Created by thanawat on 12/3/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit

@IBDesignable class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 5.0
    @IBInspectable var rightInset: CGFloat = 5.0
    
    @IBInspectable var drawDashLine: Bool = false
    @IBInspectable var dashStrokeColor: UIColor = UIColor()
    @IBInspectable var lineWith: CGFloat = 1
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
        
        if drawDashLine {
            let path = UIBezierPath(roundedRect: rect, cornerRadius: 0)
            
            dashStrokeColor.setStroke()
            path.lineWidth = lineWith
            
            let dashPattern : [CGFloat] = [4, 4]
            path.setLineDash(dashPattern, count: 2, phase: 0)
            path.stroke()
        }
      
        
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
