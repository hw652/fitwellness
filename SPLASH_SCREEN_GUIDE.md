# 스플래시 스크린(Splash Screen) 관리 가이드

이 프로젝트는 `flutter_native_splash` 패키지를 사용하여 네이티브 스플래시 스크린(앱 시작 시 보이는 화면)을 관리하고 있습니다.
이 방식은 안정적이며, `pubspec.yaml` 설정을 통해 iOS와 Android의 스플래시 화면을 자동으로 생성해줍니다.

## 1. 구성 요소

-   **패키지**: `flutter_native_splash`
-   **설정 파일**: `pubspec.yaml` 내 `flutter_native_splash` 섹션
-   **이미지 리소스**: `assets/images/loading_page.jpeg` (현재 설정된 이미지)

## 2. 현재 설정 (`pubspec.yaml`)

현재 설정은 이미지가 화면을 가득 채우도록(`fill`/`scaleAspectFill`) 설정되어 있습니다.

```yaml
flutter_native_splash:
  background_image: assets/images/loading_page.jpeg
  android_gravity: fill
  ios_content_mode: scaleAspectFill
  fullscreen: true
  android_12:
    background_image: assets/images/loading_page.jpeg
```

## 3. 스플래시 스크린 변경 방법

스플래시 이미지를 변경하거나 설정을 수정하려면 다음 절차를 따르세요.

1.  **이미지 준비**:
    *   새로운 이미지를 `assets/images/` 폴더에 넣습니다. (예: `new_splash.png`)

2.  **설정 수정**:
    *   `pubspec.yaml` 파일을 엽니다.
    *   `flutter_native_splash` 섹션에서 `background_image` 경로를 새 이미지 경로로 변경합니다.
    *   필요에 따라 `android_gravity`나 `ios_content_mode`를 조정할 수 있습니다. (옵션: `center`, `contain`, `cover` 등 패키지 문서 참조)

3.  **명령어 실행 (필수)**:
    *   설정 변경 사항을 네이티브 프로젝트(Android/iOS)에 반영하기 위해 아래 명령어를 터미널에서 실행합니다.

    ```bash
    dart run flutter_native_splash:create
    ```

    *   이 명령어를 실행해야만 실제 앱의 스플래시 화면이 업데이트됩니다.

## 4. 참고 사항

*   `android_12` 섹션은 Android 12 이상의 Splash Screen API 대응을 위한 설정입니다.
*   현재 코드(`main.dart`)에는 `FlutterNativeSplash.preserve()` 등이 적용되어 있지 않으므로, 앱이 로드되고 첫 화면이 그려지면 스플래시 화면은 자동으로 사라집니다.
