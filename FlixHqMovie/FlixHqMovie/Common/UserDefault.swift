//
//  UserDefault.swift
//  FlixHqMovie
//
//  Created by DuyThai on 22/03/2023.
//

import Foundation

struct Defaults {
    static func initUserDefault(isIndex: Bool) {
        UserDefaults.standard.set([], forKey: isIndex ? CategoryTitle.category.keyForIndex : CategoryTitle.category.keyForString)
        UserDefaults.standard.set([], forKey: isIndex ? CategoryTitle.region.keyForIndex : CategoryTitle.region.keyForString)
        UserDefaults.standard.set([], forKey: isIndex ? CategoryTitle.genre.keyForIndex : CategoryTitle.genre.keyForString)
        UserDefaults.standard.set([], forKey: isIndex ? CategoryTitle.periods.keyForIndex : CategoryTitle.periods.keyForString)
        UserDefaults.standard.set([], forKey: isIndex ? CategoryTitle.sortOption.keyForIndex : CategoryTitle.sortOption.keyForString)
    }
}
