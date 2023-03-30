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
    func addToMyListDatabase(myListModel: MyList) -> Observable<Result<ResultMyList, DatabaseError>>
    func checkExistInMyListEntity(id: String) -> Observable<Result<Bool, DatabaseError>>
    func deleteItemInMyListEntity(mediaId: String) -> Observable<Result<ResultMyList, DatabaseError>>
    func downloadM3U8Video(url: String, name: String) -> Observable<URL>
}

struct DetailUseCase: DetailUseCaseType {
    let mediaRepository: MediaRepositoryType
    let dataBaseManager = DatabaseManager.shared
    
    func getMediaDetail(mediaId: String) -> Observable<MediaInformation> {
        return mediaRepository.getMediaDetail(mediaId: mediaId)
    }
    
    func getMovie(episodeId: String, mediaId: String) -> Observable<Movie> {
        return mediaRepository.getMovie(episodeId: episodeId, mediaId: mediaId)
    }
    
    func addToMyListDatabase(myListModel: MyList) -> Observable<Result<ResultMyList, DatabaseError>> {
        dataBaseManager.addToMyListDatabase(myList: myListModel)
    }

    func checkExistInMyListEntity(id: String) -> Observable<Result<Bool, DatabaseError>> {
        dataBaseManager.checkExistInMyListEntity(id: id)
    }

    func deleteItemInMyListEntity(mediaId: String) -> Observable<Result<ResultMyList, DatabaseError>> {
        return dataBaseManager.deleteItemInMyListEntity(mediaId: mediaId)
    }

    func downloadM3U8Video(url: String, name: String) -> Observable<URL> {
        return mediaRepository.downloadM3U8Video(url: url, name: name)
    }
}
