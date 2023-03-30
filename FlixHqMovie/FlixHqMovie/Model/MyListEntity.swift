//
//  MyListEntity.swift
//  FlixHqMovie
//
//  Created by DuyThai on 27/03/2023.
//

import Foundation

struct MyList {
    let id: String
    let image: String
    let genres: [String]
    let timeRecentWatch: Double
}

struct ResultMyList {
    let myList: [MyList]
    let genres: [String]
}
