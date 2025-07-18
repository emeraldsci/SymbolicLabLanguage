(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*Resource*)


DefineUsage[Resource,
	{
		BasicDefinitions->{
			{"Resource[specifications]","resource","uses provided 'specifications' to create a sample, instrument, operator or waste 'resource' required for a protocol."}
		},
		MoreInformation->{
			"Resources can be one of the following types: sample, instrument, operator, and waste.",
			"Each resource contains a set of mandatory and optional keys that describes its requirements.",
			"Sample:",
			"\t Required keys Sample",
     			"\t Optional keys: Type, Container, Amount, Status, Preparation, Fresh",
			"Instrument",
			"\t Required key: Instrument",
			"\t Optional keys: Type, Time, DeckLayout",
			"Waste",
			"\t Required key: WasteType",
			"\t Optional keys: Type, Amount",
			"Operator",
			"\t Required key: Operator,Time",
			"\t Optional keys: Type",
			"Uploading converts a resource into an Object[Resource]."
		},
		Input:>{
			{"specifications",Sequence[_Rule..],"A set of rules to specify a resource."}
		},
		Output:>{
			{"resource",_Resource,"A resource representing the specifications."}
		},
		SeeAlso->{
			"RequireResources",
			"UploadResourceStatus"
		},
		Author->{"robert", "alou", "paul"}
	}
];


(* ::Subsection::Closed:: *)
(*ValidResourceQ*)


DefineUsage[ValidResourceQ,
	{
		BasicDefinitions->{
			{"ValidResourceQ[resource]","result","checks to see if the Resource has all required keys, that all required and optional keys match their patterns and that each Resource passes all tests associated with that Resource type'."}
		},
		MoreInformation->{
		},
		Input:>{
			{"resource",ListableP[_Resource],"A resouce objects(s) to be tested."}
		},
		Output :> {
			{"result", ListableP[BooleanP] | ListableP[_EmeraldTestSummary], "The test result."}
		},
		SeeAlso->{
			"RequireResources",
			"Resource",
			"UploadResourceStatus"
		},
		Author->{"yanzhe.zhu", "george"}
	}
];


(* ::Subsection:: *)
(*RequireResources*)


DefineUsage[RequireResources,
	{
		BasicDefinitions->{
			{"RequireResources[packet]","protocol","populates the RequiredResources field of 'packet', fills in fields of the protocol previously populated by resources, and creates new resource objects."}
		},
		MoreInformation->{
			"This function should be called in at the end of all Experiment functions to make the protocol transform resources into resource objects.",
			"The input to this function should be a list of protocol packets with links to resources in the desired fields.  These will be moved to RequiredResources for Resource Picking during the procedure's execution.",
			"The output will be a list of the protocol(s) that were changed, with the fields featuring resources populated in the input instead the models or samples that were requested.",
			"The RootProtocol option should be used to specify the root protocol (i.e., the highest-level parent protocol) to which these resources ultimately belong.  This will populate the resource's RootProtocol field.",
			"The RootProtocol option will also be used to ensure that if the user is creating a resource for a specific sample or instrument Object, and that same Object is already reserved by another resource with the same RootProtocol, this resource will not be created to avoid accidental double-reservations.",
			"If Upload -> False, RequireResources will return a flat list of the updated protocol as well as the newly-created resource packets.",
			"The only fields RequireResources Downloads are the Models of any Samples, Containers, Parts, or Instruments that are specified directly in the resources.",
			"If all resources only specify models, then nothing is Downloaded.",
			"NOTE: the Replace/Append heads for multiple fields must be specified in the input packets; RequireResources will no longer add them automatically (i.e., <|SamplesIn -> {Link[Object[Sample, \"123\"]]}|> will not automatically become <|Replace[SamplesIn] -> {Link[Object[Sample, \"123]]}|>"
		},
		Input:>{
			{"packet",ListableP[PacketP[{Object[Protocol],Object[Qualification],Object[Maintenance], Object[Program]}]],"The protocol packet to generate the RequiredResources list for."}
		},
		Output:>{
			{"protocol",ListableP[ObjectP[{Object[Protocol],Object[Qualification],Object[Maintenance], Object[Program]}]],"The protocol which was modified."}
		},
		Behaviors -> {
			"ReverseMapping"
		},
		SeeAlso->{
			"UploadResourceStatus",
			"Resource"
		},
		Author->{"daniel.shlian", "eunbin.go", "steven", "dima"}
	}
];


