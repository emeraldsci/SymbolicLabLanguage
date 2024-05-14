(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Analysis, MicroscopeOverlay], {
	Description->"Analysis for coloring and combining of a set of fluorescent microscope images with a phase contrast image while varying transparency, contrast, and brightness.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		BrightnessRed -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[-1, 1],
			Units -> None,
			Description -> "The brightness adjustment for the red image.  All pixel intensities in the red image are offset by this amount.",
			Category -> "General"
		},
		BrightnessGreen -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[-1, 1],
			Units -> None,
			Description -> "The brightness adjustment for the green image.  All pixel intensities in the blue image are offset by this amount.",
			Category -> "General"
		},
		BrightnessBlue -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[-1, 1],
			Units -> None,
			Description -> "The brightness adjustment for the blue image.  All pixel intensities in the blue image are offset by this amount.",
			Category -> "General"
		},
		ContrastRed -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 1],
			Units -> None,
			Description -> "The contrast for the red image, defined as the difference between the maximum and minimum intensity of the image. All pixel intensities in the red image are scaled to obtain this contrast value.",
			Category -> "General"
		},
		ContrastGreen -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 1],
			Units -> None,
			Description -> "The contrast for the green image, defined as the difference between the maximum and minimum intensity of the image. All pixel intensities in the green image are scaled to obtain this contrast value.",
			Category -> "General"
		},
		ContrastBlue -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 1],
			Units -> None,
			Description -> "The contrast for the blue image, defined as the difference between the maximum and minimum intensity of the image. All pixel intensities in the blue image are scaled to obtain this contrast value.",
			Category -> "General"
		},
		FalseColorRed -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _?ColorQ,
			Description -> "The red image will display with this color.",
			Category -> "General"
		},
		FalseColorGreen -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _?ColorQ,
			Description -> "The green image will display with this color.",
			Category -> "General"
		},
		FalseColorBlue -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _?ColorQ,
			Description -> "The blue image will display with this color.",
			Category -> "General"
		},
		Transparency -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 1],
			Units -> None,
			Description -> "The transparency applied to the combined false colored images before they are overlaid with the phase contrast image.",
			Category -> "General"
		},
		ChannelsOverlaid -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Red | Blue | Green | PhaseContrast,
			Description -> "The image channels included in the final overlay image.",
			Category -> "General"
		},
		Overlay -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[OverlayFile]}, ImportCloudFile[Field[OverlayFile]]],
			Pattern :> _Image,
			Description -> "The final image obtained by combining the colored and adjusted fluorescent images with the phase contrast image.",
			Category -> "Analysis & Reports"
		},
		OverlayFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[Object[EmeraldCloudFile]],
			Relation->Object[EmeraldCloudFile],
			Description -> "The overlay image using the specified analysis parameters.",
			Category -> "Analysis & Reports"
		}
	}
}];
