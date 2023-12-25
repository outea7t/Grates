//
//  SeguesNames.swift
//  Grates
//
//  Created by Out East on 08.12.2023.
//

import Foundation
import UIKit

/// имена всех переходов, которые существуют в приложении
enum SeguesNames: String {
    case loginToRegistration = "loginToRegistration"
    case loginToNewsFeed = "loginToNewsFeed"
    case registrationToEmailConfirmation = "registrationToEmailConfirmation"
    case confirmationToNewsFeed = "confirmationToNewsFeed"
    case loginToEmailConfirmation = "loginToEmailConfirmation"
}
