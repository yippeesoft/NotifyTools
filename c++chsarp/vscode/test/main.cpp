#include <iostream>

int main(int, char**) {
    std::cout << "Hello, world!\n";

#if __LINUX__
    char path[256];
    sprintf(path, "/sys/devices/system/cpu/cpu%d/cpufreq/cpuinfo_max_freq", 0);
    FILE* fp = fopen(path, "rb");
    if (!fp)
        return -1;

    int max_freq_khz = -1;
    int nscan = fscanf(fp, "%d", &max_freq_khz);

    std::cout << "fscanf, world! " << nscan << std::endl;

    sprintf(path, "/sys/devices/system/cpu/cpufreq/stats/cpu%d/time_in_state", 0);
    sprintf(path, "/home/sf/time_in_state.txt");
    FILE* fp1 = fopen(path, "rb");
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
