package main

import (
	"fmt"
)

func countValidMessages(program Program) int {
	count := 0

	for _, message := range program.messages {
		if isMessageValidLoop(program.instructions, message) {
			count++
		}
	}

	return count
}

func main() {
    program := readFile("tiny_data2_replaced.txt")

	count := countValidMessages(program)

	fmt.Println(count)
}
