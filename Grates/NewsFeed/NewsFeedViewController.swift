//
//  NewsFeedViewController.swift
//  Grates
//
//  Created by Out East on 22.12.2023.
//

import UIKit

class NewsFeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.8941176471, green: 0.9450980392, blue: 1, alpha: 1)
        
        let reactionButtonFrame = CGRect(origin: self.view.center, size: CGSize(width: 67, height: 35))
        let reactionButton = PostReactionButton(frame: reactionButtonFrame, count: 1337, imageName: "bubble.left")
        self.view.addSubview(reactionButton)
    }

}
