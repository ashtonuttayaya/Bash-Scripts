#!/bin/bash
if [ -e ~/public_html ]
then
	(
		cd ~/public_html
		touch index.html
		for file in ~/public_html/*
		do
			if [ -f "$file" ]
			then
				rm $file
			fi
		done
	)

fi
if [ -e web.tar.gz ]
then
	rm web.tar.gz
fi
