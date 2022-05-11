import 'dart:math';
//import 'package:flutter/material.dart';
import 'dart:developer' as dev;

// types of arithmetic operations
enum OperationType {plus, minus, mul, div}

// this can be used instead of a function like operationTypeNameToOperationTypeSymbol
extension OperationTypeExtension on OperationType {
  String get symbol {
    switch (this) {
      case OperationType.plus:
        return '+';
      case OperationType.minus:
        return '-';
      case OperationType.mul:
        return '*';
      case OperationType.div:
        return '/';
    }
  }
}


/// Function to map operation type name to operation type symbol
String operationTypeNameToOperationTypeSymbol(operationTypeName)
{
  String operationTypeSymbol = '';
  switch(operationTypeName)
  {
    case 'operationType.plus': operationTypeSymbol = '+'; break;
    case 'operationType.minus': operationTypeSymbol = '-'; break;
    case 'operationType.mul': operationTypeSymbol = '*'; break;
    case 'operationType.div': operationTypeSymbol = '/'; break;
  }
  return operationTypeSymbol;
}

/// Function to calculate the result based on the operation type name
/// Attention: I cannot use this function two or three times in a row cause multiplication/division has higher priority than addition/subtraction!
String resultBasedOneOperationName(amountOfTerms, term1, term2, term3, term4, operationType1, operationType2, operationType3)
{
  int result;
  if(amountOfTerms == 2)
    {
      switch (operationType1)
      {
        case OperationType.plus: result = term1 + term2 ; break;
        case OperationType.minus: result = term1 - term2 ; break;
        case OperationType.mul: result = term1 * term2 ; break;
        case OperationType.div: result = term1 ~/ term2 ; break;
        default: result = 0; dev.log('Error in termGenerator', name: 'Error in Quiz'); break;
      }
    }

  else if(amountOfTerms == 3)
  {
    if (operationType1 == OperationType.plus && operationType2 == OperationType.plus)
    {
      result = term1 + term2 + term3;
    }
    else if (operationType1 == OperationType.plus && operationType2 == OperationType.minus) {
      result = term1 + term2 - term3;
    }
    else if (operationType1 == OperationType.plus && operationType2 == OperationType.mul) {
      result = term1 + term2 * term3;
    }
    else if (operationType1 == OperationType.minus && operationType2 == OperationType.plus) {
      result = term1 - term2 + term3;
    }
    else if (operationType1 == OperationType.minus && operationType2 == OperationType.minus) {
      result = term1 - term2 - term3;
    }
    else if (operationType1 == OperationType.minus && operationType2 == OperationType.mul) {
      result = term1 - term2 * term3;
    }
    else if (operationType1 == OperationType.mul && operationType2 == OperationType.plus) {
      result = term1 * term2 + term3;
    }
    else if (operationType1 == OperationType.mul && operationType2 == OperationType.minus) {
      result = term1 * term2 - term3;
    }
    else if (operationType1 == OperationType.mul && operationType2 == OperationType.mul) {
      result = term1 * term2 * term3;
    }
    else if (operationType1 == OperationType.div && operationType2 == OperationType.plus) {
      result = term1 ~/ term2 + term3;
    }
    else if (operationType1 == OperationType.div && operationType2 == OperationType.minus) {
      result = term1 ~/ term2 - term3;
    }
    else if (operationType1 == OperationType.div && operationType2 == OperationType.mul) {
      result = term1 ~/ term2 * term3;
    }
    else
    {
      result = 0; dev.log('Error in termGenerator', name: 'Error in Quiz');
    }

  }

  else //(amountOfTerms == 4)
  {
    if (operationType1 == OperationType.plus && operationType2 == OperationType.plus && operationType3 == OperationType.plus)
    {
      result = term1 + term2 + term3 + term4;
    }
    else if (operationType1 == OperationType.plus && operationType2 == OperationType.plus && operationType3 == OperationType.minus)
    {
      result = term1 + term2 + term3 - term4;
    }
    else if (operationType1 == OperationType.plus && operationType2 == OperationType.plus && operationType3 == OperationType.mul)
    {
      result = term1 + term2 + term3 * term4;
    }
    else if (operationType1 == OperationType.plus && operationType2 == OperationType.minus && operationType3 == OperationType.plus)
    {
      result = term1 + term2 - term3 + term4;
    }
    else if (operationType1 == OperationType.plus && operationType2 == OperationType.minus && operationType3 == OperationType.minus)
    {
      result = term1 + term2 - term3 - term4;
    }
    else if (operationType1 == OperationType.plus && operationType2 == OperationType.minus && operationType3 == OperationType.mul)
    {
      result = term1 + term2 - term3 * term4;
    }
    else if (operationType1 == OperationType.plus && operationType2 == OperationType.mul && operationType3 == OperationType.plus)
    {
      result = term1 + term2 * term3 + term4;
    }
    else if (operationType1 == OperationType.plus && operationType2 == OperationType.mul && operationType3 == OperationType.minus)
    {
      result = term1 + term2 * term3 - term4;
    }
    else if (operationType1 == OperationType.plus && operationType2 == OperationType.mul && operationType3 == OperationType.mul)
    {
      result = term1 + term2 * term3 * term4;
    }


    else if (operationType1 == OperationType.minus && operationType2 == OperationType.plus && operationType3 == OperationType.plus)
    {
      result = term1 - term2 + term3 + term4;
    }
    else if (operationType1 == OperationType.minus && operationType2 == OperationType.plus && operationType3 == OperationType.minus)
    {
      result = term1 - term2 + term3 - term4;
    }
    else if (operationType1 == OperationType.minus && operationType2 == OperationType.plus && operationType3 == OperationType.mul)
    {
      result = term1 - term2 + term3 * term4;
    }
    else if (operationType1 == OperationType.minus && operationType2 == OperationType.minus && operationType3 == OperationType.plus)
    {
      result = term1 - term2 - term3 + term4;
    }
    else if (operationType1 == OperationType.minus && operationType2 == OperationType.minus && operationType3 == OperationType.minus)
    {
      result = term1 - term2 - term3 - term4;
    }
    else if (operationType1 == OperationType.minus && operationType2 == OperationType.minus && operationType3 == OperationType.mul)
    {
      result = term1 - term2 - term3 * term4;
    }
    else if (operationType1 == OperationType.minus && operationType2 == OperationType.mul && operationType3 == OperationType.plus)
    {
      result = term1 - term2 * term3 + term4;
    }
    else if (operationType1 == OperationType.minus && operationType2 == OperationType.mul && operationType3 == OperationType.minus)
    {
      result = term1 - term2 * term3 - term4;
    }
    else if (operationType1 == OperationType.minus && operationType2 == OperationType.mul && operationType3 == OperationType.mul)
    {
      result = term1 - term2 * term3 * term4;
    }


    else if (operationType1 == OperationType.mul && operationType2 == OperationType.plus && operationType3 == OperationType.plus)
    {
      result = term1 * term2 + term3 + term4;
    }
    else if (operationType1 == OperationType.mul && operationType2 == OperationType.plus && operationType3 == OperationType.minus)
    {
      result = term1 * term2 + term3 - term4;
    }
    else if (operationType1 == OperationType.mul && operationType2 == OperationType.plus && operationType3 == OperationType.mul)
    {
      result = term1 * term2 + term3 * term4;
    }
    else if (operationType1 == OperationType.mul && operationType2 == OperationType.minus && operationType3 == OperationType.plus)
    {
      result = term1 * term2 - term3 + term4;
    }
    else if (operationType1 == OperationType.mul && operationType2 == OperationType.minus && operationType3 == OperationType.minus)
    {
      result = term1 * term2 - term3 - term4;
    }
    else if (operationType1 == OperationType.mul && operationType2 == OperationType.minus && operationType3 == OperationType.mul)
    {
      result = term1 * term2 - term3 * term4;
    }
    else if (operationType1 == OperationType.mul && operationType2 == OperationType.mul && operationType3 == OperationType.plus)
    {
      result = term1 * term2 * term3 + term4;
    }
    else if (operationType1 == OperationType.mul && operationType2 == OperationType.mul && operationType3 == OperationType.minus)
    {
      result = term1 * term2 * term3 - term4;
    }
    else if (operationType1 == OperationType.mul && operationType2 == OperationType.mul && operationType3 == OperationType.mul)
    {
      result = term1 * term2 * term3 * term4;
    }



    else if (operationType1 == OperationType.div && operationType2 == OperationType.plus && operationType3 == OperationType.plus)
    {
      result = term1 ~/ term2 + term3 + term4;
    }
    else if (operationType1 == OperationType.div && operationType2 == OperationType.plus && operationType3 == OperationType.minus)
    {
      result = term1 ~/ term2 + term3 - term4;
    }
    else if (operationType1 == OperationType.div && operationType2 == OperationType.plus && operationType3 == OperationType.mul)
    {
      result = term1 ~/ term2 + term3 * term4;
    }
    else if (operationType1 == OperationType.div && operationType2 == OperationType.minus && operationType3 == OperationType.plus)
    {
      result = term1 ~/ term2 - term3 + term4;
    }
    else if (operationType1 == OperationType.div && operationType2 == OperationType.minus && operationType3 == OperationType.minus)
    {
      result = term1 ~/ term2 - term3 - term4;
    }
    else if (operationType1 == OperationType.div && operationType2 == OperationType.minus && operationType3 == OperationType.mul)
    {
      result = term1 ~/ term2 - term3 * term4;
    }
    else if (operationType1 == OperationType.div && operationType2 == OperationType.mul && operationType3 == OperationType.plus)
    {
      result = term1 ~/ term2 * term3 + term4;
    }
    else if (operationType1 == OperationType.div && operationType2 == OperationType.mul && operationType3 == OperationType.minus)
    {
      result = term1 ~/ term2 * term3 - term4;
    }
    else if (operationType1 == OperationType.div && operationType2 == OperationType.mul && operationType3 == OperationType.mul)
    {
      result = term1 ~/ term2 * term3 * term4;
    }

    else
    {
      result = 0; dev.log('Error in termGenerator', name: 'Error in Quiz');
    }
  }
  return result.toString();
}



