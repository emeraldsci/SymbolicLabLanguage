(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, MeltingPointApparatus], {
	Description->"Model of an apparatus that is used for measuring the melting temperature of a solid substance. Melting point refers to the temperature at which the physical state of the matter changes from solid to liquid. Melting point apparatuses might be able to measure other physical transitions, such as boiling point.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
    Measurands -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[MeltingPoint,MeltingRange,BoilingPoint,CloudPoint,SlipMeltingPoint],
      Description -> "The physical parameters that the apparatus can measure. Options include MeltingPoint, MeltingRange, BoilingPoint, CloudPoint, and SlipMeltingPointMeltingPoint. MeltingPoint refers to the temperature at which the physical state of the matter changes from solid to liquid. MeltingRange refers to temperature range between melting onset point (at which the first detectable liquid phase is detected) and clear point (at which no solid phase is apparent). BoilingPoint refers to the temperature at which the physical state of the matter changes from liquid to gas. CloudPoint refers to the temperature at which a transparent solution undergoes a liquid-liquid or liquid solid phase separation resulting in a cloudy solution. SlipMeltingPoint which is a characteristic of materials with waxy consistency, such as fats and cosmetics, refers to the temperature at which a sample, in an open capillary that is immersed in water, has softened sufficiently to rise in the capillary tube due to water buoyancy (weight-opposing force on an object that is immersed in a fluid).",
      Category -> "Instrument Specifications"
    },
    NumberOfMeltingPointCapillarySlots -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> GreaterEqualP[0,1],
      Description -> "Number of capillary slots that the apparatus has for simultaneous measurement of melting points. Melting point refers to the temperature at which the physical state of the matter changes from solid to liquid.",
      Category -> "Instrument Specifications"
    },
    NumberOfBoilingPointCapillarySlots -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> GreaterEqualP[0,1],
      Description -> "Number of capillary slots that the apparatus has for simultaneous measurement of boiling points. Boiling point refers to the temperature at which the physical state of the matter changes from liquid to gas.",
      Category -> "Instrument Specifications"
    },
    NumberOfCloudPointCapillarySlots -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> GreaterEqualP[0,1],
      Description -> "Number of capillary slots that the apparatus has for simultaneous measurement of cloud points. CloudPoint refers to the temperature at which a transparent solution undergoes a liquid-liquid or liquid solid phase separation resulting in a cloudy solution.",
      Category -> "Instrument Specifications"
    },
    NumberOfSlipMeltingPointCapillarySlots -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> GreaterEqualP[0,1],
      Description -> "Number of capillary slots that the apparatus has for simultaneous measurement of slip melting points. Slip melting point, which is a characteristic of materials with waxy consistency, such as fats and cosmetics, refers to the temperature at which a sample, in an open capillary that is immersed in water, has softened sufficiently to rise in the capillary tube due to water buoyancy (weight-opposing force on an object that is immersed in a fluid).",
      Category -> "Instrument Specifications"
    },
    MinTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Kelvin],
      Units -> Celsius,
      Description -> "Minimum temperature the melting point apparatus can achieve while incubating the capillary.",
      Category -> "Operating Limits"
    },
    MaxTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Kelvin],
      Units -> Celsius,
      Description -> "Maximum temperature the melting point apparatus can achieve while incubating the capillary.",
      Category -> "Operating Limits"
    },
    TemperatureResolution -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Kelvin],
      Units -> Celsius,
      Description -> "The smallest change in temperature that corresponds to a change in the displayed value.",
      Category -> "Operating Limits"
    },
    MinTemperatureRampRate -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Celsius/Minute],
      Units -> Celsius/Minute,
      Description -> "The slowest rate at which the temperature of the chamber that the sample resides can increase by instruments of this model.",
      Category -> "Operating Limits"
    },
    MaxTemperatureRampRate -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Celsius/Minute],
      Units -> Celsius/Minute,
      Description -> "The fastest rate at which the temperature of the chamber that the sample resides can increase by instruments of this model.",
      Category -> "Operating Limits"
    }
  }
}];