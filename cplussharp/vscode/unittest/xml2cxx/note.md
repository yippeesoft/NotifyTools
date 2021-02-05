测试 XML2CPP CXX

随便找了个 artifacts MyEclipse \Uninstaller\settings\uninstaller\artifacts.xml

1.4 20210205
https://app.quicktype.io/ json==> c++
https://github.com/xyz347/xpack convert json/xml/bson to c++ struct 
https://blog.csdn.net/xyz347/article/details/79338202 json与C++结构体互相转换

https://github.com/ck123pm/json2cppTool //2年前
https://www.dazhuanlan.com/2019/12/19/5dfae1c86a673/

1.3
http://www.grinninglizard.com/tinyxml/ 推荐 TinyXML-2. 
https://sourceforge.net/projects/tinyxml/files/tinyxml/2.6.2/ 2011年，据说速度慢 内存大 UTF8？
http://www.grinninglizard.com/tinyxml2/index.html
TinyXML-2 不支持xpath
https://sourceforge.net/projects/rapidxml/ 1.13 2009年 不过和tinyxml一样，周下载还是可观

1.2 不折腾xsd了 警告冲突太多
https://github.com/Yadykin/xsde-cmake

https://zhuanlan.zhihu.com/p/93844153

例子 
https://www.artima.com/cppsource/xml_data_binding.html

https://www-sop.inria.fr/dream/pmwiki/uploads/Public/Labs/xsdcpp.pdf

1.1
编译 codesynthesis demo 需要 xerces

根据 https://xerces.apache.org/xerces-c/build-3.html 交叉编译似乎有些麻烦。。暂时放弃。

备注：都2021了，找个c++的好库还是那么不容易。。。
https://docs.oracle.com/cd/B12037_01/appdev.101/b10794/adx19cpp.htm oracle看上去很强大。。

https://stackoverflow.com/questions/45254497/how-to-use-boost-xml-parser
boost 有 xml xml_oarchive xml_iarchive 

https://stackoverflow.com/questions/445905/xml-schema-to-c-classes
 CodeSynthesis XmlPlus-xsd2cpp  gSOAP Toolkit 其它收费

https://www.genivia.com/downloads.html gSOAP


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

