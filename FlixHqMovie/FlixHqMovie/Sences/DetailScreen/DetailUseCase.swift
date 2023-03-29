//
//  DetailUseCase.swift
//  FlixHqMovie
//
//  Created by DuyThai on 17/03/2023.
//

import Foundation
import RxSwift

protocol DetailUseCaseType {
    func getMediaDetail(mediaId: String) -> Observable<MediaInformation>
    func getMovie(episodeId: String, mediaId: String) -> Observable<Movie>
}

struct DetailUseCase: DetailUseCaseType {
    let mediaRepository: MediaRepositoryType

    func getMediaDetail(mediaId: String) -> Observable<MediaInformation> {
        return mediaRepository.getMediaDetail(mediaId: mediaId)
    }
    
    func getMovie(episodeId: String, mediaId: String) -> Observable<Movie> {
        return mediaRepository.getMovie(episodeId: episodeId, mediaId: mediaId)
    }
}
