# Codex 작업 기록

작성 시각: 2026-06-11 01:53:37 +09:00

## 작업 목표

- `ZMK Studio`/USB 인식 문제를 점검하기

## 진행 내용

### 1. GitHub Actions 빌드 정리

- ZMK 워크플로우와 `west.yml` 버전을 정리해 빌드가 성공하도록 수정함
- 이후 사용자가 GitHub Actions 컴파일 성공 확인

### 2. 동글 I2C 테스트용 MAX17048 설정 추가

- `left/right`는 건드리지 않고 `tomak79_dongle_i2c_test` 쉴드를 추가/정리함
- 동글 기준 `SDA = D1 = P0.06`, `SCL = D0 = P0.08` 배치로 `MAX17048` 테스트 빌드 구성
- USB CDC 로그가 보이도록 테스트용 UF2 빌드 확인
- `MAX17048` 드라이버는 부팅 후 배터리 폴링 시 재시도하도록 조정

## 최근 핀 재배치

초기:

- `SDA = D2 = P0.17`
- `SCL = D3 = P0.20`

현재 유지:

- `SDA = D1 = P0.06`
- `SCL = D0 = P0.08`

관련 파일:

- `boards/shields/tomak79/tomak79_dongle.overlay`

## 엔코더 관련 변경

점검 편의를 위해 엔코더를 임시 비활성화함.

- `config/tomak79_dongle.keymap` 에서 엔코더 센서 바인딩 제거
- `boards/shields/tomak79/tomak79_dongle.conf` 에서 `EC11` 설정 제거
- `boards/shields/tomak79/tomak79_dongle.overlay` 에서 엔코더/버튼 관련 노드 제거

## UART 충돌 대응

`nice!nano` 기본 `UART0`는 `D0/D1` 핀을 사용함.

현재 `D1/P0.06 = SDA`, `D0/P0.08 = SCL` 배치를 유지하기 위해
동글 오버레이에서 아래 설정을 추가함:

- `&pro_micro_serial { status = "disabled"; };`

관련 파일:

- `boards/shields/tomak79/tomak79_dongle.overlay`

## 현재 상태

- 변경사항은 GitHub에 푸시됨
- 최신 커밋 기준:
  - `11cccd1` `Move dongle OLED I2C to D1/D0 and disable encoder`
  - `59572d5` `Disable UART0 on dongle D0/D1 I2C pins`
- 현재 기준으로 `D1/P0.06 = SDA`, `D0/P0.08 = SCL` 배치를 유지함
- `tomak79_dongle_i2c_test` 빌드에서는 USB/펌웨어는 정상 동작함
- `MAX17048` 주소 `0x36` 접근은 반복 시도되지만 `could not get IC version!` 로 계속 실패함
- 사용 중인 Adafruit `MAX17048` 모듈은 배터리 단자 전원으로 칩이 구동되므로, 배터리/외부 셀 전원이 없으면 I2C 응답 자체가 나오지 않음
- 현재는 배터리나 대체 전원이 없어 `MAX17048` I2C 응답 검증을 여기서 보류함

## 다음 권장 작업

1. `1S LiPo/Li-ion` 또는 동등한 외부 셀 전원을 `MAX17048` 배터리 단자에 연결
2. `tomak79_dongle_i2c_test` UF2를 다시 플래시
3. USB 로그에서 `device initialised at 0x36` 출력 확인
4. 이후 실제 배터리 퍼센트/전압 동작 확인

## 참고

- 비교용 레퍼런스 폴더 `_ref_mctechnology17/` 는 로컬에만 존재하며 Git 추적 대상이 아님

## Codex 셸 연동

이 저장소를 다른 PC에서 그대로 불러와도 같은 `zmk start`, `zmk end`, `zmk status` 흐름을 쓰려면
저장소 경로 기준으로 셸 초기화에 `codex-shell.sh`만 등록하면 된다.

```bash
bash /path/to/zmk-config/codex-shell.sh install-shell
```

위 명령은 현재 로그인 셸에 맞는 기본 RC 파일(`.bashrc`, `.zshrc`, `.profile`)에
현재 저장소 절대경로를 자동으로 추가한다.

수동으로 넣고 싶으면 아래 명령으로 한 줄을 출력해 복사하면 된다.

```bash
bash /path/to/zmk-config/codex-shell.sh shell-init
```

VS Code 워크스페이스 기본 경로는 `zmk-config` 저장소 안의
`tomak79.code-workspace`를 자동 사용한다.

필요하면 워크스페이스 경로는 아래처럼 덮어쓸 수 있다.

```bash
export ZMK_WORKSPACE="/path/to/tomak79.code-workspace"
```

## 최근 Codex 운영 변경

- [2026-06-13 20:56:08 KST] `codex-shell.sh`를 추가해 `zmk start/end/status/pull` 로직을 저장소 안으로 이동함
- [2026-06-13 20:56:08 KST] `zmk end`는 `codex.md`에 진행사항을 기록한 뒤 `bisang0609/zmk-config`만 커밋/푸시하도록 정리함
- [2026-06-13 20:56:08 KST] 회사 PC에서도 같은 저장소를 pull한 뒤 `.bashrc`에 한 줄만 추가하면 동일한 흐름을 재현할 수 있게 함
- [2026-06-13 21:24:51 KST] `codex-shell.sh install-shell`과 저장소 포함 워크스페이스 설정을 추가해 집/회사 경로 차이에도 그대로 동작하도록 정리함

- [2026-06-13 23:29:45 KST] No progress note provided.
