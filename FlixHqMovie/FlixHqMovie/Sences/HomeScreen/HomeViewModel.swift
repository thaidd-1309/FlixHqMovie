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
        let refreshTableView: Driver<Bool>
        let seeMore: Driver<TableHeaderRowType>

    }

    struct Output {
        var medias: Driver<[TableViewSectionModel]>
        var isLoading: Driver<Bool>
        let refreshDone: Driver<Bool>
        let mediaInfor: Driver<MediaInformation?>
    }

    func transform(input: Input, disposeBag: RxSwift.DisposeBag) -> Output {
        let isLoading = BehaviorRelay<Bool>(value: false)
        let refreshDoneTrigger = BehaviorSubject<Bool>(value: false)
        let mediaInforTrigger = BehaviorSubject<MediaInformation?>(value: nil)

        input.slectedMovie.drive(onNext: { idMedia in
            coordinator.toDetailViewController(with: idMedia)
        })
        .disposed(by: disposeBag)

        input.seeMore.drive(onNext: { type in
            coordinator.toSeeMoreScreen(type: type)
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

        let output = Driver.combineLatest(mediaTrending, recentShow, recentMovie, input.refreshTableView,
                                          resultSelector: { mediaTrending, recentShow, recentMovie, isRefresh -> [TableViewSectionModel] in
            if isRefresh {
                isLoading.accept(false)
                refreshDoneTrigger.onNext(true)
            }
            else {
                isLoading.accept(true)
            }

            return [
                TableViewSectionModel(nameHeaderRow: .newMovie, filmsSectionModel: recentMovie),
                TableViewSectionModel(nameHeaderRow: .trendingMovie, filmsSectionModel: mediaTrending.filter { $0.type == MediaType.movie.name }),
                TableViewSectionModel(nameHeaderRow: .newShow, filmsSectionModel: recentShow),
                TableViewSectionModel(nameHeaderRow: .trendingShow, filmsSectionModel: mediaTrending.filter { $0.type == MediaType.tvSeries.name })
            ]
        }).do { _ in
            isLoading.accept(false)
        }

        mediaTrending.drive(onNext: { media in
            useCase.getMediaDetail(mediaId: media.first?.id ?? "").subscribe(onNext: { infor in
                mediaInforTrigger.onNext(infor)
            })
            .disposed(by: disposeBag)
        })
        .disposed(by: disposeBag)

        return Output(medias: output,
                      isLoading: isLoading.asDriver(),
                      refreshDone: refreshDoneTrigger.asDriver(onErrorJustReturn: false),
                      mediaInfor: mediaInforTrigger.asDriver(onErrorDriveWith: .empty()))
    }
}
