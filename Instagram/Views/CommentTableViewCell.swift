//
//  CommentTableViewCell.swift
//  Instagram
//
//  Created by Jo Michael on 8/9/23.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    var commentLabel: UICustomLabel!
    var authorLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private func setupViews() {
        authorLabel = UILabel()
        authorLabel.text = "Micaela [fpo]"
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.numberOfLines = 0
        authorLabel.font = .boldSystemFont(ofSize: 14.0)
        contentView.addSubview(authorLabel)
        
        commentLabel = UICustomLabel()
        commentLabel.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        commentLabel.text = "This is a text demo to see how the label display with multiple lines just in case you were wondering [fpo]"
        commentLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        commentLabel.textAlignment = .justified
        commentLabel.numberOfLines = 0
        commentLabel.backgroundColor = .systemGray3
        commentLabel.cornerRadius = 10
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(commentLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            authorLabel.trailingAnchor.constraint(equalTo: commentLabel.leadingAnchor, constant: -4),
//            authorLabel.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: -4)
            authorLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.20)
        ])
        
        NSLayoutConstraint.activate([
            commentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
//            commentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            commentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            commentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
