#!/bin/zsh

input="./data.txt"
count=0
while IFS= read -r line
do
    fields=$(echo $line | tr " " "\n")
    fieldArray=()

    while IFS='\n' read -r item
    do
        fieldArray+=($item)
    done <<< "$fields"
    
    IFS=- read -r locA locB <<< "${fieldArray[1]}"
    letter=${fieldArray[2][1]}
    string=${fieldArray[3]}

    letterA=${string[$locA]}
    letterB=${string[$locB]}

    echo "letter : $letter"
    echo "letter A : " $letterA
    echo "letter B : " $letterB

    if [ $letter = $letterA ]
        then
            if [ $letter != $letterB ]
            then
                count=$(($count + 1))
                echo "yes"
            else 
                echo "nope"
            fi
        else
            if [ $letter = $letterB ]
            then
                count=$(($count + 1))
                echo "yes"
            else 
                echo "nope"
            fi
    fi
done < "$input"

echo $count