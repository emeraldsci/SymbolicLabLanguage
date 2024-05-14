(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, Appearance, Colonies], {
  Description->"Image representing the physical appearance of a sample that contains bacterial colonies. Contains specific information regarding non-brightfield images of the colonies, including Fluorescent images, images from a BlueWhite Screen, and images taken with Darkfield lighting.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {

    (* Imaging Specifications *)
    (* VioletEmission, GreenEmission, OrangeEmission, RedEmission, DeepRedEmission, BlueWhite, Darkfield *)
    VioletFluorescenceImageFile->{
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[EmeraldCloudFile],
      Description -> "An image file containing the image of the sample while using a 337 Nanometer excitation wavelength and a 447 Nanometer wavelength emission filter.",
      Category -> "Imaging Specifications"
    },
    VioletFluorescenceExcitationWavelength->{
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Nanometer],
      Units -> Nanometer,
      Description -> "The wavelength of the excitation filter used to image the sample that corresponds to VioletFluorescence.",
      Category -> "Imaging Specifications"
    },
    VioletFluorescenceEmissionWavelength->{
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Nanometer],
      Units -> Nanometer,
      Description -> "The wavelength of the emission filter used to image the sample that corresponds to VioletFluorescence.",
      Category -> "Imaging Specifications"
    },
    VioletFluorescenceExposureTime->{
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Millisecond],
      Units -> Millisecond,
      Description -> "The length of time for which the sample was exposed to the VioletFluorescence channel while taking the image.",
      Category -> "Imaging Specifications"
    },
    VioletFluorescenceIlluminationDirection -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Top,
      Description -> "The direction from which the sample was illuminated with VioletFluorescenceExcitationWavelength.",
      Category -> "Imaging Specifications"
    },
    VioletFluorescenceImageScale -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[(0*Pixel)/(Centi*Meter)],
      Units -> Pixel/(Centi Meter),
      Description -> "The scale in pixels/distance relating pixels of the image when the sample was illuminated with VioletFluorescenceExcitationWavelength to real world distance.",
      Category -> "Imaging Specifications",
      Abstract -> True
    },

    (* GreenFluorescence *)
    GreenFluorescenceImageFile->{
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[EmeraldCloudFile],
      Description -> "An image file containing the image of the sample while using a 457 Nanometer excitation wavelength and a 536 Nanometer wavelength emission filter.",
      Category -> "Imaging Specifications"
    },
    GreenFluorescenceExcitationWavelength->{
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Nanometer],
      Units -> Nanometer,
      Description -> "The wavelength of the excitation filter used to image the sample that corresponds to GreenFluorescence.",
      Category -> "Imaging Specifications"
    },
    GreenFluorescenceEmissionWavelength->{
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Nanometer],
      Units -> Nanometer,
      Description -> "The wavelength of the emission filter used to image the sample that corresponds to GreenFluorescence.",
      Category -> "Imaging Specifications"
    },
    GreenFluorescenceExposureTime->{
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Millisecond],
      Units -> Millisecond,
      Description -> "The length of time for which the sample was exposed to the GreenFluorescence channel while taking the image.",
      Category -> "Imaging Specifications"
    },
    GreenFluorescenceIlluminationDirection -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Top,
      Description -> "The direction from which the sample was illuminated with GreenFluorescenceExcitationWavelength.",
      Category -> "Imaging Specifications"
    },
    GreenFluorescenceImageScale -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[(0*Pixel)/(Centi*Meter)],
      Units -> Pixel/(Centi Meter),
      Description -> "The scale in pixels/distance relating pixels of the image when the sample was illuminated with GreenFluorescenceExcitationWavelength to real world distance.",
      Category -> "Imaging Specifications",
      Abstract -> True
    },

    (* OrangeFluorescence *)
    OrangeFluorescenceImageFile->{
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[EmeraldCloudFile],
      Description -> "An image file containing the image of the sample while using a 531 Nanometer excitation wavelength and a 593 Nanometer wavelength emission filter.",
      Category -> "Imaging Specifications"
    },
    OrangeFluorescenceExcitationWavelength->{
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Nanometer],
      Units -> Nanometer,
      Description -> "The wavelength of the excitation filter used to image the sample that corresponds to OrangeFluorescence.",
      Category -> "Imaging Specifications"
    },
    OrangeFluorescenceEmissionWavelength->{
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Nanometer],
      Units -> Nanometer,
      Description -> "The wavelength of the emission filter used to image the sample that corresponds to OrangeFluorescence.",
      Category -> "Imaging Specifications"
    },
    OrangeFluorescenceExposureTime->{
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Millisecond],
      Units -> Millisecond,
      Description -> "The length of time for which the sample was exposed to the OrangeFluorescence channel while taking the image.",
      Category -> "Imaging Specifications"
    },
    OrangeFluorescenceIlluminationDirection -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Top,
      Description -> "The direction from which the sample was illuminated with OrangeFluorescenceExcitationWavelength.",
      Category -> "Imaging Specifications"
    },
    OrangeFluorescenceImageScale -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[(0*Pixel)/(Centi*Meter)],
      Units -> Pixel/(Centi Meter),
      Description -> "The scale in pixels/distance relating pixels of the image when the sample was illuminated with OrangeFluorescenceExcitationWavelength to real world distance.",
      Category -> "Imaging Specifications",
      Abstract -> True
    },

    (* RedFluorescence *)
    RedFluorescenceImageFile->{
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[EmeraldCloudFile],
      Description -> "An image file containing the image of the sample while using a 531 Nanometer excitation wavelength and a 624 Nanometer wavelength emission filter.",
      Category -> "Imaging Specifications"
    },
    RedFluorescenceExcitationWavelength->{
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Nanometer],
      Units -> Nanometer,
      Description -> "The wavelength of the excitation filter used to image the sample that corresponds to RedFluorescence.",
      Category -> "Imaging Specifications"
    },
    RedFluorescenceEmissionWavelength->{
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Nanometer],
      Units -> Nanometer,
      Description -> "The wavelength of the emission filter used to image the sample that corresponds to RedFluorescence.",
      Category -> "Imaging Specifications"
    },
    RedFluorescenceExposureTime->{
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Millisecond],
      Units -> Millisecond,
      Description -> "The length of time for which the sample was exposed to the RedFluorescence channel while taking the image.",
      Category -> "Imaging Specifications"
    },
    RedFluorescenceIlluminationDirection -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Top,
      Description -> "The direction from which the sample was illuminated with RedFluorescenceExcitationWavelength.",
      Category -> "Imaging Specifications"
    },
    RedFluorescenceImageScale -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[(0*Pixel)/(Centi*Meter)],
      Units -> Pixel/(Centi Meter),
      Description -> "The scale in pixels/distance relating pixels of the image when the sample was illuminated with RedFluorescenceExcitationWavelength to real world distance.",
      Category -> "Imaging Specifications",
      Abstract -> True
    },

    (* DarkRedFluorescence *)
    DarkRedFluorescenceImageFile->{
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[EmeraldCloudFile],
      Description -> "An image file containing the image of the sample while using a 628 Nanometer excitation wavelength and a 692 Nanometer wavelength emission filter.",
      Category -> "Imaging Specifications"
    },
    DarkRedFluorescenceExcitationWavelength->{
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Nanometer],
      Units -> Nanometer,
      Description -> "The wavelength of the excitation filter used to image the sample that corresponds to DarkRedFluorescence.",
      Category -> "Imaging Specifications"
    },
    DarkRedFluorescenceEmissionWavelength->{
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Nanometer],
      Units -> Nanometer,
      Description -> "The wavelength of the emission filter used to image the sample that corresponds to DarkRedFluorescence.",
      Category -> "Imaging Specifications"
    },
    DarkRedFluorescenceExposureTime->{
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Millisecond],
      Units -> Millisecond,
      Description -> "The length of time for which the sample was exposed to the DarkRedFluorescence channel while taking the image.",
      Category -> "Imaging Specifications"
    },
    DarkRedFluorescenceIlluminationDirection -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Top,
      Description -> "The direction from which the sample was illuminated with DarkRedFluorescenceExcitationWavelength.",
      Category -> "Imaging Specifications"
    },
    DarkRedFluorescenceImageScale -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[(0*Pixel)/(Centi*Meter)],
      Units -> Pixel/(Centi Meter),
      Description -> "The scale in pixels/distance relating pixels of the image when the sample was illuminated with DarkRedFluorescenceExcitationWavelength to real world distance.",
      Category -> "Imaging Specifications",
      Abstract -> True
    },

    (* BlueWhiteScreen *)
    BlueWhiteScreenImageFile->{
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[EmeraldCloudFile],
      Description -> "An image file containing the image of the sample while using a white light source light and a ___ Nanometer absorbance filter.", (* TODO: Figure out the exact wavelength and make sure this screens out only 1 wavelength *)
      Category -> "Imaging Specifications"
    },
    BlueWhiteScreenFilterWavelength->{
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Nanometer],
      Units -> Nanometer,
      Description -> "The wavelength of light that is filtered out before the source white light hits the sample colonies.",
      Category -> "Imaging Specifications"
    },
    BlueWhiteScreenExposureTime->{
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Millisecond],
      Units -> Millisecond,
      Description -> "The length of time for which the sample was exposed to the BlueWhiteScreen channel while taking the image.",
      Category -> "Imaging Specifications"
    },
    BlueWhiteScreenIlluminationDirection -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Bottom, (* Only happens on the qpix *)
      Description -> "The direction from which the sample was illuminated with white light.",
      Category -> "Imaging Specifications"
    },
    BlueWhiteScreenImageScale -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[(0*Pixel)/(Centi*Meter)],
      Units -> Pixel/(Centi Meter),
      Description -> "The scale in pixels/distance relating pixels of the blue white screen image to real world distance.",
      Category -> "Imaging Specifications",
      Abstract -> True
    },

    (* Darkfield *)
    DarkfieldImageFile->{
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[EmeraldCloudFile],
      Description -> "An image file containing the image of the sample while the sample was illuminated with white light from a ring around the sample.",
      Category -> "Imaging Specifications"
    },
    DarkfieldExposureTime->{
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Millisecond],
      Units -> Millisecond,
      Description -> "The length of time for which the sample was exposed to Darkfield lighting while taking the image.",
      Category -> "Imaging Specifications"
    },
    DarkfieldIlluminationDirection -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Side,
      Description -> "The direction from which the sample was illuminated while using Darkfield imaging.",
      Category -> "Imaging Specifications"
    },
    DarkfieldScreenImageScale -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[(0*Pixel)/(Centi*Meter)],
      Units -> Pixel/(Centi Meter),
      Description -> "The scale in pixels/distance relating pixels of the darkfield image to real world distance.",
      Category -> "Imaging Specifications",
      Abstract -> True
    },

    (* Analysis & Reports *)
    ColonyAnalysis -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Analysis][Reference],
      Description -> "A running log of all colony analyses performed on the image files in order to count and categorize the colonies.",
      Category -> "Analysis & Reports"
    },
    ImageExposureAnalyses -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Analysis][Reference],
      Description -> "Exposure analyses performed on the image files in this data.",
      Category -> "Analysis & Reports"
    },
    CellTypes->{
      Format->Multiple,
      Class->Link,
      Pattern:>_Link,
      Relation->Model[Cell],
      Description->"The identity models of cell lines that the sample contains as defined by the most recent ColonyAnalysis.",
      Category -> "Analysis & Reports"
    }
  }
}];
