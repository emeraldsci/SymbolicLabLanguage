(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[HandlingCondition],{
	Description->"Specifies the environment that samples are handled inside of. Handling in this case involves opening the container the sample resides in and adding to, removing, or measuring some of the sample.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the model.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Authors -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "The person(s) who created this model.",
			Category -> "Organizational Information"
		},
		Deprecated -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this model is historical and no longer used in the lab.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		},
		HandlingAtmosphere -> {
			(* This field will determine if a HandlingStation needs to be in a Glovebox. *)
			Format -> Single,
			Class -> Expression,
			Pattern :> HandlingAtmosphereP,
			Description -> "Indicates the gaseous environment that samples are interacted within and exposed to. Examples include Ambient, Nitrogen, Argon, LowVacuum, HighVacuum.",
			Category -> "Model Information"
		},
		MinWorkSurfaceArea -> {
			(* A specific HandlingCondition should support different manifestations of HandlingStations as long as each HandlingStation meets the same set of requirements. Some work surfaces may be larger than others, but what matters for safety is the smallest work surface that can be expected to be used by a HandlingCondition. *)
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter^2],
			Units -> Meter*Meter,
			Description -> "The minimum extent of the flat surface supplied to interact with samples within this model's condition. This extent determines how how many items of specific footprint sizes may be safely interacted with within the sample handling environment.",
			Category-> "Operating Limits"
		},
		MinWorkHeight -> {
			(* A specific HandlingCondition should support different manifestations of HandlingStations as long as each HandlingStation meets the same set of requirements. Some work heights may be larger than others, but what matters for safety is the smallest work height that can be expected to be used by a HandlingCondition. *)
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Centimeter,
			Description -> "The minimum vertical extent supplied to interact with samples within this model's condition. This extent determines the maximum height of object that may safely be interacted with within the sample handling environment.",
			Category-> "Operating Limits"
		},
		FumeExtraction -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			(* Fumehood, enclosure = True. BSC = False*)
			Description -> "Indicates if samples are interacted with inside of an environment that has active vapor removal such that fumes (e.g. harmful vapors) are removed from the environment and not allowed to escape into the greater lab space. An environment that captures vapors, physically filters them, and then returns the air back into the greater lab space is not considered to support FumeExtraction.",
			Category -> "Model Information"
		},
		MinVolumetricFlowRate -> {
			(* This field will determine if a HandlingStation needs to be in a Fumehood. *)
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Liter)/Second],
			Units -> Liter/Second,
			Description -> "The minimum amount of air, per unit time, pulled or pushed through the sample handling environment when the sash/door is at its working position. This rate generally determines how quickly vapors are removed from the handling environment and is often a function of the building's HVAC configuration.",
			Category-> "Operating Limits"
		},
		MinFlowSpeed -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Meter)/Second],
			Units -> Meter/Second,
			Description -> "The minimum distance per unit time traveled by air that is pulled or pushed through the open face of the sample handling environment when the sash/door is at its working position. This value determines how quickly vapors at the entrance of the handling environment are sucked into or ejected out from the work area. This speed is usually determined by the MinVolumetricFlowRate divided by the area of the open entrance door.",
			Category-> "Operating Limits"
		},
		BulkFlowDirection -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> (AwayFromOperator | TowardsOperator),
			Description -> "Indicates if air is pulled into the handling environment (AwayFromOperator) or pushed out of the handling environment (TowardsOperator).",
			Category -> "Model Information"
		},
		LaminarFlowDirection -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> (Horizontal | Vertical),
			Description -> "Indicates if smooth, non-turbid flow is present and which way it is oriented. Horizontal refers to uniform flow into or away from the handling environment through the door. Vertical refers to uniform flow up or down within the handling environment. As examples, some BiosafetyCabinets supply Vertical laminar flow down to the work surface while CleanBenches supply Horizontal laminar flow across the work surface towards the operator.",
			Category -> "Model Information"
		},
		MinLaminarFlowSpeed -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Meter)/Second],
			Units -> Meter/Second,
			Description -> "The minimum distance per unit time traveled by non-turbid air that is smoothly blown in the LaminarFlowDirection.",
			Category-> "Operating Limits"
		},
		AsepticTechniqueEnvironment -> {
			(* This field will determine if a HandlingStation needs to be in a BSC. *)
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if samples are interacted with inside of this environment using techniques that minimize risk of contamination among microorganisms.",
			Category -> "Model Information"
		},
		UVSterilization -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the inside of the handling environment is able to be sterilized with UV-C light.",
			Category -> "Model Information"
		},
		MaxRelativeHumidity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Percent],
			Units -> Percent,
			Description -> "The maximum relative humidity that samples within the model's condition will be subjected to.",
			Category -> "Operating Limits"
		},
		MinRelativeHumidity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Percent],
			Units -> Percent,
			Description -> "The minimum relative humidity that samples within the model's condition will be subjected to.",
			Category -> "Operating Limits"
		},
		NitrogenHermeticTransfer -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if samples that are interacted with inside of this environment may be hermetically transferred and have their containers backfilled with Nitrogen.",
			Category -> "Model Information"
		},
		ArgonHermeticTransfer -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if samples that are interacted with inside of this environment may be hermetically transferred and have their containers backfilled with Argon.",
			Category -> "Model Information"
		},
		NitrogenBackfillPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "The backing pressure of nitrogen available to fill the head space of a Sample's Container during a HermeticTransfer.",
			Category-> "Operating Limits"
		},
		ArgonBackfillPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "The backing pressure of argon available to fill the head space of a Sample's Container during a HermeticTransfer.",
			Category-> "Operating Limits"
		},
		SchlenkLineTransfer -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if samples that are interacted with inside of this environment may be transferred using a Schlenk Line.",
			Category -> "Model Information"
		},
		IRProbe -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if samples that are interacted with inside of this environment may have their temperature measured in a contactless manner using a blackbody radiation measurement device.",
			Category -> "Model Information"
		},
		BalanceType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BalanceModeP,
			Description -> "The scale of balance (Micro, Analytical, Macro, etc) that samples inside of this environment may be weighed with.",
			Category ->  "Model Information"
		},
		Pipette -> {
			(* This field will determine if a HandlingStation needs a pipette camera or not. *)
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if samples that are interacted with inside of this environment may be transferred using a hand pipette.",
			Category -> "Model Information"
		}
	}
}];
