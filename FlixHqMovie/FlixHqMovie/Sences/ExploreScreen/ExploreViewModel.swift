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
    let commonTrigger = CommonTrigger.shared
}

extension ExploreViewModel: ViewModelType {
    struct Input {
        var textInput: Driver<String>
        let slectedMovie: Driver<String>
    }

    struct Output {
        var medias: Driver<[MediaResult]>
        var isLoading: Driver<Bool>
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let isLoading = BehaviorRelay<Bool>(value: false)

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

        let medias = Driver.combineLatest( output, commonTrigger.allFilterTrigger.asDriver(onErrorJustReturn: [])
                                           , resultSelector: { output, allFilter -> [MediaResult] in
            isLoading.accept(true)
            let categories = filterCategoryCellSelectedModel(categoryType: .category, allFilter: allFilter)
            let regions = filterCategoryCellSelectedModel(categoryType: .region, allFilter: allFilter)
            let genres = filterCategoryCellSelectedModel(categoryType: .genre, allFilter: allFilter)
            let periods = filterCategoryCellSelectedModel(categoryType: .periods, allFilter: allFilter)
            let sortOptions = filterCategoryCellSelectedModel(categoryType: .sortOption, allFilter: allFilter)

            let result = output.filter {
                return checkFilter( movie: $0, categories: categories, type: .category)
            }.filter {
                return checkFilter( movie: $0, categories: periods, type: .periods)
                }
            return result
        }).do { _ in
            isLoading.accept(false)
        }

        return Output(medias: medias, isLoading: isLoading.asDriver())
    }

    private func filterCategoryCellSelectedModel(categoryType: CategoryType, allFilter: [CellSelectedModel?]) -> [String] {
        guard let cellSelectedModel = allFilter.filter { $0?.name == categoryType.name }.first else {
            return []
        }
        return cellSelectedModel?.categories ?? []

    }

    private func checkFilter(movie: MediaResult, categories: [String]?, type: CategoryType) -> Bool {
        var filterString = ""

        switch type {
        case .category:
            filterString = movie.type ?? ""
        case .region:
            filterString = ""
        case .genre:
            filterString = ""
        case .periods:
            filterString = movie.releaseDate ?? ""
        case .sortOption:
            filterString = ""
        }

        guard let categories = categories else { return true}
        if categories.isEmpty {
            return true
        }
        return categories.contains(filterString)
    }
}
