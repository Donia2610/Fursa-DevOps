#!/bin/bash

d=$(date +%H)

if [ $d -ge 0 -a  $d -le 4 ];
then
	echo "Good Night"
elif [ $d -ge 5 -a  $d -le 11 ];
then
	echo "Good Morning"
elif [ $d -ge 12 -a  $d -le 16 ];
then
	echo "Good Day"
else
	echo "Good Evening"
fi
