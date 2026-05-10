package main

import (
	"fmt"
	"os"
)

const appName = "theme-sample"

type config struct {
	Query string
	Count int
}

func greet(name string) string {
	if name == "" {
		name = "world"
	}
	return fmt.Sprintf("hello %s", name)
}

func main() {
	cfg := config{Query: appName, Count: 3}
	for i, item := range []string{"one", "two", "three"} {
		if i == 1 {
			fmt.Println(greet(item))
		} else {
			fmt.Println(item)
		}
	}

	if env := os.Getenv("APP_MODE"); env != "" {
		fmt.Println(env, cfg.Query, cfg.Count)
	}
}
