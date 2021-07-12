//
//  Conversation.swift
//  DesignExamples
//
//  Created by Samir Hasanli on 10.07.21.
//

import Foundation
import MessageKit

struct Conversation {
    let id : String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date : String
    let text : String
    let isRead: Bool
}

struct Message : MessageType {
    public var messageId: String
    public var sender: SenderType
    public var sentDate: Date
    public var kind: MessageKind
}
struct SearchResult {
    let name: String
    let email: String
}


