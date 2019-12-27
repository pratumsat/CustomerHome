//
//  BaseViewModel.swift
//  VRT Mobile
//
//  Created by Kemin Suenggittawisuthi on 20/6/2562 BE.
//  Copyright © 2562 Kemin Suenggittawisuthi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
class BaseViewModel<Base:InstanceProtocol>:NSObject,LoadingViewbase {
    
    weak var viewControl: Base.T?
    
    var loadingScreen: ScreenLoadingView? {
        return viewControl?.view.getScreenLoading()
    }
    
    static func instance() -> Base.M {
        if Base.obj_instance == nil {
            Base.obj_instance = Base.M()
        }
        return Base.obj_instance!
    }
    
//    func createReloadObserve<Input>( action:Driver<Input>, driver:Driver<T> ) -> Driver<T>  {
//        let result = Driver.merge( botton.rx.tap,  )
//
//        let result = botton.rx.tap.asDriver().flatMap { _ -> Driver<T> in
//            printRed("trtyax")
//            return driver
//        }
//        return result
//    }
}

protocol LoadingViewbase {
    var loadingScreen: ScreenLoadingView? { get }
}
