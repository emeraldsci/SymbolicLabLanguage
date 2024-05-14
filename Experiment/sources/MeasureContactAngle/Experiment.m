(* ::Package:: *)

(* ::Title:: *)
(*Experiment MeasureConductivity: Source*)


(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*ExperimentMeasureContactAngle*)


(* ::Subsection:: *)
(*ExperimentMeasureContactAngle Options*)


DefineOptions[ExperimentMeasureContactAngle,
	Options:>{
		{
			OptionName->Instrument,
			Default->Model[Instrument,Tensiometer,"Kruss K100SF Force Tensiometer"],
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Instrument,Tensiometer],Object[Instrument,Tensiometer]}]
			],
			Description->"The instrument that is used to measure the contact angle between fiber and liquid samples.",
			Category->"General"
		},
		{
			OptionName->NumberOfReplicates,
			Default->Null,
			Description->"The number of times to repeat measurement on each provided fiber sample(s). For example, if NumberOfReplicates->2, the sample will be measured twice with the same procedural settings.",
			AllowNull->True,
			Widget->Widget[
				Type->Number,
				Pattern:>GreaterEqualP[1,1]
			],
			Category->"General"
		},
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->SampleLabel,
				Default->Automatic,
				Description->"A user defined word or phrase used to identify the fiber sample that is immersed in the wetting liquid, for use in downstream unit operations.",
				AllowNull->False,
				Category->"General",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				UnitOperation->True
			},
			{
				OptionName->SampleContainerLabel,
				Default->Automatic,
				Description->"A user defined word or phrase used to identify the container of the fiber sample that is immersed in the wetting liquid, for use in downstream unit operations.",
				AllowNull->False,
				Category->"General",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				UnitOperation->True
			},
			{
				OptionName->WettingLiquidLabel,
				Default->Automatic,
				Description->"A user defined word or phrase used to identify the wetting liquid sample into which the fiber sample is immersed, for use in downstream unit operations.",
				AllowNull->False,
				Category->"General",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				UnitOperation->True
			},
			{
				OptionName->WettingLiquidContainerLabel,
				Default->Automatic,
				Description->"A user defined word or phrase used to identify the original container of the wetting liquid sample into which the fiber sample is immersed, for use in downstream unit operations.",
				AllowNull->False,
				Category->"General",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				UnitOperation->True
			},
			(* Wetted Length Measurement *)
			{
				OptionName->WettedLengthMeasurement,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if the circumference of the input sample must be measured before contact angle measurement.",
				ResolutionDescription->"Automatically set to True if fiber sample doesn't have its wetted length populated.",
				Category->"Protocol"
			},
			{
				OptionName->WettedLengthMeasurementLiquids,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
					PreparedSample->False,
					PreparedContainer->False
				],
				Description->"Indicates the liquid used for measuring the circumference of the input sample.",
				ResolutionDescription->"Automatically set to True if fiber sample doesn't have its wetted length populated.",
				Category->"Protocol"
			},
			(* Procedure Control *)
			{
				OptionName->NumberOfCycles,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[1,10,1]
				],
				Description->"Number of times that the sample stage is raised and lowered such that the advancing contact angle is measured when raising and receding contact angle is measured when lowering.",
				ResolutionDescription->"Automatically set to 1.",
				Category->"Protocol"
			},
			{
				OptionName->ContactDetectionSpeed,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0.1 Millimeter/Minute,500 Millimeter/Minute],
					Units->CompoundUnit[{1,{Millimeter,{Millimeter}}},{-1,{Minute,{Minute,Second}}}]
				],
				Description->"The speed at which the sample stage is moved prior to contact between the sample and fiber until contact is made.",
				ResolutionDescription->"Automatically set to 6 Millimeter/Minute.",
				Category->"Protocol"
			},
			{
				OptionName->ContactDetectionSensitivity,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[1 Microgram,10 Gram],
					Units->{Gram,{Gram,Milligram,Microgram}}
				],
				Description->"The minimum change of the value measured by the sensor which determines the contact point of the fiber and liquid/air interface. The larger the value entered, the lower the sensitivity, and vice versa. Too high a value can lead to the surface not being detected. Too low a value can lead to changes in the measured value being incorrectly interpreted as contact with the surface.",
				ResolutionDescription->"Automatically set to 0.01 Gram.",
				Category->"Protocol"
			},
			{
				OptionName->MeasuringSpeed,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0.1 Millimeter/Minute,500 Millimeter/Minute],
					Units->CompoundUnit[{1,{Millimeter,{Millimeter}}},{-1,{Minute,{Minute,Second}}}]
				],
				Description->"The speed at which the sample stage is moved up and down after contact between fiber and sample during a cycle. Increasing the measuring speed by too much will decrease the accuracy of the measurement.",
				ResolutionDescription->"Automatically set to 3 Millimeter/Minute.",
				Category->"Protocol"
			},
			{
				OptionName->AcquisitionStep,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[1 Micrometer,10 Millimeter],
					Units->{Millimeter,{Millimeter,Micrometer}}
				],
				Description->"The distance the sample stage moves between each contact angle measurement. Decreasing this option increases the number of readings per length of sample.",
				ResolutionDescription->"Automatically set to 0.2 Millimeter.",
				Category->"Protocol"
			},
			{
				OptionName->StartImmersionDepth,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0.1 Micrometer,5 Millimeter],
					Units->{Millimeter,{Millimeter,Micrometer}}
				],
				Description->"The immersion depth where the fiber sample starts advancing and ends receding.",
				ResolutionDescription->"Automatically set to 1 Millimeter.",
				Category->"Protocol"
			},
			{
				OptionName->EndImmersionDepth,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0.1 Micrometer,35 Millimeter],
					Units->{Millimeter,{Millimeter,Micrometer}}
				],
				Description->"The immersion depth where the fiber sample ends advancing and starts receding.",
				ResolutionDescription->"Automatically set to the sum of 25 AcquisitionStep or 5 Millimeter, whichever is smaller.",
				Category->"Protocol"
			},
			{
				OptionName->StartImmersionDelay,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Second,10 Minute],
					Units->{Second,{Second,Minute,Hour}}
				],
				Description->"Waiting time after sample stage reaches the position of StartImmersionDepth and before it moves up again for the next cycle.",
				ResolutionDescription->"Automatically set to 1 second.",
				Category->"Protocol"
			},
			{
				OptionName->EndImmersionDelay,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Second,10 Minute],
					Units->{Second,{Second,Minute,Hour}}
				],
				Description->"Waiting time after sample stage reaches the position of EndImmersionDepth and before it moves down.",
				ResolutionDescription->"Automatically set to 1 second.",
				Category->"Protocol"
			},
			(* Wetting liquid/Immersion container options *)
			{
				OptionName->Temperature,
				Default->Ambient,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[10 Celsius,50 Celsius],(* The machine allows -15\[Degree]C, but currently we limit it to only use water as circulation fluid so the lower limit would be 10\[Degree]C *)
						Units->{Celsius,{Celsius,Fahrenheit,Kelvin}}
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[Ambient]]
				],
				Description->"The temperature of thermal jacket, which heats up the wetting liquid in the immersion container, controlled by an external recirculating bath.",
				ResolutionDescription->"Automatically set to ambient temperature.",
				Category->"Protocol"
			},
			{
				OptionName->Volume,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Milliliter,100 Milliliter,1 Milliliter],
					Units->{Milliliter,{Milliliter,Liter}}
				],
				Description->"The amount of wetting liquid to use in the ImmersionContainer into which the fiber is immersed.",
				ResolutionDescription->"Automatically set to at most 80 Millimeter based on the remaining volume of liquid sample.",
				Category->"SamplePrep"
			},
			{
				OptionName->ImmersionContainer,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[Model[Container,Vessel]],
					PreparedSample->False,
					PreparedContainer->False
				],
				Description->"The container model that holds the wetting liquid into which the fiber is immersed.",
				ResolutionDescription->"Automatically set to Model[Container, Vessel, \"Kruss SV20 glass sample vessel\"] if Volume is greater than 35 mL. Otherwise, set to Model[Container, Vessel, \"Kruss SV10 glass sample vessel\"]",
				Category->"SamplePrep"
			},
			(* Fiber Sample Holder  *)
			{
				OptionName->FiberSampleHolder,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[Model[Container,FiberSampleHolder]],
					PreparedSample->False,
					PreparedContainer->False
				],
				Description->"The container model that holds the solid fiber sample and is mounted onto the force sensor of instrument.",
				ResolutionDescription->"Automatically set to Model[Container, FiberSampleHolder, \"Kruss single fiber sample holder\"].",
				Category->"SamplePrep"
			}
		],
		PreparatoryUnitOperationsOption,
		Experiment`Private`PreparatoryPrimitivesOption,
		ProtocolOptions,
		SimulationOption,
		PostProcessingOptions,
		PreparationOption,
		SamplesInStorageOption
	}
];


(* ::Subsection:: *)
(*ExperimentMeasureContactAngle*)

(* ::Subsubsection:: *)
(* ExperimentMeasureContactAngle Error Messages *)

(* Invalid Input error *)
Error::IncompatibleSample="The following sample(s) `1` is not the proper solid fiber sample or wetting liquid and not compatible with the single fiber tensiometer. Please check your inputs or choose different samples to be measured.";
Error::FiberCircumferenceRequired="The following sample(s) `1` does not have FiberCircumference, which is required for contact angle measurement and data analysis. Please set WettedLengthMeasurement to Automatic or True, or choose different samples.";
Warning::SurfaceTensionRequired="The following wetting liquid sample(s) `1` does not have SurfaceTension, which is required for contact angle data analysis. Please populate the SurfaceTension field or choose different wetting liquids, otherwise contact angles won't be calculated after measurement.";
Error::InvalidImmersionDepths="EndImmersionDepth `1` should be larger than StartImmersionDepth `2`.";
Error::InvalidVolume="Volume `1` is larger than the maximum volume `2` of immersion container `3`. Lower the Volume or change an immersion container.";
Error::InvalidDepth="EndImmersionDepth `1` is larger than the internal depth `2` of immersion container `3`. Lower the EndImmersionDepth or change an immersion container.";
Error::InvalidCount="Sample `1` does not have enough Count for all the measurements. Please double check the remaining Count of sample and reduce the number of samples or NumberOfReplicates.";

