//
//  FilterTrigger.swift
//  FlixHqMovie
//
//  Created by DuyThai on 27/03/2023.
//

import Foundation
import RxSwift

final class CommonTrigger {
    static let shared = CommonTrigger()
    private let databaseMangager = DatabaseManager.shared
    private let disposeBag = DisposeBag()

    var filters = [CellSelectedModel?](repeating: nil, count: 5)

    let allFilterTrigger = ReplaySubject<[CellSelectedModel?]>.create(bufferSize: 1)

    var myListTrigger = ReplaySubject<Result<ResultMyList, DatabaseError>>.create(bufferSize: 1)

   private init() {
        allFilterTrigger.onNext(filters)
        configMyListTrigger()
    }

    private func configMyListTrigger() {
        databaseMangager.fetchAllInMyListEntiy().subscribe(onNext: { [unowned self] result in
            myListTrigger.onNext(result)
        })
        .disposed(by: disposeBag)
    }
}
