# LCK 경기 예측 서비스

[![Java](https://img.shields.io/badge/Java-17-orange.svg)](https://www.oracle.com/java/)
[![Spring](https://img.shields.io/badge/Spring-6.2.5-brightgreen.svg)](https://spring.io/)
[![TailwindCSS](https://img.shields.io/badge/TailwindCSS-3.4.1-blue.svg)](https://tailwindcss.com/)
[![MySQL](https://img.shields.io/badge/MySQL-9.2.0-blue.svg)](https://www.mysql.com/)
[![Tomcat](https://img.shields.io/badge/Tomcat-10-red.svg)](https://tomcat.apache.org/)

LCK 경기 예측 서비스는 League of Legends 한국 프로리그인 LCK의 경기 결과를 예측하고 포인트를 획득할 수 있는 웹 애플리케이션입니다. 사용자들은 실시간으로 업데이트되는 경기 일정을 확인하고, 승리팀을 예측하며, 예측 정확도에 따라 포인트를 획득할 수 있습니다.

## 🌟 주요 기능

- **사용자 계정 관리**: 회원가입, 로그인, 로그아웃 기능
- **실시간 경기 일정**: 최신 LCK 경기 일정 확인
- **경기 결과 예측**: 경기 시작 전 승리팀 예측 기능
- **포인트 시스템**: 정확한 예측 시 포인트 획득
- **개인 예측 기록**: 사용자의 예측 기록 및 정확도 확인
- **팀 순위표**: 실시간 LCK 팀 순위 및 전적 확인

## 🛠 기술 스택

### 백엔드
- **Java 17**: 프로그래밍 언어
- **Spring Framework 6.2.5**: 웹 애플리케이션 프레임워크
- **Spring Security 6.3.5**: 인증 및 권한 관리
- **MySQL 9.2.0**: 데이터베이스
- **Jakarta Servlet 6.1.0**: 웹 컨테이너 API
- **JSTL 3.0.0**: JSP 태그 라이브러리
- **Jsoup 1.15.3**: 웹 크롤링 라이브러리
- **Jackson 2.18.3**: JSON 처리 라이브러리

### 프론트엔드
- **JSP**: 서버 사이드 렌더링
- **TailwindCSS 3.4.1**: CSS 프레임워크
- **Font Awesome 6.0.0**: 아이콘 라이브러리

### 인프라
- **Tomcat 10**: 웹 애플리케이션 서버
- **Docker**: 컨테이너화 및 배포

## 🚀 시작하기



이 프로젝트의 데모는 Render를 통해 배포되어 있습니다:

[https://lck-match.onrender.com/](https://lck-match.onrender.com/)

> 참고: Render의 무료 티어를 사용하고 있어, 일정 시간 동안 활동이 없으면 서버가 슬립 모드로 전환될 수 있습니다. 처음 접속 시 로딩 시간이 길어질 수 있습니다.

프로젝트에서 사용하는 주요 테이블은 다음과 같습니다:

- **USERS**: 사용자 정보
- **MATCHES**: 경기 정보
- **LCK_TEAMS**: 팀 정보
- **PREDICTED_MATCHES**: 사용자 예측 정보
- **SCHEDULER**: 데이터 업데이트 스케줄러 정보

## 🔍 프로젝트 구조

```
src/main/java/com/example/predict_match/
├── config/                  # 스프링 및 보안 설정
├── controller/              # 웹 컨트롤러
├── model/                   # 데이터 모델
│   ├── dto/                 # 데이터 전송 객체
│   └── repository/          # 데이터 액세스 레이어
├── service/                 # 비즈니스 로직
└── util/                    # 유틸리티 클래스

src/main/webapp/
├── WEB-INF/
│   └── views/               # JSP 뷰 템플릿
└── asset/
    └── css/                 # CSS 파일
```

## 🏗️ 시스템 아키텍처

다음 다이어그램은 LCK 경기 예측 서비스의 전체 아키텍처와 핵심 구성 요소 간의 상호작용을 보여줍니다:

![LCK 경기 예측 서비스 아키텍처](https://github.com/rbxo0128/predict_match/raw/main/docs/architecture.svg)

> **참고**: 위 다이어그램을 보려면 `docs/architecture.svg` 파일이 저장소에 존재해야 합니다. SVG 파일을 다운로드한 후 프로젝트의 `docs` 폴더에 저장하세요.

### 시스템 구성 요소

1. **웹 프론트엔드**: JSP와 TailwindCSS를 사용한 사용자 인터페이스 레이어
2. **백엔드 서버**: Java와 Spring 프레임워크 기반의 비즈니스 로직 처리
3. **데이터베이스**: MySQL을 사용한 데이터 저장소
4. **웹 크롤링**: Jsoup 라이브러리를 활용한 LCK 경기 데이터 수집
5. **스케줄러**: 자동 데이터 업데이트 및 포인트 계산을 위한 배치 작업

### 주요 데이터 흐름

1. 사용자는 웹 인터페이스를 통해 경기를 예측합니다.
2. 백엔드 서버는 사용자 예측을 데이터베이스에 저장합니다.
3. 웹 크롤러는 정기적으로 네이버 스포츠에서 최신 경기 결과를 수집합니다.
4. 스케줄러는 경기 결과가 확정되면 사용자 예측과 비교하여 포인트를 계산합니다.
5. 사용자는 자신의 예측 성공률과 획득한 포인트를 확인할 수 있습니다.

## 🔄 데이터 업데이트

LCK 경기 데이터는 하루에 한 번 네이버 스포츠 페이지에서 자동으로 크롤링하여 업데이트됩니다. `JsoupRepository` 클래스가 웹 크롤링을 담당하며, `MatchRepository`가 데이터베이스에 저장합니다.

## 🔐 보안

Spring Security를 사용하여 인증 및 권한 관리를 구현했습니다. 사용자 비밀번호는 BCrypt 알고리즘으로 암호화되어 저장됩니다.


## 📝 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.



## 📂 프로젝트 문서

아키텍처 다이어그램을 포함한 추가 문서는 `/docs` 디렉토리에서 찾을 수 있습니다:


---

**참고**: 이 서비스는 Riot Games 또는 LCK와 공식적으로 연결되거나 승인되지 않았습니다. League of Legends와 LCK는 Riot Games, Inc.의 상표입니다.