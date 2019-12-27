//
//  PaymentCardViewModel.swift
//  Customs2Home
//
//  Created by warodom on 18/12/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import Alamofire


class PaymentCardViewModel: BaseViewModel<PaymentCardViewModel>,ViewModelProtocol {

    typealias M = PaymentCardViewModel
    typealias T = PaymentCardViewController
    static var obj_instance: PaymentCardViewModel?
    
//    var loadingScreen: ScreenLoadingView? {
//        return viewControl?.view.getScreenLoading()
//    }

    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let commonDispose = [Disposable]()
        let item = input.onLoadView.flatMapLatest( fecthdata )
        return PaymentCardViewModel.Output(items: item,
                                             commonDispose: CompositeDisposable(disposables: commonDispose) )
    }
    
    
    func fecthdata(declareID: Int) -> Driver<URLRequest?> {
        
        guard let loadingScreen = self.loadingScreen
            else {return .just(nil)}
        
//        let service = Observable.just(true)
        let service = GetPaymentdetailcreditcardApi().callService(request: BaseRequest_Paymentdetailcreditcard(declareID: declareID))
        let loading = loadingScreen.observeLoading(service)
        .map({ [unowned self] respond -> URLRequest? in
            return self.parser( respond)
        })
        .subscribeOn(MainScheduler.asyncInstance)
        .observeOn(MainScheduler.instance)
        .asDriver(onErrorJustReturn: nil)
        return loading
        
    }
    
//    func parser(_ respond:Bool) -> URLRequest?
    func parser(_ respond:BaseResponse_Paymentdetailcreditcard) -> URLRequest?
    {
        
        
//        let myURL = URL(string: "https://uatktbfastpay.ktb.co.th/SIT/eng/payment/payForm.jsp")
         let myURL = URL(string: toString(respond.paymentDetailCreditCardResp?.paymentFormUrl))
        var myRequest = URLRequest(url: myURL!)
        myRequest.httpMethod = "POST"
        myRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let params: Parameters = [
            "merchantId": toString(respond.paymentDetailCreditCardResp?.merchantId),
            "payMethod": toString(respond.paymentDetailCreditCardResp?.payMethod),
            "currCode": toString(respond.paymentDetailCreditCardResp?.currCode),
            "amount": toString(respond.paymentDetailCreditCardResp?.amount),
            "lang": toString(respond.paymentDetailCreditCardResp?.lang),
            "payType": toString(respond.paymentDetailCreditCardResp?.payType),
            "redirect": toString(respond.paymentDetailCreditCardResp?.redirect),
            "memberPay_service": toString(respond.paymentDetailCreditCardResp?.paymentSkip), //"F",
            "remark": toString(respond.paymentDetailCreditCardResp?.remark),
            "successUrl": toString(respond.paymentDetailCreditCardResp?.successUrl),
            "failUrl": toString(respond.paymentDetailCreditCardResp?.failUrl),
            "cancelUrl": toString(respond.paymentDetailCreditCardResp?.cancelUrl),
            "orderRef": toString(respond.paymentDetailCreditCardResp?.orderRef),
            "orderRef1": toString(respond.paymentDetailCreditCardResp?.orderRef1),
            "orderRef2":toString(respond.paymentDetailCreditCardResp?.orderRef2),
            "orderRef3":toString(respond.paymentDetailCreditCardResp?.orderRef3),
            "orderRef4":toString(respond.paymentDetailCreditCardResp?.orderRef4),
            "orderRef5":toString(respond.paymentDetailCreditCardResp?.orderRef5),
            "orderRef6":toString(respond.paymentDetailCreditCardResp?.orderRef6)
//            "merchantId": "900000152",
//            "payMethod": "CC",
//            "currCode": "764",
//            "amount": "10000",
//            "lang": "T",
//            "payType": "Sale",
//            "redirect": toString(respond.paymentDetailCreditCardResp?.redirect),
//            "memberPay_service": "F", //"F",
//            "remark": "Remark (Test)",
//            "successUrl": toString(respond.paymentDetailCreditCardResp?.successUrl),
//            "failUrl": toString(respond.paymentDetailCreditCardResp?.failUrl),
//            "cancelUrl": toString(respond.paymentDetailCreditCardResp?.cancelUrl),
//            "orderRef": "Test000809",
//            "orderRef1": "Test",
//            "orderRef2":"Test",
//            "orderRef3":toString(respond.paymentDetailCreditCardResp?.orderRef3),
//            "orderRef4":toString(respond.paymentDetailCreditCardResp?.orderRef4),
//            "orderRef5":toString(respond.paymentDetailCreditCardResp?.orderRef5),
//            "orderRef6":toString(respond.paymentDetailCreditCardResp?.orderRef6)
        ]
        
        let jsonString = params.reduce("") { "\($0)\($1.0)=\($1.1)&" }
        let jsonData = jsonString.data(using: .utf8, allowLossyConversion: false)!
        myRequest.httpBody = jsonData
        return myRequest
    }
}

extension PaymentCardViewModel {
    struct Input {
        let onLoadView: Driver<Int>
    }
    
    struct Output {
        let items: Driver<URLRequest?>?
        let commonDispose: CompositeDisposable
    }
}
