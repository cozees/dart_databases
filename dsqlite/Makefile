SQLITE_AMALGAMATION_AUTO_CONF = https://www.sqlite.org/src/tarball/sqlite.tar.gz?r=release
SQLITE_AMALGAMATION_AUTO_CONF_3_17_0 = https://www.sqlite.org/src/tarball/ada05cfa/SQLite-ada05cfa.tar.gz
SQLITE_DIR = sqlite

SQLITE_FLAG = -DSQLITE_ENABLE_COLUMN_METADATA=1 \
			  -DSQLITE_ENABLE_NORMALIZE=1 \
			  -DSQLITE_ENABLE_MEMORY_MANAGEMENT=1 \
			  -DSQLITE_ENABLE_PREUPDATE_HOOK=1 \
			  -DSQLITE_ENABLE_SNAPSHOT=1 \
			  -DSQLITE_ENABLE_STMT_SCANSTATUS=1 \
			  -DSQLITE_ENABLE_UNLOCK_NOTIFY=1 \
			  -DSQLITE_ENABLE_API_ARMOR=1

COVERAGE = coverage/test
COVERAGE_IGNORE = $(realpath lib/src/sqlite)

SPACE = $(subst ,, )

WEBASSEMBLY_OUT = test/webassembly/build
WEBASSEMBLY_TEMP = test/webassembly/custom_template.ci.html.tmpl
WEBASSEMBLY_TEMP_CACHE = test/webassembly/.original_custom_template.ci.html.tmpl
WEBASSEMBLY_DEBUG = debug.normal debug.bigint
WEBASSEMBLY_RELEASE = release.normal release.bigint
# use for automatic test on all platform
WEBASSEMBLY_CI = --configuration dart_test_ci.yaml

requisition: webassembly-build-force sqlite

webassembly-build-force:
	dart run bin/dsqlite.dart -b -d --release 2021:3.36.00 -o ${WEBASSEMBLY_OUT}
	dart run bin/dsqlite.dart -b -d --release 2017:3.17.00 -o ${WEBASSEMBLY_OUT}

webassembly-build:
	dart run bin/dsqlite.dart -b --release 2021:3.36.00 -o ${WEBASSEMBLY_OUT}
	dart run bin/dsqlite.dart -b --release 2017:3.17.00 -o ${WEBASSEMBLY_OUT}

gen_sqlite_binding:
	dart run tools/binding/ffigen.dart generate --out lib/src/sqlite

sqlite: sqlite_download sqlite_build

sqlite_download: sqlite.tar.gz sqlite.3.17.0.tar.gz

sqlite_build:
	cd ${SQLITE_DIR}/latest && ./configure && make clean && make "OPTS=${SQLITE_FLAG}"
	cd ${SQLITE_DIR}/3017000 && ./configure && make clean && make "OPTS=${SQLITE_FLAG}"

sqlite.tar.gz:
	mkdir -p ${SQLITE_DIR}/latest
	curl -LsSf ${SQLITE_AMALGAMATION_AUTO_CONF} -o $@
	tar xzf $@ --strip-components=1 -C ${SQLITE_DIR}/latest
	rm $@ checksum

sqlite.3.17.0.tar.gz:
	mkdir -p ${SQLITE_DIR}/3017000
	curl -LsSf ${SQLITE_AMALGAMATION_AUTO_CONF_3_17_0} -o $@
	tar xzf $@ --strip-components=1 -C ${SQLITE_DIR}/3017000
	rm $@

dsqlite_test: dsqlite_test_clean cache_web_template dsqlite_test_chrome_debug dsqlite_test_chrome_release dsqlite_test_vm dsqlite_coverage web_template_clean

dsqlite_test_local: dsqlite_test_clean cache_web_template dsqlite_test_chrome_debug dsqlite_test_vm dsqlite_coverage web_template_clean

dsqlite_test_clean: cache_web_template
	@echo 'Remove exist coverage ...'
	@rm -f ${COVERAGE}/*.info
	@rm -f ${COVERAGE}/*.json

dsqlite_test_vm:
	@echo 'Run dart test on VM'
	dart test --coverage coverage --platform vm --exclude-tags "version-solo"
	dart test --coverage coverage --platform vm test/version_test.dart

dsqlite_test_chrome_release:
	@echo 'Run dart test release (No Coverage) on Chrome'
	@for bt in ${WEBASSEMBLY_RELEASE} ; do \
  		cat ${WEBASSEMBLY_TEMP_CACHE} > ${WEBASSEMBLY_TEMP}; \
  		sed -i '' "s/{{built}}/$${bt}/g" ${WEBASSEMBLY_TEMP}; \
  		echo "  Test for $${bt}"; \
		dart test --platform chrome ${WEBASSEMBLY_CI} --exclude-tags "version-solo"; \
	done

dsqlite_test_chrome_debug:
	@echo 'Run dart test debug (normal and bigint) coverage on Chrome'
	@for bt in ${WEBASSEMBLY_DEBUG} ; do \
		cat ${WEBASSEMBLY_TEMP_CACHE} > ${WEBASSEMBLY_TEMP}; \
		sed -i '' "s/{{built}}/$${bt}/g" ${WEBASSEMBLY_TEMP}; \
		echo "  Test for $${bt}"; \
		dart test --coverage coverage --platform chrome ${WEBASSEMBLY_CI} --exclude-tags "version-solo"; \
	done
	dart test --coverage coverage --platform chrome test/version_test.dart

cache_web_template:
	@echo 'Backup html template ...'
	@cat ${WEBASSEMBLY_TEMP} > ${WEBASSEMBLY_TEMP_CACHE}

web_template_clean:
	@cat ${WEBASSEMBLY_TEMP_CACHE} > ${WEBASSEMBLY_TEMP}
	@rm -f ${WEBASSEMBLY_TEMP_CACHE}

dsqlite_coverage: dsqlite_coverage_format dsqlite_coverage_combine
	rm -rf ${COVERAGE}/html/*
	genhtml ${COVERAGE}/overall.info -o ${COVERAGE}/html

dsqlite_coverage_format:
	@echo 'Format coverage output'
	@for file in `ls $(COVERAGE)/*.json` ; do \
  		base=`echo "$${file%.*}"`; \
  		pub run coverage:format_coverage -l --check-ignore -i $${file} -o $${base}.lcov.info --packages=.packages --report-on=lib; \
	done

dsqlite_coverage_combine:
	@echo 'Combine coverage and generate html'
	lcov $(subst $(SPACE), --add-tracefile , $(shell ls ${COVERAGE}/*.info)) --output-file ${COVERAGE}/overall.info