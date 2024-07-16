//
//  ViewController.swift
//  MusicList
//
//  Created by Boray Chen on 2024/7/14.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Properties
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout.list(using: UICollectionLayoutListConfiguration(appearance: .plain))
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PlayListCell.self, forCellWithReuseIdentifier: PlayListCell.className())
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Search Music"
        return label
    }()
    
    private let networkDebouncer = Debouncer(delay: 0.5)
    
    private lazy var searchAction = UIAction { [weak self]_ in
        guard let self,
              let searchText = self.searchTextField.text,
              !searchText.isEmpty else {
            return
        }
        
        networkDebouncer.schedule { [weak self] in
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                guard let self else { return }
                self.viewModel.fetchMediaItems(with: searchText)
            }
        }
    }
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        textField.placeholder = "Enter keyword here"
        textField.addAction(searchAction, for: .editingChanged)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.setLeftPaddingPoints(8)
        return textField
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addAction(searchAction, for: .touchUpInside)
        return button
    }()
    
    var viewModel: HomeViewModelProtocol
    
    // MARK: - Life Cycle
    
    required init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self

    }
    
    required init?(coder: NSCoder) {
        self.viewModel = HomeViewModel(service: NetworkService.shared, audioPlayer: AudioPlayer())
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swtupUI()
        
        
    }
    
    // MARK: - Helpers
    
    private func swtupUI() {
        setupSearchUI()
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.anchor(top: searchButton.bottomAnchor,
                              left: view.leadingAnchor,
                              bottom: view.bottomAnchor,
                              right: view.trailingAnchor,
                              paddingTop: 12)
    }
    
    private func setupSearchUI() {
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingLeft: 12, paddingRight: 12)
        
        view.addSubview(searchTextField)
        searchTextField.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leadingAnchor, right: titleLabel.trailingAnchor, paddingTop: 4)
        searchTextField.setHeight(36)
        
        view.addSubview(searchButton)
        searchButton.anchor(top: searchTextField.bottomAnchor, left: searchTextField.leadingAnchor, right: searchTextField.trailingAnchor, paddingTop: 12)
        searchButton.setHeight(42)
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let playListCell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayListCell.className(), for: indexPath) as? PlayListCell else {
            return UICollectionViewCell()
        }
        let cellViewModel = viewModel.cellForItemAt(indexPath)
        playListCell.configure(with: cellViewModel)
        return playListCell
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectItem(at: indexPath.item)
    }
}

// MARK: - HomeViewModelDelegate

extension HomeViewController: HomeViewModelDelegate {
    func didLoadData(_ self: HomeViewModel) {
        collectionView.reloadData()
    }
    
    func didUpdateUI(_ self: HomeViewModel, playStatusText: String?, indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PlayListCell else {
            return
        }
        
        cell.updatePlayStatus(with: playStatusText)
    }
    
    func didFailToFetchData(_ self: HomeViewModel, error: APIError) {
        print("api error: \(error)")
    }
}