(* ::Subsection::Closed:: *)
(*fulfillableResourceQ*)


DefineUsage[fulfillableResourceQ,
	{
		BasicDefinitions -> {
			{"fulfillableResourceQ[resource]", "bool", "checks whether the input 'resource' can be fulfilled given the current state of the lab."}
		},
		MoreInformation -> {
			"This function is called when generating, accepting, or entering a protocol on all that protocol's resources.",
			"It will make the following checks for resources:",
			"\tChecks if specified samples, models, or containers exist in the database",
			"\tEnsures that all samples and containers are not marked for disposal.",
			"\tEnsures that all samples and containers do not have deprecated models.",
			"\tEnsures that all provided models are not deprecated.",
			"\tEnsures that all samples and containers are not discarded.",
			"\tEnsures that all provided instruments are not retired.",
			"\tIf a storage instrument is provided, there are available storage positions.",
			"\tEnsures that all samples are not expired.  If samples ARE expired, a soft warning is thrown but True is still returned for the sample.",
			"\tIf a model is provided and no samples of that model are available, checks whether new samples of this model can be obtained either by being made in the ECL or ordered from a vendor.",
			"\tIf a model is provided and its product is deprecated, throws a warning indicating that if none of this model remains, the protocol may be aborted.",
			"\tIf a sample was provided directly, there is enough volume that is not already reserved by other resources.",
			"\tIf a consumable sample was provided directly, there is no other resource also reserving this same item.",
			"\tIf a consumable model was provided, there are enough available consumables to fulfill this resource.",
			"\tIf a model was provided and is a consolidatable model (i.e., Chemicals), there is enough total volume of the model across one or several samples",
			"\tIf a model was provided, and is not consolidatable, there is enough volume of one single instance of that model that is not already reserved to fulfill the resource",
			"\tIf a specific sample, volume, and container model were specified, throws a warning if the sample needs to be moved to a new container.",
			"\tIf container models were specified, they are large enough to hold the volume that was requested.",
			"\tIf a sample was provided directly, the user has ownership of that specific sample.",
			"Note that under the following circumstances (assuming the samples are not deprecated, discarded, retired, expired, or set for disposal), fulfillableResourceQ will always return True:",
			"\tIf a reusable model is specified (e.g., a column or a part), because even if it is already reserved by a different protocol, another protocol can simply use it afterwards.",
			"\tIf a StockSolution model is specified, because more can be prepared if not enough currently exists in the lab.",
			"\tIf a resource requesting the model for Milli-Q water is specified, because we can always get as necessary.",
			"\t(Currently, temporarily) If Object[Resource, Operator] or Object[Resource, Instrument] resources are specified, because there are currently no ways these resources can be non-fulfillable.",
			"Note that if given an empty list, will return True if OutputFormat -> SingleBoolean, and {} if OutputFormat -> Boolean"
		},
		Input :> {
			{"resource", ListableP[ObjectP[Object[Resource]] | ListableP[_Resource]], "The resource(s) to be checked for whether they can be fulfilled."}
		},
		Output :> {
			{"bool", ListableP[BooleanP], "The resulting boolean(s) indicating whether the input resources are fulfillable."}
		},
		SeeAlso -> {
			"RequireResources",
			"Resource"
		},
		Author -> {
			"steven", "dima"
		}
	}
];



(* ::Subsection::Closed:: *)
(*fulfillableResources*)


