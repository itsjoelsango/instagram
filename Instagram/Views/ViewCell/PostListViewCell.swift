//
//  PostListViewCell.swift
//  Instagram
//
//  Created by Jo Michael on 8/1/23.
//

import UIKit

protocol PostListViewCellDelegate: AnyObject {
    func didLikeButtonClicked(for cell: PostListViewCell)
}


class PostListViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likePostImageView: UIImageView!
    @IBOutlet weak var commentPostImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var userCommentedLabel: UILabel!
    @IBOutlet weak var addCommentLabel: UILabel!
    @IBOutlet weak var numberOfCommentsOnaPost: UILabel!
    
    weak var delegate: PostListViewCellDelegate?
    
    // implement a boolean value to check the "like" status for the cell
    var isLiked: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        likePostImageView.tintColor = .label
        // Initialization code
        setupViews()
        
        let likeButtontapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likeButtonTapped))
        likePostImageView.addGestureRecognizer(likeButtontapGestureRecognizer)
        likePostImageView.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addCommentTapped))
        addCommentLabel.addGestureRecognizer(tapGestureRecognizer)
        addCommentLabel.isUserInteractionEnabled = true
        
        // add gesture to see all the available comment
        let viewAllCommentapGesture = UITapGestureRecognizer(target: self, action: #selector(addCommentTapped))
        numberOfCommentsOnaPost.addGestureRecognizer(viewAllCommentapGesture)
        numberOfCommentsOnaPost.isUserInteractionEnabled = true
        
    }
    
    private func setupViews()
    {
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title2)

        self.likePostImageView.tintColor = .label
        
        let commentSymbolName = "message"
        let commentImage = UIImage(systemName: commentSymbolName, withConfiguration: symbolConfiguration)
        self.commentPostImageView.image = commentImage
        
        
        let shareSymbolName = "paperplane"
        let image = UIImage(systemName: shareSymbolName, withConfiguration: symbolConfiguration)
        self.shareImageView.image = image
    }
    
    @objc private func addCommentTapped(_ sender: UITapGestureRecognizer)
    {
        NotificationCenter.default.post(name: NSNotification.Name("commentTapped"), object: self)
        print("clicked add comment!")
    }
    
    @objc func likeButtonTapped(_ sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: NSNotification.Name("likeButtonTapped"), object: self)
        delegate?.didLikeButtonClicked(for: self)
        isLiked = !isLiked
        updateLikeButtonAppearance()
        print("like Button tapped!")
    }
    
    func updateLikeButtonAppearance() {
        let likeSymbolName = isLiked ? "heart.fill" : "heart"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title2)
        let likeImage = UIImage(systemName: likeSymbolName, withConfiguration: symbolConfiguration)
        self.likePostImageView.image = likeImage
    }

}
