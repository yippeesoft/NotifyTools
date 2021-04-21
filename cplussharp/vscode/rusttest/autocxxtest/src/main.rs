
extern crate libc;
use libc::{c_char, c_int};

use autocxx::include_cpp;

// #[link(name="ncnn")]
include_cpp! {
    // C++ headers we want to include.
    #include "tengine_c_api.h"
    #include "bob.h"
    #include "option.h"
    #include "c_api.h"
    // Safety policy. We are marking that this whole C++ inclusion is unsafe
    // which means the functions themselves do not need to be marked
    // as unsafe. Other policies are possible.
    // safety!(unsafe)
    safety!(unsafe_ffi)
    // What types and functions we want to generate
    generate!("init_tengine")
    generate!("base::Bob")
    generate!("ncnn::Option")
    generate!("_ncnn_option_t")
    generate!("ncnn_option_create")
    // generate!("ncnn_option_destroy")
    generate!("_ncnn_net_t")    
    generate!("ncnn_net_load_param")
    generate!("ncnn_net_load_model")
    generate!("ncnn_net_create")

    generate!("init_tengine")
    generate!("request_tengine_version")
}

extern "C" {
    fn printf(fmt: *const c_char, ...) -> c_int;
}

fn main() {
    // println!("cargo:rustc-link-lib=ncnn");
    // println!("cargo:rustc-link-lib=dylib=tengine-lite");
    // println!("cargo:rustc-link-lib=tengine-lite");
    // println!("cargo:rustc-link-lib=dylib=one");
    
    // println!("Hello, world {} !",_ii);
    unsafe {
        //tengine
        let _ii=ffi::init_tengine();
       
        // ffi::request_tengine_version();
        printf("hello world %d\n".as_ptr() as *const i8,_ii);
    }

    unsafe {
        //ncnn
        let _opt=ffi::ncnn_option_create();
        // ffi::ncnn_option_destroy(_opt);
        let _squeezenet = ffi::ncnn_net_create();
    }
    // let bb=ffi::base::Bob::make_unique(":::");
    // LD_LIBRARY_PATH=.   ./autocxxtest  ;//cp target/debug/autocxxtest 
}
