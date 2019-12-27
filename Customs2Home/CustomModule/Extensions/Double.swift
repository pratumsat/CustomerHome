//
//  Double.swift
//  Customs2Home
//
//  Created by thanawat on 10/17/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import Foundation

extension Double {
    private static var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits  = 2
        numberFormatter.maximumFractionDigits  = 2
        numberFormatter.roundingMode = .down
        
        return numberFormatter
    }()
    
    var delimiter: String {
        return Double.numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
