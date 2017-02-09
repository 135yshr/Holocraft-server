package main

import (
	"flag"
	"fmt"
	"net/http"
	"net/url"
	"strings"
)

const (
	BASE_URL = "http://192.168.11.16:8080/webadmin/Holocraft/HoloWorld"
)

func main() {

	flag.Parse()

	if flag.NArg() < 1 {
		fmt.Println("parameter error")
		return
	}

	action := flag.Arg(0)
	pos_x, pos_y, pos_z := flag.Arg(1), flag.Arg(2), flag.Arg(3)
	data := url.Values{
		"action": {action},
		"pos_x":  {pos_x},
		"pos_y":  {pos_y},
		"pos_z":  {pos_z},
	}
	send(data)
}

func send(data url.Values) {
	client := &http.Client{}
	req, _ := http.NewRequest("POST", BASE_URL, strings.NewReader(data.Encode()))
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
	req.SetBasicAuth("admin", "admin")
	_, err := client.Do(req)
	if err != nil {
		fmt.Println(err.Error())
	}
	fmt.Println("done")
}
