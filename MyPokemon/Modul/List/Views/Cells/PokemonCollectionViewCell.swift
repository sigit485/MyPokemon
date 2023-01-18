//
//  PokemonCollectionViewCell.swift
//  MyPokemon
//
//  Created by Sigit on 17/01/23.
//

import UIKit
import AlamofireImage

protocol PokemonCellDelegate: AnyObject {
    func removePokemonSelected(index: Int)
}

class PokemonCollectionViewCell: UICollectionViewCell {
    
    public static let identifier = "PokemonCollectionViewCell"
    
    private lazy var pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.fixSize(width: 110, height: 110)
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "fill_star")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Colors.shared.starYellow
        imageView.fixSize(width: 24, height: 24)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(starTapped)))
        return imageView
    }()
    
    public weak var delegate: PokemonCellDelegate?
    public var index: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        containerView.pin(
            to: contentView,
            insets: UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14))
        
        containerView.addSubview(pokemonImageView)
        NSLayoutConstraint.activate([
            pokemonImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            pokemonImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10)
        ])
        
        containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -14),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
        ])
        
        contentView.addSubview(starImageView)
        NSLayoutConstraint.activate([
            starImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            starImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10)
        ])
    }
    
    @objc private func starTapped() {
        guard let index = index else { return }
        delegate?.removePokemonSelected(index: index)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.pokemonImageView.image = nil
    }
    
    func configure<T>(data: T?, index: Int) {
        if let data = data as? PokemonResult {
            self.pokemonImageView.af.setImage(
                withURL: URL(string: "\(APIManager.baseImageURL)/\(index).png")!,
                placeholderImage: UIImage(named: "pokemon_placeholder"))
            self.titleLabel.text = data.name ?? ""
        } else if let data = data as? FavoritePokemonModel {
            self.pokemonImageView.af.setImage(
                withURL: URL(string: "\(APIManager.baseImageURL)/\(data.id ?? 0).png")!,
                placeholderImage: UIImage(named: "pokemon_placeholder"))
            self.titleLabel.text = data.username ?? ""
            self.starImageView.isHidden = false
            self.index = index
        }
        
    }
    
}
