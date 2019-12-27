//
//  DeclareSelectSubdistrictViewModel.swift
//  Customs2Home
//
//  Created by warodom on 3/12/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire


class DeclareSelectSubdistrictViewModel: BaseViewModel<DeclareSelectSubdistrictViewModel>,ViewModelProtocol {

    typealias M = DeclareSelectSubdistrictViewModel
    typealias T = DeclareSelectSubdistrictViewController
    static var obj_instance: DeclareSelectSubdistrictViewModel?
    var subDistrictSelect = BehaviorRelay<(String, String)?>(value:nil)
    var zipCode = BehaviorRelay<String?>(value:nil)
    
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
            let cellConten = cellModel?.content.value as? (String ,String)
            let str = (cellModel?.title.value ?? "",(cellConten?.0) ?? "")
            self.subDistrictSelect.accept(str)
            self.zipCode.accept(cellConten?.1)
            self.viewControl?.onPostcode()
        })
        commonDispose.append(onListItem.drive())
        return DeclareSelectSubdistrictViewModel.Output(items: item,
                                             commonDispose: CompositeDisposable(disposables: commonDispose) )
    }
    
    
    func fecthdata(districtCode: String) -> Driver<[KTableCellSection]> {
        
        guard let loadingScreen = self.loadingScreen
            else {return .just([])}
        
        let service = GetSubDistrictApi().callServiceNoSecurity(request: BaseRequest_SubDistrict(districtId: districtCode))
        let loading = loadingScreen.observeLoading(service)
        .map({ [unowned self] respond -> [KTableCellSection] in
            return self.parser( respond)
        })
        .subscribeOn(MainScheduler.asyncInstance)
        .observeOn(MainScheduler.instance)
        .asDriver(onErrorJustReturn: [])
        return loading
        
    }
    
    func parser(_ respond:BaseResponse_SubDistrict) -> [KTableCellSection]
    {
        var sections = [KTableCellSection]()
        var cellsForSection = [KTableCellModel]()
        
        respond.subDistrictResp?.subDistrictList?.forEach({ data in
            let cell = applyCellTable(byName: "subdistriccell", cellArray: &cellsForSection)
            cell.title.accept(data.label ?? "")
            cell.content = (data.key, data.zipCode)
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

extension DeclareSelectSubdistrictViewModel {
    struct Input {
        let onLoadView: Driver<String>
        let onItem: Driver<KTableCellModel?>
    }
    
    struct Output {
        let items: Driver< [KTableCellSection] >?
        let commonDispose: CompositeDisposable
    }
}
