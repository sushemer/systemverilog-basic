# 4_9_3 – Priority Encoder 3→2 + `valid` Flag

Activity based on `4_03_priority_encoder_and_valid_flag`, now included in the `4_9_solutions` folder.

This solution shows how to implement a **3-input priority encoder** with:

- Request inputs: `req[2:0]`
- Encoded output: `idx[1:0]`
- Valid flag: `valid` (indicates if at least one request is active)

Priority is defined as:

> `req[2]` > `req[1]` > `req[0]`

Everything is visualized on the Tang Nano 9K LEDs.

---

## Objective

The final design:

1. Takes `req[2:0]` from `key[2:0]`.
2. Determines **which input wins** according to priority (2, then 1, then 0).
3. Produces:
   - `idx[1:0]` → index of the winning input (0, 1, or 2).
   - `valid` → `1` if at least one request is active.
4. Displays on LEDs:
   - The active requests.
   - The winning index.
   - Whether there is any valid request.

---

## Signal Mapping

### Inputs (from `key`)

- `req[2:0] = key[2:0]`  
  Each bit represents a source requesting service (1 = active request).

Typical declarations:

logic [2:0] req;
logic [1:0] idx;
logic       valid;

assign req = key[2:0];

### Outputs (to `led`)

- `led[2:0] = req[2:0]`  
  Shows active requests.

- `led[4:3] = idx[1:0]`  
  Shows the winning index.

- `led[7] = valid`  
  Shows whether at least one request is active.

- `led[6:5]`  
  Free (unused).

Example:

assign led[2:0] = req;
assign led[4:3] = idx;
assign led[7]   = valid;
assign led[6:5] = 2'b00;

---

## Expected Behavior

Priority behavior:

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

Observations:

- If multiple requests are active, the **highest index always wins**.
- `valid = 1` whenever `req != 0`.
- If `req = 000`, `valid = 0` and `idx` keeps its default value (`2'd0` recommended).

---

## Logic Implementation

The main logic is implemented in an `always_comb` block:

### 1. Default values

always_comb begin  
    idx   = 2'd0;  
    valid = 1'b0;  
end

Ensures clean fallback when no request is active.

### 2. Priority chain

always_comb begin  
    idx   = 0;  
    valid = 0;  

    if (req[2]) begin  
        idx = 2;  
        valid = 1;  
    end  
    else if (req[1]) begin  
        idx = 1;  
        valid = 1;  
    end  
    else if (req[0]) begin  
        idx = 0;  
        valid = 1;  
    end  
end

- The **first true condition wins**.
- `valid` becomes `1` on any active request.

---

## LED Connection

assign led[2:0] = req;  
assign led[4:3] = idx;  
assign led[7]   = valid;  
assign led[6:5] = 2'b00;

This provides a clear, hardware-friendly visualization.

---

## Suggested Tests

Cycle through all 8 possible request values (000 to 111) and verify:

- `led[2:0]` matches the request.
- `led[4:3]` outputs the correct winner index.
- `led[7]` is ON only when at least one request is active.

### Key cases

req = 001 → idx=0, valid=1  
req = 010 → idx=1, valid=1  
req = 011 → idx=1, valid=1 (priority!)  
req = 100 → idx=2, valid=1  
req = 000 → valid=0

---

## Optional Extensions

- Implement using `casez` with don’t-care bits.
- Use `led[6:5]` for debugging or test modes.
- Extend to a 4→2 or 8→3 priority encoder.

This solution demonstrates a classic digital design pattern: managing prioritized requests and generating a valid flag.
