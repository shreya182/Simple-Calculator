#!/bin/bash

function trim() {
	awk '{$1=$1};1'
}

function test_empty_expression() {
	res=$(echo -e "\n1\nN\n" | timeout 0.1 ./test_build)
	found=$(echo "$res" | head -n 1 | grep "That isn't a valid arithmetic expression" | wc -l)
	if [[ "$found" == 0 ]]
	then
		echo "-5 points. Expected the program to print 'That isn't a valid arithmetic expression' when provided an empty expression, but it doesn't."
	else
		points=5
		echo "+5 points. Empty-expression test passed."
	fi
}

function test_space_expression() {
	res=$(echo -e " \n1\nN\n" | timeout 0.1 ./test_build)
	found=$(echo "$res" | head -n 1 | grep "That isn't a valid arithmetic expression" | wc -l)
	if [[ "$found" == 0 ]]
	then
		echo "-5 points. Expected the program to print 'That isn't a valid arithmetic expression' when provided a single space as an expression, but it doesn't."
	else
		points=5
		echo "+5 points. Space-only-expression test passed."
	fi
}

function test_starts_with_operator() {
	res=$(echo -e "+ 7 - 12\n1\nN\n" | timeout 0.1 ./test_build)
	found=$(echo "$res" | head -n 1 | grep "That isn't a valid arithmetic expression" | wc -l)
	if [[ "$found" == 0 ]]
	then
		echo "-5 points. Expected the program to print 'That isn't a valid arithmetic expression' when provided the expression '+ 7 - 12', but it doesn't."
	else
		points=5
		echo "+5 points. Starts-with-operator test passed."
	fi
}

function test_ends_with_operator() {
	res=$(echo -e "7 - 12 *\n1\nN\n" | timeout 0.1 ./test_build)
	found=$(echo "$res" | head -n 1 | grep "That isn't a valid arithmetic expression" | wc -l)
	if [[ "$found" == 0 ]]
	then
		echo "-5 points. Expected the program to print 'That isn't a valid arithmetic expression' when provided the expression '7 - 12 *', but it doesn't."
	else
		points=5
		echo "+5 points. Ends-with-operator test passed."
	fi
}

function test_missing_space() {
	res=$(echo -e "7/ 12\n1\nN\n" | timeout 0.1 ./test_build)
	found=$(echo "$res" | head -n 1 | grep "That isn't a valid arithmetic expression" | wc -l)
	if [[ "$found" == 0 ]]
	then
		echo "-5 points. Expected the program to print 'That isn't a valid arithmetic expression' when provided the expression '7/ 12', but it doesn't."
	else
		points=5
		echo "+5 points. Missing-space test passed."
	fi
}

function test_double_space() {
	res=$(echo -e "7  /  12\n1\nN\n" | timeout 0.1 ./test_build)
	found=$(echo "$res" | head -n 1 | grep "That isn't a valid arithmetic expression" | wc -l)
	if [[ "$found" == 0 ]]
	then
		points=0
		echo "-5 points. Expected the program to print 'That isn't a valid arithmetic expression' when provided the expression '7  /  12' (due to the double-spaces between the numbers and the division operator), but it doesn't."
	else
		points=5
		echo "+5 points. Double-space test passed."
	fi
}

function test_plus_operator() {
	res=$(echo -e "12 + 92\nN\n" | timeout 0.1 ./test_build)
	answer=$(echo "$res" | head -n 1 | cut -d : -f 2 | trim)
	if [[ "$answer" != "104" ]]
	then
		points=0
		echo "-5 points. Expected '12 + 92' to produce '104', but instead got '$answer'."
	else
		points=5
		echo "+5 points. Plus-operator test passed."
	fi
}

function test_minus_operator() {
	res=$(echo -e "12 - 92\nN\n" | timeout 0.1 ./test_build)
	answer=$(echo "$res" | head -n 1 | cut -d : -f 2 | trim)
	if [[ "$answer" != "-80" ]]
	then
		points=0
		echo "-5 points. Expected '12 - 92' to produce '-80', but instead got '$answer'."
	else
		points=5
		echo "+5 points. Minus-operator test passed."
	fi
}

function test_times_operator() {
	res=$(echo -e "-12 * 92\nN\n" | timeout 0.1 ./test_build)
	answer=$(echo "$res" | head -n 1 | cut -d : -f 2 | trim)
	if [[ "$answer" != "-1104" ]]
	then
		points=0
		echo "-5 points. Expected '-12 * 92' to produce '-1104', but instead got '$answer'."
	else
		points=5
		echo "+5 points. Times-operator test passed."
	fi
}

