//
//  FormModel.swift
//  VRT Mobile
//
//  Created by Wittawas Mukdaprasert on 26/8/2562 BE.
//  Copyright © 2562 Kemin Suenggittawisuthi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FormModel: NSObject {
    
    override var description: String{
        let mirror = Mirror(reflecting: self)
        let mutableStr = NSMutableString()
        mutableStr.append( super.description + "\n" )
        mirror.children.forEach { (child) in
            mutableStr.append( toString( child.label ) + ": " )
            if let value = child.value as? BehaviorRelay<String?>{
                mutableStr.append( "<String> value(\(toString( value.value )))" )
            }
            mutableStr.append("\n")
        }
        return mutableStr as String
    }
    
    lazy var map:[BindingData]! = {
        return self.mapping()
    }()
    
    
    func mapping() -> [BindingData] {
        fatalError("Implement this function")
    }
}

struct BindingData {
    enum BindType {
        case text
        case kTextError
    }
    var binder:Any
    var textKey:String
    var type:BindType
    var customBind: ( ( _ view:UIView)->Disposable? )?
    var customData: ( ( _ data:UIView) -> Void )?
    
    init(binder:Any,textKey:String) {
        self.binder = binder
        self.textKey = textKey
        self.type = .text
        self.customBind = nil
    }
    init(binder:Any,textKey:String,type:BindType) {
        self.binder = binder
        self.textKey = textKey
        self.type = type
        self.customBind = nil
    }
    
    func getRelay() -> BehaviorRelay<String?>?
    {
        if let relay = binder as? BehaviorRelay<String?> {
            return relay
        }
        return nil
    }
}

//protocol FormModelProtocol {
//    @require
//}
