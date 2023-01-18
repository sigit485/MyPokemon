//
//  UIView+Extensions.swift
//  MyPokemon
//
//  Created by Sigit on 17/01/23.
//

import UIKit

extension UIView {
    func pin(to view: UIView, guide: UILayoutGuide? = nil, insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)

        let guide = guide ?? view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -insets.right),
            topAnchor.constraint(equalTo: guide.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -insets.bottom)
        ])
    }
    
    func fixSize(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    func center(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setCornerRadius(corner: CGFloat) {
        self.layer.cornerRadius = corner
        self.clipsToBounds = true
    }
    
    func setShadow() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 3.0
        self.layer.masksToBounds = false
    }
    
}

extension UIScrollView {
    func pin(to view: UIView, with contentView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)

        view.addSubview(self)
        let guide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            frameLayoutGuide.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            frameLayoutGuide.topAnchor.constraint(equalTo: guide.topAnchor),
            frameLayoutGuide.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            frameLayoutGuide.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            contentLayoutGuide.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentLayoutGuide.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentLayoutGuide.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentLayoutGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            contentLayoutGuide.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            contentView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
        ])
    }
}
