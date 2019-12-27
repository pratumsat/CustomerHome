//
//  RequestDelayTest.swift
//  Customs2Home
//
//  Created by Wittawas Mukdaprasert on 3/9/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class RequestDelayTest:NSObject {
    enum RespondType {
        case success
        case error
    }
    
    let signal:PublishSubject<String> = PublishSubject()
    var requestDelay:Int = 3
    
    var respondType:RespondType = .success
    
    func begin() -> Observable<Bool>  {
        
        let obs = PublishSubject<Bool>()
        
        self.delay(delay: Double(requestDelay), closure: {
            switch self.respondType
            {
            case .success:
                obs.onNext(true)
                obs.onCompleted()
                break
            case .error:
//                obs.onNext("Error")
                obs.onError( KError.commonError(message: "Error") )
                break
            }
        })
        
        return obs.asObserver()
        
    }
}

//extension Reactive where Base : RequestDelayTest {
//}
