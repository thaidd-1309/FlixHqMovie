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
    }

    struct Output {
        var medias: Driver<[MediaResult]>
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = input.textInput.flatMapLatest { text in
            return useCase.getListMediaByName(query: text)
                .asDriver(onErrorJustReturn: [])
        }

        return Output(medias: output)
    }
}
