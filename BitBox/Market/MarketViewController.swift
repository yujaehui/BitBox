//
//  MarketViewController.swift
//  BitBox
//
//  Created by Jaehui Yu on 3/1/24.
//

import UIKit
import DGCharts
import SnapKit
import Toast

enum TextLabelType: String {
    case Today
    case Hp = "고가"
    case Lp = "저가"
    case Ath = "신고점"
    case Atl = "신저점"
}

class MarketViewController: BaseViewController {
    let thumbImageView = UIImageView()
    let nameLabel = CustomLabel(type: .largeTitle)
    let currentPriceLabel = CustomLabel(type: .largeTitle)
    let priceChangePercentageLabel = CustomLabel(type: .priceChange1)
    let todayLabel = CustomLabel(type: .date1)
    let highPriceTextLabel = CustomLabel(type: .high)
    let highPriceLabel = CustomLabel(type: .price1)
    let lowPriceTextLabel = CustomLabel(type: .high)
    let lowPriceLabel = CustomLabel(type: .price1)
    let athTextLabel = CustomLabel(type: .low)
    let athLabel = CustomLabel(type: .price1)
    let atlTextLabel = CustomLabel(type: .low)
    let atlLabel = CustomLabel(type: .price1)
    let chartView = CustomChartView()
    let lastUpdateDateLabel = CustomLabel(type: .date2)
    
