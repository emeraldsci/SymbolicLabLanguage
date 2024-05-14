(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*Compute*)


DefineTests[Compute,
	{
		Example[{Basic, "Compute a series of SLL expressions asynchronously on the cloud:"},
			Compute[
				xvals = Range[500];
				yvals = Sin[xvals / 100.0 * \[Pi]];
				xyData = Transpose@{xvals, yvals};
				EmeraldListLinePlot[xyData],
				Computation -> Cloud
			],
			ObjectP[Object[Notebook, Job]]
		],
		Example[{Basic, "Compute a notebook page (evaluate each code and input cell in a notebook page sequentially) asynchronously on the cloud:"},
			Compute[
				Object[Notebook, Page, "Manifold Test Notebook"],
				Computation -> Cloud
			],
			ObjectP[Object[Notebook, Job]]
		],
		Example[{Basic, "Schedule a computation to run exactly ten days from now:"},
			Compute[
				Print["This will run in ten days!"],
				Computation -> Cloud,
				Schedule -> (Now + 10 Day)
			],
			ObjectP[Object[Notebook, Job]]
		],
		Example[{Basic, "Create a job which runs the same computation once a week:"},
			Compute[
				Print["This runs once a week!"],
				Computation -> Cloud,
				RepeatFrequency -> (1 Week)
			],
			ObjectP[Object[Notebook, Job]]
		],

		(* Options *)
		Example[{Options, Computation, "Run computation asynchronously on the cloud, returning a Job notebook from which computation results can be accessed:"},
			Compute[Plot[Sin[x], {x, 0, 2\[Pi]}], Computation -> Cloud],
			ObjectP[Object[Notebook, Job]]
		],
		Example[{Options, Computation, "Run computation in the current notebook, returning the output of the input expression(s):"},
			Compute[Plot[Sin[x], {x, 0, 2\[Pi]}], Computation -> Notebook],
			ValidGraphicsP[]
		],
		Example[{Options, WaitForComputation, "Set WaitForComputation to False to run asynchronously (only supported when Computation->Cloud). The computation's status may be monitored from the resulting job notebook:"},
			Compute[Plot[Sin[x], {x, 0, 2\[Pi]}], Computation -> Cloud, WaitForComputation -> False],
			ObjectP[Object[Notebook, Job]]
		],
		Example[{Options, WaitForComputation, "Set WaitForComputation to True to prevent evaluation of additional cells until the current computation has completed:"},
			Compute["Hello World.", Computation -> Cloud, WaitForComputation -> True],
			"Hello World.",
			Stubs :> {Compute["Hello World.", Computation -> Cloud, WaitForComputation -> True] = "Hello World."}
		],
		Example[{Options, ForceComputation, "Run computation asynchronously on the cloud, returning a Job notebook, even if an interactive Manifold kernel is active."},
			LaunchInteractiveKernel[],
			Compute[1+1, ForceComputation->True],
			ObjectP[Object[Notebook, Job]],
			Stubs :> {LaunchInteractiveKernel[] = Null}
		],
		Example[{Options, Schedule, "If computing on the cloud, schedule a job to run two hours from the current time:"},
			Compute[
				Print["Hello World!"],
				Computation -> Cloud,
				Schedule -> (Now + 2 Hour)
			],
			ObjectP[Object[Notebook, Job]]
		],
		Example[{Options, Schedule, "Schedule a job to run computations at multiple dates:"},
			Compute[
				Print["Hello World!"],
				Computation -> Cloud,
				Schedule -> {Now, Now + 2 Day, Now + 2 Week}
			],
			ObjectP[Object[Notebook, Job]]
		],
		Example[{Options, RepeatFrequency, "Schedule a job to run computations every week, starting from the current date and time:"},
			Compute[
				Print["Hello World!"],
				Computation -> Cloud,
				RepeatFrequency -> (1 Week)
			],
			ObjectP[Object[Notebook, Job]]
		],
		Example[{Options, Schedule, "Schedule a job to run computations three times a week, on specific days:"},
			Compute[
				Print["Hello World!"],
				Computation -> Cloud,
				Schedule -> {Now, Now + 1 Day, Now + 3 Day},
				RepeatFrequency -> (1 Week)
			],
			ObjectP[Object[Notebook, Job]]
		],

		Example[{Options, Trigger, "If computing on the cloud, set up a Job which runs a computation every time a NMR Data object is modified. The modified objects may be referenced using $TrackedObjects:"},
			Compute[
				AnalyzeDownsampling[$TrackedObjects],
				Computation -> Cloud,
				Trigger -> {Object[Data, NMR]}
			],
			ObjectP[Object[Notebook, Job]]
		],
		Example[{Options, Trigger, "If computing on the cloud, set up a Job which runs a computation every time a specific object is modified:"},
			Compute[
				AnalyzeDownsampling[$TrackedObjects],
				Computation -> Cloud,
				Trigger -> {Object[Data, ChromatographyMassSpectra, "Sample LCMS Data"]}
			],
			ObjectP[Object[Notebook, Job]]
		],
		Example[{Options, TrackedFields, "Set up a Job which only runs computations when specific fields of given types are modified:"},
			Compute[
				AnalyzeDownsampling[$TrackedObjects],
				Computation -> Cloud,
				Trigger -> {Object[Data, ChromatographyMassSpectra], Object[Data, NMR]},
				TrackedFields -> {{IonAbundance3D, Absorbance}, {NMRSpectrum}}
			],
			ObjectP[Object[Notebook, Job]]
		],
		Example[{Options, TrackedFields, "Set up a Job which only runs computations when specific fields of a given object or objects are modified:"},
			Compute[
				AnalyzeDownsampling[$TrackedObjects],
				Computation -> Cloud,
				Trigger -> {Object[Data, ChromatographyMassSpectra, "Sample LCMS Data"]},
				TrackedFields -> {{IonAbundance3D, Absorbance}}
			],
			ObjectP[Object[Notebook, Job]]
		],
		Example[{Options, MaximumRunTime, "If computing on the cloud, set the maximum run time for which instances of this computation may run for. If this run time is exceeded, the computation will terminate with status TimedOut:"},
			Compute[Pause[1200];"Success!", MaximumRunTime -> (10 Minute), Computation -> Cloud],
			ObjectP[Object[Notebook, Job]]?(Download[#, MaximumRunTime] == (10 Minute)&)
		],
		Example[{Options, HardwareConfiguration, "If computing on the cloud, specify what hardware configuration to use. The standard configuration is a Fargate cluster with 8GB RAM:"},
			Compute[Print["Hello world"], Computation -> Cloud, HardwareConfiguration -> Standard],
			ObjectP[Object[Notebook, Job]]?(Download[#, HardwareConfiguration] == Standard&),
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "hendrik"]}
		],
		Example[{Options, HardwareConfiguration, "Request the HighRAM (24GB) hardware configuration for memory intensive computations:"},
			Compute[Print["Compute-intensive hello world"], Computation -> Cloud, HardwareConfiguration -> HighRAM],
			ObjectP[Object[Notebook, Job]]?(Download[#, HardwareConfiguration] == HighRAM&),
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "hendrik"]}
		],
		Example[{Options, EstimatedRunTime, "If computing on the cloud, specify the estimated run time of this computation. This run time will be used for scheduling:"},
			Compute[Print["Hello world"], Computation -> Cloud, EstimatedRunTime -> (1 Hour)],
			ObjectP[Object[Notebook, Job]]?(Download[#, EstimatedRunTime] == (1 Hour)&)
		],
		Example[{Options, MaximumThreads, "If computing on the cloud, specify the maximum number of computational threads that may be used:"},
			Compute[Print["Hello world"], Computation -> Cloud, MaximumThreads -> 3],
			ObjectP[Object[Notebook, Job]]?(Download[#, MaximumThreads] == 3&)
		],
		Example[{Options, Name, "If computing on the cloud, name the uploaded job object:"},
			Compute[
				Print["Hello World!"],
				Computation -> Cloud,
				Name -> "Test Job for Name Option"
			],
			ObjectP[Object[Notebook, Job]]?(Download[#, Name] == "Test Job for Name Option"&)
		],
		Example[{Options, DestinationNotebook, "Provide a Command Center notebook in which completed computations should be placed:"},
			Compute[
				Object[Notebook, Page, "Manifold Test Notebook"],
				Computation -> Cloud,
				DestinationNotebook -> Object[LaboratoryNotebook,"Compute Test CC Notebook "<>$SessionUUID]
			],
			ObjectP[Object[Notebook, Job]]?(Download[#, DestinationNotebook[Name]] == "Compute Test CC Notebook "<>$SessionUUID&)
		],
		Example[{Options, DestinationNotebookNamingFunction, "Specify a pure function which can be run at the end of each computation to name the page being placed in the directed notebook:"},
			Compute[
				Object[Notebook, Page, "Manifold Test Notebook"],
				Computation -> Cloud,
				DestinationNotebookNamingFunction->("Operations Report"<>DateString["ISODate"]&),
				DestinationNotebook -> Object[LaboratoryNotebook,"Compute Test CC Notebook "<>$SessionUUID]
			],
			ObjectP[Object[Notebook, Job]]?(Download[#, DestinationNotebookNamingFunction] == ("Operations Report" <> DateString["ISODate"] &)&)
		],
		Example[{Options, Environment, "Specify whether to run the computation within a localized development container:"},
			Compute[
				1 + 1,
				Computation -> Cloud,
				Environment -> Sandbox
			],
			ObjectP[Object[Notebook, Job]]?(Download[#, Environment] == Sandbox &),
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "hendrik"]}
		],

		(* Attributes *)
		Example[{Attributes, HoldFirst, "Compute has the attribute HoldFirst. The input expression will not be evaluated until the computation executes:"},
			Compute[1 + 1, Computation -> Notebook],
			2
		],

		(* Messages *)
		Example[{Messages, "DeveloperOnlyOptions", "Warning message shows if user without superuser privileges tries to change developer-only options:"},
			Lookup[
				Analysis`Private`stripAppendReplaceKeyHeads@Compute[Print["Hello World"],
					ZDriveFilePaths -> {"Z://testDirectory"},
					SLLVersion -> Develop,
					SLLPackage -> Developer,
					RunAsUser -> Object[User, "Test user for notebook-less test protocols"],
					Upload -> False
				],
				{ZDriveFilePaths, SLLVersion, SLLPackage, RunAsUser, FargateCluster, DisablePaclets, MathematicaVersion}
			] /. {lnk : _Link | _Object :> lnk[Object]},
			{_Missing..},
			Messages :> {Warning::DeveloperOnlyOptions}
		],
		Example[{Messages, "MaximumTimeExceeded", "Show an error and return $Failed if the supplied MaximumRunTime exceeds Manifold system limitations:"},
			Compute[
				Print["Hello World"],
				MaximumRunTime -> (2 Week)
			],
			$Failed,
			Messages :> {Error::MaximumTimeExceeded}
		],
		Example[{Messages, "MaximumTimeTooSmall", "Show an error and return $Failed if the supplied MaximumRunTime is less than ten minutes:"},
			Compute[
				Print["Hello World"],
				MaximumRunTime -> (10 Second)
			],
			$Failed,
			Messages :> {Error::MaximumTimeTooSmall}
		],
		Example[{Messages, "EstimatedTimeExceedsMaximum", "Show an error and return $Failed if the supplied EstimatedRunTime exceeds the MaximumRunTime:"},
			Compute[
				Print["Hello World"],
				MaximumRunTime -> (1 Hour),
				EstimatedRunTime -> (2 Hour)
			],
			$Failed,
			Messages :> {Error::EstimatedTimeExceedsMaximum}
		],
		Example[{Messages, "CloudOnlyOptions", "Show an error when specified options are incompatible with local (in-notebook) computation:"},
			Compute[Plot[Sin[x], {x, 0, 2\[Pi]}], RepeatFrequency -> (1 Week), Computation -> Notebook, MaximumThreads -> 3],
			$Failed,
			Messages :> {Error::CloudOnlyOptions}
		],
		Example[{Messages, "InvalidTrackedFieldsLength", "The number of lists of TrackedFields must match the length of Trigger when objects are used:"},
			Compute[
				AnalyzeDownsampling[$TrackedObjects],
				Computation -> Cloud,
				Trigger -> {Object[Data, ChromatographyMassSpectra, "Sample LCMS Data"], Object[Data, ChromatographyMassSpectra, "Sample LCMS Data"]},
				TrackedFields -> {{IonAbundance3D, DateCreated, Polygon}},
				Upload -> False
			],
			$Failed,
			Messages :> {Error::InvalidTrackedFieldsLength}
		],
		Example[{Messages, "InvalidTrackedFieldsLength", "The number of lists of TrackedFields must match the length of Trigger when types are used:"},
			Compute[
				AnalyzeDownsampling[$TrackedObjects],
				Computation -> Cloud,
				Trigger -> {Object[Data, ChromatographyMassSpectra]},
				TrackedFields -> {{IonAbundance3D, DateCreated}, {All}},
				Upload -> False
			],
			$Failed,
			Messages :> {Error::InvalidTrackedFieldsLength}
		],
		Example[{Messages, "InvalidTrackedFields", "When Trigger is a list of objects, this error shows if any of the TrackedFields are not fields of the provided objects:"},
			Compute[
				AnalyzeDownsampling[$TrackedObjects],
				Computation -> Cloud,
				Trigger -> {Object[Data, ChromatographyMassSpectra, "Sample LCMS Data"], Object[Data, ChromatographyMassSpectra, "Sample LCMS Data"]},
				TrackedFields -> {{IonAbundance3D, DateCreated, Polygon}, {All}},
				Upload -> False
			],
			$Failed,
			Messages :> {Error::InvalidTrackedFields}
		],
		Example[{Messages, "InvalidTrackedFields", "When Trigger is a list of types, this error shows if any of the TrackedFields are not fields of the provided types:"},
			Compute[
				AnalyzeDownsampling[$TrackedObjects],
				Computation -> Cloud,
				Trigger -> {Object[Data, ChromatographyMassSpectra], Object[Data, NMR2D]},
				TrackedFields -> {{IonAbundance3D, DateCreated, Polygon}, {Absorbance}},
				Upload -> False
			],
			$Failed,
			Messages :> {Error::InvalidTrackedFields}
		],
		Example[{Messages, "ObjectNotFound", "Error occurs if any of the objects specified in Trigger cannot be found in the database with DatabaseMemberQ[]:"},
			Compute[
				AnalyzeDownsampling[$TrackedObjects],
				Computation -> Cloud,
				Trigger -> {Object[Data, ChromatographyMassSpectra, "Sample LCMS Data"], Object[Data, ChromatographyMassSpectra, "invalid id"]}
			],
			$Failed,
			Messages :> {Error::ObjectNotFound}
		],
		Example[{Messages, "NoTrigger", "If Trigger->None, the TrackedFields option will be ignored:"},
			Compute[
				AnalyzeDownsampling[$TrackedObjects],
				Computation -> Cloud,
				Trigger -> None,
				TrackedFields -> {{IonAbundance3D}}
			],
			ObjectP[Object[Notebook, Job]],
			Messages :> {Warning::NoTrigger}
		],
		Example[{Messages, "InvalidSchedule", "None cannot be used if Schedule is set as a list:"},
			Compute[
				Print["Hello World!"],
				Computation -> Cloud,
				Schedule -> {None, Now}
			],
			$Failed,
			Messages :> {Error::InvalidSchedule}
		],
		Example[{Messages, "InvalidRepeat", "Only one RepeatFrequency can be specified if Schedule is either None or not provided:"},
			Compute[
				Print["Hello World!"],
				Computation -> Cloud,
				RepeatFrequency -> {1 Week, 1 Day}
			],
			$Failed,
			Messages :> {Error::InvalidRepeat}
		],
		Example[{Messages, "RepeatFrequencyTooSmall", "Repeat frequencies must be larger than the maximum run time for a computation:"},
			Compute[
				Print["Hello World!"],
				Computation -> Cloud,
				Schedule -> None,
				RepeatFrequency -> {1 Hour}
			],
			$Failed,
			Messages :> {Error::RepeatFrequencyTooSmall}
		],
		Example[{Messages, "ScheduledDateInPast", "Scheduled start dates in the Schedule option must be in the future:"},
			Compute[
				Print["Hello World!"],
				Computation -> Cloud,
				Schedule -> {Now - 2 Day, Now, Now + 2 Day}
			],
			$Failed,
			Messages :> {Error::ScheduledDateInPast}
		],
		Example[{Messages, "RepeatNotAllowed", "Can't use Sandbox with the Repeat option:"},
			Compute[
				Print["Hello World!"],
				Computation -> Cloud,
				Schedule -> None,
				RepeatFrequency -> {1 Week},
				Environment -> Sandbox
			],
			$Failed,
			Messages :> {Error::RepeatNotAllowed},
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "hendrik"]}
		],
		Example[{Messages, "ProductionDatabase", "Can't use Sandbox on Production:"},
			Compute[
				Print["Hello World!"],
				Computation -> Cloud,
				Schedule -> None,
				Environment -> Sandbox
			],
			$Failed,
			Stubs :> {ProductionQ[] = True, $PersonID = Object[User, Emerald, Developer, "hendrik"]},
			Messages :> {Error::ProductionDatabase}
		],
		Example[{Messages, "TriggerNotAllowed", "Can't trigger Sandbox Computations with TrackedFields:"},
			Compute[
				Print["Hello World!"],
				Computation -> Cloud,
				Schedule -> None,
				Environment -> Sandbox,
				Trigger -> {Object[Data, NMR]}
			],
			$Failed,
			Messages :> {Error::TriggerNotAllowed},
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "hendrik"]}
		],
		Example[{Messages, "ZDriveNotAllowed", "Can't utilize the Z-drive within the Sandbox:"},
			Compute[
				Print["Hello World!"],
				Computation -> Cloud,
				Schedule -> None,
				Environment -> Sandbox,
				ZDriveFilePaths -> {"Z://testDirectory"}
			],
			$Failed,
			Messages :> {Error::ZDriveNotAllowed},
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "hendrik"]}
		],

		(* Tests *)
		Test["Check default values for developer-only options:",
			Lookup[
				Analysis`Private`stripAppendReplaceKeyHeads@Compute[Print["Hello World"], Upload -> False],
				{ZDriveFilePaths, SLLVersion, SLLPackage, RunAsUser, FargateCluster, DisablePaclets, MathematicaVersion}
			] /. {lnk : _Link | _Object :> lnk[Object]},
			{_Missing..}
		],
		Test["Setting developer-only options is possible when signed in with superuser privileges:",
			Lookup[
				Analysis`Private`stripAppendReplaceKeyHeads@Compute[Print["Hello World"],
					ZDriveFilePaths -> {"Z://testDirectory"},
					SLLVersion -> Develop,
					SLLPackage -> Developer,
					RunAsUser -> Object[User, "Test user for notebook-less test protocols"],
					DisablePaclets -> True,
					MathematicaVersion -> "12.0.1",
					Upload -> False
				],
				{ZDriveFilePaths, SLLVersion, SLLPackage, RunAsUser, FargateCluster, DisablePaclets, MathematicaVersion}
			] /. {lnk : _Link | _Object :> lnk[Object]},
			{{"Z://testDirectory"}, Develop, Developer, Object[User, "id:n0k9mG8AXZP6"], "manifold-mm-cluster", True, "12.0.1"},
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "hendrik"]}
		],
		Test["FargateCluster defaults to manifold-mm-cluster when run as a superuser:",
			Lookup[
				Analysis`Private`stripAppendReplaceKeyHeads@Compute[Print["Hello World"],
					Upload -> False
				],
				FargateCluster
			],
			"manifold-mm-cluster",
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "hendrik"]}
		],
		Test["FargateCluster defaults to Null if run as a regular user:",
			Lookup[
				Analysis`Private`stripAppendReplaceKeyHeads@Compute[Print["Hello World"],
					Upload -> False
				],
				FargateCluster
			],
			_Missing,
			(* frezza+ET test account *)
			Stubs :> {$PersonID = Object[User, "id:GmzlKjPRo9We"]}
		],
		Test["FargateCluster and SLLPackage default to internal cluster/developer when run as a superuser:",
			Lookup[
				Analysis`Private`stripAppendReplaceKeyHeads@Compute[Print["Hello World"],
					ZDriveFilePaths -> {"Z://testDirectory"},
					Upload -> False
				],
				{ZDriveFilePaths, SLLPackage, FargateCluster}
			],
			{{"Z://testDirectory"}, Developer, "manifold-mm-cluster"},
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "hendrik"]}
		],
		Test["The EstimatedRunTime defaults to MaximumRunTime if not specified:",
			Lookup[
				Compute[
					Print["Hello World"],
					MaximumRunTime -> (5.23 Hour),
					Upload -> False
				],
				EstimatedRunTime
			],
			(5.23 Hour)
		],
		Test["Job type resolves to OneTime if no schedule or trigger options are supplied:",
			Lookup[
				Compute[Print["Hello world"], Upload -> False],
				Replace[JobType]
			],
			{OneTime}
		],
		Test["Job type resolves to Scheduled if the Schedule option is provided:",
			Lookup[
				Compute[Print["Hello world"], Schedule -> Now, Upload -> False],
				Replace[JobType]
			],
			{Scheduled}
		],
		Test["Job type resolves to Scheduled if the RepeatFrequency option is provided:",
			Lookup[
				Compute[Print["Hello world"], RepeatFrequency -> (1 Week), Upload -> False],
				Replace[JobType]
			],
			{Scheduled}
		],
		Test["Job type resolves to OneTime if the Schedule option is provided, but set to None:",
			Lookup[
				Compute[Print["Hello world"], Schedule -> None, Upload -> False],
				Replace[JobType]
			],
			{OneTime}
		],
		Test["Job type resolves to OneTime if the RepeatFrequency option is provided, but set to None:",
			Lookup[
				Compute[Print["Hello world"], RepeatFrequency -> None, Upload -> False],
				Replace[JobType]
			],
			{OneTime}
		],
		Test["Job type resolves to Triggered if triggering conditions are supplied:",
			Lookup[
				Compute[Print["Hello world"], Trigger -> {Object[Data, DynamicFoamAnalysis]}, Upload -> False],
				Replace[JobType]
			],
			{Triggered}
		],
		Test["Job type resolves to OneTime if Trigger->None:",
			Lookup[
				Compute[Print["Hello world"], Trigger -> None, Upload -> False],
				Replace[JobType]
			],
			{OneTime}
		],
		Test["Job type resolves to Scheduled and Triggered if both Schedule and Trigger are supplied:",
			Lookup[
				Compute[Print["Hello world"], Schedule -> Now, Trigger -> {Object[Data, DynamicFoamAnalysis]}, Upload -> False],
				Replace[JobType]
			],
			{Scheduled, Triggered}
		],
		Test["Job triggering specs are correct given an object trigger and tracked fields:",
			Lookup[
				Analysis`Private`stripAppendReplaceKeyHeads@Compute[
					AnalyzeDownsampling[$TrackedObjects],
					Computation -> Cloud,
					Trigger -> {Object[Data, ChromatographyMassSpectra, "Sample LCMS Data"]},
					TrackedFields -> {{IonAbundance3D, Absorbance}},
					Upload -> False
				],
				{TrackedTypeChanges, TrackedTypeFieldChanges, TrackedObjectChanges, TrackedObjectFieldChanges}
			] /. {l : _Link :> l[Object]},
			{
				Null,
				Null,
				{Object[Data, ChromatographyMassSpectra, "id:J8AY5jDjaVlD"]},
				{{IonAbundance3D, Absorbance}}
			}
		],
		Test["Job triggering specs are correct given type triggers with tracked fields:",
			Lookup[
				Analysis`Private`stripAppendReplaceKeyHeads@Compute[
					AnalyzeDownsampling[$TrackedObjects],
					Computation -> Cloud,
					Trigger -> {Object[Data, ChromatographyMassSpectra], Object[Data, NMR]},
					TrackedFields -> {{IonAbundance3D, Absorbance}, {NMRSpectrum}},
					Upload -> False
				],
				{TrackedTypeChanges, TrackedTypeFieldChanges, TrackedObjectChanges, TrackedObjectFieldChanges}
			],
			{
				{Object[Data, ChromatographyMassSpectra], Object[Data, NMR]},
				{{IonAbundance3D, Absorbance}, {NMRSpectrum}},
				Null,
				Null
			}
		],
		Test["Job triggering specs are correct given an object trigger:",
			Lookup[
				Analysis`Private`stripAppendReplaceKeyHeads@Compute[
					AnalyzeDownsampling[$TrackedObjects],
					Computation -> Cloud,
					Trigger -> {Object[Data, ChromatographyMassSpectra, "Sample LCMS Data"]},
					Upload -> False
				],
				{TrackedTypeChanges, TrackedTypeFieldChanges, TrackedObjectChanges, TrackedObjectFieldChanges}
			] /. {l : _Link :> l[Object]},
			{
				Null,
				Null,
				{Object[Data, ChromatographyMassSpectra, "id:J8AY5jDjaVlD"]},
				{{All}}
			}
		],
		Test["Job triggering specs are correct given a type modification trigger:",
			Lookup[
				Analysis`Private`stripAppendReplaceKeyHeads@Compute[
					AnalyzeDownsampling[$TrackedObjects],
					Computation -> Cloud,
					Trigger -> {Object[Data, NMR]},
					Upload -> False
				],
				{TrackedTypeChanges, TrackedTypeFieldChanges, TrackedObjectChanges, TrackedObjectFieldChanges}
			],
			{
				{Object[Data, NMR]},
				{{All}},
				Null,
				Null
			}
		],
		Test["Job triggering specs are correct given multiple scheduled dates:",
			Lookup[
				Analysis`Private`stripAppendReplaceKeyHeads@Compute[
					Print["Hello World!"],
					Computation -> Cloud,
					Schedule -> {Now, Now + 2 Day, Now + 2 Week},
					Upload -> False
				],
				{ScheduledStartDates, ComputationFrequency}
			],
			{{DateObject[{2021, 7, 7, 18, 10}], DateObject[{2021, 7, 7, 18, 10}] + 2 Day, DateObject[{2021, 7, 7, 18, 10}] + 2 Week}, Null},
			Stubs :> {Now = DateObject[{2021, 7, 7, 18, 10}]}
		],
		Test["Job triggering specs are correct given a repeat frequency with no Schedule:",
			Lookup[
				Analysis`Private`stripAppendReplaceKeyHeads@Compute[
					Print["Hello World!"],
					Computation -> Cloud,
					RepeatFrequency -> {1 Week},
					Upload -> False
				],
				{ScheduledStartDates, ComputationFrequency}
			],
			{{DateObject[{2021, 7, 7, 18, 10}]}, {1 Week}},
			Stubs :> {Now = DateObject[{2021, 7, 7, 18, 10}]}
		],
		Test["Job triggering specs are correct given multiple scheduled dates and a single repeat frequency:",
			Lookup[
				Analysis`Private`stripAppendReplaceKeyHeads@Compute[
					Print["Hello World!"],
					Computation -> Cloud,
					Schedule -> {Now, Now + 1 Day, Now + 3 Day},
					RepeatFrequency -> (1 Week),
					Upload -> False
				],
				{ScheduledStartDates, ComputationFrequency}
			],
			{{DateObject[{2021, 7, 7, 18, 10}], DateObject[{2021, 7, 7, 18, 10}] + 1 Day, DateObject[{2021, 7, 7, 18, 10}] + 3 Day}, {1 Week, 1 Week, 1 Week}},
			Stubs :> {Now = DateObject[{2021, 7, 7, 18, 10}]}
		],
		Test["If Notebook is set to something but the user is a superuser, still properly give a notebook to the job:",
			job = Compute[
				1 + 1,
				RunAsUser -> $PersonID
			];
			Download[job, Notebook],
			ObjectP[Object[LaboratoryNotebook, "id:rea9jlRZkrjx"]],
			Stubs :> {
				$PersonID = Object[User, Emerald, Developer, "id:P5ZnEjdYnVmr"],
				$Notebook = Object[LaboratoryNotebook, "id:rea9jlRZkrjx"]
			}
		]
	},

	(* Default user runs tests without superuser privileges *)
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> Module[{allTestObjects, existingObjects, notebookPacket},
		(* Initiate object tracking *)
		$CreatedObjects = {};

		(* All named objects used by these unit tests *)
		allTestObjects = {
			Object[Notebook, Job, "Test Job for Name Option"],
			Object[LaboratoryNotebook,"Compute Test CC Notebook "<>$SessionUUID]
		};

		(* Grab any test objects which are already in database *)
		existingObjects = PickList[allTestObjects, DatabaseMemberQ[allTestObjects]];

		(* Make a little test notebook *)
		notebookPacket=<|
			Type->Object[LaboratoryNotebook],
			DeveloperObject->True,
			Name->"Compute Test CC Notebook "<>$SessionUUID
		|>;

		Upload[notebookPacket];

		(* Erase any objects which we failed to erase from the last unit test *)
		Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
	],

	SymbolTearDown :> Module[{},

		(* All named objects used by these unit tests *)
		allTestObjects = {
			Object[Notebook, Job, "Test Job for Name Option"],
			Object[LaboratoryNotebook,"Compute Test CC Notebook "<>$SessionUUID]
		};

		(* Grab any test objects which are already in database *)
		existingObjects = PickList[allTestObjects, DatabaseMemberQ[allTestObjects]];

		(* Erase any objects which we failed to erase from the last unit test *)
		Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
	]
];


