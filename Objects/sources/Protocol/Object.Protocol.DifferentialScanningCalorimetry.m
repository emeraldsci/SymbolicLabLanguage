(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, DifferentialScanningCalorimetry], {
	Description -> "A differential scanning calorimetry (DSC) experiment where heat flux is measured as a function of temperature to determine thermodynamic properites of samples.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, DifferentialScanningCalorimeter] | Model[Instrument, DifferentialScanningCalorimeter],
			Description -> "The calorimeter used to measure the differential scanning calorimetry of samples.",
			Category -> "General"
		},

		PooledMixSamplePreparation -> {
			Format -> Multiple,
			Class -> {
				Mix -> Boolean,
				MixRate -> Real,
				MixTime -> Real
			},
			Pattern :> {
				Mix -> BooleanP,
				MixRate -> GreaterP[0 RPM],
				MixTime -> GreaterP[0 Second]
			},
			Units -> {
				Mix -> None,
				MixRate -> RPM,
				MixTime -> Minute
			},
			Relation -> {
				Mix -> Null,
				MixRate -> Null,
				MixTime -> Null
			},
			IndexMatching -> PooledSamplesIn,
			Description -> "For each member of PooledSamplesIn, parameters describing how the pooled samples should be mixed after aliquoting but prior to the start of the experiment.",
			Category -> "Sample Preparation"
		},

		NestedIndexMatchingMixSamplePreparation -> {
			Format -> Multiple,
			Class -> {
				Mix -> Boolean,
				MixRate -> Real,
				MixTime -> Real
			},
			Pattern :> {
				Mix -> BooleanP,
				MixRate -> GreaterP[0 RPM],
				MixTime -> GreaterP[0 Second]
			},
			Units -> {
				Mix -> None,
				MixRate -> RPM,
				MixTime -> Minute
			},
			Relation -> {
				Mix -> Null,
				MixRate -> Null,
				MixTime -> Null
			},
			IndexMatching -> PooledSamplesIn,
			Description -> "For each member of PooledSamplesIn, parameters describing how the pooled samples should be mixed after aliquoting but prior to the start of the experiment.",
			Category -> "Sample Preparation"
		},
		AutosamplerTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the samples are held prior to injection.",
			Category -> "Sample Preparation"
		},
		InjectionPlateSeal -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "The seal placed on the injection plate prior to the start of the autosampler.",
			Category -> "Thermocycling",
			Developer -> True
		},
		InjectionPlatePlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of placements used to move the injection plate into the DSC autosampler.",
			Headers -> {"Injection Plate to Place", "Placement Tree"},
			Category -> "Placements",
			Developer -> True
		},
		InjectionPlatePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP | SamplePreparationP,
			Description -> "A set of instructions specifying the transfers of blanks into the injection plate used to house sample for calorimetry measurement.",
			Category -> "General",
			Developer -> True
		},
		InjectionPlateManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, SampleManipulation] | Object[Protocol, RoboticSamplePreparation] | Object[Protocol, ManualSamplePreparation] | Object[Notebook, Script],
			Description -> "A sample manipulation protocol used to transfer blanks into the injection plate used to house sample for calorimetry measurement.",
			Category -> "General"
		},
		MethodFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path of the file necessary for the instrument to load its method file and execute this protocol.",
			Category -> "General",
			Developer -> True
		},
		DataFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path of the file used to copy the data onto the network drive.",
			Category -> "General",
			Developer -> True
		},
		InjectionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume of sample that is injected into the DSC instrument for each sample.",
			Category -> "Thermocycling"
		},
		InjectionRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter / Second],
			Units -> Microliter / Second,
			Description -> "The rate at which the sample is injected into the DSC instrument.",
			Category -> "Thermocycling"
		},
		StartTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			IndexMatching -> PooledSamplesIn,
			Description -> "For each member of PooledSamplesIn, the temperature at which the sample is held prior to heating.",
			Category -> "Thermocycling"
		},
		EndTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			IndexMatching -> PooledSamplesIn,
			Description -> "For each member of PooledSamplesIn, the temperature to which the sample is heated in the course of the experiment.",
			Category -> "Thermocycling"
		},
		TemperatureRampRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Celsius / Hour],
			Units -> Celsius / Hour,
			IndexMatching -> PooledSamplesIn,
			Description -> "For each member of PooledSamplesIn, the rate at which the temperature is increased in the course of one heating cycle.",
			Category -> "Thermocycling"
		},
		NumberOfScans -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			IndexMatching -> PooledSamplesIn,
			Description -> "For each member of PooledSamplesIn, the number of heating cycles to apply to the given sample.",
			Category -> "Thermocycling"
		},
		RescanCoolingRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Celsius / Hour],
			Units -> Celsius / Hour,
			IndexMatching -> PooledSamplesIn,
			Description -> "For each member of PooledSamplesIn, the rate at which the temperature decresases from EndTemperature to StartTemperature between scans.",
			Category -> "Thermocycling"
		},
		Blanks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "For each member of PooledSamplesIn, the model or sample used to generate a blank sample whose heating profile will be subtract as background from the calorimetry measurements of the samples.",
			Category -> "General",
			IndexMatching -> PooledSamplesIn
		},
		CleaningFrequency -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> None|First|_Integer,
			Description -> "Indicates the frequency at which the sample chamber is washed with detergent between the injections of the samples (with a value of 2 indicating cleaning after every 2 samples).",
			Category -> "Cleaning"
		},
		RunTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The length of time for which the instrument is run.",
			Category -> "Thermocycling"
		},
		RefillSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Developer -> True,
			Description -> "The model or sample used to refill the instrument during the running of the experiment.",
			Category -> "Thermocycling"
		},
		CleaningSolutions->{
			Format->Single,
			Class->{Link,Link,Link},
			Pattern:>{_Link,_Link,_Link},
			Relation->{Alternatives[Model[Sample],Object[Sample]],Alternatives[Model[Sample],Object[Sample]],Alternatives[Model[Sample],Object[Sample]]},
			Description->"Detergent solutions used to wash the flow cell during the running of the experiment.",
			Headers->{"No Detergent","Low Concentration Detergent","High Concentration Detergent"},
			Category->"Cleaning",
			Developer->True
		},
		CleaningBottleCaps->{
			Format->Single,
			Class->{Link,Link,Link},
			Pattern:>{_Link,_Link,_Link},
			Relation->{Alternatives[Model[Item,Cap],Object[Item,Cap]],Alternatives[Model[Item,Cap],Object[Item,Cap]],Alternatives[Model[Item,Cap],Object[Item,Cap]]},
			Description->"Caps to cover the cleaning solutions during the experiment.",
			Headers->{"No Detergent","Low Concentration Detergent","High Concentration Detergent"},
			Category->"Cleaning",
			Developer->True
		},
		CleaningSolutionPlacements->{
			Format->Multiple,
			Class->{Link,Expression},
			Pattern:>{_Link,{LocationPositionP..}},
			Relation->{Object[Container],Null},
			Description->"A list of placements used to move the wash solutions onto the cleaning deck.",
			Headers->{"Cleaning Solution Container","Placement Tree"},
			Category->"Placements",
			Developer->True
		}
	}
}];