DefineUsage[fulfillableResources,
	{
		BasicDefinitions -> {
			{"fulfillableResources[resource]", "association", "checks whether the input 'resource' can be fulfilled given the current state of the lab, and returns an 'association' containing all the different criteria required to be fulfillable."}
		},
		MoreInformation -> {
			"This function is called within fulfillableResourceQ in order to group the resources by different ways in which they are not fulfillable.",
			"The output association of this function matches fulfillableResourcesP, and each key of this association corresponds to a different fulfillableResourceQ message.",
			"Output Association Key-Value Pairs:",
			Grid[{
				{"Key Name", "Description"},
				{"Resources","List of all resources being checked."},
				{"Fulfillable", "List of Booleans indicating if the resource in question (index matched with the Resources key) is fulfillable."},
				{"InsufficientVolume","List of all resources requesting a specific sample that have insufficient volume/mass available."},
				{"ResourceAlreadyReserved","List of all resources requesting a sample that is already reserved."},
				{"NoAvailableSample", "List of all resources requesting a model that doesn't have any samples with enough volume/mass."},
				{"InsufficientTotalVolume", "List of all resources requesting a model where an insufficient total amount of mass/volume is available."},
				{"NoAvailableModel", "List of all resources requesting a model that has no available instances."},
				{"DeprecatedProduct", "List of all resources requesting a model that has a deprecated product."},
				{"ContainerTooSmall", "List of all resources requesting a sample in a container that is too small to hold the amount requested."},
				{"SampleMustBeMoved", "List of all resources that must be moved to a new container in order for the resource to be fulfilled."},
				{"MissingObjects", "List of all resources that do not exist in the database."},
				{"SamplesMarkedForDisposal", "List of all resources requesting items that are flagged for disposal."},
				{"DeprecatedModels", "List of all resources requesting deprecated models."},
				{"DiscardedSamples", "List of all resources requesting discarded samples."},
				{"ExpiredSamples", "List of all resources requesting expired samples."},
				{"RetiredInstrument", "List of all resources requesting a retired instrument."},
				{"DeprecatedInstrument", "List of all resources requesting a deprecated instrument model."},
				{"DeckLayoutUnavailable", "List of all resources requesting instrument deck layouts that are not available."},
				{"InstrumentUndergoingMaintenance", "List of all resources requesting instruments that are currently undergoing maintenance."},
				{"SamplesOutOfStock", "List of all resources requesting items that are currently out of stock but could be re-ordered."},
				{"SamplesNotOwned", "List of all resources requesting items that are not part of a notebook financed by one of the current financing teams."}
			}]
		},
		Input :> {
			{"resource", ListableP[ObjectP[Object[Resource]]] | ListableP[_Resource], "The resource(s) to be checked for whether they can be fulfilled."}
		},
		Output :> {
			{"association", fulfillableResourcesP, "The output association containing information about which resources cannot be fulfilled and why."}
		},
		SeeAlso -> {
			"RequireResources",
			"Resource"
		},
		Author -> {
			"steven", "dima"
		}
	}
];


(* ::Subsection::Closed:: *)
(*fulfillableResources*)


DefineUsage[AllowedResourcePickingNotebooks,
	{
		BasicDefinitions -> {
			{"AllowedResourcePickingNotebooks[financingTeams, sharingTeams]", "notebooks", "returns all the allowed notebooks from which to resource pick given all the sharing and financing teams a user is part of."}
		},
		MoreInformation -> {
			"This function is called in resource picking and fulfillableResourceQ to ensure samples are only picked from the correct notebooks."
		},
		Input :> {
			{"financingTeams", {ObjectP[Object[Team, Financing]]...}, "The financing team(s) the user is a member of."},
			{"sharingTeams", {ObjectP[Object[Team, Sharing]]...}, "The sharing team(s) the user is a member of."}
		},
		Output :> {
			{"notebooks", {ObjectP[Object[LaboratoryNotebook]]...}, "The notebooks from which the user can resource pick samples."}
		},
		SeeAlso -> {
			"fulfillableResourceQ",
			"populateResourcePickingCache"
		},
		Author -> {"tyler.pabst", "eunbin.go", "steven", "dima"}
	}
];

(* ::Subsection::Closed:: *)
(*ScanValue*)

DefineUsage[
	ScanValue,
	{
		BasicDefinitions->{
			{"ScanValue[labware, container]","reference","Provides the object which is actually used to identify the 'labware' when scanning it in the lab."}
		},
		MoreInformation->{
			"Labware that is self contained such as items and parts is always scanned directly",
			"Autoclave bags are scanned instead of the items inside them",
			"Aseptic bags are scanned instead of the items inside them",
			"If a cap doesn't have a sticker (the Barcode field in its model is set to False) the container it's on is scanned instead",
			"Stickers are never printed for samples. Their containers are scanned instead."
		},
		Input:>{
			{"labware",ObjectP[],"An object which needs to be selected/verified by scanning a sticker in the lab."},
			{"container",ObjectP[],"The container of the labware."}
		},
		Output:>{
			{"reference",ObjectP[],"The object which should actually be scanned."}
		},
		SeeAlso->{
			"ModelInstances",
			"FluidContainerTypes"
		},
		Author->{"hayley", "mohamad.zandian"}
	}
];

