//
//  MyListViewModel.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import Foundation
import RxCocoa
import RxSwift

struct MyListViewModel {
    var coordinator: MyListCoordinator
    var useCase: MyListUseCaseType
    let commonTrigger = CommonTrigger.shared
}
extension MyListViewModel: ViewModelType {
    struct Input {
        let slectedMovie: Driver<MyList>
        let updateMyList: Driver<Bool>
        let selectedGenre: Driver<String>
    }

    struct Output {
        var myListModels: Driver<[MyList]>
        var genres: Driver<[String]>
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let genresTrigger = BehaviorSubject<[String]>(value: [])
        let myListTrigger = BehaviorSubject<[MyList]>(value: [])
        input.slectedMovie.drive(onNext: { model in
            coordinator.toMovieDetail(with: model.id, previousTime: model.timeRecentWatch)
        })
        .disposed(by: disposeBag)

        commonTrigger.myListTrigger.subscribe(onNext: { result in
            switch result {
            case .success(let resultModel):
                myListTrigger.onNext(resultModel.myList)
                genresTrigger.onNext(resultModel.genres)
            case .failure(let error):
                coordinator.toNoticeViewController(notice: "\(error)")
            }
        })
        .disposed(by: disposeBag)

      let myListFilter = Driver.combineLatest(input.selectedGenre, myListTrigger.asDriver(onErrorJustReturn: []), resultSelector: {genreSelected, myList -> [MyList] in
            let myListAfterFilter = myList.filter { $0.genres.contains(genreSelected) }
            return genreSelected == "All" ? myList : myListAfterFilter
      }).asDriver(onErrorJustReturn: [])

        return Output(myListModels: myListFilter, genres: genresTrigger.asDriver(onErrorJustReturn: []))
    }
}
