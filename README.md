# BitBox

![Image](https://github.com/user-attachments/assets/b30e4b03-9636-4be3-b582-3d811b2bbd8b)

### 실시간 시세 조회부터 관심 코인 즐겨찾기까지, 스마트하게 관리하세요.

> 최신 코인 및 NFT 시세를 실시간으로 확인하고, 관심 있는 코인은 즐겨찾기로 관리하며 트렌드를 한눈에 파악할 수 있는 시세 분석 앱입니다.
> 

---

## ⭐️ 주요 기능

- 트렌디한 코인 & NFT 한눈에
    - 메인 화면에서 최신 인기 코인 TOP 15 및 NFT TOP 7 제공
- 검색 기능
    - 원하는 코인 및 NFT를 검색하여 상세 정보 확인
- 코인 세부 정보 제공
    - 현재 가격, 신저점, 신고점, 변동률 등 다양한 데이터 제공
    - 가격 변동을 한눈에 볼 수 있는 차트 지원
- 즐겨찾기 기능
    - 관심 있는 코인을 즐겨찾기로 등록
    - 즐겨찾기한 코인은 홈 화면 상단 및 별도 탭에서 빠르게 확인 가능

---

## 💻 개발 환경

- **개발 기간**: 2024.02.27 ~ 2024.03.02
- **앱 지원 iOS SDK**: iOS 16.0 이상
- **Xcode**: 15.0 이상
- **Swift 버전**: 5.8 이상

---

## 📋 설계 패턴

- **Input-Output Custom Reactive MVVM**: UI와 비즈니스 로직 분리
- **싱글턴 패턴**: 전역적으로 관리가 필요한 객체를 재사용하기 위해 사용

---

## 🛠️ 기술 스택

### **기본 구성**

- **UIKit**: iOS 사용자 인터페이스 구현
- **SnapKit**: 간결한 Auto Layout 코드 작성
- **Codebase UI**: 코드 기반으로 UI를 설계하여 Storyboard 의존성 제거

### **비동기 처리 및 데이터 관리**

- **Alamofire**: 네트워크 요청 및 응답 관리
- **Codable**: 네트워크 응답 데이터 디코딩 및 인코딩

### **데이터 관리**

- **Realm**: 경량 데이터베이스로 로컬 데이터 관리

### **UI 및 사용자 경험**

- **DGCharts**: 데이터 시각화를 위한 다양한 차트 지원
- **Kingfisher**: 네트워크 이미지를 간편하게 로드 및 캐싱
- **Toast-Swift**: 사용자 알림 메시지 표시

---

## 🗂️ 파일 디렉토리 구조

```
BitBox
 ┣ Assets.xcassets
 ┃ ┣ AccentColor.colorset
 ┃ ┃ ┗ Contents.json
 ┃ ┣ AppIcon.appiconset
 ┃ ┃ ┣ Contents.json
 ┃ ┃ ┗ 비트박스 로고.png
 ┃ ┣ Image
 ┃ ┃ ┣ btn_star.imageset
 ┃ ┃ ┃ ┣ Contents.json
 ┃ ┃ ┃ ┣ btn_star.png
 ┃ ┃ ┃ ┣ btn_star@2x.png
 ┃ ┃ ┃ ┗ btn_star@3x.png
 ┃ ┃ ┣ btn_star_fill.imageset
 ┃ ┃ ┃ ┣ Contents.json
 ┃ ┃ ┃ ┣ btn_star_fill.png
 ┃ ┃ ┃ ┣ btn_star_fill@2x.png
 ┃ ┃ ┃ ┗ btn_star_fill@3x.png
 ┃ ┃ ┣ tab_favorite.imageset
 ┃ ┃ ┃ ┣ Contents.json
 ┃ ┃ ┃ ┣ tab_portfolio.png
 ┃ ┃ ┃ ┣ tab_portfolio@2x.png
 ┃ ┃ ┃ ┗ tab_portfolio@3x.png
 ┃ ┃ ┣ tab_favorite_inactive.imageset
 ┃ ┃ ┃ ┣ Contents.json
 ┃ ┃ ┃ ┣ tab_portfolio_inactive.png
 ┃ ┃ ┃ ┣ tab_portfolio_inactive@2x.png
 ┃ ┃ ┃ ┗ tab_portfolio_inactive@3x.png
 ┃ ┃ ┣ tab_search.imageset
 ┃ ┃ ┃ ┣ Contents.json
 ┃ ┃ ┃ ┣ tab_search.png
 ┃ ┃ ┃ ┣ tab_search@2x.png
 ┃ ┃ ┃ ┗ tab_search@3x.png
 ┃ ┃ ┣ tab_search_inactive.imageset
 ┃ ┃ ┃ ┣ Contents.json
 ┃ ┃ ┃ ┣ tab_search_inactive.png
 ┃ ┃ ┃ ┣ tab_search_inactive@2x.png
 ┃ ┃ ┃ ┗ tab_search_inactive@3x.png
 ┃ ┃ ┣ tab_trend.imageset
 ┃ ┃ ┃ ┣ Contents.json
 ┃ ┃ ┃ ┣ tab_trend.png
 ┃ ┃ ┃ ┣ tab_trend@2x.png
 ┃ ┃ ┃ ┗ tab_trend@3x.png
 ┃ ┃ ┣ tab_trend_inactive.imageset
 ┃ ┃ ┃ ┣ Contents.json
 ┃ ┃ ┃ ┣ tab_trend_inactive.png
 ┃ ┃ ┃ ┣ tab_trend_inactive@2x.png
 ┃ ┃ ┃ ┗ tab_trend_inactive@3x.png
 ┃ ┃ ┣ tab_user.imageset
 ┃ ┃ ┃ ┣ Contents.json
 ┃ ┃ ┃ ┣ tab_user.png
 ┃ ┃ ┃ ┣ tab_user@2x.png
 ┃ ┃ ┃ ┗ tab_user@3x.png
 ┃ ┃ ┣ tab_user_inactive.imageset
 ┃ ┃ ┃ ┣ Contents.json
 ┃ ┃ ┃ ┣ tab_user_inactive.png
 ┃ ┃ ┃ ┣ tab_user_inactive@2x.png
 ┃ ┃ ┃ ┗ tab_user_inactive@3x.png
 ┃ ┃ ┗ Contents.json
 ┃ ┗ Contents.json
 ┣ Base
 ┃ ┣ BaseCollectionReusableView.swift
 ┃ ┣ BaseCollectionViewCell.swift
 ┃ ┣ BaseTableViewCell.swift
 ┃ ┗ BaseViewController.swift
 ┣ Base.lproj
 ┃ ┣ LaunchScreen.storyboard
 ┃ ┗ Main.storyboard
 ┣ Custom
 ┃ ┣ CustomBalloonMarker.swift
 ┃ ┣ CustomChartView.swift
 ┃ ┣ CustomCircleMarker.swift
 ┃ ┗ CustomLabel.swift
 ┣ DesignSystem
 ┃ ┣ ColorStyle.swift
 ┃ ┣ FontStyle.swift
 ┃ ┗ ImageStyle.swift
 ┣ Extension
 ┃ ┣ UIColor+Extension.swift
 ┃ ┣ UIView+Extension.swift
 ┃ ┗ UIViewController+Extension.swift
 ┣ Favorite
 ┃ ┣ FavoriteCollectionViewCell.swift
 ┃ ┣ FavoriteViewController.swift
 ┃ ┗ FavoriteViewModel.swift
 ┣ Manager
 ┃ ┣ DateFormatterManager.swift
 ┃ ┣ NumberFormatterManager.swift
 ┃ ┗ TextProcessingManager.swift
 ┣ Market
 ┃ ┣ MarketViewController.swift
 ┃ ┗ MarketViewModel.swift
 ┣ Network
 ┃ ┣ Model
 ┃ ┃ ┣ MarketCoin.swift
 ┃ ┃ ┣ SearchCoin.swift
 ┃ ┃ ┗ TrendCoin.swift
 ┃ ┣ APIService.swift
 ┃ ┗ CoinAPI.swift
 ┣ Realm
 ┃ ┣ FavoriteCoin.swift
 ┃ ┗ FavoriteCoinRepository.swift
 ┣ Search
 ┃ ┣ SearchTableViewCell.swift
 ┃ ┣ SearchViewController.swift
 ┃ ┗ SearchViewModel.swift
 ┣ Trend
 ┃ ┣ Cell
 ┃ ┃ ┣ EmptyCollectionViewCell.swift
 ┃ ┃ ┣ MyFavoriteCollectionViewCell.swift
 ┃ ┃ ┣ Top15CollectionViewCell.swift
 ┃ ┃ ┗ Top7CollectionViewCell.swift
 ┃ ┣ Header
 ┃ ┃ ┗ HeaderCollectionReusableView.swift
 ┃ ┣ Section
 ┃ ┃ ┣ EmptySection.swift
 ┃ ┃ ┣ FavoriteSection.swift
 ┃ ┃ ┣ Section.swift
 ┃ ┃ ┣ Top15Section.swift
 ┃ ┃ ┗ Top7Section.swift
 ┃ ┣ TrendViewController.swift
 ┃ ┗ TrendViewModel.swift
 ┣ User
 ┃ ┗ UserViewController.swift
 ┣ AppDelegate.swift
 ┣ Info.plist
 ┣ Observable.swift
 ┣ SceneDelegate.swift
 ┗ ViewController.swift
```

