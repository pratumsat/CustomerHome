//
import RxAlamofire
import RxCocoa
import RxSwift
//  TaxInfoViewModel.swift
//  Customs2Home
//
//  Created by thanawat on 10/16/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit

class TaxInfoViewModel: BaseViewModel<TaxInfoViewModel>, ViewModelProtocol {
    typealias M = TaxInfoViewModel
    typealias T = TaxInfoViewController
    static var obj_instance: TaxInfoViewModel?

//    var loadingScreen: ScreenLoadingView? {
//        return viewControl?.view.getScreenLoading()
//    }

    var calTaxInfoResp = BehaviorRelay<String>(value: "")

    override init() {
        super.init()
    }

    func transform(input: Input) -> Output {
        var commonDispose = [Disposable]()
        let item = input.onLoadView.flatMapLatest(fecthdata)
            .map({ _ in }).drive()
        commonDispose.append(item)

        return TaxInfoViewModel.Output(items: nil,
                                       commonDispose: CompositeDisposable(disposables: commonDispose))
    }

    func fecthdata() -> Driver<Void> {
        guard let loadingScreen = self.loadingScreen
        else { return .just(()) }

        let service = CalTaxInfoApi().callService(request: BaseRequest())
        let loading = loadingScreen.observeLoading(service)
            .map({ [unowned self] respond in
                self.parser(respond)
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        return loading
    }

    func parser(_ respond: CalTaxInfo) {
        calTaxInfoResp.accept(respond.calTaxInfoResp ?? "")
    }

    private func applyCellTable(byName name: String, cellArray: inout [KTableCellModel]) -> KTableCellModel {
        let count = cellArray.count
        let cell = KTableCellModel(identity: count, cellIden: name)
        cellArray.append(cell)
        return cell
    }
}

extension TaxInfoViewModel {
    struct Input {
        let onLoadView: Driver<Void>
        let onItem: Driver<KTableCellModel?>?
    }

    struct Output {
        let items: Driver<Void>?
        let commonDispose: CompositeDisposable
    }
}
