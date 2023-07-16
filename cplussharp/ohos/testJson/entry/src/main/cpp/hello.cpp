#include "napi/native_api.h"

#include <iostream>
#include <stdio.h>
#include <string.h>
#include <ratio>
#include <chrono>

// time_since_epoch函数表示求 从1970-01-01到该时间点的duration。
// duration_cast函数表示把精度强转到<>内的精度
// count表示数出有多少个滴答（chrono库里，精度表示一个滴答的时间间隔。毫秒精度，就是1毫秒1个滴答）

using namespace std;
int main() {
    FILE *fp = NULL;
    char cmd[1024];
    char buf[1024];
    char result[4096];
    sprintf(cmd, "snapshot_display");
    uint64_t ts_ms = std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::system_clock::now().time_since_epoch()).count();

    if ((fp = popen(cmd, "r")) != NULL) {
        while (fgets(buf, 1024, fp) != NULL) {
            strcat(result, buf);
        }
        pclose(fp);
        fp = NULL;
    }
    uint64_t ts_ms2 = std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::system_clock::now().time_since_epoch()).count();
    cout << "time::" << (ts_ms2 - ts_ms) << endl;
    cout << "result:" << result << endl;
    return 0;
}

static napi_value Add(napi_env env, napi_callback_info info) {
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    double value0;
    napi_get_value_double(env, args[0], &value0);

    double value1;
    napi_get_value_double(env, args[1], &value1);

    napi_value sum;
    napi_create_double(env, value0 + value1, &sum);

    return sum;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports) {
    napi_property_descriptor desc[] = {
        {"add", nullptr, Add, nullptr, nullptr, nullptr, napi_default, nullptr}};
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) {
    napi_module_register(&demoModule);
}
