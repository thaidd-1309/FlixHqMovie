//
//  Constants.swift
//  FlixHqMovie
//
//  Created by DuyThai on 13/03/2023.
//

import Foundation
import UIKit
import Reachability

enum BaseUrl: String {
    case main = "https://api.consumet.org/movies/flixhq/"
    case viewAsia = "https://api.consumet.org/movies/viewasian/"
    case local = "http://0.0.0.0:3000/movies/flixhq/"
    case deploy = "https://astra-cinema.herokuapp.com/movies/flixhq/"
}

enum EndPoint {
    case getMovie(episodeId: String, mediaId: String)
    case getListMediaByName(query: String)
    case getListTrending
    case getListRecentShow
    case getListRecentMovie
    case getMediaDetail(mediaId: String)
    
    var url: String {
        let baseUrl = BaseUrl.deploy.rawValue
        switch self {
        case .getMovie(episodeId: let episodeId, mediaId: let mediaId):
            return "\(baseUrl)watch?episodeId=\(episodeId)&mediaId=\(mediaId)"
        case .getListMediaByName(query: let query):
            return "\(baseUrl)\(query)"
        case .getListTrending:
            return "\(baseUrl)trending"
        case .getListRecentShow:
            return "\(baseUrl)recent-shows"
        case .getListRecentMovie:
            return "\(baseUrl)recent-movies"
        case .getMediaDetail(mediaId: let mediaId):
            return "\(baseUrl)info?id=\(mediaId)"
        }
    }
}

enum LayoutOptions {
    case itemPoster
    case addToMylistButton
    case tagLabel
    case filterCell
    case buttonInFilterScreen
    case filterButtton
    case containerView
    
    var cornerRadious: CGFloat {
        switch self {
        case .itemPoster:
            return 8
        case .tagLabel:
            return 4
        case .addToMylistButton, .filterCell:
            return 0
        case  .filterButtton:
            return 10
        case .buttonInFilterScreen:
            return 12
        case .containerView:
            return 16
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .itemPoster:
            return 1.2
        case  .filterButtton, .tagLabel, .buttonInFilterScreen:
            return 0
        case .addToMylistButton:
            return 2
        case .filterCell, .containerView:
            return 2
        }
    }
}

enum LayoutCell {
    case paddingWidth
    case paddingHeight
    case heightRatio
    var value: CGFloat {
        switch self {
        case .paddingWidth:
            return 10
        case.paddingHeight:
            return 4
        case.heightRatio:
            return 1.8
        }
    }
}

enum MediaType {
    case movie
    case tvSeries
    
    var name: String {
        switch self {
        case .movie:
            return "Movie"
        case .tvSeries:
            return "TV Series"
        }
    }
}

enum TableHeaderRowType {
    case newMovie
    case newShow
    case trendingMovie
    case trendingShow
    
    var name: String {
        switch self {
        case .newMovie:
            return "New movies"
        case .newShow:
            return "New shows"
        case .trendingMovie:
            return "Trending movies"
        case .trendingShow:
            return "Trending shows"
        }
    }
}

enum SearchNotice {
    case startLabel
    case startNotice
    case notFoundLabel
    case notFoundNotice
    
    var text: String {
        switch self {
        case .startLabel:
            return "Let search"
        case .startNotice:
            return "Find your movie or show you like"
        case .notFoundLabel:
            return "Not found"
        case .notFoundNotice:
            return "Sorry, the keyword you entered could not be found. Try to check again or search with other keywords."
        }
    }
}

enum CustomImageName {
    case noResult
    case search
    case emptyList
    case emptyDownload
    case crown

    var name: String {
        switch self {
        case .noResult:
            return "no-results"
        case .search:
            return "search"
        case .emptyList:
            return "emptyList"
        case .emptyDownload:
            return "movieDownload"
        case .crown:
            return "crown"
        }
    }
}

enum FunctionProfileType {

