ZIRAN ?= ziran
LOCKED := $(if $(wildcard ziran.local.toml),,--locked)
.PHONY: check test rpc-test
check:
	$(ZIRAN) check --project $(LOCKED) src/tl.zi src/auth.zi src/session.zi
test:
	$(ZIRAN) build --project $(LOCKED) --target=c --entry tl_test:Main --exe -o build/tests tests/tl_test.zi
	env -u DISPLAY -u WAYLAND_DISPLAY -u XAUTHORITY -u DBUS_SESSION_BUS_ADDRESS build/tests/tl_test
	$(ZIRAN) build --project $(LOCKED) --target=c --entry auth_test:Main --exe -o build/auth-test tests/auth_test.zi
	env -u DISPLAY -u WAYLAND_DISPLAY -u XAUTHORITY -u DBUS_SESSION_BUS_ADDRESS build/auth-test/auth_test
	$(ZIRAN) build --project $(LOCKED) --target=c --entry session_test:Main --exe -o build/session-test tests/session_test.zi
	env -u DISPLAY -u WAYLAND_DISPLAY -u XAUTHORITY -u DBUS_SESSION_BUS_ADDRESS build/session-test/session_test
# Opt-in: this contacts Telegram's test DC without signing in or using an account.
rpc-test:
	$(ZIRAN) build --project $(LOCKED) --target=c --entry rpc_test:Main --exe -o build/rpc-test tests/rpc_test.zi
	env -u DISPLAY -u WAYLAND_DISPLAY -u XAUTHORITY -u DBUS_SESSION_BUS_ADDRESS build/rpc-test/rpc_test
