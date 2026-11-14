# 현대파킹

목적지 주변 공영주차장의 예상 요금, 목적지까지의 거리와 빈자리 정보를 함께 비교하는 차량용 주차 탐색 앱을 제안합니다.

이 저장소는 현대자동차그룹 차량용 앱 개발 공모전의 **개인 출품 프로토타입**입니다. 현대자동차그룹이 운영하는 공식 서비스가 아닙니다.

## 현재 시연 범위

- 뱅뱅사거리와 언주초교 공영주차장 사례를 오프라인으로 표시합니다. 30분·1시간·2시간 선택에 따라 과거 기본요금을 계산하고, 확인된 과거 민영 주차장 요금과 비교합니다. 비교 대상은 가장 가까운 곳으로 검증되지 않았습니다.
- 공영 요금은 2026-04-15, 민영 비교 요금은 2025-08-25 기준 자료를 사용합니다. 현재 현장 요금, 운영시간, 할인, 일일 상한은 확인되지 않았으며 실제 방문 판단에 사용하면 안 됩니다.
- 도보 경로, 현재 빈자리, 실제 입구 사진은 미연결입니다. 입구 이미지는 실제 사진이 아닙니다. Pleos SDK 내비게이션 연동과 주행 중 사용 제한도 아직 미구현입니다.

## APK 실행

- 서명된 Android release 시연 APK: [`apk/개인_현대파킹_release.apk`](apk/개인_현대파킹_release.apk)
- Android Studio Device Manager에서 Pleos Connect 에뮬레이터를 실행한 후 APK를 설치합니다. 예: `adb install -r apk/개인_현대파킹_release.apk`.
- 검증 환경: Pleos Connect Emulator **v2.1.0, Android API 34**, 전체 화면 **2560×1440**. 화면 표시와 시간별 요금 변경을 확인했습니다. 실제 차량은 테스트하지 않았습니다.
- APK 패키지: `kr.ssadaparking.demo.releasecandidate`. 테스트용 패키지명으로 기존 시연 앱과 공존합니다.

## 소스 실행 및 빌드

PC 화면 미리보기: 프로젝트 루트에서 `python3 -m http.server 18375 --bind 127.0.0.1 --directory app/src/main/assets`를 실행하고 브라우저에서 `http://127.0.0.1:18375/`를 엽니다.

Android 빌드에는 JDK 17, Android SDK 플랫폼 34, Build Tools 36이 필요합니다. Android Studio에서 프로젝트를 연 뒤 Gradle을 동기화하거나 `JAVA_HOME=<JDK17 경로> ./gradlew :app:assembleRelease`로 서명 전 APK를 빌드합니다. 최초 Gradle 의존성 설치에는 인터넷이 필요할 수 있습니다.

서명된 테스트 APK를 새로 빌드하려면 `bash scripts/build-release-apk.sh`를 실행합니다. 기존 릴리스와 동일한 서명을 유지하려면 별도로 보관한 서명 키와 비밀번호가 필요하며, 저장소에는 포함되지 않습니다. 새 키를 만들면 기존 APK를 덮어 설치할 수 없습니다.

## 참고 자료

- 서울 공영주차장 기본정보: https://data.seoul.go.kr/dataList/OA-13122/S/1/datasetView.do
- 서울 시영주차장 실시간 현황: https://data.seoul.go.kr/dataList/OA-21709/A/1/datasetView.do
- 현재 시연 화면에는 위 API가 연동되어 있지 않습니다.
- 포함된 Asta Sans 글꼴 라이선스: [`app/src/main/assets/fonts/OFL.txt`](app/src/main/assets/fonts/OFL.txt)
