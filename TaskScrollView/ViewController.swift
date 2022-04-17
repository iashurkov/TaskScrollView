//
//  ViewController.swift
//  TaskScrollView
//
//  Created by Igor Ashurkov on 22.03.2022.
//

import UIKit

class ViewController: UIViewController {
    
    
    // MARK: - Public structures
    
    enum Constants {
        static let logoViewHeight: CGFloat = 48
        
        static let textFieldBackgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        static let textFieldCornerRadius: CGFloat = 8
        static let textFieldBorderWidth: CGFloat = 1
        static let textFieldBorderColor = #colorLiteral(red: 0.7647058824, green: 0.7647058824, blue: 0.7647058824, alpha: 1).cgColor
        
        static let logoViewInsets = UIEdgeInsets(top: -119, left: 32, bottom: 0, right: -32)
        
        static let loginTextFielHeight: CGFloat = 50
        static let loginTextFieldInsets = UIEdgeInsets(top: 16, left: 32, bottom: 0, right: -32)
        
        static let passwordTextFielHeight: CGFloat = 50
        static let passwordTextFieldInsets = UIEdgeInsets(top: 8, left: 32, bottom: 0, right: -32)
        
        static let buttonBackgroundColor = #colorLiteral(red: 0, green: 0.4666666667, blue: 1, alpha: 1)
        static let buttonCornerRadius: CGFloat = 8
        static let buttonTintColor = UIColor.white
        
        static let loginButtonHeight: CGFloat = 50
        static let loginButtonInsets = UIEdgeInsets(top: 16, left: 32, bottom: 0, right: -32)
    }
    
    enum Texts {
        static let loginTitle = "Email or phone"
        static let passwordTitle = "Password"
        static let buttonTitle = "Log In"
    }
    
    
    // MARK: - Private properties
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var logoView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.init(named: "VKLogo")
        
