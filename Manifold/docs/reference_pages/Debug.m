(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*DebugManifoldJob*)


(* ::Subsubsection::Closed:: *)
(*DebugManifoldJob*)

DefineUsage[DebugManifoldJob,{
  BasicDefinitions->{
    {"DebugManifoldJob[computation]", "output", "returns information and log links for the provided computation."},
    {"DebugManifoldJob[job]", "output", "returns information and log links for the provided job."},
    {"DebugManifoldJob[function]", "output", "returns information and log links for the provided unit test function."},
    {"DebugManifoldJob[suite]", "output", "returns information and log links for the LaunchingJobs of the provided unit test suite."}
  },
  Input:>{
    {"computation", ObjectP[Object[Notebook, Computation]], "The computation that was run asynchronously on ECL Manifold."},
    {"job", ObjectP[Object[Notebook, Job]], "The job that represents the computation that was run asynchronously on ECL Manifold."},
    {"function", ObjectP[Object[UnitTest, Function]], "The individual unit test that was run asynchronously on ECL Manifold."},
    {"suite", ObjectP[Object[UnitTest, Suite]], "The collection of unit test functions that was run asynchronously on ECL Manifold."}
  },
  Output:>{
    {"output", _String, "The simplified response if there are no issues or the job failed due to a common error."},
    {"output", _Grid, "Contains the ObjectLog response and links to Fargate and Lambda CloudWatchLogs for the associated job."},
    {"output", _Association, "The association form of the grid output."}
  },
  MoreInformation->{
    "This function returns a list of URLs that can only be accessed by developers who have read permissions to AWS CloudWatchLogs."
  },
  SeeAlso->{
    "Compute",
    "PlotComputationQueue"
  },
  Author->{"platform"}
}];

DefineUsage[PlotTestSuiteTimeline,{
  BasicDefinitions->{
    {"PlotTestSuiteTimeline[suite]","output","displays each of the functions that compose the given unit test suite in a timeline plot."}
  },
  Input:>{
    {"suite",ObjectP[Object[UnitTest,Suite]],"The unit test suite for which we want to plot the timeline of functions."}
  },
  Output:>{
    {"output", _Grid, "The timeline plot containing each of the runtime for the functions in the unit test suite."}
  },
  SeeAlso->{
    "DebugManifoldJob",
    "PlotTestSuiteSummaries"
  },
  Author->{"platform"}
}];

DefineUsage[PlotTestSuiteSummaries,{
  BasicDefinitions->{
    {"PlotTestSuiteSummaries[testSuite]", "output", "shows test summaries for a unit test suite."},
    {"PlotTestSuiteSummaries[testFunction]", "output", "shows test summaries for a unit test function."}
  },
  Input:>{
    {"testSuite",  ObjectP[Object[UnitTest, Suite]], "The unit test suite for which we want to plot the test summaries."},
    {"testFunction",  ObjectP[Object[UnitTest, Function]], "The unit test function for which we want to plot the test summary."}
  },
  Output:>{
    {"output", _TableForm, "A table showing the test summaries of a unit test suite."},
    {"output", _TableForm, "A table showing the test summary of a unit test function."}
  },
  SeeAlso->{
    "TestSummaryNotebook",
    "PlotTestSuiteTimeline"
  },
  Author->{"dima", "steven", "mert"}
}];