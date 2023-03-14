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
