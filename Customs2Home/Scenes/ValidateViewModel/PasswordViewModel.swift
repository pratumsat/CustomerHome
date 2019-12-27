//
//  PasswordViewModel.swift
//  Customs2Home
//
//  Created by thanawat on 11/6/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import RxSwift
import RxCocoa
import Foundation

struct PasswordViewModel : ValidationProtocol{
    var errorMessage = "รหัสผ่านต้องมีอย่างน้อย 8 ตัวอักษรซึ่งประกอบด้วย a-z และ A-Z และตัวเลข 0-9 รวมถึงเครื่องหมายหรืออักขระพิเศษ"
    
    var data = BehaviorRelay<String>(value: "")
    
    var errorValue = BehaviorRelay<String?>(value: nil)
    let disposeBag = DisposeBag()
    
    func validateCredentials() -> Bool {
        guard validateLength(text: data.value, size: (8, 100)) else{
            errorValue.accept(errorMessage)
            return false;
        }
        guard validateNumberAndCharacter(text: data.value) else{
            errorValue.accept(errorMessage)
            return false;
        }
        guard validateCapital(text: data.value) else{
//            errorValue.accept("\(errorMessage), จะต้องมีตัวพิมพ์ใหญ่ 1 ตัว")
            errorValue.accept(errorMessage)
            return false;
        }
        guard validateSpecial(text: data.value) else{
//            errorValue.accept("\(errorMessage), จะต้องมีตัวอัษรพิเศษ 1 ตัว")
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
    
    fileprivate func validateNumberAndCharacter(text : String) -> Bool{
        let capitalLetterRegEx  = ".*[a-z]+.*"
        let capitalLetterNumberRegEx  = ".*[0-9]+.*"
        
        return NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx).evaluate(with: text)
            && NSPredicate(format:"SELF MATCHES %@", capitalLetterNumberRegEx).evaluate(with: text)
    }
    
    fileprivate func validateCapital(text : String) -> Bool{
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        return passwordPred.evaluate(with: text)
    }
    fileprivate func validateSpecial(text : String) -> Bool{
        let specialCharacterRegEx  = ".*[!&^%$#@()/_*+-]+.*"
        let specialPred = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        return specialPred.evaluate(with: text)
    }
    
}
