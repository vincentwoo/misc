#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef struct SuffixNodes {
  struct SuffixNodes* children[4];
  struct SuffixNodes* suffix_link;
} SuffixNode;

typedef int bool;
#define true 1
#define false 0

int base_to_index(char base) {
  switch(base) {
    case 'A':
      return 0;
    case 'T':
      return 1;
    case 'C':
      return 2;
    default:
      return 3;
  }
}

SuffixNode* build_suffix_trie(char* string) {
  SuffixNode *root = calloc(1, sizeof(SuffixNode));
  root->suffix_link = root;
  SuffixNode *longest = calloc(1, sizeof(SuffixNode));
  longest->suffix_link = root;
  root->children[base_to_index(*(string++))] = longest;

  while (*string) {
    int base = base_to_index(*string);
    SuffixNode *current = longest;
    SuffixNode *previous = NULL;

    while (true) {
      SuffixNode *new = current->children[base];
      if (new) {
        if (previous) previous->suffix_link = new;
        break;
      } else {
        new = calloc(1, sizeof(SuffixNode));
        current->children[base] = new;
        if (previous) previous->suffix_link = new;
      }

      if (current == root) {
        new->suffix_link = root;
        break;
      }
      previous = new;
      current = current->suffix_link;
    }

    longest = longest->children[base];
    string++;
  }

  return root;
}

char* longest_common_substring(SuffixNode* trie, char* string, int minLen) {
  char *cur_start = string, *string_ptr = string, *best_start = string;
  int max_len = 0;

  while (*string_ptr) {
    SuffixNode* child = trie->children[base_to_index(*string_ptr)];
    if (!child) {
      trie = trie->suffix_link;
      cur_start = string_ptr;
    } else {
      string_ptr++;
      trie = child;
      if (string_ptr - cur_start > max_len) {
        best_start = cur_start;
        max_len = string_ptr - cur_start;
      }
    }
  }

  if (max_len >= minLen) {
    char* ret = calloc(max_len + 1, sizeof(char));
    return strncpy(ret, best_start, max_len);
  }

  return NULL;
}

int main() {
  FILE *sequenceFile, *patternsFile;

  sequenceFile = fopen("MSNP1AS_sequence.txt", "r");
  char *sequence = malloc(sizeof(char) * 10000);
  fgets(sequence, 10000, sequenceFile);
  fclose(sequenceFile);
  SuffixNode* trie = build_suffix_trie(sequence);
  free(sequence);

  char pattern[256];
  int num1, num2, count=0;
  patternsFile = fopen("MSN3B_L003_3D_L008_REN24OE_COMPARE.txt", "r");

  while (fscanf(patternsFile, "%s %d %d", pattern, &num1, &num2) != EOF) {
    char* lcs = longest_common_substring(trie, pattern, 20);
    if (lcs) {
      printf("%s %s %d %d\n", pattern, lcs, num1, num2);
      free(lcs);
    }
  }
  fclose(patternsFile);
  return 0;
}
