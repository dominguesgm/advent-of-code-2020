package ex2;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

class Main {
    public static void main(String[] args) {

        Program program = new Program();

        try {
            File myObj = new File("./data.txt");
            Scanner myReader = new Scanner(myObj);

            while(myReader.hasNextLine()) {
                String data =  myReader.nextLine();

                program.parseAndAppend(data);
            }

            myReader.close();
        } catch(FileNotFoundException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        }
        
        int instrToMutate = 0;
        Integer acc;
        do {
            acc = program.mockRun(instrToMutate);
            instrToMutate++;
        } while (acc == null);

        System.out.println("Accumulator was: " + acc);
    }
}