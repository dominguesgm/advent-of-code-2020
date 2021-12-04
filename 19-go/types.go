package main 

type InstructionSegment struct {
	sequence []string
	value string
}

type Instruction struct {
	segments []InstructionSegment
}

type Program struct {
	instructions map[string]Instruction
	messages []string
}