#include <iostream>
#include "pugixml.hpp"
int main()
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
    return 0;
}