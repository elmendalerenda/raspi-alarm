#!/usr/bin/env bash

cd "$1"
rake autoschedule > output.txt 2>&1
