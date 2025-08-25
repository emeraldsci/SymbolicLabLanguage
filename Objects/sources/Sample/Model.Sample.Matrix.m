(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab,Inc.*)

(* NOTE: If you're doing this, make sure that any files that use these $ shared fields are loaded AFTER this file, otherwise *)
(* you will get load errors. The Packager loads files from the UnitOperation/ folder alphabetically. *)
$ModelSampleStockSolutionSharedFields={
	Formula->{
		Format->Multiple,
		Class->{VariableUnit, Link},
		Pattern:>{GreaterP[0 Milliliter] | GreaterP[0 Gram]| GreaterP[0], _Link},
		Relation->{Null, Alternatives[Model[Sample],Object[Sample]]},
		Units->{None, None},
		Description->"Describes the desired final concentrations or amounts of each component of this solution.",
		Headers-> {"Amount","Component"},
		Category->"Formula",
		Abstract->True
	},
	FillToVolumeSolvent-> {
		Format->Single,
		Class->Link,
		Pattern:>_Link,
		Relation->Model[Sample],
		Description->"The solvent to use to dilute the components up to the requested TotalVolume.",
		Category->"Formula",
		Abstract->True
	},
	SolventVolume->{
		Format->Single,
		Class->Real,
		Pattern:>GreaterP[0 Liter],
		Units->Liter,
		Description->"The amount of solvent that when added to the formula components will produce a sample with TotalVolume. Will only be used if FillToVolumeParameterized is True.",
		Category->"Formula",
		Developer->True
	},
	TotalVolume-> {
		Format->Single,
		Class->Real,
		Pattern:>GreaterP[0 Liter],
		Units->Liter,
		Description->"The total volume of this solution as specified by the Formula, where Solvent is used to fill any remaining volume.",
		Category->"Formula",
		Abstract->True
	},
	FillToVolumeMethod->{
		Format->Single,
		Class->Expression,
		Pattern:>FillToVolumeMethodP,
		Description->"The method by which to add the Solvent to the bring the stock solution up to the TotalVolume.",
		Category->"Formula",
		Abstract->True
	},
	PrepareSterile-> {
		Format->Single,
		Class->Boolean,
		Pattern:>BooleanP,
		Description->"Indicates if this model sample is made free of both microbial contamination and any microbial cell samples by employing aseptic techniques. Aseptic techniques include sanitization, autoclaving, sterile filtration, mixing exclusively sterile components, and transferring in a biosafety cabinet during experimentation and storage.",
		Category->"Sample Preparation"
	},
	OrderOfOperations->{
		Format->Multiple,
		Class->Expression,
		Pattern:>Alternatives[FixedReagentAddition, FillToVolume, pHTitration, Incubation, Filtration,
			Autoclave, FixedHeatSensitiveReagentAddition, PostAutoclaveIncubation],
		Description->"The order in which the stock solution should be created. By default, the order is {FixedReagentAddition, Incubation, FillToVolume, pHTitration, Filtration}.",
		Category->"Formula"
	},
	UnitOperations->{
		Format->Multiple,
		Class->Expression,
		Pattern:>ManualSamplePreparationP,
		Description->"The sample preparation primitives to prepare this stock solution when a non-standard preparation is required.",
		Category->"Formula"
	},
	PreparationType->{
		Format->Single,
		Class->Expression,
		Pattern:>Alternatives[Formula,UnitOperations,SupplierPrepared],
		Description->"The method by which this stock solution model is defined.",
		Category->"Formula"
	},
	HeatSensitiveReagents->{
		Format->Multiple,
		Class->Link,
		Pattern:>_Link,
		Relation->Model[Sample],
		Description->"Components of this stock solution that are heat sensitive and should be added after autoclave.",
		Category->"Formula"
	},
	(* --- Incubating --- *)
	IncubationTime->{
		Format->Single,
		Class->Real,
		Pattern:>GreaterP[0*Minute],
		Units->Minute,
		Description-> "The duration for which the stock solution is incubated following component combination, filling to volume with solvent, and mixing.",
		Category->"Incubation",
		Abstract->True
	},
	IncubationTemperature->{
		Format->Single,
		Class->Real,
		Pattern:>GreaterP[0*Kelvin],
		Units->Celsius,
		Description-> "The temperature at which the stock solution is incubated following component combination, filling to volume with solvent, and mixing.",
		Category->"Incubation",
		Abstract->True
	},
	(* --- Incubating --- *)
	PostAutoclaveIncubationTime->{
		Format->Single,
		Class->Real,
		Pattern:>GreaterP[0*Minute],
		Units->Minute,
		Description-> "The duration for which the stock solution is incubated following autoclave and addition of heat sensitive reagents.",
		Category->"Incubation",
		Abstract->True
	},
	PostAutoclaveIncubationTemperature->{
		Format->Single,
		Class->Real,
		Pattern:>GreaterP[0*Kelvin],
		Units->Celsius,
		Description-> "The temperature at which the stock solution is incubated following autoclave and addition of heat sensitive reagents.",
		Category->"Incubation",
		Abstract->True
	},
	(* --- Mixing --- *)
	MixUntilDissolved->{
		Format->Single,
		Class->Boolean,
		Pattern:>BooleanP,
		Description->"Indicates if the stock solution is mixed in an attempt to completed dissolve any solid components following component combination and filling to volume with solvent.",
		Category->"Mixing"
	},
	MixTime->{
		Format->Single,
		Class->Real,
		Pattern:>GreaterP[0*Minute],
		Units->Minute,
		Description-> "The duration for which the stock solution is mixed following component combination and filling to volume with solvent.",
		Category->"Mixing",
		Abstract->True
	},
	MaxMixTime->{
		Format->Single,
		Class->Real,
		Pattern:>GreaterP[0*Minute],
		Units->Minute,
		Description->"The maximum duration for which the stock solution is mixed in an attempt to dissolve any solid components following component combination and filling to volume with solvent.",
		Category->"Mixing"
	},
	MixType->{
		Format->Single,
		Class->Expression,
		Pattern:>MixTypeP,
		Description->"The style of motion used to mix the stock solution following component combination and filling to volume with solvent.",
		Category->"Mixing",
		Abstract->True
	},
	Mixer->{
		Format->Single,
		Class->Link,
		Pattern:>_Link,
		Relation->Alternatives[
			Model[Instrument,Vortex],
			Model[Instrument,Shaker],
			Model[Instrument,BottleRoller],
			Model[Instrument,Sonicator],
			Model[Instrument, Roller],
			Model[Instrument, OverheadStirrer]
		],
		Description->"The instrument used to mix the stock solution following component combination and filling to volume with solvent.",
		Category->"Mixing"
	},
	MixRate->{
		Format->Single,
		Class->Real,
		Pattern:>GreaterP[0*RPM],
		Units->RPM,
		Description->"The frequency of rotation the mixing instrument uses to mix the stock solution following component combination and filling to volume with solvent. When the MixType is set to Stir, the mix rate may be adjusted to match the container's MaxOverheadMixRate in order to prevent overflow or spillage.",
		Category->"Mixing"
	},
	NumberOfMixes->{
		Format->Single,
		Class->Integer,
		Pattern:>GreaterP[0],
		Units->None,
		Description->"The number of times the stock solution is mixed by inversion or pipetting up and down following component combination and filling to volume with solvent.",
		Category->"Mixing"
	},
	MaxNumberOfMixes->{
		Format->Single,
		Class->Integer,
		Pattern:>GreaterP[0],
		Units->None,
		Description->"The maximum number of times the stock solution is mixed in an attempt to dissolve any solid components following component combination and filling to volume with solvent.",
		Category->"Mixing"
	},
	VisiblePrecipitate->{
		Format->Single,
		Class->Boolean,
		Pattern:>BooleanP,
		Description->"Indicates if this is an over saturated solution and some leftover solids are expected to be visible in the solution following component combination, filling to volume with solvent, and/or mixing.",
		Category->"Mixing"
	},
	PostAutoclaveMixUntilDissolved->{
		Format->Single,
		Class->Boolean,
		Pattern:>BooleanP,
		Description->"Indicates if the stock solution is mixed in an attempt to completed dissolve any solid components following autoclave and addition of heat sensitive reagents.",
		Category->"Mixing"
	},
	PostAutoclaveMixTime->{
		Format->Single,
		Class->Real,
		Pattern:>GreaterP[0*Minute],
		Units->Minute,
		Description-> "The duration for which the stock solution is mixed following autoclave and addition of heat sensitive reagents.",
		Category->"Mixing",
		Abstract->True
	},
	PostAutoclaveMaxMixTime->{
		Format->Single,
		Class->Real,
		Pattern:>GreaterP[0*Minute],
		Units->Minute,
		Description->"The maximum duration for which the stock solution is mixed in an attempt to dissolve any solid components following autoclave and addition of heat sensitive reagents.",
		Category->"Mixing"
	},
	PostAutoclaveMixType->{
		Format->Single,
		Class->Expression,
		Pattern:>MixTypeP,
		Description->"The style of motion used to mix the stock solution following autoclave and addition of heat sensitive reagents.",
		Category->"Mixing",
		Abstract->True
	},
	PostAutoclaveMixer->{
		Format->Single,
		Class->Link,
		Pattern:>_Link,
		Relation->Alternatives[
			Model[Instrument,Vortex],
			Model[Instrument,Shaker],
			Model[Instrument,BottleRoller],
			Model[Instrument,Sonicator],
			Model[Instrument, Roller],
			Model[Instrument, OverheadStirrer]
		],
		Description->"The instrument used to mix the stock solution following autoclave and addition of heat sensitive reagents.",
		Category->"Mixing"
	},
	PostAutoclaveMixRate->{
		Format->Single,
		Class->Real,
		Pattern:>GreaterP[0*RPM],
		Units->RPM,
		Description->"The frequency of rotation the mixing instrument uses to mix the stock solution following autoclave and addition of heat sensitive reagents.",
		Category->"Mixing"
	},
	PostAutoclaveNumberOfMixes->{
		Format->Single,
		Class->Integer,
		Pattern:>GreaterP[0],
		Units->None,
		Description->"The number of times the stock solution is mixed by inversion or pipetting up and down following autoclave and addition of heat sensitive reagents.",
		Category->"Mixing"
	},
	PostAutoclaveMaxNumberOfMixes->{
		Format->Single,
		Class->Integer,
		Pattern:>GreaterP[0],
		Units->None,
		Description->"The maximum number of times the stock solution is mixed in an attempt to dissolve any solid components following autoclave and addition of heat sensitive reagents.",
		Category->"Mixing"
	},
	(* --- pH Titration --- *)
	NominalpH->{
		Format->Single,
		Class->Real,
		Pattern:>RangeP[0, 14],
		Units->None,
		Description->"The pH to which this stock solution is adjusted after component combination, filling to volume with solvent, and/or mixing.",
		Category->"pH Titration",
		Abstract->True
	},
	MinpH->{
		Format->Single,
		Class->Real,
		Pattern:>RangeP[0, 14],
		Units->None,
		Description->"The minimum allowable pH this stock solution has after pH adjustment, where pH adjustment occurs following component combination, filling to volume with solvent and/or mixing.",
		Category->"pH Titration"
	},
	MaxpH->{
		Format->Single,
		Class->Real,
		Pattern:>RangeP[0, 14],
		Units->None,
		Description->"The maximum allowable pH this stock solution has after pH adjustment, where pH adjustment occurs following component combination, filling to volume with solvent, and/or mixing.",
		Category->"pH Titration"
	},
	pHingAcid->{
		Format->Single,
		Class->Link,
		Pattern:>_Link,
		Relation->Model[Sample],
		Description->"The acid that is used to adjust the pH of the solution downwards following component combination, filling to volume with solvent, and/or mixing.",
		Category->"pH Titration"
	},
	pHingBase->{
		Format->Single,
		Class->Link,
		Pattern:>_Link,
		Relation->Model[Sample],
		Description->"The base that is used to adjust the pH of the solution upwards following component combination, filling to volume with solvent, and/or mixing.",
		Category->"pH Titration"
	},
	MaxNumberOfpHingCycles->{
		Format->Single,
		Class->Integer,
		Pattern:>GreaterEqualP[0, 1],
		Units->None,
		Description->"The maximum number of additions to make before stopping pH titrations.",
		Category->"pHing Limits"
	},
	MaxpHingAdditionVolume->{
		Format->Single,
		Class->Real,
		Pattern:>GreaterP[0*Milliliter],
		Units->Milliliter,
		Description->"The largest volume of pHingAcid and pHingBase that can be added during pHing.",
		Category->"pHing Limits"
	},
	MaxAcidAmountPerCycle->{
		Format->Single,
		Class->VariableUnit,
		Pattern:>Alternatives[GreaterEqualP[0 * Liter],GreaterEqualP[0 * MilliGram]],
		Description->"The largest amount of TitrationAcid that can be added to in each pH titration cycle.",
		Category->"pHing Limits"
	},
	MaxBaseAmountPerCycle->{
		Format->Single,
		Class->VariableUnit,
		Pattern:>Alternatives[GreaterEqualP[0 * Liter],GreaterEqualP[0 * MilliGram]],
		Description->"The largest amount of TitrationBase that can be added to in each pH titration cycle.",
		Category->"pHing Limits"
	},
	(* --- Filtration ---  *)
	FilterMaterial->{
		Format->Single,
		Class->Expression,
		Pattern:>FilterMembraneMaterialP,
		Description->"The material through which the stock solution is filtered following component combination, filling to volume with solvent, mixing, and/or pH titration.",
		Category->"Filtration",
		Abstract->True
	},
	FilterSize->{
		Format->Single,
		Class->Real,
		Pattern:>FilterSizeP,
		Units->Micron,
		Description->"The size of the membrane pores through which the stock solution is filtered following component combination, filling to volume with solvent, mixing, and/or pH titration.",
		Category->"Filtration",
		Abstract->True
	},
	(* --- FillToVolume --- *)
	FillToVolumeParameterized->{
		Format->Single,
		Class->Boolean,
		Pattern:>BooleanP,
		Description->"Indicates if the fill to volume of the solvent component of this solution will be done using a single transfer of a volume calculated using the mean of the fill to volume ratios.",
		Category->"Fill to Volume",
		Developer->True
	},
	FillToVolumeParameterization->{
		Format->Multiple,
		Class->Link,
		Pattern:>_Link,
		Relation->Object[Protocol,StockSolution],
		Description->"A list of protocols used to obtain the fill to volume ratios for this model of stock solution.",
		Category->"Fill to Volume",
		Developer->True
	},
	FillToVolumeExampleData->{
		Format->Multiple,
		Class->{Real, Real},
		Pattern:>{GreaterP[0 Milliliter],GreaterP[0 Milliliter]},
		Units->{Milliliter, Milliliter},
		Description->"For each member of FillToVolumeParameterization, the volume of the solvent added and the total volume of the solution prepared.",
		Headers-> {"Solvent Volume", "Total Volume"},
		Category->"Fill to Volume",
		IndexMatching->FillToVolumeParameterization,
		Developer->True
	},
	FillToVolumeRatios->{
		Format->Multiple,
		Class->Real,
		Pattern:>GreaterP[0],
		Description->"For each member of FillToVolumeParameterization, the ratio between the volume of solvent and total volume of solution.",
		Category->"Fill to Volume",
		IndexMatching->FillToVolumeParameterization,
		Developer->True
	},
	FillToVolumeDistribution->{
		Format->Single,
		Class->Expression,
		Pattern:>DistributionP[],
		Description->"Distribution and standard deviation of the fill to volume ratios.",
		Category->"Fill to Volume",
		Developer->True
	},
	Autoclave->{
		Format->Single,
		Class->Boolean,
		Pattern:>BooleanP,
		Description->"Indicates that this model of stock solution should be autoclaved once all components are added.",
		Category->"Autoclaving"
	},
	AutoclaveProgram-> {
		Format->Single,
		Class->Expression,
		Pattern:>AutoclaveProgramP,
		Description->"Indicates the type of autoclave cycle to run.",
		Category->"Autoclaving"
	},
	MixtureNFPA->{
		Format->Computable,
		Expression:>SafeEvaluate[{Field[NFPA], Field[Composition]}, Computables`Private`mixtureNFPAComputable[Field[NFPA], Field[Composition]]],
		Pattern:>NFPAP,
		Description->"The calculated NFPA of the stock solution based on its components, or the explicitly defined NFPA if provided.",
		Category->"Health & Safety"
	},
	ComponentsMSDSFiles->{
		Format->Computable,
		Expression:>SafeEvaluate[{Field[Formula], Field[Composition]}, Computables`Private`componentsMSDSComputable[Field[Formula],Field[Composition]]],
		Pattern:>{PDFFileP..},
		Description->"EmeraldCloudFiles of the MSDS .pdf files for the components of this stock solution.",
		Category->"Health & Safety"
	},
	CentrifugeIncompatible->{
		Format->Single,
		Class->Boolean,
		Pattern:>BooleanP,
		Description->"Indicates if centrifugation of this model should be avoided. If Null or False, samples of this model will be centrifuged when requested and when experimentally appropriate.",
		Category->"Compatibility"
	},
	VolumeIncrements->{
		Format->Multiple,
		Class->Real,
		Pattern:>GreaterP[0*Liter],
		Units->Liter Milli,
		Description->"The volume increments at which this stock solution must be generated due to certain components only being available in fixed amounts.  If this field is populated, stock solutions may only be made at the volumes populated and no others.",
		Category->"Operating Limits"
	},
	PreferredContainers->{
		Format->Multiple,
		Class->Link,
		Pattern:>_Link,
		Relation->Model[Container, Vessel],
		Description->"The list of containers that should be chosen first, if possible, when choosing a container to store the sample in.",
		Category->"Storage Information"
	},
	DiscardThreshold -> {
		Format -> Single,
		Class -> Real,
		Pattern :> RangeP[0 Percent, 100 Percent],
		Units -> Percent,
		Description -> "The percent of the total initial volume of samples of this stock solution below which the stock solution will automatically marked as AwaitingDisposal.  For instance, if DiscardThreshold is set to 5% and the initial volume of the stock solution was set to 100 mL, that stock solution sample is automatically marked as AwaitingDisposal once its volume is below 5mL.",
		Category -> "Storage Information"
	},
	(* Inventory information *)
	Inventories->{
		Format->Multiple,
		Class->Link,
		Pattern:>_Link,
		Relation->Object[Inventory][StockedInventory],
		Description->"The inventory objects responsible for keeping this media in stock.",
		Category->"Inventory"
	},
	(* Pricing information *)
	Price->{
		Format->Single,
		Class->VariableUnit,
		Pattern:>Alternatives[GreaterEqualP[0*USD / Liter],GreaterEqualP[0*USD / Gram]],
		Description->"The baseline cost of this media when ECL generates it in advance and it is subsequently purchased.",
		Category->"Pricing Information",
		Developer->True
	}
};

With[
	{insertMe=Sequence@@$ModelSampleStockSolutionSharedFields},DefineObjectType[Model[Sample, Matrix], {
		Description->"Model information for a stock solution of chemicals specifically prepared for use as a matrix in MassSpectrometry.",
		CreatePrivileges->None,
		Cache->Session,
		Fields -> {
			ReferenceMassSpectra -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data],
				Description -> "Reference mass spectrometry data for this matrix.",
				Category -> "Experimental Results"
			},
			PreferredSpottingMethod -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> SpottingMethodP,
				Description -> "The preferred spotting method to use with this matrix.",
				Category -> "General",
				Abstract -> True
			},
			SpottingDryTime -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Second],
				Units -> Second,
				Description -> "The amount of time the matrix should be left to dry on the plate after spotting.",
				Category -> "General"
			},
			SpottingVolume -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The volume of matrix which should be spotted onto the plate in each layer.",
				Category -> "General"
			},
			DispenseHeight -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0 Millimeter],
				Units -> Millimeter,
				Description -> "The height above the MALDI plate from which matrix should be dispensed.",
				Category -> "General"
			},
			AlternativePreparations->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample, Matrix][AlternativePreparations],
				Description->"Stock solution models that have the same formula components and component ratios as this stock solution. These alternative stock solutions may have different preparatory methods.",
				Category->"Formula"
			},

			insertMe
		}
	}];
];