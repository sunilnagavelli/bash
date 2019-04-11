#!/bin/bash

time=0
echo `date -d "1970-01-01 00:00:00 UTC $time seconds" +"%H:%M:%S"`
time=$((time + 600))
echo `date -d "1970-01-01 00:00:00 UTC $time seconds" +"%H:%M:%S"`
time=$((time + 600))
echo `date -d "1970-01-01 00:00:00 UTC $time seconds" +"%H:%M:%S"`
