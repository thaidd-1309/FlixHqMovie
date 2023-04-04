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
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var darkModeSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        otherInformationContainerView.isHidden = true
    }

    func bindData(type: FunctionProfileType) {
        iconImageView.image = type.image
        iconImageView.tintColor = .white
        nameLabel.text = type.name

        let isChangeLanguage = type == FunctionProfileType.changeLanguage
        let isDarkMode = type == FunctionProfileType.changeDarkMode
        otherInformationContainerView.isHidden = !(isChangeLanguage || isDarkMode)
        darkModeSwitch.isHidden = !isDarkMode
        languageLabel.isHidden = !isChangeLanguage
        rightChevronImageView.isHidden = isDarkMode
    }

}
