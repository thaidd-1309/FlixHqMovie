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
        let baseUrl = BaseUrl.main.rawValue
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
    case ibmPointLabel
    case addToMylistButton
    case playMovieButton
    case downloadMovieButton
    case ageLabel
    case nationalLabel
    case subLabel

    var cornerRadious: CGFloat {
        switch self {
        case .itemPoster:
            return 8
        case .ibmPointLabel, .ageLabel:
            return 4
        case .addToMylistButton:
            return 0
        case .playMovieButton, .downloadMovieButton:
            return 10
        case .nationalLabel, .subLabel:
            return 6
        }
    }

    var borderWidth: CGFloat {
        switch self {
        case .itemPoster:
            return 1.2
        case .ibmPointLabel, .playMovieButton, .downloadMovieButton,
                .ageLabel, .nationalLabel, .subLabel:
            return 0
        case .addToMylistButton:
            return 2

        }
    }
}

enum LayoutCell {
    case padding

    var value: CGFloat {
        switch self {
        case .padding:
            return 10
        }
    }
}
