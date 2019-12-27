//
//  TutorialViewController.swift
//  Customs2Home
//
//  Created by warodom on 9/9/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState

class TutorialViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    
    var array = [UIImage]()
    var timer = Timer()
    var couter = 0
    
    override func viewDidLoad() {
        bind()
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
        
    }
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = TutorialViewModel.instance()
        viewModel.viewControl = self
        let onload = Driver.just(())

//        let onItem = tableView.rx.itemSelected.map({ [unowned self] path -> KTableCellModel? in
//            try?self.tableView.rx.model(at: path)
//        }).asDriver(onErrorJustReturn: nil)
        let input = TutorialViewModel.Input( onLoadView: onload
//            ,onItem: onItem
        )
        
        let output = viewModel.transform(input: input)
//        output.items?.drive( self.tableView.rx.items(dataSource: dataSource) ).disposed(by: disposeBag )
        output.commonDispose.disposed(by: disposeBag)
        
        for _ in 0...3 {
            array.append(UIImage(named: "us_flag")!)
        }
        pageControl.numberOfPages = array.count
    }
    
    let dataSource = RxTableViewSectionedReloadDataSource<KTableCellSection>(
        configureCell: { ( _, tableView, indexPath, cellModel) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.cellIden) as? KTableViewCell else { fatalError("Set wrong cell Iden or Wrong class") }
            cell.bind(cellData: cellModel)
            return cell
    })
//    var collectionDataSource:RxCollectionViewSectionedReloadDataSource<CollectionSection> {
//        let datasource = RxCollectionViewSectionedReloadDataSource<CollectionSection> (configureCell: { (_, collectionView, indexPath, cellData) -> UICollectionViewCell in
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as! RetailerCell
//            cell.bind(cellData: cellData)
//            return cell
//        })
//        return datasource
//    }
    
    @objc func changeImage() {
        guard couter < array.count else {
            couter = 0
            let index = IndexPath(item: couter, section: 0)
            collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            return
        }
        let index = IndexPath(item: couter, section: 0)
        collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        couter += 1
    }
}

extension TutorialViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellslide", for: indexPath) as! TutorialCollectionViewCell
        cell.textDetail.text = "hello world \(indexPath.row)"
        cell.imageView.image = array[indexPath.row]
//        pageControl.currentPage = Int((self.collectionView.contentOffset.x + (collectionView.width/2)) / collectionView.width)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width , height: size.height)
    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//         return 0.0
//    }
//
    
    
    
    

    
}
