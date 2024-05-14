

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, Lyophilize], {
	Description->"Protocol for removing solvent from the provided samples via sublimation.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument,Lyophilizer],Object[Instrument,Lyophilizer]],
			Description -> "The instrument that will hold the samples at various vacuum pressure and temperatures in order to freeze the samples and then sublimate solvent out of the samples.",
			Category -> "Instrument Setup"
		},
		DeckLayout -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[DeckLayout],
			Description -> "The deck configuration this protocol requires for fitting all the samples into the sample chamber of the instrument.",
			Category -> "Instrument Setup"
		},
		TemperaturePressureProfile -> {
			Format -> Multiple,
			Class -> {Real,Real,Real},
			Pattern :> {GreaterEqualP[0*Second],GreaterEqualP[0*Kelvin],GreaterEqualP[0*Millitorr]},
			Units -> {Hour,Celsius,Millitorr},
			Description -> "Combination of Pressure and Temperature gradients, detailing the vacuum pressures and temperatures the samples will be exposed to over the course of the lyophilization.",
			Category -> "General",
			Headers -> {"Time","Temperature","Pressure"}
		},
		TemperatureGradient -> {
			Format -> Multiple,
			Class -> {Real,Real},
			Pattern :> {GreaterEqualP[0*Second], GreaterEqualP[0*Kelvin]},
			Units -> {Hour, Celsius},
			Description -> "The temperature curve, in the form {time, temperature}, that the samples will be exposed to in order to facilitate sublimation of solvent.",
			Category -> "General",
			Headers -> {"Time","Temperature"}
		},
		PressureGradient -> {
			Format -> Multiple,
			Class -> {Real,Real},
			Pattern :> {GreaterEqualP[0*Second], GreaterEqualP[0*Millitorr]},
			Units -> {Hour, Millitorr},
			Description -> "The pressure curve, in the form {time, pressure}, that the samples will be exposed to in order to facilitate sublimation of solvent.",
			Category -> "General",
			Headers -> {"Time","Pressure"}
		},
		LyophilizationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Hour],
			Units -> Hour,
			Description -> "Indicates the duration of time for which the samples will be lyophilized during one full Temperature and Pressure gradient cycle.",
			Category -> "General"
		},
		PreFrozenSamples ->{
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the SamplesIn were already frozen, prior to the start of the experiment, which reduces the amount of freezing time necessary on the lyophilizer.",
			Category -> "General"
		},
		LyophilizeUntilDry ->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if the lyophilization should be continued up to the MaxLyophilizationTime, in an attempt fully dry the samples.",
			Category -> "General",
			IndexMatching -> SamplesIn
		},
		MaxLyophilizationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Hour],
			Units -> Hour,
			Description -> "Indicates the maximum duration of time for which the samples will be lyophilized in an attempt to fully dry the sample, if the LyophilizeUntilDry is True.",
			Category -> "General"
		},
		FullyLyophilized -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if the sample appears fully dried upon visual inspection.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		},
		ResidualTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature the shelves will maintain after the completion of the lyophilization method while the samples await storage.",
			Category -> "Storage Information"
		},
		ResidualPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Torr],
			Units -> Torr,
			Description -> "The pressure the lyophilizer will maintain after the completion of the lyophilization method while the samples await storage.",
			Category -> "Storage Information"
		},
		NitrogenFlush -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the sample chamber will be filled with nitrogen before and after the lyophilization process. During the lyophilization process, nitrogen flow is stopped to allow for high vacuum pressures to be maintained.",
			Category -> "Storage Information"
		},
		ProbeSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample],Object[Sample]],
			Description -> "The samples into which the thermocouple temperature sensors will be immersed during the lyophilization in order to measure sample temperature throughout the experiment.",
			Category -> "Sensor Information"
		},
		TemperatureData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data,Temperature],
			Description -> "The data gathered by the instrument's temperature probes that were immersed in the ProbeSamples during the experiment.",
			Category -> "Experimental Results"
		},
(*	TODO: Re-implement the parser. It is possible to get data off the instrument, just quite difficult
		PressureData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data,Pressure],
			Description -> "The pressure curve gathered by the instrument from within the sample chamber.",
			Category -> "Experimental Results"
		},*)
		CurrentFullyLyophilized -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "A field that will temporarily hold Lab Operator responses to whether samples are fully dried before the information is transfered to the field FullyLyophilized.",
			Category -> "Experimental Results",
			Developer -> True
		},
		TotalLyophilizationTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> TimeP,
			Description -> "For each member of SamplesIn, total amount of time that elapsed during evaporation.",
			Category -> "Batching",
			Developer -> True,
			Units -> Hour,
			IndexMatching -> SamplesIn
		},
		(* The AdvantagePro lyophilizer expects temperature/pressure/time in the form of {ShelfTemp,RampTime,HoldTime,Pressure}.
		 Below are two fields (one for each input screen on the instrument) of the gradient converted from TemperaturePressureProfile
		 into the expected format *)
		ThermalTreatmentSteps -> {
			Format -> Multiple,
			Class -> {Real,Real,Real},
			Pattern :> {TemperatureP,TimeP,TimeP},
			Units -> {Celsius, Minute, Minute},
			Headers -> {"Shelf Temperature","Ramp Time","Hold Time"},
			Description -> "The thermal treatment steps of the TemperaturePressureProfile, which are used for freezing converted into the AdvantagePro expected format.",
			Category -> "General",
			Developer -> True
		},
		FirstDryingSteps -> {
			Format -> Multiple,
			Class -> {Real,Real,Real,Real},
			Pattern :> {TemperatureP,TimeP,TimeP,PressureP},
			Units -> {Celsius, Minute, Minute, Millitorr},
			Headers -> {"Shelf Temperature","Ramp Time","Hold Time","Chamber Pressure"},
			Description -> "The first six drying steps of the TemperaturePressureProfile converted into the AdvantagePro expected format.",
			Category -> "General",
			Developer -> True
		},
		LastDryingSteps -> {
			Format -> Multiple,
			Class -> {Real,Real,Real,Real},
			Pattern :> {TemperatureP,TimeP,TimeP,PressureP},
			Units -> {Celsius, Minute, Minute, Millitorr},
			Headers -> {"Shelf Temperature","Ramp Time","Hold Time","Chamber Pressure"},
			Description -> "The last six drying steps of the TemperaturePressureProfile converted into the AdvantagePro expected format.",
			Category -> "General",
			Developer -> True
		},
		ContainerCovers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item,Consumable],Object[Item,Consumable],Model[Item,Cap],Object[Item,Cap],Model[Item,PlateSeal],Object[Item,PlateSeal]],
			Description -> "For each member of ContainersIn, the item used to hold any frozen sample plugs inside the container.",
			Category -> "General",
			IndexMatching -> ContainersIn
		},
		PerforateCover -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates whether the seal should be punctured.",
			Category -> "General",
			IndexMatching -> SamplesIn
		}
	}
}];
