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
    vector<bool> detected(40, false);
    vector<bool> detected_tmp(40, false);
    for (int i = 0; i < 16; i++) {
        for (int j = 0; j < 16; j++) {
            for (int k = 0; k < 40; k++) detected_tmp[k] = false;
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
                for (int k = 0; k < 40; k++) detected[k] = false;
                for (int k = 0; k < 40; k++) 
                    detected[k] = detected_tmp[k];
            }
        }
    }
    // cout << "Circle_1 detected points: \n";
    // for (int k = 0; k < 40; k++) {
    //     if (detected[k])
    //         cout << list[k].first << ", " << list[k].second << endl;
    // }
    cout << endl;
    cout << std::hex << "circle_1: (" << x1 << ", " << y1 << ")" << endl;
    cout << "max #coverage of circle_1: " << std::dec << max << endl;

    int max1 = max; // max1: the max coverage found of circle_1
    int max2 = 0; // max2: the max coverage found of circle_2
    
    float T0 = 10; // T0 = 5
    float T = T0;
    int n = 1, x2 = 15, y2 = 15;
    vector<bool> detected_2(40, false);
    vector<bool> detected_2_tmp(40, false);

    while (T > 0.1) {
        // Second step: fix circle_1, find the best central point for circle_2        
        cout << "\n-\nRound_" << n++ << ":\n";

        for (int i = 15; i >= 0; i--) {
            for (int j = 15; j >= 0; j--) {
                for (int k = 0; k < 40; k++) detected_2_tmp[k] = false;
                int cnt = 0;
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
                if (max1 + cnt > max || max1 + cnt == max) {                
                    max2 = cnt;
                    max = max1 + max2;
                    x2 = i; y2 = j;
                    for (int k = 0; k < 40; k++) detected_2[k] = detected_2_tmp[k];
                }
                else {
                    srand(std::time(nullptr));
                    float r = rand();
                    float sample = r / RAND_MAX;
                    float prob = exp(-(max-(max1+cnt))/T);                    
                    if (sample < prob) { // accept the worse solution
                        max2 = cnt;
                        max = max1 + max2;
                        x2 = i; y2 = j;
                        for (int k = 0; k < 40; k++) detected_2[k] = detected_2_tmp[k];
                    }
                }
            }
        }
        // cout << "Circle_2 detected points: \n" << std::hex;
        // for (int k = 0; k < 40; k++) {
        //     if (detected_2[k])
        //         cout << list[k].first << ", " << list[k].second << endl;
        // }
        cout << endl;
        cout << "\tcircle_2: (" << x2 << ", " << y2 << ")" << endl;
        cout << "\tmax #coverage: " << std::dec << max << endl;
        cout << endl;

        //Third step: fix circle_2, find the best covering central point for circle_2
        for (int i = 15; i >= 0; i--) {
        // for (int i = 0; i < 16; i++) {
            for (int j = 0; j < 16; j++) {
          //  for (int j = 15; j >= 0; j--) {
                for (int k = 0; k < 40; k++) detected_tmp[k] = false;
                int cnt = 0;
                for (int k = 0; k < 40; k++) {
                    // check whether the points are in the radius of 4 of the circle
                    x = list[k].first; y = list[k].second;
                    int dist = (x-i)*(x-i) + (y-j)*(y-j);
                    if (dist < 16 || dist == 16) {
                        detected_tmp[k] = true;
                        if (!detected_2[k]) cnt++;
                    }
                }
                if (max2 + cnt > max || max2 + cnt == max) {                
                    max1 = cnt;
                    max = max1 + max2;
                    x1 = i; y1 = j;
                    for (int k = 0; k < 40; k++) detected[k] = detected_tmp[k];
                }
                else {
                    srand(std::time(nullptr));
                    float r = rand();
                    float sample = r / RAND_MAX;
                    float prob = exp(-(max-(max1+cnt))/T);                    
                    if (sample < prob) { // accept the worse solution
                        max1 = cnt;
                        max = max1 + max2;
                        x1 = i; y1 = j;
                        for (int k = 0; k < 40; k++) detected[k] = detected_tmp[k];
                    }
                }
            }
        }
        // cout << "Circle_1 detected points: \n";
        // for (int k = 0; k < 40; k++) {
        //     if (detected[k])
        //         cout << list[k].first << ", " << list[k].second << endl;
        // }
        cout << endl;
        cout << "\tcircle_1: (" << std::hex << x1 << ", " << y1 << ")" << endl;
        cout << "\tmax #coverage: " << std::dec << max << endl;
        cout << endl;   

        T = T * 0.9; // Tn = r^n * T0, where T0 = 5
        cout << "\tT: " << T << endl;
        cout << "\t" << sol_tmp << endl;
        if (max == sol) {
            cout << 
            "\t>----------------------<\n\t|                      |\n\t|        Perfect       |\n\t|                      |\n\t>----------------------<\n";
        }
    }
}
