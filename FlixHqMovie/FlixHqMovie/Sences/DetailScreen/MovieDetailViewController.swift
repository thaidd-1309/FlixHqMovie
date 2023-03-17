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

    private var playerItem: AVPlayerItem?
    private var player: AVPlayer?
    private var currentTime: Float = 0.0
    private let layerPlayer = AVPlayerLayer()
    private var playerController = AVPlayerViewController()
    private var movie: Movie?
    private var previousTimeWatch: Double = 0.0
    private var durationMovie: Int = 0
    private let disposeBag = DisposeBag()

    private let recommendCellSelectedTrigger = PublishSubject<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configPlayVideo()
        bindingData()
        configReleatedMovieCollectionView()
        configCastCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let player = playerController.player {
            let currentTime = Double(CMTimeGetSeconds(player.currentTime()))
            previousTimeWatch = currentTime
        }
    }

    private func configPlayVideo() {
        let urlVideo = movie?.sources?[0].url ?? ""
        let urlSub = movie?.subtitles?[0].url ?? ""
        guard let urlForVideo = URL(string: urlVideo),
              let urlForSub = URL(string: urlSub)else { return }
        let asset = AVAsset(url: urlForVideo)
        let subtitleAsset = AVAsset(url: urlForSub)

        playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(url: urlForVideo)
        player?.replaceCurrentItem(with: playerItem)

        playMovieButton.rx.tap.subscribe(onNext: { [unowned self] _ in
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

    private func configHiddenView(isHiddenView: Bool) {
        scrollView.isHidden = !isHiddenView
        loadingActivityIndicator.isHidden = isHiddenView
    }

    private  func configView() {
        configMoviePosterImage()
        playMovieButton.layer.cornerRadius = playMovieButton.frame.height / 2
        downloadMovieButton.layer.cornerRadius = downloadMovieButton.frame.height / 2
        ageLabel.makeCornerRadius(radious: LayoutOptions.ageLabel.cornerRadious)
        nationalLabel.makeCornerRadius(radious: LayoutOptions.nationalLabel.cornerRadious)
        subLabel.makeCornerRadius(radious: LayoutOptions.subLabel.cornerRadious)
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

    private func configCastCollectionView() {
        castsCollecttionView.rx.setDelegate(self).disposed(by: disposeBag)
        castsCollecttionView.register(nibName: CastCollectionViewCell.self)
    }

    func configReleatedMovieCollectionView() {
        relatedMovieCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        relatedMovieCollectionView.register(nibName: ImageFilmCollectionViewCell.self)
    }
}
extension MovieDetailViewController {
    func bindingData() {

        let releatedMovieDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Int>>(
            configureCell: { _, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageFilmCollectionViewCell.defaultReuseIdentifier, for: indexPath)
                        as? ImageFilmCollectionViewCell else {
                    return UICollectionViewCell()
                }
                return cell
            }
        )

        //TODO: Fake data, will update in task/60489
        let dataTest = Driver.of([1, 2, 3, 4, 5, 6, 7, 8, 9])
        dataTest.map {
            [SectionModel(model: "", items: $0)]
        }
        .drive(relatedMovieCollectionView.rx.items(dataSource: releatedMovieDataSource))
        .disposed(by: disposeBag)

        let castDataSource =  RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(
            configureCell: { dataSource, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.defaultReuseIdentifier, for: indexPath)
                        as? CastCollectionViewCell else {
                    return UICollectionViewCell()
                }
                return cell
            }
        )

        //TODO: Fake data, will update in task/60489
        Driver.of(["a", "b", "c", "d"]).map {
            [SectionModel(model: "", items: $0)]
        }
        .drive(castsCollecttionView.rx.items(dataSource: castDataSource))
        .disposed(by: disposeBag)
    }

}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == castsCollecttionView {
            return CGSize(width: castsCollecttionView.frame.size.width / 2.2, height: castsCollecttionView.frame.size.height)
        } else {
            return CGSize(width: relatedMovieCollectionView.frame.size.width / 2 - LayoutCell.padding.value, height: relatedMovieCollectionView.frame.size.height / 1.8)
        }
    }

}
