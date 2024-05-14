(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation,DynamicFoamAnalysis],
	{
		Description->"A protocol for running a Dynamic Foam Analysis experiment on a set of samples.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{
			(* Sample-related fields *)
			Sample -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Model[Sample]
				],
				Description -> "Source samples to be run in this dynamic foam analysis experiment.",
				Category -> "General"
			},
			AdditiveSample -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Model[Sample]
				],
				Description -> "Source additive samples to be run in this dynamic foam analysis experiment.",
				Category -> "General"
			},
			WorkingAdditiveSamples -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Model[Sample]
				],
				Description -> "For each member of AdditiveSample, the additive samples to be mixed with solvent samples in a dynamic foam analysis experiment.",
				Category -> "General",
				IndexMatching -> AdditiveSample,
				Developer -> True
			},
			(* This is either Sources or the corresponding WorkingSamples after aliquoting etc. *)
			WorkingSamples -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Model[Sample]
				],
				Description -> "For each member of Sample, the samples to be run with a dynamic foam analysis experiment after any aliquoting, if applicable.",
				Category -> "General",
				IndexMatching -> Sample,
				Developer -> True
			},
			WorkingContainers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Container],
					Model[Container]
				],
				Description -> "For each member of Sample, the containers holding the samples to be run with a dynamic foam analysis experiment after any aliquoting, if applicable.",
				Category -> "General",
				IndexMatching -> Sample,
				Developer -> True
			},
			SampleLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "For each member of Sample, the label of the sample that goes into the filter.",
				Category -> "General",
				Developer -> True,
				IndexMatching -> Sample
			},
			SampleContainerLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "For each member of Sample, the label of the sample's container that goes into the filter.",
				Category -> "General",
				Developer -> True,
				IndexMatching -> Sample
			},

			(* experiment options *)
			Instrument->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Object[Instrument,DynamicFoamAnalyzer],Model[Instrument,DynamicFoamAnalyzer]],
				Description->"For each member of Sample, the dynamic foam analyzer instrument that should be used in this experiment.",
				Category->"Instrument Specifications"
			},
			SampleVolume->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Milliliter],
				Units->Milliliter,
				Description->"For each member of Sample, the SampleVolume of the samples that will be used in the experiment.",
				Category -> "General",
				IndexMatching->Sample
			},
			AdditiveSampleMass -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Gram],
				Units -> Gram,
				Description -> "For each member of AdditiveSample, the mass of the additive samples that will be used in the experiment.",
				Category -> "General",
				IndexMatching -> AdditiveSample
			},
			Temperature->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Celsius],
				Units->Celsius,
				Description->"For each member of Sample, the temperature at which the foam column containing the sample will be heated to during the duration of the experiment.",
				Category -> "General",
				IndexMatching->Sample
			},
			TemperatureMonitoring->{
				Format->Multiple,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"For each member of Sample, indicates if the temperature of the sample will be directly monitored during the experiment using a probe inserted into the foam column.",
				Category -> "General",
				IndexMatching->Sample
			},
			DetectionMethod->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{FoamDetectionMethodP..},
				Description->"For each member of Sample, the type of foam detection method(s) that will be used during the experiment. The foam detection methods are the Height Method (default method for the Dynamic Foam Analyzer), Liquid Conductivity Method, and Imaging Method. The Height Method provides information on foamability and foam height, the Liquid Conductivity Method provides information on the liquid content and drainage dynamics of foam, and then Imaging Method provides data on the size and distribution of foam bubbles.",
				Category -> "General",
				IndexMatching->Sample
			},
			FoamColumn->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Container,FoamColumn],Object[Container,FoamColumn]],
				Description->"For each member of Sample, the foam column used to contain the sample during the experiment.",
				Category->"Instrument Specifications",
				IndexMatching->Sample
			},
			FoamColumnLoading->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[Wet,Dry],
				Description->"For each member of Sample, indicates whether the foam column will be pre-wetted when the sample is loaded during the experiment. Wet indicates that the sides of the foam column will be wetted with the sample during sample loading. Dry indicates that the sample will be directly loaded to the bottom of the foam column, and the sides of the column will be left dry.",
				Category -> "General",
				IndexMatching->Sample
			},
			LiquidConductivityModule->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Part,LiquidConductivityModule],Object[Part,LiquidConductivityModule]],
				Description->"For each member of Sample, the Liquid Conductivity Module object that will be used in the experiment if the Liquid Conductivity Method is selected. The Liquid Conductivity Module is an attachment for the Dynamic Foam Analyzer instrument that provides information on the liquid content and drainage dynamics over time at various positions along the foam column; this is achieved by recording changes in conductivity of the foam over time, which provides information on the amount of liquid vs gas that is present.",
				Category->"Instrument Specifications",
				IndexMatching->Sample
			},
			FoamImagingModule->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Part,FoamImagingModule],Object[Part,FoamImagingModule]],
				Description->"For each member of Sample, the Foam Imaging Module object that will be used in the experiment if the Imaging Method is selected. The Foam Imaging Module involves transmitting light through a glass prism specially fitted on the side of a foam column, in order to ascertain the 2D structure of the foam based on the principles of total reflection. Since glass and liquid have comparable diffractive indices, light that hits a foam lamella will be partially diffracted and transmitted into the foam. On the other hand, glass and air have different diffractive indices, so light that hits within the air bubble will be fully reflected and sensed by the camera, allowing for construction of a 2D image of the layer of foam located at the edge of the prism.",
				Category->"Instrument Specifications",
				IndexMatching->Sample
			},

			(*- detection -*)
			(*- decay -*)
			Wavelength->{
				Format->Multiple,
				Class->Real,
				Pattern:>Alternatives[469 Nanometer,850 Nanometer],
				Units->Nanometer,
				Description->"For each member of Sample, the wavelength type (visible or infrared) that will be used by the Diode Array Module during the experiment if the Diode Array Module detector is selected.",
				Category -> "General",
				IndexMatching->Sample
			},
			HeightIlluminationIntensity->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Percent],
				Units->Percent,
				Description->"For each member of Sample, the illumination intensity that will be used for foam height detection by the Diode Array Module.",
				Category -> "General",
				IndexMatching->Sample
			},
			CameraHeight->{
				Format->Multiple,
				Class->Integer,
				Pattern:>GreaterEqualP[0*Millimeter],
				Units->Millimeter,
				Description->"For each member of Sample, the height along the column at which the camera used by the Foam Imaging Module will be positioned during the experiment if the Imaging Method is selected.",
				Category->"Instrument Specifications",
				IndexMatching->Sample
			},
			StructureIlluminationIntensity->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Percent],
				Units->Percent,
				Description->"For each member of Sample, the illumination intensity that will be used for foam structure detection by the Foam Structure Module.",
				Category -> "General",
				IndexMatching->Sample
			},
			FieldOfView->{
				Format->Multiple,
				Class->Integer,
				Pattern:>Alternatives[85 Millimeter^2,140 Millimeter^2,285 Millimeter^2],
				Units->Millimeter^2,
				Description->"For each member of Sample, the size of the surface area that is observable at any given moment by the camera used by the Foam Imaging Module in the experiment if the Imaging Method is selected.",
				Category -> "General",
				IndexMatching->Sample
			},
			MeasurementTime->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Minute],
				Units->Second,
				Description->"For each member of Sample, the total amount of time the dynamic foam analysis measurement is estimated to take.",
				Category -> "General",
				IndexMatching->Sample,
				Developer->True
			},

			(*- agitation -*)
			Agitation->{
				Format->Multiple,
				Class->Expression,
				Pattern:>FoamAgitationTypeP,
				Description->"For each member of Sample, the type of agitation (sparging or stirring) used for foam generation of the sample.",
				Category -> "General",
				IndexMatching->Sample
			},
			AgitationTime->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Second],
				Units->Second,
				Description->"For each member of Sample, the amount of time the dynamic foam analysis experiment will agitate the sample to induce the production of foam.",
				Category -> "General",
				IndexMatching->Sample
			},
			AgitationSamplingFrequency->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterP[0 Hertz],
				Units->Hertz,
				Description->"For each member of Sample, the data sampling frequency during the agitation period in which foam is made. The data recorded for the Height Method are the foam and liquid heights over time. The data recorded for the Imaging Method are timelapse 2D snapshots of the foam in the camera field of view. The data recorded for the Liquid Conductivity Method are the resistances at sensors spaced along the length of the foam column.",
				Category -> "General",
				IndexMatching->Sample
			},
			SpargeFilter->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Part,SpargeFilter],Object[Part,SpargeFilter]],
				Description->"For each member of Sample, the sparging filter that will be used to introduce gas bubbles into the column during foam generation. The filter is a glass plate with pores for bubble generation. The size of the filter must match the size of the column selected in order to only flow gas within the confines of the column.",
				Category->"Instrument Specifications",
				IndexMatching->Sample
			},
			SpargeGas->{
				Format->Multiple,
				Class->Expression,
				Pattern:>FoamSpargeGasP,
				Description->"For each member of Sample, the sparging gas that will be used during foam generation in the experiment if agitation is set to sparge.",
				Category -> "General",
				IndexMatching->Sample
			},
			SpargeFlowRate->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Liter/Minute],
				Units->Liter/Minute,
				Description->"For each member of Sample, the flow rate of the sparging gas that will be used during foam generation in the experiment if agitation is set to sparge.",
				Category -> "General",
				IndexMatching->Sample
			},
			StirBlade->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Part,StirBlade],Object[Part,StirBlade]],
				Description->"For each member of Sample, the stir blade that will be used during foam generation in the experiment if agitation is set to stir.",
				Category->"Instrument Specifications",
				IndexMatching->Sample
			},
			StirRate->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*RPM],
				Units->RPM,
				Description->"For each member of Sample, the stir rate of the stir blade that will be used during foam generation in the experiment if agitation is set to stir.",
				Category -> "General",
				IndexMatching->Sample
			},
			StirOscillationPeriod->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Second],
				Units->Second,
				Description->"For each member of Sample, the oscillation period setting for the stir blade that will be used during foam generation in the experiment if agitation is set to stir. This refers to the time after which the stirring blade changes stirring direction.",
				Category -> "General",
				IndexMatching->Sample
			},
			DecayTime->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Minute],
				Units->Second,
				Description->"For each member of Sample, the amount of time the dynamic foam analysis experiment will allow the foam bubbles to drain and coalesce, during which experimental measurements will be taken.",
				Category -> "General",
				IndexMatching->Sample
			},
			DecaySamplingFrequency->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterP[0 Hertz],
				Units->Hertz,
				Description->"For each member of Sample, the data sampling frequency during the period in which the foam column undergoes decay, involving liquid draining, bubble coalescence, and foam column height decrease. The data recorded for the Height Method are the foam and liquid heights over time. The data recorded for the Imaging Method are timelapse 2D snapshots of the foam in the camera field of view. The data recorded for the Liquid Conductivity Method are the resistances at sensors spaced along the length of the foam column.",
				Category -> "General",
				IndexMatching->Sample
			},

			(*- wash -*)
			NumberOfWashes->{
				Format->Multiple,
				Class->Integer,
				Pattern:>GreaterEqualP[1,1],
				Description->"For each member of Sample, the number of washes that will be used to clean the column and/or the stir blade/filter plate after the experiment is run.",
				Category->"Instrument Specifications",
				IndexMatching->Sample
			},
			Syringes->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Model[Container,Syringe],
					Object[Container,Syringe]
				],
				Description->"For each member of Sample, the syringes used to load the sample into the foam columns.",
				Category->"Instrument Specifications",
				Abstract->False,
				IndexMatching->Sample
			},
			Needles->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Model[Item,Needle],
					Object[Item,Needle]
				],
				Description->"For each member of Sample, the needle used to extend the syringe for loading the sample into the foam column.",
				Category->"Instrument Specifications",
				Abstract->False,
				IndexMatching->Sample
			},

			(*- other needed things -*)
			FoamAgitationModule->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Object[Container,FoamAgitationModule],Model[Container,FoamAgitationModule]],
				Description->"For each member of Sample, the agitation module that will be used to hold the foam column, agitation unit, and sample during the experiment.",
				Category->"Instrument Specifications",
				IndexMatching->Sample
			},
			ORing->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Model[Part,ORing],
					Object[Part,ORing]
				],
				Description->"For each member of Sample, the O-ring which seals the connection between the foam column and the foam agitation module, to be installed with either the sparge filter or stir blade during this experiment.",
				Category->"Instrument Specifications",
				Abstract->False,
				IndexMatching->Sample
			},
			SecondaryORing->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Model[Part,ORing],
					Object[Part,ORing]
				],
				Description->"For each member of Sample, the secondary O-ring which seals the connection between the foam column and the foam agitation module, to be installed with either the sparge filter or stir blade during this experiment.",
				Category->"Instrument Specifications",
				Abstract->False,
				IndexMatching->Sample
			},
			AgitatorPlacements->{
				Format->Multiple,
				Class->{Link,Expression},
				Pattern:>{_Link,{LocationPositionP..}},
				Relation->{Alternatives[Object[Part,StirBlade],Object[Part,SpargeFilter]],Null},
				Description->"For each member of Sample, a list of placements used to place the agitator (stir blade or sparge filter) onto the Foam Agitation Module.",
				Category->"Placements",
				Developer->True,
				Headers->{"Agitator to Place","Placement"},
				IndexMatching->Sample
			},
			ORingPlacement->{
				Format->Multiple,
				Class->{Link,Expression},
				Pattern:>{_Link,{LocationPositionP..}},
				Relation->{Object[Part,ORing],Null},
				Description->"For each member of Sample, a list of placements used to place the O-ring onto the Foam Agitation Module.",
				Category->"Placements",
				Developer->True,
				Headers->{"ORing to Place","Placement"},
				IndexMatching->Sample
			},
			SecondaryORingPlacement->{
				Format->Multiple,
				Class->{Link,Expression},
				Pattern:>{_Link,{LocationPositionP..}},
				Relation->{Object[Part,ORing],Null},
				Description->"For each member of Sample, a list of placements used to place the second O-ring onto the Foam Agitation Module.",
				Category->"Placements",
				Developer->True,
				Headers->{"ORing to Place","Placement"},
				IndexMatching->Sample
			},
			LiquidConductivityModulePlacements->{
				Format->Multiple,
				Class->{Link,Expression},
				Pattern:>{_Link,{LocationPositionP..}},
				Relation->{Object[Part,LiquidConductivityModule],Null},
				Description->"For each member of Sample, a list of placements used to place the Liquid Conductivity Module sensors onto the Foam Agitation Module.",
				Category->"Placements",
				Developer->True,
				Headers->{"LiquidConductivityModule to Place","Placement"},
				IndexMatching->Sample
			},
			FoamColumnPlacements->{
				Format->Multiple,
				Class->{Link,Expression},
				Pattern:>{_Link,{LocationPositionP..}},
				Relation->{Object[Container,FoamColumn],Null},
				Description->"For each member of Sample, a list of placements used to place the Foam Column onto the Foam Agitation Module.",
				Category->"Placements",
				Developer->True,
				Headers->{"Foam Column to Place","Placement"},
				IndexMatching->Sample
			},
			FoamAgitationModulePlacements->{
				Format->Multiple,
				Class->{Link,Expression},
				Pattern:>{_Link,{LocationPositionP..}},
				Relation->{Object[Container,FoamAgitationModule],Null},
				Description->"For each member of Sample, a list of placements used to place the Foam Agitation Module onto the Dynamic Foam Analyzer instrument.",
				Category->"Placements",
				Developer->True,
				Headers->{"Foam Agitation Module to Place","Placement"},
				IndexMatching->Sample
			},
			WashFilterPlacements->{
				Format->Multiple,
				Class->{Link,Expression},
				Pattern:>{_Link,{LocationPositionP..}},
				Relation->{Object[Part,SpargeFilter],Null},
				Description->"For each member of Sample, a list of placements used to place the Sparge Filter onto the cleaning module.",
				Category->"Placements",
				Developer->True,
				Headers->{"Wash Filter to Place","Placement"},
				IndexMatching->Sample
			},
			WashFilterColumnPlacements->{
				Format->Multiple,
				Class->{Link,Expression},
				Pattern:>{_Link,{LocationPositionP..}},
				Relation->{Object[Container,FoamColumn],Null},
				Description->"For each member of Sample, a list of placements used to place the Foam Column onto the cleaning module for washing the Sparge Filter.",
				Category->"Placements",
				Developer->True,
				Headers->{"Foam Column to Place","Placement"},
				IndexMatching->Sample
			},

			(*--- file paths needed for the experiment---*)
			DynamicFoamAnalyzerMethodFilePaths->{
				Format->Multiple,
				Class->String,
				Pattern:>FilePathP,
				Description->"For each member of Sample, the full file path of the zip file necessary for the instrument to load and execute the protocol.",
				Category->"General",
				Developer->True,
				IndexMatching->Sample
			},
			DataFilePaths->{
				Format->Multiple,
				Class->String,
				Pattern:>FilePathP,
				Description->"For each member of Sample, the file paths of the data files generated at the conclusion of the experiment.",
				Category->"General",
				Developer->True,
				IndexMatching->Sample
			},
			DataFileNames->{
				Format->Multiple,
				Class->String,
				Pattern:>_String,
				Description->"For each member of Sample, the file names of the data files generated at the conclusion of the experiment.",
				Category->"General",
				Developer->True,
				IndexMatching->Sample
			},
			VideoFilePaths->{
				Format->Multiple,
				Class->String,
				Pattern:>FilePathP,
				Description->"For each member of Sample, the file paths of the video files generated from the structure method, at the conclusion of the experiment.",
				Category->"General",
				Developer->True,
				IndexMatching->Sample
			}
		}
	}
];
