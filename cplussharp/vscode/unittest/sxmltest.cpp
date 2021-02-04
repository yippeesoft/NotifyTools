#include <iostream>
#include "pugixml.hpp"
#include "tinyxml2.h"
using namespace tinyxml2;
using namespace std;
void pugixml()
{
    pugi::xml_document doc;

    pugi::xml_parse_result result = doc.load_file("artifacts.xml");

    std::cout << "Load result: " << result.description() << ", mesh name: " << doc.child("repository").child("properties").child("property").attribute("name").value() << std::endl;

    pugi::xpath_node_set tools = doc.select_nodes("/repository/mappings/rule");

    std::cout << "Tools:\n";

    for (pugi::xpath_node_set::const_iterator it = tools.begin(); it != tools.end(); ++it)
    {
        pugi::xpath_node node = *it;
        std::cout << node.node().attribute("output").value() << "\n";
    }
};

//Support for XPath & XQuery are not planned for TinyXML-2.
//https://github.com/leethomason/tinyxml2/issues/704

void tinyxmll2()
{
    XMLDocument doc;
    doc.LoadFile("artifacts.xml");

    // Structure of the XML file:
    // - Element "PLAY"      the root Element, which is the
    //                       FirstChildElement of the Document
    // - - Element "TITLE"   child of the root PLAY Element
    // - - - Text            child of the TITLE Element

    // Navigate to the title, using the convenience function,
    // with a dangerous lack of error checking.
    const char* title = doc.FirstChildElement("repository")->FirstChildElement("properties")->GetText();
    printf("Name of play (1): %s\n", title);

    // Text is just another Node to TinyXML-2. The more
    // general way to get to the XMLText:
    // XMLNode* textNode = doc.FirstChildElement("repository")->FirstChildElement("mappings")->FirstChild();
    XMLElement* e = doc.FirstChildElement("repository")->FirstChildElement("mappings")->FirstChildElement("rule");
    title = e->Attribute("output");
    printf("Name of play (2): %s\n", title);

    title = e->NextSiblingElement()->Attribute("output");
    printf("Name of play (3): %s\n", title);

    title = e->NextSiblingElement()->NextSiblingElement()->Attribute("output");
    printf("Name of play (4): %s\n", title);

}
int main()
{
    pugixml();
    tinyxmll2(); //放弃
    return 0;
}