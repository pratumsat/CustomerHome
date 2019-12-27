//
//  PaymentViewModel.swift
//  Customs2Home
//
//  Created by warodom on 2/12/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire


class PaymentViewModel: BaseViewModel<PaymentViewModel>,ViewModelProtocol {

    typealias M = PaymentViewModel
    typealias T = PaymentViewController
    static var obj_instance: PaymentViewModel?
    
    var cellModels: [KTableCellModel]?
    private var currentDeclareList:[DeclareList]?
    private var pageNo = 1
    
    override init() {
        super.init()
    }
    
    func resetDataLoadMore(){
        self.currentDeclareList = []
        self.pageNo = 1
    }
    
    func transform(input: Input) -> Output {
        let commonDispose = [Disposable]()
        //let onload = input.onLoadView.map({ 0 }).flatMapLatest( fecthdata )
        
        let onItemSelect = input.onItem
            .map({ (cellModel) -> String? in
                guard let data = cellModel?.content else { return nil }
                guard let declareID = (data as! DeclareList).declareID else { return nil }
                return declareID
            })
            .asObservable()

        /*let items = input.onLoadView.flatMapLatest( fecthdata )
            .do(onNext: { [unowned self] section in
                self.cellModels = section.first?.items
            })*/
        
        let onRefresh = input.onRefresh
            .do(onNext: {[unowned self] _ in
                self.resetDataLoadMore()
            })
            .withLatestFrom(input.onLoadView)
            .flatMapLatest(fecthdata)
            .do(onNext: { [unowned self] _ in
                self.viewControl?.tableView.rx.refreshing.onNext(false)
            })
        
        let onLoadMore = input.onLoadMore
            .do(onNext: {[unowned self] _ in self.pageNo += 1 })
            .withLatestFrom(input.onLoadView)
            .flatMapLatest(loadMoreFecthdata)
            .do(onNext: { [unowned self] _ in
                self.viewControl?.tableView.rx.loadingMore.onNext(false)
            })
        
        let allItem = Driver.merge(onRefresh, onLoadMore)
        return PaymentViewModel.Output(items: allItem,
                                       onItemSelect : onItemSelect,
                                        commonDispose: CompositeDisposable(disposables: commonDispose) )
        
    }
    
    func fecthdata() -> Driver<[KTableCellSection]> {
        guard let loadingScreen = self.loadingScreen   else {return .just([])}
        
        let status = ["APPROVED", "REJECTED"]
        
        let searchCriteria = SearchCriteria(status: status)
        let baseRequest_Declarelist  = BaseRequest_Declarelist(pageNo: pageNo, pageItem: 20, searchCriteria: searchCriteria)
        let service = GetDeclareListApi().callService(request: baseRequest_Declarelist)
        let loading = loadingScreen.observeLoading(service)
            .map({ [unowned self] respond -> [KTableCellSection] in
                return self.parser( respond)
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
        return loading
        
    }
    
    func loadMoreFecthdata() -> Driver<[KTableCellSection]> {
        guard let loadingScreen = self.loadingScreen  else {return .just([])}
        
        let status = ["APPROVED", "REJECTED"]
        
        let searchCriteria = SearchCriteria(status: status)
        let baseRequest_Declarelist  = BaseRequest_Declarelist(pageNo: pageNo, pageItem: 20, searchCriteria: searchCriteria)
        let service = GetDeclareListApi().callService(request: baseRequest_Declarelist)
        let loading = loadingScreen.observeLoading(service, noLoading: true )
            .map({ [unowned self] respond -> [KTableCellSection] in
                return self.parser( respond)
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
        return loading
        
    }
    
    func parser(_ respond:BaseResponse_DeclareList) -> [KTableCellSection]
    {
        
        guard (respond.declareResp?.declareList?.count ?? 0) > 0 || (currentDeclareList?.count ?? 0) > 0 else { return []}
        
        //handle load more
        let count = respond.declareResp?.declareList?.count ?? 0
        self.viewControl?.updateLoadMoreEnable(count)
        
        var sections = [KTableCellSection]()
        var cells = [KTableCellModel]()
        
        //current data
        currentDeclareList?.forEach({ data in
            bindDataDeclareList(data, cells: &cells)
        })
        
        //new data
        respond.declareResp?.declareList?.forEach({ data in
            bindDataDeclareList(data, cells: &cells)
            currentDeclareList?.append(data)
        })
        
        let section = KTableCellSection(items: cells)
        sections.append(section)
        
        
        return sections
    }
    
    
    func bindDataDeclareList(_ data:DeclareList, cells:inout [KTableCellModel]){
        let cell = applyCellTable(byName: "tabdeclarationcell", cellArray: &cells)
        cell.identity = toInt(data.declareID)
        cell.detail.accept(toString(data.statusTH))
        cell.attributedDetail = BehaviorRelay<NSAttributedString>(value: toString(data.trackingID).toAttributed())
        cell.attributedDetail2 = BehaviorRelay<NSAttributedString>(value: toString(data.customsID).toAttributed())
        cell.attributedDetail3 = BehaviorRelay<NSAttributedString>(value: toDouble(data.totalTaxTHB).delimiter.toAttributed())
        cell.attributedDetail4 = BehaviorRelay<NSAttributedString>(value: toString(data.declareDate).DateToNewDateFormat(formatIn: "yyyy-MM-dd HH:mm:ss.SSS", formatOut: "dd MMMM yyyy", locale: .init(identifier: "th"), calendar: Calendar(identifier: .buddhist))?.toAttributed() ?? toString(data.declareDate).toAttributed())
        cell.attributedDetail5 = BehaviorRelay<NSAttributedString>(value: toString(data.paymentDate).DateToNewDateFormat(formatIn: "yyyy-MM-dd HH:mm:ss.SSS", formatOut: "dd MMMM yyyy", locale: .init(identifier: "th"), calendar: Calendar(identifier: .buddhist))?.toAttributed() ?? toString(data.paymentDate).toAttributed())
        cell.content = data
    }
    
    private func applyCellTable( byName name:String, cellArray:inout [KTableCellModel]) -> KTableCellModel
    {
        let count = cellArray.count
        let cell =  KTableCellModel(identity: count, cellIden: name)
        cellArray.append( cell )
        return cell
    }
    
}

extension PaymentViewModel {
    struct Input {
        let onLoadView: Driver<Void>
        let onRefresh: Driver<Void?>
        let onLoadMore: Driver<Void?>
        let onItem: Driver<KTableCellModel?>
    }
    
    struct Output {
        let items: Driver< [KTableCellSection] >?
        let onItemSelect : Observable<String?>
        let commonDispose: CompositeDisposable
    }
}
