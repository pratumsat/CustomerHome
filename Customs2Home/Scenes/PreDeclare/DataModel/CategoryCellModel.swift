//
//  CategoryCellModel.swift
//  Customs2Home
//
//  Created by Wittawas Mukdaprasert on 11/10/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import Foundation
import UIKit

class CategoryCellModel: KTableCellModel {
    
    var name:String?
    var subModels:[CategoryCellModel]?
//    var
    init(_ categoryList:CategoryList) {
        super.init(identity: toInt( categoryList.category?.categoryID ), cellIden: "catagoryCell")
        self.name = categoryList.category?.categoryName
        self.cellBuildDetail = categoryList.subCategoryList?.map({ data -> CategoryCellModel in  return CategoryCellModel( data) })
        self.content = categoryList.category
        self.title.accept( toString(name) )
        self.image.accept( UIImage(named: categoryList.category?.categoryImage ?? "") )
    }
    
    init(_ subCategoryList:SubCategoryList) {
        super.init(identity: toInt( subCategoryList.subCategory?.subCategoryID ), cellIden: "catagoryCell")
        self.name = subCategoryList.subCategory?.subCategoryName
        self.cellBuildDetail = subCategoryList.tariffList?.map({ data -> CategoryCellModel in  return CategoryCellModel( data) })
        self.content = subCategoryList.subCategory
        self.title.accept( toString(name) )
    }
    init(_ tariffList:TariffList) {
        super.init(identity: toInt( tariffList.tariffID ), cellIden: "catagoryCell")
        self.name = tariffList.tariffName
        self.content = tariffList
        
        self.title.accept( toString(name) )
    }
}