/// Function to generate the amount of terms
int amountOfTermsGenerator()
{
  //use this to to make long terms less probably
  int amountOfTerms;
  final generatorAmountOfTerms = Random();
  double resultGeneratorAmountOfTerms = generatorAmountOfTerms.nextDouble(); // generate random number between 0 and 1
  if(resultGeneratorAmountOfTerms < 0.08)
  {
    amountOfTerms = 4;
  }
  else if(resultGeneratorAmountOfTerms < 0.3)
  {
    amountOfTerms = 3;
  }
  else
  {
    amountOfTerms = 2;
  }
  return amountOfTerms;
}


/// Function to generate an arithmetic operation type
OperationType operationTypeGenerator()
{
  final generatorOperationType = Random();
  int operationTypeNumber;
  var operationType; // chosen element from enum
  operationTypeNumber = generatorOperationType.nextInt(3); // generates a value from 0-3
  switch(operationTypeNumber)
  {
    case 0: operationType = OperationType.plus; break;
    case 1: operationType = OperationType.minus; break;
    case 2: operationType = OperationType.mul; break;
    case 3: operationType = OperationType.div; break;
    default: dev.log('Error in operationTypeGenerator', name: 'Error in Quiz'); break;
  }
  return operationType;
  //shorter version:   return OperationType.values[Random().nextInt(OperationType.values.length)];
  }


