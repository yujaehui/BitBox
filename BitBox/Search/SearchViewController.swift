//
//  SearchViewController.swift
//  BitBox
//
//  Created by Jaehui Yu on 2/29/24.
//

import UIKit
import SnapKit
import Kingfisher
import Toast

class SearchViewController: BaseViewController {
    let viewModel = SearchViewModel()
    
    let searchTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // 어디선가 별 누르고 이 곳으로 돌아오면 확인 필요
        viewModel.inputViewWillAppear.value = ()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    deinit {
        print("search", #function)
    }
    
    func bindData() {
        viewModel.outputSearchCoinList.bind { [weak self] _ in
            self?.searchTableView.reloadData()
        }
        
        viewModel.outputFavoriteCoinList.bind { [weak self] _ in
            self?.searchTableView.reloadData()
        }
        
        viewModel.DidSelectRowAt.bind { [weak self] value in
            guard let value = value else { return }
            //TODO: MarketViewController로 Transition
//            let vc = MarketViewController()
//            vc.viewModel.inputMarket.value = value // 여기서 value는 id
//            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(searchTableView)
    }
    
    override func configureView() {
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        searchTableView.rowHeight = 80
    }
    
    override func configureConstraints() {
        searchTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setNavigationBar() {
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: ColorStyle.black]
        
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        navigationItem.title = "Search"
        navigationItem.backButtonTitle = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(rightBarButtonClicked))
    }
    
    @objc func rightBarButtonClicked() {
        //TODO: UserViewController로 Transition
//        let vc = UserViewController()
//        self?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func isFavoriteButtonClicked(id: String) {
        let data = FavoriteCoin(id: id)
        viewModel.inputIsFavoriteButtonClicked.value = (data)
        
        // 추가, 삭제, 10개 초과 토스트 메시지
        var style = ToastStyle()
        style.backgroundColor = ColorStyle.purple
        view.makeToast(viewModel.outputToastMessage.value, duration: 1, position: .bottom, style: style)
    }
}

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        //viewModel.inputSearch.value = searchBar.text
        //업데이트가 될 때마다 뷰모델에 값을 넣어주면 그만큼 api 통신의 양이 많아지게 됨 >>> 492 error
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.inputSearch.value = searchBar.text
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //viewModel.inputSearch.value = ""
        //캔슬 버튼을 누를 때마다 빈 값이라도 뷰모델에 넣어주면 그만큼 api 통신의 양이 많아지게 됨 >>> 492 error
        
        // 그래서 그냥 내가 만든 리스트 비워주기
        // 값이 변할 때마다 테이블뷰 리로드 해줄테니까 괜찮을 듯
        viewModel.outputSearchCoinList.value.removeAll()
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputSearchCoinList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        let row = indexPath.row
        let currentCell = viewModel.outputSearchCoinList.value[row]
        let searchText = viewModel.inputSearch.value ?? ""
        cell.configureCell(currentCell: currentCell, searchText: searchText)
        cell.buttonAction = { self.isFavoriteButtonClicked(id: currentCell.id) }
        
        viewModel.inputCellForRowAt.value = row
        cell.isFavoriteButton.setImage(viewModel.outputCellForRowAt.value ? ImageStyle.starFill : ImageStyle.star, for: .normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = viewModel.outputSearchCoinList.value[indexPath.row].id
        viewModel.DidSelectRowAt.value = (id)
    }
}

