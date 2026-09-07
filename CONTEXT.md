# Homepage

A personal application: food and water logs, soap making, storage inventories,
repeatable lists, train sightings, and a handful of integrations. Everything in
it belongs to somebody, so the language below is mostly about who a piece of
work is being done for.

## Language

**Scope**:
The caller on whose behalf a request runs. It names the user and nothing else,
and it is what a domain context consults to decide what may be read or written.
_Avoid_: current user, session, actor, principal

**Owner**:
The user a record belongs to. Ownership is what access decisions are made
against, and a record has exactly one owner — either its own, or the one it
inherits from the record it hangs off.
_Avoid_: creator, author

**Provenance**:
A record of who did something, kept for display and history. Provenance is
never consulted for access decisions; that is the owner's job. A food log entry
remembers who logged it, but only the parent log's owner may see it.
_Avoid_: attribution, audit trail

**Entry point**:
A place where identity is established and a scope is built — an authenticated
browser request, an API-token request, a socket connection, a routed LiveView
mount. Code past an entry point receives a scope rather than establishing one.
_Avoid_: boundary, gateway

**API token**:
A credential a user issues to call the API as themselves. A token is owned like
any other record, and only its owner may list or destroy it. Resolving one to
the user it stands for is a different act, done at an entry point before any
scope exists, and is kept in a module of its own so that "takes no scope" is
visibly a property of where the code lives.
_Avoid_: API key, access token
