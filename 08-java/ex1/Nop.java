package ex1;

class Nop implements Instruction {
    protected int value;

    Nop(int value) {
        this.value = value;
    }

    public void execute(ProgramData data) {
        data.incrementProgramCounter();
    }
}