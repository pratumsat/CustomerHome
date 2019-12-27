//
import RxAlamofire
import RxCocoa
import RxSwift
//  PreDeclareViewModel.swift
//  Customs2Home
//
//  Created by Wittawas Mukdaprasert on 2/9/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit

class PreDeclareViewModel: BaseViewModel<PreDeclareViewModel>, ViewModelProtocol {
    typealias M = PreDeclareViewModel
    typealias T = PreDeclareViewController
    static var obj_instance: PreDeclareViewModel?

//    var loadingScreen: ScreenLoadingView? {
//        return viewControl?.view.getScreenLoading()
//    }

    override init() {
        super.init()
    }

    func transform(input: Input) -> Output {
        var commonDispose = [Disposable]()
        let item = input.onLoadView.flatMapLatest(fecthdata)

//        let onCreateTax = input.onTaxButton.do(onNext: { [unowned self] _ in
//            self.viewControl?.onTaxForm()
//        })
//        commonDispose.append(onCreateTax.drive())

        let onShowTax = input.onShowTax.do(onNext: { indexPath in
            printRed(indexPath)
        })
        commonDispose.append(onShowTax.drive())

        let onListItem = input.onItem.do(onNext: { [unowned self] _ in
            self.viewControl?.onListItem()
        })
        commonDispose.append(onListItem.drive())

        return PreDeclareViewModel.Output(items: item,
                                          commonDispose: CompositeDisposable(disposables: commonDispose))
    }

    func fecthdata() -> Driver<[KTableCellSection]> {
        guard let loadingScreen = self.loadingScreen
        else { return .just([]) }

        //        let tester = RequestDelayTest()
        //        tester.respondType = .success
        //        let service = tester.begin()

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
        var cell = applyCellTable(byName: "taxCell", cellArray: &allCells)
        cell.title.accept("Hello")
        cell.detail.accept("world")
        let regularAttributes = [NSAttributedString.Key.font: UIFont.mainFontRegular(ofSize: 12)]
        let largeAttributes = [NSAttributedString.Key.font: UIFont.mainFontBold(ofSize: 24)]
        let attributedSentence = NSMutableAttributedString(string: "THB 1,984", attributes: largeAttributes)
        attributedSentence.setAttributes(regularAttributes, range: NSRange(location: 0, length: 3))
        cell.attributedDetail.accept(attributedSentence)
        cell = applyCellTable(byName: "taxCell", cellArray: &allCells)
        cell.title.accept("Hello")
        cell.detail.accept("world")
//        let regularAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
//        let largeAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24)]
//        let attributedSentence = NSMutableAttributedString(string: "THB 1,984", attributes: largeAttributes)
        attributedSentence.setAttributes(regularAttributes, range: NSRange(location: 0, length: 3))
        cell.attributedDetail.accept(attributedSentence)
//        cell = applyCellTable(byName: "taxCell", cellArray: &allCells)
//        cell = applyCellTable(byName: "taxCell", cellArray: &allCells)
//        cell = applyCellTable(byName: "taxCell", cellArray: &allCells)
//        cell = applyCellTable(byName: "taxCell", cellArray: &allCells)
//        cell = applyCellTable(byName: "taxCell", cellArray: &allCells)
        let section = KTableCellSection(items: allCells)
        let section1 = KTableCellSection(items: allCells)
        sections.append(section)
        sections.append(section1)
        return sections
    }

    private func applyCellTable(byName name: String, cellArray: inout [KTableCellModel]) -> KTableCellModel {
        let count = cellArray.count
        let cell = KTableCellModel(identity: count, cellIden: name)
        cellArray.append(cell)
        return cell
    }
}

extension PreDeclareViewModel {
    struct Input {
        let onLoadView: Driver<Void>
        let onItem: Driver<KTableCellModel?>
//        let onTaxButton: Driver<Void>
        let onShowTax: Driver<IndexPath>
    }

    struct Output {
        let items: Driver<[KTableCellSection]>?
        let commonDispose: CompositeDisposable
    }
}
