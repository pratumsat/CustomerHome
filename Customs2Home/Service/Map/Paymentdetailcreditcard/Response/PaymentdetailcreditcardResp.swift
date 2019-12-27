/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct PaymentDetailCreditCardResp : Mappable {
    var orderRef : String?
    var amount : String?
    var currCode : String?
    var lang : String?
    var cancelUrl : String?
    var failUrl : String?
    var successUrl : String?
    var merchantId : String?
    var payType : String?
    var payMethod : String?
    var orderRef1 : String?
    var orderRef2 : String?
    var orderRef3 : String?
    var orderRef4 : String?
    var orderRef5 : String?
    var orderRef6 : String?
    var remark : String?
    var redirect : String?
    var mpEmail : String?
    var paymentSkip : String?
    var dTime : String?
    var washAccount : String?
    var washAmount : String?
    var washMerchant : String?
    var paymentFormUrl : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        orderRef <- map["orderRef"]
        amount <- map["amount"]
        currCode <- map["currCode"]
        lang <- map["lang"]
        cancelUrl <- map["cancelUrl"]
        failUrl <- map["failUrl"]
        successUrl <- map["successUrl"]
        merchantId <- map["merchantId"]
        payType <- map["payType"]
        payMethod <- map["payMethod"]
        orderRef1 <- map["orderRef1"]
        orderRef2 <- map["orderRef2"]
        orderRef3 <- map["orderRef3"]
        orderRef4 <- map["orderRef4"]
        orderRef5 <- map["orderRef5"]
        orderRef6 <- map["orderRef6"]
        remark <- map["remark"]
        redirect <- map["redirect"]
        mpEmail <- map["mpEmail"]
        paymentSkip <- map["paymentSkip"]
        dTime <- map["dTime"]
        washAccount <- map["washAccount"]
        washAmount <- map["washAmount"]
        washMerchant <- map["washMerchant"]
        paymentFormUrl <- map["paymentFormUrl"]
    }
    
}
