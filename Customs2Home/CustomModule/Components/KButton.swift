//
//  KButton.swift
//  VRT Mobile
//
//  Created by Kemin Suenggittawisuthi on 26/7/2562 BE.
//  Copyright © 2562 Kemin Suenggittawisuthi. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

@IBDesignable
class KButton: UIButton {
    var disposeBag:DisposeBag? = nil
    var content:Any?
    
    @IBInspectable var numberOfLine:Int = 1{
        didSet {
            self.titleLabel?.numberOfLines = numberOfLine
        }
    }
    override var isEnabled: Bool {
        didSet {
            if (self.isEnabled == false) {
                self.alpha = 0.5
            } else {
                self.alpha = 1.0
            }
        }
    }
    
    override func awakeFromNib() {
        if (!self.isEnabled){
            self.alpha = 0.5
        }
    }
    
    
}
