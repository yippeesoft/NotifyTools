// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// https://zhuanlan.zhihu.com/p/218662208
#[link(name="tengine-lite")]
fn main() {
    // It's necessary to use an absolute path here because the
    // C++ codegen and the macro codegen appears to be run from different
    // working directories.
    let path = std::path::PathBuf::from(".");
    let path2 = std::path::PathBuf::from("src");
    let defs: Vec<String> = Vec::new();
    // println!("cargo:rustc-link-lib=dylib=tengine-lite");
    // println!("cargo:rustc-link-lib=tengine-lite");
    let mut b = autocxx_build::build("src/main.rs", &[&path, &path2], &defs).unwrap();
    b.flag_if_supported("-std=c++14")
        .compile("autocxx-s2-example");
    println!("cargo:rerun-if-changed=src/main.rs");
    // println!("cargo:rustc-link-search=native=src");
    // This is supposed to link the generated/compiled .lib file
    println!("cargo:rustc-link-lib=dylib=tengine-lite"); //不要问我为什么放后面，前面的注释掉，我也不知道。反正这样能过。
}
