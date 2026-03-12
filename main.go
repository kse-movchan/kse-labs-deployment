package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		fmt.Fprintf(w, "OK")
	})

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello! My microservice is running on port 3000!")
	})

	fmt.Println("Starting server on port 3000...")
	
	if err := http.ListenAndServe(":3000", nil); err != nil {
		log.Fatal(err)
	}
}
