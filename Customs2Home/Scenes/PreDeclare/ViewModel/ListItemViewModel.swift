//
//  ListItemViewModel.swift
//  Customs2Home
//
//  Created by warodom on 5/9/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxAlamofire
import RxCocoa
import RxSwift

class ListItemViewModel: BaseViewModel<ListItemViewModel>, ViewModelProtocol {
    typealias M = ListItemViewModel
    typealias T = ListItemViewController
    static var obj_instance: ListItemViewModel?
    var taxDis = BehaviorRelay<Double>(value: 0)
    var cellModels: [KTableCellModel]?
    var calcostif = BehaviorRelay<CalCostReq?>(value: nil)
    var modelCalTax:CalTaxReq?
    
    var calTaxReq:CalCostReq?
    var calcostifUpdate = BehaviorRelay<CalCostReq?>(value: nil)
//    var loadingScreen: ScreenLoadingView? {
//        return viewControl?.view.getScreenLoading()
//    }
    
    override init() {
        super.init()
    }
    
    
    func transform(input: Input) -> Output {
        //Clear Data
        modelCalTax = nil
        taxDis.accept(0)
        cellModels = nil
        calcostif.accept(nil)
        
        var commonDispose = [Disposable]()
        let onLoad = calcostif.asDriver().flatMapLatest( fecthdata )
        //let onLoad = input.onLoadView.flatMapLatest(fecthdata)
        
        let bindTaxReq = calcostif.bind {[unowned self] (calTaxReq) in
            self.calTaxReq = calTaxReq
        }
        commonDispose.append(bindTaxReq)
        
        let onDelete = input.onDelete.filter({ (indexPaths) -> Bool in
            indexPaths != nil && self.cellModels != nil
        }).map { [unowned self] (models) -> CalCostReq? in
            if let models = models,
                let cellModels = self.cellModels {
                let _ = cellModels.sorted(by: { $0.identity > $1.identity }).filter({ searchModel in
                    let result = models.firstIndex(of: searchModel)
                    if result != nil {
                        self.calTaxReq?.preDeclareList?.remove(at: searchModel.identity)
                    }
                    return result == nil
                })
            }
            return self.calTaxReq
        }.asDriver().flatMapLatest( fecthdata )
        
        let items = Driver.merge(onLoad, onDelete)
            .do(onNext: { [unowned self] section in
                self.cellModels = section.first?.items
            })
        return ListItemViewModel.Output(items: items,
                                        commonDispose: CompositeDisposable(disposables: commonDispose))
    }
    
    func fecthdata(calCostIf: CalCostReq?) -> Driver<[KTableCellSection]> {
        guard let loadingScreen = self.loadingScreen
       , let cal = calCostIf
            else { return .just([]) }

        self.calcostifUpdate.accept(cal)
        
        if cal.preDeclareList?.isEmpty ?? true {
            self.taxDis.accept(0.00)
            return .just([])
        }
        
        
        let service = CalcostifApi().callService(request: BaseRequestCalCostIf(calCostReq: cal))
        let loading = loadingScreen.observeLoading(service)
            .map({ [unowned self] respond -> [KTableCellSection] in
                self.taxDis.accept(respond.calCIFResp?.totalCIFTHB ?? 0.00)
                return self.parser(respond)
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
        return loading
    }
    
    func parser(_ respond: CalCostIf) -> [KTableCellSection] {
        var sections = [KTableCellSection]()
        var allcells = [KTableCellModel]()
        
        let exchange = CurrencyViewModel.instance().selectExchange.value
        var prelist = [PreDeclareList]()
        
        respond.calCIFResp?.preDeclareList?.forEach({ data in
            let cell = applyCellTable(byName: "itemcell", cellArray: &allcells)
            cell.title.accept("สินค้า: \(data.tariffNameTH ?? "")")
            let ex = CurrencyViewModel.instance().selectExchange.value
            cell.attributedDetail = BehaviorRelay<NSAttributedString>(value: data.price.delimiter.toAttributedString(currency: ex?.currencyCode ?? ""))
            cell.attributedDetail2 = BehaviorRelay<NSAttributedString>(value: data.freight.delimiter.toAttributedString(currency: ex?.currencyCode ?? ""))
            cell.attributedDetail3 = BehaviorRelay<NSAttributedString>(value: data.insurance.delimiter.toAttributedString(currency: ex?.currencyCode ?? ""))
            cell.attributedDetail4 = BehaviorRelay<NSAttributedString>(value: data.cif.delimiter.toAttributedString(currency: ex?.currencyCode ?? ""))
            cell.attributedDetail5 = BehaviorRelay<NSAttributedString>(value: data.cifTHB.delimiter.toAttributedString(currency: "THB"))
            cell.content = data
            prelist.append(PreDeclareList(tariffSeqID: data.tariffSeqID, categoryID: data.categoryID ?? "", subCategoryID: data.subCategoryID ?? "", tariffID: data.tariffID ?? "", tariffNameEN: data.tariffNameEN ?? "", tariffNameTH: data.tariffNameTH ?? "", unitPrice: data.unitPrice, quantity: data.quantity))
        })
        
//        SumTaxViewModel.instance().calTaxReq.accept(CalTaxReq(exchangeRateSeqId: exchange?.exchangeRateSeqId ?? 0, currencyCode: exchange?.currencyCode ?? "", freight: 40, insurance: 10, preDeclareList: prelist))

        guard let pre = calcostifUpdate.value?.preDeclareList else { return [] }
        self.modelCalTax = CalTaxReq(exchangeRateSeqId: exchange?.exchangeRateSeqId ?? 0, currencyCode: exchange?.currencyCode ?? "", freight: calcostifUpdate.value?.freight ?? 0, insurance: calcostifUpdate.value?.insurance ?? 0, preDeclareList: pre)
         //SumTaxViewModel.instance().calTaxReq.accept(CalTaxReq(exchangeRateSeqId: exchange?.exchangeRateSeqId ?? 0, currencyCode: exchange?.currencyCode ?? "", freight: 40, insurance: 10, preDeclareList: pre))
        
        let section = KTableCellSection(items: allcells)
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

extension ListItemViewModel {
    struct Input {
        let onLoadView: Driver<Void>
        let onItem: Driver<KTableCellModel?>
        let onDelete: Driver<[KTableCellModel]?>
    }
    
    struct Output {
        let items: Driver<[KTableCellSection]>?
        let commonDispose: CompositeDisposable
    }
}