function test_divide_operator() {
	res=$(echo -e "7 / 5\nN\n" | timeout 0.1 ./test_build)
	answer=$(echo "$res" | head -n 1 | cut -d : -f 2 | trim)
	if [[ "$answer" != "1.4" ]]
	then
		points=0
		echo "-5 points. Expected '7 / 5' to produce '1.4', but instead got '$answer'."
	else
		points=5
		echo "+5 points. Divide-operator test passed."
	fi
}

function test_exponential_operator() {
	res=$(echo -e "7 ^ 5\nN\n" | timeout 0.1 ./test_build)
	answer=$(echo "$res" | head -n 1 | cut -d : -f 2 | trim)
	if [[ "$answer" != "16807" ]]
	then
		points=0
		echo "-5 extra credit points. Expected '7 ^ 5' to produce '16807', but instead got '$answer'."
	else
		points=5
		echo "+5 extra credit points. Exponential-operator test passed."
	fi
}

function test_multiple_operator_expression() {
	res=$(echo -e "7 + 5 * 2 / 4 - 2\nN\n" | timeout 0.1 ./test_build)
	answer=$(echo "$res" | head -n 1 | cut -d : -f 2 | trim)
	if [[ "$answer" == "4" ]]
	then
		points=10
		echo "+10 points. Multiple-operator-expression test passed."
		echo "-10 extra credit points (order of operations). Expected '7 + 5 * 2 / 4 - 2' to produce '7.5', but instead got '$answer' (i.e., the regular, left-to-right evaluation answer)."
	elif [[ "$answer" == "7.5" ]]
	then
		points=20
		echo "+10 points. Multiple-operator-expression test passed."
		echo "+10 extra credit points. Order of operations implemented."
	else
		points=0
		echo "-10 points. Expected '' to produce '4' or '7.5' (depending on whether you did the order-of-operations extra credit), but instead got '$answer'."
		echo "-10 extra credit points (order of operations). Expected '7 + 5 * 2 / 4 - 2' to produce '7.5', but instead got '$answer'."
	fi
}

function test_parentheses() {
	res=$(echo -e "5 - ( ( 2 / 4 ) - 2 )\nN\n" | timeout 0.1 ./test_build)
	answer=$(echo "$res" | head -n 1 | cut -d : -f 2 | trim)
	if [[ "$answer" != "6.5" ]]
	then
		points=0
		echo "-15 extra credit points. Expected '5 - ( ( 2 / 4 ) - 2 )' to produce 6.5, but instead got '$answer'."
	else
		points=5
		echo "+5 extra credit points. Valid-parentheses test passed."

		res=$(echo -e "5 - ((2 / 4) - 2)\nN\n" | timeout 0.1 ./test_build)
		found=$(echo "$res" | head -n 1 | grep "That isn't a valid arithmetic expression" | wc -l)
		if [[ "$found" == 0 ]]
		then
			echo "-3 extra points. Expected the program to print 'That isn't a valid arithmetic expression' when provided the expression '5 - ((2 / 4) - 2)', but it doesn't."
		else
			points=$((points + 3))
			echo "+3 extra credit points. Parentheses-missing-space test passed."
		fi

		res=$(echo -e "5 - ) ) 2 / 4 ( - 2 (\nN\n" | timeout 0.1 ./test_build)
		found=$(echo "$res" | head -n 1 | grep "That isn't a valid arithmetic expression" | wc -l)
		if [[ "$found" == 0 ]]
		then
			echo "-4 extra points. Expected the program to print 'That isn't a valid arithmetic expression' when provided the expression '5 - ) ) 2 / 4 ( - 2 (', but it doesn't."
		else
			points=$((points + 4))
			echo "+4 extra credit points. Parentheses-missing-space test passed."
		fi

		res=$(echo -e "5 - ( ( 2 / 4 ) - 2\nN\n" | timeout 0.1 ./test_build)
		found=$(echo "$res" | head -n 1 | grep "That isn't a valid arithmetic expression" | wc -l)
		if [[ "$found" == 0 ]]
		then
			echo "-3 extra points. Expected the program to print 'That isn't a valid arithmetic expression' when provided the expression '5 - ( ( 2 / 4 ) - 2', but it doesn't."
		else
			points=$((points + 3))
			echo "+3 extra credit points. Parentheses-missing-parenthesis test passed."
		fi
	fi
}

