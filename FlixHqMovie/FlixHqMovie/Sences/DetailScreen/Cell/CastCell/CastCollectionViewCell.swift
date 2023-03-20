//
//  CastCollectionViewCell.swift
//  FlixHqMovie
//
//  Created by DuyThai on 14/03/2023.
//

import UIKit

final class CastCollectionViewCell: UICollectionViewCell, ReuseCellType {
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var positionNameLabel: UILabel!
    @IBOutlet private weak var actorNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.applyCircleView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        positionNameLabel.text = nil
        actorNameLabel.text = nil
    }

    func bind(actorName: String) {
        actorNameLabel.text = actorName
    }
}
