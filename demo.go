package main

import (
	"encoding/json"
	"fmt"
	"net/http"
)

type Animal struct {
	Name string
	Sound string

}
func main() {
	http.HandleFunc("/", rootpath)
	http.HandleFunc("/duck", duck)
	http.HandleFunc("/cat", cat)
	http.HandleFunc("/dog", dog)
	// using standard web port for demo purposes
	http.ListenAndServe(":80", nil)
}

func rootpath(w http.ResponseWriter, r *http.Request){
	a := Animal{"Animal", "Sound"}
	writeResult(w, a)
}
func duck(w http.ResponseWriter, r *http.Request){
	a := Animal{"Duck", "Quack"}
	writeResult(w, a)
}
func cat(w http.ResponseWriter, r *http.Request){
	a := Animal{"Cat", "Meow"}
	writeResult(w, a)
}
func dog(w http.ResponseWriter, r *http.Request){
	a := Animal{"Dog", "Woof"}
	writeResult(w, a)
}

func writeResult(w http.ResponseWriter, a Animal){
	b, err := json.Marshal(a)
	w.Header().Add("Content-Type", "application/json")
	if err == nil {
		w.Write(b)
	} else {
		fmt.Fprint(w, "{\"error\":\"something went wrong\"}")
	}
}

