/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct DeclareAddEditReq : Mappable {
	
    var trackingID : String?
    var name : String?
    var address : String?
    var mobileNo : String?
    var email : String?
    var totalCostTHB : Double?
    var totalInsuranceTHB : Double?
    var totalFreightTHB : Double?
    var totalCifTHB : Double?
    var totalDutyTHB : Double?
    var totalVatTHB : Double?
    var totalTaxTHB : Double?
    var totalTaxDisplay : Int?
    var exchangeRateSeqId : Int?
    var currencyCode : String?
    var exchangeRate : Double?
    var rateFactor : Double?
    var paymentMethod : String?
    var status : String?
    var tariffList : [AddEditTariffList]?
    

    var calTaxId:Int? //for delete
    

    
	init?(map: Map) {

	}
    
    init(totalCostTHB : Double?,
         totalInsuranceTHB : Double?,
         totalFreightTHB : Double?,
         totalCifTHB : Double?,
         totalDutyTHB : Double?,
         totalVatTHB : Double?,
         totalTaxTHB : Double?,
         totalTaxDisplay : Int?,
         exchangeRateSeqId : Int?,
         currencyCode : String?,
         exchangeRate : Double?,
         rateFactor : Double?,
         tariffList : [AddEditTariffList]?,
         status : String?) {
        
        self.totalCostTHB = totalCostTHB
        self.totalInsuranceTHB = totalInsuranceTHB
        self.totalFreightTHB = totalFreightTHB
        self.totalCifTHB = totalCifTHB
        self.totalDutyTHB = totalDutyTHB
        self.totalVatTHB = totalVatTHB
        self.totalTaxTHB = totalTaxTHB
        self.totalTaxDisplay = totalTaxDisplay
        self.exchangeRateSeqId = exchangeRateSeqId
        self.currencyCode = currencyCode
        self.exchangeRate = exchangeRate
        self.rateFactor = rateFactor
        self.tariffList = tariffList
        self.status = status
        
        
    }
    
    mutating func mapNameAndAddress(name : String? ,address : String? , mobileNo : String? ,email : String?){
        self.name = name
        self.address = address
        self.mobileNo = mobileNo
        self.email = email
    }
    
    init() {
        
    }
    
	mutating func mapping(map: Map) {

        trackingID <- map["trackingID"]
        name <- map["name"]
        address <- map["address"]
        mobileNo <- map["mobileNo"]
        email <- map["email"]
        totalCostTHB <- map["totalCostTHB"]
        totalInsuranceTHB <- map["totalInsuranceTHB"]
        totalFreightTHB <- map["totalFreightTHB"]
        totalCifTHB <- map["totalCifTHB"]
        totalDutyTHB <- map["totalDutyTHB"]
        totalVatTHB <- map["totalVatTHB"]
        totalTaxTHB <- map["totalTaxTHB"]
        totalTaxDisplay <- map["totalTaxDisplay"]
        exchangeRateSeqId <- map["exchangeRateSeqId"]
        currencyCode <- map["currencyCode"]
        exchangeRate <- map["exchangeRate"]
        rateFactor <- map["rateFactor"]
        paymentMethod <- map["paymentMethod"]
        status <- map["status"]
		tariffList <- map["tariffList"]
	}

}
