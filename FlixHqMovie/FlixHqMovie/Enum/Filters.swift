//
//  Filters.swift
//  FlixHqMovie
//
//  Created by DuyThai on 26/03/2023.
//

import Foundation

enum CategoryTitle {
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
            return "Sort"
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
}

enum FilterCategoryModel {
    case categories
    case regions
    case genres
    case periods
    case sortOptions

    var value: FilterSectionModel {
        switch self {
        case .categories:
            return FilterSectionModel(
                name: "Categories",
                data: ["Movie", "TV Series", "K-Drama", "Anime", "Wars"])
        case .regions:
            return FilterSectionModel(
                name: "Regions",
                data: ["All Regions", "US", "Korean", "Viet nam", "China"])
        case .genres:
            return FilterSectionModel(
                name: "Genres",
                data: ["Action", "Comedy", "Romance", "Thriller", "Documentary"])
        case .periods:
            return FilterSectionModel(
                name: "Time/Periods",
                data: ["All periods", "2023", "2022", "2021", "2020", "2019"])
        case .sortOptions:
            return FilterSectionModel(
                name: "Sorts",
                data: ["Popularity", "Lastest Release", "A->Z", "Z->A"])
        }
    }
}
