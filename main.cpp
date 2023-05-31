#include <bits/stdc++.h>
#define ll long long
#define ld long double
#define eb emplace_back
#define ef emplace_front
#define endl '\n'
using namespace std;

int main() {
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    
    string sol_tmp;
    cin >> sol_tmp;
    cout << sol_tmp << endl;
    int sol = (sol_tmp[8] - '0')*10 + (sol_tmp[9] - '0');

    vector<vector<int>> map(16, vector<int>(16, 0));
    vector<pair<int, int>> list;
    int x, y;
    while (cin >> x >> y) {
        map[x][y] = 1;
        list.eb(make_pair(x, y));
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

    // First step: find the max coverage of the first circle
    float max = 0;
    int x1 = 0, y1 = 0;
    vector<bool> detected(40, false);
    vector<bool> detected_tmp(40, false);
    for (int i = 0; i < 16; i++) {
        for (int j = 0; j < 16; j++) {            
            for (int k = 0; k < 40; k++) detected_tmp[k] = false; // avoid segmentation fault
            float cnt = 0;
            for (int k = 0; k < 40; k++) {
                // Check whether the points are in the radius of 4 of the circle
                x = list[k].first; y = list[k].second;
                int dist = (x-i)*(x-i) + (y-j)*(y-j);
                if (dist < 17) {
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
    cout << std::dec << "\ncircle_1: (" << x1 << ", " << y1 << ")" << endl;
    cout << "max #coverage of circle_1: " << max << endl;

    // vvvvvvvvvvv Manual Parameters vvvvvvvvvvv //
    float T = 100, r = 0.8; // T0 = 10, r increases from 0.8 to 0.94 then decreases to 0.94
    bool frozen = false;
    int repeat_max = 100; // if reach repeat_max consecutive repeated values, froze the SA algo.
    int frozen_cnt = 0; 
    // ^^^^^^^^^^^ Manual Parameters ^^^^^^^^^^^ //

    vector<bool> detected_2(40, false);
    vector<bool> detected_2_tmp(40, false);
    float max1 = max; // max1: the max coverage found of circle_1
    float max2 = 0; // max2: the max coverage found of circle_2
    float max_global = max1;
    srand(std::time(nullptr));
    int n = 1, x2 = rand() % 16, y2 = rand() % 16;
    int x1_ans = x1, y1_ans = y1, x2_ans = x2, y2_ans = y2;
    int prev_max = 0;
    while (T > 0.1) {
        if (frozen) {
            cout << "\n\tFrozen!\n";
            break;
        }
        cout << "\n-\nRound_" << n++ << ":\n";
        // Second step: fix circle_1, find the best central point for circle_2        
        for (int t = 0; t < 15; t++) {
            for (int k = 0; k < 40; k++) detected_2_tmp[k] = false; // reset the tmp; looks stupid, but effectively avoid segmentation fault 
            int x2_tmp = x2 + pow(-1, rand()%2) * (rand()%3); // x2 = x2 +- (1~2)
            if (x2_tmp < 0) x2_tmp = 0;
            else if (x2_tmp > 15) x2_tmp = 15;
            int y2_tmp = y2 + pow(-1, rand()%2) * (rand()%3); // y2 = y2 +- (1~2)
            if (y2_tmp < 0) y2_tmp = 0;
            else if (y2_tmp > 15) y2_tmp = 15;

            float cnt = 0, overlapped_n = 0;
            for (int k = 0; k < 40; k++) {
                // Check whether the points are in the radius of 4 of the circle
                x = list[k].first; y = list[k].second;
                int dist = (x-x2_tmp)*(x-x2_tmp) + (y-y2_tmp)*(y-y2_tmp);
                if (dist < 17) {
                    detected_2_tmp[k] = true;
                    if (detected[k]) overlapped_n++; // punishment for overlapping
                    cnt++; 
                }
            }
            float w_fixed = 1;
            float w_search = 1;
            float w_overlap = 5; // penalty weight for overlapping
            float dist12 = (x1-x2_tmp)*(x1-x2_tmp) + (y1-y2_tmp)*(y1-y2_tmp); // distance b/w two circles
            float cost = w_fixed*max1*max1 + w_search*(cnt-overlapped_n)*(cnt-overlapped_n) - w_overlap*overlapped_n;
            // if (cost > max || cost == max) {     // need a MUX 
            if (cost > max) {                // no MUXs needed
                max2 = cnt - overlapped_n;
                max = cost;
                x2 = x2_tmp; y2 = y2_tmp;
                if (max1+max2 > max_global) {
                    max_global = max1 + max2;
                    x1_ans = x1;
                    y1_ans = y1;
                    x2_ans = x2;
                    y2_ans = y2;
                }
                for (int k = 0; k < 40; k++) detected_2[k] = detected_2_tmp[k];
            }
            else {
                float r = rand();
                float sample = r / RAND_MAX;
                float prob = exp(-(max-cost)/T);                    
                if (sample < prob) { // accept the worse solution
                    max2 = cnt - overlapped_n;
                    max = cost;
                    x2 = x2_tmp; y2 = y2_tmp;
                    for (int k = 0; k < 40; k++) detected_2[k] = detected_2_tmp[k];
                }
            }
            cout << "\tcircle_2: (" << std::dec << x2 << ", " << y2 << ")" << endl;
            cout << "\tmax #coverage: " << max1+max2 << "\n\n";
            if ((int)(max1+max2) == sol) {
                cout << 
                "\t>----------------------<\n\t|                      |\n\t|        Perfect       |\n\t|                      |\n\t>----------------------<\n";
            }
            
            if (prev_max == max1+max2) frozen_cnt++;
            else frozen_cnt = 0;
            prev_max = max1+max2;
            if (frozen_cnt == repeat_max) {
                frozen = true;
                break;
            }

            // Third step: fix circle_2, find the best covering central point for circle_1
            for (int k = 0; k < 40; k++) detected_tmp[k] = false; // avoid segmentation fault

            int x1_tmp = x1 + pow(-1, rand()%2) * (rand()%3); // x1 = x1 +- (1~2)
            if (x1_tmp < 0) x1_tmp = 0;
            else if (x1_tmp > 15) x1_tmp = 15;
            int y1_tmp = y1 + pow(-1, rand()%2) * (rand()%3); // y2 = y1 +- (1~2)
            if (y1_tmp < 0) y1_tmp = 0;
            else if (y1_tmp > 15) y1_tmp = 15;

            cnt = 0, overlapped_n = 0;
            for (int k = 0; k < 40; k++) {
                // Check whether the points are in the radius of 4 of the circle
                x = list[k].first; y = list[k].second;
                int dist = (x-x1_tmp)*(x-x1_tmp) + (y-y1_tmp)*(y-y1_tmp);
                if (dist < 17) {
                    detected_tmp[k] = true;
                    if (detected_2[k]) overlapped_n++; // punishment for overlapping
                    cnt++; 
                }
            }

            // dist12 = (x2-x1_tmp)*(x2-x1_tmp) + (y2-y1_tmp)*(y2-y1_tmp); // distance b/w two circles
            cost = w_fixed*max2*max2 + w_search*(cnt-overlapped_n)*(cnt-overlapped_n) - w_overlap*overlapped_n;
            // if (cost > max || cost == max) {      
            if (cost > max) {                
                max1 = cnt - overlapped_n;
                max = cost;
                x1 = x1_tmp; y1 = y1_tmp;
                if (max1+max2 > max_global) {
                    max_global = max1 + max2;
                    x1_ans = x1;
                    y1_ans = y1;
                    x2_ans = x2;
                    y2_ans = y2;
                }
                for (int k = 0; k < 40; k++) detected[k] = detected_tmp[k];
            }
            else {
                float r = rand();
                float sample = r / RAND_MAX;
                float prob = exp(-(max-cost)/T);                    
                if (sample < prob) { // accept the worse solution
                    max1 = cnt - overlapped_n;
                    max = cost;
                    x1 = x1_tmp; y1 = y1_tmp;
                    for (int k = 0; k < 40; k++) detected[k] = detected_tmp[k];
                }
            }
        
            cout << "\n\tcircle_1: (" << x1 << ", " << y1 << ")" << endl;
            cout << "\tmax #coverage: " << max1+max2 << "\n\n";
            if ((int)(max1+max2) == sol) {
                cout << 
                "\t>----------------------<\n\t|                      |\n\t|        Perfect       |\n\t|                      |\n\t>----------------------<\n";
            }
            cout << "-\n";

            if (prev_max == max1+max2) frozen_cnt++;
            else frozen_cnt = 0;
            prev_max = max1+max2;
            if (frozen_cnt == repeat_max) {
                frozen = true;
                break;
            }
        }

        // vvvvvvvvvvv Manual Parameters vvvvvvvvvvv //
        T = T * r; // Tn = r^n * T0, where T0 = 5
        float tmpA = (float)0.94 / (float)0.8, tmpB = (float)1 / (float)23;
        float schedule = pow(tmpA, tmpB);
        if (n < 31) r = r * schedule;
        else r = r / schedule;
        // ^^^^^^^^^^^ Manual Parameters ^^^^^^^^^^^ //
        cout << "-\nRound_" << n-1 << ":" << endl;
        cout << "\tT: " << T << ", r: " << r << endl;
        cout << "\t" << sol_tmp << endl;
    }

    cout << "\nCircle_1 (" << x1_ans << ", " << y1_ans << ") detected points: \n";
    for (int k = 0; k < 40; k++) {
        x = list[k].first; y = list[k].second;
        int dist = (x-x1_ans)*(x-x1_ans) + (y-y1_ans)*(y-y1_ans);
        if (dist < 17)
            cout << "\t" << list[k].first << ", " << list[k].second << endl;
    }

    cout << "\nCircle_2 (" << x2_ans << ", " << y2_ans << ") detected points: \n";
    for (int k = 0; k < 40; k++) {
        x = list[k].first; y = list[k].second;
        int dist = (x-x2_ans)*(x-x2_ans) + (y-x2_ans)*(y-x2_ans);
        if (dist < 17)
            cout << "\t" << list[k].first << ", " << list[k].second << endl;
    }
    cout << "\n\tmax #coverage: " << max_global << endl;
    cout << "\t" << sol_tmp << endl;
    if ((int)(max_global) == sol) {
        cout << 
        "\t>----------------------<\n\t|                      |\n\t|        Perfect       |\n\t|                      |\n\t>----------------------<\n";
    }
}
