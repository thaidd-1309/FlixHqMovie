//
//  MovieTableViewCell.swift
//  FlixHqMovie
//
//  Created by DuyThai on 30/03/2023.
//

import UIKit

final class MovieTableViewCell: UITableViewCell, ReuseCellType {

    @IBOutlet private weak var playImageView: UIImageView!
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var movieCapacityLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var movieNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }

    private func configView() {
        movieImageView.layer.cornerRadius = LayoutOptions.itemPoster.cornerRadious
        movieImageView.layer.borderWidth = LayoutOptions.itemPoster.borderWidth
        movieImageView.layer.borderColor = UIColor.tabBarUnselectedItemTintColor.cgColor
        playImageView.applyCircleView()
    }
}
