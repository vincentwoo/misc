#include <stdio.h>
#include <string.h>
#include <openssl/sha.h>
#include <stdlib.h>
#include <time.h>
#include <pthread.h>

void *forever(void* ptr);
char lowest[SHA512_DIGEST_LENGTH*2+1] = "z";

int main() {
  srand(time(NULL));

  pthread_t thread;
  for (int i = 0; i < 4; i++) {
    pthread_create(&thread, NULL, forever, NULL);
  }

  pthread_join(thread, NULL);
}

void *forever(void *ptr) {
  while (1) {
    char hexDigest[SHA512_DIGEST_LENGTH*2+1];
    char seed[10];
    unsigned char digest[SHA512_DIGEST_LENGTH];

    sprintf(seed, "%d", rand() % 1000000000);
    SHA512((unsigned char*) seed, strlen(seed), digest);

    for(int i = 0; i < SHA512_DIGEST_LENGTH; i++) {
      sprintf(&hexDigest[i*2], "%02x", (unsigned int)digest[i]);
    }

    if (strcmp(hexDigest, lowest) < 0) {
      printf("%s:\t%.20s\n", seed, hexDigest);
      strcpy(lowest, hexDigest);
    }
  }

  return NULL;
}
