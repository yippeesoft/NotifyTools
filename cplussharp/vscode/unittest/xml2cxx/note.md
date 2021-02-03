测试 XML2CPP CXX

随便找了个 artifacts MyEclipse \Uninstaller\settings\uninstaller\artifacts.xml

1.1
编译 codesynthesis demo 需要 xerces

根据 https://xerces.apache.org/xerces-c/build-3.html 交叉编译似乎有些麻烦。。暂时放弃。

一 vs csd

https://www.cnblogs.com/qq260250932/p/4245376.html
 xsd.exe test.xml
直接卡住，无输出。

https://stackoverflow.com/questions/59132321/generate-xml-schema-xsd-to-c-class
xsd /language:CPP your.xsd /classes

https://stackoverflow.com/questions/20545224/web-application-build-error-the-codedom-provider-type-microsoft-visualc-cppcode
gacutil /i "path to CppCodeProvider.dll"

生成的 artifacts.h 。。。 好像是托管c++代码，无语。。。。

二 trang.jar
https://blog.csdn.net/luoww1/article/details/47272651

https://github.com/relaxng/jing-trang
按说明ant编译生成jar
java -jar trang.jar  person.xml  person.xsd
生成 artifacts.xsd

https://www.pianshen.com/article/82141100699/

https://www.codesynthesis.com/products/xsd/download.xhtml
下载 xsd-4.0.0-x86_64-linux-gnu.tar.bz2

./xsd cxx-tree artifacts.xsd
./xsd cxx-parser artifacts.xsd

生成各hxx cxx 文件

