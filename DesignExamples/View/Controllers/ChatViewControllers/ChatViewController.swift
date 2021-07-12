//
//  ConversationsViewController.swift
//  DesignExamples
//
//  Created by Samir Hasanli on 03.07.21.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    private var senderPhotoUrl : URL?
    private var otherUserPhotoUrl : URL?
    
    public static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
    public let otherUserEmail: String
    private var conversationId: String?
    public var isNewConversation = false
    
    private var messages = [Message]()
    
    private var selfSender: Sender? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        let safeEmail = DatabaseManager.safeEmail(email_adress: email)

        return Sender(photoURL: "",
                      senderId: safeEmail,
                      displayName: "Me")
        
    }
    
    let bottomLine : UIView = {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = .gray
        return lineView
    }()
    let topBackView : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1670032779, green: 0.2772738464, blue: 0.4184761433, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let titleText : UILabel = {
        let label = UILabel()
        label.text = "Chat"
        label.textAlignment = .left
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let backButton : UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "close"), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    init(with email: String, id: String?) {
        self.conversationId = id
        self.otherUserEmail = email
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(topBackView)
        view.addSubview(titleText)
        view.addSubview(backButton)
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesDataSource = self
        messageInputBar.delegate = self
        setSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
        if let conversationId = conversationId  {
            listenForMessages(id: conversationId, shouldScrollToButtom: true)
        }
       }
    
    private func setSubviews(){
        titleText.topAnchor.constraint(equalTo: view.topAnchor, constant: view.height/16).isActive = true
        titleText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.height/32).isActive = true
        titleText.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4).isActive = true
        titleText.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/16).isActive = true
        titleText.font = UIFont(name: "Arial-BoldMT", size: view.height/30)
        
        topBackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topBackView.bottomAnchor.constraint(equalTo: titleText.bottomAnchor).isActive = true
        topBackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topBackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        titleText.addSubview(bottomLine)
        bottomLine.bottomAnchor.constraint(equalTo: titleText.bottomAnchor).isActive = true
        bottomLine.centerXAnchor.constraint(equalTo: titleText.centerXAnchor).isActive = true
        bottomLine.widthAnchor.constraint(equalTo: titleText.widthAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        backButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.width/16).isActive = true
        backButton.centerYAnchor.constraint(equalTo: titleText.centerYAnchor).isActive = true
        backButton.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/40).isActive = true
        backButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/40).isActive = true
        backButton.layer.cornerRadius = view.height/40
        messagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        messagesCollectionView.contentInset.top = CGFloat(view.height/8)
    }
    
    @objc private func backButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    private func listenForMessages(id: String, shouldScrollToButtom: Bool){
        DatabaseManager.shared.getAllMessagesForConversation(with: id, completion: {[weak self] result in
            switch result {
            case .success(let messages):
                guard !messages.isEmpty else {
                    return
                }
                self?.messages = messages
                DispatchQueue.main.async {
                    self?.messagesCollectionView.reloadDataAndKeepOffset()

                    if shouldScrollToButtom {
                        self?.messagesCollectionView.scrollToLastItem(at: .top, animated: true)
                    }
                }
            case .failure(let err):
                print("failed to get messages: \(err.localizedDescription)")
            }
        })
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let sender = message.sender
        if sender.senderId == selfSender?.senderId {
            return #colorLiteral(red: 0.1670032779, green: 0.2772738464, blue: 0.4184761433, alpha: 1)
        }
        return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let sender = message.sender
        if sender.senderId == selfSender?.senderId {
            if let currentUserImageURL = self.senderPhotoUrl {
                avatarView.sd_setImage(with: currentUserImageURL, completed: nil)
            }else {
                guard let email = UserDefaults.standard.value(forKey: "email") as? String else {return}
                let safeEmail = DatabaseManager.safeEmail(email_adress: email)
                StorageManager.shared.downloadURL(for: "images/\(safeEmail)_profile.png") { [weak self] result in
                    switch result {
                    case .success(let url):
                        DispatchQueue.main.async {
                            self?.senderPhotoUrl = url
                            avatarView.sd_setImage(with: url, completed: nil)
                        }
                    case .failure(let error):
                        print("\(error.localizedDescription)")
                    }
                }
            }
        } else {
            if let otherUserURL = self.otherUserPhotoUrl {
                avatarView.sd_setImage(with: otherUserURL, completed: nil)
            } else {
                let email = self.otherUserEmail
                let safeEmail = DatabaseManager.safeEmail(email_adress: email)
                StorageManager.shared.downloadURL(for: "images/\(safeEmail)_profile.png") { [weak self] result in
                    switch result {
                    case .success(let url):
                        DispatchQueue.main.async {
                            self?.otherUserPhotoUrl = url
                            avatarView.sd_setImage(with: url, completed: nil)
                        }
                    case .failure(let error):
                        print("\(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        
        if let sender = selfSender  {
            return sender
        }
        fatalError("Self sender is nill")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func createMessageId() -> String? {
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        
        let safeCurrentEmail = DatabaseManager.safeEmail(email_adress: currentUserEmail)
        
        let dateString = Self.dateFormatter.string(from: Date())
        let newIndentifier = "\(otherUserEmail)_\(safeCurrentEmail)_\(dateString)"
        return newIndentifier
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty, let selfSender = self.selfSender, let messageId = createMessageId() else {
            return}
        let message = Message(messageId: messageId, sender: selfSender, sentDate: Date(), kind: .text(text))
        
        if isNewConversation {
            DatabaseManager.shared.createNewConversation(with: otherUserEmail, name: self.titleText.text ?? "User", firstMessage: message) { success in
                if success {
                    self.isNewConversation = false
                    let newConversationId = "conversation_\(message.messageId)"
                    self.conversationId = newConversationId
                    self.listenForMessages(id: newConversationId, shouldScrollToButtom: true)
                    self.messageInputBar.inputTextView.text = nil
                } else {
                }
            }
            
        }else{
            guard let conversationId = conversationId else {
                return
            }
            guard let name = UserDefaults.standard.value(forKey: "name") as? String else {
                return
            }
            DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: otherUserEmail, name: name, newMessage: message) { success in
                if success {
                    self.messageInputBar.inputTextView.text = nil
                }else{
                    
                }
            }
        }
    }
}
