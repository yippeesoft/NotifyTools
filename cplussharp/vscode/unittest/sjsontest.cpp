// https://github.com/open-source-parsers/jsoncpp/blob/master/example/readFromString/readFromString.cpp
// https://stackoverflow.com/questions/34386807/converting-json-object-to-c-object

#include <string>
#include <json/json.h>
#include <iostream>
/**
 * \brief Parse a raw string into Value object using the CharReaderBuilder
 * class, or the legacy Reader class.
 * Example Usage:
 * $g++ readFromString.cpp -ljsoncpp -std=c++11 -o readFromString
 * $./readFromString
 * colin
 * 20
 */

std::string json_data = R"~(
{
    "id": 1,
    "parameters":
    {
        "var1": "bla",
        "var2": 7,
        "var3": "base64 encoded binary data"
    }
}
)~";

struct parameters_1
{
    std::string var1; // store text here
    int var2;
    std::string var3; // store binary data here
};
parameters_1 parse_1(const Json::Value& parameters)
{
    parameters_1 p;

    p.var1 = parameters.get("var1", Json::nullValue).asString();
    p.var2 = parameters.get("var2", Json::nullValue).asInt();
    p.var3 = (parameters.get("var3", Json::nullValue).asString());

    return p;
}
int main()
{
    const std::string rawJson = R"~(
        {"Age": 20, "Name": " colin "})~"; //格式化会可能导致自动加前后空格
    const auto rawJsonLength = static_cast<int>(rawJson.length());
    constexpr bool shouldUseOldWay = false;
    JSONCPP_STRING err;
    Json::Value root;
    Json::CharReaderBuilder builder;
    {
        const std::unique_ptr<Json::CharReader> reader(builder.newCharReader());
        if (!reader->parse(rawJson.c_str(), rawJson.c_str() + rawJsonLength, &root,
                           &err))
        {
            std::cout << "error" << std::endl;
            return EXIT_FAILURE;
        }
    }
    const std::string name = root["Name"].asString();
    const int age = root["Age"].asInt();

    std::cout << name << std::endl;
    std::cout << age << std::endl;
    std::cout << name << std::endl;
    std::cout << root.get("Age", Json::nullValue) << std::endl;
    Json::Value json;

    std::unique_ptr<Json::CharReader> reader(builder.newCharReader());
    reader->parse(json_data.c_str(), json_data.c_str() + json_data.length(), &json, &err);

    Json::Value id = json.get("id", Json::nullValue);

    switch (id.asInt())
    {
    case 1:
    {
        parameters_1 p = parse_1(json.get("parameters", Json::nullValue));

        std::cout << "var1: " << p.var1 << '\n';
        std::cout << "var2: " << p.var2 << '\n';
        std::cout << "var3: " << p.var3 << '\n';
    }
    break;

    default:
        std::cerr << "ERROR: Bad parameter type: " << id.asInt() << '\n';
        break;
    }
    return EXIT_SUCCESS;
}