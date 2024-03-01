//
//  TrendViewController.swift
//  BitBox
//
//  Created by Jaehui Yu on 3/1/24.
//

import UIKit
import SnapKit
import Kingfisher
import Toast

enum SectionType: String, CaseIterable {
    case MyFavorite = "My Favorite"
    case Top15Coin = "Top 15 Coin"
    case Top7NFT = "Top 7 NFT"
    
    // favorite 항목이 있을 때 사용
    func makeOriginalVersionSection() -> Section {
        switch self {
        case .MyFavorite:
            return FavoriteSection()
        case .Top15Coin:
            return Top15Section()
        case .Top7NFT:
            return Top7Section()
        }
    }
    
    // favorite 항목이 없을 때 사용
    func makeEmptyVersionSection() -> Section {
        switch self {
        case .MyFavorite:
            return EmptySection()
        case .Top15Coin:
            return Top15Section()
        case .Top7NFT:
            return Top7Section()
        }
    }
}

class TrendViewController: BaseViewController {
    let viewModel = TrendViewModel()
        
    lazy var collectionViewLayout = {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            // 네트워크 통신 결과 항목이 없으면 makeEmptyVersionSection, 있으면 makeOriginalVersionSection
            if self.viewModel.outputMarketCoinList.value.count == 0 {
                return SectionType.allCases[sectionIndex].makeEmptyVersionSection().layoutSection()
            } else {
                return SectionType.allCases[sectionIndex].makeOriginalVersionSection().layoutSection()
            }
        }
        return layout
    }()
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.dataSource = self
        view.delegate = self
        view.register(EmptyCollectionViewCell.self, forCellWithReuseIdentifier: EmptyCollectionViewCell.identifier)
        view.register(MyFavoriteCollectionViewCell.self, forCellWithReuseIdentifier: MyFavoriteCollectionViewCell.identifier)
        view.register(Top15CollectionViewCell.self, forCellWithReuseIdentifier: Top15CollectionViewCell.identifier)
        view.register(Top7CollectionViewCell.self, forCellWithReuseIdentifier: Top7CollectionViewCell.identifier)
        view.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        setNavigationBar()
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
        print("trend", #function)
    }
    
    func bindData() {
        viewModel.outputFavoriteCoinList.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
        
        viewModel.outputMarketCoinList.bind { [weak self] value in
            self?.collectionView.reloadData()
            
            // FIXME: 값의 변경에 따라 레이아웃 자체도 변해야 할 때
            // 네트워크 통신 결과에 따라서 다시 레이아웃 설정
            self?.collectionViewLayout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
                if self?.viewModel.outputMarketCoinList.value.count == 0 {
                    return SectionType.allCases[sectionIndex].makeEmptyVersionSection().layoutSection()
                } else {
                    return SectionType.allCases[sectionIndex].makeOriginalVersionSection().layoutSection()
                }
            }
        }
        
        viewModel.outputTrendCoinList.bind { [weak self] _ in
            self?.collectionView.reloadData()
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
        view.addSubview(collectionView)
    }
    
    override func configureView() {
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc func refresh() {
        DispatchQueue.main.async {
            self.viewModel.inputRefresh.value = (self.viewModel.outputMarketCoinList.value)
            self.collectionView.refreshControl?.endRefreshing() // 새로고침 종료
        }
    }
    
    override func configureConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setNavigationBar() {
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: ColorStyle.black]

        navigationItem.title = "Crypto Coin"
        navigationItem.backButtonTitle = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(rightBarButtonClicked))
    }
    
    @objc func rightBarButtonClicked() {
        let vc = UserViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension TrendViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        SectionType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as! HeaderCollectionReusableView
        header.headerLabel.text = SectionType.allCases[indexPath.section].rawValue
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch SectionType.allCases[section] {
            // 네트워크 통신 결과 항목이 없으면 셀의 갯수는 1개, emptyLabel을 보여줄거니까
        case .MyFavorite: return viewModel.outputMarketCoinList.value.count == 0 ? 1 : viewModel.outputMarketCoinList.value.count
        case .Top15Coin: return viewModel.outputTrendCoinList.value.coins.count
        case .Top7NFT: return viewModel.outputTrendCoinList.value.nfts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch SectionType.allCases[indexPath.section] {
        case .MyFavorite:
            // 네트워크 통신 결과 항목이 없으면 EmptyCollectionViewCell, 있으면 MyFavoriteCollectionViewCell
            if viewModel.outputMarketCoinList.value.count == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCollectionViewCell.identifier, for: indexPath) as! EmptyCollectionViewCell
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyFavoriteCollectionViewCell.identifier, for: indexPath) as! MyFavoriteCollectionViewCell
                let row = indexPath.row
                let currentCell = viewModel.outputMarketCoinList.value[row]
                cell.configureCell(currentCell: currentCell)
                return cell
            }
        case .Top15Coin:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Top15CollectionViewCell.identifier, for: indexPath) as! Top15CollectionViewCell
            let row = indexPath.row
            let currentCell = viewModel.outputTrendCoinList.value.coins[row].item
            cell.configureCell(row: row, currentCell: currentCell)
            return cell
        case .Top7NFT:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Top7CollectionViewCell.identifier, for: indexPath) as! Top7CollectionViewCell
            let row = indexPath.row
            let currentCell = viewModel.outputTrendCoinList.value.nfts[row]
            cell.configureCell(row: row, currentCell: currentCell)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 네트워크 통신 결과 항목이 존재할때의 Favorite과 Top 15 Coin에서만 진행
        switch SectionType.allCases[indexPath.section] {
        case .MyFavorite:
            if viewModel.outputMarketCoinList.value.count == 0 {
                return
            } else {
                let id = viewModel.outputMarketCoinList.value[indexPath.row].id
                viewModel.DidSelectItemAt.value = (id)
            }
        case .Top15Coin:
            let id = viewModel.outputTrendCoinList.value.coins[indexPath.row].item.id
            viewModel.DidSelectItemAt.value = (id)
        case .Top7NFT:
            return
        }
    }
}

