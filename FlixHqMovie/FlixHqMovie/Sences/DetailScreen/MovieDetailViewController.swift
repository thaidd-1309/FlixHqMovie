//
//  MovieDetailViewController.swift
//  FlixHqMovie
//
//  Created by DuyThai on 14/03/2023.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import SDWebImage
import AVFoundation
import AVKit
import Then
import SwiftyComments

final class MovieDetailViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var otherMovieCollectionVIew: UICollectionView!
    @IBOutlet private weak var lineCommentButton: UIView!
    @IBOutlet private weak var lineMoreLikeThisButton: UIView!
    @IBOutlet private weak var lineTrailersButtonView: UIView!
    @IBOutlet private weak var commentButton: UIButton!
    @IBOutlet private weak var moreLikeThisButton: UIButton!
    @IBOutlet private weak var trailerButton: UIButton!
    @IBOutlet private weak var actorsCollectionView: UICollectionView!
    @IBOutlet private weak var decriptionMovieTextView: UITextView!
    @IBOutlet private weak var downloadMovieButton: UIButton!
    @IBOutlet private weak var playMovieButton: UIButton!
    @IBOutlet private weak var addToMyListButton: UIButton!
    @IBOutlet private weak var subLabel: UILabel!
    @IBOutlet private weak var nationalLabel: UILabel!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var relatedMovieCollectionView: UICollectionView!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var ibmPointLabel: UILabel!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var moviePosterImageView: UIImageView!
    @IBOutlet private weak var castsCollecttionView: UICollectionView!
    @IBOutlet private weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var commentContainer: UIView!
    @IBOutlet private weak var trailerTableView: UITableView!
    @IBOutlet private weak var commentTableView: UITableView!

    private var playerItem: AVPlayerItem?
    private var player: AVPlayer?
    private var currentTime: Float = 0.0
    private let layerPlayer = AVPlayerLayer()
    private var playerController = AVPlayerViewController()
    private var previousTimeWatch: Double = 0.0
    private var durationMovie: Int = 0
    private var isLoading = false
    private var isAddMyList = false
    private var nameMovie = ""
    private var m3u8UrlVideo = ""
    private let disposeBag = DisposeBag()
    private let databaseManager = DatabaseManager.shared
    private var m3u8Url = ""
    private var movieName = ""
    private var streamMovie: Movie?
    var viewModel: DetailViewModel!

    private let recommendCellSelectedTrigger = PublishSubject<String>()
    private let previousTimeWatchTrigger = BehaviorSubject<Double>(value: 0.0)
    private let addMyListTrigger = PublishSubject<Bool>()
    private let downloadMovieTrigger = PublishSubject<(String, String)>()
    private let showNoticeTrigger = PublishSubject<MovieStreamError>()

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configPlayButton()
        bindingData()
        configTrailerTableView()
        configReleatedMovieCollectionView()
        configCastCollectionView()
        configAddMyListButton()
        configDownloadMovieButton()
        configBottomButton()
        relatedMovieCollectionView.isHidden = false
        commentContainer.isHidden = true
        trailerTableView.isHidden = true
        addCommentView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let player = playerController.player {
            let currentTime = Double(CMTimeGetSeconds(player.currentTime()))
            previousTimeWatch = currentTime
        }
        addToMyListButton.tintColor = isAddMyList ? .red : .white
    }

    private func addCommentView() {
        let childViewController = RedditCommentsViewController()
        addChild(childViewController)
        commentContainer.addSubview(childViewController.view)
        childViewController.view.frame = commentContainer.bounds
        childViewController.didMove(toParent: self)
    }

    private func configPlayButton() {
        playMovieButton.layer.cornerRadius = playMovieButton.frame.height / 2
        playMovieButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            configPlayVideo()
            playerController.then {
                $0.player = player
                $0.showsTimecodes = true
                $0.player?.play()
            }
            if previousTimeWatch > 1 && previousTimeWatch < Double(durationMovie) {
                playerController.player?.seek(to: CMTime(seconds: previousTimeWatch, preferredTimescale: 1))
            }

            self.present(playerController, animated: true)
        })
        .disposed(by: disposeBag)
    }

    private func configAddMyListButton() {
        addToMyListButton.rx.tap.subscribe(onNext: { [unowned self] in
            isAddMyList = !isAddMyList
            addMyListTrigger.onNext(isAddMyList)
            addToMyListButton.tintColor = isAddMyList ? .red : .white
        })
        .disposed(by: disposeBag)
    }

    private func configPlayVideo() {
        guard let urlVideo = streamMovie?.sources?[0].url,
              let urlSub = streamMovie?.sources?[0].url
        else {
            showNoticeTrigger.onNext(MovieStreamError.notFoundUrl)
            return
        }
        guard let urlForVideo = URL(string: urlVideo),
              let urlForSub = URL(string: urlSub)
        else { return }
        let asset = AVAsset(url: urlForVideo)
        let subtitleAsset = AVAsset(url: urlForSub)

        playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(url: urlForVideo)
        player?.replaceCurrentItem(with: playerItem)
    }

    private func configHiddenView(isHiddenView: Bool) {
        scrollView.isHidden = !isHiddenView
        loadingActivityIndicator.isHidden = isHiddenView
    }

    private func configDownloadMovieButton() {
        downloadMovieButton.rx.tap.subscribe(onNext: { [unowned self] in
            downloadMovieTrigger.onNext((m3u8Url, movieName))
        }).disposed(by: disposeBag)
    }

    private func configView() {
        configMoviePosterImage()
        downloadMovieButton.layer.cornerRadius = downloadMovieButton.frame.height / 2
        ageLabel.makeCornerRadius(radious: LayoutOptions.tagLabel.cornerRadious)
        nationalLabel.makeCornerRadius(radious: LayoutOptions.tagLabel.cornerRadious)
        subLabel.makeCornerRadius(radious: LayoutOptions.tagLabel.cornerRadious)
    }

    private func configMoviePosterImage() {
        let gradientLayer = CAGradientLayer().then {
            $0.frame = moviePosterImageView.bounds
            $0.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
            $0.locations = [0.0, 1.0]
        }
    }

    private func getYear(str: String) -> String {
        return String(str.prefix(4))
    }

    private func configTrailerTableView() {
        trailerTableView.then {
            $0.register(nibName: TrailerTableViewCell.self)
            $0.rx.setDelegate(self)
                .disposed(by: disposeBag)
        }

        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>>(
            configureCell: {  _, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TrailerTableViewCell.defaultReuseIdentifier, for: indexPath) as? TrailerTableViewCell
                else {
                    return UITableViewCell()
            }
                return cell
            })
        // TODO: Fake data, because api is Error, so will update when api is fixed
        Driver.of([1, 2, 3, 4, 5, 6, 7, 8, 9])
            .map { [SectionModel(model: "", items: $0)] }
            .drive(trailerTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    private func configCastCollectionView() {
        castsCollecttionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        castsCollecttionView.register(nibName: CastCollectionViewCell.self)
    }

    private func configReleatedMovieCollectionView() {
        relatedMovieCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        relatedMovieCollectionView.register(nibName: ImageFilmCollectionViewCell.self)
        relatedMovieCollectionView.rx.modelSelected(Recommendation.self)
            .subscribe(onNext: { [unowned self] item in
                recommendCellSelectedTrigger.onNext("\(item.id ?? "")")
            })
            .disposed(by: disposeBag)
    }

    private func updateUI(item: MediaInformation) {
        movieTitleLabel.text = item.title
        ibmPointLabel.text = "\(item.rating ?? 0)"
        yearLabel.text = getYear(str: item.releaseDate ?? "")
        nationalLabel.text = item.country
        let genres = item.genres?.joined(separator: ", ")
        decriptionMovieTextView.text = "Genres: \(genres ?? "")\n\(item.description ?? "")"
        let url = URL(string: item.cover ?? "")
        moviePosterImageView.sd_setImage(with: url)
        durationMovie = 60 * (Int(item.duration?.getNumberFromString() ?? "") ?? 0)
        movieName = item.title?.replacingOccurrences(of: " ", with: "") ?? ""
    }
}
extension MovieDetailViewController {
    func bindingData() {
        let loadTrigger = Driver.just(())
        loadTrigger
            .drive(onNext: { [unowned self]_ in
                isLoading = true
            })
            .disposed(by: disposeBag)

        viewModel.checkExistInMyList(disposeBag: disposeBag).drive(onNext: { [unowned self] result in
            switch result {
            case .success(let isExisted):
                isAddMyList = isExisted
            case .failure(let error):
                viewModel.coordinator.toNoticeViewController(notice: "\(error)")
            }
        })
        .disposed(by: disposeBag)

        let input = DetailViewModel.Input(loadTrigger: loadTrigger,
                                          slectedMovie: recommendCellSelectedTrigger.asDriver(onErrorDriveWith: .empty()),
                                          previousTimeWatch: previousTimeWatchTrigger.asDriver(onErrorDriveWith: .empty()),
                                          addMyList: addMyListTrigger.asDriver(onErrorDriveWith: .empty()),
                                          downloadMovie: downloadMovieTrigger.asDriver(onErrorDriveWith: .empty()),
                                          showNotice: showNoticeTrigger.asDriver(onErrorDriveWith: .empty()))
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        binder(output: output)
    }

