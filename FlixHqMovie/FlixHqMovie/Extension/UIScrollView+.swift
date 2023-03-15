//
//  UIScrollView.swift
//  FlixHqMovie
//
//  Created by DuyThai on 15/03/2023.
//

import Foundation
import UIKit

extension UIScrollView {
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let superview = superview {
            let emptyView = UIView(frame: CGRect.zero)
            superview.addSubview(emptyView)
            superview.sendSubviewToBack(emptyView)
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        if let superview = superview {
            superview.subviews.last?.frame = CGRect.zero
        }
    }
}
