//
import RxAlamofire
import RxCocoa
import RxSwift
//  CurrencyViewModel.swift
//  Customs2Home
//
//  Created by warodom on 24/9/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit

class CurrencyViewModel: BaseViewModel<CurrencyViewModel>, ViewModelProtocol {
    typealias M = CurrencyViewModel
    typealias T = CurrencyViewController
    static var obj_instance: CurrencyViewModel?
    var selectExchange = BehaviorRelay<ExchangeRateList?>(value: nil)

//    var loadingScreen: ScreenLoadingView? {
//        return viewControl?.view.getScreenLoading()
//    }

    override init() {
        super.init()
    }

    func transform(input: Input) -> Output {
        var commonDispose = [Disposable]()
        selectExchange.accept(nil)

        let items = input.onLoadView.flatMapLatest(fecthdata)
//        let newItems = self.createReloadObserve(botton: loadingScreen!.retryButton, driver: items)
//        let onselect = input.onSelectCurrency.do(onNext: { data in
//
//        })
//        commonDispose.append(onselect.drive())
        let onListItem = input.onItem.do(onNext: { cellModel in
            let data = cellModel?.content as! ExchangeRateList
            self.selectExchange.accept(data)
            cellModel?.onCellCheck.accept(true)
        })
        commonDispose.append(onListItem.drive())

        return CurrencyViewModel.Output(items: items,
                                        commonDispose: CompositeDisposable(disposables: commonDispose))
    }

    func fecthdata() -> Driver<[KTableCellSection]> {
        guard let loadingScreen = self.loadingScreen
        else { return .just([]) }

//        let service = Observable.just(true)

//        let service = GetExchangeRateApi().callService(request: BaseRequest())
        let service = GetExchangeRateApi().callServiceNoSecurity(request: BaseRequest(version: UserDefaultService.getExchangeRateVersion ?? ""))
        let loading = loadingScreen.observeLoading(service)
            .map({ [unowned self] respond -> [KTableCellSection] in
                self.parser(respond)
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
        return loading
    }

    func parser(_ respond: ExchangeRate) -> [KTableCellSection] {
        UserDefaultService.setExchangeRateVersion(date: respond.version ?? "")
        var sections = [KTableCellSection]()
        var cellsForSection = [KTableCellModel]()

        respond.exchangeRateListResp?.exchangeRateList?.forEach({ data in
            let cell = applyCellTable(byName: "currencycell", cellArray: &cellsForSection)
            cell.title.accept("\(data.currencyCode?.description ?? "")")
            cell.image.accept(UIImage(named: data.currencyImage?.description ?? "") ?? UIImage(named: "placeholder"))
            cell.content = data
        })

        let section = KTableCellSection(items: cellsForSection)
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

extension CurrencyViewModel {
    struct Input {
        let onLoadView: Driver<Void>
        let onItem: Driver<KTableCellModel?>
//        let onSelectCurrency: Driver<IndexPath>
    }

    struct Output {
        let items: Driver<[KTableCellSection]>?
        let commonDispose: CompositeDisposable
    }
}
