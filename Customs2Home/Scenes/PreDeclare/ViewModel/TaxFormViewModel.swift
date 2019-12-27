//
import RxAlamofire
import RxCocoa
import RxSwift
//  TaxFormViewModel.swift
//  Customs2Home
//
//  Created by Wittawas Mukdaprasert on 4/9/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit

class TaxFormViewModel: BaseViewModel<TaxFormViewModel>, ViewModelProtocol {
    typealias M = TaxFormViewModel
    typealias T = TaxFormViewController
    static var obj_instance: TaxFormViewModel?

//    var loadingScreen: ScreenLoadingView? {
//        return viewControl?.view.getScreenLoading()
//    }

    var taxRegistFormModel: TaxRegistFormModel?

    override init() {
        super.init()
    }

    func transform(input: Input) -> Output {
        var commonDispose = [Disposable]()
        taxRegistFormModel = TaxRegistFormModel()
        let onRegist = input.onRegist.do(onNext: { [unowned self] _ in
            let form = self.viewControl?.view as? FormView
            form?.submitForm()
            printYellow(self.taxRegistFormModel!)
        })
        commonDispose.append(onRegist.drive())
        return TaxFormViewModel.Output(commonDispose: CompositeDisposable(disposables: commonDispose))
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
        let sections = [KTableCellSection]()
        return sections
    }

    private func applyCellTable(byName name: String, cellArray: inout [KTableCellModel]) -> KTableCellModel {
        let count = cellArray.count
        let cell = KTableCellModel(identity: count, cellIden: name)
        cellArray.append(cell)
        return cell
    }
}

extension TaxFormViewModel {
    struct Input {
        let onLoadView: Driver<Void>
        let onRegist: Driver<Void>
    }

    struct Output {
        let commonDispose: CompositeDisposable
    }
}
