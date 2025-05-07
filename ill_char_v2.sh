#!/bin/bash

if [[ -z "$1" ]]; then
	echo "Please enter directory name to check."

else
	dir=$1
	find $dir -name '*[\:]*' -exec rename \: _ {} \;
	find $dir -name '*[\%]*' -exec rename \% _ {} \;
	find $dir -name '*[\*]*' -exec rename \* _ {} \;
	find $dir -name '*[\#]*' -exec rename \# _ {} \;
fi

echo "Task completed..."
