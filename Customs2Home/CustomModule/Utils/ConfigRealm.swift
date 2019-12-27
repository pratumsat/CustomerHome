//
//  StorageRealm.swift
//  Customs2Home
//
//  Created by thanawat on 10/21/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import Foundation
import RealmSwift

class ConfigRealm {
    
    func deleteByCalTaxId(_ calTaxId:Int){
        let realm = ConfigRealm().getEncyptedRealm()
        if let object = realm?.objects(CalTaxResp.self).filter("calTaxId = %@", calTaxId).first {
            
            try! realm?.write {
                realm?.delete(object.preDeclare)
                realm?.delete(object)
                
            }
        }
    }
    func deleteByCalTaxResp(_ newValue:CalTaxResp){
        let realm = ConfigRealm().getEncyptedRealm()
        if let object = realm?.objects(CalTaxResp.self).filter("calTaxId = %@", newValue.calTaxId).first {
            
            try! realm?.write {
                realm?.delete(object.preDeclare)
                realm?.delete(object)
                
            }
        }
    }
    
    func addCalTaxResp(_ newValue:CalTaxResp){
        let realm = ConfigRealm().getEncyptedRealm()
        if let object = realm?.objects(CalTaxResp.self).filter("calTaxId = %@", newValue.calTaxId).first {
            try! realm?.write {
                
                object.totalCostTHB = newValue.totalCostTHB
                object.totalInsuranceTHB = newValue.totalInsuranceTHB
                object.totalFreightTHB = newValue.totalFreightTHB
                object.totalCifTHB = newValue.totalCifTHB
                object.totalDutyTHB = newValue.totalDutyTHB
                object.totalVatTHB = newValue.totalVatTHB
                object.totalTaxTHB = newValue.totalTaxTHB

                object.totalTaxDisplay = newValue.totalTaxDisplay
                object.flagCurrencyCurrent = newValue.flagCurrencyCurrent
                object.currencyCode = newValue.currencyCode
                object.exchangeRate = newValue.exchangeRate
                object.rateFactor  = newValue.rateFactor
                object.exchangeRateSeqId = newValue.exchangeRateSeqId
                object.currencyImage = newValue.currencyImage
                object.freight = newValue.freight
                object.insurance = newValue.insurance
                
                realm?.delete(object.preDeclare)
                let preDeclareList = newValue.preDeclareList
                preDeclareList?.forEach({ (model) in
                    object.preDeclare.append(model)
                })
            }

        }else {
            newValue.calTaxId = CalTaxResp().IncrementaID()
            let preDeclareList = newValue.preDeclareList
            preDeclareList?.forEach({ (model) in
                newValue.preDeclare.append(model)
            })
           
            try! realm?.write {
                realm?.add(newValue)
            }
        }
        
    }
    
    func getCalTaxResp() -> Results<CalTaxResp>? {
        return ConfigRealm().getEncyptedRealm()?.objects(CalTaxResp.self)
    }
    
    func getCalTaxRespById(calTaxId:Int) -> CalTaxResp? {
        let realm = ConfigRealm().getEncyptedRealm()
        return realm?.objects(CalTaxResp.self).filter("calTaxId = %@", calTaxId).first
    }
    
    func getEncyptedRealm() -> Realm? {
        let encyptedConfig = Realm.Configuration(encryptionKey: "c2h!(QtoaWQdifsSKLLWj".sha512() )
        return try? Realm(configuration: encyptedConfig)
    }
}
