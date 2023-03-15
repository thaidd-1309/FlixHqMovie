//
//  ImageFilmCollectionViewCell.swift
//  MVVM_Swift
//
//  Created by DuyThai on 22/02/2023.
//

import UIKit
import RxSwift
import SDWebImage

final class ImageFilmCollectionViewCell: UICollectionViewCell, ReuseCellType {
    @IBOutlet private weak var ibmPointLabel: UILabel!
    @IBOutlet private weak var imageFilmImageView: UIImageView!
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        ibmPointLabel.text = nil
        imageFilmImageView.image = nil
    }
    
    private func configView() {
        layer.cornerRadius = LayoutOptions.itemPoster.cornerRadious
        layer.borderWidth = LayoutOptions.itemPoster.borderWidth
        layer.borderColor = UIColor.gray.cgColor
        ibmPointLabel.layer.cornerRadius = LayoutOptions.ibmPointLabel.cornerRadious
        ibmPointLabel.layer.masksToBounds = true
    }
    
    func bindUI(imageUrl: URL) {
        imageFilmImageView.sd_setImage(with: imageUrl)
    }
    
}
