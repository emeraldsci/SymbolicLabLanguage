(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Redefine on every load since General is a Mathematica symbol we're stealing *)
OnLoad[
	(* Command Builder Functions*)
	Error::InvalidOption = "Because an error was encountered for option(s): `1`, the result cannot be generated. Please double check these errors and run the function again to proceed.";
	Error::InvalidInput = "Because an error was encountered for input(s): `1`, the result cannot be generated. Please double check these errors and then run the function again to proceed.";
	Error::NonUniqueName = "The requested name, `1`, is already taken for type `2`. Please rename the existing object or specify a unique name for the current object.";
	Error::InputLengthMismatch = "The inputs, `1`, has a value of length `2`, however it is expected to match the length of `3` which is length `4`. Please provide a single value to `1` or make sure the lengths of `1` and `3` match.";
	Error::EmptyContainers = "The following containers are empty and so cannot be used: `1`. Please check you've specified the correct containers or directly specify samples instead.";
	Error::DiscardedSamples = "The following object(s) specified are discarded and so cannot be used: `1`.  Please check the Status field of the samples in question, or provide alternative, non-discarded samples to use.";
	Error::DeprecatedModels = "The following model(s) specified are deprecated and so cannot be used: `1`.  Please check the Deprecated field of the models in question, or provide alternative, non-deprecated models to use.";


	Error::DuplicateName = "The requested name is already used for another `1`. Please rename the current object or specify a new unique name.";
	Error::MethodOptionConflict="The samples, `1`, at indices, `4`, have option(s), `2`, that do not match the option specified by the selected method, `3`. If any option(s) do not match the selected method, please set Method to Custom.";

	(* Math.m *)
	General::EvaluationFailure = "The function did not evaluate as expected.";
	
	(* Inventory, Maintenance, Qualifications, Plot *)
	General::MissingObject = "The provided object(s), '`1`', could not be found on Constellation. Please check the syntax and spelling of your input.";
	
	(* AbsorbanceQuantification, SolidPhaseExtraction *)
	General::IncompleteInformation="The field `1` in the objects `2` is missing information. Please run ValidObjectQ with Verbose -> Failures option to further diagnose the problem.";	
	
	(* Analysis functions *)
	General::UnknownUser = "A user must be logged in to Upload or Download from Constellation. Please login to the ECL.";
	General::MissingStandardCurve="Unable to resolve standard curve for given input.";
	
	(* DNA *)
	General::InvalidSequence="The sequence `1` is not a valid sequence. Please check your input with SequenceQ.";
	General::InvalidStrand="The strand `1` is not a valid strand. Please check your input with StrandQ.";
	General::InvalidStructure="The structre `1` is not a valid structure. Please check your input with StructureQ.";
	General::UnsupportedPolymers="The following polymer types are unsupported: `1`.  Please remove or change the unsupported polymer type to a new type and try agian.";

	(* Qualifications & Maintenance *)
	General::ObjectInactive = "The object(s), '`1`' have a Status of discarded, deprecated, or retired. Please check your input and its status.";
	General::PleaseSpecifyModel = "Unable to resolve option, '`1` -> Automatic'. More than one '`2`' option available for '`3`'. Please specify which model to use.";
	General::NoModelMaintenanceFound = "No compatible model maintenance were found for this target. Please verify your target and the requested maintenance type.";
	General::NoModelQualificationFound = "No compatible Model Qualifications were found for this target. Please verify your target and the requested Qualification type.";
	General::MaintenanceNotAvailable = "Unfortunately maintenance protocol: '`1`' is not available for '`2`'. Please select a compatible maintenance.";
	General::QualificationNotAvailable = "Unfortunately Qualification protocol: '`1`' is not available for '`2`'. Please select a compatible Qualification.";
	General::ModelMaintenanceNotValid = "The model Maintenance: '`1`', is not passing Valid Object tests. Please run ValidObjectQ with Verbose -> Failures option to further diagnose the problem.";
	General::ModelQualificationNotValid = "The model Qualification: '`1`', is not passing Valid Object tests. Please run ValidObjectQ with Verbose -> Failures option to further diagnose the problem.";
	General::UnableToCreateAsanaTask = "CreateAsanaTask[`1`] was unable to create an Asana task, please check that the Assignee and Followers have Asana IDs.";
	General::UndergoingMaintenance = "'`1`' is set to UndergoingMaintenance. Please use FastTrack->True to enqueue the protocol.";
	General::TargetDiscarded = "The object(s), '`1`' have a Status of discarded. Please check your target and its status.";
	General::TargetHistorical="The operator `1` is no longer at the company. Please check your target and its status.";
	General::QualificationAlreadyEnqueued = "A qualification of the model `1` for target `2` is already enqueued or running: (`3`). Please set FastTrack -> True if you intend to enqueue an additional qualification.";
	General::MaintenanceAlreadyEnqueued = "A maintenance of the model `1` for target `2` is already enqueued or running: (`3`). Please set FastTrack -> True if you intend to enqueue an additional qualification.";
	General::NoTargetModel = "The target `1` does not have a model and therefore there are no associated qualifications. Please upload an instrument model.";
];
