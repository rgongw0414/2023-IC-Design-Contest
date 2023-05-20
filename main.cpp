#include <bits/stdc++.h>
#define ll long long
#define ld long double
#define eb emplace_back
#define ef emplace_front
#define endl '\n'
using namespace std;

void solve() {
    
}

int main() {
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    
    srand(1000);
    int r, a=0, b=0;
    for (int i = 0; i < 100; i++) {
        r = rand() % 100 + 1;
        if (r <= 70) a++;
        else b++;
        cout << r << endl;
    }
    cout << "# < 7: " << a << endl;
    cout << "# >= 7: " << b << endl;
}