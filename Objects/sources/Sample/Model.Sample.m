(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Sample], {
	Description->"Model information for a reagent used in an experiment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		(* --- Organizational Information --- *)
		Name->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The name of the model, to uniquely identify it in Constellation.",
			Category->"Organizational Information",
			Abstract->True
		},
		Synonyms->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"A list of alternative names for this sample model.",
			Category->"Organizational Information",
			Abstract->True
		},
		Analytes->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->IdentityModelTypeP,
			Description->"The molecular entities of primary interest in this sample model.",
			Category->"Organizational Information",
			Abstract->True
		},
		Composition->{
			Format->Multiple,
			Class->{VariableUnit,Link},
			Pattern:>{
				CompositionP,
				_Link
			},
			Relation->{
				Null,
				IdentityModelTypeP
			},
			Headers->{
				"Amount",
				"Identity Model"
			},
			Description->"The various components that constitute this sample model, along with their respective concentrations.",
			Category->"Organizational Information",
			Abstract->True
		},
		OpticalComposition->{
			Format->Multiple,
			Class->{Real, Link},
			Units->{Percent,None},
			Pattern:>{
				RangeP[-100Percent,100Percent],
				_Link
			},
			Relation->{
				Null,
				IdentityModelTypeP
			},
			Headers->{
				"Amount",
				"Identity Model"
			},
			Description->"If this sample contains chiral component(s), the relative amounts of each of the two enantiomers, in percent, for each chiral substance.",
			Category->"Organizational Information"
		},
		Media->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample],
			Description->"The base cell growth solution of this sample model.",
			Category->"Organizational Information"
		},
		UsedAsMedia->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model are typically used as a cell growth medium.",
			Category->"Organizational Information"
		},
		Living -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if there is living material in this sample.",
			Category -> "Organizational Information"
		},
		Solvent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample],
			Description->"The base component of this sample model that contains, dissolves and disperses the other components.",
			Category->"Organizational Information"
		},
		UsedAsSolvent->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model are typically used to dissolve other substances.",
			Category->"Organizational Information",
			Abstract->True
		},
		(* Only filled out if given by the user or can be determined from the products *)
		Authors->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[User],
			Description->"The people who created this model.",
			Category->"Organizational Information"
		},
		Deprecated->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates that this model is historical and no longer used in the ECL.",
			Category->"Organizational Information",
			Abstract->True
		},
		Grade->{
			Format->Single,
			Class->Expression,
			Pattern:>GradeP, (* Anhydrous | Biosynthesis | Reagent | Ultrapure | RO | ACS | USP | BioUltra | ... *)
			Description->"The purity standard of this sample model.",
			Category->"Organizational Information",
			Abstract->True
		},
		AlternativeForms->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample][AlternativeForms],
			Description->"Other sample models representing variations of the same substance with different grades, hydration states, monobasic/dibasic forms, etc.",
			Category->"Organizational Information",
			Abstract->False
		},
		UNII->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The Unique Ingredient Identifier of this substance based on the unified identification scheme of FDA.",
			Category->"Organizational Information",
			Abstract->True
		},
		Tags->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"Labels that are used for the management and organization of samples. If an aliquot is taken out of this sample, the new sample that is generated will inherit this sample's tags.",
			Category->"Organizational Information",
			Abstract->True
		},
		DeveloperObject->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category->"Organizational Information",
			Developer->True
		},
		Verified -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the information in this model has been reviewed for accuracy by an ECL employee.",
			Category -> "Organizational Information"
		},
		VerifiedLog -> {
			Format -> Multiple,
			Class -> {Boolean, Link, Date},
			Pattern :> {BooleanP, _Link, _?DateObjectQ},
			Relation -> {Null, Object[User], Null},
			Headers -> {"Verified", "Responsible person", "Date"},
			Description -> "Records the history of changes to the Verified field, along with when the change occured, and the person responsible.",
			Category -> "Organizational Information"
		},

		(* --- Physical Properties --- *)
		BoilingPoint->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Units->Celsius,
			Description->"The temperature at which bulk sample of this model transitions from condensed phase to gas at atmospheric pressure. This occurs when the vapor pressure of the sample equals atmospheric pressure.",
			Category->"Physical Properties",
			Abstract->False
		},
		MeltingPoint->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Units->Celsius,
			Description->"The temperature at which samples of this model transition from solid to liquid at atmospheric pressure.",
			Category->"Physical Properties",
			Abstract->False
		},
		VaporPressure->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Kilo*Pascal],
			Units->Kilo Pascal,
			Description->"The pressure of the vapor in thermodynamic equilibrium with condensed phase for samples of this model in a closed system at room temperature.",
			Category->"Physical Properties",
			Abstract->False
		},
		CellType->{
			Format->Single,
			Class->Expression,
			Pattern:>CellTypeP,
			Description->"The taxon of the organism or cell line from which the cell sample originates.",
			Category->"Physical Properties"
		},
		CultureAdhesion->{
			Format->Single,
			Class->Expression,
			Pattern:>CultureAdhesionP,
			Description->"The default type of cell culture (adherent or suspension) that should be performed when growing any cells in this model. If a cell line can be cultured via an adherent or suspension culture, this is set to the most common cell culture type for the cell line.",
			Category->"Physical Properties"
		},
		Conductivity->{
			Format->Single,
			Class->Expression,
			Pattern:>DistributionP[Micro Siemens/Centimeter],
			Description->"The degree to which samples of this model facilitate the flow of electric charge.",
			Category->"Physical Properties",
			Abstract->False
		},
		Density->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[(0*Gram)/Liter Milli],
			Units->Gram/(Liter Milli),
			Description->"The mass of sample per amount of volume for a pure sample of this model at room temperature and pressure.",
			Category->"Physical Properties",
			Abstract->False
		},
		ExtinctionCoefficients->{
			Format->Multiple,
			Class->{Wavelength->VariableUnit, ExtinctionCoefficient->VariableUnit},
			Pattern:>{Wavelength->GreaterP[0*Nanometer], ExtinctionCoefficient->(GreaterP[0 Liter/(Centimeter*Mole)] | GreaterP[0 Milli Liter /(Milli Gram * Centimeter)])},
			Description->"A measure of how strongly samples of this model absorb light at a particular wavelength in aqueous solution at ambient temperature and pressure.",
			Category->"Physical Properties"
		},
		Fiber->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model consist of a thin cylindrical string of solid substance.",
			Category->"Physical Properties"
		},
		FiberCircumference->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Millimeter],
			Units->Millimeter,
			Description->"If samples of this model come in fiber form, the length of the perimeter of the circular cross-section of the sample.",
			Category->"Physical Properties"
		},
		NominalParticleSize->{
			Format->Single,
			Class->Distribution,
			Pattern:>DistributionP[Nanometer],
			Units->Nanometer,
			Description -> "If containing or composed of discrete fragments of solid, such as a powder or suspension, the manufacturer stated distribution of particle dimensions in the sample model.",
			Category->"Physical Properties"
		},
		ParticleWeight->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Gram],
			Units->Gram,
			Description->"If containing or composed of discrete fragments of solid, such as a powder or suspension, the average weight of a single fragment of the sample.",
			Category->"Physical Properties",
			Abstract->False
		},
		pKa->{
			Format->Multiple,
			Class->Real,
			Pattern:>NumericP,
			Units->None,
			Description->"The logarithmic acid dissociation constants of the substance at room temperature in water.",
			Category->"Physical Properties",
			Abstract->False
		},
		pH->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0,14],
			Units->None,
			Description->"The logarithmic concentration of hydrogen ions of samples of this model at room temperature.",
			Category->"Physical Properties",
			Abstract->False
		},
		pHTemperatureFitAnalysis->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis, Fit],
			Description->"A fit analysis describing the expected pH of this sample at specified temperatures. Generated from the pH temperature dependence table in the sample's manufacturer specification.",
			Category->"Physical Properties",
			Abstract->False
		},
		RefractiveIndex->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[1],
			Units->None,
			Description->"The ratio of the speed of light in a vacuum to the speed of light travelling through samples of this model at 20 degree Celsius.",
			Category->"Physical Properties",
			Abstract->False
		},
		SingleUse->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model must be used only once and then disposed of after use.",
			Category->"Physical Properties"
		},
		State->{
			Format->Single,
			Class->Expression,
			Pattern:>ModelStateP,
			Description->"The physical state of samples of this model when well solvated at room temperature and pressure.",
			Category->"Physical Properties"
		},
		SurfaceTension->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Milli Newton/Meter],
			Units->Milli Newton/Meter,
			Description->"The ability of the surface of samples of this model to resist breaking when disrupted by an external force. Surface tension arises from the tendency of the constituent molecules to stick together and minimize the liquid's surface area.",
			Category->"Physical Properties",
			Abstract->False
		},
		Tablet->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this sample model is composed of small disks of compressed solid substance.",
			Category->"Physical Properties"
		},
		Capsule ->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this model is in the form of a small cylinder that can be opened containing solid substance in a measured amount.",
			Category->"Physical Properties"
		},
		SolidUnitWeight->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Gram],
			Units->Gram,
			Description->"If samples of this model come in tablet or sachet form, the average mass of sample in a single tablet or sachet.",
			Category->"Physical Properties"
		},
		SolidUnitWeightDistribution->{
			Format->Single,
			Class->Expression,
			Pattern:>DistributionP[Gram],
			Description-> "If samples of this model come in tablet or sachet form, the range of masses of sample in a single tablet or sachet.",
			Category->"Physical Properties"
		},
		Sachet->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this sample model is in the form of a small pouch filled with a measured amount of loose solid substance.",
			Category->"Physical Properties"
		},
		DefaultSachetPouch -> {
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Material],
			Description->"If samples of this model come in sachet form, the material that the enclosing pouch is made from.",
			Category->"Physical Properties"
		},
		Viscosity->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Pascal*Second],
			Units->Pascal Second,
			Description->"The dynamic viscosity of samples of this model at room temperature and pressure, indicating how resistant it is to flow when an external force is applied.",
			Category->"Physical Properties",
			Abstract->False
		},
		MiscibleLiquids -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Molecule][MiscibleLiquids], Model[Sample][MiscibleLiquids]],
			Description -> "Solvent or solvent mixtures with which this sample is able to mix with and form a homogenous solution regardless of the ratio.",
			Category -> "Physical Properties"
		},
		LD50 -> {
			Format -> Multiple,
			Class -> {Real, Expression, Expression},
			Pattern :> {GreaterP[0], AnimalP, DosageRouteP},
			Description -> "The dose for which a half the members of a given population dies. Dose is recorded as a unitless value but corresponds to dosage mass per animal mass.",
			Category -> "Health & Safety",
			Headers -> {"Dose", "Animal", "Route"}
		},

		(* --- Sample History --- *)
		Protocols->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Protocol][SamplesIn],
				Object[Protocol,DynamicFoamAnalysis][AdditiveSamplesIn]
			],
			Description->"Experiments currently requesting sample(s) of this model as their primary input but did not specify particular samples to use.",
			Category->"Sample History"
		},

		(* --- Storage & Handling --- *)
		DefaultStorageCondition->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[StorageCondition],
			Description->"The typical environment in which samples of this model should be stored when not in use by an experiment. Default conditions may be overridden individually for any given sample.",
			Category->"Storage & Handling"
		},
		StoragePositions->{
			Format->Multiple,
			Class->{Link, String},
			Pattern:>{_Link, LocationPositionP},
			Relation->{Object[Container]|Object[Instrument], Null},
			Description->"The specific containers and positions in which samples of this model should typically be stored, allowing more granular organization within storage locations that satisfy default storage condition.",
			Category->"Storage & Handling",
			Headers->{"Storage Container", "Storage Position"},
			Developer->True
		},
		AutoclaveUnsafe->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model are unstable and can potentially degrade under extreme heating conditions.",
			Category->"Storage & Handling",
			Abstract->True
		},
		PreferredWashBin->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Container,WashBin],
			Description->"The recommended bin for samples of this model prior to dishwashing.",
			Category->"Storage & Handling"
		},
		Waste->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model are a collection of other samples that are to be thrown out.",
			Category->"Storage & Handling"
		},
		WasteType->{
			Format->Single,
			Class->Expression,
			Pattern:>WasteTypeP,
			Description->"Indicates the type of waste collected in this sample model.",
			Category->"Storage & Handling"
		},
		Expires->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model have a finite lifespan and become unsuitable for use after a given amount of time.",
			Category->"Storage & Handling",
			Abstract->True
		},
		ShelfLife->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Day],
			Units->Day,
			Description->"The length of time after their creation date (DateCreated) that samples of this model are recommended for use, before being considered expired.",
			Category->"Storage & Handling",
			Abstract->True
		},
		UnsealedShelfLife->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Day],
			Units->Day,
			Description->"The length of time after first being uncovered (DateUnsealed) that samples of this model are recommended for use before being considered expired.",
			Category->"Storage & Handling",
			Abstract->True
		},
		LightSensitive->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model react or degrade in the presence of light and requires storage in the dark.",
			Category->"Storage & Handling"
		},
		SampleHandling->{
			Format->Single,
			Class->Expression,
			Pattern:>SampleHandlingP,
			Description->"The method by which samples of this model should be manipulated in the lab when transfers out of the sample are requested.",
			Category->"Storage & Handling"
		},
		AsepticHandling -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if special techniques should be used to prevent contamination by microorganisms when handling samples of this model. Aseptic techniques include sanitization, autoclaving, sterile filtration, mixing exclusively sterile components, and transferring in a biosafety cabinet during experimentation and storage.",
			Category -> "Storage & Handling"
		},
		TransportCondition->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[TransportCondition],
			Description->"The environment in which samples of this model should be transported when in use by an experiment, if different from ambient conditions.",
			Category->"Storage & Handling"
		},
		TransferTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Units->Celsius,
			Description->"The temperature at which samples of this model should be heated or cooled to when moved around the lab during experimentation, if different from ambient temperature.",
			Category->"Storage & Handling"
		},
		ThawTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Units->Celsius,
			Description->"The typical temperature that samples of this model should be defrosted at before using in experimentation.",
			Category->"Storage & Handling"
		},
		ThawTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Second],
			Units->Minute,
			Description->"The typical time that samples of this model should be defrosted before using in experimentation. If the samples are still not thawed after this time, thawing will continue until the samples are fully thawed.",
			Category->"Storage & Handling"
		},
		MaxThawTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Second],
			Units->Minute,
			Description->"The default maximum time that samples of this model should be defrosted before using in experimentation.",
			Category->"Storage & Handling"
		},
		ThawMixType->{
			Format->Single,
			Class->Expression,
			Pattern:>MixTypeP,
			Description->"The default style of motion used to homogenize samples of this model following defrosting.",
			Category->"Storage & Handling"
		},
		ThawMixRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*RPM],
			Units->RPM,
			Description->"The default frequency of rotation the default instrument uses to homogenize samples of this model following thawing.",
			Category->"Storage & Handling"
		},
		ThawMixTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Minute],
			Units->Minute,
			Description-> "The default duration for which samples of this model are homogenized following thawing.",
			Category->"Storage & Handling",
			Abstract->True
		},
		ThawNumberOfMixes->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0, 1],
			Units->None,
			Description->"The default number of times samples of this model are homogenized by inversion or pipetting up and down following defrosting.",
			Category->"Storage & Handling"
		},
		ThawCellsMethod->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method, ThawCells],
			Description->"The default method object containing the parameters to use to bring cryovials containing this sample model up to ambient temperature.",
			Category->"Storage & Handling"
		},
		WashCellsMethod->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method, WashCells],
			Description->"The default method object containing the parameters to use to purify cultures of this sample model.",
			Category->"Storage & Handling"
		},
		ChangeMediaMethod->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method, ChangeMedia],
			Description->"The default method object containing the parameters to use to change the base cell growth solution for cultures of this sample model.",
			Category->"Storage & Handling"
		},
		Parafilm->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if containers that contain this sample model should have their covers sealed with parafilm by default.",
			Category->"Storage & Handling"
		},
		AluminumFoil->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if containers that contain this sample model should be wrapped in aluminum foil to protect the container contents from light by default.",
			Category->"Storage & Handling"
		},
		(*Fields below are phasing out after TransportCondition is in play*)

		TransportTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Units->Celsius,
			Description->"The temperature that samples of this model should be heated or refrigerated while transported between instruments during experimentation.",
			Category->"Storage & Handling"
		},
		AsepticTransportContainerType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AsepticTransportContainerTypeP,
			Description -> "Indicates how samples of this model are contained in an aseptic barrier and if they need to be unbagged before being used in a protocol, maintenance, or qualification.",
			Category -> "Storage & Handling"
		},

		(* --- Inventory ---*)
		Products->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Product][ProductModel],
			Description->"Product objects describing commercially available entities composed of samples of this model.",
			Category->"Inventory"
		},
		ProductDocumentationFiles->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"PDFs of any product documentation provided by the supplier of this model.",
			Category->"Inventory"
		},
		Icon -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A simplified image used to represent this sample.",
			Category -> "Organizational Information"
		},
		ConcentratedBufferDiluent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample],
			Description->"The solvent required to dilute this sample model to form BaselineStock. The model is diluted by ConcentratedBufferDilutionFactor.",
			Category->"Inventory"
		},
		(* Copy this over to Object[Sample] and set the 1x buffer as Solvent when we dilute it with Diluent*)
		ConcentratedBufferDilutionFactor->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0],
			Units->None,
			Description->"The amount by which this the sample must be diluted with its ConcentratedBufferDiluent in order to form standard ratio of Models for 1X buffer, the BaselineStock.",
			Category->"Inventory"
		},
		BaselineStock->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample],
			Description->"The 1X version of buffer that this sample model forms when diluted with ConcentratedBufferDiluent by a factor of ConcentrationBufferDilutionFactor.",
			Category->"Inventory"
		},
		Preparable->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model may be prepared as needed during the course of an experiment.",
			Category->"Inventory"
		},
		FixedAmounts->{
			Format->Multiple,
			Class->VariableUnit,
			Pattern:>GreaterP[0 Milliliter] | GreaterP[0 Gram],
			Units->None,
			Description->"If this sample model is purchased and stored in pre-measured amounts, the amounts that samples of this model exist in.",
			Category->"Inventory"
		},
		TransferOutSolventVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*Liter],
			Units->Liter Milli,
			IndexMatching->FixedAmounts,
			Description->"For each member of FixedAmounts, if this sample model is purchased and stored in pre-measured amounts, the amounts of dissolution solvents required to solvate each of the fixed amounts that this model is handled in.",
			Category->"Inventory"
		},
		PipettingMethod->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Method,Pipetting][Models],
			Description->"The default parameters describing how pure samples of this molecule should be manipulated by pipette, such as aspiration and dispensing rates. These parameters may be overridden when creating experiments.",
			Category->"Inventory"
		},
		ReversePipetting->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description-> "Indicates if additional source sample should be aspirated (past the first stop of the pipette) to reduce the chance of bubble formation when dispensing into a destination position. It is recommended to set ReversePipetting->True if this sample model foams or forms bubbles easily.",
			Category->"Inventory"
		},
		Resuspension->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if one of the components in this sample model can only be prepared by adding a solution to its original container to dissolve it. The dissolved sample can be optionally removed from the original container for other preparation steps.",
			Category->"Inventory"
		},
		KitProducts->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Product][KitComponents, ProductModel],
			Description->"Product objects describing commercially available entities composed of samples of this model, if this model is part of one or more kits.",
			Category->"Inventory"
		},
		ServiceProviders->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Company, Service][CustomSynthesizes],
			Description->"Companies that can be contracted to synthesize samples of this model.",
			Category->"Inventory"
		},
		StickeredUponArrival->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if a barcode should be attached to this item during Receive Inventory, or if the unpeeled sticker should be stored with the item and affixed during resource picking.",
			Category->"Inventory",
			Developer->True
		},
		BarcodeTag->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Item,Consumable]
			],
			Description->"The secondary tag used to affix a barcode to this object.",
			Category->"Inventory",
			Developer->True
		},

		(* --- Health & Safety --- *)
		Sterile->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates that samples of this model arrive free of both microbial contamination and any microbial cell samples from the manufacturer, or is prepared free of both microbial contamination and any microbial cell samples by employing autoclaving, sterile filtration, or mixing exclusively sterile components with aseptic techniques during the course of experiments, as well as during sample storage and handling.",
			Category->"Health & Safety"
		},
		RNaseFree->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model are verified to be free from enzymes that break down ribonucleic acid (RNA).",
			Category->"Health & Safety"
		},
		NucleicAcidFree->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model are verified to be free from nucleic acids - large biomolecules composed of nucleotides that may encode genetic information, such as DNA and RNA.",
			Category->"Health & Safety"
		},
		PyrogenFree->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model are verified to be free from compounds that induce fever when introduced into the bloodstream, such as Endotoxins.",
			Category->"Health & Safety"
		},
		Radioactive->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model emit substantial ionizing radiation.",
			Category->"Health & Safety"
		},
		Ventilated->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model must be handled in an enclosure where airflow is used to reduce exposure of the user to the substance and contaminated air is exhausted in a safe location.",
			Category->"Health & Safety"
		},
		InertHandling->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model must be handled in a glove box under an unreactive atmosphere.",
			Category->"Health & Safety"
		},
		GloveBoxIncompatible->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model cannot be used inside of a glove box due high volatility and/or detrimental reactivity with the catalyst in the glove box that is used to remove traces of water and oxygen. Sulfur and sulfur compounds (such as H2S, RSH, COS, SO2, SO3), halides, halogen (Freon), alcohols, hydrazine, phosphene, arsine, arsenate, mercury, and saturation with water may deactivate the catalyst.",
			Category->"Health & Safety"
		},
		GloveBoxBlowerIncompatible->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates that the glove box blower must be turned off to prevent damage to the catalyst in the glove box that is used to remove traces of water and oxygen when manipulating samples of this model inside of the glove box.",
			Category->"Health & Safety"
		},
		Flammable->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model are easily set aflame under standard conditions. This corresponds to NFPA rating of 3 or greater.",
			Category->"Health & Safety"
		},
		Acid->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model are strong acids (pH <= 2) and require dedicated secondary containment during storage.",
			Category->"Health & Safety"
		},
		Base->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model are strong bases (pH >= 12) and require dedicated secondary containment during storage.",
			Category->"Health & Safety"
		},
		Pyrophoric->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model can ignite spontaneously upon exposure to air.",
			Category->"Health & Safety"
		},
		WaterReactive->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model react spontaneously upon exposure to water.",
			Category->"Health & Safety"
		},
		Fuming->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model emit fumes spontaneously when exposed to air.",
			Category->"Health & Safety"
		},
		Aqueous->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model are a solution in water.",
			Category->"Health & Safety"
		},
		Anhydrous->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this sample model does not contain traces of water.",
			Category->"Health & Safety"
		},
		HazardousBan->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model are currently banned from usage in the ECL because the facility isn't yet equipped to handle them.",
			Category->"Health & Safety"
		},
		ExpirationHazard->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model become hazardous once they are expired and therefore must be automatically disposed of when they pass their expiration date.",
			Category->"Health & Safety"
		},
		ParticularlyHazardousSubstance->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if exposure to samples of this model has the potential to cause serious and lasting harm. A substance is considered particularly harmful if it is categorized by any of the following GHS classifications (as found on a MSDS): Reproductive Toxicity (H340, H360, H362),  Acute Toxicity (H300, H310, H330, H370, H371, H372, H373), Carcinogenicity (H350). Note that PHS designation primarily describes toxicity hazard and doesn't include other types of hazard such as water reactivity or being pyrophoric.",
			Category->"Health & Safety"
		},
		DrainDisposal->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model may be safely disposed down a standard drain.",
			Category->"Health & Safety"
		},
		LabWasteDisposal->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model may be safely disposed into a regular lab waste container.",
			Category->"Health & Safety"
		},
		Pungent->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model have a strong odor.",
			Category->"Health & Safety"
		},
		MSDSRequired->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if an MSDS is applicable for this sample model.",
			Category->"Health & Safety"
		},
		MSDSFile->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"A PDF file of the MSDS (Materials Safety Data Sheet) of this sample model.",
			Category->"Health & Safety"
		},
		NFPA->{
			Format->Single,
			Class->Expression,
			Pattern:>NFPAP,
			Description->"The National Fire Protection Association (NFPA) 704 hazard diamond classification for this sample model. The NFPA diamond standard is maintained by the United States National Fire Protection Association and summarizes, clockwise from top, Fire Hazard, Reactivity, Specific Hazard and Health Hazard of a substance.",
			Category->"Health & Safety"
		},
		DOTHazardClass->{
			Format->Single,
			Class->String,
			Pattern:>DOTHazardClassP,
			Description->"The Department of Transportation hazard classification of this sample model.",
			Category->"Health & Safety"
		},
		BiosafetyLevel->{
			Format->Single,
			Class->Expression,
			Pattern:>BiosafetyLevelP,
			Description->"The set of laboratory precautions required for safe handling of samples of this model from biological hazard. Ranging from least stringent at BSL-1 to most stringent at BSL-4 the biosafety levels are described for use in the United States by the Centers for Disease Control and Prevention (CDC) https://www.cdc.gov/labs/pdf/SF__19_308133-A_BMBL6_00-BOOK-WEB-final-3.pdf.",
			Category->"Health & Safety"
		},
		DoubleGloveRequired -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if working with this sample requires users to wear two pairs of gloves.",
			Category -> "Health & Safety",
			Developer -> True
		},

		(* --- Compatibility --- *)
		IncompatibleMaterials->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MaterialP|None,
			Description->"The types of matter that would be damaged if wetted by samples of this model.",
			Category->"Compatibility"
		},
		WettedMaterials->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MaterialP,
			Category->"Compatibility",
			Description->"If containing or composed of a structural material, such as a fiber or bead, the types of such matter that may come in direct contact with fluids."
		},
		LiquidHandlerIncompatible->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model cannot be reliably aspirated or dispensed on an automated liquid handling robot. Substances may be incompatible if they have a low boiling point, readily producing vapor, are highly viscous or are chemically incompatible with all tip types.",
			Category->"Compatibility"
		},
		UltrasonicIncompatible->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if volume measurements of samples of this model cannot be performed via the ultrasonic distance method due to vapors interfering with the reading.",
			Category->"Compatibility"
		},
		PreferredMALDIMatrix->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample, Matrix],
			Description->"The substance best suited to co-crystallize with samples of this model in preparation for mass spectrometry using the matrix-assisted laser desorption/ionization (MALDI) technique.",
			Category->"Compatibility",
			Abstract->False
		},
		ForeignMaterialContactDisallowed -> {
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if any contact of this sample with submerged item/part is blocked.",
			Category->"Compatibility"
		},

				(* --- Qualifications & Maintenance --- *)
		QualificationFrequency->{
			Format->Multiple,
			Class->{Link, Real},
			Pattern:>{_Link, GreaterP[0*Day]},
			Relation->{Model[Qualification][Targets], Null},
			Units->{None, Day},
			Description->"The type of protocols run on samples of this model, and the nominal period of time between protocol runs, to verify that the samples maintain their expected properties.",
			Category->"Qualifications & Maintenance",
			Headers->{"Model Qualification","Time Interval"},
			Abstract->False
		},
		MaintenanceFrequency->{
			Format->Multiple,
			Class->{Link, Real},
			Pattern:>{_Link, GreaterP[0*Day]},
			Relation->{Model[Maintenance][Targets], Null},
			Units->{None, Day},
			Description->"The type of protocols run on samples of this model, and the nominal period of time between protocol runs, to restore the samples to a condition where they attain their expected properties.",
			Category->"Qualifications & Maintenance",
			Headers->{"Model Maintenance","Time Interval"},
			Abstract->False
		},
		ContinuousOperation->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model are required to be continuously available for use in the lab, regardless of if it is InUse by a specific protocol.",
			Developer->True,
			Category-> "Qualifications & Maintenance"
		},

		(* --- Resources --- *)
		RequestedResources->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Resource, Sample][RequestedModels],
			Description->"The list of resource requests for this model that have not yet been Fulfilled.",
			Category->"Resources",
			Developer->True
		},

		(* --- Quality Assurance --- *)
		ReceivingBatchInformation -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FieldP[Object[Report,Certificate,Analysis], Output->Short],
			Description -> "A list of the required fields populated by receiving.",
			Category -> "Quality Assurance"
		},
		ReceivingBatchCertificateExample -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Report,Certificate][ModelsSupported],
			Description -> "Certificate example that contains images for where receiving batch information can be found on documentation.",
			Category -> "Quality Assurance"
		},

		(* --- Migration Support --- *)
		LegacyID->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The SLL2 ID for this Object, if it was migrated from the old data store.",
			Category->"Migration Support",
			Developer->True
		}
	}
}];