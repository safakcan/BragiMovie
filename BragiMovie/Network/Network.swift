//
//  Network.swift
//  BragiMovie
//
//  Created by Can Bas on 4.09.2023.
//

import Foundation
import RxSwift

class Network {

    static let shared = Network()

    private init() { }

    func request(url: URL) -> Observable<Data> {
        return Observable.create { observer in
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    observer.onError(error)
                    return
                }

                if let data = data {
                    observer.onNext(data)
                    observer.onCompleted()
                } else {
                    observer.onError(NSError(domain: "", code: -1, userInfo: nil))
                }
            }
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
}
