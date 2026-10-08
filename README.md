# MODU-C ZMK Keymap Editor config (kjmin0228 custom)

MODU-C 원본 펌웨어 전체를 복사하는 대신, 일부 파일을 불러와 keymap editor, github actions를 사용할 수 있게 만든 레포지토리입니다.

[22sh22/modu-c-zmk-config](https://github.com/22sh22/modu-c-zmk-config)를 fork 해서 아래와 같이 손본 개인용 설정입니다.

`main` 브랜치를 fork 한 후, 해당 레포지토리를 [keymap editor](https://nickcoutsos.github.io/keymap-editor/) 로 불러와 수정하십시오.

## 원본과 다른 점

- **절전 펌웨어 사용**: 펌웨어 소스를 제 포크 [kjmin0228/modu-c-firmware](https://github.com/kjmin0228/modu-c-firmware)로 바꿨습니다. 30분 동안 입력이 없으면 딥슬립에 들어가고 키를 누르면 깨어나며, LED 밝기를 낮춰 배터리를 아낍니다.
- **PC에서 바로 빌드**: GitHub Actions를 기다리지 않고 PC에서 양쪽 펌웨어를 만들 수 있습니다. Windows는 `build.cmd`, Linux/macOS는 `build.sh`를 실행하면 `results` 폴더에 좌우 UF2 파일이 생깁니다. 왼쪽은 ZMK Studio를 쓸 수 있게 빌드됩니다.

## Windows 빌드 준비 (최초 1회)

Python 3.10 이상을 설치한 뒤 저장소 폴더에서 아래를 실행하고, Zephyr SDK 0.17.0의 ARM 툴체인을 설치해 CMake에 등록합니다. 그 뒤로는 `build.cmd`만 실행하면 됩니다.

```powershell
python -m venv .venv
.venv\Scripts\python -m pip install west "cmake<4" ninja
.venv\Scripts\west init -l config
.venv\Scripts\west update
.venv\Scripts\west zephyr-export
.venv\Scripts\python -m pip install -r zephyr\scripts\requirements-base.txt -r zmk\app\scripts\requirements.txt
```

## 라이선스와 표시

이 저장소의 원본 MODU 전용 코드와 키맵은 `EKS NON-COMMERCIAL SOURCE LICENSE 1.0`의 적용을 받으며 비상업적 용도로만 사용할 수 있습니다.
