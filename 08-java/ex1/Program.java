package ex1;

import java.util.ArrayList;
import java.util.HashMap;

class Program {
    protected ProgramData programData;
    protected ArrayList<Instruction> instructions;
    protected HashMap<Integer, Boolean> ranLines;
    
    Program() {
        this.programData = new ProgramData();
        this.instructions = new ArrayList<Instruction>();
        this.ranLines = new HashMap<Integer, Boolean>();
    }

    public void parseAndAppend(String inputLine) {
        String[] tokens = inputLine.split(" ");

        switch(tokens[0]) {
            case "jmp":
                instructions.add(new Jmp(Integer.parseInt(tokens[1])));
                break;
            case "acc":
                instructions.add(new Acc(Integer.parseInt(tokens[1])));
                break;                
            case "nop":
                instructions.add(new Nop(Integer.parseInt(tokens[1])));
                break;
            default:
                break;
        }
    }

    public int run() {
        do {
            int counter = this.programData.getProgramCounter();
            Instruction currInstruction = this.instructions.get(counter);
            currInstruction.execute(this.programData);
        } while(!this.hasLoopBeenFound());

        return this.programData.getAccumulator();
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
}