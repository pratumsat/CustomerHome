//
//  SelectPostCodeViewModel.swift
//  Customs2Home
//
//  Created by warodom on 12/11/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire


class SelectPostCodeViewModel: BaseViewModel<SelectPostCodeViewModel>,ViewModelProtocol {

    typealias M = SelectPostCodeViewModel
    typealias T = SelectPostCodeViewController
    static var obj_instance: SelectPostCodeViewModel?
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
            self.viewControl?.onRegister()
        })
        commonDispose.append(onListItem.drive())
        return SelectPostCodeViewModel.Output(items: item,
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

extension SelectPostCodeViewModel {
    struct Input {
        let onLoadView: Driver<String>
        let onItem: Driver<KTableCellModel?>
    }
    
    struct Output {
        let items: Driver< [KTableCellSection] >?
        let commonDispose: CompositeDisposable
    }
}
