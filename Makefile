.PHONY: pod_push pod_lint

pod_push:
	pod trunk push Boomerang.podspec --allow-warnings
	pod trunk push RxBoomerang.podspec --allow-warnings
	pod trunk push RxBoomerangTest.podspec --allow-warnings

pod_lint:
	pod lib lint Boomerang.podspec --allow-warnings --no-clean
	pod lib lint RxBoomerang.podspec --allow-warnings --no-clean
	pod lib lint RxBoomerangTest.podspec --allow-warnings --no-clean
