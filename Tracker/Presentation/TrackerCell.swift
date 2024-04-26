//
//  TrackerCell.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 15.04.2024.
//

import UIKit

final class TrackerCell: UICollectionViewCell {
    static let identifier = "trackerCell"
    // MARK: - Private Properties
    private lazy var colorView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var emojiView: UILabel = {
        let label = UILabel()
        label.text = "😻"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.layer.backgroundColor = UIColor.white.withAlphaComponent(0.3).cgColor
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var nameView: UILabel = {
        let label = UILabel()
        label.text = "Название трекера"
        label.textColor = .trWhite
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var scheduleView: UILabel = {
        let label = UILabel()
        label.text = "5 дней"
        label.textColor = .trBlack
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus")?.applyingSymbolConfiguration(.init(pointSize: 12, weight: .medium)), for: .normal)
        button.layer.cornerRadius = 17
        button.backgroundColor = .orange
        button.tintColor = .trWhite
        button.addTarget(self, action: #selector(didTapTrackerPlusButton), for: .touchUpInside)
        return button
    }()
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Public Methods
    func configurateCell(for tracker: Tracker) {
        colorView.backgroundColor = tracker.color
        emojiView.text = tracker.emoji
        nameView.text = tracker.name
        plusButton.backgroundColor = tracker.color
    }
    // MARK: - Private Methods
    private func addSubviews() {
        [colorView,
         emojiView,
         nameView,
         scheduleView,
         plusButton].forEach { contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiView.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 12),
            emojiView.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            emojiView.heightAnchor.constraint(equalToConstant: 24),
            
            nameView.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -12),
            nameView.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            nameView.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -12),
            
            scheduleView.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            scheduleView.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            
            plusButton.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
            plusButton.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -12),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            plusButton.widthAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    @objc private func didTapTrackerPlusButton() {
        // TODO: дописать логику отметки трекера выполненым
        let check = UIImage(systemName: "checkmark")?.applyingSymbolConfiguration(.init(pointSize: 12, weight: .heavy))
        let plus = UIImage(systemName: "plus")?.applyingSymbolConfiguration(.init(pointSize: 12, weight: .medium))
        let isImageChanged = plusButton.imageView?.image != check
        if isImageChanged {
            plusButton.setImage(check, for: .normal)
            plusButton.backgroundColor = colorView.backgroundColor?.withAlphaComponent(0.3)
        } else {
            plusButton.setImage(plus, for: .normal)
            plusButton.backgroundColor = colorView.backgroundColor
        }
    }
}
