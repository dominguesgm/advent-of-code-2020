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
    
    IFS=- read -r min max <<< "${fieldArray[1]}"
    letter=${fieldArray[2][1]}
    string=${fieldArray[3]}

    numOccur=$(echo $string | grep -o -n $letter | wc -l)

    echo $min
    echo $numOccur
    echo $max

    if ((numOccur>=min && numOccur<=max ))
        then
            count=$(($count + 1))
            echo "yes : $numOccur"
        else
            echo "nope: $numOccur"
    fi

    echo $line
    echo $string
done < "$input"

echo $count