package main
import (
    "io/ioutil"
    "net/http"
    "net/http/httptest"
    "testing"
)

func TestHelloWorld(t *testing.T) {
    req := httptest.NewRequest(http.MethodGet, "/", nil)
    w := httptest.NewRecorder()
    handler(w, req)
    res := w.Result()
    defer res.Body.Close()
    data, err := ioutil.ReadAll(res.Body)

    if err != nil {
        t.Errorf("expected error to be nil got %v", err)
    }

    if string(data) != "Welcome to omar's site" {
        t.Errorf("Expected a welcome message got %v", string(data))
    }
}
