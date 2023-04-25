//
//  TrailerTableViewCell.swift
//  FlixHqMovie
//
//  Created by DuyThai on 25/04/2023.
//

import UIKit

class TrailerTableViewCell: UITableViewCell, ReuseCellType {
    @IBOutlet private weak var trailerImageView: UIImageView!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var tagLabel: UILabel!
    @IBOutlet private weak var trailerNameLabel: UILabel!
    @IBOutlet private weak var playButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        trailerImageView.layer.cornerRadius = LayoutOptions.itemPoster.cornerRadious
        tagLabel.makeCornerRadius(radious: LayoutOptions.tagLabel.cornerRadious)
    }
}
