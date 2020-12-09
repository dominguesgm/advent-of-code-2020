package ex2;

interface Instruction {
    public void execute(ProgramData data);

    public int getValue();

    public String getType();
}