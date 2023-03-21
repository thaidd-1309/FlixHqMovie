//
//  ExploreUseCase.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import Foundation
import RxSwift

protocol ExploreUseCaseType {
    func getListMediaByName(query: String) -> Observable<[MediaResult]>
}

struct ExploreUseCase: ExploreUseCaseType {
    let mediaRepository: MediaRepositoryType

    func getListMediaByName(query: String) -> Observable<[MediaResult]> {
        return mediaRepository.getListMediaByName(query: query)
    }
}
