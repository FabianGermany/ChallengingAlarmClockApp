import 'dart:math';
import 'package:flutter/material.dart';


// types of arithmetic operations
enum operationTypeEnum {plus, minus, mul, div}

/// Function to map operation type name to operation type symbol
String operationTypeNameToOperationTypeSymbol(operationTypeName)
{
  String operationTypeSymbol = '';
  switch(operationTypeName)
  {
    case 'operationTypeEnum.plus': operationTypeSymbol = '+'; break;
    case 'operationTypeEnum.minus': operationTypeSymbol = '-'; break;
    case 'operationTypeEnum.mul': operationTypeSymbol = '*'; break;
    case 'operationTypeEnum.div': operationTypeSymbol = '/'; break;
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
        case operationTypeEnum.plus: result = term1 + term2 ; break;
        case operationTypeEnum.minus: result = term1 - term2 ; break;
        case operationTypeEnum.mul: result = term1 * term2 ; break;
        case operationTypeEnum.div: result = term1 ~/ term2 ; break;
        default: result = 0; debugPrint('Error in termGenerator'); break;
      }
    }

  else if(amountOfTerms == 3)
  {
    if (operationType1 == operationTypeEnum.plus && operationType2 == operationTypeEnum.plus)
    {
      result = term1 + term2 + term3;
    }
    else if (operationType1 == operationTypeEnum.plus && operationType2 == operationTypeEnum.minus) {
      result = term1 + term2 - term3;
    }
    else if (operationType1 == operationTypeEnum.plus && operationType2 == operationTypeEnum.mul) {
      result = term1 + term2 * term3;
    }
    else if (operationType1 == operationTypeEnum.minus && operationType2 == operationTypeEnum.plus) {
      result = term1 - term2 + term3;
    }
    else if (operationType1 == operationTypeEnum.minus && operationType2 == operationTypeEnum.minus) {
      result = term1 - term2 - term3;
    }
    else if (operationType1 == operationTypeEnum.minus && operationType2 == operationTypeEnum.mul) {
      result = term1 - term2 * term3;
    }
    else if (operationType1 == operationTypeEnum.mul && operationType2 == operationTypeEnum.plus) {
      result = term1 * term2 + term3;
    }
    else if (operationType1 == operationTypeEnum.mul && operationType2 == operationTypeEnum.minus) {
      result = term1 * term2 - term3;
    }
    else if (operationType1 == operationTypeEnum.mul && operationType2 == operationTypeEnum.mul) {
      result = term1 * term2 * term3;
    }
    else if (operationType1 == operationTypeEnum.div && operationType2 == operationTypeEnum.plus) {
      result = term1 ~/ term2 + term3;
    }
    else if (operationType1 == operationTypeEnum.div && operationType2 == operationTypeEnum.minus) {
      result = term1 ~/ term2 - term3;
    }
    else if (operationType1 == operationTypeEnum.div && operationType2 == operationTypeEnum.mul) {
      result = term1 ~/ term2 * term3;
    }
    else
    {
      result = 0; debugPrint('Error in termGenerator');
    }

  }

  else //(amountOfTerms == 4)
  {
    if (operationType1 == operationTypeEnum.plus && operationType2 == operationTypeEnum.plus && operationType3 == operationTypeEnum.plus)
    {
      result = term1 + term2 + term3 + term4;
    }
    else if (operationType1 == operationTypeEnum.plus && operationType2 == operationTypeEnum.plus && operationType3 == operationTypeEnum.minus)
    {
      result = term1 + term2 + term3 - term4;
    }
    else if (operationType1 == operationTypeEnum.plus && operationType2 == operationTypeEnum.plus && operationType3 == operationTypeEnum.mul)
    {
      result = term1 + term2 + term3 * term4;
    }
    else if (operationType1 == operationTypeEnum.plus && operationType2 == operationTypeEnum.minus && operationType3 == operationTypeEnum.plus)
    {
      result = term1 + term2 - term3 + term4;
    }
    else if (operationType1 == operationTypeEnum.plus && operationType2 == operationTypeEnum.minus && operationType3 == operationTypeEnum.minus)
    {
      result = term1 + term2 - term3 - term4;
    }
    else if (operationType1 == operationTypeEnum.plus && operationType2 == operationTypeEnum.minus && operationType3 == operationTypeEnum.mul)
    {
      result = term1 + term2 - term3 * term4;
    }
    else if (operationType1 == operationTypeEnum.plus && operationType2 == operationTypeEnum.mul && operationType3 == operationTypeEnum.plus)
    {
      result = term1 + term2 * term3 + term4;
    }
    else if (operationType1 == operationTypeEnum.plus && operationType2 == operationTypeEnum.mul && operationType3 == operationTypeEnum.minus)
    {
      result = term1 + term2 * term3 - term4;
    }
    else if (operationType1 == operationTypeEnum.plus && operationType2 == operationTypeEnum.mul && operationType3 == operationTypeEnum.mul)
    {
      result = term1 + term2 * term3 * term4;
    }


    else if (operationType1 == operationTypeEnum.minus && operationType2 == operationTypeEnum.plus && operationType3 == operationTypeEnum.plus)
    {
      result = term1 - term2 + term3 + term4;
    }
    else if (operationType1 == operationTypeEnum.minus && operationType2 == operationTypeEnum.plus && operationType3 == operationTypeEnum.minus)
    {
      result = term1 - term2 + term3 - term4;
    }
    else if (operationType1 == operationTypeEnum.minus && operationType2 == operationTypeEnum.plus && operationType3 == operationTypeEnum.mul)
    {
      result = term1 - term2 + term3 * term4;
    }
    else if (operationType1 == operationTypeEnum.minus && operationType2 == operationTypeEnum.minus && operationType3 == operationTypeEnum.plus)
    {
      result = term1 - term2 - term3 + term4;
    }
    else if (operationType1 == operationTypeEnum.minus && operationType2 == operationTypeEnum.minus && operationType3 == operationTypeEnum.minus)
    {
      result = term1 - term2 - term3 - term4;
    }
    else if (operationType1 == operationTypeEnum.minus && operationType2 == operationTypeEnum.minus && operationType3 == operationTypeEnum.mul)
    {
      result = term1 - term2 - term3 * term4;
    }
    else if (operationType1 == operationTypeEnum.minus && operationType2 == operationTypeEnum.mul && operationType3 == operationTypeEnum.plus)
    {
      result = term1 - term2 * term3 + term4;
    }
    else if (operationType1 == operationTypeEnum.minus && operationType2 == operationTypeEnum.mul && operationType3 == operationTypeEnum.minus)
    {
      result = term1 - term2 * term3 - term4;
    }
    else if (operationType1 == operationTypeEnum.minus && operationType2 == operationTypeEnum.mul && operationType3 == operationTypeEnum.mul)
    {
      result = term1 - term2 * term3 * term4;
    }


    else if (operationType1 == operationTypeEnum.mul && operationType2 == operationTypeEnum.plus && operationType3 == operationTypeEnum.plus)
    {
      result = term1 * term2 + term3 + term4;
    }
    else if (operationType1 == operationTypeEnum.mul && operationType2 == operationTypeEnum.plus && operationType3 == operationTypeEnum.minus)
    {
      result = term1 * term2 + term3 - term4;
    }
    else if (operationType1 == operationTypeEnum.mul && operationType2 == operationTypeEnum.plus && operationType3 == operationTypeEnum.mul)
    {
      result = term1 * term2 + term3 * term4;
    }
    else if (operationType1 == operationTypeEnum.mul && operationType2 == operationTypeEnum.minus && operationType3 == operationTypeEnum.plus)
    {
      result = term1 * term2 - term3 + term4;
    }
    else if (operationType1 == operationTypeEnum.mul && operationType2 == operationTypeEnum.minus && operationType3 == operationTypeEnum.minus)
    {
      result = term1 * term2 - term3 - term4;
    }
    else if (operationType1 == operationTypeEnum.mul && operationType2 == operationTypeEnum.minus && operationType3 == operationTypeEnum.mul)
    {
      result = term1 * term2 - term3 * term4;
    }
    else if (operationType1 == operationTypeEnum.mul && operationType2 == operationTypeEnum.mul && operationType3 == operationTypeEnum.plus)
    {
      result = term1 * term2 * term3 + term4;
    }
    else if (operationType1 == operationTypeEnum.mul && operationType2 == operationTypeEnum.mul && operationType3 == operationTypeEnum.minus)
    {
      result = term1 * term2 * term3 - term4;
    }
    else if (operationType1 == operationTypeEnum.mul && operationType2 == operationTypeEnum.mul && operationType3 == operationTypeEnum.mul)
    {
      result = term1 * term2 * term3 * term4;
    }



    else if (operationType1 == operationTypeEnum.div && operationType2 == operationTypeEnum.plus && operationType3 == operationTypeEnum.plus)
    {
      result = term1 ~/ term2 + term3 + term4;
    }
    else if (operationType1 == operationTypeEnum.div && operationType2 == operationTypeEnum.plus && operationType3 == operationTypeEnum.minus)
    {
      result = term1 ~/ term2 + term3 - term4;
    }
    else if (operationType1 == operationTypeEnum.div && operationType2 == operationTypeEnum.plus && operationType3 == operationTypeEnum.mul)
    {
      result = term1 ~/ term2 + term3 * term4;
    }
    else if (operationType1 == operationTypeEnum.div && operationType2 == operationTypeEnum.minus && operationType3 == operationTypeEnum.plus)
    {
      result = term1 ~/ term2 - term3 + term4;
    }
    else if (operationType1 == operationTypeEnum.div && operationType2 == operationTypeEnum.minus && operationType3 == operationTypeEnum.minus)
    {
      result = term1 ~/ term2 - term3 - term4;
    }
    else if (operationType1 == operationTypeEnum.div && operationType2 == operationTypeEnum.minus && operationType3 == operationTypeEnum.mul)
    {
      result = term1 ~/ term2 - term3 * term4;
    }
    else if (operationType1 == operationTypeEnum.div && operationType2 == operationTypeEnum.mul && operationType3 == operationTypeEnum.plus)
    {
      result = term1 ~/ term2 * term3 + term4;
    }
    else if (operationType1 == operationTypeEnum.div && operationType2 == operationTypeEnum.mul && operationType3 == operationTypeEnum.minus)
    {
      result = term1 ~/ term2 * term3 - term4;
    }
    else if (operationType1 == operationTypeEnum.div && operationType2 == operationTypeEnum.mul && operationType3 == operationTypeEnum.mul)
    {
      result = term1 ~/ term2 * term3 * term4;
    }

    else
    {
      result = 0; debugPrint('Error in termGenerator');
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
dynamic operationTypeGenerator()
{
  final generatorOperationType = Random();
  int operationTypeNumber;
  var operationType; // chosen element from enum
  operationTypeNumber = generatorOperationType.nextInt(3); // generates a value from 0-3
  switch(operationTypeNumber)
  {
    case 0: operationType = operationTypeEnum.plus; break;
    case 1: operationType = operationTypeEnum.minus; break;
    case 2: operationType = operationTypeEnum.mul; break;
    case 3: operationType = operationTypeEnum.div; break;
    default: debugPrint('Error in operationTypeGenerator'); break;
  }
  return operationType;
}


/// Function to generate an extra arithmetic operation type (no division)
dynamic operationTypeGeneratorExtra()
{
  final generatorOperationType = Random();
  int operationTypeNumber;
  var operationType; // chosen element from enum
  operationTypeNumber = generatorOperationType.nextInt(2); // generates a value from 0-2 (no division)
  switch(operationTypeNumber)
  {
    case 0: operationType = operationTypeEnum.plus; break;
    case 1: operationType = operationTypeEnum.minus; break;
    case 2: operationType = operationTypeEnum.mul; break;
    default: debugPrint('Error in operationTypeGeneratorExtra'); break;
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
  if (operationType == operationTypeEnum.plus || operationType == operationTypeEnum.minus)
  {
    min = 0;
    max = 99;
  }
  else if (operationType == operationTypeEnum.mul)
  {
    min = 0;
    max = 30;
  }
  else // if (operationType == operationTypeEnum.div)
  {
    min = 1;
    max = 20;
  }

  // second; generate terms
  if (operationType == operationTypeEnum.plus || operationType == operationTypeEnum.minus || operationType == operationTypeEnum.mul)
  {
    term1 = min + generatorTerm.nextInt(max - min);
    term2 = min + generatorTerm.nextInt(max - min);
  }

  else // if (operationType == operationTypeEnum.div)
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
  if (operationType == operationTypeEnum.plus || operationType == operationTypeEnum.minus)
  {
    min = 0;
    max = 99;
  }
  else // if (operationType == operationTypeEnum.mul)
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
  dynamic operationType1, operationType2, operationType3;
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
    completeTerm = "$term1 ${operationTypeNameToOperationTypeSymbol(operationType1.toString())} $term2";
  }

  else if (amountOfTerms == 3)
  {
    completeTerm = "$term1 ${operationTypeNameToOperationTypeSymbol(operationType1.toString())} $term2 ${operationTypeNameToOperationTypeSymbol(operationType2.toString())} $term3";
  }

  else // (amountOfTerms == 4)
  {
    completeTerm = "$term1 ${operationTypeNameToOperationTypeSymbol(operationType1.toString())} $term2 ${operationTypeNameToOperationTypeSymbol(operationType2.toString())} $term3 ${operationTypeNameToOperationTypeSymbol(operationType3.toString())} $term4";
  }

  // 5 Calculate the result
  result = resultBasedOneOperationName(amountOfTerms, term1, term2, term3, term4, operationType1, operationType2, operationType3);
  //debugPrint('${[term1, term2, term3, term4, operationType1, operationType2, operationType3]}');
  return [completeTerm, result];
}

/// Score function
/// returns the output score and the bool for passed/not passed
List scoreHandler (int currentScore, bool correctAnswer, [int targetScore = 5])
{
  //declare return vars
  int outputScore;
  bool passed;

  if(correctAnswer) // correct answer
  {
    outputScore = currentScore + 1;
  }
  else // wrong answer
  {
    outputScore = currentScore - 3;
  }

  // cut score if it's too low (no negative score)
  if(outputScore < 0)
  {
    outputScore = 0;
  }

  if(outputScore >= targetScore) // check for success
  {
    passed = true;
  }
  else
  {
    passed = false;
  }
  return [outputScore, passed];
}
