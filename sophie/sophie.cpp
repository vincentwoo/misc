#include <fstream>
#include <tr1/unordered_map>
#include <string>
#include <string.h>
#include <stdlib.h>
#include <limits>
#include <vector>
using namespace std;

#define MAXLINE 256
int num;
double *probs, **weights;

struct node_entry {
    int index;
    bool active;
};

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

bool solveable(vector<node_entry> &relevant) {
    for (vector<node_entry>::iterator n = relevant.begin(); n != relevant.end(); n++) {
        if (weights[0][n->index] == numeric_limits<double>::max())
            return false;
    }
    return true;
}

double solve(int node, vector<node_entry> &remain, double unseen,
        double expect = 0.0, double time = 0.0) {
    static double min = numeric_limits<double>::max();
    if (expect + unseen * time >= min)
        return -1;
    
    bool empty = true;
    for (vector<node_entry>::iterator n = remain.begin(); n != remain.end(); n++) {
        if (!n->active)
            continue;
        empty = false;
        int next = n->index;
        double next_time = time + weights[node][next];
        n->active = false;
        solve(next, remain, unseen - probs[next],
            expect + next_time * probs[next], next_time);
        n->active = true;
    }
    if (empty) min = expect;
    return min;
}

int main(int argc, char *argv[]) {
    if (argc != 2) return 1;
    ingest(argv[1]);
    floyd_warshall();
    vector<node_entry> initial;
    for (int i = 1; i < num; i++) {
        if (probs[i] > 0) {
            node_entry n;
            n.index = i;
            n.active = true;
            initial.push_back(n);
        }
    }
    if (!solveable(initial))
        printf("-1.00\n");
    else
        printf("%.2f\n", solve(0, initial, 1.0 - probs[0]));
        
    return 0;
}