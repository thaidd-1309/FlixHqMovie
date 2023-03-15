//
//  ReuseCellType.swift
//  FlixHqMovie
//
//  Created by DuyThai on 15/03/2023.
//

import Foundation

protocol ReuseCellType: AnyObject {
    static var defaultReuseIdentifier: String { get }
    static var nibName: String { get }
}

extension ReuseCellType where Self: AnyObject {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
}
