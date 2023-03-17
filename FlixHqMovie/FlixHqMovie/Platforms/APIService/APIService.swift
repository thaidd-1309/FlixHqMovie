//
//  APIService.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import Foundation
import RxSwift
import Alamofire
import ObjectMapper

struct APIService {
    static let shared = APIService()
    private init() {}

    func request<T: Mappable>(endPoint: EndPoint) -> Observable<T> {
        return Observable.create { observer in
            AF.request(endPoint.url).responseJSON { response in
                switch response.result {
                case .success(let data):
                    if let jsonDict = data as? [String: Any], let model = Mapper<T>().map(JSON: jsonDict) {
                        observer.onNext(model)
                        observer.onCompleted()
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }

    func requestArray<T: Mappable>(endPoint: EndPoint) -> Observable<[T]> {
        return Observable.create { observer in
            AF.request(endPoint.url).responseJSON { response in
                switch response.result {
                case .success(let data):
                    guard let jsonArray = data as? [[String : Any]] else { return }
                    let model = Mapper<T>().mapArray(JSONObject: jsonArray)
                    observer.onNext(model ?? [])
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }

}
