#!/usr/bin/env bash

cd "$1"
rake ring > output.txt 2>&1
