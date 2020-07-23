#include <node_api.h>
#include <stdio.h> 
//#include <napi.h> https://zhuanlan.zhihu.com/p/94682309

#include "benchmark.h"
extern int mainn();


//https://www.worldflying.cn/article-id-249.html

static napi_async_work async_work;

void OnExecuteWork (napi_env env, void *data) { // 执行异步函数，这里已经不是主线程了
printf ("I am async function OnExecuteWork!!!\n");
mainn();
printf ("I am async function OnExecuteWork2!!!\n");
}

void OnWorkComplete (napi_env env, napi_status status, void *data) { // 执行异步函数接收，这里同样不是主线程
printf ("I am async function OnWorkComplete!!!\n");
 
napi_delete_async_work (env, async_work); // 释放异步方法
}

//https://github.com/msatyan/MyNodeC
// 实际暴露的方法，这里只是简单返回一个字符串
napi_value HelloMethod (napi_env env, napi_callback_info info) {
    napi_value world;
    printf("hellofromc\n");
    napi_create_string_utf8(env, "world", 5, &world);
	napi_status status;
	size_t argc = 1;
  napi_value args[1];
  status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
   // The first parameter is a JS callback function
  napi_value cbJsFunc = args[0];
	 
	napi_create_async_work (env, NULL, world, OnExecuteWork, OnWorkComplete, NULL, &async_work); // 创建异步方法
	// 倒数第二个参数就是执行与完成回调中的void *data
	napi_queue_async_work (env, async_work); // 将异步方法放入执行队列中
	 
	printf("HelloMethod end\n");
    return world;
}

/* https://zhuanlan.zhihu.com/p/94682309
String getMd5()
{
	printf("getMd5\n");
}
*/
// 扩展的初始化方法，其中 
// env：环境变量
// exports、module：node模块中对外暴露的对象
napi_value Init (napi_env env, napi_value exports) {
    // napi_property_descriptor 为结构体，作用是描述扩展暴露的 属性/方法 的描述
	
	//exports.set("md5",Function::New(env,getMd5); https://zhuanlan.zhihu.com/p/94682309
	
	
    napi_property_descriptor desc[] = { "hello", 0, HelloMethod, 0, 0, 0, napi_default, 0 };
    
    napi_define_properties(env, exports, 1, desc);  // 定义暴露的方法
    return exports;
}


NAPI_MODULE(hello, Init);  // 注册扩展，扩展名叫做hello，Init为扩展的初始化方法

