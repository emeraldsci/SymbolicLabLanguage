(* ::Package:: *)
 
(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitTest, Function], {
  Description -> "A run of tests to evaluate the correctness of a single function in Symbolic Lab Language (SLL).",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    Status -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> UnitTestFunctionStatusP,
      Description -> "Indicates if the unit tests are Enqueued, Running, Passed, Failed, Crashed, Aborted, or TimedOut.",
      Category -> "Organizational Information"
    },
    Function -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> _Symbol|_String|TypeP[],
      Description -> "The Symbolic Lab Language (SLL) function being tested for correctness by running through its unit tests by evaluating the expressions and comparing to the expected output.",
      Category -> "Organizational Information"
    },
    AsanaAssignee -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[User, Emerald, Developer],
      Description -> "The person who will be assigned to the asana task if the unit test fails.",
      Category -> "Organizational Information"
    },
    FailingEmeraldTestSummary -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[EmeraldCloudFile],
      Description -> "A cloud file containing the previous test summary whose failing tests should be rerun on Manifold.",
      Category -> "Organizational Information"
    },
    UnitTestSuite -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[UnitTest, Suite][UnitTests],
        Object[UnitTest, Suite][StressUnitTests]
      ],
      Description -> "The collection of unit tests that covers all of the functions defined by the function UnitTestedItems.",
      Category -> "Organizational Information"
    },
    Job -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Notebook, Job],
        Object[Notebook, Job][UnitTest]
      ],
      Description -> "The Manifold process used to evaluate this function's unit tests.",
      Category -> "Organizational Information"
    },
    Database -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> _Integer,
      Description -> "The Constellation unit testing database (https://constellation-neutrino(integer).emeraldcloudlab.com) that this test ran on. The unit testing databases are numbered 0-3. If Parallel->True, this field will be set to Null since Parallel tests run across all of the unit testing databases.",
      Category -> "Organizational Information"
    },
    Parallel -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "Indicates if the unit tests for this function ran in parallel across all of the unit testing databases.",
      Category -> "Organizational Information"
    },
    ParallelChildJobs -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Notebook, Job][ParallelParentUnitTest],
      Description -> "The Manifold jobs created by this unit test in order to run many tests in parallel.",
      Category -> "Organizational Information"
    },
    EmeraldTestSummary -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[EmeraldCloudFile],
      Description -> "A cloud file containing the results of this function's unit tests.",
      Category -> "Test Results"
    },
    Passed -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "Indicates if the return value matched the expected value for all of the unit tests for this function.",
      Category -> "Test Results"
    },
    Messages -> {
      Format -> Multiple,
      Class -> {
        String,
        Expression
      },
      Pattern :> {
        _String,
        _HoldForm
      },
      Headers -> {"Test Description","Message Thrown"},
      Description -> "For each unit test, the messages that were thrown in the course of running that unit test that were not in the expected Messages.",
      Category -> "Test Results"
    },
    SessionUUID->{
      Format-> Single,
      Class-> String,
      Pattern:> _String,
      Description->"The $SessionUUID used for this unit test.",
      Category->"Organizational Information"
    }
  }
}]
