/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct ImporterRegisterReq : Mappable {
	var firstNameTH : String?
	var lastNameTH : String?
	var mobileNo : String?
	var email : String?
	var password : String?
	var confirmPassword : String?
	var birthday : String?
	var address : String?
	var province : String?
	var district : String?
	var subDistrict : String?
	var zipCode : String?

	init?(map: Map) {

	}
    
    init() {
        
    }
    
    init(firstNameTH: String, lastNameTH : String, mobileNo : String, email : String? = nil, password : String? = nil, confirmPassword : String? = nil, birthday : String, address : String, province : String, district : String, subDistrict : String, zipCode : String) {
        self.firstNameTH = firstNameTH
        self.lastNameTH = lastNameTH
        self.mobileNo = mobileNo
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
        self.birthday = birthday
        self.address = address
        self.province = province
        self.district = district
        self.subDistrict = subDistrict
        self.zipCode = zipCode
        
    }

	mutating func mapping(map: Map) {

		firstNameTH <- map["firstNameTH"]
		lastNameTH <- map["lastNameTH"]
		mobileNo <- map["mobileNo"]
		email <- map["email"]
		password <- map["password"]
		confirmPassword <- map["confirmPassword"]
		birthday <- map["birthday"]
		address <- map["address"]
		province <- map["province"]
		district <- map["district"]
		subDistrict <- map["subDistrict"]
		zipCode <- map["zipCode"]
	}

}
