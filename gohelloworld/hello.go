package main

import (
    "fmt"
    "log"
    "net/http"
    "github.com/prometheus/client_golang/prometheus/promhttp"
)

func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Welcome to omar's site")
}

func logHandler(w http.ResponseWriter, r *http.Request) {
    log.Println("this is a log to view")
}

func main() {
    http.HandleFunc("/", handler)
    http.HandleFunc("/log", logHandler)
    http.Handle("/metrics", promhttp.Handler())
    log.Fatal(http.ListenAndServe(":8080", nil))
}
