//
//  HomeUseCase.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import Foundation
import RxSwift

protocol HomeUseCaseType {
    func getListTrending() -> Observable<[MediaResult]>
    func getListRecentShow() -> Observable<[MediaResult]>
    func getListRecentMovie() -> Observable<[MediaResult]>
    func getMediaDetail(mediaId: String) -> Observable<MediaInformation>
}

struct HomeUseCase: HomeUseCaseType {
    let mediaRepository: MediaRepositoryType

    func getListTrending() -> Observable<[MediaResult]> {
        return mediaRepository.getListTrending()
    }

    func getListRecentShow() -> Observable<[MediaResult]> {
        return mediaRepository.getListRecentShow()
    }

    func getListRecentMovie() -> Observable<[MediaResult]> {
        return mediaRepository.getListRecentMovie()
    }

    func getMediaDetail(mediaId: String) -> Observable<MediaInformation> {
        return mediaRepository.getMediaDetail(mediaId: mediaId)
    }
}
