//
//  MovieTableViewCell.swift
//  MovieExplorer
//
//  Created by Ekbana on 18/11/2025.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    static let identifier = Constants.movieTableViewCell

    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "This is title Label"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var subTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. "
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var movieImageView:UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "photo.artframe")
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {
        selectionStyle = .none
        contentView.addSubview(movieImageView)
        contentView.addSubview(labelsStackView)
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(subTitleLabel)

        NSLayoutConstraint.activate([
            movieImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            movieImageView.widthAnchor.constraint(equalToConstant: 150),
            movieImageView.heightAnchor.constraint(equalToConstant: 100),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            labelsStackView.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor,constant: 8),
            labelsStackView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 8),
            labelsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -8),
            labelsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -8)
        ])
    }



    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
