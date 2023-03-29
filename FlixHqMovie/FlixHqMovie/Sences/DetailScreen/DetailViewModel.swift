//
//  DetailViewModel.swift
//  FlixHqMovie
//
//  Created by DuyThai on 17/03/2023.
//

import Foundation
import RxSwift
import RxCocoa

struct DetailViewModel {
    var coordinator: DetailCoordinator
    var useCase: DetailUseCaseType
    var mediaId: String
}

extension DetailViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
        let slectedMovie: Driver<String>
        let previousTimeWatch: Driver<Double>
        let addMyListTrigger: Driver<Bool>
    }

    struct Output {
        var media: Driver<Movie>
        var information: Driver<MediaInformation>
        var isLoading: Driver<Bool>
        var recommandMovie: Driver<[Recommendation]>
    }
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let addToMyListTrigger = BehaviorSubject<Bool>(value: false)
        let isLoading = BehaviorRelay<Bool>(value: false)

        let information = input.loadTrigger.flatMapLatest { _ in
            isLoading.accept(true)
            return useCase.getMediaDetail(mediaId: mediaId).asDriver(onErrorDriveWith: .empty())
        }.do {_ in
            isLoading.accept(false)
        }

        let mediaOuput = information.flatMapLatest { media -> Driver<Movie> in
            // get media high quality
            return useCase.getMovie(episodeId: media.episodes?.first?.id ?? "", mediaId: mediaId)
                .asDriver(onErrorDriveWith: .empty())
        }
        input.slectedMovie.drive(onNext: { idMedia in
            coordinator.toOtherDetailViewController(with: idMedia)
        })
            .disposed(by: disposeBag)

        let recommandMovie = information.flatMapLatest { information -> Driver<[Recommendation]> in
            return Driver.of(information.recommendations ?? [])
        }

        return Output(media: mediaOuput, information: information, isLoading: isLoading.asDriver(), recommandMovie: recommandMovie)
    }
}
