//
import RealmSwift
import RxAlamofire
import RxCocoa
import RxSwift
//  SumTaxViewModel.swift
//  Customs2Home
//
//  Created by warodom on 25/9/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit

class SumTaxViewModel: BaseViewModel<SumTaxViewModel>, ViewModelProtocol {
    typealias M = SumTaxViewModel
    typealias T = SumTaxViewController
    static var obj_instance: SumTaxViewModel?
    var taxDis = BehaviorRelay<Int>(value: 0)

    var calTaxResp: CalTaxResp?
    // var calTaxReq = BehaviorRelay<CalTaxReq?>(value: nil)

//    var loadingScreen: ScreenLoadingView? {
//        return viewControl?.view.getScreenLoading()
//    }

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

        taxDis.accept(0)

        modelCalTaxReq = nil
        calTaxID = 0
        currencyImage = ""
        exchangeRateSeqId = 0
        freight = 0.0
        insurance = 0.0

        var commonDispose = [Disposable]()
        let itemOnLoad = input.onLoadView.flatMapLatest(fecthdata)

        let updateTax = input.btnUpdateTax.map { [unowned self] _ in
            self.modelCalTaxReq
        }
        .flatMapLatest(fecthdata)
        .asDriver(onErrorJustReturn: [])

        let saveButton = input.saveButton.subscribe { [unowned self] _ in
            self.updateCalTaxResp()
            self.viewControl?.goToHomePreDeClare()
        }
        commonDispose.append(saveButton)

        let flagCurrencyCurrent = CurrencyViewModel.instance().selectExchange.map({ data -> String in
            return data?.flagCurrencyCurrent ?? ""
        })
        let checkUpdate = input.declareButton
            .filter({ _ in return TokenModel.instance().checkAccountValid() })
            .withLatestFrom(flagCurrencyCurrent)
            .map({ $0 == "Y"})
        
        let declareAddEditReq = checkUpdate.filter({ $0 == true})
            .map({_ in self.calTaxResp })
            .flatMapLatest(getDeclareAddEditReq)
        
        let items = Driver.merge(itemOnLoad , updateTax)

        return SumTaxViewModel.Output(items: items,
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
        let declareAddEdit = DeclareAddEditReq(totalCostTHB: cal.totalCostTHB,
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
            ConfigRealm().addCalTaxResp(calTaxResp)
            HomePreDeclareViewModel.instance().onReloadItem.accept(HomePreDeclareViewModel.instance().parser(ConfigRealm().getCalTaxResp()))
        }
    }
    
    func fecthdata(_ model: CalTaxReq? = nil) -> Driver<[KTableCellSection]> {
        guard let loadingScreen = self.loadingScreen , let cal = model else { return .just([]) }

        let base = BaseRequestCalTax(calTaxReq: cal)
        let service = CalTaxApi().callService(request: base)

        let loading = loadingScreen.observeLoading(service)
            .map({ [unowned self] respond -> [KTableCellSection] in
                self.taxDis.accept(respond.calTaxResp?.totalTaxDisplay ?? 0)

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


        calTaxResp?.exchangeRateSeqId = CurrencyViewModel.instance().selectExchange.value?.exchangeRateSeqId ?? 0
        calTaxResp?.currencyImage = CurrencyViewModel.instance().selectExchange.value?.currencyImage ?? ""
        calTaxResp?.freight = Double(ListItemViewModel.instance().calcostifUpdate.value?.freight ?? 0)
        calTaxResp?.insurance = Double(ListItemViewModel.instance().calcostifUpdate.value?.insurance ?? 0)
     
   

        respond.calTaxResp?.preDeclareList?.forEach({ data in
            let cell = applyCellTable(byName: "sumtaxcell", cellArray: &cellModels)
            bindCell(data, flagCurrencyCurrent: respond.calTaxResp?.flagCurrencyCurrent, cell: cell)
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

extension SumTaxViewModel {
    struct Input {
        let onLoadView: Driver<CalTaxReq?>
        let onItem: Driver<KTableCellModel?>
        let saveButton: Observable<Void>
        let declareButton: Observable<Void>
        let btnUpdateTax: Observable<Void>
    }

    struct Output {
        let items: Driver<[KTableCellSection]>?
        let showAlertUpdate: Observable<Bool>
        let declareAddEditReq: Observable<DeclareAddEditReq?>
        let commonDispose: CompositeDisposable
    }
}
