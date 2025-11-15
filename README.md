# Subs Track

구독 서비스 관리 앱입니다. 여러 구독 서비스의 정보를 한 곳에서 관리하고, 월간 총 구독 비용을 추적할 수 있습니다.

## 📱 앱 소개

Subs Track은 사용자가 구독 중인 다양한 서비스(스트리밍, 클라우드 스토리지, 멤버십 등)를 효율적으로 관리할 수 있도록 도와주는 Flutter 기반 모바일 애플리케이션입니다.

### 주요 기능

- ✅ **구독 서비스 목록 조회**: 등록된 모든 구독 서비스를 한눈에 확인
- ➕ **구독 서비스 등록**: 새로운 구독 서비스 정보 추가
- 💰 **월간 총 비용 계산**: 모든 구독 서비스의 월간 총 비용 자동 계산
- 📅 **결제일 관리**: 각 구독 서비스의 결제일 추적
- 🔄 **결제 주기 관리**: 월간/연간 결제 주기 지원
- 💱 **다중 통화 지원**: KRW, USD 통화 지원
- 🌙 **다크 모드 지원**: 시스템 설정에 따른 자동 다크 모드 전환


## 📁 프로젝트 구조

```
lib/
├── core/                                        # 핵심 기능
│   ├── constants/                               # 상수 정의
│   ├── extensions/                              # 확장 메서드
│   ├── theme.dart                               # 앱 테마 설정 (라이트/다크 모드)
│   └── utils/                                   # 유틸리티 함수
│       └── currency_utils.dart                  # 통화 포맷팅 유틸리티
│
├── models/                                      # 데이터 모델
│   └── subscription/
│       └── subscription_model.dart              # 구독 서비스 모델
│
├── viewmodels/                                  # 뷰 모델 (비즈니스 로직)
│   └── subscription/
│       └── subscription_notifier.dart           # 구독 서비스 상태 관리
│
├── views/                                       # UI 화면
│   ├── home/
│   │   └── home_view.dart                       # 홈 화면 (구독 목록)
│   └── registration/
│       └── subscription_registration_view.dart  # 구독 등록 화면
│
└── main.dart                                    # 앱 진입점
```

## 🏗 아키텍처

이 프로젝트는 **MVVM (Model-View-ViewModel)** 패턴을 따릅니다:

- **Model**: `SubscriptionModel` - 구독 서비스 데이터 구조
- **View**: `HomeView`, `SubscriptionRegistrationView` - UI 화면
- **ViewModel**: `SubscriptionNotifier` - 비즈니스 로직 및 상태 관리

### 상태 관리 흐름

```
View (UI)
  ↓ watch/read
Riverpod Provider
  ↓
StateNotifier (ViewModel)
  ↓
Model (Data)
```

## 📖 주요 기능 설명

### 1. 구독 서비스 목록

홈 화면에서 등록된 모든 구독 서비스를 확인할 수 있습니다. 각 항목에는 다음 정보가 표시됩니다:
- 서비스 이름
- 구독료 (포맷팅된 금액)
- 결제 주기 (매월/매년)
- 결제일

### 2. 월간 총 비용

홈 화면 상단에 이번 달 총 구독 비용이 자동으로 계산되어 표시됩니다.
- 월간 구독: 금액 그대로 합산
- 연간 구독: 금액을 12로 나눈 값으로 합산

### 3. 구독 서비스 등록

새로운 구독 서비스를 등록할 수 있습니다:
- 서비스 이름
- 구독료
- 결제일 (날짜 선택기 사용)
- 결제 주기 (매월/매년)
- 통화 (KRW/USD)

### 4. 통화 포맷팅

통화별로 적절한 포맷으로 금액을 표시합니다:
- KRW: 천 단위 구분 기호 포함 (예: 1,490)
- USD: 달러 기호 포함 (예: $9.99)

## 🔍 AI 코드 리뷰

이 프로젝트는 AI를 활용한 자동 코드 리뷰를 지원합니다. 작업 내용을 템플릿에 작성하고 파일 경로만 전달하면, AI가 자동으로 변경사항을 탐색하고 맥락을 파악한 후 리뷰를 진행합니다.

### 워크플로우

1. **작업 내용 작성**: `.code-review-prompt-template.md` 파일에 작업 내용 작성
2. **AI에게 요청**: `./.code-review-prompt-template.md 파일을 확인해서 코드리뷰를 해줘`
3. **자동 처리**: AI가 자동으로 변경사항 탐색 → 맥락 파악 → 리뷰 진행

### 문서
- **[프롬프트 템플릿](.code-review-prompt-template.md)**: 작업 내용을 작성하는 템플릿
- **[워크플로우 가이드](.code-review-workflow.md)**: 전체 워크플로우 상세 설명
- **[코드 리뷰 룰](.code-review-rules.md)**: AI가 코드 리뷰 시 사용하는 기준과 룰

### 사용 방법

**1단계: 템플릿에 작업 내용 작성**
```markdown
### 작업 개요
구독 서비스 삭제 기능 추가

### 주요 변경사항
- 삭제 버튼 추가
- 삭제 확인 다이얼로그 구현
- StateNotifier에 removeSubscription 메서드 추가
```

**2단계: AI에게 요청**
```
./.code-review-prompt-template.md 파일을 확인해서 코드리뷰를 해줘
```

**3단계: AI 자동 처리**
- 템플릿 파일 읽기
- git diff로 변경사항 자동 탐색
- 관련 파일들 자동 분석
- 맥락 파악 후 리뷰 진행

## 🚀 시작하기

### 필수 요구사항
- Flutter SDK 3.7.2 이상
- Dart SDK 3.7.2 이상
- Android Studio / VS Code (Flutter 확장 프로그램)
- iOS 개발 시 Xcode (macOS만)

### 설치 및 실행

1. **저장소 클론**
   ```bash
   git clone <repository-url>
   cd subs_track
   ```

2. **의존성 설치**
   ```bash
   flutter pub get
   ```

3. **앱 실행**
   ```bash
   flutter run
   ```

### 빌드

```bash
# Android APK 빌드
flutter build apk

# Android App Bundle 빌드
flutter build appbundle

# iOS 빌드 (macOS만)
flutter build ios
```

## 📄 라이선스

이 프로젝트는 개인 프로젝트입니다.
