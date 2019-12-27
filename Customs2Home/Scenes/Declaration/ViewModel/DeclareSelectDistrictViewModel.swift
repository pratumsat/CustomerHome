//
//  DeclareSelectDistrictViewModel.swift
//  Customs2Home
//
//  Created by warodom on 3/12/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire


class DeclareSelectDistrictViewModel: BaseViewModel<DeclareSelectDistrictViewModel>,ViewModelProtocol {

    typealias M = DeclareSelectDistrictViewModel
    typealias T = DeclareSelectDistrictViewController
    static var obj_instance: DeclareSelectDistrictViewModel?
    var districtSelect = BehaviorRelay<(String, String)?>(value:nil)
    
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
            let str = (cellModel?.title.value ?? "",(cellModel?.content.value as? String) ?? "")
            self.districtSelect.accept(str)
            self.viewControl?.onSubDistric()
        })
        commonDispose.append(onListItem.drive())
        return DeclareSelectDistrictViewModel.Output(items: item,
                                             commonDispose: CompositeDisposable(disposables: commonDispose) )
    }
    
    
    func fecthdata(provinceCode: String) -> Driver<[KTableCellSection]> {
        
        guard let loadingScreen = self.loadingScreen
            else {return .just([])}
        
        let service = GetDistrictApi().callServiceNoSecurity(request: BaseRequest_District(districtReq: DistrictReq(provinceId: provinceCode)))
        let loading = loadingScreen.observeLoading(service)
        .map({ [unowned self] respond -> [KTableCellSection] in
            return self.parser( respond)
        })
        .subscribeOn(MainScheduler.asyncInstance)
        .observeOn(MainScheduler.instance)
        .asDriver(onErrorJustReturn: [])
        return loading
        
    }
    
    func parser(_ respond:Response_District) -> [KTableCellSection]
    {
        var sections = [KTableCellSection]()
        var cellsForSection = [KTableCellModel]()
        
        respond.districtResp?.dropdownList?.forEach({ data in
            let cell = applyCellTable(byName: "areacell", cellArray: &cellsForSection)
            cell.title.accept(data.label ?? "")
            cell.content = data.key
        })
        
        sections.append(KTableCellSection(items: cellsForSection))
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

extension DeclareSelectDistrictViewModel {
    struct Input {
        let onLoadView: Driver<String>
        let onItem: Driver<KTableCellModel?>
    }
    
    struct Output {
        let items: Driver< [KTableCellSection] >?
        let commonDispose: CompositeDisposable
    }
}
