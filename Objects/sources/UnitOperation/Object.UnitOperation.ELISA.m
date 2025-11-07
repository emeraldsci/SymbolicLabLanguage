(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation, ELISA], {
	Description -> "A detailed set of parameters that specifies the information of how to prepare and read ELISA plates in a larger protocol.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(*===General Information===*)
		SampleLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Model[Container],
				Object[Container]
			],
			Description -> "The sample(s) to be analyzed using ELISA for the detection and quantification of certain analytes such as peptides, proteins, antibodies and hormones during this unit operation.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The sample(s) to be analyzed using ELISA for the detection and quantification of certain analytes such as peptides, proteins, antibodies and hormones during this unit operation.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}] | _String},
			Description -> "The sample(s) to be analyzed using ELISA for the detection and quantification of certain analytes such as peptides, proteins, antibodies and hormones during this unit operation.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the label of the source sample that are used in the experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		SampleContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the label of the source container that are used in the experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		Method -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ELISAMethodP,
			Description -> "The format used for ELISA analysis in this unit operation.",
			Category -> "General"
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument, LiquidHandler], Object[Instrument, LiquidHandler]],
			Description -> "The instrument integrates a shaker, plate washer, and plate reader, and is used to dispense reagents into ELISAPlates and SampleAssemblyPlates and transfer them between modules during the unit operation.",
			Category -> "General"
		},
		DetectionMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AbsorbanceIntensity|FluorescenceIntensity|LuminescenceIntensity,
			Description -> "The type of detection method used to measure the signal generated from the enzyme substrate reaction to quantify the target analyte during this unit operation.",
			Category -> "General"
		},
		NumberOfReadings -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "Number of redundant readings taken by the detector to determine a single averaged absorbance, fluorescence or luminescence reading.",
			Category -> "General"
		},
		SampleAssemblyPlate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Plate], Object[Container, Plate]],
			Description -> "The desired plate model used to dilute samples, standards, spiking samples, mixing samples and antibodies, and antibody-sample complex incubation before loading them onto ELISAPlate(s).",
			Category -> "General"
		},
		ELISAPlateLink -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Plate], Object[Container, Plate]],
			Description -> "The plate that serves as the solid-phase support for the enzyme-linked immunosorbent assay, where samples, standards, and blanks are loaded.",
			Category -> "General",
			Migration -> SplitField
		},
		ELISAPlateString -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The plate that serves as the solid-phase support for the enzyme-linked immunosorbent assay, where samples, standards, and blanks are loaded.",
			Category -> "General",
			Migration -> SplitField
		},
		ELISAPlateLabel -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "A user defined word or phrase used to identify the ELISAPlate that the input sample and other reagents that are transferred into and incubated and imaged to quantify the analytes, for use in downstream unit operations.",
			Category -> "General"
		},
		SecondaryELISAPlateLink -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Plate], Object[Container, Plate]],
			Description -> "The second plate that serves as the solid-phase support for the enzyme-linked immunosorbent assay, where samples, standards, and blanks are loaded.",
			Category -> "General",
			Migration -> SplitField
		},
		SecondaryELISAPlateString -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The second plate that serves as the solid-phase support for the enzyme-linked immunosorbent assay, where samples, standards, and blanks are loaded.",
			Category -> "General",
			Migration -> SplitField
		},
		SecondaryELISAPlateLabel -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "A user defined word or phrase used to identify the SecondaryELISAPlate that the input sample and other reagents that are transferred into and incubated and imaged to quantify the analytes, for use in downstream unit operations.",
			Category -> "General"
		},
		TertiaryELISAPlateLink -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Plate], Object[Container, Plate]],
			Description -> "The third plate that serves as the solid-phase support for the enzyme-linked immunosorbent assay, where samples, standards, and blanks are loaded.",
			Category -> "General",
			Migration -> SplitField
		},
		TertiaryELISAPlateString -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The third plate that serves as the solid-phase support for the enzyme-linked immunosorbent assay, where samples, standards, and blanks are loaded.",
			Category -> "General",
			Migration -> SplitField
		},
		TertiaryELISAPlateLabel -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "A user defined word or phrase used to identify the TertiaryELISAPlate that the input sample and other reagents that are transferred into and incubated and imaged to quantify the analytes, for use in downstream unit operations.",
			Category -> "General"
		},
		TargetAntigen -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[Model[Molecule]],
			Relation -> Model[Molecule],
			Description -> "For each member of SampleLink, the analyte molecule (e.g., peptide, protein, and hormone) detected and quantified in this unit operation.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		(*===Sample Assembly===*)
		Spike -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of SampleLink, the additional sample with a known concentration of analyte to be mixed with the input sample to perform a spike-and-recovery assessment.",
			Category -> "Sample Preparation",
			IndexMatching -> SampleLink
		},
		SpikeDilutionFactor -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0, 1],
			Description -> "For each member of SampleLink, the ratio of dilution by which the Spike is mixed with the input sample before further dilution is performed, calculated as the volume of the Spike divided by the total final volume consisting of both the Spike and the input Sample (undiluted).",
			Category -> "Sample Preparation",
			IndexMatching -> SampleLink
		},
		SampleDiluent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "The buffer used to dilute samples (either neat samples or spiked samples) to appropriate concentrations for the assay.",
			Category -> "Sample Preparation"
		},
		SampleVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of SampleLink, the amount of Sample that is dispensed into the SampleAssemblyPlate(s) in order to form Sample-Antibody complex when Method is FastELISA.",
			Category -> "Sample Preparation",
			IndexMatching -> SampleLink
		},
		SampleCoatingVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of SampleLink, the amount of Sample that is dispensed into the assay plate(s), in order for the Sample to be adsorbed to the surface of the assay plate(s).",
			Category -> "Sample Preparation",
			IndexMatching -> SampleLink
		},
		SampleImmunosorbentVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of SampleLink, the volume of the Sample to be loaded on the assay plate(s) for the TargetAntigen to bind to the CaptureAntibody in DirectSandwichELISA and IndirectSandwichELISA methods.",
			Category -> "Sample Preparation",
			IndexMatching -> SampleLink
		},
		(*===Coating Antibody===*)
		CoatingAntibody -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of SampleLink, the antibody to be immobilized on the surface of the ELISA plate(s) to capture the TargetAntigen during the assay in FastELISA method.",
			Category -> "Antibody Antigen Preparation",
			IndexMatching -> SampleLink
		},
		CoatingAntibodyDilutionFactor -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0, 1],
			Description -> "For each member of SampleLink, the dilution ratio of CoatingAntibody, calculated as the volume of the CoatingAntibody divided by the total final volume consisting of both the CoatingAntibody and CoatingAntibodyDiluent.",
			Category -> "Antibody Antigen Preparation",
			IndexMatching -> SampleLink
		},
		CoatingAntibodyVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of SampleLink, the volume of undiluted CoatingAntibody added into the corresponding well of the assay plate(s).",
			Category -> "Antibody Antigen Preparation",
			IndexMatching -> SampleLink
		},
		CoatingAntibodyCoatingVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of SampleLink, the amount of CoatingAntibody (either diluted or undiluted) that is dispensed into the assay plate(s), in order for the CoatingAntibody to be adsorbed to the surface of the well.",
			Category -> "Antibody Antigen Preparation",
			IndexMatching -> SampleLink
		},
		CoatingAntibodyDiluent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "The buffer used to dilute coating antibodies to appropriate concentrations for the assay before plate coating.",
			Category -> "Antibody Antigen Preparation"
		},
		(*===Capture Antibody===*)
		CaptureAntibody -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of SampleLink, the antibody that is used to pull down the TargetAntigen from sample solution to the surface of the assay plate(s) in DirectSandwichELISA, IndirectSandwichELISA, and FastELISA methods.",
			Category -> "Antibody Antigen Preparation",
			IndexMatching -> SampleLink
		},
		CaptureAntibodyDilutionFactor -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0, 1],
			Description -> "For each member of SampleLink, the ratio of dilution of CaptureAntibody, calculated as the volume of the CaptureAntibody divided by the total final volume consisting of both the CaptureAntibody and either CaptureAntibodyDiluent or Sample.",
			Category -> "Antibody Antigen Preparation",
			IndexMatching -> SampleLink
		},
		CaptureAntibodyVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of SampleLink, the volume of undiluted CaptureAntibody directly added into the corresponding well of the assay plate(s) when Method is DirectSandwichELISA or IndirectSandwichELISA, or the volume of diluted CaptureAntibody directly added into the corresponding well of the SampleAssemblyPlate(s) to form Sample-Antibody complex when Method is FastELISA.",
			Category -> "Antibody Antigen Preparation",
			IndexMatching -> SampleLink
		},
		CaptureAntibodyCoatingVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of SampleLink, the amount of CaptureAntibody that is dispensed into the assay plate(s), in order for the CaptureAntibody to be adsorbed to the surface of the well when Method is DirectSandwichELISA or IndirectSandwichELISA.",
			Category -> "Coating",
			IndexMatching -> SampleLink
		},
		CaptureAntibodyDiluent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "The buffer used to dilute CaptureAntibodies to appropriate concentrations for the assay before plate coating when Method is DirectSandwichELISA or IndirectSandwichELISA or binding to TargetAntigen in samples when Method is FastELISA.",
			Category -> "Antibody Antigen Preparation"
		},
		(*===Reference Antigen===*)
		ReferenceAntigen -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of SampleLink, the antigen that competes with sample for the binding of the PrimaryAntibody when Method is DirectCompetitiveELISA or IndirectCompetitiveELISA.",
			Category -> "Antibody Antigen Preparation",
			IndexMatching -> SampleLink
		},
		ReferenceAntigenDilutionFactor -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0, 1],
			Description -> "For each member of SampleLink, the ratio of dilution of ReferenceAntigen, calculated as the volume of the ReferenceAntigen divided by the total final volume consisting of both the ReferenceAntigen and ReferenceAntigenDiluent.",
			Category -> "Antibody Antigen Preparation",
			IndexMatching -> SampleLink
		},
		ReferenceAntigenVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of SampleLink, the volume of undiluted ReferenceAntigen added into the corresponding well of the assay plate(s).",
			Category -> "Antibody Antigen Preparation",
			IndexMatching -> SampleLink
		},
		ReferenceAntigenCoatingVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of SampleLink, the amount of diluted ReferenceAntigen that is dispensed into the assay plate(s), in order for the ReferenceAntigen to be adsorbed to the surface of the well.",
			Category -> "Antibody Antigen Preparation",
			IndexMatching -> SampleLink
		},
		ReferenceAntigenDiluent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "The buffer used to dilute the ReferenceAntigen to appropriate concentrations for the assay before plate coating.",
			Category -> "Antibody Antigen Preparation"
		},
		(*===Primary Antibody===*)
		PrimaryAntibody -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of SampleLink, the antibody that directly binds to the TargetAntigen.",
			Category -> "Antibody Antigen Preparation",
			IndexMatching -> SampleLink
		},
		PrimaryAntibodyDilutionFactor -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0, 1],
			Description -> "For each member of SampleLink, the ratio of dilution of PrimaryAntibody, calculated as the volume of the PrimaryAntibody divided by the total final volume consisting of both the PrimaryAntibody and either PrimaryAntibodyDiluent or Sample.",
			Category -> "Antibody Antigen Preparation",
			IndexMatching -> SampleLink
		},
		PrimaryAntibodyVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of SampleLink, the volume of undiluted PrimaryAntibody added into the corresponding well of the assay plate(s) when Method is DirectELISA, IndirectELISA, DirectSandwichELISA, and IndirectSandwichELISA, or the volume of diluted PrimaryAntibody directly added into the corresponding well of the SampleAssemblyPlate(s) to form Sample-Antibody complex when Method is DirectCompetitiveELISA, IndirectCompetitiveELISA, and FastELISA.",
			Category -> "Antibody Antigen Preparation",
			IndexMatching -> SampleLink
		},
		PrimaryAntibodyImmunosorbentVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of SampleLink, the volume of the PrimaryAntibody to be loaded on the assay plate(s) for Immunosorbent step when Method is DirectELISA, IndirectELISA, DirectSandwichELISA, and IndirectSandwichELISA.",
			Category -> "Antibody Antigen Preparation",
			IndexMatching -> SampleLink
		},
		PrimaryAntibodyDiluent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "The buffer used to dilute PrimaryAntibodies to their working concentration before they are added to the assay plate(s).",
			Category -> "Antibody Antigen Preparation"
		},
		(*===Secondary Antibody===*)
		SecondaryAntibody -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of SampleLink, the antibody that binds to the PrimaryAntibody.",
			Category -> "Antibody Antigen Preparation",
			IndexMatching -> SampleLink
		},
		SecondaryAntibodyDilutionFactor -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0, 1],
			Description -> "For each member of SampleLink, the ratio of dilution of SecondaryAntibody, calculated as the volume of the SecondaryAntibody divided by the total final volume consisting of both the SecondaryAntibody and SecondaryAntibodyDiluent.",
			Category -> "Antibody Antigen Preparation",
			IndexMatching -> SampleLink
		},
		SecondaryAntibodyVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of SampleLink, the volume of undiluted SecondaryAntibody added into the corresponding well of the assay plate(s).",
			Category -> "Antibody Antigen Preparation",
			IndexMatching -> SampleLink
		},
		SecondaryAntibodyImmunosorbentVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of SampleLink, the volume of SecondaryAntibody to be loaded on the assay plate(s) for Immunosorbent assay.",
			Category -> "Antibody Antigen Preparation",
			IndexMatching -> SampleLink
		},
		SecondaryAntibodyDiluent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "The buffer used to dilute SecondaryAntibodies to their working concentrations before they are added to the assay plate(s).",
			Category -> "Antibody Antigen Preparation"
		},
		(*==========EXPERIMENTAL PROCEDURE===============*)
		WashingBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "The solution used to rinse off unbound molecules from the assay plate(s).",
			Category -> "General"
		},
		WashPlateMethod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[Object[Method, WashPlate]],
			Relation -> Alternatives[Object[Method, WashPlate]],
			Description -> "The file containing a set of parameters define how the plate washer aspirates, dispenses, and manages liquid flow during ELISA washing steps, including speeds, heights, delays, and positioning for optimal washing efficiency.",
			Category -> "Washing"
		},
		(*==========Antibody Complex Incubation==============*)
		SampleAntibodyComplexIncubation -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Specifies whether the pre-mixed samples and antibodies in the SampleAssemblyPlate(s) undergo an incubation step to facilitate the formation of the sample–antibody complex prior to transfer into the assay plate(s).",
			Category -> "Sample Antibody Complex Incubation"
		},
		SampleAntibodyComplexIncubationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Hour],
			Units -> Hour,
			Description -> "The incubation duration of pre-mixed samples and antibodies during SampleAntibodyComplexIncubation.",
			Category -> "Sample Antibody Complex Incubation"
		},
		SampleAntibodyComplexIncubationTemperatureExpression -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Ambient],
			Description -> "The temperature at which the pre-mixed samples and antibodies are incubated during SampleAntibodyComplexIncubation.",
			Category -> "Sample Antibody Complex Incubation",
			Migration -> SplitField
		},
		SampleAntibodyComplexIncubationTemperatureReal -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the pre-mixed samples and antibodies are incubated during SampleAntibodyComplexIncubation.",
			Category -> "Sample Antibody Complex Incubation",
			Migration -> SplitField
		},
		SampleAntibodyComplexIncubationMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The speed at which the SampleAssemblyPlate(s) containing the pre-mixed samples and antibodies is shaken (orbitally, at a radius of 2 mm) during SampleAntibodyComplexIncubation.",
			Category -> "Sample Antibody Complex Incubation"
		},
		(*============Coating==============*)
		Coating -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if Coating is required. Coating is a procedure to immobilize analytes (usually antigens and antibodies) to the surface of the assay plate(s) non-specifically.",
			Category -> "General"
		},
		CoatingTemperatureExpression -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Ambient],
			Description -> "The temperature at which the assay plate(s) are kept during coating, in order for the analytes to be adsorbed to the surface of the assay plate(s).",
			Category -> "Coating",
			Migration -> SplitField
		},
		CoatingTemperatureReal -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the assay plate(s) are kept during coating, in order for the analytes to be adsorbed to the surface of the assay plate(s).",
			Category -> "Coating",
			Migration -> SplitField
		},
		CoatingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Hour],
			Units -> Hour,
			Description -> "The duration for coating step.",
			Category -> "Coating"
		},
		CoatingWashVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume of WashBuffer added to rinse off unbound coating analytes from the assay plate(s) per well.",
			Category -> "Coating"
		},
		CoatingNumberOfWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of washes performed to rinse off unbound coating analytes. Each wash cycle first aspirates from, and then dispenses WashBuffer to, the assay plate(s).",
			Category -> "Coating"
		},
		MoatVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume which each moat is filled with in order to slow evaporation of inner assay samples during the coating step.",
			Category -> "Coating"
		},
		MoatBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The sample each moat well is filled with in order to slow evaporation of inner assay samples during the coating step.",
			Category -> "Coating"
		},
		MoatSize -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The depth the moat extends into the assay plate. For example, if MoatSize is 1, the first available well for sample is B2.",
			Category -> "Coating"
		},
		(*============Blocking==============*)
		Blocking -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if a protein solution should be incubated with the assay plate to prevent non-specific binding of molecules to the assay plate.",
			Category -> "Blocking"
		},
		BlockingBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "The solution used to prevent non-specific binding of antigen or antibody to the surface of the assay plate.",
			Category -> "Blocking"
		},
		BlockingVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of SampleLink, the amount of BlockingBuffer that is dispensed into the corresponding wells of the assay plate(s), in order to prevent non-specific binding.",
			Category -> "Blocking",
			IndexMatching -> SampleLink
		},
		BlockingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Hour],
			Units -> Hour,
			Description -> "The blocking duration when the BlockingBuffer is kept with the assay plate(s), in order to prevent non-specific binding of molecules to the assay plate.",
			Category -> "Blocking"
		},
		BlockingTemperatureExpression -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Ambient],
			Description -> "The temperature at which the assay plate(s) are kept during blocking, in order for the blocking analytes to be adsorbed to the unoccupied sites of the assay plate(s).",
			Category -> "Blocking",
			Migration -> SplitField
		},
		BlockingTemperatureReal -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the assay plate(s) are kept during blocking, in order for the blocking analytes to be adsorbed to the unoccupied sites of the assay plate(s).",
			Category -> "Blocking",
			Migration -> SplitField
		},
		BlockingMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The speed at which the plate is shaken (orbitally, at a radius of 2 mm) during blocking.",
			Category -> "Blocking"
		},
		BlockingWashVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume of WashBuffer added to rinse off the unbound blocking reagents from the assay plate(s).",
			Category -> "Blocking"
		},
		BlockingNumberOfWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of washes performed to rinse off unbound blocking reagents.",
			Category -> "Blocking"
		},
		(*Immunosorbent Step*)
		SampleAntibodyComplexImmunosorbentVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of SampleLink, the volume of the SampleAntibodyComplex to be loaded on the ELISAPlate. In DirectCompetitiveELISA and IndirectCompetitiveELISA, this step enables the free primary antibody to bind to the ReferenceAntigen coated on the plate. In FastELISA, this step enables the PrimaryAntibody-TargetAntigen-CaptureAntibody complex to bind to the CoatingAntibody on the plate.",
			Category -> "Immunosorbent Step",
			IndexMatching -> SampleLink
		},
		SampleAntibodyComplexImmunosorbentTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Hour],
			Units -> Hour,
			Description -> "The duration for which the sample-antibody complex is allowed to adsorb onto the assay plate(s).",
			Category -> "Immunosorbent Step"
		},
		SampleAntibodyComplexImmunosorbentTemperatureExpression -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Ambient],
			Description -> "The temperature at which the assay plate(s) are kept during SampleAntibodyComplexImmunosorbent step.",
			Category -> "Immunosorbent Step",
			Migration -> SplitField
		},
		SampleAntibodyComplexImmunosorbentTemperatureReal -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the assay plate(s) are kept during SampleAntibodyComplexImmunosorbent step.",
			Category -> "Immunosorbent Step",
			Migration -> SplitField
		},
		SampleAntibodyComplexImmunosorbentMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The speed at which the assay plate(s) are shaken (orbitally, at a radius of 2 mm) during SampleAntibodyComplexImmunosorbent step.",
			Category -> "Immunosorbent Step"
		},
		SampleAntibodyComplexImmunosorbentWashVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume of WashBuffer added to rinse off the unbound PrimaryAntibody after SampleAntibodyComplexImmunosorbent step.",
			Category -> "Immunosorbent Step"
		},
		SampleAntibodyComplexImmunosorbentNumberOfWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of rinses performed after SampleAntibodyComplexImmunosorbent step.",
			Category -> "Immunosorbent Step"
		},
		SampleImmunosorbentTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Hour],
			Units -> Hour,
			Description -> "The duration for which the samples are allowed to adsorb onto the assay plate(s) in DirectSandwichELISA and IndirectSandwichELISA.",
			Category -> "Immunosorbent Step"
		},
		SampleImmunosorbentTemperatureExpression -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Ambient],
			Description -> "The temperature at which the assay plate(s) are kept during SampleImmunosorbent step.",
			Category -> "Immunosorbent Step",
			Migration -> SplitField
		},
		SampleImmunosorbentTemperatureReal -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the assay plate(s) are kept during SampleImmunosorbent step.",
			Category -> "Immunosorbent Step",
			Migration -> SplitField
		},
		SampleImmunosorbentMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The speed at which the assay plate(s) are shaken (orbitally, at a radius of 2 mm) during SampleImmunosorbent step.",
			Category -> "Immunosorbent Step"
		},
		SampleImmunosorbentWashVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume of WashBuffer added to rinse off the unbound Samples after SampleImmunosorbent step.",
			Category -> "Immunosorbent Step"
		},
		SampleImmunosorbentNumberOfWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of rinses performed to rinse off the unbound Samples after SampleImmunosorbent step.",
			Category -> "Immunosorbent Step"
		},
		PrimaryAntibodyImmunosorbentTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Hour],
			Units -> Hour,
			Description -> "The duration for which the PrimaryAntibodies are allowed to adsorb onto the assay plate(s) for DirectELISA, IndirectELISA, DirectSandwichELISA, or IndirectSandwichELISA.",
			Category -> "Immunosorbent Step"
		},
		PrimaryAntibodyImmunosorbentTemperatureExpression -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Ambient],
			Description -> "The temperature at which the assay plate(s) are kept during PrimaryAntibodyImmunosorbent incubation.",
			Category -> "Immunosorbent Step",
			Migration -> SplitField
		},
		PrimaryAntibodyImmunosorbentTemperatureReal -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the assay plate(s) are kept during PrimaryAntibodyImmunosorbent incubation.",
			Category -> "Immunosorbent Step",
			Migration -> SplitField
		},
		PrimaryAntibodyImmunosorbentMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The speed at which the assay plate(s) are shaken (orbitally, at a radius of 2 mm) during PrimaryAntibodyImmunosorbent incubation.",
			Category -> "Immunosorbent Step"
		},
		PrimaryAntibodyImmunosorbentWashVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume of WashBuffer added to rinse off the unbound PrimaryAntibody after PrimaryAntibody incubation.",
			Category -> "Immunosorbent Step"
		},
		PrimaryAntibodyImmunosorbentNumberOfWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of rinses performed to rinse off the unbound PrimaryAntibody after PrimaryAntibody incubation.",
			Category -> "Immunosorbent Step"
		},
		SecondaryAntibodyImmunosorbentTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Hour],
			Units -> Hour,
			Description -> "The duration for which the SecondaryAntibodies are allowed to adsorb onto the assay plate(s) for IndirectELISA, IndirectSandwichELISA, and IndirectCompetitiveELISA.",
			Category -> "Immunosorbent Step"
		},
		SecondaryAntibodyImmunosorbentTemperatureExpression -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Ambient],
			Description -> "The temperature at which the assay plate(s) are kept during SecondaryAntibodyImmunosorbent incubation.",
			Category -> "Immunosorbent Step",
			Migration -> SplitField
		},
		SecondaryAntibodyImmunosorbentTemperatureReal -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the assay plate(s) are kept during SecondaryAntibodyImmunosorbent incubation.",
			Category -> "Immunosorbent Step",
			Migration -> SplitField
		},
		SecondaryAntibodyImmunosorbentMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The speed at which the assay plate(s) are shaken (orbitally, at a radius of 2 mm) during SecondaryAntibodyImmunosorbent incubation.",
			Category -> "Immunosorbent Step"
		},
		SecondaryAntibodyImmunosorbentWashVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume of WashBuffer added per wash cycle to rinse off the unbound Secondary antibody after SecondaryAntibodyImmunosorbent incubation.",
			Category -> "Immunosorbent Step"
		},
		SecondaryAntibodyImmunosorbentNumberOfWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of rinses performed to rinse off the unbound SecondaryAntibody from assay plate(s) after SecondaryAntibodyImmunosorbent incubation.",
			Category -> "Immunosorbent Step"
		},
		(*===Detection===*)
		SubstrateSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "The solution containing a chromogenic, fluorogenic, or chemiluminescent reagent that reacts with the enzyme conjugated to the detection antibody (or other enzyme label) to produce a measurable signal.",
			Category -> "Detection"
		},
		SecondarySubstrateSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "The solution containing an enhancer or activator that optimizes or initiates the reaction of SubstrateSolution when the two are mixed together.",
			Category -> "Detection"
		},
		PreMixSubstrateSolution -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Whether the SubstrateSolution and SecondarySubstrateSolution are mixed prior to being added to the assay plate(s).",
			Category -> "Detection"
		},
		SubstrateSolutionMixRatio -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Description -> "The volume ratio of SubstrateSolution to SecondarySubstrateSolution.",
			Category -> "Detection"
		},
		SubstrateSolutionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume of the working SubstrateSolution (pre-mixed according to the SubstrateSolutionMixRatio if a SecondarySubstrateSolution is specified) to be added to the assay plate(s).",
			Category -> "Detection"
		},
		SubstrateIncubationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Hour],
			Units -> Hour,
			Description -> "The time allowed for the enzyme substrate reaction to occur in the assay plate(s) before the reaction is stopped or measured.",
			Category -> "Detection"
		},
		SubstrateIncubationTemperatureExpression -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Ambient],
			Description -> "The temperature at which the assay plate(s) are kept during SubstrateIncubation, in order for the detection reagent to react with antibody-conjugated enzyme.",
			Category -> "Detection",
			Migration -> SplitField
		},
		SubstrateIncubationTemperatureReal -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the assay plate(s) are kept during SubstrateIncubation, in order for the detection reagent to react with antibody-conjugated enzyme.",
			Category -> "Detection",
			Migration -> SplitField
		},
		SubstrateIncubationMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The speed at which the assay plate(s) are shaken (orbitally, at a radius of 2 mm) during SubstrateIncubation.",
			Category -> "Detection"
		},
		StopSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "The reagent that is used to stop colorimetric reaction between the enzyme and its substrate.",
			Category -> "Detection"
		},
		StopSolutionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume of StopSolution to be added to the assay plate(s).",
			Category -> "Detection"
		},
		DetectionWashing -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if an initial washing step is added to detection step before adding SubstrateSolution.",
			Category -> "Detection"
		},
		DetectionWashingBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "The solution used to wash assay plate(s) prior to adding SubstrateSolution.",
			Category -> "Detection"
		},
		DetectionWashVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume of DetectionWashingBuffer added per wash cycle per well to the assay plate(s).",
			Category -> "Detection"
		},
		DetectionNumberOfWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of washes performed for DetectionWashing.",
			Category -> "Detection"
		},
		RetainCover -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the lid(s) on the assay plate(s) should not be taken off during measurement to decrease evaporation.",
			Category -> "Detection"
		},
		AbsorbanceWavelength -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ListableP[GreaterP[0 Nanometer]],
			Description -> "The wavelength used to detect the absorbance of light by the product of the detection reaction.",
			Category -> "Detection"
		},
		PrereadBeforeStop -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicate if colorimetric reactions between the enzyme and its substrate will be checked by the plate reader before the StopSolution is added to terminate the reaction.",
			Category -> "Detection"
		},
		PrereadTimepoints -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			Description -> "The list of time points when the absorbance intensities were recorded at PrereadAbsorbanceWavelengths during the preread process.",
			Category -> "Detection"
		},
		PrereadAbsorbanceWavelength -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ListableP[GreaterP[0 Nanometer]],
			Description -> "The wavelength used to detect the absorbance of light produced by colorimetric reaction before the sample is quenched by the StopSolution.",
			Category -> "Detection"
		},
		SignalCorrection -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if an absorbance reading that is used to eliminate the interference of background absorbance (such as from ELISAPlate material and dust) is used.",
			Category -> "Detection"
		},
		SignalCorrectionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Nanometer],
			Units -> Nanometer,
			Description -> "The wavelength for absorbance reading that is used to eliminate the interference of background absorbance.",
			Category -> "Detection"
		},
		WavelengthSelection -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WavelengthSelectionP,
			Description -> "The method used to obtain the emission and excitation wavelengths.",
			Category -> "Detection"
		},
		ReadLocation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReadLocationP,
			Description -> "Indicates if the plate will be illuminated and read from top or bottom.",
			Category -> "Detection"
		},
		EmissionWavelengthReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Nanometer],
			Units -> Nanometer,
			Description->"The wavelength(s) at which fluorescence/luminescence emitted from the sample should be measured.",
			Category -> "Detection",
			Migration -> SplitField
		},
		EmissionWavelengthExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[NoFilter],
			Description -> "The wavelength(s) at which fluorescence/luminescence emitted from the sample should be measured.",
			Category -> "Detection",
			Migration -> SplitField
		},
		AdjustmentSample -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[FullPlate],
			Description -> "For each member of EmissionWavelengthReal, the sample used to determine the gain percentage and focal height adjustments.",
			Category -> "Detection",
			IndexMatching -> EmissionWavelengthReal
		},
		FocalHeightReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Meter],
			Units -> Millimeter,
			Description -> "For each member of EmissionWavelengthReal, the height above the assay plates from which the readings are made.",
			Migration -> SplitField,
			Category -> "Detection",
			IndexMatching -> EmissionWavelengthReal
		},
		FocalHeightExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Auto],
			Description -> "For each member of EmissionWavelengthReal, the height above the assay plates from which the readings are made.",
			Migration -> SplitField,
			Category -> "Detection",
			IndexMatching -> EmissionWavelengthReal
		},
		ExcitationWavelength -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Nanometer],
			Units -> Nanometer,
			Description -> "For each member of EmissionWavelengthReal, the wavelengths of light used to excite the samples.",
			Category -> "Detection",
			IndexMatching -> EmissionWavelengthReal
		},
		Gain -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Percent],
			Units -> Percent,
			Description -> "For each member of EmissionWavelengthReal, the voltage set on the PMT (photomultiplier tube) detector to amplify the detected signal during the luminescence measurement at this wavelength.",
			IndexMatching -> EmissionWavelengthReal,
			Category -> "Detection"
		},
		DualEmissionWavelength -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Nanometer],
			Units -> Nanometer,
			Description -> "For each member of EmissionWavelengthReal, the wavelength at which fluorescence emitted from the sample should be measured with the secondary detector (simultaneous to the measurement at the emission wavelength done by the primary detector).",
			IndexMatching -> EmissionWavelengthReal,
			Category -> "Fluorescence Measurement"
		},
		DualEmissionGain -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Percent],
			Units -> Percent,
			Description -> "For each member of EmissionWavelengthReal, the voltage set on the PMT (photomultiplier tube) detector to amplify the detected signal during the luminescence measurement at this wavelength.",
			IndexMatching -> EmissionWavelengthReal,
			Category -> "Detection"
		},
		FocalHeight -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "For each member of EmissionWavelengthReal, indicate the distance from the bottom of the plate carrier to the focal point where light from the sample is directed onto the detector.",
			Category -> "Detection",
			IndexMatching -> EmissionWavelengthReal
		},
		IntegrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Second,
			Description -> "The amount of time over which luminescence measurements should be integrated.",
			Category -> "Detection"
		},
		(*==============STANDARD OPTIONS=================*)
		Standard -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "The samples containing known amount of TargetAntigen molecule. Standard is used for the quantification of Standard analyte.",
			Category -> "Standard"
		},
		StandardTargetAntigen -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[Model[Molecule]],
			Relation -> Model[Molecule],
			Description -> "For each member of Standard, the analyte molecule(e.g., peptide, protein, and hormone) detected and quantified in the Standard samples by antibodies in the ELISA experiment.",
			Category -> "Standard",
			IndexMatching -> Standard
		},
		StandardDiluent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "The buffer used to perform multiple dilutions on Standard to appropriate concentrations.",
			Category -> "Standard"
		},
		StandardCoatingVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of Standard, the amount of Standard that is dispensed into the ELISAPlate(s), in order for the Standard to be adsorbed to the surface of the well.",
			Category -> "Standard",
			IndexMatching -> Standard
		},
		StandardImmunosorbentVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of Standard, the volume of the Standard to be loaded on the ELISAPlate for the target antigen to bind to the capture antibody in DirectSandwichELISA and IndirectSandwichELISA.",
			Category -> "Standard",
			IndexMatching -> Standard
		},
		StandardCoatingAntibody -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of Standard, the antibody to be immobilized on the surface of the ELISA plate(s) to capture the StandardTargetAntigen during the assay for FastELISA method.",
			Category -> "Standard",
			IndexMatching -> Standard
		},
		StandardCoatingAntibodyDilutionFactor -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0, 1],
			Description -> "For each member of Standard, the ratio of dilution of StandardCoatingAntibody, calculated as the volume of the StandardCoatingAntibody divided by the total final volume consisting of both the StandardCoatingAntibody and CoatingAntibodyDiluent.",
			Category -> "Standard",
			IndexMatching -> Standard
		},
		StandardCoatingAntibodyVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of Standard, th volume of undiluted StandardCoatingAntibody directly added into the corresponding well of the assay plate(s).",
			Category -> "Standard",
			IndexMatching -> Standard
		},
		StandardCoatingAntibodyCoatingVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of Standard, the amount of StandardCoatingAntibody (either diluted or undiluted) that is dispensed into the assay plate(s), in order for the StandardCoatingAntibody to be adsorbed to the surface of the well.",
			Category -> "Standard",
			IndexMatching -> Standard
		},
		StandardCaptureAntibody -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of Standard, the antibody that is used to pull down the StandardTargetAntigen from standard solution to the the surface of the assay plate(s) in DirectSandwichELISA, IndirectSandwichELISA, and FastELISA.",
			Category -> "Standard",
			IndexMatching -> Standard
		},
		StandardCaptureAntibodyDilutionFactor -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0, 1],
			Description -> "For each member of Standard, the ratio of dilution of StandardCaptureAntibody.",
			Category -> "Standard",
			IndexMatching -> Standard
		},
		StandardCaptureAntibodyVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of Standard, the volume of undiluted StandardCaptureAntibody added into the corresponding well of the assay plate(s) when Method is DirectSandwichELISA or IndirectSandwichELISA, or the volume of diluted StandardCaptureAntibody directly added into the corresponding well of the SampleAssemblyPlate(s) to form Sample-Antibody complex when Method is FastELISA.",
			Category -> "Standard",
			IndexMatching -> Standard
		},
		StandardCaptureAntibodyCoatingVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of Standard, the amount of StandardCaptureAntibody (either diluted or undiluted) that is dispensed into the assay plate(s), in order for the StandardCaptureAntibody to be adsorbed to the surface of the well.",
			Category -> "Coating",
			IndexMatching -> Standard
		},
		StandardReferenceAntigen -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of Standard, the antigen that competes with StandardTargetAntigen in the standard for the binding of the StandardPrimaryAntibody.",
			Category -> "Standard",
			IndexMatching -> Standard
		},
		StandardReferenceAntigenDilutionFactor -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0, 1],
			Description -> "For each member of Standard, the ratio of dilution of StandardReferenceAntigen.",
			Category -> "Standard",
			IndexMatching -> Standard
		},
		StandardReferenceAntigenVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of Standard, the StandardReferenceAntigen added into the corresponding well of the assay plate(s).",
			Category -> "Standard",
			IndexMatching -> Standard
		},
		StandardReferenceAntigenCoatingVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of Standard, the amount of StandardReferenceAntigen (either diluted or undiluted) that is dispensed into the assay plate(s), in order for the StandardReferenceAntigen to be adsorbed to the surface of the well.",
			Category -> "Standard",
			IndexMatching -> Standard
		},
		StandardPrimaryAntibody -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of Standard, the antibody that directly binds to the StandardTargetAntigen.",
			Category -> "Standard",
			IndexMatching -> Standard
		},
		StandardPrimaryAntibodyDilutionFactor -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0, 1],
			Description -> "For each member of Standard, the ratio of dilution of StandardPrimaryAntibody.",
			Category -> "Standard",
			IndexMatching -> Standard
		},
		StandardPrimaryAntibodyVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of Standard, the volume of undiluted StandardPrimaryAntibody added into the corresponding well of the assay plate(s) when Method is DirectELISA, IndirectELISA, DirectSandwichELISA, and IndirectSandwichELISA, or the volume of diluted StandardPrimaryAntibody directly added into the corresponding well of the SampleAssemblyPlate(s) to form Sample-Antibody complex when Method is DirectCompetitiveELISA, IndirectCompetitiveELISA, and FastELISA.",
			Category -> "Standard",
			IndexMatching -> Standard
		},
		StandardPrimaryAntibodyImmunosorbentVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of Standard, the volume of the StandardPrimaryAntibody (either diluted or undiluted) to be loaded on the assay plate(s) for the Immunosorbent step when Method is DirectELISA, IndirectELISA, DirectSandwichELISA, and IndirectSandwichELISA.",
			Category -> "Standard",
			IndexMatching -> Standard
		},
		StandardSecondaryAntibody -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of Standard, the antibody that binds to the StandardPrimaryAntibody rather than directly to the StandardTargetAntigen.",
			Category -> "Standard",
			IndexMatching -> Standard
		},
		StandardSecondaryAntibodyDilutionFactor -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0, 1],
			Description -> "For each member of Standard, the ratio of dilution of StandardSecondaryAntibody.",
			Category -> "Standard",
			IndexMatching -> Standard
		},
		StandardSecondaryAntibodyVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of Standard, the volume of StandardSecondaryAntibody (either diluted or undiluted) added into the corresponding well of the assay plate(s) for the immunosorbent step.",
			Category -> "Standard",
			IndexMatching -> Standard
		},
		StandardSecondaryAntibodyImmunosorbentVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of Standard, the volume of the StandardSecondaryAntibody (either diluted or undiluted) to be loaded on the assay plate(s) for the immunosorbent step.",
			Category -> "Standard",
			IndexMatching -> Standard
		},
		StandardBlockingVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of Standard, the amount of BlockingBuffer that is dispensed into the corresponding wells of the assay plate(s), in order to prevent non-specific binding.",
			Category -> "Standard",
			IndexMatching -> Standard
		},
		StandardAntibodyComplexImmunosorbentVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of Standard, the volume of the StandardAntibodyComplex to be loaded on the assay plate(s).",
			Category -> "Standard",
			IndexMatching -> Standard
		},
		(*================Blank ==================*)
		Blank -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "The solution containing no TargetAntigen, used as a baseline or negative control for the ELISA.",
			Category -> "Blank"
		},
		BlankTargetAntigen -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[Model[Molecule]],
			Relation -> Model[Molecule],
			Description -> "For each member of Blank, the analyte molecule(e.g., peptide, protein, and hormone) used in the blanks as baseline or negative control.",
			Category -> "Blank",
			IndexMatching -> Blank
		},
		BlankCoatingVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of Blank, the amount of Blank that is dispensed into the ELISAPlate(s), in order for the Blank to be adsorbed to the surface of the well.",
			Category -> "Blank",
			IndexMatching -> Blank
		},
		BlankImmunosorbentVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of Blank, the volume of the Blank to be loaded on the ELISAPlate(s) for the target antigen to bind to the capture antibody in DirectSandwichELISA and IndirectSandwichELISA.",
			Category -> "Blank",
			IndexMatching -> Blank
		},
		BlankCoatingAntibody -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of Blank, the antibody to be immobilized on the surface of the ELISA plate(s) to capture the BlankTargetAntigen during the assay.",
			Category -> "Blank",
			IndexMatching -> Blank
		},
		BlankCoatingAntibodyDilutionFactor -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0, 1],
			Description -> "For each member of Blank, the dilution ratio of BlankCoatingAntibody, calculated as the volume of the BlankCoatingAntibody divided by the total final volume consisting of both the BlankCoatingAntibody and CoatingAntibodyDiluent.",
			Category -> "Blank",
			IndexMatching -> Blank
		},
		BlankCoatingAntibodyVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of Blank, the volume of undiluted BlankCoatingAntibody directly added into the corresponding well of the assay plate(s).",
			Category -> "Blank",
			IndexMatching -> Blank
		},
		BlankCoatingAntibodyCoatingVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of Blank, the amount of BlankCoatingAntibody (either diluted or undiluted) that is dispensed into the assay plate(s), in order for the BlankCoatingAntibody to be adsorbed to the surface of the well.",
			Category -> "Blank",
			IndexMatching -> Blank
		},
		BlankCaptureAntibody -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of Blank, the antibody that is used to pull down the BlankTargetAntigen from blank solution to the surface of the assay plate(s) in DirectSandwichELISA, IndirectSandwichELISA, and FastELISA methods.",
			Category -> "Blank",
			IndexMatching -> Blank
		},
		BlankCaptureAntibodyDilutionFactor -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0, 1],
			Description -> "For each member of Blank, the dilution ratio of BlankCaptureAntibody. For DirectSandwichELISA and IndirectSandwichELISA, BlankCaptureAntibody is diluted with CaptureAntibodyDiluent.",
			Category -> "Blank",
			IndexMatching -> Blank
		},
		BlankCaptureAntibodyVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of Blank, the volume of undiluted BlankCaptureAntibody added into the corresponding well of the assay plate(s) when Method is DirectSandwichELISA or IndirectSandwichELISA, or the volume of diluted BlankCaptureAntibody directly added into the corresponding well of the SampleAssemblyPlate(s) to form Sample-Antibody complex when Method is FastELISA.",
			Category -> "Blank",
			IndexMatching -> Blank
		},
		BlankCaptureAntibodyCoatingVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of Blank, the amount of BlankCaptureAntibody (either diluted or undiluted) that is dispensed into the assay plate(s), in order for the BlankCaptureAntibody to be adsorbed to the surface of the well.",
			Category -> "Blank",
			IndexMatching -> Blank
		},
		BlankReferenceAntigen -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of Blank, the antigen that competes with BlankTargetAntigen in the blank for the binding of the BlankPrimaryAntibody.",
			Category -> "Blank",
			IndexMatching -> Blank
		},
		BlankReferenceAntigenDilutionFactor -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0, 1],
			Description -> "For each member of Blank, the dilution ratio of BlankReferenceAntigen.",
			Category -> "Blank",
			IndexMatching -> Blank
		},
		BlankReferenceAntigenVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of Blank, the volume of BlankReferenceAntigen added into the corresponding well of the assay plate(s).",
			Category -> "Blank",
			IndexMatching -> Blank
		},
		BlankReferenceAntigenCoatingVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of Blank, the amount of diluted BlankReferenceAntigen that is dispensed into the assay plate(s), in order for the BlankReferenceAntigen to be adsorbed to the surface of the well.",
			Category -> "Blank",
			IndexMatching -> Blank
		},
		BlankPrimaryAntibody -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of Blank, the antibody that directly binds with the BlankTargetAntigen.",
			Category -> "Blank",
			IndexMatching -> Blank
		},
		BlankPrimaryAntibodyDilutionFactor -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0, 1],
			Description -> "For each member of Blank, the ratio of dilution of BlankPrimaryAntibody.",
			Category -> "Blank",
			IndexMatching -> Blank
		},
		BlankPrimaryAntibodyVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of Blank, the volume of undiluted BlankPrimaryAntibody added into the corresponding well of the assay plate(s) when Method is DirectELISA, IndirectELISA, DirectSandwichELISA, and IndirectSandwichELISA, or the volume of diluted BlankPrimaryAntibody directly added into the corresponding well of the SampleAssemblyPlate(s) to form Sample-Antibody complex when Method is DirectCompetitiveELISA, IndirectCompetitiveELISA, and FastELISA.",
			Category -> "Blank",
			IndexMatching -> Blank
		},
		BlankPrimaryAntibodyImmunosorbentVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of Blank, the volume of the BlankPrimaryAntibody (either diluted or undiluted) to be loaded on the assay plate(s) for the Immunosorbent step when Method is DirectELISA, IndirectELISA, DirectSandwichELISA, and IndirectSandwichELISA.",
			Category -> "Blank",
			IndexMatching -> Blank
		},
		BlankSecondaryAntibody -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of Blank, the antibody that binds to the BlankPrimaryAntibody rather than directly to the BlankTargetAntigen.",
			Category -> "Blank",
			IndexMatching -> Blank
		},
		BlankSecondaryAntibodyDilutionFactor -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0, 1],
			Description -> "For each member of Blank, the ratio of dilution of BlankSecondaryAntibody.",
			Category -> "Blank",
			IndexMatching -> Blank
		},
		BlankSecondaryAntibodyVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of Blank, the volume of BlankSecondaryAntibody added into the corresponding well of the assay plate(s) for the immunosorbent step.",
			Category -> "Blank",
			IndexMatching -> Blank
		},
		BlankSecondaryAntibodyImmunosorbentVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of Blank, the volume of the BlankSecondaryAntibody (either diluted or undiluted) to be loaded on the assay plate(s) for the immunosorbent step.",
			Category -> "Blank",
			IndexMatching -> Blank
		},
		BlankBlockingVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of Blank, the amount of BlockingBuffer that is dispensed into the corresponding wells of the assay plate(s), in order to prevent non-specific binding.",
			Category -> "Blank",
			IndexMatching -> Blank
		},
		BlankAntibodyComplexImmunosorbentVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of Blank, the volume of the BlankAntibodyComplex to be loaded on the assay plate(s).",
			Category -> "Blank",
			IndexMatching -> Blank
		},
		(*===Post Experiment Storage===*)
		SpikeStorageCondition -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP|Disposal,
			Description -> "For each member of SampleLink, the condition under which the unused portion of Spike stock sample should be stored after the protocol is completed.",
			Category -> "Sample Post-Processing",
			IndexMatching -> SampleLink
		},
		CoatingAntibodyStorageConditions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP|Disposal,
			Description -> "For each member of SampleLink, the condition under which the unused portion of CoatingAntibody stock should be stored after the protocol is completed.",
			Category -> "Sample Post-Processing",
			IndexMatching -> SampleLink
		},
		CaptureAntibodyStorageCondition -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP|Disposal,
			Description -> "For each member of SampleLink, the condition under which the unused portion of Capture Antibody stock should be stored after the protocol is completed.",
			Category -> "Sample Post-Processing",
			IndexMatching -> SampleLink
		},
		ReferenceAntigenStorageCondition -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP|Disposal,
			Description -> "For each member of SampleLink, the condition under which the unused portion of ReferenceAntigen stock should be stored after the protocol is completed.",
			Category -> "Sample Post-Processing",
			IndexMatching -> SampleLink
		},
		PrimaryAntibodyStorageCondition -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP|Disposal,
			Description -> "For each member of SampleLink, the condition under which the unused portion of PrimaryAntibody stock should be stored after the protocol is completed.",
			Category -> "Sample Post-Processing",
			IndexMatching -> SampleLink
		},
		SecondaryAntibodyStorageCondition -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP|Disposal,
			Description -> "For each member of SampleLink, the condition under which the unused portion of SecondaryAntibody stock should be stored after the protocol is completed.",
			Category -> "Sample Post-Processing",
			IndexMatching -> SampleLink
		},
		StandardStorageCondition -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP|Disposal,
			Description -> "For each member of Standard, the condition under which the unused portion of Standard stock should be stored after the protocol is completed.",
			Category -> "Sample Post-Processing",
			IndexMatching -> Standard
		}
	}
}];




