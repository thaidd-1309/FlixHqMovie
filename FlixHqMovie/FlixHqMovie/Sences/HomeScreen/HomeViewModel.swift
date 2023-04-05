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
        let loadTrigger: BehaviorSubject<Void>
        let slectedMovie: Driver<String>
        let seeMore: Driver<TableHeaderRowType>

    }

    struct Output {
        var medias: Driver<[TableViewSectionModel]>
        var isLoading: Driver<Bool>
        let refreshDone: Driver<Bool>
        let mediaInfor: Driver<MediaInformation?>
        let connectionNetwork: Driver<Bool>
    }

    func transform(input: Input, disposeBag: RxSwift.DisposeBag) -> Output {
        let isLoading = BehaviorRelay<Bool>(value: false)
        let mediaInforTrigger = BehaviorSubject<MediaInformation?>(value: nil)
        let connectionNetworkTrigger = BehaviorSubject<Bool>(value: false)
        let refreshTableViewTrigger = BehaviorSubject<Bool>(value: true)

        input.slectedMovie.drive(onNext: { idMedia in
            coordinator.toDetailViewController(with: idMedia)
        })
        .disposed(by: disposeBag)

        input.seeMore.drive(onNext: { type in
            coordinator.toSeeMoreScreen(type: type)
        })
        .disposed(by: disposeBag)

        let mediaTrending = input.loadTrigger.asDriver(onErrorDriveWith: .empty()).flatMapLatest {  _ in
            isLoading.accept(true)
            return useCase.getListTrending().asDriver(onErrorJustReturn: [])
        }

        let recentShow = input.loadTrigger.asDriver(onErrorDriveWith: .empty()).flatMapLatest { _ in
            isLoading.accept(true)
            return useCase.getListRecentShow().asDriver(onErrorJustReturn: [])
        }

        let recentMovie = input.loadTrigger.asDriver(onErrorDriveWith: .empty()).flatMapLatest { _ in
            isLoading.accept(true)
            return useCase.getListRecentMovie().asDriver(onErrorJustReturn: [])
        }

        let output = Driver.combineLatest(mediaTrending, recentShow, recentMovie,
                                          resultSelector: { mediaTrending, recentShow, recentMovie -> [TableViewSectionModel] in
            isLoading.accept(true)
            return [
                TableViewSectionModel(nameHeaderRow: .newMovie, filmsSectionModel: recentMovie),
                TableViewSectionModel(nameHeaderRow: .trendingMovie, filmsSectionModel: mediaTrending.filter { $0.type == MediaType.movie.name }),
                TableViewSectionModel(nameHeaderRow: .newShow, filmsSectionModel: recentShow),
                TableViewSectionModel(nameHeaderRow: .trendingShow, filmsSectionModel: mediaTrending.filter { $0.type == MediaType.tvSeries.name })
            ]
        }).do { _ in
            isLoading.accept(false)
            refreshTableViewTrigger.onNext(true)
        }

        mediaTrending.drive(onNext: { media in
            useCase.getMediaDetail(mediaId: media.first?.id ?? "").subscribe(onNext: { infor in
                mediaInforTrigger.onNext(infor)
            })
            .disposed(by: disposeBag)
        })
        .disposed(by: disposeBag)

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.connectionRelay
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { connection in
                    switch connection {
                    case .unavailable:
                        connectionNetworkTrigger.onNext(false)
                    case .wifi:
                        connectionNetworkTrigger.onNext(true)
                    case .cellular:
                        connectionNetworkTrigger.onNext(true)
                    case .none:
                        connectionNetworkTrigger.onNext(false)
                    }
                })
                .disposed(by: disposeBag)
        }

        return Output(medias: output,
                      isLoading: isLoading.asDriver(),
                      refreshDone: refreshTableViewTrigger.asDriver(onErrorJustReturn: true),
                      mediaInfor: mediaInforTrigger.asDriver(onErrorDriveWith: .empty()),
                      connectionNetwork: connectionNetworkTrigger.asDriver(onErrorJustReturn: false))
    }
}
