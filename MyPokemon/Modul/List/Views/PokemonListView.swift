//
//  PokemonListView.swift
//  MyPokemon
//
//  Created by Sigit on 17/01/23.
//

import UIKit
import NVActivityIndicatorView


class PokemonListView: BaseView {
    
    private lazy var pokemonCollection: UICollectionView = {
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionFlowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
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
    
    
    private var pokemonVM: PokemonListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let service = PokemonListService()
        pokemonVM = PokemonListViewModel(service: service)
        pokemonCollection.pin(to: view)
        initIndicatiorView()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = Colors.shared.lightGrayPrimary
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = Constant.pokemon
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "star"),
            style: .plain,
            target: self,
            action: #selector(myPokemonTapped(sender:)))
    }
    
    fileprivate func fetchData() {
        self.indicator.startAnimating()
        DispatchQueue.global().async {
            self.pokemonVM?.getData()
            self.pokemonVM?.didSuccess = { [weak self] in
                guard let strongSelf = self else { return }
                DispatchQueue.main.async {
                    strongSelf.pokemonCollection.reloadData()
                    strongSelf.indicator.stopAnimating()
                }
            }
            self.pokemonVM?.didFailed = { message in
                DispatchQueue.main.async {
                    print(message)
                    self.indicator.stopAnimating()
                }
            }
        }
    }
    
    fileprivate func loadMoreData() {
        self.indicator.startAnimating()
        DispatchQueue.global().async {
            self.pokemonVM?.loadMoreData()
            self.pokemonVM?.didSuccess = {
                DispatchQueue.main.async {
                    guard let lastIndexPaths = self.pokemonVM?.lastIndexPath else { return }
                    self.pokemonCollection.insertItems(at: lastIndexPaths)
                    self.indicator.stopAnimating()
                }
            }
            self.pokemonVM?.didFailed = { message in
                DispatchQueue.main.async {
                    self.showAlert(message: message)
                    self.indicator.stopAnimating()
                }
            }
        }
    }
    
    
    @objc fileprivate func myPokemonTapped(sender: UIButton) {
        let vc = FavoritePokemonListView()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension PokemonListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonVM?.pokemonList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCollectionViewCell.identifier, for: indexPath) as! PokemonCollectionViewCell
        if let pokemon = pokemonVM?.pokemonList?[indexPath.row] {
            let lastPath = ((pokemon.url ?? "") as NSString).lastPathComponent
            cell.containerView.setCornerRadius(corner: 10)
            cell.configure(data: pokemon, index: Int(lastPath) ?? 0)
        }
        return cell
    }
}

extension PokemonListView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthPerItem = (collectionView.frame.width / 2) - 6
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailPokemonView()
        vc.detailURL = pokemonVM?.pokemonList?[indexPath.row].url
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (pokemonVM?.pokemonList?.count ?? 0) - 2 {
            self.loadMoreData()
        }
    }
}
