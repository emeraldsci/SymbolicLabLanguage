(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection::Closed:: *)
(*Units*)


(* ::Subsubsection::Closed:: *)
(*AbsorbanceAreaQ*)


DefineUsage[AbsorbanceAreaQ,
	{
		BasicDefinitions -> {
			{"AbsorbanceAreaQ[item]", "validUnit", "tests if the given item is in Units of AbsorbanceUnits times Units of time."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of AbsorbanceUnit times Units of time."}
		},
		SeeAlso -> {
			"UnitsQ",
			"AbsorbanceQ",
			"AbsorbanceRateQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*AbsorbanceDistanceQ*)


DefineUsage[AbsorbanceDistanceQ,
	{
		BasicDefinitions -> {
			{"AbsorbanceDistanceQ[item]", "validUnit", "tests if the given item is in Units of AbsorbanceUnit times Units of distance."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of AbsorbanceUnit times Units of distance."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*AbsorbancePerDistanceQ*)


DefineUsage[AbsorbancePerDistanceQ,
	{
		BasicDefinitions -> {
			{"AbsorbancePerDistanceQ[item]", "validUnit", "tests if the given item is in Units of AbsorbanceUnit per Units of distance."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of AbsorbanceUnit per Units of distance."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*AbsorbanceQ*)


DefineUsage[AbsorbanceQ,
	{
		BasicDefinitions -> {
			{"AbsorbanceQ[item]", "validUnit", "tests if the given item is in Units of AbsorbanceUnit."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of AbsorbanceUnit."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*AbsorbanceRateQ*)


DefineUsage[AbsorbanceRateQ,
	{
		BasicDefinitions -> {
			{"AbsorbanceRateQ[item]", "validUnit", "tests if the given item is in Units of AbsorbanceUnit per Units of time."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of AbsorbanceUnit per Units of time."}
		},
		SeeAlso -> {
			"UnitsQ",
			"AbsorbanceQ",
			"AbsorbanceAreaQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*AccelerationQ*)


DefineUsage[AccelerationQ,
	{
		BasicDefinitions -> {
			{"AccelerationQ[item]", "validUnit", "tests if the given item is in Units of distance per time-squared."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of acceleration."}
		},
		SeeAlso -> {
			"UnitsQ",
			"AbsorbanceQ"
		},
		Author -> {
			"brad",
			"srikant"
		}
	}];



(* ::Subsubsection::Closed:: *)
(*AllGreaterEqual*)


DefineUsage[AllGreaterEqual,
	{
		BasicDefinitions -> {
			{"AllGreaterEqual[array,val]", "bool", "returns True if every element in 'array' is greater than or equal 'val'."},
			{"AllGreaterEqual[array,vals]", "bool", "compares bottom level lists in 'array' to list 'vals'."}
		},
		Input :> {
			{"array", _?ArrayQ | _?QuantityArrayQ, "A numerical array or QuantityArray.  Array can have any dimensions."},
			{"val", _?UnitsQ, "A value to compare against the elements in 'array'.  Units of 'val' must be compatible with units of 'array'."},
			{"vals", {_?UnitsQ..}, "A list of values to compare against the bottom level lists in 'array'.  Length of 'vals' must match Last[Dimensions['array']].  Units of 'vals' can be different, but must be compatible with the corresponding units in the bottom level lists in 'array'."}
		},
		Output :> {
			{"bool", True | False, "True if every element in 'array' is greater than the specied value or values."}
		},
		SeeAlso -> {
			"Greater",
			"GreaterP",
			"AllGreater",
			"AllLessEqual",
			"AllLess"
		},
		Author -> {
			"brad",
			"alice",
			"qian",
			"thomas"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*AllGreater*)


DefineUsage[AllGreater,
	{
		BasicDefinitions -> {
			{"AllGreater[array,val]", "bool", "returns True if every element in 'array' is greater than 'val'."},
			{"AllGreater[array,vals]", "bool", "compares bottom level lists in 'array' to list 'vals'."}
		},
		Input :> {
			{"array", _?ArrayQ | _?QuantityArrayQ, "A numerical array or QuantityArray.  Array can have any dimensions."},
			{"val", _?UnitsQ, "A value to compare against the elements in 'array'.  Units of 'val' must be compatible with units of 'array'."},
			{"vals", {_?UnitsQ..}, "A list of values to compare against the bottom level lists in 'array'.  Length of 'vals' must match Last[Dimensions['array']].  Units of 'vals' can be different, but must be compatible with the corresponding units in the bottom level lists in 'array'."}
		},
		Output :> {
			{"bool", True | False, "True if every element in 'array' is greater than the specied value or values."}
		},
		SeeAlso -> {
			"Greater",
			"GreaterP",
			"AllGreaterEqual"
		},
		Author -> {
			"brad",
			"alice",
			"qian",
			"thomas"
		}
	}];



(* ::Subsubsection::Closed:: *)
(*AllLessEqual*)


DefineUsage[AllLessEqual,
	{
		BasicDefinitions -> {
			{"AllLessEqual[array,val]", "bool", "returns True if every element in 'array' is less than or equal 'val'."},
			{"AllLessEqual[array,vals]", "bool", "compares bottom level lists in 'array' to list 'vals'."}
		},
		Input :> {
			{"array", _?ArrayQ | _?QuantityArrayQ, "A numerical array or QuantityArray.  Array can have any dimensions."},
			{"val", _?UnitsQ, "A value to compare against the elements in 'array'.  Units of 'val' must be compatible with units of 'array'."},
			{"vals", {_?UnitsQ..}, "A list of values to compare against the bottom level lists in 'array'.  Length of 'vals' must match Last[Dimensions['array']].  Units of 'vals' can be different, but must be compatible with the corresponding units in the bottom level lists in 'array'."}
		},
		Output :> {
			{"bool", True | False, "True if every element in 'array' is greater than the specied value or values."}
		},
		SeeAlso -> {
			"Greater",
			"GreaterP",
			"AllGreaterEqual",
			"AllGreater",
			"AllLess"
		},
		Author -> {
			"brad",
			"alice",
			"qian",
			"thomas"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*AllLess*)


DefineUsage[AllLess,
	{
		BasicDefinitions -> {
			{"AllLess[array,val]", "bool", "returns True if every element in 'array' is less than 'val'."},
			{"AllLess[array,vals]", "bool", "compares bottom level lists in 'array' to list 'vals'."}
		},
		Input :> {
			{"array", _?ArrayQ | _?QuantityArrayQ, "A numerical array or QuantityArray.  Array can have any dimensions."},
			{"val", _?UnitsQ, "A value to compare against the elements in 'array'.  Units of 'val' must be compatible with units of 'array'."},
			{"vals", {_?UnitsQ..}, "A list of values to compare against the bottom level lists in 'array'.  Length of 'vals' must match Last[Dimensions['array']].  Units of 'vals' can be different, but must be compatible with the corresponding units in the bottom level lists in 'array'."}
		},
		Output :> {
			{"bool", True | False, "True if every element in 'array' is greater than the specied value or values."}
		},
		SeeAlso -> {
			"Greater",
			"GreaterP",
			"AllGreaterEqual",
			"AllGreater",
			"AllLessEqual"
		},
		Author -> {
			"brad",
			"alice",
			"qian",
			"thomas"
		}
	}];



(* ::Subsubsection::Closed:: *)
(*AmountQ*)


DefineUsage[AmountQ,
	{
		BasicDefinitions -> {
			{"AmountQ[item]", "validUnit", "tests if the given item is in Units of Moles."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of Moles."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*AngularVelocityQ*)


DefineUsage[AngularVelocityQ,
	{
		BasicDefinitions -> {
			{"AngularVelocityQ[item]", "validUnit", "tests if the given item is in Units of revolutions per time."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of revolutions per time."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*ArbitraryUnitQ*)


DefineUsage[ArbitraryUnitQ,
	{
		BasicDefinitions -> {
			{"ArbitraryUnitQ[item]", "validUnit", "tests if the given item is in Units of ArbitraryUnits."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of ArbitraryUnits."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*AreaQ*)


DefineUsage[AreaQ,
	{
		BasicDefinitions -> {
			{"AreaQ[item]", "validUnit", "tests if the given item is in Units of distance squared."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of distance squared."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*BasePairQ*)


DefineUsage[BasePairQ,
	{
		BasicDefinitions -> {
			{"BasePairQ[item]", "validUnit", "tests if the given item is in Units of BasePair."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of BasePair."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*ByteQ*)


DefineUsage[ByteQ,
	{
		BasicDefinitions -> {
			{"ByteQ[item]", "isByte", "returns true if the provided item has Units bytes."}
		},
		Input :> {
			{"item", _, "An item to test see if it is in Bytes."}
		},
		Output :> {
			{"isByte", BooleanP, "True if 'item' has Units Bytes."}
		},
		SeeAlso -> {
			"UnitsQ",
			"BasePairQ"
		},
		Author -> {
			"xu.yi"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*ChemicalShiftQ*)


DefineUsage[ChemicalShiftQ,
	{
		BasicDefinitions -> {
			{"ChemicalShiftQ[item]", "validUnit", "tests if the given item is in Units of PPM."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of PPM."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*ChemicalShiftStrengthQ*)


DefineUsage[ChemicalShiftStrengthQ,
	{
		BasicDefinitions -> {
			{"ChemicalShiftStrengthQ[item]", "validUnit", "tests if the given item is in Units of PPM times ArbitraryUnits."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of PPM times ArbitraryUnits."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*CFUQ*)


DefineUsage[CFUQ,
	{
		BasicDefinitions -> {
			{"CFUQ[item]", "validUnit", "tests if the given item is in Units of CFU."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of CFU."}
		},
		SeeAlso -> {
			"UnitsQ",
			"CFUConcentrationQ"
		},
		Author -> {"harrison.gronlund", "taylor.hochuli"}
	}];
(* ::Subsubsection::Closed:: *)
(*CFUConcentrationQ*)


DefineUsage[CFUConcentrationQ,
	{
		BasicDefinitions -> {
			{"CFUConcentrationQ[item]", "validUnit", "tests if the given item is in Units of CFU per volume."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of CFU per volume."}
		},
		SeeAlso -> {
			"UnitsQ",
			"CFUQ"
		},
		Author -> {"harrison.gronlund", "taylor.hochuli"}
	}];

(* ::Subsubsection::Closed:: *)
(*ColonyCountQ*)


DefineUsage[ColonyCountQ,
	{
		BasicDefinitions -> {
			{"ColonyCountQ[item]", "validUnit", "tests if the given item is in Units of Colony."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of Colony."}
		},
		SeeAlso -> {
			"UnitsQ",
			"Colony",
			"CFUQ"
		},
		Author -> {"lige.tonggu", "harrison.gronlund"}
	}];

(* ::Subsubsection::Closed:: *)
(*ConcentrationQ*)


DefineUsage[ConcentrationQ,
	{
		BasicDefinitions -> {
			{"ConcentrationQ[item]", "validUnit", "tests if the given item is in Units of molarity."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of molarity."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConductanceQ"
		},
		Author -> {
			"brad",
			"Frezza",
			"Anand"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*ConductanceAreaQ*)


DefineUsage[ConductanceAreaQ,
	{
		BasicDefinitions -> {
			{"ConductanceAreaQ[item]", "validUnit", "tests if the given item is in Units of conductance times units of time."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of conductance times units of time."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*ConductancePerTimeQ*)


DefineUsage[ConductancePerTimeQ,
	{
		BasicDefinitions -> {
			{"ConductancePerTimeQ[item]", "validUnit", "tests if the given item is in Units of conductance per Units of time."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of conductance per Units of time."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*ConductanceQ*)


DefineUsage[ConductanceQ,
	{
		BasicDefinitions -> {
			{"ConductanceQ[item]", "validUnit", "tests if the given item is in Units of Siemens per distance."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of Siemens per distance."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*CurrencyQ*)


DefineUsage[CurrencyQ,
	{
		BasicDefinitions -> {
			{"CurrencyQ[item]", "isCurrency", "returns true if the provided item has unit that is unit of money."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"isCurrency", BooleanP, "True if item is in Units of money."}
		},
		SeeAlso -> {
			"UnitsQ",
			"CurrencyForm",
			"Convert"
		},
		Author -> {
			"brad",
			"Jonathan",
			"Ruben",
			"frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*CurrentQ*)


DefineUsage[CurrentQ,
	{
		BasicDefinitions -> {
			{"CurrentQ[item]", "validUnit", "tests if the given item is in Units of Ampere."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of Ampere."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*CycleQ*)


DefineUsage[CycleQ,
	{
		BasicDefinitions -> {
			{"CycleQ[item]", "validUnit", "tests if the given item is in Units of Cycle."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of Cycle."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*DensityQ*)


DefineUsage[DensityQ,
	{
		BasicDefinitions -> {
			{"DensityQ[item]", "validUnit", "tests if the given item is in Units of Mass over Units of volume."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of Mass per volume."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*DistanceQ*)


DefineUsage[DistanceQ,
	{
		BasicDefinitions -> {
			{"DistanceQ[item]", "validUnit", "tests if the given item is in Units of Distance."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of Distance."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*EnergyQ*)


DefineUsage[EnergyQ,
	{
		BasicDefinitions -> {
			{"EnergyQ[item]", "validUnit", "tests if the given item is in Units of molar energy."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of molar energy."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*EntropyQ*)


DefineUsage[EntropyQ,
	{
		BasicDefinitions -> {
			{"EntropyQ[item]", "validUnit", "tests if the given item is in Units of molar entropy."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of molar entropy."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*ExtinctionCoefficientQ*)


DefineUsage[ExtinctionCoefficientQ,
	{
		BasicDefinitions -> {
			{"ExtinctionCoefficientQ[item]", "validUnit", "tests if the given item is in Units of Liter/(Centi Meter Mole)."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of Liter/(Centi Meter Mole)."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*FirstOrderRateQ*)


DefineUsage[FirstOrderRateQ,
	{
		BasicDefinitions -> {
			{"FirstOrderRateQ[item]", "validUnit", "tests if the given item is in Units of first order rate constants (per time)."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of per time."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*FlowRateQ*)


DefineUsage[FlowRateQ,
	{
		BasicDefinitions -> {
			{"FlowRateQ[item]", "validUnit", "tests if the given item is in Units of Volume per Units of Time."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of Volume per Units of Time."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*FluorescenceAreaQ*)


DefineUsage[FluorescenceAreaQ,
	{
		BasicDefinitions -> {
			{"FluorescenceAreaQ[item]", "validUnit", "tests if the given item is in Units of RFU times Units of distance."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of RFU times Units of distance."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*FluorescencePerAreaQ*)


DefineUsage[FluorescencePerAreaQ,
	{
		BasicDefinitions -> {
			{"FluorescencePerAreaQ[item]", "validUnit", "tests if the given item is in Units of RFU per Units of distance."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of RFU per Units of distance."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*FluorescenceQ*)


DefineUsage[FluorescenceQ,
	{
		BasicDefinitions -> {
			{"FluorescenceQ[item]", "validUnit", "tests if the given item is in Units of RFU."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of RFU."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*FluorescenceTimeQ*)


DefineUsage[FluorescenceTimeQ,
	{
		BasicDefinitions -> {
			{"FluorescenceTimeQ[item]", "validUnit", "tests if the given item is in Units of RFU times time."}
		},
		Input :> {
			{"item", _, "The 'item' you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if 'item' is in Units of RFU times time."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Jonathan",
			"Ruben",
			"frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*FormazinTurbidityUnitQ*)


DefineUsage[FormazinTurbidityUnitQ,
	{
		BasicDefinitions -> {
			{"FormazinTurbidityUnitQ[item]", "validUnit", "tests if the given item is in Units of FormazinTurbidityUnit."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of FormazinTurbidityUnit."}
		},
		SeeAlso -> {
			"UnitsQ",
			"NephelometricTurbidityUnitQ",
			"RelativeNephelometricUnitQ"
		},
		Author -> {"harrison.gronlund", "taylor.hochuli"}
	}];
(* ::Subsubsection::Closed:: *)
(*FrequencyQ*)


DefineUsage[FrequencyQ,
	{
		BasicDefinitions -> {
			{"FrequencyQ[item]", "validUnit", "tests if the given item is in Units per time or Hertz."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of per time or Hertz."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*InverseMolecularWeightQ*)


DefineUsage[InverseMolecularWeightQ,
	{
		BasicDefinitions -> {
			{"InverseMolecularWeightQ[item]", "validUnit", "tests if the given item is in Units of inverse molecular weight."}
		},
		MoreInformation -> {
			""
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of inverse molecualr weight."}
		},
		SeeAlso -> {
			"UnitsQ",
			"MolecularWeightQ"
		},
		Author -> {
			"brad",
			"Frezza",
			"Yang"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*ISOQ*)


DefineUsage[ISOQ,
	{
		BasicDefinitions -> {
			{"ISOQ[item]", "validUnit", "tests if the given item is in Units of ISO."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of ISO."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*RRTQ*)


DefineUsage[RRTQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"RRTQ[item]", "validUnit"},
				Description -> "tests if the given item is in Units of RRT.",
				Inputs :> {
					{
						InputName -> "item",
						Description -> "The item you wish to query.",
						Widget -> Widget[Type -> Expression, Pattern :> _, Size -> Line]
					}
				},
				Outputs :> {
					{
						OutputName -> "validUnit",
						Description -> "True if item is in Units of RRT.",
						Pattern :> BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"xu.yi"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*LuminescencePerMolecularWeightQ*)


DefineUsage[LuminescencePerMolecularWeightQ,
	{
		BasicDefinitions -> {
			{"LuminescencePerMolecularWeightQ[item]", "validUnit", "tests if the given item is in Units of luminescence per molecular weight."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of luminescence per molecular weight."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*LuminescenceQ*)


DefineUsage[LuminescenceQ,
	{
		BasicDefinitions -> {
			{"LuminescenceQ[item]", "validUnit", "tests if the given item is in Units of Lumens."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of Lumens."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*MassConcentrationQ*)


DefineUsage[MassConcentrationQ,
	{
		BasicDefinitions -> {
			{"MassConcentrationQ[item]", "validUnit", "tests if the given item is in Units of mass concentration (SI Units: kg/m^3, kg/L)."}
		},
		MoreInformation -> {
			"Technically mass concentrations have identical Units to denisities and so inputs will test positive with DensityQ in ever case as well."
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of mass concentration (eg. kg/m^3, kg/L)."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*MassExtinctionCoefficientQ*)


DefineUsage[MassExtinctionCoefficientQ,
	{
		BasicDefinitions -> {
			{"MassExtinctionCoefficientQ[item]", "validUnit", "tests if the given item is in Units of Liter/(Centi Meter Gram)."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of Liter/(Centi Meter Gram)."}
		},
		SeeAlso -> {
			"UnitsQ",
			"MassConcentrationQ",
			"ExtinctionCoefficientQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*MassQ*)


DefineUsage[MassQ,
	{
		BasicDefinitions -> {
			{"MassQ[item]", "validUnit", "tests if the given item is in Units of Mass."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of Mass."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*MolecularWeightLuminescenceAreaQ*)


DefineUsage[MolecularWeightLuminescenceAreaQ,
	{
		BasicDefinitions -> {
			{"MolecularWeightLuminescenceAreaQ[item]", "validUnit", "tests if the given item is in Units of molecular weight times luminescence."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of weight times luminescence."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*MolecularWeightQ*)


DefineUsage[MolecularWeightQ,
	{
		BasicDefinitions -> {
			{"MolecularWeightQ[item]", "validUnit", "tests if the given item is in Units of molecular weight."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of molecular weight."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*MolecularWeightStrengthQ*)


DefineUsage[MolecularWeightStrengthQ,
	{
		BasicDefinitions -> {
			{"MolecularWeightStrengthQ[item]", "validUnit", "tests if the given item is in Units of ArbitraryUnit times Weight."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of ArbitraryUnit times Weight."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*NephelometricTurbidityUnitQ*)


DefineUsage[NephelometricTurbidityUnitQ,
	{
		BasicDefinitions -> {
			{"NephelometricTurbidityUnitQ[item]", "validUnit", "tests if the given item is in Units of NephelometricTurbidityUnit."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of NephelometricTurbidityUnit."}
		},
		SeeAlso -> {
			"UnitsQ",
			"FormazinTurbidityUnitQ",
			"RelativeNephelometricUnitQ"
		},
		Author -> {"harrison.gronlund", "taylor.hochuli"}
	}];
(* ::Subsubsection::Closed:: *)
(*NucleotideQ*)


DefineUsage[NucleotideQ,
	{
		BasicDefinitions -> {
			{"NucleotideQ[item]", "validUnit", "tests if the given item is in Units of Nucleotide."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of Nucleotide."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*OD600Q*)


DefineUsage[OD600Q,
	{
		BasicDefinitions -> {
			{"OD600Q[item]", "validUnit", "tests if the given item is in Units of OD600."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of OD600."}
		},
		SeeAlso -> {
			"UnitsQ",
			"CFUQ"
		},
		Author -> {"harrison.gronlund", "taylor.hochuli"}
	}];
(* ::Subsubsection::Closed:: *)
(*PercentQ*)


DefineUsage[PercentQ,
	{
		BasicDefinitions -> {
			{"PercentQ[item]", "validUnit", "tests if the given item is in Units of Percent."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of temperature."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*PercentRateQ*)


DefineUsage[PercentRateQ,
	{
		BasicDefinitions -> {
			{"PercentRateQ[item]", "validUnit", "tests if the given item is in Units of Percent per time."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of percent per time."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*PerMolarQ*)


DefineUsage[PerMolarQ,
	{
		BasicDefinitions -> {
			{"PerMolarQ[item]", "validUnit", "tests if the given item is in Units of 1/Molar."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of 1/Molar."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*PixelAreaQ*)


DefineUsage[PixelAreaQ,
	{
		BasicDefinitions -> {
			{"PixelAreaQ[item]", "validUnit", "tests if the given item is in Units of Pixels squared."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of Pixels squared."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*PixelQ*)


DefineUsage[PixelQ,
	{
		BasicDefinitions -> {
			{"PixelQ[item]", "validUnit", "tests if the given item is in Units of Pixels."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of Pixels."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*PixelsPerDistanceQ*)


DefineUsage[PixelsPerDistanceQ,
	{
		BasicDefinitions -> {
			{"PixelsPerDistanceQ[item]", "validUnit", "tests if the given item is in Units of Pixels per Units of distance."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of Pixels per Units of distance."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*PositiveQuantityQ*)


DefineUsage[PositiveQuantityQ,
	{
		BasicDefinitions -> {
			{"PositiveQuantityQ[item]", "bool", "returns a 'bool' indicating if 'item' is a unit-ed value with positive magnitude in its base unit."}
		},
		Input :> {
			{"item", _, "Thing that might be a positive quantity."}
		},
		Output :> {
			{"bool", True | False, "True if 'item' is a positive quantity."}
		},
		SeeAlso -> {
			"QuantityQ",
			"UnitsQ",
			"CompatibleUnitQ"
		},
		Author -> {"xu.yi", "hanming.yang", "thomas"}
	}
];


(* ::Subsubsection::Closed:: *)
(*PowerQ*)


DefineUsage[PowerQ,
	{
		BasicDefinitions -> {
			{"PowerQ[item]", "validUnit", "tests if the given item is in Units of Watts."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of Watts."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*PressureQ*)


DefineUsage[PressureQ,
	{
		BasicDefinitions -> {
			{"PressureQ[item]", "validUnit", "tests if the given item is in Units of Pressure."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of Pressure."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*RangeQ*)


DefineUsage[RangeQ,
	{
		BasicDefinitions -> {
			{"RangeQ[value,span]", "inRange", "checks if a given 'value' is inside the provided 'span'."},
			{"RangeQ[value,{min,max}]", "inRange", "tests if a given 'value' is inside the range from 'min' to max'."}
		},
		MoreInformation -> {
			"The function is unit frendly, and if provided spans and values that match CompatibleUnitQ, will Convert to a common form before performing the check.",
			"Null can be provided on either side of the range to add no additional restrictions to the maximum or minimum values."
		},
		Input :> {
			{"value", _?InfiniteNumericQ | _?UnitsQ, "The value you wish to test to see if it is in range."},
			{"span", (_?InfiniteNumericQ | _?UnitsQ | Null);;(_?InfiniteNumericQ | _?UnitsQ | Null), "The span of values defining the range of possible from min to max."},
			{"min", _?InfiniteNumericQ | _?UnitsQ | Null, "The minimum allowed value in the range."},
			{"max", _?InfiniteNumericQ | _?UnitsQ | Null, "The maximum allowed value in the range."}
		},
		Output :> {
			{"inRange", BooleanP, "True if the given 'value' is within the provided range."}
		},
		SeeAlso -> {
			"Equal",
			"Greater",
			"GreaterEqual",
			"Less",
			"LessEqual"
		},
		Author -> {"xu.yi", "Frezza", "Courtney", "brad"}
	}];



(* ::Subsubsection::Closed:: *)
(*RangeP*)


DefineUsage[RangeP,
	{
		BasicDefinitions -> {
			{"RangeP[min,max]", "pattern", "generates a pattern that will match a value between the provided 'min' and 'max'."},
			{"RangeP[min,max,increment]", "pattern", "generates a pattern that will match a value greater than 'min' by a multiple of 'increment' and also less than 'max'."},
			{"RangeP[increment]", "pattern", "generates a pattern that will match any value that is a multiple of 'increment'."}
		},
		MoreInformation -> {
			"The function is unit frendly, and if provided values that match CompatibleUnitQ, will Convert to a common form before performing the check."
		},
		Input :> {
			{"min", _?NumericQ | _?UnitsQ, "The minimum allowed value in the range."},
			{"max", _?NumericQ | _?UnitsQ, "The maximum allowed value in the range."},
			{"increment", _?NumericQ | _?UnitsQ, "The test value must greater than 'min' by a multiple of this 'increment'."}
		},
		Output :> {
			{"pattern", _PatternTest, "A pattern that will match a value in the provided min/max range."}
		},
		SeeAlso -> {
			"RangeQ",
			"GreaterP",
			"LessP",
			"GreaterEqualP",
			"LessEqualP"
		},
		Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
	}];


(* ::Subsubsection::Closed:: *)
(*RelativeNephelometricUnitQ*)


DefineUsage[RelativeNephelometricUnitQ,
	{
		BasicDefinitions -> {
			{"RelativeNephelometricUnitQ[item]", "validUnit", "tests if the given item is in Units of RelativeNephelometricUnit."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of RelativeNephelometricUnit."}
		},
		SeeAlso -> {
			"UnitsQ",
			"FormazinTurbidityUnitQ",
			"NephelometricTurbidityUnitQ"
		},
		Author -> {"harrison.gronlund", "taylor.hochuli"}
	}];
(* ::Subsubsection::Closed:: *)
(*ResistivityQ*)


DefineUsage[ResistivityQ,
	{
		BasicDefinitions -> {
			{"ResistivityQ[item]", "validUnit", "tests if the given item is in Units of resistance times Units of distance."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of resistance times Units of distance."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {"axu", "dirk.schild"}
	}];


(* ::Subsubsection::Closed:: *)
(*RPMQ*)


DefineUsage[RPMQ,
	{
		BasicDefinitions -> {
			{"RPMQ[item]", "validUnit", "tests if the given item is in Units of RPM."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of RPM."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*SecondOrderRateQ*)


DefineUsage[SecondOrderRateQ,
	{
		BasicDefinitions -> {
			{"SecondOrderRateQ[item]", "validUnit", "tests if the given item is in Units of second order rate constants per concentration per time."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of per concentration per time."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*StrengthPerChemicalShiftQ*)


DefineUsage[StrengthPerChemicalShiftQ,
	{
		BasicDefinitions -> {
			{"StrengthPerChemicalShiftQ[item]", "validUnit", "tests if the given item is in Units of ArbitraryUnits/PPM."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of PPM."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*StrengthPerMolecularWeightQ*)


DefineUsage[StrengthPerMolecularWeightQ,
	{
		BasicDefinitions -> {
			{"StrengthPerMolecularWeightQ[item]", "validUnit", "tests if the given item is in ArbitraryUnit per Units of weight."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in ArbitraryUnit per Units of weight."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*TemperatureQ*)


DefineUsage[TemperatureQ,
	{
		BasicDefinitions -> {
			{"TemperatureQ[item]", "validUnit", "tests if the given item is in Units of temperature."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of temperature."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*TemperatureRampRateQ*)


DefineUsage[TemperatureRampRateQ,
	{
		BasicDefinitions -> {
			{"TemperatureRampRateQ[item]", "validUnit", "tests if the given item is in Units of temperature per time."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of temperature per time."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*TimeOfFlightAreaQ*)


DefineUsage[TimeOfFlightAreaQ,
	{
		BasicDefinitions -> {
			{"TimeOfFlightAreaQ[item]", "validUnit", "test if the given item is in Units of time of flight spectra area."}
		},
		MoreInformation -> {
			"Time of flight spectra area is simply ArbitraryUnit times any time unit. This is mainly used in the peak area of time of flight spectra of mass spectrometry."
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of time of flight spectra area."}
		},
		SeeAlso -> {
			"UnitsQ",
			"TimeQ"
		},
		Author -> {
			"brad",
			"thomas",
			"Jonathan",
			"Wyatt"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*TimeQ*)


DefineUsage[TimeQ,
	{
		BasicDefinitions -> {
			{"TimeQ[item]", "validUnit", "tests if the given item is in Units of Time."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of Time."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*UnitBase*)


DefineUsage[UnitBase,
	{
		BasicDefinitions -> {
			{"UnitBase[q]", "baseUnit", "returns only the unit portion of the item in absence of the metric magnitude (sans the number and prefix)."},
			{"UnitBase[UnitDimension]", "baseUnit", "return only the unit portion of the item in absence of the metric magnitude (sans the number and prefix)."},
			{"UnitBase[UnitDimension,All]", "baseUnitList", "returns only the unit portion of the item in absence of the metric magnitude (sans the number and prefix)."}
		},
		Input :> {
			{"q", _?UnitsQ | _?KnownUnitQ, "Quantity to pull the base unit of."},
			{"UnitDimension", _String, "Dimension to find base unit of."}
		},
		Output :> {
			{"baseUnit", _?UnitsQ, "The base unit."},
			{"baseUnitList", {_?UnitsQ...}, "List of Units for given dimension."}
		},
		SeeAlso -> {
			"Units",
			"Unitless"
		},
		Author -> {"scicomp", "brad", "Frezza"}
	}];


(* ::Subsubsection::Closed:: *)
(*UnitDimension*)


DefineUsage[UnitDimension,
	{
		BasicDefinitions -> {
			{"UnitDimension[q]", "dimensionDescription", "returns a description of the unit measured by 'q'."}
		},
		Input :> {
			{"q", _?UnitsQ | _?KnownUnitQ | UnitDimensionP, "A value you wish to know the dimensions of."}
		},
		Output :> {
			{"dimensionDescription", _String, "Description of the quantity measured by the provided 'unit'."}
		},
		SeeAlso -> {
			"UnitForm",
			"UnitScale"
		},
		Author -> {"scicomp", "brad"}
	}];


(* ::Subsubsection::Closed:: *)
(*UnitFlatten*)


DefineUsage[UnitFlatten,
	{
		BasicDefinitions -> {
			{"UnitFlatten[q]", "qFlat", "converts 'q' to its base units (i.e. without any prefixes)."}
		},
		MoreInformation -> {
			"Seconds are considered the base Units for time, and Kelvin the base Units for temperature."
		},
		Input :> {
			{"q", _?UnitsQ, "The quantity to Convert to base Units."}
		},
		Output :> {
			{"qFlat", _?UnitsQ, "The flattened quantity."}
		},
		SeeAlso -> {
			"UnitScale",
			"Units"
		},
		Author -> {"scicomp", "brad", "Frezza"}
	}];


(* ::Subsubsection::Closed:: *)
(*Unitless*)


DefineUsage[Unitless,
	{
		BasicDefinitions -> {
			{"Unitless[expr]", "unitlessExpr", "removes any Units from an 'expr' to return only the numeric value."},
			{"Unitless[expr,targetUnit]", "unitlessExpr", "removes the Units from an 'expr' after first converting it to the 'targetUnit' Units."}
		},
		Input :> {
			{"expr", _, "An expression containing Quantities and/or QuantityArrays."},
			{"targetUnit", _?UnitsQ | {_?UnitsQ..}, "The unit you wish to Convert the expression's quanitites to before stripping the Units off."}
		},
		Output :> {
			{"unitlessExpr", _, "Expression whose quantities have been stripped of their Units."}
		},
		SeeAlso -> {
			"Units",
			"UnitBase"
		},
		Author -> {"scicomp", "brad", "Frezza"}
	}];


(* ::Subsubsection::Closed:: *)
(*Units*)


DefineUsage[Units,
	{
		BasicDefinitions -> {
			{"Units[q]", "unitQuantity", "returns a Quantity object containing the Units of the given quantity 'q'."},
			{"Units[qa,levelSpec]", "unitSpec", "returns a unit specification describing the units in the QuantityArray 'qa'."}
		},
		Input :> {
			{"q", _?UnitsQ, "A quantity to pull the units from."},
			{"qa", _?QuantityArrayQ, "A QuantityArray to pull the units from."},
			{"levelSpec", Automatic | _Integer | {_Integer}, "Level at which to pull the units from the QuantityArray."}
		},
		Output :> {
			{"unitQuantity", _?UnitsQ, "A Quantity object with magnitude 1 and same Units as input quantity."},
			{"unitSpec", _, "An array of units that matches the units of 'qa' at the level defined by 'levelSpec'."}
		},
		SeeAlso -> {
			"Unitless",
			"UnitBase",
			"QuantityUnit"
		},
		Author -> {"scicomp", "brad", "Frezza"}
	}];


(* ::Subsubsection::Closed:: *)
(*UnitsP*)


DefineUsage[UnitsP,
	{
		BasicDefinitions -> {
			{"UnitsP[q]", "patt", "returns a pattern that matches any quantity whose dimensions are compatible with the dimensions of 'q'."},
			{"UnitsP[q,increment]", "incPatt", "returns a pattern that matches any quantity whose dimensions match those of 'q' and is divisible by 'increment'."}
		},
		Input :> {
			{"q", _?UnitsQ | _?KnownUnitQ | _String, "A quantity whose unit base is used to generate a pattern."},
			{"increment", _?UnitsQ, "An increment to compare against."}
		},
		Output :> {
			{"patt", _, "Pattern that matches any quantity with compatible dimensions."},
			{"incPatt", _, "Pattern that matches any quantity with compatible dimensions that is divisible by 'increment'."}
		},
		SeeAlso -> {
			"UnitsQ",
			"Units"
		},
		Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
	}];


(* ::Subsubsection::Closed:: *)
(*UnitsQ*)


DefineUsage[UnitsQ,
	{
		BasicDefinitions -> {
			{"UnitsQ[item]", "validUnit", "tests if the item is in the form of Units known to Emerald's EmeraldUnits.m package."},
			{"UnitsQ[item,compatibleUnit]", "validUnit", "tests if the item is compatible with 'compatibleUnit'."}
		},
		Input :> {
			{"item", _, "The input you wish to if is in the form of Units recognized by Emerald's EmeraldUnits.m package."},
			{"compatibleUnit", _?UnitsQ, "A unit to compare 'item' to."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if the Units are known and match the baseUnit(s) UnitBase."}
		},
		SeeAlso -> {
			"CompatibleUnitQ",
			"Units",
			"UnitsP"
		},
		Author -> {"scicomp", "brad", "Frezza"}
	}];


(* ::Subsubsection::Closed:: *)
(*SpeedQ*)


DefineUsage[SpeedQ,
	{
		BasicDefinitions -> {
			{"SpeedQ[item]", "validUnit", "tests if the given item is in Units of distance per time."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of distance per time."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*ViscosityQ*)


DefineUsage[ViscosityQ,
	{
		BasicDefinitions -> {
			{"ViscosityQ[item]", "validUnit", "tests if the given item is in Units of pressure pre time or mass per distance times time."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of pressure pre time or mass per distance times time."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*VoltageQ*)


DefineUsage[VoltageQ,
	{
		BasicDefinitions -> {
			{"VoltageQ[item]", "validUnit", "tests if the given item is in Units of Volts."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of Volts."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];

(* ::Subsubsection::Closed:: *)
(*PercentConfluencyQ*)


DefineUsage[PercentConfluencyQ,
	{
		BasicDefinitions -> {
			{"PercentConfluencyQ[item]", "out", "test if the given item is in Units of percent confluency."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"out", BooleanP, "True if item is in Units of percent confluency."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ",
			"MassConcentrationQ",
			"VolumePercentQ"
		},
		Author -> {
			"brad"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*MassPercentQ*)


DefineUsage[MassPercentQ,
	{
		BasicDefinitions -> {
			{"MassPercentQ[item]", "out", "test if the given item is in Units of Mass Percent."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"out", BooleanP, "True if item is in Units of mass percent."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ",
			"MassConcentrationQ",
			"VolumePercentQ"
		},
		Author -> {
			"brad"
		}
	}];

(* ::Subsubsection::Closed:: *)
(*VolumePercentQ*)


DefineUsage[VolumePercentQ,
	{
		BasicDefinitions -> {
			{"VolumePercentQ[item]", "out", "test if the given item is in Units of volume percent."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"out", BooleanP, "True if item is in Units of volume percent."}
		},
		SeeAlso -> {
			"UnitsQ",
			"PercentQ",
			"WeightVolumePercentQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*DimensionlessQ*)


DefineUsage[DimensionlessQ,
	{
		BasicDefinitions -> {
			{"DimensionlessQ[item]", "out", "test if the given item has no dimension units."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"out", BooleanP, "True if item has no dimension units."}
		},
		SeeAlso -> {
			"UnitsQ",
			"PercentQ",
			"WeightVolumePercentQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*NoUnitQ*)


DefineUsage[NoUnitQ,
	{
		BasicDefinitions -> {
			{"NoUnitQ[item]", "out", "test if the given item has no units."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"out", BooleanP, "True if item has no units."}
		},
		SeeAlso -> {
			"UnitsQ",
			"PercentQ",
			"WeightVolumePercentQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];



(* ::Subsubsection::Closed:: *)
(*VolumeQ*)


DefineUsage[VolumeQ,
	{
		BasicDefinitions -> {
			{"VolumeQ[item]", "validUnit", "tests if the given item is in Units of Volume."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of Volume."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ConcentrationQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*WeightVolumePercentQ*)


DefineUsage[WeightVolumePercentQ,
	{
		BasicDefinitions -> {
			{"WeightVolumePercentQ[item]", "validUnit", "tests if the given item is in Units of WeightVolumePercent."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"validUnit", BooleanP, "True if item is in Units of temperature."}
		},
		SeeAlso -> {
			"UnitsQ",
			"PercentQ",
			"VolumePercentQ"
		},
		Author -> {
			"brad",
			"Frezza"
		}
	}];


(* ::Subsection::Closed:: *)
(*Unit Manipulation*)


(* ::Subsubsection::Closed:: *)
(*CanonicalUnit*)


DefineUsage[CanonicalUnit,
	{
		BasicDefinitions -> {
			{"CanonicalUnit[q]", "unit", "returns the canonical unit of the given value."},
			{"CanonicalUnit[unitDimension]", "unit", "returns the canonical unit of the given unit dimension."}
		},
		MoreInformation -> {
			"The canonical unit is the SI Base unit for the given unit/dimension."
		},
		Input :> {
			{"q", _?UnitsQ, "Quantity to find the canonical unit of."},
			{"unitDimension", _String, "Dimension to find canonical unit of."}
		},
		Output :> {
			{"unit", _?UnitsQ, "The canonical unit of the input quantity or dimension."}
		},
		SeeAlso -> {
			"Units",
			"Unitless",
			"Convert",
			"UnitBase"
		},
		Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
	}];


(* ::Subsection::Closed:: *)
(*Distributions*)


(* ::Subsubsection::Closed:: *)
(*DistributionQ*)


DefineUsage[DistributionQ, {
	BasicDefinitions -> {
		{"DistributionQ[dist]", "bool", "returns True if 'dist' is a valid distribution."},
		{"DistributionQ[dist,unitSpec]", "bool", "returns True if 'dist' is valid distribution and its units match 'unitSpec'."}
	},
	Input :> {
		{"dist", _, "An item that might be a valid distribution."},
		{"unitSpec", _, "Specification of unit dimensions and magnitude constraints to check against 'val'."}
	},
	Output :> {
		{"bool", True | False, "True if 'dist' is a valid distribution and matches 'unitSpec'."}
	},
	SeeAlso -> {"DistributionP", "QuantityDistribution", "UnitsQ", "UnitCoordinatesQ"},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];



(* ::Subsubsection::Closed:: *)
(*DistributionP*)


DefineUsage[DistributionP, {
	BasicDefinitions -> {
		{"DistributionP[]", "patt", "returns a pattern that matches valid distributions."},
		{"DistributionP[unitSpec]", "bool", "returns a pattern that matches valid distributions whose units match 'unitSpec'."}
	},
	Input :> {
		{"unitSpec", _, "Specification of unit dimensions and magnitude constraints to check against 'val'."}
	},
	Output :> {
		{"patt", _, "A pattern that matches valid distributions with the additional unit constraints specified by 'unitSpec'."}
	},
	SeeAlso -> {"DistributionQ", "QuantityDistribution", "UnitsP", "UnitCoordinatesP"},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];


(* ::Subsubsection::Closed:: *)
(*QuantityDistributionQ*)


DefineUsage[QuantityDistributionQ,
	{
		BasicDefinitions -> {
			{"QuantityDistributionQ[qd]", "bool", "checks if 'qd' is a valid QuantityDistribution."},
			{"QuantityDistributionQ[qd,unitSpec]", "bool", "checks if 'qd' is a valid QuantityDistribution and if its units match the pattern 'unitSpec'."}
		},
		Input :> {
			{"qd", _, "An object that will be tested as a QuantityDistribution and against a units pattern."},
			{"unitSpec", _, "A pattern describing the units in a QuantityDistribution.  Can be a unit, a nested list of units repeated, or another QuantityArray."}
		},
		Output :> {
			{"bool", True | False, "True if 'qd' is a valid QuantityDistribution whose units match the pattern 'unitSpec'."}
		},
		SeeAlso -> {
			"QuantityArrayQ",
			"UnitsQ"
		},
		Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
	}];


(* ::Subsubsection::Closed:: *)
(*QuantityDistributionP*)


DefineUsage[QuantityDistributionP,
	{
		BasicDefinitions -> {
			{"QuantityDistributionP[]", "qdPatt", "returns a pattern that will match any valid QuantityDistribution."},
			{"QuantityDistributionP[unitSpec]", "qdPatt", "returns a pattern that will match a valid QuantityDistribution whose units match 'unitSpec'."}
		},
		Input :> {
			{"unitSpec", _, "A pattern describing the units in a QuantityDistribution.  Can be a unit, or a nested list of units repeated."}
		},
		Output :> {
			{"qdPatt", _, "A pattern that will match a valid QuantityDistribution whose units match 'unitSpec'."}
		},
		SeeAlso -> {
			"QuantityArrayQ",
			"UnitsQ"
		},
		Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
	}];


(* ::Subsubsection::Closed:: *)
(*EmpiricalDistributionQ*)


DefineUsage[EmpiricalDistributionQ,
	{
		BasicDefinitions -> {
			{"EmpiricalDistributionQ[dist]", "bool", "checks if 'dist' is a valid empirical distribution."},
			{"EmpiricalDistributionQ[dist,unitSpec]", "bool", "checks if 'dist' is a valid empirical distribution and if its units match the pattern 'unitSpec'."}
		},
		Input :> {
			{"dist", _, "An object that will be tested as an empirical distribution and against a units pattern."},
			{"unitSpec", _, "A pattern describing the units in the distribution.  Can be a unit, a nested list of units repeated, or a QuantityArray."}
		},
		Output :> {
			{"bool", True | False, "True if 'dist' is a valid empirical distribution whose units match the pattern 'unitSpec'."}
		},
		SeeAlso -> {
			"DistributionQ",
			"QuantityDistributionQ",
			"UnitsQ"
		},
		Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
	}];



(* ::Subsubsection::Closed:: *)
(*EmpiricalDistributionP*)


DefineUsage[EmpiricalDistributionP,
	{
		BasicDefinitions -> {
			{"EmpiricalDistributionP[]", "pattern", "generates a 'pattern' that matches a valid empirical distribution."},
			{"EmpiricalDistributionP[unitSpec]", "pattern", "generates a 'pattern' that matches a valid empirical distribution with units of 'unitSpec'."}
		},
		Input :> {
			{"unitSpec", _, "A pattern describing the units in the distribution.  Can be a unit, a nested list of units repeated, or a QuantityArray."}
		},
		Output :> {
			{"pattern", _PatternTest, "True if 'dist' is a valid empirical distribution whose units match the pattern 'unitSpec'."}
		},
		SeeAlso -> {
			"EmpiricalDistributionQ",
			"DistributionQ",
			"QuantityDistributionQ",
			"UnitsQ"
		},
		Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
	}];


(* ::Subsubsection::Closed:: *)
(*EmpiricalDistributionPoints*)


DefineUsage[EmpiricalDistributionPoints,
	{
		BasicDefinitions -> {
			{
				Definition -> {"EmpiricalDistributionPoints[edist]", "points"},
				Description -> "extracts the data points from an empirical distribution.",
				Inputs :> {
					{
						InputName -> "edist",
						Description -> "An empirical distribution whose points will be returned.",
						Widget -> Widget[Type -> Expression, Pattern :> EmpiricalDistributionP, Size -> Line]
					}
				},
				Outputs :> {
					{
						OutputName -> "points",
						Description -> "Set of points insdie the input distribution.",
						Pattern :> _?ArrayQ | _?QuantityArrayQ
					}
				}
			}
		},
		MoreInformation -> {
			"If the distribution has units associated with it, the points come out as a QuantityArray."
		},
		SeeAlso -> {
			"EmpiricalDistribution",
			"PropagateUncertainty",
			"EmpiricalDistributionJoin"
		},
		Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
	}];


(* ::Subsubsection::Closed:: *)
(*EmpiricalDistributionJoin*)


DefineUsage[EmpiricalDistributionJoin,
	{
		BasicDefinitions -> {
			{"EmpiricalDistributionJoin[edist..]", "joinedDist", "joins together the points from the given distributions into a single empirical distribution 'joinedDist'."}
		},
		MoreInformation -> {
		},
		Input :> {
			{"edist", EmpiricalDistributionP, "An empirical distribution that will be joined together with other empirical distributions."}
		},
		Output :> {
			{"joinedDist", EmpiricalDistributionP, "Empirical distribution obtained by joining together the points in the input distributions."}
		},
		SeeAlso -> {
			"EmpiricalDistribution",
			"PropagateUncertainty",
			"EmpiricalDistributionPoints"
		},
		Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
	}];


(* ::Subsection::Closed:: *)
(*Conversions*)


(* ::Subsubsection::Closed:: *)
(*Convert*)


DefineUsage[Convert,
	{
		BasicDefinitions -> {
			{"Convert[q,targetUnit]", "convertedQuantity", "converts the provided physical 'q' to the Units of the provided 'targetUnit'."},
			{"Convert[value,oldUnit,targetUnit]", "convertedValue", "converts the numeric 'Value' from the 'oldUnit' to the 'targetUnit'."},
			{"Convert[values,oldUnits,targetUnits]", "convertedValues", "converts each innermost list in 'Values' from the 'oldUnits' to the 'targetUnits'."}
		},
		MoreInformation -> {
			"Emerald version of the Mathematica 10 function UnitConvert.",
			"The function is listable and can Convert an entire lists of items very quickly if all Units start in the same form (but must move more slowly if there are mixed Units)."
		},
		Input :> {
			{"q", _?UnitsQ, "A numeric value associated with a physical unit."},
			{"value", NumericP, "A raw numeric value you wish to Convert between Units."},
			{"oldUnit", _?UnitsQ | _?KnownUnitQ, "The orignal Units of the 'Value' before conversion."},
			{"targetUnit", _?UnitsQ | _?KnownUnitQ, "The desired Units for the output."},
			{"values", {{NumericP..}..} | {{{NumericP..}..}..}, "Array of numbers whose inntermost list is associated with differing Units."},
			{"oldUnits", {(_?UnitsQ | _?KnownUnitQ)..}, "Original Units whose size should match the innermost list of 'values'."},
			{"targetUnits", {(_?UnitsQ | _?KnownUnitQ)..}, "Target Units whose size shoudl match the innermost list of 'values'."}
		},
		Output :> {
			{"convertedQuantity", _?UnitsQ, "The final 'q' after the unit conversion."},
			{"convertedValue", NumericP, "The final 'value' after the unit conversion."},
			{"convertedValues", {{NumericP..}..} | {{{NumericP..}..}..}, "Converted version of 'values'."}
		},
		SeeAlso -> {
			"UnitScale",
			"CompatibleUnitQ",
			"UnitsQ",
			"Units",
			"Unitless",
			"ConvertCellConcentration"
		},
		Author -> {"robert", "alou", "frezza"}
	}];


(* ::Subsubsection::Closed:: *)
(*UnitScale*)


DefineUsage[UnitScale,
	{
		BasicDefinitions -> {
			{"UnitScale[q]", "metricItem", "takes an item and converts its Units to the nearest sensible metric such that the number is the greater than 1 if possible."}
		},
		MoreInformation -> {
			"When Units are in metric it picks the smallest metric prefix that leaves the number > 1.",
			"The function also works on time Units."
		},
		Input :> {
			{"q", _?UnitsQ, "The item you wish to reduce to Convert to the nearest sensible metric."}
		},
		Output :> {
			{"metricItem", _?UnitsQ, "A converted 'item' now in in Units of the nearest sensible metric."}
		},
		SeeAlso -> {
			"Convert",
			"CompatibleUnitQ"
		},
		Author -> {"xu.yi", "qian", "brad", "Frezza"}
	}];


(* ::Subsubsection::Closed:: *)
(*UnitForm*)


DefineUsage[UnitForm,
	{
		BasicDefinitions -> {
			{"UnitForm[q]", "shorthand", "takes a quantity and converts it into a minimal string representation.  IE. Micro Molar -> \"[\[Mu]M]\"."}
		},
		Input :> {
			{"q", _?UnitsQ | _?KnownUnitQ, "The item you wish to Convert to a shorthand string."}
		},
		Output :> {
			{"shorthand", _String, "A string representing the unit or value in compact form."}
		},
		SeeAlso -> {
			"UnitScale",
			"CurrencyForm"
		},
		Author -> {"scicomp", "brad", "Frezza"}
	}];


(* ::Subsubsection::Closed:: *)
(*CurrencyForm*)


DefineUsage[CurrencyForm,
	{
		BasicDefinitions -> {
			{"CurrencyForm[number]", "cash", "formats 'number' as a monetary amount."}
		},
		MoreInformation -> {
			"By default, the function will attempt to round and use shorthand to make the numbers more digestable.  This can be deactivated by setting the Unist option to Dollar and the Shorthand option to False."
		},
		Input :> {
			{"number", _?CurrencyQ | _?NumericQ, "The number you wish to Convert to a currency value."}
		},
		Output :> {
			{"cash", _String, "A string represenetation of the 'number' amount of currency."}
		},
		SeeAlso -> {
			"UnitScale",
			"CurrencyQ"
		},
		Author -> {"scicomp", "brad"}
	}];


(* ::Subsection::Closed:: *)
(*Quantity Arrays*)


(* ::Subsubsection::Closed:: *)
(*QuantityArrayP*)


DefineUsage[QuantityArrayP,
	{
		BasicDefinitions -> {
			{"QuantityArrayP[]", "qaPatt", "returns a pattern that will match any valid QuantityArray."},
			{"QuantityArrayP[unitSpec]", "qaPatt", "returns a pattern that will match a valid QuantityArray whose units match 'unitSpec'."}
		},
		Input :> {
			{"unitSpec", _, "A pattern describing the units in a QuantityArray.  Can be a unit, or a nested list of units repeated."}
		},
		Output :> {
			{"qaPatt", _, "A pattern that will match a valid QuantityArray whose units match 'unitSpec'."}
		},
		SeeAlso -> {
			"QuantityArrayQ",
			"QuantityArray",
			"UnitsQ"
		},
		Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
	}];


(* ::Subsubsection::Closed:: *)
(*QuantityArrayQ*)


DefineUsage[QuantityArrayQ,
	{
		BasicDefinitions -> {
			{"QuantityArrayQ[qa]", "bool", "checks if 'qa' is a valid QuantityArray."},
			{"QuantityArrayQ[qa,unitSpec]", "bool", "checks if 'qa' is a valid QuantityArray and if its units match the pattern 'unitSpec'."}
		},
		Input :> {
			{"qa", _, "An object that will be tested as a QuantityArray and against a units pattern."},
			{"unitSpec", _, "A pattern describing the units in a QuantityArray.  Can be a unit, a nested list of units repeated, or another QuantityArray."}
		},
		Output :> {
			{"bool", True | False, "True if 'qa' is a valid QuantityArray whose units match the pattern 'unitSpec'."}
		},
		SeeAlso -> {
			"QuantityArrayP",
			"QuantityArray",
			"UnitsQ"
		},
		Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
	}];


(* ::Subsubsection::Closed:: *)
(*QuantityCoordinatesP*)


DefineUsage[QuantityCoordinatesP,
	{
		BasicDefinitions -> {
			{"QuantityCoordinatesP[]", "patt", "returns a pattern that matches an Nx2 quantity array."},
			{"QuantityCoordinatesP[{xunit,yunit}]", "patt", "additionally requires the units of the item being matched are compatible with specified units."}
		},
		Input :> {
			{"xunit", UnitsP[], "Unit that must be compatible with first element of sublists of the value being checked."},
			{"yunit", UnitsP[], "Unit that must be compatible with second element of sublists of the value being checked."}
		},
		Output :> {
			{"patt", _, "A pattern that matches a quantity array whose units match the speicifed units."}
		},
		SeeAlso -> {
			"QuantityArrayQ",
			"QuantityVectorQ",
			"QuantityMatrixQ"
		},
		Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
	}];


(* ::Subsubsection::Closed:: *)
(*QuantityCoordinatesQ*)


DefineUsage[QuantityCoordinatesQ,
	{
		BasicDefinitions -> {
			{"QuantityCoordinatesQ[item]", "bool", "returns true if 'item' is an Nx2 quantity array."},
			{"QuantityCoordinatesQ[item,{xunit,yunit}]", "bool", "additionally requires the units of 'item' be compatible with specified units."}
		},
		Input :> {
			{"item", _, "Thing that might be a quantity array."},
			{"xunit", UnitsP[], "Unit that must be compatible with first element of sublists of 'item'."},
			{"yunit", UnitsP[], "Unit that must be compatible with second element of sublists of 'item'."}
		},
		Output :> {
			{"bool", True | False, "True if 'item' is a quantity array whose units match the specified units."}
		},
		SeeAlso -> {
			"QuantityArrayQ",
			"QuantityVectorQ",
			"QuantityMatrixQ"
		},
		Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
	}];


(* ::Subsubsection::Closed:: *)
(*QuantityMatrixQ*)


DefineUsage[QuantityMatrixQ,
	{
		BasicDefinitions -> {
			{"QuantityMatrixQ[item]", "bool", "returns true if 'item' is an NxM quantity array."},
			{"QuantityMatrixQ[item,unit]", "bool", "additionally requires the units of 'item' be compatible with 'unit'."}
		},
		Input :> {
			{"item", _, "Thing that might be a quantity arry."},
			{"unit", {UnitsP[]..}, "List of units that must be compatible to corresponding elements of sublists in 'item'."}
		},
		Output :> {
			{"bool", True | False, "True if 'item' is a quantity array whose units match 'unit'."}
		},
		SeeAlso -> {
			"QuantityMatrixP",
			"QuantityArrayQ",
			"QuantityVectorQ",
			"QuantityCoordinatesQ"
		},
		Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
	}];


(* ::Subsubsection::Closed:: *)
(*QuantityMatrixP*)


DefineUsage[QuantityMatrixP,
	{
		BasicDefinitions -> {
			{"QuantityMatrixP[]", "patt", "returns pattern that matches any NxM quantity array."},
			{"QuantityMatrixP[units]", "patt", "additionally requires the units of the item being checked are compatible with 'units'."}
		},
		Input :> {
			{"units", {UnitsP[]..}, "List of units that must be compatible to corresponding elements of sublists in the array being checked."}
		},
		Output :> {
			{"patt", _, "A pattern that matches an item that is a quantity array whose units match 'unit'."}
		},
		SeeAlso -> {
			"QuantityMatrixQ",
			"QuantityArrayQ",
			"QuantityVectorQ",
			"QuantityCoordinatesQ"
		},
		Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
	}];


(* ::Subsubsection::Closed:: *)
(*QuantityVectorQ*)


DefineUsage[QuantityVectorQ,
	{
		BasicDefinitions -> {
			{"QuantityVectorQ[item]", "bool", "returns true if 'item' is an Nx1 quantity array."},
			{"QuantityVectorQ[item,unit]", "bool", "additionally requires the units of 'item' be compatible with 'unit'."}
		},
		Input :> {
			{"item", _, "Thing that might be a quantity array."},
			{"unit", UnitsP[], "A unit to compare against the units of 'item'."}
		},
		Output :> {
			{"bool", True | False, "True if 'item' is a quantity array whose units match 'unit'."}
		},
		SeeAlso -> {
			"QuantityArrayQ",
			"QuantityMatrixQ",
			"QuantityCoordinatesQ"
		},
		Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
	}];


(* ::Subsection::Closed:: *)
(*Unit coordinate comparisons*)


(* ::Subsubsection::Closed:: *)
(*UnitCoordinatesQ*)


DefineUsage[UnitCoordinatesQ, {
	BasicDefinitions -> {
		{"UnitCoordinatesQ[val]", "bool", "returns true if 'val' is a set of coordinate pairs, either as a list of numbers, list of quantities, or quantity array."},
		{"UnitCoordinatesQ[val,unitSpec]", "bool", "also tests that the values in 'val' match the units or constraints in 'unitSpec'."}
	},
	Input :> {
		{"val", _, "A value being tested."},
		{"unitSpec", _, "Specification of unit dimensions and magnitude constraints to check against 'val'."}
	},
	Output :> {
		{"bool", True | False, "True if input 'val' is a set of coordinates that matches 'unitSpec'."}
	},
	SeeAlso -> {"UnitCoordinatesP", "QuantityCoordinatesQ", "UnitsQ", "QuantityArrayQ"},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];



(* ::Subsubsection::Closed:: *)
(*UnitCoordinatesP*)


DefineUsage[UnitCoordinatesP, {
	BasicDefinitions -> {
		{"UnitCoordinatesP[]", "patt", "returns a pattern that matches if 'val' is a set of coordinate pairs, either as a list of numbers, list of quantities, or quantity array."},
		{"UnitCoordinatesP[unitSpec]", "patt", "also tests that the values in 'val' match the units or constraints in 'unitSpec'."}
	},
	Input :> {
		{"unitSpec", _, "Specification of unit dimensions and magnitude constraints to check against 'val'."}
	},
	Output :> {
		{"patt", _, "A pattern that matches values that satisfy UnitCoordinatesQ."}
	},
	SeeAlso -> {"UnitCoordinatesQ", "QuantityCoordinatesP", "UnitsP", "QuantityArrayP"},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];



(* ::Subsection::Closed:: *)
(*QuantityFunction*)


(* ::Subsubsection::Closed:: *)
(*QuantityFunction*)


DefineUsage[QuantityFunction,
	{
		BasicDefinitions -> {
			{"QuantityFunction[f, inputUnit, outputUnit][input..]", "output", "applies the function 'f' after converting 'input' to 'inputUnit' and returns 'output' in 'outputUnit'."}
		},
		MoreInformation -> {
			"Number of 'input' arguments much match length of 'inputUnit' list.",
			"Evalution procedure is to convert 'input' to 'inputUnit', strip the units off that value, apply 'f' to the resulting numerical values, and finally add 'outputUnit' to the output of the function."
		},
		Input :> {
			{"f", _Function, "A pure function to add Units to."},
			{"inputUnit", ListableP[UnitsP[]], "The Units to which inputs should be converted."},
			{"outputUnit", UnitsP[], "The Units of the returned value."},
			{"input", UnitsP[], "The input to evaluate the function on."}
		},
		Output :> {
			{"output", UnitsP[], "The result in Units 'outputunit'."}
		},
		SeeAlso -> {
			"Convert",
			"AnalyzeFit"
		},
		Author -> {"scicomp", "brad", "Jenny", "alice", "qian", "thomas"}
	}];



(* ::Subsubsection::Closed:: *)
(*QuantityFunctionP*)


DefineUsage[QuantityFunctionP,
	{
		BasicDefinitions -> {
			{"QuantityFunctionP[inputUnit, outputUnit]", "pattern", "returns a 'pattern' that matches any QuantityFunction whose input and output units are compatible with 'inputUnit' and 'outputUnit', respectively."},
			{"QuantityFunctionP[inputsUnit, outputUnit]", "pattern", "returns a 'pattern' that matches any QuantityFunction whose multiple inputs and single output units are compatible with 'inputsUnit' and 'outputUnit', respectively."},
			{"QuantityFunctionP[]", "pattern", "returns a 'pattern' that matches any QuantityFunction."}
		},
		Input :> {
			{"inputUnit", _Quantity, "The Units of the input to evaluate the function on."},
			{"outputUnit", _Quantity, "The Units of the output function."},
			{"inputsUnit", {_Quantity..}, "The Units of the multiple inputs to evaluate the function on."}
		},
		Output :> {
			{"pattern", _, "A pattern that matches any QuantityFunction with input and output units specified."}
		},
		SeeAlso -> {
			"QuantityFunction",
			"AnalyzeFit"
		},
		Author -> {"xu.yi", "Javi", "brad", "alice", "qian", "thomas"}
	}];



(* ::Subsection:: *)
(*Comparisons*)


(* ::Subsubsection::Closed:: *)
(*EqualP*)


DefineUsage[EqualP, {
	BasicDefinitions -> {
		{"EqualP[value]", "pattern", "returns a 'pattern' that matches any quantity equal to 'value'."}
	},
	MoreInformation -> {
		"For distributions, the means are computed and used for the comparsion."
	},
	Input :> {
		{"value", _, "A value used for pattern matching."}
	},
	Output :> {
		{"pattern", _, "A pattern that matches any quantity equal to a test quantity."}
	},
	SeeAlso -> {"EqualQ", "LessEqualP", "LessP"},
	Author -> {
		"brad"
	}
}];


(* ::Subsubsection::Closed:: *)
(*GreaterEqualP*)


DefineUsage[GreaterEqualP, {
	BasicDefinitions -> {
		{"GreaterEqualP[value]", "pattern", "returns a 'pattern' that matches any quantity greater than or equal to 'value'."},
		{"GreaterEqualP[value,increment]", "pattern", "returns a 'pattern' that matches any quantity equal to 'value' or greater than 'value' by a multiple of 'increment'."}
	},
	MoreInformation -> {
		"For distributions, the means are computed and used for the comparsion."
	},
	Input :> {
		{"value", _, "A value used for pattern matching."},
		{"increment", UnitsP[], "The test value must greater than 'value' by a multiple of this 'increment'."}
	},
	Output :> {
		{"pattern", _, "A pattern that matches any quantity greater than or equal to test quantity."}
	},
	SeeAlso -> {"GreaterEqualQ", "GreaterP", "LessEqualP", "LessP"},
	Author -> {
		"brad",
		"alice",
		"qian",
		"thomas"
	}
}];


(* ::Subsubsection::Closed:: *)
(*GreaterP*)


DefineUsage[GreaterP, {
	BasicDefinitions -> {
		{"GreaterP[value]", "pattern", "returns a 'pattern' that matches any quantity greater than 'value'."},
		{"GreaterP[value,increment]", "pattern", "returns a 'pattern' that matches any quantity greater than 'value' by a multiple of 'increment'."}
	},
	MoreInformation -> {
		"For distributions, the means are computed and used for the comparsion."
	},
	Input :> {
		{"value", _, "A value used for pattern matching."},
		{"increment", UnitsP[], "The test value must greater than 'value' by a multiple of this 'increment'."}
	},
	Output :> {
		{"pattern", _, "A pattern that matches any quantity greater than the test quantity."}
	},
	SeeAlso -> {"GreaterQ", "GreaterEqualP", "LessEqualP", "LessP"},
	Author -> {
		"brad",
		"alice",
		"qian",
		"thomas"
	}
}];


(* ::Subsubsection::Closed:: *)
(*LessEqualP*)


DefineUsage[LessEqualP, {
	BasicDefinitions -> {
		{"LessEqualP[value]", "pattern", "returns a 'pattern' that matches any quantity less than or equal to 'value'."},
		{"LessEqualP[value]", "pattern", "returns a 'pattern' that matches any quantity equal to 'value' or less than 'value' by a multiple of 'increment'."}
	},
	MoreInformation -> {
		"For distributions, the means are computed and used for the comparsion."
	},
	Input :> {
		{"value", _, "A value used for pattern matching."},
		{"increment", UnitsP[], "The test value must less than 'value' by a multiple of this 'increment'."}
	},
	Output :> {
		{"pattern", _, "A pattern that matches any quantity less than or equal to test quantity."}
	},
	SeeAlso -> {"LessEqualQ", "GreaterEqualP", "GreaterP", "LessP"},
	Author -> {
		"brad",
		"alice",
		"qian",
		"thomas"
	}
}];


(* ::Subsubsection::Closed:: *)
(*LessP*)


DefineUsage[LessP, {
	BasicDefinitions -> {
		{"LessP[value]", "pattern", "returns a 'pattern' that matches any quantity less than 'value'."},
		{"LessP[value]", "pattern", "returns a 'pattern' that matches any quantity less than 'value' by a multiple of 'increment'."}
	},
	MoreInformation -> {
		"For distributions, the means are computed and used for the comparsion."
	},
	Input :> {
		{"value", _, "A value used for pattern matching."},
		{"increment", UnitsP[], "The test value must less than 'value' by a multiple of this 'increment'."}
	},
	Output :> {
		{"pattern", _, "A pattern that matches any quantity less than the test quantity."}
	},
	SeeAlso -> {"LessQ", "GreaterEqualP", "GreaterP", "LessEqualP"},
	Author -> {
		"brad",
		"alice",
		"qian",
		"thomas"
	}
}];


(* ::Subsubsection::Closed:: *)
(*EqualQ*)


DefineUsage[EqualQ, {
	BasicDefinitions -> {
		{"EqualQ[testVal,val]", "pattern", "returns True if 'testVal' is equal to 'val'."}
	},
	MoreInformation -> {
		"For distributions, the means are computed and used for the comparison."
	},
	Input :> {
		{"testVal", _, "A value used for comparison."},
		{"val", _, "A value used for comparison."}
	},
	Output :> {
		{"pattern", _, "A pattern that matches any quantity equal to a test quantity."}
	},
	SeeAlso -> {"EqualP", "LessEqualP", "LessP"},
	Author -> {
		"brad"
	}
}];


(* ::Subsubsection::Closed:: *)
(*GreaterEqualQ*)


DefineUsage[GreaterEqualQ, {
	BasicDefinitions -> {
		{"GreaterEqualQ[testVal,value]", "bool", "returns True if 'testVal' is greater than or equal to 'value'."},
		{"GreaterEqualQ[testVal,value,increment]", "bool", "returns True if 'testVal' is equal to 'value' or greater than 'value' by a multiple of 'increment'."}
	},
	MoreInformation -> {
		"For distributions, the means are computed and used for the comparsion."
	},
	Input :> {
		{"testVal", _, "A value to compare against 'value'."},
		{"value", _, "A value being compared against."},
		{"increment", UnitsP[], "The test value must greater than 'value' by a multiple of this 'increment'."}
	},
	Output :> {
		{"bool", BooleanP, "True if 'testVal' is greater than or equal to 'value'."}
	},
	SeeAlso -> {"GreaterEqualQ", "GreaterP", "LessEqualP", "LessP"},
	Author -> {
		"brad"
	}
}];


(* ::Subsubsection::Closed:: *)
(*GreaterQ*)


DefineUsage[GreaterQ, {
	BasicDefinitions -> {
		{"GreaterQ[testVal,value]", "bool", "returns True if 'testVal' is greater than 'value'."},
		{"GreaterQ[testVal,value,increment]", "bool", "returns True if 'testVal' is greater than 'value' by a multiple of 'increment'."}
	},
	MoreInformation -> {
		"For distributions, the means are computed and used for the comparsion."
	},
	Input :> {
		{"testVal", _, "A value to compare against 'value'."},
		{"value", _, "A value being compared against."},
		{"increment", UnitsP[], "The test value must greater than 'value' by a multiple of this 'increment'."}
	},
	Output :> {
		{"bool", BooleanP, "True if 'testVal' is greater than 'value'."}
	},
	SeeAlso -> {"GreaterP", "GreaterEqualP", "LessEqualP", "LessP"},
	Author -> {
		"brad"
	}
}];


(* ::Subsubsection::Closed:: *)
(*LessEqualQ*)


DefineUsage[LessEqualQ, {
	BasicDefinitions -> {
		{"LessEqualQ[testVal,value]", "bool", "returns True if 'testVal' is less than or equal to 'value'."},
		{"LessEqualQ[testVal,value,increment]", "bool", "returns True if 'testVal' is equal to 'value' or less than 'value' by a multiple of 'increment'."}
	},
	MoreInformation -> {
		"For distributions, the means are computed and used for the comparsion."
	},
	Input :> {
		{"testVal", _, "A value to compare against 'value'."},
		{"value", _, "A value being compared against."},
		{"increment", UnitsP[], "The test value must less than 'value' by a multiple of this 'increment'."}
	},
	Output :> {
		{"bool", BooleanP, "True if 'testVal' is less than or equal to 'value'."}
	},
	SeeAlso -> {"LessEqualP", "GreaterEqualP", "GreaterP", "LessP"},
	Author -> {
		"brad"
	}
}];


(* ::Subsubsection::Closed:: *)
(*LessQ*)


DefineUsage[LessQ, {
	BasicDefinitions -> {
		{"LessQ[testVal,value]", "bool", "returns True if 'testVal' is less than 'value'."},
		{"LessQ[testVal,value,increment]", "bool", "returns True if 'testVal' is less than 'value' by a multiple of 'increment'."}
	},
	MoreInformation -> {
		"For distributions, the means are computed and used for the comparsion."
	},
	Input :> {
		{"testVal", _, "A value to compare against 'value'."},
		{"value", _, "A value being compared against."},
		{"increment", UnitsP[], "The test value must less than 'value' by a multiple of this 'increment'."}
	},
	Output :> {
		{"bool", BooleanP, "True if 'testVal' is less than 'value'."}
	},
	SeeAlso -> {"LessP", "GreaterEqualP", "GreaterP", "LessEqualP"},
	Author -> {
		"brad"
	}
}];


(* ::Subsubsection::Closed:: *)
(*DistributionQ*)


DefineUsage[MatrixP, {
	BasicDefinitions -> {
		{"MatrixP[]", "pattern", "returns a 'pattern' that matches any matrix, which is an Nx2 array."},
		{"MatrixP[elementPattern]", "pattern", "returns a 'pattern' that matches matrix whose elements all match 'elementPattern'."}
	},
	Input :> {
		{"elementPattern", _, "A pattern to compare against the elements of the matrix."}
	},
	Output :> {
		{"pattern", _, "A pattern that matches a matrix."}
	},
	SeeAlso -> {"GreaterEqualP", "GreaterP", "MatrixQ"},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];


(* ::Subsection::Closed:: *)
(*QuantityPartition*)


DefineUsage[QuantityPartition,
	{
		BasicDefinitions -> {
			{"QuantityPartition[amount,maxAmount]", "amounts", "divides 'amount' into a list of 'amounts' that are all equal to or below the 'maxAmount'."},
			{"QuantityPartition[integer,maxInteger]", "integers", "divides 'integer' into a list of 'integers' that are all equal to or below the 'maxInteger'."}
		},
		Input :> {
			{"amount", PositiveQuantityP, "A quantity to partition based on a given maximum."},
			{"maxAmount", PositiveQuantityP, "The maximum size of any given element of the partitioned list."},
			{"integer", _Integer, "An integer to partition based on a given maximum."},
			{"maxInteger", _Integer, "The maximum size of any given element of the partitioned list."}
		},
		Output :> {
			{"amounts", {PositiveQuantityP...}, "A list of partitioned amounts all at or below the provided maximum amount."},
			{"integers", {(_Integer)...}, "A list of partitioned integers all at or below the provided maximum integer."}
		},
		SeeAlso -> {
			"PartitionRemainder",
			"PositiveQuantityQ",
			"QuantityQ",
			"CompatibleUnitQ"
		},
		Author -> {"xu.yi", "hanming.yang", "thomas", "wyatt"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ParticleConcentrationQ*)


DefineUsage[ParticleConcentrationQ,
	{
		BasicDefinitions -> {
			{"ParticleConcentrationQ[item]", "out", "test if the given item is in Units of particle concentration."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"out", BooleanP, "True if item is in Units of particle concentration."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ParticleCountQ"
		},
		Author -> {
			"brad",
			"noelle.toong"
		}
	}];

(* ::Subsubsection::Closed:: *)
(*ParticleConcentrationQ*)


DefineUsage[ParticleCountQ,
	{
		BasicDefinitions -> {
			{"ParticleCountQ[item]", "out", "test if the given item is in Units of Particles."}
		},
		Input :> {
			{"item", _, "The item you wish to query."}
		},
		Output :> {
			{"out", BooleanP, "True if item is in Units of Particles."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ParticleConcentrationQ"
		},
		Author -> {
			"brad",
			"noelle.toong"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*StringToQuantity*)


DefineUsage[StringToQuantity,
	{
		BasicDefinitions -> {
			{"StringToQuantity[strings]", "quantities", "attempts to interpret each of the 'strings' as a quantity, returning the 'quantities'."}
		},
		MoreInformation -> {
			"Be aware that converting from strings to quantities is not always an exact process and multiple interpretations may be possible, particularly if the formatting of the input string is poor.",
			"For example, ms could potentially be milliseconds or meter-seconds. This function follows the behavior of Quantity, and scientific convention, that a compound unit such as meter-seconds should be separated by a space to indicate multiplication - m s.",
			"Additionally, \[Degree]C is interpreted as Celsius whereas \[Degree] C is interpreted strictly as Angular Degree-Coulomb.",
			"In general, the function will try to find the longest match between the string and possible units.",
			"Unit words are not case sensitive but unit symbols and abbreviations are."
		},
		Input :> {
			{"strings", ListableP[_String], "The quantity strings to convert."}
		},
		Output :> {
			{"quantities", ListableP[Alternatives[_Quantity, $Failed]], "The list of quantities, or $Failed if a conversion failed."}
		},
		SeeAlso -> {
			"UnitsQ",
			"ToString",
			"TextForm"
		},
		Author -> {
			"david.ascough"
		}
	}
];