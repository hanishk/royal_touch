get:
	flutter pub get

run:
	flutter run

1.22:
	flutter_1.22 run

1.20:
	flutter_1.20 run

prod_all:
	flutter run --dart-define=env=prod -d all

local_all:
	flutter run --dart-define=env=local -d all

dev_all:
	flutter run --dart-define=env=dev -d all

apk_dev:
	flutter build apk --dart-define=env=dev --release

apk_prod:
	flutter build apk --dart-define=env=prod --release

ios_prod:
	flutter build ios --dart-define=env=prod --release

aab_prod:
	flutter build appbundle --dart-define=env=prod --release

build_prod: aab_prod ios_prod

aab_dev:
	flutter build appbundle --dart-define=env=dev --release 

ios_dev:
	flutter build ios --dart-define=env=dev --release

build_dev: aab_dev ios_dev
