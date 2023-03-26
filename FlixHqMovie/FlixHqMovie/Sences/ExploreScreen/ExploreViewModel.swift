//
//  ExploreViewModel.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import Foundation
import RxCocoa
import RxSwift

struct ExploreViewModel {
    var coordinator: ExploreCoordinator
    var useCase: ExploreUseCaseType
}

extension ExploreViewModel: ViewModelType {
    struct Input {
        let allFilter: Driver<[FilterSectionModel]>
        var textInput: Driver<String>
        let slectedMovie: Driver<String>
    }

    struct Output {
        var medias: Driver<[MediaResult]>
        var isLoading: Driver<Bool>
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let isLoading = BehaviorRelay<Bool>(value: false)
        Defaults.initUserDefault(isIndex: true)
        Defaults.initUserDefault(isIndex: false)

        input.slectedMovie
            .drive(onNext: { idMedia in
                coordinator.toMovieDetail(with: idMedia)
            })
            .disposed(by: disposeBag)

        let output = input.textInput.flatMapLatest { text in
            isLoading.accept(true)
            return useCase.getListMediaByName(query: text)
                .asDriver(onErrorJustReturn: [])
        }
        let categoryFilters = input.allFilter
        let medias = Driver.combineLatest( output, categoryFilters
                                           , resultSelector: { output, categoryFilters -> [MediaResult] in
            isLoading.accept(true)
            let categories = categoryFilters.filter { $0.name == CategoryTitle.category.name}
                .first?.data
            let regions = categoryFilters.filter { $0.name == CategoryTitle.region.name }
                .first?.data
            let genres = categoryFilters.filter { $0.name == CategoryTitle.genre.name }
                .first?.data
            let periods = categoryFilters.filter { $0.name == CategoryTitle.periods.name }
                .first?.data
            let sortOptions = categoryFilters.filter { $0.name == CategoryTitle.sortOption.name }
                .first?.data
            let result = output.filter {
                return  checkFilter( movie: $0, categories: categories, category: .categories)

            }
                .filter {
                    return  checkFilter( movie: $0, categories: periods, category: .periods)

                }
            return result
        }).do { _ in
            isLoading.accept(false)
        }

        return Output(medias: medias, isLoading: isLoading.asDriver())
    }

    private func checkFilter(movie: MediaResult, categories: [String]?, category: FilterCategoryModel) -> Bool {
        var filterString = ""
        switch category {
        case .categories:
            filterString = movie.type ?? ""
        case .regions:
            // TODO: Update after
            filterString = ""
        case .genres:
            // TODO: Update after
            filterString = ""
        case .periods:
            filterString = movie.releaseDate ?? ""
        case . sortOptions:
            // TODO: Update after
            filterString = ""
        }
        guard let categories = categories else { return true}
        if categories.isEmpty {
            return true
        }

        return categories.contains(filterString)
    }
}
