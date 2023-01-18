//
//  DetailStatView.swift
//  MyPokemon
//
//  Created by Sigit on 18/01/23.
//

import UIKit

class DetailStatView: UIView {
    
    private lazy var statTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 80).isActive = true
        return label
    }()
    
    private lazy var statValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private lazy var progressView: UIProgressView = {
        let progress = UIProgressView()
        progress.progressTintColor = Colors.shared.skyBlue
        progress.trackTintColor = .white
        progress.progressViewStyle = .default
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.heightAnchor.constraint(equalToConstant: 12).isActive = true
        progress.layer.cornerRadius = 6
        progress.clipsToBounds = true
        progress.layer.sublayers?.last?.cornerRadius = 6
        progress.subviews.last?.clipsToBounds = true
        progress.progress = 0.5
        return progress
    }()
    
    lazy var hStackContainer : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(statTitleLabel)
        stack.addArrangedSubview(progressView)
        stack.addArrangedSubview(statValueLabel)
        return stack
    }()
    
    private let title: String
    private let progress: Float
    
    init(title: String, progress: Float) {
        self.title = title
        self.progress = progress
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(hStackContainer)
        NSLayoutConstraint.activate([
            hStackContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            hStackContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            hStackContainer.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            hStackContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
        
        statTitleLabel.text = title.capitalized
        statValueLabel.text = "\(Int(progress))"
        progressView.progress = progress / 100
    }
    
}
