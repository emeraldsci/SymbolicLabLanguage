(* ::Package:: *)

(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Shared Options*)


(* ::Subsubsection:: *)
(*TemperatureOption*)


DefineOptionSet[
	TemperatureOption :> {
		{
			OptionName->Temperature,
			Default->37 Celsius,
			AllowNull->False,
			Widget->Alternatives[
					Widget[Type->Quantity, Pattern:>GreaterEqualP[0 Kelvin], Units->Alternatives[Kelvin,Celsius,Fahrenheit]],
					Widget[Type->Enumeration, Pattern:>Alternatives[Null]],
					Widget[Type->Expression, Pattern:>_Function, Size->Line]
				],
			Description->"Temperature used to calculate Gibbs free energy while running the simulation. Temperature will affect the rates of the reactions. If a Function, Temperature must be in Kelvin."
		}
	}
];


(* ::Subsubsection:: *)
(*MaxMismatchOption*)


DefineOptionSet[
	MaxMismatchOption :> {
		{
			OptionName->MaxMismatch,
			Default->0,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[True,False]],
			Description->"Maximum number of mismatches that can exist in consecutive base pairs."
		}
	}
];


(* ::Subsubsection:: *)
(*MinPieceSizeOption*)


DefineOptionSet[
	MinPieceSizeOption :> {
		{
			OptionName->MinPieceSize,
			Default->1,
			AllowNull->False,
			Widget->Widget[Type->Number, Pattern:>GreaterP[0, 1]],
			Description->"Minimum number of consecutive paired bases required when containing mismatches."
		}
	}
];


(* ::Subsubsection:: *)
(*InterStrandFoldingOption*)


DefineOptionSet[
	InterStrandFoldingOption :> {
		{
			OptionName->InterStrandFolding,
			Default->True,
			AllowNull->False,
			Widget->Widget[Type->Number, Pattern:>GreaterP[0, 1]],
			Description->"For a hybridized structure, allow Folding among different Strands that are already bonded in this Structure."
		}
	}
];


(* ::Subsubsection:: *)
(*IntraStrandFoldingOption*)


DefineOptionSet[
	IntraStrandFoldingOption :> {
		{
			OptionName->IntraStrandFolding,
			Default->True,
			AllowNull->False,
			Widget->Widget[Type->Number, Pattern:>GreaterP[0, 1]],
			Description->"For a hybridized structure, allow self Folding of individual Strand."
		}
	}
];


(* ::Subsubsection:: *)
(*MinLevelOption*)


DefineOptionSet[
	MinLevelOption :> {
		{
			OptionName->MinLevel,
			Default->3,
			AllowNull->False,
			Widget->Widget[Type->Number, Pattern:>GreaterEqualP[0, 1]],
			Description->"Minimum number of bases required in each duplex."
		}
	}
];


(* ::Subsubsection:: *)
(*PolymerOption*)


DefineOptionSet[
	PolymerOption :> {
		{
			OptionName->Polymer,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[Automatic, DNA, RNA, Null]],
			Description->"The polymer type that defines the potnetial alphabaet a valid sequence should be composed of when the input sequence is ambiguous."
		}
	}
];

(*SimulationTemplateOption*)
DefineOptionSet[SimulationTemplateOption:>{
	{
		OptionName -> Template,
		Default -> Null,
		Description -> "A template simulation object whose methodology should be reproduced in running this simulation. Option values will be inherited from the template simulation object, but can be individually overridden by directly specifying values for those options to this Simulation function.",
		AllowNull -> True,
		Category -> "Method",
		Widget -> Widget[Type->Object,Pattern:>ObjectP[Types[Object[Simulation]]],ObjectTypes->{Object[Simulation]}]
	}
}];