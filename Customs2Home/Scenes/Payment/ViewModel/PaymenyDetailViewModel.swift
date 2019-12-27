//
//  PaymenyDetailViewModel.swift
//  Customs2Home
//
//  Created by thanawat on 12/17/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire


class PaymenyDetailViewModel: BaseViewModel<PaymenyDetailViewModel>,ViewModelProtocol {

    typealias M = PaymenyDetailViewModel
    typealias T = PaymentDetailViewController
    static var obj_instance: PaymenyDetailViewModel?
    


    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let commonDispose = [Disposable]()
        let declareDetail = input.onLoadView.flatMapLatest( getDeclareDetail )
        
        return PaymenyDetailViewModel.Output(declareDetail: declareDetail,
                                             commonDispose: CompositeDisposable(disposables: commonDispose) )
    }
    
    func getDeclareDetail(declareId: Int) -> Observable<DeclareResponse?> {
        guard let loadingScreen = self.loadingScreen   else { return .just(nil) }
        
        let base = BaseRequestDeclareDetailReq(declareDetailReq: DeclareDetailReq(declareID: declareId))
        let service = GetDeclareDetailApi().callService(request: base)
        let loading = loadingScreen.observeLoading(service)
            .map({respond -> DeclareResponse? in
                return respond
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
        
        
        return loading
    }
   
}

extension PaymenyDetailViewModel {
    struct Input {
        let onLoadView: Observable<Int>
    }
    
    struct Output {
        let declareDetail: Observable<DeclareResponse?>
        let commonDispose: CompositeDisposable
    }
}
