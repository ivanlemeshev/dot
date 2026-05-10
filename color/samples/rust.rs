// Rust sample for keywords, types, functions, strings, and enum variants.

const APP_NAME: &str = "theme-sample";

fn greet(name: &str) {
    let target = if name.is_empty() { "world" } else { name };
    println!("hello {target}");
}

fn parse_name(input: Option<&str>) -> Result<&str, &'static str> {
    match input {
        Some(name) if !name.is_empty() => Ok(name),
        Some(_) => Err("empty name"),
        None => Err("missing name"),
    }
}

fn main() {
    let items = ["one", "two", "three"];
    for item in items {
        if item == "two" {
            greet(item);
        } else {
            println!("{item}");
        }
    }

    greet(APP_NAME);

    match parse_name(Some("rust")) {
        Ok(name) => println!("{name}"),
        Err(err) => eprintln!("{err}"),
    }

    let missing: Option<&str> = None;
    if let Some(value) = missing {
        println!("{value}");
    }
}
