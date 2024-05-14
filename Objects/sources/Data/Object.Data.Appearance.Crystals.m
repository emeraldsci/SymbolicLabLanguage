(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, Appearance, Crystals], {
  Description -> "Image representing the physical appearance of a sample that contains crystals. Contains specific information regarding images of the crystals, including visible light imaging, ultraviolet (UV) imaging, and cross polarized imaging at different z focus height taken on a daily basis.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {

    (* Imaging Specifications *)
    (* VisibleLightImaging *)
    VisibleLightExposureTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Millisecond],
      Units -> Millisecond,
      Description -> "The length of time for which the image sensor was exposed to the visible light ranging from 400nm to 700nm passed through the sample.",
      Category -> "VisibleLightImaging Specifications"
    },
    VisibleLightObjectiveMagnification -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[1],
      Description -> "The visible light objective lens magnification provided to zoom in on the sample.",
      Category -> "VisibleLightImaging Specifications"
    },
    VisibleLightImageScale -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Pixel/Millimeter],
      Units -> Pixel/Millimeter,
      Description -> "The scale in pixels/distance relating pixels of the image to real world distance when the sample was illuminated with visible light and passed through the magnification lens.",
      Category -> "VisibleLightImaging Specifications"
    },
    VisibleLightImageFile -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[EmeraldCloudFile],
      Description -> "An extended focus image containing superimposed images of the sample illuminated with visible light focused at multiple focal planes of the sample.",
      Category -> "VisibleLightImaging Specifications",
      Abstract -> True
    },

    (* UVImaging *)
    UVExposureTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Millisecond],
      Units -> Millisecond,
      Description -> "The length of time for which the image sensor was exposed to the ultraviolet light centered at 280nm passed through the sample.",
      Category -> "UVImaging Specifications"
    },
    UVObjectiveMagnification -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[1],
      Description -> "The ultraviolet light objective lens magnification provided to zoom in on the sample.",
      Category -> "UVImaging Specifications"
    },
    UVImageScale -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Pixel/Millimeter],
      Units -> Pixel/Millimeter,
      Description -> "The scale in pixels/distance relating pixels of the image to real world distance when the sample was illuminated with ultraviolet light and passed through the magnification lens.",
      Category -> "UVImaging Specifications"
    },
    UVImageFile -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[EmeraldCloudFile],
      Description -> "An extended focus image containing superimposed images of the sample illuminated with ultraviolet light focused at multiple focal planes of the sample.",
      Category -> "UVImaging Specifications"
    },

    (* CrossPolarization *)
    CrossPolarizationExposureTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Millisecond],
      Units -> Millisecond,
      Description -> "The length of time for which the image sensor was exposed to the cross polarized light ranged from 400nm to 700nm passed through the sample.",
      Category -> "CrossPolarizedImaging Specifications"
    },
    CrossPolarizationObjectiveMagnification -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[1],
      Description -> "The cross polarized light objective lens magnification provided to zoom in on the sample.",
      Category -> "CrossPolarizedImaging Specifications"
    },
    CrossPolarizedImageScale -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Pixel/Millimeter],
      Units -> Pixel/Millimeter,
      Description -> "The scale in pixels/distance relating pixels of the image to real world distance when the sample was illuminated with cross polarized light and passed through the magnification lens.",
      Category -> "CrossPolarizedImaging Specifications"
    },
    CrossPolarizedImageFile -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[EmeraldCloudFile],
      Description -> "An extended focus image containing superimposed images of the sample illuminated with cross polarized light focused at multiple focal planes of the sample.",
      Category -> "CrossPolarizedImaging Specifications"
    }
  }
}];