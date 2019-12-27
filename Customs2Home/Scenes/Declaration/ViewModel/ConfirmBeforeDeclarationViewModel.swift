//
//  ConfirmBeforeDeclarationViewModel.swift
//  Customs2Home
//
//  Created by warodom on 14/11/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire


class ConfirmBeforeDeclarationViewModel: BaseViewModel<ConfirmBeforeDeclarationViewModel>,ViewModelProtocol {

    typealias M = ConfirmBeforeDeclarationViewModel
    typealias T = ConfirmBeforeDeclarationViewController
    static var obj_instance: ConfirmBeforeDeclarationViewModel?
    
//    var loadingScreen: ScreenLoadingView? {
//        return viewControl?.view.getScreenLoading()
//    }

    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let commonDispose = [Disposable]()
        let item = input.onLoadView.flatMapLatest( fecthdata )
        return ConfirmBeforeDeclarationViewModel.Output(items: item,
                                             commonDispose: CompositeDisposable(disposables: commonDispose) )
    }
    
    
    func fecthdata() -> Driver<[KTableCellSection]> {
        
        guard let loadingScreen = self.loadingScreen  else {return .just([])}
        
        let service = Observable.just(viewControl?.declareAddEditReq)
        let loading = loadingScreen.observeLoading(service)
        .map({ [unowned self] respond -> [KTableCellSection] in
            return self.parser(respond)
        })
        .subscribeOn(MainScheduler.asyncInstance)
        .observeOn(MainScheduler.instance)
        .asDriver(onErrorJustReturn: [])
        return loading
        
    }
    
    func parser(_ respond:DeclareAddEditReq?) -> [KTableCellSection] {
        guard let respond = respond else { return [] }
        var sections = [KTableCellSection]()
        var cellsForSection = [KTableCellModel]()
        
        let cell = applyCellTable(byName: "beforedeclarationcell", cellArray: &cellsForSection)
        
        var name = ""
        respond.tariffList?.enumerated().forEach({ (offset,model) in
            if offset != 0 {
                name += ", \(model.tariffName ?? "")"
            }else{
                name += "\(model.tariffName ?? "")"
            }
        })
        cell.title.accept("สินค้า: \(name)")
        
        let attributedString = NSMutableAttributedString(string: "THB \(respond.totalTaxDisplay?.delimiter ?? "0" )  ", attributes: [
            .font: UIFont.mainFontSemiBold(ofSize: 24),
            .foregroundColor: UIColor(red: 87.0 / 255.0, green: 166.0 / 255.0, blue: 0.0, alpha: 1.0)
            ])
        attributedString.addAttribute(.font, value: UIFont.mainFontRegular(ofSize: 12), range: NSRange(location: 0, length: 3))
        
        cell.attributedDetail.accept(attributedString)
        cell.content = data
        
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

extension ConfirmBeforeDeclarationViewModel {
    struct Input {
        let onLoadView: Driver<Void>
        let onItem: Driver<KTableCellModel?>
    }
    
    struct Output {
        let items: Driver< [KTableCellSection] >?
        let commonDispose: CompositeDisposable
    }
}
