//
//  SelectPaymentViewModel.swift
//  Customs2Home
//
//  Created by thanawat on 12/6/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire


enum PaymentType {
    case QR_CODE(_ declareId:Int )
    case CREDIT_CARD(_ declareId:Int )
    case BILL_PAYMENT(_ declareId:Int )
}

class SelectPaymentViewModel: BaseViewModel<SelectPaymentViewModel>,ViewModelProtocol {

    typealias M = SelectPaymentViewModel
    typealias T = SelectPaymentViewController
    static var obj_instance: SelectPaymentViewModel?
  
    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let commonDispose = [Disposable]()
        
        
        
        
        let declareID = Observable.combineLatest(input.selectPayment, input.declareId,
                                                 resultSelector: { ( $0, $1) })
        
       
        let declareSuccess = input.addDeclare
            .withLatestFrom(declareID)
            .flatMapLatest( getDeclareApi )
        
        return SelectPaymentViewModel.Output(declareSuccess: declareSuccess,
                                             commonDispose: CompositeDisposable(disposables: commonDispose) )
    }
    
    
    func getDeclareApi(selectPatyment:Int , declareID:String?) -> Observable<PaymentType?>{
        //return .just(PaymentType.CREDIT_CARD(toInt(declareID)))
        guard let loadingScreen = self.loadingScreen  else { return .just(nil) }
        
        var paymentMethod = ""
        switch selectPatyment {
        case 0:
            paymentMethod = "QR_CODE"
            break
        case 1:
            paymentMethod = "CREDIT_CARD"
            break
        case 2:
            paymentMethod = "BILL_PAYMENT"
            break
        default:
            break
        }
        var modelAddPayment = DeclareAddEditReq()
        modelAddPayment.paymentMethod = paymentMethod
        modelAddPayment.status = "PENDING_PAYMENT"
        
        let condition = Condition(declareID: declareID)
        
        let baseRequest = BaseRequestDeclareAddEdit(declareAddEditReq: modelAddPayment,
                                                    condition: condition)
        
        let service = AddEditDeclareApi().callService(request: baseRequest)
        let loading = loadingScreen.observeLoading(service , shouldRetry: { (error) -> Bool in
            guard let k_error = error as? KError else {return false}
            let errorMessage = k_error.getMessage
            let code = " (\(toString( errorMessage.codeString )))"
            self.viewControl?.alert(message: toString( errorMessage.message ) + code)
            return false
        })
            .map({ respond -> PaymentType? in
                
                let declareID = respond.declareResp?.declareID ?? 0
               
                switch selectPatyment {
                case 0:
                    return PaymentType.QR_CODE(declareID)
                case 1:
                    return PaymentType.CREDIT_CARD(declareID)
                case 2:
                    return PaymentType.BILL_PAYMENT(declareID)
                default:
                    return nil
                }
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
        return loading
        
    }
    
}

extension SelectPaymentViewModel {
    struct Input {
        let onLoadView: Driver<Void>
        let declareId: Observable<String?>
        let selectPayment : Observable<Int>
        let addDeclare: Observable<Void>
    }
    
    struct Output {
        let declareSuccess: Observable<PaymentType?>
        let commonDispose: CompositeDisposable
    }
}
