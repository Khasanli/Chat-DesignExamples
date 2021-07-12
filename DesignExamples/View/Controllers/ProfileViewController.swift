//
//  ProfileViewController.swift
//  DesignExamples
//
//  Created by Samir Hasanli on 02.07.21.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    let topBackView : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1670032779, green: 0.2772738464, blue: 0.4184761433, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let titleText : UILabel = {
        let label = UILabel()
        label.text = "Profile"
        label.textAlignment = .left
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let tableView: UITableView = {
         let tableView = UITableView()
         tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
         return tableView
     }()
    var data = [ProfileViewModel]()
    var imageView : UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "user")
        image.layer.borderWidth = 2
        image.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        image.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        image.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        image.layer.masksToBounds = true
        image.isUserInteractionEnabled = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        data.append(ProfileViewModel(viewModelType: .info, title: "Name: \(UserDefaults.standard.value(forKey: "name") as? String ?? "No name")", handler: nil))
        data.append(ProfileViewModel(viewModelType: .info, title: "Email: \(UserDefaults.standard.value(forKey: "email" ) as? String ?? "No email")", handler: nil))
        data.append(ProfileViewModel(viewModelType: .logout, title: "Log out", handler: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            UserDefaults.standard.setValue(nil, forKey: "email")
            UserDefaults.standard.setValue(nil, forKey: "name")

            let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { _ in
                do {
                    try FirebaseAuth.Auth.auth().signOut()
                    let vc = LoginViewController()
                    vc.modalPresentationStyle = .fullScreen
                    strongSelf.present(vc, animated: true)
                }catch {
                }
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            strongSelf.present(actionSheet, animated: true)
        }))
        view.addSubview(topBackView)
        view.addSubview(titleText)
        view.addSubview(imageView)
        view.addSubview(tableView)
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(changeImageTapped))
        imageView.addGestureRecognizer(imageGesture)
        
        setSubviews()
        getProfileImage()

    }
    
    private func setSubviews() {
        titleText.topAnchor.constraint(equalTo: view.topAnchor, constant: view.height/16).isActive = true
        titleText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.height/32).isActive = true
        titleText.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4).isActive = true
        titleText.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/16).isActive = true
        titleText.font = UIFont(name: "Arial-BoldMT", size: view.height/30)
        
        topBackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topBackView.bottomAnchor.constraint(equalTo: titleText.bottomAnchor).isActive = true
        topBackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topBackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        imageView.topAnchor.constraint(equalTo: topBackView.bottomAnchor, constant: view.height/32).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2).isActive = true
        imageView.layer.cornerRadius = view.frame.size.width/4
        
        tableView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: view.height/32).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/3).isActive = true
    }
    
    func getProfileImage() {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            print("here")
            return}
        let safeEmail = DatabaseManager.safeEmail(email_adress: email)
        let filename = safeEmail + "_profile.png"
        let path = "images/" + filename
        
        StorageManager.shared.downloadURL(for: path, completion: { [weak self]
            result in
            switch result {
            case .success(let url):
                self?.downloadImage(url: url)
            case .failure(let err):
                print(err.localizedDescription)
            }
        })
    }
    
    private func downloadImage(url: URL) {
        imageView.sd_setImage(with: url, completed: nil)
        URLSession.shared.dataTask(with: url, completionHandler: { data, _, err in
            guard let data = data, err == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.imageView.image = image
            }
        }).resume()
    }
    
    @objc private func changeImageTapped(){
        presentPhotoActionSheet()
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture", message: "Dou want to take picture or choose one?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        self.imageView.image = selectedImage
        let email = UserDefaults.standard.value(forKey: "email") as! String
        let safeEmail = DatabaseManager.safeEmail(email_adress: email)
        StorageManager.shared.updateProfilePhoto(filename: "\(safeEmail)_profile.png") { result in
            switch result {
            case .success(let success):
                if success {
                    guard let data = selectedImage.pngData() else {
                        return
                    }
                    StorageManager.shared.uploadProfilePhoto(with: data, filename: "\(safeEmail)_profile.png") { result in
                        switch result {
                        case .success(let downloadURL):
                            UserDefaults.standard.set(downloadURL, forKey: "profile_picture_url")
                            print(downloadURL)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                    self.getProfileImage()
                }
            case .failure(let error):
                print("failed to deleteimage: \(error.localizedDescription)")
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
        cell.setUp(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.row].handler?()
    }
}
class ProfileTableViewCell: UITableViewCell {
    static let identifier  = "ProfileTabelViewCell"
    public func setUp(with viewModel: ProfileViewModel) {
        
        self.textLabel?.text = viewModel.title
        self.backgroundColor = .white
        switch viewModel.viewModelType {
        case .info:
            self.textLabel?.textAlignment = .left
            self.textLabel?.textColor = .black
        case .logout:
            self.textLabel?.textColor = .systemPink
            self.textLabel?.textAlignment = .center
        }
    }
}
