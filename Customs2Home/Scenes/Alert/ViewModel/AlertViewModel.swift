//
//  AlertViewModel.swift
//  Customs2Home
//
//  Created by thanawat on 11/13/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire


class AlertViewModel: BaseViewModel<AlertViewModel>,ViewModelProtocol {

    typealias M = AlertViewModel
    typealias T = AlertViewController
    static var obj_instance: AlertViewModel?
    
    var cellModels: [KTableCellModel]?
    private var currentMsgList:[MsgList]?
    private var pageNo = 1
    
    override init() {
        super.init()
    }
    
    func resetDataLoadMore(){
        self.currentMsgList = []
        self.pageNo = 1
    }
    
    
    func transform(input: Input) -> Output {
        let commonDispose = [Disposable]()
        
        /*let onLoad = input.onLoadView
            .do(onNext: {[unowned self] (_) in
                self.resetDataLoadMore()
            })
            .flatMapLatest( fecthdata )*/
        
        let deleteMsgIds = input.onDelete.filter({ (indexPaths) -> Bool in
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
            }.asDriver().flatMapLatest( msgIds )
        
        let reloadItem = deleteMsgIds
            .do(onNext: {[unowned self] (_) in
                self.resetDataLoadMore()
            })
            .withLatestFrom(input.onLoadView)
            .flatMapLatest( fecthdata )
        
        
        
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
 

        let updateList = input.onItem
            .map({ (cellModel) -> MsgList? in
                guard let data = cellModel?.content else { return nil }
                var msgList = data as! MsgList
                
                //update readFlag
                msgList.readFlag = "Y"
                
                if let indexInList = self.currentMsgList?.firstIndex(where: { $0.msgId == msgList.msgId }){
                    self.currentMsgList?[indexInList] = msgList
                }
                return msgList
            })
        
        let reloadList = updateList
            .map({ _ in return })
            .flatMapLatest( updateData )
            


        let onItemSelect = updateList
            .map({ (msgList) -> Int? in
                return msgList?.msgId
            })
            .asObservable()

       
        
        
        
        //let items = Driver.merge(onLoad, onRefresh, reloadItem , onLoadMore, reloadList)
        let items = Driver.merge(onRefresh, reloadItem , onLoadMore, reloadList)
            .do(onNext: { [unowned self] section in
                self.cellModels = section.first?.items
                
                let msgList = section.first?.items.map({ (data) -> MsgList in
                    return data.content as! MsgList
                })
                self.setBadgeToTabBar(msgList)
            })
        
        return AlertViewModel.Output(items: items,
                                     onItemSelect: onItemSelect,
                                     commonDispose: CompositeDisposable(disposables: commonDispose) )
    }
    
    func msgIds(msgIds: [Int]) -> Driver<Bool> {
        guard let loadingScreen = self.loadingScreen   else { return .just(false) }
        
        let baseRequestDeleteMsgReq = BaseRequestDeleteMsgReq(msgdelReq: MsgdelReq(msgId: msgIds))
        let service = DeleteMsgApi().callService(request: baseRequestDeleteMsgReq)
        let loading = loadingScreen.observeLoading(service)
            .map({respond -> Bool in
                return true
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: false)
        
        return loading
    }
    
    func fecthdata() -> Driver<[KTableCellSection]> {
        
        guard let loadingScreen = self.loadingScreen  else {return .just([])}
        
        let service = GetMessagesListApi().callService(request: BaseRequest_MessagesList(pageNo: pageNo, pageMsg: 20))
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
        
        let service = GetMessagesListApi().callService(request: BaseRequest_MessagesList(pageNo: pageNo, pageMsg: 20))
        let loading = loadingScreen.observeLoading(service, noLoading: true)
            .map({ [unowned self] respond -> [KTableCellSection] in
                return self.parser( respond)
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
        return loading
    }
    
    func parser(_ respond:BaseResponse_MessagesList) -> [KTableCellSection]
    {
        
        guard (respond.msglistResp?.msgList?.count ?? 0) > 0 || (currentMsgList?.count ?? 0) > 0 else { return []}
        
        //handle load more
        let count = respond.msglistResp?.msgList?.count ?? 0
        self.viewControl?.updateLoadMoreEnable(count)
        
        var sections = [KTableCellSection]()
        var cells = [KTableCellModel]()
        
        //current data
        currentMsgList?.forEach({ data in
            bindDataDeclareList(data, cells: &cells)
        })
        
        //new data
        respond.msglistResp?.msgList?.forEach({ data in
            bindDataDeclareList(data, cells: &cells)
            currentMsgList?.append(data)
        })
        
        let section = KTableCellSection(items: cells)
        sections.append(section)

        return sections
    }
    
    func updateData() -> Driver<[KTableCellSection]>
       {
          
           var sections = [KTableCellSection]()
           var cells = [KTableCellModel]()
           
           //current data
           currentMsgList?.forEach({ data in
               bindDataDeclareList(data, cells: &cells)
           })
        
           let section = KTableCellSection(items: cells)
           sections.append(section)

        return Driver.just(sections)
       }
    
    
    func bindDataDeclareList(_ data:MsgList, cells:inout [KTableCellModel]){
        let cell = applyCellTable(byName: "alertcell", cellArray: &cells)
        cell.identity = toInt(data.msgId)
        cell.specingBetweenCell = 12.0
        
        
        cell.title.accept(data.topic ?? "")
        cell.subDetail1 = BehaviorRelay<String>(value: data.receiveTxt ?? "")
        cell.subDetail2 = BehaviorRelay<String>(value: data.msg ?? "")
        
        cell.readFlag = BehaviorRelay<Bool>(value: (data.readFlag ?? "") == "Y" ? true : false)
        
        
        cell.content = data
    }
    
    
    func setBadgeToTabBar(_ msgList:[MsgList]?){
        guard let tabItems = self.viewControl?.tabBarController?.tabBar.items else {return }
        guard let msgList = msgList else { return }
        let tabItem = tabItems[3]
        
        let unreadItems = msgList.filter({ (model) -> Bool in
            let flag = model.readFlag ?? ""
            return flag == "N" ? true : false
        })
        let count = unreadItems.count
        KeyChainService.setNotiBadge(data: toString(count))
        tabItem.badgeValue = count == 0 ? nil : toString(count)
    }
    
    private func applyCellTable( byName name:String, cellArray:inout [KTableCellModel]) -> KTableCellModel
    {
        let count = cellArray.count
        let cell =  KTableCellModel(identity: count, cellIden: name)
        cellArray.append( cell )
        return cell
    }
    
}

extension AlertViewModel {
    struct Input {
        let onLoadView: Driver<Void>
        let onRefresh: Driver<Void?>
        let onLoadMore: Driver<Void?>
        let onItem: Driver<KTableCellModel?>
        let onDelete: Driver<[KTableCellModel]?>
    }
    
    struct Output {
        let items: Driver< [KTableCellSection] >?
        let onItemSelect : Observable<Int?>
        let commonDispose: CompositeDisposable
    }
}
