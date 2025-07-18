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
		],
		Example[{Basic, "Plots data objects linked to a given ICPMS protocol:"},
			PlotICPMS[
				Object[Data, ICPMS, "ICPMS Data For PlotICPMS Test " <> $SessionUUID]
			],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		]
	},
	SymbolSetUp :> (

		$CreatedObjects={};

		(* Gather and erase all pre-existing objects created in SymbolSetUp *)
		Module[
			{
				allObjects, existingObjects, protocol1, data1
			},

			(* All data objects generated for unit tests *)

			allObjects=
				{
					Object[Protocol, ICPMS, "ICPMS Protocol For PlotICPMS Test " <> $SessionUUID],
					Object[Data, ICPMS, "ICPMS Data For PlotICPMS Test " <> $SessionUUID]
				};

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(* Erase any test objects and models that we failed to erase in the last unit test *)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

			{protocol1, data1} = CreateID[{Object[Protocol, ICPMS], Object[Data, ICPMS]}];

			Upload[
				<|
					Name -> "ICPMS Data For PlotICPMS Test " <> $SessionUUID,
					Object -> data1,
					Type -> Object[Data, ICPMS],
					MassSpectrum -> QuantityArray[{#, RandomReal[50000]} & /@ Range[7, 243], {Gram/Mole, ArbitraryUnit}]
				|>
			];

			Upload[
				<|
					Name -> "ICPMS Protocol For PlotICPMS Test " <> $SessionUUID,
					Object -> protocol1,
					Type -> Object[Protocol, ICPMS],
					Replace[AnalyteData] -> {Link[data1, Protocol]}
				|>
			];
		];
	),
	SymbolTearDown :> Module[{objects},
		objects = {
			Object[Protocol, ICPMS, "ICPMS Protocol For PlotICPMS Test " <> $SessionUUID],
			Object[Data, ICPMS, "ICPMS Data For PlotICPMS Test " <> $SessionUUID]
		};

		EraseObject[
			PickList[objects,DatabaseMemberQ[objects],True],
			Verbose->False,
			Force->True
		]
	]
];