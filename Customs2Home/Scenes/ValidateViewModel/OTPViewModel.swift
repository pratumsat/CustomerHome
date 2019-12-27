//
//  OTPTextFieldModel.swift
//  Customs2Home
//
//  Created by thanawat on 11/21/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation

struct OTPViewModel : ValidationProtocol{
    var errorMessage = "รหัส OTP ไม่ถูกต้อง"
    
    var data = BehaviorRelay<String>(value: "")
    
    var errorValue = BehaviorRelay<String?>(value: nil)
    
    func validateCredentials() -> Bool {
        guard validateLength(text: data.value, size: (6, 6)) else{
            errorValue.accept(errorMessage)
            return false;
        }
        errorValue.accept(nil)
        return true
    }
    
    init(){
    }
    
    fileprivate func validateLength(text : String, size : (min : Int, max : Int)) -> Bool{
        return (size.min...size.max).contains(text.count)
    }
    
}
