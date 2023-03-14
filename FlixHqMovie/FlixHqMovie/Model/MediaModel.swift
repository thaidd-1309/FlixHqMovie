//
//  MediaModel.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import Foundation
import ObjectMapper

struct MediaSearch: Mappable {
    var currentPage: Int?
    var hasNextPage: Bool?
    var results: [MediaResult]?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        currentPage <- map["currentPage"]
        hasNextPage <- map["hasNextPage"]
        results <- map["results"]
    }
}

struct MediaResult: Mappable {
    var id: String?
    var title: String?
    var url: String?
    var image: String?
    var releaseDate: String?
    var duration: String?
    var type: String?
    var season: String?
    var latestEpisode: String?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        url <- map["url"]
        image <- map["image"]
        releaseDate <- map["releaseDate"]
        duration <- map["duration"]
        type <- map["type"]
        season <- map["season"]
        latestEpisode <- map["latestEpisode"]
    }
}

struct MediaInformation: Mappable {
    var id: String?
    var title: String?
    var url: String?
    var cover: String?
    var image: String?
    var description: String?
    var type: String?
    var releaseDate: String?
    var genres: [String]?
    var casts: [String]?
    var tags: [String]?
    var production: String?
    var country: String?
    var duration: String?
    var rating: Double?
    var recommendations: [Recommendation]?
    var episodes: [Episode]?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        url <- map["url"]
        cover <- map["cover"]
        image <- map["image"]
        description <- map["description"]
        type <- map["type"]
        releaseDate <- map["releaseDate"]
        genres <- map["genres"]
        casts <- map["casts"]
        tags <- map["tags"]
        production <- map["production"]
        country <- map["country"]
        duration <- map["duration"]
        rating <- map["rating"]
        recommendations <- map["recommendations"]
        episodes <- map["episodes"]
    }
}

struct TrendingMedia: Mappable {
    var results: [MediaResult]?

    init?(map: Map) {}
    mutating func mapping(map: Map) {
        results <- map["results"]
    }
}

struct Show: Mappable {
    var id: String?
    var title: String?
    var url: String?
    var image: String?
    var type: String?
    var season: String?
    var latestEpisode: String?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        url <- map["url"]
        image <- map["image"]
        type <- map["type"]
        season <- map["season"]
        latestEpisode <- map["latestEpisode"]

    }
}
