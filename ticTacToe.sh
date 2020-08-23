##!/bin/bash -x
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

function tossToPlayFirst()
{
	randomToss=$((RANDOM%2))
	if [[ $randomToss -eq 0 ]]
	then
		echo "Player1 wins the toss"
	else
		echo "player2 wins the toss"
	fi
}

tossToPlayFirst
