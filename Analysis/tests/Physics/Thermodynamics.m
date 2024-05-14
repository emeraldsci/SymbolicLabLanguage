DefineTestsWithCompanions[
	AnalyzeThermodynamics,
	{

		(* ---- Basic ---- *)

		Example[{Basic, "Compute the binding entropy and enthalpy of a two-state from van't Hoff analysis:"},
			PlotThermodynamics@AnalyzeThermodynamics[{Object[Analysis, MeltingPoint, "id:bq9LA0dBwLRr"], Object[Analysis, MeltingPoint, "id:Vrbp1jG8wp8b"], Object[Analysis, MeltingPoint, "id:bq9LA0dBwLBr"]}],
			ValidGraphicsP[],
			TimeConstraint -> 1200
		],
		Test["Compute the binding entropy and enthalpy of a two-state from van't Hoff analysis:",
			AnalyzeThermodynamics[{Object[Analysis, MeltingPoint, "id:bq9LA0dBwLRr"], Object[Analysis, MeltingPoint, "id:Vrbp1jG8wp8b"], Object[Analysis, MeltingPoint, "id:bq9LA0dBwLBr"]}, Upload -> False][Enthalpy],
			Quantity[-70.56056228981849, "KilocaloriesThermochemical"/"Moles"],
			EquivalenceFunction -> RoundMatchQ[5]
		],


		Example[{Basic, "Pull the melting point analyses from the given data objects:"},
			PlotThermodynamics@AnalyzeThermodynamics[{Object[Data, MeltingCurve, "id:8qZ1VWNmdAVP"],Object[Data, MeltingCurve, "id:bq9LA0dBGWPz"],Object[Data, MeltingCurve, "id:kEJ9mqaVPxl3"],Object[Data, MeltingCurve, "id:3em6Zv9NjXeL"],Object[Data, MeltingCurve, "id:Vrbp1jG80OwO"],Object[Data, MeltingCurve, "id:qdkmxz0A8rPx"],Object[Data, MeltingCurve, "id:n0k9mGzRaw9n"],Object[Data, MeltingCurve, "id:1ZA60vwjb4va"]}],
			ValidGraphicsP[]
		],
		Test["Pull the melting point analyses from the given data objects:",
			AnalyzeThermodynamics[
				{Object[Data, MeltingCurve, "id:8qZ1VWNmdAVP"],Object[Data, MeltingCurve, "id:bq9LA0dBGWPz"],Object[Data, MeltingCurve, "id:kEJ9mqaVPxl3"],Object[Data, MeltingCurve, "id:3em6Zv9NjXeL"],Object[Data, MeltingCurve, "id:Vrbp1jG80OwO"],Object[Data, MeltingCurve, "id:qdkmxz0A8rPx"],Object[Data, MeltingCurve, "id:n0k9mGzRaw9n"],Object[Data, MeltingCurve, "id:1ZA60vwjb4va"]
				},Upload->False],
			_Association
		],


		Example[{Basic, "Pull the melting point analyses from the protocol data:"},
			AnalyzeThermodynamics[Object[Protocol,UVMelting, "id:pZx9jonGXrJp"]][FreeEnergy],
			Quantity[-9.886862819262475, "KilocaloriesThermochemical"/"Moles"],
			EquivalenceFunction -> RoundMatchQ[5]
		],
		Test["Pull the melting point analyses from the protocol data:",
			AnalyzeThermodynamics[Object[Protocol,UVMelting, "id:pZx9jonGXrJp"],Upload->False],
			_Association
		],


		Example[{Basic,"Plot the melting point fit:"},
			PlotThermodynamics[AnalyzeThermodynamics[{Object[Analysis, MeltingPoint, "id:bq9LA0dBwLRr"], Object[Analysis, MeltingPoint, "id:Vrbp1jG8wp8b"], Object[Analysis, MeltingPoint, "id:bq9LA0dBwLBr"]}]],
			_?ValidGraphicsQ
		],


		Example[{Basic, "Given mixed list of inputs:"},
			AnalyzeThermodynamics[{
				Object[Protocol,UVMelting, "id:pZx9jonGXrJp"],
				{Object[Analysis, MeltingPoint, "id:bq9LA0dBwLRr"], Object[Analysis, MeltingPoint, "id:Vrbp1jG8wp8b"], Object[Analysis, MeltingPoint, "id:bq9LA0dBwLBr"]}
			}
			][FreeEnergy],
			{
				Quantity[-9.886862819262475, "KilocaloriesThermochemical"/"Moles"],
				Quantity[-14.868694339705486, "KilocaloriesThermochemical"/"Moles"]
			},
			EquivalenceFunction -> RoundMatchQ[5]
		],


		(* ---- Additional ---- *)

		Test["Given replicate melting point analyses:",
			AnalyzeThermodynamics[{Object[Analysis, MeltingPoint, "id:bq9LA0dBwLZz"],Object[Analysis, MeltingPoint, "id:qdkmxz0AXmLm"],Object[Analysis, MeltingPoint, "id:Y0lXejGKWXBv"],Object[Analysis, MeltingPoint, "id:WNa4ZjRrw4B4"],Object[Analysis, MeltingPoint, "id:Vrbp1jG8wpZo"],Object[Analysis, MeltingPoint, "id:bq9LA0dBwLoL"],Object[Analysis, MeltingPoint, "id:Vrbp1jG8wpzo"],Object[Analysis, MeltingPoint, "id:bq9LA0dBwL8L"],Object[Analysis, MeltingPoint, "id:WNa4ZjRrw48R"],Object[Analysis, MeltingPoint, "id:Y0lXejGKWXbP"],Object[Analysis, MeltingPoint, "id:WNa4ZjRrw4XR"],Object[Analysis, MeltingPoint, "id:Vrbp1jG8wpVE"],Object[Analysis, MeltingPoint, "id:bq9LA0dBwL7d"],Object[Analysis, MeltingPoint, "id:Vrbp1jG8wpkE"],Object[Analysis, MeltingPoint, "id:L8kPEjNLYPVN"],Object[Analysis, MeltingPoint, "id:WNa4ZjRrw4EL"]},Upload->False],
			_Association
		],


		(*
        (* can't find a valid protocol to test these on *)


        Test["Given FluorescenceThermodynamics datas:",
          AnalyzeThermodynamics[{Object[Data, FluorescenceThermodynamics, "id:O81aEB4kM6PO"],Object[Data, FluorescenceThermodynamics, "id:3539"],Object[Data, FluorescenceThermodynamics, "id:3540"],Object[Data, FluorescenceThermodynamics, "id:3541"],Object[Data, FluorescenceThermodynamics, "id:3542"],Object[Data, FluorescenceThermodynamics, "id:WNa4ZjRrBq9D"],Object[Data, FluorescenceThermodynamics, "id:3544"],Object[Data, FluorescenceThermodynamics, "id:3545"]},Upload->False,Output->Packet],
          validAnalysisPacketP[analysis[Thermodynamics],
            {
              BindingEnthalpy -> _?EnergyQ,
              BindingEntropy -> _?EntropyQ,
              BindingFreeEnergy -> _?EnergyQ,
              EquilibriumType -> BimolecularHomogenous,
              Reference->{Link[Object[Analysis, MeltingPoint, "id:Vrbp1jG8wjKx"],Thermodynamics],Link[Object[Analysis, MeltingPoint, "id:1196"],Thermodynamics],Link[Object[Analysis, MeltingPoint, "id:1197"],Thermodynamics],Link[Object[Analysis, MeltingPoint, "id:1198"],Thermodynamics],Link[Object[Analysis, MeltingPoint, "id:1199"],Thermodynamics],Link[Object[Analysis, MeltingPoint, "id:1200"],Thermodynamics],Link[Object[Analysis, MeltingPoint, "id:1201"],Thermodynamics],Link[Object[Analysis, MeltingPoint, "id:1202"],Thermodynamics]}
            },
            ResolvedOptions -> {Upload -> False, Output -> Packet, App -> False, AppTest -> False},
            NullFields -> {Exclude},
            NonNullFields -> {AffinityConstants},
            Round -> 5
          ]
        ],

        Example[{Additional, "Given FluorescenceThermodynamics datas:"},
          AnalyzeThermodynamics[{Object[Data, FluorescenceThermodynamics, "id:O81aEB4kM6PO"],Object[Data, FluorescenceThermodynamics, "id:3539"],Object[Data, FluorescenceThermodynamics, "id:3540"],Object[Data, FluorescenceThermodynamics, "id:3541"],Object[Data, FluorescenceThermodynamics, "id:3542"],Object[Data, FluorescenceThermodynamics, "id:WNa4ZjRrBq9D"],Object[Data, FluorescenceThermodynamics, "id:3544"],Object[Data, FluorescenceThermodynamics, "id:3545"]},Upload\[Rule]False],
          {Quantity[-131.98232566857274, "CaloriesThermochemical"/("Kelvins"*"Moles")], Quantity[-54.87633274870769, "KilocaloriesThermochemical"/"Moles"]},
          EquivalenceFunction -> RoundMatchQ[5]
        ],

        Example[{Additional, "Given FluorescenceThermodynamics protocol:"},
          AnalyzeThermodynamics[Object[Protocol, FluorescenceThermodynamics, "id:rea9jl1oG6np"],Upload\[Rule]False],
          {Quantity[-131.98232566857274, "CaloriesThermochemical"/("Kelvins"*"Moles")], Quantity[-54.87633274870769, "KilocaloriesThermochemical"/"Moles"]},
          EquivalenceFunction -> RoundMatchQ[5]
        ],
        Test["Given FluorescenceThermodynamics protocol:",
          AnalyzeThermodynamics[Object[Protocol, FluorescenceThermodynamics, "id:rea9jl1oG6np"],Upload\[Rule]False,Return\[Rule]Packet],
          validAnalysisPacketP[analysis[Thermodynamics],
            {
              BindingEnthalpy -> Quantity[-54.87633274870769, "KilocaloriesThermochemical"/"Moles"],
              BindingEntropy -> Quantity[-131.98232566857274, "CaloriesThermochemical"/("Kelvins"*"Moles")],
              EquilibriumType -> BimolecularHeterogenous,
              Append[Reference] -> {Link[Object[Analysis, MeltingPoint, "id:bq9LA0dBwLZz"],Thermodynamics],Link[Object[Analysis, MeltingPoint, "id:qdkmxz0AXmLm"],Thermodynamics],Link[Object[Analysis, MeltingPoint, "id:Y0lXejGKWXBv"],Thermodynamics],Link[Object[Analysis, MeltingPoint, "id:WNa4ZjRrw4B4"],Thermodynamics],Link[Object[Analysis, MeltingPoint, "id:Vrbp1jG8wpZo"],Thermodynamics],Link[Object[Analysis, MeltingPoint, "id:bq9LA0dBwLoL"],Thermodynamics],Link[Object[Analysis, MeltingPoint, "id:Vrbp1jG8wpzo"],Thermodynamics],Link[Object[Analysis, MeltingPoint, "id:bq9LA0dBwL8L"],Thermodynamics],Link[Object[Analysis, MeltingPoint, "id:WNa4ZjRrw48R"],Thermodynamics],Link[Object[Analysis, MeltingPoint, "id:Y0lXejGKWXbP"],Thermodynamics],Link[Object[Analysis, MeltingPoint, "id:WNa4ZjRrw4XR"],Thermodynamics],Link[Object[Analysis, MeltingPoint, "id:Vrbp1jG8wpVE"],Thermodynamics],Link[Object[Analysis, MeltingPoint, "id:bq9LA0dBwL7d"],Thermodynamics],Link[Object[Analysis, MeltingPoint, "id:Vrbp1jG8wpkE"],Thermodynamics],Link[Object[Analysis, MeltingPoint, "id:L8kPEjNLYPVN"],Thermodynamics],Link[Object[Analysis, MeltingPoint, "id:WNa4ZjRrw4EL"],Thermodynamics]}
            },
            ResolvedOptions -> {Upload -> False, Output -> Packet, App -> False, AppTest -> False},
            NullFields -> {Exclude},
            NonNullFields -> {AffinityConstants},
            Round -> 5
          ]
        ],
    *)

		(* ---- Options ---- *)

		Example[{Options,Output, "Return packet:"},
			AnalyzeThermodynamics[Object[Protocol,UVMelting,"id:pZx9jonGXrJp"],Output->Result,Upload->False],
			PacketP[]
		],
		Example[{Options,Name, "Name to be used as the name of Object[Analysis, Thermodynamics] generated by the analysis:"},
			randomStr = CreateUUID[];
			AnalyzeThermodynamics[Object[Protocol,UVMelting,"id:pZx9jonGXrJp"],Name->randomStr][Name],
			_String
		],

		(* ---- Messages ---- *)

		Example[{Messages, "TooFewPoints", "Thermodynamic analysis requires data for at least two different concentrations:"},
			AnalyzeThermodynamics[{Object[Analysis, MeltingPoint, "id:bq9LA0dBwLRr"]}],
			$Failed,
			Messages :> {Error::TooFewPoints}
		],
		Example[{Messages, "MissingConcentration", "All samples whose melting points are being used in the calculation must have concentrations:"},
			AnalyzeThermodynamics[
				Object[Protocol,UVMelting, "id:eGakldJJV0j1"]],
			$Failed,
			Messages :> {Error::MissingConcentration}
		],


		(* ---- Test ---- *)

		Test["Return all packets:",
			AnalyzeThermodynamics[{Object[Analysis, MeltingPoint, "id:bq9LA0dBwLRr"], Object[Analysis, MeltingPoint, "id:Vrbp1jG8wp8b"], Object[Analysis, MeltingPoint, "id:bq9LA0dBwLBr"]}, Upload -> False],
			_Association
		],


		Example[{Messages,"BadEquilibrium","All datas must have same reactions:"},
			AnalyzeThermodynamics[{Object[Analysis, MeltingPoint,
				"id:bq9LA0dBwLRr"],
				Object[Analysis, MeltingPoint, "id:Vrbp1jG8wp8b"],
				Object[Analysis, MeltingPoint, "id:bq9LA0dBwLBr"]}, Upload -> False],
			_,
			Messages:>{Error::BadEquilibrium},
			Stubs:> {
				Analysis`Private`resolveMeltingPointEquilibriumTypeFromSamples[_]:=RandomReal[]
			}
		],

		Test["Given mixed list of objects, packets, and links:",
			AnalyzeThermodynamics[{
				Link[Object[Protocol,UVMelting, "id:pZx9jonGXrJp"]],
				{Download[Object[Analysis, MeltingPoint, "id:bq9LA0dBwLRr"]], Link[Object[Analysis, MeltingPoint, "id:Vrbp1jG8wp8b"]], Object[Analysis, MeltingPoint, "id:bq9LA0dBwLBr"]}
			},
				Upload -> False
			][FreeEnergy],
			{
				Quantity[-9.886862819262475, "KilocaloriesThermochemical"/"Moles"],
				Quantity[-14.868694339705486, "KilocaloriesThermochemical"/"Moles"]
			},
			EquivalenceFunction -> RoundMatchQ[5]
		]

	}
]