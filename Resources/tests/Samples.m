(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Samples: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(* Sample *)


DefineTests[Sample,
		{
			Example[{Basic,"Makes a sample construct:"},
				Sample[
					Model -> Model[Sample,"Milli-Q water"],
					Volume -> 10 Milliliter
				],
				_?validSampleSpecQ
			],
			Example[{Basic,"In order to work with only sample blobs, it is possible to convert a sample object to a sample blob:"},
				Sample[Object[Sample, "id:L8kPEjNGZZ7V"]],
				_Sample,
				Stubs:>{
					Download[ObjectP[Object[Sample]]]:=Association[
						Type -> Object[Sample],
						Model -> Link[Model[Sample,"5'-Amino-C6-CTCAC"],"linkID"],
						Container -> Link[Object[Container,Vessel,"id:1"],"linkID"],
						Volume -> 1.5 Milliliter,
						Mass -> Null,
						MassConcentration -> Null,
						Concentration -> 100 Nanomole/Liter
					],

					Download[Link[Object[Container,Vessel,"id:1"],"linkID"]]:=Association[
						Type -> Object[Container,Vessel],
						Object -> Object[Container,Vessel,"id:1"],
						ID ->"id:1",
						Model->Link[Model[Container,Vessel,"2mL Tube"],"linkID"]
					]
				}
			],
			Example[{Basic,"Returns $Failed if any of the provided objects are not in the database:"},
				Sample[
					{
						Object[Sample, "id:L8kPEjNGZZ7V"],
						Object[Sample, "nonsenseString"]
					}
				],
				$Failed,
				Messages:>{Message[Generic::MissingObject,{Object[Sample, "nonsenseString"]}]},
				Stubs:>{
					Download[Object[Sample, "id:L8kPEjNGZZ7V"]]:=Association[
						Type -> Object[Sample],
						Model -> Link[Model[Sample,"5'-Amino-C6-CTCAC"],"linkID"],
						Container -> Link[Object[Container,Vessel,"id:1"],"linkID"],
						Volume -> 1.5 Milliliter
					],
					Download[Object[Sample, "nonsenseString"]]:=$Failed
				}
			],
			Test["Returns $Failed if given an object which is not in the database:",
				Sample[Object[Sample,"nonsenseString"]],
				$Failed,
				Messages:>{Message[Generic::MissingObject,Object[Sample, "nonsenseString"]]},
				Stubs:>{
					Download[Object[Sample, "nonsenseString"]]:=$Failed
				}
			],
			Test["Adds an Amount key when converting an object to a blob:",
				Sample[Object[Sample, "id:L8kPEjNGZZ7V"]][Amount],
				1.5 Milliliter,
				Stubs:>{
					Download[ObjectP[Object[Sample]]]:=Association[
						Type -> Object[Sample],
						Model -> Link[Model[Sample,"5'-Amino-C6-CTCAC"],"linkID"],
						Container -> Link[Object[Container,Vessel,"id:1"],"linkID"],
						Volume -> 1.5 Milliliter,
						Mass -> Null,
						MassConcentration -> Null,
						Concentration -> 100 Nanomole/Liter
					]
				}
			],
			Test["Keeps container field as link in packet:",
				blobLookup[
					Sample[Object[Sample, "id:L8kPEjNGZZ7V"]],
					Container
				],
				Link[Object[Container,Vessel,"id:1"],"linkID"],
				Stubs:>{
					Download[ObjectP[Object[Sample]]]:=Association[
						Type -> Object[Sample],
						Model -> Link[Model[Sample,"5'-Amino-C6-CTCAC"],"linkID"],
						Container -> Link[Object[Container,Vessel,"id:1"],"linkID"],
						Volume -> 1.5 Milliliter,
						Mass -> Null,
						MassConcentration -> Null,
						Concentration -> 100 Nanomole/Liter
					]
				}
			],
			Example[{Additional,"For solid samples, use the mass and a mass concentration keys:"},
				Sample[
					Model -> Model[Sample,"Magnesium Chloride"],
					Mass -> 10 Gram,
					MassConcentration -> 1 Kilogram/Liter
				],
				_?validSampleSpecQ
			],
			Example[{Additional,"For liquid samples, use the volume and a molar concentration keys:"},
				Sample[
					Model -> Model[Sample,"5'-Amino-C6-CTCAC"],
					Volume -> 1 Milliliter,
					Concentration -> 1 Nanomole/Liter
				],
				_?validSampleSpecQ
			],
			Example[{Additional,"If the exact amount is unknown it can instead be represented with a distribution:"},
				Sample[
					Model -> Model[Sample,"5'-Amino-C6-CTCAC"],
					Volume -> UniformDistribution[{1 Milliliter,2 Milliliter}],
					Concentration -> 100 Nanomole/Liter
				],
				_?validSampleSpecQ
			],
			Example[{Additional,"If the exact concentration is unknown it can instead be represented with a distribution:"},
				Sample[
					Model -> Model[Sample,"5'-Amino-C6-CTCAC"],
					Volume -> 1 Milliliter,
					Concentration -> NormalDistribution[1 Nanomole/Liter, 0.25 Nanomole/Liter]
				],
				_?validSampleSpecQ
			],
			Example[{Additional,"If the experiment is expected to create an uncertain number of samples, the sample construct can be wrapped in Repeated. Here we represent the case where vacuum evaporation may fill between 1 and 8 tubes with between 0 and 2 mLs of water as it creates needed counterweights:"},
				Repeated[
					Sample[
						Model -> Model[Sample,"Milli-Q water"],
						Volume -> UniformDistribution[{0 Milliliter, 2 Milliliter}],
						Container -> Container[Model->Model[Container,Vessel,"2mL Tube"]]
					],
					{1,8}
				],
				_Repeated
			],
			Example[{Additional,"Represent the case where HPLC may create 0-384 fraction samples. Since only 96 samples will fit in a plate, 4 unique container constructs are used:"},
				With[
					{
						containersOut = Table[
							Container[Model -> Model[Container, Plate, "id:L8kPEjkmLbvW"]],
							{4}
						]
					},
					Map[
						Repeated[
							Sample[
								Container -> #,
								Volume -> UniformDistribution[{0 Milliliter, 2 Milliliter}]
							],
							{0,96}
						]&,
						containersOut
					]
				],
				{_Repeated..}
			],
			Example[{Messages,"InvalidSample","Throws a message if the value for a provided key is invalid:"},
				Sample[
					Model -> Model[Sample,"5'-Amino-C6-CTCAC"],
					Volume -> 10,
					Concentration -> 1 Mole
				],
				$Failed,
				Messages:>{Sample::InvalidSample}
			],
			Example[{Messages,"InvalidSample","Throws a message if an invalid key is provided:"},
				Sample[
					Model -> Model[Sample,"Milli-Q water"],
					Volume -> 10 Milliliter,
					Taco -> 12
				],
				$Failed,
				Messages:>{Sample::InvalidSample}
			],
			Example[{Messages,"InvalidSample","Throws a message if no keys are provided:"},
				Sample[],
				$Failed,
				Messages:>{Sample::InvalidSample}
			],
			Test["Adds the Amount key when Volume is specified:",
				blobLookup[
					Sample[
						Model -> Model[Sample,"Milli-Q water"],
						Volume -> 10 Milliliter
					],
					Amount
				],
				10 Milliliter
			],
			Test["Adds the Volume key when Amount is specified:",
				blobLookup[
					Sample[
						Model -> Model[Sample,"Milli-Q water"],
						Amount -> 10 Milliliter
					],
					Volume
				],
				10 Milliliter
			],
			Test["If fields are not specified in a sample blob, they will be Null or {}:",
				blobLookup[
					Sample[
						Model -> Model[Sample,"Milli-Q water"],
						Amount -> 10 Milliliter
					],
					{Name,Protocols}
				],
				{Null,{}}
			],
			Test["Automatically adds the type using the provided model:",
				blobLookup[
					Sample[
						Model -> Model[Sample,"Milli-Q water"],
						Amount -> 10 Milliliter
					],
					Type
				],
				Object[Sample]
			],
			Test["Automatically adds any unspecifed fields as {} or Null:",
				blobLookup[
					Sample[
						Model -> Model[Sample,"Milli-Q water"],
						Amount -> 10 Milliliter
					],
					Status
				],
				Null
			],
			Test["Supplied fields are not overwritten:",
				blobLookup[
					Sample[
						Model -> Model[Sample,"Milli-Q water"],
						Amount -> 10 Milliliter
					],
					Amount
				],
				10 Milliliter
			],
			Test["If no model is provided the type will be Object[Sample]:",
				blobLookup[
					Sample[
						Amount -> 10 Milliliter
					],
					Type
				],
				Object[Sample]
			],
			Test["Returns $Failed if the type cannot be determined:",
				Sample[
					Amount -> 10 Milliliter,
					Model -> Model[Sample,"nonsense model name"]
				],
				$Failed,
				Messages:>{Message[Sample::InvalidSample,"The type, $Failed, must match TypeP[Object[Sample]]. Make sure you've supplied a valid model."]},
				Stubs:>{
					Download[Model[Sample, "nonsense model name"], Type]:=$Failed
				}
			]
		},
		Stubs:>{
			Download[object:ObjectReferenceP[],Object]:=object,
			Download[object:ObjectReferenceP[],Type]:=Most[object],

			Download[Link[object_,___],Object]:=object,
			Download[objs:{ObjectP[]..},fields___]:=Map[
				Download[#,fields]&,
				objs
			],
			Download[x___]:=Print[{Download,x}],
			Upload[x___]:=Print[{Upload,x}]
		}
];



(* ::Subsection:: *)
(* Container *)


DefineTests[Container,
		{
			Example[{Basic,"Makes a Container construct:"},
				Container[
					Model -> Model[Container,Vessel,"2mL Tube"]
				],
				_?validContainerSpecQ
			],
			Example[{Basic,"Returns $Failed if any of the provided objects are not in the database:"},
				Container[{Object[Container, Vessel, "id:Vrbp1jG8YxMx"], Object[Container,Vessel, "nonsenseString"]}],
				$Failed,
				Messages:>{Message[Generic::MissingObject,{Object[Container,Vessel, "nonsenseString"]}]},
				Stubs:>{
					Download[Object[Container,Vessel, "nonsenseString"]]:=$Failed
				}
			],
			Test["Returns $Failed if the provided object is not in the database:",
				Container[Object[Container,Vessel, "nonsenseString"]],
				$Failed,
				Messages:>{Message[Generic::MissingObject,Object[Container,Vessel, "nonsenseString"]]},
				Stubs:>{
					Download[Object[Container,Vessel, "nonsenseString"]]:=$Failed
				}
			],
			Example[{Additional,"Contents should point to sample constructs:"},
				Container[
					Model -> Model[Container,Vessel,"2mL Tube"],
					Contents -> {{"A1",Sample[Model->Model[Sample,"Milli-Q water"]]}}
				],
				_?validContainerSpecQ
			],
			Example[{Additional,"Container constructs can be specified by supplying container objects:"},
				Container[{Object[Container, Vessel, "id:Vrbp1jG8YxMx"], Object[Container,Vessel, "id:XnlV5jmbPxB8"]}],
				{_Container,_Container}
			],
			Example[{Messages,"InvalidContainer","Throws a message if the model key is missing and returns $Failed:"},
				Container[
					Contents -> {{"A1",Object[Sample,"Milli-Q water"]}}
				],
				$Failed,
				Messages:>{Container::InvalidContainer}
			],
			Example[{Messages,"InvalidContainer","Throws a message if the value for a provided key is invalid:"},
				Container[
					Model -> Model[Container,Vessel,"2mL Tube"],
					Contents -> {1,2,3}
				],
				$Failed,
				Messages:>{Container::InvalidContainer}
			],
			Example[{Messages,"InvalidContainer","Throws a message if an invalid key is provided:"},
				Container[
					Model -> Model[Container,Vessel,"2mL Tube"],
					Taco -> 12
				],
				$Failed,
				Messages:>{Container::InvalidContainer}
			],

			Test["Can specify a container construct by supplying a container object without contents:",
				Container[Object[Container,Vessel,"id:XnlV5jmbPxB8"]],
				_?validContainerSpecQ
			],
			Test["Can specify a container construct by supplying a container object:",
				Container[Object[Container,Vessel,"id:Vrbp1jG8YxMx"]],
				_Container
			],
			Test["Automatically adds the type using the model:",
				blobLookup[
					Container[
						Model -> Model[Container,Vessel,"2mL Tube"]
					],
					Type
				],
				Object[Container,Vessel]
			],
			Test["Automatically adds any unspecified fields as {} or Null:",
				blobLookup[
					Container[
						Model -> Model[Container,Vessel,"2mL Tube"]
					],
					Contents
				],
				{}
			],
			Test["Supplied fields are not overwritten:",
				blobLookup[
					Container[
						Model -> Model[Container,Vessel,"2mL Tube"],
						Status -> InUse
					],
					Status
				],
				InUse
			]
		},
		Stubs:>{
			Download[{}, Object]:={},
			Download[object:ObjectReferenceP[],Object]:=object,
			Download[Link[object_,___],Object]:=object,
			Download[object:ObjectReferenceP[],Type]:=Most[object],

			Download[objs:{ObjectP[]..},fields___]:=Map[
				Download[#,fields]&,
				objs
			],

			Download[object:Object[Container,Vessel,"id:XnlV5jmbPxB8"]]:=Association[
				Type -> Object[Container,Vessel],
				Model -> Link[Model[Container,Vessel,"2mL Tube"],"linkID"],
				Contents -> {}
			],


			Download[object:Object[Container,Vessel,"id:Vrbp1jG8YxMx"]]:=Association[
				Type -> Object[Container,Vessel],
				Model -> Link[Model[Container,Vessel,"2mL Tube"],"linkID"],
				Contents -> {
					{"A1", Link[Object[Sample,"id:1"], Container, "linkID"]},
					{"A2", Link[Object[Sample,"id:2"], Container, "linkID"]}
				}
			],

			Download[ObjectP[Object[Sample]]]:=Association[
				Type -> Object[Sample],
				Model -> Link[Model[Sample,"Milli-Q water"],"linkID"],
				Container -> Link[Object[Container,Vessel,"id:1"],"linkID"],
				Volume -> 1 Milliliter,
				Mass -> Null,
				MassConcentration -> Null,
				Concentration -> Null
			],
			Download[Link[Model[Sample,"Milli-Q water"],"linkID"],State]:=Liquid,
			Download[Object[Container,Vessel,"id:1"],Model]:=Link[Model[Container,Vessel,"2mL Tube"],"linkID"],

				Download[x___]:=Print[{Download,x}],
				Upload[x___]:=Print[{Upload,x}]
		}
];


(* ::Subsection::Closed:: *)
(* toBlob *)


DefineTests[
	toBlob,
		{
			Example[{Basic,"Converts a list samples and containers into sample and container blobs:"},
				toBlob[{Object[Container,Vessel,"id:Vrbp1jG8YxMx"],Object[Sample,"id:Arzy1hG4YrLp"]}],
				{_Container,_Sample}
			],
			Test["Only one blob will be made for a sample object regardless of how many times it appears in the list:",
				SameQ[blobLookup[toBlob[{Object[Sample,"id:Arzy1hG4YrLp"],Object[Sample,"id:Arzy1hG4YrLp"]}], ID]],
				True
			],
			Test["Only one blob will be made for a container object regardless of how many times it appears in the list:",
				SameQ[blobLookup[toBlob[{Object[Container,Vessel,"id:Vrbp1jG8YxMx"],Object[Container,Vessel,"id:Vrbp1jG8YxMx"]}], ID]],
				True
			]
		},
		Stubs :> {
			Download[{}]:={},
			Download[{}, fields___]:={},
			Download[object:ObjectReferenceP[],Object]:=object,
			Download[Link[object_,___],Object]:=object,

			Download[objs:{ObjectP[]..},fields___]:=Map[
				Download[#,fields]&,
				objs
			],

			Download[object:Object[Container,Vessel,"id:XnlV5jmbPxB8"]]:=Association[
				Type -> Object[Container,Vessel],
				Model -> Link[Model[Container,Vessel,"2mL Tube"],"linkID"],
				Contents -> {}
			],


			Download[object:Object[Container,Vessel,"id:Vrbp1jG8YxMx"]]:=Association[
				Type -> Object[Container,Vessel],
				Model -> Link[Model[Container,Vessel,"2mL Tube"],"linkID"],
				Contents -> {
					{"A1", Link[Object[Sample,"id:1"], Container, "linkID"]},
					{"A2", Link[Object[Sample,"id:2"], Container, "linkID"]}
				}
			],

			Download[ObjectP[Object[Sample]]]:=Association[
				Type -> Object[Sample],
				Model -> Link[Model[Sample,"Milli-Q water"],"linkID"],
				Container -> Link[Object[Container,Vessel,"id:1"],"linkID"],
				Volume -> 1 Milliliter,
				Mass -> Null,
				MassConcentration -> Null,
				Concentration -> Null
			],

			Download[ObjectP[Object[Resource]]]:=Association[
				Type -> Object[Resource,Sample],
				Models-> {Link[Model[Sample,"Acetone"],"linkID"]},
				Amount -> 1 Liter,
				Sample -> Null,
				Container -> Null,
				ContainerModels -> {}
			],

			Download[Link[Model[Sample,"Milli-Q water"],"linkID"],State]:=Liquid,
			Download[Object[Container,Vessel,"id:1"],Model]:=Link[Model[Container,Vessel,"2mL Tube"],"linkID"],

			Download[PacketP[Object[Resource]],Preparation[Object]]:=Null,

			Download[Link[obj_,"linkID"],Type]:=Most[obj],
			Download[obj:ObjectReferenceP[],Type]:=Most[obj]
		}
];


(* ::Subsection::Closed:: *)
(* blobToObject *)


DefineTests[blobToString,
		{
			Example[{Basic,"Returns the object used to create the blob:"},
				blobToString[Container[Object[Container,Vessel,"id:XnlV5jmbPxB8"]]],
				"Object[Container, Vessel, id:XnlV5jmbPxB8]"
			],
			Example[{Basic,"If there is no underlying object, return the model:"},
				blobToString[Container[Model -> Model[Container,Vessel,"2mL Tube"]]],
				"an object generated during the experiment with Model[Container, Vessel, 2mL Tube]"
			],
			Test["If there is no model associated with the sample blob, return a description of the blob:",
				blobToString[Sample[Volume -> 2 Milliliter]],
				"a sample with <|Type -> Object[Sample], Volume -> 2 milliliters|>"
			]
		},
		Stubs:>{
			Download[object:Object[Container,Vessel,"id:XnlV5jmbPxB8"]]:=Association[
				Type -> Object[Container,Vessel],
				Object -> Object[Container,Vessel,"id:XnlV5jmbPxB8"],
				ID -> "id:XnlV5jmbPxB8",
				Model -> Link[Model[Container,Vessel,"2mL Tube"],"linkID"],
				Contents -> {}
			],

			Download[Model[Container,Vessel,"2mL Tube"],Type]:=Model[Container,Vessel],
			Download[Object[Container,Vessel,"2mL Tube"],Type]:=Object[Container,Vessel],

			Download[x___]:=Print[{Download,x}],
			Upload[x___]:=Print[{Upload,x}]
		}
];


(* ::Subsection::Closed:: *)
(* blobLookup *)


DefineTests[blobLookup,
		{
			Example[{Basic,"Returns the value for the requested key:"},
				blobLookup[
					Sample[
						Model -> Model[Sample,"Milli-Q Water"],
						Volume -> 20 Milliliter
					],
					Volume
				],
				20 Milliliter
			],
			Example[{Basic,"Looks-up values from multiple blobs"},
				blobLookup[
					{
						Sample[
							Model -> Model[Sample,"Milli-Q Water"],
							Volume -> 10 Milliliter
						],
						Sample[
							Model -> Model[Sample,"Ethanol"],
							Volume -> 20 Milliliter
						],
						Sample[
							Model -> Model[Sample,"Acetonitrile"],
							Volume -> 30 Milliliter
						]
					},
					{Model,Volume}
				],
				{
					{Model[Sample,"Milli-Q Water"],10 Milliliter},
					{Model[Sample,"Ethanol"],20 Milliliter},
					{Model[Sample,"Acetonitrile"],30 Milliliter}
				}
			],
			Example[{Basic,"Allows specification of a default which can be used if the key is not in the blob:"},
				blobLookup[
					Sample[
						Amount -> 10 Milliliter
					],
					Cake,
					Chocolate
				],
				Chocolate
			],
			Example[{Additional,"Returns Missing if the key is not present and no default is supplied:"},
				blobLookup[
					Sample[
						Model -> Model[Sample,"Milli-Q Water"]
					],
					ExquisiteGoatHairBrush
				],
				Missing["KeyAbsent", ExquisiteGoatHairBrush]
			]
		},
		Stubs:>{
		Download[Model[Sample,___],Type]:=Model[Sample],

			Download[x___]:=Print[{Download,x}],
			Upload[x___]:=Print[{Upload,x}]
		}
];
