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

    func downloadM3U8Video(url: String, name: String) -> Observable<URL> {
        /// This func will not active, because do not have Apple Developer Enterprise account, so can not use `File and Folder Access` in Capabilities
        ///  So we can create file to save on disk of device
        return Observable.create { observer in
            guard let m3u8URL = URL(string: url) else { return Disposables.create() }
            URLSession.shared.dataTask(with: m3u8URL) { data, response, error in
                guard let data = data else {
                    observer.onError(error ?? NSError(domain: "Error", code: -1, userInfo: nil))
                    return
                }

                do {
                    let fileUrl = URL(fileURLWithPath: "/path/to/\(name).m3u8")
                    try data.write(to: fileUrl, options: .atomic)
                    observer.onNext(fileUrl)
                    observer.onCompleted()
                } catch (let error) {
                    observer.onError(error)
                }
            }.resume()

            return Disposables.create()
        }
    }
}
