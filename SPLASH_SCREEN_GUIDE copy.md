# 스플래시 스크린(Splash Screen) 관리 가이드

이 프로젝트는 **2단계 스플래시 구조**를 가지고 있습니다.
1. **Native Splash**: 앱이 메모리에 로드되는 동안 보여지는 네이티브 화면 (`flutter_native_splash` 패키지 관리)
2. **Flutter Splash**: 앱 실행 직후 초기화 로직이나 부드러운 전환을 위해 보여지는 Flutter 위젯 (`SplashScreen` 클래스)

이 두 화면이 자연스럽게 이어지도록 설정되어 있습니다.

## 1. Native Splash (앱 기동 전)

앱 아이콘을 누르자마자 뜨는 화면입니다.

-   **패키지**: `flutter_native_splash`
-   **설정 파일**: `pubspec.yaml` 내 `flutter_native_splash` 섹션
-   **이미지 리소스**: `assets/images/loading_page.jpeg`
-   **관리 방법**:
    1. `assets/images/`에 새 이미지 추가
    2. `pubspec.yaml`에서 경로 수정
    3. 터미널에서 `dart run flutter_native_splash:create` 실행 (필수)

```yaml
# pubspec.yaml 예시
flutter_native_splash:
  background_image: assets/images/loading_page.jpeg
  android_gravity: fill
  ios_content_mode: scaleAspectFill
  fullscreen: true
```

## 2. Flutter Splash (앱 기동 후)

Native Splash가 사라진 직후 보이는 Flutter 화면입니다. 현재 1초간 대기 후 환영 페이지로 이동하도록 코딩되어 있습니다.

-   **파일 위치**: `lib/features/onboarding/splash_screen.dart`
-   **이미지 리소스**: `assets/images/loading_page.jpeg` (Native와 동일한 이미지 사용 중)
-   **동작 로직**:
    -   `initState`에서 1초 지연(`Future.delayed`) 후 `/welcome` 라우트로 이동
    -   `Image.asset`을 사용하여 화면을 가득 채움(`BoxFit.cover`)

```dart
// lib/features/onboarding/splash_screen.dart
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToWelcome();
  }

  Future<void> _navigateToWelcome() async {
    await Future.delayed(const Duration(seconds: 1)); // 1초 대기
    if (mounted) {
      context.go('/welcome');
    }
  }
  // ... build 메서드에서 이미지 출력
}
```

## 3. 수정 시 주의사항

자연스러운 사용자 경험(UX)을 위해 **두 단계의 이미지를 통일**하는 것이 좋습니다.

1.  **이미지 변경 시**:
    -   `pubspec.yaml` 수정 및 `dart run flutter_native_splash:create` 실행 (Native 반영)
    -   `lib/features/onboarding/splash_screen.dart`의 `Image.asset` 경로 수정 (Flutter 반영)

2.  **대기 시간 수정 시**:
    -   `lib/features/onboarding/splash_screen.dart`의 `Duration(seconds: 1)` 값을 변경하세요.

3.  **초기화 로직 추가 시**:
    -   `_navigateToWelcome` 함수 내 `Future.delayed` 대신 필요한 비동기 로직(API 호출, 데이터 로드 등)을 추가하면 됩니다.
