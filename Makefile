.PHONY: all

all: bootstrap

clean:
	git clean -xdf

bundler:
	bundle check --path=vendor/bundle || bundle install --path=vendor/bundle --jobs=4 --retry=3 --without development
	bundle exec pod repo update
	bundle exec pod install --verbose

bootstrap: install_deps bundler

install_deps:
	brew uninstall --force git-lfs imagemagick
	brew install git-lfs imagemagick
	sudo gem install bundler

close_xcode:
	osascript -e 'quit app "Xcode"'

julius_happy:
	git checkout planet_julius
	git merge --ff-only master
	git checkout master
	git push upstream

wtf_rm:
	rm -rf $(HOME)/Library/Developer/Xcode/DerivedData/*
	rm -rf ./Pods

wtf_project: close_xcode wtf_rm bundler
	xcodebuild -scheme HeyStaxDev -workspace HeyStax.xcworkspace clean | xcpretty -c
	xcodebuild -scheme HeyStaxStage -workspace HeyStax.xcworkspace clean | xcpretty -c
	xcodebuild -scheme HeyStaxProd -workspace HeyStax.xcworkspace clean | xcpretty -c
	open HeyStax.xcworkspace

update: clean bootstrap
	git lfs checkout

staging:
	bundle exec fastlane testbuild

keys:
	bundle exec match --app_identifier "com.krush.heystax" --type development
	bundle exec match --app_identifier "com.krush.heystax" --type adhoc

bump:
	bundle exec fastlane version_bump
	git add fastlane/README.md
	git commit --amend
