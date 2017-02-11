package main

import (
	"flag"
	"fmt"
	"net"
)

type ClientList struct {
	list map[net.Addr]net.Conn
}

var (
	clist *ClientList
	port  int
)

func main() {
	l, err := net.Listen("tcp", fmt.Sprintf(":%d", port))
	if err != nil {
		fmt.Println(err)
		return
	}
	defer l.Close()

	clist = &ClientList{make(map[net.Addr]net.Conn)}
	fmt.Println("Server Started...")
	for {
		conn, err := l.Accept()
		if err != nil {
			fmt.Println(err)
			return
		}
		fmt.Println("client connectd:", conn.RemoteAddr())
		clist.Add(conn)
		go handleRequest(conn)
	}
}

func init() {
	flag.IntVar(&port, "p", 25566, "listen port")
}

func handleRequest(conn net.Conn) {
	for {
		buf := make([]byte, 1024)
		size, err := conn.Read(buf)
		if err != nil {
			fmt.Println("Error reading:", err.Error())
			clist.Del(conn)
			conn.Close()
			return
		}
		fmt.Println(buf[:size])
		clist.BroadCast(buf[:size], conn)
	}
}

func (c *ClientList) Add(conn net.Conn) {
	c.list[conn.RemoteAddr()] = conn
	fmt.Println("Add", c.list)
}

func (c *ClientList) Del(conn net.Conn) {
	delete(c.list, conn.RemoteAddr())
	fmt.Println("Del", c.list)
}

func (c *ClientList) BroadCast(b []byte, me net.Conn) {
	fmt.Println("BroadCast:", me.RemoteAddr(), b)
	fmt.Println(c.list)
	for k, v := range c.list {
		fmt.Println("BroadCast:", k)
		if k != me.RemoteAddr() {
			v.Write(b)
		}
	}
}
