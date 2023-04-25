//
//  FoldableRedditCommentsViewController.swift
//  FlixHqMovie
//
//  Created by DuyThai on 25/04/2023.
//

import Foundation
import UIKit
import SwiftyComments
class FoldableRedditCommentsViewController: RedditCommentsViewController, CommentsViewDelegate {

    func commentCellExpanded(atIndex index: Int) {
        updateCellFoldState(false, atIndex: index)
    }

    func commentCellFolded(atIndex index: Int) {
        updateCellFoldState(true, atIndex: index)
    }

    private func updateCellFoldState(_ folded: Bool, atIndex index: Int) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? RedditCommentTableViewCell else { return }
        cell.animateIsFolded(fold: folded)
        (self.currentlyDisplayed[index] as? RichComment)?.isFolded = folded
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }

    override func viewDidLoad() {
        self.fullyExpanded = true
        super.viewDidLoad()
        self.delegate = self
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCom: AbstractComment = currentlyDisplayed[indexPath.row]
        let selectedIndex = indexPath.row
        // Enable cell folding for comments without replies
        if selectedCom.replies.isEmpty {
            if (selectedCom as? RichComment)?.isFolded  ?? false{
                commentCellExpanded(atIndex: selectedIndex)
            } else {
                commentCellFolded(atIndex: selectedIndex)
            }
        } else {
            super.tableView(tableView, didSelectRowAt: indexPath)
        }
    }
}

class RedditCommentsViewController: CommentsViewController {
    private let commentCellId = "redditComentCellId"
    var allComments: [RichComment] = [] // All the comments (nested, not in a linear format)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(RedditCommentTableViewCell.self, forCellReuseIdentifier: commentCellId)
        tableView.backgroundColor = RedditConstants.backgroundColor
        allComments = RandomDiscussion.generate().comments
        currentlyDisplayed = allComments
        self.swipeToHide = true
        self.swipeActionAppearance.swipeActionColor = RedditConstants.flashyColor
    }

    override open func commentsView(_ tableView: UITableView, commentCellForModel commentModel: AbstractComment, atIndexPath indexPath: IndexPath) -> CommentCell {
        guard let commentCell = tableView.dequeueReusableCell(withIdentifier: commentCellId, for: indexPath) as? RedditCommentTableViewCell else { return CommentCell() }
        let comment = currentlyDisplayed[indexPath.row] as? RichComment
        commentCell.level = comment?.level ?? 0
        commentCell.commentContent = comment?.body
        commentCell.posterName = comment?.posterName
        commentCell.date = comment?.soMuchTimeAgo()
        commentCell.upvotes = comment?.upvotes
        commentCell.isFolded = comment?.isFolded  ?? false && !isCellExpanded(indexPath: indexPath)
        return commentCell
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = RedditConstants.flashyColor
        self.navigationController?.navigationBar.tintColor = .white
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
