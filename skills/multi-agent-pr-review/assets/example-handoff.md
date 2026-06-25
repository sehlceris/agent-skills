# PR Review — Suggested Improvements

PR: #482 "Add session refresh + rate limiting to auth API"
Coverage note: Testing & regression lane timed out; test gaps below are from the correctness reviewer's incidental observations, not a dedicated pass.

---

**1. Token refresh swallows expiry, serves stale token** — *Blocking*

*Location:* `auth/session.py:142-158`

*Why it matters:* The refresh path catches `TokenExpiredError` and returns the cached token instead of re-authenticating, so requests continue on an expired session and fail later, far from the cause.

*Suggested action:* In the expiry branch, trigger re-auth rather than returning the cached token; propagate if re-auth fails.

- [ ] Fix   - [ ] Won't fix

*Project lead comments:* 

---

**2. Rate limiter keyed on IP only, not account** — *Blocking*

*Location:* `auth/ratelimit.py:30-47`

*Why it matters:* Shared-IP users (NAT, office networks) throttle each other, and a single account behind many IPs isn't limited at all — defeating the feature's intent per the ticket.

*Suggested action:* Consider keying on account ID where available, falling back to IP for unauthenticated requests.

- [ ] Fix   - [ ] Won't fix

*Project lead comments:* 

---

**3. Refresh window is a magic number** — *Non-blocking*

*Location:* `auth/session.py:119`

*Why it matters:* The 300-second window is hardcoded mid-function; the rest of the module reads timing from config, so this will drift.

*Suggested action:* Pull into the existing auth config block.

- [ ] Fix   - [ ] Won't fix

*Project lead comments:* 

---

**4. No test covers the concurrent-refresh path** — *Non-blocking*

*Location:* multiple — `auth/session.py` refresh logic

*Why it matters:* Two in-flight requests can both trigger refresh; behavior under that race is unverified and is exactly where item 1's bug lives.

*Suggested action:* Add a test exercising overlapping refreshes.

- [ ] Fix   - [ ] Won't fix

*Project lead comments:* 

---

**5. `_decode` helper duplicated across two modules** — *Informational*

*Location:* `auth/session.py:88`, `auth/tokens.py:54`

*Why it matters:* Two near-identical decoders will diverge over time. Low urgency.

*Suggested action:* Consider consolidating into `auth/tokens.py`.

- [ ] Fix   - [ ] Won't fix

*Project lead comments:* 
