# Codex 작업 기록

작성 시각: 2026-06-11 01:53:37 +09:00

## 작업 목표

- `tomak79_dongle`에서 `SH1106 1.3"` OLED를 동작시키기
- `ZMK Studio`/USB 인식 문제를 함께 점검하기

## 진행 내용

### 1. GitHub Actions 빌드 정리

- ZMK 워크플로우와 `west.yml` 버전을 정리해 빌드가 성공하도록 수정함
- 이후 사용자가 GitHub Actions 컴파일 성공 확인

### 2. OLED 설정 조정

- `boards/shields/tomak79/tomak79_dongle.overlay`
  - `compatible = "sinowealth,sh1106"`
  - `reg = <0x3c>`
  - `width = <129>`
  - `height = <64>`
  - `segment-offset = <1>`
  - `page-offset = <0>`
  - `display-offset = <0>`
  - `multiplex-ratio = <63>`
  - `prechargep = <0x22>`
  - `segment-remap`
  - `com-invdir`
  - `inversion-on`

### 3. 하드웨어 증상 확인 결과

- OLED 전원만 연결하면 동글 USB 인식 정상
- `SDA` 또는 `SCL` 한 가닥만 연결하면 정상
- `SDA + SCL` 둘 다 연결하면 USB 인식 이상
- 화면은 지속적으로 가로줄만 표시됨

이 결과로 보아 펌웨어 단독 문제보다 아래 가능성이 더 큼:

- OLED 모듈이 실제 `I2C` 모드가 아님
- OLED 모듈 핀 순서 또는 배선 문제
- `SDA/SCL` 풀업 전압 문제 (`5V` 가능성)
- OLED 모듈 불량 또는 버스 전기적 문제

## 최근 핀 재배치

초기:

- `SDA = D2 = P0.17`
- `SCL = D3 = P0.20`

현재 변경:

- `SDA = D0 = P0.08`
- `SCL = D1 = P0.06`

관련 파일:

- `boards/shields/tomak79/tomak79_dongle.overlay`

## 엔코더 관련 변경

OLED 검증을 위해 엔코더를 임시 비활성화함.

- `config/tomak79_dongle.keymap` 에서 엔코더 센서 바인딩 제거
- `boards/shields/tomak79/tomak79_dongle.conf` 에서 `EC11` 설정 제거
- `boards/shields/tomak79/tomak79_dongle.overlay` 에서 엔코더/버튼 관련 노드 제거

## UART 충돌 대응

`nice!nano` 기본 `UART0`는 `D0/D1` 핀을 사용함.

OLED를 `D0/D1` 기반 `I2C`로 옮긴 뒤에도 `UART0`가 같은 핀을 점유할 수 있어,
동글 오버레이에서 아래 설정을 추가함:

- `&pro_micro_serial { status = "disabled"; };`

관련 파일:

- `boards/shields/tomak79/tomak79_dongle.overlay`

## 현재 상태

- 변경사항은 GitHub에 푸시됨
- 최신 커밋 기준:
  - `11cccd1` `Move dongle OLED I2C to D1/D0 and disable encoder`
  - `59572d5` `Disable UART0 on dongle D0/D1 I2C pins`

## 다음 권장 작업

가장 우선순위 높은 다음 단계는 OLED 모듈 자체 검증임.

1. 다른 MCU에서 `I2C` 스캔으로 `0x3C`/`0x3D` 응답 확인
2. 다른 MCU에서 `SH1106` 예제로 실제 표시 확인
3. OLED 모듈의 `SDA/SCL` 풀업 전압 확인 (`3.3V`인지 측정)
4. OLED 모듈이 실제 `I2C` 모드인지 확인 (`BS0/BS1/BS2`, 점퍼, 저항 구성)

## 참고

- 비교용 레퍼런스 폴더 `_ref_mctechnology17/` 는 로컬에만 존재하며 Git 추적 대상이 아님
