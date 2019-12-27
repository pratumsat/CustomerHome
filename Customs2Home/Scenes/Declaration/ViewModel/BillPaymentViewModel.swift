//
//  BillPaymentViewModel.swift
//  Customs2Home
//
//  Created by warodom on 19/12/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire


class BillPaymentViewModel: BaseViewModel<BillPaymentViewModel>,ViewModelProtocol {

    typealias M = BillPaymentViewModel
    typealias T = BillPaymentViewController
    static var obj_instance: BillPaymentViewModel?
    
//    var loadingScreen: ScreenLoadingView? {
//        return viewControl?.view.getScreenLoading()
//    }

    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let commonDispose = [Disposable]()
        let item = input.onLoadView.flatMapLatest( fecthdata )
        return BillPaymentViewModel.Output(items: item,
                                             commonDispose: CompositeDisposable(disposables: commonDispose) )
    }
    
    
    func fecthdata(declareID: Int) -> Driver<Bool> {
        
        guard let loadingScreen = self.loadingScreen
            else {return .just(false)}
        
//        let service = Observable.just(true)
        let service = GetPayInSlipApi().callService(request: BaseRequest_Payinslip(declareID: declareID))
        let loading = loadingScreen.observeLoading(service, shouldRetry: { (error) -> Bool in
            guard let k_error = error as? KError else {return false}
            let errorMessage = k_error.getMessage
            let code = " (\(toString( errorMessage.codeString )))"
            self.viewControl?.alert(message: toString( errorMessage.message ) + code)
            return false
        })
            .map({  respond -> Bool in
                return true
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: false)
        return loading
        
    }
    
   

}

extension BillPaymentViewModel {
    struct Input {
        let onLoadView: Driver<Int>
    }
    
    struct Output {
        let items: Driver<Bool>?
        let commonDispose: CompositeDisposable
    }
}
