(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: ian *)
(* :Date: 2023-02-14 *)

DefineObjectType[Object[Qualification,Training,ParameterizeContainer], {
  Description -> "A protocol that verifies an operator's ability to measure and parameterize a container.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    DimensionsUserInput -> {
      Format -> Single,
      Class -> {Real, Real, Real},
      Pattern :> {GreaterEqualP[0*Meter],GreaterEqualP[0*Meter],GreaterEqualP[0*Meter]},
      Units ->{Meter,Meter,Meter},
      Description -> "The user inputted external dimensions of this model of container.",
      Category -> "General",
      Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
    },
    WellDimensionsUserInput -> {
      Format -> Single,
      Class -> {Real,Real},
      Pattern :> {GreaterP[0*Milli*Meter],GreaterP[0*Milli*Meter]},
      Units -> {Meter Milli,Meter Milli},
      Headers -> {"Width","Depth"},
      Description -> "The user inputted internal size of the each position in this model of rack.",
      Category -> "General"
    },
    HorizontalPitchUserInput -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Milli*Meter],
      Units -> Meter Milli,
      Description -> "The user inputted center-to-center distance from one well to the next in a given row.",
      Category -> "General"
    },
    VerticalPitchUserInput -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Milli*Meter],
      Units -> Meter Milli,
      Description -> "The user inputted center-to-center distance from one well to the next in a given column.",
      Category -> "General"
    },
    VerticalMarginUserInput -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Milli*Meter],
      Units -> Meter Milli,
      Description -> "The user inputted distance from the top edge of the plate to the edge of the first well.",
      Category -> "General"
    },
    HorizontalMarginUserInput -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Milli*Meter],
      Units -> Meter Milli,
      Description -> "The user inputted distance from the left edge of the plate to the edge of the first well.",
      Category -> "General"
    },
    WellDepthUserInput -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Milli*Meter],
      Units -> Meter Milli,
      Description -> "The user inputted maximum z-axis depth of each well.",
      Category -> "General"
    },
    WellBottomUserInput -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> WellShapeP,
      Description -> "The user inputted shape of the bottom of each well.",
      Category -> "General"
    },
    DepthMarginUserInput -> {
      Format -> Single,
      Class -> Real,
      (* Intentionally leave this open to negative values for cases where wells protrude beyond skirt (e.g., filter plates) *)
      Pattern :> DistanceP,
      Units -> Meter Milli,
      Description -> "The user inputted Z-axis distance from the bottom of the plate to the bottom of the first well.",
      Category -> "General"
    },
    WellColorUserInput -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> PlateColorP,
      Description -> "The user inputted color of the bottom of the wells of the plate.",
      Category -> "General"
    },
    PlateColorUserInput -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> PlateColorP,
      Description -> "The user inputted color of the main body of the plate.",
      Category -> "General"
    },
    RowsUserInput -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> GreaterP[0, 1],
      Units -> None,
      Description -> "The user inputted number of rows of wells in the plate.",
      Category -> "General"
    },
    ColumnsUserInput -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> GreaterP[0, 1],
      Units -> None,
      Description -> "The user inputted number of columns of wells in the plate.",
      Category -> "General"
    },
    AspiratableUserInput -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "The user inputted indication if this samples can be transferred out of this container when it is not Covered.",
      Category -> "General"
    },
    DispensableUserInput -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "The user inputted indication if samples can be dispensed into this container when it is not Covered.",
      Category -> "General"
    },
    ReusabilityUserInput -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "The user inputted indication that this container can be used repeatedly.",
      Category -> "General"
    },
    CleaningMethodUserInput -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> CleaningMethodP,
      Description -> "The user inputted indication of the type of cleaning that is employed for this model of container before reuse.",
      Category -> "General"
    },
    HermeticUserInput -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "The user inputted indication if this container has an airtight seal at its aperture.",
      Category -> "General"
    },
    SelfStandingUserInput -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "The user inputted indication if this container is capable of staying upright when placed on a flat surface and does not require a rack.",
      Category -> "General"
    },
    TransportStableUserInput -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "The user inputted indication if this container is capable of staying upright without assistance when being transported on an operator cart. Containers that are stable for transport can tolerate cart motion and accidental contact without falling, while those that are not must be resource picked into a rack.",
      Category -> "General"
    },
    OpaqueUserInput -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "The user indication if the exterior of this container blocks the transmission of light.",
      Category -> "General"
    },
    SterileUserInput -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "The user inputted indication that this model of container arrives sterile from the manufacturer.",
      Category -> "General"
    },
    RNaseFreeUserInput -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "The user inputted indication that this model of container is free of any RNases when received from the manufacturer.",
      Category -> "General"
    },
    PyrogenFreeUserInput -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "The user inputted indication if this model of container is tested to be not contaminated with endotoxin by the manufacturer.",
      Category -> "General"
    },
    ParameterizeTrainingContainer -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container]|Object[Container],
      Description -> "The part or container that an operator will parameterize for training.",
      Category -> "General"
    },
    Caliper -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Instrument, DistanceGauge], Model[Instrument, DistanceGauge]],
      Description -> "The distance measurement device used to perform measurements in this protocol.",
      Category -> "General"
    }
  }
}]