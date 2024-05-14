(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*UploadReferenceElectrodeModel*)


(* ::Subsubsection::Closed:: *)
(*UploadReferenceElectrodeModel*)


DefineUsage[UploadReferenceElectrodeModel,
	{
		BasicDefinitions->{
			{
				Definition->{"UploadReferenceElectrodeModel[]","referenceElectrodeModel"},
				Description->"creates a new 'referenceElectrodeModel' that contains information about the material, working limits, and storage conditions of the reference electrode.",
				Inputs:>{},
				Outputs:>{
					{
						OutputName->"referenceElectrodeModel",
						Description->"The newly-created reference electrode model.",
						Pattern:>ObjectP[Model[Item, Electrode, ReferenceElectrode]]
					}
				}
			},
			{
				Definition->{"UploadReferenceElectrodeModel[templateReferenceElectrodeModel]","referenceElectrodeModel"},
				Description->"creates a new 'referenceElectrodeModel' with electrode-related information provided by options and with remaining parameters drew from the 'templateReferenceElectrodeModel'.",
				Inputs:>{
					{
						InputName->"templateReferenceElectrodeModel",
						Description->"An existing reference electrode model from which related parameters are used as defaults when creating a new reference electrode model. The input template reference electrode model is left unmodified so as to preserve the relationship between the templateReferenceElectrodeModel and its existing objects.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[Model[Item, Electrode, ReferenceElectrode]]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"referenceElectrodeModel",
						Description->"The newly-created reference electrode model.",
						Pattern:>ObjectP[Model[Item, Electrode, ReferenceElectrode]]
					}
				}
			}
		},
		MoreInformation->{
			"If an existing reference electrode model is found that matches all of the parameters specified for the new reference electrode model, the existing model is returned.",
			"Reference electrode models generated with this function may be then prepared via ExperimentPrepareReferenceElectrode."
		},
		SeeAlso->{
			"UploadReferenceElectrodeModelOptions",
			"ValidUploadReferenceElectrodeModelQ",
			"ExperimentPrepareReferenceElectrode"
		},
		Author->{"waseem.vali", "malav.desai", "steven", "qijue.wang"}
	}
];


(* ::Subsubsection::Closed:: *)
(*UploadReferenceElectrodeModelOptions*)


DefineUsage[UploadReferenceElectrodeModelOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"UploadReferenceElectrodeModelOptions[]","ResolvedOptions"},
				Description->"returns the 'ResolvedOptions' from UploadReferenceElectrodeModel for creating a new 'referenceElectrodeModel' that contains information about the material, working limits, and storage conditions of the reference electrode.",
				Inputs:>{},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"The resolved options from UploadReferenceElectrodeModel when creating a new 'referenceElectrodeModel' that contains information about the electrode material, working limits, and storage conditions of the reference electrode.",
						Pattern:>{Rule[_Symbol,Except[Automatic]]..}
					}
				}
			},
			{
				Definition->{"UploadReferenceElectrodeModelOptions[templateReferenceElectrode]","ResolvedOptions"},
				Description->"returns the 'ResolvedOptions' from UploadReferenceElectrodeModel for creating a new 'referenceElectrodeModel' with electrode-related information provided by options and with remaining parameters drew from the 'templateReferenceElectrode'.",
				Inputs:>{
					{
						InputName->"templateReferenceElectrode",
						Description->"An existing reference electrode model from which related parameters are used as defaults when creating a new reference electrode model.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[Model[Item, Electrode, ReferenceElectrode]]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"The resolved options from UploadReferenceElectrodeModel for the provided templateReferenceElectrode.",
						Pattern:>{Rule[_Symbol,Except[Automatic]]..}
					}
				}
			}
		},
		SeeAlso->{
			"UploadReferenceElectrodeModel",
			"ValidUploadReferenceElectrodeModelQ",
			"ExperimentPrepareReferenceElectrode"
		},
		Author->{"waseem.vali", "malav.desai", "steven", "qijue.wang"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidUploadReferenceElectrodeModelQ*)


DefineUsage[ValidUploadReferenceElectrodeModelQ,
	{
		BasicDefinitions->{
			{
				Definition->{"ValidUploadReferenceElectrodeModelQ[]","Boolean"},
				Description->"returns a 'Boolean' indicating the validity of an UploadReferenceElectrodeModel call for creating a new 'referenceElectrodeModel' that contains information about the material, working limits, and storage conditions of the reference electrode.",
				Inputs:>{},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description->"A boolean indicating the validity of the UploadReferenceElectrodeModel call.",
						Pattern:>BooleanP
					}
				}
			},
			{
				Definition->{"ValidUploadReferenceElectrodeModelQ[templateReferenceElectrode]","Boolean"},
				Description->"returns a 'Boolean' indicating the validity of an UploadReferenceElectrodeModel call for creating a new 'referenceElectrodeModel' with electrode-related information provided by options and with remaining parameters drew from the 'templateReferenceElectrode'.",
				Inputs:>{
					{
						InputName->"templateReferenceElectrode",
						Description->"An existing reference electrode model from which related parameters are used as defaults when creating a new reference electrode model.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[Model[Item, Electrode, ReferenceElectrode]]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description->"A boolean indicating the validity of the UploadReferenceElectrodeModel call.",
						Pattern:>BooleanP
					}
				}
			}
		},
		SeeAlso->{
			"UploadReferenceElectrodeModel",
			"UploadReferenceElectrodeModelOptions",
			"ExperimentPrepareReferenceElectrode"
		},
		Author->{"waseem.vali", "malav.desai", "steven", "qijue.wang"}
	}
];