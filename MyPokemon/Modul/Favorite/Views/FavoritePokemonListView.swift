//
//  FavoritePokemonListView.swift
//  MyPokemon
//
//  Created by Sigit on 18/01/23.
//

import UIKit

class FavoritePokemonListView: BaseView {
    
    private lazy var pokemonCollection: UICollectionView = {
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionFlowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            PokemonCollectionViewCell.self,
            forCellWithReuseIdentifier: PokemonCollectionViewCell.identifier)
        collectionView.collectionViewLayout = collectionFlowLayout
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.emptyData
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let favoriteVM = FavoritePokemonViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.shared.lightGrayPrimary
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = Constant.myPokemon
        fetchData()
    }
    
    private func setupUI() {
        pokemonCollection.pin(to: view)
        pokemonCollection.backgroundView = emptyLabel
        pokemonCollection.backgroundView?.isHidden = true
        
        initIndicatiorView()
    }
    
    private func fetchData() {
        self.indicator.startAnimating()
        DispatchQueue.global().async {
            self.favoriteVM.getPokemonLocale()
            self.favoriteVM.didSuccess = {
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.pokemonCollection.reloadData()
                    if self.favoriteVM.pokemonList?.isEmpty == true {
                        self.pokemonCollection.backgroundView?.isHidden = false
                    } else {
                        self.pokemonCollection.backgroundView?.isHidden = true
                    }
                }
            }
            self.favoriteVM.didFailed = { message in
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.pokemonCollection.backgroundView?.isHidden = false
                    self.showAlert(message: message)
                }
            }
        }
    }
    
    
}

extension FavoritePokemonListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteVM.pokemonList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCollectionViewCell.identifier, for: indexPath) as! PokemonCollectionViewCell
        if let pokemon = favoriteVM.pokemonList?[indexPath.row] {
            cell.containerView.setCornerRadius(corner: 10)
            cell.configure(data: pokemon, index: indexPath.row)
            cell.delegate = self
        }
        return cell
    }
}

extension FavoritePokemonListView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthPerItem = (collectionView.frame.width / 2) - 6
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}

extension FavoritePokemonListView: PokemonCellDelegate {
    func removePokemonSelected(index: Int) {
        guard let idPokemon = self.favoriteVM.pokemonList?[index].id else { return }
        favoriteVM.deletePokemon(idPokemon) {
            DispatchQueue.main.async {
                self.favoriteVM.pokemonList?.remove(at: index)
                self.pokemonCollection.deleteItems(at: [IndexPath(row: index, section: 0)])
            }
        }
    }
}