(* ::Subsection::Closed:: *)
(*ValidComputationQ*)


DefineTests[ValidComputationQ,
	{
		Example[{Basic, "Indicates if a set of commands can be turned into a Computation:"},
			ValidComputationQ[c = 1 + 1;b + c],
			True
		],
		Example[{Basic, "Computations cannot contain any Experiment function calls:"},
			ValidComputationQ[
				ExperimentHPLC[
					{
						Object[Sample, "Test Sample 1 for ExperimentHPLC tests"],
						Object[Sample, "Test Sample 2 for ExperimentHPLC tests"],
						Object[Sample, "Test Sample 3 for ExperimentHPLC tests"]
					}
				]
			],
			True,
			Messages :> {Warning::ExperimentCallInComputation}
		],
		Example[{Options, OutputFormat, "Return a test summary:"},
			ValidComputationQ[1 + 1, OutputFormat -> TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options, Verbose, "Print the results of all tests:"},
			ValidComputationQ[1 + 1, Verbose -> True],
			True
		],
		Example[{Messages, "ExperimentCallInComputation", "Computations cannot contain any Experiment function calls:"},
			ValidComputationQ[
				ExperimentHPLC[
					{
						Object[Sample, "Test Sample 1 for ExperimentHPLC tests"],
						Object[Sample, "Test Sample 2 for ExperimentHPLC tests"],
						Object[Sample, "Test Sample 3 for ExperimentHPLC tests"]
					}
				]
			],
			True,
			Messages :> {Warning::ExperimentCallInComputation}
		]
	},
	SymbolTearDown :> Module[{},
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects];
	]
];
