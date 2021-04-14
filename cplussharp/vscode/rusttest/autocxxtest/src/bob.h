#ifndef BOB_H_
#define BOB_H_
#include <string>
namespace base {
  class Bob {
  public:
      Bob(std::string name) {printf("ssss %s\n",name.c_str());};
   
      void do_a_thing()  { printf("ssss\n");};
  }; 
}
#endif