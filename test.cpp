#include <bits/stdc++.h>

using namespace std;

int main() {
    int a=10, b=3, c=2;
    srand(std::time(nullptr));
    float t = rand();
    float r = t / RAND_MAX;
    cout << t/RAND_MAX  << endl;
    float prob = exp(-(29-27)/0.9);
    cout << (t/RAND_MAX > prob) << endl;
}