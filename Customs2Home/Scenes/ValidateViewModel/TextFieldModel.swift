//
//  TextFieldModel.swift
//  Customs2Home
//
//  Created by thanawat on 11/12/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import RxSwift
import RxCocoa
import Foundation

struct TextFieldViewModel : ValidationProtocol{
    var nameTextField:String?
    var errorMessage = "กรุณากรอกข้อมูลให้ครบถ้วน"
    
    var data = BehaviorRelay<String>(value: "")
    
    var errorValue = BehaviorRelay<String?>(value: nil)
    
    func validateCredentials() -> Bool {
        guard !data.value.isEmpty else {
            errorValue.accept(errorMessage)
            return false
        }
        errorValue.accept(nil)
        return true
    }
    
    init(errorMessage:String = "กรุณากรอกข้อมูลให้ครบถ้วน"){
        self.errorMessage = errorMessage
    }
}
