(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, GasChromatograph], {
	Description -> "The object for a gas chromatograph used to separate and analyze the components of mixtures of compounds.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {

		(* --- Instrument Specifications ---*)
		Detectors -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (MassSpectrometer|FlameIonizationDetector),
			Description -> "A list of detectors that can be installed on the instrument.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		InstalledDetector -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> (MassSpectrometer|FlameIonizationDetector),
			Description -> "The detector in this instrument to which a GC column is currently connected.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Scale -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> PurificationScaleP,
			Description -> "Indicates if the instrument is intended to separate material (Preparative) and therefore collect fractions and/or analyze properties of the material (Analytical).",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		CarrierGases -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (Helium|Dihydrogen|Dinitrogen),
			Description -> "A list of the carrier gases that can be plumbed to the instrument.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Inlets -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GCInletP,
			Description -> "Inlets that can be installed on this instrument. SplitSplitless inlets can flash vaporize a sample and force it either totally (splitless) or partially (split) onto the column for analysis, while the Multimode inlet allows for solvent venting with multiple injections, prior to a temperature programmed vaporization of the sample, pushing it onto the column in either split or splitless mode. OnlineGasSampling/OnlineLiquidSampling inlets can inject a sample loop containing gas/liquid into the inlet and onto the column.", (* The sampling technique(s) that may be used to inject a sample onto the column. LiquidInjection samples the liquid component of a sample, while HeadspaceInjection samples the gas in the space above a sample in the vial. SPMEInjection will adsorb a subset of the sample onto a fiber, which can then be heated inside the injector to release these compounds for analysis. *)
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		InstalledInlet -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GCInletP,
			Description -> "The inlet in this instrument to which a GC column is currently connected.",
			Category -> "Instrument Specifications",
			Developer -> True,
			Abstract -> True
		},
		ColumnOvenSize -> {
			Format -> Single,
			Class -> {Real, Real, Real},
			Pattern :> {GreaterP[0*Centi*Meter],GreaterP[0*Centi*Meter],GreaterP[0*Centi*Meter]},
			Units -> {Centi Meter,Centi Meter,Centi Meter},
			Description -> "The dimensions of the GC column oven in centimeters, in order Height, Width, Depth.",
			Headers -> {"Height","Width","Depth"},
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		ImportFileTemplates -> {
			Format -> Multiple,
			Class -> {String,Link},
			Pattern :> {_String,_Link},
			Relation -> {Null,Object[EmeraldCloudFile]},
			Description -> "Files used as templates to import protocol methods into the instrument's software.",
			Headers -> {"Filename","Cloud File"},
			Category -> "Instrument Specifications",
			Developer -> True
		},
		InstalledColumnAssembly -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Description -> "All column components in their order along the flow path of the installed column.",
			Relation -> Alternatives[
				Object[Item,Column],
				Model[Item,Column],
				Object[Plumbing,ColumnJoin],
				Model[Plumbing,ColumnJoin]
			],
			Category -> "Instrument Specifications",
			Developer -> True
		},

		(* --- Operating Limits --- *)
		MaxInletPressure->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*PSI],
			Units->PSI,
			Description->"The maximum inlet pressure (in gauge pressure) that can be set on this instrument.",
			Category->"Operating Limits",
			Abstract->True
		},
		MaxNumberOfColumns -> {
			Format->Single,
			Class->Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The maximum number of unique columns (on unique cages) that can be installed in the column oven simultaneously.",
			Category -> "Operating Limits"
		},
		MinColumnOvenTemperature -> {
			Format->Single,
			Class->Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units->Celsius,
			Description -> "The minimum temperature at which the column oven can incubate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxColumnOvenTemperature -> {
			Format->Single,
			Class->Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units->Celsius,
			Description -> "The maximum temperature at which the column oven can incubate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxColumnCageDiameter -> {
			Format->Single,
			Class->Real,
			Pattern :> GreaterP[0*Inch],
			Units->Inch,
			Description -> "The maximum column cage outside diameter that can be accommodated inside of the column oven.",
			Category -> "Operating Limits"
		},

		(* --- Dimensions & Positions --- *)
		AutosamplerDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck][Instruments],
			Description -> "The platform from which samples are robotically mixed/aspirated and injected onto the column.",
			Category -> "Dimensions & Positions"
		},
		ColumnConditioningLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Data],Object[Protocol]},
			Description -> "A historical record of chromatography data generated for any column conditioning procedures performed using the instrument.",
			Category -> "Qualifications & Maintenance",
			Headers ->{"Date","Chromatogram","Protocol"}
		},

		(* Sensors & Generators *)
		HeliumTankPressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "The pressure gauge indicating the pressure inside the He carrier gas tank.",
			Category -> "Sensor Information"
		},
		HeliumDeliveryPressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "The pressure gauge indicating the pressure on the instrument side of the regulator for the He carrier gas tank.",
			Category -> "Sensor Information"
		},
		MethaneTankPressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "The pressure gauge indicating the pressure inside the He carrier gas tank.",
			Category -> "Sensor Information"
		},
		MethaneDeliveryPressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "The pressure gauge indicating the pressure inside the He carrier gas tank.",
			Category -> "Sensor Information"
		},
		HydrogenDetector -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Pressure],
			Description -> "The H2 detector installed in the GC oven.",
			Category -> "Sensor Information"
		},
		ZeroAirGenerator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, GasGenerator],
			Description -> "The zero air generator used to supply the GC's air demands.",
			Category -> "Sensor Information"
		},
		HydrogenGenerator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, GasGenerator],
			Description -> "The H2 generator used to supply the GC's H2 demands.",
			Category -> "Sensor Information"
		},
		IntegratedMassSpectrometer-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, MassSpectrometer][IntegratedGC],
			Description -> "The mass spectrometer that is connected to this instrument and is used to ionize and measure the samples by mass spectrometry.",
			Category -> "Integrations"
		},
		(* track the ion source installed in the instrument's mass spectrometer *)
		InstalledIonSource -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ElectronIonization|ChemicalIonization,
			Relation -> Null,
			Description -> "The ion source installed in the mass spectrometer that is connected to this instrument.",
			Category -> "Integrations"
		},
		(* integrated mass spectrometer adapter, tubing that connects the column to the MS to reduce the need to vent the ms. *)
		InstalledMassSpectrometerAdapter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item,Column],
			Description -> "The mass spectrometer adapter that is currently installed on the inlet to the integrated mass spectrometer.",
			Category -> "General",
			Developer -> True
		},
		(* Tackle box *)
		PreferredTackleBox-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Box],
			Description -> "The tackle box for this instrument containing spare parts, tools, nuts, ferrules, etc.",
			Category -> "Integrations",
			Developer -> True
		}
	}
}
];
