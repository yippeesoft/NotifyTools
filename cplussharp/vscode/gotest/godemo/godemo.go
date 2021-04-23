package main

// #include <stdio.h>
// #include <stdlib.h>
//
// static void myprint(char* s) {
//   printf("https://www.cnblogs.com/terencezhou/p/10059156.html %s\n", s);
// }
import "C"
import "unsafe"

func main() {
	cs := C.CString("Hello from stdio")
	C.myprint(cs)
	C.free(unsafe.Pointer(cs))
}
