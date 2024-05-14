(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*AnalyzeCellCount*)

(* -------------------------------------- *)
(* --- Main Definitions and Variables --- *)
(* -------------------------------------- *)

(* -------------------------- *)
(* --- Option Definitions --- *)
(* -------------------------- *)

DefineOptions[AnalyzeColonyCount,
	Options :> {

    (** Options shared with AnalyzeCellCount **)
    SharedOptions:>{
      AnalyzeCellCount,
      {
        CellType,
        CultureAdhesion,
        MicroscopeImageSelection,
        FluorescenceThreshold,
        AreaThreshold,
        MinCellRadius,
        MaxCellRadius,
        PropertyMeasurement,
        ImageAdjustment,
        ImageSegmentation
      }
    },

		(** Cell Color **)
		{
			OptionName -> CellColor,
			Default -> Null,
			Description -> "Indicates the color of the cells to include when performing the couning analysis.",
			AllowNull ->False,
			Widget->Widget[Type->Enumeration,Pattern:> ColorP | _LABColor],
			Category -> "Cell Color"
		},
		{
			OptionName -> CellColorThreshold,
			Default -> Automatic,
			Description -> "Specifies the acceptable color distance (measured with ColorDistance) that indicates whether a cell given its color should be included in the counting.
			The ColorDistance computes the Euclidean distance between the two color vectors in the LABColor space. LABColor is a color space designed to have perceptual uniformity;
			i.e. equal changes in its components will be perceived by a human to have equal effects. For the default method \"CIE76\", 0.2 is a reasonable distance and is the default.",
			ResolutionDescription -> "If Automatic and the CellColor is Null, this will be set to Null. If Automatic and the CellColor is provided, the default will be 0.2.",
			AllowNull ->True,
			Widget->Widget[Type->Number,Pattern:>RangeP[0,2.49863]],
			Category -> "Cell Color"
		},

		(** Output Processing **)
    AnalysisTemplateOption,
		OutputOption,
		UploadOption
	}
];
