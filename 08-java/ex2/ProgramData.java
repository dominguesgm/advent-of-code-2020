package ex2;

class ProgramData {
    protected int programCounter;
    protected int accumulator;

    ProgramData() {
        this.programCounter = 0;
        this.accumulator = 0;
    }

    public int getAccumulator() {
        return this.accumulator;
    }

    public void incrementAccumulator(int value) {
        this.accumulator += value;
    }

    public int getProgramCounter() {
        return this.programCounter;
    }

    public void setProgramCounter(int value) {
        this.programCounter = value;
    }

    public void incrementProgramCounter() {
        this.programCounter++;
    }
}