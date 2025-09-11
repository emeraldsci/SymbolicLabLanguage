(* ::Package:: *)

(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(* SampleManipulation framework (Deprecated) legacy usages *)



(* ::Subsection:: *)
(*Consolidation*)



DefineUsage[Consolidation,
	{
		BasicDefinitions -> {
			{"Consolidation[consolidationRules]","primitive","generates an ExperimentSampleManipulation-compatible (deprecated) 'primitive' that describes a transfer of multiple sources to a single destination."}
		},
		Input:>{
			{
				"consolidationRules",
				{
					Sources->{(NonSelfContainedSampleP|NonSelfContainedSampleModelP|ObjectP[{Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette],Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette]}]|{ObjectP[{Model[Container,Plate],Object[Container,Plate]}],WellP})..},
					Amounts->{GreaterEqualP[0 Milliliter]..}|{GreaterEqualP[0 Gram]|GreaterEqualP[0, 1]..},
					Destination->
					(NonSelfContainedSampleP|ObjectP[{Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette],Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette]}]|{ObjectP[{Model[Container,Plate],Object[Container,Plate]}],WellP})
				},
				"The list of key/value pairs describing the transfer of specified amounts of multiple sources and their destination."
			}
		},
		Output:>{
			{"primitive",_Consolidation,"A sample manipulation primitive (deprecated) containing information for specification and execution of a consolidation of multiple samples into a single location."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"ExperimentSamplePreparation",
			"Mix",
			"Aliquot",
			"FillToVolume",
			"Incubate",
			"Pellet",
			"Wait",
			"Define",
			"Filter",
			"Centrifuge",
			"ExperimentStockSolution",
			"ExperimentIncubate",
			"ExperimentMeasureVolume",
			"ExperimentHPLC",
			"ExperimentMassSpectrometry"
		},
		Author->{"robert", "alou"}
	}
];


(* ::Subsection:: *)
(*Define*)


DefineUsage[Define,
	{
		BasicDefinitions -> {
			{"Define[name]","primitive","generates an ExperimentSampleManipulation-compatible (deprecated) 'primitive' that describes the definition of a sample, container, or model's name reference in other primitives."}
		},
		Input:>{
			{
				"name",
				_String,
				"The named reference to a sample, container, or model."
			}
		},
		Output:>{
			{"primitive",_Define,"A sample manipulation primitive (deprecated) containing information for a named reference in a set of primitives."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"ExperimentSamplePreparation",
			"Transfer",
			"Mix",
			"Aliquot",
			"FillToVolume",
			"Incubate",
			"Pellet",
			"Filter",
			"Wait",
			"Centrifuge"
		},
		Author->{"robert", "alou"}
	}
];



(* ::Subsection:: *)
(*MoveToMagnet*)


DefineUsage[MoveToMagnet,
	{
		BasicDefinitions->{
			{"MoveToMagnet[Sample]","primitive","generates an ExperimentSampleManipulation-compatible (deprecated) 'primitive' that describes subjecting a sample to magnetization."}
		},
		MoreInformation->{
			"Only 96-well plates are currently supported for MoveToMagnet primitives."
		},
		Input:>{
			{
				"Sample",
				(NonSelfContainedSampleP|NonSelfContainedSampleModelP|ObjectP[{Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette],Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette]}]|{ObjectP[{Model[Container,Plate],Object[Container,Plate]}],WellP}),
				"The sample/container to be magnetized."
			}
		},
		Output:>{
			{"primitive",_MoveToMagnet,"A sample manipulation primitive (deprecated) containing information for specification and execution of the magnetization of a sample."}
		},
		Sync->Automatic,
		SeeAlso->{
			"ExperimentSamplePreparation",
			"RemoveFromMagnet",
			"Define",
			"Transfer",
			"Aliquot",
			"Mix",
			"Incubate",
			"Wait",
			"Filter"
		},
		Author->{"melanie.reschke", "yanzhe.zhu"}
	}
];



(* ::Subsection:: *)
(*ReadPlate*)


DefineUsage[ReadPlate,
	{
		BasicDefinitions -> {
			{"ReadPlate[Sample]","primitive","generates an ExperimentSampleManipulation-compatible (deprecated) 'primitive' that describes placing a plate into a plate-reader instrument and reading it under a certain set of specified parameters."}
		},
		MoreInformation->{},
		Input:>{
			{
				"Sample",
				ListableP[(NonSelfContainedSampleP|NonSelfContainedSampleModelP|ObjectP[{Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette],Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette]}]|{ObjectP[{Model[Container,Plate],Object[Container,Plate]}],WellP})],
				"The sample whose absorbance/fluorescence/luminescence should be read."
			}
		},
		Output:>{
			{"primitive",_ReadPlate,"A sample manipulation primitive (deprecated) containing information for specification and execution of reading a plate in a plate reader."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"ExperimentSamplePreparation",
			"Transfer",
			"Aliquot",
			"Consolidation",
			"Mix",
			"Wait",
			"Define",
			"Incubate",
			"Pellet",
			"Centrifuge",
			"Filter",
			"ExperimentStockSolution",
			"ExperimentIncubate",
			"ExperimentMeasureVolume",
			"ExperimentHPLC",
			"ExperimentMassSpectrometry"
		},
		Author->{"robert", "alou"}
	}
];



(* ::Subsection:: *)
(*RemoveFromMagnet*)


DefineUsage[RemoveFromMagnet,
	{
		BasicDefinitions->{
			{"RemoveFromMagnet[Sample]","primitive","generates an ExperimentSampleManipulation-compatible (deprecated) 'primitive' that describes removing a sample from magnetization."}
		},
		MoreInformation->{
			"Only 96-well plates are currently supported for RemoveFromMagnet primitives."
		},
		Input:>{
			{
				"Sample",
				(NonSelfContainedSampleP|NonSelfContainedSampleModelP|ObjectP[{Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette],Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette]}]|{ObjectP[{Model[Container,Plate],Object[Container,Plate]}],WellP}),
				"The sample/container to be removed from magnetization."
			}
		},
		Output:>{
			{"primitive",_RemoveFromMagnet,"A sample manipulation primitive (deprecated) containing information for specification and execution of the removal of a sample from magnetization."}
		},
		Sync->Automatic,
		SeeAlso->{
			"ExperimentSamplePreparation",
			"MoveToMagnet",
			"Define",
			"Transfer",
			"Aliquot",
			"Mix",
			"Incubate",
			"Wait",
			"Filter"
		},
		Author->{"melanie.reschke", "yanzhe.zhu"}
	}
];


