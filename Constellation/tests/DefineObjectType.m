(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(*DefineObjectType*)


DefineTests[
	DefineObjectType,
	{

		Example[{Basic, "Define new Types:"},
			DefineObjectType[Object[Testing],
				{
					Description -> "Description is longer than ten characters",
					Fields -> {
						Name -> {
							Format -> Single,
							Class -> String,
							Pattern :> _String,
							Description -> "A name.",
							Required -> True,
							Category -> "Organizational Information"
						}
					},
					CreatePrivileges -> Developer,
					Cache -> Download
				}
			];
			ValidTypeQ[Object[Testing]],
			True
		],

		Example[{Basic, "Define sub Types:"},
			DefineObjectType[Object[Testing],
				{
					Description -> "Description is longer than ten characters",
					Fields -> {
						Name -> {
							Format -> Single,
							Class -> String,
							Pattern :> _String,
							Description -> "A name.",
							Required -> True,
							Category -> "Organizational Information"
						}
					},
					CreatePrivileges -> Developer,
					Cache -> Download
				}
			];
			DefineObjectType[Object[Testing, Person],
				{
					Description -> "Testing testing one two three",
					Fields -> {
						Number -> {
							Format -> Single,
							Class -> Real,
							Pattern :> _?NumericQ,
							Units -> None,
							Description -> "A number.",
							Required -> False,
							Category -> "Organizational Information"
						}
					},
					CreatePrivileges -> Developer,
					Cache -> Download
				}
			];
			{ValidTypeQ[Object[Testing]], ValidTypeQ[Object[Testing, Person]]},
			{True, True}
		],

		Example[{Basic, "Define a named Type:"},
			DefineObjectType[Object[Testing],
				{
					Description -> "Description is longer than ten characters",
					Fields -> {
						EmissionFilter -> {
							Format -> Single,
							Class -> {
								Wavelength -> Real,
								Bandpass -> Real,
								Dichroic -> Real
							},
							Pattern :> {
								Wavelength -> GreaterP[0 Nanometer],
								Bandpass -> GreaterP[0 Nanometer],
								Dichroic -> GreaterP[0 Nanometer]
							},
							Units -> {
								Wavelength -> Nanometer,
								Bandpass -> Nanometer,
								Dichroic -> Nanometer
							},
							Description -> "Fluorescence emission filtering used in recording the microscope image.",
							Category -> "Instrument Specifications"
						}
					},
					CreatePrivileges -> Developer,
					Cache -> Download
				}
			];
			ValidTypeQ[Object[Testing]],
			True
		],

		Test["Defining an ObjectType for Models works:",
			{
				DefineObjectType[Model[Testing], {
					Fields -> {
						Name -> {
							Format -> Single,
							Class -> String,
							Pattern :> _String,
							Units -> None,
							Description -> "A name.",
							Required -> True
						}
					}
				}, registeredTypes],
				DefineObjectType[Model[Testing, Person], {
					Description -> "Testing testing one two three",
					Fields -> {
						Number -> {
							Format -> Single,
							Class -> Real,
							Pattern :> _?NumericQ,
							Units -> None,
							Description -> "A number.",
							Required -> False
						}
					}
				}, registeredTypes]
			},
			{_?(KeyPatternsQ[#, <|Fields -> _List|>] &), _?(KeyPatternsQ[#, <|Fields -> _List, Description -> _String|>] &)}
		],

		Example[{Messages, "NoTypeDefError", "Parent Types must exist:"},
			DefineObjectType[Object[NotAType, Testing], {Fields -> {}}, registeredTypes],
			$Failed,
			Messages :> {Message[
				DefineObjectType::NoTypeDefError,
				"Object[Constellation`Private`NotAType]"
			]}
		],

		Example[{Messages, "TypeAlreadyDefinedError", "Type Names must be unique:"},
			DefineObjectType[Object[Testing], {Fields -> {}}, registeredTypes];
			DefineObjectType[Object[Testing], {Fields -> {}}, registeredTypes],
			$Failed,
			Messages :> {Message[DefineObjectType::TypeAlreadyDefinedError]}
		],

		Example[{Attributes, HoldRest, "Parameters are held, so that the explicit type registry can be passed by reference:"},
			literal=With[{registeredTypesLitteral=<||>},
				DefineObjectType[Object[Testing], {Fields -> {}}, registeredTypesLitteral]
			];
			reference=Module[{registeredTypesReference=<||>},
				DefineObjectType[Object[Testing], {Fields -> {}}, registeredTypesReference]
			];
			{literal, reference},
			{_DefineObjectType, {_Rule..}}
		]
	},
	Stubs :> {
		registeredTypes=Association[],
		Constellation`Private`registeredTypes=Association[]
	}
];


DefineTests[
	LookupTypeDefinition,
	{
		Example[{Basic, "Look up a type:"},
			LookupTypeDefinition[Object[Sample]],
			KeyValuePattern[{
				Description -> "A reagent used in an experiment.",
				Fields -> {(_Rule | _RuleDelayed)..}
			}]
		],

		Example[{Basic, "Look up a field from a type:"},
			LookupTypeDefinition[Object[Sample], Name],
			KeyValuePattern[{Format -> Single, Class -> String, Description -> "Name of this Object."}]
		],

		Example[{Basic, "Look up an attribute from a field:"},
			LookupTypeDefinition[Object[Sample], Name, Pattern],
			Verbatim[_String]
		],

		Test["Looking up the whole type definition returns the whole thing, for Models:",
			With[
				{check=LookupTypeDefinition[Model[Testing, Person]]},
				{
					Lookup[check, Description],
					Lookup[check, Fields]
				}
			],
			{"This is a description, of more then 10 characters, for this type.", {(_Rule | _RuleDelayed)..}}
		],
		Test["Looking up a field returns only the Field's definition, for Models:",
			With[
				{check=LookupTypeDefinition[Model[Testing, Person], Name]},
				{
					Lookup[check, Format],
					Lookup[check, Class],
					Lookup[check, Description]
				}
			],
			{Single, String, "Name of this Object."}
		],
		Test["Look up the field definition for ID:",
			With[
				{check=LookupTypeDefinition[Model[Testing, Person], ID]},
				{
					Lookup[check, Format],
					Lookup[check, Class],
					Lookup[check, Pattern]
				}
			],
			{Single, String, Verbatim[_String]}
		],
		Test["Look up the field definition for Object:",
			With[
				{check=LookupTypeDefinition[Model[Testing, Person], Object]},
				{
					Lookup[check, Format],
					Lookup[check, Class],
					Lookup[check, Pattern]
				}
			],
			{Single, Expression, Verbatim[Model[Testing, Person, _String]]}
		],
		Test["Look up the field definition for Type:",
			With[
				{check=LookupTypeDefinition[Object[Testing, Person], Type]},
				{
					Lookup[check, Format],
					Lookup[check, Class],
					Lookup[check, Pattern]
				}
			],
			{Single, Expression, Object[Testing, Person]}
		],
		Test["Model field not included if no specific Model type exists:",
			LookupTypeDefinition[Object[Testing, Person, Specific], Model],
			$Failed,
			Messages :> {
				Message[LookupTypeDefinition::NoFieldDefError, Object[Testing, Person, Specific], Model]
			}
		],

		Example[{Messages, "NoFieldDefError", "Provides a message when asked for a nonexistant field:"},
			LookupTypeDefinition[Object[Sample], NotAField],
			$Failed,
			Messages :> {Message[
				LookupTypeDefinition::NoFieldDefError,
				Object[Sample],
				Constellation`Private`NotAField
			]}
		],

		Example[{Messages, "NoFieldComponentDefError", "Provides a message if asked for a field attribute that does not exist:"},
			LookupTypeDefinition[Object[Sample], Name, NotAComponent],
			$Failed,
			Messages :> {Message[
				LookupTypeDefinition::NoFieldComponentDefError,
				Object[Sample],
				Name,
				{Constellation`Private`NotAComponent}
			]}
		]
	},
	Stubs :> {
		registeredTypes=Association[
			Object[Testing, Person] -> {
				Type -> Object[Testing, Person],
				Description -> "This is a description, of more then 10 characters, for this type.",
				UniqueFields -> {},
				Fields -> {
					Number -> {
						Format -> Single,
						Class -> Real,
						Pattern :> _?NumericQ,
						Units -> None,
						Description -> "A number.",
						Required -> False
					},
					Name -> {
						Format -> Single,
						Class -> String,
						Pattern :> _String,
						Units -> None,
						Description -> "A name.",
						Required -> True
					}
				}
			},
			Object[Testing, Person, Specific] -> {
				Type -> Object[Testing, Person, Specific],
				Description -> "This is a description, of more then 10 characters, for this type.",
				UniqueFields -> {},
				Fields -> {
					Number -> {
						Format -> Single,
						Class -> Real,
						Pattern :> _?NumericQ,
						Units -> None,
						Description -> "A number.",
						Required -> False
					},
					Name -> {
						Format -> Single,
						Class -> String,
						Pattern :> _String,
						Units -> None,
						Description -> "A name.",
						Required -> True
					}
				}
			},
			Model[Testing, Person] -> {
				Type -> Model[Testing, Person],
				Description -> "This is a description, of more then 10 characters, for this type.",
				UniqueFields -> {},
				Fields -> {
					Number -> {
						Format -> Single,
						Class -> Real,
						Pattern :> _?NumericQ,
						Units -> None,
						Description -> "A number.",
						Required -> False
					},
					Name -> {
						Format -> Single,
						Class -> String,
						Pattern :> _String,
						Units -> None,
						Description -> "A name.",
						Required -> True
					}
				}
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidTypeQ*)
DefineTests[
	ValidTypeQ,
	{
		Example[{Basic, "Returns True if the definition for the given SLL Type is correctly formatted:"},
			ValidTypeQ[Object[Example, Data]],
			True,
			Stubs :> {
				registeredTypes=Association[
					Object[Example, Data] -> {
						Type -> Object[Example, Data],
						Description -> "This is some sort of valid description.",
						CreatePrivileges -> Developer,
						Cache -> Download,
						UniqueFields -> {},
						Fields -> {
							Strands -> {
								Format -> Multiple,
								Class -> {Integer, Expression},
								Pattern :> {_Integer, _?NucleicAcids`StrandQ},
								Units -> {None, None},
								Category -> "Organizational Information",
								Required -> False,
								Description -> "Storing weird strand expressions.",
								Abstract -> True,
								Headers -> {"Header 1", "Header 2"}
							}
						}
					}
				]
			}
		],

		Example[{Basic, "Returns True if the definition for the given SLL Type is correctly formatted, for Models:"},
			ValidTypeQ[Model[Example, Data]],
			True,
			Stubs :> {
				registeredTypes=Association[
					Model[Example, Data] -> {
						Type -> Model[Example, Data],
						Description -> "This is some sort of valid description.",
						CreatePrivileges -> Developer,
						Cache -> Download,
						UniqueFields -> {},
						Fields -> {
							Strands -> {
								Format -> Multiple,
								Class -> {Integer, Expression},
								Pattern :> {_Integer, _?NucleicAcids`StrandQ},
								Units -> {None, None},
								Category -> "Organizational Information",
								Required -> False,
								Description -> "Storing weird strand expressions.",
								Abstract -> True,
								Headers -> {"Header 1", "Header 2"}
							}
						}
					}
				]
			}
		],

		Example[{Options, CheckServer, "Indicate if the validity checks for the type should include comparing the database type definition to the SLL type definition:"},
			ValidTypeQ[Object[Example, Data], CheckServer -> False],
			True,
			Stubs :> {
				registeredTypes=Association[
					Object[Example, Data] -> {
						Type -> Object[Example, Data],
						Description -> "This is some sort of valid description.",
						CreatePrivileges -> Developer,
						Cache -> Download,
						UniqueFields -> {},
						Fields -> {
							Strands -> {
								Format -> Multiple,
								Class -> {Integer, Expression},
								Pattern :> {_Integer, _?NucleicAcids`StrandQ},
								Units -> {None, None},
								Category -> "Organizational Information",
								Required -> False,
								Description -> "Storing weird strand expressions.",
								Abstract -> True,
								Headers -> {"Header 1", "Header 2"}
							}
						}
					}
				]
			}
		],

		Test["Returns False if Cache key is missing:",
			ValidTypeQ[Model[Example, Data]],
			False,
			Stubs :> {
				registeredTypes=Association[
					Model[Example, Data] -> {
						Type -> Model[Example, Data],
						Description -> "This is some sort of valid description.",
						CreatePrivileges -> Developer,
						UniqueFields -> {},
						Fields -> {
							Strands -> {
								Format -> Multiple,
								Class -> {Integer, Expression},
								Pattern :> {_Integer, _?NucleicAcids`StrandQ},
								Units -> {None, None},
								Category -> "Organizational Information",
								Required -> False,
								Description -> "Storing weird strand expressions.",
								Abstract -> True
							}
						}
					}
				]
			}
		],

		Test["Returns False if Cache key is not Download|Session:",
			ValidTypeQ[Model[Example, Data]],
			False,
			Stubs :> {
				registeredTypes=Association[
					Model[Example, Data] -> {
						Type -> Model[Example, Data],
						Description -> "This is some sort of valid description.",
						CreatePrivileges -> Developer,
						Cache -> Taco,
						UniqueFields -> {},
						Fields -> {
							Strands -> {
								Format -> Multiple,
								Class -> {Integer, Expression},
								Pattern :> {_Integer, _?NucleicAcids`StrandQ},
								Units -> {None, None},
								Category -> "Organizational Information",
								Required -> False,
								Description -> "Storing weird strand expressions.",
								Abstract -> True
							}
						}
					}
				]
			}
		],

		Example[{Additional, "Returns False if descriptions for fields do not start with uppercase and end with a period:"},
			ValidTypeQ[Object[Example, Data]],
			False,
			Stubs :> {
				registeredTypes=Association[
					Object[Example, Data] -> {
						Type -> Object[Example, Data],
						CreatePrivileges -> Developer,
						Description -> "This is some sort of valid description.",
						Cache -> Download,
						UniqueFields -> {},
						Fields -> {
							Strands -> {
								Format -> Multiple,
								Class -> {Integer, Expression},
								Pattern :> {_Integer, _?NucleicAcids`StrandQ},
								Units -> {None, None},
								Category -> "Organizational Information",
								Required -> False,
								Description -> "Storing weird strand expressions",
								Abstract -> True
							}
						}
					}
				]
			}
		],

		Example[{Additional, "Returns False if descriptions for fields do not start with uppercase and end with a period, for Models:"},
			ValidTypeQ[Model[Example, Data]],
			False,
			Stubs :> {
				registeredTypes=Association[
					Model[Example, Data] -> {
						Type -> Model[Example, Data],
						CreatePrivileges -> Developer,
						Description -> "This is some sort of valid description.",
						Cache -> Download,
						UniqueFields -> {},
						Fields -> {
							Strands -> {
								Format -> Multiple,
								Class -> {Integer, Expression},
								Pattern :> {_Integer, _?NucleicAcids`StrandQ},
								Units -> {None, None},
								Category -> "Organizational Information",
								Required -> False,
								Description -> "Storing weird strand expressions",
								Abstract -> True
							}
						}
					}
				]
			}
		],

		Example[{Additional, "Returns False if descriptions for fields contain square brackets:"},
			ValidTypeQ[Object[Example, Data]],
			False,
			Stubs :> {
				registeredTypes=Association[
					Object[Example, Data] -> {
						Type -> Object[Example, Data],
						Description -> "This is some sort of valid description.",
						CreatePrivileges -> Developer,
						Cache -> Download,
						UniqueFields -> {},
						Fields -> {
							Strands -> {
								Format -> Multiple,
								Class -> {Integer, Expression},
								Pattern :> {_Integer, _?NucleicAcids`StrandQ},
								Units -> {None, None},
								Category -> "Organizational Information",
								Required -> False,
								Description -> "Otherwise valid description [].",
								Abstract -> True
							}
						}
					}
				]
			}
		],

		Example[{Additional, "Returns False if descriptions for fields contain square brackets, for Models:"},
			ValidTypeQ[Model[Example, Data]],
			False,
			Stubs :> {
				registeredTypes=Association[
					Model[Example, Data] -> {
						Type -> Model[Example, Data],
						Description -> "This is some sort of valid description.",
						CreatePrivileges -> Developer,
						Cache -> Download,
						UniqueFields -> {},
						Fields -> {
							Strands -> {
								Format -> Multiple,
								Class -> {Integer, Expression},
								Pattern :> {_Integer, _?NucleicAcids`StrandQ},
								Units -> {None, None},
								Category -> "Organizational Information",
								Required -> False,
								Description -> "Otherwise valid description [].",
								Abstract -> True
							}
						}
					}
				]
			}
		],

		Example[{Additional, "Returns False if storage pattern is _:"},
			ValidTypeQ[Object[Example, Data]],
			False,
			Stubs :> {
				registeredTypes=Association[
					Object[Example, Data] -> {
						Type -> Object[Example, Data],
						Description -> "This is some sort of valid description.",
						CreatePrivileges -> Developer,
						Cache -> Download,
						UniqueFields -> {},
						Fields -> {
							Strands -> {
								Format -> Multiple,
								Class -> {Integer, Expression},
								Pattern :> {_Integer, _},
								Units -> {None, None},
								Category -> "Organizational Information",
								Required -> False,
								Description -> "Storing weird strand expressions.",
								Abstract -> True
							}
						}
					}
				]
			}
		],

		Example[{Additional, "Returns False if storage pattern is _, for Models:"},
			ValidTypeQ[Model[Example, Data]],
			False,
			Stubs :> {
				registeredTypes=Association[
					Model[Example, Data] -> {
						Type -> Model[Example, Data],
						Description -> "This is some sort of valid description.",
						CreatePrivileges -> Developer,
						Cache -> Download,
						UniqueFields -> {},
						Fields -> {
							Strands -> {
								Format -> Multiple,
								Class -> {Integer, Expression},
								Pattern :> {_Integer, _},
								Units -> {None, None},
								Category -> "Organizational Information",
								Required -> False,
								Description -> "Storing weird strand expressions.",
								Abstract -> True
							}
						}
					}
				]
			}
		],

		Example[{Additional, "Returns False if category does not match FieldCategoryP:"},
			ValidTypeQ[Object[Example, Data]],
			False,
			Stubs :> {
				registeredTypes=Association[
					Object[Example, Data] -> {
						Type -> Object[Example, Data],
						Description -> "This is some sort of valid description.",
						CreatePrivileges -> Developer,
						Cache -> Download,
						UniqueFields -> {},
						Fields -> {
							Strands -> {
								Format -> Multiple,
								Class -> {Integer, Expression},
								Pattern :> {_Integer, _?NumericQ},
								Units -> {None, None},
								Category -> "Uncategorized",
								Required -> False,
								Description -> "Storing weird strand expressions.",
								Abstract -> True
							}
						}
					}
				],
				FieldCategoryP=Alternatives["Some Category"]
			}
		],

		Test["Returns True for valid Named Fields:",
			DefineObjectType[Object[Testing],
				{
					Description -> "Description is longer than ten characters",
					Fields -> {
						EmissionFilter -> {
							Format -> Single,
							Class -> {
								Wavelength -> Real,
								Bandpass -> Real,
								Dichroic -> Real
							},
							Pattern :> {
								Wavelength -> GreaterP[0 Nanometer],
								Bandpass -> GreaterP[0 Nanometer],
								Dichroic -> GreaterP[0 Nanometer]
							},
							Units -> {
								Wavelength -> Nanometer,
								Bandpass -> Nanometer,
								Dichroic -> Nanometer
							},
							Description -> "Fluorescence emission filtering used in recording the microscope image.",
							Category -> "Instrument Specifications"
						}
					},
					CreatePrivileges -> Developer,
					Cache -> Download
				}
			];
			ValidTypeQ[Object[Testing]],
			True,
			Stubs :> {
				Constellation`Private`registeredTypes=<||>
			}
		],

		Example[{Additional, "Returns False if Named Field columns are out of order:"},
			DefineObjectType[Object[Testing],
				{
					Description -> "Description is longer than ten characters",
					Fields -> {
						EmissionFilter -> {
							Format -> Single,
							Class -> {
								Wavelength -> Real,
								Dichroic -> Real,
								Bandpass -> Real
							},
							Pattern :> {
								Wavelength -> GreaterP[0 Nanometer],
								Bandpass -> GreaterP[0 Nanometer],
								Dichroic -> GreaterP[0 Nanometer]
							},
							Units -> {
								Wavelength -> Nanometer,
								Bandpass -> Nanometer,
								Dichroic -> Nanometer
							},
							Description -> "Fluorescence emission filtering used in recording the microscope image.",
							Category -> "Instrument Specifications"
						}
					},
					CreatePrivileges -> Developer,
					Cache -> Download
				}
			];
			ValidTypeQ[Object[Testing]],
			False,
			Stubs :> {
				Constellation`Private`registeredTypes=<||>
			}
		],

		Test["Returns False if named field columns are not specified as lists of rules:",
			DefineObjectType[Object[Testing],
				{
					Description -> "Description is longer than ten characters",
					Fields -> {
						EmissionFilter -> {
							Format -> Single,
							Class -> {
								Wavelength -> Real,
								Bandpass -> Real,
								Dichroic -> Real
							},
							Pattern :> {
								Wavelength -> GreaterP[0 Nanometer],
								Bandpass -> GreaterP[0 Nanometer],
								Dichroic -> GreaterP[0 Nanometer]
							},
							Units -> Nanometer,
							Description -> "Fluorescence emission filtering used in recording the microscope image.",
							Category -> "Instrument Specifications"
						}
					},
					CreatePrivileges -> Developer,
					Cache -> Download
				}
			];
			ValidTypeQ[Object[Testing]],
			False,
			Stubs :> {
				Constellation`Private`registeredTypes=<||>
			}
		],

		Test["Returns False if there are duplicate named field columns:",
			DefineObjectType[Object[Testing],
				{
					Description -> "Description is longer than ten characters",
					Fields -> {
						EmissionFilter -> {
							Format -> Single,
							Class -> {
								Wavelength -> Real,
								Bandpass -> Real,
								Dichroic -> Real,
								Dichroic -> Real
							},
							Pattern :> {
								Wavelength -> GreaterP[0 Nanometer],
								Bandpass -> GreaterP[0 Nanometer],
								Dichroic -> GreaterP[0 Nanometer],
								Dichroic -> GreaterP[0 Nanometer]
							},
							Units -> {
								Wavelength -> Nanometer,
								Bandpass -> Nanometer,
								Dichroic -> Nanometer,
								Dichroic -> Nanometer
							},
							Units -> Nanometer,
							Description -> "Fluorescence emission filtering used in recording the microscope image.",
							Category -> "Instrument Specifications"
						}
					},
					CreatePrivileges -> Developer,
					Cache -> Download
				}
			];
			ValidTypeQ[Object[Testing]],
			False,
			Stubs :> {
				Constellation`Private`registeredTypes=<||>
			}
		],

		Test["Returns false if Pattern is not a delayed rule:",
			DefineObjectType[Object[Testing],
				{
					Description -> "Description is longer than ten characters",
					Fields -> {
						BadPattern -> {
							Format -> Single,
							Class -> Real,
							Pattern -> _Real,
							Units -> None,
							Relation -> Null,
							Description -> "Field without a delayedrule pattern.",
							Category -> "Experiments & Simulations"
						}
					},
					CreatePrivileges -> Developer,
					Cache -> Download
				}
			];
			ValidTypeQ[Object[Testing]],
			False,
			Stubs :> {
				Constellation`Private`registeredTypes=<||>
			}
		],

		Example[{Additional, "Returns False if category does not match FieldCategoryP, for Models:"},
			ValidTypeQ[Model[Example, Data]],
			False,
			Stubs :> {
				registeredTypes=Association[
					Model[Example, Data] -> {
						Type -> Model[Example, Data],
						Description -> "This is some sort of valid description.",
						CreatePrivileges -> Developer,
						Cache -> Download,
						UniqueFields -> {},
						Fields -> {
							Strands -> {
								Format -> Multiple,
								Class -> {Integer, Expression},
								Pattern :> {_Integer, _?NumericQ},
								Units -> {None, None},
								Category -> "Uncategorized",
								Required -> False,
								Description -> "Storing weird strand expressions.",
								Abstract -> True
							}
						}
					}
				],
				FieldCategoryP=Alternatives["Some Category"]
			}
		],

		Test["If there are restricted field names in the definition, its fails:",
			ValidTypeQ[Object[Example, Data]],
			False,
			Stubs :> {
				registeredTypes=Association[
					Object[Example, Data] -> {
						Type -> Object[Example, Data],
						Description -> "This is some sort of valid description.",
						CreatePrivileges -> Developer,
						Cache -> Download,
						UniqueFields -> {},
						Fields -> {
							Type -> {
								Format -> Single,
								Class -> String,
								Pattern :> _String,
								Units -> None,
								Category -> "Uncategorized",
								Required -> False,
								Description -> "Fail.",
								Abstract -> True
							}
						}
					}
				]
			}
		],

		Test["If there are restricted field names in the definition, its fails, for Models:",
			ValidTypeQ[Model[Example, Data]],
			False,
			Stubs :> {
				registeredTypes=Association[
					Model[Example, Data] -> {
						Type -> Model[Example, Data],
						Description -> "This is some sort of valid description.",
						CreatePrivileges -> Developer,
						Cache -> Download,
						UniqueFields -> {},
						Fields -> {
							Type -> {
								Format -> Single,
								Class -> String,
								Pattern :> _String,
								Units -> None,
								Category -> "Uncategorized",
								Required -> False,
								Description -> "Fail.",
								Abstract -> True
							}
						}
					}
				]
			}
		],

		Test["Does not evaluate if given an expression that is not an Object Type:",
			ValidTypeQ[horse],
			_ValidTypeQ
		],

		Example[{Messages, "TypeDefinitionStructureError", "Types with improperly formatted Fields provide a message:"},
			DefineObjectType[Object[Testing], {Description -> "A type without fields"}];
			ValidTypeQ[Object[Testing]],
			False,
			Messages :> {
				ValidTypeQ::TypeDefinitionStructureError,
				ValidTypeQ::TypeDefinitionStructureError,
				RunValidQTest::InvalidTests
			},
			Stubs :> {Constellation`Private`registeredTypes=<||>}
		],

		Test["A dangling link fails ValidTypeQ:", With[
			{failures=ValidTypeQ[Object[Example, Data], OutputFormat -> TestSummary][ResultFailures]},

			StringStartsQ[
				Map[#[Description]&, failures],
				"Backlink check:"
			]
		],
			{True},
			Stubs :> {
				registeredTypes=<|
					Object[Example, Data] -> {
						Type -> Object[Example, Data],
						Description -> "Test a dangling link.",
						CreatePrivileges -> Developer,
						Cache -> Download,
						UniqueFields -> {},
						Fields -> {
							DanglingLink -> {
								Format -> Single,
								Class -> Link,
								Pattern :> _Link,
								Relation -> Object[Example, Data][NoSuchField],
								Description -> "Link with bad backlink.",
								Category -> "Experiments & Simulations"
							}
						}
					}
				|>
			}
		],

		Test["A link requires a backlink with the correct index:", With[
			{failures=ValidTypeQ[Object[Example, Data], OutputFormat -> TestSummary][ResultFailures]},

			StringStartsQ[
				Map[#[Description]&, failures],
				"Backlink check:"
			]
		],
			{True, True},
			Stubs :> {
				registeredTypes=<|
					Object[Example, Data] -> {
						Type -> Object[Example, Data],
						Description -> "Test a dangling link.",
						CreatePrivileges -> Developer,
						Cache -> Download,
						UniqueFields -> {},
						Fields -> {
							MismatchedLink -> {
								Format -> Single,
								Class -> {String, Link},
								Pattern :> {_String, _Link},
								Relation -> {Null, Object[Example, Data][Backlink]},
								Description -> "Link with bad backlink.",
								Category -> "Experiments & Simulations",
								Headers -> {"Header 1", "Header 2"}
							},
							Backlink -> {
								Format -> Single,
								Class -> Link,
								Pattern :> _Link,
								Relation -> Object[Example, Data][MismatchedLink, 1],
								Description -> "Link with bad backlink.",
								Category -> "Experiments & Simulations"
							}
						}
					}
				|>
			}
		],

		Test["A named field link requires a backlink with the correct symbol:", With[
			{failures=ValidTypeQ[Object[Example, Data], OutputFormat -> TestSummary][ResultFailures]},

			StringStartsQ[
				Map[#[Description]&, failures],
				"Backlink check:"
			]
		],
			{True},
			Stubs :> {
				registeredTypes=<|
					Object[Example, Data] -> {
						Type -> Object[Example, Data],
						Description -> "Test a dangling link.",
						CreatePrivileges -> Developer,
						Cache -> Download,
						UniqueFields -> {},
						Fields -> {
							MismatchedLink -> {
								Format -> Single,
								Class -> {StringColumn -> String, LinkColumn -> Link},
								Pattern :> {StringColumn -> _String, LinkColumn -> _Link},
								Relation -> {StringColumn -> Null, LinkColumn -> Object[Example, Data][Backlink]},
								Description -> "Link with bad backlink.",
								Category -> "Experiments & Simulations"
							},
							Backlink -> {
								Format -> Single,
								Class -> Link,
								Pattern :> _Link,
								Relation -> Object[Example, Data][MismatchedLink, BadBacklink],
								Description -> "Link with bad backlink.",
								Category -> "Experiments & Simulations"
							}
						}
					}
				|>
			}
		],

		Test["A valid named field link returns true:",
			ValidTypeQ[Object[Example, Data]],
			True,
			Stubs :> {
				registeredTypes=<|
					Object[Example, Data] -> {
						Type -> Object[Example, Data],
						Description -> "Test a dangling link.",
						CreatePrivileges -> Developer,
						Cache -> Download,
						UniqueFields -> {},
						Fields -> {
							MismatchedLink -> {
								Format -> Single,
								Class -> {StringColumn -> String, LinkColumn -> Link},
								Pattern :> {StringColumn -> _String, LinkColumn -> _Link},
								Relation -> {StringColumn -> Null, LinkColumn -> Object[Example, Data][Backlink]},
								Description -> "Link with bad backlink.",
								Category -> "Experiments & Simulations"
							},
							Backlink -> {
								Format -> Single,
								Class -> Link,
								Pattern :> _Link,
								Relation -> Object[Example, Data][MismatchedLink, LinkColumn],
								Description -> "Link with bad backlink.",
								Category -> "Experiments & Simulations"
							}
						}
					}
				|>
			}
		],

		(* ---------------------- QA TESTS ---------------------------- *)
		Test["QA field correctly formatted:",
			ValidTypeQ[Object[Example, Data]],
			True,
			Stubs :> {
				registeredTypes=Association[
					Object[Example, Data] -> {
						Type -> Object[Example, Data],
						Description -> "This is some sort of valid description.",
						CreatePrivileges -> Developer,
						Cache -> Download,
						UniqueFields -> {},
						Fields -> {
							QuantityArray2D -> {
								Format -> Single,
								Class -> QuantityArray,
								Pattern :> QuantityArrayP[{{Second, Meter}..}],
								Units -> {Second, Meter},
								Category -> "Organizational Information",
								Required -> False,
								Description -> "Storing QuantityArray.",
								Abstract -> True
							}
						}
					}
				]
			}
		],
		Test["QA wihtout units fails:",
			ValidTypeQ[Object[Example, Data]],
			False,
			Stubs :> {
				registeredTypes=Association[
					Object[Example, Data] -> {
						Type -> Object[Example, Data],
						Description -> "This is some sort of valid description.",
						CreatePrivileges -> Developer,
						Cache -> Download,
						UniqueFields -> {},
						Fields -> {
							QuantityArray2D -> {
								Format -> Single,
								Class -> QuantityArray,
								Pattern :> QuantityArrayP[{{Second, Meter}..}],
								Category -> "Organizational Information",
								Required -> False,
								Description -> "Storing QuantityArray.",
								Abstract -> True
							}
						}
					}
				]
			}
		],
		Test["QA indexed multiple field correctly formatted:",
			ValidTypeQ[Object[Example, Data]],
			True,
			Stubs :> {
				registeredTypes=Association[
					Object[Example, Data] -> {
						Type -> Object[Example, Data],
						Description -> "This is some sort of valid description.",
						CreatePrivileges -> Developer,
						Cache -> Download,
						UniqueFields -> {},
						Fields -> {
							QuantityArray2D -> {
								Format -> Multiple,
								Class -> {String, Real, QuantityArray},
								Pattern :> {_String, _?NumericQ, QuantityArrayP[{{Second, Meter}..}]},
								Units -> {None, Gram, {Second, Meter}},
								Category -> "Organizational Information",
								Required -> False,
								Description -> "QuantityArray in an indexed multiple.",
								Abstract -> True,
								Headers -> {"Header 1", "Header 2", "Header 3"}
							}
						}
					}
				]
			}
		],
		Test["Link fields correctly formated:",
			ValidTypeQ[Object[Example, Person, Emerald]],
			True,
			Stubs :> {
				registeredTypes=Association[
					Object[Example, Person, Emerald] -> {
						Type -> Object[Example, Person, Emerald],
						Description -> "This is some sort of valid description.",
						CreatePrivileges -> Developer,
						Cache -> Download,
						UniqueFields -> {},
						Fields -> {
							DataRelation -> {
								Format -> Multiple,
								Class -> Link,
								Pattern :> _Link,
								Relation -> Object[Example, Data][PersonRelation],
								Description -> "Any data parsed by this user.",
								Category -> "References",
								Required -> False,
								Abstract -> False
							},
							OneWayData -> {
								Format -> Multiple,
								Class -> Link,
								Pattern :> _Link,
								Relation -> Object[Example, Data],
								Description -> "Any data parsed by this user.",
								Category -> "References",
								Required -> False,
								Abstract -> False
							}
						}
					},
					Object[Example, Data] -> {
						Type -> Object[Example, Data],
						Description -> "This is some sort of valid description.",
						CreatePrivileges -> Developer,
						Cache -> Download,
						UniqueFields -> {},
						Fields -> {
							PersonRelation -> {
								Format -> Single,
								Class -> Link,
								Pattern :> _Link,
								Relation -> Object[Example, Person, Emerald][DataRelation],
								Description -> "Person who made this data.",
								Category -> "References",
								Required -> False,
								Abstract -> False
							}
						}
					}
				]
			}
		],

		Test["Returns False if Indexed field does not have headers:",
			ValidTypeQ[Model[Example, Data]],
			False,
			Stubs :> {
				registeredTypes=Association[
					Model[Example, Data] -> {
						Type -> Model[Example, Data],
						Description -> "This is some sort of valid description.",
						CreatePrivileges -> Developer,
						Cache -> Download,
						UniqueFields -> {},
						Fields -> {
							Strands -> {
								Format -> Multiple,
								Class -> {Integer, Expression},
								Pattern :> {_Integer, _?NucleicAcids`StrandQ},
								Units -> {None, None},
								Category -> "Organizational Information",
								Required -> False,
								Description -> "Storing weird strand expressions.",
								Abstract -> True
							}
						}
					}
				]
			}
		],
		Test["Returns False if headers for Indexed field does not match length of class:",
			ValidTypeQ[Model[Example, Data]],
			False,
			Stubs :> {
				registeredTypes=Association[
					Model[Example, Data] -> {
						Type -> Model[Example, Data],
						Description -> "This is some sort of valid description.",
						CreatePrivileges -> Developer,
						Cache -> Download,
						UniqueFields -> {},
						Fields -> {
							Strands -> {
								Format -> Multiple,
								Class -> {Integer, Expression},
								Pattern :> {_Integer, _?NucleicAcids`StrandQ},
								Units -> {None, None},
								Category -> "Organizational Information",
								Required -> False,
								Description -> "Storing weird strand expressions.",
								Abstract -> True,
								Headers -> {"Header 1", "Header 2", "Header 3"}
							}
						}
					}
				]
			}
		],
		Test["Returns False if headers exist for a field that is not indexed, named, or computable:",
			ValidTypeQ[Model[Example, Data]],
			False,
			Stubs :> {
				registeredTypes=Association[
					Model[Example, Data] -> {
						Type -> Model[Example, Data],
						Description -> "This is some sort of valid description.",
						CreatePrivileges -> Developer,
						Cache -> Download,
						UniqueFields -> {},
						Fields -> {
							Name -> {
								Format -> Single,
								Class -> String,
								Pattern :> _String,
								Description -> "A string field for uniqueness for delete unit test.",
								Category -> "Experiments & Simulations",
								Required -> False,
								Abstract -> False,
								Headers -> {"Header 1"}
							}
						}
					}
				]
			}
		],
		Test["Headers are allowed for Indexed fields if they match the length of the Class:",
			ValidTypeQ[Model[Example, Data]],
			True,
			Stubs :> {
				registeredTypes=Association[
					Model[Example, Data] -> {
						Type -> Model[Example, Data],
						Description -> "This is some sort of valid description.",
						CreatePrivileges -> Developer,
						Cache -> Download,
						UniqueFields -> {},
						Fields -> {
							Strands -> {
								Format -> Multiple,
								Class -> {Integer, Expression},
								Pattern :> {_Integer, _?NucleicAcids`StrandQ},
								Units -> {None, None},
								Category -> "Organizational Information",
								Required -> False,
								Description -> "Storing weird strand expressions.",
								Abstract -> True,
								Headers -> {"Header 1", "Header 2"}
							}
						}
					}
				]
			}
		]

	},
	Stubs :> {
		FieldCategoryP=_String
	},
	SetUp :> (
		clearLookupTypeDefinitions[{Object[Example, Data], Model[Example, Data], Object[Example, Person, Emerald]}];
	),
	TearDown :> (
		clearLookupTypeDefinitions[{Object[Example, Data], Model[Example, Data], Object[Example, Person, Emerald]}];
	)];


(* ::Subsubsection::Closed:: *)
(*correctUnitsQ*)

DefineTests[correctUnitsQ, {
	Test["Single Real with Units:",
		correctUnitsQ[{Format -> Single, Class -> Real, Units -> Meter}],
		True
	],
	Test["Single real with None Units:",
		correctUnitsQ[{Format -> Single, Class -> Real, Units -> None}],
		True
	],
	Test["Single expression without Units rule:",
		correctUnitsQ[{Format -> Single, Class -> Expression}],
		True
	],

	Test["Single Real with NoUnit:",
		correctUnitsQ[{Format -> Single, Class -> Real, Units -> NoUnit}],
		False
	],
	Test["Single Real without Units rule:",
		correctUnitsQ[{Format -> Single, Class -> Real}],
		False
	],
	Test["Single expression with Units:",
		correctUnitsQ[{Format -> Single, Class -> Expression, Units -> Meter}],
		False
	],

	Test["GroupedMultiple with no Units specified:",
		correctUnitsQ[{Format -> Multiple, Class -> {Expression, String}}],
		True
	],
	Test["GroupedMultiple with a None in Units",
		correctUnitsQ[{Format -> Multiple, Class -> {Real, String}, Units -> {Meter, None}}],
		True
	],
	Test["GroupedMultiple with a None for a Real",
		correctUnitsQ[{Format -> Multiple, Class -> {Real, String}, Units -> {None, None}}],
		True
	],

	Test["GroupedMultiple with no Units specified:",
		correctUnitsQ[{Format -> Multiple, Class -> {Real, String}}],
		False
	],
	Test["GroupedMultiple with a NoUnit:",
		correctUnitsQ[{Format -> Multiple, Class -> {Real, String}, Units -> {Meter, NoUnit}}],
		False
	],
	Test["GroupedMultiple with Units specified for a String:",
		correctUnitsQ[{Format -> Multiple, Class -> {Real, String}, Units -> {Meter, Meter}}],
		False
	]
}
];

(* ::Subsubsection::Closed:: *)
(*validFieldQ*)


DefineTests[
	validFieldQ,
	{
		Test["Returns False if LHS of field rule is not a symbol:",
			validFieldQ["Something" -> {}],
			False
		],

		Test["Returns False if input is not a Rule:",
			validFieldQ[Taco],
			False
		],

		Test["Returns False if RHS of input is not a list of Rule|RuleDelayed:",
			validFieldQ[Taco -> {"Taco"}],
			False
		],

		Test["Returns False if RHS of input is missing Format rule:",
			validFieldQ[Taco -> {}],
			False
		],

		Test["Returns False if FieldType does not match FieldClassP:",
			validFieldQ[Taco -> {
				Format -> Taco,
				Class -> Date,
				Required -> True,
				Category -> SomethingElse
			}],
			False
		],

		Test["Returns False if RHS of input is missing StorageType rule:",
			validFieldQ[Taco -> {
				Format -> Single,
				StorageName -> "taco"
			}],
			False
		],

		Test["Returns False if StorageType does not match StorageTypeP:",
			validFieldQ[Taco -> {
				Format -> Single,
				Class -> Taco,
				Required -> True,
				Category -> "Organizational Information"
			}],
			False
		],

		Test["Returns False if RHS of input is missing Required rule:",
			validFieldQ[Taco -> {
				Format -> Single,
				Class -> Integer
			}],
			False
		],

		Test["Returns False if Required is not True|False:",
			validFieldQ[Taco -> {
				Format -> Single,
				StorageName -> "taco",
				Class -> Integer,
				Required -> General,
				Category -> "Organizational Information"
			}],
			False
		],

		Test["Returns False if RHS of input is missing Category rule:",
			validFieldQ[Taco -> {
				Format -> Single,
				StorageName -> "taco",
				Class -> Integer,
				Required -> False
			}],
			False
		],

		Test["Returns False if Category is not a string:",
			validFieldQ[Taco -> {
				Format -> Single,
				Class -> Integer,
				Required -> False,
				Category -> Taco
			}],
			False
		],

		Test["Returns False if RHS of input is missing Description rule:",
			validFieldQ[Taco -> {
				Format -> Single,
				Class -> Integer,
				Required -> False,
				Category -> "Organizational Information"
			}],
			False
		],

		Test["Returns False if Description is not a string:",
			validFieldQ[Taco -> {
				Format -> Single,
				Class -> Integer,
				Required -> False,
				Category -> "Organizational Information",
				Description -> Taco
			}],
			False
		],

		Test["Returns False if RHS of input is missing Pattern rule:",
			validFieldQ[Taco -> {
				Format -> Single,
				Class -> Integer,
				Required -> False,
				Category -> "Organizational Information",
				Description -> "text"
			}],
			False
		],

		Test["Returns False if Abstract rule is not True|False:",
			validFieldQ[Taco -> {
				Format -> Single,
				Class -> Integer,
				Required -> False,
				Description -> "some text",
				Category -> "Organizational Information",
				Pattern :> _,
				Abstract -> Taco
			}],
			False
		],

		Test["Returns True if RHS of input has all required rules:",
			validFieldQ[Taco -> {
				Format -> Single,
				Class -> Integer,
				Required -> False,
				Description -> "some text",
				Category -> "Organizational Information",
				Pattern :> _,
				Abstract -> True
			}],
			True
		],

		Test["Returns True if StorageName is a list of strings:",
			validFieldQ[Taco -> {
				Format -> Single,
				Class -> Integer,
				Required -> False,
				Description -> "some text",
				Category -> "Organizational Information",
				Pattern :> _,
				Abstract -> False
			}],
			True
		],

		Test["Returns True if StorageType is a list of StorageTypeP:",
			validFieldQ[Taco -> {
				Format -> Single,
				Class -> {Integer, Real},
				Required -> False,
				Description -> "some text",
				Category -> "Organizational Information",
				Pattern :> _,
				Abstract -> False
			}],
			True
		],

		Test["Returns True if RHS of input has optional rules:",
			validFieldQ[Taco -> {
				Format -> Single,
				Class -> Integer,
				Required -> False,
				Category -> "Organizational Information",
				Description -> "some text",
				Pattern :> _,
				Relation -> Null,
				Abstract -> False,
				Units -> None
			}],
			True
		],

		Test["Given a type and field as input, looks up the field in the object definition:",
			validFieldQ[Taco, Object[Example, Person, Emerald]],
			True,
			Stubs :> {
				registeredTypes=Association[
					Object[Example, Person, Emerald] -> {
						Class -> Object[User],
						Type -> Object[Example, Person, Emerald],
						Description -> "This is some sort of valid description.",
						UniqueFields -> {},
						Fields -> {
							Taco -> {
								Format -> Single,
								Class -> Integer,
								Required -> False,
								Category -> "Organizational Information",
								Description -> "some text",
								Pattern :> _,
								Relation -> Null,
								Units -> None,
								Abstract -> False
							}
						}
					}
				]
			},
			SetUp :> (
				clearLookupTypeDefinitions[{Object[Example, Person, Emerald]}];
			),
			TearDown :> (
				clearLookupTypeDefinitions[{Object[Example, Person, Emerald]}];
			)],

		Test["Only FieldType,StoragePattern,Description,Expression,Category,Abstract required for Computable fields:",
			validFieldQ[Taco -> {
				Format -> Computable,
				Category -> "Organizational Information",
				Description -> "some text",
				Pattern :> _,
				Expression :> Field[Thing],
				Abstract -> False
			}],
			True
		],

		Test["Return False if Expression field missing from a Computable field definition:",
			validFieldQ[Taco -> {
				Format -> Computable,
				Category -> "Organizational Information",
				Description -> "some text",
				Pattern :> _
			}],
			False
		],

		Test["Given a type and field as input, returns False if field does not exist in object definition:",
			validFieldQ[Taco, Object[User]],
			False,
			Messages :> {
				Message[LookupTypeDefinition::NoFieldDefError, Object[User], Taco]
			}
		],

		Test["Returns False if extra invalid rules:",
			validFieldQ[Taco -> {
				Format -> Single,
				StorageName -> "taco",
				Class -> Integer,
				Required -> False,
				Category -> "Organizational Information",
				Description -> "some text",
				Pattern :> _,
				Category -> "Organizational Information",
				Taco -> 4
			}],
			False
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*lookupTypeFieldNames*)


DefineTests[
	lookupTypeFieldNames,
	{
		Test["The function works as expected.",
			lookupTypeFieldNames[Object[Example, Data]],
			{Strands},
			Stubs :> {
				registeredTypes=Association[
					Object[Example, Data] -> {
						Class -> Object[Data],
						Type -> Object[Example, Data],
						Description -> "This is some sort of valid description.",
						UniqueFields -> {},
						Fields -> {
							Strands -> {
								Format -> Multiple,
								Class -> {Integer, Expression},
								Pattern :> {_Integer, _},
								Units -> {None, None},
								Category -> "Uncategorized",
								Required -> False,
								Description -> "Storing weird strand expressions.",
								Abstract -> True
							}
						}
					}
				]
			}
		]
	}
];





(*
	Check that all fields get their UpValues added.

	The number of UpValues a field gets depends on all the things it's used for. 

	* All fields get at least two UpValues for derefencing 
		- List dereference
		- Failed dereference
	* If the field is exported in an ECL package manifest, it gets another UpValue to track FunctionPackage	
	* If the field is also an ECL function, it gets another UpValue for Usage
	* If the field is also a unit operation / primitive it gets more, but exact number varies
	
*)

DefineTests[fieldUpValues,{
	(* 
		These tests each return the list of symbols that are failing (as opposed to a single True) so that if the test ever fails,
		it's immediately obvious which fields are having problems
	*)
			
	Test["All symbols have dereferncing UpValues:",
		Module[{allFields,failDerefP,hasFailDeferQ},
			(* pattern for one of the dereferencing upvalues *)
			failDerefP[s_Symbol] := Verbatim[HoldPattern[$Failed[s]] :> $Failed];
			(* deref upvalue is in the upvalues*)
			hasFailDeferQ[s_Symbol] := MemberQ[UpValues[s], failDerefP[s]];
			(* find the bad fields*)
			allFields = Fields[Output->Short];
			Select[
				allFields,
				Or[
					Length[UpValues[#]] < 2,
					Not[hasFailDeferQ[#]]
				]&
			]
		],
		{}
	],

	Test["ECL symbols also have FunctionPackage UpValue:",
		Module[{allFields, eclFields, functionPackageP,hasFunctionPackageQ},
			(* pattern for the FunctionPackage UpValue *)
			functionPackageP[s_Symbol] := Verbatim[HoldPattern][HoldPattern[FunctionPackage[s]]] :> _String | $Failed;
			(* deref upvalue is in the upvalues*)
			hasFunctionPackageQ[s_Symbol] := MemberQ[UpValues[s], functionPackageP[s]];
			(* find the bad fields*)
			allFields = Fields[Output->Short];
			eclFields = Select[allFields, Context[#]==="ECL`"&];
			Select[ eclFields, Not[hasFunctionPackageQ[#]]& ]
		],
		{}
	],
	
	Test["ECL functions also have Usage UpValue:",
		Module[{allFields, eclFields, eclFunctions, usageUpValueP,hasUsageUpValueQ},
			(* pattern for a usage UpValue *)
			usageUpValueP[s_Symbol] := Verbatim[HoldPattern][HoldPattern[Usage[s,___]|Verbatim[Condition][Usage[s,___],___]]] :> _;
			(* usage upvalue is in the upvaules *)
			hasUsageUpValueQ[s_Symbol] := MemberQ[UpValues[s], usageUpValueP[s]];
			(* find the bad fields*)
			allFields = Fields[Output->Short];
			eclFields = Select[allFields, Context[#]==="ECL`"&];
			eclFunctions = Select[eclFields, Length[DownValues[#]]>0&];
			Select[eclFunctions,Not[hasUsageUpValueQ[#]]&]
		],
		{}
	]

}];


(*
    Check that 'fieldSymbols' populated.
*)
DefineTests[fieldSymbolsChecks,{
    Test["ECL symbol: ",
        Lookup[Constellation`Private`fieldSymbols,"PeaksAnalyses"],
        PeaksAnalyses
    ],
    Test["Mathematica symbol: ",
        Lookup[Constellation`Private`fieldSymbols,"Messages"],
        Messages
    ],
	Test["Should be more entries than there are fields:",
		Length[Constellation`Private`fieldSymbols] > Length[Fields[Output->Short]],
		True
	]
}];

DefineTests[autoFieldReverseMatchQ,{
	Test["Object[] matches Object head ",
		autoFieldReverseMatchQ[Object[],Object],
		True
	],
	Test["Model[] matches Model head ",
		autoFieldReverseMatchQ[Model[],Model],
		True
	],
	Test["Subtypes match head:",
		{
			autoFieldReverseMatchQ[Object[User,Emerald],Object],
			autoFieldReverseMatchQ[Model[User,Emerald],Model]
		},
		{True,True}
	],
	Test["Only matches existing types:",
		autoFieldReverseMatchQ[Object[Emerald,User],Object],
		False
	]
}];