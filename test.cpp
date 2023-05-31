#include <bits/stdc++.h>

using namespace std;

int main() {
    srand(std::time(nullptr));
    int x1 = 4, y1 = 6, x2 = 4, y2 = 6;
    int rr = abs(x1-x2) + abs(y1-y2);
    cout << rr << endl;
    if (rr < 6) cout << "haha\n";
}