    private func binder(output: DetailViewModel.Output) {
        let releatedMovieDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Recommendation>>(
            configureCell: { _, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageFilmCollectionViewCell.defaultReuseIdentifier, for: indexPath)
                        as? ImageFilmCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.bind(imageUrl: item.image ?? "")
                return cell
            }
        )

        let castDataSource =  RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(
            configureCell: { _, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.defaultReuseIdentifier, for: indexPath)
                        as? CastCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.bind(actorName: item)
                return cell
            }
        )

        output.information.drive(onNext: { [unowned self] item in
            updateUI(item: item)
            Driver.of(item.casts ?? []).map {
                [SectionModel(model: "", items: $0)]
            }
            .drive(castsCollecttionView.rx.items(dataSource: castDataSource))
            .disposed(by: disposeBag)
        })
        .disposed(by: disposeBag)

        output.recommandMovie
            .map {
                [SectionModel(model: "", items: $0)]
            }
            .drive(relatedMovieCollectionView.rx.items(dataSource: releatedMovieDataSource))
            .disposed(by: disposeBag)

        output.isLoading.drive(onNext: {[unowned self] isLoading in
            configHiddenView(isHiddenView: !isLoading)
        })
        .disposed(by: disposeBag)

        output.media.drive(onNext: {[unowned self] media in
            streamMovie = media
            m3u8Url = media.sources?[0].url ?? ""
        })
        .disposed(by: disposeBag)

        output.errorAddedOrDelete.drive(onNext: { [unowned self]  error in
            viewModel.coordinator.toNoticeViewController(notice: "\(error)")
        })
        .disposed(by: disposeBag)

        output.previousTimeWatch.drive(onNext: { [unowned self] time in
            previousTimeWatch = time
        })
        .disposed(by: disposeBag)
    }

}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == castsCollecttionView {
            return CGSize(
                width: castsCollecttionView.frame.size.width / 2.2,
                height: castsCollecttionView.frame.size.height)
        } else {
            return CGSize(
                width: relatedMovieCollectionView.frame.size.width / 2 - LayoutCell.paddingWidth.value,
                height: relatedMovieCollectionView.frame.size.height / 1.8)
        }
    }

}

