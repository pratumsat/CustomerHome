/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper
import RealmSwift

class PreDeclareList : Object, Mappable {

    required convenience init?(map: Map) {
        self.init()
    }
    
	@objc dynamic var tariffSeqID = 0
	@objc dynamic var categoryID : String? = ""
	@objc dynamic var subCategoryID : String? = ""
	@objc dynamic var tariffID : String? = ""
	@objc dynamic var tariffNameEN : String? = ""
	@objc dynamic var tariffNameTH : String? = ""
	@objc dynamic var unitPrice = 0.0
	@objc dynamic var quantity = 0
	@objc dynamic var price = 0.0
	@objc dynamic var freight = 0.0
	@objc dynamic var insurance = 0.0
	@objc dynamic var freightInsurance = 0.0
	@objc dynamic var cif = 0.0

	@objc dynamic var importDutyRate = 0.0

	@objc dynamic var vatRate = 0.0

	
    
    
    // Add Parameter
    @objc dynamic var priceTHB = 0.0
    @objc dynamic var freightTHB = 0.0
    @objc dynamic var insuranceTHB = 0.0
    @objc dynamic var freightInsuranceTHB = 0.0
    @objc dynamic var cifTHB = 0.0
    @objc dynamic var importDutyTHB = 0.0
    @objc dynamic var vatTHB = 0.0
    @objc dynamic var taxDutyTHB = 0.0
    
    
    
    var tarriff: TariffList?
    
    convenience init(tariffSeqID: Int, tariffID: String, unitPrice: Double, quantity: Int) {
        self.init()
        self.tariffSeqID = tariffSeqID
        self.tariffID = tariffID
        self.unitPrice = unitPrice
        self.quantity = quantity
    }

    convenience init(tariffSeqID: Int, categoryID: String, subCategoryID: String, tariffID: String, tariffNameEN: String, tariffNameTH: String, unitPrice: Double, quantity: Int) {
        self.init()
        self.tariffSeqID = tariffSeqID
        self.categoryID = categoryID
        self.subCategoryID = subCategoryID
        self.tariffID = tariffID
        self.tariffNameEN = tariffNameEN
        self.tariffNameTH = tariffNameTH
        self.unitPrice = unitPrice
        self.quantity = quantity
    }
    
    convenience init(tariff:TariffList , price:Double, qty:Int ) {
        self.init()
        self.tarriff = tariff
        self.tariffSeqID = toInt( tariff.tariffSeqID )
        self.categoryID = tariff.categoryID
        self.subCategoryID = tariff.subCategoryID
        self.tariffID = tariff.tariffID
        self.tariffNameEN = tariff.tariffNameEN
        self.tariffNameTH = tariff.tariffNameTH
        self.unitPrice = price
        self.quantity = qty
    }
    


    var tariffName: String? {
        return convenientLangCompair(interLang: tariffNameEN, altLang: tariffNameTH)
    }
    func mapping(map: Map) {

        tariffSeqID <- map["tariffSeqID"]
        if tariffSeqID == 0 {
            tariffSeqID <- map["tariffSeqId"]
        }
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
        if cifTHB == 0 {
            cifTHB <- map["cifthb"]
        }
		importDutyRate <- map["importDutyRate"]
        importDutyTHB <- map["importDutyTHB"]
		vatRate <- map["vatRate"]
		vatTHB <- map["vatTHB"]
        taxDutyTHB <- map["taxDutyTHB"]
        
       
        
	}

}
