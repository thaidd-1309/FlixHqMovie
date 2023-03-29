//
//  SectionModel.swift
//  FlixHqMovie
//
//  Created by DuyThai on 15/03/2023.
//

import Foundation

struct TableViewSectionModel {
    let nameHeaderRow: String
    let filmsSectionModel: [MediaResult]
}

struct CollectionViewSectionModel {
    let ibmPoint: String
    let image: String
}

struct FilterSectionModel {
    let name: String
    var categories: [String]
}

struct CellSelectedModel {
    let name: String
    let indexs: [Int]
    let categories: [String]
}
