//
//  PostData.swift
//  Grates
//
//  Created by Out East on 01.01.2024.
//

import Foundation
import UIKit

struct PostData: Codable {
    var authorName: String
//    var authorImage: UIImage
    var text: String
//    var images: [UIImage]
    var likesNumber: Int
    var commentsNumber: Int
    var repostsNumber: Int
    var viewsNumber: Int
    var date: String
}
