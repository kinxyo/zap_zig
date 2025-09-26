# Zap

A TUI based `curl` replacement in **Zig** that also extends its usecase for API testing.

_Might also include other features such as ping, domain verification and certbot._

---

# Usage

## Args

- `<app_name> <method> <path>`

## TUI

- CRUD for Apis

## Config

Example:-

```json
{
  "name": "world",
  "port": 8000,
  "token": "",
  "apis": [
    {
      "path": "GET /",
      "protected": false
    },
    {
      "path": "GET /api/users",
      "protected": false
    },
    {
      "path": "POST /api/users",
      "protected": false,
       "body": {
         "message": "Hello World!"
      }
    }
  ]
}

```

---

# Build

`make build`

---

# Benchmark Results

`hyperfine -N 'zap /' 'curl -s localhost:8000'`

```
Benchmark 1: zap /
  Time (mean ± σ):     225.4 µs ± 205.3 µs    [User: 251.2 µs, System: 339.3 µs]
  Range (min … max):     0.0 µs … 1245.0 µs    1562 runs

Benchmark 2: curl -s localhost:8000
  Time (mean ± σ):       2.8 ms ±   0.4 ms    [User: 1.3 ms, System: 1.5 ms]
  Range (min … max):     1.8 ms …   4.5 ms    676 runs

Summary
  zap / ran
   12.41 ± 11.47 times faster than curl -s localhost:8000
```


`hyperfine 'zap httpbin.org/json' 'curl -s https://httpbin.org/json'`

```
Benchmark 1: zap httpbin.org/json
  Time (mean ± σ):      1.051 s ±  0.605 s    [User: 0.001 s, System: 0.001 s]
  Range (min … max):    0.469 s …  2.006 s    10 runs

Benchmark 2: curl -s https://httpbin.org/json
  Time (mean ± σ):      1.601 s ±  0.510 s    [User: 0.015 s, System: 0.005 s]
  Range (min … max):    0.968 s …  2.395 s    10 runs

Summary
  zap httpbin.org/json ran
    1.52 ± 1.00 times faster than curl -s https://httpbin.org/json
```

