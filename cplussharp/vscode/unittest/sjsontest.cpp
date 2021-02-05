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
int main1()
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

//  To parse this JSON data, first install
//
//      json.hpp  https://github.com/nlohmann/json
//
//  Then include this file, and then do
//
//     Welcome data = nlohmann::json::parse(jsonString);
// https://app.quicktype.io/
// #pragma once

#include "json.hpp"

#include <optional>
#include <stdexcept>
#include <regex>

namespace quicktype {
using nlohmann::json;

inline json get_untyped(const json& j, const char* property)
{
    if (j.find(property) != j.end())
    {
        return j.at(property).get<json>();
    }
    return json();
}

inline json get_untyped(const json& j, std::string property)
{
    return get_untyped(j, property.data());
}

class Parameters
{
public:
    Parameters() = default;
    virtual ~Parameters() = default;

private:
    std::string var1;
    int64_t var2;
    std::string var3;

public:
    const std::string& get_var1() const
    {
        return var1;
    }
    std::string& get_mutable_var1()
    {
        return var1;
    }
    void set_var1(const std::string& value)
    {
        this->var1 = value;
    }

    const int64_t& get_var2() const
    {
        return var2;
    }
    int64_t& get_mutable_var2()
    {
        return var2;
    }
    void set_var2(const int64_t& value)
    {
        this->var2 = value;
    }

    const std::string& get_var3() const
    {
        return var3;
    }
    std::string& get_mutable_var3()
    {
        return var3;
    }
    void set_var3(const std::string& value)
    {
        this->var3 = value;
    }
};

class Welcome
{
public:
    Welcome() = default;
    virtual ~Welcome() = default;

private:
    int64_t id;
    Parameters parameters;

public:
    const int64_t& get_id() const
    {
        return id;
    }
    int64_t& get_mutable_id()
    {
        return id;
    }
    void set_id(const int64_t& value)
    {
        this->id = value;
    }

    const Parameters& get_parameters() const
    {
        return parameters;
    }
    Parameters& get_mutable_parameters()
    {
        return parameters;
    }
    void set_parameters(const Parameters& value)
    {
        this->parameters = value;
    }
};
} // namespace quicktype

namespace nlohmann {
void from_json(const json& j, quicktype::Parameters& x);
void to_json(json& j, const quicktype::Parameters& x);

void from_json(const json& j, quicktype::Welcome& x);
void to_json(json& j, const quicktype::Welcome& x);

inline void from_json(const json& j, quicktype::Parameters& x)
{
    x.set_var1(j.at("var1").get<std::string>());
    x.set_var2(j.at("var2").get<int64_t>());
    x.set_var3(j.at("var3").get<std::string>());
}

inline void to_json(json& j, const quicktype::Parameters& x)
{
    j = json::object();
    j["var1"] = x.get_var1();
    j["var2"] = x.get_var2();
    j["var3"] = x.get_var3();
}

inline void from_json(const json& j, quicktype::Welcome& x)
{
    x.set_id(j.at("id").get<int64_t>());
    x.set_parameters(j.at("parameters").get<quicktype::Parameters>());
}

inline void to_json(json& j, const quicktype::Welcome& x)
{
    j = json::object();
    j["id"] = x.get_id();
    j["parameters"] = x.get_parameters();
}
} // namespace nlohmann

int main()
{
    nlohmann::json jj = nlohmann::json::parse(json_data);
    quicktype::Welcome w;
    nlohmann::from_json(jj, w);
    std::cout << w.get_id() << w.get_parameters().get_var1() << std::endl;
}