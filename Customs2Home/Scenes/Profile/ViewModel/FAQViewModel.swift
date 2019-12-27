//
//  FAQViewModel.swift
//  Customs2Home
//
//  Created by thanawat on 10/16/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire


class FAQViewModel: BaseViewModel<FAQViewModel>,ViewModelProtocol {

    typealias M = FAQViewModel
    typealias T = FAQViewController
    static var obj_instance: FAQViewModel?
    
//    var loadingScreen: ScreenLoadingView? {
//        return viewControl?.view.getScreenLoading()
//    }

    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let commonDispose = [Disposable]()
        let item = input.onLoadView.flatMapLatest( fecthdata )
        
        return FAQViewModel.Output(items: item,
                                             commonDispose: CompositeDisposable(disposables: commonDispose))
    }
    

    func fecthdata() -> Driver<[String:[FaqResp]]> {
        
        guard let loadingScreen = self.loadingScreen
            else {return .just([:])}
        
        let service = GetFaqApi().callService(request: BaseRequest())
        let loading = loadingScreen.observeLoading(service)
            .map({ [unowned self] respond -> [String:[FaqResp]] in
                //printRed(respond)
                return self.parser(respond)
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: [:])
        return loading
        
    }
    
    func parser(_ respond:Faq) -> [String:[FaqResp]]
    {
        
        var faqGroup:[String:[FaqResp]] = [:]
        
        respond.faqResp?.forEach({ (data) in
            faqGroup[data.faqGroupCode!] = respond.faqResp?.filter({ $0.faqGroupCode == data.faqGroupCode})
        })
        
        return faqGroup
    }
    
    private func applyCellTable( byName name:String, cellArray:inout [KTableCellModel]) -> KTableCellModel
    {
        let count = cellArray.count
        let cell =  KTableCellModel(identity: count, cellIden: name)
        cellArray.append( cell )
        return cell
    }
    
}

extension FAQViewModel {
    struct Input {
        let onLoadView: Driver<Void>
    }
    
    struct Output {
        let items: Driver< [String:[FaqResp]] >?
        let commonDispose: CompositeDisposable
       
    }
}
