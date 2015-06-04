#include <stdlib.h>
#include <stdio.h>

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

bool containsString(SuffixNode* trie, char* string) {
  while (*string) {
    int base = base_to_index(*string);
    trie = trie->children[base];
    if (!trie) return false;
    string++;
  }
  return true;
}

int main() {
  SuffixNode* trie = build_suffix_trie("AAAACCATTA");
  // if (!containsString(trie, "AAAA")) printf("AAAA not contained\n");
  if (containsString(trie, "AC")) printf("AC contained\n");
  if (!containsString(trie, "CATTT")) printf("CATTT not contained\n");
  if (containsString(trie, "CATT")) printf("CATT contained\n");
  if (containsString(trie, "ATT")) printf("ATT contained\n");
  if (!containsString(trie, "TCC")) printf("TCC not contained\n");
  return 0;
}
