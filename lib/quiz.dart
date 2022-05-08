import 'package:flutter/material.dart'; //Google Material Design assets

/// Score function
/// returns the output score and the bool for passed/not passed
List scoreHandler (int current_score, bool correct_answer, [int target_score = 5])
{
  //declare return vars
  int output_score;
  bool passed;

  if(correct_answer) // correct answer
    {
      output_score = current_score + 1;
    }
  else // wrong answer
    {
      output_score = current_score - 3;
    }

  // cut score if it's too low (no negative score)
  if(output_score<0)
  {
    output_score = 0;
  }

  if(output_score >= target_score) // check for success
    {
      passed = true;
    }
  else
    {
      passed = false;
    }
  return [output_score, passed];
}

//todo call function like this
// quiz.scoreHandler(5, false, 5);

/// Mathematical quiz generator function