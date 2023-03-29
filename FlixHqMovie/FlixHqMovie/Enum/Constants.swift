//
//  Constants.swift
//  FlixHqMovie
//
//  Created by DuyThai on 13/03/2023.
//

import Foundation

enum BaseUrl: String {
    case main = "https://api.consumet.org/movies/flixhq/"
    case viewAsia = "https://api.consumet.org/movies/viewasian/"
    case local = "http://0.0.0.0:3000/movies/flixhq/"
    case deploy = "https://astra-cinema.herokuapp.com/movies/flixhq/"
}

enum EndPoint {
    case getMovie(episodeId: String, mediaId: String)
    case getListMediaByName(query: String)
    case getListTrending
    case getListRecentShow
    case getListRecentMovie
    case getMediaDetail(mediaId: String)
    
    var url: String {
        let baseUrl = BaseUrl.deploy.rawValue
        switch self {
        case .getMovie(episodeId: let episodeId, mediaId: let mediaId):
            return "\(baseUrl)watch?episodeId=\(episodeId)&mediaId=\(mediaId)"
        case .getListMediaByName(query: let query):
            return "\(baseUrl)\(query)"
        case .getListTrending:
            return "\(baseUrl)trending"
        case .getListRecentShow:
            return "\(baseUrl)recent-shows"
        case .getListRecentMovie:
            return "\(baseUrl)recent-movies"
        case .getMediaDetail(mediaId: let mediaId):
            return "\(baseUrl)info?id=\(mediaId)"
        }
    }
}

enum LayoutOptions {
    case itemPoster
    case addToMylistButton
    case tagLabel
    case filterCell
    case buttonInFilterScreen
    case filterButtton
    case containerView
    
    var cornerRadious: CGFloat {
        switch self {
        case .itemPoster:
            return 8
        case .tagLabel:
            return 4
        case .addToMylistButton, .filterCell:
            return 0
        case  .filterButtton:
            return 10
        case .buttonInFilterScreen:
            return 12
        case .containerView:
            return 16
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .itemPoster:
            return 1.2
        case  .filterButtton, .tagLabel, .buttonInFilterScreen:
            return 0
        case .addToMylistButton:
            return 2
        case .filterCell, .containerView:
            return 2
        }
    }
}

enum LayoutCell {
    case paddingWidth
    case paddingHeight
    case heightRatio
    var value: CGFloat {
        switch self {
        case .paddingWidth:
            return 10
        case.paddingHeight:
            return 4
        case.heightRatio:
            return 1.8
        }
    }
}

enum MediaType {
    case movie
    case tvSeries
    
    var name: String {
        switch self {
        case .movie:
            return "Movie"
        case .tvSeries:
            return "TV Series"
        }
    }
}

enum NameTableHeaderRow {
    case newMovie
    case newShow
    case trendingMovie
    case trendingShow
    
    var name: String {
        switch self {
        case .newMovie:
            return "New movies"
        case .newShow:
            return "New shows"
        case .trendingMovie:
            return "Trending movies"
        case .trendingShow:
            return "Trending shows"
        }
    }
}

enum SearchNotice {
    case startLabel
    case startNotice
    case notFoundLabel
    case notFoundNotice
    
    var text: String {
        switch self {
        case .startLabel:
            return "Let search"
        case .startNotice:
            return "Find your movie or show you like"
        case .notFoundLabel:
            return "Not found"
        case .notFoundNotice:
            return "Sorry, the keyword you entered could not be found. Try to check again or search with other keywords."
        }
    }
}

enum CustomImageName {
    case noResult
    case search
    case emptyList

    var name: String {
        switch self {
        case .noResult:
            return "no-results"
        case .search:
            return "search"
        case .emptyList:
            return "emptyList"
        }
    }
}
