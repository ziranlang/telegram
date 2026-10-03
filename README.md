# Telegram for Ziran

Telegram account authorization and MTProto 2.0 requests implemented in Ziran.
The package uses the Ziran `crypto` and `compression` packages; native sockets,
entropy and private file operations use operating-system bindings. It does not
load TDLib, run a Python bridge, or depend on a Telegram C/C++ implementation.

Exports are package-qualified: `telegram/tl`, `telegram/mtproto`,
`telegram/client`, `telegram/auth`, `telegram/messages` and `telegram/session`.
Use `ziran add https://github.com/ziranlang/telegram.git` once this repository
is published. For development, resolve the canonical checkout through an
ignored `ziran.local.toml` override and commit the generated lock file.

`client` owns an authenticated encrypted connection and accepts TL objects as
JSON. Bytes use base64; `int128` and `int256` use hexadecimal. Integer fields
are serialized without converting through floating point. `auth` adds phone
number, code and SRP two-step verification, private session snapshots and
authorization transfer between data centers. Account applications need their
own API ID and hash from [Telegram's app configuration](https://my.telegram.org/apps).

`session` provides a single-account, single-thread event interface for CLI
and native hosts: `Create`, `Send`, `Receive`, `Execute`. Its high-level JSON
request names preserve compatibility with existing mirror callers. Account
history, bot membership, text sends, exact callback bytes, reactions, read
receipts, edits, deletions and service messages are normalized in Ziran. The
same connection receives updates and recovers account and channel sequence
gaps. It does not start a bot-token poller.

Before `setTdlibParameters`, create an owner-controlled directory with mode
0700 and provide its path as `database_directory`. That historical request name
initializes this package, without TDLib. The session pins the directory and
stores `account.json` with mode 0600 using fsync and an atomic rename. Existing
unsafe or corrupt account files are rejected and preserved. Codes and passwords
are not included in account snapshots. Drain and apply received events before
calling `Receive` again: update cursors are checkpointed after the queue is
drained so interrupted processing can replay safely.

The high-level session covers the operations used by account chat mirrors;
it is not a complete Telegram application. `loadChats` announces every chat
with its full name, newest message and mute state. `downloadMessageFile`
saves a message's photo or document to a new owner-only file, connecting to
the file's data center when it differs from the account's. Other API
methods can be called through `client` and the bundled TL schema. Secret
chats, account registration, uploads and interactive email enrollment do
not have high-level session helpers.

Run `make check test` for offline TL, SRP, normalization and update-sequence
checks. `make rpc-test` is an explicit network test: it performs an encrypted
`help.getConfig` request against Telegram's test DC without signing into an
account or sending a message.

Protocol references: [authorization](https://core.telegram.org/api/auth),
[update sequences](https://core.telegram.org/api/updates),
[SRP](https://core.telegram.org/api/srp), and
[MTProto 2.0](https://core.telegram.org/mtproto/description).