    case editProfile
    case notification
    case download
    case security
    case changeLanguage
    case changeDarkMode
    case privacy
    case helpCenter
    case logOut

   private func customImage(image: UIImage?) -> UIImage {
       guard let image = image else { return UIImage() }
       let whiteImage = image.withRenderingMode(.alwaysTemplate)
       return whiteImage
   }

    var name: String {
        switch self {
        case .editProfile:
            return "Edit profile"
        case .notification:
            return "Notification"
        case .download:
            return "Download"
        case .security:
            return "Security"
        case .changeLanguage:
            return "Language"
        case .changeDarkMode:
            return "Dark mode"
        case .privacy:
            return "Privacy"
        case .helpCenter:
            return "Help center"
        case .logOut:
            return "Log out"
        }
    }

    var cellMode: CellMode {
        switch self {
        case .editProfile:
            return CellMode.info
        case .notification:
            return CellMode.info
        case .download:
            return CellMode.info
        case .security:
            return CellMode.info
        case .changeLanguage:
            return CellMode.info
        case .changeDarkMode:
            return CellMode.switch
        case .privacy:
            return CellMode.info
        case .helpCenter:
            return CellMode.info
        case .logOut:
            return CellMode.logOut
        }
    }

    var image: UIImage {
        switch self {
        case .editProfile:
            let image = UIImage(systemName: "person")
            return customImage(image: image)
        case .notification:
            let image = UIImage(named: "bell")
            return customImage(image: image)
        case .download:
            let image = UIImage(systemName: "square.and.arrow.down")
            return customImage(image: image)
        case .security:
            let image = UIImage(named: "security")
            return customImage(image: image)
        case .changeLanguage:
            let image = UIImage(named: "language")
            return customImage(image: image)
        case .changeDarkMode:
            let image = UIImage(systemName: "eye")
            return customImage(image: image)
        case .privacy:
            let image = UIImage(systemName: "list.bullet.rectangle.portrait")
            return customImage(image: image)
        case .helpCenter:
            let image = UIImage(named: "infor")
            return customImage(image: image)
        case .logOut:
            let image = UIImage(systemName: "rectangle.portrait.and.arrow.right")
            return customImage(image: image)
        }
    }

    var subTitle: String {
        switch self {
        case .editProfile:
            return ""
        case .notification:
            return ""
        case .download:
            return ""
        case .security:
            return ""
        case .changeLanguage:
            return "Englis - US"
        case .changeDarkMode:
            return ""
        case .privacy:
            return ""
        case .helpCenter:
            return ""
        case .logOut:
            return ""
        }
    }
}

enum CellMode {
    case `switch`
    case info
    case normal
    case logOut
}

enum LoginType {
    case google
    case facebook
}

extension Reachability.Connection {
    var title: String {
        switch self {
        case .none:
            return "Not found network"
        case .unavailable:
            return "Not found network"
        case .wifi:
            return "Connect successfully"
        case .cellular:
            return "Connect successfully"
        }
    }

    var message: String {
        switch self {
        case .none:
            return "Please check your internet connection and retry"
        case .unavailable:
            return "Please check your internet connection and retry"
        case .wifi:
            return "Connect wifi successfully"
        case .cellular:
            return "Connect 3g/4g successfully"
        }
    }

    private func customImage(image: UIImage?) -> UIImage {
        guard let image = image else { return UIImage() }
        let whiteImage = image.withRenderingMode(.alwaysTemplate)
        return whiteImage
    }

    var image: UIImage {
        switch self {
        case .none:
            let image = UIImage(named: "lostConnection") ?? UIImage()
            return image
        case .unavailable:
            let image = UIImage(named: "lostConnection") ?? UIImage()
            return image
        case .wifi:
            let image = UIImage(named: "connectionSuccess")
            return customImage(image: image)
        case .cellular:
            let image = UIImage(named: "mobileNetWork")
            return customImage(image: image)
        }
    }
}
