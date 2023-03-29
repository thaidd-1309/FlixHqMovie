//
//  DatabaseManager.swift
//  FlixHqMovie
//
//  Created by DuyThai on 27/03/2023.
//

import Foundation
import CoreData
import RxSwift

final class DatabaseManager {
    static let share = DatabaseManager()
    private let presistentContainer: NSPersistentContainer

    private init() {
        presistentContainer = NSPersistentContainer(name: "FlixHqMovie").with {
            $0.loadPersistentStores { _, _ in }
        }
    }

    private func convertToMylistModel(entities: [MyListEntity]) -> [MyListModel] {
        let myListModels = entities.map { item in
            let myListModel = MyListModel(id: item.id ?? "",
                                          image: item.image ?? "",
                                          genres: item.genres as? [String] ?? [],
                                          timeRecentWatch: item.timeRecentWatch)
            return myListModel
        }
        return myListModels
    }
    
    func addToMyListDatabase(myListEntity: MyListModel) -> Observable<Result<Bool, DatabaseError>> {
        let context = presistentContainer.viewContext

        return Observable.create { observer in
            do {
                MyListEntity(context: context).do {
                    $0.id = myListEntity.id
                    $0.image = myListEntity.image
                    $0.genres = myListEntity.genres as NSObject
                    $0.timeRecentWatch = myListEntity.timeRecentWatch
                }
                try context.save()
                observer.onNext(.success(true))
                observer.onCompleted()
            } catch {
                observer.onNext(.failure(.addFailed))
            }
            return Disposables.create()
        }
    }

    func checkExistInMyListEntity(id: String) -> Observable<Result<Bool, DatabaseError>> {
        let context = presistentContainer.viewContext
        let request = MyListEntity.fetchRequest() as NSFetchRequest<MyListEntity>

        return Observable.create { observer in
            do {
                let medias = try context.fetch(request)
                observer.onNext(.success(medias.contains(where: { $0.id == id })))
                observer.onCompleted()
            } catch {
                observer.onNext(.failure(.checkExistFailed))
            }
            return Disposables.create()
        }
    }

    func deleteItemInMyListEntity(mediaId: String) -> Observable<Result<[MyListModel], DatabaseError>> {
        let context = presistentContainer.viewContext
        let request = MyListEntity.fetchRequest() as NSFetchRequest<MyListEntity>

        return Observable.create { [unowned self] observer in
            do {
                if let myListEntity = try? context.fetch(request) {
                    if let myList = myListEntity.first(where: { $0.id == mediaId }) {
                        context.delete(myList)
                        try context.save()
                    }
                    if let myListEntityAfterDelete = try? context.fetch(request) {
                        observer.onNext(.success(convertToMylistModel(entities: myListEntityAfterDelete)))
                        observer.onCompleted()
                    }
                }
            } catch {
                observer.onNext(.failure(.deleteFailed))
            }
            return Disposables.create()
        }
    }

    func fetchAllInMyListEntiy() -> Observable<Result<[MyListModel], DatabaseError>> {
        let context = presistentContainer.viewContext
        return Observable.create {[unowned self] observer in
            do {
                let request = MyListEntity.fetchRequest() as NSFetchRequest<MyListEntity>
                let myListsEntity = try context.fetch(request)

                observer.onNext(.success(convertToMylistModel(entities: myListsEntity)))
                observer.onCompleted()
            } catch {
                observer.onNext(.failure(.getAllMediaFailed))
            }
            return Disposables.create()
        }
    }

    func addToGenreEntity(name: String) -> Observable<Result<Bool, DatabaseError>> {
        let context = presistentContainer.viewContext

        return Observable.create { observer in
            do {
                GenreEntity(context: context).do {
                    $0.name = name
                }
                try context.save()
                observer.onNext(.success(true))
                observer.onCompleted()
            } catch {
                observer.onNext(.failure(.addFailed))
            }
            return Disposables.create()
        }
    }

    func checkExistInGenreEntity(name: String) -> Observable<Result<Bool, DatabaseError>> {
        let context = presistentContainer.viewContext
        let request = GenreEntity.fetchRequest() as NSFetchRequest<GenreEntity>

        return Observable.create { observer in
            do {
                let genres = try context.fetch(request)
                observer.onNext(.success(genres.contains(where: { $0.name == name })))
                observer.onCompleted()
            } catch {
                observer.onNext(.failure(.checkExistFailed))
            }
            return Disposables.create()
        }
    }
}
