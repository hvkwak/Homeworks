#include <iostream>
#include "include/eAutomobile.hpp"

int main(int argc, char *argv[])
{
  std::cout << "*************************Auto0*****************************" << std::endl;
  eAutomobile Auto0 = eAutomobile();
  Auto0.output();

  std::cout << "*************************Auto1*****************************" << std::endl;
  eAutomobile Auto1 = eAutomobile(10.0, 20.0, 30.0, 40.0, 58);/////////////////////
  Auto1.setEnergy();
  Auto1.setLoad(); // after setEnergy().
  Auto1.output();
  Auto1.prozent();
  return 0;
}
