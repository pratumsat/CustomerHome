/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct TariffList : Mappable {
	var tariffSeqID : Int?
	var categoryID : String?
	var categoryNameTH : String?
	var categoryNameEN : String?
	var categoryImage : String?
	var subCategoryID : String?
	var subCategoryTH : String?
	var subCategoryEN : String?
	var tariffID : String?
	var tariffNameEN : String?
	var tariffNameTH : String?
	var importDuty : Int?
	var vat : Int?
	var licensorEN : String?
	var licensorTH : String?
	var qtyLimit : Int?
    var msgWarning : String?

	init?(map: Map) {

	}
    
    mutating func fillCategoryData( category:Category , subCategory:SubCategory)
    {
        self.categoryID = category.categoryID
        self.categoryNameTH = category.categoryNameTH
        self.categoryNameEN = category.categoryNameEN
        self.subCategoryID = subCategory.subCategoryID
        self.subCategoryEN = subCategory.subCategoryNameEN
        self.subCategoryTH = subCategory.subCategoryNameTH

    }
    
    var tariffName:String? {
        return convenientLangCompair(interLang: tariffNameEN, altLang: tariffNameTH)
    }
    var categoryName:String? {
        return convenientLangCompair(interLang: categoryNameEN, altLang: categoryNameTH)
    }
    var subCategory:String? {
        return convenientLangCompair(interLang: subCategoryEN, altLang: subCategoryTH)
    }

	mutating func mapping(map: Map) {

		tariffSeqID <- map["tariffSeqID"]
		categoryID <- map["categoryID"]
		categoryNameTH <- map["categoryNameTH"]
		categoryNameEN <- map["categoryNameEN"]
		categoryImage <- map["categoryImage"]
		subCategoryID <- map["subCategoryID"]
		subCategoryTH <- map["subCategoryTH"]
		subCategoryEN <- map["subCategoryEN"]
		tariffID <- map["tariffID"]
		tariffNameEN <- map["tariffNameEN"]
		tariffNameTH <- map["tariffNameTH"]
		importDuty <- map["importDuty"]
		vat <- map["Vat"]
		licensorEN <- map["licensorEN"]
		licensorTH <- map["licensorTH"]
		qtyLimit <- map["qtyLimit"]
        msgWarning <- map["msgWarning"]
	}

}
