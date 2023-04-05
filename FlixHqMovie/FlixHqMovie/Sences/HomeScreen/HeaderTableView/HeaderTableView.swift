//
//  HeaderTableView.swift
//  MVVM_Swift
//
//  Created by DuyThai on 22/02/2023.
//

import UIKit
import RxSwift
import RxCocoa
import Then

final class HeaderTableView: UITableViewCell, ReuseCellType {
    @IBOutlet private weak var headerTableImageView: UIImageView!
    @IBOutlet private weak var addMyListButton: UIButton!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var nameMovieLabel: UILabel!
    @IBOutlet private weak var decriptionLabel: UILabel!

    var playButtonTapped: ((String) -> Void)?
    private let disposeBag = DisposeBag()
    private var id = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
        playButton.rx.tap
            .subscribe(onNext: {
                self.playButtonTapped?(self.id)
            })
            .disposed(by: disposeBag)
    }

    private func configView() {
        playButton.layer.cornerRadius = playButton.frame.size.height / 2
        addMyListButton.then {
            $0.layer.cornerRadius = addMyListButton.frame.size.height / 2
            $0.layer.borderWidth = LayoutOptions.addToMylistButton.borderWidth
            $0.layer.borderColor = UIColor.white.cgColor
        }
        headerTableImageView.setGradientBackground(colorTop: UIColor.clear.cgColor, colorBottom: UIColor.black.cgColor)
    }

    func bind(media: MediaInformation?) {
        let url = URL(string: media?.cover ?? "")
        headerTableImageView.sd_setImage(with: url)
        nameMovieLabel.text = media?.title
        decriptionLabel.text = media?.description?.removeWhiteSpaceAndBreakLine()
        id = media?.id ?? ""
    }
}
