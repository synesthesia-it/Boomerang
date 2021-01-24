.DEFAULT_GOAL := project

project:
	xcodegen

setup: 
	brew bundle
	make project

clean:
	rm -rf *.xcodeproj
	rm -rf *.xcworkspace
	rm -rf Pods/