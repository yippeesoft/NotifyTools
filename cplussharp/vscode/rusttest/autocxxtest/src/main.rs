
extern crate libc;
use libc::{c_char, c_int};

use autocxx::include_cpp;
#[link(name="tengine-lite")]

include_cpp! {
    // C++ headers we want to include.
    #include "tengine_c_api.h"
    #include "bob.h"
    // Safety policy. We are marking that this whole C++ inclusion is unsafe
    // which means the functions themselves do not need to be marked
    // as unsafe. Other policies are possible.
    safety!(unsafe)
    // What types and functions we want to generate
    generate!("init_tengine")
    generate!("base::Bob")
}

extern "C" {
    fn printf(fmt: *const c_char, ...) -> c_int;
}

fn main() {
    // println!("cargo:rustc-link-lib=dylib=tengine-lite");
    // println!("cargo:rustc-link-lib=tengine-lite");
    // println!("cargo:rustc-link-lib=dylib=one");
    let _ii=ffi::init_tengine();
    // println!("Hello, world {} !",_ii);
    unsafe {
        printf("hello world %d\n".as_ptr() as *const i8,_ii);
    }
    let bb=ffi::base::Bob::make_unique(":::");
    // LD_LIBRARY_PATH=.   ./autocxxtest  ;//cp target/debug/autocxxtest 
}
