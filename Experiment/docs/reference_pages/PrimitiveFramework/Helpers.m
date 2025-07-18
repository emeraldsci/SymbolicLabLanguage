(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(*LookupLabeledObject*)

DefineUsage[LookupLabeledObject,
	{
		BasicDefinitions -> {
			{
				Definition->{"LookupLabeledObject[Protocol, Label]","Object"},
				Description->"looks up the labeled 'Object'(s) associated with 'Label'(s) in the 'Protocol' object(s).",
				Inputs:>{
					{
						InputName -> "Protocol",
						Description-> "The protocol object(s) that contains the labeled object.",
						Widget-> Alternatives[
							Widget[
								Type -> Object,
								Pattern :> ObjectP[Object[Protocol]]
							],
							Adder[Widget[
								Type -> Object,
								Pattern :> ObjectP[Object[Protocol]]
							]]
						],
						Expandable->False
					},
					{
						InputName -> "Label",
						Description-> "The label(s) that was used to identify the object in the protocol.",
						Widget-> Alternatives[
							Widget[
								Type -> String,
								Pattern :> _String,
								Size -> Word
							],
							Adder[Widget[
								Type -> String,
								Pattern :> _String,
								Size -> Word
							]]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"object",
						Description->"The corresponding labeled object(s).",
						Pattern:>ObjectP[]
					}
				}
			},
			{
				Definition->{"LookupLabeledObject[Simulation, Label]","Object"},
				Description->"looks up the labeled 'Object'(s) associated with 'Label'(s) in the 'Simulation'.",
				Inputs:>{
					{
						InputName -> "Simulation",
						Description-> "The simulation that contains the labeled object.",
						Widget->Widget[
							Type -> Expression,
							Pattern :> SimulationP,
							Size -> Line
						],
						Expandable->False
					},
					{
						InputName -> "Label",
						Description-> "The label(s) that was used to identify the object in the protocol.",
						Widget->Alternatives[
							Widget[
								Type -> String,
								Pattern :> _String,
								Size -> Word
							],
							Adder[Widget[
								Type -> String,
								Pattern :> _String,
								Size -> Word
							]]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"object",
						Description->"The corresponding labeled object(s).",
						Pattern:>ObjectP[]
					}
				}
			},
			{
				Definition->{"LookupLabeledObject[Script, Label]","Object"},
				Description->"looks up the labeled 'Object'(s) associated with 'Label'(s) in protocols that were executed in the 'Script' object.",
				Inputs:>{
					{
						InputName -> "Script",
						Description-> "The script object that executed protocols which contains the labeled object.",
						Widget->Widget[
							Type -> Object,
							Pattern :> ObjectP[Object[Notebook, Script]]
						],
						Expandable->False
					},
					{
						InputName -> "Label",
						Description-> "The label(s) that was used to identify the object in the protocol.",
						Widget->Alternatives[
							Widget[
								Type -> String,
								Pattern :> _String,
								Size -> Word
							],
							Adder[Widget[
								Type -> String,
								Pattern :> _String,
								Size -> Word
							]]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"object",
						Description->"The corresponding labeled object(s).",
						Pattern:>ObjectP[]
					}
				}
			}
		},
		SeeAlso -> {
			"Experiment",
			"ExperimentSamplePreparation",
			"ExperimentCellPreparation"
		},
		Tutorials -> {},
		Author -> {"dima", "steven"}
	}
];

(* ::Subsubsection::Closed:: *)
(*RestrictLabeledSamples*)

DefineUsage[RestrictLabeledSamples,
	{
		BasicDefinitions -> {
			{
				Definition->{"RestrictLabeledSamples[Samples]","Objects"},
				Description->"restricts 'samples' that were labeled preventing their use for model fulfillment.",
				Inputs:>{
					{
						InputName -> "Samples",
						Description-> "Samples that were assigned to labels and now can not be use for model fulfillment.",
						Widget->Widget[
							Type -> Object,
							Pattern :> ObjectP[{Object[Sample], Object[Container], Object[Item]}]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"Objects",
						Description->"Objects that were assigned to labels and now can not be use for model fulfillment.",
						Pattern:>ObjectP[]
					}
				}
			}
		},
		SeeAlso -> {
			"Experiment",
			"ExperimentSamplePreparation",
			"ExperimentCellPreparation",
			"UnrestrictLabeledSamples",
			"RestrictSamples"
		},
		Tutorials -> {},
		Author -> {"dima", "steven"}
	}
];

(* ::Subsubsection::Closed:: *)
(*UnrestrictLabeledSamples*)

DefineUsage[UnrestrictLabeledSamples,
	{
		BasicDefinitions -> {
			{
				Definition->{"UnrestrictLabeledSamples[Samples]","Objects"},
				Description->"unrestricts 'samples' that were labeled allowing their use for model fulfillment.",
				Inputs:>{
					{
						InputName -> "Samples",
						Description-> "Samples that were assigned to labels and now can be use for model fulfillment.",
						Widget->Widget[
							Type -> Object,
							Pattern :> ObjectP[{Object[Sample], Object[Container], Object[Item]}]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"Objects",
						Description->"Objects that were assigned to labels and now can be use for model fulfillment.",
						Pattern:>ObjectP[]
					}
				}
			}
		},
		SeeAlso -> {
			"Experiment",
			"ExperimentSamplePreparation",
			"ExperimentCellPreparation",
			"RestrictLabeledSamples",
			"UnrestrictSamples"
		},
		Tutorials -> {},
		Author -> {"dima", "steven"}
	}
];

(* ::Subsubsection::Closed:: *)
(*SimulateResources*)

DefineUsage[Experiment`Private`SimulateResources,
	{
		BasicDefinitions -> {
			{
				Definition->{"Experiment`Private`SimulateResources[ProtocolPacket]","Simulation"},
				Description->"replaces any resource requests in the given 'ProtocolPacket' with simulated samples/containers/items.",
				Inputs:>{
					{
						InputName -> "ProtocolPacket",
						Description-> "The protocol packet that contains the resource requests to be simulated.",
						Widget->Widget[
							Type -> Object,
							Pattern :> ObjectP[Object[Protocol]]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"Simulation",
						Description->"The simulation that contains the simulated samples/containers/items inside of the protocol object.",
						Pattern:>ObjectP[]
					}
				}
			}
		},
		SeeAlso -> {
			"Experiment",
			"ExperimentSamplePreparation",
			"ExperimentCellPreparation"
		},
		Tutorials -> {},
		Author -> {"steven"}
	}
];

(* ::Subsubsection::Closed:: *)
(*updateLabelFieldReferences*)
DefineUsage[updateLabelFieldReferences,
	{
		BasicDefinitions -> {
			{
				Definition->{"Experiment`Private`updateLabelFieldReferences[simulation,parentField]","updatedSimulation"},
				Description->"updates the LabelFields of the 'simulation' to reference objects via 'parentField' instead of directly. Useful for when we have child UO inside a parent UO. Should be called in the parent UO resolved (for example Aliquot) once it is done resolving.",
				Inputs:>{
					{
						InputName -> "simulation",
						Description-> "The simulation to be updated.",
						Widget->Widget[
							Type -> Expression,
							Pattern :> SimulationP,
							Size -> Line
						],
						Expandable->False
					},
					{
						InputName -> "parentField",
						Description-> "The field in the parent UnitOperation that contains the child UnitOperations (RoboticUnitOperations, etc.).",
						Widget->Widget[
							Type -> Expression,
							Pattern :> _Symbol,
							Size -> Word
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"updatedSimulation",
						Description->"The simulation that contains updated LabelFields.",
						Pattern:>SimulationP
					}
				}
			}
		},
		SeeAlso -> {
			"Experiment",
			"LookupLabeledObjects",
			"Experiment`Private`SimulateResources"
		},
		Tutorials -> {},
		Author -> {"dima"}
	}
];
(* ::Subsubsection::Closed:: *)
(*addLabelFields*)
DefineUsage[addLabelFields,{
	BasicDefinitions -> {
		{
			Definition->{"Experiment`Private`addLabelFields[primitiveOptions,primitiveOptionDefinitions,labelFieldLookup]","primitiveOptionsWithLabels"},
			Description->"replaces any existing label in 'primitiveOptions' (can be options or inputs) with values from 'labelFieldLookup' relying on the UO definitions in 'primitiveOptionDefinitions'. In some cases, the replacement value is a reference to another field so we can later use this in the script generation. Note: this function can be further abstracted to take only UO and simulation, but for computation reasons it is currently not structured that way.",
			Inputs:>{
				{
					InputName -> "primitiveOptions",
					Description-> "The unit operation entries that need their labels replaced.",
					Widget->Widget[
						Type -> Expression,
						Pattern :> _,
						Size->Paragraph
					],
					Expandable->False
				},
				{
					InputName -> "primitiveOptionDefinitions",
					Description-> "The option definitions for this unit operations.",
					Widget->Widget[
						Type -> Expression,
						Pattern :> _,
						Size->Paragraph
					],
					Expandable->False
				},
				{
					InputName -> "labelFieldLookup",
					Description-> "Lookup rules derived from LabelFields of the corresponding Simulation.",
					Widget->Widget[
						Type -> Expression,
						Pattern :> _,
						Size->Paragraph
					],
					Expandable->False
				}

			},
			Outputs:>{
				{
					OutputName->"primitiveOptionsWithLabels",
					Description->"Unit operation options with labels replaced with field references where relevant.",
					Pattern:>_
				}
			}
		}
	},
	SeeAlso -> {
		"Experiment",
		"LookupLabeledObjects",
		"Experiment`Private`SimulateResources",
		"Experiment`Private`updateLabelFieldReferences"
	},
	Tutorials -> {},
	Author -> {"thomas"}
}];

(* ::Subsubsection::Closed:: *)
(*joinClauses*)

DefineUsage[joinClauses,
	{
		BasicDefinitions -> {
			{
				Definition -> {"Experiment`Private`joinClauses[inputClauses]", "combinedClause"},
				Description -> "join all 'inputClauses' to a 'combinedClause'.",
				Inputs :> {
					{
						InputName -> "inputClauses",
						Description -> "A list of strings (clauses) to be joined.",
						Widget-> Adder[Widget[
							Type -> String,
							Pattern :> _String,
							Size -> Line
						]],
						Expandable -> False
					}
				},
				Outputs :> {
					{
						OutputName -> "combinedClause",
						Description -> "The single combined string (clause) without any duplicates and with conjuction word.",
						Pattern :> _String
					}
				}
			}
		},
		SeeAlso -> {
			"Experiment",
			"LookupLabeledObjects",
			"ExperimentFreezeCells"
		},
		Tutorials -> {},
		Author -> {"lige.tonggu"}
	}
]