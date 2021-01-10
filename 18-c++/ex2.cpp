#include <iostream>
#include <fstream>
#include <vector>
#include <climits>
#include <regex>

using namespace std;

int main() {
    ifstream dataFile;
    dataFile.open("./data.txt");
    string expressionString;
    long long accumulator = 0;

    while(getline(dataFile, expressionString)) {
        int maxLevel = 0;
        int currentLevel = 0;
        vector<string> processedExpression;
        for(int i = 0; i < expressionString.size(); i++) {
            if(expressionString[i] != ' ') {
                processedExpression.push_back(string(1, expressionString[i]));

                switch(expressionString[i]) {
                    case '(':
                        currentLevel++;
                        if(currentLevel > maxLevel) {
                            maxLevel = currentLevel;
                        }
                        break;
                    case ')':
                        currentLevel--;
                        break;
                }
            }
        }

        int lastPriority = 0;
        bool shouldPrioritize = true;
        int noPriorityIn = -1;
        int lastMults = 0;
        int multLevel = maxLevel;
        
        while(processedExpression.size() > 1) {
            int index = 0;
            int currentLevel = 0;

            cout << "Expression: ";
            for( int i = 0; i < processedExpression.size(); i++) {
                cout << processedExpression.at(i);
            }
            cout << "\n";

            while(index < processedExpression.size()) {
                if(processedExpression.at(index) == "(") {
                    currentLevel++;
                }

                if(processedExpression.at(index) == ")") {
                    currentLevel--;
                }

                if(index > 0 && index < processedExpression.size() - 1) {
                    if(!shouldPrioritize) {
                        if (regex_match(processedExpression.at(index - 1), regex("^[0-9]+$")) &&
                            regex_match(processedExpression.at(index + 1), regex("^[0-9]+$")) &&
                            processedExpression.at(index) == "*" && multLevel == currentLevel &&
                            currentLevel == multLevel) {

                            processedExpression.at(index - 1) = to_string(stoll(processedExpression.at(index - 1)) * stoll(processedExpression.at(index + 1)));
                            processedExpression.erase(processedExpression.begin() + index + 1);
                            processedExpression.erase(processedExpression.begin() + index);
                            lastMults++;
                            continue;
                        }
                    } else {
                        if (regex_match(processedExpression.at(index), regex("^[0-9]+$")) && processedExpression.at(index - 1) == "(" && processedExpression.at(index + 1) == ")") {
                            processedExpression.erase(processedExpression.begin() + index + 1);
                            processedExpression.erase(processedExpression.begin() + index - 1);
                            lastPriority++;
                            continue;
                        } else if (regex_match(processedExpression.at(index - 1), regex("^[0-9]+$")) && regex_match(processedExpression.at(index + 1), regex("^[0-9]+$")) && processedExpression.at(index) == "+") {
                            processedExpression.at(index - 1) = to_string(stoll(processedExpression.at(index - 1)) + stoll(processedExpression.at(index + 1)));
                            processedExpression.erase(processedExpression.begin() + index + 1);
                            processedExpression.erase(processedExpression.begin() + index);
                            lastPriority++;
                            continue;
                        }
                    }
                }
                
                index++;
            }

            if(lastPriority > 0) {
                noPriorityIn = -1;
                lastPriority = 0;
                continue;
            }

            if(shouldPrioritize && lastPriority == 0) {
                shouldPrioritize = false;
                lastMults = 0;
                noPriorityIn++;
                multLevel = maxLevel - noPriorityIn;
                continue;
            }

            if(!shouldPrioritize) {
                shouldPrioritize = true;
                lastMults = 0;
                lastPriority = 0;
            }

        }

        cout << expressionString << " = " << processedExpression.at(0) << "\n";
        accumulator += stol(processedExpression.at(0));
    }

    

    cout << "Result: " << accumulator << "\n";

}