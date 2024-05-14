(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, FoamImagingModule], {
	Description->"Information for a foam imaging module used in a dynamic foam analysis instrument for the optical measurement of the 2D structure of foams. The Foam Imaging Module transmits light through a glass prism specially fitted on the side of a foam column, in order to ascertain the 2D structure of the foam based on the principles of total reflection. Since glass and liquid have comparable diffractive indices, light that hits a foam lamella will be partially diffracted and transmitted into the foam. On the other hand, glass and air have different diffractive indices, so light that hits within the air bubble will be fully reflected and sensed by the camera, allowing for construction of a 2D image of the layer of foam located at the edge of the prism.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
	}
}];
