//
//  RadioButton.swift
//  MovieExplorer
//
//  Created by Ekbana on 20/11/2025.
//

import UIKit

class RadioButton: UIButton {
    var alternateButton:Array<RadioButton>?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.masksToBounds = true
        self.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func unselectAlternateButtons() {
        if alternateButton != nil {
            self.isSelected = true
            for aButton:RadioButton in alternateButton! {
                aButton.isSelected = false
            }
        } else {
            toggleButton()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        unselectAlternateButtons()
        super.touchesBegan(touches, with: event)
    }

    func toggleButton() {
        self.isSelected = !isSelected
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundColor = .systemRed
            } else {
                self.backgroundColor = .clear
            }
        }
    }
}

#Preview {
    RadioButton()
}
