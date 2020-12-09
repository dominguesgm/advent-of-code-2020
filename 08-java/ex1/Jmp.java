package ex1;

class Jmp implements Instruction {
    protected int value;

    Jmp(int value) {
        this.value = value;
    }

    public void execute(ProgramData data) {
        data.setProgramCounter(data.getProgramCounter() + this.value);
    }
}