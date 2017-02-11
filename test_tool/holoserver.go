package main

import (
	"fmt"
	"net"
)

func main() {
	l, err := net.Listen("tcp", ":25566")
	if err != nil {
		fmt.Println(err)
		return
	}
	defer l.Close()

	fmt.Println("Server Started...")
	for {
		conn, err := l.Accept()
		if err != nil {
			fmt.Println(err)
			return
		}
		go handleRequest(conn)
	}
}

func handleRequest(conn net.Conn) {
	buf := make([]byte, 1024)
	// Read the incoming connection into the buffer.
	size, err := conn.Read(buf)
	if err != nil {
		fmt.Println("Error reading:", err.Error())
		return
	}
	if size != 50 {
		fmt.Println("not equals:", size)
	}
	if string(buf[:size]) != `{"action":"setblock", "pos":{"y":0, "x":0, "z":0}}` {
		fmt.Println("not equals", string(buf[:size]))
	}
	conn.Close()
}
