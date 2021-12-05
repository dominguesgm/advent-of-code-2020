package main

import (
	"fmt"
)

type AnalysisSubject struct {
	matchesSoFar bool
	messageLeftToAnalyze string
}

func runInstructionSegmentLoop(segment InstructionSegment, message string, instructions map[string]Instruction) []AnalysisSubject {
	analysisList := []AnalysisSubject{}

	if message == "" {
		return analysisList
	}
	
	if segment.value != "" {
		if segment.value == string(message[0]) {
			analysisList = append(analysisList, AnalysisSubject{matchesSoFar: true, messageLeftToAnalyze: message[1:]})
		}
		return analysisList
	}

	analysisList = append(analysisList, AnalysisSubject{matchesSoFar: true, messageLeftToAnalyze: message})
	
	for _, instructionAddress := range segment.sequence {

		tempAnalysisList := []AnalysisSubject{}
		for _, analysisItem := range analysisList {
			resultList := runInstructionLoop(instructions[instructionAddress], analysisItem.messageLeftToAnalyze, instructions)

			if len(resultList) > 0 {
				tempAnalysisList = append(tempAnalysisList, resultList...)
			}
		}

		analysisList = tempAnalysisList

		if len(tempAnalysisList) == 0 {
			return analysisList
		}
	}

	return analysisList
}

func runInstructionLoop(instruction Instruction, message string, instructions map[string]Instruction) []AnalysisSubject {
	matchingList := []AnalysisSubject{}
	for _, segments := range instruction.segments {
		resultList := runInstructionSegmentLoop(segments, message, instructions)

		for _, resultItem := range resultList {
			if resultItem.matchesSoFar {
				matchingList = append(matchingList, resultItem)
			}
		}
	}

	return matchingList
}

func isMessageValidLoop(instructions map[string]Instruction, message string) bool {
	initialInstruction := instructions["0"]


	resultList := runInstructionLoop(initialInstruction, message, instructions)
	isMatch := false

	for _, match := range resultList {
		if match.messageLeftToAnalyze == "" {
			isMatch = true
			break
		}
 	}

	if isMatch {
		fmt.Println(message)
	}

	return isMatch
}