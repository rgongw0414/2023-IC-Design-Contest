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
    // test222
    // int r, a=0, b=0;
    // for (int i = 0; i < 100; i++) {
    //     r = rand() % 100 + 1;
    //     if (r <= 70) a++;
    //     else b++;
    //     cout << r << endl;
    // }
    // cout << "# < 7: " << a << endl;
    // cout << "# >= 7: " << b << endl;
    string sol_tmp;
    cin >> sol_tmp;
    cout << sol_tmp << endl;
    int sol = (sol_tmp[8] - '0')*10 + (sol_tmp[9] - '0');
    // cout << sol << endl;

    vector<vector<int>> map(16, vector<int>(16, 0));
    // int map[16][16];
    int x, y;
    while (cin >> x >> y) {
        map[x][y] = 1;
        // cout << x << ", " << y << endl;
    }
    int tmp = 0;
    cout << "  ";
    for (int i = 0; i < 16; i++) cout << std::hex << i << " "; cout << endl << " ";
    for (int i = 0; i < 16; i++) cout << "--"; cout << endl;
    for (auto &row: map) {
        cout << std::hex << tmp++ << "|";
        for (auto &elem: row) cout << elem << " ";
        cout << endl;
    }
}
