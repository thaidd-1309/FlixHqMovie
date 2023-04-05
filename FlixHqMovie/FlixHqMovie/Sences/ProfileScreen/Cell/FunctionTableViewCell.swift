//
//  FunctionTableViewCell.swift
//  FlixHqMovie
//
//  Created by DuyThai on 03/04/2023.
//

import UIKit

final class FunctionTableViewCell: UITableViewCell, ReuseCellType {
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var rightChevronImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var otherInformationContainerView: UIView!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var buttonSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        otherInformationContainerView.isHidden = true
    }

    func bindData(type: FunctionProfileType) {
        iconImageView.image = type.image
        iconImageView.tintColor = .white
        nameLabel.text = type.name

        switch type.cellMode {
        case .switch:
            otherInformationContainerView.isHidden = false
            buttonSwitch.isHidden = false
            subTitleLabel.isHidden = true
            rightChevronImageView.isHidden = true
        case .info:
            otherInformationContainerView.isHidden = false
            buttonSwitch.isHidden = true
            subTitleLabel.isHidden = false
            subTitleLabel.text = type.subTitle
        case .normal:
            otherInformationContainerView.isHidden = true
        case .logOut:
            break
        }
    }

}
