#include "rekEidp.hpp"

long long rekEidp(unsigned int n)
{
  if ( n == 1 ){
    return 1;
  } else if (n == 2){
    return 1;
  }else{
    return rekEidp(n-1) + 3*rekEidp(n-2);
  }
}

unsigned int rek_count(unsigned int n){
  // counts the number of additions recursively.
  if (n == 1 || n == 2){
    return 0;
  }else{
    return 1 + rek_count(n-1) + rek_count(n-2);
  }
}
