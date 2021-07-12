//
//  RegisterViewController.swift
//  DesignExamples
//
//  Created by Samir Hasanli on 02.07.21.
//
import Foundation
import UIKit
import FirebaseAuth
import JGProgressHUD

class RegisterViewController: UIViewController {
    private let spinner = JGProgressHUD(style: .light)

    let profileImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "user")
        return image
    }()
    
    let titleText : UILabel = {
        let label = UILabel()
        label.text = "Register"
        label.textAlignment = .left
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let firstNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.placeholder = "First Name"
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.textColor = #colorLiteral(red: 0.1670032779, green: 0.2772738464, blue: 0.4184761433, alpha: 1)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    let lastNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.placeholder = "Last Name"
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.textColor = #colorLiteral(red: 0.1670032779, green: 0.2772738464, blue: 0.4184761433, alpha: 1)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.placeholder = "Email"
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.textColor = #colorLiteral(red: 0.1670032779, green: 0.2772738464, blue: 0.4184761433, alpha: 1)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.placeholder = "Password"
        field.leftViewMode = .always
        field.textColor = #colorLiteral(red: 0.1670032779, green: 0.2772738464, blue: 0.4184761433, alpha: 1)
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    let registerButton:  UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.1670032779, green: 0.2772738464, blue: 0.4184761433, alpha: 1)
        button.layer.borderWidth = 2
        button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let loginButton:  UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1670032779, green: 0.2772738464, blue: 0.4184761433, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let registerGradientBackgroundColor = CAGradientLayer()
        let colorTop = #colorLiteral(red: 0.1670032779, green: 0.2772738464, blue: 0.4184761433, alpha: 1).cgColor
        let colorBottom = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor

        registerGradientBackgroundColor.frame = view.bounds
        registerGradientBackgroundColor.colors = [colorTop, colorBottom]
        view.layer.addSublayer(registerGradientBackgroundColor)
        
        view.addSubview(titleText)
        view.addSubview(firstNameField)
        view.addSubview(lastNameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(registerButton)
        view.addSubview(loginButton)
        setSubviews()
    }
    
    private func setSubviews(){
        titleText.topAnchor.constraint(equalTo: view.topAnchor, constant: view.height/16).isActive = true
        titleText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleText.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4).isActive = true
        titleText.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/16).isActive = true
        titleText.font = UIFont(name: "Arial-BoldMT", size: view.height/32)
        
        firstNameField.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: view.height/32).isActive = true
        firstNameField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        firstNameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5).isActive = true
        firstNameField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/16).isActive = true
        firstNameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        firstNameField.layer.cornerRadius = view.height/32
        
        lastNameField.topAnchor.constraint(equalTo: firstNameField.bottomAnchor, constant: view.height/32).isActive = true
        lastNameField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lastNameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5).isActive = true
        lastNameField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/16).isActive = true
        lastNameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        lastNameField.layer.cornerRadius = view.height/32
        
        emailField.topAnchor.constraint(equalTo: lastNameField.bottomAnchor, constant: view.height/32).isActive = true
        emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5).isActive = true
        emailField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/16).isActive = true
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        emailField.layer.cornerRadius = view.height/32

        passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: view.height/32).isActive = true
        passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5).isActive = true
        passwordField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/16).isActive = true
        passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        passwordField.layer.cornerRadius = view.height/32

        registerButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: view.height/32).isActive = true
        registerButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5).isActive = true
        registerButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/16).isActive = true
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.layer.cornerRadius = view.height/32

        loginButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: view.height/64).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4).isActive = true
        loginButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/16).isActive = true
        
    }
    
    @objc private func registerButtonTapped(){
        
        if firstNameField.text?.count ?? 0 < 6 {
            firstNameField.shakeAnimated()
        } else {
            if lastNameField.text?.count ?? 0 < 6 {
                lastNameField.shakeAnimated()
            } else {
                if emailField.text?.count ?? 0 < 6 {
                emailField.shakeAnimated()
                } else {
                    if passwordField.text?.count ?? 0 < 6 {
                    passwordField.shakeAnimated()
                    } else {
                        guard let firstname = self.firstNameField.text else {return}
                        guard let lastname = self.lastNameField.text else {return}
                        guard let password = self.passwordField.text else {return}
                        guard let email = self.emailField.text else {return}
                        
                        spinner.show(in: view)
                        let safeEmail = DatabaseManager.safeEmail(email_adress: email)
                        UserDefaults.standard.set(safeEmail, forKey: "email")
                        
                        UserDefaults.standard.setValue("\(firstname) \(lastname)", forKey: "name")

                        DatabaseManager.shared.userExists(with: email) { [weak self] exist in
                            guard let strongSelf = self else {
                                return
                            }
                            DispatchQueue.main.async {
                                strongSelf.spinner.dismiss()
                            }
                            guard !exist else {
                                strongSelf.alertUserRegisterError(message: "This email adress is used already. Please, try with another email adress!")
                                return
                            }
                            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { result, err in
                                guard result != nil, err == nil else {
                                    strongSelf.alertUserRegisterError(message: "This email adress is used already. Please, try with another email adress!")
                                    return
                                }
                                let chatUser = ChatAppUser(first_name: firstname, last_name: lastname, email_adress: email)
                                DatabaseManager.shared.insertUser(with: chatUser) { success in
                                    if success {
                                        guard let image = strongSelf.profileImage.image, let data = image.pngData() else {
                                            return
                                        }
                                        let fileName = chatUser.profileImageFileName
                                        StorageManager.shared.uploadProfilePhoto(with: data, filename: fileName) { result in
                                            switch result {
                                            case .success(let downloadURL):
                                                UserDefaults.standard.set(downloadURL, forKey: "profile_picture_url")
                                                print(downloadURL)
                                            case .failure(let error):
                                                print(error.localizedDescription)
                                            }
                                        }
                                    }
                                }
                            
                                let vc = MainViewController()
                                vc.modalPresentationStyle = .fullScreen
                                strongSelf.present(vc, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc private func loginButtonTapped(){
        let vc = LoginViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
    
    func alertUserRegisterError(message: String){
        let alert = UIAlertController(title: "Could not register!!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
