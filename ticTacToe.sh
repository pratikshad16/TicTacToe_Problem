##!/bin/bash -x
echo "Welcome to TicTacToe Program"

declare -A board
#constants
ROW=3
COLUMN=3
TOTAL_MOVES=9

count=1

#function for resetting the board
function resettingBoard()
{
	for (( row=1; row<=$ROW; row++ ))
	do
		for (( column=1; column<=$COLUMN; column++ ))
		do
			board[$row,$column]="-"
		done
	done
}

#function for assigning the letter
function letterAssignment()
{
	randomLetter=$((RANDOM%2))
	if [[ $randomLetter -eq 0 ]]
	then
		player="O"
	else
		player="X"
	fi
	echo $player
}

#function for toss
function toss()
{
	randomToss=$((RANDOM%2))
	if [[ $randomToss -eq 0 ]]
	then
		currentPlayer=$(letterAssignment)
	else
		currentPlayer=$(letterAssignment)
	fi
}

#function for displaying board
function displayBoard()
{
	echo -e "----------------"
	for (( row=1; row<=ROW; row++ ))
	do
		for (( column=1; column<=COLUMN+1; column++ ))
		do
			echo -e "|| ${board[$row,$column]} \c"
		done
   echo -e "\n----------------"
	done
}

#function for changing player
function changePlayer()
{
	if [[ $1 == "X" ]]
	then
		currentPlayer="O"
	else
		currentPlayer="X"
	fi
}

#function for checkking winning conditions
function checkWin()
{
	diagonalOneCondition=0
	diagonalTwoCondition=0
	win=0
	for (( i=1; i<=3; i++ ))
	do
		rowCondition=0
		columnCondition=0
		#row check
		for (( j=1; j<=3; j++ ))
		do
			if [[ ${board[$i,$j]} == $1 ]]
			then
				rowCondition=$((rowCondition+1))
			fi
		done
		#column check
		for (( k=1; k<=3; k++ ))
		do
			if [[ ${board[$k,$i]} == $1 ]]
			then
				columnCondition=$((columnCondition+1))
			fi
		done
		#diagonal one
		if [[ ${board[$i,$i]} == $1 ]]
		then
			diagonalOneCondition=$((diagonalOneCondition+1))
		fi
		#diagonaltwo
		for (( y=1; y<=3; y++ ))
		do
			add=$((i+y))
			if [[ $add == 4 && ${board[$i,$y]} == $1 ]]
			then
				diagonalTwoCondition=$((diagonalTwoCondition+1))
			fi
		done
	if [[ $rowCondition == 3 || $columnCondition == 3 || $diagonalOneCondition == 3 || $diagonalTwoCondition == 3 ]]
	then
		win=1
	fi
	done
}

#function for playing the game
function playingGame()
{
	row=$1
	column=$2
	if [[ ${board[$row,$column]} == "-" ]]
	then
		board[$row,$column]=$currentPlayer
		displayBoard
		checkWin $currentPlayer
		((count++))
		if [[ $win == 1 ]]
		then
			echo "$currentPlayer wins"
			exit
		fi
			changePlayer $currentPlayer
	else
		echo "No place"
	fi
}

#function to check availability of corners
function checkCorners()
{
	if [[ $block == 0 ]]
	then
		for (( row=1; row<=$ROW; $((row+=2)) ))
		do
			for (( column=1; column<=$COLUMN; $((column+=2)) ))
			do
				if [[ ${board[$row,$column]} == "-" ]]
				then
					board[$row,$column]=$currentPlayer
					displayBoard
					win=0
					((count++))
					block=1
					break
				fi
			done
			if [[ $block == 1 ]]
			then
				break
			fi
		done
	fi
}

#when corners are not available then select center
function checkCenter()
{
	if [[ $block == 0 ]]
	then
		if [[ ${board[$2,$3]} == "-" ]]
		then
			board[$2,$3]=$1
			displayBoard
			win=0
			((count++))
			block=1
		fi
	fi
}


#when corners and center is not avalible
function checkSides()
{
	if [[ block == 0 ]]
	then
		for (( row=1; row<=$ROW; row++ ))
		do
			for ((column=1; column<=$COLUMN; column++ ))
			do
				sum=$((row+column))
				if [[ $sum == 3 || $sum == 5 ]]
				then
					if [[ ${board[$row,$column]} == "-" ]]
					then
						board[$row,$column]=$1
						displayBoard
						win=0
						((count++))
						block=1
					fi
				fi
			done
		done
	fi
}
#checkwin before playing game
function computerPlayToWin()
{
	block=0
	for (( row=1; row<=$ROW; row++ ))
	do
		for (( column=1; column<=$COLUMN; column++ ))
		do
			if [[ ${board[$row,$column]} == "-" ]]
			then
				board[$row,$column]=$1
				checkWin $1
				if [[ $win == 0 ]]
				then
					board[$row,$column]="-"
				elif [[ $win == 1 && ${board[$row,$column]} == $currentPlayer ]]
				then
					displayBoard
					echo "!!! $currentPlayer wins !!!"
					exit
				elif [[ $win == 1 ]]
				then
					board[$row,$column]=$currentPlayer
					displayBoard
					win=0
					block=1
					count=$((count+1))
					break
				fi
			fi
		done
		if [[ $block == 1 ]]
		then
			break
		fi
	done
}

resettingBoard
toss
displayBoard
while [[ $count -le TOTAL_MOVES ]]
do
	if [[ $currentPlayer == "X" ]]
	then
		read -p "Enter row Position: " rowPosition
		read -p "Enter column position: " columnPosition
		playingGame $rowPosition $columnPosition
	else
		echo -e "\nComputer turn :\n"
		nextPlayer="X"
		computerPlayToWin $currentPlayer
		computerPlayToWin $nextPlayer
		checkCorners $currentPlayer
		row=$((ROW/2+1))
		column=$((COLUMN/2+1))
		checkCenter $currentPlayer $row $column
		checkSides $currentPlayer
		if [[ $block == 0 ]]
		then
			rowPosition=$((RANDOM % 3 + 1))
			columnPosition=$((RANDOM % 3 + 1))
			playingGame $rowPosition $columnPosition
		else
			changePlayer $currentPlayer
		fi
	fi
done
if [[ $win == 0 ]]
then
	echo "oh oh It is a tie game"
fi
