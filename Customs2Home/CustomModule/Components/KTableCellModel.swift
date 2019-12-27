//
//  KTableCellModel.swift
//  VRT Mobile
//
//  Created by Wittawas Mukdaprasert on 6/8/2562 BE.
//  Copyright © 2562 Kemin Suenggittawisuthi. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift
import RxCocoa
import RxAlamofire

class KTableCellModel {
    var identity: Int
    var cellIden: String
    var limitLine: Bool = true
//    var shouldUpdate = false
    var showSubView = false
    
    var imageUrl: String?
    var dispose = DisposeBag()
    let detail = BehaviorRelay<String>(value: "")
    var attributedDetail = BehaviorRelay<NSAttributedString>(value:  NSAttributedString(string: "") )
    var attributedDetail2 = BehaviorRelay<NSAttributedString>(value:  NSAttributedString(string: "") )
    var attributedDetail3 = BehaviorRelay<NSAttributedString>(value:  NSAttributedString(string: "") )
    var attributedDetail4 = BehaviorRelay<NSAttributedString>(value:  NSAttributedString(string: "") )
    var attributedDetail5 = BehaviorRelay<NSAttributedString>(value:  NSAttributedString(string: "") )
    let title = BehaviorRelay<String>(value: "")
    let image = BehaviorRelay<UIImage?>(value: nil)
    let loading = BehaviorRelay<Bool>(value: false)
    var cellBuildDetail:Any?
    var content:Any?
    let onCellCheck = BehaviorRelay<Bool>(value: false)
    
    var subDetail1:BehaviorRelay<String>?
    var subDetail2:BehaviorRelay<String>?
    var subDetail3:BehaviorRelay<String>?
    var subDetail4:BehaviorRelay<String>?
    var subDetail5:BehaviorRelay<String>?
    var subDetail6:BehaviorRelay<String>?
    var subDetail7:BehaviorRelay<String>?
    
    var specingBetweenCell:CGFloat?
    
    var readFlag:BehaviorRelay<Bool>?
    
    init( identity:Int, cellIden: String) {
        self.identity = identity
        self.cellIden = cellIden
    }
    
    func beginLoadImage()
    {
        if image.value == nil && loading.value == false
        {
            self.loadImage().drive(image).disposed(by: dispose)
        }
        
    }
    
    func loadImage() -> Driver<UIImage?>
    {
        let errorImage =  UIImage(imageLiteralResourceName: "vrtPartnerMerchant")
        let urlEndcode = imageUrl?.urlEncode()
        guard let url = urlEndcode ,
            let comUrl =  URLComponents(string: url)
            else { return   Driver.just( errorImage ) }
        
        
        let image = RxAlamofire.requestData( .get , comUrl )
            //        .timeout(RxTimeInterval.milliseconds(5000), scheduler: MainScheduler.instance)
            .observeOn( MainScheduler.instance )
            .map( { respond, data throws -> UIImage? in
                if respond.statusCode != 200 { throw KError.commonError(message: "Image load error".localizable()) }
                return UIImage(data: data)
            })
            .do( afterNext: { _ in
                self.loading.accept(false)
            })
        
        let imageActivity = Observable.just( () ).map( { [unowned self] in
            self.loading.accept(true)
            })
            .flatMapLatest( {image} )
        .asDriver(onErrorJustReturn: errorImage)
        
        return imageActivity
    }
    
}

extension KTableCellModel:IdentifiableType,Equatable
{
    typealias Identity = Int
    static func == (lhs: KTableCellModel, rhs: KTableCellModel) -> Bool {
        let isSame = (lhs === rhs)
//        printBlue(isSame)
        return isSame
    }
}

struct KTableCellSection {
    var identity: String
    var items: [KTableCellModel]
    var header:String?
    init( identity:Int,items:[KTableCellModel] ) {
        self.identity = String(identity)
        self.items = items
    }
    init(items:[KTableCellModel] ) {
        self.identity = "No id"
        self.items = items
    }
}

extension KTableCellSection:AnimatableSectionModelType
{
    typealias Item = KTableCellModel
    typealias Identity = String
    init(original: KTableCellSection, items: [KTableCellModel]) {
        self = original
        self.items = items
        self.identity = original.identity
    }
    
}

