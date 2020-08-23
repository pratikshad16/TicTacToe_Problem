##!/bin/bash -x
echo "Welcome to TicTacToe Program"

declare -A board
#variables
row=3
column=3
count=1

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


function tossToPlayFirst()
{
	randomToss=$((RANDOM%2))
	if [[ $randomToss -eq 0 ]]
	then
		currentPlayer=$(letterAssignment)
	else
		currentPlayer=$(letterAssignment)
	fi
}


function seeBoard()
{
	echo -e "----------------"
	for (( i=1; i<=row; i++ ))
	do
		for (( j=1; j<=column+1; j++ ))
		do
			echo -e "|| ${board[$i,$j]} \c"
		done
   echo -e "\n----------------"
	done
}


function changePlayer()
{
	if [[ $1 == "X" ]]
	then
		currentPlayer="O"
	else
		currentPlayer="X"
	fi
}
function checkWin()
{
	match3=0
	match4=0
	win=0
	for (( i=1; i<=3; i++ ))
	do
		match1=0
		match2=0
		#row check
		for (( j=1; j<=3; j++ ))
		do
			if [[ ${board[$i,$j]} == $1 ]]
			then
				match1=$((match1+1))
			fi
		done
		#column check
		for (( k=1; k<=3; k++ ))
		do
			if [[ ${board[$k,$i]} == $1 ]]
			then
				match2=$((match2+1))
			fi
		done
		#diagonal one
		if [[ ${board[$i,$i]} == $1 ]]
		then
			match3=$((match3+1))
		fi
		#diagonaltwo
		for (( y=1; y<=3; y++ ))
		do
			add=$((i+y))
			if [[ $add == 4 && ${board[$i,$y]} == $1 ]]
			then
				match4=$((match4+1))
			fi
		done
	if [[ $match1 == 3 || $match2 == 3 || $match3 == 3 || $match4 == 3 ]]
	then
		win=1
	fi
	done
}

function playingGame()
{
	row1=$1
	column1=$2
	if [[ ${board[$row1,$column1]} == "-" ]]
	then
		board[$row1,$column1]=$currentPlayer
		seeBoard
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

function checkCorners()
{
	if [[ $block == 0 ]]
	then
		for (( a=1; a<=$row; $((a+=2)) ))
		do
			for (( b=1; b<=$column; $((b+=2)) ))
			do
				if [[ ${board[$a,$b]} == "-" ]]
				then
					board[$a,$b]=$currentPlayer
					seeBoard
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

#checkwin before playing game
function computerPlayToWin()
{
	block=0
	for (( m=1; m<=$row; m++ ))
	do
		for (( n=1; n<=$column; n++ ))
		do
			if [[ ${board[$m,$n]} == "-" ]]
			then
				board[$m,$n]=$1
				checkWin $1
				if [[ $win == 0 ]]
				then
					board[$m,$n]="-"
				elif [[ $win == 1 && ${board[$m,$n]} == $currentPlayer ]]
				then
					seeBoard
					echo "!!! $currentPlayer wins !!!"
					exit
				elif [[ $win == 1 ]]
				then
					board[$m,$n]=$currentPlayer
					seeBoard
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
tossToPlayFirst
seeBoard
while [[ $count -le 9 ]]
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
