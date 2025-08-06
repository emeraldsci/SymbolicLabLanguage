(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(* ExperimentAutoclave *)


DefineUsage[ExperimentAutoclave,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentAutoclave[Inputs]","Protocol"},
				Description->"generates a 'Protocol' object to sterilize 'Inputs' by using an autoclave.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Inputs",
							Description->"The sample(s)/container(s) to be autoclaved.",
							Widget->Alternatives[
								"Sample or Container"->Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Container,Vessel],Object[Container,Rack],Object[Sample],Object[Item]}],
									ObjectTypes -> {Object[Container,Vessel],Object[Container,Rack],Object[Sample],Object[Item]},
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Model Sample"->Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]},
									OpenPaths -> {
										{
											Object[Catalog, "Root"],
											"Materials"
										}
									}
								]
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName -> "Protocol",
						Description -> "A protocol object for sterilizing the samples/containers requested by using an autoclave.",
						Pattern :> ObjectP[Object[Protocol, Autoclave]]
					}
				}
			}
		},
		MoreInformation->{
			"The maximum surface area that can be occupied in one Autoclave protocol is 0.25 square meters. To autoclave a list of Inputs with a total surface area larger than this, please enqueue multiple Autoclave protocols.",
			"AutoclaveProgram Description: \n\t Universal: Nominal Sterilization Temperature of 134 Celsius, Nominal Sterilization Time of 7 minutes \n\t Liquid: Nominal Sterilization Temperature of 121 Celsius, Nominal Sterilization Time of 20 Minutes.",
			"Samples which have True for any of the following Fields cannot be autoclaved: Flammable, Acid, Base, Pyrophoric, WaterReactive, or Radioactive.",
			"Any container with non-Solid Contents that has a volume greater than 3/4 the MaxVolume of the container will not be autoclaved to prevent loss of sample. Non-Solid contents will be automatically transferred to a larger container.",
			"Any container with a MaxTemperature below 120 C will not be autoclaved. Non-solid Contents in these containers will be automatically transferred into an autoclave-safe container.",
			"Items or Containers with Models with SterilizationBag->True are automatically put into autoclave bags before autoclaving.",
			"Only vessels containers can be not empty, samples or items inside of rack containers should be removed before autoclaving.",
			"Any Item or Container (that is autoclave safe and will fit in an autoclave bag) can be put into an autoclave bag before autoclaving by using the SterilizationBag option.",
			"After ExperimentAutoclave, objects in autoclave bags are moved, stored, and resource picked in their bags to preserve their sterility."
		},
		SeeAlso->{
			"ValidExperimentAutoclaveQ",
			"ExperimentAutoclaveOptions",
			"ExperimentStockSolution",
			"ExperimentSamplePreparation"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"yanzhe.zhu", "clayton.schwarz", "awixtrom", "wyatt", "spencer.clark", "paul"}
	}
];

(* ExperimentAutoclaveOptions *)
DefineUsage[ExperimentAutoclaveOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentAutoclaveOptions[Inputs]","ResolvedOptions"},
				Description->"outputs the resolved options of ExperimentAutoclave with the provided Inputs and specified options.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Inputs",
							Description->"The sample(s)/container(s) to be autoclaved.",
							Widget->Alternatives[
								"Sample or Container"->Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Container,Vessel],Object[Container,Rack],Object[Sample],Object[Item]}],
									ObjectTypes -> {Object[Container,Vessel],Object[Container,Rack],Object[Sample],Object[Item]},
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Model Sample"->Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]}
								]
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"Resolved options when ExperimentAutoclave is called on the input(s).",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso->
				{
					"ExperimentAutoclave",
					"ExperimentAutoclavePreview",
					"ValidExperimentAutoclaveQ"
				},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"yanzhe.zhu", "clayton.schwarz", "awixtrom", "wyatt", "spencer.clark"}
	}
];

(* ExperimentAutoclavePreview *)
DefineUsage[ExperimentAutoclavePreview,
	{
		BasicDefinitions->
				{
					{
						Definition->{"ExperimentAutoclavePreview[Inputs]","Preview"},
						Description->"currently ExperimentAutoclave does not have a preview.",
						Inputs:>{
							IndexMatching[
								{
									InputName->"Inputs",
									Description->"The sample(s)/container(s) to be autoclaved.",
									Widget->Alternatives[
										"Sample or Container"->Widget[
											Type -> Object,
											Pattern :> ObjectP[{Object[Container,Vessel],Object[Container,Rack],Object[Sample],Object[Item]}],
											ObjectTypes -> {Object[Container,Vessel],Object[Container,Rack],Object[Sample],Object[Item]},
											Dereference -> {
												Object[Container] -> Field[Contents[[All, 2]]]
											}
										],
										"Model Sample"->Widget[
											Type -> Object,
											Pattern :> ObjectP[Model[Sample]],
											ObjectTypes -> {Model[Sample]}
										]
									],
									Expandable->False
								},
								IndexName->"experiment samples"
							]
						},
						Outputs:>{
							{
								OutputName->"Preview",
								Description->"Graphical preview representing the output of ExperimentAutoclave. This value is always Null.",
								Pattern:>Null
							}
						}
					}
				},
		SeeAlso->
				{
					"ExperimentAutoclave",
					"ExperimentAutoclaveOptions",
					"ValidExperimentAutoclaveQ"
				},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"yanzhe.zhu", "clayton.schwarz", "awixtrom", "wyatt", "spencer.clark"}
	}
];

(* ValidExperimentAutoclaveQ *)
DefineUsage[ValidExperimentAutoclaveQ,
	{
		BasicDefinitions->
				{
					{
						Definition->{"ValidExperimentAutoclaveQ[Inputs]","Boolean"},
						Description->"checks whether the provided Inputs and specified options are valid for calling ExperimentAutoclave.",
						Inputs:>{
							IndexMatching[
								{
									InputName->"Inputs",
									Description->"The sample(s)/container(s) to be autoclaved.",
									Widget->Alternatives[
										"Sample or Container"->Widget[
											Type -> Object,
											Pattern :> ObjectP[{Object[Container,Vessel],Object[Container,Rack],Object[Sample],Object[Item]}],
											ObjectTypes -> {Object[Container,Vessel],Object[Container,Rack],Object[Sample],Object[Item]},
											Dereference -> {
												Object[Container] -> Field[Contents[[All, 2]]]
											}
										],
										"Model Sample"->Widget[
											Type -> Object,
											Pattern :> ObjectP[Model[Sample]],
											ObjectTypes -> {Model[Sample]}
										]
									],
									Expandable->False
								},
								IndexName->"experiment samples"
							]
						},
						Outputs->{
							{
								OutputName->"Boolean",
								Description->"Whether or not the ExperimentAutoclave call is valid. Return Value can be changed via the OutputFormat option.",
								Pattern:>_EmeraldTestSummary|BooleanP
							}
						}
					}
				},
		SeeAlso->
				{
					"ExperimentAutoclave",
					"ExperimentAutoclaveOptions",
					"ExperimentAutoclavePreview"
				},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"yanzhe.zhu", "clayton.schwarz", "awixtrom", "wyatt", "spencer.clark"}
	}
];