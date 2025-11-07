(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Sample], {
	Description->"A reagent used in an experiment.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{

		(* --- Organizational Information --- *)
		Name->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"A unique name used to identify this sample.",
			Category->"Organizational Information",
			Abstract->True
		},
		ModelName->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model], Name]],
			Pattern:>_String,
			Description->"The name of the model that this sample was based on.",
			Category->"Organizational Information"
		},
		Analytes->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->IdentityModelTypeP,
			Description->"The molecular identities of primary interest in this sample.",
			Category->"Organizational Information",
			Abstract->True
		},
		Composition->{
			Format->Multiple,
			Class->{VariableUnit, Link, Date},
			Pattern:>{
				CompositionP,
				_Link,
				_?DateObjectQ
			},
			Relation->{
				Null,
				IdentityModelTypeP,
				Null
			},
			Headers->{
				"Amount",
				"Identity Model",
				"Date"
			},
			Description->"Records the various molecular components present in this sample, along with their respective concentrations. The recorded composition is associated with the specific time at which it was measured or recorded.",
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
		CurrentProtocol->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Protocol][Resources],
				Object[Maintenance][Resources],
				Object[Qualification][Resources]
			],
			Description->"The experiment, maintenance, or Qualification that is currently using this sample.",
			Category->"Organizational Information",
			Abstract->True
		},
		CurrentSubprotocol->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Protocol],
				Object[Maintenance],
				Object[Qualification]
			],
			Description->"The specific protocol or subprotocol that is currently using this sample.",
			Category->"Organizational Information",
			Developer->True
		},
		Missing->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates that this object was not found at its database listed location and that troubleshooting will be required to locate it.",
			Category->"Organizational Information",
			Developer->True
		},
		DateMissing->{
			Format->Single,
			Class->Date,
			Pattern:>_?DateObjectQ,
			Description->"Date the sample was set Missing.",
			Category->"Organizational Information"
		},
		MissingLog->{
			Format->Multiple,
			Class->{Date, Boolean, Link},
			Pattern:>{_?DateObjectQ, BooleanP, _Link},
			Relation->{Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Description->"A log of changes made to this sample's Missing status.",
			Headers->{"Date", "Missing", "Responsible Party"},
			Category->"Organizational Information"
		},
		Restricted->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this sample must be specified directly in order to be used in experiments or if instead it can be used by any experiments that request a model matching this sample's model.",
			Category->"Organizational Information"
		},
		RestrictedLog->{
			Format->Multiple,
			Class->{Date, Boolean, Link},
			Pattern:>{_?DateObjectQ, BooleanP, _Link},
			Relation->{Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Description->"A log of changes made to this sample's restricted status.",
			Headers->{"Date", "Restricted", "Responsible Party"},
			Category->"Organizational Information"
		},
		Destination->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container, Site],
			Description->"If this sample is in transit, the site where the sample is being shipped to.",
			Category->"Organizational Information"
		},
		Site->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container,Site],
			Description->"The ECL site at which this sample currently resides.",
			Category->"Organizational Information"
		},
		SiteLog->{
			Format->Multiple,
			Headers->{"Date", "Site", "Responsible Party"},
			Class->{Date, Link, Link},
			Pattern:>{_?DateObjectQ, _Link, _Link},
			Relation->{Null, Object[Container,Site], Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description->"The site history of the sample.",
			Category->"Container Information"
		},
		Status->{
			Format->Single,
			Class->Expression,
			Pattern:>SampleStatusP,
			Description->"Current status of the sample. Options include Stocked (not yet in circulation), Available (in active use), and Discarded (discarded).",
			Category->"Organizational Information",
			Abstract->True
		},
		StatusLog->{
			Format->Multiple,
			Class->{Expression, Expression, Link},
			Pattern:>{_?DateObjectQ, SampleStatusP, _Link},
			Relation->{Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Description->"A log of changes made to the sample's status.",
			Headers->{"Date", "Status", "Responsible Party"},
			Category->"Organizational Information",
			Developer->True
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

		(* --- Container Information --- *)
		Container->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container][Contents, 2],
				Object[Instrument][Contents, 2]
			],
			Description->"The container in which this sample is physically located.",
			Category->"Container Information"
		},
		LocationLog->{
			Format->Multiple,
			Class->{Date, Expression, Link, String, Link},
			Pattern:>{_?DateObjectQ, In | Out, _Link, _String, _Link},
			Relation->{Null, Null, Object[Container][ContentsLog, 3] | Object[Instrument][ContentsLog, 3], Null, Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description->"The location history of the sample. Lines recording a movement to container and position of {Null, Null} respectively indicate the item being discarded.",
			Category->"Container Information",
			Headers->{"Date", "Change Type", "Container", "Position", "Responsible Party"}
		},
		Position->{
			Format->Single,
			Class->String,
			Pattern:>LocationPositionP,
			Description->"The name of the position in this sample's container where this sample is physically located.",
			Category->"Container Information"
		},
		Well->{
			Format->Single,
			Class->String,
			Pattern:>WellP|LocationPositionP,
			Description->"The microplate well in which this sample is physically located.",
			Category->"Container Information"
		},
		ResourcePickingGrouping->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Object[Instrument]
			],
			Description->"The parent container of this object which can be used to give the object's approximate location and to see show its proximity to other objects which may be resource picked at the same time or in use by the same protocol.",
			Category->"Container Information"
		},

		(* --- Physical Properties --- *)
		Appearance->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Object]}, Computables`Private`latestAppearance[Field[Object]]],
			Pattern:>_Image,
			Description->"The most recent image taken of this sample.",
			Category->"Physical Properties"
		},
		AppearanceLog->{
			Format->Multiple,
			Class->{Date, Link, Link},
			Pattern:>{_?DateObjectQ, _Link, _Link},
			Relation->{Null, Object[Data], Object[Protocol]|Object[Qualification]|Object[Maintenance]},
			Units->{None, None, None},
			Description->"A historical record of when the sample was imaged.",
			Category->"Physical Properties",
			Headers->{"Date", "Data", "Protocol"}
		},
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
		PharmacopeiaMeltingPoint->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Units->Celsius,
			Description->"Nominal pharmacopeia melting temperature of a melting point standard at atmospheric pressure.",
			Category->"Physical Properties",
			Abstract->False,
			Developer -> True
		},
		ThermodynamicMeltingPoint->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Units->Celsius,
			Description->"Nominal thermodynamic melting temperature of a melting point standard at atmospheric pressure.",
			Category->"Physical Properties",
			Abstract->False,
			Developer -> True
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
			Description->"The type of cell culture that is currently being performed to grow these cells.",
			Category->"Physical Properties"
		},
		CrystallizationImage->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"The most recent automatic visible light image taken of this sample to monitor crystal growth during storage.",
			Category->"Physical Properties"
		},
		CrystallizationImagingLog->{
			Format->Multiple,
			Class->{Date, Link},
			Pattern:>{_?DateObjectQ, _Link},
			Relation->{Null, Object[Data, Appearance, Crystals]},
			Description->"A historical record of when the sample was automatically imaged with visible light to monitor crystal growth during storage taken daily.",
			Category->"Physical Properties",
			Headers->{"Date", "Data"}
		},
		CrystallizationTemperatureLog->{
			Format->Single,
			Class->Link,
			Pattern:> _Link,
			Relation->Object[Data,Temperature],
			Description->"A historical environment temperature record of this sample during storage and diffraction updated daily.",
			Category->"Physical Properties"
		},
		Conductivity->{
			Format->Single,
			Class->Expression,
			Pattern:>DistributionP[Micro Siemens/Centimeter],
			Description->"The most recently measured conductivity of the sample.",
			Category->"Physical Properties",
			Abstract->False
		},
		ConductivityLog->{
			Format->Multiple,
			Class->{Date, Expression, Link},
			Pattern:>{_?DateObjectQ, DistributionP[Micro Siemens/Centimeter], _Link},
			Relation->{Null, Null, Object[Protocol] | Object[Analysis] | Object[Product] | Object[Maintenance] | Object[Qualification] | Object[User]},
			Description->"A historical record of the measured conductivity of the sample.",
			Category->"Physical Properties",
			Headers->{"Date", "Conductivity", "Responsible Party"}
		},
		Count->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0, 1],
			Units->None,
			Description->"The current number of individual items that are part of this sample.",
			Category->"Physical Properties"
		},
		CountLog->{
			Format->Multiple,
			Class->{Date, Integer, Link},
			Pattern:>{_?DateObjectQ, GreaterEqualP[0, 1], _Link},
			Relation->{Null, Null, Object[Protocol] | Object[Maintenance] | Object[Qualification] | Object[Product] | Object[User]},
			Units->{None, None, None},
			Description->"A historical record of the count of the sample.",
			Category->"Physical Properties",
			Headers->{"Date", "Count", "Responsible Party"}
		},
		Density->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[(0 * Gram) / Liter],
			Units->Gram / (Liter Milli),
			Description->"The most recently measured density of the sample.",
			Category->"Physical Properties"
		},
		DensityLog->{
			Format->Multiple,
			Class->{Date, Real, Link},
			Pattern:>{_?DateObjectQ, GreaterP[(0 * Gram) / Liter], _Link},
			Relation->{Null, Null, Object[Protocol] | Object[Analysis] | Object[Product] | Object[Maintenance] | Object[Qualification] | Object[User]},
			Units->{None, Gram / (Liter Milli), None},
			Description->"A historical record of the measured density of the sample.",
			Category->"Physical Properties",
			Headers->{"Date", "Density", "Responsible Party"}
		},
		DensityDistribution->{
			Format->Single,
			Class->Expression,
			Pattern:>DistributionP[Gram / (Liter Milli)],
			Description->"The statistical distribution of the density.",
			Category->"Physical Properties"
		},
		Mass->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 * Gram],
			Units->Gram,
			Description->"The most recently measured mass of the sample.",
			Category->"Physical Properties"
		},
		MassLog->{
			Format->Multiple,
			Class->{Date, Real, Link, Expression},
			Pattern:>{_?DateObjectQ, GreaterEqualP[0 * Gram], _Link, WeightMeasurementStatusP},
			Relation->{Null, Null, Object[Protocol] | Object[Analysis] | Object[Product] | Object[Maintenance] | Object[Qualification] | Object[User], Null},
			Units->{None, Gram, None, None},
			Description->"A historical record of the measured weight of the sample.",
			Category->"Physical Properties",
			Headers->{"Date", "Weight", "Responsible Party", "Measurement Type"}
		},
		Volume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 * Liter],
			Units->Liter,
			Description->"The most recently measured volume of the sample.",
			Category->"Physical Properties"
		},
		VolumeLog->{
			Format->Multiple,
			Class->{Date, Real, Link, Expression},
			Pattern:>{_?DateObjectQ, GreaterEqualP[0 * Liter], _Link, VolumeMeasurementStatusP},
			Relation->{Null, Null, Object[Protocol] | Object[Analysis] | Object[Product] | Object[Maintenance] | Object[Qualification] | Object[User], Null},
			Units->{None, Liter, None, None},
			Description->"A historical record of the measured volume of the sample.",
			Category->"Physical Properties",
			Headers->{"Date", "Volume", "Responsible Party", "Measurement Type"}
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
			Description->"Indicates if this object is in the form of a thin cylindrical string of solid substance.",
			Category->"Physical Properties"
		},
		FiberLength->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Millimeter],
			Units->Millimeter,
			Description->"The length of the long axial of a fiber sample when it is fully extended.",
			Category->"Physical Properties"
		},
		FiberCircumference->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Millimeter],
			Units->Millimeter,
			Description->"Assuming the fiber is cylindrical, it's the perimeter of the circular cross-section of a single fiber. In the context of measuring contact angle or surface tension, it's essentially the so called \"wetted length\", the length of the three-phase boundary line for contact between a solid and a liquid in a bulk third phase.",
			Category->"Physical Properties"
		},
		ParticleSize->{
			Format->Single,
			Class->Distribution,
			Pattern:>DistributionP[Nanometer],
			Units->Nanometer,
			Description ->
					"The size distribution of particles as measured in the sample solution.",
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
			Pattern:>NumericP,
			Units->None,
			Description->"The most recently measured pH of the sample.",
			Category->"Physical Properties"
		},
		pHLog->{
			Format->Multiple,
			Class->{Date, Real, Link},
			Pattern:>{_?DateObjectQ, NumericP, _Link},
			Relation->{Null, Null, Object[Protocol] | Object[Analysis] | Object[Product] | Object[Maintenance] | Object[Qualification] | Object[User]},
			Units->{None, None, None},
			Description->"A historical record of the measured pH of the sample.",
			Category->"Physical Properties",
			Headers->{"Date", "pH", "Responsible Party"}
		},
		RefractiveIndex->{
			Format->Single,
			Class->Expression,
			Pattern:>DistributionP[]|GreaterP[1],
			Units->None,
			Description ->"The most recently measured refractive index of the sample under ambient conditions.",
			Category->"Physical Properties"
		},
		RefractiveIndexLog->{
			Format->Multiple,
			Class->{Date, Expression, Expression, Link},
			Pattern:>{_?DateObjectQ, DistributionP[]|GreaterP[0 Celsius], DistributionP[]|GreaterP[1], _Link},
			Relation->{Null, Null, Null, Object[Protocol]|Object[Analysis]|Object[Product]|Object[Maintenance]|Object[Qualification]|Object[User]},
			Units->{None, None, None, None},
			Description->"A historical record of the measured refractive index of the sample under ambient conditions.",
			Category->"Physical Properties",
			Headers->{"Date", "Temperature", "Refractive Index", "Responsible Party"}
		},
		State->{
			Format->Single,
			Class->Expression,
			Pattern:>PhysicalStateP,
			Description->"The physical state of the sample when well solvated at room temperature and pressure.",
			Category->"Physical Properties"
		},
		SurfaceTension->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Milli Newton/Meter],
			Units->Milli Newton/Meter,
			Description->"The most recently measured surface tension of the sample.",
			Category->"Physical Properties"
		},
		SurfaceTensionLog->{
			Format->Multiple,
			Class->{Date, Real, Link},
			Pattern:>{_?DateObjectQ, GreaterEqualP[0*Milli Newton/Meter], _Link},
			Relation->{Null, Null, Object[Protocol] | Object[Analysis] | Object[Product] | Object[Maintenance] | Object[Qualification] | Object[User]},
			Units->{None, Milli Newton/Meter, None},
			Description->"A historical record of the measured surface tension of the sample.",
			Category->"Physical Properties",
			Headers->{"Date", "Surface Tension", "Responsible Party"}
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
			Description->"Indicates if this object is in the form of a small pouch filled with a measured amount of loose solid substance.",
			Category->"Physical Properties"
		},
		TotalProteinConcentration->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[(0 * Milligram) / Milliliter],
			Units->Milligram / Milliliter,
			Description->"The most recently calculated mass of the proteins present divided by the volume of the lysate.",
			Category->"Physical Properties"
		},
		TotalProteinConcentrationLog->{
			Format->Multiple,
			Class->{Date, Real, Link},
			Pattern:>{_?DateObjectQ, GreaterEqualP[(0 * Milligram) / Milliliter], _Link},
			Relation->{Null, Null, Object[Protocol] | Object[Analysis] | Object[Product] | Object[Maintenance] | Object[Qualification] | Object[User]},
			Units->{None, Milligram / Milliliter, None},
			Description->"A historical record of the total protein concentration of the sample.",
			Headers->{"Date", "Total Protein Concentration", "Responsible Party"},
			Category->"Physical Properties"
		},
		Viscosity->{
			Format->Single,
			Class->Real,
			Units->Milli*Pascal*Second,
			Pattern:>GreaterEqualP[0*(Milli*Pascal)*Second],
			Description->"The most recently measured viscosity of the sample at 25 Celsius.",
			Category->"Physical Properties",
			Abstract->False
		},
		ViscosityLog->{
			Format->Multiple,
			Class->{Date, Expression, Link},
			Pattern:>{_?DateObjectQ, GreaterEqualP[0*(Milli*Second*Pascal)], _Link},
			Relation->{Null, Null, Object[Protocol] | Object[Analysis] | Object[Product] | Object[Maintenance] | Object[Qualification] | Object[User]},
			Description->"A historical record of the measured viscosity of the sample.",
			Category->"Physical Properties",
			Headers->{"Date", "Viscosity", "Responsible Party"}
		},
		(*Fields below are phasing out*)
		Concentration->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 * Micromolar],
			Units->Micromolar,
			Description->"The most recently calculated concentration of the sample.",
			Category->"Physical Properties",
			Developer->True
		},
		ConcentrationLog->{
			Format->Multiple,
			Class->{Date, Real, Link},
			Pattern:>{_?DateObjectQ, GreaterEqualP[0 * Micromolar], _Link},
			Relation->{Null, Null, Object[Protocol] | Object[Analysis] | Object[Product] | Object[Maintenance] | Object[Qualification] | Object[User] | Model[Sample]},
			Units->{None, Micromolar, None},
			Description->"A historical record of the concentration of the sample.",
			Category->"Physical Properties",
			Headers->{"Date", "Molar Concentration", "Responsible Party"},
			Developer->True
		},
		MassConcentration->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[(0 * Gram) / Liter],
			Units->Gram / Liter,
			Description->"The most recently calculated mass of the constituent(s) divided by the volume of the mixture.",
			Category->"Physical Properties",
			Developer->True
		},
		MassConcentrationLog->{
			Format->Multiple,
			Class->{Date, Real, Link},
			Pattern:>{_?DateObjectQ, GreaterEqualP[(0 * Gram) / Liter], _Link},
			Relation->{Null, Null, Object[Protocol] | Object[Analysis] | Object[Product] | Object[Maintenance] | Object[Qualification] | Object[User] | Model[Sample]},
			Units->{None, Gram / Liter, None},
			Description->"A historical record of the measured mass concentration of the sample.",
			Category->"Physical Properties",
			Headers->{"Date", "Mass Concentration", "Responsible Party"},
			Developer->True
		},

		(* --- Sample History --- *)
		AliquotSamples->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample][SourceSample],
			Description->"Any aliquots generated from this sample.",
			Category->"Sample History"
		},
		SourceSample->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample][AliquotSamples],
			Description->"The source sample from which this aliquot sample was taken.",
			Category->"Sample History"
		},
		TransfersIn->{ (* Note: The only things that can transfer into items are gels. *)
			Format->Multiple,
			Class->{Date, VariableUnit, Link, Link, Expression},
			Pattern:>{_?DateObjectQ, GreaterEqualP[0*Milliliter] | GreaterEqualP[0*Milligram] | GreaterEqualP[0*Unit, 1*Unit], _Link, _Link, TransferCompletenessP},
			Relation->{Null, Null, Object[Sample][TransfersOut,3] | Object[Item][TransfersOut, 3], Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification], Null},
			Units->{None, None, None, None, None},
			Description->"Materials transfered into this item from other samples, in the form: {Date, Nominal amount transferred, Source sample, Responsible party, Completeness of transfer (specified Partial amount vs All)}.",
			Category->"Sample History",
			Headers ->{"Date","Target Amount","Origin Sample","Responsible Party","Transfer Type"}
		},
		TransfersOut->{
			Format->Multiple,
			Class->{Date, VariableUnit, Link, Link, Expression},
			Pattern:>{_?DateObjectQ, GreaterEqualP[0*Milliliter] | GreaterEqualP[0*Milligram] | GreaterEqualP[0*Unit, 1*Unit], _Link, _Link, TransferCompletenessP},
			Relation->{Null, Null, Object[Sample][TransfersIn,3] | Object[Item][TransfersIn,3], Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification], Null},
			Units->{None, None, None, None, None},
			Description->"Materials transfered out of this item and into other samples, in the form: {Date, Nominal amount transferred, Destination sample, Responsible party, Completeness of transfer (specified Partial amount vs All)}.",
			Category->"Sample History",
			Headers ->{"Date","Target Amount","Destination Sample","Responsible Party","Transfer Type"}
		},
		AutoclaveLog->{
			Format->Multiple,
			Class->{Date, Link},
			Pattern:>{_?DateObjectQ, _Link},
			Relation->{Null, Object[Protocol]},
			Units->{None, None},
			Description->"A historical record of when the sample was last autoclaved.",
			Category->"Sample History",
			Headers->{"Date", "Protocol"}
		},
		Protocols->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Protocol][SamplesIn],
				Object[Protocol][SamplesOut],
				Object[Protocol, UVMelting][SamplesInAliquots, 1],
				Object[Protocol, DynamicFoamAnalysis][AdditiveSamplesIn],
				Object[Protocol, SolidPhaseExtraction][PreFlushingSampleOut],
				Object[Protocol, SolidPhaseExtraction][ConditioningSampleOut],
				Object[Protocol, SolidPhaseExtraction][LoadingSampleFlowthroughSampleOut],
				Object[Protocol, SolidPhaseExtraction][WashingSampleOut],
				Object[Protocol, SolidPhaseExtraction][SecondaryWashingSampleOut],
				Object[Protocol, SolidPhaseExtraction][TertiaryWashingSampleOut],
				Object[Protocol, SolidPhaseExtraction][ElutingSampleOut]
			],
			Description->"All protocols that used this sample at any point during their execution in the lab.",
			Category->"Sample History"
		},
		SampleHistory->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleHistoryP,
			Description->"An ordered description of every major event in a sample's lifetime.",
			Category->"Sample History"
		},

		(* --- Experimental Results --- *)
		Data->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Data][AliquotSamples],
				Object[Data][SamplesIn],
				Object[Data][SamplesOut],
				Object[Data, LCMS][Columns],
				Object[Data, TLC][Stain],
				Object[Data, AbsorbanceIntensity][InjectionSamples],
				Object[Data, AbsorbanceSpectroscopy][InjectionSamples],
				Object[Data, AbsorbanceKinetics][InjectionSamples],
				Object[Data, FluorescenceKinetics][InjectionSamples],
				Object[Data, FluorescenceIntensity][InjectionSamples],
				Object[Data, FluorescenceSpectroscopy][InjectionSamples],
				Object[Data, FluorescencePolarization][InjectionSamples],
				Object[Data, FluorescencePolarizationKinetics][InjectionSamples],
				Object[Data, LuminescenceKinetics][InjectionSamples],
				Object[Data, LuminescenceIntensity][InjectionSamples],
				Object[Data, LuminescenceSpectroscopy][InjectionSamples],
				Object[Data, Nephelometry][InjectionSamples],
				Object[Data, NephelometryKinetics][InjectionSamples],
				Object[Data, Weight][WeighBoat],
				Object[Data, LiquidParticleCount][DilutionSamples],
				Object[Data, CyclicVoltammetry][LoadingSample],
				Object[Data, DigitalPCR][AssaySample],
				Object[Data, DynamicFoamAnalysis][AdditiveSamplesIn],
				Object[Data, CoulterCount][DilutionSamples],
				Object[Data, MeltingPoint][AssaySample],
				Object[Data, QuantifyColonies][QuantificationColonySamples]
			],
			Description->"Experimental data involved in the creation or consumption of the sample.",
			Category->"Experimental Results"
		},

		(* --- Analysis & Reports --- *)
		QuantificationAnalyses->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Analysis, AbsorbanceQuantification][SamplesIn],
			Description->"Analyses performed to determine the concentration of this sample.",
			Category->"Analysis & Reports"
		},

		(* --- Storage & Handling --- *)
		StorageCondition->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[StorageCondition],
			Description->"The current conditions under which this sample should be kept when not in use by an experiment.",
			Category->"Storage & Handling"
		},
		StorageConditionLog->{
			Format->Multiple,
			Class->{Date, Link, Link},
			Pattern:>{_?DateObjectQ, _Link, _Link},
			Relation->{Null, Model[StorageCondition], Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description->"A record of past changes made to the conditions under which this sample should be kept when not in use by an experiment.",
			Headers->{"Date", "Condition", "Responsible Party"},
			Category->"Storage & Handling"
		},
		StoragePositions->{
			Format->Multiple,
			Class->{Link, String},
			Pattern:>{_Link, LocationPositionP},
			Relation->{Object[Container]|Object[Instrument], Null},
			Description->"The specific containers and positions in which this container is to be stored, allowing more granular organization within storage locations for this sample's storage condition.",
			Category->"Storage & Handling",
			Headers->{"Storage Container", "Storage Position"},
			Developer->True
		},
		StorageSchedule->{
			Format->Multiple,
			Class->{Date, Link, Link},
			Pattern:>{_?DateObjectQ, _Link, _Link},
			Relation->{Null, Model[StorageCondition], Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description->"The planned storage condition changes to be performed.",
			Headers->{"Date", "Condition", "Responsible Party"},
			Category->"Storage & Handling"
		},
		AwaitingStorageUpdate->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if this sample has been scheduled for movement to a new storage condition.",
			Category->"Storage & Handling",
			Developer->True
		},
		AwaitingDisposal->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this sample is marked for disposal once it is no longer required for any outstanding experiments.",
			Category->"Storage & Handling"
		},
		AutoclaveSafe->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if the sample is stable and does not degrade under extreme heating conditions.",
			Category->"Storage & Handling",
			Abstract->True
		},
		DisposalLog->{
			Format->Multiple,
			Class->{Expression, Boolean, Link},
			Pattern:>{_?DateObjectQ, BooleanP, _Link},
			Relation->{Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Description->"A log of changes made to when this sample is marked as awaiting disposal by the AwaitingDisposal Boolean.",
			Headers->{"Date", "Awaiting Disposal", "Responsible Party"},
			Category->"Storage & Handling"
		},
		Waste->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this sample is a collection of other samples that are to be thrown out.",
			Category->"Storage & Handling"
		},
		WasteType->{
			Format->Single,
			Class->Expression,
			Pattern:>WasteTypeP,
			Description->"Indicates the type of waste collected in this sample.",
			Category->"Storage & Handling"
		},
		BiohazardDisposal->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates whether the sample should be disposed of as biohazardous waste if disposed of, though it is not necessarily designated for disposal at this time.",
			Category->"Storage & Handling"
		},
		DiscardThreshold -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The volume below which this sample is automatically marked as AwaitingDisposal.",
			Category -> "Storage & Handling"
		},
		CrystallizationTerminationDate->{
			Format->Single,
			Class->Date,
			Pattern:> _?DateObjectQ,
			Description->"Date after which this sample will be moved out of the crystal incubator if it is still inside.",
			Category->"Storage & Handling"
		},
		Expires->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if this sample expires after a given amount of time.",
			Category->"Storage & Handling",
			Abstract->True
		},
		ShelfLife->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 * Day],
			Units->Day,
			Description->"The length of time after DateCreated this sample is recommended for use before it should be discarded.",
			Category->"Storage & Handling",
			Abstract->True
		},
		UnsealedShelfLife->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 * Day],
			Units->Day,
			Description->"The length of time after DateUnsealed this sample is recommended for use before it should be discarded.",
			Category->"Storage & Handling",
			Abstract->True
		},
		LightSensitive->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates that this sample reacts or degrades in the presence of light and should be stored in the dark to avoid exposure.",
			Category->"Storage & Handling"
		},
		SampleHandling->{
			Format->Single,
			Class->Expression,
			Pattern:>SampleHandlingP,
			Description->"The method by which this sample should be manipulated in the lab when transfers out of the sample are requested.",
			Category->"Storage & Handling"
		},
		TransportCondition->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[TransportCondition],
			Description->"Specifies how the this sample should be transported when in use in the lab.",
			Category->"Storage & Handling"
		},
		TransferTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Units->Celsius,
			Description->"The temperature that this sample should be at before any transfers using this sample occur.",
			Category->"Storage & Handling"
		},
		ThawTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 * Kelvin],
			Units->Celsius,
			Description->"The temperature that this sample should be thawed at before using in experimentation.",
			Category->"Storage & Handling"
		},
		ThawTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 * Second],
			Units->Minute,
			Description->"The time that this sample should be thawed before using in experimentation. If the samples are still not thawed after this time, thawing will continue until the samples are fully thawed.",
			Category->"Storage & Handling"
		},
		MaxThawTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Second],
			Units->Minute,
			Description->"The maximum time that samples of this model should be thawed before using in experimentation.",
			Category->"Storage & Handling"
		},
		ThawMixType->{
			Format->Single,
			Class->Expression,
			Pattern:>MixTypeP,
			Description->"The style of motion used to mix this sample following thawing.",
			Category->"Storage & Handling"
		},
		ThawMixRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*RPM],
			Units->RPM,
			Description->"The frequency of rotation the mixing instrument uses to mix this sample following thawing.",
			Category->"Storage & Handling"
		},
		ThawMixTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Minute],
			Units->Minute,
			Description-> "The duration for which this sample is mixed following thawing.",
			Category->"Storage & Handling",
			Abstract->True
		},
		ThawNumberOfMixes->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0],
			Units->None,
			Description->"The number of times this sample is mixed by inversion or pipetting up and down following thawing.",
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
			Description->"Indicates if this sample's container should have its cover sealed with parafilm when re-covered.",
			Category->"Storage & Handling"
		},
		AluminumFoil->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this sample's container should be wrapped in aluminum foil to protect the sample from light.",
			Category->"Storage & Handling"
		},
		TransportTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 * Kelvin],
			Units->Celsius,
			Description->"The temperature at which the sample should be incubated while transported between instruments during experimentation.",
			Category->"Storage & Handling"
		},
		AsepticTransportContainerType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AsepticTransportContainerTypeP,
			Description -> "Indicates how this sample is contained in an aseptic barrier and if it needs to be unbagged before being used in a protocol, maintenance, or qualification.",
			Category -> "Storage & Handling"
		},
		AsepticHandling -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if aseptic techniques are followed for handling this sample in lab. Aseptic techniques include sanitization, autoclaving, sterile filtration, or transferring in a biosafety cabinet during experimentation and storage.",
			Category -> "Storage & Handling"
		},
		CellPassageNumber -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of times the cell model in this sample has been subcultured from its original source. Each passage involves harvesting cells and reinoculating them into a new vessel. If the sample contains multiple cell models, this value reflects the maximum among their individual passage numbers. A record of passage number changes can be found in the CellPassageLog field.",
			Category -> "Sample History"
		},
		CellPassageLog -> {
			Format -> Multiple,
			Class -> {Expression, Link, Link, Integer, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link, GreaterEqualP[0], _Link},
			Relation -> {Null, Model[Cell], Object[Sample], Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Units -> {None, None, None, None, None},
			Description -> "A record of the subculture history of cell models in this sample. Each entry is a list that includes the date, the cell model, the immediate inoculation source sample from which this cell model was inoculated, the passage number, and the responsible protocol. Higher passage numbers indicate prolonged culturing, which can lead to passage-dependent drift (e.g., altered morphology, growth rate, gene expression, or stimulus response). SamplesOut from InoculateLiquidMedia, SpreadCells, StreakCells, and PickColonies will be logged with +1 in passage number. However, simply aliquoting by Transfer will not up the number, unless CountAsPassage is set to True.",
			Headers -> {"Date", "Cell Model", "Parent Cell Sample", "Passage Number", "Responsible Party"},
			Category -> "Sample History"
		},
			(* --- Inventory --- *)
		Product->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Product][Samples],
			Description->"Contains ordering and product information as well as shipping and receiving instructions for the sample.",
			Category->"Inventory"
		},
		Order->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Transaction, Order],
				Object[Transaction, DropShipping]
			],
			Description->"The transaction that generated this sample.",
			Category->"Inventory"
		},
		Source->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Transaction],
				Object[Protocol],
				Object[Protocol][PurchasedItems],
				Object[Qualification],
				Object[Qualification][PurchasedItems],
				Object[Maintenance],
				Object[Maintenance][PurchasedItems]
			],
			Description->"The transaction or protocol that is responsible for generating this sample.",
			Category->"Inventory"
		},
		ConcentratedBufferDiluent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample],
			Description->"The buffer that is used to dilute the sample by ConcentratedBufferDilutionFactor to prepare a sample in the BaselineStock solvent.",
			Category->"Inventory"
		},
		ConcentratedBufferDilutionFactor->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0],
			Units->None,
			Description-> "The amount by which this the sample must be diluted with its ConcentratedBufferDiluent in order to prepare the sample in the BaslineStock solvent.",
			Category->"Inventory"
		},
		BaselineStock->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample],
			Description->"The model that when diluted with its ConcentratedBufferDilutionFactor by ConcentratedBufferDilutionFactor to prepare the sample in the equivalent 1X versions of the same buffer.",
			Category->"Inventory"
		},
		PipettingMethod->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Method,Pipetting],
			Description->"The pipetting parameters used to manipulate this sample; these parameters may be overridden by direct specification of pipetting parameters in manipulation primitives.",
			Category->"Inventory"
		},
		ReversePipetting->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if reverse pipetting technique should be used when transferring this sample via pipette. It is recommended to set ReversePipetting->True if this sample foams or forms bubbles easily.",
			Category->"Inventory"
		},
		PreparedAmounts->{
			Format->Multiple,
			Class->{Link, String, Real, Expression},
			Pattern:>{_Link, _String, GreaterP[0], _?UnitsQ},
			Relation->{Object[Sample], Null, Null, Null},
			Units->{None, None, None, None},
			Description->"Describes the measured weight of each solid component and the volume of each liquid component combined when this solution was initially prepared.",
			Headers-> {"Component","Component Name","Amount","Unit"},
			Category->"Inventory",
			Abstract->True
		},
		KitComponents->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample][KitComponents],
				Object[Item][KitComponents],
				Object[Container][KitComponents],
				Object[Part][KitComponents],
				Object[Plumbing][KitComponents],
				Object[Wiring][KitComponents],
				Object[Sensor][KitComponents]
			],
			Description->"All other samples that were received as part of the same kit as this sample.",
			Category->"Inventory"
		},
		Receiving->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Maintenance, ReceiveInventory][Items],
			Description->"The MaintenanceReceiveInventory in which this sample was received.",
			Category->"Inventory"
		},
		QCDocumentationFiles->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"PDFs of any QC documentation that arrived with the sample.",
			Category->"Inventory"
		},
		LabelImage->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"Image of the label of this sample.",
			Category->"Inventory"
		},
		BatchNumber->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"A identifier for the particular batch that this sample was created in.",
			Category->"Inventory"
		},
		DateStocked->{
			Format->Single,
			Class->Date,
			Pattern:>_?DateObjectQ,
			Description->"Date the sample was created or entered into Emerald's inventory system.",
			Category->"Inventory"
		},
		DateUnsealed->{
			Format->Single,
			Class->Date,
			Pattern:>_?DateObjectQ,
			Description->"Date the packaging on the sample was first opened in the lab.",
			Category->"Inventory"
		},
		DatePurchased->{
			Format->Single,
			Class->Date,
			Pattern:>_?DateObjectQ,
			Description->"Date ownership of this sample was transferred to the user.",
			Category->"Inventory"
		},
		DateDiscarded->{
			Format->Single,
			Class->Date,
			Pattern:>_?DateObjectQ,
			Description->"Date the sample was discarded into waste.",
			Category->"Inventory"
		},
		DateLastUsed->{
			Format->Single,
			Class->Date,
			Pattern:>_?DateObjectQ,
			Description->"Date this sample was last handled in any way.",
			Category->"Inventory"
		},
		ExpirationDate->{
			Format->Single,
			Class->Date,
			Pattern:>_?DateObjectQ,
			Description->"Date after which this sample is considered expired and users will be warned about using it in protocols.",
			Category->"Inventory"
		},

		(* --- Quality Assurance --- *)
		(* TODO: migrate Certificates field to Object[Batch] and link Object[Sample] to Object[Batch]*)
		Certificates -> {
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Report, Certificate, Analysis][MaterialCertified],
				Object[Report, Certificate, Analysis][MaterialsCertified],
				Object[Report, Certificate, Analysis][DownstreamSamplesCertified]
			],
			Description->"The quality assurance documentation and data for this sample or its components.",
			Category->"Quality Assurance"
		},

		(* --- Health & Safety --- *)
		Sterile->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates that this sample is presently considered free of both microbial contamination and any microbial cell samples. To preserve this sterile state, the sample is handled with aseptic techniques during experimentation and storage.",
			Category->"Health & Safety"
		},
		RNaseFree->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates that this sample is free of any RNases.",
			Category->"Health & Safety"
		},
		NucleicAcidFree->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if this sample is presently considered to be not contaminated with DNA and RNA.",
			Category->"Health & Safety"
		},
		PyrogenFree->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if this sample is presently considered to be not contaminated with endotoxin.",
			Category->"Health & Safety"
		},
		Radioactive->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if this sample emit substantial ionizing radiation.",
			Category->"Health & Safety"
		},
		Ventilated->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if this sample must be handled in a ventilated enclosures.",
			Category->"Health & Safety"
		},
		InertHandling->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if this sample must be handled in a glove box.",
			Category->"Health & Safety"
		},
		GloveBoxIncompatible->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if this sample cannot be used inside of the glove box due high volatility and/or detrimental reactivity with the catalyst in the glove box that is used to remove traces of water and oxygen. Sulfur and sulfur compounds (such as H2S, RSH, COS, SO2, SO3), halides, halogen (Freon), alcohols, hydrazine, phosphene, arsine, arsenate, mercury, and saturation with water may deactivate the catalyst.",
			Category->"Health & Safety"
		},
		GloveBoxBlowerIncompatible->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates that the glove box blower must be turned off to prevent damage to the catalyst in the glove box that is used to remove traces of water and oxygen when manipulating this sample inside of the glove box.",
			Category->"Health & Safety"
		},
		Flammable->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if this sample are easily set aflame under standard conditions.",
			Category->"Health & Safety"
		},
		Acid->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if this sample are strong acids (pH <= 2) and require dedicated secondary containment during storage.",
			Category->"Health & Safety"
		},
		Base->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if this sample are strong bases (pH >= 12) and require dedicated secondary containment during storage.",
			Category->"Health & Safety"
		},
		Pyrophoric->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if this sample can ignite spontaneously upon exposure to air.",
			Category->"Health & Safety"
		},
		WaterReactive->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if this sample react spontaneously upon exposure to water.",
			Category->"Health & Safety"
		},
		Fuming->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if this sample emit fumes spontaneously when exposed to air.",
			Category->"Health & Safety"
		},
		Aqueous->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if this sample are a solution in water.",
			Category->"Health & Safety"
		},
		Anhydrous->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this sample does not contain water.",
			Category->"Health & Safety"
		},
		HazardousBan->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if this sample are currently banned from usage in the ECL because the facility isn't yet equiped to handle them.",
			Category->"Health & Safety"
		},
		ExpirationHazard->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this sample become hazardous once they are expired and therefore must be automatically disposed of when they pass their expiration date.",
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
			Description->"Indicates if this sample may be safely disposed down a standard drain.",
			Category->"Health & Safety"
		},
		Pungent->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this sample have a strong odor.",
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
			Description -> "Indicates if working with this molecule requires to wear two pairs of gloves.",
			Category -> "Health & Safety",
			Developer -> True
		},

		AutoclaveUnsafe->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this sample cannot be safely autoclaved.",
			Category->"Health & Safety"
		},

		(* --- Compatibility --- *)
		IncompatibleMaterials->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MaterialP | None,
			Description->"A list of materials that would be damaged if wetted by this sample.",
			Category->"Compatibility"
		},
		WettedMaterials->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MaterialP,
			Category->"Compatibility",
			Description->"The materials of which this sample is made that may come in direct contact with fluids."
		},
		LiquidHandlerIncompatible->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if this sample cannot be reliably aspirated or dispensed on an automated liquid handling robot.",
			Category->"Compatibility"
		},
		UltrasonicIncompatible->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if volume measurements of this sample cannot be performed via the ultrasonic distance method due to vapors interfering with the reading.",
			Category->"Compatibility"
		},

		(* --- Qualifications & Maintenance --- *)
		QualificationFrequency->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Computables`Private`qualificationFrequency[Field[Model]]],
			Pattern:>{{ObjectReferenceP[Model[Qualification]], GreaterP[0 * Day] | Null}..},
			Description->"The Qualifications and their required frequencies.",
			Category->"Qualifications & Maintenance",
			Headers->{"Qualification Model", "Time Interval"}
		},
		RecentQualifications->{
			Format->Multiple,
			Class->{Expression, Link, Link},
			Pattern:>{_?DateObjectQ, _Link, _Link},
			Relation->{Null, Object[Qualification], Model[Qualification]},
			Description->"List of the most recent Qualifications run on this sample for each model Qualification in QualificationFrequency.",
			Category->"Qualifications & Maintenance",
			Headers->{"Date", "Qualification", "Qualification Model"},
			Abstract->True
		},
		QualificationLog->{
			Format->Multiple,
			Class->{Expression, Link, Link},
			Pattern:>{_?DateObjectQ, _Link, _Link},
			Relation->{Null, Object[Qualification], Model[Qualification]},
			Description->"List of all the Qualifications that target this sample and are not an unlisted protocol.",
			Category->"Qualifications & Maintenance",
			Headers->{"Date", "Qualification", "Qualification Model"},
			Developer->True
		},
		NextQualificationDate->{
			Format->Multiple,
			Class->{Link, Expression},
			Pattern:>{_Link, _?DateObjectQ},
			Relation->{Model[Qualification], Null},
			Description->"A list of the dates on which the next qualifications will be enqueued for this sample.",
			Headers->{"Qualification Model", "Date"},
			Category->"Qualifications & Maintenance",
			Developer->True
		},
		Qualified->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if this sample has passed its most recent qualification.",
			Category->"Qualifications & Maintenance",
			Developer->True
		},
		QualificationResultsLog->{
			Format->Multiple,
			Class->{
				Date->Date,
				Qualification->Link,
				Result->Expression
			},
			Pattern:>{
				Date->_?DateObjectQ,
				Qualification->_Link,
				Result->QualificationResultP
			},
			Relation->{
				Date->Null,
				Qualification->Object[Qualification],
				Result->Null
			},
			Headers->{
				Date->"Date Evaluated",
				Qualification->"Qualification",
				Result->"Result"
			},
			Description->"A record of the qualifications run on this sample and their results.",
			Category->"Qualifications & Maintenance"
		},
		QualificationExtensionLog->{
			Format->Multiple,
			Class->{Link, Expression, Expression, Link, Expression, String},
			Pattern:>{_Link, _?DateObjectQ, _?DateObjectQ, _Link, QualificationExtensionCategoryP, _String},
			Relation->{Model[Qualification], Null, Null, Object[User], Null, Null},
			Description->"A list of amendments made to the regular qualification schedule of this sample, and the reason for the deviation.",
			Category->"Qualifications & Maintenance",
			Headers->{"Qualification Model", "Original Due Date","Revised Due Date","Responsible Party","Extension Category","Extension Reason"}
		},
		MaintenanceFrequency->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Computables`Private`maintenanceFrequency[Field[Model]]],
			Pattern:>{{ObjectReferenceP[Model[Maintenance]], GreaterP[0 * Day] | Null}..},
			Description->"A list of the maintenances which are run on this sample and their required frequencies.",
			Category->"Qualifications & Maintenance",
			Headers->{"Maintenance Model", "Time Interval"}
		},
		RecentMaintenance->{
			Format->Multiple,
			Class->{Expression, Link, Link},
			Pattern:>{_?DateObjectQ, _Link, _Link},
			Relation->{Null, Object[Maintenance], Model[Maintenance]},
			Description->"List of the most recent maintenances run on this sample for each modelMaintenance in MaintenanceFrequency.",
			Category->"Qualifications & Maintenance",
			Headers->{"Date", "Maintenance", "Maintenance Model"},
			Abstract->True
		},
		MaintenanceLog->{
			Format->Multiple,
			Class->{Expression, Link, Link},
			Pattern:>{_?DateObjectQ, _Link, _Link},
			Relation->{Null, Object[Maintenance], Model[Maintenance]},
			Description->"List of all the maintenances that target this sample and are not an unlisted protocol.",
			Category->"Qualifications & Maintenance",
			Headers->{"Date", "Maintenance", "Maintenance Model"}
		},
		NextMaintenanceDate->{
			Format->Multiple,
			Class->{Link, Expression},
			Pattern:>{_Link, _?DateObjectQ},
			Relation->{Model[Maintenance], Null},
			Description->"A list of the dates on which the next maintenance runs will be enqueued for this sample.",
			Headers->{"Maintenance Model", "Date"},
			Category->"Qualifications & Maintenance",
			Developer->True
		},
		MaintenanceExtensionLog->{
			Format->Multiple,
			Class->{Link, Expression, Expression, Link, Expression, String},
			Pattern:>{_Link, _?DateObjectQ, _?DateObjectQ, _Link, MaintenanceExtensionCategoryP, _String},
			Relation->{Model[Maintenance], Null, Null, Object[User], Null, Null},
			Description->"A list of amendments made to the regular maintenance schedule of this sample, and the reason for the deviation.",
			Category->"Qualifications & Maintenance",
			Headers->{"Maintenance Model", "Original Due Date","Revised Due Date","Responsible Party","Extension Category","Extension Reason"}
		},

		(* --- Resources --- *)
		RequestedResources->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Resource, Sample][RequestedSample],
			Description->"The list of resource requests for this sample that have not yet been Fulfilled.",
			Category->"Resources",
			Developer->True
		},

		(* --- Migration Support --- *)
		LegacyType->{
			Format->Single,
			Class->Expression,
			Pattern:>Object[___] | Model[___],
			Description->"The pre-samplefest object type that this object was migrated from.",
			Category->"Migration Support",
			Developer->True
		},
		NewStickerPrinted->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if a new sticker with a hashphrase has been printed for this object and therefore the hashphrase should be shown in engine when scanning the object.",
			Category->"Migration Support",
			Developer->True
		},
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