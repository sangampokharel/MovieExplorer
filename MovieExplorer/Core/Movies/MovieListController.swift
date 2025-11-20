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

    private lazy var footerSpinner: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    private lazy var footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
        view.addSubview(footerSpinner)
        footerSpinner.center = view.center
        return view
    }()

    private let movieViewModel = MovieViewModel(movieService: MovieService())
    private var cancellables = Set<AnyCancellable>()
    private var currentFilter: Filters?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setNavBar()
        movieViewModel.fetchMovies()
        observeChanges()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
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
        title = "Movies"
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal.decrease.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(onFilterPressed)
        )
    }

    private func observeChanges() {
        movieViewModel
            .$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.tableView.reloadData()
            }.store(in: &cancellables)

        movieViewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }

                if movieViewModel.page == 1 {
                    if isLoading == true {
                        self.activityIndicator.startAnimating()
                    } else {
                        self.activityIndicator.stopAnimating()
                    }
                }
            }.store(in: &cancellables)

        movieViewModel.$isPaginating
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isPaginating in
                guard let self else { return }

                if isPaginating == true {
                    self.footerSpinner.startAnimating()
                    self.tableView.tableFooterView = self.footerView
                } else {
                    self.footerSpinner.stopAnimating()
                    self.tableView.tableFooterView = nil
                }
            }.store(in: &cancellables)
    }

    @objc
    func onFilterPressed() {
        let filterVC = FilterController()
        filterVC.onFilterSelected = { [weak self] selectedFilter in
            guard let self else { return }

            if self.currentFilter?.key != selectedFilter.key {
                self.currentFilter = selectedFilter
                print("Filter changed to: \(selectedFilter.title) with key: \(selectedFilter.key)")
                self.movieViewModel.resetPagination()
                self.movieViewModel.fetchMovies(filter: currentFilter?.key ?? Constants.popularKey)
            }
        }

        if let sheet = filterVC.sheetPresentationController {
            sheet.detents = [UISheetPresentationController.Detent.custom(resolver: { context in
                150
            })]
        }
        self.present(filterVC, animated: true)
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

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let threshold = movieViewModel.movies.count - 3
        if indexPath.row >= max(threshold, 0) && !movieViewModel.isPaginating && movieViewModel.hasMorePages {
            movieViewModel.fetchMovies()
        }
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
