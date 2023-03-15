//
//  HeaderTableView.swift
//  MVVM_Swift
//
//  Created by DuyThai on 22/02/2023.
//

import UIKit
import RxSwift
import RxCocoa

final class HeaderTableView: UITableViewCell, ReuseCellType {
    @IBOutlet private weak var headerTableImageView: UIImageView!
    @IBOutlet private weak var addMyListButton: UIButton!
    @IBOutlet private weak var playButton: UIButton!

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
        addMyListButton.layer.cornerRadius = addMyListButton.frame.size.height / 2
        addMyListButton.layer.borderWidth = LayoutOptions.addToMylistButton.borderWidth
        addMyListButton.layer.borderColor = UIColor.white.cgColor
        headerTableImageView.setGradientBackground(colorTop: UIColor.clear.cgColor, colorBottom: UIColor.black.cgColor)
    }
    
}
