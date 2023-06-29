#!/usr/bin/env node
fs = require('fs');
split = require('split');

// console.log(JSON.stringify(fs.statSync(process.argv[2])));

function work(path) {
    console.log(JSON.stringify(fs.statSync(path)));
}

let arg = process.argv[2];
if (arg) {
    work(arg);
} else {
    process.stdin.pipe(split()).on('data', work);
}