//
//  SearchController.swift
//  MovieExplorer
//
//  Created by Ekbana on 20/11/2025.
//

import UIKit
import Combine

class SearchController: UIViewController {

    private lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var indicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    private let searchViewModel = SearchViewModel(service: SearchService())
    private var cancellables = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        searchViewModel.search(query: "Frank")
    }

    private func setUp() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(indicator)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func observe() {
        searchViewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self else { return }
                if let value {
                    if value {
                        self.indicator.startAnimating()
                    }else{
                        self.indicator.stopAnimating()
                    }
                }
            }.store(in: &cancellables)

        searchViewModel.$moviesSearchList.receive(on: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self else {return}
                self.tableView.reloadData()
            }.store(in: &cancellables)
    }
}

extension SearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.moviesSearchList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let name = searchViewModel.moviesSearchList[indexPath.row].movieName
        let overview = searchViewModel.moviesSearchList[indexPath.row].movieDescription
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = overview
        return cell
    }
}

extension SearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movieDetailsVC = MovieDetailsController()
        movieDetailsVC.movieId = searchViewModel.moviesSearchList[indexPath.row].id
        navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
}
