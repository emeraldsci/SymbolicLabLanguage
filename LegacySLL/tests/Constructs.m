(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*typeToPeaksFields*)


DefineTests[
	typeToPeaksFields,
	{
		Example[{Basic,"The function returns a list of Peaks fields of the given type:"},
			typeToPeaksFields[Object[Data, Chromatography]],
			Absorbance, Absorbance3D, SecondaryAbsorbance, Conductance,
			Fluorescence, SecondaryFluorescence, TertiaryFluorescence,
			QuaternaryFluorescence, Scattering
		],
		Example[{Basic,"The function returns a list of Peaks fields of the given type:"},
			typeToPeaksFields[Object[Data, NMR]],
			{NMRSpectrum}
		],
		Example[{Basic,"The function returns a list of Peaks fields of the given type:"},
			typeToPeaksFields[Object[Data, MassSpectrometry]],
			{MassSpectrum}
		]
	}
];


(* ::Subsection::Closed:: *)
(*typeToPeaksSourceFields*)


DefineTests[typeToPeaksSourceFields,
{
	Example[{Basic,"The function returns a list of PeaksSource fields of the given type:"},
		typeToPeaksSourceFields[Object[Data, Chromatography]],
		{___Symbol,AbsorbancePeaksAnalyses,___Symbol}
	],
	Example[{Basic,"The function returns a list of PeaksSource fields of the given type:"},
		typeToPeaksSourceFields[Object[Data, NMR]],
		{NMRSpectrumPeaksAnalyses}
	],
	Example[{Basic,"The function returns a list of PeaksSource fields of the given type:"},
		typeToPeaksSourceFields[Object[Data, MassSpectrometry]],
		{MassSpectrumPeaksAnalyses}
	]
}
];



(* ::Subsection::Closed:: *)
(*peaksFieldToPeaksSourceField*)


DefineTests[
	peaksFieldToPeaksSourceField,
	{
		Example[{Basic,"The function returns the PeaksSource field of the given Peaks field in the given type:"},
			peaksFieldToPeaksSourceField[Object[Data, Chromatography], Absorbance],
			AbsorbancePeaksAnalyses
		],
		Example[{Basic,"The function returns the PeaksSource field of the given Peaks field in the given type:"},
			peaksFieldToPeaksSourceField[Object[Data, NMR], NMRSpectrum],
			NMRSpectrumPeaksAnalyses
		],
		Example[{Basic,"The function returns the PeaksSource field of the given Peaks field in the given type:"},
			peaksFieldToPeaksSourceField[Object[Data, MassSpectrometry], MassSpectrum],
			MassSpectrumPeaksAnalyses
		]
	}
];



(* ::Subsection::Closed:: *)
(*fitFieldToFitSourceField*)


DefineTests[
	fitFieldToFitSourceField,
	{
		Example[{Basic,"The function returns the FitSource field of the given Fit field in the given type:"},
			fitFieldToFitSourceField[Object[Data, Western], MassSpectrum],
			FitSourceSpectra
		],
		Example[{Basic,"The function returns the FitSource field of the given Fit field in the given type:"},
			fitFieldToFitSourceField[Object[Analysis, Ladder], FragmentPeaks],
			StandardFit
		]
	}
];
