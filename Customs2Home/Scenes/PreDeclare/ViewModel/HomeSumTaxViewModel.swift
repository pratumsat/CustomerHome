//
//  HomeSumTaxViewModel.swift
//  Customs2Home
//
//  Created by thanawat on 11/29/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RealmSwift
import RxAlamofire
import RxCocoa
import RxSwift

class HomeSumTaxViewModel: BaseViewModel<HomeSumTaxViewModel>, ViewModelProtocol {
    typealias M = HomeSumTaxViewModel
    typealias T = HomeSumTaxViewController
    static var obj_instance: HomeSumTaxViewModel?
    var taxDis = BehaviorRelay<Int>(value: 0)
    
    var calTaxResp: CalTaxResp?
    // var calTaxReq = BehaviorRelay<CalTaxReq?>(value: nil)
    
    //    var loadingScreen: ScreenLoadingView? {
    //        return viewControl?.view.getScreenLoading()
    //    }
    
    var flagUpdate = BehaviorRelay<String>(value: "Y")
    var hiddenSaveButton = BehaviorRelay<Bool>(value: true)
    var textCurrency = BehaviorRelay<String>(value: "")
    var textTotalTaxDisplay = BehaviorRelay<Int>(value: 0)
    
    var modelCalTaxReq: CalTaxReq?
    var calTaxID = 0
    var currencyImage = ""
    var exchangeRateSeqId = 0
    var freight = 0.0
    var insurance = 0.0
    
    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        flagUpdate.accept("Y")
        hiddenSaveButton.accept(true)
        taxDis.accept(0)
        
        modelCalTaxReq = nil
        calTaxID = 0
        currencyImage = ""
        exchangeRateSeqId = 0
        freight = 0.0
        insurance = 0.0
        
        var commonDispose = [Disposable]()
        let itemOnLoad = input.onLoadView.flatMapLatest(fecthdata)
        
        let onItemHomePredeclare = input.onItemCalTaxResp.do(onNext: { [unowned self] model in
            if let model = model {
                self.calTaxID = model.calTaxId
                self.exchangeRateSeqId = model.exchangeRateSeqId
                self.currencyImage = model.currencyImage
                self.freight = model.freight
                self.insurance = model.insurance
                
                var preDeclareList: [PreDeclareList] = []
                model.preDeclare.forEach({ model in
                    let preDeclare = PreDeclareList(tariffSeqID: model.tariffSeqID,
                                                    categoryID: model.categoryID ?? "",
                                                    subCategoryID: model.subCategoryID ?? "",
                                                    tariffID: model.tariffID ?? "",
                                                    tariffNameEN: model.tariffNameEN ?? "",
                                                    tariffNameTH: model.tariffNameTH ?? "",
                                                    unitPrice: model.unitPrice,
                                                    quantity: model.quantity)
                    preDeclareList.append(preDeclare)
                })
                
                let calTaxReq = CalTaxReq(exchangeRateSeqId: model.exchangeRateSeqId,
                                          currencyCode: model.currencyCode ?? "",
                                          freight: model.freight,
                                          insurance: model.insurance,
                                          preDeclareList: preDeclareList)
                // prepare update data
                self.modelCalTaxReq = calTaxReq
                self.textCurrency.accept("อัตราแลกเปลี่ยน \(model.currencyCode ?? "") \(model.rateFactor ) = THB \(model.exchangeRate )")
                self.textTotalTaxDisplay.accept(model.totalTaxDisplay)
                //self.flagUpdate.accept(model.flagCurrencyCurrent ?? "Y")
                self.flagUpdate.accept("N") // always update
            }
        }).map({ [unowned self] modelCalTaxReq in
            self.parser(modelCalTaxReq)
        }).asDriver(onErrorJustReturn: [])
        
        let updateTax = input.btnUpdateTax.map { [unowned self] _ in
            self.modelCalTaxReq
            }
            .flatMapLatest(fecthdata)
            .asDriver(onErrorJustReturn: [])
        
        let checkUpdate = input.declareButton
            .filter({ _ in return TokenModel.instance().checkAccountValid() })
            .withLatestFrom(flagUpdate)
            .map({ $0 == "Y"})
        
        let declareAddEditReq = checkUpdate.filter({ $0 == true})
            .map({_ in self.calTaxResp })
            .flatMapLatest(getDeclareAddEditReq)
        
        
        
        let items = Driver.merge(itemOnLoad, onItemHomePredeclare, updateTax)
        
