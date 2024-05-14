(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, Viscosity], {
	Description->"Measurements of viscosity at specific temperatures and shear rates.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ViscometerChip -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part,ViscometerChip],
				Object[Part,ViscometerChip]
			],
			Description -> "The microfluidic viscometer chip used to measure the viscosity of the sample by recording pressure drops across a measurement channel embedded with pressure sensors.",
			Category -> "General"
		},
		MeasurementMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ViscosityMeasurementMethodP,
			Description -> "The general type of measurement method that was conducted on this sample. Optimize determines the flow parameters during measurement time to measure viscosity of the sample at a single measurement temperature. TemperatureSweep conducts measurements at two or more temperatures. FlowRateSweep conducts measurements at two or more FlowRates (shear rates). Custom conducts measurements at any combination temperatures and shear rates .",
			Category -> "General"
		},
		InjectionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "The amount of sample injected into the measurement chip for viscosity measurements.",
			Category -> "General"
		},
		MeasurementMethodTable -> {
			Format->Multiple,
			Class -> {
				MeasurementTemperature -> Real,
				FlowRate -> Real,
				RelativePressure -> Real,
				EquilibrationTime -> Real,
				MeasurementTime -> Real,
				PauseTime -> Real,
				Priming -> Expression,
				NumberOfReadings -> Integer
			},
			Pattern :> {
				MeasurementTemperature -> GreaterP[0 Celsius],
				FlowRate -> GreaterEqualP[0 Microliter/Minute],
				RelativePressure -> GreaterEqualP[0 Percent],
				EquilibrationTime -> GreaterEqualP[0 Second],
				MeasurementTime -> GreaterEqualP[0 Second],
				PauseTime -> GreaterEqualP[0 Second],
				Priming -> BooleanP,
				NumberOfReadings -> GreaterP[0, 1]
			},
			Units->{
				MeasurementTemperature -> Celsius,
				FlowRate -> Microliter/Minute,
				RelativePressure -> Percent,
				EquilibrationTime -> Second,
				MeasurementTime -> Second,
				PauseTime -> Second,
				Priming -> None,
				NumberOfReadings -> None
			},
			Headers -> {
				MeasurementTemperature -> "Measurement Temperature",
				FlowRate -> "Flow Rate",
				RelativePressure -> "Relative Pressure",
				EquilibrationTime ->"Equilibration Time",
				MeasurementTime -> "Measurement Time",
				PauseTime -> "Pause Time",
				Priming ->"Priming",
				NumberOfReadings -> "Number Of Readings"
			},
			Description -> "The measurement parameters used to characterize the sample's viscosity.",
			Category -> "General"
		},
		(*===Experimental Results===*)
		(*  Data processed so that any repeated measurements at a specific MesurementTemperature and ShearRate(FlowRate) are combined together to produce a distribution *)
		StandardViscosity ->{
			Format->Single,
			Class -> Real,
			Pattern :> GreaterP[0*(Milli*Pascal)*Second],
			Units -> Milli*Pascal*Second,
			Description -> "The viscosity of the sample at 25 C at the first measured shear rate. For Non-Newtonian fluids, StandardViscosity does not take into account shear rate-dependence of viscosity.",
			Category-> "Experimental Results"
		},
		Viscosities ->{
			Format->Multiple,
			Class -> Distribution,
			Pattern :> DistributionP[(Milli*Pascal)*Second],
			Units -> (Milli*Pascal)*Second,
			Description -> "The empirical distribution of viscosity readings that were obtained at each distinct MeasurementTemperature and FlowRate (ShearRate), based on the NumberOfReadings.",
			Category-> "Experimental Results"
		},
		MeasurementTemperatures->{
			Format->Multiple,
			Class -> Distribution,
			Pattern :> DistributionP[Celsius],
			Units -> Celsius,
			Description -> "For each member of Viscosities, the empirical distribution of temperature(s) used to obtain the measurement(s), based on the NumberOfReadings.",
			IndexMatching->Viscosities,
			Category-> "Experimental Results"
		},
		FlowRates -> {
			Format->Multiple,
			Class -> Distribution,
			Pattern :> DistributionP[Microliter/Minute],
			Units -> Microliter/Minute,
			Description -> "For each member of Viscosities, the empirical distribution of the flow rate(s) used to obtain the measurement(s), based on the NumberOfReadings.",
			IndexMatching->Viscosities,
			Category-> "Experimental Results"
		},
		ShearRates -> {
			Format->Multiple,
			Class -> Distribution,
			Pattern :> DistributionP[Second^-1],
			Units -> Second^-1,
			Description -> "For each member of Viscosities, the empirical distribution of the shear rate(s) (calculated from FlowRates and channel geometry) used to obtain the measurement(s), based on the NumberOfReadings.",
			IndexMatching->Viscosities,
			Category-> "Experimental Results"
		},
		ShearStresses -> {
			Format->Multiple,
			Class -> Distribution,
			Pattern :> DistributionP[Pascal],
			Units -> Pascal,
			Description -> "For each member of Viscosities, the empirical distribution of the shear stress(es) (calculated from FlowRates) used to obtain the measurement(s), based on the NumberOfReadings.",
			IndexMatching->Viscosities,
			Category-> "Experimental Results"
		},
		PercentageFullScales -> {
			Format->Multiple,
			Class -> Distribution,
			Pattern :> DistributionP[],
			Units -> None,
			Description -> "For each member of Viscosities, the empirical distribution of the percentage(s) of the maximum pressure in the measurement channel achieved during the measurement(s), based on the NumberOfReadings. Excessively low or high percentages may result in unreliable reads.",
			IndexMatching->Viscosities,
			Category-> "Experimental Results"
		},
		MeasuredVolumes -> {
			Format->Multiple,
			Class -> Distribution,
			Pattern :> DistributionP[Microliter],
			Units -> Microliter,
			Description -> "For each member of Viscosities, the empirical distribution of the volume(s) of sample flowed through the measurement channel to obtain the mesaurement(s), based on the NumberOfReadings.",
			IndexMatching->Viscosities,
			Category-> "Experimental Results"
		},
		LoadedVolume -> {
			Format->Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume of sample injected into the MeasurementChip that the instrument draws from to obtain all measurements specified in the MeasurementMethodTable.",
			Category-> "Experimental Results"
		},
		RSquaredValues -> {
			Format->Multiple,
			Class -> Distribution,
			Pattern :> DistributionP[],
			Units->None,
			Description -> "For each member of Viscosities, the distribution of the R-squared values describing the linearity of the pressure readings across the channel, based on the NumberOfReadings.",
			IndexMatching->Viscosities,
			Category-> "Experimental Results"
		},
		SyringeTemperatures -> {
			Format->Multiple,
			Class -> Distribution,
			Pattern :> DistributionP[Celsius],
			Units->Celsius,
			Description -> "For each member of Viscosities, the distribution of the temperatures of the syringe that contains the sample to prior to being introduced into measurement chip, based on the NumberOfReadings.",
			IndexMatching->Viscosities,
			Category-> "Experimental Results"
		},
		RawDataFiles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The file(s) containing the raw unprocessed data generated by the instrument.",
			Category -> "Experimental Results"
		}
	 }
}];
