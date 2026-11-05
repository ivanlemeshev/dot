# Fish sample for keywords, variables, functions, and strings.

set -l name "theme-sample"

function greet
    set -l target $argv[1]
    if test -z "$target"
        set target world
    end
    echo "hello $target"
end

for item in one two three
    if test "$item" = two
        greet $item
    else
        echo $item
    end
end

greet $name
