(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*BMGCompatiblePlates*)


DefineTests[BMGCompatiblePlates,
	{
		Example[{Basic,"BMGCompatiblePlates returns compatible plates for Absorbance experimnent:"},
			BMGCompatiblePlates[Absorbance],
			{ObjectP[Model[Container,Plate]]..}
		],
		Example[{Basic,"BMGCompatiblePlates returns compatible plates for AlphaScreen experimnent:"},
			BMGCompatiblePlates[AlphaScreen],
			{ObjectP[Model[Container,Plate]]..}
		],
		Example[{Basic,"BMGCompatiblePlates returns compatible plates for Fluorescence experimnent:"},
			BMGCompatiblePlates[Fluorescence],
			{ObjectP[Model[Container,Plate]]..}
		],
		Example[{Basic,"BMGCompatiblePlates returns compatible plates for Nephelometry experimnent:"},
			BMGCompatiblePlates[Nephelometry],
			{ObjectP[Model[Container,Plate]]..}
		]
	}
];


(* ::Subsection:: *)
(*BMGCompatiblePlatesP*)


DefineTests[BMGCompatiblePlatesP,
	{
		Example[{Basic,"BMGCompatiblePlatesP returns a pattern of compatible plates for Absorbance experimnent:"},
			BMGCompatiblePlatesP[Absorbance],
			_Alternatives
		],
		Example[{Basic,"BMGCompatiblePlatesP returns a pattern of compatible plates for Fluorescence experimnent:"},
			BMGCompatiblePlatesP[Fluorescence],
			_Alternatives
		],
		Example[{Basic,"BMGCompatiblePlatesP returns a pattern of compatible plates for Nephelometry experimnent:"},
			BMGCompatiblePlatesP[Nephelometry],
			_Alternatives
		]
	},
	SymbolSetUp:>Module[{},
		$CreatedObjects={};
		(* Backup Cleanup *)
		(* Define test objects *)
		(* Upload test objects *)
	],
	SymbolTearDown:>Module[{},
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects];
	],
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"],
		$PublicPath=$TemporaryDirectory,
		$AllowSystemsProtocols=True
	}
];




