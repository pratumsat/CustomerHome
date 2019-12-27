//
import RxAlamofire
import RxCocoa
import RxSwift
//  TaxSummaryViewModel.swift
//  Customs2Home
//
//  Created by Wittawas Mukdaprasert on 6/9/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit

class TaxSummaryViewModel: BaseViewModel<TaxSummaryViewModel>, ViewModelProtocol {
    typealias M = TaxSummaryViewModel
    typealias T = TaxSummaryViewController
    static var obj_instance: TaxSummaryViewModel?

//    var loadingScreen: ScreenLoadingView? {
//        return viewControl?.view.getScreenLoading()
//    }

    override init() {
        super.init()
    }

    func transform(input: Input) -> Output {
        let commonDispose = [Disposable]()
        let item = input.onLoadView.flatMapLatest(fecthdata)
        return TaxSummaryViewModel.Output(items: item,
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
        var allCells = [KTableCellModel]()
        var cell = applyCellTable(byName: "cell", cellArray: &allCells)
        cell = applyCellTable(byName: "cell", cellArray: &allCells)
        cell = applyCellTable(byName: "cell", cellArray: &allCells)
        let section = KTableCellSection(items: allCells)
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

extension TaxSummaryViewModel {
    struct Input {
        let onLoadView: Driver<Void>
        let onItem: Driver<KTableCellModel?>
    }

    struct Output {
        let items: Driver<[KTableCellSection]>?
        let commonDispose: CompositeDisposable
    }
}
