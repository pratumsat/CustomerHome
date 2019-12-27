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

class CalTaxResp : Object, Mappable {
	
	@objc dynamic var totalTaxDisplay  = 0
	@objc dynamic var flagCurrencyCurrent : String? = ""
    @objc dynamic var currencyCode : String? = ""
    @objc dynamic var exchangeRate  = 0.0
    @objc dynamic var rateFactor  = 0.0
    var preDeclareList : [PreDeclareList]?
    @objc dynamic var exchangeRateSeqId : Int = 0
    @objc dynamic var currencyImage : String = ""
    @objc dynamic var freight = 0.0
    @objc dynamic var insurance = 0.0
    @objc dynamic var calTaxId  = 0
    var preDeclare = List<PreDeclareList>()

    
    // Add
    @objc dynamic var totalCostTHB = 0.0
    @objc dynamic var totalInsuranceTHB = 0.0
    @objc dynamic var totalFreightTHB = 0.0
    @objc dynamic var totalCifTHB = 0.0
    @objc dynamic var totalDutyTHB = 0.0
    @objc dynamic var totalVatTHB = 0.0
    @objc dynamic var totalTaxTHB = 0.0
    
    
    override class func primaryKey() -> String {
        return "calTaxId"
    }
    func IncrementaID() -> Int{
        let realm = ConfigRealm().getEncyptedRealm()!
        if let retNext = realm.objects(CalTaxResp.self).sorted(byKeyPath: "calTaxId").last?.calTaxId {
            return retNext + 1
        }else{
            return 1
        }
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
	 func mapping(map: Map) {

        totalCostTHB <- map["totalCostTHB"]
        totalInsuranceTHB <- map["totalInsuranceTHB"]
        totalFreightTHB <- map["totalFreightTHB"]
        totalCifTHB <- map["totalCifTHB"]
        totalDutyTHB <- map["totalDutyTHB"]
        totalVatTHB <- map["totalVatTHB"]
        totalTaxTHB <- map["totalTaxTHB"]
		totalTaxDisplay <- map["totalTaxDisplay"]
		flagCurrencyCurrent <- map["flagCurrencyCurrent"]
        currencyCode <- map["currencyCode"]
        exchangeRate <- map["exchangeRate"]
        rateFactor <- map["rateFactor"]
		preDeclareList <- map["preDeclareList"]
	}

}
