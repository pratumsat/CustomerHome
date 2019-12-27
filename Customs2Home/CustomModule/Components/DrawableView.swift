//
//  DrawableView.swift
//  Customs2Home
//
//  Created by Wittawas Mukdaprasert on 4/9/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
@IBDesignable
class DrawableView:UIView {
//    override var cornerRadius: CGFloat = 0 {
//        didSet
//        {
//
//        }
//    }
//    @IBInspectable var cornerRadius: CGFloat = 0 {
//        didSet {
//        }
//    }
//    @IBInspectable var borderWidth: CGFloat = 0 {
//        didSet {
//            layer.borderWidth = borderWidth
//        }
//    }
//    @IBInspectable var borderColor: UIColor? {
//        didSet {
//            layer.borderColor = borderColor?.cgColor
//        }
//    }
    @IBInspectable var dropshadow: Bool = false {
        didSet {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.5
            layer.shadowOffset = .zero
            layer.shadowRadius = 4
        }
    }
}
