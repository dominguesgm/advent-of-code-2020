package ex1;

class Acc implements Instruction {
    protected int value;

    Acc(int value) {
        this.value = value;
    }

    public void execute(ProgramData data) {
        data.incrementAccumulator(this.value);
        data.incrementProgramCounter();
    }
}