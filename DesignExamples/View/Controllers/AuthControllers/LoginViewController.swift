//
//  LoginViewController.swift
//  DesignExamples
//
//  Created by Samir Hasanli on 02.07.21.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class LoginViewController: UIViewController {
    private let spinner = JGProgressHUD(style: .light)

    let titleText : UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.textAlignment = .left
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    let loginButton:  UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.1670032779, green: 0.2772738464, blue: 0.4184761433, alpha: 1)
        button.layer.borderWidth = 2
        button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let registerButton:  UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1670032779, green: 0.2772738464, blue: 0.4184761433, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let colorTop = #colorLiteral(red: 0.1670032779, green: 0.2772738464, blue: 0.4184761433, alpha: 1).cgColor
        let colorBottom = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor

        let loginGradientBackgroundColor = CAGradientLayer()
        loginGradientBackgroundColor.frame = view.bounds
        loginGradientBackgroundColor.colors = [colorTop, colorBottom]
        view.layer.addSublayer(loginGradientBackgroundColor)
        
        view.addSubview(titleText)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        setSubviews()
    }
    
    private func setSubviews(){
        titleText.topAnchor.constraint(equalTo: view.topAnchor, constant: view.height/16).isActive = true
        titleText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleText.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4).isActive = true
        titleText.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/16).isActive = true
        titleText.font = UIFont(name: "Arial-BoldMT", size: view.height/32)
        
        emailField.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: view.height/32).isActive = true
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

        loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: view.height/32).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5).isActive = true
        loginButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/16).isActive = true
        loginButton.layer.cornerRadius = view.height/32

        registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: view.height/64).isActive = true
        registerButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4).isActive = true
        registerButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/16).isActive = true
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    @objc private func loginButtonTapped(){
        if emailField.text?.count ?? 0 < 6 {
            emailField.shakeAnimated()
        } else {
            if passwordField.text?.count ?? 0 < 6 {
                passwordField.shakeAnimated()
            } else {
                guard let email = emailField.text else {return}
                guard let password = passwordField.text else {return}

                spinner.show(in: view)
                FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) {[weak self] result, err in
                    guard let strongSelf = self else {return}
                    
                    DispatchQueue.main.async {
                        strongSelf.spinner.dismiss()
                    }
                    guard result != nil, err == nil else {
                        print("failed to login")
                        return
                    }
                    
                    let safeEmail = DatabaseManager.safeEmail(email_adress: email)
                    
                    DatabaseManager.shared.getDataFor(path: safeEmail) { result in
                        switch result{
                        case .success(let data):
                            guard let userData = data as? [String: Any],
                                  let firstname = userData["first_name"] as? String,
                                  let lastname = userData["last_name"] as? String else {return}
                            UserDefaults.standard.set("\(firstname) \(lastname)", forKey: "name")
                        case .failure(let err):
                            print("Failed to read the data: \(err.localizedDescription)")
                        }
                    }
                    UserDefaults.standard.set(safeEmail, forKey: "email")
                    
                    let vc = MainViewController()
                    vc.modalPresentationStyle = .fullScreen
                    strongSelf.present(vc, animated: false)
                }
            }
        }
    }
    
    @objc private func registerButtonTapped(){
        let vc = RegisterViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
    func alertUserLoginError(){
        let alert = UIAlertController(title: "User not Found", message: "Please, enter correct email and password!!!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField{
            passwordField.becomeFirstResponder()
        }
        
        else if textField == passwordField{
            loginButtonTapped()
        }
        return true
    }
}
