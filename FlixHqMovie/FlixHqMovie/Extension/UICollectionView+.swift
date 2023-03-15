//
//  UICollectionView+.swift
//  FlixHqMovie
//
//  Created by DuyThai on 15/03/2023.
//

import Foundation
import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(nibName name: T.Type,
                                           atBundle bundleClass: AnyClass? = nil)where T: ReuseCellType {
        let identifier = T.defaultReuseIdentifier
        let nibName = T.nibName
        var bundle: Bundle?
        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }
        register(UINib(nibName: nibName, bundle: bundle), forCellWithReuseIdentifier: identifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T? where T: ReuseCellType {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            return nil
        }
        return cell
    }
}
