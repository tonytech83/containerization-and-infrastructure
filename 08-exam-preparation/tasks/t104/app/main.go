package main

import (
"os"
"fmt"
"log"
"net/http"
)

func getEnv(key, defaultValue string) string {
    value := os.Getenv(key)
    if len(value) == 0 {
        return defaultValue
    }
    return value
}

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Println(r.URL.RawQuery)

	greeting := getEnv("HELLO", "Awesome")

	fmt.Fprintf(w, "Hello " + greeting + " Docker World!")
}

func main() {
	http.HandleFunc("/", handler)
	log.Fatal(http.ListenAndServe(":5000", nil))
}