# BitBox

![Image](https://github.com/user-attachments/assets/b30e4b03-9636-4be3-b582-3d811b2bbd8b)

### 실시간 시세 조회부터 관심 코인 즐겨찾기까지, 스마트하게 관리하세요.

> 최신 코인 및 NFT 시세를 실시간으로 확인하고, 관심 있는 코인은 즐겨찾기로 관리하며 트렌드를 한눈에 파악할 수 있는 시세 분석 앱입니다.
> 

---

# 📚 목차

1. [⭐️ 주요 기능](#features)
2. [💻 개발 환경](#development-environment)
3. [📋 설계 패턴](#design-patterns)
4. [🛠️ 기술 스택](#tech-stack)
5. [🚀 트러블 슈팅](#troubleshooting)
   - [Refresh & NSCache 활용한 네트워크 통신 최적화](#troubleshooting1)
   - [CompositionalLayout의 프로토콜 기반 설계](#troubleshooting2)
6. [🗂️ 파일 디렉토리 구조](#file-directory-structure)

---

<h1 id="features">⭐️ 주요 기능</h1>

**1. 트렌디한 코인 & NFT 한눈에**

- 메인 화면에서 최신 인기 코인 TOP 15 및 NFT TOP 7 제공

**2. 검색 기능**

- 원하는 코인을 검색하여 상세 정보 확인

**3. 코인 세부 정보 제공**

- 현재 가격, 신저점, 신고점, 변동률 등 다양한 데이터 제공
- 가격 변동을 한눈에 볼 수 있는 차트 지원

**4. 즐겨찾기 기능**

- 관심 있는 코인을 즐겨찾기로 등록
- 즐겨찾기한 코인은 홈 화면 상단 및 별도 탭에서 빠르게 확인 가능

---

<h1 id="development-environment">💻 개발 환경</h1>

- **개발 기간**: 2024.02.27 ~ 2024.03.02
- **앱 지원 iOS SDK**: iOS 16.0 이상
- **Xcode**: 15.0 이상
- **Swift 버전**: 5.8 이상

---

<h1 id="design-patterns">📋 설계 패턴</h1>

- **Input-Output Custom Reactive MVVM**: UI와 비즈니스 로직 분리
- **싱글턴 패턴**: 전역적으로 관리가 필요한 객체를 재사용하기 위해 사용

---

<h1 id="tech-stack">🛠️ 기술 스택</h1>

### **기본 구성**

- **UIKit**: iOS 사용자 인터페이스 구현
- **SnapKit**: 간결한 Auto Layout 코드 작성
- **Codebase UI**: 코드 기반으로 UI를 설계하여 Storyboard 의존성 제거
- **ComposableLayout**: UICollectionView 레이아웃 설계

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

<h1 id="troubleshooting">🚀 트러블 슈팅</h1>

<h2 id="troubleshooting1">Refresh & NSCache 활용한 네트워크 통신 최적화</h2>

### **1. 문제 정의**

- 코인 정보와 관련된 외부 API의 호출 횟수가 극히 제한
- 초기에는 viewWillAppear 시점마다 네트워크 통신을 수행하여 데이터를 갱신했는데, 이 방식은 사용자가 즐겨찾기한 코인 항목이 바뀌지 않았음에도 불필요하게 매번 요청을 발생시키는 문제가 존재
- 단순히 화면을 이동하거나 돌아오는 것만으로도 불필요한 요청이 반복되면서 호출 횟수를 낭비
- 이를 해결하기 위해 Refresh 기능을 도입하여 통신 시점을 제한하였으나, 이 역시 사용자의 즐겨찾기 상태가 변경되지 않은 경우에도 새로고침만으로 항상 네트워크 요청이 발생.

### **2. 문제 해결**

- 즐겨찾기한 코인 리스트를 키로 활용하여, 해당 상태에서 받아온 응답 데이터를 NSCache에 저장
- 새로고침이 발생해도 동일한 즐겨찾기 상태라면 캐시 된 데이터를 우선 활용하고 API 요청은 생략
- 코인 정보는 수시로 변동되기 때문에, 캐시 생성 시각을 함께 저장하고, 일정 시간이 지나면 캐시를 무효화하고 API를 재호출
- API 호출 횟수를 최소화하면서도 사용자에게는 최신 데이터를 제공하는 구조로 개선

### **3. 결과**

- API 호출 횟수 최소화로 외부 API의 호출 제한 정책에 안정적으로 대응
- 불필요한 리소스 낭비 제거, 앱의 성능과 반응 속도 향상
- 사용자 입장에서는 항상 최신 데이터가 표시되면서도 빠른 체감 속도 유지

<h2 id="troubleshooting2">CompositionalLayout의 프로토콜 기반 설계</h2>

### **1. 문제 정의**

- CompositionalLayout을 적용하면서 섹션별로 개별적인 레이아웃을 정의해야 하는 문제 발생
- 섹션별로 다른 속성을 적용하면서도 전체 레이아웃 코드는 일관된 구조로 관리될 필요가 존재
- orthogonalScrollingBehavior, boundarySupplementaryItems 등 섹션별로 다른 속성은 유연하게 설정할 필요가 있음

### **2. 문제 해결**

- 공통 인터페이스로서 layoutSection() 메서드를 정의한 Section 프로토콜을 설계
- 각 섹션이 해당 프로토콜을 채택하여 자신의 레이아웃을 독립적으로 구현
- 이 구조를 통해 공통된 틀을 유지하면서도, 섹션마다 필요한 속성을 유연하게 설정할 수 있도록 구성

### **3. 결과**

- 일관된 구조 속에서 유연한 섹션별 커스터마이징 가능
- 새로운 섹션 추가 시 기존 코드를 손대지 않고 확장 가능, 구조적 확장성 확보
- CompositionalLayout 코드의 가독성과 유지보수성 개선
- 개발 속도 향상 및 레이아웃 관련 버그 발생 가능성 감소

---

<h1 id="file-directory-structure">🗂️ 파일 디렉토리 구조</h1>

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

