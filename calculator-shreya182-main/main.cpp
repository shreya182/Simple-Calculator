/*
 * Author: Shreya Suresh
 * Description: Calculator using the terminal. It can multiply, divide, add and substract numbers. 
 * 		The user can enter as many expressions as they want. 
 * 		It also prints a history of calculations.
 */
#include <iostream>
#include <sstream>
#include <vector>
#include <cmath>

/*
 * Function: print_error
 * Description: Prints an error message explaining that the user supplied
 * 		an invalid arithmetic expression.
 */
void print_error() {
	// DO NOT MODIFY THIS FUNCTION, OR ELSE YOU RISK BREAKING THE GRADING
	// SCRIPT.
	std::cout << "That isn't a valid arithmetic expression." << std::endl;
}

/*
 * Function: prompt_for_arithmetic_expression
 * Description: Prompts the user for an arithmetic expression and returns
 * 		whatever text they supply, whether that text represents a valid
 * 		arithmetic expression or not (validity should be checked elsewhere;
 * 		checking validity is not this particular function's responsibility).
 * Returns: An entire line of text supplied by the user via the terminal when
 * 		prompted for an arithmetic expression
 */
std::string prompt_for_arithmetic_expression() {
	// DO NOT MODIFY THE BELOW PRINT STATEMENT, OR ELSE YOU RISK BREAKING THE
	// GRADING SCRIPT
	std::string str;
	std::cout << "Enter a valid arithmetic expression: ";
	std::getline(std::cin, str);
	return str;
	// TODO Complete this function so that it reads the user's line of text
	// and returns it
}

/*
 * Function: prompt_for_retry
 * Description: Asks the user whether they'd like to enter another arithmetic
 * 		expression and returns their entire line-of-text response
 * Returns: An entire line of text supplied by the user via the terminal when
 * 		asked if they'd like to enter another arithmetic expression. If this
 * 		function returns the string "Y", then that means the user would like
 * 		to enter another arithmetic expression.
 */
std::string prompt_for_retry() {
	// DO NOT MODIFY THE BELOW PRINT STATEMENT, OR ELSE YOU RISK BREAKING THE
	// GRADING SCRIPT
	std::string str;
	std::cout << "Would you like to enter another expression? Enter Y for "
		"yes: ";
	std::getline(std::cin, str);
	return str;
	// TODO Complete this function so that it reads the user's line of text
	// and returns it
}

/*
 * Function: print_history_header
 * Description: Prints the header that precedes the history of values to be
 * 		printed at the end of the program.
 */
void print_history_header() {
	// DO NOT MODIFY THIS FUNCTION, OR ELSE YOU RISK BREAKING THE GRADING
	// SCRIPT. YOU SHOULD CALL THIS FUNCTION FROM WITHIN A LARGER FUNCTION
	// WHOSE RESPONSIBILITY IS TO PRINT THE ENTIRE HISTORY.
	std::cout << "History of computed values:" << std::endl;
}

/*
 * Function: is_number
 * Description: Determines whether a given string holds a valid numeric value
 * Returns: True if the given string holds a valid numeric value, or false
 * 		otherwise. If this function returns true, it's safe to use std::stod()
 * 		on the string to convert it to a number (double) afterwards. Otherwise,
 * 		the given string does not contain a valid numeric value, and attempting
 * 		to use std::stod() on the string may crash your program.
 */
bool is_number(std::string str) {
	// A valid number must contain at least one digit and at most one
	// decimal point
	int num_digits = 0;
	int num_points = 0;
	for (int i = 0; i < str.length(); i++) {
		bool is_point = str.at(i) == '.';
		// A negative sign is a dash at the beginning of the string
		bool is_negative_sign = str.at(i) == '-' && i == 0;
		bool is_number = str.at(i) >= '0' && str.at(i) <= '9';

		if (is_point) {
			// If the character is a decimal point, increment
			// the number of points found, and return false if
			// it's greater than 1
			num_points++;
			if (num_points > 1) {
				return false;
			}
		}
		if (is_number) {
			// If the character is a digit, increment the number of
			// digits found
			num_digits++;
		}

		// If the character isn't any of the three valid possibilities,
		// return false, immediately ending the function
		if (!is_point && !is_negative_sign && !is_number) {
			return false;
		}
	}

	// Return true only if at least one digit was found
	return num_digits > 0;
}
/*
 * Function: is_operator
 * Description: Determines whether a given string holds an operator
 * Returns: True if the given string holds an operator, or false
 *              otherwise. If this function returns true, you can perform an operator.
 */
