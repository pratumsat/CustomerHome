//
//  OrderDetailViewModel.swift
//  Customs2Home
//
//  Created by thanawat on 12/2/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire


class OrderDetailViewModel: BaseViewModel<OrderDetailViewModel>,ViewModelProtocol {

    typealias M = OrderDetailViewModel
    typealias T = OrderDetailViewController
    static var obj_instance: OrderDetailViewModel?
    
   

    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        var commonDispose = [Disposable]()
        let userDetail = input.onLoadView.flatMapLatest( fecthdata )
        
        let fullnameViewModel = FullNameViewModel()
        let mobileViewModel = MobileViewModel()
        let emailViewModel = EmailViewModel()
        let addressViewModel = TextFieldViewModel(errorMessage: "กรุณากรอกข้อมูลให้ครบถ้วน")
        
        let fullname = input.fullname.bind(to: fullnameViewModel.data)
        let mobile = input.mobile.bind(to: mobileViewModel.data)
        let email = input.email.bind(to: emailViewModel.data)
        let address = input.address.bind(to: addressViewModel.data)
        
        
        commonDispose.append(fullname)
        commonDispose.append(mobile)
        commonDispose.append(email)
        commonDispose.append(address)

        
        let errorValidate = Observable.merge(fullnameViewModel.errorValue.filter({$0 != nil}) ,
                                             addressViewModel.errorValue.filter({$0 != nil}) ,
                                             mobileViewModel.errorValue.filter({$0 != nil}) ,
                                             emailViewModel.errorValue.filter({$0 != nil})
                                            )
        
        let newData = input.nextButton
            .withLatestFrom(input.toggle)
            .filter({ $0 == true})
            .filter({ _ in fullnameViewModel.validateCredentials()
                            && addressViewModel.validateCredentials()
                            && mobileViewModel.validateCredentials()
                            && emailViewModel.validateCredentials()
                
            })
            .map {[unowned self] (isToggle) -> DeclareAddEditReq? in
                //var declareAddEditReq = (self.viewControl?.navigationController as! DeclarationNav).declareAddEditReq
                var declareAddEditReq = self.viewControl?.declareAddEditReq
                let name = fullnameViewModel.data.value
                let address = addressViewModel.data.value
                let mobile = mobileViewModel.data.value
                let email = emailViewModel.data.value
                declareAddEditReq?.mapNameAndAddress(name: name, address: address, mobileNo: mobile, email: email)
                return declareAddEditReq
            }
        
        let oldData = input.nextButton
            .withLatestFrom(input.toggle)
            .filter({ $0 == false})
            .map {[unowned self] (isToggle) -> DeclareAddEditReq? in
                //var declareAddEditReq = (self.viewControl?.navigationController as! DeclarationNav).declareAddEditReq
                var declareAddEditReq = self.viewControl?.declareAddEditReq
                let name = self.viewControl?.nameLabel.text
                let address = self.viewControl?.addressLabel.text
                let mobile = self.viewControl?.mobileLabel.text
                let email = self.viewControl?.emailLabel.text
                declareAddEditReq?.mapNameAndAddress(name: name, address: address, mobileNo: mobile, email: email)
                return declareAddEditReq
        }
        
        let nextStep = Observable.merge(newData , oldData)
        
        
        return OrderDetailViewModel.Output(userDetail: userDetail,
                                           errorValidate: errorValidate,
                                           nextStep : nextStep,
                                           commonDispose: CompositeDisposable(disposables: commonDispose) )
    }
    
    
    func fecthdata() -> Observable<UserDetail?> {
        guard let loadingScreen = self.loadingScreen else { return .just((nil)) }
        
        let service = GetUserDetail().callService(request: BaseRequest())
        let loading = loadingScreen.observeLoading(service , shouldRetry: { (error) -> Bool in
            guard let k_error = error as? KError else {return false}
            let errorMessage = k_error.getMessage
            let code = " (\(toString( errorMessage.codeString )))"
            self.viewControl?.alert(message: toString( errorMessage.message ) + code)
            return false
        })
            .map({ respond -> UserDetail? in
                return respond
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
        return loading
    }

    
}

extension OrderDetailViewModel {
    struct Input {
        let onLoadView: Observable<Void>
        let fullname: Observable<String>
        let mobile: Observable<String>
        let email: Observable<String>
        let address: Observable<String>
        let toggle:Observable<Bool>
        let nextButton: Observable<Void>
    }
    
    struct Output {
        let userDetail: Observable<UserDetail?>
        let errorValidate: Observable<String?>
        let nextStep: Observable<DeclareAddEditReq?>
        let commonDispose: CompositeDisposable
    }
}
