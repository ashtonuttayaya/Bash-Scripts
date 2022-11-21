#!/bin/bash

grep -iw href in*.html > hrefs.txt
grep -iw -E 'jpg|jpeg|gif' in*.html > pics.txt
wc -l hrefs.txt
wc -l pics.txt
grep gif pics.txt | wc -l
