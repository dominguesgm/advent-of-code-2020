package main

import (
	"fmt"
)

func runInstructionSegment(segment InstructionSegment, message string, instructions map[string]Instruction) (bool, string) {
	if message == "" {
		return false, message
	}
	
	if segment.value != "" {
		if segment.value == string(message[0]) {
			return true, message[1:]
		} else {
			return false, message
		}
	}

	messageLeftToAnalyze := message
	
	for _, instructionAddress := range segment.sequence {
		isMatch, resultingMessage := runInstruction(instructions[instructionAddress], messageLeftToAnalyze, instructions)

		if isMatch {
			messageLeftToAnalyze = resultingMessage
		} else {
			return false, message
		}
	}

	return true, messageLeftToAnalyze
}

func runInstruction(instruction Instruction, message string, instructions map[string]Instruction) (bool, string) {
	for _, segments := range instruction.segments {
		isMatch, resultingMessage := runInstructionSegment(segments, message, instructions)
		if(isMatch) {
			return true, resultingMessage
		}
	}

	return false, message
}

func isMessageValid(instructions map[string]Instruction, message string) bool {
	initialInstruction := instructions["0"]


	isMatch, resultingMessage := runInstruction(initialInstruction, message, instructions)
	isMatch = isMatch && resultingMessage == ""

	if isMatch {
		fmt.Println(message)
	}

	return isMatch
}