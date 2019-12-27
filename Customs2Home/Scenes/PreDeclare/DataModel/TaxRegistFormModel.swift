//
//  TaxRegistFormModel.swift
//  Customs2Home
//
//  Created by Wittawas Mukdaprasert on 5/9/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TaxRegistFormModel: FormModel {
    let searchPinLocation = BehaviorRelay<String?>(value: nil)
    let searchItemType = BehaviorRelay<String?>(value: nil)
    let searchItemSubType = BehaviorRelay<String?>(value: nil)
    let searchItemIndex = BehaviorRelay<String?>(value: nil)
    
    let pricePerItems = BehaviorRelay<String?>(value: nil)
    let itemsCount = BehaviorRelay<String?>(value: nil)
    
    let transferPrice = BehaviorRelay<String?>(value: nil)
    let warrantyPrice = BehaviorRelay<String?>(value: nil)
    
    override func mapping() -> [BindingData] {
        var map = [BindingData]()
        map.append( BindingData(binder: searchPinLocation, textKey: "searchPinLocation") )
        map.append( BindingData(binder: searchItemType, textKey: "searchItemType") )
        map.append( BindingData(binder: searchItemSubType, textKey: "searchItemSubType") )
        map.append( BindingData(binder: searchItemIndex, textKey: "searchItemIndex") )
        
        map.append( BindingData(binder: pricePerItems, textKey: "pricePerItems") )
        map.append( BindingData(binder: itemsCount, textKey: "itemsCount") )
        
        map.append( BindingData(binder: transferPrice, textKey: "transferPrice") )
        map.append( BindingData(binder: warrantyPrice, textKey: "warrantyPrice") )
        return map
    }
    
}