    let viewModel = MarketViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    
    deinit {
        print("market", #function)
    }
    
    func bindData() {
        print(#function)
        
        viewModel.outputFavoriteCoinList.bind { [weak self] _ in
            self?.setNavigationBar()
        }
        
        viewModel.outputCoinID.bind { [weak self] _ in
            self?.setNavigationBar()
        }
        
        viewModel.outputThumbImageView.bind { [weak self] value in
            let imageURL = URL(string: value)
            self?.thumbImageView.kf.setImage(with: imageURL)
        }
        
        viewModel.outputNameLabel.bind { [weak self] value in
            self?.nameLabel.text = value
        }
        
        viewModel.outputCurrentPriceLabel.bind { [weak self] value in
            self?.currentPriceLabel.text = value
        }
        
        viewModel.outputPriceChangePercentageLabel.bind { [weak self] value in
            self?.priceChangePercentageLabel.text = value
        }
        
        viewModel.outputPriceChangePercentageColor.bind { [weak self] value in
            self?.priceChangePercentageLabel.textColor = value ? ColorStyle.red : ColorStyle.blue
        }
        
        viewModel.outputHighPriceLabel.bind { [weak self] value in
            self?.highPriceLabel.text = value
        }
        
        viewModel.outputLowPriceLabel.bind { [weak self] value in
            self?.lowPriceLabel.text = value
        }
        
        viewModel.outputAthLabel.bind { [weak self] value in
            self?.athLabel.text = value
        }
        
        viewModel.outputAtlLabel.bind { [weak self] value in
            self?.atlLabel.text = value
        }
        
        viewModel.outputLastUpdateDateLabel.bind { [weak self] value in
            self?.lastUpdateDateLabel.text = value
        }
        
        viewModel.outputChartView.bind { [weak self] value in
            self?.chartView.configureView(price: value)
        }
        
        viewModel.outputError.bind { [weak self] value in
            guard let value = value else { return }
            self?.hideAllSubviews()
            
            var style = ToastStyle()
            style.backgroundColor = ColorStyle.purple
            style.messageAlignment = .center
            self?.view.makeToast(value, duration: .infinity, position: .center, style: style)
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(thumbImageView)
        view.addSubview(nameLabel)
        view.addSubview(currentPriceLabel)
        view.addSubview(priceChangePercentageLabel)
        view.addSubview(todayLabel)
        view.addSubview(highPriceTextLabel)
        view.addSubview(highPriceLabel)
        view.addSubview(lowPriceTextLabel)
        view.addSubview(lowPriceLabel)
        view.addSubview(athTextLabel)
        view.addSubview(athLabel)
        view.addSubview(atlTextLabel)
        view.addSubview(atlLabel)
        view.addSubview(chartView)
        view.addSubview(lastUpdateDateLabel)
    }
    
    override func configureView() {
        todayLabel.text = TextLabelType.Today.rawValue
        highPriceTextLabel.text = TextLabelType.Hp.rawValue
        lowPriceTextLabel.text = TextLabelType.Lp.rawValue
        athTextLabel.text = TextLabelType.Ath.rawValue
        atlTextLabel.text = TextLabelType.Atl.rawValue
    }
    
    override func configureConstraints() {
        thumbImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.size.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.leading.equalTo(thumbImageView.snp.trailing).offset(8)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(40)
        }
        
        currentPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbImageView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(40)
        }
        
        priceChangePercentageLabel.snp.makeConstraints { make in
            make.top.equalTo(currentPriceLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(20)
        }
        
        todayLabel.snp.makeConstraints { make in
            make.top.equalTo(currentPriceLabel.snp.bottom).offset(8)
            make.leading.equalTo(priceChangePercentageLabel.snp.trailing).offset(8)
            make.height.equalTo(20)
        }
        
        highPriceTextLabel.snp.makeConstraints { make in
            make.top.equalTo(priceChangePercentageLabel.snp.bottom).offset(32)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.width.equalTo(view.bounds.width / 2 - 10)
            make.height.equalTo(20)
        }
        
        highPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(highPriceTextLabel.snp.bottom).offset(16)
            make.leading.size.equalTo(highPriceTextLabel)
        }
        
        lowPriceTextLabel.snp.makeConstraints { make in
            make.top.equalTo(priceChangePercentageLabel.snp.bottom).offset(32)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.width.equalTo(view.bounds.width / 2 - 10)
            make.height.equalTo(20)
        }
        
        lowPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(lowPriceTextLabel.snp.bottom).offset(16)
            make.trailing.size.equalTo(lowPriceTextLabel)
        }
        
        athTextLabel.snp.makeConstraints { make in
            make.top.equalTo(highPriceLabel.snp.bottom).offset(24)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.width.equalTo(view.bounds.width / 2 - 10)
            make.height.equalTo(20)
        }
        
        athLabel.snp.makeConstraints { make in
            make.top.equalTo(athTextLabel.snp.bottom).offset(16)
            make.leading.size.equalTo(athTextLabel)
        }
        
        atlTextLabel.snp.makeConstraints { make in
            make.top.equalTo(lowPriceLabel.snp.bottom).offset(24)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.width.equalTo(view.bounds.width / 2 - 10)
            make.height.equalTo(20)
        }
        
        atlLabel.snp.makeConstraints { make in
            make.top.equalTo(atlTextLabel.snp.bottom).offset(16)
            make.trailing.size.equalTo(atlTextLabel)
        }
        
        chartView.snp.makeConstraints { make in
            make.top.equalTo(athLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        lastUpdateDateLabel.snp.makeConstraints { make in
            make.top.equalTo(chartView.snp.bottom).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(20)
        }
    }
    
    func setNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = ColorStyle.purple
        
        viewModel.inputSetNavigationBar.value = viewModel.outputCoinID.value
        
        var image: UIImage = ImageStyle.star
        image = viewModel.outputSetNavigationBar.value ? ImageStyle.starFill : ImageStyle.star
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(isFavoriteButtonClicked))
    }
    
    @objc func isFavoriteButtonClicked() {
        let data = FavoriteCoin(id: viewModel.outputCoinID.value)
        viewModel.inputIsFavoriteButtonClicked.value = (data)
        
        var style = ToastStyle()
        style.backgroundColor = ColorStyle.purple
        style.messageAlignment = .center
        view.makeToast(viewModel.outputToastMessage.value, duration: 1, position: .bottom, style: style)
    }
}