/// Function to generate an extra arithmetic operation type (no division)
OperationType operationTypeGeneratorExtra()
{
  final generatorOperationType = Random();
  int operationTypeNumber;
  var operationType; // chosen element from enum
  operationTypeNumber = generatorOperationType.nextInt(2); // generates a value from 0-2 (no division)
  switch(operationTypeNumber)
  {
    case 0: operationType = OperationType.plus; break;
    case 1: operationType = OperationType.minus; break;
    case 2: operationType = OperationType.mul; break;
    default: dev.log('Error in operationTypeGeneratorExtra', name: 'Error in Quiz'); break;
  }
  return operationType;
}


/// This functions generated the two terms based on their operation type
List<int> termGenerator(operationType)
{
  int min, max; // min and max are used as an offset/range to disable too easy/diffucult equations
  int term1, term2;
  final generatorTerm = Random();

  // first: generate min and max bounds
  if (operationType == OperationType.plus || operationType == OperationType.minus)
  {
    min = 0;
    max = 99;
  }
  else if (operationType == OperationType.mul)
  {
    min = 0;
    max = 30;
  }
  else // if (operationType == OperationType.div)
  {
    min = 1;
    max = 20;
  }

  // second; generate terms
  if (operationType == OperationType.plus || operationType == OperationType.minus || operationType == OperationType.mul)
  {
    term1 = min + generatorTerm.nextInt(max - min);
    term2 = min + generatorTerm.nextInt(max - min);
  }

  else // if (operationType == OperationType.div)
  {
    term2 = min + generatorTerm.nextInt(max - min); // divisor
    term1 = term2 * generatorTerm.nextInt(15);  // dividend
  }
  return [term1, term2];
}



