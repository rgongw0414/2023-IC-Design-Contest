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
    vector<pair<int, int>> list;
    int x, y;
    while (cin >> x >> y) {
        map[x][y] = 1;
        list.eb(make_pair(x, y));
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

    // for (auto &elem: list) {
    //     cout << elem.first << ", " << elem.second << endl;
    // }
    // First step: find the max coverage of the first circle
    int max = 0;
    int x1 = 0, y1 = 0;
    vector<bool> detected;
    // detected.assign(40, false);
    vector<bool> detected_tmp;
    for (int i = 0; i < 16; i++) {
        for (int j = 0; j < 16; j++) {
            detected_tmp.assign(40, false);
            int cnt = 0;
            for (int k = 0; k < 40; k++) {
                // check whether the points are in the radius of 4 of the circle
                x = list[k].first; y = list[k].second;
                int dist = (x-i)*(x-i) + (y-j)*(y-j);
                if (dist < 16 || dist == 16) {
                    detected_tmp[k] = true;
                    cnt++;
                }
            }
            if (cnt > max) {                
                max = cnt;
                x1 = i; y1 = j;
                detected.assign(40, false);
                for (int k = 0; k < 40; k++) 
                    detected[k] = detected_tmp[k];
            }
        }
    }
    cout << "detected points: \n";
    for (int k = 0; k < 40; k++) {
        if (detected[k])
            cout << list[k].first << ", " << list[k].second << endl;
    }
    cout << endl;
    cout << "circle_1: (" << x1 << ", " << y1 << ")" << endl;
    cout << "max #coverage of circle_1: " << std::dec << max << endl;
    cout << endl;

    // Second step: fix circle_1, find the best central point for circle_2
    float T0 = 1; // T0 = 5
    float T = T0;
    int n = 1, x2 = 15, y2 = 15;
    //max = 0;
    int max_tmp = max;
    vector<bool> detected_2;
    // detected.assign(40, false);
    vector<bool> detected_2_tmp;
    for (int i = 15; i >= 0; i--) {
        for (int j = 15; j >= 0; j--) {
            detected_2_tmp.assign(40, false);
            int cnt = max_tmp;
            for (int k = 0; k < 40; k++) {
                // check whether the points are in the radius of 4 of the circle
                x = list[k].first; y = list[k].second;
                int dist = (x-i)*(x-i) + (y-j)*(y-j);
                if (dist < 16 || dist == 16) {
                    detected_2_tmp[k] = true;
                    if (!detected[k])
                        cnt++;
                }
            }
            if (cnt > max) {                
                max = cnt;
                x2 = i; y2 = j;
                detected_2.assign(40, false);
                for (int k = 0; k < 40; k++) 
                    detected_2[k] = detected_2_tmp[k];
            }
        }
    }
    cout << "detected points: \n" << std::hex;
    for (int k = 0; k < 40; k++) {
        if (detected_2[k])
            cout << list[k].first << ", " << list[k].second << endl;
    }
    cout << endl;
    cout << "circle_2: (" << x2 << ", " << y2 << ")" << endl;
    cout << "max #coverage of circle_1: " << std::dec << max << endl;
    cout << endl;


    
    // while (T > 0.1) {
        


    //     cout << "n: " << n << ", T: " << T << endl;
    //     T = T0 * pow(0.9, n++); // Tn = r^n * T0, where T0 = 5
    // }
}
