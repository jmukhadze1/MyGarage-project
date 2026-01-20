//
//  FormTextFieldView.swift
//  MyGarage
//
//  Created by David on 20.01.26.
//

import UIKit

final class FormTextFieldView: UIView {

    private let titleLabel = UILabel()
    private let textField = UITextField()

    var text: String {
        get { textField.text ?? "" }
        set { textField.text = newValue }
    }

    init(title: String, placeholder: String, keyboard: UIKeyboardType = .default) {
        super.init(frame: .zero)

        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        titleLabel.textColor = .secondaryLabel

        textField.placeholder = placeholder
        textField.keyboardType = keyboard
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.secondarySystemBackground
        textField.layer.cornerRadius = 12
        textField.setLeftPadding(12)
        textField.heightAnchor.constraint(equalToConstant: 48).isActive = true

        let stack = UIStackView(arrangedSubviews: [titleLabel, textField])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

private extension UITextField {
    func setLeftPadding(_ value: CGFloat) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: value, height: 1))
        leftView = view
        leftViewMode = .always
    }
}
