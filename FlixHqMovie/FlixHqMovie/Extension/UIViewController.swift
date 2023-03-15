//
//  UIViewController.swift
//  FlixHqMovie
//
//  Created by DuyThai on 15/03/2023.
//

import Foundation
import UIKit

extension UIViewController {
    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}
