package main

// #cgo LDFLAGS:-L./ -lncnn
// #include <stdio.h>
// #include <stdlib.h>
// #include "c_api.h"
import "C"
import "fmt"

func main() {
	ver := C.ncnn_version()
	fmt.Println(C.GoString(ver))
	/* #include "greet.h"
	name := C.CString("Gopher")
	defer C.free(unsafe.Pointer(name))

	year := C.int(2018)

	ptr := C.malloc(C.sizeof_char * 1024)
	defer C.free(unsafe.Pointer(ptr))

	size := C.greet(name, year, (*C.char)(ptr))

	b := C.GoBytes(ptr, size)
	fmt.Println(string(b))
	*/
}

//LD_LIBRARY_PATH=. ./m

//https://blog.csdn.net/u014633283/article/details/52225274
// go mod init example.com/m/v
// go build
// 1968992 4月  23 15:52 m
// ./m 输出 Greetings, Gopher from 2018! We come in peace :)
