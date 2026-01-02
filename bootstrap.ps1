# PowerShell bootstrap for FlowGenX scaffold
$RepoDir = (Get-Location).Path
Set-StrictMode -Version Latest

# 1. Ensure git identity is set (edit values if needed)
git config --global user.email "user @example.com"
git config --global user.name "Gemini CLI User"

# 2. Create directories
$dirs = @("cmd","planner","runtime","actions","connectors","security","infra","docs","examples","examples\flows",".github\workflows")
foreach ($d in $dirs) { if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d | Out-Null } }

# 3. Create starter files (only if missing)
if (-not (Test-Path README.md)) { " @`n# FlowGenX`nGenerative-AI driven integration platform scaffold." | Out-File -FilePath README.md -Encoding utf8 }
if (-not (Test-Path LICENSE)) { "MIT License" | Out-File -FilePath LICENSE -Encoding utf8 }

# 4. Example server entrypoint (Go)
$mainGo = @'
package main

import (
  "log"
  "net/http"
)

func main() {
  // TODO: wire planner and runtime packages
  http.HandleFunc("/plan", func(w http.ResponseWriter, r *http.Request) {
    w.Write([]byte("planner endpoint"))
  })

  http.HandleFunc("/execute", func(w http.ResponseWriter, r *http.Request) {
    w.Write([]byte("execute endpoint"))
  })

  log.Println("FlowGenX server listening on :8080")
  log.Fatal(http.ListenAndServe(":8080", nil))
}
'@
if (-not (Test-Path "cmd\flowgenx-server")) { New-Item -ItemType Directory -Path "cmd\flowgenx-server" | Out-Null }
$mainGoPath = "cmd\flowgenx-server\main.go"
if (-not (Test-Path $mainGoPath)) { $mainGo | Out-File -FilePath $mainGoPath -Encoding utf8 }

# 5. Example planner stub (planner/handler.go)
$plannerGo = @'
package planner

// TODO: implement NL parsing and flow compilation
func Init() {}
'@
if (-not (Test-Path "planner\handler.go")) { $plannerGo | Out-File -FilePath "planner\handler.go" -Encoding utf8 }

# 6. Example Action manifest (actions/example_action/action.yaml)
$actionYaml = @'
id: example_http
runtime: python
inputs: payload
outputs: result
secrets: API_KEY
'@
if (-not (Test-Path "actions\example_action")) { New-Item -ItemType Directory -Path "actions\example_action" | Out-Null }
if (-not (Test-Path "actions\example_action\action.yaml")) { $actionYaml | Out-File -FilePath "actions\example_action\action.yaml" -Encoding utf8 }

# 7. Example CI workflow
$ciYaml = @'
name: CI
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout @v4
      - name: Set up Go
        uses: actions/setup-go @v4
        with:
          go-version: "1.20"
      - name: Lint
        run: echo "Add linters and tests"
'@
if (-not (Test-Path ".github\workflows\ci.yml")) { $ciYaml | Out-File -FilePath ".github\workflows\ci.yml" -Encoding utf8 }

# 8. Git add, commit, push (only if there are changes)
git add .
$status = git status --porcelain
if ($status) {
  git commit -m "Initial scaffold for FlowGenX"
  git push -u origin main
} else {
  Write-Host "No changes to commit. Repository is up to date."
}

# 9. Create starter issue (explicit repo)
gh issue create --repo aka1976mb/flowgenx --title "Roadmap: MVP" --body "Planner, Agent runtime, Actions marketplace, PII masking, DW adapters, Notifications"
Write-Host "Bootstrap complete."
