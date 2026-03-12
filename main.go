package main

import (
    "fmt"
    "net/http"
)

func main() {
    fmt.Println("Hello! My microservice is running!")

    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprintf(w, "Welcome to my Go app!")
    })

    http.ListenAndServe(":8080", nil)
}