        return HomeSumTaxViewModel.Output(items: items,
                                          showAlertUpdate: checkUpdate.filter({ $0 == false }),
                                          declareAddEditReq: declareAddEditReq.filter({ $0 != nil }),
                                          commonDispose: CompositeDisposable(disposables: commonDispose))
    }
    
    func getDeclareAddEditReq(_ model: CalTaxResp? = nil) -> Observable<DeclareAddEditReq?>{
        guard let loadingScreen = self.loadingScreen, let cal = model  else { return .just(nil) }
        
        var tariffList:[AddEditTariffList] = []

        cal.preDeclareList?.forEach({ (model) in
            tariffList.append(AddEditTariffList(tariffSeqID: model.tariffSeqID,
                                                categoryID: model.categoryID,
                                                subCategoryID: model.subCategoryID,
                                                tariffID: model.tariffID,
                                                tariffNameEN: model.tariffNameEN,
                                                tariffNameTH: model.tariffNameTH,
                                                unitPrice: model.unitPrice,
                                                quantity: model.quantity,
                                                price: model.price,
                                                freight: model.freight,
                                                insurance: model.insurance,
                                                freightInsurance: model.freightInsurance,
                                                cif: model.cif,
                                                importDutyRate: model.importDutyRate,
                                                vatRate: model.vatRate,
                                                priceTHB: model.priceTHB,
                                                freightTHB: model.freightTHB,
                                                insuranceTHB: model.insuranceTHB,
                                                freightInsuranceTHB: model.freightInsuranceTHB,
                                                cifTHB: model.cifTHB,
                                                importDutyTHB: model.importDutyTHB,
                                                vatTHB: model.vatTHB,
                                                taxDutyTHB: model.taxDutyTHB))
        })
        
        var declareAddEdit = DeclareAddEditReq(totalCostTHB: cal.totalCostTHB,
                                               totalInsuranceTHB: cal.totalInsuranceTHB,
                                               totalFreightTHB: cal.totalFreightTHB,
                                               totalCifTHB: cal.totalCifTHB,
                                               totalDutyTHB: cal.totalDutyTHB,
                                               totalVatTHB: cal.totalVatTHB,
                                               totalTaxTHB: cal.totalTaxTHB,
                                               totalTaxDisplay: cal.totalTaxDisplay,
                                               exchangeRateSeqId: cal.exchangeRateSeqId,
                                               currencyCode: cal.currencyCode,
                                               exchangeRate: cal.exchangeRate,
                                               rateFactor: cal.rateFactor,
                                               tariffList: tariffList,
                                               status: "DECLARED")
        
        declareAddEdit.calTaxId = calTaxID
        
        let service = Observable.just(declareAddEdit)
        let loading = loadingScreen.observeLoading(service)
            .map({ (declareAddEditReq) -> DeclareAddEditReq? in
                return declareAddEditReq
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
        
        return loading
        
    }
    
    
    func updateCalTaxResp(){
        if let calTaxResp = self.calTaxResp {
            calTaxResp.calTaxId = calTaxID
            ConfigRealm().addCalTaxResp(calTaxResp)
            HomePreDeclareViewModel.instance().onReloadItem.accept(HomePreDeclareViewModel.instance().parser(ConfigRealm().getCalTaxResp()))
        }
    }
    
    func fecthdata(_ model: CalTaxReq? = nil) -> Driver<[KTableCellSection]> {
        guard let loadingScreen = self.loadingScreen
            , let cal = model
            //            , let exchange = CurrencyViewModel.instance().selectExchange.value
            else { return .just([]) }
        //        let service = Observable.just(true)
        
        //        let cal = CalTaxReq(exchangeRateSeqId: exchange.exchangeRateSeqId ?? 0, currencyCode: exchange.currencyCode ?? "", freight: 40, insurance: 15, preDeclareList: [PreDeclareList(tariffSeqID: 1, categoryID: "01", subCategoryID: "01", tariffID: "61149090", tariffNameEN: "Clothes", tariffNameTH: "เสื้อผ้า", unitPrice: 100, quantity: 1), PreDeclareList(tariffSeqID: 2, categoryID: "02", subCategoryID: "01", tariffID: "33049990", tariffNameEN: "Cosmetics", tariffNameTH: "เครื่องสำอาง", unitPrice: 100, quantity: 1)])
        
        let base = BaseRequestCalTax(calTaxReq: cal)
        let service = CalTaxApi().callService(request: base)
        
        let loading = loadingScreen.observeLoading(service)
            .map({ [unowned self] respond -> [KTableCellSection] in
                self.taxDis.accept(respond.calTaxResp?.totalTaxDisplay ?? 0)
                
                self.flagUpdate.accept(respond.calTaxResp?.flagCurrencyCurrent ?? "")
                self.textCurrency.accept("อัตราแลกเปลี่ยน \(respond.calTaxResp?.currencyCode ?? "") \(respond.calTaxResp?.rateFactor ?? 1 ) = THB \(respond.calTaxResp?.exchangeRate ?? 0 )")
                self.textTotalTaxDisplay.accept((respond.calTaxResp?.totalTaxDisplay ?? 0))
                //self.hiddenSaveButton.accept(false)
                
                return self.parser(respond)
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
        return loading
    }
    
    func parser(_ respond: CalTax) -> [KTableCellSection] {
        var sections = [KTableCellSection]()
        var cellModels = [KTableCellModel]()
        
        calTaxResp = respond.calTaxResp
        
        calTaxResp?.exchangeRateSeqId = exchangeRateSeqId
        calTaxResp?.currencyImage = currencyImage
        calTaxResp?.freight = freight
        calTaxResp?.insurance = insurance
        self.updateCalTaxResp()
        
        
        respond.calTaxResp?.preDeclareList?.forEach({ data in
            let cell = applyCellTable(byName: "sumtaxcell", cellArray: &cellModels)
            bindCell(data, flagCurrencyCurrent: respond.calTaxResp?.flagCurrencyCurrent, cell: cell)
        })
        
        let section = KTableCellSection(items: cellModels)
        sections.append(section)
        return sections
    }
    
    func parser(_ respond: CalTaxResp?) -> [KTableCellSection] {
        var sections = [KTableCellSection]()
        var cellModels = [KTableCellModel]()
        
        calTaxResp = respond
        respond?.preDeclare.forEach({ data in
            let cell = applyCellTable(byName: "sumtaxcell", cellArray: &cellModels)
            bindCell(data, flagCurrencyCurrent: respond?.flagCurrencyCurrent, cell: cell)
        })
        
        let section = KTableCellSection(items: cellModels)
        sections.append(section)
        return sections
    }
    
    func bindCell(_ data:PreDeclareList ,flagCurrencyCurrent:String?, cell:KTableCellModel){
        cell.title.accept("สินค้า: \(data.tariffName ?? "")")
        
        cell.subDetail6 = BehaviorRelay<String>(value: "ค่าอัตราอากรขาเข้า (\(Int(data.importDutyRate * 100)))%")
        cell.subDetail7 = BehaviorRelay<String>(value: "ภาษีมูลค่าเพิ่ม (\(Int(data.vatRate * 100)))%")
        
        let ex = CurrencyViewModel.instance().selectExchange.value
        cell.attributedDetail = BehaviorRelay<NSAttributedString>(value: data.cif.delimiter.toAttributedString(currency: ex?.currencyCode ?? "THB"))
        cell.attributedDetail2 = BehaviorRelay<NSAttributedString>(value: data.cifTHB.delimiter.toAttributedString(currency: "THB"))
        cell.attributedDetail3 = BehaviorRelay<NSAttributedString>(value: data.importDutyTHB.delimiter.toAttributedString(currency: "THB"))
        cell.attributedDetail4 = BehaviorRelay<NSAttributedString>(value: data.vatTHB.delimiter.toAttributedString(currency: "THB"))
        cell.attributedDetail5 = BehaviorRelay<NSAttributedString>(value: data.taxDutyTHB.delimiter.toAttributedString(currency: "THB"))
        
        
        if flagCurrencyCurrent == "Y" {
            cell.image.accept(nil)
        } else {
            cell.image.accept(UIImage(named: "icAlert"))
        }
    }
    
    private func applyCellTable(byName name: String, cellArray: inout [KTableCellModel]) -> KTableCellModel {
        let count = cellArray.count
        let cell = KTableCellModel(identity: count, cellIden: name)
        cellArray.append(cell)
        return cell
    }
}

extension HomeSumTaxViewModel {
    struct Input {
        let onLoadView: Driver<CalTaxReq?>
        let onItem: Driver<KTableCellModel?>
        let declareButton: Observable<Void>
        let btnUpdateTax: Observable<Void>
        let onItemCalTaxResp: BehaviorRelay<CalTaxResp?>
    }
    
    struct Output {
        let items: Driver<[KTableCellSection]>?
        let showAlertUpdate: Observable<Bool>
        let declareAddEditReq: Observable<DeclareAddEditReq?>
        let commonDispose: CompositeDisposable
    }
}
