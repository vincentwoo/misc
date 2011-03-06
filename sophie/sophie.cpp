#include <fstream>
#include <tr1/unordered_map>
#include <string>
#include <string.h>
#include <stdlib.h>
#include <limits>
#include <set>
using namespace std;

#define MAXLINE 256
int num;
double *probs, **weights;

void ingest(char* file) {
    ifstream in(file, ios::in);
    char line[MAXLINE];
    in.getline(line, MAXLINE);
    num = atoi(line);
    probs = new double[num];
    weights = new double*[num];
    tr1::unordered_map<string, int> nodes;
    for (int i = 0; i < num; i++) {
        in.getline(line, MAXLINE);
        weights[i] = new double[num];
        fill_n(weights[i], num, numeric_limits<double>::max());
        nodes[strtok(line, " \t\n")] = i;
        probs[i] = atof(strtok(NULL, " \t\n"));
    }
    in.getline(line, MAXLINE);
    int edges = atoi(line);
    for (int i = 0; i < edges; i++) {
        in.getline(line, MAXLINE);
        int x = nodes[strtok(line, " \t\n")];
        int y = nodes[strtok(NULL, " \t\n")];
        weights[x][y] = weights[y][x] = atof(strtok(NULL, " \t\n"));
    }
    in.close();
}

void floyd_warshall() {
    for (int k = 0; k < num; k++) {
    for (int i = 0; i < num; i++) {
    for (int j = 0; j < num; j++) {
        if (weights[i][k] + weights[k][j] < weights[i][j])
            weights[i][j] = weights[i][k] + weights[k][j];
    }}}
}

bool solveable(set<int> &relevant) {
    for (set<int>::iterator n = relevant.begin(); n != relevant.end(); n++) {
        if (weights[0][*n] == numeric_limits<double>::max())
            return false;
    }
    return true;
}

double solve(int node, set<int> &remain, double unseen,
        double expect = 0.0, double time = 0.0) {
    static double min = numeric_limits<double>::max();
    if (expect + unseen * time >= min)
        return -1;
    if (remain.size() == 0) {
        min = expect;
        return -1;
    }
    set<int> next_remain = remain;
    for (set<int>::iterator n = remain.begin(); n != remain.end(); n++) {
        int next = *n;
        double next_time = time + weights[node][next];
        next_remain.erase(next);
        solve(next, next_remain, unseen - probs[next],
            expect + next_time * probs[next], next_time);
        next_remain.insert(next);
    }
    return min;
}

int main(int argc, char *argv[]) {
    if (argc != 2) return 1;
    ingest(argv[1]);
    floyd_warshall();
    set<int> initial;
    for (int i = 1; i < num; i++) if (probs[i] > 0) initial.insert(i);
    if (!solveable(initial))
        printf("-1.00\n");
    else
        printf("%.2f\n", solve(0, initial, 1.0 - probs[0]));
    return 0;
}