function test_e2e() {
	echo "--------------------------------------------------------------------------"
	echo "Running large end-to-end test with many expressions..."
	echo ""
	echo "If there are errors (points lost) in these end-to-end"
	echo "tests, you can reproduce them by following the below"
	echo "example run and finding where your program's outputs"
	echo "don't match the example:"
	echo ""
	echo "Enter a valid arithmetic expression: 3 + 7.5 - -2 / 4.0"
	echo "3.125"
	echo "Would you like to enter another expression? Enter Y for yes: Y"
	echo "Enter a valid arithmetic expression:  "
	echo "That isn't a valid arithmetic expression."
	echo "Enter a valid arithmetic expression: "
	echo "That isn't a valid arithmetic expression."
	echo "Enter a valid arithmetic expression: 12"
	echo "12"
	echo "Would you like to enter another expression? Enter Y for yes: Y"
	echo "Enter a valid arithmetic expression: 8 / 2 / 2"
	echo "2"
	echo "Would you like to enter another expression? Enter Y for yes: fjdsajfads"
	echo ""
	echo "History of computed values:"
	echo "3.125"
	echo "12"
	echo "2"
	echo "--------------------------------------------------------------------------"

	points=0
	err=0
	res=$(echo -e "3 + 7.5 - -2 / 4.0\nY\n \n\n12\nY\n8 / 2 / 2\nfjdsajfads\n" | timeout 0.2 ./test_build)
	answer_1=$(echo "$res" | head -n 1 | tail -n 1 | cut -d : -f 2 | trim)
	if [[ "$answer_1" != "3.125" && "$answer_1" != "11" ]]
	then
		echo -e "-4 points. Expected '3 + 7.5 - -2 / 4.0' to produce '3.125' or '11' (depending on extra credit), but instead got '$answer_1'."
		echo
	else
		points=$((points + 4))
		echo -e "+4 points. First expression result correct."
	fi

	answer_2=$(echo "$res" | head -n 4 | tail -n 1 | cut -d : -f 2 | trim)
	if [[ "$answer_2" != "12" ]]
	then
		echo -e "-3 points. Expected '12' to produce '12', but instead got '$answer_2'."
		echo
	else
		points=$((points + 3))
		echo -e "+3 points. Second expression result correct."
	fi

	answer_3=$(echo "$res" | head -n 5 | tail -n 1 | cut -d : -f 3 | trim)
	if [[ "$answer_3" != "2" ]]
	then
		echo -e "-4 points. Expected '8 / 2 / 2' to produce '2', but instead got '$answer_2'."
		echo
	else
		points=$((points + 4))
		echo -e "+4 points. Third expression result correct."
	fi

	history_1=$(echo "$res" | head -n 8 | tail -n 1)
	if [[ "$history_1" != "$answer_1" ]]
	then
		echo -e "-3 points. Expected first history entry, '$history_1', to match first answer, '$answer_1'."
	else
		points=$((points + 3))
		echo -e "+3 points. First history result correct."
	fi

	history_2=$(echo "$res" | head -n 9 | tail -n 1)
	if [[ "$history_2" != "$answer_2" ]]
	then
		echo -e "-3 points. Expected second history entry, '$history_2', to match second answer, '$answer_2'."
	else
		points=$((points + 3))
		echo -e "+3 points. Second history result correct."
	fi

	history_3=$(echo "$res" | head -n 10 | tail -n 1)
	if [[ "$history_3" != "$answer_3" ]]
	then
		echo -e "-3 points. Expected third history entry, '$history_3', to match third answer, '$answer_3'."
	else
		points=$((points + 3))
		echo -e "+3 points. Third history result correct."
	fi
	echo
	echo "Total points on end-to-end test: $points / 20"

	echo "--------------------------------------------------------------------------"
	echo
}

g++ -o test_build main.cpp

total_points=0

test_empty_expression
total_points=$((total_points + points))

test_space_expression
total_points=$((total_points + points))

test_starts_with_operator
total_points=$((total_points + points))

test_ends_with_operator
total_points=$((total_points + points))

test_missing_space
total_points=$((total_points + points))

test_double_space
total_points=$((total_points + points))

test_plus_operator
total_points=$((total_points + points))

test_minus_operator
total_points=$((total_points + points))

test_times_operator
total_points=$((total_points + points))

test_divide_operator
total_points=$((total_points + points))

test_multiple_operator_expression
total_points=$((total_points + points))

test_exponential_operator
total_points=$((total_points + points))

test_parentheses
total_points=$((total_points + points))

echo

test_e2e
total_points=$((total_points + points))

echo "Total points: $total_points / 80"
echo ""
echo "Disclaimer: This is similar but not identical to the actual grading"
echo "script that will be used to demo your assignment, so this is only an"
echo "approximation of what your real grade will be."
echo ""
echo "A max of 20 more points can be earned when your randomly assigned TA"
echo "grades your code style during finals week (refer to the course's style"
echo "guidelines)"

rm -f test_build
