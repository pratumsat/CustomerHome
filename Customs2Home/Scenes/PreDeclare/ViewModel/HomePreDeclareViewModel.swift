//
import RxAlamofire
import RxCocoa
import RxSwift
import RealmSwift
//  HomePreDeclareViewModel.swift
//  Customs2Home
//
//  Created by warodom on 27/9/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit

class HomePreDeclareViewModel: BaseViewModel<HomePreDeclareViewModel>, ViewModelProtocol {
    typealias M = HomePreDeclareViewModel
    typealias T = HomePreDeclareViewController
    static var obj_instance: HomePreDeclareViewModel?

//    var loadingScreen: ScreenLoadingView? {
//        return viewControl?.view.getScreenLoading()
//    }
    var cellModels: [KTableCellModel]?
    
    var showTaxDetail:PublishRelay<CalTaxResp?> = PublishRelay<CalTaxResp?>()
    
    var onReloadItem = BehaviorRelay<[KTableCellSection]>(value: [])
    
    override init() {
        super.init()
    }

    
    func transform(input: Input) -> Output {
        var commonDispose = [Disposable]()
        //let item = input.onLoadView.flatMapLatest(fecthdata)
        
        let onLoad = input.onLoadView.flatMapLatest(fecthdata)
        
        let onShowTax = input.onShowTax.do(onNext: {[unowned self]  (indexPath) in
            print(indexPath)
            if let model:KTableCellModel = try? self.viewControl!.tableView.rx.model(at: indexPath) {
                self.showTaxDetail.accept(model.content as? CalTaxResp)
            }
        })
        commonDispose.append(onShowTax.drive())
        
        
        let onDelete = input.onDelete.filter({ (indexPaths) -> Bool in
            
            indexPaths != nil && self.cellModels != nil
        })
            .map { [unowned self] (models) -> [KTableCellSection] in
                
                if let models = models,
                    let cellModels = self.cellModels {
                    let array = cellModels.filter({ searchModel in
                        let result = models.firstIndex(of: searchModel)
                        if result != nil {
                            ConfigRealm().deleteByCalTaxResp(models[result!].content as! CalTaxResp)
                        }
                       
                       return result == nil
                    })
                    
                    let section = KTableCellSection(identity: 0, items: array)
                    
                    return !array.isEmpty ? [section] : []
                }
                return []
        }

        
        let items = Driver.merge(onLoad, onDelete , onReloadItem.asDriver())
            .do(onNext: { [unowned self] section in
                self.cellModels = section.first?.items
            })
        
        return HomePreDeclareViewModel.Output(items: items,
                                              commonDispose: CompositeDisposable(disposables: commonDispose))
    }

    func fecthdata() -> Driver<[KTableCellSection]> {
        guard let loadingScreen = self.loadingScreen
        else {
            return .just([])
            
        }

        let service = Observable.just(ConfigRealm().getCalTaxResp())
        let loading = loadingScreen.observeLoading(service)
            .map({ [unowned self] respond -> [KTableCellSection] in
                guard let respond = respond, !respond.isEmpty else { return []  }
                return self.parser(respond)
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
        return loading
    }

    func parser(_ respond:Results<CalTaxResp>?) -> [KTableCellSection] {
        var sections = [KTableCellSection]()
        var cellModels = [KTableCellModel]()

    
        respond?.forEach({ (data) in
            let cell = applyCellTable(byName: "predeclarecell", cellArray: &cellModels)
            var name = ""
            data.preDeclare.enumerated().forEach({ (offset,model) in
                if offset != 0 {
                    name += ", \(model.tariffName ?? "")"
                }else{
                    name += "\(model.tariffName ?? "")"
                }
            })
            cell.title.accept("สินค้า: \(name)")

            if data.flagCurrencyCurrent == "Y" {
                cell.image.accept(nil)
            }else{
                cell.image.accept(UIImage(named: "icAlert"))
            }

            let attributedString = NSMutableAttributedString(string: "THB \(data.totalTaxDisplay.delimiter )  ", attributes: [
                .font: UIFont.mainFontSemiBold(ofSize: 24),
                .foregroundColor: UIColor(red: 87.0 / 255.0, green: 166.0 / 255.0, blue: 0.0, alpha: 1.0)
                ])
            attributedString.addAttribute(.font, value: UIFont.mainFontRegular(ofSize: 12), range: NSRange(location: 0, length: 3))

            cell.attributedDetail.accept(attributedString)
            cell.content = data
        })
        
       
        
        

        let section = KTableCellSection(items: cellModels)
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

extension HomePreDeclareViewModel {
    struct Input {
        let onLoadView: Driver<Void>
        let onItem: Driver<KTableCellModel?>
        let onDelete: Driver<[KTableCellModel]?>
        let onShowTax: Driver<IndexPath>
    }

    struct Output {
        let items: Driver<[KTableCellSection]>?
        let commonDispose: CompositeDisposable
    }
}
