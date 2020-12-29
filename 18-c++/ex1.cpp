#include <iostream>
#include <fstream>
#include <vector>

using namespace std;

int main() {
    ifstream dataFile;
    dataFile.open("./data.txt");
    string expressionString;
    long accumulator = 0;

    while(getline(dataFile, expressionString)) {

        int currentLevel = 0;
        vector<long> levelAccumulators(10, 0);
        vector<char> levelOperators(10, '+');
        int stringIndex = 0;

        while(stringIndex < expressionString.length()) {
            char currChar = expressionString.at(stringIndex);
            if(isdigit(currChar)) {
                if(levelOperators.at(currentLevel) == '+') {
                    levelAccumulators.at(currentLevel) += (currChar - '0');
                } else {
                    levelAccumulators.at(currentLevel) *= (currChar - '0');
                }
            }

            if(currChar == '(') {
                currentLevel++;
                levelAccumulators.at(currentLevel) = 0;
                levelOperators.at(currentLevel) = '+';
            }

            if(currChar == ')') {
                currentLevel--;
                if(levelOperators.at(currentLevel) == '+') {
                    levelAccumulators.at(currentLevel) += levelAccumulators.at(currentLevel + 1);
                } else {
                    levelAccumulators.at(currentLevel) *= levelAccumulators.at(currentLevel + 1);
                }
            }

            if(currChar == '*' || currChar == '+') {
                levelOperators.at(currentLevel) = currChar;
            }

            stringIndex++;
        }

        cout << expressionString << " = " << levelAccumulators.at(0) << "\n";
        accumulator += levelAccumulators.at(0);
    }

    

    cout << "Result: " << accumulator << "\n";

}