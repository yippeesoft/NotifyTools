extern crate bindgen;
// extern crate cc;

use std::env;
use std::path::PathBuf;

fn main() {
    let lib_path = PathBuf::from(env::current_dir().unwrap().join("."));

    println!("cargo:rustc-link-search={}", lib_path.display());
    println!("cargo:rustc-link-lib=tengine-lite");
    // println!("cargo:rustc-link-lib=ncnn");
    let bindingsncnn = bindgen::Builder::default()
        .header("c_api.h")
        // .whitelist_function("hello_from_c")
        .generate()
        .expect("unable to generate hello bindings");

    // let out_path = PathBuf::from(env::var("OUT_DIR").unwrap());
    bindingsncnn.write_to_file("ncnn_c_api.rs")
        .expect("couldn't write bindings!");

    let bindingsten = bindgen::Builder::default()
        .header("tengine_c_api.h")
        // .whitelist_function("hello_from_c")
        .generate()
        .expect("unable to generate hello bindings");

    // let out_path = PathBuf::from(env::var("OUT_DIR").unwrap());
    bindingsten.write_to_file("tengine_c_api.rs")
        .expect("couldn't write bindings!");
}