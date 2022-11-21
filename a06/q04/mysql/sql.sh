#!/bin/bash

for i in salesweek*
do
	mv "$i" "${i/salesweek/oldsw}"
done
for i in newsw*
do
	mv "$i" "${i/newsw/salesweek}"
done


