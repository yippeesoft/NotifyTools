use opencv::{
    core,
    highgui,
    prelude::*,imgcodecs,imgproc,
    videoio,
};

use opencv::imgcodecs::IMREAD_COLOR;
 
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
