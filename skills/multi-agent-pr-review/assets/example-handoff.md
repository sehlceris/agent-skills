# PR Review — Suggested Improvements

PR: #482 "Add session refresh + rate limiting to auth API"
Coverage note: Testing & regression lane timed out; test gaps below are from the correctness reviewer's incidental observations, not a dedicated pass.

---

**1. Token refresh swallows expiry, serves stale token** — _Blocking_

_Location:_ `auth/session.py:142-158`

_Why it matters:_ The refresh path catches `TokenExpiredError` and returns the cached token instead of re-authenticating, so requests continue on an expired session and fail later, far from the cause.

_Suggested action:_ In the expiry branch, trigger re-auth rather than returning the cached token; propagate if re-auth fails.

- [ ] Fix - [ ] Won't fix

_Project lead comments:_

---

**2. Rate limiter keyed on IP only, not account** — _Blocking_

_Location:_ `auth/ratelimit.py:30-47`

_Why it matters:_ Shared-IP users (NAT, office networks) throttle each other, and a single account behind many IPs isn't limited at all — defeating the feature's intent per the ticket.

_Suggested action:_ Consider keying on account ID where available, falling back to IP for unauthenticated requests.

- [ ] Fix - [ ] Won't fix

_Project lead comments:_

---

**3. Refresh window is a magic number** — _Non-blocking_

_Location:_ `auth/session.py:119`

_Why it matters:_ The 300-second window is hardcoded mid-function; the rest of the module reads timing from config, so this will drift.

_Suggested action:_ Pull into the existing auth config block.

- [ ] Fix - [ ] Won't fix

_Project lead comments:_

---

**4. No test covers the concurrent-refresh path** — _Non-blocking_

_Location:_ multiple — `auth/session.py` refresh logic

_Why it matters:_ Two in-flight requests can both trigger refresh; behavior under that race is unverified and is exactly where item 1's bug lives.

_Suggested action:_ Add a test exercising overlapping refreshes.

- [ ] Fix - [ ] Won't fix

_Project lead comments:_

---

**5. `_decode` helper duplicated across two modules** — _Informational_

_Location:_ `auth/session.py:88`, `auth/tokens.py:54`

_Why it matters:_ Two near-identical decoders will diverge over time. Low urgency.

_Suggested action:_ Consider consolidating into `auth/tokens.py`.

- [ ] Fix - [ ] Won't fix

_Project lead comments:_
