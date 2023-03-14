//
//  MediaRepository.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import Foundation
import RxSwift

protocol MediaRepositoryType {
    func getListMediaByName(query: String) -> Observable<[MediaResult]>
    func getListTrending() -> Observable<[MediaResult]>
    func getListRecentShow() -> Observable<[MediaResult]>
    func getListRecentMovie() -> Observable<[MediaResult]>
    func getMediaDetail(mediaId: String) -> Observable<MediaInformation>
    func getMovie(episodeId: String, mediaId: String) -> Observable<Movie>
}

struct MediaRepository: MediaRepositoryType {

    static let shared = MediaRepository()

    func getMovie(episodeId: String, mediaId: String) -> Observable<Movie> {
        return APIService.shared.request(endPoint: .getMovie(episodeId: episodeId, mediaId: mediaId))
    }

    func getListMediaByName(query: String) -> Observable<[MediaResult]> {
        let request: Observable<MediaSearch> = APIService.shared.request(endPoint: .getListMediaByName(query: query))
        return request.map{ $0.results ?? [] }
    }

    func getListTrending() -> Observable<[MediaResult]> {
        let request: Observable<TrendingMedia> = APIService.shared.request(endPoint: .getListTrending)
        return request.map{ $0.results ?? [] }
    }

    func getListRecentShow() -> Observable<[MediaResult]> {
        return APIService.shared.requestArray(endPoint: .getListRecentShow)
    }

    func getListRecentMovie() -> Observable<[MediaResult]> {
        return APIService.shared.requestArray(endPoint: .getListRecentMovie)
    }

    func getMediaDetail(mediaId: String) -> Observable<MediaInformation> {
        return APIService.shared.request(endPoint: .getMediaDetail(mediaId: mediaId))
    }

}
