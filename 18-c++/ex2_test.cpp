#include <iostream>
#include <fstream>
#include <vector>

using namespace std;

char nextOperator(string expression) {
    int parenthisisCount = 0;
    for(int i = 0; i < expression.length(); i++) {
        if(parenthisisCount < 0) {
            break;
        }

        switch(expression.at(i)) {
            case '(':
                parenthisisCount++;
                break;
            case ')':
                parenthisisCount--;
                break;
            case '+':
            case '*':
                if(parenthisisCount == 0) {
                    return expression.at(i);
                }
            default:
                break;
        }
    }

    return ' ';
}

int main() {
    ifstream dataFile;
    dataFile.open("./tiny_data2.txt");
    string expressionString;
    long long accumulator = 0;

    while(getline(dataFile, expressionString)) {

        int currentLevel = 0;
        int priorityLevel = 0;
        vector<long long> levelAccumulators(10, 0);
        vector<char> levelOperators(10, '+');
        vector<bool> highPriorityFlag(10, false);
        int stringIndex = 0;

        while(stringIndex < expressionString.length()) {
            char currChar = expressionString.at(stringIndex);

            cout << "char: " << currChar << "\n";
            cout << "level: " << currentLevel << "\n";
            cout << "level accumulator: " << levelAccumulators.at(currentLevel) << "\n";
            cout << "High priority: " << highPriorityFlag.at(currentLevel) << "\n";

            if(isdigit(currChar)) {
                if(levelOperators.at(currentLevel) == '+') {
                    levelAccumulators.at(currentLevel) += (currChar - '0');
                } else {
                    char nextSameLevelOperator = nextOperator(expressionString.substr(stringIndex, string::npos));

                    if(nextSameLevelOperator == '+') {
                        currentLevel++;
                        highPriorityFlag.at(currentLevel) = true;
                        levelAccumulators.at(currentLevel) = (currChar - '0');
                    } else {   
                        levelAccumulators.at(currentLevel) *= (currChar - '0');
                    }
                }
            }

            if(currChar == '(') {
                if(levelOperators.at(currentLevel) == '+') {
                    currentLevel++;
                    levelAccumulators.at(currentLevel) = 0;
                    levelOperators.at(currentLevel) = '+';
                    highPriorityFlag.at(currentLevel) = false;
                } else {
                    char nextSameLevelOperator = nextOperator(expressionString.substr(stringIndex, string::npos));

                    if(nextSameLevelOperator == '+') {
                        currentLevel++;
                        highPriorityFlag.at(currentLevel) = true;
                    }

                    currentLevel++;
                    levelAccumulators.at(currentLevel) = 0;
                    levelOperators.at(currentLevel) = '+';
                    highPriorityFlag.at(currentLevel) = false;
                }
            }

            if(currChar == ')') {
                if(highPriorityFlag.at(currentLevel)) {
                    long long rightSideValue = levelAccumulators.at(currentLevel);
                    currentLevel--;

                    cout << rightSideValue << "\n";
                    switch(levelOperators.at(currentLevel)){
                        case '+':
                            levelAccumulators.at(currentLevel) += rightSideValue;
                            break;
                        case '*':
                            levelAccumulators.at(currentLevel) *= rightSideValue;
                            break;
                    }
                }

                currentLevel--;
                cout << "Test A accumulator: " << levelAccumulators.at(currentLevel + 1) << "\n";
                cout << "Test B accumulator: " << levelAccumulators.at(currentLevel) << "\n\n\n";
                if(levelOperators.at(currentLevel) == '+') {
                    levelAccumulators.at(currentLevel) += levelAccumulators.at(currentLevel + 1);
                } else {
                    levelAccumulators.at(currentLevel) *= levelAccumulators.at(currentLevel + 1);
                }
            }

            if(currChar == '+') {
                levelOperators.at(currentLevel) = currChar;
            }

            if(currChar == '*') {
                if(highPriorityFlag.at(currentLevel)){
                    cout << "high priority\n";
                    long long rightSideValue = levelAccumulators.at(currentLevel);
                    currentLevel--;

                    cout << rightSideValue << "\n";
                    switch(levelOperators.at(currentLevel)){
                        case '+':
                            levelAccumulators.at(currentLevel) += rightSideValue;
                            break;
                        case '*':
                            levelAccumulators.at(currentLevel) *= rightSideValue;
                            break;
                    }
                } else {
                    cout << "low priority\n";
                }

                levelOperators.at(currentLevel) = currChar;
            }

            stringIndex++;
        }

        cout << expressionString << " = " << levelAccumulators.at(0) << "\n";
        accumulator += levelAccumulators.at(0);
    }

    

    cout << "Result: " << accumulator << "\n";

}