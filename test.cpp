#include <bits/stdc++.h>

using namespace std;

int main() {
    srand(std::time(nullptr));
    int T = 100;
    float a = (float)0.94 / (float)0.8, b = (float)1 / (float)30;
    float rr = pow(a, b);
    cout << rr << endl;
}