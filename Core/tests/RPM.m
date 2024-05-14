(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*Spin Speed Conversions*)


(* ::Subsubsection::Closed:: *)
(*RPMToRCF*)


DefineTests[RPMToRCF,
	{
		Example[{Basic, "Convert RPM to RCF given RPM and Radius:"},
			RPMToRCF[5000 RPM, 204 Milli Meter],
			AccelerationP
		],
		Example[{Basic, "Convert RPM to RCF given a Centrifuge Rotor model:"},
			RPMToRCF[12000 RPM, Model[Container, CentrifugeRotor, "Mini-6K Tube Rotor"]],
			AccelerationP
		],
		Example[{Basic, "Convert RPM to RCF given a Centrifuge Rotor object:"},
			RPMToRCF[6000 RPM, Object[Container, CentrifugeRotor, "Microfuge16 Rotor 1"]],
			AccelerationP
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*RCFToRPM*)


DefineTests[RCFToRPM,
	{
		Example[{Basic, "Convert RCF to RPM given RCF and Radius:"},
			RCFToRPM[12000 GravitationalAcceleration, 66 Milli Meter],
			RPMP
		],
		Example[{Basic, "Convert RCF to RPM given a Centrifuge Rotor model:"},
			RCFToRPM[6000 GravitationalAcceleration, Model[Container, CentrifugeRotor, "GH3.8 Rotor with 15mL Tube Carrier"]],
			RPMP
		],
		Example[{Basic, "Convert RCF to RPM given a Centrifuge Rotor object:"},
			RCFToRPM[3000 GravitationalAcceleration, Object[Container, CentrifugeRotor, "Microfuge16 Rotor 1"]],
			RPMP
		]
	}
];
