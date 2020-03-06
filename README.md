# G-TEAM [2019-2 아주대학교 SW 캡스톤디자인]
---------------------------------------
## About G-TEAM
- 2040 직장인들이 쉽게 단체운동을 즐길 수 있도록 사람을 모아주는 애플리케이션 서비스
---------------------------------------
## Authors & Role (가나다 순)
- 김도현: Overall Project Management
- 김영운: Database Management (Backend)
- 김학준: Application UI & Integrate Frontend and Backend
- 안우일: Application UI & Web(in Server)
---------------------------------------
## Function of G-TEAM
#### 1. User (in Android Application)
- 로그인 및 회원가입 기능 (Google 로그인 포함)
- 게임 생성 및 참여 기능 (지도를 이용한 경기장 선택 기능 포함)
- 필터링(참여율, 참여가격)과 검색을 통한 게임 검색 기능
- 포인트를 통한 결제 기능 (신용카드, 페이, 핸드폰결제) 
- 게임 참여자들 간 채팅 기능 
- 푸시 알람을 이용하여 게임 상태 알림 기능
- 현재 참여 게임 모아보기 기능
- 경기장 평가 기능

#### 2. Facility Manager (in Android Application)
- 관리하는 경기장 추가 기능
- 경기장 예약 승인 기능  
- 경기장 예약 보기 및 관리 기능
- 경기장 정보 수정 기능
- 푸시 알람을 이용한 예약 알림 기능

#### 3. System Manager (in Web)
- 유저 리스트 보기 기능
- 경기장 목록 보기 기능
- 경기장 관리자 계정 권한 부여 기능
---------------------------------------
## FrameWork & Language
- **App (For User & Facility Manager)**
  - FrameWork: Flutter (Language: Dart)
  - DataBase: Firebase
  <br><br>
- **Web (For Admin)**
  - Frontend: BootStrap (HTML, CSS)
  - Backend: Django (Language: Python)
  <br><br>
- **사용하는 외부 API**
  - Google MAP API
  - IamPort API
---------------------------------------
## Reference
- flutter UI      <https://flutterawesome.com/> 
- flutter ICON    <https://fontawesome.com/icons>  
- additional ICON <https://www.flaticon.com/> 
- lifecycle of flutter <https://flutterbyexample.com/stateful-widget-lifecycle/>
---------------------------------------
## Getting Started (Flutter)

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

