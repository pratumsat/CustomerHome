//
//  AddEditTariffList.swift
//  Customs2Home
//
//  Created by thanawat on 12/12/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//


import Foundation
import ObjectMapper

struct AddEditTariffList : Mappable {
    
    var tariffSeqID : Int?
    var categoryID : String?
    var subCategoryID : String?
    var tariffID : String?
    var tariffNameEN : String?
    var tariffNameTH : String?
    var unitPrice : Double?
    var quantity : Int?
    var price : Double?
    var freight : Double?
    var insurance : Double?
    var freightInsurance : Double?
    var cif : Double?
    var importDutyRate: Double?
    var vatRate: Double?
    var priceTHB: Double?
    var freightTHB: Double?
    var insuranceTHB: Double?
    var freightInsuranceTHB : Double?
    var cifTHB : Double?
    var importDutyTHB : Double?
    var vatTHB : Double?
    var taxDutyTHB : Double?
    
    init?(map: Map) {
        
    }
    var tariffName:String? {
        return convenientLangCompair(interLang: tariffNameEN, altLang: tariffNameTH)
    }
    init(tariffSeqID : Int?,
         categoryID : String?,
         subCategoryID : String?,
         tariffID : String?,
         tariffNameEN : String?,
         tariffNameTH : String?,
         unitPrice : Double?,
         quantity : Int?,
         price : Double?,
         freight : Double?,
         insurance : Double?,
         freightInsurance : Double?,
         cif : Double?,
         importDutyRate: Double?,
         vatRate: Double?,
         priceTHB: Double?,
         freightTHB: Double?,
         insuranceTHB: Double?,
         freightInsuranceTHB : Double?,
         cifTHB : Double?,
         importDutyTHB : Double?,
         vatTHB : Double?,
         taxDutyTHB : Double?) {
        
        self.tariffSeqID = tariffSeqID
        self.categoryID = categoryID
        self.subCategoryID = subCategoryID
        self.tariffID = tariffID
        self.tariffNameEN = tariffNameEN
        self.tariffNameTH = tariffNameTH
        self.unitPrice = unitPrice
        self.quantity = quantity
        self.price = price
        self.freight = freight
        self.insurance = insurance
        self.freightInsurance = freightInsurance
        self.cif = cif
        self.importDutyRate = importDutyRate
        self.vatRate = vatRate
        self.priceTHB = priceTHB
        self.freightTHB = freightTHB
        self.insuranceTHB = insuranceTHB
        self.freightInsuranceTHB = freightInsuranceTHB
        self.cifTHB = cifTHB
        self.importDutyTHB = importDutyTHB
        self.vatTHB = vatTHB
        self.taxDutyTHB = taxDutyTHB
    }
    
    mutating func mapping(map: Map) {
        tariffSeqID <- map["tariffSeqID"]
        categoryID <- map["categoryID"]
        subCategoryID <- map["subCategoryID"]
        tariffID <- map["tariffID"]
        tariffNameEN <- map["tariffNameEN"]
        tariffNameTH <- map["tariffNameTH"]
        unitPrice <- map["unitPrice"]
        quantity <- map["quantity"]
        price <- map["price"]
        priceTHB <- map["priceTHB"]
        freight <- map["freight"]
        freightTHB <- map["freightTHB"]
        insurance <- map["insurance"]
        insuranceTHB <- map["insuranceTHB"]
        freightInsurance <- map["freightInsurance"]
        freightInsuranceTHB <- map["freightInsuranceTHB"]
        cif <- map["cif"]
        cifTHB <- map["cifTHB"]
        importDutyRate <- map["importDutyRate"]
        importDutyTHB <- map["importDutyTHB"]
        vatRate <- map["vatRate"]
        vatTHB <- map["vatTHB"]
        taxDutyTHB <- map["taxDutyTHB"]
        
    }
    
}

