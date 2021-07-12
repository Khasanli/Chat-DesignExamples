//
//  Sender.swift
//  DesignExamples
//
//  Created by Samir Hasanli on 10.07.21.
//

import Foundation
import MessageKit

struct Sender: SenderType  {
    public var photoURL: String
    public var senderId: String
    public var displayName: String
}

enum ProfileViewModelType {
    case info, logout
}
struct ProfileViewModel {
    let viewModelType: ProfileViewModelType
    let title: String
    let handler: (() -> Void)?
}
