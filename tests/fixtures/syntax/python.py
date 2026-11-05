"""Python sample for keywords, strings, numbers, and functions."""

APP_NAME = "theme-sample"


def greet(name: str) -> None:
    target = name or "world"
    print(f"hello {target}")


for item in ["one", "two", "three"]:
    if item == "two":
        greet(item)
    else:
        print(item)


greet(APP_NAME)
