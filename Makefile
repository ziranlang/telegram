ZIRAN ?= ziran
LOCKED := $(if $(wildcard ziran.local.toml),,--locked)
.PHONY: check test
check:
	$(ZIRAN) check --project $(LOCKED) src/tl.zi
test:
	$(ZIRAN) build --project $(LOCKED) --target=c --entry tl_test:Main --exe -o build/tests tests/tl_test.zi
	env -u DISPLAY -u WAYLAND_DISPLAY build/tests/tl_test
