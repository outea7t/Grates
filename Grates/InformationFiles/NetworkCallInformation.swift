//
//  NetworkCallInformation.swift
//  Grates
//
//  Created by Out East on 15.12.2023.
//

import Foundation

/// Класс для удобства отправления запросов
/// Все пути прописаны тут
/// * Использование:
/// NetworkCallInformation.Registration.authRefresh*
class NetworkCallInformation {
    static private let domain = "https://grates.mgtu.tech/"
    
    class Registration {
        static let authRefresh = domain + "auth/refresh"
        static let authSignIn = domain + "auth/sign-in"
        
        static let authSignUp = domain + "auth/sign-up"
        /// переотправить письмо подтверждения
        /// * обязательно добавить userID после последнего слеша
        static let resendEmail = domain + "auth/resend/"
    }
    
    class Comments {
        /// * обязательно вставлять commentID после последнего слеша
        static let deleteComment = domain + "api/comment/"
        /// * обязательно вставлять commentID после последнего слеша
        static let updateComment = domain + "api/comment/"
        /// * обязательно вставлять postID после последнего слеша
        /// * api/posts/{postID}/comments
        static let getPostComments = domain + "api/posts/"
        /// * обязательно вставлять postID после последнего слеша
        /// * api/posts/{postID}/comments
        static let createComment = domain + "api/posts/"
    }
    
    class Friends {
        static let acceptFriendRequest = domain + "api/friends/accept"
        static let sendFriendRequest = domain + "api/friends/request"
        static let unfriend = domain + "api/friends/unfriend"
        /// * обязательно использовать userID после последнего слэша
        static let getFriends = domain + "api/friends/"
    }
    
    class Posts {
        static let createPost = domain + "api/posts"
        static let getUserPosts = domain + "api/posts"
        /// * обязательно использование userID после последнего слеша
        static let getFriendsPosts = domain + "api/posts/friends/"
        /// * обязательно использование postID после последнего слэша
        static let getPost = domain + "api/posts/"
        /// * обязательно использование postID после последнего слэша
        static let deletePost = domain + "api/posts/"
        /// * обязательно использование postID после последнего слэша
        static let updatePost = domain + "api/posts/"
    }
    
    class Likes {
        /// * обязательно использование postID после последнего слэша
        /// * api/posts/{postID}/dislike
        static let dislikePost = domain + "api/posts/"
        /// * обязательно использование postID после последнего слэша
        /// * api/posts/{postID}/like
        static let likePost = domain + "api/posts/"
    }
    
    class Profile {
        static let profile = domain + "api/profile"
    }
    
}
