#include <iostream>
#include <stdio.h>

#include "itEidp.hpp"
#include "rekEidp.hpp"
#include "moivreBinetEidP.hpp"

int main(int argc, char * argv[])
{
  unsigned int n;
  unsigned int count = 0;
  sscanf(argv[1], "%d", &n);

  // rekEidp
  std::cout << "rekEidp(" << n << "): " << rekEidp(n) << std::endl;
  std::cout << "rekEidp_count: " << rek_count(n)  << std::endl;

  // itEidp
  itEidp(n, count);

  // moivrebinetEidP
  std::cout << "moivreBinetEidP(" << n << "): " << moivreBinetEidP(n) << std::endl;
  return 0;
}
