//
//  FilterController.swift
//  MovieExplorer
//
//  Created by Ekbana on 20/11/2025.
//

import UIKit

class FilterController: UIViewController {

    private lazy var rootStackView:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var filterLabel: UILabel = {
        let label = UILabel()
        label.text = "Filters"
        label.font = .systemFont(ofSize: 24,weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var filters: [FiltersModel] = []

    private var radioButtons: [RadioButton] = []

    private(set) var selectedFilter: FiltersModel?
    
    var onFilterSelected: ((FiltersModel) -> Void)?
    
    init(currentFilter: FiltersModel? = nil) {
        super.init(nibName: nil, bundle: nil)
        setupFilters(with: currentFilter)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupFilters(with currentFilter: FiltersModel?) {
        filters = FiltersModel.data.map { filter in
            let isSelected = currentFilter?.key == filter.key
            return FiltersModel(title: filter.title, isSelected: isSelected, key: filter.key)
        }
        selectedFilter = filters.first { $0.isSelected } ?? filters.first
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let selectedFilter = selectedFilter {
            onFilterSelected?(selectedFilter)
        }
    }

    private func setUp() {
        view.backgroundColor = .systemBackground
        view.addSubview(filterLabel)
        view.addSubview(rootStackView)

        filters.enumerated().forEach { index, item in

            let label = UILabel()
            label.text = item.title.capitalized
            label.font = .systemFont(ofSize: 20, weight: .medium)

            let radioBtn = RadioButton()
            radioBtn.isSelected = item.isSelected
            radioBtn.tag = index
            radioBtn.widthAnchor.constraint(equalToConstant: 24).isActive = true
            radioBtn.heightAnchor.constraint(equalToConstant: 24).isActive = true
            radioBtn.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)

            radioButtons.append(radioBtn)

            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillProportionally
            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(radioBtn)
            rootStackView.addArrangedSubview(stackView)
        }

        radioButtons.forEach { button in
            button.alternateButton = radioButtons.filter { $0 != button }
        }

        NSLayoutConstraint.activate([
            filterLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 16),
            filterLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 16),
            filterLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            rootStackView.topAnchor.constraint(equalTo: filterLabel.bottomAnchor,constant: 8),
            rootStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 16),
            rootStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -16),
        ])
    }

    @objc private func radioButtonTapped(_ sender: RadioButton) {
        let selectedIndex = sender.tag
        selectedFilter = filters[selectedIndex]
    }

    func getCurrentFilter() -> FiltersModel? {
        return selectedFilter
    }
}
