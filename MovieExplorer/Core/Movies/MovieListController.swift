//
//  ViewController.swift
//  MovieExplorer
//
//  Created by Ekbana on 18/11/2025.
//

import UIKit
import Combine

class MovieListController: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.separatorInset = .zero
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()


    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    private let movieViewModel = MovieViewModel(movieService: MovieService())
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setNavBar()
        movieViewModel.fetchMovies()
        observeChanges()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Movies"
        view.addSubview(tableView)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
    }

    private func setNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func observeChanges() {
        movieViewModel
            .$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                guard let self else {return}
                self.tableView.reloadData()
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
}

extension MovieListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieViewModel.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        let movie = movieViewModel.movies[indexPath.row]
        cell.config(image: movie.imageUrl, title: movie.movieName, subTitle: movie.movieDescription)
        return cell
    }
}

extension MovieListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailsVC = MovieDetailsController()
        movieDetailsVC.movieId = self.movieViewModel.movies[indexPath.row].id
        navigationController?.pushViewController(movieDetailsVC, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
