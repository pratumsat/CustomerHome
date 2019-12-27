//
//  FullNameViewModel.swift
//  Customs2Home
//
//  Created by thanawat on 12/2/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import RxSwift
import RxCocoa
import Foundation

struct FullNameViewModel : ValidationProtocol{
    var errorMessage = "ชื่อและนามสกุลต้องเป็นภาษาไทย และมีอย่างละไม่น้อยกว่า 2 ตัวอักษร"
    
    var data = BehaviorRelay<String>(value: "")
    
    var errorValue = BehaviorRelay<String?>(value: nil)
    
    func validateCredentials() -> Bool {
        //        guard validateLength(text: data.value, size: (2, 100)) else{
        //            errorValue.accept("\(errorMessage), จะต้องมากกว่า 2 ตัวอักษร")
        //            return false;
        //        }
        guard isValidName(name: data.value) else {
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
    func isValidName(name:String) -> Bool {
        let nameRegEx = "^[ก-๏\\s]{2,200}$"
        
        let namePred = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return namePred.evaluate(with: name)
    }
}
