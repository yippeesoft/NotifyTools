{
	 'variables': {
        'lite_dir%': './ncnn', # Path of Paddle Lite prebuild libraries for Windows x86
    },
  "targets": [
    {
      "target_name": "hello",
      "sources": [ "./src/hello.cc" ,"./src/benchncnn.cpp"]
	  ,
            'include_dirs': [
                "<(lite_dir)/include/ncnn",
                "<(lite_dir)/third_party/mklml/include"
            ],
			 "link_settings": {
			 'libraries': [
                "/home/sf/sfdev/node-n-api/hello/libncnn.a" ,
				"-lgomp" 
            ]
			}
    }
  ]
}

