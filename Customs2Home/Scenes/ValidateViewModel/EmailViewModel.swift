//
//  File.swift
//  Customs2Home
//
//  Created by thanawat on 11/6/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import RxSwift
import RxCocoa
import Foundation

struct EmailViewModel : ValidationProtocol{
    var errorMessage = "ข้อมูลอีเมล์ไม่ถูกต้อง"
    
    var data = BehaviorRelay<String>(value: "")
    
    var errorValue = BehaviorRelay<String?>(value: nil)
    
    func validateCredentials() -> Bool {
        guard isValidEmail(emailStr: data.value) else {
            errorValue.accept(errorMessage)
            return false
        }
        errorValue.accept(nil)
        return true
    }
    
    init(){
    }
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
}
