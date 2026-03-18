(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*UploadCoverModel*)


(* ::Subsubsection::Closed:: *)
(*UploadCoverModel*)

With[
	{
		typeWidget = Widget[
			Type -> Enumeration,
			Pattern :> Append[
				Alternatives @@ Types[{
					Model[Item, Cap],
					Model[Item, Lid],
					Model[Item, PlateSeal]
				}],
				Model[Item]
			]
		],
		productWidget = Alternatives[
			"Product URL" -> Widget[
				Type -> String,
				Pattern :> URLP,
				Size -> Paragraph,
				PatternTooltip -> "The URL of the product page of this cover."
			],
			"Product Documentation CloudFile" -> Widget[
				Type -> Object,
				Pattern :> ObjectP[Object[EmeraldCloudFile]]
			],
			"Product Documentation File from PC" -> Widget[
				Type -> String,
				Pattern :> FilePathP,
				Size -> Paragraph,
				PatternTooltip -> "The complete path to the documentation file. This documentation file must be PDF format."
			],
			"Product Documentation File URL" -> Widget[
				Type -> String,
				Pattern :> URLP,
				Size -> Paragraph,
				PatternTooltip -> "In the format of a valid web address that can include or exclude http://. This documentation file must be PDF format."
			],
			"Product Object" -> Widget[
				Type -> Object,
				Pattern :> ObjectP[Object[Product]]
			],
			"Container Model of your Product" -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Container, Vessel], Model[Container, Plate], Model[Container, ExtractionCartridge]}]
			],
			"Sample Model of your Product" -> Widget[
				Type -> Object,
				Pattern :> ObjectP[Model[Sample]]
			]
		],
		nullProductWidget = Alternatives[
			"No product information" -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Null]
			]
		]
	},
	DefineUsage[UploadCoverModel,
		{
			BasicDefinitions -> {
				{
					Definition -> {"UploadCoverModel[typeOfCover, ProductInformation]", "CoverModel"},
					(* Singleton overload *)
					Description -> "creates a commercially-available new 'CoverModel' of common 'typeOfCover' that contains the information given about this cover based on 'ProductInformation'. Cover model information is used to determine compatibility with instrumentation with experimental conditions, exposure to solvents, etc. Minimal information ('typeOfCover' and 'ProductInformation' input) is required when creating this model. Any missing information will be filled by the ECL team during a verification process before covers of this model can be used in the lab.",
					Inputs :> {
						{
							InputName -> "typeOfCover",
							Description -> "The type of cover model to create. If you are unsure what type to use, you can select 'Others', but note that if you choose this type, ECL will create a new cover model of the correct sub-type later to replace the one you created.",
							Widget -> Widget[
								Type -> Enumeration,
								Pattern :> UploadCoverModelTypeStringP
							],
							Expandable -> False
						},
						{
							InputName -> "ProductInformation",
							Description -> "The information of either the cover itself, or where the cover is available, such as spec sheet, supplier webpage url, etc.",
							Widget -> productWidget,
							Expandable -> False
						}
					},
					Outputs :> {
						{
							OutputName -> "CoverModel",
							Description -> "The new cover model.",
							Pattern :> ObjectP[Model[Item]]
						}
					}
				},
				{
					Definition -> {"UploadCoverModel[typeOfCover]", "CoverModel"},
					(* Singleton overload *)
					Description -> "creates a non-commercially-available new 'CoverModel' of common 'typeOfCover' that contains the information given about this cover. Cover model information is used to determine compatibility with instrumentation with experimental conditions, exposure to solvents, etc. Minimal information, including Name, WettedMaterials, Sterile and Reusable option is required when creating this model. Any missing information will be filled by the ECL team during a verification process before covers of this model can be used in the lab.",
					Inputs :> {
						{
							InputName -> "typeOfCover",
							Description -> "The type of cover model to create. If you are unsure what type to use, you can select 'Others', but note that if you choose this type, ECL will create a new cover model of the correct sub-type later to replace the one you created.",
							Widget -> Widget[
								Type -> Enumeration,
								Pattern :> UploadCoverModelTypeStringP
							],
							Expandable -> False
						}
					},
					Outputs :> {
						{
							OutputName -> "CoverModel",
							Description -> "The new cover model.",
							Pattern :> ObjectP[Model[Item]]
						}
					}
				},
				{
					Definition -> {"UploadCoverModel[CoverModelType, ProductInformation]", "CoverModel"},
					Description -> "creates a new 'CoverModel' of the 'CoverModelType' that contains the information given about this Cover based on 'ProductInformation'. Cover model information is used to determine compatibility with instrumentation with experimental conditions, exposure to solvents, etc. Minimal information ('CoverModelType' and 'ProductInformation' input) is required when creating this model, any missing information will be filled by ECL during later process.",
					Inputs :> {
						{
							InputName -> "CoverModelType",
							Description -> "The type of Cover to create.",
							Widget -> typeWidget,
							Expandable -> False
						},
						{
							InputName -> "ProductInformation",
							Description -> "The information of either the cover itself, or where the cover is available, such as spec sheet, supplier webpage url, etc.",
							Widget -> Join[productWidget, nullProductWidget],
							Expandable -> False
						}
					},
					Outputs :> {
						{
							OutputName -> "CoverModel",
							Description -> "The new Cover model.",
							Pattern :> ObjectP[{Model[Item]}]
						}
					},
					CommandBuilder -> False
				},
				{
					Definition -> {"UploadCoverModel[CoverModelTypes, ProductInformation]", "CoverModel"},
					Description -> "creates multiple commercially-available new 'CoverModel' of the 'CoverModelTypes' that contains the information given about this Cover based on 'ProductInformation'. Cover model information is used to determine compatibility with instrumentation with experimental conditions, exposure to solvents, etc. Minimal information ('CoverModelTypes' and 'ProductInformation' input) is required when creating this model, any missing information will be filled by ECL during later process.",
					Inputs :> {
						IndexMatching[
							{
								InputName -> "CoverModelTypes",
								Description -> "The type of Cover to create.",
								Widget -> typeWidget,
								Expandable -> False
							},
							{
								InputName -> "ProductInformation",
								Description -> "The information of either the cover itself, or where the cover is available, such as spec sheet, supplier webpage url, etc.",
								Widget -> Join[productWidget, nullProductWidget],
								Expandable -> False
							},
							IndexName -> "Input Data"
						]
					},
					Outputs :> {
						{
							OutputName -> "CoverModel",
							Description -> "The new Cover model.",
							Pattern :> ObjectP[{Model[Item]}]
						}
					},
					CommandBuilder -> False
				},
				{
					Definition -> {"UploadCoverModel[ModelToUpdate]", "ModelToUpdate"},
					Description -> "updates fields of an existing ModelToUpdate according to the supplied options.",
					Inputs :> {
						IndexMatching[
							{
								InputName -> "ModelToUpdate",
								Description -> "The type of Cover to create or the existing Cover model to update.",
								Widget -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Model[Item]}]
								],
								Expandable -> False
							},
							IndexName -> "Input Data"
						]
					},
					Outputs :> {
						{
							OutputName -> "ModelToUpdate",
							Description -> "The new or updated Cover model.",
							Pattern :> ObjectP[{Model[Item]}]
						}
					},
					CommandBuilder -> False
				}
			},
			SeeAlso -> {
				"UploadSampleModel",
				"UploadProduct",
				"UploadContainerModel",
				"UploadCoverModelOptions",
				"ValidUploadCoverModelQ"
			},
			Author -> {"hanming.yang"}
		}
	];
	DefineUsage[UploadCoverModelOptions,
		{
			BasicDefinitions -> {
				{
					Definition -> {"UploadCoverModelOptions[typeOfCover, ProductInformation]", "resolvedCoverModelOptions"},
					Description -> "returns a list of options as they will be resolved by UploadCoverModel[].",
					Inputs :> {
						{
							InputName -> "typeOfCover",
							Description -> "The type of cover model to create. For covers with one position to hold its contents, use 'Tube or bottle'; for flat covers with one or multiple positions to hold its contents, use 'Plate'; If you are unsure what type to use, you can select 'Others', but note that if you choose this type, ECL will create a new cover model of the correct sub-type later to replace the one you created.",
							Widget -> Widget[
								Type -> Enumeration,
								Pattern :> UploadCoverModelTypeStringP
							],
							Expandable -> False
						},
						{
							InputName -> "ProductInformation",
							Description -> "The information of either the cover itself, or where the cover is available, such as spec sheet, supplier webpage url, etc.",
							Widget -> productWidget,
							Expandable -> False
						}
					},
					Outputs :> {
						{
							OutputName -> "resolvedCoverModelOptions",
							Description -> "A list of options as they will be resolved by UploadCoverModel[].",
							Pattern :> {_Rule..}
						}
					}
				},
				{
					Definition -> {"UploadCoverModelOptions[typeOfCover]", "resolvedCoverModelOptions"},
					Description -> "returns a list of options as they will be resolved by UploadCoverModel[].",
					Inputs :> {
						{
							InputName -> "typeOfCover",
							Description -> "The type of cover model to create. For covers with one position to hold its contents, use 'Tube or bottle'; for flat covers with one or multiple positions to hold its contents, use 'Plate'; If you are unsure what type to use, you can select 'Others', but note that if you choose this type, ECL will create a new cover model of the correct sub-type later to replace the one you created.",
							Widget -> Widget[
								Type -> Enumeration,
								Pattern :> UploadCoverModelTypeStringP
							],
							Expandable -> False
						}
					},
					Outputs :> {
						{
							OutputName -> "resolvedCoverModelOptions",
							Description -> "A list of options as they will be resolved by UploadCoverModel[].",
							Pattern :> {_Rule..}
						}
					}
				},
				{
					Definition -> {"UploadCoverModelOptions[CoverModelType, ProductInformation]", "resolvedCoverModelOptions"},
					Description -> "returns a list of options as they will be resolved by UploadCoverModel[].",
					Inputs :> {
						{
							InputName -> "CoverModelType",
							Description -> "The type of Cover to create.",
							Widget -> typeWidget,
							Expandable -> False
						},
						{
							InputName -> "ProductInformation",
							Description -> "The information of either the cover itself, or where the cover is available, such as spec sheet, supplier webpage url, etc.",
							Widget -> Join[productWidget, nullProductWidget],
							Expandable -> False
						}
					},
					Outputs :> {
						{
							OutputName -> "resolvedCoverModelOptions",
							Description -> "A list of options as they will be resolved by UploadCoverModel[].",
							Pattern :> {_Rule..}
						}
					},
					CommandBuilder -> False
				},
				{
					Definition -> {"UploadCoverModelOptions[CoverModelType, ProductInformation]", "resolvedCoverModelOptions"},
					Description -> "returns a list of options as they will be resolved by UploadCoverModel[].",
					Inputs :> {
						IndexMatching[
							{
								InputName -> "CoverModelType",
								Description -> "The type of Cover to create.",
								Widget -> typeWidget,
								Expandable -> False
							},
							{
								InputName -> "ProductInformation",
								Description -> "The information of either the cover itself, or where the cover is available, such as spec sheet, supplier webpage url, etc.",
								Widget -> Join[productWidget, nullProductWidget],
								Expandable -> False
							},
							IndexName -> "Input Data"
						]
					},
					Outputs :> {
						{
							OutputName -> "resolvedCoverModelOptions",
							Description -> "A list of options as they will be resolved by UploadCoverModel[].",
							Pattern :> {_Rule..}
						}
					},
					CommandBuilder -> False
				},
				{
					Definition -> {"UploadCoverModelOptions[ModelToUpdate]", "resolvedCoverModelOptions"},
					Description -> "returns a list of options as they will be resolved by UploadCoverModel[].",
					Inputs :> {
						IndexMatching[
							{
								InputName -> "ModelToUpdate",
								Description -> "The type of Cover to create or the existing Cover model to update.",
								Widget -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Model[Item, Cap], Model[Item, Lid], Model[Item, PlateSeal]}]
								],
								Expandable -> False
							},
							IndexName -> "Input Data"
						]
					},
					Outputs :> {
						{
							OutputName -> "resolvedCoverModelOptions",
							Description -> "A list of options as they will be resolved by UploadCoverModel[].",
							Pattern :> {_Rule..}
						}
					},
					CommandBuilder -> False
				}
			},
			SeeAlso -> {
				"UploadSampleModel",
				"UploadProduct",
				"UploadContainerModel",
				"UploadCoverModel",
				"ValidUploadCoverModelQ"
			},
			Author -> {"hanming.yang"}
		}
	];

	DefineUsage[ValidUploadCoverModelQ,
		{
			BasicDefinitions -> {
				{
					Definition -> {"ValidUploadCoverModelQ[typeOfCover, ProductInformation]", "isValidCoverModelObject"},
					Description -> "returns a boolean that indicates if a valid Cover model object will be generated from the inputs of this function.",
					Inputs :> {
						{
							InputName -> "typeOfCover",
							Description -> "The type of cover model to create. If you are unsure what type to use, you can select 'Others', but note that if you choose this type, ECL will create a new cover model of the correct sub-type later to replace the one you created.",
							Widget -> Widget[
								Type -> Enumeration,
								Pattern :> UploadCoverModelTypeStringP
							],
							Expandable -> False
						},
						{
							InputName -> "ProductInformation",
							Description -> "The information of either the cover itself, or where the cover is available, such as spec sheet, supplier webpage url, etc.",
							Widget -> productWidget,
							Expandable -> False
						}
					},
					Outputs :> {
						{
							OutputName -> "isValidCoverModelObject",
							Description -> "A boolean that indicates if a valid Cover model object will be generated from the inputs of this function.",
							Pattern :> BooleanP
						}
					}
				},
				{
					Definition -> {"ValidUploadCoverModelQ[typeOfCover]", "isValidCoverModelObject"},
					Description -> "returns a boolean that indicates if a valid Cover model object will be generated from the inputs of this function.",
					Inputs :> {
						{
							InputName -> "typeOfCover",
							Description -> "The type of cover model to create. If you are unsure what type to use, you can select 'Others', but note that if you choose this type, ECL will create a new cover model of the correct sub-type later to replace the one you created.",
							Widget -> Widget[
								Type -> Enumeration,
								Pattern :> UploadCoverModelTypeStringP
							],
							Expandable -> False
						}
					},
					Outputs :> {
						{
							OutputName -> "isValidCoverModelObject",
							Description -> "A boolean that indicates if a valid Cover model object will be generated from the inputs of this function.",
							Pattern :> BooleanP
						}
					}
				},
				{
					Definition -> {"ValidUploadCoverModelQ[CoverModelType, ProductInformation]", "isValidCoverModelObject"},
					Description -> "returns a boolean that indicates if a valid Cover model object will be generated from the inputs of this function.",
					Inputs :> {
						{
							InputName -> "CoverModelType",
							Description -> "The type of Cover to create.",
							Widget -> typeWidget,
							Expandable -> False
						},
						{
							InputName -> "ProductInformation",
							Description -> "The information of either the cover itself, or where the cover is available, such as spec sheet, supplier webpage url, etc.",
							Widget -> Join[productWidget, nullProductWidget],
							Expandable -> False
						}
					},
					Outputs :> {
						{
							OutputName -> "isValidCoverModelObject",
							Description -> "A boolean that indicates if a valid Cover model object will be generated from the inputs of this function.",
							Pattern :> BooleanP
						}
					}
				},
				{
					Definition -> {"ValidUploadCoverModelQ[CoverModelType, ProductInformation]", "isValidCoverModelObject"},
					Description -> "returns a boolean that indicates if a valid Cover model object will be generated from the inputs of this function.",
					Inputs :> {
						IndexMatching[
							{
								InputName -> "CoverModelType",
								Description -> "The type of Cover to create.",
								Widget -> typeWidget,
								Expandable -> False
							},
							{
								InputName -> "ProductInformation",
								Description -> "The information of either the cover itself, or where the cover is available, such as spec sheet, supplier webpage url, etc.",
								Widget -> Join[productWidget, nullProductWidget],
								Expandable -> False
							},
							IndexName -> "Input Data"
						]
					},
					Outputs :> {
						{
							OutputName -> "isValidCoverModelObject",
							Description -> "A boolean that indicates if a valid Cover model object will be generated from the inputs of this function.",
							Pattern :> BooleanP
						}
					}
				},
				{
					Definition -> {"ValidUploadCoverModelQ[ModelToUpdate]", "isValidCoverModelObject"},
					Description -> "returns a boolean that indicates if a valid Cover model object will be generated from the inputs of this function.",
					Inputs :> {
						IndexMatching[
							{
								InputName -> "ModelToUpdate",
								Description -> "The type of Cover to create or the existing Cover model to update.",
								Widget -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Model[Item, Cap], Model[Item, Lid], Model[Item, PlateSeal]}]
								],
								Expandable -> False
							},
							IndexName -> "Input Data"
						]
					},
					Outputs :> {
						{
							OutputName -> "isValidCoverModelObject",
							Description -> "A boolean that indicates if a valid Cover model object will be generated from the inputs of this function.",
							Pattern :> BooleanP
						}
					}
				}
			},
			SeeAlso -> {
				"UploadSampleModel",
				"UploadProduct",
				"UploadContainerModel",
				"UploadCoverModel",
				"UploadCoverModelOptions"
			},
			Author -> {"hanming.yang"}
		}
	];

];
