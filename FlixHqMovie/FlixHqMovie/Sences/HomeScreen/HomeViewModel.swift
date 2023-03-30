//
//  HomeViewModel.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import Foundation
import RxSwift
import RxCocoa

struct HomeViewModel {
    let coordinator: HomeCoordinator
    let useCase: HomeUseCaseType
}

extension HomeViewModel: ViewModelType {

    struct Input {
        let loadTrigger: Driver<Void>
        let slectedMovie: Driver<String>
    }

    struct Output {
        var medias: Driver<[TableViewSectionModel]>
        var isLoading: Driver<Bool>
    }

    func transform(input: Input, disposeBag: RxSwift.DisposeBag) -> Output {
        let isLoading = BehaviorRelay<Bool>(value: false)

        input.slectedMovie.drive(onNext: { idMedia in
            coordinator.toDetailViewController(with: idMedia)
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
                                          resultSelector: { mediaTrending, recentShow, recentMovie -> [TableViewSectionModel] in
            isLoading.accept(true)
            return [
                TableViewSectionModel(nameHeaderRow: NameTableHeaderRow.newMovie.name, filmsSectionModel: recentMovie),
                TableViewSectionModel(nameHeaderRow: NameTableHeaderRow.trendingMovie.name, filmsSectionModel: mediaTrending.filter { $0.type == MediaType.movie.name }),
                TableViewSectionModel(nameHeaderRow: NameTableHeaderRow.newShow.name, filmsSectionModel: recentShow),
                TableViewSectionModel(nameHeaderRow: NameTableHeaderRow.trendingShow.name, filmsSectionModel: mediaTrending.filter { $0.type == MediaType.tvSeries.name })
            ]
        }).do { _ in
            isLoading.accept(false)
        }
        return Output(medias: output, isLoading: isLoading.asDriver())
    }
}
