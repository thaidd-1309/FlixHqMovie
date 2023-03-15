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

//TODO: Fake model, will update in task/60489
struct FakeSectionModel {
    let nameHeaderRow: String
    let filmsSectionModel: [Int]
}
