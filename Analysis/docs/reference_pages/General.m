(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*Absorbance*)


DefineUsage[Absorbance,
{
	BasicDefinitions -> {
		{"Absorbance[absorbanceSpectrum,wavelength]", "absorbance", "returns the 'absorbance' from a provided 'absorbanceSpectrum' at the indicated 'wavelength'."},
		{"Absorbance[absorbanceSpectrum,wavelength,blank]", "absorbance", "returns the 'absorbance' from a provided 'absorbanceSpectrum' at the indicated 'wavelength', with the blank spectrum provided."}
	},
	MoreInformation -> {
		"If the blank spectrum is not used, the provided spectrum will be assumed to be already blanked",
		"If an absorbance data object is provided as either input or as the blank spectrum, the relevant spectrum will be assumed to be in the field AbsorbanceSpectrum."
	},
	Input :> {
		{"absorbanceSpectrum", ObjectP[Object[Data, AbsorbanceSpectroscopy]] | CoordinatesP | {{_?DistanceQ, _?AbsorbanceQ}..} | QuantityCoordinatesP[{Nanometer,AbsorbanceUnit}], "The absorbance spectrum from which absorbance is drawn, given as either a raw spectrum (unitless or unit-ed) or a quantity array or as an absorbance data object."},
		{"wavelength", _?DistanceQ | (_?DistanceQ ;; _?DistanceQ), "The wavelength at which an absorbance range is to be extracted from the provided spectrum."},
		{"blank", ObjectP[Object[Data, AbsorbanceSpectroscopy]] | CoordinatesP | {{_?DistanceQ, _?AbsorbanceQ}..} | QuantityCoordinatesP[{Nanometer,AbsorbanceUnit}] | Null, "The blank spectrum as a baseline, given as either a raw spectrum (unitless or unit-ed) or a quantity array or as an absorbance data object."}
	},
	Output :> {
		{"absorbance", _?AbsorbanceQ, "The absorbance value returned from the spectrum for a given wavelength."},
		{"absorbanceRange", {_?AbsorbanceQ..}, "A list of absorbance values returned from the spectrum for a given wavelength range, as set by minWavelength and maxWavelength."}
	},
	Sync -> Automatic,
	SeeAlso -> {
		"ExperimentAbsorbanceSpectroscopy",
		"Concentration"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*Concentration*)


DefineUsage[Concentration,
{
	BasicDefinitions -> {
		{"Concentration[absorbance,pathLength,extinctionCoefficient]", "concentration", "solves Beer's law to return a concentration when given an 'absorbance', 'pathLength', and 'extinctionCoefficient'."}
	},
	MoreInformation -> {
		"The concentration will be returned in units that reflect the units of the extinction coefficient"
	},
	Input :> {
		{"absorbance", _?AbsorbanceQ, "The sample absorbance for which concentration is to be calculated."},
		{"pathLength", _?DistanceQ, "The path length of the sample for which concentration is to be calculated."},
		{"extinctionCoefficient", _?ExtinctionCoefficientQ | _?MassExtinctionCoefficientQ | _?SequenceQ | _?StrandQ | ObjectP[Object[Sample]], "The extinction coefficient of the sample. This can either be directly provided, or a macromolecular representation can be provided, for which the extinction coefficient will be calculated."}
	},
	Output :> {
		{"concentration", _?ConcentrationQ | _?MassConcentrationQ, "The concentration calculcated from the provided inputs using Beer's law."}
	},
	Sync -> Automatic,
	SeeAlso -> {
		"Absorbance",
		"PathLength",
		"ExtinctionCoefficient",
		"AnalyzeAbsorbanceQuantification"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*PathLength*)


DefineUsage[PathLength,
{
	BasicDefinitions -> {
		{"PathLength[blankDistance,sampleDistance]", "pathLength", "returns a blanked 'pathLength' given a 'blankDistance' and 'sampleDistance'."},
		{"PathLength[volume,volumeCalibration]", "pathLength", "returns a 'pathlength' when given a 'volume', using the inverse of a 'volumeCalibration' fit between path length and volume to do so."},
		{"PathLength[emptyAbsorbance,sampleAbsorbance,pathLengthCalibration]", "pathLength", "returns a 'pathlength' when given an 'emptyAbsorbance' and 'sampleAbsorbance', using a 'pathLengthcalibration' fit between absorbance and path length to do so."}
	},
	Input :> {
		{"blankDistance", _?DistanceQ, "An empty distance corresponding to the container in which the sample for which path length is to be determined is located."},
		{"sampleDistance", _?DistanceQ, "The measured raw distance of the sample for which path length is being determined."},
		{"volume", _?VolumeQ, "A volume for which path length is to be back-calculated."},
		{"emptyAbsorbance", ObjectP[Object[Data, AbsorbanceSpectroscopy]], "An absorbance spectroscopy data object containing an empty container spectrum to be used as a blank."},
		{"sampleAbsorbance", ObjectP[Object[Data, AbsorbanceSpectroscopy]], "An absorbance spectroscopy data object containing a sample spectrum for which path length is to be calculated."},
		{"volumeCalibration", ObjectP[Object[Calibration, Volume]], "A calibration fit relating path length to volume."},
		{"pathLengthCalibration", ObjectP[Object[Calibration, PathLength]], "A calibration fit relating absorbance to path length."}
	},
	Output :> {
		{"pathLength", _?DistanceQ, "The path length of light through a sample of interest, assumed to be in the vertical direction."}
	},
	Sync -> Automatic,
	SeeAlso -> {
		"Concentration"
	},
	Author -> {"scicomp", "brad"}
}];



(* ::Subsubsection:: *)
(*SequenceAlignmentTable*)


DefineUsage[SequenceAlignmentTable,{
  BasicDefinitions -> {
    {
      Definition -> {"SequenceAlignmentTable[sequence1,sequence2]", "summary"},
      Description -> "returns a table showing sequence similarity, identity, gaps, and a visual preview of the alignment betwen 'sequence1' and 'sequence2'.",
      Inputs :> {
        {
          InputName -> "sequence1",
          Description -> "A string, oligomer, or DNASequencing object representing a sequence to align.",
          Widget -> Alternatives[
						"String"->Widget[Type->String,Pattern:>_String,Size->Paragraph],
						"Oligomer"->Widget[Type->Expression,Pattern:>SequenceP,Size->Paragraph],
						"Object"->Widget[Type->Object,Pattern:>ObjectP[{Object[Data,DNASequencing],Object[Analysis,DNASequencing]}]]
					]
        },
        {
          InputName -> "sequence2",
          Description -> "A string, oligomer, or DNASequencing object representing a sequence to align.",
          Widget -> Alternatives[
						"String"->Widget[Type->String,Pattern:>_String,Size->Paragraph],
						"Oligomer"->Widget[Type->Expression,Pattern:>SequenceP,Size->Paragraph],
						"Object"->Widget[Type->Object,Pattern:>ObjectP[{Object[Data,DNASequencing],Object[Analysis,DNASequencing]}]]
					]
        }
      },
      Outputs :> {
        {
          OutputName -> "summary",
          Description -> "Either a table or a list of rules showing the sequence similarity, sequence identity, number of gaps, and a visual preview of the aligment between the two input sequences.",
          Pattern :> _Pane|{_Rule..}
        }
      }
    }
	},
	MoreInformation -> {
		"SequenceAlignmentTable extends upon the functionality of the native Mathematica SequenceAlignment[] function.",
		"Sequence identity is calculated by dividing by the length of the total aligned sequence, including gaps."
	},
	SeeAlso -> {
		"AnalyzeDNASequencing",
		"SequenceAlignment",
		"SimilarityRules"
	},
	Author -> {"scicomp", "brad", "kevin.hou"}
}];