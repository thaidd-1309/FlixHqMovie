//
//  FilterViewModel.swift
//  FlixHqMovie
//
//  Created by DuyThai on 21/03/2023.
//

import Foundation
import RxSwift
import RxCocoa

struct FilterViewModel {
    var coordinator: FilterCoordinator
}

extension FilterViewModel: ViewModelType {
    struct Input {
        var categoriesTrigger: Driver<[String]>
        var regionsTrigger: Driver<[String]>
        var generesTrigger: Driver<[String]>
        var periodsTrigger: Driver<[String]>
        var sortOptionsTriger: Driver<[String]>
    }
    
    struct Output {
        var categoriesIsSelected: Driver<[FilterSectionModel]>
    }
    
    func transform(input: Input, disposeBag: RxSwift.DisposeBag) -> Output {
        let ouput = Driver.combineLatest(
            input.categoriesTrigger,
            input.regionsTrigger,
            input.generesTrigger,
            input.periodsTrigger,
            input.sortOptionsTriger,
            resultSelector: { categories, regions, genres, periods, sortOptions -> [FilterSectionModel] in
                return [
                    FilterSectionModel(name: CategoryTitle.category.name, data: categories),
                    FilterSectionModel(name: CategoryTitle.region.name, data: regions),
                    FilterSectionModel(name: CategoryTitle.genre.name, data: genres),
                    FilterSectionModel(name: CategoryTitle.periods.name, data: periods),
                    FilterSectionModel(name: CategoryTitle.sortOption.name, data: sortOptions)
                ]
            }
        ).asDriver(onErrorJustReturn: [])
        
        return Output(categoriesIsSelected: ouput)
    }
    
    func saveToUserDefault<T>(disposeBag: DisposeBag,
                              categoriesTrigger: Driver<[T]>,
                              regionsTrigger: Driver<[T]>,
                              genresTrigger: Driver<[T]>,
                              periodsTrigger: Driver<[T]>,
                              sortOptionsTrigger: Driver<[T]>, isIndex: Bool) {
        setValueUserDefault(key: .category, trait: categoriesTrigger, isIndex: isIndex, disposeBag: disposeBag)
        setValueUserDefault(key: .region, trait: regionsTrigger, isIndex: isIndex, disposeBag: disposeBag)
        setValueUserDefault(key: .genre, trait: genresTrigger, isIndex: isIndex, disposeBag: disposeBag)
        setValueUserDefault(key: .periods, trait: periodsTrigger, isIndex: isIndex, disposeBag: disposeBag)
        setValueUserDefault(key: .sortOption, trait: sortOptionsTrigger, isIndex: isIndex, disposeBag: disposeBag)
    }
    
    private func setValueUserDefault<T>(key: CategoryTitle, trait: Driver<[T]>, isIndex: Bool, disposeBag: DisposeBag) {
        trait.drive(onNext: { value in
            UserDefaults.standard.set(value, forKey: isIndex ? key.keyForIndex : key.keyForString)
        })
        .disposed(by: disposeBag)
    }
}
