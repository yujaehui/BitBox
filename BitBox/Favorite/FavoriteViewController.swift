//
//  FavoriteViewController.swift
//  BitBox
//
//  Created by Jaehui Yu on 3/1/24.
//

import UIKit
import SnapKit
import Toast

class FavoriteViewController: BaseViewController {
    let favoriteCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    
    let viewModel = FavoriteViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
//        viewModel.inputViewWillAppear.value = (viewModel.outputMarketCoinList.value)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    deinit {
        print("favorite", #function)
    }
    
    func bindData() {
        viewModel.outputFavoriteCoinList.bind { [weak self] _ in
            self?.favoriteCollectionView.reloadData()
        }
        
        viewModel.outputMarketCoinList.bind { [weak self] _ in
            self?.favoriteCollectionView.reloadData()
        }
        
        viewModel.outputError.bind { [weak self] value in
            guard let value = value else { return }
            var style = ToastStyle()
            style.backgroundColor = ColorStyle.purple
            style.messageAlignment = .center
            self?.view.makeToast(value, duration: 3, position: .center, style: style)
        }
        
        viewModel.DidSelectItemAt.bind { [weak self] value in
            guard let value = value else { return }
            let vc = MarketViewController()
            vc.viewModel.inputMarket.value = value
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(favoriteCollectionView)
    }
    
    override func configureView() {
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.delegate = self
        favoriteCollectionView.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
        
        // refreshControl - 당겨서 새로고침
        favoriteCollectionView.refreshControl = UIRefreshControl()
        favoriteCollectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc func refresh() {
        DispatchQueue.main.async {
            self.viewModel.inputRefresh.value = (self.viewModel.outputMarketCoinList.value)
            self.favoriteCollectionView.refreshControl?.endRefreshing() // 새로고침 종료
        }
    }
    
    override func configureConstraints() {
        favoriteCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setNavigationBar() {
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: ColorStyle.black]

        navigationItem.title = "Favorite Coin"
        navigationItem.backButtonTitle = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(rightBarButtonClicked))
    }
    
    @objc func rightBarButtonClicked() {
        //TODO: UserViewController로 Transition
//        let vc = UserViewController()
//        self?.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FavoriteViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    private static func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        let cellWidth = UIScreen.main.bounds.width - (spacing * 3)
        layout.itemSize = CGSize(width: cellWidth / 2, height: cellWidth / 2)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: 0, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputMarketCoinList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.identifier, for: indexPath) as! FavoriteCollectionViewCell
        let row = indexPath.row
        let currentCell = viewModel.outputMarketCoinList.value[row]
        cell.configureCell(currentCell: currentCell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = viewModel.outputMarketCoinList.value[indexPath.row].id
        viewModel.DidSelectItemAt.value = (id)
    }
}
