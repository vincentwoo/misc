#include <stdio>
#include <stdlib>
#include <math>
#include <algorithm>
using namespace std;

unsigned int solve(unsigned int *sequence, unsigned int *weights, unsigned int n) {
  unsigned int *dp = new unsigned int [n];
  unsigned int *sorted = new unsigned int [n];
  unsigned int i, max = 0;
  
  dp[0] = weights[0];
  sort(
  
  for (i = 1; i < n; i++) {
    int j;
    
    dp[i] = weights[i];
    
    for (j = i - 1; j >= 0; j--) {
      if (dp[j] + weights[i] > dp[i] && sequence[j] < sequence[i]) {
        dp[i] = dp[j] + weights[i];
        if (dp[i] > max) max = dp[i];
      }
    }
  }
  
  return max;
}

int main() {
  unsigned int tests;
  scanf("%d", &tests);
  for ( ; tests > 0; tests--) {
    unsigned int n, i, *sequence, *weights;
    scanf("%d", &n);
    
    sequence = new unsigned int [n];
    weights = new unsigned int [n];
    
    for (i = 0; i < n; i++) {
      scanf("%d", sequence + i);
    }
    for (i = 0; i < n; i++) {
      scanf("%d", weights + i);
    }
    
    printf("%d\n", solve(sequence, weights, n));
    
    free(sequence);
    free(weights);
  }
  return 0;
}