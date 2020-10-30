#include "tests.h"

#include <iostream>
#include <stdlib.h>

using namespace std;

#if 0
int test_dir_main()
{
	string folderPath = "y:\\temp\\database\\testFolder";

	if (0 != _access(folderPath.c_str(), 0))
	{
        // if this folder not exist, create a new one. 换成 ::_mkdir  ::_access 也行，不知道什么意思
		mkdir(folderPath.c_str());   // 返回 0 表示创建成功，-1 表示失败
	}

	return 0;
}
#endif

int main(int, char **)
{
    int kk = 1;
    kk++;
    std::cout << "Hello, world!\n";
    test_boost();
    //test_dir_main();
    test_glog_main(1);
    test_spdlog_main(1);

#if __LINUX__
    char path[256];
    sprintf(path, "/sys/devices/system/cpu/cpu%d/cpufreq/cpuinfo_max_freq", 0);
    FILE *fp = fopen(path, "rb");
    if (!fp)
        return -1;

    int max_freq_khz = -1;
    int nscan = fscanf(fp, "%d", &max_freq_khz);

    std::cout << "fscanf, world! " << nscan << std::endl;

    sprintf(path, "/sys/devices/system/cpu/cpufreq/stats/cpu%d/time_in_state", 0);
    sprintf(path, "/home/sf/time_in_state.txt");
    FILE *fp1 = fopen(path, "rb");
    max_freq_khz = 0;
    while (!feof(fp1))
    {
        int freq_khz = 0;
        int nscan = fscanf(fp1, "%d %*d", &freq_khz);
        std::cout << "fscanf, freq_khz! " << nscan << std::endl;
        if (nscan != 1)
            break;

        if (freq_khz > max_freq_khz)
            max_freq_khz = freq_khz;
    }
#endif
    std::cout << "fscanf end \n";
}
