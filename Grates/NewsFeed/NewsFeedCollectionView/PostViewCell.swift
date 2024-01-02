//
//  PostViewCell.swift
//  Grates
//
//  Created by Out East on 01.01.2024.
//

import UIKit

class PostViewCell: UICollectionViewCell {

    private var hasAlreadySetConstraints = false
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var eyeImageView: UIImageView!
    @IBOutlet weak var viewsCountLabel: UILabel!
    
    var imageViews = [UIImageView]()
    
    var likeButton: PostReactionButton?
    var commentButton: PostReactionButton?
    var repostButton: PostReactionButton?
    
    var data: PostData?
    var viewSize = CGSize()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setup(data: PostData, viewSize: CGSize) {
        self.data = data
        self.viewSize = viewSize
        
        self.blurView.contentView.backgroundColor = .clear
        self.blurView.backgroundColor = .clear
        self.blurView.effect = UIBlurEffect(style: .regular)
        
        // Если у владельца поста нет аватара, то мы даем ему дефолтный
        self.avatarImageView.contentMode = .scaleAspectFill
        if let authorImage = data.authorImage {
            self.avatarImageView.image = authorImage
        } else {
            let defaultAvatar = UIImage(named: "DefaultAvatar")
            self.avatarImageView.image = defaultAvatar
        }
        
        self.dateLabel.text = data.date
        self.authorNameLabel.text = data.authorName
        
        let reactionButtonFrame = CGRect(x: 0, y: 0, width: 67, height: 35)
        self.likeButton = PostReactionButton(frame: reactionButtonFrame, count: data.likesNumber, imageName: "heart")
        self.commentButton = PostReactionButton(frame: reactionButtonFrame, count: data.commentsNumber, imageName: "bubble.left")
        self.repostButton = PostReactionButton(frame: reactionButtonFrame, count: data.repostsNumber, imageName: "arrowshape.turn.up.right")
        
        self.viewsCountLabel.text = self.calculateViewsForString(viewsCount: data.viewsNumber)
        
        self.mainTextLabel.numberOfLines = 35
//        self.mainTextLabel.lineBreakMode = .
        
        // устанавли
        self.setConstraints()
        self.setBackgroundShapes()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func calculateViewsForString(viewsCount: Int) -> String {
        if viewsCount < 1_000 {
            return "\(viewsCount)"
        }
        
        if viewsCount < 100_000 {
            return "\(Int(viewsCount/1000)).\(Int(viewsCount/100) - 10*Int(viewsCount/1000))k"
        }
        if viewsCount < 1_000_000 {
            return "\(Int(viewsCount/1000))k"
        }
        if viewsCount >= 1_000_000 {
            return "\(Int(viewsCount/1_000_000)).\(Int(viewsCount/100_000) - 10*Int(viewsCount/1_000_000))"
        }
        return "\(viewsCount)"
    }
    
    private func setConstraints() {
        guard !self.hasAlreadySetConstraints else {
            return
        }
        self.hasAlreadySetConstraints = true
        
        // MARK: Сначала устанавливаем констрейнты для всех элементов интерфейса, кроме реакций и просмотров
        self.avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        let avatarViewConstraints: [NSLayoutConstraint] = [
            self.avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            self.avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            self.avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.avatarImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 23)
        ]
        NSLayoutConstraint.activate(avatarViewConstraints)
        
        self.authorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        let authorNameConstraints: [NSLayoutConstraint] = [
            self.authorNameLabel.heightAnchor.constraint(equalToConstant: 26),
            self.authorNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -28),
            self.authorNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 23),
            self.authorNameLabel.leadingAnchor.constraint(equalTo: self.avatarImageView.trailingAnchor, constant: 13)
        ]
        NSLayoutConstraint.activate(authorNameConstraints)
        
        self.dateLabel.translatesAutoresizingMaskIntoConstraints = false
        let dateConstraints: [NSLayoutConstraint] = [
            self.dateLabel.heightAnchor.constraint(equalToConstant: 19),
            self.dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 150),
            self.dateLabel.topAnchor.constraint(equalTo: self.authorNameLabel.bottomAnchor),
            self.dateLabel.leadingAnchor.constraint(equalTo: self.avatarImageView.trailingAnchor, constant: 13)
        ]
        NSLayoutConstraint.activate(dateConstraints)
        
        self.mainTextLabel.translatesAutoresizingMaskIntoConstraints = false
        let mainTextConstraints: [NSLayoutConstraint] = [
            self.mainTextLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.mainTextLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 38),
            self.mainTextLabel.topAnchor.constraint(equalTo: self.avatarImageView.bottomAnchor, constant: 1)
        ]
        NSLayoutConstraint.activate(mainTextConstraints)
        
        let calculatedWidth: CGFloat = 23 + self.avatarImageView.frame.height + 1 + self.mainTextLabel.frame.height + 50
        // MARK: Потом констрейнты для рамки
        self.frame.size = CGSize(width: self.viewSize.width, height: calculatedWidth)
        
        // MARK: Потом констрейнты для blurView
        self.blurView.translatesAutoresizingMaskIntoConstraints = false
        let blurViewConstraints: [NSLayoutConstraint] = [
            self.blurView.topAnchor.constraint(equalTo: self.topAnchor),
            self.blurView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.blurView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ]
        NSLayoutConstraint.activate(blurViewConstraints)
        
        if let likeButton = self.likeButton,
           let commentButton = self.commentButton,
           let repostButton = self.repostButton
        {
            // MARK: Потом констрейты для реакций и просмотров
            likeButton.translatesAutoresizingMaskIntoConstraints = false
            let likeButtonConstraints: [NSLayoutConstraint] = [
                likeButton.widthAnchor.constraint(equalToConstant: 67),
                likeButton.heightAnchor.constraint(equalToConstant: 35),
                likeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
                likeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 19)
            ]
            NSLayoutConstraint.activate(likeButtonConstraints)
            
            commentButton.translatesAutoresizingMaskIntoConstraints = false
            let commentButtonConstraints: [NSLayoutConstraint] = [
                commentButton.widthAnchor.constraint(equalToConstant: 67),
                commentButton.heightAnchor.constraint(equalToConstant: 35),
                commentButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 14.5),
                commentButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 19)
            ]
            NSLayoutConstraint.activate(commentButtonConstraints)
            
            repostButton.translatesAutoresizingMaskIntoConstraints = false
            let repostButtonConstraints: [NSLayoutConstraint] = [
                repostButton.widthAnchor.constraint(equalToConstant: 67),
                repostButton.heightAnchor.constraint(equalToConstant: 35),
                repostButton.leadingAnchor.constraint(equalTo: commentButton.trailingAnchor, constant: 14.5),
                repostButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 19)
            ]
            NSLayoutConstraint.activate(repostButtonConstraints)
        }
        
        self.viewsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        let viewsCountLabelConstraints: [NSLayoutConstraint] = [
            self.viewsCountLabel.widthAnchor.constraint(equalToConstant: 55),
            self.viewsCountLabel.heightAnchor.constraint(equalToConstant: 20),
            self.viewsCountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.viewsCountLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 34)
        ]
        NSLayoutConstraint.activate(viewsCountLabelConstraints)
        
        self.eyeImageView.translatesAutoresizingMaskIntoConstraints = false
        let eyeImageViewConstraints: [NSLayoutConstraint] = [
            self.eyeImageView.widthAnchor.constraint(equalToConstant: 25),
            self.eyeImageView.heightAnchor.constraint(equalToConstant: 15.75),
            self.eyeImageView.centerYAnchor.constraint(equalTo: self.viewsCountLabel.centerYAnchor),
            self.eyeImageView.trailingAnchor.constraint(equalTo: self.viewsCountLabel.leadingAnchor)
        ]
        NSLayoutConstraint.activate(eyeImageViewConstraints)
    }
    
    private func setBackgroundShapes() {
        
    }
}
