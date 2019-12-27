//
import RxAlamofire
import RxCocoa
import RxSwift
//  CatagoryViewModel.swift
//  Customs2Home
//
//  Created by warodom on 1/10/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit

class CategoryViewModel: BaseViewModel<CategoryViewModel>, ViewModelProtocol {
    typealias M = CategoryViewModel
    typealias T = CatagoryViewController
    static var obj_instance: CategoryViewModel?

//    var loadingScreen: ScreenLoadingView? {
//        return viewControl?.view.getScreenLoading()
//    }

    override init() {
        super.init()
    }

    func transform(input: Input) -> Output {
        let commonDispose = [Disposable]()
        let item = input.onLoadView.flatMapLatest(fecthdata)
        return CategoryViewModel.Output(items: item, commonDispose: CompositeDisposable(disposables: commonDispose))
    }

    func fecthdata() -> Driver<[KTableCellModel]> {
        guard let loadingScreen = self.loadingScreen
        else { return .just([]) }
//        let service = GetTaRiffListApi().callService(request: base)
        let service = GetTaRiffListApi().callServiceNoSecurity(request: BaseRequest(version: UserDefaultService.getTariffVersion ?? ""))
        let loading = loadingScreen.observeLoading(service)
            .map({ [unowned self] respond -> [KTableCellModel] in
                self.parser(respond)
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
        return loading
    }

    func parser(_ respond: Tariff) -> [KTableCellModel] {
        UserDefaultService.setTariffVersion(date: respond.version ?? "")
        
        var cellmodels = [KTableCellModel]()

        respond.categoryList?.forEach({ data in
            let model = CategoryCellModel(data)
            cellmodels.append(model)
        })
        return cellmodels
    }

//    private func applyCellTable( byName name:String, cellArray:inout [KTableCellModel]) -> KTableCellModel
//    {
//        let count = cellArray.count
//        let cell =  KTableCellModel(identity: count, cellIden: name)
//        cellArray.append( cell )
//        return cell
//    }
}

extension CategoryViewModel {
    struct Input {
        let onLoadView: Driver<Void>
        let onItem: Driver<KTableCellModel?>?
    }

    struct Output {
        let items: Driver<[KTableCellModel]>?
        let commonDispose: CompositeDisposable
    }
}
