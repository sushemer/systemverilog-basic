# 4.3 – Priority Encoder 3→2 with "Valid" Flag

This activity introduces a **priority encoder**, a common digital design block used whenever multiple sources request service at the same time.

The encoder:

- Receives **3 request inputs**: `req[2:0]`.
- Produces:
  - `idx[1:0]` → binary code of the highest-priority active request.
  - `valid`   → indicates whether *any* request is active.

Priority definition:

> `req[2]` has higher priority than `req[1]`, which has higher priority than `req[0]`.

---

## Objectives

1. Implement a **3→2 priority encoder** using a chain of `if / else if`.
2. Correctly generate:
   - `idx[1:0]` → index of the winning request,
   - `valid` → `1` whenever at least one `req[i]` is high.
3. Visualize request inputs, selected index and valid flag on LEDs.

---

## Suggested Signal Mapping

Inputs (`key`):

- `req[0] = key[0]`
- `req[1] = key[1]`
- `req[2] = key[2]`

LEDs:

- `led[2:0] = req`
- `led[4:3] = idx`
- `led[7]   = valid`
- `led[6:5]` free for extensions

---

## Expected Behavior

| req      | Winner | idx | valid |
|----------|--------|-----|--------|
| 000      | –      | 0   | 0      |
| 001      | 0      | 0   | 1      |
| 010      | 1      | 1   | 1      |
| 011      | 1      | 1   | 1      |
| 100      | 2      | 2   | 1      |
| 101      | 2      | 2   | 1      |
| 110      | 2      | 2   | 1      |
| 111      | 2      | 2   | 1      |

---

## Suggested Implementation

Inside an `always_comb` block:

- Initialize `idx = 0` and `valid = 0`.
- Check requests in order:  
  first `req[2]`, then `req[1]`, then `req[0]`.

This expresses priority explicitly.

---

## Testing Procedure

1. Set `key[2:0]` to all combinations from `000` to `111`.
2. Observe:
   - `led[2:0]` → shows current requests
   - `led[4:3]` → shows index
   - `led[7]`   → valid flag

If LEDs match the truth table, the design is correct.

---

## Optional Extensions

- Add a version using `casez` with don’t-cares.
- Expand to a 4→2 or 8→3 priority encoder.
- Use LEDs `6:5` to display additional information.
