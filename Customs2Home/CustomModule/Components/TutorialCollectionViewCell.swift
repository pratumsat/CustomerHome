//
//  TutorialCollectionViewCell.swift
//  Customs2Home
//
//  Created by warodom on 9/9/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TutorialCollectionViewCell: UICollectionViewCell {
    var disposeBag:DisposeBag?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textDetail: UILabel!
    
    
//    func bind( cellData:RetailerCellModule ) {
//        disposeBag = DisposeBag()
//        if titleLabel != nil {
//            cellData.title.bind(to: titleLabel!.rx.text).disposed(by: disposeBag!)
//        }
//        if imageView != nil {
//            cellData.image.bind(to: imageView!.rx.image).disposed(by: disposeBag!)
//        }
//
//    }
    
}
