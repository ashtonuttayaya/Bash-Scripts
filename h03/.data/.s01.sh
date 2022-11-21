#!/bin/bash
tar --wildcards -xvf web.tar.gz *.html
grep -i href *.html */*.html
