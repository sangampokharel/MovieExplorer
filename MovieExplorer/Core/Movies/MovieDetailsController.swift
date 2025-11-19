//
//  MovieDetailsController.swift
//  MovieExplorer
//
//  Created by Ekbana on 18/11/2025.
//

import UIKit
import Combine

class MovieDetailsController: UIViewController {

    private lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints =  false
        return view
    }()

    private lazy var imgView:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18,weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var activityIndicator:UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    private lazy var subTitleLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18,weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let movieViewModel = MovieViewModel()
    private var cancellables = Set<AnyCancellable>()


    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        movieViewModel.fetchMovieDetail(id: UUID().uuidString)
        observe()
    }

    private func observe() {
        movieViewModel
            .$movie
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self, let value else {return}
                self.config(movie: value)
            }.store(in: &cancellables)

        movieViewModel.$isLoading
            .receive(on: DispatchQueue.main).sink { [weak self] value in
                guard let self, let value else {return}
                if value {
                    self.activityIndicator.startAnimating()
                }else{
                    self.activityIndicator.stopAnimating()
                }

            }.store(in: &cancellables)
    }

    private func setUp() {
        navigationController?.navigationItem.backButtonTitle = "Back"
        view.backgroundColor = .systemBackground
        view.addSubview(activityIndicator)
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(imgView)
        containerView.addSubview(labelStackView)
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(subTitleLabel)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: imgView.bottomAnchor,constant: 16),

            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            imgView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imgView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imgView.heightAnchor.constraint(equalToConstant: 200),

            labelStackView.topAnchor.constraint(equalTo: imgView.bottomAnchor,constant: 4),
            labelStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 16),
            labelStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -16),
            labelStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }

    private func config(movie:MovieModel) {
        titleLabel.text = movie.movieName
        subTitleLabel.text = movie.movieDescription
        imgView.loadImage(from: movie.imageUrl)
        title = movie.movieName
    }
}

#Preview {
    MovieDetailsController()
}
