A2O_TARGET = debug

HTML = a2o/build/$(A2O_TARGET)/products/application/application.html

.PHONY: all xcodebuild clean clean_html run runff

all: xcodebuild

$(HTML): xcodebuild

xcodebuild:
	a2obrew xcodebuild -t ${A2O_TARGET} -j1

full:
	a2obrew xcodebuild -t ${A2O_TARGET} -k0

clean:
	a2obrew xcodebuild -c -t ${A2O_TARGET}

clean_html:
	rm -f $(HTML)

run:
	emrun --browser chrome_canary $(HTML) 2>&1 | tee run.log

runff:
	emrun --kill_start --browser firefox_nightly --profile=emscripten_user $(HTML)

runmobile:
	emrun --browser chrome_dev --ifname en0 --android $(HTML)
