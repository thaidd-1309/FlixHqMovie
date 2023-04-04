//
//  ProfileViewController.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa
import Then

final class ProfileViewController: UIViewController {

    @IBOutlet private weak var crownImageView: UIImageView!
    @IBOutlet private weak var joinPremiumContainerView: UIView!
    @IBOutlet private weak var functionTableView: UITableView!
    @IBOutlet private weak var userMailLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var editProfileButton: UIButton!
    @IBOutlet private weak var avatarImageView: UIImageView!

    private let disposeBag = DisposeBag()
    var viewModel: ProfileViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configTableView()
        bindViewModel()
    }

    private func configView() {
        avatarImageView.applyCircleView()
        editProfileButton.layer.cornerRadius = LayoutOptions.tagLabel.cornerRadious
        joinPremiumContainerView.then {
            $0.layer.cornerRadius = joinPremiumContainerView.frame.size.height / 3.5
            $0.layer.borderWidth = LayoutOptions.containerView.borderWidth
            $0.layer.borderColor = UIColor.borderColorFilterCell
        }
        crownImageView.then {
            $0.image = customImage(imageName: .crown)
            $0.tintColor = .filterCellSelectedBackGroundColor
        }
    }

    private func customImage(imageName: CustomImageName) -> UIImage {
        guard let image = UIImage(named: imageName.name) else { return UIImage() }
        let whiteImage = image.withRenderingMode(.alwaysTemplate)
        return whiteImage
    }

    private func configTableView() {
        functionTableView.register(nibName: FunctionTableViewCell.self)
        functionTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }

    private func bindViewModel() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, FunctionProfileType>>(
            configureCell: { [unowned self] _, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: FunctionTableViewCell.defaultReuseIdentifier, for: indexPath) as? FunctionTableViewCell
                else {
                    return UITableViewCell()
                }
                cell.bindData(type: item)
                return cell
            })

        let functionTypes = [FunctionProfileType.editProfile,
                             FunctionProfileType.notification,
                             FunctionProfileType.download,
                             FunctionProfileType.security,
                             FunctionProfileType.changeLanguage,
                             FunctionProfileType.changeDarkMode,
                             FunctionProfileType.privacy,
                             FunctionProfileType.helpCenter]
        Driver.of(functionTypes)
            .map { [SectionModel(model: "", items: $0)] }
            .drive(functionTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 6.5
    }
}
