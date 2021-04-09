extern crate libc;

use libc::c_char;
use std::ffi::CStr;
use std::str;

use opencv::{
    core,
    highgui,
    prelude::*,imgcodecs,imgproc,
    videoio,
};

use opencv::imgcodecs::IMREAD_COLOR;

extern "C" {
    // pub  fn ncnn_version()-> *const u8;
    pub  fn hello()-> *const c_char;
}

fn printchar() {
    //https://blog.csdn.net/wowotuo/article/details/109334442
    // const char* hello(){
    //     return "Hello World!";
    // }
    
    unsafe { 
        // let data: Vec<u8>=ncnn_version();
        // let s = String::from_utf8(data).expect("Found invalid UTF-8");
        let c_buf: *const c_char = unsafe { hello() };
        let c_str: &CStr = unsafe { CStr::from_ptr(c_buf) };
        let str_slice: &str = c_str.to_str().unwrap();
        let str_buf: String = str_slice.to_owned();  // if necessary
        println!("{}", str_buf);
 

        // let strver = CString::new(data).unwrap();
        println!("Hello, world {:?} !",str_buf) 
    };
}
fn cv_demo() {
    let window = "rust";
    highgui::named_window(window, 1);
    let mat = imgcodecs::imread("/home/sf/bsw4-1280.jpg",  IMREAD_COLOR);
    mat.map(|m| {
        highgui::imshow("rust", &m);
        highgui::wait_key(0);
        highgui::destroy_window("name");
    });
}

fn main() {
    let a= " aaa ss";
    println!("Hello, world!{}",a);
    cv_demo()
}
