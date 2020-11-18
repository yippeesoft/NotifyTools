
#include "MainWidget1.h"
#include <QApplication>
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <iostream>

#include "stbtest.h"

namespace fs = std::filesystem;

//export DISPLAY=localhost:10.0

int main(int argc, char** argv)
{
    QApplication app(argc, argv);
    MainWidget1 w;
    w.show();
    std::cout << fs::current_path().c_str() << std::endl;
    return app.exec();
}
