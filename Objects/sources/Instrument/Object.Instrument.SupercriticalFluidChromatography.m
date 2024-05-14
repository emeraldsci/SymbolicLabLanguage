(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, SupercriticalFluidChromatography], {
	Description->"An instrument that uses supercritical CO2 and sometimes organic cosolvents in order to separate mixtures of compounds.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		CosolventAInlet -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing][SupercriticalFluidChromatography]|Object[Plumbing, Tubing],
			Description -> "The entry tubing used to take up cosolvent A to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		CosolventBInlet -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing][SupercriticalFluidChromatography]|Object[Plumbing, Tubing],
			Description -> "The entry tubing used to take up cosolvent B to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		CosolventCInlet -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing][SupercriticalFluidChromatography]|Object[Plumbing, Tubing],
			Description -> "The entry tubing used to take up cosolvent C to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		CosolventDInlet -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing][SupercriticalFluidChromatography]|Object[Plumbing, Tubing],
			Description -> "The entry tubing used to take up cosolvent D to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		MakeupSolventInlet -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing][SupercriticalFluidChromatography]|Object[Plumbing, Tubing],
			Description -> "The entry tubing used to take up buffer to the instrument after column separation and before detector measurement.",
			Category -> "Instrument Specifications"
		},
		NeedleWashSolutionInlet -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing][SupercriticalFluidChromatography]|Object[Plumbing, Tubing],
			Description -> "The entry tubing used to take up the strong needle wash solution to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		ExternalNeedleWashSolutionInlet -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing][SupercriticalFluidChromatography]|Object[Plumbing, Tubing],
			Description -> "The entry tubing used to take up the weak needle wash solution to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		NeedleWashCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item,Cap][SupercriticalFluidChromatography]|Object[Plumbing,AspirationCap][SupercriticalFluidChromatography],
			Description -> "The aspiration cap used to take up NeedleWash solution from the container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		ExternalNeedleWashCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item,Cap][SupercriticalFluidChromatography]|Object[Plumbing,AspirationCap][SupercriticalFluidChromatography],
			Description -> "The aspiration cap used to take up ExternalNeedleWash solution from the container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		CosolventACap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item,Cap][SupercriticalFluidChromatography]|Object[Plumbing,AspirationCap][SupercriticalFluidChromatography],
			Description -> "The aspiration cap used to take up cosolvent A from the container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		CosolventBCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item,Cap][SupercriticalFluidChromatography]|Object[Plumbing,AspirationCap][SupercriticalFluidChromatography],
			Description -> "The aspiration cap used to take up cosolvent B from the container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		CosolventCCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item,Cap][SupercriticalFluidChromatography]|Object[Plumbing,AspirationCap][SupercriticalFluidChromatography],
			Description -> "The aspiration cap used to take up cosolvent C from the container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		CosolventDCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item,Cap][SupercriticalFluidChromatography]|Object[Plumbing,AspirationCap][SupercriticalFluidChromatography],
			Description -> "The aspiration cap used to take up cosolvent D from the container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		MakeupSolventCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item,Cap][SupercriticalFluidChromatography]|Object[Plumbing,AspirationCap][SupercriticalFluidChromatography],
			Description -> "The aspiration cap used to take up solvent from the container to the system after the column separation.",
			Category -> "Instrument Specifications"
		},
		WastePump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, VacuumPump][SupercriticalFluidChromatography],
			Description -> "Vacuum pump that drains waste liquid into the carboy.",
			Category -> "Instrument Specifications"
		},

		(* --- Dimensions & Positions --- *)
		AutosamplerDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck][Instruments],
			Description -> "The platform from which samples are robotically aspirated and injected onto the column.",
			Category -> "Dimensions & Positions"
		},
		FractionCollectorDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck][Instruments],
			Description -> "The platform that houses containers into which the instrument will direct the fractions into individual wells robotically.",
			Category -> "Dimensions & Positions"
		},
		CosolventDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck][Instruments],
			Description -> "The platform which contains the liquids that are used as buffers/solvents for elution by the instrument.",
			Category -> "Dimensions & Positions"
		},
		WashBufferDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck][Instruments],
			Description -> "The platform which contains solvents used to flush and clean the fluid lines of the instrument.",
			Category -> "Dimensions & Positions"
		},
		ColumnCapRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Rack],
			Description -> "The rack which contains the column caps and joins while the columns themselves are being used by the instrument.",
			Category -> "Dimensions & Positions"
		},

		(* --- Qualifications & Maintenance---*)
		SystemPrimeLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Data],Object[Protocol]},
			Description -> "A historical record of chromatography data generated for the system prime runs on this instrument.",
			Category -> "Qualifications & Maintenance",
			Headers ->{"Date","Chromatogram","Protocol"}
		},
		SystemFlushLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Data],Object[Protocol]},
			Description -> "A historical record of chromatography data generated for the system flush runs on this instrument.",
			Category -> "Qualifications & Maintenance",
			Headers ->{"Date","Chromatogram","Protocol"}
		},

		(* Sensors *)

		CosolventABottleSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Cosolvent A volumes in bottles.",
			Category -> "Sensor Information"
		},
		CosolventBBottleSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Cosolvent B volumes in bottles.",
			Category -> "Sensor Information"
		},
		CosolventCBottleSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Cosolvent C volumes in bottles.",
			Category -> "Sensor Information"
		},
		CosolventDBottleSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Cosolvent D volumes in bottles.",
			Category -> "Sensor Information"
		},
		MakeupSolventBottleSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess MakeupSolvent volumes in bottles.",
			Category -> "Sensor Information"
		}
	}
}];
