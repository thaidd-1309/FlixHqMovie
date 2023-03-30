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
    var previousTimeWatch: Double
    var mediaId: String
    let commonTrigger = CommonTrigger.shared
}

extension DetailViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
        let slectedMovie: Driver<String>
        let previousTimeWatch: Driver<Double>
        let addMyList: Driver<Bool>
    }

    struct Output {
        var media: Driver<Movie>
        var information: Driver<MediaInformation>
        var isLoading: Driver<Bool>
        var recommandMovie: Driver<[Recommendation]>
        var errorAddedOrDelete: Driver<DatabaseError>
        var previousTimeWatch: Driver<Double>
    }

    func checkExistInMyList() -> Driver<Result<Bool, DatabaseError>> {
        return useCase.checkExistInMyListEntity(id: mediaId).asDriver(onErrorDriveWith: .empty())
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let errorAddedOrDelete = PublishSubject<DatabaseError>()
        let isLoading = BehaviorRelay<Bool>(value: false)
        let previousTimeWatch = BehaviorRelay<Double>(value: previousTimeWatch)

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

        let isAddMyList = Driver.combineLatest(information, input.previousTimeWatch, input.addMyList,
                                               resultSelector: { infor, previousTime, isAdded -> Observable<Result<ResultMyList, DatabaseError>> in
            let myListModel = MyList(id: infor.id ?? "",
                                          image: infor.image ?? "",
                                          genres: infor.genres ?? [],
                                          timeRecentWatch: previousTime)
            return isAdded ? useCase.addToMyListDatabase(myListModel: myListModel) : useCase.deleteItemInMyListEntity(mediaId: mediaId)
        })
            .asDriver()

        isAddMyList.drive(onNext: { observer in
            observer.subscribe(onNext: { result in
                commonTrigger.myListTrigger.onNext(result)
            })
            .disposed(by: disposeBag)
        })
        .disposed(by: disposeBag)

        commonTrigger.myListTrigger.subscribe(onNext:  { result in
            switch result {
            case .success(_):
                break
            case .failure( let error ):
                errorAddedOrDelete.onNext(error)
            }
        })
        .disposed(by: disposeBag)

        return Output(media: mediaOuput,
                      information: information,
                      isLoading: isLoading.asDriver(),
                      recommandMovie: recommandMovie,
                      errorAddedOrDelete: errorAddedOrDelete.asDriver(onErrorDriveWith: .empty()),
                      previousTimeWatch: previousTimeWatch.asDriver())
    }
}