(* ::Subsubsection:: *)
(* Experiment function and overloads *)
(* Main sample overload *)
ExperimentMeasureContactAngle[
	mySolidSamples:Alternatives[ListableP[ObjectP[Object[Sample]]],ListableP[ObjectP[Object[Item,WilhelmyPlate]]]],
	myWettingLiquids:ListableP[ObjectP[{Object[Sample],Model[Sample]}]],
	myOptions:OptionsPattern[]
]:=Module[
	{
		outputSpecification,output,gatherTests,listedSamplesNamed,listedOptionsNamed,
		validSamplePreparationResult,allPreparedSamples,myOptionsWithPreparedSamplesNamed,updatedSimulation,
		mySamplesWithPreparedSamplesNamed,myWettingLiquidsWithPreparedSamplesNamed,safeOpsNamed,safeOpsTests,
		combinedNamedSamples,combinedSamples,safeOps,myOptionsWithPreparedSamples,
		mySamplesWithPreparedSamples,myWettingLiquidsWithPreparedSamples,validLengths,validLengthTests,
		templatedOptions,templateTests,inheritedOptions,upload,confirm,fastTrack,parentProtocol,cache,
		expandedSafeOps,expandedFiberSamples,expandedWettingLiquids,
		(* Download *)
		immersionContainerOption,immersionContainerObjects,immersionContainerModels,
		inputsInOrderPacket,wettingLiquidsInOrderPacket,inputsContainerInOrderPacket,
		wettingLiquidsContainerInOrderPacket,immersionContainerModelPacket,immersionContainerObjectPacket,
		cacheBall,inputsObjects,wettingLiquidObjects,resolvedOptionsResult,resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,
		returnEarlyQ,performSimulationQ,resourcePackets,resourcePacketTests,simulatedProtocol,simulation,protocolObject
	},
	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Make sure we're working with a list of options and samples, and remove all temporal links *)
	{listedSamplesNamed,listedOptionsNamed}=removeLinks[ToList[mySolidSamples],ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{allPreparedSamples,myOptionsWithPreparedSamplesNamed,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentMeasureContactAngle,
			Join[listedSamplesNamed,ToList[myWettingLiquids]],
			listedOptionsNamed
		],
		$Failed,
		{Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	{mySamplesWithPreparedSamplesNamed,myWettingLiquidsWithPreparedSamplesNamed}=TakeDrop[allPreparedSamples,Length[listedSamplesNamed]];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentMeasureContactAngle,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentMeasureContactAngle,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOpsNamed,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->safeOpsTests,
			Options->$Failed,
			Preview->Null,
			Simulation->Null
		}]
	];

	(* Combined the samples to be sent to the sanitizeInput function*)
	combinedNamedSamples=Join[mySamplesWithPreparedSamplesNamed,myWettingLiquidsWithPreparedSamplesNamed];

	(* Replace all objects referenced by Name to ID *)
	{combinedSamples,{safeOps,myOptionsWithPreparedSamples}}=sanitizeInputs[combinedNamedSamples,{safeOpsNamed,myOptionsWithPreparedSamplesNamed}];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->safeOpsTests,
			Options->$Failed,
			Preview->Null,
			Simulation->Null
		}]
	];

	(* Separate them into fiber and wetting liquid samples*)
	{mySamplesWithPreparedSamples,myWettingLiquidsWithPreparedSamples}=TakeList[combinedSamples,{Length[mySamplesWithPreparedSamplesNamed],Length[myWettingLiquidsWithPreparedSamplesNamed]}];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentMeasureContactAngle,{mySamplesWithPreparedSamples,myWettingLiquidsWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentMeasureContactAngle,{mySamplesWithPreparedSamples,myWettingLiquidsWithPreparedSamples},myOptionsWithPreparedSamples],Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests],
			Options->$Failed,
			Preview->Null,
			Simulation->Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentMeasureContactAngle,{mySamplesWithPreparedSamples,myWettingLiquidsWithPreparedSamples},ToList[myOptionsWithPreparedSamples],Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentMeasureContactAngle,{mySamplesWithPreparedSamples,myWettingLiquidsWithPreparedSamples},ToList[myOptionsWithPreparedSamples]],Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests],
			Options->$Failed,
			Preview->Null,
			Simulation->Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions=ReplaceRule[safeOps,templatedOptions];

	(* get assorted hidden options *)
	{upload,confirm,fastTrack,parentProtocol,cache}=Lookup[inheritedOptions,{Upload,Confirm,FastTrack,ParentProtocol,Cache}];

	(* Expand index-matching options and secondary input (the primary antibodies) *)
	{{expandedFiberSamples,expandedWettingLiquids},expandedSafeOps}=ExpandIndexMatchedInputs[ExperimentMeasureContactAngle,{mySamplesWithPreparedSamples,myWettingLiquidsWithPreparedSamples},inheritedOptions];


	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
	immersionContainerOption=Lookup[expandedSafeOps,ImmersionContainer];
	immersionContainerObjects=Cases[immersionContainerOption,ObjectP[Object[Container,Vessel]]];
	immersionContainerModels=Cases[immersionContainerOption,ObjectP[Model[Container,Vessel]]];

	{
		inputsInOrderPacket,
		wettingLiquidsInOrderPacket,
		inputsContainerInOrderPacket,
		wettingLiquidsContainerInOrderPacket,
		immersionContainerObjectPacket,
		immersionContainerModelPacket
	}=Quiet[
		Download[
			{
				expandedFiberSamples,
				expandedWettingLiquids,
				expandedFiberSamples,
				expandedWettingLiquids,
				immersionContainerObjects,
				immersionContainerModels
			},
			{
				(* Get input and wetting liquid objects *)
				{Packet[Name,Status,State,Container,FiberCircumference,WettedLength,Count]},
				{Packet[Name,Status,State,Container,SurfaceTension]},
				{Packet[Container[Name,Model]]},
				{Packet[Container[Name,Model]]},
				{Packet[Model[Name,MaxVolume,InternalDepth,InternalDiameter]]},
				{Packet[Name,MaxVolume,InternalDepth,InternalDiameter]}
			},
			Cache->cache,
			Simulation->updatedSimulation,
			Date->Now
		],
		{Download::FieldDoesntExist,Download::NotLinkField}
	];

	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
	cacheBall=FlattenCachePackets[{
		cache,
		{
			(* Make sure this list is the same as in Download *)
			inputsInOrderPacket,
			wettingLiquidsInOrderPacket,
			inputsContainerInOrderPacket,
			wettingLiquidsContainerInOrderPacket,
			immersionContainerObjectPacket,
			immersionContainerModelPacket
		}
	}];

	(* Make lists of the inputs and antibodies by Object ID to pass to the helper functions *)
	inputsObjects=Lookup[Flatten[inputsInOrderPacket],Object];
	wettingLiquidObjects=Lookup[Flatten[wettingLiquidsInOrderPacket],Object];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentMeasureContactAngleOptions[
			inputsObjects,
			wettingLiquidObjects,
			expandedSafeOps,
			Cache->cacheBall,
			Simulation->updatedSimulation,
			Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentMeasureContactAngleOptions[inputsObjects,wettingLiquidObjects,expandedSafeOps,Cache->cacheBall(* TODO: add simulation back? *)],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions=CollapseIndexMatchedOptions[
		ExperimentMeasureContactAngle,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentMeasureContactAngle,collapsedResolvedOptions],
			Preview->Null
		}]
	];


	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ=Which[
		MatchQ[resolvedOptionsResult,$Failed],True,
		gatherTests,Not[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,Verbose->False,OutputFormat->SingleBoolean]],
		True,False
	];

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	performSimulationQ=MemberQ[output,Simulation]||MatchQ[$CurrentSimulation,SimulationP];

	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	If[returnEarlyQ&&!performSimulationQ,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentMeasureContactAngle,collapsedResolvedOptions],
			Preview->Null,
			Simulation->Simulation[]
		}]
	];

	(* Build packets with resources *)
	(* NOTE: Don't actually run our resource packets function if there was a problem with our option resolving. *)
	{resourcePackets,resourcePacketTests}=If[returnEarlyQ,
		{$Failed,{}},
		If[gatherTests,
			experimentMeasureContactAngleResourcePackets[
				ToList[mySamplesWithPreparedSamples],
				ToList[myWettingLiquidsWithPreparedSamples],
				expandedSafeOps,
				resolvedOptions,
				Cache->cacheBall,
				Simulation->updatedSimulation,
				Output->{Result,Tests}
			],
			{
				experimentMeasureContactAngleResourcePackets[
					ToList[mySamplesWithPreparedSamples],
					ToList[myWettingLiquidsWithPreparedSamples],
					expandedSafeOps,
					resolvedOptions,
					Cache->cacheBall,
					Simulation->updatedSimulation
				],
				{}
			}
		]
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol,simulation}=If[performSimulationQ,
		simulateExperimentMeasureContactAngle[
			resourcePackets,
			ToList[mySamplesWithPreparedSamples],
			ToList[myWettingLiquidsWithPreparedSamples],
			resolvedOptions,
			Cache->cacheBall,
			Simulation->updatedSimulation],
		{Null,Null}
	];

	(* If Result does not exist in the output, return everything without uploading *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result->Null,
			Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options->RemoveHiddenOptions[ExperimentMeasureContactAngle,collapsedResolvedOptions],
			Preview->Null,
			Simulation->simulation
		}]
	];

	(* We have to return our result. Either return a protocol with a simulated procedure if SimulateProcedure\[Rule]True or return a real protocol that's ready to be run. *)
	protocolObject=Which[
		(* If there was a problem with our resource packets function or option resolver, we can't return a protocol. *)
		MatchQ[resourcePackets,$Failed]||MatchQ[resolvedOptionsResult,$Failed],
		$Failed,

		(* Were we asked to simulate the procedure? *)
		MatchQ[Lookup[safeOps,SimulateProcedure],True],
		measureContactAngleSimulationPackets[
			resourcePackets,
			Upload->Lookup[safeOps,Upload],
			Cache->cacheBall,
			Simulation->updatedSimulation
		],

		(* Otherwise, upload a real protocol that's ready to be run. *)
		True,
		UploadProtocol[
			resourcePackets,
			Upload->Lookup[safeOps,Upload],
			Confirm->Lookup[safeOps,Confirm],
			ParentProtocol->Lookup[safeOps,ParentProtocol],
			ConstellationMessage->Object[Protocol,MeasureContactAngle],
			Simulation->updatedSimulation
		]
	];

	(* Return requested output *)
	outputSpecification/.{
		Result->protocolObject,
		Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests(*,resourcePacketTests*)}],
		Options->RemoveHiddenOptions[ExperimentMeasureContactAngle,collapsedResolvedOptions],
		Preview->Null
	}
];

(* Container overload *)
ExperimentMeasureContactAngle[
	myFiberSampleContainers:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],
	myWettingLiquidContainers:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],
	myOptions:OptionsPattern[]
]:=Module[
	{listedFiberContainers,listedLiquidContainers,listedOptions,outputSpecification,output,gatherTests,validFiberSamplePreparationResult,validLiquidSamplePreparationResult,myFiberSamplesWithPreparedSamples,myLiquidSamplesWithPreparedSamples,myOptionsWithPreparedFiberSamples,myOptionsWithPreparedLiquidSamples,
		updatedSimulation,containerToFiberSampleResult,containerToLiquidSampleResult,containerToFiberSampleOutput,containerToLiquidSampleOutput,containerToLiquidSampleTests,fiberSamples,wettingLiquids,sampleOptions,containerToFiberSampleTests},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Remove temporal links. *)
	{listedFiberContainers,listedOptions}=removeLinks[ToList[myFiberSampleContainers],ToList[myOptions]];
	{listedLiquidContainers,listedOptions}=removeLinks[ToList[myWettingLiquidContainers],ToList[myOptions]];

	(* First, simulate our sample preparation. *)
	validFiberSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{myFiberSamplesWithPreparedSamples,myOptionsWithPreparedFiberSamples,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentMeasureContactAngle,
			listedFiberContainers,
			listedOptions
		],
		$Failed,
		{Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	validLiquidSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{myLiquidSamplesWithPreparedSamples,myOptionsWithPreparedLiquidSamples,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentMeasureContactAngle,
			listedLiquidContainers,
			listedOptions
		],
		$Failed,
		{Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validFiberSamplePreparationResult,$Failed]||MatchQ[validLiquidSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToFiberSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToFiberSampleOutput,containerToFiberSampleTests}=containerToSampleOptions[
			ExperimentMeasureContactAngle,
			myFiberSamplesWithPreparedSamples,
			myOptionsWithPreparedFiberSamples,
			Output->{Result,Tests},
			Simulation->updatedSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToFiberSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			containerToFiberSampleOutput=containerToSampleOptions[
				ExperimentMeasureContactAngle,
				myFiberSamplesWithPreparedSamples,
				myOptionsWithPreparedFiberSamples,
				Output->Result,
				Simulation->updatedSimulation
			],
			$Failed,
			{Error::EmptyContainer}
		]
	];

	containerToLiquidSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToLiquidSampleOutput,containerToLiquidSampleTests}=containerToSampleOptions[
			ExperimentMeasureContactAngle,
			myLiquidSamplesWithPreparedSamples,
			myOptionsWithPreparedLiquidSamples,
			Output->{Result,Tests},
			Simulation->updatedSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToLiquidSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			containerToLiquidSampleOutput=containerToSampleOptions[
				ExperimentMeasureContactAngle,
				myLiquidSamplesWithPreparedSamples,
				myOptionsWithPreparedLiquidSamples,
				Output->Result,
				Simulation->updatedSimulation
			],
			$Failed,
			{Error::EmptyContainer}
		]
	];

	(* If we were given an empty container, return early. *)
	If[MatchQ[containerToFiberSampleResult,$Failed]||MatchQ[containerToLiquidSampleResult,$Failed],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification/.{
			Result->$Failed,
			Tests->Join[containerToFiberSampleTests,containerToLiquidSampleTests],
			Options->$Failed,
			Preview->Null
		},
		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{fiberSamples,sampleOptions}=containerToFiberSampleOutput;
		{wettingLiquids,sampleOptions}=containerToLiquidSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentMeasureContactAngle[fiberSamples,wettingLiquids,ReplaceRule[sampleOptions,Simulation->updatedSimulation]]
	]
];


