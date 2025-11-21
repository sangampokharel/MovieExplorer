//
//  SearchController.swift
//  MovieExplorer
//
//  Created by Ekbana on 20/11/2025.
//

import UIKit
import Combine

class SearchController: UIViewController {

    private let searchViewModel = SearchViewModel.shared
    private var cancellables = Set<AnyCancellable>()
    private var moviesSearchList: [MovieModel] = []
    private var isLoading: Bool = false
    private var currentQuery: String = ""

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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        observeViewModel()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
    }

    private func observeViewModel() {
        searchViewModel.$moviesSearchList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                guard let self = self else { return }
                self.moviesSearchList = movies
                self.tableView.reloadData()
            }
            .store(in: &cancellables)

        searchViewModel.$isLoading
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                self.isLoading = isLoading
                if isLoading {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        searchViewModel.$error
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self = self else { return }
                if self.moviesSearchList.isEmpty {
                    self.showError(error) { [weak self] in
                        self?.searchViewModel.retryLastSearch(query: self?.currentQuery ?? "")
                    }
                }
            }
            .store(in: &cancellables)
    }

    func searchMovies(query: String) {
        currentQuery = query
        searchViewModel.search(query: query)
    }

    func clearSearchResults() {
        searchViewModel.clearResults()
    }
}

extension SearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesSearchList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        let movie = moviesSearchList[indexPath.row]
        cell.config(image: movie.imageUrl, title: movie.movieName, subTitle: movie.movieDescription)
        return cell
    }
}

extension SearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailsVC = MovieDetailsController()
        movieDetailsVC.movieId = moviesSearchList[indexPath.row].id
        if let navigationController = self.navigationController {
            navigationController.pushViewController(movieDetailsVC, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