(* ::Subsection::Closed:: *)
(*ModelObjectType*)

DefineUsage[
	ModelObjectType,
	{
		BasicDefinitions->{
			{"ModelObjectType[modelType]","objectType","Provides the object type corresponding to a given model."}
		},
		MoreInformation->{
		},
		Input:>{
			{"model",TypeP[],"The model type to convert."}
		},
		Output:>{
			{"object",TypeP[],"The object type associated with the input model type."}
		},
		SeeAlso->{
			"ModelInstances",
			"Types"
		},
		Author->{"robert", "alou", "hayley"}
	}
];

(* use the new DefineUsage style b/c we need to expand the provided options *)
DefineUsage[
	ModelInstances,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ModelInstances[Resource,CurrentProtocol]", "Instances"},
				Description -> "returns a list of 'Objects' that can be picked to satisfy 'Resource'.",
				Inputs :> {
					{
						InputName -> "Resource",
						Description -> "Any resource in need of fulfillment.",
						Widget -> Widget[
							Type -> Object,
							Pattern :> ObjectP[Object[Resource, Sample]]
						]
					},
					{
						InputName -> "CurrentProtocol",
						Description -> "The protocol or subprotocol which is currently attempting to pick the objects to satisfy the provided resource.",
						Widget -> Alternatives[
							Widget[
								Type -> Object,
								Pattern :> ObjectP[ProtocolTypes[]]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null]
							]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "objects",
						Description -> "The objects which the given protocol is allowed to pick to satisfy the provided resource.",
						Pattern :> {ObjectP[]..}
					}
				}
			},
			{
				Definition -> {"ModelInstances[Model,Amount,AllowedContainerModels,AllowedNotebooks,RootProtocol,CurrentProtocol]", "Objects"},
				Description -> "returns a list of 'Objects' that can be picked to satisfy a list of requirements dictated by 'Model', 'Amount', 'AllowedContainerModels', 'AllowedNotebooks', 'RootProtocol', 'CurrentProtocol'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Model",
							Description -> "Any model(s) in need of fulfillment.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Sample], Model[Item]}]
							]
						},
						{
							InputName -> "Amount",
							Description -> "The amount(s) of the sample needed to fulfill the model(s).",
							Widget -> Widget[
								Type -> Expression,
								Pattern :> Null | MassP | VolumeP | NumericP | UnitsP[Unit],
								Size -> Line
							]
						},
						{
							InputName -> "AllowedContainerModels",
							Description -> "A list of container model(s) that the sample is in in order to fulfill the model.",
							Widget -> Alternatives[
								Adder[Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Container]]
								]],
								Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[{}]
								]
							]
						},
						IndexName -> "fulfillment models"
					],
					{
						InputName -> "AllowedNotebooks",
						Description -> "The notebook(s) that the sample that belongs to in order to fulfill the model.",
						Widget -> Alternatives[
							Adder[
								Widget[
									Type -> Object,
									Pattern :> ObjectP[Object[LaboratoryNotebook]]
								]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[{}]
							]
						]
					},
					{
						InputName -> "RootProtocol",
						Description -> "The protocol or subprotocol which is currently attempting to pick the objects to satisfy the provided resource.",
						Widget -> Alternatives[
							Widget[
								Type -> Object,
								Pattern :> ObjectP[ProtocolTypes[]]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null]
							]
						]
					},
					{
						InputName -> "CurrentProtocol",
						Description -> "The protocol or subprotocol which is currently attempting to pick the objects to satisfy the provided model.",
						Widget -> Alternatives[
							Widget[
								Type -> Object,
								Pattern :> ObjectP[ProtocolTypes[]]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null]
							]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "objects",
						Description -> "The objects which the given protocol is allowed to pick to satisfy the provided model.",
						Pattern :> {ObjectP[]..}
					}
				}
			}
		},
		MoreInformation -> {
			"Objects must meet a number of general criteria to be pickable - e.g. they can't be expired, restricted or discarded",
			"Disposable containers can only be picked if they are stocked to ensure they are truly clean and content-less."
		},
		SeeAlso -> {
			"WhyCantIPickThisSample",
			"RequireResources"
		},
		Author -> {"hayley", "mohamad.zandian"}
	}
];


