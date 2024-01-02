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

        let reactionButtonFrame = CGRect(origin: self.view.center, size: CGSize(width: 67, height: 35))
        let reactionButton = PostReactionButton(frame: reactionButtonFrame, count: 1337, imageName: "bubble.left")
        self.view.addSubview(reactionButton)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
