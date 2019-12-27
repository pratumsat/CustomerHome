//
//  ConditionViewModel.swift
//  Customs2Home
//
//  Created by thanawat on 11/21/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire


class ConditionViewModel: BaseViewModel<ConditionViewModel>,ViewModelProtocol {

    typealias M = ConditionViewModel
    typealias T = ConditionViewController
    static var obj_instance: ConditionViewModel?

    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let commonDispose = [Disposable]()
        let htmlString = input.onLoadView.flatMapLatest( fecthdata )
        
        return ConditionViewModel.Output(htmlString: htmlString,
                                        commonDispose: CompositeDisposable(disposables: commonDispose) )
    }
    
    
    func fecthdata() -> Driver<String> {
        guard let loadingScreen = self.loadingScreen else {return  .just("") }
        
        let service = GetTermAndCondApi().callService(request: BaseRequest())
        let loading = loadingScreen.observeLoading(service)
        .map({ [unowned self] respond -> String in
            return self.parse(respond.termAndCondResp)
        })
        .subscribeOn(MainScheduler.asyncInstance)
        .observeOn(MainScheduler.instance)
        .asDriver(onErrorJustReturn: "")
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

extension ConditionViewModel {
    struct Input {
        let onLoadView: Driver<Void>
    }
    
    struct Output {
        let htmlString: Driver<String>
        let commonDispose: CompositeDisposable
    }
}
