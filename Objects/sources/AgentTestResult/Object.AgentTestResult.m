(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: tharr *)
(* :Date: 2023-07-31 *)

DefineObjectType[Object[AgentTestResult], {
  Description -> "An instance of the test results given by the Emerald function assistant.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    DeveloperObject -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
      Category -> "Organizational Information",
      Developer -> True
    },
    Prompts -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "A list of the queries that are input into the function assistant LLM.",
      Category -> "General"
    },
    AgentAnswers -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of Prompts, an answer provided by the LLM agent.",
      Category -> "General",
      IndexMatching -> Prompts
    },
    CorrectAnswers -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of Prompts, the correct answer to the input prompt that are used to grade the function assistant LLM.",
      Category -> "General",
      IndexMatching -> Prompts
    },
    Scores -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> RangeP[0, 1],
      Description -> StringJoin[{
        "For each member of Prompts, the score associated with the quality of the agent's answer to the given prompt. ",
        "The score is a number between 0 and 1, in which higher is better. ",
        "It is derived from the cosine similarity metric applied to the embeddings of the correct and agent answers."
      }],
      Category -> "General",
      IndexMatching -> Prompts
    },
    AverageScore -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0, 1],
      Description -> "The average score over the set of all of the agent's answers.",
      Category -> "General",
      Abstract -> True
    },
    StandardDeviationScore -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0, 1],
      Description -> "The standard deviation of the the set of all of the agent's scores.",
      Category -> "General",
      Abstract -> True
    },
    MaxScore -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0, 1],
      Description -> "The maximum score of all of the agent's scores.",
      Category -> "General",
      Abstract -> True
    },
    MinScore -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0, 1],
      Description -> "The minimum score of all of the agent's scores.",
      Category -> "General",
      Abstract -> True
    },
    MedianScore -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0, 1],
      Description -> "The median score of all of the agent's scores.",
      Category -> "General",
      Abstract -> True
    },
    UpperQuartileScore -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0, 1],
      Description -> "The upper quartile score of all of the agent's scores, meaning the score under which 75% of the other scores are found.",
      Category -> "General",
      Abstract -> True
    },
    LowerQuartileScore -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0, 1],
      Description -> "The lower quartile score of all of the agent's scores, meaning the score under which 25% of the other scores are found.",
      Category -> "General",
      Abstract -> True
    },
    AnswerKey -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[AgentAnswerKey],
      Description -> "The link to the answer key version that was used for this test.",
      Category -> "General"
    }
  }
}];