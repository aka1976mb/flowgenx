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
