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
    static let shared = DatabaseManager()
    private let presistentContainer: NSPersistentContainer
    private let disposeBag = DisposeBag()
    
    private init() {
        presistentContainer = NSPersistentContainer(name: "FlixHqMovie").with {
            $0.loadPersistentStores { _, _ in }
        }
    }
    
    private func convertToMResultMyListModel(entities: [MyListEntity]) -> ResultMyList {
        let firstElementInGenres = "All"
        var genres = [String]()
        var myLists = [MyList]()
        entities.forEach { item in
            let myList = MyList(id: item.id ?? "",
                                          image: item.image ?? "",
                                          genres: item.genres as? [String] ?? [],
                                          timeRecentWatch: item.timeRecentWatch)
            myLists.append(myList)
            genres.append(contentsOf: item.genres as? [String] ?? [])
        }
        var filterGenres: [String] = [firstElementInGenres]
        filterGenres.append(contentsOf: Array(Set(genres)))

        let result = ResultMyList( myList: myLists, genres: filterGenres )
        return result
    }
    
    func addToMyListDatabase(myList: MyList) -> Observable<Result<ResultMyList, DatabaseError>> {
        let context = presistentContainer.viewContext
        let request = MyListEntity.fetchRequest() as NSFetchRequest<MyListEntity>
        
        return Observable.create { [unowned self] observer in
            do {
                MyListEntity(context: context).do {
                    $0.id = myList.id
                    $0.image = myList.image
                    $0.genres = myList.genres as NSObject
                    $0.timeRecentWatch = myList.timeRecentWatch
                }
                try context.save()
                if let myListEntityAfterAdd = try? context.fetch(request) {
                    let result = convertToMResultMyListModel(entities: myListEntityAfterAdd)
                    observer.onNext(.success(result))
                    observer.onCompleted()
                }
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
    
    func deleteItemInMyListEntity(mediaId: String) -> Observable<Result<ResultMyList, DatabaseError>> {
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
                        let result = convertToMResultMyListModel(entities: myListEntityAfterDelete)
                        observer.onNext(.success(result))
                        observer.onCompleted()
                    }
                }
            } catch {
                observer.onNext(.failure(.deleteFailed))
            }
            return Disposables.create()
        }
    }
    
    func fetchAllInMyListEntiy() -> Observable<Result<ResultMyList, DatabaseError>> {
        let context = presistentContainer.viewContext
        return Observable.create {[unowned self] observer in
            do {
                let request = MyListEntity.fetchRequest() as NSFetchRequest<MyListEntity>
                let myListsEntity = try context.fetch(request)
                let result = convertToMResultMyListModel(entities: myListsEntity)
                observer.onNext(.success(result))
                observer.onCompleted()
            } catch {
                observer.onNext(.failure(.getAllMediaFailed))
            }
            return Disposables.create()
        }
    }

}
