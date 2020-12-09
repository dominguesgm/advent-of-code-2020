package ex2;

import java.util.ArrayList;
import java.util.HashMap;

class Program {
    protected ProgramData programData;
    protected ArrayList<Instruction> instructions;
    protected HashMap<Integer, Boolean> ranLines;
    protected ArrayList<Integer> nopAndJmpLocations; 
    
    Program() {
        this.instructions = new ArrayList<Instruction>();
        this.nopAndJmpLocations = new ArrayList<Integer>();
    }

    public void parseAndAppend(String inputLine) {
        String[] tokens = inputLine.split(" ");

        switch(tokens[0]) {
            case "jmp":
                nopAndJmpLocations.add(instructions.size());
                instructions.add(new Jmp(Integer.parseInt(tokens[1])));
                break;
            case "acc":
                instructions.add(new Acc(Integer.parseInt(tokens[1])));
                break;                
            case "nop":
                nopAndJmpLocations.add(instructions.size());
                instructions.add(new Nop(Integer.parseInt(tokens[1])));
                break;
            default:
                break;
        }
    }

    public Integer run() {
        this.resetMetadata();

        while(true) {
            int counter = this.programData.getProgramCounter();
            Instruction currInstruction = this.instructions.get(counter);
            currInstruction.execute(this.programData);

            if(this.hasLoopBeenFound()) {
                return null;
            }

            if(this.programData.getProgramCounter() == instructions.size()) {
                break;
            }
        };

        return this.programData.getAccumulator();
    }

    public Integer mockRun(int instructionToChange) {
        this.resetMetadata();

        while(true) {
            int counter = this.programData.getProgramCounter();

            Instruction currInstruction = this.instructions.get(counter);
            if(counter == this.nopAndJmpLocations.get(instructionToChange)) {
                if(currInstruction.getType().equals("jmp")) {
                    currInstruction = new Nop(currInstruction.getValue());
                } else {
                    currInstruction = new Jmp(currInstruction.getValue());
                }
            }
            currInstruction.execute(this.programData);

            if(this.hasLoopBeenFound()) {
                return null;
            }

            if(this.programData.getProgramCounter() >= this.instructions.size()) {
                return this.programData.getAccumulator();
            }
        }
    }

    private boolean hasLoopBeenFound() {
        Boolean currentRan = this.ranLines.get(this.programData.getProgramCounter());
        if(currentRan == null || !currentRan) {
            ranLines.put(this.programData.getProgramCounter(), true);
            return false;
        } else {
            return true;
        }
    }

    private void resetMetadata() {
        this.programData = new ProgramData();
        this.ranLines = new HashMap<Integer, Boolean>();
    }

    public ArrayList<Integer> getNopAndJmpLocations() {
        return this.nopAndJmpLocations;
    }
}