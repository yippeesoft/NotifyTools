include!("../bindings.rs");
// use opencv::{core, highgui, imgcodecs, imgproc, prelude::*, videoio};
use std::ffi::CString;
use std::os::raw::c_float;
use std::os::raw::c_int;
use std::os::raw::c_void;
use std::ptr;
use std::thread::sleep;
use std::time::{Duration, SystemTime};

fn main() {
    unsafe {
        let _pp = init_tengine();
        let _opt = options {
            num_thread: 1,
            cluster: 1,
            precision: 0,
            affinity: 255,
        };
        let modelname = CString::new("tengine").expect("CString::new failed");
        let tmfilename =
            CString::new("squeezenet_v1.1_benchmark.tmfile").expect("CString::new failed");
        let mut graph = create_graph(
            std::ptr::null_mut(),
            modelname.as_ptr(),
            tmfilename.as_ptr(),
        );
        let input_tensor = get_graph_input_tensor(graph, 0, 0);
        let dims: [c_int; 4] = [1, 3, 227, 227];
        set_tensor_shape(input_tensor, dims.as_ptr(), 4);
        prerun_graph_multithread(graph, _opt);
        //  227, 227, 3, 1);
        let img_size = 227 * 227 * 3;
        let img_data: [f32; 227 * 227 * 3] = [1.0; 227 * 227 * 3];
        let x = Box::new(img_data);
        let ptrr = Box::into_raw(x);
        set_tensor_buffer(input_tensor, img_data.as_ptr() as *mut c_void, img_size * 4);
        let mut rtn = run_graph(graph, 1);
        println!("Hello, world! {}", rtn);
        let sys_time = SystemTime::now();
        rtn = run_graph(graph, 1);
        let new_sys_time = SystemTime::now();
        let difference = new_sys_time
            .duration_since(sys_time)
            .expect("Clock may have gone backwards");
        println!("{:?}", difference);
        // let sd=ncnn_version();
        // let ddd=ncnn_option_create();
        // ncnn_option_destroy(ddd);
    }
}
