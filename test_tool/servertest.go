package main

import (
	"fmt"
	"net/http"
	"net/url"
	"strings"
)

const (
	BASE_URL = "http://127.0.0.1:8080/webadmin/Holocraft/HoloWorld"
)

func main() {
	data := url.Values{"action": {"action"}}
	client := &http.Client{}
	req, _ := http.NewRequest("POST", BASE_URL, strings.NewReader(data.Encode()))
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
	req.SetBasicAuth("admin", "admin")
	_, err := client.Do(req)
	if err != nil {
		fmt.Println(err.Error())
	}
	fmt.Println(req)
}
