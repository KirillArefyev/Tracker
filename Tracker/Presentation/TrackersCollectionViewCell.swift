//
//  TrackersCollectionViewCell.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 15.04.2024.
//

import UIKit

final class TrackersCollectionViewCell: UICollectionViewCell {
    static let trackerCellIdentifier = "trackerCell"
    
    weak var delegate: TrackersViewController?
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.backgroundColor = .color2
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var emojiView: UILabel = {
        let label = UILabel()
        label.text = "😻"
        label.font = .systemFont(ofSize: 16, weight: .medium) // размер указан в Figma, но чтобы совпадал с макетом дб 14 🤔
        label.textAlignment = .center
        label.layer.backgroundColor = UIColor.white.withAlphaComponent(0.3).cgColor
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var nameView: UILabel = {
        let label = UILabel()
        label.text = "Кошка заслонила камеру на созвоне"
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
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.frame.size = CGSize(width: 34, height: 34)
        button.layer.cornerRadius = 17
        button.backgroundColor = colorView.backgroundColor
        button.tintColor = .trWhite
        button.addTarget(self, action: #selector(didTapTrackerPlusButton), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [colorView,
         emojiView,
         nameView,
         scheduleView,
         plusButton].forEach { contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiView.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 12),
            emojiView.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            
            nameView.topAnchor.constraint(equalTo: emojiView.bottomAnchor, constant: 8),
            nameView.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            nameView.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -12),
            
            scheduleView.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 16),
            scheduleView.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            scheduleView.trailingAnchor.constraint(lessThanOrEqualTo: plusButton.leadingAnchor, constant: -8),
            
            plusButton.centerYAnchor.constraint(equalTo: scheduleView.centerYAnchor),
            plusButton.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -12)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapTrackerPlusButton() {
        // TODO: что-то происходит
        print("+ нажат")
    }
}
