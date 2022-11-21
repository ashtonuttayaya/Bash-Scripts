#!/bin/sh

alias accounts="ls /home"

function extract {
	local input_num=$1

	tar -zxvf a0${input_num}.tar.gz > t${input_num}.txt
}

function cleanup {
	local input_num=$1
	rm t${input_num}.txt
	rm -rf a0${input_num}.tar.gz
}

export Q2=$(cd ~/class/h03/q02;pwd)

export WEB=$(cd ~/public_html;pwd)
