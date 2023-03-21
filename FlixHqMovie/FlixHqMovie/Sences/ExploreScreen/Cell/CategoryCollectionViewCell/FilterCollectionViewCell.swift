//
//  FilterCollectionViewCell.swift
//  FlixHqMovie
//
//  Created by DuyThai on 20/03/2023.
//

import UIKit
import RxSwift

final class FilterCollectionViewCell: UICollectionViewCell, ReuseCellType {
    @IBOutlet private weak var nameFilterLabel: UILabel!

    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        configView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        nameFilterLabel.text = nil
    }

    private func configView() {
        layer.cornerRadius  = self.frame.size.height / 2
        layer.borderWidth = LayoutOptions.filterCell.borderWidth
        layer.borderColor = UIColor.borderColorFilterCell
    }

    func getTextInLabel() -> String {
        return nameFilterLabel.text ?? ""
    }

    func setTextInLabel(name: String) {
        nameFilterLabel.text = name
    }
}
