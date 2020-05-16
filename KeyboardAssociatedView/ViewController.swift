//
//  ViewController.swift
//  KeyboardAssociatedView
//
//  Created by NixonShih on 2020/5/16.
//  Copyright © 2020 NixonShih. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var someInputView = KeyboardAssociatedView()
    private let contentLabel = UILabel()

    override var inputAccessoryView: UIView? { someInputView }
    override var canBecomeFirstResponder: Bool { true }
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
            contentLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25),
            contentLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        someInputView.delegate = self
    }
}

extension ViewController: KeyboardAssociatedViewDelegate {
    
    func keyboardAssociatedView(_ keyboardAssociatedView: KeyboardAssociatedView, didSendWith text: String) {
        contentLabel.text = text
    }
}

protocol KeyboardAssociatedViewDelegate: class {
    func keyboardAssociatedView(_ keyboardAssociatedView: KeyboardAssociatedView, didSendWith text: String)
}

class KeyboardAssociatedView: UIView {
    
    weak var delegate: KeyboardAssociatedViewDelegate?
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        button.backgroundColor = .black
        return button
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize { CGSize.zero }

    override func layoutSubviews() {
        super.layoutSubviews()
        button.layer.cornerRadius = button.bounds.height / 2
    }
        
    private func setup() {
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            textField.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            textField.leftAnchor.constraint(equalTo: leftAnchor, constant: 20)
        ])
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            button.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            button.leftAnchor.constraint(equalTo: textField.rightAnchor, constant: 15),
            button.widthAnchor.constraint(equalToConstant: 74)
        ])
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        autoresizingMask = .flexibleHeight
        button.addTarget(self, action: #selector(buttonDidPressed(_:)), for: .touchUpInside)
    }
    
    @objc
    private func buttonDidPressed(_ sender: UIButton) {
        delegate?.keyboardAssociatedView(self, didSendWith: textField.text ?? "")
        textField.text = nil
        textField.resignFirstResponder()
    }
}
