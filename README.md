# BithumbTest

### 1. 사용한 3rd-parties
  1. SwiftLint: 일관된 컨벤션을 유지할 수 있게 많이 도와줘서 사용했습니다
  2. CocoaPods: SwiftLint을 적용하기 위해 사용했습니다

<br>

---

<br>

### 2. 구현내용
![Simulator Screen Recording - iPod touch (7th generation) - 2022-02-02 at 13 52 54](https://user-images.githubusercontent.com/83933153/152095141-740f9c0b-9375-4003-bcd6-8f32eb6d44cd.gif)

1. HTTP 통신을 통해 처음에 Ticker들을 뿌려주도록 한 뒤, WS통신을 통해 현재 화면에 보여지는 Ticker들을 지속적으로 갱신하도록 구현하였습니다
2. 코어데이터를 활용하여 관심코인을 저장하도록 구현하였습니다

<br>

![Simulator Screen Recording - iPod touch (7th generation) - 2022-02-02 at 13 50 47](https://user-images.githubusercontent.com/83933153/152095254-3b5dc444-c434-4ba5-823d-b85da5b73c33.gif)

1. HTTP 통신을 통해 처음에 Ticker들을 뿌려주도록 한 뒤, WS통신을 통해 현재 화면에 보여지는 Ticker들을 지속적으로 갱신하도록 구현하였습니다
2. HTTP 통신을 통해 Candlestick들을 가져온 뒤, opening price를 기준으로 linear chart를 그리도록 구현하였습니다
  * 해당 내용은 코어데이터에 저장해놓은 뒤 재사용할 수 있도록 구현하였습니다.

<br>

![Simulator Screen Recording - iPod touch (7th generation) - 2022-02-02 at 14 17 00](https://user-images.githubusercontent.com/83933153/152097226-03ad0d99-3879-4682-aa2e-bc49bc11c4b0.gif)

1. 다이나믹타입을 이용하여 시스템 폰트 크기에 따라 화면이 바뀌도록 수정하였습니다
2. 테이블뷰에 Voice-over를 잘 사용할 수 있도록 하여, 셀 단위로 컨텐츠를 읽도록 하였습니다


<br>

---

<br>

### 3. 타임라인
| Day | Task |
|:---:|---|
| 1 | * 프로젝트 생성 <br> * SwiftLint 적용 <br> * public WebsocketAPI 및 HTTPAPI 확인. 상태코드 및 에러코드 확인 <br> * public WebsocketAPI를 이용하여 현재가 및 체결 정보 구하는 내용 구현 <br>  * 요청 메시지를 만들 때 잘 만들어지는지 확인하기 위해서 약간의 유닛테스트 구현 |
| 2 | * 코로나 2차를 맞느라 진행을 많이 못했습니다 <br> * WS와 HTTP를 요청 및 응답을 분리하도록 결정한 뒤 관련 타입에 prefix를 붙여서 구분 <br> * HTTP 요청을 통해 모든 코인의 현재정보를 가져오는 HTTPTickerAllRequester 구현 -> 메인화면에 사용할 예정|
| 3 | * 백신 맞고 골골대다가 낮잠을 자서 많이 진행은 못했습니다 <br> * 네트워크 요청 모델 및 응답 모델 관련 정리 및 가독성을 위한 이름 수정 <br> * 메인화면 구현을 위해 틀을 잡아놓았고 디테일한 기능구현 필요 |
| 4 | * 메인화면 관련 뷰 컴포넌트들 구현 <br> * 컴포넌트들에 접근성 관련 내용 추가 <br> * 가독성을 위해 모델의 프로퍼티드 이름 수정, 익스텐션 및 주석 정리 |
| 5~7 | * 솔팅을 위해 필요한 기능들을 추가 <br> * 네트워킹 관련 로딩 화면을 윈도우의 루트뷰컨트롤러에 추가 |
| 8~9 | * HTTPCoin와 WSCoin이 잘 매칭이 되도록 수정 <br> * 코인리스트에서 WS을 활용하여 셀의 내용이 갱신이 되도록 수정 <br> * Coordinator 패턴을 적용해보기 위해서 공부 및 테스트 |
| 10 | * Coordinator 관련 조정  <br> * Orderbook 요청을 위한 도메인 모델 추가 및 HTTP 모델 추가 <br> * 코인 상세페이지 관련 뷰 및 뷰컨 추가 중... |
| 11~13 | * Orderbook을 코인 상세화면에서 보여줄 수 있도록 HTTP 모델과 WS 모델을 구현 <br> * WS모델을 통해 실시간으로 Orderbook을 갱신하도록 해보고 싶었으나 도메인 지식이 많이 부족하여 보류... <br> * 빗섬앱을 벤치마킹하여 당장 할 수 있는 선에서 레이아웃을 구현 <br> * 차트뷰 관련 작업 중 |
| 14 | * 컨텐츠 뷰컨에서 view.addSubview가 아니라 view를 교체하도록 수정 <br> * Chart데이터 요청하는 모델 및 API 생성 <br> * LinearChartViewController 생성 <br> * 로컬데이터 관리를 위해 CoreData 관련 타입 구현 중 |
| 15~16 | * 미사용 코드 정리 <br> * 디코딩 관련 에러로 인해 HTTPCoin 수정 <br> * 거래소 화면에서 결제통화 및 관심 등을 데이터를 가져오도록 수정 <br> * LinearChatView 내용을 수정하여 opening_price를 기준으로 색이 변경되도록 수정 |


### 4. 트러블슈팅

<details>
  <summary>1. API 관련</summary>  
  
  <img width="769" alt="스크린샷 2022-02-02 오후 2 09 26" src="https://user-images.githubusercontent.com/83933153/152096526-4cfa276e-384e-4aa3-aeec-66d84d8ce80a.png">

  1. API의 response들이 Swift를 위한 것은 아니라는 생각이 먼저 들었습니다. 특히 Public Ticker의 주문 통화가 ALL일 경우에는 data에 Coin과 date가 같은 레벨에 존재했고 이러한 부분이 나이브한 딕셔너리로 처리하기에는 어려움이 있었습니다. 예를 들면 [String: Coin]과 같이 처리할 수가 없었는데, Coin과 Date를 enum으로 묶어서 각각의 경우에 따라 파싱을 할 수 있도록 처리를 하였습니다.

  <br>

  <img width="712" alt="스크린샷 2022-02-02 오후 2 06 32" src="https://user-images.githubusercontent.com/83933153/152096325-a48b3ec2-9714-442e-8333-407d3d88d4e6.png">

  2. 또 fluctate_rate_24H가 주문통화가 KRW일 때에는 stirng으로 오는 반면 BTC일 때에는 number로 오는 경우가 있어 어려움이 있었습니다. 해당 내용도 각각의 경우를 enum으로 묶어서 처리하도록 구현하였습니다

</details>

<details>
  <summary>2. Indicator, Alert 관련</summary>
  1. 처음 생각했던 방향은 모두 window의 rootViewController를 통해 보여주려고 생각했습니다. 특히 네트워크 통신 관련 로딩이 발생할 경우 Indicator를 뿌려줄 때에는, 각각의 뷰컨이 이러한 기능을 갖기보다는 윈도우에서 처리하는 게 더 바람직할 것 같아 Notification을 활용하여 구현하였습니다
  2. 에러도 마찬가지의 방향을 생각했으나, 곰곰히 생각해보니 에러의 경우에는 화면의 내용에 따라 액션이 달라질 수가 있다고 생각됐습니다. 예를 들면 Ticker를 가져오는 것에 대한 에러는 다시 요청을 한다거나 고객센터에 문의를 남겨달라는 메시지 정도로 퉁칠 수 있겠지만, 실제로 코인을 매수하거나 매도하는 경우에는 에러가 발생할 경우는 다를 것 같다고 생각했습니다. 특히 입력값에 확인이 필요할 경우에는, Alert을 띄운 뒤 이것을 닫고 재입력을 시키는 것보다는 Alert에서 재입력을 하도록 할 수도 있을 것 같다는 생각이 들었고, 이러한 방향에 따라 기본적인 내용은 POP로 가져가고 필요에 따라 재정의를 할 수 있도록 구현을 하였습니다.
</details>
