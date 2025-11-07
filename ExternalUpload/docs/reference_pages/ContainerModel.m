(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*UploadContainerModel*)


(* ::Subsubsection::Closed:: *)
(*UploadContainerModel*)

With[
	{
		typeWidget = Widget[
			Type -> Enumeration,
			Pattern :> Alternatives@@Append[
				Types[{
					Model[Container, Vessel],
					Model[Container, Plate],
					Model[Container,ExtractionCartridge]
				}],
				Model[Container]
			]
		],
		productWidget = Alternatives[
			"Product URL" -> Widget[
				Type -> String,
				Pattern :> URLP,
				Size -> Paragraph,
				PatternTooltip -> "The URL of the product page of this container."
			],
			"Product Documentation CloudFile" -> Widget[
				Type -> Object,
				Pattern :> ObjectP[Object[EmeraldCloudFile]]
			],
			"Product Documentation File from PC" -> Widget[
				Type -> String,
				Pattern :> FilePathP,
				Size -> Paragraph,
				PatternTooltip -> "The complete path to the documentation file."
			],
			"Product Documentation File URL" -> Widget[
				Type -> String,
				Pattern :> URLP,
				Size -> Paragraph,
				PatternTooltip -> "In the format of a valid web address that can include or exclude http://."
			],
			"Product Object" -> Widget[
				Type -> Object,
				Pattern :> ObjectP[Object[Product]]
			]
		],
		allowNullProductWidget = Alternatives[
			"No product information" -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Null]
			],
			"Product URL" -> Widget[
				Type -> String,
				Pattern :> URLP,
				Size -> Paragraph,
				PatternTooltip -> "The URL of the product page of this container."
			],
			"Product Documentation CloudFile" -> Widget[
				Type -> Object,
				Pattern :> ObjectP[Object[EmeraldCloudFile]]
			],
			"Product Documentation File from PC" -> Widget[
				Type -> String,
				Pattern :> FilePathP,
				Size -> Paragraph,
				PatternTooltip -> "The complete path to the documentation file."
			],
			"Product Documentation File URL" -> Widget[
				Type -> String,
				Pattern :> URLP,
				Size -> Paragraph,
				PatternTooltip -> "In the format of a valid web address that can include or exclude http://."
			],
			"Product Object" -> Widget[
				Type -> Object,
				Pattern :> ObjectP[Object[Product]]
			]
		]
	},
	DefineUsage[UploadContainerModel,
		{
			BasicDefinitions -> {
				{
					Definition -> {"UploadContainerModel[typeOfContainer, ProductInformation]", "ContainerModel"},
					(* Singleton overload *)
					Description -> "creates a commercially-available new 'ContainerModel' of common 'typeOfContainer' that contains the information given about this container based on 'ProductInformation'. Container model information is used to determine compatibility with instrumentation with experimental conditions, exposure to solvents, etc. Minimal information ('typeOfContainer' and 'ProductInformation' input) is required when creating this model. Any missing information will be filled by the ECL team during a verification process before containers of this model can be used in the lab.",
					Inputs :> {
						{
							InputName -> "typeOfContainer",
							Description -> "The type of container model to create. For containers with one position to hold its contents, use 'Tube or bottle'; for flat containers with one or multiple positions to hold its contents, use 'Plate'; If you are unsure what type to use, you can select 'Others', but note that if you choose this type, ECL will create a new container model of the correct sub-type later to replace the one you created.",
							Widget -> Widget[
								Type -> Enumeration,
								Pattern :> UploadContainerModelTypeStringP
							],
							Expandable -> False
						},
						{
							InputName -> "ProductInformation",
							Description -> "The information of either the container itself, or where the container is available, such as spec sheet, supplier webpage url, etc.",
							Widget -> productWidget,
							Expandable -> False
						}
					},
					Outputs :> {
						{
							OutputName -> "ContainerModel",
							Description -> "The new container model.",
							Pattern :> ObjectP[Model[Container]]
						}
					}
				},
				{
					Definition -> {"UploadContainerModel[typeOfContainer]", "ContainerModel"},
					(* Singleton overload *)
					Description -> "creates a non-commercially-available new 'ContainerModel' of common 'typeOfContainer' that contains the information given about this container. Container model information is used to determine compatibility with instrumentation with experimental conditions, exposure to solvents, etc. Minimal information, including Name, ContainerMaterials, Sterile, Reusable and MaxVolume option is required when creating this model. Any missing information will be filled by the ECL team during a verification process before containers of this model can be used in the lab.",
					Inputs :> {
						{
							InputName -> "typeOfContainer",
							Description -> "The type of container model to create. For containers with one position to hold its contents, use 'Tube or bottle'; for flat containers with one or multiple positions to hold its contents, use 'Plate'; If you are unsure what type to use, you can select 'Others', but note that if you choose this type, ECL will create a new container model of the correct sub-type later to replace the one you created.",
							Widget -> Widget[
								Type -> Enumeration,
								Pattern :> UploadContainerModelTypeStringP
							],
							Expandable -> False
						}
					},
					Outputs :> {
						{
							OutputName -> "ContainerModel",
							Description -> "The new container model.",
							Pattern :> ObjectP[Model[Container]]
						}
					}
				},
				{
					Definition -> {"UploadContainerModel[newContainerType, ProductInformation]", "ContainerModel"},
					(* Explain what we do with the container model *)
					(* Also mention that we only need minimal info, the rest will be filled by ECL *)
					Description -> "creates a new 'ContainerModel' of the 'newContainerType' that contains the information given about this container based on 'ProductInformation'. Container model information is used to determine compatibility with instrumentation with experimental conditions, exposure to solvents, etc. Minimal information ('newContainerType' and 'ProductInformation' input) is required when creating this model. Any missing information will be filled by the ECL team during a verification process before containers of this model can be used in the lab.",
					Inputs :> {
						{
							InputName -> "newContainerType",
							Description -> "The type of container model to create.",
							Widget -> typeWidget,
							Expandable -> False
						},
						{
							InputName -> "ProductInformation",
							Description -> "The information of either the container itself, or where the container is available, such as spec sheet, supplier webpage url, etc.",
							Widget -> allowNullProductWidget,
							Expandable -> False
						}
					},
					Outputs :> {
						{
							OutputName -> "ContainerModel",
							Description -> "The new container model.",
							Pattern :> ObjectP[Model[Container]]
						}
					}
				},
				{
					Definition -> {"UploadContainerModel[newContainerType, ProductInformation]", "ContainerModel"},
					Description -> "creates multiple new 'ContainerModel's of the 'newContainerType's that contains the information given about this container based on 'ProductInformation'. Container model information is used to determine compatibility with instrumentation with experimental conditions, exposure to solvents, etc. Minimal information is required when creating this model. Any missing information will be filled by the ECL team during a verification process before containers of this model can be used in the lab.",
					Inputs :> {
						IndexMatching[
							{
								InputName -> "newContainerType",
								Description -> "The type of container model to create.",
								Widget -> typeWidget,
								Expandable -> False
							},
							{
								InputName -> "ProductInformation",
								Description -> "The information of either the container itself, or where the container is available, such as spec sheet, supplier webpage url, etc.",
								Widget -> allowNullProductWidget,
								Expandable -> False
							},
							IndexName -> "inputs"
						]
					},
					Outputs :> {
						{
							OutputName -> "ContainerModel",
							Description -> "The new container model.",
							Pattern :> ObjectP[Model[Container]]
						}
					}
				},
				{
					Definition -> {"UploadContainerModel[ModelToUpdate]", "ModelToUpdate"},
					Description -> "updates properties of an existing Model[Container]. Container model information is used to determine compatibility with instrumentation with experimental conditions, exposure to solvents, etc. Only container models that belongs to your team can be modified this way.",
					Inputs :> {
						IndexMatching[
							{
								InputName -> "ModelToUpdate",
								Description -> "The existing container model to update.",
								Widget -> Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Container]]
								],
								Expandable -> False
							},
							IndexName -> "inputs"
						]
					},
					Outputs :> {
						{
							OutputName -> "ModelToUpdate",
							Description -> "The updated container model.",
							Pattern :> ObjectP[Model[Container]]
						}
					}
				}
			},
			SeeAlso -> {
				"UploadSampleModel",
				"UploadProduct",
				"UploadCoverModel",
				"UploadContainerModelOptions",
				"ValidUploadContainerModelQ"
			},
			Author -> {"hanming.yang"}
		}
	];

	DefineUsage[UploadContainerModelOptions,
		{
			BasicDefinitions -> {
				{
					Definition -> {"UploadContainerModelOptions[typeOfContainer, ProductInformation]", "resolvedContainerModelOptions"},
					(* Singleton overload *)
					Description -> "returns a list of options as they will be resolved by UploadContainerModel[].",
					Inputs :> {
						{
							InputName -> "typeOfContainer",
							Description -> "The type of container model to create. For containers with one position to hold its contents, use 'Tube or bottle'; for flat containers with one or multiple positions to hold its contents, use 'Plate'; If you are unsure what type to use, you can select 'Others', but note that if you choose this type, ECL will create a new container model of the correct sub-type later to replace the one you created.",
							Widget -> Widget[
								Type -> Enumeration,
								Pattern :> UploadContainerModelTypeStringP
							],
							Expandable -> False
						},
						{
							InputName -> "ProductInformation",
							Description -> "The information of either the container itself, or where the container is available, such as spec sheet, supplier webpage url, etc.",
							Widget -> productWidget,
							Expandable -> False
						}
					},
					Outputs :> {
						{
							OutputName -> "resolvedContainerModelOptions",
							Description -> "A list of options as they will be resolved by UploadContainerModelOptions[].",
							Pattern :> {_Rule..}
						}
					}
				},
				{
					Definition -> {"UploadContainerModelOptions[typeOfContainer]", "resolvedContainerModelOptions"},
					(* Singleton overload *)
					Description -> "returns a list of options as they will be resolved by UploadContainerModel[].",
					Inputs :> {
						{
							InputName -> "typeOfContainer",
							Description -> "The type of container model to create. For containers with one position to hold its contents, use 'Tube or bottle'; for flat containers with one or multiple positions to hold its contents, use 'Plate'; If you are unsure what type to use, you can select 'Others', but note that if you choose this type, ECL will create a new container model of the correct sub-type later to replace the one you created.",
							Widget -> Widget[
								Type -> Enumeration,
								Pattern :> UploadContainerModelTypeStringP
							],
							Expandable -> False
						}
					},
					Outputs :> {
						{
							OutputName -> "resolvedContainerModelOptions",
							Description -> "A list of options as they will be resolved by UploadContainerModelOptions[].",
							Pattern :> {_Rule..}
						}
					}
				},
				{
					Definition -> {"UploadContainerModelOptions[newContainerType, ProductInformation]", "resolvedContainerModelOptions"},
					(* Explain what we do with the container model *)
					(* Also mention that we only need minimal info, the rest will be filled by ECL *)
					Description -> "returns a list of options as they will be resolved by UploadContainerModel[].",
					Inputs :> {
						{
							InputName -> "newContainerType",
							Description -> "The type of container model to create.",
							Widget -> typeWidget,
							Expandable -> False
						},
						{
							InputName -> "ProductInformation",
							Description -> "The information of either the container itself, or where the container is available, such as spec sheet, supplier webpage url, etc.",
							Widget -> allowNullProductWidget,
							Expandable -> False
						}
					},
					Outputs :> {
						{
							OutputName -> "resolvedContainerModelOptions",
							Description -> "A list of options as they will be resolved by UploadContainerModelOptions[].",
							Pattern :> {_Rule..}
						}
					}
				},
				{
					Definition -> {"UploadContainerModelOptions[newContainerType, ProductInformation]", "resolvedContainerModelOptions"},
					Description -> "returns a list of options as they will be resolved by UploadContainerModel[].",
					Inputs :> {
						IndexMatching[
							{
								InputName -> "newContainerType",
								Description -> "The type of container model to create.",
								Widget -> typeWidget,
								Expandable -> False
							},
							{
								InputName -> "ProductInformation",
								Description -> "The information of either the container itself, or where the container is available, such as spec sheet, supplier webpage url, etc.",
								Widget -> allowNullProductWidget,
								Expandable -> False
							},
							IndexName -> "inputs"
						]
					},
					Outputs :> {
						{
							OutputName -> "resolvedContainerModelOptions",
							Description -> "A list of options as they will be resolved by UploadContainerModelOptions[].",
							Pattern :> {_Rule..}
						}
					}
				},
				{
					Definition -> {"UploadContainerModelOptions[ContainerModel]", "resolvedContainerModelOptions"},
					Description -> "returns a list of options as they will be resolved by UploadContainerModel[].",
					Inputs :> {
						IndexMatching[
							{
								InputName -> "ContainerModel",
								Description -> "The existing container model to update.",
								Widget -> Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Container]]
								],
								Expandable -> False
							},
							IndexName -> "inputs"
						]
					},
					Outputs :> {
						{
							OutputName -> "resolvedContainerModelOptions",
							Description -> "A list of options as they will be resolved by UploadContainerModelOptions[].",
							Pattern :> {_Rule..}
						}
					}
				}
			},
			SeeAlso -> {
				"UploadSampleModel",
				"UploadProduct",
				"UploadCoverModel",
				"UploadContainerModel",
				"ValidUploadContainerModelQ"
			},
			Author -> {"hanming.yang"}
		}
	];

	DefineUsage[ValidUploadContainerModelQ,
		{
			BasicDefinitions -> {
				{
					Definition -> {"ValidUploadContainerModelQ[typeOfContainer, ProductInformation]", "isValidContainerModelObject"},
					(* Singleton overload *)
					Description -> "returns a boolean that indicates if a valid container model object will be generated from the inputs of this function.",
					Inputs :> {
						{
							InputName -> "typeOfContainer",
							Description -> "The type of container model to create. For containers with one position to hold its contents, use 'Tube or bottle'; for flat containers with one or multiple positions to hold its contents, use 'Plate'; If you are unsure what type to use, you can select 'Others', but note that if you choose this type, ECL will create a new container model of the correct sub-type later to replace the one you created.",
							Widget -> Widget[
								Type -> Enumeration,
								Pattern :> UploadContainerModelTypeStringP
							],
							Expandable -> False
						},
						{
							InputName -> "ProductInformation",
							Description -> "The information of either the container itself, or where the container is available, such as spec sheet, supplier webpage url, etc.",
							Widget -> productWidget,
							Expandable -> False
						}
					},
					Outputs :> {
						{
							OutputName -> "isValidContainerModelObject",
							Description -> "A boolean that indicates if a valid container model object will be generated from the inputs of this function.",
							Pattern :> BooleanP
						}
					}
				},
				{
					Definition -> {"ValidUploadContainerModelQ[typeOfContainer]", "isValidContainerModelObject"},
					(* Singleton overload *)
					Description -> "returns a boolean that indicates if a valid container model object will be generated from the inputs of this function.",
					Inputs :> {
						{
							InputName -> "typeOfContainer",
							Description -> "The type of container model to create. For containers with one position to hold its contents, use 'Tube or bottle'; for flat containers with one or multiple positions to hold its contents, use 'Plate'; If you are unsure what type to use, you can select 'Others', but note that if you choose this type, ECL will create a new container model of the correct sub-type later to replace the one you created.",
							Widget -> Widget[
								Type -> Enumeration,
								Pattern :> UploadContainerModelTypeStringP
							],
							Expandable -> False
						}
					},
					Outputs :> {
						{
							OutputName -> "isValidContainerModelObject",
							Description -> "A boolean that indicates if a valid container model object will be generated from the inputs of this function.",
							Pattern :> BooleanP
						}
					}
				},
				{
					Definition -> {"ValidUploadContainerModelQ[newContainerType, ProductInformation]", "isValidContainerModelObject"},
					(* Explain what we do with the container model *)
					(* Also mention that we only need minimal info, the rest will be filled by ECL *)
					Description -> "returns a boolean that indicates if a valid container model object will be generated from the inputs of this function.",
					Inputs :> {
						{
							InputName -> "newContainerType",
							Description -> "The type of container model to create.",
							Widget -> typeWidget,
							Expandable -> False
						},
						{
							InputName -> "ProductInformation",
							Description -> "The information of either the container itself, or where the container is available, such as spec sheet, supplier webpage url, etc.",
							Widget -> allowNullProductWidget,
							Expandable -> False
						}
					},
					Outputs :> {
						{
							OutputName -> "isValidContainerModelObject",
							Description -> "A boolean that indicates if a valid container model object will be generated from the inputs of this function.",
							Pattern :> BooleanP
						}
					}
				},
				{
					Definition -> {"ValidUploadContainerModelQ[newContainerType, ProductInformation]", "isValidContainerModelObject"},
					Description -> "returns a boolean that indicates if a valid container model object will be generated from the inputs of this function.",
					Inputs :> {
						IndexMatching[
							{
								InputName -> "newContainerType",
								Description -> "The type of container model to create.",
								Widget -> typeWidget,
								Expandable -> False
							},
							{
								InputName -> "ProductInformation",
								Description -> "The information of either the container itself, or where the container is available, such as spec sheet, supplier webpage url, etc.",
								Widget -> allowNullProductWidget,
								Expandable -> False
							},
							IndexName -> "inputs"
						]
					},
					Outputs :> {
						{
							OutputName -> "isValidContainerModelObject",
							Description -> "A boolean that indicates if a valid container model object will be generated from the inputs of this function.",
							Pattern :> BooleanP
						}
					}
				},
				{
					Definition -> {"ValidUploadContainerModelQ[ContainerModel]", "isValidContainerModelObject"},
					Description -> "returns a boolean that indicates if a valid container model object will be generated from the inputs of this function.",
					Inputs :> {
						IndexMatching[
							{
								InputName -> "ContainerModel",
								Description -> "The existing container model to update.",
								Widget -> Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Container]]
								],
								Expandable -> False
							},
							IndexName -> "inputs"
						]
					},
					Outputs :> {
						{
							OutputName -> "isValidContainerModelObject",
							Description -> "A boolean that indicates if a valid container model object will be generated from the inputs of this function.",
							Pattern :> BooleanP
						}
					}
				}
			},
			SeeAlso -> {
				"UploadSampleModel",
				"UploadProduct",
				"UploadCoverModel",
				"UploadContainerModel",
				"UploadContainerModelOptions"
			},
			Author -> {"hanming.yang"}
		}
	];

	DefineUsage[UploadVerifiedContainerModel,
		{
			BasicDefinitions -> {
				{
					Definition -> {"UploadVerifiedContainerModel[ContainerModel]", "ContainerModel"},
					Description -> "updates properties of an existing Model[Container] based on the provided options, and check if the resulted model passes ValidObjectQ. If yes, mark the container model as Verified.",
					Inputs :> {
						IndexMatching[
							{
								InputName -> "ContainerModel",
								Description -> "The existing container model to update.",
								Widget -> Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Container]]
								],
								Expandable -> False
							},
							IndexName -> "inputs"
						]
					},
					Outputs :> {
						{
							OutputName -> "ContainerModel",
							Description -> "The updated container model.",
							Pattern :> ObjectP[Model[Container]]
						}
					}
				}
			},
			SeeAlso -> {
				"UploadSampleModel",
				"UploadProduct",
				"UploadCoverModel",
				"UploadContainerModelOptions",
				"ValidUploadContainerModelQ"
			},
			Author -> {"hanming.yang"}
		}
	];

];