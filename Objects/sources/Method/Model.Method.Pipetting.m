(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Method, Pipetting],
	{
		Description -> "Parameters describing the specific way in which a sample should be aspirated and dispensed from a pipette.",
		CreatePrivileges->None,
		Cache->Session,
		Fields -> {
			Models -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Model[Sample][PipettingMethod],
				Description -> "The objects for which these pipetting parameters will be used as default unless they are directly specified in manipulation primitives.",
				Category -> "General"
			},
			(* Aspiration Parameters *)
			AspirationRate -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0 Microliter/Second],
				Units -> Microliter/Second,
				Description -> "The speed at which liquid should be drawn up into the pipette tip.",
				Category -> "General"
			},
			OverAspirationVolume -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The volume of air drawn into the pipette tip at the end of the aspiration of a liquid.",
				Category -> "General"
			},
			AspirationWithdrawalRate -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0 Millimeter/Second],
				Units -> Millimeter/Second,
				Description -> "The speed at which the pipette is removed from the liquid after an aspiration.",
				Category -> "General"
			},
			AspirationEquilibrationTime -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Second],
				Units -> Second,
				Description -> "The delay length the pipette waits after aspirating before it is removed from the liquid.",
				Category -> "General"
			},
			AspirationMixRate -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0 Microliter/Second],
				Units -> Microliter/Second,
				Description -> "The speed at which liquid is aspirated and dispensed in a liquid before it is aspirated.",
				Category -> "General"
			},
			AspirationPosition -> {
				Format -> Single,
				Class -> Expression,
				(* Top | Bottom | LiquidLevel *)
				Pattern :> PipettingPositionP,
				Description -> "The location from which liquid should be aspirated. Top will aspirate AspirationPositionOffset below the Top of the container, Bottom will aspirate AspirationPositionOffset above the Bottom of the container, LiquidLevel will aspirate AspirationPositionOffset below the liquid level of the sample in the container, and TouchOff will touch the bottom of the container before moving the specified AspirationPositionOffset above the bottom of the container to start aspirate the sample.",
				Category -> "General"
			},
			AspirationPositionOffset -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Millimeter],
				Units -> Millimeter,
				Description -> "The distance from the top or bottom of the container, depending on AspirationPosition, from which liquid should be aspirated.",
				Category -> "General"
			},
			
			(* Dispense Parameters *)
			DispenseRate -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0 Microliter/Second],
				Units -> Microliter/Second,
				Description -> "The speed at which liquid should be expelled from the pipette tip.",
				Category -> "General"
			},
			OverDispenseVolume -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The volume of air drawn blown out at the end of the dispensing of a liquid.",
				Category -> "General"
			},
			DispenseWithdrawalRate -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0 Millimeter/Second],
				Units -> Millimeter/Second,
				Description -> "The speed at which the pipette is removed from the liquid after a dispense.",
				Category -> "General"
			},
			DispenseEquilibrationTime -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Second],
				Units -> Second,
				Description -> "The delay length the pipette waits after dispensing before it is removed from the liquid.",
				Category -> "General"
			},
			DispenseMixRate -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0 Microliter/Second],
				Units -> Microliter/Second,
				Description -> "The speed at which liquid is aspirated and dispensed in a liquid after a dispense.",
				Category -> "General"
			},
			DispensePosition -> {
				Format -> Single,
				Class -> Expression,
				(* Top | Bottom | LiquidLevel *)
				Pattern :> PipettingPositionP,
				Description -> "The location from which liquid should be dispensed. Top will dispense DispensePositionOffset below the Top of the container, Bottom will dispense DispensePositionOffset above the Bottom of the container, LiquidLevel will dispense DispensePositionOffset below the liquid level of the sample in the container, and TouchOff will touch the bottom of the container before moving the specified DispensePositionOffset above the bottom of the container to start dispensing the sample.",
				Category -> "General"
			},
			DispensePositionOffset -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Millimeter],
				Units -> Millimeter,
				Description -> "The distance from the top or bottom of the container, depending on DispensePosition, from which liquid should be dispensed.",
				Category -> "General"
			},
			CorrectionCurve -> {
				Format -> Multiple,
				Class -> {Real,Real},
				Pattern :> {GreaterEqualP[0 Microliter],GreaterEqualP[0 Microliter]},
				Units -> {Microliter,Microliter},
				Description -> "The relationship between a target volume and the corrected volume that needs to be aspirated or dispensed to reach the target volume in the form: {target volume, actual volume}.",
				Category -> "General",
				Headers -> {"Target Volume","Actual Volume"}
			},
			DynamicAspiration -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if droplet formation should be prevented during liquid transfer. This should only be used for solvents that have high vapor pressure.",
				Category -> "General"
			}
		}
	}
];
