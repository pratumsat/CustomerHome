//
//  UIScrollView + Refresh.swift
//  Customs2Home
//
//  Created by thanawat on 12/23/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Refreshable

extension Reactive where Base: UIScrollView {
    
    public var refreshing: Binder<Bool> {
        return Binder(base) { scrollView, isShow in
            if isShow {
                scrollView.startPullToRefresh()
            } else {
                scrollView.stopPullToRefresh()
            }
        }
    }
    
    public var loadingMore: Binder<Bool> {
        return Binder(base) { scrollView, isShow in
            if isShow {
                scrollView.startLoadMore()
            } else {
                scrollView.stopLoadMore()
            }
        }
    }
    
}
