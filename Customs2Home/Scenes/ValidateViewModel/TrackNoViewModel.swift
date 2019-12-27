//
//  TrackNoViewModel.swift
//  Customs2Home
//
//  Created by thanawat on 12/16/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import RxSwift
import RxCocoa
import Foundation

struct TrackNoViewModel : ValidationProtocol{
    var errorMessage = "Tracking No. ไม่ถูกต้อง"
    
    var data = BehaviorRelay<String>(value: "")
    
    var errorValue = BehaviorRelay<String?>(value: nil)
    let disposeBag = DisposeBag()
    
    func validateCredentials() -> Bool {
       
        guard validateTrackingNo(text: data.value) else{
            errorValue.accept("\(errorMessage)")
            return false;
        }
        
        errorValue.accept(nil)
        return true
    }
    
    init(){
    }
   
    fileprivate func validateTrackingNo(text : String) -> Bool{
        let specialCharacterRegEx  = "[a-z-A-Z]{2,2}[0-9]{9,9}[a-z-A-Z]{2,2}"
        let specialPred = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        return specialPred.evaluate(with: text)
    }
    
}
