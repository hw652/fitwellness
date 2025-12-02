\## Korean Text \& Encoding (Hangul Safety)

\- Always save files as UTF‑8. When scripting on Windows/PowerShell use: `Set-Content -Encoding UTF8` and `$PSDefaultParameterValues\['Out-File:Encoding']='utf8'`.

\- If using a console, run `chcp 65001` before text operations to avoid mojibake.

\- Avoid pasting from PDFs/screenshots; retype Hangul literals when possible.

\- Git settings (optional): `git config --global core.quotepath false` and `git config --global i18n.logOutputEncoding utf8`.

\- Agent keywords to honor when editing text: `UTF8\_ONLY`, `KEEP\_HANGUL`, `NO\_MOJIBAKE`, `DO\_NOT\_REENCODE`, `UTF8\_SAVE`.

   1. "Centralized Theme" (중앙 집중식 테마)
      > "색상이나 폰트 사이즈를 위젯에 직접 하드코딩(Hard-coding)하지 말고, `lib/theme/` 폴더에 `ThemeData`를 정의해서 거기서 불러오도록 짜줘."
   2. "ThemeExtension" (커스텀 토큰)
      > "우리 앱에는 'Gold' 등급과 'Silver' 등급 색상이 있어. 이걸 `ThemeExtension`으로 정의해서 Theme.of(context).extension<MyColors>()!.gold 처럼 쓸 수 있게       
  해줘."
   3. "Export Constants" (상수화)
      > "여백(Spacing)이랑 둥글기(Radius) 값은 AppDimens 같은 별도 클래스에 `static const`로 모아서 관리해줘. 숫자 16.0, 8.0을 코드에 직접 쓰지 마."

중간에 사용자가 원하는게 몇번 잘 안되면, 원하는 크기를 명시해서 강제해서 해결해보거나 사용자에게 제시할것.
  - Row는 “가로 스크롤 리스트”일 때 SingleChildScrollView가 잘 맞고,                                                                                                                                                                                             
  - Column은 “화면 전체를 위아래로 스크롤하는 페이지”일 때만 쓰는 게 좋고,                                                                                                                                                                                       
  - 카드/셀 안 Column overflow는 지금처럼 Expanded 등으로 잡는 게 더 안전한 설계
터치 영역 때문에 삽입된 아이콘이 너무 큰 공간을 차지하지 않도록 배려할것.

SafeArea로 하단의 ||| O < 가 침범 받지 않도록 할 것.
플러터로 앱 개발시 guideline_pages 폴더안의 디자인 규격을 거의 최대한 맞출 것.
각 화면의 라우터 연결은 일반적인 라우터 연결 형태를 따르나, 모두 맞춰서 구성한 이후에 사용자에게 구성한 내용이 맞는지 물어볼 것.
do 'flutter analyze' after modification.(warning! :  RenderFlex overflow는 flutter analyze를 통해 미리 파악할 수 없음)(info 수준의 경보도 그냥 가능한 시간 있을때에 제거할 것.)

* RenderFlex overflow 를 사전에 방지 하기 위한 방법
-> Expanded 또는 Flexible 위젯 사용: Row나 Column 내에서 공간을 유연하게 할당해야 하는 자식 위젯을 Expanded나 Flexible로 감싸면 됩니다. Expanded는 남은 공간을 모두 차지하고, Flexible은 필요에 따라 공간을 차지하되 넘치지 않도록 조절합니다.

iPhone pro의 lidar 사용시 pbxproj에 DepthChannel을 등록해야 에러가 발생하지 않음. camera preview도 platformview 구성을 사용해야 추가 가능함.
lidar 사용시 ios 프로젝트 설정에 15.6 버전 이상을 사용하도록 지정할 것.

요청이 있지 않는한 ListView를 그냥 사용하고 ResponsiveContainer는 최소한으로 사용할 것.
kDebugMode를 사용해 메 페이지에 간단한 로깅 등 에러 감지를 위한 방법 추가할 것.
무한 너비 문제를 항상 인지하고 그에 대처해서 구현할 것.
2번 이상의 에러의 반복된 질문이 있으면 flutter run -d emulator-5554 --verbose | tee run.log 를 사용자에게 요청할것.