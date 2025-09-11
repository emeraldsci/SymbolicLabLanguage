(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotELISA*)


DefineTests[PlotELISA,
	{
		Example[{Basic, "Given an Object[Data,ELISA] from ExperimentCapillaryELISA with a pre-loaded cartridge, PlotELISA returns an plot:"},
			PlotELISA[Object[Data, ELISA, "id:bq9LA0JwN9nv"]],
			ValidGraphicsP[],
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic, "Given an Object[Data,ELISA] from ExperimentCapillaryELISA with a customizable cartridge, PlotELISA returns an plot:"},
			PlotELISA[Object[Data, ELISA, "id:zGj91a7ZdKne"]],
			ValidGraphicsP[],
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic, "Given multiple Object[Data,ELISA]s from ExperimentCapillaryELISA with pre-loaded cartridges, PlotELISA returns an plot:"},
			PlotELISA[{Object[Data, ELISA, "id:bq9LA0JwN9nv"], Object[Data, ELISA, "id:54n6evL69YRB"]}],
			ValidGraphicsP[],
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic, "Given an Object[Data,ELISA] from ExperimentCapillaryELISA with a pre-loaded cartridge, PlotELISA returns an plot:"},
			PlotELISA[Object[Data, ELISA, "id:bq9LA0JwN9nv"]],
			ValidGraphicsP[],
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic, "Given an Object[Protocol, CapillaryELISA], PlotELISA returns an plot:"},
			PlotELISA[Object[Data, ELISA, "id:bq9LA0JwN9nv"][Protocol]],
			ValidGraphicsP[],
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],



		Example[{Options, Legend, "Add a legend:"},
			PlotELISA[Object[Data, ELISA, "id:bq9LA0JwN9nv"],
				Legend -> {"Analyte Concentration"}
			],
			ValidGraphicsP[],
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options, Frame, "Specify a frame:"},
			PlotELISA[Object[Data, ELISA, "id:bq9LA0JwN9nv"],
				Frame -> {True, True, False, False}
			],
			ValidGraphicsP[],
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options, LabelStyle, "Specify a label style:"},
			PlotELISA[Object[Data, ELISA, "id:bq9LA0JwN9nv"],
				LabelStyle -> {Bold, 20, FontFamily -> "Times"}
			],
			ValidGraphicsP[],
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options, Scale, "Specify a scale:"},
			PlotELISA[Object[Data, ELISA, "id:bq9LA0JwN9nv"],
				Scale -> Linear
			],
			ValidGraphicsP[],
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options, Joined, "Specify if the points are joined:"},
			PlotELISA[Object[Data, ELISA, "id:bq9LA0JwN9nv"],
				Joined -> True
			],
			ValidGraphicsP[],
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options, FrameLabel, "Specify a frame label:"},
			PlotELISA[Object[Data, ELISA, "id:bq9LA0JwN9nv"],
				FrameLabel -> "Custom Label"
			],
			ValidGraphicsP[],
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "MixmatchedELISAAssayType", "If data from both CapillaryELISA and ELISA are provided, throw error message and return $Failed:"},
			PlotELISA[{Object[Data, ELISA, "id:bq9LA0JwN9nv"],Object[Data, ELISA, "id:9RdZXv14ADqx"]}],
			$Failed,
			Messages:>{Error::MixmatchedELISAAssayType}
		],
		Example[{Messages, "MixmatchedCapillaryELISACartridgeType", "If data from both pre-loaded CapillaryELISA cartridges and customizable CapillaryELISA cartridges are provided, throw error message and return $Failed:"},
			PlotELISA[{Object[Data, ELISA, "id:bq9LA0JwN9nv"],Object[Data, ELISA, "id:zGj91a7ZdKne"]}],
			$Failed,
			Messages:>{Error::MixmatchedCapillaryELISACartridgeType}
		]
	}
];
