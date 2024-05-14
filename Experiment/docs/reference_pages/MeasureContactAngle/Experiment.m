(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ExperimentMeasureContactAngle*)


DefineUsage[ExperimentMeasureContactAngle,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentMeasureContactAngle[SolidSamples, WettingLiquids]","Protocol"},
				Description->"generates a 'Protocol' object for determining the contact angle of 'SolidSamples' with the given 'WettingLiquids'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"SolidSamples",
							Description->"The solid sample, such as fiber or Wilhelmy plate, whose contact angle with a given wetting liquid will be measured during this experiment.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container],Object[Item,WilhelmyPlate]}],
								ObjectTypes->{Object[Sample],Object[Container],Object[Item,WilhelmyPlate]},
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								}
							],
							Expandable->False
						},
						{
							InputName->"WettingLiquids",
							Description->"The liquid samples that are contacted by the solid samples in order to measure the contact angle between them.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Model[Sample],Object[Sample],Object[Container]}],
								ObjectTypes->{Model[Sample],Object[Sample],Object[Container]},
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								}
							],
							Expandable->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol object for measuring the contact angle between fiber and wetting liquid.",
						Pattern:>ListableP[ObjectP[Object[Protocol,MeasureContactAngle]]]
					}
				}
			}
		},
		MoreInformation->{
			"Measuring contact angle for a given solid and liquid pair is a simple method to characterize the wettability, i.e. whether a liquid tends to spread out or maintain droplet shape on a solid surface. Here, the fiber samples are attached onto a sample holder, which can be mounted onto the microbalance on a single fiber tensiometer. The advancing and receding contact angles of each sample are determined by immersing and withdrawing the fiber in and out of wetting liquid at a constant speed and measuring the force applied on the probe. The contact angles can then be calculated from force data using the Wilhelmy equation. Noted that the wetted length (perimeter) of fiber and the surface tension of liquid must be known before the contact angle between a single fiber and a wetting liquid can be measured. The wetted length measurement should be carried out using a liquid with an expected contact angle of 0 degree (e.g. hexane)."
		},
		SeeAlso->{
			"ExperimentMeasureContactAngleOptions",
			"ExperimentMeasureContactAnglePreview",
			"ValidExperimentMeasureContactAngleQ",
			"ExperimentMeasureSurfaceTension"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"jireh.sacramento", "alou", "ti.wu"}
	}
];


(* ::Subsubsection:: *)
(*ExperimentMeasureContactAngleOptions*)


DefineUsage[ExperimentMeasureContactAngleOptions,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentMeasureContactAngleOptions[FiberSamples,WettingLiquids]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentMeasureContactAngle when it is called on 'FiberSamples' and 'WettingLiquids'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"FiberSamples",
							Description->"The fiber sample whose contact angle with a given wetting liquid will be measured during this experiment.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes->{Object[Sample],Object[Container]},
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								}
							],
							Expandable->False
						},
						{
							InputName->"WettingLiquids",
							Description->"The liquid samples that are contacted by the fiber samples in order to measure the contact angle between them.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes->{Object[Sample],Object[Container]},
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								}
							],
							Expandable->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description -> "Resolved options when ExperimentMeasureContactAngle is called on the input objects.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"This function returns the resolved options that would be fed to ExperimentMeasureContactAngle if it were called on these input objects."
		},
		SeeAlso -> {
			"ExperimentMeasureContactAngle",
			"ExperimentMeasureContactAnglePreview",
			"ValidExperimentMeasureContactAngleQ",
			"ExperimentMeasureSurfaceTension"

		},
		Author -> {"jireh.sacramento", "hayley", "ti.wu"}
	}
];

(* ::Subsubsection:: *)
(*ExperimentMeasureContactAnglePreview*)


DefineUsage[ExperimentMeasureContactAnglePreview,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentMeasureContactAnglePreview[FiberSamples,WettingLiquids]","Preview"},
				Description -> "returns the preview for ExperimentMeasureContactAngle when it is called on 'FiberSamples' and 'WettingLiquids'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"FiberSamples",
							Description->"The fiber sample whose contact angle with a given wetting liquid will be measured during this experiment.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes->{Object[Sample],Object[Container]},
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								}
							],
							Expandable->False
						},
						{
							InputName->"WettingLiquids",
							Description->"The liquid samples that are contacted by the fiber samples in order to measure the contact angle between them.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes->{Object[Sample],Object[Container]},
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								}
							],
							Expandable->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description -> "Graphical preview representing the output of ExperimentMeasureContactAngle. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentMeasureContactAngle",
			"ExperimentMeasureContactAngleOptions",
			"ValidExperimentMeasureContactAngleQ",
			"ExperimentMeasureSurfaceTension"
		},
		Author -> {"jireh.sacramento", "hayley", "ti.wu"}
	}
];

(* ::Subsubsection:: *)
(*ValidExperimentMeasureContactAngleQ*)


DefineUsage[ValidExperimentMeasureContactAngleQ,
	{
		BasicDefinitions -> {
			{
				Definition->{"ValidExperimentMeasureContactAngleQ[FiberSamples,WettingLiquids]","Booleans"},
				Description -> "checks whether the provided 'FiberSamples' and 'WettingLiquids' and specified options are valid for calling ExperimentMeasureContactAngle.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"FiberSamples",
							Description->"The fiber sample whose contact angle with a given wetting liquid will be measured during this experiment.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes->{Object[Sample],Object[Container]},
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								}
							],
							Expandable->False
						},
						{
							InputName->"WettingLiquids",
							Description->"The liquid samples that are contacted by the fiber samples in order to measure the contact angle between them.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes->{Object[Sample],Object[Container]},
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								}
							],
							Expandable->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Booleans",
						Description -> "Whether or not the ExperimentMeasureContactAngle call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentMeasureContactAngle",
			"ExperimentMeasureContactAngleOptions",
			"ExperimentMeasureContactAnglePreview",
			"ExperimentMeasureSurfaceTension"
		},
		Author -> {"jireh.sacramento", "hayley", "ti.wu"}
	}
];