//
//  ConversationTableViewCell.swift
//  DesignExamples
//
//  Created by Samir Hasanli on 08.07.21.
//

import UIKit
import SDWebImage

class ConversationTableViewCell: UITableViewCell {
    static let identifier = "ConversationTableViewCell"
    
    private let userImageView : UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        imageview.contentMode = .scaleAspectFill
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.layer.masksToBounds = true
        return imageview
    }()
    
    private let userNameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userMessageLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userMessageLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        userImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        userImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 2/3).isActive = true
        userImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 2/3).isActive = true
        userImageView.layer.cornerRadius = contentView.height/4
        
        userNameLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        userNameLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 10).isActive = true
        userNameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1/3).isActive = true
        userNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 2/3).isActive = true
        
        
        userMessageLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor).isActive = true
        userMessageLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 10).isActive = true
        userMessageLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1/3).isActive = true
        userMessageLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 2/3).isActive = true

    }

    public func configure(with model: Conversation){
        self.userNameLabel.text = model.name
        self.userMessageLabel.text = model.latestMessage.text
        
        let path = "images/\(model.otherUserEmail)_profile.png"
        StorageManager.shared.downloadURL(for: path, completion: {[weak self] result in
            switch result {
            case .success(let url):
                DispatchQueue.main.async {
                    self?.userImageView.sd_setImage(with: url, completed: nil)
                }
            case .failure(let err):
                print("failed to load image for conersations \(err.localizedDescription)")
            }
            
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
