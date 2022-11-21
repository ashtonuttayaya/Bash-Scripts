#!/bin/bash
tar --wildcards -xf web.tar.gz *.html
grep -i href *.html web/*.html

