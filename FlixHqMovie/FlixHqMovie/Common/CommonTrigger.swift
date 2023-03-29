//
//  FilterTrigger.swift
//  FlixHqMovie
//
//  Created by DuyThai on 27/03/2023.
//

import Foundation
import RxSwift

class CommonTrigger {
    static let share = CommonTrigger()

    var filters = [CellSelectedModel?](repeating: nil, count: 5)

    let allFilterTrigger = ReplaySubject<[CellSelectedModel?]>.create(bufferSize: 1)
    init() {
        allFilterTrigger.onNext(filters)
    }
}
