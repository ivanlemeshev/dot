#include <stdio.h>
#include <stdlib.h>

#define APP_NAME "theme-sample"
#define MAX_ITEMS 3

typedef struct {
  const char *query;
  int count;
} Config;

static const char *greet(const char *name) {
  if (name == NULL || name[0] == '\0') {
    name = "world";
  }
  return name;
}

int main(void) {
  Config cfg = {APP_NAME, MAX_ITEMS};

  for (int i = 0; i < cfg.count; i++) {
    const char *item = (i == 1) ? "two" : "item";
    printf("%s %s\n", greet(item), cfg.query);
  }

  return EXIT_SUCCESS;
}
