//
//  HomeTabbarViewModel.swift
//  Customs2Home
//
//  Created by thanawat on 11/25/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire


class HomeTabbarViewModel: BaseViewModel<HomeTabbarViewModel>,ViewModelProtocol {

    typealias M = HomeTabbarViewModel
    typealias T = HomeTabbarViewController
    static var obj_instance: HomeTabbarViewModel?


    override init() {
        super.init()
    }
    
    func showLogin(){
        //self.viewControl?.alert(message: "Please Login")
        
        self.viewControl?.showLoginRegister()
    }
    func showAlertForceLogin(_ msg:String){
        self.viewControl?.showAlertForceLogin(msg: msg)
    }
    

    
    func transform(input: Input) -> Output {
        let commonDispose = [Disposable]()
        let item = input.onLoadView.filter({ TokenModel.instance().isLogin() }).flatMapLatest( fecthdata )
        return HomeTabbarViewModel.Output(items: item,
                                             commonDispose: CompositeDisposable(disposables: commonDispose) )
    }
    
    
    func fecthdata() -> Driver<Void> {
        
        guard let loadingScreen = self.loadingScreen else {return .just(())}
        let base = BaseRequest_FCMToken(fcmToken: KeyChainService.getTokenFirebase() ?? "")
        let service = PostFCMTokenApi().callService(request: base)
        let loading = loadingScreen.observeLoading(service , shouldRetry: { (error) -> Bool in
            guard let k_error = error as? KError else {return false}
            let errorMessage = k_error.getMessage
            let code = " (\(toString( errorMessage.codeString )))"
            self.viewControl?.alert(message: toString( errorMessage.message ) + code)
            return false
        }, noLoading: true)
        .map({  respond -> Void in
            print("PostFCMTokenApi \(respond)")
            return
        })
        .subscribeOn(MainScheduler.asyncInstance)
        .observeOn(MainScheduler.instance)
        .asDriver(onErrorJustReturn: ())
        return loading
        
    }
    
   
}

extension HomeTabbarViewModel {
    struct Input {
        let onLoadView: Driver<Void>
//        let onItem: Driver<KTableCellModel?>
    }
    
    struct Output {
        let items: Driver<Void>
        let commonDispose: CompositeDisposable
    }
}
