//
//  SeeMoreViewModel.swift
//  FlixHqMovie
//
//  Created by DuyThai on 03/04/2023.
//

import Foundation
import RxCocoa
import RxSwift

struct SeeMoreViewModel {
    var coordinator: SeeMoreCoordinator
    var useCase: HomeUseCaseType
    var seeMoreType: TableHeaderRowType
}

extension SeeMoreViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let slectedMovie: Driver<String>
    }

    struct Output {
        var medias: Driver<[MediaResult]>
        var isLoading: Driver<Bool>
        let title: Driver<String>
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let isLoading = BehaviorRelay<Bool>(value: false)
        let titleTrigger = BehaviorSubject<String>(value: seeMoreType.name)
        
        input.slectedMovie.drive(onNext: { idMedia in
            coordinator.toMovieDetail(with: idMedia)
        })
        .disposed(by: disposeBag)

        let mediaTrending = input.loadTrigger.flatMapLatest {  _ in
            isLoading.accept(true)
            return useCase.getListTrending().asDriver(onErrorJustReturn: [])
        }
        let recentShow = input.loadTrigger.flatMapLatest { _ in
            isLoading.accept(true)
            return useCase.getListRecentShow().asDriver(onErrorJustReturn: [])
        }
        let recentMovie = input.loadTrigger.flatMapLatest { _ in
            isLoading.accept(true)
            return useCase.getListRecentMovie().asDriver(onErrorJustReturn: [])
        }

        let output = Driver.combineLatest(mediaTrending, recentShow, recentMovie,
                                          resultSelector: { mediaTrending, recentShow, recentMovie -> [MediaResult] in
            isLoading.accept(true)
            switch seeMoreType {
            case .newMovie:
                return recentMovie
            case .newShow:
                return recentShow
            case .trendingMovie:
                return mediaTrending.filter { $0.type == MediaType.movie.name }
            case .trendingShow:
                return mediaTrending.filter { $0.type == MediaType.tvSeries.name }
            }
            return []
        }).do { _ in
            isLoading.accept(false)
        }

        return Output(medias: output, isLoading: isLoading.asDriver(onErrorJustReturn: true), title: titleTrigger.asDriver(onErrorJustReturn: ""))
    }
}
