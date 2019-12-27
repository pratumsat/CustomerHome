//
//  ToggleButton.swift
//  Customs2Home
//
//  Created by thanawat on 11/28/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit

class ToggleButton: UIButton {
    // Images
    let checkedImage = UIImage(named: "ic_eyeGreen")! as UIImage
    let uncheckedImage = UIImage(named: "ic_eyeGray")! as UIImage
    
    var toggle:((_ check:Bool)->Void)?
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                let original = checkedImage.withRenderingMode(.alwaysOriginal)
                self.setImage(original, for: UIControl.State.normal)
            } else {
                let original = uncheckedImage.withRenderingMode(.alwaysOriginal)
                self.setImage(original, for: UIControl.State.normal)
            }
            self.toggle?(isChecked)
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        
        let original = uncheckedImage.withRenderingMode(.alwaysOriginal)
        self.setImage(original, for: UIControl.State.normal)
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        
        let original = uncheckedImage.withRenderingMode(.alwaysOriginal)
        self.setImage(original, for: UIControl.State.normal)
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
