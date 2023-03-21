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
        var textInput: Driver<String>
        let slectedMovie: Driver<String>
    }

    struct Output {
        var medias: Driver<[MediaResult]>
        var isLoading: Driver<Bool>
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let isLoading = BehaviorRelay<Bool>(value: false)

        let selectedMovieId = input.slectedMovie
            .drive(onNext: { idMedia in
                coordinator.toMovieDetail(with: idMedia)
            })
            .disposed(by: disposeBag)

        let output = input.textInput.flatMapLatest { text in
            isLoading.accept(true)
            return useCase.getListMediaByName(query: text)
                .asDriver(onErrorJustReturn: [])
        }.do { _ in
            isLoading.accept(false)
        }
        return Output(medias: output, isLoading: isLoading.asDriver())
    }
}
