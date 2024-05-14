(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: tharr *)
(* :Date: 2023-07-31 *)

DefineObjectType[Object[AgentAnswerKey], {
  Description -> "An instance of an answer key that is used to assess the quality of the Emerald function assistant.",
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
    Answers -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of Prompts, an answer to the input prompt that is used to grade the function assistant LLM.",
      IndexMatching -> Prompts,
      Category -> "General"
    },
    AnswerEmbeddings -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {_?NumericQ..},
      Description -> "For each member of Answers, the embeddings created from a specific natural language model. An embedding is a vector of numbers that encode the semantic meaning of the original text. These are useful for determining whether two blocks of text are similar.",
      IndexMatching -> Answers,
      Category -> "General"
    },
    PreviousAnswerKey -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[AgentAnswerKey],
      Description -> "The previous answer key, which can be used to compare changes in test results, and/or revert to older answer keys.",
      Category -> "General"
    },
    EmbeddingModel -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The model used to create the embeddings from the text associated with each answer. Embeddings created by different models cannot be compared to one another to determine the semantic similarity between the associated text blocks.",
      Category -> "General"
    }
  }
}];
