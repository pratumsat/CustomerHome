//
//  DeclareSelectPostCodeViewModel.swift
//  Customs2Home
//
//  Created by warodom on 3/12/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire


class DeclareSelectPostCodeViewModel: BaseViewModel<DeclareSelectPostCodeViewModel>,ViewModelProtocol {

    typealias M = DeclareSelectPostCodeViewModel
    typealias T = DeclareSelectPostCodeViewController
    static var obj_instance: DeclareSelectPostCodeViewModel?
    var postcodeSelect = BehaviorRelay<(String, String)?>(value:nil)
//    var loadingScreen: ScreenLoadingView? {
//        return viewControl?.view.getScreenLoading()
//    }

    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        var commonDispose = [Disposable]()
        let item = input.onLoadView.flatMapLatest( fecthdata )
        let onListItem = input.onItem.do(onNext: { [unowned self] cellModel in
            cellModel?.onCellCheck.accept(true)
            let str = (cellModel?.title.value ?? "",(cellModel?.content.value as? String) ?? "")
            self.postcodeSelect.accept(str)
            self.viewControl?.onAddress()
        })
        commonDispose.append(onListItem.drive())
        return DeclareSelectPostCodeViewModel.Output(items: item,
                                             commonDispose: CompositeDisposable(disposables: commonDispose) )
    }
    
    
    func fecthdata(zipCode: String) -> Driver<[KTableCellSection]> {
        
        guard let loadingScreen = self.loadingScreen
            else {return .just([])}
        
        let service = Observable.just(zipCode)
        let loading = loadingScreen.observeLoading(service)
        .map({ [unowned self] respond -> [KTableCellSection] in
            return self.parser( respond)
        })
        .subscribeOn(MainScheduler.asyncInstance)
        .observeOn(MainScheduler.instance)
        .asDriver(onErrorJustReturn: [])
        return loading
        
    }
    
    func parser(_ respond:String) -> [KTableCellSection]
    {
        var sections = [KTableCellSection]()
        var cellsForSection = [KTableCellModel]()
        let array = [respond]
        
        array.forEach({ str in
            let cell = applyCellTable(byName: "postcodecell", cellArray: &cellsForSection)
            cell.title.accept(str)
        })
        sections.append(KTableCellSection(items: cellsForSection))
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

extension DeclareSelectPostCodeViewModel {
    struct Input {
        let onLoadView: Driver<String>
        let onItem: Driver<KTableCellModel?>
    }
    
    struct Output {
        let items: Driver< [KTableCellSection] >?
        let commonDispose: CompositeDisposable
    }
}
