//
//  NewsFeedViewController.swift
//  Grates
//
//  Created by Out East on 22.12.2023.
//

import UIKit

class NewsFeedViewController: UIViewController {

    @IBOutlet weak var headerBackgroundView: HeaderBackgroundView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var postCellData = [PostData]()
    private let cellIdentifier = "PostViewCell"
    
    private let uploadPostButton = UIButton()
    private let notificationsButton = UIButton()
    private let feedLabel = UILabel()
    
    private let userAvatarImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.8941176471, green: 0.9450980392, blue: 1, alpha: 1)
        
        let cellClass = UINib(nibName: self.cellIdentifier, bundle: nil)
        self.collectionView.register(cellClass, forCellWithReuseIdentifier: self.cellIdentifier)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = #colorLiteral(red: 0.8941176471, green: 0.9450980392, blue: 1, alpha: 1)
        
        // настраиваем расположение ячеек в collectionView
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        // отступы от конкретных граней
        layout.sectionInset = UIEdgeInsets(top: 120, left: 0, bottom: 10, right: 0)
        
        self.collectionView.collectionViewLayout = layout
        
        let text = """
        Русский язык — это удивительная и богатая система, которая проникнута историей, культурой и литературным наследием. Он является одним из самых распространенных языков мира. Его уникальность проявляется в богатстве слов, гибкости грамматики и разнообразии диалектов.
                                                  
        Величие русского языка отражается в его способности выразить сложные мысли, эмоции и идеи.  Русские классики, такие как Пушкин, Толстой, Достоевский, создали произведения, которые стали не только великими в своем языке, но и уникальными для мировой литературы
        
        Русский язык — это удивительная и богатая система, которая проникнута историей, культурой и литературным наследием. Он является одним из самых распространенных языков мира. Его уникальность проявляется в богатстве слов, гибкости грамматики и разнообразии диалектов.
                                                          
        Величие русского языка отражается в его способности выразить сложные мысли, эмоции и идеи.  Русские классики, такие как Пушкин, Толстой, Достоевский, создали произведения, которые стали не только великими в своем языке, но и уникальными для мировой литературы
        """
        self.postCellData.append(PostData(authorName: "Россия", text: text, images: [], likesNumber: 1000, commentsNumber: 1000, repostsNumber: 1000, viewsNumber: 19700, date: "28 dec 18:39"))
        
        self.headerBackgroundView.addSubview(self.userAvatarImageView)
        self.headerBackgroundView.addSubview(self.feedLabel)
        self.headerBackgroundView.addSubview(self.notificationsButton)
        self.headerBackgroundView.addSubview(self.uploadPostButton)
        
        self.setUserAvatar()
        self.setFeedLabel()
        self.setNotificationsButton()
        self.setUploadPostButton()
    }
    
    private func setUserAvatar() {
        self.userAvatarImageView.contentMode = .scaleAspectFit
        self.userAvatarImageView.image = UIImage(named: "DefaultAvatar")
        
        self.userAvatarImageView.translatesAutoresizingMaskIntoConstraints = false
        let constraints: [NSLayoutConstraint] = [
            self.userAvatarImageView.widthAnchor.constraint(equalToConstant: 56),
            self.userAvatarImageView.heightAnchor.constraint(equalToConstant: 56),
            self.userAvatarImageView.leadingAnchor.constraint(equalTo: self.headerBackgroundView.leadingAnchor, constant: 12),
            self.userAvatarImageView.topAnchor.constraint(equalTo: self.headerBackgroundView.topAnchor, constant: 49)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setFeedLabel() {
        self.feedLabel.text = "Feed"
        self.feedLabel.font = UIFont(name: "Comfortaa Bold", size: 30)
        self.feedLabel.textAlignment = .center
        self.feedLabel.textColor = #colorLiteral(red: 0.2138944566, green: 0.1927550137, blue: 0.366743058, alpha: 1)
        
        self.feedLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints: [NSLayoutConstraint] = [
            self.feedLabel.widthAnchor.constraint(equalToConstant: 113),
            self.feedLabel.heightAnchor.constraint(equalToConstant: 43),
            self.feedLabel.leadingAnchor.constraint(equalTo: self.userAvatarImageView.trailingAnchor, constant: 5),
            self.feedLabel.topAnchor.constraint(equalTo: self.headerBackgroundView.topAnchor, constant: 62)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setUploadPostButton() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        let plusImage = UIImage(systemName: "plus.circle", withConfiguration: configuration)
        self.uploadPostButton.imageView?.image = plusImage
        self.uploadPostButton.backgroundColor = .clear
        
        self.uploadPostButton.translatesAutoresizingMaskIntoConstraints = false
        let constraints: [NSLayoutConstraint] = [
            self.uploadPostButton.widthAnchor.constraint(equalToConstant: 38),
            self.uploadPostButton.heightAnchor.constraint(equalToConstant: 38),
            self.uploadPostButton.trailingAnchor.constraint(equalTo: self.notificationsButton.trailingAnchor, constant: 10),
            self.uploadPostButton.topAnchor.constraint(equalTo: self.headerBackgroundView.topAnchor, constant: 65)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setNotificationsButton() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        let bellImage = UIImage(systemName: "bell", withConfiguration: configuration)
        self.notificationsButton.imageView?.image = bellImage
        self.notificationsButton.backgroundColor = .clear
        
        self.notificationsButton.translatesAutoresizingMaskIntoConstraints = false
        let constraints: [NSLayoutConstraint] = [
            self.notificationsButton.widthAnchor.constraint(equalToConstant: 38),
            self.notificationsButton.heightAnchor.constraint(equalToConstant: 38),
            self.notificationsButton.trailingAnchor.constraint(equalTo: self.headerBackgroundView.trailingAnchor, constant: -21),
            self.notificationsButton.topAnchor.constraint(equalTo: self.headerBackgroundView.topAnchor, constant: 65)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}

extension NewsFeedViewController: UIScrollViewDelegate {
    
}

extension NewsFeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.postCellData.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as! PostViewCell
        
        cell.setup(data: self.postCellData[indexPath.item], viewSize: self.view.frame.size)
        
        return cell
    }
}

extension NewsFeedViewController: UICollectionViewDelegateFlowLayout {
    
}

extension NewsFeedViewController: UICollectionViewDelegate {
    
}