        return imageView
    }()
    
    private lazy var loginTextField: TextField = {
        let textField = TextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = Constants.textFieldBackgroundColor
        textField.layer.cornerRadius = Constants.textFieldCornerRadius
        textField.layer.borderWidth = Constants.textFieldBorderWidth
        textField.layer.borderColor = Constants.textFieldBorderColor
        textField.delegate = self
        textField.tag = 0
        textField.placeholder = Texts.loginTitle
        
        return textField
    }()
    
    private lazy var passwordTextField: TextField = {
        let textField = TextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = Constants.textFieldBackgroundColor
        textField.layer.cornerRadius = Constants.textFieldCornerRadius
        textField.layer.borderWidth = Constants.textFieldBorderWidth
        textField.layer.borderColor = Constants.textFieldBorderColor
        textField.delegate = self
        textField.tag = 1
        textField.placeholder = Texts.passwordTitle
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Constants.buttonBackgroundColor
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.tintColor = Constants.buttonTintColor
        button.setTitle(Texts.buttonTitle, for: .normal)
        button.addTarget(self, action: #selector(self.didTapLogInButton), for: .touchUpInside)
        
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.draft()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didShowKeyboard(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didHideKeyboard(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    
    // MARK: - Private methods
    
    private func draft() {
        self.view.addSubview(self.scrollView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.forcedHideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        self.scrollView.addSubview(self.logoView)
        self.scrollView.addSubview(self.loginTextField)
        self.scrollView.addSubview(self.passwordTextField)
        self.scrollView.addSubview(self.loginButton)
        
        let constraintsForScrollView = self.constraintsForScrollView()
        let constraintsForLogoView = self.constraintsForLogoView()
        let constraintsForLoginTextField = self.constraintsForLoginTextField()
        let constraintsForPasswordTextField = self.constraintsForPasswordTextField()
        let constraintsForLoginButton = self.constraintsForLoginButton()
        
        NSLayoutConstraint.activate(
            constraintsForScrollView +
            constraintsForLogoView +
            constraintsForLoginTextField +
            constraintsForPasswordTextField +
            constraintsForLoginButton
        )
    }
    
    private func constraintsForScrollView() -> [NSLayoutConstraint] {
        let topAnchor = self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor)
        let trailingAnchor = self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        let leadingAnchor = self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let bottomAnchor = self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        
        return [
            topAnchor,
            trailingAnchor,
            leadingAnchor,
            bottomAnchor
        ]
    }
    
    private func constraintsForLogoView() -> [NSLayoutConstraint] {
        let centerYAnchor = self.logoView.centerYAnchor.constraint(equalTo: self.scrollView.centerYAnchor, constant: Constants.logoViewInsets.top)
        let trailingAnchor = self.logoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: Constants.logoViewInsets.right)
        let leadingAnchor = self.logoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.logoViewInsets.left)
        let heightAnchor = self.logoView.heightAnchor.constraint(equalToConstant: Constants.logoViewHeight)
        
        return [
            centerYAnchor,
            trailingAnchor,
            leadingAnchor,
            heightAnchor
        ]
    }
    
    private func constraintsForLoginTextField() -> [NSLayoutConstraint] {
        let topAnchor = self.loginTextField.topAnchor.constraint(equalTo: self.logoView.bottomAnchor, constant: Constants.loginTextFieldInsets.top)
        let heightAnchor = self.loginTextField.heightAnchor.constraint(equalToConstant: Constants.loginTextFielHeight)
        let trailingAnchor = self.loginTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: Constants.loginTextFieldInsets.right)
        let leadingAnchor = self.loginTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.loginTextFieldInsets.left)
        
        return [
            topAnchor,
            heightAnchor,
            trailingAnchor,
            leadingAnchor
        ]
    }
    
    private func constraintsForPasswordTextField() -> [NSLayoutConstraint] {
        let topAnchor = self.passwordTextField.topAnchor.constraint(equalTo: self.loginTextField.bottomAnchor, constant: Constants.passwordTextFieldInsets.top)
        let heightAnchor = self.passwordTextField.heightAnchor.constraint(equalToConstant: Constants.passwordTextFielHeight)
        let trailingAnchor = self.passwordTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: Constants.passwordTextFieldInsets.right)
        let leadingAnchor = self.passwordTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.passwordTextFieldInsets.left)
        
        return [
            topAnchor,
            heightAnchor,
            trailingAnchor,
            leadingAnchor
        ]
    }
    
    private func constraintsForLoginButton() -> [NSLayoutConstraint] {
        let topAnchor = self.loginButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: Constants.loginButtonInsets.top)
        let heightAnchor = self.loginButton.heightAnchor.constraint(equalToConstant: Constants.loginButtonHeight)
        let trailingAnchor = self.loginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: Constants.loginButtonInsets.right)
        let leadingAnchor = self.loginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.loginButtonInsets.left)
        
        return [
            topAnchor,
            heightAnchor,
            trailingAnchor,
            leadingAnchor
        ]
    }
    
    @objc private func didShowKeyboard(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let loginButtonOffset = self.loginButton.frame.origin.y + Constants.loginButtonHeight
            let keyboardOffset = self.view.frame.height - keyboardHeight
            
            let yOffset = keyboardOffset < loginButtonOffset
                ? (loginButtonOffset - keyboardHeight) / 4
                : 0
            
            print("🍏 \(yOffset)")
            self.scrollView.contentOffset = CGPoint(x: 0, y: yOffset)
        }
    }
    
    @objc private func didHideKeyboard(_ notification: Notification) {
        self.forcedHideKeyboard()
    }
    
    @objc private func forcedHideKeyboard() {
        self.view.endEditing(true)
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @objc private func didTapLogInButton() {
        self.forcedHideKeyboard()
        
        let login = self.loginTextField.text ?? ""
        let password = self.passwordTextField.text ?? ""
        
        print("User enter login: \(login) and password: \(password)")
    }
}


// MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    
}
