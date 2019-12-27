//
//  DeclareSelectProvinceViewModel.swift
//  Customs2Home
//
//  Created by warodom on 3/12/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire


class DeclareSelectProvinceViewModel: BaseViewModel<DeclareSelectProvinceViewModel>,ViewModelProtocol {
    
    typealias M = DeclareSelectProvinceViewModel
    typealias T = DeclareSelectProvinceViewController
    static var obj_instance: DeclareSelectProvinceViewModel?
    var provinceSelect = BehaviorRelay<(String, String)?>(value:nil)
    
    //    var loadingScreen: ScreenLoadingView? {
    //        return viewControl?.view.getScreenLoading()
    //    }
    
    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        var commonDispose = [Disposable]()
        let item = input.onLoadView.flatMapLatest( fecthdata )
        let onListItem = input.onItem.do(onNext: { [unowned self] cellModel in
            cellModel?.onCellCheck.accept(true)
            self.provinceSelect.accept((cellModel?.title.value, (cellModel?.content as? String)) as? (String, String))
            self.viewControl?.onArea()
        })
        commonDispose.append(onListItem.drive())
        return DeclareSelectProvinceViewModel.Output(items: item,
                                              commonDispose: CompositeDisposable(disposables: commonDispose) )
    }
    
    
    func fecthdata() -> Driver<[KTableCellSection]> {
        
        guard let loadingScreen = self.loadingScreen
            else {return .just([])}
        
        //        let service = Observable.just(true)
        //         let service = GetProvince().callService(request: BaseRequest_Province(version: "2019-11-20 12:49:16:227"))
        //        let service = GetProvince().callService(request: BaseRequest_Province(version: ""))
        let service = GetProvince().callServiceNoSecurity(request: BaseRequest_Province(version: UserDefaultService.getProvinceVersion ?? ""))
        let loading = loadingScreen.observeLoading(service)
            .map({ [unowned self] respond -> [KTableCellSection] in
                return self.parser( respond)
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
        return loading
        
    }
    
    func parser(_ respond:Response_Province) -> [KTableCellSection]
    {
        UserDefaultService.setProvinceVersion(date: respond.provinceResp?.version ?? "")
        var sections = [KTableCellSection]()
        var cells = [KTableCellModel]()
        
        respond.provinceResp?.dropdownList?.forEach({ data in
            let cell = applyCellTable(byName: "provincecell", cellArray: &cells)
            cell.title.accept(data.label ?? "")
            cell.content = data.key
        })
        
        let section = KTableCellSection(items: cells)
        sections.append(section)
        return sections
    }
    
    private func applyCellTable( byName name:String, cellArray:inout [KTableCellModel]) -> KTableCellModel
    {
        let count = cellArray.count
        let cell =  KTableCellModel(identity: count, cellIden: name)
        cellArray.append( cell )
        return cell
    }
    
}

extension DeclareSelectProvinceViewModel {
    struct Input {
        let onLoadView: Driver<Void>
        let onItem: Driver<KTableCellModel?>
    }
    
    struct Output {
        let items: Driver< [KTableCellSection] >?
        let commonDispose: CompositeDisposable
    }
}
