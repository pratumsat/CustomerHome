//
//  SearchResultViewModel.swift
//  Customs2Home
//
//  Created by warodom on 27/9/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//
import RxAlamofire
import RxCocoa
import RxSwift
import UIKit

class SearchResultViewModel: BaseViewModel<SearchResultViewModel>, ViewModelProtocol {
    typealias M = SearchResultViewModel
    typealias T = SearchResultViewController
    static var obj_instance: SearchResultViewModel?

    var searchText = BehaviorRelay<String?>(value: nil)

//    var loadingScreen: ScreenLoadingView? {
//        return viewControl?.view.getScreenLoading()
//    }

    override init() {
        super.init()
    }

    func transform(input: Input) -> Output {
        let commonDispose = [Disposable]()
//        let item = input.onLoadView.flatMapLatest( fecthdata )
//        let item = searchText.map( { value throws -> String  in
//            guard let value = value , !value.isEmpty else { throw KError.commonError(message: "Not found") }
//            return value
//        } )
//        .flatMapLatest( fecthdata )

        let item = searchText.asDriver()
            .flatMapLatest(fecthdata)

        return SearchResultViewModel.Output(items: item,
                                            commonDispose: CompositeDisposable(disposables: commonDispose))
    }

    func fecthdata(searchText: String?) -> Driver<[KTableCellSection]> {
        guard let loadingScreen = self.loadingScreen,
            let searchText = searchText,
            !searchText.isEmpty
        else { return .just([]) }

        let base = BaseRequestTaRiff(tariffName: searchText)
        let service = GetTaRiffByNameApi().callService(request: base)
        let loading = loadingScreen.observeLoading(service)
            .map({ [unowned self] respond -> [KTableCellSection] in
                self.parser(respond)
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
        return loading
    }

    func parser(_ respond: TariffbyName) -> [KTableCellSection] {
        var sections = [KTableCellSection]()
        var cellmodels = [KTableCellModel]()

        respond.tariffbyNameResp?.tariffList?.forEach({ data in
            let cell = applyCellTable(byName: "searchcell", cellArray: &cellmodels)
            cell.title.accept(data.categoryNameTH ?? "")
            cell.image.accept(UIImage(named: data.categoryImage ?? ""))
            cell.subDetail1 = BehaviorRelay<String>(value: data.subCategoryTH ?? "")
            cell.subDetail2 = BehaviorRelay<String>(value: data.tariffNameTH ?? "")
            cell.content = data
        })

//        for i in 1...3 {
//            let cell = applyCellTable(byName: "searchcell", cellArray: &cellmodels)
//            cell.title.accept("")
//        }
        let section = KTableCellSection(items: cellmodels)
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

extension SearchResultViewModel {
    struct Input {
        let onLoadView: Driver<Void>
        let onItem: Driver<KTableCellModel?>
    }

    struct Output {
        let items: Driver<[KTableCellSection]>?
        let commonDispose: CompositeDisposable
    }
}
