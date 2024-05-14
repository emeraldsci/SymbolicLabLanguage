(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, CyclicVoltammetry], {
	Description->"Experiment results including the voltammograms for each individual sample measured by cyclic voltammetry experiment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		DataType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CyclicVoltammetryDataTypeP,
			Description -> "Indicates if the current data object reflects the result for the electrode pretreatment step or the cyclic voltammetry measurement step.",
			Category -> "General",
			Abstract -> True
		},

		(* Sample Information *)
		LoadingSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample][Data],
			Description -> "The solution loaded into the ReactionVessel for the measurement of this data. This solution is diluted from SamplesIn if the SamplesIn is not a fully prepared solution including the solvent, electrolyte, target analyte and an optional internal standard.",
			Category -> "General"
		},
		SampleVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The volumetric amount of LoadingSample transferred into the ReactionVessel for the measurement of this data.",
			Category -> "General"
		},
		InternalStandard -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			Description -> "Indicates if a chemical is included in the LoadingSample as a voltage (potential) standard when collecting this data.",
			Category -> "General"
		},

		(* Temporal Links for working, reference and counter electrodes *)
		WorkingElectrode -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Electrode],
			Description -> "The electrode whose potential is linearly swept in order to trigger local reduction and oxidation of the target analyte included in the LoadingSample.",
			Category -> "General"
		},
		ReferenceElectrode -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Electrode, ReferenceElectrode],
			Description -> "The electrode whose potential stays constant during the measurement, therefore can be used as a reference point to measure the potential of the WorkingElectrode. The potential difference between the WorkingElectrode and ReferenceElectrode is recorded as the x-axis of this data.",
			Category -> "General"
		},
		CounterElectrode -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Electrode],
			Description -> "The electrode inserted into the same LoadingSample solution as the WorkingElectrode to form a complete electrical circuit. The current flows between the WorkingElectrode and the CounterElectrodes is recorded as the y-axis of this data.",
			Category -> "General"
		},

		(* Temporal link as well for the cap and reaction vessel. *)
		ReactionVessel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, ReactionVessel, ElectrochemicalSynthesis],
			Description -> "The vessel used to hold the LoadingSample solution to be measured, which the WorkingElectrode, ReferenceElectrode, and CounterElectrode are inserted into.",
			Category -> "General"
		},
		ElectrodeCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Cap, ElectrodeCap],
			Description -> "The cap of the ReactionVessel, which holds the WorkingElectrode, ReferenceElectrode, and CounterElectrode, and conductively connects them to the Instrument.",
			Category -> "General"
		},

		(* Sparging Related *)
		SpargingGas -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> InertGasP,
			Description -> "Indicates the type of inert gas used for the sparging step before the measurement of this data.",
			Category -> "General"
		},
		SpargingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			Description -> "Indicates the duration for which the inert gas sparging step lasts before the measurement of this data.",
			Category -> "General"
		},
		SpargingPressure -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Pressure],
			Description -> "The inert gas pressure recording during the sparging step before the measurement of this data.",
			Category -> "General"
		},

		ExportDirectory -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path to where the data were stored.",
			Category -> "General",
			Developer -> True
		},

		(* Cyclic Voltammetry Measurement Information *)
		RawVoltammograms -> {
			(* TODO: plot with arrow *)
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Millivolt, Microampere}],
			Units -> {Millivolt, Microampere},
			Description -> "The two dimensional line plot showing the potential difference between the WorkingElectrode and the ReferenceElectrode as the x-axis, and the current between the WorkingElectrode and CounterElectrode as the y-axis, not adjusted for the middle potential of the internal standard.",
			Category -> "Data Processing"
		},
		InternalStandardMiddlePotentials -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> VoltageP,
			Units -> Millivolt,
			Description -> "For each member of RawVoltammograms, the middle potential value of the reduction wave and the oxidation wave of the included internal standard chemical. This value can be used to laterally shift the Voltammogram.",
			Category -> "Data Processing",
			IndexMatching -> RawVoltammograms
		},
		Voltammograms -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Volt, Ampere}],
			Units -> {Millivolt, Microampere},
			Description -> "For each member of RawVoltammograms, the two dimensional line plot showing the potential difference between the WorkingElectrode and the ReferenceElectrode as the x-axis, and the current between the WorkingElectrode and CounterElectrode as the y-axis, after being laterally offset by the InternalStandardMiddlePotential value.",
			Category -> "Experimental Results",
			IndexMatching -> RawVoltammograms
		},
		VoltammogramPotentials -> {
			Format -> Multiple,
			Class -> {
				InitialPotential -> Real,
				FirstPotential -> Real,
				SecondPotential -> Real,
				FinalPotential -> Real,
				SweepRate -> Real
			},
			Pattern :> {
				InitialPotential -> VoltageP,
				FirstPotential -> VoltageP,
				SecondPotential -> VoltageP,
				FinalPotential -> VoltageP,
				SweepRate -> GreaterP[0 Millivolt/Second]
			},
			Units -> {
				InitialPotential -> Millivolt,
				FirstPotential -> Millivolt,
				SecondPotential -> Millivolt,
				FinalPotential -> Millivolt,
				SweepRate -> Millivolt/Second
			},
			Headers -> {
				InitialPotential ->"Initial Potential",
				FirstPotential ->"First Potential",
				SecondPotential ->"Second Potential",
				FinalPotential ->"Final Potential",
				SweepRate ->"Sweep Rate"
			},
			Description -> "For each member of RawVoltammograms, the measurement starts at the InitialPotential, then to FirstPotential, then to SecondPotential, and stops at the FinalPotential. During this process, the WorkingElectrode potential is linearly swept between these potential points with a speed specified by SweepRate.",
			Category -> "Experimental Results",
			IndexMatching -> RawVoltammograms
		}

		(* Data Analyses Will be Migrated to Data Shared Fields *)
	}
}];
