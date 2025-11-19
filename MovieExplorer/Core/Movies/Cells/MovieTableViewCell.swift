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
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var subTitleLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var movieImageView:UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .systemGray5
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 16
        imgView.clipsToBounds = true
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

    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.cancelImageLoad()
    }

    private func setUp() {
        selectionStyle = .none
        contentView.addSubview(movieImageView)
        contentView.addSubview(labelsStackView)
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(subTitleLabel)

        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 8),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 8),
            movieImageView.widthAnchor.constraint(equalToConstant: 150),

            labelsStackView.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor,constant: 8),
            labelsStackView.centerYAnchor.constraint(equalTo: movieImageView.centerYAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -8)
        ])
    }

    func config(image: String, title: String, subTitle: String) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
        movieImageView.loadImage(from: image)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