(* ::Subsubsection:: *)
(* resolveExperimentMeasureContactAngleMethod *)


DefineOptions[resolveExperimentMeasureContactAngleMethod,
	SharedOptions :> {
		ExperimentMeasureContactAngle,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

resolveExperimentMeasureContactAngleMethod[
	mySamples: ListableP[Automatic|(ObjectP[{Object[Sample],Object[Container]}])],
	myOptions: OptionsPattern[resolveExperimentMeasureContactAngleMethod]
] := Module[
	{outputSpecification, output, gatherTests, result, tests},


	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	result = Manual;
	tests = {};

	outputSpecification/.{
		Result -> result,
		Tests -> tests
	}
];


(* ::Subsubsection:: *)
(*resolveExperimentMeasureContactAngleOptions*)


DefineOptions[resolveExperimentMeasureContactAngleOptions,
	SharedOptions:>{
		ExperimentMeasureContactAngle,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];


resolveExperimentMeasureContactAngleOptions[
	mySamples:{ObjectP[{Object[Sample],Object[Item,WilhelmyPlate]}]...},
	myWettingLiquids:{ObjectP[{Object[Sample],Model[Sample]}]...},
	myOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[resolveExperimentMeasureContactAngleOptions]
]:=Module[
	{
		outputSpecification,output,gatherTests,messages,warnings,cache,simulation,
		measureContactAngleOptionsAssociation,
		(* Download *)
		fiberSamplePackets,fiberContainerPackets,wettingLiquidPackets,wettingLiquidContainerPackets,cacheBall,fastAssoc,
		(* Input Validation *)
		discardedSamplePackets,discardedInvalidInputs,discardedTest,
		incompatibleFiberSampleInputBools,incompatibleWettingLiquidInputBools,incompatibleFiberSampleInputs,incompatibleWettingLiquidInputs,incompatibleInputs,incompatibleInputsTest,
		missingWettedLengthBools,missingWettedLengthInvalidInputs,missingWettedLengthInvalidInputsTest,
		missingSurfaceTensionBools,missingSurfaceTensionInvalidInputs,missingSurfaceTensionInvalidInputsTest,
		(* Option Precision *)
		contactAngleOptionsChecks,
		contactAnglePrecisions,
		roundedExperimentMeasureContactAngleOptions,
		precisionTests,
		roundedExperimentMeasureContactAngleOptionsList,
		allOptionsRounded,
		(* Conflicting Options *)
		instrument,
		numberOfReplicates,
		temperature,
		numberOfCycles,
		contactDetectionSpeed,
		contactDetectionSensitivity,
		measuringSpeed,
		acquisitionStep,
		startImmersionDepth,
		endImmersionDepth,
		startImmersionDelay,
		endImmersionDelay,
		volume,
		immersionContainer,
		wettedLengthMeasurement,
		wettedLengthMeasurementLiquids,

		validImmersionDepthQ,invalidImmersionDepthOption,validImmersionDepthTest,
		invalidVolumesAndContainers,validVolumeQ,invalidVolumeImmersionContainerOptions,compatibleVolumeImmersionContainerTest,
		invalidDepthsAndContainers,validDepthQ,invalidMaxImmersionDepthContainerOptions,compatibleMaxImmersionDepthContainerTest,
		notEnoughCountSamplesInvalidInputs,measurementCounts,validCountQ,invalidNumberOfReplicatesOptions,compatibleCountNumberOfReplicatesTest,
		mapThreadFriendlyOptions,
		(* ResolvedOption variables *)
		resolvedSampleLabel,
		resolvedSampleContainerLabel,
		resolvedWettingLiquidLabel,
		resolvedWettingLiquidContainerLabel,
		resolvedWettedLengthMeasurement,
		resolvedNumberOfCycles,
		resolvedContactDetectionSpeed,
		resolvedContactDetectionSensitivity,
		resolvedMeasuringSpeed,
		resolvedAcquisitionStep,
		resolvedStartImmersionDepth,
		resolvedEndImmersionDepth,
		resolvedStartImmersionDelay,
		resolvedEndImmersionDelay,
		resolvedTemperature,
		resolvedVolume,
		resolvedImmersionContainer,
		resolvedWettedLengthMeasurementLiquids,
		resolvedFiberSampleHolder,

		baseVolume,
		minRequiredVolume,
		(* Setup our error tracking variables *)
		notEnoughLiquidError,fiberTooThinError,
		(* Miscellaneous options *)
		emailOption,
		uploadOption,
		nameOption,
		confirmOption,
		parentProtocolOption,
		fastTrackOption,
		templateOption,
		samplesInStorageCondition,
		samplesOutStorageCondition,
		operator,
		imageSample,
		measureWeight,
		measureVolume,
		(* Others *)
		invalidInputs,invalidOptions,allTests,resolvedEmail,resolvedPostProcessingOptions,resolvedOptions},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;
	warnings=!gatherTests&&!MatchQ[$ECLApplication,Engine];

	(* Fetch our cache from the parent function. *)
	cache=Lookup[ToList[myResolutionOptions],Cache,{}];
	simulation=Lookup[ToList[myResolutionOptions],Simulation,Null];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	measureContactAngleOptionsAssociation=Association[myOptions];

	(* Extract the packets that we need from our downloaded cache. *)
	fiberSamplePackets=fetchPacketFromCache[#,cache]&/@mySamples;
	fiberContainerPackets=fetchPacketFromCache[Lookup[#,Container],cache]&/@fiberSamplePackets;
	wettingLiquidPackets=fetchPacketFromCache[#,cache]&/@myWettingLiquids;
	wettingLiquidContainerPackets=fetchPacketFromCache[Lookup[#,Container],cache]&/@wettingLiquidPackets;

	(* combine the cache together *)
	(* TODO: this step actually makes no change *)
	cacheBall=FlattenCachePackets[{
		cache,
		fiberSamplePackets,
		fiberContainerPackets,
		wettingLiquidPackets,
		wettingLiquidContainerPackets
	}];
	fastAssoc=makeFastAssocFromCache[cacheBall];

	(* If you have Warning:: messages, do NOT throw them when MatchQ[$ECLApplication,Engine]. Warnings should NOT be surfaced in engine. *)

	(*-- INPUT VALIDATION CHECKS --*)

	(* 1. Discarded Samples *)
	(* Get the samples from mySamples that are discarded. *)
	discardedSamplePackets=Cases[Flatten[Join[fiberSamplePackets,wettingLiquidPackets]],KeyValuePattern[Status->Discarded]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs=If[MatchQ[discardedSamplePackets,{}],
		{},
		Lookup[discardedSamplePackets,Object]
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs]>0&&!gatherTests,
		Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Cache->cache]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				Nothing,
				Test["Input samples "<>ObjectToString[discardedInvalidInputs,Cache->cache]<>" are not discarded:",True,False]
			];

			passingTest=If[Length[discardedInvalidInputs]==Length[mySamples],
				Nothing,
				Test["Input samples "<>ObjectToString[Complement[mySamples,discardedInvalidInputs],Cache->cache]<>" are not discarded:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* 2. Incompatible Samples *)
	(* Get boolean for if the samples are not solid. *)
	incompatibleFiberSampleInputBools=Map[
		!(SameQ[Lookup[#,State],Solid]||SameQ[Lookup[#,Type],Object[Item,WilhelmyPlate]])&,
		fiberSamplePackets
	];

	(* Get boolean for if the wetting liquids are not liquid. *)
	incompatibleWettingLiquidInputBools=Map[
		!SameQ[Lookup[#,State],Liquid]&,
		wettingLiquidPackets
	];

	(* Get the list of non-solid fiber sample . *)
	incompatibleFiberSampleInputs=PickList[Lookup[fiberSamplePackets,Object],incompatibleFiberSampleInputBools];
	(* Get the list of non-liquid. *)
	incompatibleWettingLiquidInputs=PickList[Lookup[wettingLiquidPackets,Object],incompatibleWettingLiquidInputBools];

	incompatibleInputs=Join[incompatibleFiberSampleInputs,incompatibleWettingLiquidInputs];

	(* If there are incompatible samples and we are throwing messages, throw an error message *)
	If[Length[incompatibleInputs]>0&&!gatherTests,
		Message[Error::IncompatibleSample,ObjectToString[incompatibleInputs,Cache->cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	incompatibleInputsTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[incompatibleInputs]==0,
				(* if no sample is incompatible, we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test for all discarded samples *)
				Test["The input sample(s) "<>ObjectToString[incompatibleInputs,Cache->cacheBall]<>" is/are compatible with an available single fiber tensiometer:",True,False]
			];
			passingTest=If[Length[incompatibleInputs]==Length[mySamples]+Length[myWettingLiquids],
				(* if ALL samples are incompatible, we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test for all non-discarded samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[Union[mySamples,myWettingLiquids],incompatibleInputs],Cache->cacheBall]<>" is/are compatible with an available single fiber tensiometer:",True,True]
			];
			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(* 3. Fiber Wetted Length Required *)
	(* Get boolean for if the samples are not fiber. *)
	missingWettedLengthBools=MapThread[
		And[NullQ[Lookup[#1,FiberCircumference]],SameQ[#2,False]] &,
		{fiberSamplePackets,Lookup[myOptions,WettedLengthMeasurement]}
	];

	(* Get the samples that are not fiber. *)
	missingWettedLengthInvalidInputs=PickList[Lookup[fiberSamplePackets,Object],missingWettedLengthBools];

	(* If there are incompatible samples and we are throwing messages, throw an error message *)
	If[Length[missingWettedLengthInvalidInputs]>0&&!gatherTests,
		Message[Error::FiberCircumferenceRequired,ObjectToString[missingWettedLengthInvalidInputs,Cache->cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	missingWettedLengthInvalidInputsTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[missingWettedLengthInvalidInputs]==0,
				(* if no sample is incompatible, we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test for all discarded samples *)
				Test["The input sample(s) "<>ObjectToString[missingWettedLengthInvalidInputs,Cache->cacheBall]<>" has/have FiberCircumference information:",True,False]
			];
			passingTest=If[Length[missingWettedLengthInvalidInputs]==Length[mySamples],
				(* if ALL samples are incompatible, we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test for all non-discarded samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[mySamples,missingWettedLengthInvalidInputs],Cache->cacheBall]<>" has/have FiberCircumference information:",True,True]
			];
			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(* 4. Wetting Liquid Surface Tension Required *)
	missingSurfaceTensionBools=Map[
		NullQ[Lookup[#,SurfaceTension]]&,
		wettingLiquidPackets
	];

	(* Get the samples that are not fiber. *)
	missingSurfaceTensionInvalidInputs=PickList[Lookup[wettingLiquidPackets,Object],missingSurfaceTensionBools];

	(* If there are incompatible samples and we are throwing messages, throw an error message *)
	If[Length[missingSurfaceTensionInvalidInputs]>0&&!gatherTests,
		Message[Warning::SurfaceTensionRequired,ObjectToString[missingSurfaceTensionInvalidInputs,Cache->cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	missingSurfaceTensionInvalidInputsTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[missingSurfaceTensionInvalidInputs]==0,
				(* if no sample is incompatible, we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test for all discarded samples *)
				Test["The input wetting liquid sample(s) "<>ObjectToString[missingSurfaceTensionInvalidInputs,Cache->cacheBall]<>" has/have SurfaceTension information:",True,False]
			];
			passingTest=If[Length[missingSurfaceTensionInvalidInputs]==Length[mySamples],
				(* if ALL samples are incompatible, we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test for all non-discarded samples *)
				Test["The input wetting liquid sample(s) "<>ObjectToString[Complement[mySamples,missingSurfaceTensionInvalidInputs],Cache->cacheBall]<>" has/have SurfaceTension information:",True,True]
			];
			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*-- OPTION PRECISION CHECKS --*)
	contactAngleOptionsChecks={
		(*1*)Temperature,
		(*2*)ContactDetectionSpeed,
		(*3*)MeasuringSpeed,
		(*4*)EndImmersionDepth,
		(*5*)StartImmersionDepth,
		(*6*)EndImmersionDelay,
		(*7*)StartImmersionDelay,
		(*8*)AcquisitionStep
	};

	contactAnglePrecisions={
		(*1*)1*10^-1 Celsius,
		(*2*)1*10^-1 Millimeter/Minute,
		(*3*)1*10^-1 Millimeter/Minute,
		(*4*)1*10^-1 Micrometer,
		(*5*)1*10^-1 Micrometer,
		(*6*)1 Second,
		(*7*)1 Second,
		(*8*)1*10^-6 Meter
	};

	(* Round the options *)
	{roundedExperimentMeasureContactAngleOptions,precisionTests}=If[
		gatherTests,
		RoundOptionPrecision[measureContactAngleOptionsAssociation,contactAngleOptionsChecks,contactAnglePrecisions,Output->{Result,Tests}],
		{RoundOptionPrecision[measureContactAngleOptionsAssociation,contactAngleOptionsChecks,contactAnglePrecisions],Null}
	];

	(* Convert association of rounded options to a list of rules *)
	roundedExperimentMeasureContactAngleOptionsList=Normal[roundedExperimentMeasureContactAngleOptions];

	(* Replace the raw options with rounded values in full set of options, myOptions *)
	allOptionsRounded=ReplaceRule[
		myOptions,
		roundedExperimentMeasureContactAngleOptionsList,
		Append->False
	];

	(*-- CONFLICTING OPTIONS CHECKS --*)
	(* Pull out the defaulted options *)
	instrument=Lookup[allOptionsRounded,Instrument];
	numberOfReplicates=Lookup[allOptionsRounded,NumberOfReplicates]/.Null->1;
	temperature=Lookup[allOptionsRounded,Temperature]/.Ambient->$AmbientTemperature;

	(* Pull out the all unresolved options *)
	{
		wettedLengthMeasurement,
		numberOfCycles,
		contactDetectionSpeed,
		contactDetectionSensitivity,
		measuringSpeed,
		acquisitionStep,
		startImmersionDepth,
		endImmersionDepth,
		startImmersionDelay,
		endImmersionDelay,
		volume,
		immersionContainer,
		wettedLengthMeasurementLiquids
	}=Lookup[allOptionsRounded,
		{
			WettedLengthMeasurement,
			NumberOfCycles,
			ContactDetectionSpeed,
			ContactDetectionSensitivity,
			MeasuringSpeed,
			AcquisitionStep,
			StartImmersionDepth,
			EndImmersionDepth,
			StartImmersionDelay,
			EndImmersionDelay,
			Volume,
			ImmersionContainer,
			WettedLengthMeasurementLiquids
		}];

	(* 1. Is EndImmersionDepth larger than StartImmersionDepth? *)
	MapThread[
		Function[{endDepth,startDepth},
			If[!SameQ[endDepth,Automatic]&&!SameQ[startDepth,Automatic],
				(
					validImmersionDepthQ=If[endDepth>startDepth,
						True,
						False
					];

					(* If validImmersionDepthQ is False and we are throwing messages, throw an error message. *)
					invalidImmersionDepthOption=If[!validImmersionDepthQ&&!gatherTests,
						Message[Error::InvalidImmersionDepths,endDepth,startDepth];{endDepth,startDepth},
						{}
					];

					(* Generate test for immersion depth check *)
					validImmersionDepthTest=If[gatherTests,
						Test["If specified, EndImmersionDepth must be larger than StartImmersionDepth:",
							validImmersionDepthQ,
							True
						],
						Nothing
					];
				),
				invalidImmersionDepthOption=Nothing;
				validImmersionDepthTest=Nothing;
			]
		],
		{endImmersionDepth,startImmersionDepth}
	];

	(* 2. Is Volume larger than the MaxVolume of ImmersionContainer? *)
	invalidVolumesAndContainers={};
	validVolumeQ=!MemberQ[
		MapThread[
			Function[{vol,immCont},
				Module[
					{maxVol},
					If[!SameQ[vol,Automatic]&&!SameQ[immCont,Automatic],
						maxVol=Lookup[fetchPacketFromFastAssoc[immCont,fastAssoc],MaxVolume];
						If[vol<=maxVol,
							True,
							AppendTo[invalidVolumesAndContainers,{vol,immCont,maxVol}];False
						],
						True
					]
				]
			],
			{volume,immersionContainer}
		],
		False];

	(* If validVolumeQ is False and we are throwing messages, throw an error message. *)
	invalidVolumeImmersionContainerOptions=If[!validVolumeQ&&!gatherTests,
		Message[Error::InvalidVolume,invalidVolumesAndContainers[[All,1]],invalidVolumesAndContainers[[All,3]],ObjectToString[invalidVolumesAndContainers[[All,2]]]];invalidVolumesAndContainers[[All,1;;2]],
		{}
	];

	(* Generate test for immersion depth check *)
	compatibleVolumeImmersionContainerTest=If[gatherTests,
		Test["If specified, Volume is smaller than the maximum volume of immersion container:",
			validVolumeQ,
			True
		],
		Nothing
	];

	(* 3. Is EndImmersionDepth larger than the depth of ImmersionContainer? *)
	invalidDepthsAndContainers={};
	validDepthQ=!MemberQ[
		MapThread[
			Function[{endDepth,immCont},
				Module[
					{maxDepth},
					If[!SameQ[endDepth,Automatic]&&!SameQ[immCont,Automatic],
						maxDepth=Lookup[fetchPacketFromFastAssoc[immCont,fastAssoc],InternalDepth];
						If[endDepth<=maxDepth,
							True,
							AppendTo[invalidDepthsAndContainers,{endDepth,immCont,maxDepth}];False
						],
						True
					]
				]
			],
			{endImmersionDepth,immersionContainer}
		],
		False];

	(* If validVolumeQ is False and we are throwing messages, throw an error message. *)
	invalidMaxImmersionDepthContainerOptions=If[!validDepthQ&&!gatherTests,
		Message[Error::InvalidDepth,invalidDepthsAndContainers[[All,1]],invalidDepthsAndContainers[[All,3]],ObjectToString[invalidDepthsAndContainers[[All,2]]]];invalidDepthsAndContainers[[All,1;;2]],
		{}
	];

	(* Generate test for immersion depth check *)
	compatibleMaxImmersionDepthContainerTest=If[gatherTests,
		Test["If specified, EndImmersionDepth is smaller than the internal depth of immersion container:",
			validDepthQ,
			True
		],
		Nothing
	];

	(* 4. Do we have enough sample counts for all measurement, accounting number of replicates? *)
	notEnoughCountSamplesInvalidInputs={};
	measurementCounts=Counts[mySamples]*numberOfReplicates;
	validCountQ=!MemberQ[
		Map[
			Function[{sample},
				Module[
					{count,measurementNumber},
					count=Lookup[fetchPacketFromFastAssoc[sample,fastAssoc],Count];
					measurementNumber=Lookup[measurementCounts,sample];
					If[count>=measurementNumber,
						True,
						DeleteDuplicates[AppendTo[notEnoughCountSamplesInvalidInputs,sample]];False
					]
				]
			],
			mySamples
		],
		False
	];

	(* If validCountQ is False and we are throwing messages, throw an error message. *)
	invalidNumberOfReplicatesOptions=If[!validCountQ&&!gatherTests,
		Message[Error::InvalidCount,notEnoughCountSamplesInvalidInputs];notEnoughCountSamplesInvalidInputs,
		{}
	];

	(* Generate test for immersion depth check *)
	compatibleCountNumberOfReplicatesTest=If[gatherTests,
		Test["Current Count of each SamplesIn should be larger than the number of measurements will be carried out accounting of NumberOfReplicates:",
			validCountQ,
			True
		],
		Nothing
	];

	(*-- RESOLVE EXPERIMENT OPTIONS --*)
	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentMeasureContactAngle,allOptionsRounded];

	(* Resolve master switches *)
	(* Independent options resolution *)
	{
		resolvedSampleLabel,
		resolvedSampleContainerLabel,
		resolvedWettingLiquidLabel,
		resolvedWettingLiquidContainerLabel,
		resolvedWettedLengthMeasurement,
		resolvedNumberOfCycles,
		resolvedContactDetectionSpeed,
		resolvedContactDetectionSensitivity,
		resolvedMeasuringSpeed,
		resolvedAcquisitionStep,
		resolvedStartImmersionDepth,
		resolvedEndImmersionDepth,
		resolvedStartImmersionDelay,
		resolvedEndImmersionDelay,
		resolvedVolume,
		resolvedImmersionContainer,
		resolvedWettedLengthMeasurementLiquids,
		resolvedFiberSampleHolder,
		(* Set up error tracking booleans*)
		notEnoughLiquidError,
		fiberTooThinError
	}=Transpose[MapThread[
		Function[
			{mtFiberPacket,mtFiberContainerPacket,mtWettingLiquidPacket,mtWettingLiquidContainerPacket,mtOption},

			Module[
				{
					(* Unresolved single option *)
					mtUnresolvedSampleLabel,
					mtUnresolvedSampleContainerLabel,
					mtUnresolvedWettingLiquidLabel,
					mtUnresolvedWettingLiquidContainerLabel,
					mtUnresolvedWettedLengthMeasurement,
					mtUnresolvedNumberOfCycles,
					mtUnresolvedContactDetectionSpeed,
					mtUnresolvedContactDetectionSensitivity,
					mtUnresolvedMeasuringSpeed,
					mtUnresolvedAcquisitionStep,
					mtUnresolvedStartImmersionDepth,
					mtUnresolvedEndImmersionDepth,
					mtUnresolvedStartImmersionDelay,
					mtUnresolvedEndImmersionDelay,
					mtUnresolvedTemperature,
					mtUnresolvedVolume,
					mtUnresolvedImmersionContainer,
					mtUnresolvedWettedLengthMeasurementLiquids,
					mtUnresolvedFiberSampleHolder,
					(* Resolved single option *)
					mtResolvedSampleLabel,
					mtResolvedSampleContainerLabel,
					mtResolvedWettingLiquidLabel,
					mtResolvedWettingLiquidContainerLabel,
					mtResolvedWettedLengthMeasurement,
					mtResolvedNumberOfCycles,
					mtResolvedContactDetectionSpeed,
					mtResolvedContactDetectionSensitivity,
					mtResolvedMeasuringSpeed,
					mtResolvedAcquisitionStep,
					mtResolvedStartImmersionDepth,
					mtResolvedEndImmersionDepth,
					mtResolvedStartImmersionDelay,
					mtResolvedEndImmersionDelay,
					mtResolvedVolume,
					mtResolvedImmersionContainer,
					mtResolvedWettedLengthMeasurementLiquids,
					mtResolvedFiberSampleHolder,
					(* Set up error tracking booleans*)
					mtNotEnoughLiquidError,
					mtFiberTooThinError,
					(* Others *)
					circumferenceLookup,
					immersionContainerPacket
				},

				(* Setup our error tracking variables *)
				{mtNotEnoughLiquidError,mtFiberTooThinError}=ConstantArray[False,2];

				{
					mtUnresolvedSampleLabel,
					mtUnresolvedSampleContainerLabel,
					mtUnresolvedWettingLiquidLabel,
					mtUnresolvedWettingLiquidContainerLabel,
					mtUnresolvedWettedLengthMeasurement,
					mtUnresolvedNumberOfCycles,
					mtUnresolvedContactDetectionSpeed,
					mtUnresolvedContactDetectionSensitivity,
					mtUnresolvedMeasuringSpeed,
					mtUnresolvedAcquisitionStep,
					mtUnresolvedStartImmersionDepth,
					mtUnresolvedEndImmersionDepth,
					mtUnresolvedStartImmersionDelay,
					mtUnresolvedEndImmersionDelay,
					mtUnresolvedTemperature,
					mtUnresolvedVolume,
					mtUnresolvedImmersionContainer,
					mtUnresolvedWettedLengthMeasurementLiquids,
					mtUnresolvedFiberSampleHolder
				}=Lookup[mtOption,
					{
						SampleLabel,
						SampleContainerLabel,
						WettingLiquidLabel,
						WettingLiquidContainerLabel,
						WettedLengthMeasurement,
						NumberOfCycles,
						ContactDetectionSpeed,
						ContactDetectionSensitivity,
						MeasuringSpeed,
						AcquisitionStep,
						StartImmersionDepth,
						EndImmersionDepth,
						StartImmersionDelay,
						EndImmersionDelay,
						Temperature,
						Volume,
						ImmersionContainer,
						WettedLengthMeasurementLiquids,
						FiberSampleHolder
					}
				];

				(* resolve the label options *)
				(* for Sample/ContainerLabel options, automatically resolve to Null *)
				(* NOTE: We use the simulated object IDs here to help generate the labels so we don't spin off a million *)
				(* labels if we have duplicates. *)
				mtResolvedSampleLabel=Which[
					Not[MatchQ[mtUnresolvedSampleLabel,Automatic]],mtUnresolvedSampleLabel,
					MatchQ[simulation,SimulationP]&&MemberQ[Lookup[simulation[[1]],Labels][[All,2]],Lookup[mtFiberPacket,Object]],
					Lookup[Reverse/@Lookup[simulation[[1]],Labels],Lookup[mtFiberPacket,Object]],
					True,"Single fiber "<>StringDrop[Lookup[mtFiberPacket,ID],3]
				];
				mtResolvedSampleContainerLabel=Which[
					SameQ[Lookup[mtFiberPacket,Type],Object[Item,WilhelmyPlate]],Null,
					Not[MatchQ[mtUnresolvedSampleContainerLabel,Automatic]],mtUnresolvedSampleContainerLabel,
					MatchQ[simulation,SimulationP]&&MemberQ[Lookup[simulation[[1]],Labels][[All,2]],Lookup[mtFiberContainerPacket,Object]],
					Lookup[Reverse/@Lookup[simulation[[1]],Labels],Lookup[mtFiberContainerPacket,Object]],
					True,"Single fiber container "<>StringDrop[Lookup[mtFiberContainerPacket,ID],3]
				];
				mtResolvedWettingLiquidLabel=Which[
					Not[MatchQ[mtUnresolvedWettingLiquidLabel,Automatic]],mtUnresolvedWettingLiquidLabel,
					MatchQ[simulation,SimulationP]&&MemberQ[Lookup[simulation[[1]],Labels][[All,2]],Lookup[mtWettingLiquidPacket,Object]],
					Lookup[Reverse/@Lookup[simulation[[1]],Labels],Lookup[mtWettingLiquidPacket,Object]],
					True,"Wetting liquid "<>StringDrop[Lookup[mtWettingLiquidPacket,ID],3]
				];
				mtResolvedWettingLiquidContainerLabel=Which[
					Not[MatchQ[mtUnresolvedWettingLiquidContainerLabel,Automatic]],mtUnresolvedWettingLiquidContainerLabel,
					MatchQ[simulation,SimulationP]&&MemberQ[Lookup[simulation[[1]],Labels][[All,2]],Lookup[mtWettingLiquidContainerPacket,Object]],
					Lookup[Reverse/@Lookup[simulation[[1]],Labels],Lookup[mtWettingLiquidContainerPacket,Object]],
					SameQ[mtWettingLiquidContainerPacket,<||>],"Wetting liquid container for "<>StringDrop[Lookup[mtWettingLiquidPacket,ID],3],
					True,"Wetting liquid container "<>StringDrop[Lookup[mtWettingLiquidContainerPacket,ID],3]
				];

				(* WettedLengthMeasurement *)
				mtResolvedWettedLengthMeasurement=If[SameQ[mtUnresolvedWettedLengthMeasurement,Automatic],
					(
						circumferenceLookup=If[SameQ[Lookup[mtFiberPacket,Type],Object[Item,WilhelmyPlate]],
							Lookup[mtFiberPacket,WettedLength],
							Lookup[mtFiberPacket,FiberCircumference]
						];
						Which[
							(* Resolve to True if the FiberCircumference of fiber or WettedLength of Wilhelmy plate is unknown *)
							NullQ[circumferenceLookup],True,
							(* Track error if the FiberCircumference of fiber is smaller than 5 micrometer *)
							circumferenceLookup<5 Micrometer,mtFiberTooThinError=True,
							(* Otherwise, resolve to False *)
							True,False
						]
					),
					(* Resolve it to user-specified value *)
					mtUnresolvedWettedLengthMeasurement
				];

				(* NumberOfCycles *)
				mtResolvedNumberOfCycles=If[SameQ[mtUnresolvedNumberOfCycles,Automatic],
					(* Simply resolved to 1 *)
					1,
					(* Resolve it to user-specified value *)
					mtUnresolvedNumberOfCycles
				];

				(* ContactDetectionSpeed *)
				mtResolvedContactDetectionSpeed=If[SameQ[mtUnresolvedContactDetectionSpeed,Automatic],
					(* Simply resolved to 6 Millimeter/Minute *)
					6 Millimeter/Minute,
					(* Resolve it to user-specified value *)
					mtUnresolvedContactDetectionSpeed
				];

				(* ContactDetectionSensitivity *)
				mtResolvedContactDetectionSensitivity=If[SameQ[mtUnresolvedContactDetectionSensitivity,Automatic],
					(* Simply resolved to 0.0001 Gram *)
					0.0001 Gram,
					(* Resolve it to user-specified value *)
					mtUnresolvedContactDetectionSensitivity
				];

				(* MeasuringSpeed *)
				mtResolvedMeasuringSpeed=If[SameQ[mtUnresolvedMeasuringSpeed,Automatic],
					(* Simply resolved to 3 Millimeter/Minute *)
					3 Millimeter/Minute,
					(* Resolve it to user-specified value *)
					mtUnresolvedMeasuringSpeed
				];

				(* AcquisitionStep *)
				mtResolvedAcquisitionStep=If[SameQ[mtUnresolvedAcquisitionStep,Automatic],
					(* Simply resolved to 0.2 Millimeter *)
					0.2 Millimeter,
					(* Resolve it to user-specified value *)
					mtUnresolvedAcquisitionStep
				];

				(* StartImmersionDepth *)
				mtResolvedStartImmersionDepth=If[SameQ[mtUnresolvedStartImmersionDepth,Automatic],
					(* Simply resolved to 1 Millimeter *)
					1 Millimeter,
					(* Resolve it to user-specified value *)
					mtUnresolvedStartImmersionDepth
				];

				(* EndImmersionDepth *)
				mtResolvedEndImmersionDepth=If[SameQ[mtUnresolvedEndImmersionDepth,Automatic],
					(* Resolve to the sum of 25 AcquisitionStep or 5 Millimeter, whichever is smaller *)
					If[mtResolvedAcquisitionStep>0.2 Millimeter,
						5 Millimeter,
						25*mtResolvedAcquisitionStep
					],
					(* Resolve it to user-specified value *)
					mtUnresolvedEndImmersionDepth
				];

				(* StartImmersionDelay *)
				mtResolvedStartImmersionDelay=If[SameQ[mtUnresolvedStartImmersionDelay,Automatic],
					(* Simply resolved to 1 second *)
					1 Second,
					(* Resolve it to user-specified value *)
					mtUnresolvedStartImmersionDelay
				];

				(* EndImmersionDelay *)
				mtResolvedEndImmersionDelay=If[SameQ[mtUnresolvedEndImmersionDelay,Automatic],
					(* Simply resolved to 1 second *)
					1 Second,
					(* Resolve it to user-specified value *)
					mtUnresolvedEndImmersionDelay
				];


				(* Volume *)
				(* ImmersionContainer *)
				{mtResolvedVolume,mtResolvedImmersionContainer}=Which[
					(* 1 *)
					And[SameQ[mtUnresolvedVolume,Automatic],SameQ[mtUnresolvedImmersionContainer,Automatic]],
					(* TODO: change to resolution based on lookup remaining volume of liquid sample *)
					{87 Milliliter, Model[Container, Vessel, "id:xRO9n3BadnZO"]},(* 2.5 cm of liquid height with Model[Container,Vessel,"Kruss SV20 glass sample vessel"]*)
					(* 2 *)
					And[!SameQ[mtUnresolvedVolume,Automatic],SameQ[mtUnresolvedImmersionContainer,Automatic]],
					{
						mtUnresolvedVolume,
						If[mtUnresolvedVolume>=40 Milliliter,
							Model[Container, Vessel, "id:xRO9n3BadnZO"], (* Model[Container,Vessel,"Kruss SV20 glass sample vessel"] *)
							Model[Container, Vessel, "id:mnk9jORZBj8Y"] (* Model[Container,Vessel,"Kruss SV10 glass sample vessel"] *)
						]
					},
					(* 3 *)
					And[SameQ[mtUnresolvedVolume,Automatic],!SameQ[mtUnresolvedImmersionContainer,Automatic]],
					(
						immersionContainerPacket=SelectFirst[cacheBall,MatchQ[#[Object],ObjectP[mtUnresolvedImmersionContainer]]&];
						(* Base Volume (in milliliter) is the manufacturer-suggested minimal volume for 0 immersion depth. *)
						baseVolume=Which[
							SameQ[Lookup[immersionContainerPacket,Name],"Kruss SV20 glass sample vessel"],28 Milliliter,
							SameQ[Lookup[immersionContainerPacket,Name],"Kruss SV10 glass sample vessel"],12 Milliliter
						];
						(* Minimal required volume could be calculated from max immersion depth and container diameter on top of base volume. *)
						minRequiredVolume=mtResolvedEndImmersionDepth*(Lookup[immersionContainerPacket,InternalDiameter]/2)^2*Pi+baseVolume;
						{minRequiredVolume,mtUnresolvedImmersionContainer}
					),
					(* 4 *)
					And[!SameQ[mtUnresolvedVolume,Automatic],!SameQ[mtUnresolvedImmersionContainer,Automatic]],
					(
						immersionContainerPacket=SelectFirst[cacheBall,MatchQ[#[Object],ObjectP[mtUnresolvedImmersionContainer]]&];
						(* Base Volume  (in milliliter) is the manufacturer-suggested minimal volume for 0 immersion depth. *)
						baseVolume=Which[
							SameQ[Lookup[immersionContainerPacket,Name],"Kruss SV20 glass sample vessel"],28 Milliliter,
							SameQ[Lookup[immersionContainerPacket,Name],"Kruss SV10 glass sample vessel"],12 Milliliter
						];
						(* Minimal required volume could be calculated from max immersion depth and container diameter on top of base volume. *)
						minRequiredVolume=mtResolvedEndImmersionDepth*(Lookup[immersionContainerPacket,InternalDiameter]/2)^2*Pi+baseVolume;
						If[mtUnresolvedVolume>minRequiredVolume,
							{mtUnresolvedVolume,mtUnresolvedImmersionContainer},
							notEnoughLiquidError==True;{mtUnresolvedVolume,mtUnresolvedImmersionContainer}
						]
					)
				];

				(* Liquids, Volume, ImmersionContainer for WettedLengthMeasurement *)
				mtResolvedWettedLengthMeasurementLiquids=If[SameQ[mtResolvedWettedLengthMeasurement,False],
					Null,
					If[SameQ[mtUnresolvedWettedLengthMeasurementLiquids,Automatic],
						(* Simply resolved Hexanes *)
						Model[Sample, "id:1ZA60vwjbb5E"], (* "Hexanes" *)
						(* Resolve it to user-specified value *)
						mtUnresolvedWettedLengthMeasurementLiquids
					]
				];

				(* Fiber Sample Holder *)
				mtResolvedFiberSampleHolder=Which[
					SameQ[Lookup[mtFiberPacket,Object],Object[Item,WilhelmyPlate,"id:wqW9BPWEV66O"]],Null,(* "Kruss standard plate" *)
					(* Simply resolved sticky-head fiber sample holder *)
					SameQ[mtUnresolvedFiberSampleHolder,Automatic],Model[Container,FiberSampleHolder,"id:KBL5DvLrRkda"],(* "Kruss single fiber sample holder" *)
					(* Otherwise, resolve it to user-specified value *)
					True,mtUnresolvedFiberSampleHolder
				];

				(* Gather MapThread results *)
				{
					(* Resolved options *)
					mtResolvedSampleLabel,
					mtResolvedSampleContainerLabel,
					mtResolvedWettingLiquidLabel,
					mtResolvedWettingLiquidContainerLabel,
					mtResolvedWettedLengthMeasurement,
					mtResolvedNumberOfCycles,
					mtResolvedContactDetectionSpeed,
					mtResolvedContactDetectionSensitivity,
					mtResolvedMeasuringSpeed,
					mtResolvedAcquisitionStep,
					mtResolvedStartImmersionDepth,
					mtResolvedEndImmersionDepth,
					mtResolvedStartImmersionDelay,
					mtResolvedEndImmersionDelay,
					mtResolvedVolume,
					mtResolvedImmersionContainer,
					mtResolvedWettedLengthMeasurementLiquids,
					mtResolvedFiberSampleHolder,
					(* Set up error tracking booleans*)
					mtNotEnoughLiquidError,
					mtFiberTooThinError
				}
			]
		],
		{fiberSamplePackets,fiberContainerPackets,wettingLiquidPackets,wettingLiquidContainerPackets,mapThreadFriendlyOptions}
	]];

	(*-- UNRESOLVABLE OPTION CHECKS --*)
	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[
		Flatten[{
			discardedInvalidInputs,
			incompatibleInputs,
			missingWettedLengthInvalidInputs,
			notEnoughCountSamplesInvalidInputs
		}]
	];
	invalidOptions=DeleteDuplicates[
		Flatten[{
			invalidImmersionDepthOption,
			invalidVolumeImmersionContainerOptions,
			invalidMaxImmersionDepthContainerOptions
		}]
	];

	(* Pull out miscellaneous options *)
	{
		emailOption,
		uploadOption,
		nameOption,
		confirmOption,
		parentProtocolOption,
		fastTrackOption,
		templateOption,
		samplesInStorageCondition,
		samplesOutStorageCondition,
		operator,
		imageSample,
		measureWeight,
		measureVolume
	}=Lookup[
		allOptionsRounded,
		{
			Email,
			Upload,
			Name,
			Confirm,
			ParentProtocol,
			FastTrack,
			Template,
			SamplesInStorageCondition,
			SamplesOutStorageCondition,
			Operator,
			ImageSample,
			MeasureWeight,
			MeasureVolume
		}
	];

	(* Resolve email option *)
	resolvedEmail=If[!MatchQ[emailOption,Automatic],
		(* If email is specified, use the supplied value *)
		emailOption,

		(*If both upload->true and result is a member of output, send emails. Otherwise, do not send emails. *)
		If[And[uploadOption,MemberQ[output,Result]],
			True,
			False
		]
	];

	(*-- Resolve Post Processing Options: ImageSample, MeasureVolume, and MeasureWeight --*)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

	allTests=Flatten[{
		(* Invalid input tests *)
		discardedTest,incompatibleInputsTest,missingWettedLengthInvalidInputsTest,
		(* Precision tests *)
		precisionTests,
		(* Conflicting options tests *)
		validImmersionDepthTest,compatibleVolumeImmersionContainerTest,compatibleMaxImmersionDepthContainerTest,compatibleCountNumberOfReplicatesTest
	}];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->cache]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	(*-- CONTAINER GROUPING RESOLUTION --*)
	(* Resolve RequiredAliquotContainers *)
	(* targetContainers={ *)
	(* targetContainers is in the form {(Null|ObjectP[Model[Container]])..} and is index-matched to simulatedSamples. *)
	(* When you do not want an aliquot to happen for the corresponding simulated sample, make the corresponding index of targetContainers Null. *)
	(* Otherwise, make it the Model[Container] that you want to transfer the sample into. *)
	(* }; *)

	resolvedOptions=ReplaceRule[
		allOptionsRounded,
		Join[
			resolvedPostProcessingOptions,
			{
				Instrument->instrument,
				NumberOfReplicates->numberOfReplicates,
				SampleLabel->resolvedSampleLabel,
				SampleContainerLabel->resolvedSampleContainerLabel,
				WettingLiquidLabel->resolvedWettingLiquidLabel,
				WettingLiquidContainerLabel->resolvedWettingLiquidContainerLabel,
				WettedLengthMeasurement->resolvedWettedLengthMeasurement,
				NumberOfCycles->resolvedNumberOfCycles,
				ContactDetectionSpeed->resolvedContactDetectionSpeed,
				ContactDetectionSensitivity->resolvedContactDetectionSensitivity,
				MeasuringSpeed->resolvedMeasuringSpeed,
				AcquisitionStep->resolvedAcquisitionStep,
				StartImmersionDepth->resolvedStartImmersionDepth,
				EndImmersionDepth->resolvedEndImmersionDepth,
				StartImmersionDelay->resolvedStartImmersionDelay,
				EndImmersionDelay->resolvedEndImmersionDelay,
				Temperature->temperature,
				Volume->resolvedVolume,
				ImmersionContainer->resolvedImmersionContainer,
				WettedLengthMeasurementLiquids->resolvedWettedLengthMeasurementLiquids,
				FiberSampleHolder->resolvedFiberSampleHolder,

				Email->resolvedEmail,
				Upload->uploadOption,
				Name->nameOption,
				Confirm->confirmOption,
				ParentProtocol->parentProtocolOption,
				FastTrack->fastTrackOption,
				Template->templateOption,
				SamplesInStorageCondition->samplesInStorageCondition,
				SamplesOutStorageCondition->samplesOutStorageCondition,
				Operator->operator,
				ImageSample->imageSample,
				MeasureWeight->measureWeight,
				MeasureVolume->measureVolume,
				Preparation->Manual
			}
		],
		Append->False
	];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result->resolvedOptions,
		Tests->allTests
	}
];


(* ::Subsubsection:: *)
(* experimentMeasureContactAngleResourcePackets *)


DefineOptions[experimentMeasureContactAngleResourcePackets,
	Options:>{OutputOption,CacheOption,SimulationOption}
];


experimentMeasureContactAngleResourcePackets[
	mySamples:{ObjectP[{Object[Sample],Object[Item,WilhelmyPlate]}]..},
	myWettingLiquids:{ObjectP[{Object[Sample],Model[Sample]}]..},
	myUnresolvedOptions:{_Rule..},
	myResolvedOptions:{_Rule..},
	myOptions:OptionsPattern[]
]:=Module[
	{
		expandedSampleInputs,expandedWettingLiquidInputs,expandedResolvedOptions,resolvedOptionsNoHidden,outputSpecification,output,gatherTests,messages,inheritedCache,
		sampleDownload,sampleContainerDownload,wettingLiquidDownload,sampleContainerDownloadWithNumReplicates,samplePackets,wettingLiquidPackets,sampleContainerObjects,

		expandedSampleLabel,
		expandedSampleContainerLabel,
		instrument,
		numberOfReplicates,
		expandedWettedLengthMeasurement,
		expandedNumberOfCycles,
		expandedContactDetectionSpeed,
		expandedContactDetectionSensitivity,
		expandedMeasuringSpeed,
		expandedAcquisitionStep,
		expandedStartImmersionDepth,
		expandedEndImmersionDepth,
		expandedStartImmersionDelay,
		expandedEndImmersionDelay,
		expandedTemperature,
		expandedVolume,
		expandedImmersionContainer,
		expandedWettedLengthMeasurementLiquids,
		expandedFiberSampleHolder,

		contactDetectionSensitivityAdjustmentLog,expandedSamplesWithNumReplicates,expandedSampleContainerWithNumReplicates,expandedOptionsWithNumReplicates,expandedWettingLiquidWithNumReplicates,
		sampleResourceReplaceRules,samplesInResources,containerResourceReplaceRules,containersInResources,
		wettingLiquidContainerVolumeCombination,uniqueWettingLiquidContainerVolumeCombination,liquidResourceReplaceRules,wettingLiquidResources,
		immersionContainerModel,expandedWettedLengthMeasurementContainer,expandedWettedLengthMeasurementVolume,wettedLengthMeasurementLiquidResources,fiberSampleHolderResources,tweezerResource,
		wettedLengthMeasurementTime,contactAngleMeasurementTime,setUpTearDownTime,instrumentTime,instrumentResource,

		protocolPacket,sharedFieldPacket,finalizedPacket,
		allResourceBlobs,fulfillable,frqTests,testsRule,resultRule
	},

	(* expand the resolved options if they weren't expanded already *)
	{{expandedSampleInputs,expandedWettingLiquidInputs},expandedResolvedOptions}=ExpandIndexMatchedInputs[ExperimentMeasureContactAngle,{mySamples,myWettingLiquids},myResolvedOptions];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentMeasureContactAngle,
		RemoveHiddenOptions[ExperimentMeasureContactAngle,myResolvedOptions],
		Ignore->myUnresolvedOptions,
		Messages->False
	];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionDefault[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];
	messages=Not[gatherTests];

	(* Get the inherited cache *)
	inheritedCache=Lookup[ToList[myOptions],Cache];

	(* Expand our samples and options according to NumberOfReplicates. *)
	{expandedSamplesWithNumReplicates,expandedOptionsWithNumReplicates}=expandNumberOfReplicates[ExperimentMeasureContactAngle,mySamples,expandedResolvedOptions];
	expandedWettingLiquidWithNumReplicates=First[expandNumberOfReplicates[ExperimentMeasureContactAngle,myWettingLiquids,expandedResolvedOptions]];

	(* --- Make our one big Download call --- *)
	{sampleDownload,sampleContainerDownload,sampleContainerDownloadWithNumReplicates,wettingLiquidDownload}=Download[
		{
			expandedSampleInputs,
			expandedSampleInputs,
			expandedSamplesWithNumReplicates,
			expandedWettingLiquidInputs
		},
		{
			{
				Packet[Name,Status,State,FiberCircumference]
			},
			{
				Container
			},
			{
				Container
			},
			{
				Packet[Name,Status,State]
			}
		},
		Cache->inheritedCache
	];

	(* Flatten the downloaded packets *)
	{samplePackets,wettingLiquidPackets,expandedSampleContainerWithNumReplicates}=Map[Flatten,{sampleDownload,wettingLiquidDownload,Download[sampleContainerDownloadWithNumReplicates,Object]}];

	(* Link removal *)
	sampleContainerObjects=Flatten@Download[sampleContainerDownload,Object];

	(* --- Make all the resources needed in the experiment --- *)

	(* Pull out options *)
	{
		expandedSampleLabel,
		expandedSampleContainerLabel,
		instrument,
		numberOfReplicates,
		expandedWettedLengthMeasurement,
		expandedNumberOfCycles,
		expandedContactDetectionSpeed,
		expandedContactDetectionSensitivity,
		expandedMeasuringSpeed,
		expandedAcquisitionStep,
		expandedStartImmersionDepth,
		expandedEndImmersionDepth,
		expandedStartImmersionDelay,
		expandedEndImmersionDelay,
		expandedTemperature,
		expandedVolume,
		expandedImmersionContainer,
		expandedWettedLengthMeasurementLiquids,
		expandedFiberSampleHolder
	}=Lookup[
		expandedOptionsWithNumReplicates,
		{
			SampleLabel,
			SampleContainerLabel,
			Instrument,
			NumberOfReplicates,
			WettedLengthMeasurement,
			NumberOfCycles,
			ContactDetectionSpeed,
			ContactDetectionSensitivity,
			MeasuringSpeed,
			AcquisitionStep,
			StartImmersionDepth,
			EndImmersionDepth,
			StartImmersionDelay,
			EndImmersionDelay,
			Temperature,
			Volume,
			ImmersionContainer,
			WettedLengthMeasurementLiquids,
			FiberSampleHolder
		}
	];

	(* -- Populate non-resource fields -- *)
	contactDetectionSensitivityAdjustmentLog=Map[
		QuantityArray[{#}]&,
		expandedContactDetectionSensitivity
	];

	(* -- Generate resources for the SamplesIn -- *)

	(* Make replace rules for the samples and its resources; doing it this way because we only want to make one resource per sample including in replicates *)
	sampleResourceReplaceRules=Map[
		Function[{sample},
			sample->Resource[Sample->sample,Name->ToString[Unique[]]]
		],
		expandedSampleInputs
	];

	(* Use the replace rules to get the sample resources *)
	samplesInResources=Replace[expandedSamplesWithNumReplicates,sampleResourceReplaceRules,{1}];

	(* Make replace rules for the sample containers and its resources; doing it this way because we only want to make one resource per sample including in replicates *)
	containerResourceReplaceRules=Map[
		Function[{sampleContainerObj},
			sampleContainerObj->Resource[Sample->sampleContainerObj,Name->ToString[Unique[]],Rent->True]
		],
		sampleContainerObjects
	];

	(* Use the replace rules to get the sample container resources *)
	containersInResources=Replace[expandedSampleContainerWithNumReplicates,containerResourceReplaceRules,{1}];

	(* -- Generate resources for the WettingLiquids -- *)
	(* Find unique liquid/container/volume combinations so we can reuse the same liquid resources. The limiting factor is actually the liquid container that there are only 6 SV20 containers and 6 SV10 containers in lab *)
	wettingLiquidContainerVolumeCombination=Transpose[{expandedWettingLiquidWithNumReplicates,expandedImmersionContainer,expandedVolume}];
	uniqueWettingLiquidContainerVolumeCombination=DeleteDuplicates[wettingLiquidContainerVolumeCombination];
	liquidResourceReplaceRules=Map[
		#->Resource[Sample->#[[1]],Name->ToString[Unique[]],Container->#[[2]],Amount->#[[3]],RentContainer->True]&,
		uniqueWettingLiquidContainerVolumeCombination
	];

	(* Use the replace rules to get the wetting liquid resources *)
	wettingLiquidResources=Map[
		Replace[#,liquidResourceReplaceRules]&,
		wettingLiquidContainerVolumeCombination
	];


	immersionContainerModel=Map[
		#[[2]]&,
		wettingLiquidContainerVolumeCombination
	];

	{expandedWettedLengthMeasurementContainer,expandedWettedLengthMeasurementVolume}=Transpose[Map[
		If[TrueQ[#],
			{Model[Container,Vessel,"id:xRO9n3BadnZO"],87 Milliliter},(* Model[Container,Vessel,"Kruss SV20 glass sample vessel"] *)
			{Null,Null}
		]&,
		expandedWettedLengthMeasurement
	]];

	wettedLengthMeasurementLiquidResources=MapThread[
		If[TrueQ[#1],
			Resource[Sample->#2,Name->ToString[Unique[]],Container->#3,Amount->#4,RentContainer->True],
			Null
		]&,
		{expandedWettedLengthMeasurement,expandedWettedLengthMeasurementLiquids,expandedWettedLengthMeasurementContainer,expandedWettedLengthMeasurementVolume}
	];

	fiberSampleHolderResources=Module[
		{stickyHolderResource,clipperHolderResource},
		(* We have two types of sample holders: a sticky head one that works best with fiber sample, and a clipper one that works with Wilhelmy plates or millimeter-thick fibers (e.g. glass rod) *)
		stickyHolderResource=If[MemberQ[expandedFiberSampleHolder,Model[Container,FiberSampleHolder,"id:KBL5DvLrRkda"]], (* "Kruss single fiber sample holder" *)
			Resource[Sample->Model[Container,FiberSampleHolder,"id:KBL5DvLrRkda"],Name->ToString[Unique[]],Rent->True],
			Null
		];
		clipperHolderResource=If[MemberQ[expandedFiberSampleHolder,Model[Container,FiberSampleHolder,"id:WNa4ZjamMmBE"]], (* "Kruss sample holder (clipper)" *)
			Resource[Sample->Model[Container,FiberSampleHolder,"id:WNa4ZjamMmBE"],Name->ToString[Unique[]],Rent->True],
			Null
		];
		Map[
			Which[
				NullQ[#],Null,
				SameQ[#,Model[Container,FiberSampleHolder,"id:KBL5DvLrRkda"]],stickyHolderResource,
				SameQ[#,Model[Container,FiberSampleHolder,"id:WNa4ZjamMmBE"]],clipperHolderResource
			]&,
			expandedFiberSampleHolder
		]
	];

	tweezerResource=Resource[Sample->Model[Item, Tweezer, "id:P5ZnEjZDJ97k"],Name->ToString[Unique[]],Rent->True];

	(* -- Generate instrument resources -- *)

	(* Template Note: The time in instrument resources is used to charge customers for the instrument time so it's important that this estimate is accurate
		this will probably look like set-up time + time/sample + tear-down time *)

	wettedLengthMeasurementTime=If[MemberQ[expandedWettedLengthMeasurement,True],
		5 Minute*Count[expandedWettedLengthMeasurement,True],
		0 Minute
	];
	setUpTearDownTime=30 Minute;
	contactAngleMeasurementTime=Total[((expandedEndImmersionDepth-expandedStartImmersionDepth)/expandedMeasuringSpeed*2+expandedEndImmersionDelay+expandedStartImmersionDelay)*expandedNumberOfCycles*numberOfReplicates];
	instrumentTime=wettedLengthMeasurementTime+contactAngleMeasurementTime+setUpTearDownTime;
	instrumentResource=Resource[Instrument->instrument,Time->instrumentTime,Name->ToString[Unique[]]];

	(* --- Generate the protocol packet --- *)
	protocolPacket=<|
		Object->CreateID[Object[Protocol,MeasureContactAngle]],
		Type->Object[Protocol,MeasureContactAngle],
		Replace[SamplesIn]->Map[Link[#,Protocols]&,samplesInResources],
		Replace[ContainersIn]->Map[Link[#,Protocols]&,containersInResources],
		UnresolvedOptions->myUnresolvedOptions,
		ResolvedOptions->myResolvedOptions,
		NumberOfReplicates->numberOfReplicates,
		Instrument->Link[instrumentResource],
		Tweezer->Link[tweezerResource],(* We only use the "Bernstein 5-052 Stainless Steel SMD tweezer" provided by Kruss in the toolbox *)
		Replace[Checkpoints]->{
			{"Picking Resources",20 Minute,"Samples required to execute this protocol are gathered from storage.",Link[Resource[Operator->Model[User,Emerald,Operator,"Level 1"],Time->20 Minute]]},
			{"Checking Instrument Connection",10 Minute,"Instrument required to execute this protocol are connected correctly.",Link[Resource[Operator->Model[User,Emerald,Operator,"Level 1"],Time->10 Minute]]},
			{"Preparing Samples",10 Minute,"Preprocessing, such as mounting fiber sample and transferring liquid, is performed.",Link[Resource[Operator->Model[User,Emerald,Operator,"Level 1"],Time->10 Minute]]},
			{"Measuring Contact Angle",instrumentTime,"The contact angle of fiber samples are measured with specified wetting liquid.",Link[Resource[Operator->Model[User,Emerald,Operator,"Level 1"],Time->instrumentTime]]},
			{"Sample Post-Processing",1 Hour,"Any measuring of volume, weight, or sample imaging post experiment is performed.",Link[Resource[Operator->Model[User,Emerald,Operator,"Level 1"],Time->1 Hour]]},
			{"Returning Materials",20 Minute,"Samples are returned to storage.",Link[Resource[Operator->Model[User,Emerald,Operator,"Level 1"],Time->20 Minute]]}
		},
		Replace[WettedLengthMeasurement]->expandedWettedLengthMeasurement,
		Replace[NumberOfCycles]->expandedNumberOfCycles,
		Replace[ContactDetectionSpeed]->expandedContactDetectionSpeed,
		Replace[ContactDetectionSensitivity]->expandedContactDetectionSensitivity,
		Replace[ContactDetectionSensitivityAdjustmentLog]->contactDetectionSensitivityAdjustmentLog,
		Replace[MeasuringSpeed]->expandedMeasuringSpeed,
		Replace[AcquisitionStep]->expandedAcquisitionStep,
		Replace[EndImmersionDepth]->expandedEndImmersionDepth,
		Replace[StartImmersionDepth]->expandedStartImmersionDepth,
		Replace[EndImmersionDelay]->expandedEndImmersionDelay,
		Replace[StartImmersionDelay]->expandedStartImmersionDelay,
		Replace[Temperature]->expandedTemperature,
		Replace[Volume]->expandedVolume,
		Replace[ImmersionContainer]->Map[Link,immersionContainerModel],
		Replace[WettingLiquids]->Map[Link,wettingLiquidResources],
		Replace[FiberSampleHolder]->Map[Link,fiberSampleHolderResources],
		Replace[FiberSampleCount]->ConstantArray[1,Length[samplesInResources]],
		Replace[WettedLengthMeasurementLiquids]->Map[Link,wettedLengthMeasurementLiquidResources]
	|>;

	(* generate a packet with the shared fields *)
	sharedFieldPacket=populateSamplePrepFields[mySamples,myResolvedOptions,Cache->inheritedCache];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket=Join[sharedFieldPacket,protocolPacket];

	(* get all the resource symbolic representations *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs=DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]],_Resource,Infinity]];

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication,Engine],{True,{}},
		gatherTests,Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->inheritedCache],
		True,{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Cache->inheritedCache],Null}
	];

	(* generate the tests rule *)
	testsRule=Tests->If[gatherTests,
		frqTests,
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule=Result->If[MemberQ[output,Result]&&TrueQ[fulfillable],
		finalizedPacket,
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification/.{resultRule,testsRule}
];


(* ::Subsubsection:: *)
(* simulateExperimentMeasureContactAngle *)

DefineOptions[
	simulateExperimentMeasureContactAngle,
	Options:>{CacheOption,SimulationOption,ParentProtocolOption}
];

simulateExperimentMeasureContactAngle[
	myResourcePacket:(PacketP[Object[Protocol,MeasureContactAngle],{Object,ResolvedOptions}]|$Failed|Null),
	mySamples:{ObjectP[{Object[Sample],Object[Item,WilhelmyPlate]}]...},
	myWettingLiquids:{ObjectP[Object[Sample]]...},
	myResolvedOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[simulateExperimentMeasureContactAngle]
]:=Module[
	{
		cache,simulation,fastAssoc,protocolObject,currentSimulation,sampleContainers,wettingLiquidContainers,simulationWithLabels,
		(* Resolved options *)
		resolvedInstrument,
		resolvedNumberOfReplicates,
		resolvedSampleLabel,
		resolvedSampleContainerLabel,
		resolvedWettingLiquidLabel,
		resolvedWettingLiquidContainerLabel,
		resolvedWettedLengthMeasurement,
		resolvedNumberOfCycles,
		resolvedContactDetectionSpeed,
		resolvedContactDetectionSensitivity,
		resolvedMeasuringSpeed,
		resolvedAcquisitionStep,
		resolvedStartImmersionDepth,
		resolvedEndImmersionDepth,
		resolvedStartImmersionDelay,
		resolvedEndImmersionDelay,
		resolvedTemperature,
		resolvedVolume,
		resolvedImmersionContainer,
		resolvedPreparation,
		(* Resources *)
		instrumentResource,
		immersionContainerResources,
		recirculatingPumpResource
	},

	(* Lookup our cache and simulation *)
	cache=Lookup[ToList[myResolutionOptions],Cache,{}];
	simulation=Lookup[ToList[myResolutionOptions],Simulation,Null];
	fastAssoc=makeFastAssocFromCache[cache];

	(* Look up our resolved options *)
	{
		resolvedInstrument,
		resolvedNumberOfReplicates,
		resolvedSampleLabel,
		resolvedSampleContainerLabel,
		resolvedWettingLiquidLabel,
		resolvedWettingLiquidContainerLabel,
		resolvedWettedLengthMeasurement,
		resolvedNumberOfCycles,
		resolvedContactDetectionSpeed,
		resolvedContactDetectionSensitivity,
		resolvedMeasuringSpeed,
		resolvedAcquisitionStep,
		resolvedStartImmersionDepth,
		resolvedEndImmersionDepth,
		resolvedStartImmersionDelay,
		resolvedEndImmersionDelay,
		resolvedTemperature,
		resolvedVolume,
		resolvedImmersionContainer,
		resolvedPreparation
	}=Lookup[
		myResolvedOptions,
		{
			Instrument,
			NumberOfReplicates,
			SampleLabel,
			SampleContainerLabel,
			WettingLiquidLabel,
			WettingLiquidContainerLabel,
			WettedLengthMeasurement,
			NumberOfCycles,
			ContactDetectionSpeed,
			ContactDetectionSensitivity,
			MeasuringSpeed,
			AcquisitionStep,
			StartImmersionDepth,
			EndImmersionDepth,
			StartImmersionDelay,
			EndImmersionDelay,
			Temperature,
			Volume,
			ImmersionContainer,
			Preparation
		}];

	(* Look up resources from protocol packet *)
	{
		instrumentResource,
		immersionContainerResources,
		recirculatingPumpResource
	}=Lookup[
		myResourcePacket,
		{
			Instrument,
			ImmersionContainer,
			RecirculatingPump
		}
	];


	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject=If[MatchQ[myResourcePacket,$Failed],
		SimulateCreateID[Object[Protocol,MeasureContactAngle]],
		Lookup[myResourcePacket,Object]
	];

	(* Simulate the fulfillment of all resources by the procedure.*)
	currentSimulation=If[
		MatchQ[myResourcePacket,$Failed],
		SimulateResources[
			<|
				Object->protocolObject,
				Replace[SamplesIn]->(Resource[Sample->#]&)/@mySamples,
				ResolvedOptions->myResolvedOptions
			|>,
			Cache->cache,
			Simulation->simulation
		],
		SimulateResources[
			myResourcePacket,
			Cache->cache,
			Simulation->simulation
		]
	];

	(* Fetch fiber container and wetting liquid container from Cache *)
	sampleContainers=Lookup[Lookup[fastAssoc,#]&/@mySamples,Container];
	wettingLiquidContainers=Lookup[Lookup[fastAssoc,#]&/@myWettingLiquids,Container];

	(* Update our simulation *)
	(*currentSimulation=UpdateSimulation[currentSimulation,Simulation[sampleTransfer]]; *)

	simulationWithLabels=Simulation[
		Labels->Join[
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions,SampleLabel],mySamples}],
				{_String,ObjectP[]}
			],
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions,WettingLiquidLabel],myWettingLiquids}],
				{_String,ObjectP[]}
			],
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions,SampleContainerLabel],sampleContainers}],
				{_String,ObjectP[]}
			],
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions,WettingLiquidContainerLabel],wettingLiquidContainers}],
				{_String,ObjectP[]}
			]
		],
		LabelFields->If[MatchQ[resolvedPreparation,Manual],
			Join[
				Rule@@@Cases[
					Transpose[{Lookup[myResolvedOptions,SampleLabel],(Field[SampleLink[[#]]]&)/@Range[Length[mySamples]]}],
					{_String,_}
				],
				Rule@@@Cases[
					Transpose[{Lookup[myResolvedOptions,WettingLiquidLabel],(Field[WettingLiquidLink[[#]]]&)/@Range[Length[myWettingLiquids]]}],
					{_String,_}
				],
				Rule@@@Cases[
					Transpose[{Lookup[myResolvedOptions,SampleContainerLabel],(Field[SampleLink[[#]]]&)/@Range[Length[mySamples]]}],
					{_String,_}
				],
				Rule@@@Cases[
					Transpose[{Lookup[myResolvedOptions,WettingLiquidContainerLabel],(Field[WettingLiquidLink[[#]]]&)/@Range[Length[myWettingLiquids]]}],
					{_String,_}
				]
			],
			{}
		]
	];

	(* Merge our packets with our labels. *)
	{
		protocolObject,
		UpdateSimulation[currentSimulation,simulationWithLabels]
	}
];

(* ::Subsection:: *)
(* ExperimentMeasureContactAngleOptions *)


DefineOptions[ExperimentMeasureContactAngleOptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>Alternatives[Table,List]
			],
			Description->"Indicates whether the function returns a table or a list of the options.",
			Category->"Protocol"
		}
	},
	SharedOptions:>{ExperimentMeasureContactAngle}
];

ExperimentMeasureContactAngleOptions[
	mySamples:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],
	myWettingLiquids:ListableP[ObjectP[{Object[Sample],Model[Sample]}]],
	myOptions:OptionsPattern[]
]:=Module[
	{listedOptions,noOutputOptions,options},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptions,(Output->_)|(OutputFormat->_)];

	(* return only the preview for ExperimentMeasureContactAngle *)
	options=ExperimentMeasureContactAngle[mySamples,myWettingLiquids,Append[noOutputOptions,Output->Options]];

	(* If options fail, return failure *)
	If[MatchQ[options,$Failed],
		Return[$Failed]
	];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentMeasureContactAngleOptions],
		options
	]
];


(* ::Subsection:: *)
(* ExperimentMeasureContactAnglePreview *)


DefineOptions[ExperimentMeasureContactAnglePreview,
	SharedOptions:>{ExperimentMeasureContactAngle}
];

ExperimentMeasureContactAnglePreview[
	myFiberSample:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],
	myWettingLiquid:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],
	myOptions:OptionsPattern[]
]:=Module[
	{listedOptions,noOutputOptions},

	(* Get the options as a list*)
	listedOptions=ToList[myOptions];

	(* Remove the Output options before passing to the main function.*)
	noOutputOptions=DeleteCases[listedOptions,Output->_];

	(* Return only the preview for ExperimentMeasureContactAngle *)
	ExperimentMeasureContactAngle[myFiberSample,myWettingLiquid,Append[noOutputOptions,Output->Preview]]
];


(* ::Subsection:: *)
(* ValidExperimentMeasureContactAngleQ *)


DefineOptions[ValidExperimentMeasureContactAngleQ,
	Options:>{VerboseOption,OutputFormatOption},
	SharedOptions:>{ExperimentMeasureContactAngle}
];

ValidExperimentMeasureContactAngleQ[
	myFiberSample:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],
	myWettingLiquid:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],
	myOptions:OptionsPattern[ValidExperimentMeasureContactAngleQ]
]:=Module[
	{listedOptions,listedInput,preparedOptions,filterTests,initialTestDescription,allTests,verbose,outputFormat},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];
	listedInput=Join[ToList[myFiberSample],ToList[myWettingLiquid]];

	(* Remove the Output option before passing to the core function *)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

	(* Return only the tests for ExperimentMeasureContactAngle *)
	filterTests=ExperimentMeasureContactAngle[myFiberSample,myWettingLiquid,Append[preparedOptions,Output->Tests]];

	(* Define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* Make a list of all the tests, including the blanket test *)
	allTests=If[MatchQ[filterTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[
			{initialTest,validObjectBooleans,voqWarnings},

			(* Generate the initial test *)
			initialTest=Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans=ValidObjectQ[DeleteCases[listedInput,_String],OutputFormat->Boolean];
			voqWarnings=MapThread[
				Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{DeleteCases[listedInput,_String],validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest,filterTests,voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentMeasureConductivityQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentMeasureContactAngleQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidExperimentMeasureContactAngleQ"]

];