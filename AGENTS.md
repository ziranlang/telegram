# Telegram agent guide

Telegram account authorization and MTProto 2.0 requests implemented in Ziran.
Uses the Ziran `crypto` and `compression` packages; sockets, entropy and
private file operations use OS bindings. No TDLib, no Python bridge.

## Layout

- `src/` — exports `tl`, `encoding`, `mtproto`, `client`, `auth`, `messages`,
  `members`, `folders`, `session` (import `telegram/<name>`).
- `tests/` — `tl_test`, `auth_test`, `session_test`, `forum_test`,
  `folders_test`, plus the opt-in `rpc_test`.
- `Makefile` — `check`, `test`, `rpc-test`; `build/` holds outputs; an
  ignored `ziran.local.toml` drops `--locked`.
- `ziran.toml` / `ziran.lock` — identity, locked toolchain, dependency pins.

## Commands

- `make check` — `ziran check --project` over `tl.zi`, `auth.zi`, `session.zi`.
- `make test` — build and run the five test executables (display/session
  variables removed).
- `make rpc-test` — opt-in; contacts Telegram's test DC without signing in or
  using an account.

## Pins

- Toolchain: `ziran.lock` pins ziran.git
  `5db3d3c39425d5dfe4bfe4a84e6f6e2e5a810ad0`.
- Dependencies: crypto `51add53b2ab0bc8f6c1b524f0b62b66e20035c10`,
  compression `b081b26058daac4c61c2f7cb0cdff36496363b18` (both ziranlang).
- Own Telegram API ID/hash from my.telegram.org are the app's, never committed.

## Question -> file

- Connection/session model? -> README, `src/client.zi`, `src/session.zi`.
- Auth flow including SRP? -> `src/auth.zi`, README.
- JSON request names and normalizations? -> `src/messages.zi`, `src/members.zi`,
  `src/folders.zi`, README.
- Which toolchain/dependency revisions? -> `ziran.toml`, `ziran.lock`.
