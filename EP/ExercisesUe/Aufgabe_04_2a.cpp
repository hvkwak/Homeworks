#include <iostream>
using namespace std;

int dreieckszahl(int n)
{
    int sum = 0;
    for (unsigned int i = 1; i <= n; ++i)
    {
        sum = sum + i;
    }
    return sum;
}

int main()
{
    unsigned int const n = 25;
    for (unsigned int i = 1; i < n; ++i)
    {
        cout << "dreickszahl: " << dreieckszahl(i) << endl;
    }
    return 0;
}