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
import GoogleSignIn
import SDWebImage
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit

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

    private let logOutTrigger = PublishSubject<Bool>()

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
        let input = ProfileViewModel.Input(logOut: logOutTrigger.asDriver(onErrorJustReturn: false))
        let outout = viewModel.transform(input: input, disposeBag: disposeBag)
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, FunctionProfileType>>(
            configureCell: { _, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: FunctionTableViewCell.defaultReuseIdentifier, for: indexPath) as? FunctionTableViewCell
                else {
                    return UITableViewCell()
                }
                cell.bindData(type: item)
                return cell
            })

        outout.functionTypes
            .map { [SectionModel(model: "", items: $0)] }
            .drive(functionTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        outout.informationGoogleUser.drive(onNext: { [unowned self] user in
            if let user = user {
                updateGoogleUser(user: user)
            }
        })
        .disposed(by: disposeBag)
        outout.informationFaceBookUser.drive(onNext: { [unowned self] user in
            if let user = user {
                updateFacebookUser(user: user)
            }
        })
        .disposed(by: disposeBag)
        configCellSelected()
    }

    private func configCellSelected() {
        functionTableView.rx.modelSelected(FunctionProfileType.self).subscribe(onNext: { [unowned self] item in
            if item == FunctionProfileType.logOut {
                logOutTrigger.onNext(true)
            }
        })
        .disposed(by: disposeBag)
    }

    private func updateGoogleUser(user: GIDGoogleUser?) {
        let avatarUrl = user?.profile?.imageURL(withDimension: 320)
        avatarImageView.sd_setImage(with: avatarUrl)
        userNameLabel.text = user?.profile?.name
        userMailLabel.text = user?.profile?.email
    }

    private func updateFacebookUser(user: User?) {
        let avatarUrl = user?.photoURL
        avatarImageView.sd_setImage(with: avatarUrl)
        userNameLabel.text = user?.displayName
        userMailLabel.text = user?.email
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 7.4
    }
}
