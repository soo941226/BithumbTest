# BithumbTest

### Day1
* 프로젝트 생성
* SwiftLint 적용
* public WebsocketAPI 및 HTTPAPI 확인. 상태코드 및 에러코드 확인
* public WebsocketAPI를 이용하여 현재가 및 체결 정보 구하는 내용 구현
  * 요청 메시지를 만들 때 잘 만들어지는지 확인하기 위해서 약간의 유닛테스트 구현
  
### Day2
* 코로나 2차를 맞느라 진행을 많이 못했습니다
* WS와 HTTP를 요청 및 응답을 분리하도록 결정한 뒤 관련 타입에 prefix를 붙여서 구분
* HTTP 요청을 통해 모든 코인의 현재정보를 가져오는 HTTPTickerAllRequester 구현 -> 메인화면에 사용할 예정

### Day3
* 백신 맞고 골골대다가 낮잠을 자서 많이 진행은 못했습니다
* 네트워크 요청 모델 및 응답 모델 관련 정리 및 가독성을 위한 이름 수정
* 메인화면 구현을 위해 틀을 잡아놓았고 디테일한 기능구현 필요

### Day4
* 메인화면 관련 뷰 컴포넌트들 구현
* 컴포넌트들에 접근성 관련 내용 추가
* 가독성을 위해 모델의 프로퍼티드 이름 수정, 익스텐션 및 주석 정리

### Day5~7
* 솔팅을 위해 필요한 기능들을 추가
* 네트워킹 관련 로딩 화면을 윈도우의 루트뷰컨트롤러에 추가

### Day8~9
* HTTPCoin와 WSCoin이 잘 매칭이 되도록 수정
* 코인리스트에서 WS을 활용하여 셀의 내용이 갱신이 되도록 수정
* Coordinator 패턴을 적용해보기 위해서 공부 및 테스트