DefineUsage[
	ConsolidationInstances,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ConsolidationInstances[Model,Amount,AllowedNotebooks,RootProtocol,CurrentProtocol]", "Results"},
				Description -> "returns an information association 'Results' that can be consolidated to fulfill the 'Model' of 'Amount', along with other requirements dictated by'AllowedNotebooks', 'RootProtocol', and 'CurrentProtocol'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Model",
							Description -> "Any model(s) in need of fulfillment.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Sample], Model[Item]}]
							]
						},
						{
							InputName -> "Amount",
							Description -> "The amount(s) of the sample needed to fulfill the model(s).",
							Widget -> Widget[
								Type -> Expression,
								Pattern :> Null | MassP | VolumeP | NumericP | UnitsP[Unit],
								Size -> Line
							]
						},
						IndexName -> "fulfillment models"
					],
					{
						InputName -> "AllowedNotebooks",
						Description -> "The notebook(s) that the sample that belongs to in order to fulfill the model.",
						Widget -> Alternatives[
							Adder[
								Widget[
									Type -> Object,
									Pattern :> ObjectP[Object[LaboratoryNotebook]]
								]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[{}]
							]
						]
					},
					{
						InputName -> "RootProtocol",
						Description -> "The protocol or subprotocol which is currently attempting to pick the objects to satisfy the provided resource.",
						Widget -> Alternatives[
							Widget[
								Type -> Object,
								Pattern :> ObjectP[ProtocolTypes[]]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null]
							]
						]
					},
					{
						InputName -> "CurrentProtocol",
						Description -> "The protocol or subprotocol which is currently attempting to pick the objects to satisfy the provided model.",
						Widget -> Alternatives[
							Widget[
								Type -> Object,
								Pattern :> ObjectP[ProtocolTypes[]]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null]
							]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "Results",
						Description -> "The association result that list objects which the given protocol is allowed to pick to satisfy the provided model.",
						Pattern :> (AssociationMatchP[<|"PossibleSamples" -> {ObjectReferenceP[]..}, "SamplesAmounts" -> {(VolumeP | MassP)..}, "UserOwned" -> {BooleanP..}, "RequestedModel" -> ObjectReferenceP[]|>] | {})
					}
				}
			}
		},
		MoreInformation -> {
			"Objects must meet a number of general criteria to be pickable - e.g. they can't be expired, restricted or discarded, in a hermetic container."
		},
		SeeAlso -> {
			"ModelInstances"
		},
		Author -> {"tyler.pabst", "eunbin.go"}
	}
];


DefineUsage[
	RootProtocol,
	{
		BasicDefinitions->{
			{"RootProtocol[protocol]","root","Returns the root protocol when given any protocol in the protocol tree."}
		},
		MoreInformation->{
		},
		Input:>{
			{"protocol",ObjectP[ProtocolTypes[]],"Any protocol whose root protocol is desired."}
		},
		Output:>{
			{"root",ObjectP[ProtocolTypes[]],"The top level protocol."}
		},
		SeeAlso->{
			"Download"
		},
		Author->{"hayley"}
	}
];

DefineUsage[
	ResourcesOnCart,
	{
		BasicDefinitions->{
			{"ResourcesOnCart[allResources]","cartResources","Filters the list of objects returning only those that are on the cart at any level."}
		},
		MoreInformation->{
			"Only self-contained objects are returned - for instance sample containers but not the samples themselves are returned."
		},
		Input:>{
			{"allResources",{ObjectP[]...},"A list of objects InUse by the protocol."}
		},
		Output:>{
			{"cartResources",{ObjectP[]...},"A filtered list of objects currently somewhere on a cart."}
		},
		SeeAlso->{
		},
		Author->{"hayley", "mohamad.zandian"}
	}
];