(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitTest, Suite], {
  Description -> "A run of tests to evaluate the correctness of all the functions in Symbolic Lab Language (SLL).",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    Status -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> UnitTestSuiteStatusP,
      Description -> "Indicates if the unit test suite is enqueued, running, or completed.",
      Category -> "Organizational Information"
    },
    TimeOut -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Second],
      Units -> Hour,
      Description -> "The amount of time allowed for each function to run all of its tests before aborting and will be considered to be TimedOut.",
      Category -> "Organizational Information"
    },
    LaunchingJobs -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Notebook, Job],
      Description -> "The Manifold processes used to enqueue the individual unit tests.",
      Category -> "Organizational Information"
    },
    UnitTestedItems -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> _Symbol|_String|TypeP[],
      Description -> "The Symbolic Lab Language (SLL) functions that are tested in this unit test suite.",
      Category -> "Organizational Information"
    },
    UnitTestStatus -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> UnitTestFunctionStatusP,
      Description -> "For each member of UnitTestedItems, indicates if the unit tests are Enqueued, Running, Passed, Failed, Crashed, or TimedOut.",
      Category -> "Organizational Information",
      IndexMatching -> UnitTestedItems
    },
    UnitTests -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[UnitTest, Function][UnitTestSuite],
      Description -> "For each member of UnitTestedItems, the link to the individual tests for each function.",
      Category -> "Organizational Information",
      IndexMatching -> UnitTestedItems
    },
    PassingFunctions -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> _Symbol|_String,
      Description -> "The Symbolic Lab Language (SLL) functions that have been fully evaluated and passed their unit tests.",
      Category -> "Test Results"
    },
    FailingFunctions -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> _Symbol|_String,
      Description -> "The Symbolic Lab Language (SLL) functions that have been fully evaluated and failed their unit tests.",
      Category -> "Test Results"
    },
    TimedOutFunctions -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> _Symbol|_String,
      Description -> "The Symbolic Lab Language (SLL) functions that have been fully evaluated and didn't finish their unit tests within the TimeOut.",
      Category -> "Test Results"
    },
    SuiteTimedOutFunctions -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> _Symbol|_String,
      Description -> "The Symbolic Lab Language (SLL) functions that have been fully evaluated and didn't finish their unit tests within this suite's overall TimeOut.",
      Category -> "Test Results"
    },
    ManifoldBackendErrorFunctions -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> _Symbol|_String,
      Description -> "The Symbolic Lab Language (SLL) functions whose tests failed to complete because of some error on the Manifold backend.",
      Category -> "Test Results"
    },
    MathematicaErrorFunctions -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> _Symbol|_String,
      Description -> "The Symbolic Lab Language (SLL) functions whose tests failed to complete because of some error on the Mathematica testing framework.",
      Category -> "Test Results"
    },
    AbortedFunctions -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> _Symbol|_String,
      Description -> "The Symbolic Lab Language (SLL) functions whose tests were aborted before they were able to complete.",
      Category -> "Test Results"
    },
    CrashedFunctions -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> _Symbol|_String,
      Description -> "The Symbolic Lab Language (SLL) functions that crashed the Mathematica kernel while evaluating.",
      Category -> "Test Results"
    },
    UntestedFunctions -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> _Symbol|_String,
      Description -> "The Symbolic Lab Language (SLL) functions that currently do not have unit tests for this branch and should have tests added by a developer immediately.",
      Category -> "Test Results"
    },
    StressTestFunctions -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> _String | _Symbol,
      Relation -> Null,
      Description -> "The Symbolic Lab Language (SLL) functions that failed in the last unit testing run and should be run multiple times in the current unit testing run in order to make sure that they are passing robustly. These functions will be run up to 10 times (stopping early if they fail), as long as there is enough time in the unit testing suite to run additional tests.",
      Category -> "Test Results"
    },
    StressUnitTests -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[UnitTest, Function],
        Object[UnitTest, Function][UnitTestSuite]
      ],
      Description -> "The Symbolic Lab Language (SLL) functions that failed in the last unit testing run and should be run multiple times in the current unit testing run in order to make sure that they are passing robustly. These functions will be run up to 10 times (stopping early if they fail), as long as there is enough time in the unit testing suite to run additional tests.",
      Category -> "Test Results"
    }
  }
}]
