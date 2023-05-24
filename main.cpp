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
            for (int k = 0; k < 40; k++) detected_tmp[k] = false; // avoid segmentation fault
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
                for (int k = 0; k < 40; k++) detected[k] = detected_tmp[k];
            }
        }
    }
    // cout << "Circle_1 detected points: \n";
    // for (int k = 0; k < 40; k++) {
    //     if (detected[k])
    //         cout << list[k].first << ", " << list[k].second << endl;
    // }
    cout << endl;
    cout << std::dec << "circle_1: (" << x1 << ", " << y1 << ")" << endl;
    cout << "max #coverage of circle_1: " << max << endl;

    int max1 = max; // max1: the max coverage found of circle_1
    int max2 = 0; // max2: the max coverage found of circle_2
    
    float T = 1000; // T0 = 10
    int n = 1, x2 = rand() % 16, y2 = rand() % 16;
    vector<bool> detected_2(40, false);
    vector<bool> detected_2_tmp(40, false);
    srand(std::time(nullptr));
    while (T > 0.1) {
        cout << "\n-\nRound_" << n++ << ":\n";

        // Second step: fix circle_1, find the best central point for circle_2        
        for (int k = 0; k < 40; k++) detected_2_tmp[k] = false; // avoid segmentation fault
        int cnt = 0;
        int x2_tmp = x2 + pow(-1, rand()%2) * (rand()%3); // x2 = x2 +- (1~2)
        if (x2_tmp < 0) x2_tmp = 0;
        else if (x2_tmp > 15) x2_tmp = 15;
        int y2_tmp = y2 + pow(-1, rand()%2) * (rand()%3); // y2 = y2 +- (1~2)
        if (y2_tmp < 0) y2_tmp = 0;
        else if (y2_tmp > 15) y2_tmp = 15;
        for (int k = 0; k < 40; k++) {
            // Check whether the points are in the radius of 4 of the circle
            x = list[k].first; y = list[k].second;
            int dist = (x-x2_tmp)*(x-x2_tmp) + (y-y2_tmp)*(y-y2_tmp);
            if (dist < 16 || dist == 16) {
                detected_2_tmp[k] = true;
                if (!detected[k]) cnt++;
                // else cnt--; // punishment for overlapping
            }
        }
        if (max1 + cnt > max || max1 + cnt == max) {                
            max2 = cnt;
            max = max1 + max2;
            x2 = x2_tmp; y2 = y2_tmp;
            for (int k = 0; k < 40; k++) detected_2[k] = detected_2_tmp[k];
        }
        else {
            float r = rand();
            float sample = r / RAND_MAX;
            float prob = exp(-(max-(max1+cnt))/T);                    
            if (sample < prob) { // accept the worse solution
                max2 = cnt;
                max = max1 + max2;
                x2 = x2_tmp; y2 = y2_tmp;
                for (int k = 0; k < 40; k++) detected_2[k] = detected_2_tmp[k];
            }
        }
        cout << endl;
        cout << "\tcircle_2: (" << std::dec << x2 << ", " << y2 << ")" << endl;
        cout << "\tmax #coverage: " << max << endl;
        cout << endl;

        // Third step: fix circle_2, find the best covering central point for circle_1
        for (int k = 0; k < 40; k++) detected_tmp[k] = false; // avoid segmentation fault
        cnt = 0;
        int x1_tmp = x1 + pow(-1, rand()%2) * (rand()%3); // x1 = x1 +- (1~2)
        if (x1_tmp < 0) x1_tmp = 0;
        else if (x1_tmp > 15) x1_tmp = 15;
        int y1_tmp = y1 + pow(-1, rand()%2) * (rand()%3); // y2 = y1 +- (1~2)
        if (y1_tmp < 0) y1_tmp = 0;
        else if (y1_tmp > 15) y1_tmp = 15;
        for (int k = 0; k < 40; k++) {
            // check whether the points are in the radius of 4 of the circle
            x = list[k].first; y = list[k].second;
            int dist = (x-x1_tmp)*(x-x1_tmp) + (y-y1_tmp)*(y-y1_tmp);
            if (dist < 16 || dist == 16) {
                detected_tmp[k] = true;
                if (!detected_2[k]) cnt++;
                // else cnt--; // punishment for overlapping
            }
        }
        if (max2 + cnt > max || max2 + cnt == max) {                
            max1 = cnt;
            max = max1 + max2;
            x1 = x1_tmp; y1 = y1_tmp;
            for (int k = 0; k < 40; k++) detected[k] = detected_tmp[k];
        }
        else {
            float r = rand();
            float sample = r / RAND_MAX;
            float prob = exp(-(max-(max1+cnt))/T);                    
            if (sample < prob) { // accept the worse solution
                max1 = cnt;
                max = max1 + max2;
                x1 = x1_tmp; y1 = y1_tmp;
                for (int k = 0; k < 40; k++) detected[k] = detected_tmp[k];
            }
        }

      
        cout << endl;
        cout << "\tcircle_1: (" << std::hex << x1 << ", " << y1 << ")" << endl;
        cout << "\tmax #coverage: " << std::dec << max << endl;
        cout << endl;   

        T = T * 0.922; // Tn = r^n * T0, where T0 = 5
        cout << "\tT: " << T << endl;
        cout << "\t" << sol_tmp << endl;
        if (max == sol) {
            cout << 
            "\t>----------------------<\n\t|                      |\n\t|        Perfect       |\n\t|                      |\n\t>----------------------<\n";
        }
    }
}
