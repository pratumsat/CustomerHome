//
//  ContactViewModel.swift
//  Customs2Home
//
//  Created by warodom on 11/10/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire


class ContactViewModel: BaseViewModel<ContactViewModel>,ViewModelProtocol {

    typealias M = ContactViewModel
    typealias T = ContactViewController
    static var obj_instance: ContactViewModel?
    
//    var loadingScreen: ScreenLoadingView? {
//        return viewControl?.view.getScreenLoading()
//    }

    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        var commonDispose = [Disposable]()
        let item = input.onLoadView.flatMapLatest( fecthdata )
        .map({_ in}).drive()
        commonDispose.append(item)
        
        return ContactViewModel.Output(items: nil,
                                             commonDispose: CompositeDisposable(disposables: commonDispose) )
    }
    
    
    func fecthdata() -> Driver<Void> {
        
        guard let loadingScreen = self.loadingScreen
            else {return .just(())}
        let base = BaseRequest()
//        let service = Observable.just(true)
        let service = GetContactApi().callService(request: base)
        let loading = loadingScreen.observeLoading(service)
        .map({ [unowned self] respond  in
            self.parser( respond)
            
        })
        .subscribeOn(MainScheduler.asyncInstance)
        .observeOn(MainScheduler.instance)
        .asDriver(onErrorJustReturn: ())
        return loading
        
    }
    
    func parser(_ respond:Contact)
    {
//        self.viewControl?.textField.attributedText = respond.contactUsResp?.htmlDecode()
        self.viewControl?.textField.attributedText = respond.contactUsResp?.htmlAttributed(using: UIFont.mainFontlight(ofSize: 14.0))
    }
    
    private func applyCellTable( byName name:String, cellArray:inout [KTableCellModel]) -> KTableCellModel
    {
        let count = cellArray.count
        let cell =  KTableCellModel(identity: count, cellIden: name)
        cellArray.append( cell )
        return cell
    }
    
}

extension ContactViewModel {
    struct Input {
        let onLoadView: Driver<Void>
        let onItem: Driver<KTableCellModel?>?
    }
    
    struct Output {
        let items: Driver< [KTableCellSection] >?
        let commonDispose: CompositeDisposable
    }
}