extension MovieDetailViewController {
    private func selectButtonBottom(selection: BottomSelection) {
        switch selection {
        case .trailer:
            trailerButton.setTitleColor(.red, for: .normal)
            lineTrailersButtonView.backgroundColor = .red
            moreLikeThisButton.setTitleColor(.lineColor, for: .normal)
            lineMoreLikeThisButton.backgroundColor = .lineColor
            commentButton.setTitleColor(.lineColor, for: .normal)
            lineCommentButton.backgroundColor = .lineColor
            relatedMovieCollectionView.isHidden = true
            commentContainer.isHidden = true
            trailerTableView.isHidden = false
        case .moreLikeThis:
            trailerButton.setTitleColor(.lineColor, for: .normal)
            lineTrailersButtonView.backgroundColor = .lineColor
            moreLikeThisButton.setTitleColor(.red, for: .normal)
            lineMoreLikeThisButton.backgroundColor = .red
            commentButton.setTitleColor(.lineColor, for: .normal)
            lineCommentButton.backgroundColor = .lineColor
            relatedMovieCollectionView.isHidden = false
            commentContainer.isHidden = true
            trailerTableView.isHidden = true
        case .comment:
            trailerButton.setTitleColor(.lineColor, for: .normal)
            lineTrailersButtonView.backgroundColor = .lineColor
            moreLikeThisButton.setTitleColor(.lineColor, for: .normal)
            lineMoreLikeThisButton.backgroundColor = .lineColor
            commentButton.setTitleColor(.red, for: .normal)
            lineCommentButton.backgroundColor = .red
            relatedMovieCollectionView.isHidden = true
            commentContainer.isHidden = false
            trailerTableView.isHidden = true
        }
    }

    private func configBottomButton() {
        print("call configBottomButton")
        trailerButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            print("trailerButton")
            selectButtonBottom(selection: .trailer)
        })
        .disposed(by: disposeBag)

        moreLikeThisButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            print("moreLikeThisButton")
            selectButtonBottom(selection: .moreLikeThis)
        })
        .disposed(by: disposeBag)

        commentButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            print("commentButton")
            selectButtonBottom(selection: .comment)
        })
        .disposed(by: disposeBag)
        
    }
}

extension MovieDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / 5
    }
}
