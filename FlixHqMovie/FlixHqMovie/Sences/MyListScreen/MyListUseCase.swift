//
//  MyListUseCase.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import Foundation
import RxSwift

protocol MyListUseCaseType {
    func fetchAllInMyListEntiy() -> Observable<Result<[MyListModel], DatabaseError>>
}

struct MyListUseCase: MyListUseCaseType {
    let mediaRepository: MediaRepositoryType
    let dataBaseManager = DatabaseManager.share

    func fetchAllInMyListEntiy() -> Observable<Result<[MyListModel], DatabaseError>> {
        return dataBaseManager.fetchAllInMyListEntiy()
    }
}
