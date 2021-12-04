package main

import (
	"bufio"
    "fmt"
    "log"
    "os"
	"strings"
	"regexp"
)

func check(e error) {
    if e != nil {
        panic(e)
    }
}

func parseInstruction(instructionText string) (Instruction, string) {
	instruction := Instruction{segments: []InstructionSegment{}}

	instructionIndexArray := strings.Split(instructionText, ": ")
	
	segmentsTextArray := strings.Split(instructionIndexArray[1], " | ")

	for _, segmentText := range segmentsTextArray {
		var segment InstructionSegment
		match, _ := regexp.MatchString("\"[a-z]*\"", segmentText);

		if match {
			segment.value = string(segmentText[1])
		} else {
			segment.value = ""
			segment.sequence = []string{}
			referenceArray := strings.Split(segmentText, " ")

			for _, reference := range referenceArray {
				segment.sequence = append(segment.sequence, reference)
			}
		}

		instruction.segments = append(instruction.segments, segment)
	}

	return instruction, instructionIndexArray[0]
}

func readFile(filename string) Program {
	file, err := os.Open(filename)
	check(err)
	defer file.Close()

	scanner := bufio.NewScanner(file)

	program := Program{instructions: map[string]Instruction{}, messages: []string{}}
	
	stage := "instructions"
	for scanner.Scan() {
		line := scanner.Text()

		if line == "" {
			stage = "messages"
			continue;
		}

		switch stage {
		case "instructions":
			instruction, index := parseInstruction(line)
			program.instructions[index] = instruction
		case "messages":
			program.messages = append(program.messages, line)
		}
	}

	fmt.Println(program)

	if err := scanner.Err(); err != nil {
        log.Fatal(err)
    }

	return program
}