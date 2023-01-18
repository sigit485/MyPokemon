//
//  DetailPokemonView.swift
//  MyPokemon
//
//  Created by Sigit on 17/01/23.
//

import UIKit
import NVActivityIndicatorView
import AlamofireImage


class DetailPokemonView: BaseView {
    
    private lazy var pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 310).isActive = true
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.bounces = true
        scroll.alwaysBounceVertical = true
        scroll.showsVerticalScrollIndicator = false
        scroll.isHidden = true
        return scroll
    }()
    
    private lazy var vStackContainer : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(pokemonImageView)
        stack.addArrangedSubview(pokemonNameLabel)
        stack.addArrangedSubview(vStackAbout)
        stack.addArrangedSubview(vStackMoves)
        stack.addArrangedSubview(vStackTypes)
        stack.addArrangedSubview(vStackStats)
        return stack
    }()
    
    // MARK: Name
    private lazy var pokemonNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    // MARK: About
    private lazy var vStackAbout : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.addArrangedSubview(aboutTitleLabel)
        stack.addArrangedSubview(heightLabel)
        stack.addArrangedSubview(weightLabel)
        stack.addArrangedSubview(abilityLabel)
        return stack
    }()
    
    private lazy var aboutTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.text = Constant.pokedexData
        return label
    }()
    
    private lazy var heightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private lazy var abilityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Moves
    private lazy var vStackMoves: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.addArrangedSubview(movesTitleLabel)
        stack.addArrangedSubview(movesLabel)
        return stack
    }()
    
    private lazy var movesTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.text = Constant.moves
        return label
    }()
    
    private lazy var movesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 3
        return label
    }()
    
    // MARK: Types
    private lazy var vStackTypes: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.addArrangedSubview(typesTitleLabel)
        stack.addArrangedSubview(typesLabel)
        return stack
    }()
    
    private lazy var typesTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.text = Constant.types
        return label
    }()
    
    private lazy var typesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Stats
    private lazy var vStackStats: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.addArrangedSubview(statsTitleLabel)
        return stack
    }()
    
    private lazy var statsTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.text = Constant.stats
        return label
    }()
    
    private lazy var catchButton: UIButton = {
        let btn = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 60, height: 60)))
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 20
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        btn.setCornerRadius(corner: btn.frame.height / 2)
        let image = UIImage(named: "pokeball")?.withRenderingMode(.alwaysTemplate)
        btn.setImage(image, for: .normal)
        btn.tintColor = Colors.shared.skyBlue
        btn.addTarget(self, action: #selector(catchTapped(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private var detailVM: DetailPokemonViewModel?
    public var detailURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()

        guard let detailURL = detailURL else { return }
        detailVM = DetailPokemonViewModel(detailURL: detailURL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = false
        
        fetchData()
    }
    
    private func setupUI() {
        scrollView.pin(to: view)

        scrollView.addSubview(vStackContainer)
        NSLayoutConstraint.activate([
            vStackContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            vStackContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            vStackContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            vStackContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
        
        view.addSubview(catchButton)
        NSLayoutConstraint.activate([
            catchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            catchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        initIndicatiorView()
    }
    
    private func fetchData() {
        indicator.startAnimating()
        DispatchQueue.global().async {
            self.detailVM?.fetchDetail()
            self.detailVM?.didSuccess = {
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.bindingData()
                }
            }
            self.detailVM?.didFailed = { [weak self] message in
                DispatchQueue.main.async {
                    guard let strongSelf = self else { return }
                    strongSelf.indicator.stopAnimating()
                    strongSelf.showAlert(message: message)
                }
            }
        }
    }
    
    private func bindingData() {
        guard let detailData = self.detailVM?.detailData else { return }
        scrollView.isHidden = false
        navigationItem.title = detailData.name?.capitalized ?? ""
        pokemonNameLabel.text = detailData.name?.capitalized ?? ""
        pokemonImageView.af.setImage(
            withURL: URL(string: detailData.sprites?.other?.home?.frontDefault ?? "")!,
            placeholderImage: UIImage(named: "pokemon_placeholder"))
        
        heightLabel.text = "Height: \(Double(detailData.height ?? 0) / 10) m"
        weightLabel.text = "Weight: \(Double(detailData.weight ?? 0) / 10) kg"
        
        let abilities = detailData.abilities?.compactMap { $0.ability?.name }.sentence
        abilityLabel.text = "Ability: \(abilities ?? "-")"
        
        let moves = detailData.moves?.compactMap { $0.move?.name }.sentence
        movesLabel.text = "Moves: \(moves ?? "-")"
        
        let types = detailData.types?.compactMap { $0.type?.name }.sentence
        typesLabel.text = "Types: \(types ?? "-")"
        
        
        let stat = detailData.stats?
            .map { return DetailStatView(title: $0.stat?.name ?? "", progress: Float($0.baseStat ?? 0)) }
        stat?.forEach { vStackStats.addArrangedSubview($0) }
    }
    
    @objc private func catchTapped(sender: UIButton) {
        if detailVM?.isAllowCatch == true {
            showAlertWithField(Constant.askQuestionName) { username in
                self.detailVM?.catchNewPokemon(username: username) {
                    DispatchQueue.main.async {
                        self.showAlert(message: Constant.successAdd)
                    }
                }
                self.detailVM?.didFailed = { message in
                    DispatchQueue.main.async {
                        self.showAlert(message: "Failed add pokemon: \(message)")
                    }
                }
            }
        } else {
            self.showAlert(message: Constant.runawayPokemon)
        }
        
    }
    
}
