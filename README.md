# Zap

A TUI based `curl` replacement in **Zig** that also extends its usecase for API testing.

_Might also include other features such as ping, domain verification and certbot._


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
