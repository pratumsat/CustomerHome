//
//  ProfileViewModel.swift
//  Customs2Home
//
//  Created by Wittawas Mukdaprasert on 3/9/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire


class ProfileViewModel:  BaseViewModel<ProfileViewModel>,ViewModelProtocol {
    typealias M = ProfileViewModel
    typealias T = ProfileViewController
    static var obj_instance: ProfileViewModel?
    
//    var loadingScreen: ScreenLoadingView? {
//        return viewControl?.view.getScreenLoading()
//    }
    
    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        var commonDispose = [Disposable]()
        let item = input.onLoadView.map( {_ in return self.cellMenu() } )
        let onItem = input.onItem.do(onNext: { indexpath in
            print(indexpath)
            guard let index = indexpath?.row else {return}
            _ = index == 0 ? self.viewControl?.onFaq() : self.viewControl?.onContact()
        })
        commonDispose.append(onItem.drive())
        
        let logout = input.logout.flatMapLatest( getLogout )
        
        return ProfileViewModel.Output(items: item,
                                       logout: logout,
                                       commonDispose: CompositeDisposable(disposables: commonDispose) )
    }
    
    
    func getLogout() -> Observable<Bool> {

        guard let loadingScreen = self.loadingScreen    else {return .just(false)}

        let service = TokenModel.instance().getLogout()
        let loading = loadingScreen.observeLoading(service)
        .map({  respond -> Bool in
            return TokenModel.instance().isLogin()
        })
        .subscribeOn(MainScheduler.asyncInstance)
        .observeOn(MainScheduler.instance)
        
        return loading

    }
//
//    func parser(_ respond:Bool) -> [KTableCellSection]
//    {
//        let sections = [KTableCellSection]()
//        return sections
//    }
    func cellMenu() -> [KTableCellSection]
    {
        var sections = [KTableCellSection]()
        var allCells = [KTableCellModel]()
        var cell = self.applyCellTable(byName: "profileCell", cellArray: &allCells)
        cell.title.accept("ถาม-ตอบ")
        cell.image.accept(UIImage(named: "icnFaq"))
        cell = self.applyCellTable(byName: "profileCell", cellArray: &allCells)
        cell.title.accept("ติดต่อเรา")
        cell.image.accept(UIImage(named: "icnContact"))
//        cell = self.applyCellTable(byName: "profileCell", cellArray: &allCells)
//        cell.title.accept("FAQ")
//        cell = self.applyCellTable(byName: "profileCell", cellArray: &allCells)
//        cell.title.accept("Contact")
//        cell = self.applyCellTable(byName: "profileCell", cellArray: &allCells)
//        cell.title.accept("ภาษา")
        let section = KTableCellSection(items: allCells)
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

extension ProfileViewModel {
    struct Input {
        let onLoadView: Driver<Void>
        let onItem: Driver<IndexPath?>
        let logout: Observable<Void>
//        let ontap: Driver<IndexPath>
    }
    
    struct Output {
        let items: Driver< [KTableCellSection] >?
        let logout: Observable<Bool>
        let commonDispose: CompositeDisposable
        
    }
}
