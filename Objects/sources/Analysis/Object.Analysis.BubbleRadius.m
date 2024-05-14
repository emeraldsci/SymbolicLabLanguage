(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Analysis,BubbleRadius],{
	Description->"Image analysis that computes the distribution of bubble radii at each frame of a video showing the evolution of foam bubbles over time.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		AnalysisVideoFile->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An AVI or MP4 file containing the video showing of this analysis, with a histogram showing the evolution of bubble sizes over time overlaid on a video where bubbles have been colored by relative size.",
			Category->"Analysis & Reports"
		},
		AnalysisVideoFrames->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"A ZIP file containing each frame of the AnalysisVideoFile, where each frame is a PNG or TIFF image file.",
			Category->"Analysis & Reports"
		},
		AnalysisVideoPreview->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"A Mathematica MX binary file containing an animation showing a dynamic histogram of bubble sizes over time alongside the original video, with bubbles colored by relative size.",
			Category->"Analysis & Reports"
		},
		VideoTimePoints->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0.0 Second],
			Units->Second,
			Description->"Elapsed time from the start of the experiment at each frame of the analyzed foaming video.",
			Category->"Analysis & Reports"
		},
		RadiusDistribution->{
			Format->Multiple,
			Class->Distribution,
			Pattern:>DistributionP[Micrometer],
			Units->Micrometer,
			Description->"For each member of VideoTimePoints, the distribution of bubble radii at each frame of the analyzed foaming video.",
			Category->"Analysis & Reports",
			IndexMatching->VideoTimePoints
		},
		AreaDistribution->{
			Format->Multiple,
			Class->Distribution,
			Pattern:>DistributionP[Micrometer^2],
			Units->Micrometer^2,
			Description->"For each member of VideoTimePoints, the distribution of bubble areas at each frame of the analyzed foaming video.",
			Category->"Analysis & Reports",
			IndexMatching->VideoTimePoints
		},
		AbsoluteBubbleCount->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[0,1],
			Description->"For each member of VideoTimePoints, the absolute number of bubbles detected at each frame of the analyzed foaming video.",
			Category->"Analysis & Reports",
			IndexMatching->VideoTimePoints
		},
		(* Fields computed by the instrument which are recomputed here *)
		BubbleCount->{
			Format->Single,
			Class->QuantityArray,
			Pattern:>QuantityMatrixP[{Second, Millimeter^-2}],
			Units->{Second, Millimeter^-2},
			Description->"The re-analyzed absolute number of bubbles divided by the total bubble area at each frame of the analyzed foaming video.",
			Category->"Analysis & Reports"
		},
		MeanBubbleArea->{
			Format->Single,
			Class->QuantityArray,
			Pattern:>QuantityMatrixP[{Second, Micrometer^2}],
			Units->{Second, Micrometer^2},
			Description->"The re-analyzed average area of bubbles at each frame of the analyzed foaming video.",
			Category->"Analysis & Reports"
		},
		StandardDeviationBubbleArea->{
			Format->Single,
			Class->QuantityArray,
			Pattern:>QuantityMatrixP[{Second, Micrometer^2}],
			Units->{Second, Micrometer^2},
			Description->"The re-analyzed standard deviation of bubble areas at each frame of the analyzed foaming video.",
			Category->"Analysis & Reports"
		},
		AverageBubbleRadius->{
			Format->Single,
			Class->QuantityArray,
			Pattern:>QuantityMatrixP[{Second, Micrometer}],
			Units->{Second, Micrometer},
			Description->"The re-analyzed average bubble radius at each frame of the analyzed foaming video.",
			Category->"Analysis & Reports"
		},
		StandardDeviationBubbleRadius->{
			Format->Single,
			Class->QuantityArray,
			Pattern:>QuantityMatrixP[{Second, Micrometer}],
			Units->{Second, Micrometer},
			Description->"The re-analyzed standard deviation of bubble radius at each frame of the analyzed foaming video.",
			Category->"Analysis & Reports"
		},
		MeanSquareBubbleRadius->{
			Format->Single,
			Class->QuantityArray,
			Pattern:>QuantityMatrixP[{Second, Micrometer}],
			Units->{Second, Micrometer},
			Description->"The re-analyzed mean-squared bubble radius at each frame of the analyzed foaming video.",
			Category->"Analysis & Reports"
		},
		BubbleSauterMeanRadius->{
			Format->Single,
			Class->QuantityArray,
			Pattern:>QuantityMatrixP[{Second, Micrometer}],
			Units->{Second, Micrometer},
			Description->"The re-analyzed Sauter-mean bubble radius (R32) at each frame of the analyzed foaming video.",
			Category->"Analysis & Reports"
		},
		(* Method Information populated from the input data object for easier searching *)
		DetectionMethod->{
			Format->Single,
			Class->Expression,
			Pattern:>{FoamDetectionMethodP..},
			Description->"The type of foam detection method(s) that was used during the experiment. The foam detection methods are the Height Method (default method for the Dynamic Foam Analyzer), Liquid Conductivity Method, and Imaging Method. The Height Method provides information on foamability and foam height, the Liquid Conductivity Method provides information on the liquid content and drainage dynamics of foam, and then Imaging Method provides data on the size and distribution of foam bubbles.",
			Category -> "General"
		},
		SampleVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Milliliter],
			Units->Milliliter,
			Description->"The volume of initial liquid sample solution that was used for the dynamic foam analysis experiment.",
			Category -> "General"
		},
		AgitationTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Minute,
			Description->"The amount of time that the liquid sample was agitated to generate foam.",
			Category -> "General"
		},
		DecayTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Minute,
			Description->"The amount of time that the foam was allowed to decay in the experiment, during which experimental measurements were taken.",
			Category -> "General"
		},
		Wavelength->{
			Format->Single,
			Class->Integer,
			Pattern:>Alternatives[469 Nanometer,850 Nanometer],
			Units->Nanometer,
			Description->"The wavelength that was used to illuminate the sample column during the course of the experiment.",
			Category->"Instrument Specifications"
		},
		FieldOfView->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0*Millimeter^2],
			Units->Millimeter^2,
			Description->"The field of view used by the Foam Structure Module in the experiment.",
			Category -> "General"
		},
		CameraHeight->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Millimeter],
			Units->Millimeter,
			Description->"The height at which the camera used by the Foam Structure Module was positioned during the experiment.",
			Category->"Instrument Specifications"
		},
		ManifoldLogs -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "Debugging log generated by AnalyzeBubbleRadius when it is run on Manifold.",
			Category->"Analysis & Reports",
			Developer->True
		}
	}
}];
