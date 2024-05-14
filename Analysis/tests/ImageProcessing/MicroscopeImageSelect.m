(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*MicroScopeImageSelect: Tests*)


(* ::Section:: *)
(*Unit Testing*)

(* ::Subsection:: *)
(*Main Functions*)

(* ::Subsubsection:: *)
(*MicroScopeImageSelect*)


DefineTests[MicroscopeImageSelect,
	{
		(* Basic *)
		Example[{Basic,"Get an association for every image stored within an Object[Data,Microscope]:"},
			MicroscopeImageSelect[
				Object[Data,Microscope,"id:1ZA60vL7NKLD"]
			],
			ConstantArray[_Association,36]
		],
		Example[{Basic,"Get an association for every image stored within an Object[Data,Microscope] that was taken in BrightField:"},
			imageAssociations=MicroscopeImageSelect[
				Object[Data,Microscope,"id:1ZA60vL7NKLD"],
				Mode->BrightField
			];
			Lookup[imageAssociations,Mode],
			ConstantArray[BrightField,9],
			Variables:>{imageAssociations}
		],
		Example[{Basic,"Get an association for every image stored within an Object[Data,Microscope] that was taken at the first ImagingSite:"},
			imageAssociations=MicroscopeImageSelect[
				Object[Data,Microscope,"id:1ZA60vL7NKLD"],
				ImagingSite->1
			];
			Lookup[imageAssociations,ImagingSite],
			ConstantArray[1,4],
			Variables:>{imageAssociations}
		],
		Example[{Basic,"If image specifications are requested that are not present among the images in the Object[Data,Microscope], then return an empty list:"},
			MicroscopeImageSelect[
				Object[Data,Microscope,"id:1ZA60vL7NKLD"],
				ObjectiveMagnification->40.
			],
			{}
		]
	}
];
