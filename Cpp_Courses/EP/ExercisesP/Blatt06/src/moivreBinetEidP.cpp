#include "moivreBinetEidP.hpp"
#include <cmath>

long long moivreBinetEidP(unsigned int n){
  return (1/sqrt(13))*(pow((1 + sqrt(13))/2.0, n) - pow((1 - sqrt(13))/2.0, n));
}
