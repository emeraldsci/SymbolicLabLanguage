(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ExperimentELISA*)


DefineUsage[ExperimentELISA,{

	BasicDefinitions->{
		{
			Definition->{"ExperimentELISA[Samples]","Protocol"},
			Description->"creates a 'Protocol' to run Enzyme-Linked Immunosorbent Assay (ELISA) experiment on the provided 'Samples' for the detection and quantification of certain analytes.",
			Inputs:> {
				IndexMatching[
					{
						InputName->"Samples",
						Description->"The samples to be analyzed using ELISA for the detection and quantification of certain analytes such as peptides, proteins, antibodies and hormones.",
						Widget->Widget[
							Type->Object,
								Pattern:>ObjectP[{Object[Sample], Object[Container]}],
							Dereference->{
								Object[Container]->Field[Contents[[All, 2]]]
							}
						],
						Expandable->False
					},
					IndexName->"experiment samples"
				]
			},
			Outputs:>{
				{
					OutputName->"Protocol",
					Description->"A protocol object that describes the capillary ELISA experiment to be run.",
					Pattern:>ObjectP[Object[Protocol,ELISA]]
				}
			}
		}
	},
	MoreInformation->{

	},
	SeeAlso->{
		"ValidExperimentELISAQ",
		"ExperimentELISAOptions",
		"ExperimentWestern",
		"ExperimentTotalProteinQuantification",
		"ExperimentSampleManipulation"
	},
	Tutorials->{
		"Sample Preparation"
	},
	Author->{"harrison.gronlund", "taylor.hochuli", "xiwei.shan"}
}];

(* ::Subsubsection::Closed:: *)
(*ELISAWashPlate*)


DefineUsage[ELISAWashPlate,
	{
		BasicDefinitions -> {
			{"ELISAWashPlate[elisaWashPlateRules]","primitive","generates an ELISAWashPlate 'primitive' that describes washing an ELISA plate."}
		},
		MoreInformation->{
			"The volume with which to wash the plate can be described with WashVolume, and the number of times can be specified with NumberOfWashes"
		},
		Input:>{
			{
				"elisaWashPlateRules",
				{
					Sample->(ObjectP[{Model[Container,Plate],Object[Container,Plate]}]|{ObjectP[{Model[Container,Plate],Object[Container,Plate]}],WellP}),
					NumberOfWashes->GreaterEqualP[0],
					WashVolume->GreaterEqualP[0Microliter]
				},
				"The list of key/value pairs describing the sample, wash volume, and number of washes of the plate washing."
			}
		},
		Output:>{
			{"primitive",_ELISAWashPlate,"A primitive containing the information about washing an ELISA plate."}
		},
		SeeAlso -> {
			"ExperimentELISA",
			"ELISAIncubatePlate",
			"ELISAReadPlate"
		},
		Author->{"dirk.schild", "lei.tian"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ELISAIncubatePlate*)


DefineUsage[ELISAIncubatePlate,
	{
		BasicDefinitions -> {
			{"ELISAIncubatePlate[elisaIncubatePlateRules]","primitive","generates an ELISAIncubatePlate 'primitive' that describes incubation of an ELISA plate."}
		},
		MoreInformation->{
			"The time with which to incubate the plate can be described with IncubationTime, the temperature can be described with IncubationTemperature, and shaking can be described with ShakingFrequency"
		},
		Input:>{
			{
				"elisaIncubatePlateRules",
				{
					Sample->(ObjectP[{Model[Container,Plate],Object[Container,Plate]}]|{ObjectP[{Model[Container,Plate],Object[Container,Plate]}],WellP}),
					IncubationTime->GreaterEqualP[0Second],
					IncubationTemperature->GreaterEqualP[0Celsius],
					ShakingFrequency->GreaterP[0Hertz]
				},
				"The list of key/value pairs describing the sample, time, temperature and shaking frequency of the plate incubation."
			}
		},
		Output:>{
			{"primitive",_ELISAIncubatePlate,"A primitive containing the information about incubating an ELISA plate."}
		},
		SeeAlso -> {
			"ExperimentELISA",
			"ELISAWashPlate",
			"ELISAReadPlate"
		},
		Author->{"Yahya.Benslimane", "dima"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ELISAReadPlate*)


DefineUsage[ELISAReadPlate,
	{
		BasicDefinitions -> {
			{"ELISAReadPlate[elisaReadPlateRules]","primitive","generates an ELISAReadPlate 'primitive' that describes the parameters of reading an ELISA plate."}
		},
		MoreInformation->{
			"The wavelength used in reading the plate is specified with MeasurementWavelength, the reference wavelength is described with ReferenceWavelength, and the data is stored in DataFilePath"
		},
		Input:>{
			{
				"elisaReadPlateRules",
				{
					Sample->(ObjectP[{Model[Container,Plate],Object[Container,Plate]}]|{ObjectP[{Model[Container,Plate],Object[Container,Plate]}],WellP}),
					MeasurementWavelength -> {GreaterP[0Nanometer]..},
					ReferenceWavelength -> GreaterP[0],
					DataFilePath ->
						{_String..}
				},
				"The list of key/value pairs describing the sample, wash volume, and number of washes of the plate washing."
			}
		},
		Output:>{
			{"primitive",_ELISAReadPlate,"A primitive containing the information about reading an ELISA plate."}
		},
		SeeAlso -> {
			"ExperimentELISA",
			"ELISAIncubatePlate",
			"ELISAWashPlate"
		},
		Author->{"dirk.schild", "lei.tian"}
	}
];