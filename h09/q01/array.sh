#!/bin/bash
input=( "$@" )
echo "A. ${input[@]}"
echo "B. ${input[3]}"
echo "C. ${#input}"
echo "D. ${#input[@]}"
echo "E. ${#input[4]}"
