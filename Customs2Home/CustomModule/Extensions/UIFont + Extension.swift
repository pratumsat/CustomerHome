//
//  UIFont + Extension.swift
//  Customs2Home
//
//  Created by warodom on 30/10/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit

extension UIFont {
    private static func customFont(name: String, size: CGFloat) -> UIFont {
        let font = UIFont(name: name, size: size)
        assert(font != nil, "Can't load font: \(name)")
        return font ?? UIFont.systemFont(ofSize: size)
    }
    
    static func mainFontRegular(ofSize size: CGFloat) -> UIFont {
        return customFont(name: "Prompt-Regular", size: size)
    }
    
    static func mainFontlight(ofSize size: CGFloat) -> UIFont {
        return customFont(name: "Prompt-Light", size: size)
    }
    
    static func mainFontSemiBold(ofSize size: CGFloat) -> UIFont {
        return customFont(name: "Prompt-SemiBold", size: size)
    }
    
    static func mainFontBold(ofSize size: CGFloat) -> UIFont {
        return customFont(name: "Prompt-Bold", size: size)
    }
    
}
