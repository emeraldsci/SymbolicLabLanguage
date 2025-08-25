(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(*DomainP*)


DefineUsage[DomainP,
{
	BasicDefinitions -> {
		{"DomainP[patt]", "outputPattern", "generates a pattern that matches {min:patt,max:patt} while also enforcing that min<max."}
	},
	Input :> {
		{"patt", _, "Pattern describing each element of the domain list."}
	},
	Output :> {
		{"outputPattern", _PatternTest, "A pattern that matches a pair of elements whose first is strictly less than the second, and both elements match 'patt'."}
	},
	SeeAlso -> {
		"UnitsP",
		"RangeP",
		"ListableP"
	},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];

(* ::Subsection:: *)
(*Unit coordinate comparisons*)


(* ::Subsubsection::Closed:: *)
(*DateCoordinatesComparisonP*)


DefineUsage[DateCoordinatesComparisonP,{
	BasicDefinitions->{
		{"DateCoordinatesComparisonP[comparison]","patt","matches an array or quantity array or coordinates whose x-values are date objects and whose y-values match 'comparison'."}
	},
	Input:>{
		{"comparison",_,"A comparison pattern function, such as GreaterP or RangeP, that will be checked against all y-values in the array being tested."}
	},
	Output:>{
		{"patt",_,"A pattern that matches an array whose x-values are date objects and whose y-values match 'comparison'."}
	},
	SeeAlso->{"GreaterP","DateObjectQ","QuantityCoordinatesP"},
	Author->{"scicomp", "brad", "alice"}
}];



(* ::Subsubsection::Closed:: *)
(*RosettaTaskQ*)


DefineUsage[RosettaTaskP,
	{
		BasicDefinitions -> {
			{"RosettaTaskP[]","pattern","matches an association that is a valid Rosetta Task (includes TaskType and ID key-value pairs)."},
			{"RosettaTaskP[type]","pattern","matches an association that is a valid Rosetta Task of type 'type'."}
		},
		MoreInformation -> {
			"A valid Rosetta task must have the TaskType and ID keys."
		},
		Input :> {
			{"type", RosettaTaskTypeP, "A Rosetta task type."}
		},
		Output :> {
			{"pattern",_,"A pattern that matches a valid Rosetta task."}
		},
		SeeAlso -> {
			"RosettaTaskTypeP",
			"ReadyCheck",
			"RosettaTaskQ",
			"EditProcedure"
		},
		Author -> {"robert", "alou"}
	}
];



(* ::Subsubsection::Closed:: *)
(*RosettaTaskQ*)


DefineUsage[RosettaTaskQ,
	{
		BasicDefinitions -> {
			{"RosettaTaskQ[task]","boolean","returns True when 'task' is a valid Rosetta task."},
			{"RosettaTaskQ[task,type]","boolean","returns True when 'task' is a valid Rosetta task with TaskType 'type'."}
		},
		MoreInformation -> {
			"Valid Rosetta tasks are defined in associations with specific keys and key-values.",
			"RosettaTaskQ checks that the input association has the correct keys:",
			Grid[{
				{"Key","Pattern","Description"},
				{"TaskType","RosettaTaskTypeP","The type of task described by the task association."},
				{"ID","_String","A unique identifier used to distinguish the task from other tasks such that procedures can be reset to specific tasks."},
				{"Args","_Association","An association defining all arguments used by the task. Each task type may have different arguments."}
			}]
		},
		Input :> {
			{"task", _Association, "An association to be tested as a Rosetta task definition."},
			{"type", RosettaTaskTypeP, "A Rosetta task type."}
		},
		Output :> {
			{"boolean",BooleanP,"True|False value indicating the validity of input task association."}
		},
		SeeAlso -> {
			"ReadyCheck",
			"RosettaTaskP",
			"RosettaTaskTypeP"
		},
		Author -> {"robert", "alou"}
	}
];


(* ::Subsubsection::Closed:: *)
(*DomainP*)


DefineUsage[PolymerQ,
{
	BasicDefinitions -> {
		{"PolymerQ[polymer]", "result", "checks if the pattern of polymer type 'polymer' is either among the known type or a corresponding model physics object is properly uploaded."}
	},
	Input :> {
		{"polymer", _, "Polymer type to be checked for existence."}
	},
	Output :> {
		{"result", BooleanP, "Returns true if the polymer type is either known or the object Model[Physics,Oligomer,\"'polymer'\"] exists."}
	},
	SeeAlso -> {
		"ValidPolymerQ",
		"UploadModification"
	},
	Author -> {"scicomp", "brad", "amir.saadat"}
}];

(* ::Subsubsection::Closed:: *)
(*AffinityLabelP*)


DefineUsage[AffinityLabelP,
	{
		BasicDefinitions -> {
			{"AffinityLabelP[]", "outputPattern", "generates a pattern that matches Model[Molecule]s that have high binding capacity with certain materials and can be attached to another molecule."}
		},
		Input :> {
		},
		Output :> {
			{"outputPattern", _PatternTest, "A pattern that matches Model[Molecule]s that have high binding capacity with certain materials and can be attached to another molecule."}
		},
		SeeAlso -> {
			"DetectionLabelP",
			"RangeP",
			"ListableP"
		},
		Author -> {"dirk.schild", "gil.sharon"}
	}];

(* ::Subsubsection::Closed:: *)
(*DetectionLabelP*)


DefineUsage[DetectionLabelP,
	{
		BasicDefinitions -> {
			{"DetectionLabelP[]", "outputPattern", "generates a pattern that matches Model[Molecule]s that can be attached to another molecule and act as a tag that can indicate the presence and amount of the other molecule."}
		},
		Input :> {
		},
		Output :> {
			{"outputPattern", _PatternTest, "A pattern that matches Model[Molecule]s that can be attached to another molecule and act as a tag that can indicate the presence and amount of the other molecule."}
		},
		SeeAlso -> {
			"AffinityLabelP",
			"RangeP",
			"ListableP"
		},
		Author -> {"dirk.schild", "gil.sharon"}
	}];


(* ::Subsubsection::Closed:: *)
(*AreaMeasurementAssociationQ*)


DefineUsage[AreaMeasurementAssociationQ,
	{
		BasicDefinitions -> {
			{"AreaMeasurementAssociationQ[association]", "result", "checks if the association matches the pattern used for AreaProperties field for each individual cell in Object[Analysis,CellCount]."}
		},
		Input :> {
			{"association", _, "Association to be checked."}
		},
		Output :> {
			{"result", BooleanP, "Returns true if the association matches the accepted pattern."}
		},
		SeeAlso -> {
			"AnalyzeCellCount"
		},
		Author -> {"dirk.schild", "waseem.vali", "lei.tian", "charlene.konkankit", "cgullekson"}
	}];

(* ::Subsubsection::Closed:: *)
(*BestfitEllipseAssociationQ*)


DefineUsage[BestfitEllipseAssociationQ,
	{
		BasicDefinitions -> {
			{"BestfitEllipseAssociationQ[association]", "result", "checks if the association matches the pattern used for BestfitEllipse field for each individual cell in Object[Analysis,CellCount]."}
		},
		Input :> {
			{"association", _, "Association to be checked."}
		},
		Output :> {
			{"result", BooleanP, "Returns true if the association matches the accepted pattern."}
		},
		SeeAlso -> {
			"AnalyzeCellCount"
		},
		Author -> {"dirk.schild", "waseem.vali", "lei.tian", "charlene.konkankit", "cgullekson"}
	}];

(* ::Subsubsection::Closed:: *)
(*BoundingboxPropertiesAssociationQ*)


DefineUsage[BoundingboxPropertiesAssociationQ,
	{
		BasicDefinitions -> {
			{"BoundingboxPropertiesAssociationQ[association]", "result", "checks if the association matches the pattern used for BoundingboxProperties field for each individual cell in Object[Analysis,CellCount]."}
		},
		Input :> {
			{"association", _, "Association to be checked."}
		},
		Output :> {
			{"result", BooleanP, "Returns true if the association matches the accepted pattern."}
		},
		SeeAlso -> {
			"AnalyzeCellCount"
		},
		Author -> {"dirk.schild", "waseem.vali", "lei.tian", "charlene.konkankit", "cgullekson"}
	}];

(* ::Subsubsection::Closed:: *)
(*CellConcentrationQ*)


DefineUsage[CellConcentrationQ,
	{
		BasicDefinitions -> {
			{"CellConcentrationQ[value]", "result", "checks if the value is in units of cells per volume."}
		},
		Input :> {
			{"value", _, "Value to be checked."}
		},
		Output :> {
			{"result", BooleanP, "Returns true if the value matches the accepted pattern."}
		},
		SeeAlso -> {
			"AnalyzeCellCount",
			"CFUConcentrationQ"
		},
		Author -> {"dirk.schild"}
	}];


(* ::Subsubsection::Closed:: *)
(*CellConcentrationQ*)

DefineUsage[CFUConcentrationQ,
	{
		BasicDefinitions -> {
			{"CFUConcentrationQ[value]", "result", "checks if the value is in units of CFU per volume."}
		},
		Input :> {
			{"value", _, "Value to be checked."}
		},
		Output :> {
			{"result", BooleanP, "Returns true if the value matches the accepted pattern."}
		},
		SeeAlso -> {
			"CellConcentrationQ"
		},
		Author -> {"harrison.gronlund", "taylor.hochuli"}
	}];

DefineUsage[CentroidPropertiesAssociationQ,
	{
		BasicDefinitions -> {
			{"CentroidPropertiesAssociationQ[association]", "result", "checks if the association matches the pattern used for CentroidProperties field for each individual cell in Object[Analysis,CellCount]."}
		},
		Input :> {
			{"association", _, "Association to be checked."}
		},
		Output :> {
			{"result", BooleanP, "Returns true if the association matches the accepted pattern."}
		},
		SeeAlso -> {
			"AnalyzeCellCount"
		},
		Author -> {"dirk.schild", "waseem.vali", "lei.tian", "charlene.konkankit", "cgullekson"}
	}];

DefineUsage[ImageIntensityAssociationQ,
	{
		BasicDefinitions -> {
			{"ImageIntensityAssociationQ[association]", "result", "checks if the association matches the pattern used for ImageIntensity field in Object[Analysis,CellCount]."}
		},
		Input :> {
			{"association", _, "Association to be checked."}
		},
		Output :> {
			{"result", BooleanP, "Returns true if the association matches the accepted pattern."}
		},
		SeeAlso -> {
			"AnalyzeCellCount"
		},
		Author -> {"dirk.schild", "waseem.vali", "lei.tian", "charlene.konkankit", "cgullekson"}
	}];

DefineUsage[PerimeterPropertiesAssociationQ,
	{
		BasicDefinitions -> {
			{"PerimeterPropertiesAssociationQ[association]", "result", "checks if the association matches the pattern used for PerimeterProperties field in Object[Analysis,CellCount]."}
		},
		Input :> {
			{"association", _, "Association to be checked."}
		},
		Output :> {
			{"result", BooleanP, "Returns true if the association matches the accepted pattern."}
		},
		SeeAlso -> {
			"AnalyzeCellCount"
		},
		Author -> {"dirk.schild", "waseem.vali", "lei.tian", "charlene.konkankit", "cgullekson"}
	}];

DefineUsage[ShapeMeasurementsAssociationQ,
	{
		BasicDefinitions -> {
			{"ShapeMeasurementsAssociationQ[association]", "result", "checks if the association matches the pattern used for ShapeMeasurements field in Object[Analysis,CellCount]."}
		},
		Input :> {
			{"association", _, "Association to be checked."}
		},
		Output :> {
			{"result", BooleanP, "Returns true if the association matches the accepted pattern."}
		},
		SeeAlso -> {
			"AnalyzeCellCount"
		},
		Author -> {"dirk.schild", "waseem.vali", "lei.tian", "charlene.konkankit", "cgullekson"}
	}];

DefineUsage[TopologicalPropertiesAssociationQ,
	{
		BasicDefinitions -> {
			{"TopologicalPropertiesAssociationQ[association]", "result", "checks if the association matches the pattern used for TopologicalProperties field in Object[Analysis,CellCount]."}
		},
		Input :> {
			{"association", _, "Association to be checked."}
		},
		Output :> {
			{"result", BooleanP, "Returns true if the association matches the accepted pattern."}
		},
		SeeAlso -> {
			"AnalyzeCellCount"
		},
		Author -> {"dirk.schild", "waseem.vali", "lei.tian", "charlene.konkankit", "cgullekson"}
	}];
(* ::Subsection:: *)
(* Sample History Cards *)

(* ::Subsubsection:: *)
(*Initialized*)

DefineUsage[Initialized,
	{
		BasicDefinitions -> {
			{"Initialized[rules]", "sampleHistoryCard", "creates a sample history card that indicates conditions of a sample being first created."}
		},
		Input :> {
			{"rules", __Rule, "Rules indicating conditions of the indicated sample being Initialized."}
		},
		Output :> {
			{"sampleHistoryCard", _Initialized, "A sample history card that indicates conditions of a sample being first created."}
		},
		SeeAlso -> {
			"DefinedComposition",
			"ExperimentStarted",
			"ExperimentEnded"
		},
		Author -> {
			"taylor.hochuli", "thomas"
		}
	}
];


(* ::Subsubsection:: *)
(*ExperimentStarted*)

DefineUsage[ExperimentStarted,
	{
		BasicDefinitions -> {
			{"ExperimentStarted[rules]", "sampleHistoryCard", "creates a sample history card that indicates when the sample object was first picked to use in a protocol."}
		},
		Input :> {
			{"rules", __Rule, "Rules indicating conditions of the indicated sample being picked to be used by a protocol."}
		},
		Output :> {
			{"sampleHistoryCard", _ExperimentStarted, "A sample history card that indicates when the sample object was first picked to use in a protocol."}
		},
		SeeAlso -> {
			"Initialized",
			"ExperimentEnded"
		},
		Author -> {
			"taylor.hochuli", "thomas"
		}
	}
];


(* ::Subsubsection:: *)
(*ExperimentEnded*)

DefineUsage[ExperimentEnded,
	{
		BasicDefinitions -> {
			{"ExperimentEnded[rules]", "sampleHistoryCard", "creates a sample history card that indicates when the sample object was stored after being used by a protocol."}
		},
		Input :> {
			{"rules", __Rule, "Rules indicating conditions of the indicated sample being stored after being used by a protocol."}
		},
		Output :> {
			{"sampleHistoryCard", _ExperimentEnded, "A sample history card that indicates when the sample object was stored after being used by a protocol."}
		},
		SeeAlso -> {
			"Initialized",
			"ExperimentStarted"
		},
		Author -> {
			"taylor.hochuli", "thomas"
		}
	}
];


(* ::Subsubsection:: *)
(*Centrifuged*)

DefineUsage[Centrifuged,
	{
		BasicDefinitions -> {
			{"Centrifuged[rules]", "sampleHistoryCard", "creates a sample history card that indicates when the sample object was centrifuged."}
		},
		Input :> {
			{"rules", __Rule, "Rules indicating conditions of the indicated sample being centrifuged."}
		},
		Output :> {
			{"sampleHistoryCard", _Centrifuged, "A sample history card that indicates when the sample object was centrifuged."}
		},
		SeeAlso -> {
			"Incubated",
			"Filtered"
		},
		Author -> {
			"jireh.sacramento", "thomas"
		}
	}
];

(* ::Subsubsection:: *)
(*Incubated*)

DefineUsage[Incubated,
	{
		BasicDefinitions -> {
			{"Incubated[rules]", "sampleHistoryCard", "creates a sample history card that indicates when the sample object was incubated or mixed."}
		},
		Input :> {
			{"rules", __Rule, "Rules indicating conditions of the indicated sample being incubated or mixed."}
		},
		Output :> {
			{"sampleHistoryCard", _Incubated, "A sample history card that indicates when the sample object was incubated or mixed."}
		},
		SeeAlso -> {
			"Centrifuged",
			"Filtered"
		},
		Author -> {
			"melanie.reschke", "thomas"
		}
	}
];


(* ::Subsubsection:: *)
(*Evaporated*)

DefineUsage[Evaporated,
	{
		BasicDefinitions -> {
			{"Evaporated[rules]", "sampleHistoryCard", "creates a sample history card that indicates when the sample object was evaporated."}
		},
		Input :> {
			{"rules", __Rule, "Rules indicating conditions of the indicated sample being evaporated."}
		},
		Output :> {
			{"sampleHistoryCard", _Evaporated, "A sample history card that indicates when the sample object was evaporated."}
		},
		SeeAlso -> {
			"Incubated",
			"FlashFrozen"
		},
		Author -> {
			"jireh.sacramento", "thomas"
		}
	}
];


(* ::Subsubsection:: *)
(*FlashFrozen*)

DefineUsage[FlashFrozen,
	{
		BasicDefinitions -> {
			{"FlashFrozen[rules]", "sampleHistoryCard", "creates a sample history card that indicates when the sample object was flash frozen."}
		},
		Input :> {
			{"rules", __Rule, "Rules indicating conditions of the indicated sample being flash frozen."}
		},
		Output :> {
			{"sampleHistoryCard", _FlashFrozen, "A sample history card that indicates when the sample object was flash frozen."}
		},
		SeeAlso -> {
			"Incubated",
			"Evaporated"
		},
		Author -> {"dirk.schild"}
	}
];


(* ::Subsubsection:: *)
(*Degassed*)

DefineUsage[Degassed,
	{
		BasicDefinitions -> {
			{"Degassed[rules]", "sampleHistoryCard", "creates a sample history card that indicates when the sample object was degassed."}
		},
		Input :> {
			{"rules", __Rule, "Rules indicating conditions of the indicated sample being degassed."}
		},
		Output :> {
			{"sampleHistoryCard", _Degassed, "A sample history card that indicates when the sample object was degassed."}
		},
		SeeAlso -> {
			"FlashFrozen",
			"Evaporated"
		},
		Author -> {
			"boris.brenerman"
		}
	}
];

(* ::Subsubsection:: *)
(*Desiccated*)

DefineUsage[Desiccated,
	{
		BasicDefinitions -> {
			{"Desiccated[rules]", "sampleHistoryCard", "creates a sample history card that indicates when the sample object was desiccated."}
		},
		Input :> {
			{"rules", __Rule, "Rules indicating conditions of the indicated sample being desiccated."}
		},
		Output :> {
			{"sampleHistoryCard", _Desiccated, "A sample history card that indicates when the sample object was desiccated."}
		},
		SeeAlso -> {
			"Degassed",
			"Evaporated",
			"Lyophilized"
		},
		Author -> {
			"mohamad.zandian"
		}
	}
];

(* ::Subsubsection:: *)
(*Filtered*)

DefineUsage[Filtered,
	{
		BasicDefinitions -> {
			{"Filtered[rules]", "sampleHistoryCard", "creates a sample history card that indicates when the sample object was filtered."}
		},
		Input :> {
			{"rules", __Rule, "Rules indicating conditions of the indicated sample being filtered."}
		},
		Output :> {
			{"sampleHistoryCard", _Filtered, "A sample history card that indicates when the sample object was filtered."}
		},
		SeeAlso -> {
			"Incubated",
			"Centrifuged"
		},
		Author -> {
			"jireh.sacramento",
			"steven"
		}
	}
];
(* ::Subsubsection:: *)
(* Ground *)

DefineUsage[Ground,
	{
		BasicDefinitions -> {
			{"Ground[rules]", "sampleHistoryCard", "creates a sample history card that indicates when the sample object was ground."}
		},
		Input :> {
			{"rules", __Rule, "Rules indicating grinding parameters for the indicated sample."}
		},
		Output :> {
			{"sampleHistoryCard", _Ground, "A sample history card that indicates when the sample object was ground."}
		},
		SeeAlso -> {
			"Incubated",
			"Evaporated"
		},
		Author -> {
			"yanzhe.zhu", "lige.tonggu"
		}
	}
];

(* ::Subsubsection:: *)
(*Restricted*)

DefineUsage[Restricted,
	{
		BasicDefinitions -> {
			{"Restricted[rules]", "sampleHistoryCard", "creates a sample history card that indicates when the sample object was restricted."}
		},
		Input :> {
			{"rules", __Rule, "Rules indicating conditions of the indicated sample being restricted."}
		},
		Output :> {
			{"sampleHistoryCard", _Restricted, "A sample history card that indicates when the sample object was restricted."}
		},
		SeeAlso -> {
			"Unrestricted",
			"SetStorageCondition"
		},
		Author -> {
			"taylor.hochuli", "thomas"
		}
	}
];


(* ::Subsubsection:: *)
(*Unrestricted*)

DefineUsage[Unrestricted,
	{
		BasicDefinitions -> {
			{"Unrestricted[rules]", "sampleHistoryCard", "creates a sample history card that indicates when the sample object was unrestricted."}
		},
		Input :> {
			{"rules", __Rule, "Rules indicating conditions of the indicated sample being unrestricted."}
		},
		Output :> {
			{"sampleHistoryCard", _Unrestricted, "A sample history card that indicates when the sample object was unrestricted."}
		},
		SeeAlso -> {
			"Restricted",
			"SetStorageCondition"
		},
		Author -> {
			"taylor.hochuli", "thomas"
		}
	}
];


(* ::Subsubsection:: *)
(*SetStorageCondition*)

DefineUsage[SetStorageCondition,
	{
		BasicDefinitions -> {
			{"SetStorageCondition[rules]", "sampleHistoryCard", "creates a sample history card that indicates when the sample object had its storage condition set or changed."}
		},
		Input :> {
			{"rules", __Rule, "Rules indicating conditions of the indicated sample having its storage condition set or changed."}
		},
		Output :> {
			{"sampleHistoryCard", _SetStorageCondition, "A sample history card that indicates when the sample object had its storage condition set or changed."}
		},
		SeeAlso -> {
			"Restricted",
			"Unrestricted"
		},
		Author -> {"taylor.hochuli", "harrison.gronlund"}
	}
];


(* ::Subsubsection:: *)
(*Measured*)

DefineUsage[Measured,
	{
		BasicDefinitions -> {
			{"Measured[rules]", "sampleHistoryCard", "creates a sample history card that indicates when the sample object had some property measured."}
		},
		Input :> {
			{"rules", __Rule, "Rules indicating conditions of the indicated sample being measured by some protocol."}
		},
		Output :> {
			{"sampleHistoryCard", _Measured, "A sample history card that indicates when the sample object was measured."}
		},
		SeeAlso -> {
			"AcquiredData",
			"StateChanged"
		},
		Author -> {
			"taylor.hochuli", "thomas"
		}
	}
];


(* ::Subsubsection:: *)
(*StateChanged*)

DefineUsage[StateChanged,
	{
		BasicDefinitions -> {
			{"StateChanged[rules]", "sampleHistoryCard", "creates a sample history card that indicates when the sample object had its state changed."}
		},
		Input :> {
			{"rules", __Rule, "Rules indicating conditions of the indicated sample having its state changed."}
		},
		Output :> {
			{"sampleHistoryCard", _StateChange, "A sample history card that indicates when the sample object had its state changed."}
		},
		SeeAlso -> {
			"FlashFrozen",
			"Evaporated"
		},
		Author -> {
			"taylor.hochuli", "thomas"
		}
	}
];

(* ::Subsubsection:: *)
(*Sterilized*)

DefineUsage[Sterilized,
	{
		BasicDefinitions -> {
			{"Sterilized[rules]", "sampleHistoryCard", "creates a sample history card that indicates when the sample object was sterilized."}
		},
		Input :> {
			{"rules", __Rule, "Rules indicating conditions of the indicated sample being sterilized."}
		},
		Output :> {
			{"sampleHistoryCard", _Sterilized, "A sample history card that indicates when the sample object was sterilized."}
		},
		SeeAlso -> {
			"Filtered",
			"SetStorageCondition"
		},
		Author -> {
			"taylor.hochuli", "thomas"
		}
	}
];

(* ::Subsubsection:: *)
(*Transferred*)

DefineUsage[Transferred,
	{
		BasicDefinitions -> {
			{"Transferred[rules]", "sampleHistoryCard", "creates a sample history card that indicates when the sample object either had something transferred into or out of it."}
		},
		Input :> {
			{"rules", __Rule, "Rules indicating conditions of something being transferred into or out of the indicated sample."}
		},
		Output :> {
			{"sampleHistoryCard", _Transferred, "A sample history card that indicates when something was transferred into or out of the indicated sample."}
		},
		SeeAlso -> {
			"Filtered",
			"SetStorageCondition"
		},
		Author -> {
			"zechen.zhang", "thomas"
		}
	}
];

(* ::Subsubsection:: *)
(*AcquiredData*)

DefineUsage[AcquiredData,
	{
		BasicDefinitions -> {
			{"AcquiredData[rules]", "sampleHistoryCard", "creates a sample history card that indicates when the sample object had some data acquired of various types."}
		},
		Input :> {
			{"rules", __Rule, "Rules indicating conditions of the indicated sample having some data acquired by some protocol."}
		},
		Output :> {
			{"sampleHistoryCard", _AcquiredData, "A sample history card that indicates when the sample object had data acquired."}
		},
		SeeAlso -> {
			"Measured",
			"StateChanged"
		},
		Author -> {
			"taylor.hochuli", "thomas"
		}
	}
];

(* ::Subsubsection:: *)
(*Shipped*)

DefineUsage[Shipped,
	{
		BasicDefinitions -> {
			{"Shipped[rules]", "sampleHistoryCard", "creates a sample history card that indicates when the sample object has been shipped to or from ECL."}
		},
		Input :> {
			{"rules", __Rule, "Rules indicating conditions of the indicated sample having been shipped to or from ECL."}
		},
		Output :> {
			{"sampleHistoryCard", _Shipped, "A sample history card that indicates when the sample object has been shipped to or from ECL."}
		},
		SeeAlso -> {
			"Initialized",
			"SetStorageCondition"
		},
		Author -> {
			"taylor.hochuli", "thomas"
		}
	}
];

(* ::Subsubsection:: *)
(*DefinedComposition*)

DefineUsage[DefinedComposition,
	{
		BasicDefinitions -> {
			{"DefinedComposition[rules]", "sampleHistoryCard", "creates a sample history card that indicates when the sample object has had a new composition defined."}
		},
		Input :> {
			{"rules", __Rule, "Rules indicating conditions of the indicated sample having a new composition defined."}
		},
		Output :> {
			{"sampleHistoryCard", _DefinedComposition, "A sample history card that indicates when the sample object has had a new composition defined."}
		},
		SeeAlso -> {
			"Initialized",
			"AcquiredData"
		},
		Author -> {
			"taylor.hochuli", "thomas"
		}
	}
];

(* ::Subsubsection:: *)
(*Lysed*)

DefineUsage[Lysed,
	{
		BasicDefinitions -> {
			{"Lysed[rules]", "sampleHistoryCard", "creates a sample history card that indicates when a sample object contained living cells has been lysed."}
		},
		Input :> {
			{"rules", __Rule, "Rules indicating the conditions under which cells contained in the indicated sample have been lysed."}
		},
		Output :> {
			{"sampleHistoryCard", _Lysed, "A sample history card that indicates the conditions under which the cells contained within the sample object have been lysed."}
		},
		SeeAlso -> {
			"ExperimentLyseCells"
		},
		Author -> {
			"tyler.pabst"
		}
	}
];

(* ::Subsubsection:: *)
(*CASNumberQ and CASNumberP*)

DefineUsage[CASNumberQ,
	{
		BasicDefinitions -> {
			{"CASNumberQ[CASNumberString]", "result", "tests whether CASNumberString matches the pattern of a Chemical Abstract Service (CAS) registry number."}
		},
		Input :> {
			{"CASNumberString", Blank[], "The input to compare with the CAS registry number pattern."}
		},
		Output :> {
			{"result", BooleanP, "Indicates if the input was a string with a CAS registry number pattern."}
		},
		SeeAlso -> {
			"ValidObjectQ",
			"PolymerQ",
			"PeptideQ",
			"DNAQ",
			"RNAQ"
		},
		Author -> {"ryan.bisbey", "axu"}
	}
];

(* ::Subsubsection:: *)
(*Washed*)
DefineUsage[Washed,
	{
		BasicDefinitions -> {
			{"Washed[rules]", "sampleHistoryCard", "creates a sample history card that indicates when a cell sample object has been washed."}
		},
		Input :> {
			{"rules", __Rule, "Rules indicating the conditions under which cells contained in the indicated sample have been washed."}
		},
		Output :> {
			{"sampleHistoryCard", _Washed, "A sample history card that indicates the conditions under which the cells contained within the sample object have been washed."}
		},
		SeeAlso -> {
			"ExperimentWashCells",
			"ExperimentChangeMedia"
		},
		Author -> {
			"xu.yi"
		}
	}
];

(* ::Subsubsection:: *)
(*DayObjectQ*)
DefineUsage[DayObjectQ,
	{
		BasicDefinitions -> {
			{"DayObjectQ[expression]", "boolean", "indicates if the 'expression' represents a Day. Dates return False."}
		},
		Input :> {
			{"expression",_, "Expression to test."}
		},
		Output :> {
			{"boolean", BooleanP, "Indicates if the input expression represents a date."}
		},
		SeeAlso -> {
			"DateObjectQ",
			"DateObject"
		},
		Author -> {"dirk.schild", "kelmen.low", "david.ascough"}
	}
];

(* ::Subsubsection:: *)
(* CellsFrozen *)
DefineUsage[CellsFrozen,
	{
		BasicDefinitions -> {
			{"CellsFrozen[rules]", "sampleHistoryCard", "creates a sample history card that indicates when a cell sample object has been frozen for cryopreservation."}
		},
		Input :> {
			{"rules", __Rule, "Rules indicating the conditions under which cells contained in the indicated sample have been frozen."}
		},
		Output :> {
			{"sampleHistoryCard", _CellsFrozen, "A sample history card that indicates the conditions under which the cells contained within the sample object have been frozen."}
		},
		SeeAlso -> {
			"ExperimentFreezeCells"
		},
		Author -> {
			"tyler.pabst"
		}
	}
];