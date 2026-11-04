// JavaScript sample for keywords, strings, numbers, and functions.
import fs from "fs";

const appName = "theme-sample";

function greet(name) {
	const target = name ?? "world";
	console.log(`hello ${target}`);
}

for (const item of ["one", "two", "three"]) {
	if (item === "two") {
		greet(item);
	} else {
		console.log(item);
	}
}

greet(appName);
