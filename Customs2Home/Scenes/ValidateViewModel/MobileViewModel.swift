//
//  MobileViewModel.swift
//  Customs2Home
//
//  Created by thanawat on 11/15/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import RxSwift
import RxCocoa
import Foundation

struct MobileViewModel : ValidationProtocol{
    var errorMessage = "เบอร์มือถือ ไม่ถูกต้อง"
    
    var data = BehaviorRelay<String>(value: "")
    
    var errorValue = BehaviorRelay<String?>(value: nil)
    
    func validateCredentials() -> Bool {
        guard validateLength(text: data.value, size: (10, 10)) else{
            errorValue.accept("\(errorMessage), จะต้องเป็นตัวเลข 10 ตัว")
            return false;
        }
        guard isValidMobile(mobile: data.value) else {
            errorValue.accept(errorMessage)
            return false
        }
        errorValue.accept(nil)
        return true
    }
    
    init(){
    }
    
    fileprivate func validateLength(text : String, size : (min : Int, max : Int)) -> Bool{
        return (size.min...size.max).contains(text.count)
    }
    func isValidMobile(mobile:String) -> Bool {
        let mobileRegEx = "^0[0-9]*$"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", mobileRegEx)
        return emailPred.evaluate(with: mobile)
    }
}
