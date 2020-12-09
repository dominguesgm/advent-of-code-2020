package ex2;

class Nop implements Instruction {
    protected int value;

    Nop(int value) {
        this.value = value;
    }

    public void execute(ProgramData data) {
        data.incrementProgramCounter();
    }

    public int getValue() {
        return this.value;
    }

    public String getType() {
        return "nop";
    }
}