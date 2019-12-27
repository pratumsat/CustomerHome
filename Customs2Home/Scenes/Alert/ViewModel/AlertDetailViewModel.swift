//
//  AlertDetailViewModel.swift
//  Customs2Home
//
//  Created by thanawat on 12/23/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire


class AlertDetailViewModel: BaseViewModel<AlertDetailViewModel>,ViewModelProtocol {

    typealias M = AlertDetailViewModel
    typealias T = AlertDetailViewController
    static var obj_instance: AlertDetailViewModel?
    
   

    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let commonDispose = [Disposable]()
        let htmlString = input.onLoadView.flatMapLatest( getDeclareDetail )
        
        let readMsg = input.onLoadView.flatMapLatest( getMsgRead )
        
        return AlertDetailViewModel.Output(htmlString: htmlString,
                                           readMsg: readMsg,
                                           commonDispose: CompositeDisposable(disposables: commonDispose) )
    }
    
    
    func getMsgRead(msgId: Int) -> Observable<Bool> {
        guard let loadingScreen = self.loadingScreen   else { return .just(false) }
        
        let base = BaseRequestMsgreadReq(msgreadReq: MsgreadReq(msgId: msgId))
        let service = MsgReadApi().callService(request: base)
        let loading = loadingScreen.observeLoading(service)
            .map({respond -> Bool in
                print("getMsgRead \(respond)")
                return true
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
        
        
        return loading
    }
    
    func getDeclareDetail(msgId: Int) -> Observable<String> {
        guard let loadingScreen = self.loadingScreen   else { return .just("") }
        
        let base = BaseRequestMsgdetailReq(msgdetailReq: MsgdetailReq(msgId: msgId))
        let service = MessageDetailApi().callService(request: base)
        let loading = loadingScreen.observeLoading(service)
            .map({respond -> String in
                return self.parse(respond.msgdetailResp?.msg)
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
        
        
        return loading
    }
    
    func parse(_ htmlString:String?) -> String{
        guard let htmlString = htmlString else { return ""}
        let font = UIFont.mainFontSemiBold(ofSize: 40)
        let newHtmlString = """
        <style>
        @font-face
        {
        font-family: 'Prompt';
        font-weight: normal;
        src: url(Prompt-Regular.ttf);
        }
        </style>
        <span style="font-family: '\(font.familyName)'; font-size: \(font.pointSize);">\(htmlString)</span>
        """
        return newHtmlString
    }

    
}

extension AlertDetailViewModel {
    struct Input {
        let onLoadView: Observable<Int>
    }
    
    struct Output {
        let htmlString: Observable<String>
        let readMsg: Observable<Bool>
        let commonDispose: CompositeDisposable
    }
}
