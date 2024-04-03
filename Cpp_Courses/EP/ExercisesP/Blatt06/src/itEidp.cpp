#include "itEidp.hpp"
#include <iostream>

long long itEidp(unsigned int n, unsigned int count)
{
  long long eidp1 = 1;
  long long eidp2 = 1;
  long long eidp3 = eidp1;
  for (int i = 2; i < n; ++i) {
    eidp3 = eidp2 + 3*eidp1;
    eidp1 = eidp2;
    eidp2 = eidp3;
    count++;
  }
  std::cout << "itEidp(" << n << "): " << eidp3 << std::endl;
  std::cout << "itEidp_count: " << count << std::endl;
  return eidp3;
}
