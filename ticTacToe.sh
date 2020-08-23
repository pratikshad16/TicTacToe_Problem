#!/bin/bash -x
echo "Welcome to TicTacToe Program"

declare -A board
#variables
row=3
column=3

function resettingBoard()
{
	for (( i=1; i<=$row; i++ ))
	do
		for (( j=1; j<=$column; j++ ))
		do
			board[$i,$j]="-"
		done
	done
}

resettingBoard
