//
//  FilterTrigger.swift
//  FlixHqMovie
//
//  Created by DuyThai on 27/03/2023.
//

import Foundation
import RxSwift

class FilterTrigger {
    static let share = FilterTrigger()
    let categoriesTrigger =  PublishSubject<CellSelectedModel>()
    let regionsTrigger = PublishSubject<CellSelectedModel>()
    let generesTrigger = PublishSubject<CellSelectedModel>()
    let periodsTrigger = PublishSubject<CellSelectedModel>()
    let sortOptionsTriger = PublishSubject<CellSelectedModel>()

    let allFilterTrigger = ReplaySubject<[CellSelectedModel]>.create(bufferSize: 1)
}
