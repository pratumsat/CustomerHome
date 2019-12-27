//
//  TutorialViewModel.swift
//  Customs2Home
//
//  Created by warodom on 9/9/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire


class TutorialViewModel: BaseViewModel<TutorialViewModel>,ViewModelProtocol {

    typealias M = TutorialViewModel
    typealias T = TutorialViewController
    static var obj_instance: TutorialViewModel?
    
//    var loadingScreen: ScreenLoadingView? {
//        return viewControl?.view.getScreenLoading()
//    }

    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let commonDispose = [Disposable]()
        let item = input.onLoadView.flatMapLatest( fecthdata )
        return TutorialViewModel.Output(items: item,
                                             commonDispose: CompositeDisposable(disposables: commonDispose) )
    }
    
    
    func fecthdata() -> Driver<[KTableCellSection]> {
        guard let loadingScreen = super.loadingScreen
            else {return .just([])}
        
        let service = Observable.just(true)
        let loading = loadingScreen.observeLoading(service)
        .map({ [unowned self] respond -> [KTableCellSection] in
            return self.parser( respond)
        })
        .subscribeOn(MainScheduler.asyncInstance)
        .observeOn(MainScheduler.instance)
        .asDriver(onErrorJustReturn: [])
        return loading
        
    }
    
    func parser(_ respond:Bool) -> [KTableCellSection]
    {
        let sections = [KTableCellSection]()
        return sections
    }
    
    private func applyCellTable( byName name:String, cellArray:inout [KTableCellModel]) -> KTableCellModel
    {
        let count = cellArray.count
        let cell =  KTableCellModel(identity: count, cellIden: name)
        cellArray.append( cell )
        return cell
    }
    
}

extension TutorialViewModel {
    struct Input {
        let onLoadView: Driver<Void>
//        let onItem: Driver<KTableCellModel?>
    }
    
    struct Output {
        let items: Driver< [KTableCellSection] >?
        let commonDispose: CompositeDisposable
    }
}
