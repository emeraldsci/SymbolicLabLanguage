(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)



(* ::Subsubsection:: *)
(*ExperimentMeasureVolume*)


DefineUsage[ExperimentMeasureVolume,
	{
		BasicDefinitions->{
			{
				Definition -> {"ExperimentMeasureVolume[Samples]","Protocol"},
				Description -> "generates a 'Protocol' for measuring the volume of the provided 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The sample(s) for which volume measurements should be taken.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Sample]}],
								ObjectTypes -> {Object[Sample]}
							],
							Expandable -> False,
							Dereference -> {
								Object[Container] -> Field[Contents[[All, 2]]]
							}
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Protocol",
						Description -> "A protocol object or packet that will be used to measure the volume of the provided 'Sample'.",
						Pattern :> ObjectP[Object[Protocol, MeasureVolume]]
					}
				}
			}
		},
		MoreInformation->{
			"The preferred measurement method is Gravimetric, which will weigh a sample and back-calculate volume from a known density.",
			"If weight measurement is not possible, volume will be measured using Ultrasonic liquid level detection and conversion to volume.",
			"The conversion of liquid level distance (via Ultrasonic measurement) to well volume is done using the conversion functions stored in the container's VolumeCalibrations field."
		},
		SeeAlso->{
			"ExperimentMeasureDensity",
			"ExperimentImageSample",
			"ExperimentSampleManipulation",
			"ExperimentMeasureWeight"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"clayton.schwarz", "kstepurska", "wyatt"}
	}
];


(* ::Subsubsection:: *)
(*VolumeMeasurementOptions*)


DefineUsage[VolumeMeasurementDevices,
	{
		BasicDefinitions->{
			{
				Definition -> {"VolumeMeasurementDevices[]","compatibleDevices"},
				Description -> "lists the devices required for an experiment measure volume call given the options provided.",
				Inputs :> {},
				Outputs :> {
					{
						OutputName -> "compatibleDevices",
						Description -> "A list compatible Objects used to measure the volume of `sample`.",
						Pattern :> {{ObjectP[{Object[Instrument],Object[Container,Rack]}]..}..}
					}
				}
			},
			{
				Definition -> {"VolumeMeasurementDevices[Sample]","compatibleDevices"},
				Description -> "lists the devices required for an experiment measure volume call given the options and `sample` provided.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The sample(s) for which volume measurements should be taken.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Sample]}],
								ObjectTypes -> {Object[Sample]}
							],
							Expandable -> False,
							Dereference -> {
								Object[Container] -> Field[Contents[[All, 2]]]
							}
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "compatibleDevices",
						Description -> "A list compatible Objects used to measure the volume of `sample`.",
						Pattern :> {{ObjectP[{Object[Instrument],Object[Container,Rack]}]..}..}
					}
				}
			},
			{
				Definition -> {"VolumeMeasurementDevices[container]","compatibleDevices"},
				Description -> "lists the devices required for an experiment measure volume call given the options and `container` provided.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "container",
							Description -> "The container(s) for which volume measurements should be taken.",
							Widget -> Adder[
								Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Container,Plate],Object[Container,Vessel]}],
									ObjectTypes -> {Object[Container,Plate],Object[Container,Vessel]}
								]
							]
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "compatibleDevices",
						Description -> "A list compatible Objects used to measure the volume of `sample`.",
						Pattern :> {{ObjectP[{Object[Instrument],Object[Container,Rack]}]..}..}
					}
				}
			}
		},
		MoreInformation->{},
		SeeAlso->{
			"ExperimentMeasureVolume",
			"ExperimentMeasureDensity",
			"ExperimentSampleManipulation",
			"ExperimentMeasureWeight"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"clayton.schwarz", "kstepurska", "wyatt"}
	}
];


(* ::Subsection:: *)
(*ValidExperimentMeasureVolumeQ*)


DefineUsage[ValidExperimentMeasureVolumeQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentMeasureVolumeQ[Samples]", "Boolean"},
				Description -> "returns a 'Boolean' indicating the validity of an ExperimentMeasureVolume call for measuring the volume of provided 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The sample(s) for which volume measurements should be taken.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Sample]}],
								ObjectTypes -> Types[Object[Sample]]
							],
							Expandable -> False,
							Dereference -> {
								Object[Container] -> Field[Contents[[All, 2]]]
							}
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Boolean",
						Description -> "A True/False value indicating the validity of the provided ExperimentMeasureVolume call.",
						Pattern :> BooleanP
					}
				}
			}
		},
		MoreInformation -> {
			"This function runs a series of tests to ensure that the provided inputs/options, when passed to ExperimentMeasureVolume proper, will return a valid experiment."
		},
		SeeAlso -> {
			"ExperimentMeasureVolume",
			"ExperimentMeasureVolumePreview",
			"ExperimentMeasureVolumeOptions"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"clayton.schwarz", "kstepurska", "wyatt"}
	}
];


(* ::Subsection:: *)
(*ExperimentMeasureVolumeOptions*)


DefineUsage[ExperimentMeasureVolumeOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentMeasureVolumeOptions[Samples]", "ResolvedOptions"},
				Description -> "generates the 'ResolvedOptions' for measuring the volume of provided 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The sample(s) for which volume measurements should be taken.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Sample]}],
								ObjectTypes -> Types[Object[Sample]]
							],
							Expandable -> False,
							Dereference -> {
								Object[Container] -> Field[Contents[[All, 2]]]
							}
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "Resolved options when ExperimentMeasureVolumeOptions is called on the input samples.",
						Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"The options returned by this function may be passed directly to ExperimentMeasureVolume."
		},
		SeeAlso -> {
			"ExperimentMeasureVolume",
			"ExperimentMeasureVolumePreview",
			"ValidExperimentMeasureVolumeQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"clayton.schwarz", "kstepurska", "wyatt"}
	}
];

(* ::Subsection:: *)
(*ExperimentMeasureVolumePreview*)


DefineUsage[ExperimentMeasureVolumePreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentMeasureVolumePreview[Samples]", "Preview"},
				Description -> "generates a graphical 'Preview' for measuring the volume of the provided 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The sample(s) for which volume measurements should be taken.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Sample]}],
								ObjectTypes -> Types[Object[Sample]]
							],
							Expandable -> False,
							Dereference -> {
								Object[Container] -> Field[Contents[[All, 2]]]
							}
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"A graphical representation of the provided measure volume experiment.",
						Pattern:>Null
					}
				}
			}
		},
		MoreInformation -> {

		},
		SeeAlso -> {
			"ExperimentMeasureVolume",
			"ExperimentMeasureVolumeOptions",
			"ValidExperimentMeasureVolumeQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"clayton.schwarz", "kstepurska", "wyatt"}
	}
];