//
//  Filters.swift
//  FlixHqMovie
//
//  Created by DuyThai on 26/03/2023.
//

import Foundation
import RxSwift

enum CategoryType {
    case category
    case region
    case genre
    case periods
    case sortOption

    var name: String {
        switch self {
        case .category:
            return "Categories"
        case .region:
            return "Regions"
        case .genre:
            return "Genres"
        case .periods:
            return "Time/Periods"
        case .sortOption:
            return "Sorts"
        }
    }

    var keyForIndex: String {
        switch self {
        case .category:
            return "indexCategoriesTrigger"
        case .region:
            return "indexRegionsTrigger"
        case .genre:
            return "indexGenresTrigger"
        case .periods:
            return "indexPeriodsTrigger"
        case .sortOption:
            return "indexSortOptionsTrigger"
        }
    }

    var keyForString: String {
        switch self {
        case .category:
            return "stringCategoriesTrigger"
        case .region:
            return "stringRegionsTrigger"
        case .genre:
            return "stringGenresTrigger"
        case .periods:
            return "stringPeriodsTrigger"
        case .sortOption:
            return "stringSortOptionsTrigger"
        }
    }

    var categories: [String] {
        switch self {
        case .category:
            return ["Movie", "TV Series", "K-Drama", "Anime", "Wars"]
        case .region:
            return  ["All Regions", "US", "Korean", "Viet nam", "China"]
        case .genre:
            return ["Action", "Comedy", "Romance", "Thriller", "Documentary"]
        case .periods:
            return ["All periods", "2023", "2022", "2021", "2020", "2019", "2016", "2015", "2014"]
        case .sortOption:
            return ["Popularity", "Lastest Release", "A->Z", "Z->A"]
        }
    }

    var index: Int {
        switch self {
        case .category:
            return 0
        case .region:
            return 1
        case .genre:
            return 2
        case .periods:
            return 3
        case .sortOption:
            return 4
        }
    }
}

enum CategoryTriggerType {
    case category(cellSelected: CellSelectedModel, type: CategoryType)
    case region(cellSelected: CellSelectedModel, type: CategoryType)
    case genre(cellSelected: CellSelectedModel, type: CategoryType)
    case periods(cellSelected: CellSelectedModel, type: CategoryType)
    case sortOption(cellSelected: CellSelectedModel, type: CategoryType)

    var cellSelectedModel: [CellSelectedModel?] {
        let shareTrigger = CommonTrigger.shared
        switch self {
        case .category(let cellSelected, let type):
            shareTrigger.filters[type.index] = cellSelected
        case .region(let cellSelected, let type):
            shareTrigger.filters[type.index] = cellSelected
        case .genre(let cellSelected, let type):
            shareTrigger.filters[type.index] = cellSelected
        case .periods(let cellSelected, let type):
            shareTrigger.filters[type.index] = cellSelected
        case .sortOption(let cellSelected, let type):
            shareTrigger.filters[type.index] = cellSelected
        }
        return shareTrigger.filters
    }
}
