//
//  DeclarationDetailViewModel.swift
//  Customs2Home
//
//  Created by thanawat on 12/3/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire


class DeclarationDetailViewModel: BaseViewModel<DeclarationDetailViewModel>,ViewModelProtocol {

    typealias M = DeclarationDetailViewModel
    typealias T = DeclarationDetailViewController
    static var obj_instance: DeclarationDetailViewModel?
    
    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        var commonDispose = [Disposable]()
        
        let trackingViewModel = TrackNoViewModel()
        let paySlipViewModel = TextFieldViewModel(errorMessage: "กรุณาแนบหลักฐานการชำระเงินอย่างน้อย 1 รูป")
        
        let tracking = input.trackingNO.bind(to: trackingViewModel.data)
        let paySlip = input.paySlip.bind(to: paySlipViewModel.data)
        
        commonDispose.append(tracking)
        commonDispose.append(paySlip)
        
        
        
        let trackingResult =  input.searchAction
            .filter({ trackingViewModel.validateCredentials() })
            .map({[unowned self] _ -> String in
                self.viewControl?.trackingNoTextField.resignFirstResponder()
                return trackingViewModel.data.value
            })
            .flatMapLatest( searchTrackingNo )

        
        let nextStep = input.declareAction
            .filter({ paySlipViewModel.validateCredentials() })
            .map {[unowned self] _ -> DeclareAddEditReq? in
                var declareAddEditReq = self.viewControl?.declareAddEditReq
                declareAddEditReq?.trackingID = trackingViewModel.data.value.uppercased()
                return declareAddEditReq
        }
        let showButton = Observable.combineLatest(trackingResult, input.paySlip )
            { (validTracking , validPaySlip) -> Bool in
                return validTracking && !validPaySlip.isEmpty
            }
      
        
        return DeclarationDetailViewModel.Output(errorValidate: trackingViewModel.errorValue.filter({$0 != nil}),
                                                 trackingResult: trackingResult,
                                                 nextStep: nextStep,
                                                 showButton: showButton,
                                                 commonDispose: CompositeDisposable(disposables: commonDispose) )
    }
    
    func searchTrackingNo(trackingNo:String) -> Observable<Bool> {
        //return .just(true)
        guard let loadingScreen = self.loadingScreen else {return .just(false)}
        
        let base = BaseRequestTrackingReq(trackingReq: TrackingReq(trackingID: trackingNo.uppercased()))
        let service = SearchTrackingApi().callService(request: base)
        let loading = loadingScreen.observeLoading(service , shouldRetry: { (error) -> Bool in
                guard let k_error = error as? KError else {return false}
                let errorMessage = k_error.getMessage
                let code = " (\(toString( errorMessage.codeString )))"
                self.viewControl?.alert(message: toString( errorMessage.message ) + code)
                return false
            },noBackgroundColor: true)
            .map({ respond -> Bool in
                return true
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
        return loading
        
    }
    
}

extension DeclarationDetailViewModel {
    struct Input {
        let onLoadView: Observable<Void>
        let trackingNO: Observable<String>
        let paySlip: Observable<String>
        let searchAction: Observable<Void>
        let declareAction: Observable<Void>
    }
    
    struct Output {
        let errorValidate: Observable<String?>
        let trackingResult:Observable<Bool>
        let nextStep: Observable<DeclareAddEditReq?>
        let showButton:Observable<Bool>
        let commonDispose: CompositeDisposable
    }
}
