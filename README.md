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