bool is_operator(std::string str) {
  // Check if the string is empty or has more than one character
  if (str.empty() || str.length() > 1) {
    return false;
  }

  char c = str[0]; // Extract the single character

  // Check if the character is one of the valid operators
  std::string operators = "+-*/";
  return operators.find(c) != std::string::npos;
}
/*
 * Function: is_valid_expression
 * Description: Determmines whether an expression is valid. Valid means that it 
 * 		has alternate numbers and operators with a space seperating them,
 * 		start and end with a number, and have at least one number.
 * Returns: True if the given string is a valid expression, or false otherwise. If this function
 *		holds true, you can calculate the expression.
 */ 
bool is_valid_expression(std::string expression) {
    std::string token;
    std::string prev_token = ""; // Store the previous token
    bool expect_number = true; // Start by expecting a number
    bool last_token_was_operator = false; // Track if the last token was an operator

    // Iterate through each character in the input string
    for (char c : expression) {
        if (c == ' ') {
            // If current character is a space, check the token
            if (expect_number) {
                // Expecting a number
                if (token.empty() || !is_number(token)) {
                    // Invalid number
                    return false;
                }
                expect_number = false; // Next, expect an operator
            } else {
                // Expecting an operator
                if (token == "-" && !last_token_was_operator && prev_token.empty()) {
                    // Negative sign
                    // Do nothing, continue expecting an operator
                } else if (!is_operator(token)) {
                    // Invalid operator
                    return false;
                } else {
                    // Reset expect_number and update last_token_was_operator
                    expect_number = true;
                    last_token_was_operator = true;
                }
            }
            // Update the previous token and reset the token for the next iteration
            prev_token = token;
            token.clear();
        } else {
            // Append non-space characters to the current token
            token += c;
        }
    }

    // Check the last token after the loop ends
    if (expect_number) {
        // Expecting a number
        if (token.empty() || !is_number(token)) {
            // Invalid number
            return false;
        }
    } else {
        // Expecting an operator
        if (token == "-" && !last_token_was_operator && prev_token.empty()) {
            // Double negative sign at the end, treat as positive number
            // Do nothing
        } else if (!is_operator(token)) {
            // Invalid operator
            return false;
        }
    }

    
    // The expression is valid if all tokens are valid
    return true;
}
/*
 * Function: evaluate_expression
 * Description: Calculates a numerical expression
 * Returns: The result of the calculations, which is a double.  
 */ 
double evaluate_expression(std::string str) {
    double result = 0;
    char op = '+';
    bool negative = false;
    bool lastWasOperator = true;
    std::string numStr;
    for (char c : str) {
        if (c == ' ') {
            if (!numStr.empty()) {
		double num = std::stod(numStr);
		if (negative) {
			num *= -1;
			negative = false;
		}	
                
                if (op == '*')
                    result *= num;
                else if (op == '/')
                    result /= num;
		else if (op == '+')
                    result += num;
                else if (op == '-')
                    result -= num;
                numStr.clear();
		lastWasOperator = false;
            }
        } else if (isdigit(c) || c == '.') {
            numStr += c;
	    lastWasOperator = false;
        } else if (c == '+' || c == '-' || c == '*' || c == '/') {
            if (c == '-' && lastWasOperator) {
		    negative = true;
	    } else {
		op = c;
	    } 
	    lastWasOperator = true;
        }
    }
    if (lastWasOperator){
	return 0;
    }
    // Process the last number
    if (!numStr.empty()) {
        double num = std::stod(numStr);
	if (negative){
		num *= -1;
	}
        if (op == '+')
            result += num;
        else if (op == '-')
            result -= num;
        else if (op == '*')
            result *= num;
        else if (op == '/')
            result /= num;
    }
    return result;
}

int main() {
    
    double history[100];
    int history_size = 0;

    bool again = true;
    while (again) {
        std::string str = prompt_for_arithmetic_expression();
        if (is_valid_expression(str) == false) {
            print_error();
	    continue;
        }
        double result = evaluate_expression(str);
	if (result == 0){
		print_error();
	} else {
	std::cout << result << std::endl;
        history[history_size++] = result;
	}
        std::string response = prompt_for_retry();
        if (response != "Y") {
            again = false;
        }
    }

    print_history_header();
    for (int i = 0; i < history_size; i++) {
        std::cout << history[i] << std::endl;
    }

    return 0;
}
