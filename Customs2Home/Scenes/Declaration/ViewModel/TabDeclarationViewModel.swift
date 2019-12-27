//
//  TabDeclarationViewModel.swift
//  Customs2Home
//
//  Created by warodom on 28/11/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import SWSegmentedControl


class TabDeclarationViewModel: BaseViewModel<TabDeclarationViewModel>,ViewModelProtocol {

    typealias M = TabDeclarationViewModel
    typealias T = TabDeclarationViewController
    static var obj_instance: TabDeclarationViewModel?
    
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
        
        let deleteIds = input.onDelete.filter({ (indexPaths) -> Bool in
            indexPaths != nil && self.cellModels != nil
        }).map { [unowned self] (models) -> [Int] in
            if let models = models,  let cellModels = self.cellModels {
                let declareIds = cellModels
                    .sorted(by: { $0.identity > $1.identity })
                    .filter({  models.firstIndex(of: $0) != nil })
                
                return declareIds.map({ model -> Int in
                    return model.identity
                })
            }
            return []
            }.asDriver().flatMapLatest( declareDeleteIds )
        
        let reloadItem = deleteIds
            .do(onNext: {[unowned self] (selectValue) in
                self.resetDataLoadMore()
            })
            .withLatestFrom(input.onSegment)
            .flatMapLatest( fecthdata )
        
        let onsegment = input.onSegment
            .do(onNext: {[unowned self] (selectValue) in
                self.resetDataLoadMore()
            })
            .flatMapLatest( fecthdata )
        
        let onRefresh = input.onRefresh
            .do(onNext: {[unowned self] _ in
                self.resetDataLoadMore()
            })
            .withLatestFrom(input.onSegment)
            .flatMapLatest(fecthdata)
            .do(onNext: { [unowned self] _ in
                self.viewControl?.tableView.rx.refreshing.onNext(false)
            })

        let onLoadMore = input.onLoadMore
            .do(onNext: {[unowned self] _ in self.pageNo += 1 })
            .withLatestFrom(input.onSegment)
            .flatMapLatest(loadMoreFecthdata)
            .do(onNext: { [unowned self] _ in
                self.viewControl?.tableView.rx.loadingMore.onNext(false)
            })

        
        let onItemSelect = input.onItem
            .map({ (cellModel) -> DeclareList? in
                guard let data = cellModel?.content else { return nil }
                let declareList = (data as! DeclareList)
                if (declareList.status ?? "") == "EXPIRED" {
                    return nil
                }
                return declareList
            })
            .asObservable()
        

        
        
        let items = Driver.merge(onsegment, reloadItem, onRefresh, onLoadMore)
            .do(onNext: { [unowned self] section in
                self.cellModels = section.first?.items
            })
        return TabDeclarationViewModel.Output(items: items,
                                              onItemSelect : onItemSelect,
                                              commonDispose: CompositeDisposable(disposables: commonDispose) )
    }
    
    func declareDeleteIds(declareIds: [Int]) -> Driver<Bool> {
        guard let loadingScreen = self.loadingScreen   else { return .just(false) }
       
        let baseRequestDeleteDeclareReq = BaseRequestDeleteDeclareReq(deleteDeclareReq: DeleteDeclareReq(declareID: declareIds))
        let service = DeleteDeclareApi().callService(request: baseRequestDeleteDeclareReq)
        let loading = loadingScreen.observeLoading(service)
            .map({respond -> Bool in
                return true
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: false)
        
        return loading
    }
    
    func fecthdata(index: Int) -> Driver<[KTableCellSection]> {
        guard let loadingScreen = self.loadingScreen
            else {return .just([])}
        
        
        var status = [""]
        if index == 0 {
            status = ["DECLARED", "PENDING_PAYMENT", "FAILED_PAYMENT", "CANCELED_PAYMENT"]
        }else if index == 1{
            status = ["EXPIRED"]
        }
        
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
    func loadMoreFecthdata(index: Int) -> Driver<[KTableCellSection]> {
        guard let loadingScreen = self.loadingScreen  else {return .just([])}
        
        var status = [""]
        if index == 0 {
            status = ["DECLARED", "PENDING_PAYMENT", "FAILED_PAYMENT", "CANCELED_PAYMENT"]
        }else if index == 1{
            status = ["EXPIRED"]
        }
        
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
        
        var cell:KTableCellModel!
        
        if (data.status ?? "") == "EXPIRED" {
            cell = applyCellTable(byName: "tabdeclaration_expired_cell", cellArray: &cells)
        }else{
            cell = applyCellTable(byName: "tabdeclarationcell", cellArray: &cells)
        }
        
        
        cell.identity = toInt(data.declareID)
        cell.detail.accept(toString(data.statusTH))
        cell.attributedDetail = BehaviorRelay<NSAttributedString>(value: toString(data.trackingID).toAttributed())
        cell.attributedDetail2 = BehaviorRelay<NSAttributedString>(value: toString(data.customsID).toAttributed())
        cell.attributedDetail3 = BehaviorRelay<NSAttributedString>(value: toDouble(data.totalTaxTHB).delimiter.toAttributed())
        cell.attributedDetail4 = BehaviorRelay<NSAttributedString>(value: toString(data.declareDate).DateToNewDateFormat(formatIn: "yyyy-MM-dd HH:mm:ss.SSS", formatOut: "dd MMMM yyyy", locale: .init(identifier: "th"), calendar: Calendar(identifier: .buddhist))?.toAttributed() ?? toString(data.declareDate).toAttributed())
        cell.attributedDetail5 = BehaviorRelay<NSAttributedString>(value: toString(data.paymentDueDate).DateToNewDateFormat(formatIn: "yyyy-MM-dd HH:mm:ss.SSS", formatOut: "dd MMMM yyyy", locale: .init(identifier: "th"), calendar: Calendar(identifier: .buddhist))?.toAttributed() ?? toString(data.paymentDueDate).toAttributed())
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



extension TabDeclarationViewModel {
    struct Input {
        let onLoadView: Driver<Void>
        let onRefresh: Driver<Void?>
        let onLoadMore: Driver<Void?>
        let onItem: Driver<KTableCellModel?>
        let onSegment: Driver<Int>
        let onDelete: Driver<[KTableCellModel]?>
    }
    
    struct Output {
        let items: Driver< [KTableCellSection] >?
        let onItemSelect : Observable<DeclareList?>
        let commonDispose: CompositeDisposable
    }
}
