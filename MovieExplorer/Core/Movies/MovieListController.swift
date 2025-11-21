//
//  ViewController.swift
//  MovieExplorer
//
//  Created by Ekbana on 18/11/2025.
//

import UIKit
import Combine

class MovieListController: UIViewController {

    //MARK: UI Properties
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

    private lazy var resultsVC: UINavigationController = {
        return UINavigationController(rootViewController: SearchController())
    }()

    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: resultsVC)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search"
        return controller
    }()


    //MARK: Data Properties
    private let movieViewModel = MovieViewModel(movieService: MovieService())
    private let searchViewModel = SearchViewModel.shared
    private var cancellables = Set<AnyCancellable>()
    private var currentFilter: FiltersModel? = FiltersModel.data.first { $0.isSelected }
    private var debounceTimer: Timer?

    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setNavBar()
        movieViewModel.fetchMovies(filter: currentFilter?.key ?? Constants.popularKey)
        observeChanges()
        setupNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //MARK: Functions
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

    private func setNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Movies"
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal.decrease.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(onFilterPressed)
        )

        navigationItem.searchController = searchController
        definesPresentationContext = true
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
        
        movieViewModel.$error
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self else { return }
                
                if !self.movieViewModel.movies.isEmpty && error is NetworkError {
                    return
                }
                
                self.showError(error) { [weak self] in
                    self?.movieViewModel.retryLastOperation()
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleOfflineMode),
            name: .useOfflineMode,
            object: nil
        )
    }
    
    @objc private func handleOfflineMode() {
        Task {
            await MainActor.run {
                if self.movieViewModel.movies.isEmpty {
                    self.showError(NetworkError.noData)
                }
            }
        }
    }

    @objc
    func onFilterPressed() {
        let filterVC = FilterController(currentFilter: currentFilter)
        filterVC.onFilterSelected = { [weak self] selectedFilter in
            guard let self else { return }
            if self.currentFilter?.key != selectedFilter.key {
                self.currentFilter = selectedFilter
                
                guard NetworkMonitor.shared.isConnected else {
                    self.showError(NetworkError.filterError(selectedFilter.title))
                    return
                }
                
                self.movieViewModel.resetPagination()
                self.movieViewModel.fetchMovies(filter: selectedFilter.key)
            }
        }

        if let sheet = filterVC.sheetPresentationController {
            sheet.detents = [UISheetPresentationController.Detent.custom(resolver: { context in
                155
            })]
        }
        self.present(filterVC, animated: true)
    }
}

//MARK: Extensions
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
            
            guard NetworkMonitor.shared.isConnected else {
                return
            }
            
            movieViewModel.fetchMovies(filter: currentFilter?.key ?? Constants.popularKey)
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

extension MovieListController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchViewModel.searchText = searchController.searchBar.text ?? ""
    }
}
