(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotICPMS*)

DefineTests[PlotICPMS,
	{
		Example[{Basic, "Displays raw mass spectrum data as a graphical plot:"},
			PlotICPMS[
				QuantityArray[
					Join[
						Table[{num, 0}, {num, 1, 55}],
						{{56, 1000}},
						Table[{num, 0}, {num, 57, 100}]
					],
					{Gram/Mole, ArbitraryUnit}
				]
			],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		]
	}
];