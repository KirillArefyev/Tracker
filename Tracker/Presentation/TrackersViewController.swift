//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 07.04.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    // MARK: - Private Properties
    private var categories: [TrackerCategory] = []
    private var completedTrakers: [TrackerRecord] = []
    private var currentDate = Date()
    
    private lazy var noTrackersImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Star")
        return imageView
    }()
    
    private lazy var noTrakersText: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .trBlack
        label.textAlignment = .center
        return label
    }()
    
    private lazy var noTrackersStub: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8.0
        [noTrackersImage,
         noTrakersText].forEach { stackView.addArrangedSubview($0) }
        stackView.isHidden = true
        return stackView
    }()
    
    private lazy var errorImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Error")
        return imageView
    }()
    
    private lazy var errorText: UILabel = {
        let label = UILabel()
        label.text = "Ничего не найдено"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .trBlack
        label.textAlignment = .center
        return label
    }()
    
    private lazy var errorStub: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8.0
        [errorImage,
         errorText].forEach { stackView.addArrangedSubview($0) }
        stackView.isHidden = true
        return stackView
    }()
    
    private lazy var addTrackerButton: UIBarButtonItem = {
        let addTrackerButton = UIBarButtonItem(image: UIImage(systemName: "plus")?.applyingSymbolConfiguration(.init(pointSize: CGFloat(18), weight: .semibold)), style: .plain, target: self, action: #selector(didTapToAddNewTracker))
        return addTrackerButton
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.tintColor = .trBlue
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var searchField: UISearchController = {
        let searchField = UISearchController()
        searchField.searchBar.placeholder = "Поиск"
        searchField.searchBar.tintColor = .trBlue
        searchField.hidesNavigationBarDuringPresentation = false
        searchField.searchBar.searchTextField.clearButtonMode = .whileEditing
        searchField.searchBar.setValue("Отменить", forKey: "cancelButtonText")
        if let navBar = navigationController?.navigationItem.searchController?.searchBar {
            searchField.searchBar.resignFirstResponder()
        }
        searchField.resignFirstResponder()
        return searchField
    }()
    
    private lazy var  trackersCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: TrackersCollectionViewCell.identifier)
        collectionView.register(HeaderTrackersCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderTrackersCollectionView.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isHidden = false
        return collectionView
    }()
    // MARK: - Inits
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trWhite
        setupNavBar()
        addSubviews()
        applyConstraints()
        checkItemsForCollectionView()
    }
    // MARK: - Private Methods
    private func addSubviews() {
        [noTrackersStub,
         errorStub,
         trackersCollectionView].forEach { view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            noTrackersStub.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            noTrackersStub.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            errorStub.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            errorStub.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            trackersCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupNavBar() {
        if let navBar = navigationController?.navigationBar {
            navBar.backgroundColor = .trWhite
            navBar.tintColor = .trBlack
            navBar.prefersLargeTitles = true
            navigationItem.title = "Трекеры"
            navigationItem.leftBarButtonItem = self.addTrackerButton
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.datePicker)
            navigationItem.searchController = self.searchField
        }
    }
    
    private func checkCategoryIsExist() -> Bool {
        return categories.isEmpty
    }
    
    private func checkTrackersIsExist(_ categories: [TrackerCategory]) -> Bool {
        for category in categories {
            if category.trackers.isEmpty {
                return true
            }
        }
        return false
    }
    
    private func checkItemsForCollectionView() {
        if checkCategoryIsExist() || checkTrackersIsExist(categories) == true {
            trackersCollectionView.isHidden = true
            noTrackersStub.isHidden = false
        }
    }
    
    @objc private func didTapToAddNewTracker() {
        let selectingNewTrackerViewController = SelectingNewTrackerViewController()
        selectingNewTrackerViewController.delegate = self
        present(selectingNewTrackerViewController, animated: true)
        print("Добавление трекера")
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: { self.dismiss(animated: false) })
        print("Выбранная дата: \(formattedDate)")
    }
}
// MARK: - Extension: CollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackersCollectionViewCell.identifier, for: indexPath) as? TrackersCollectionViewCell else { return UICollectionViewCell() }
        let tracker = categories[indexPath.section].trackers[indexPath.row]
        cell.configurateCell(for: tracker)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderTrackersCollectionView.identifier, for: indexPath) as? HeaderTrackersCollectionView else { return UICollectionReusableView() }
        let categoryName = categories[indexPath.section].categoryName
        view.setTitleCategory(categoryName)
        return view
    }
}
// MARK: - Extension: CollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 16 * 2 - 9) / 2, height: 148 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingCompressedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)
    }
}