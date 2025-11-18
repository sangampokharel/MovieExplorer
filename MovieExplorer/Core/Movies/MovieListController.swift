//
//  ViewController.swift
//  MovieExplorer
//
//  Created by Ekbana on 18/11/2025.
//

import UIKit

class MovieListController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Movie Explorer"
        setupUI()
    }

    private func setupUI() {
        // Add your UI elements here
        let label = UILabel()
        label.text = "Welcome to Movie Explorer"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
