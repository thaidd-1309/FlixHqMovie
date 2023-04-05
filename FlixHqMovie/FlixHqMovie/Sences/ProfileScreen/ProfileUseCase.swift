//
//  ProfileUseCase.swift
//  FlixHqMovie
//
//  Created by DuyThai on 04/04/2023.
//

import Foundation
import RxSwift

struct ProfileUseCase {
    private let functionTypes = [FunctionProfileType.editProfile,
                                 FunctionProfileType.notification,
                                 FunctionProfileType.download,
                                 FunctionProfileType.security,
                                 FunctionProfileType.changeLanguage,
                                 FunctionProfileType.changeDarkMode,
                                 FunctionProfileType.privacy,
                                 FunctionProfileType.helpCenter,
                                 FunctionProfileType.logOut]
    
    func getFunctionTypes() -> Observable<[FunctionProfileType]> {
        return Observable.create { observer in
            observer.onNext(functionTypes)
            return Disposables.create()
        }
    }
}
