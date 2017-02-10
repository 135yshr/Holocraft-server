package main

import (
	"encoding/binary"
	"flag"
	"fmt"
	"net"
)

var (
	serverIP   string
	serverPort int
)

const (
	cCOMMAND_FORMAT = "{action: %s, pos: {x: %s, y: %s, z: %s}}"
)

type Command struct {
	Action string `json:"action"`
	Pos    struct {
		X int `json:"x"`
		Y int `json:"y"`
		Z int `json:"z"`
	} `json:"pos"`
}

func main() {
	flag.Parse()

	json := fmt.Sprintf(cCOMMAND_FORMAT,
		flag.Arg(0),
		flag.Arg(1),
		flag.Arg(2),
		flag.Arg(3))

	conn, err := net.Dial("tcp", fmt.Sprintf("%s:%d", serverIP, serverPort))
	if err != nil {
		fmt.Println(err)
		return
	}
	defer conn.Close()

	bs := make([]byte, 4)
	binary.LittleEndian.PutUint32(bs, uint32(len(json)))
	conn.Write(bs)
	conn.Write([]byte(json))
	fmt.Println(json)
}

func init() {
	flag.StringVar(&serverIP, "ip", "127.0.0.1", "server ip")
	flag.IntVar(&serverPort, "port", 25566, "server port")
}
