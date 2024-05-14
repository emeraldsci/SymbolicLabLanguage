(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part,FoamImagingModule],{
	Description->"Model information for a foam imaging module used in a dynamic foam analysis instrument for the optical measurement of the 2D structure of foams. The Foam Imaging Module transmits light through a glass prism specially fitted on the side of a foam column, in order to ascertain the 2D structure of the foam based on the principles of total reflection. Since glass and liquid have comparable diffractive indices, light that hits a foam lamella will be partially diffracted and transmitted into the foam. On the other hand, glass and air have different diffractive indices, so light that hits within the air bubble will be fully reflected and sensed by the camera, allowing for construction of a 2D image of the layer of foam located at the edge of the prism.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(*- Camera fields (similar to those in Model[Part,Camera]) -*)
		CameraDimensions->{
			Format->Single,
			Class->{Real,Real,Real},
			Pattern:>{GreaterEqualP[0*Meter],GreaterEqualP[0*Meter],GreaterEqualP[0*Meter]},
			Units->{Meter,Meter,Meter},
			Description->"The external dimensions of the camera.",
			Category->"Physical Properties",
			Headers->{"X Dimension (Width)","Y Dimension (Depth)","Z Dimension (Height)"}
		},
		ImageScale->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*(Pixel/Centimeter)],
			Units->Pixel/Centimeter,
			Description->"The scale in pixels/centimeter relating pixels of the camera's output image to the physical distance at the camera's focal length.",
			Category->"Data Processing"
		},
		ImagePixelDimensions->{
			Format->Single,
			Class->{Integer,Integer},
			Pattern:>{GreaterEqualP[0*Pixel],GreaterEqualP[0*Pixel]},
			Units->{Pixel,Pixel},
			Description->"The pixel dimensions of the images output by this camera as configured.",
			Category->"Data Processing",
			Headers->{"X Dimension (Width)","Y Dimension (Height)"}
		},
		MinCameraHeight->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[Millimeter],
			Units->Millimeter,
			Description->"The minimum height along the foam column at which the camera used by the Foam Imaging Module can be positioned during the experiment.",
			Category->"Operating Limits"
		},
		MaxCameraHeight->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[Millimeter],
			Units->Millimeter,
			Description->"The maximum height along the foam column at which the camera used by the Foam Imaging Module can be positioned during the experiment.",
			Category->"Operating Limits"
		},

		(*- foam imaging module- *)
		MinImageSamplingFrequency->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Unit/Second],
			Units->Unit/Second,
			Description->"The minimum data sampling frequency that can be performed by the Foam Imaging Module for foam structure analysis. The data recorded for the Imaging Method are timelapse 2D snapshots of the foam in the camera field of view.",
			Category->"Operating Limits"
		},
		MaxImageSamplingFrequency->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Unit/Second],
			Units->Unit/Second,
			Description->"The maximum data sampling frequency that can be performed by the Foam Imaging Module for foam structure analysis. The data recorded for the Imaging Method are timelapse 2D snapshots of the foam in the camera field of view.",
			Category->"Operating Limits"
		},
		FieldOfView->{
			Format->Multiple,
			Class->Integer,
			Pattern:>Alternatives[85 Millimeter^2,140 Millimeter^2,285 Millimeter^2],
			Units->Millimeter^2,
			Description->"The size of the surface area that is observable at any given moment by the camera used by the Foam Imaging Module.",
			Category->"Part Specifications"
		},
		Wavelength->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Meter*Nano],
			Units->Meter Nano,
			Description->"Wavelength of emitted light that is used to illuminate the foam through the prism attached to the foam column.",
			Category->"Part Specifications"
		}
	}
}];
