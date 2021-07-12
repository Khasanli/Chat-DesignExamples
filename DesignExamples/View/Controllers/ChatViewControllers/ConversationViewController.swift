//
//  ChatViewController.swift
//  DesignExamples
//
//  Created by Samir Hasanli on 02.07.21.
//

import UIKit
import JGProgressHUD

class ConversationViewController: UIViewController {
    private let spinner = JGProgressHUD(style: .dark)
    public var conversations = [Conversation]()
    
    let bottomLine : UIView = {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = .gray
        return lineView
    }()
    let addConversationButton : UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(addConversationButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: "add-chat"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let topBackView : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1670032779, green: 0.2772738464, blue: 0.4184761433, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let titleText : UILabel = {
        let label = UILabel()
        label.text = "Conversations"
        label.textAlignment = .left
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ConversationTableViewCell.self, forCellReuseIdentifier: ConversationTableViewCell.identifier)
        return tableView
    }()
    let noConversationsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Conversation"
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.1670032779, green: 0.2772738464, blue: 0.4184761433, alpha: 1)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(topBackView)
        view.addSubview(titleText)
        view.addSubview(addConversationButton)
        view.addSubview(tableView)
        view.addSubview(noConversationsLabel)
        
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        startListeningConversations()
        setSubviews()
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
        
        addConversationButton.centerYAnchor.constraint(equalTo: titleText.centerYAnchor).isActive = true
        addConversationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.width/32).isActive = true
        addConversationButton.widthAnchor.constraint(equalTo: titleText.heightAnchor).isActive = true
        addConversationButton.heightAnchor.constraint(equalTo: titleText.heightAnchor).isActive = true
        
        titleText.addSubview(bottomLine)
        bottomLine.bottomAnchor.constraint(equalTo: titleText.bottomAnchor).isActive = true
        bottomLine.centerXAnchor.constraint(equalTo: titleText.centerXAnchor).isActive = true
        bottomLine.widthAnchor.constraint(equalTo: titleText.widthAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        tableView.topAnchor.constraint(equalTo: titleText.bottomAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        noConversationsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        noConversationsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noConversationsLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        noConversationsLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/16).isActive = true
    }
    
    private func startListeningConversations(){
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {return}
        let safeEmail = DatabaseManager.safeEmail(email_adress: email)
        DatabaseManager.shared.getAllConversations(for: safeEmail, completion: {[weak self] result in
            switch result {
            case .success(let conversations):
                guard !conversations.isEmpty else {
                    self?.tableView.isHidden = true
                    self?.noConversationsLabel.isHidden = false
                    return
                }
            
            self?.tableView.isHidden = false
            self?.noConversationsLabel.isHidden = true
            self?.conversations = conversations
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            case .failure(let error):
                self?.tableView.isHidden = true
                self?.noConversationsLabel.isHidden = false
                print("faild to get conversations \(error.localizedDescription)")
            }
        })
    }
    
    @objc private func addConversationButtonTapped(){
        let vc = NewConversationViewController()
        vc.completion = {[weak self] result in
            guard let strongSelf = self else {return}
            
            let currentConversations = strongSelf.conversations
            if let targetConversation = currentConversations.first(where: {
                $0.otherUserEmail == DatabaseManager.safeEmail(email_adress: result.email)
            }){
                let vc = ChatViewController(with: targetConversation.otherUserEmail, id: targetConversation.id)
                vc.isNewConversation = false
                vc.modalPresentationStyle = .fullScreen
                vc.titleText.text = targetConversation.name
                strongSelf.present(vc, animated: true)
            }else {
                strongSelf.createNewConversation(result: result)
            }
        }
        present(vc, animated: true)
    }
    
    private func createNewConversation(result: SearchResult ){
        let name = result.name
        let email = DatabaseManager.safeEmail(email_adress: result.email)
        DatabaseManager.shared.conversationExists(with: email, completion: { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let conversationId):
                let vc = ChatViewController(with: email, id: conversationId)
                vc.isNewConversation = false
                vc.modalPresentationStyle = .fullScreen
                vc.titleText.text = name
                strongSelf.present(vc, animated: true)
            case .failure(_):
                let vc = ChatViewController(with: email, id: nil)
                vc.isNewConversation = true
                vc.modalPresentationStyle = .fullScreen
                vc.titleText.text = name
                strongSelf.present(vc, animated: true)
            }
        })
    }
}

extension ConversationViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = conversations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.identifier, for: indexPath) as! ConversationTableViewCell
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = conversations[indexPath.row]
        let vc = ChatViewController(with: model.otherUserEmail, id: model.id)
        vc.titleText.text = model.name
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let conversationId = conversations[indexPath.row].id
            tableView.beginUpdates()
            self.conversations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            DatabaseManager.shared.deleteConversation(conversationId: conversationId, completion: { success in
                if !success {
                        }
                })
            tableView.endUpdates()
        }
    }
    
}
