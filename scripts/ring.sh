#!/usr/bin/env bash

`rvm cron setup`

cd "$1"
rake ring >> output.txt
