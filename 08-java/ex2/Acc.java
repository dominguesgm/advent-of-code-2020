package ex2;

class Acc implements Instruction {
    protected int value;

    Acc(int value) {
        this.value = value;
    }

    public void execute(ProgramData data) {
        data.incrementAccumulator(this.value);
        data.incrementProgramCounter();
    }

    public int getValue() {
        return this.value;
    }

    public String getType() {
        return "acc";
    }
}