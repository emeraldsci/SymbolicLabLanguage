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
			Description->"The name of the model.",
			Category->"Organizational Information",
			Abstract->True
		},
		Synonyms->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"List of possible alternative names this model goes by.",
			Category->"Organizational Information",
			Abstract->True
		},
		Analytes->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->IdentityModelTypeP,
			Description->"The molecular identities of primary interest in this model.",
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
			Description->"The various molecular components present in this sample, along with their respective initial or theoretical concentrations.",
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
			Description->"Describes the molar composition (in percent) of enantiomers, if this sample contains one of the enantiomers or is a mixture of enantiomers.",
			Category->"Organizational Information"
		},
		Media->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample],
			Description->"The base cell growth medium this sample model is in.",
			Category->"Organizational Information"
		},
		UsedAsMedia->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this sample is used as a cell growth medium.",
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
			Description->"The base solution this sample model is in.",
			Category->"Organizational Information"
		},
		UsedAsSolvent->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this sample is used as a solvent.",
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
			Description->"The purity of this model, encapsulating a set of purity standards for specific uses.",
			Category->"Organizational Information",
			Abstract->True
		},
		AlternativeForms->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample][AlternativeForms],
			Description->"Models of other samples with different grades, hydration states, monobasic/dibasic forms, etc.",
			Category->"Organizational Information",
			Abstract->False
		},
		UNII->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"Unique Ingredient Identifier of compounds based on the unified identification scheme of FDA.",
			Category->"Organizational Information",
			Abstract->True
		},
		Tags->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"User-supplied labels that are used for the management and organization of samples. If an aliquot is taken out of this sample, the new sample that is generated will inherit this sample's tags.",
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
		AdditionalInformation -> {
			Format -> Multiple,
			Class -> {String, Date},
			Pattern :> {_String, _?DateObjectQ},
			Description -> "Supplementary information recorded from the UploadMolecule function. These information usually records the user supplied input and options, providing additional information for verification.",
			Headers -> {"Information", "Date Added"},
			Category -> "Hidden"
		},

		(* --- Physical Properties --- *)
		BoilingPoint->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Units->Celsius,
			Description->"Temperature at which the pure substance boils under atmospheric pressure.",
			Category->"Physical Properties",
			Abstract->False
		},
		MeltingPoint->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Units->Celsius,
			Description->"Melting temperature of the pure substance at atmospheric pressure.",
			Category->"Physical Properties",
			Abstract->False
		},
		VaporPressure->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Kilo*Pascal],
			Units->Kilo Pascal,
			Description->"Vapor pressure of the substance at room temperature.",
			Category->"Physical Properties",
			Abstract->False
		},
		CellType->{
			Format->Single,
			Class->Expression,
			Pattern:>CellTypeP,
			Description->"The primary types of cells that are contained within this sample.",
			Category->"Physical Properties"
		},
		CultureAdhesion->{
			Format->Single,
			Class->Expression,
			Pattern:>CultureAdhesionP,
			Description->"The default type of cell culture (adherent or suspension) that should be performed when growing these cells. If a cell line can be cultured via an adherent or suspension culture, this is set to the most common cell culture type for the cell line.",
			Category->"Physical Properties"
		},
		Conductivity->{
			Format->Single,
			Class->Expression,
			Pattern:>DistributionP[Micro Siemens/Centimeter],
			Description->"The conductivity of the substance.",
			Category->"Physical Properties",
			Abstract->False
		},
		Density->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[(0*Gram)/Liter Milli],
			Units->Gram/(Liter Milli),
			Description->"Known density of samples of this model at room temperature.",
			Category->"Physical Properties",
			Abstract->False
		},
		ExtinctionCoefficients->{
			Format->Multiple,
			Class->{Wavelength->VariableUnit, ExtinctionCoefficient->VariableUnit},
			Pattern:>{Wavelength->GreaterP[0*Nanometer], ExtinctionCoefficient->(GreaterP[0 Liter/(Centimeter*Mole)] | GreaterP[0 Milli Liter /(Milli Gram * Centimeter)])},
			Description->"A measure of how strongly this sample absorbs light at a particular wavelength.",
			Category->"Physical Properties"
		},
		Fiber->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this model is in the form of a thin cylindrical string of solid substance.",
			Category->"Physical Properties"
		},
		FiberCircumference->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Millimeter],
			Units->Millimeter,
			Description->"It's the perimeter of the circular cross-section of a the sample if it is a single fiber. In the context of measuring contact angle or surface tension, it's essentially the so called \"wetted length\", the length of the three-phase boundary line for contact between a solid and a liquid in a bulk third phase.",
			Category->"Physical Properties"
		},
		NominalParticleSize->{
			Format->Single,
			Class->Distribution,
			Pattern:>DistributionP[Nanometer],
			Units->Nanometer,
			Description ->
					"The manufacture designated size distribution of particles in the sample model.",
			Category->"Physical Properties"
		},
		ParticleWeight->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Gram],
			Units->Gram,
			Description->"The weight of a single particle of the sample, if the sample is a powder.",
			Category->"Physical Properties",
			Abstract->False
		},
		pKa->{
			Format->Multiple,
			Class->Real,
			Pattern:>NumericP,
			Units->None,
			Description->"The logarithmic acid dissociation constants of the substance at room temperature.",
			Category->"Physical Properties",
			Abstract->False
		},
		pH->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0,14],
			Units->None,
			Description->"The logarithmic concentration of hydrogen ions of the substance at room temperature.",
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
			Description->"The refractive index of the substance at 20 degree Celsius.",
			Category->"Physical Properties",
			Abstract->False
		},
		SingleUse->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this model of sample must be used only once and then disposed of after use.",
			Category->"Physical Properties"
		},
		State->{
			Format->Single,
			Class->Expression,
			Pattern:>ModelStateP,
			Description->"The physical state of the sample when well solvated at room temperature and pressure.",
			Category->"Physical Properties"
		},
		SurfaceTension->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Milli Newton/Meter],
			Units->Milli Newton/Meter,
			Description->"The surface tension of the substance in pure form at room temperature.",
			Category->"Physical Properties",
			Abstract->False
		},
		Tablet->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this model is in the form of a small disk or cylinder of compressed solid substance in a measured amount.",
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
			Description->"The mean mass of a single tablet or sachet of this model.",
			Category->"Physical Properties"
		},
		SolidUnitWeightDistribution->{
			Format->Single,
			Class->Expression,
			Pattern:>DistributionP[Gram],
			Description-> "The distribution of the single tablet or sachet weights measured from multiple samplings.",
			Category->"Physical Properties"
		},
		Sachet->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this model is in the form of a small pouch filled with a measured amount of loose solid substance.",
			Category->"Physical Properties"
		},
		DefaultSachetPouch -> {
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Material],
			Description->"The material of the pouch that the filler of the sachet is wrapped in to form a single unit of sachet.",
			Category->"Physical Properties"
		},
		Viscosity->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Pascal*Second],
			Units->Pascal Second,
			Description->"The viscosity of the substance in pure form at room temperature.",
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
			Description->"All protocols that used this sample at any point during their execution in the lab.",
			Category->"Sample History"
		},

		(* --- Storage & Handling --- *)
		DefaultStorageCondition->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[StorageCondition],
			Description->"The condition in which samples of this model are stored when not in use by an experiment; this condition may be overridden by the specific storage condition of any given sample.",
			Category->"Storage & Handling"
		},
		StoragePositions->{
			Format->Multiple,
			Class->{Link, String},
			Pattern:>{_Link, LocationPositionP},
			Relation->{Object[Container]|Object[Instrument], Null},
			Description->"The specific containers and positions in which this container is to be stored, allowing more granular organization within storage locations for this model's default storage condition.",
			Category->"Storage & Handling",
			Headers->{"Storage Container", "Storage Position"},
			Developer->True
		},
		AutoclaveUnsafe->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if the sample is unstable and can potentially degrade under extreme heating conditions.",
			Category->"Storage & Handling",
			Abstract->True
		},
		PreferredWashBin->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Container,WashBin],
			Description->"Indicates the recommended bin for dishwashing this sample.",
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
			Description->"Indicates the type of waste collected in this sample.",
			Category->"Storage & Handling"
		},
		Expires->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model expire after a given amount of time.",
			Category->"Storage & Handling",
			Abstract->True
		},
		ShelfLife->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Day],
			Units->Day,
			Description->"The length of time after DateCreated that samples of this model are recommended for use before they should be discarded.",
			Category->"Storage & Handling",
			Abstract->True
		},
		UnsealedShelfLife->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Day],
			Units->Day,
			Description->"The length of time after DateUnsealed that samples of this model are recommended for use before they should be discarded.",
			Category->"Storage & Handling",
			Abstract->True
		},
		LightSensitive->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Determines if the sample reacts or degrades in the presence of light and should be stored in the dark to avoid exposure.",
			Category->"Storage & Handling"
		},
		SampleHandling->{
			Format->Single,
			Class->Expression,
			Pattern:>SampleHandlingP,
			Description->"The method by which this sample should be manipulated in the lab when transfers out of the sample are requested.",
			Category->"Storage & Handling"
		},
		AsepticHandling -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if aseptic techniques are followed for handling this sample in lab. Aseptic techniques include sanitization, autoclaving, sterile filtration, or transferring in a biosafety cabinet during experimentation and storage.",
			Category -> "Storage & Handling"
		},
		TransportCondition->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[TransportCondition],
			Description->"Specifies how the samples of this model should be transported when in use in the lab.",
			Category->"Storage & Handling"
		},
		TransferTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Units->Celsius,
			Description->"The temperature that samples of this model should be at before any transfers using this sample occur.",
			Category->"Storage & Handling"
		},
		ThawTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Units->Celsius,
			Description->"The default temperature that samples of this model should be thawed at before using in experimentation.",
			Category->"Storage & Handling"
		},
		ThawTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Second],
			Units->Minute,
			Description->"The default time that samples of this model should be thawed before using in experimentation. If the samples are still not thawed after this time, thawing will continue until the samples are fully thawed.",
			Category->"Storage & Handling"
		},
		MaxThawTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Second],
			Units->Minute,
			Description->"The default maximum time that samples of this model should be thawed before using in experimentation.",
			Category->"Storage & Handling"
		},
		ThawMixType->{
			Format->Single,
			Class->Expression,
			Pattern:>MixTypeP,
			Description->"The default style of motion used to mix samples of this model following thawing.",
			Category->"Storage & Handling"
		},
		ThawMixRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*RPM],
			Units->RPM,
			Description->"The default frequency of rotation the mixing instrument uses to mix samples of this model following thawing.",
			Category->"Storage & Handling"
		},
		ThawMixTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Minute],
			Units->Minute,
			Description-> "The default duration for which samples of this model are mixed following thawing.",
			Category->"Storage & Handling",
			Abstract->True
		},
		ThawNumberOfMixes->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0],
			Units->None,
			Description->"The default number of times samples of this model are mixed by inversion or pipetting up and down following thawing.",
			Category->"Storage & Handling"
		},
		ThawCellsMethod->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method, ThawCells],
			Description->"The default method by which to thaw cryovials of this sample model.",
			Category->"Storage & Handling"
		},
		WashCellsMethod->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method, WashCells],
			Description->"The default method by which to wash cultures of this sample model.",
			Category->"Storage & Handling"
		},
		ChangeMediaMethod->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method, ChangeMedia],
			Description->"The default method by which to change the media for cultures of this sample model.",
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
			Description->"The temperature that samples of this model should be incubated at while transported between instruments during experimentation.",
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
			Description->"Products ordering information for this model.",
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
			Description->"The buffer that is used to dilute the sample by ConcentratedBufferDilutionFactor to form BaselineStock.",
			Category->"Inventory"
		},
		(* Copy this over to Object[Sample] and set the 1x buffer as Solvent when we dilute it with Diluent*)
		ConcentratedBufferDilutionFactor->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0],
			Units->None,
			Description->"The amount by which this the sample must be diluted in order to form the standard working concentration. For a sample with ConcentratedBufferDiluent, the dilution made with ConcentratedBufferDiluent forms the standard 1X buffer (BaselineStock).",
			Category->"Inventory"
		},
		BaselineStock->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample],
			Description->"The equivalent 1X model of the buffer that the sample forms when diluted with their ConcentratedBufferDiluent by ConcentratedBufferDilutionFactor.",
			Category->"Inventory"
		},
		Preparable->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this samples/items of this model maybe prepared as needed during the course of an experiment.",
			Category->"Inventory"
		},
		FixedAmounts->{
			Format->Multiple,
			Class->VariableUnit,
			Pattern:>GreaterP[0 Milliliter] | GreaterP[0 Gram],
			Units->None,
			Description->"The pre-measured amounts in which samples of this model are always stored.",
			Category->"Inventory"
		},
		TransferOutSolventVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*Liter],
			Units->Liter Milli,
			IndexMatching->FixedAmounts,
			Description->"For each member of FixedAmounts, the amount of the dissolution solvent required to solvate the fixed amount component in this model.",
			Category->"Inventory"
		},
		PipettingMethod->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Method,Pipetting][Models],
			Description->"The pipetting parameters used to manipulate samples of this model; these parameters may be overridden by direct specification of pipetting parameters in manipulation primitives.",
			Category->"Inventory"
		},
		ReversePipetting->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if reverse pipetting technique should be used when transferring this sample via pipette. It is recommended to set ReversePipetting->True if this sample foams or forms bubbles easily.",
			Category->"Inventory"
		},
		Resuspension->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if one of the components in the stock solution is a sample which can only be prepared by adding a solution to its original container to dissolve it. The dissolved sample can be optionally removed from the original container for other preparation steps.",
			Category->"Inventory"
		},
		KitProducts->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Product][KitComponents, ProductModel],
			Description->"Products ordering information for this model if this model is part of one or more kits.",
			Category->"Inventory"
		},
		MixedBatchProducts->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Product][MixedBatchComponents, ProductModel],
			Description->"Products ordering information for this model if this model is part of one or more mixed batches.",
			Category->"Inventory"
		},
		ServiceProviders->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Company, Service][CustomSynthesizes],
			Description->"Service companies that provide synthesis of this model as a service.",
			Category->"Inventory"
		},
		StickeredUponArrival->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if a sticker should be attached to this item during Receive Inventory, or if the unpeeled sticker should be stored with the item and affixed during resource picking.",
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
			Description->"Indicates that this model of sample arrives free of both microbial contamination and any microbial cell samples from the manufacturer, or is prepared free of both microbial contamination and any microbial cell samples by employing aseptic techniques during experimentation and storage.",
			Category->"Health & Safety"
		},
		RNaseFree->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates that this model of sample is free of any RNases.",
			Category->"Health & Safety"
		},
		NucleicAcidFree->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if this model of sample is tested to be not contaminated with DNA and RNA by the manufacturer.",
			Category->"Health & Safety"
		},
		PyrogenFree->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if this model of sample is tested to be not contaminated with endotoxin by the manufacturer.",
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
			Description->"Indicates if samples of this model must be handled in a ventilated enclosures.",
			Category->"Health & Safety"
		},
		InertHandling->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model must be handled in a glove box.",
			Category->"Health & Safety"
		},
		GloveBoxIncompatible->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model cannot be used inside of the glove box due high volatility and/or detrimental reactivity with the catalyst in the glove box that is used to remove traces of water and oxygen. Sulfur and sulfur compounds (such as H2S, RSH, COS, SO2, SO3), halides, halogen (Freon), alcohols, hydrazine, phosphene, arsine, arsenate, mercury, and saturation with water may deactivate the catalyst.",
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
			Description->"Indicates if samples of this model are easily set aflame under standard conditions.",
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
			Description->"Indicates if samples of this model do not contain water.",
			Category->"Health & Safety"
		},
		HazardousBan->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if samples of this model are currently banned from usage in the ECL because the facility isn't yet equiped to handle them.",
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
			Description->"Indicates if exposure to this substance has the potential to cause serious and lasting harm. A substance is considered particularly harmful if it is categorized by any of the following GHS classifications (as found on a MSDS): Reproductive Toxicity (H340, H360, H362),  Acute Toxicity (H300, H310, H330, H370, H373), Carcinogenicity (H350).",
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
			Description->"Indicates if an MSDS is applicable for this model.",
			Category->"Health & Safety"
		},
		MSDSFile->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"PDF of the models MSDS (Materials Saftey Data Sheet).",
			Category->"Health & Safety"
		},
		NFPA->{
			Format->Single,
			Class->Expression,
			Pattern:>NFPAP,
			Description->"The National Fire Protection Association (NFPA) 704 hazard diamond classification for the substance.",
			Category->"Health & Safety"
		},
		DOTHazardClass->{
			Format->Single,
			Class->String,
			Pattern:>DOTHazardClassP,
			Description->"The Department of Transportation hazard classification of the substance.",
			Category->"Health & Safety"
		},
		BiosafetyLevel->{
			Format->Single,
			Class->Expression,
			Pattern:>BiosafetyLevelP,
			Description->"The Biosafety classification of the substance.",
			Category->"Health & Safety"
		},
		DoubleGloveRequired -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if working with this sample requires to wear two pairs of gloves.",
			Category -> "Health & Safety",
			Developer -> True
		},

		(* --- Compatibility --- *)
		IncompatibleMaterials->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MaterialP|None,
			Description->"A list of materials that would be damaged if wetted by this model.",
			Category->"Compatibility"
		},
		WettedMaterials->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MaterialP,
			Category->"Compatibility",
			Description->"The materials of which this model sample is made that may come in direct contact with fluids."
		},
		LiquidHandlerIncompatible->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if this model sample cannot be reliably aspirated or dispensed on an automated liquid handling robot.",
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
			Description->"The model of the matrix that is best suited for MALDI mass spectrometry of this sample.",
			Category->"Compatibility",
			Abstract->False
		},

		(* --- Qualifications & Maintenance --- *)
		QualificationFrequency->{
			Format->Multiple,
			Class->{Link, Real},
			Pattern:>{_Link, GreaterP[0*Day]},
			Relation->{Model[Qualification][Targets], Null},
			Units->{None, Day},
			Description->"The model Qualifications and their required frequencies.",
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
			Description->"The model maintenances and their required frequencies.",
			Category->"Qualifications & Maintenance",
			Headers->{"Model Maintenance","Time Interval"},
			Abstract->False
		},
		ContinuousOperation->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if the sample is required to operate continuously in the lab, regardless of if it is InUse by a specific protocol.",
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