/// This functions generated an additional term
int termGeneratorExtra(operationType)
{
  int min, max; // min and max are used as an offset/range to disable too easy/diffucult equations
  int term;
  final generatorTerm = Random();

  // first: generate min and max bounds
  if (operationType == OperationType.plus || operationType == OperationType.minus)
  {
    min = 0;
    max = 99;
  }
  else // if (operationType == OperationType.mul)
  {
    min = 0;
    max = 30;
  }

  // second: generate term
  term = min + generatorTerm.nextInt(max - min);

  return term;
}


/// Mathematical quiz generator function
List quizGenerator()
{
  int term1, term2, term3, term4;
  String completeTerm;
  String result;
  // 1 Generate the amount of terms
  int amountOfTerms = amountOfTermsGenerator(); // generate the amount of terms

  // 2 Generate the operation types
  OperationType operationType1, operationType2, operationType3;
  operationType1 = operationTypeGenerator(); // generate the operation type
  operationType2 = operationTypeGeneratorExtra(); // generate the operation type
  operationType3 = operationTypeGeneratorExtra(); // generate the operation type

  // 3 Generate the terms
  List<int> terms = termGenerator(operationType1);
  term1 = terms[0];
  term2 = terms[1];
  term3 = termGeneratorExtra(operationType2);
  term4 = termGeneratorExtra(operationType3);

  // 4 Print the quiz question
  if (amountOfTerms == 2)
  {
    completeTerm = "$term1 ${operationType1.symbol} $term2";
  }

  else if (amountOfTerms == 3)
  {
    completeTerm = "$term1 ${operationType1.symbol} $term2 ${operationType2.symbol} $term3";
  }

  else // (amountOfTerms == 4)
  {
    completeTerm = "$term1 ${operationType1.symbol} $term2 ${operationType2.symbol} $term3 ${operationType3.symbol} $term4";
  }

  // 5 Calculate the result
  result = resultBasedOneOperationName(amountOfTerms, term1, term2, term3, term4, operationType1, operationType2, operationType3);
  dev.log('${[term1, term2, term3, term4, operationType1, operationType2, operationType3]}', name: 'Quiz');
  return [completeTerm, result];
}

/// Score function
/// returns the output score and the bool for passed/not passed
List scoreHandler (int _currentScore, bool correctAnswer, [int _targetScore = 5])
{
  //declare return vars
  int outputScore;
  bool passed;

  if(correctAnswer) // correct answer
  {
    outputScore = _currentScore + 1;
  }
  else // wrong answer
  {
    outputScore = _currentScore - 3;
  }

  // cut score if it's too low (no negative score)
  if(outputScore < 0)
  {
    outputScore = 0;
  }

  if(outputScore >= _targetScore) // check for success
  {
    passed = true;
  }
  else
  {
    passed = false;
  }
  return [outputScore, passed];
}
