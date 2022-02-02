# BithumbTest

### 사용한 3rd-parties
  1. SwiftLint: 일관된 컨벤션을 유지할 수 있게 많이 도와줘서 사용했습니다
  2. CocoaPods: SwiftLint을 적용하기 위해 사용했습니다


<details>
 <summary> 타임라인 </summary>
 
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
 
</details>
