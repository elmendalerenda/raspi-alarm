#!/usr/bin/env bash

`rvm cron setup`

cd "$1"
rake autoschedule > output.txt 2>&1
