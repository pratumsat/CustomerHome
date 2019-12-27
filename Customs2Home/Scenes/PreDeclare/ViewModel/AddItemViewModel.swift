//
import RxAlamofire
import RxCocoa
import RxSwift
//  AddItemViewModel.swift
//  Customs2Home
//
//  Created by warodom on 24/9/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit

class AddItemViewModel: BaseViewModel<AddItemViewModel>, ViewModelProtocol {
    typealias M = AddItemViewModel
    typealias T = AddItemViewController
    static var obj_instance: AddItemViewModel?


    override init() {
        super.init()
    }

    func transform(input: Input) -> Output {
        var commonDispose = [Disposable]()
        let item = input.onLoadView.flatMapLatest(fecthdata)

        let onSelectCat = input.onSelectCat.do(onNext: { indexpath in
            printRed(indexpath)
        })
        commonDispose.append(onSelectCat.drive())

        return AddItemViewModel.Output(items: item,
                                       commonDispose: CompositeDisposable(disposables: commonDispose))
    }

    func fecthdata() -> Driver<[KTableCellSection]> {
        guard let loadingScreen = self.loadingScreen
        else { return .just([]) }

        let service = Observable.just(true)
        let loading = loadingScreen.observeLoading(service)
            .map({ [unowned self] respond -> [KTableCellSection] in
                self.parser(respond)
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
        return loading
    }

    func parser(_ respond: Bool) -> [KTableCellSection] {
        var sections = [KTableCellSection]()
        var cellForSection = [KTableCellModel]()
        _ = applyCellTable(byName: "additemcell", cellArray: &cellForSection)
        let section = KTableCellSection(items: cellForSection)
        sections.append(section)
        return sections
    }

    private func applyCellTable(byName name: String, cellArray: inout [KTableCellModel]) -> KTableCellModel {
        let count = cellArray.count
        let cell = KTableCellModel(identity: count, cellIden: name)
        cellArray.append(cell)
        return cell
    }
}

extension AddItemViewModel {
    struct Input {
        let onLoadView: Driver<Void>
        let onItem: Driver<KTableCellModel?>?
        let onSelectCat: Driver<IndexPath>
    }

    struct Output {
        let items: Driver<[KTableCellSection]>?
        let commonDispose: CompositeDisposable
    }
}
