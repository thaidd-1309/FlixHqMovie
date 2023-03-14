//
//  MovieModel.swift
//  FlixHqMovie
//
//  Created by DuyThai on 13/03/2023.
//

import Foundation
import ObjectMapper

// MARK: - Movie
struct Movie: Mappable {
    var headers: MovieHeaders?
    var sources: [MovieSource]?
    var subtitles: [MovieSubtitle]?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        headers <- map["headers"]
        sources <- map["sources"]
        subtitles <- map["subtitles"]
    }
}

// MARK: - Headers
struct MovieHeaders: Mappable {
    var referer: String?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        referer <- map["Referer"]
    }
}

// MARK: - Source
struct MovieSource: Mappable {
    var url: String?
    var quality: String?
    var isM3U8: Bool?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        url <- map["url"]
        quality <- map["quality"]
        isM3U8 <- map["isM3U8"]
    }
}

// MARK: - Subtitle
struct MovieSubtitle: Mappable {
    var url: String?
    var language: String?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        url <- map["url"]
        language <- map["lang"]
    }
}

// MARK: - Episode
struct Episode: Mappable {
    var id: String?
    var title: String?
    var url: String?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        url <- map["url"]
    }
}

// MARK: - Recommendation
struct Recommendation: Mappable {
    var id: String?
    var title: String?
    var image: String?
    var duration: String?
    var type: String?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        image <- map["image"]
        duration <- map["duration"]
        type <- map["type"]
    }
}
