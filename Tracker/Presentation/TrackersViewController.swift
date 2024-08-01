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
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate = Date()
    private var visibleCategories: [TrackerCategory] = []
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    
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
        datePicker.date = currentDate
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.tintColor = .trBlue
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.addTarget(self, action: #selector(datePickerDateChanged), for: .valueChanged)
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
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.identifier)
        collectionView.register(HeaderTrackersCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderTrackersCollectionView.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trWhite
        setupNavBar()
        addSubviews()
        applyConstraints()
//        categories = CategoriesMock.shared.categories /* моки для проверки фильтра
//                                                       для проверки добавления трекера закомментить строку */
        datePickerDateChanged()
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
    
    private func checkVisibleCategories() {
        categories = trackerCategoryStore.categories
        var newCategories = categories.map { checkTrackerAtDayOfWeek($0) }
        newCategories.removeAll { $0.trackers.isEmpty }
        noTrackersStub.isHidden = !newCategories.isEmpty
        visibleCategories = newCategories
        trackersCollectionView.reloadData()
    }
    
    private func checkTrackerAtDayOfWeek(_ trackerCategory: TrackerCategory) -> TrackerCategory {
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: currentDate)
        let trackers = trackerCategory.trackers.filter { $0.schedule.contains { $0.rawValue == dayOfWeek}}
        let newCategory = TrackerCategory(name: trackerCategory.name, trackers: trackers)
        return newCategory
    }
    
    @objc private func didTapToAddNewTracker() {
        let selectingTrackerViewController = SelectingTrackerViewController()
        selectingTrackerViewController.delegate = self
        present(selectingTrackerViewController, animated: true)
    }
    
    @objc private func datePickerDateChanged() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: false)
        })
        
        currentDate = datePicker.date
        checkVisibleCategories()
    }
}

// MARK: - CollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identifier, for: indexPath) as? TrackerCell else {
            assertionFailure("❌ no cell")
            return UICollectionViewCell()
        }
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        cell.delegate = self
        let isCompleted = isTrackerCompleted(id: tracker.id)
        let completedDays = completedTrackers.filter { $0.id == tracker.id }.count
        cell.configurateCell(for: tracker,
                             trackerIsCompleted: isCompleted,
                             completedDays: completedDays,
                             at: indexPath
        )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderTrackersCollectionView.identifier, for: indexPath) as? HeaderTrackersCollectionView else {
            assertionFailure("❌ no header")
            return UICollectionReusableView()
        }
        
        let categoryName = visibleCategories[indexPath.section].name
        view.setSectionTitle(categoryName)
        return view
    }
    
    private func isTrackerCompleted(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            return trackerRecord.id == id && isSameDay(trackerRecord)
        }
    }
    
    private func isSameDay(_ trackerRecord: TrackerRecord) -> Bool {
        let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
        return isSameDay
    }
}

// MARK: - CollectionViewDelegate
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

// MARK: - SelectingNewTrackerViewController
extension TrackersViewController: SelectingTrackerViewControllerDelegate {
    func appendTrackerToTrackerCategory(_ trackerCategory: TrackerCategory) {
        dismiss(animated: true)
        if let tracker = trackerCategory.trackers.first {
            try? trackerCategoryStore.createCategory(with: tracker, and: trackerCategory.name) }
        var newCategories = categories
        if !newCategories.contains(where: { $0.name == trackerCategory.name }) {
            newCategories.append(trackerCategory)
            categories = newCategories
        } else {
            guard let categoryIndex = newCategories.firstIndex(where: { $0.name == trackerCategory.name }) else {
                assertionFailure("❌ no index for category")
                return
            }
            let oldTrackers = categories[categoryIndex].trackers
            let newTrackers = oldTrackers + trackerCategory.trackers
            let newCategory = TrackerCategory(name: trackerCategory.name, trackers: newTrackers)
            categories[categoryIndex] = newCategory
        }
        datePickerDateChanged()
    }
}

// MARK: - TrackerCellDelegate
extension TrackersViewController: TrackerCellDelegate {
    func completeTracker(id: UUID, at indexPath: IndexPath) {
        if currentDate <= Date() {
            let trackerRecord = TrackerRecord(id: id, date: currentDate)
            completedTrackers.insert(trackerRecord)
            trackersCollectionView.reloadItems(at: [indexPath])
        }
    }
    
    func uncompliteTracker(id: UUID, at indexPath: IndexPath) {
        let removingTracker = TrackerRecord(id: id, date: datePicker.date)
        completedTrackers.remove(removingTracker)
        trackersCollectionView.reloadItems(at: [indexPath])
    }
}
