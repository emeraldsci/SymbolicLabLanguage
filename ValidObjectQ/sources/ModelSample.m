(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validModelSampleQTests*)


validModelSampleQTests[packet : PacketP[Model[Sample]]] := Module[
	{
		identifier, modelExistsQ, nameAlreadyExistsQ, prodPackets, storageConditionPackets, storageConditionPacketsToList,
		compositionNotebookPackets, solventPackets
	},

	(* get the identifier *)
	identifier = FirstCase[Lookup[packet, {Name, MolecularFormula, IUPAC, CAS, UNII, InChI, InChIKey, Object}], Except[_Missing], packet];

	(* figure out if we're making a new model or not, and if something with this name already exists  *)
	(* need to do some weridness with not existing because otherwise DatabaseMemberQ[Model[Sample, Null]] will be unevaluated, not False *)
	{modelExistsQ, nameAlreadyExistsQ} = DatabaseMemberQ[{packet, Append[Lookup[packet, Type], (Lookup[packet, Name] /. {Null -> "id:DoesNotExist"})]}];

	(* do our one Download call *)
	{
		prodPackets,
		storageConditionPackets,
		compositionNotebookPackets,
		solventPackets
	} = Download[
		packet,
		{
			Packet[Products[{Deprecated, NotForSale, Stocked, Notebook}]],
			Packet[DefaultStorageCondition[{Flammable, Acid, Base, Pyrophoric}]],
			Packet[Composition[[All, 2]][Notebook]],
			Packet[ConcentratedBufferDiluent[UsedAsSolvent]]
		}
	];
	storageConditionPacketsToList=If[MatchQ[storageConditionPackets,Null],{},storageConditionPackets];

	{

		(* General fields filled in *)
		NotNullFieldTest[packet, {Authors, Expires, DefaultStorageCondition, State, BiosafetyLevel}, Message -> Hold[Error::RequiredOptions], MessageArguments -> {identifier}],

		(* fields that must be populated together *)
		RequiredTogetherTest[packet, {Waste, WasteType}],
		RequiredTogetherTest[packet, {FixedAmounts, TransferOutSolventVolumes}],
		RequiredTogetherTest[packet, {ConcentratedBufferDilutionFactor, ConcentratedBufferDiluent}],
		Test["BaselineStock must be specified together with ConcentratedBufferDilutionFactor and ConcentratedBufferDiluent:",
			Or[
				And[
					!NullQ[Lookup[packet, ConcentratedBufferDiluent]],
					!NullQ[Lookup[packet, BaselineStock]],
					!NullQ[Lookup[packet, ConcentratedBufferDilutionFactor]]
				],
				NullQ[Lookup[packet, BaselineStock]]
			],
			True
		],

		Test["If FixedAmounts is populated, SingleUse -> True and SampleHandling -> Fixed:",
			If[MatchQ[Lookup[packet, FixedAmounts],{(MassP|VolumeP)..}],
				TrueQ[Lookup[packet, SingleUse]] && MatchQ[Lookup[packet, SampleHandling], Fixed],
				True
			],
			True
		],

		Test["FixedAmounts and TransferOutSolventVolumes have same length:",
			If[MatchQ[Lookup[packet, FixedAmounts],{(MassP|VolumeP)..}]||MatchQ[Lookup[packet, TransferOutSolventVolumes],{VolumeP..}],
				MatchQ[Length[Lookup[packet, FixedAmounts]],Length[Lookup[packet, TransferOutSolventVolumes]]],
				True
			],
			True
		],

		Test["The Name of the Model is unique for " <> ToString[identifier] <> ":",
			(* either the model already exists, or it doesn't but the name also doesn't exist; in either case we're good but otherwise we're not *)
			TrueQ[modelExistsQ] || Not[TrueQ[nameAlreadyExistsQ]],
			True,
			Message -> Hold[Error::NonUniqueSampleName],
			MessageArguments -> {identifier}
		],

		Test["The Composition field of the sample must be filled in for the model(s) " <> ToString[identifier] <> ":",
			MatchQ[Lookup[packet, Composition, Null], Except[Null | {}]],
			True,
			Message -> Hold[Error::CompositionRequired],
			MessageArguments -> {identifier}
		],

		Test["If sample model is public all member of Composition are public as well:",
			Or[
				MatchQ[Lookup[packet, Notebook, $Notebook], ObjectP[]],
				MatchQ[Lookup[packet, Composition, {}], {}],
				MatchQ[Lookup[packet, Composition], {{Null, Null} ..}],
				And[
					MatchQ[Lookup[packet, Notebook, $Notebook], Null],
					MatchQ[compositionNotebookPackets,{(Null|KeyValuePattern[{Notebook->Null}]|$Failed)..}]
				]
			],
			True
		],

		(* If the model is in the catalog, it has products (with some notable exceptions) *)
		Test["If this model is in the catalog, it must have at least one product that is not Deprecated/NotForSale and has Stocked -> True (unless the model itself is a preparable stock solution):",
			If[
				Quiet[And[
					(* in the catalog *)
					MemberQ[Catalog`Private`catalogObjs[], Lookup[packet, Object]],
					(* not a Preparable model *)
					!TrueQ[Lookup[packet, Preparable]],
					(* not part of a kit *)
					MatchQ[Lookup[packet, KitProducts], {}],
					(* not water *)
					!MatchQ[Lookup[packet, Object], Model[Sample, "id:8qZ1VWNmdLBD"]] (* Do not require Milli-Q water to have a product *)
				]],
				Lookup[prodPackets, {Deprecated, NotForSale, Stocked, Notebook}],
				{{Null, Null, True, Null}}
			],
			_?(MemberQ[#, {Null | False, Null | False, True, Null}]&)
		],

		(* If Expires \[Equal] True, then either ShelfLife or UnsealedShelfLife must be informed. If either ShelfLife or UnsealedShelfLife is informed, then Expires must \[Equal] True. *)
		Test["ShelfLife and UnsealedShelfLife must be informed if Expires == True; if either ShelfLife or UnsealedShelfLife is informed, Expires must equal True for " <> ToString[identifier] <> ":",
			Lookup[packet, {Expires, ShelfLife, UnsealedShelfLife}],
			Alternatives[
				{True, Except[NullP | {}], Except[NullP | {}]},
				{Except[True], NullP | {}, NullP | {}}
			],
			Message -> Hold[Error::SampleExpires],
			MessageArguments -> {identifier}
		],

		(* The user isn't allowed to set Deprecated in the upload function. *)
		Test["If Deprecated is True, Products must also be Deprecated for " <> ToString[identifier] <> ":",
			If[TrueQ[Lookup[packet, Deprecated]],
				Lookup[prodPackets, Deprecated],
				Null
			],
			{True..} | Null
		],

		Test["A sample of this model cannot be obtained by both a normal product and a kit product (i.e., Products and KitProducts cannot both be populated) for " <> ToString[identifier] <> ":",
			Lookup[packet, {Products, KitProducts}],
			Alternatives[
				{{}, {}},
				{{ObjectP[Object[Product]]..}, {}},
				{{}, {ObjectP[Object[Product]]..}}
			],
			Message -> Hold[Error::BothProductsAndKitProducts],
			MessageArguments -> {identifier}
		],

		Test["DefaultStorageCondition is consistent with model's safety requirements for " <> ToString[identifier] <> ":",
			TrueQ /@ Lookup[packet, {Flammable, Acid, Base, Pyrophoric}],
			TrueQ /@ Lookup[storageConditionPacketsToList, {Flammable, Acid, Base, Pyrophoric}],
			Message -> Hold[Error::InconsistentDefaultStorageCondition],
			MessageArguments -> {identifier}
		],

		(* TransportChilled must not be True if TransportWarmed is populated *)
		Test["If TransportWarmed is populated, TransportChilled must not be True for " <> ToString[identifier] <> ":",
			If[TemperatureQ[Lookup[packet, TransportWarmed]],
				Not[TrueQ[Lookup[packet, TransportChilled]]],
				True
			],
			True,
			Message -> Hold[Error::ConflictingTransportCondition],
			MessageArguments -> {identifier}
		],

		Test["Both Acid and Base cannot be True simultaneously for " <> ToString[identifier] <> ":",
			Lookup[packet, {Acid, Base}],
			Except[{True, True}],
			Message -> Hold[Error::AcidAndBase],
			MessageArguments -> {identifier}
		],

		(* Density of solid or liquid must be \[GreaterEqual] density of liquid hydrogen *)
		Test["Density of any solid or liquid must be greater than that of liquid Hydrogen for " <> ToString[identifier] <> ":",
			Lookup[packet, {State, Density}],
			Alternatives[{Null | Gas, _}, {Solid | Liquid | Consumable, Null | GreaterEqualP[Quantity[0.0708`, ("Grams") / ("Milliliters")]]}],
			Message -> Hold[Error::InvalidDensity],
			MessageArguments -> {identifier}
		],

		(* Density of solid or liquid must be \[LessEqual] density of hassium *)
		Test["Density of any solid or liquid must be less than that of Hassium for " <> ToString[identifier] <> ":",
			Lookup[packet, {State, Density}],
			Alternatives[{Null | Gas, _}, {Solid | Liquid | Consumable, Null | LessEqualP[Quantity[40.7 , ("Grams") / ("Milliliters")]]}],
			Message -> Hold[Error::InvalidDensity],
			MessageArguments -> {identifier}
		],

		(* Density of any gas \[GreaterEqual] density of hydrogen gas *)
		Test["Density of any gas must be greater than that of Hydrogen gas for " <> ToString[identifier] <> ":",
			Lookup[packet, {State, Density}],
			Alternatives[{Solid | Liquid | Consumable | Null, _}, {Gas, Null | GreaterEqualP[Quantity[0.00008988 , ("Grams") / ("Milliliters")]]}],
			Message -> Hold[Error::InvalidDensity],
			MessageArguments -> {identifier}
		],

		(* Density of any gas \[LessEqual] density of tungsten hexafluoride *)
		Test["Density of any gas must be less than that of tungsten hexafluoride gas for " <> ToString[identifier] <> ":",
			Lookup[packet, {State, Density}],
			Alternatives[{Solid | Liquid | Consumable | Null, _}, {Gas, Null | LessEqualP[Quantity[0.0124 , ("Grams") / ("Milliliters")]]}],
			Message -> Hold[Error::InvalidDensity],
			MessageArguments -> {identifier}
		],

		Test["If a sample is marked as pungent it must also be set to ventilated for " <> ToString[identifier] <> ":",
			If[TrueQ[Lookup[packet, Pungent]],
				TrueQ[Lookup[packet, Ventilated]],
				True
			],
			True,
			Message -> Hold[Error::VentilatedRequired],
			MessageArguments -> {identifier}
		],

		Test["The contents of the Name field is a member of the Synonyms field for " <> ToString[identifier] <> ":",
			Module[{synonyms, name},
				{synonyms, name} = Lookup[packet, {Synonyms, Name}, Null];
				Or[
					MatchQ[{synonyms, name}, {{}, Null}],
					MemberQ[synonyms, name]
				]
			],
			True,
			Message -> Hold[Error::NameIsNotPartOfSynonyms],
			MessageArguments -> {identifier}
		],

		(* Tests that only apply if MSDSRequired is not False *)
		If[!MatchQ[Lookup[packet, MSDSRequired], False],
			NotNullFieldTest[packet, {Flammable, MSDSFile, NFPA, DOTHazardClass}, Message -> Hold[Error::RequiredMSDSOptions], MessageArguments -> {identifier}],
			Nothing
		],

		Test["IncompatibleMaterials is populated and contains either just None or a list of incompatible materials for " <> ToString[identifier] <> ":",
			Lookup[packet, IncompatibleMaterials],
			{None} | {MaterialP..},
			Message -> Hold[Error::IncompatibleMaterials],
			MessageArguments -> {identifier}
		],

		(* Other tests *)
		Test["If MeltingPoint and BoilingPoint are both provided, BoilingPoint must be above MeltingPoint for " <> ToString[identifier] <> ":",
			Module[{meltingPoint, boilingPoint},
				{meltingPoint, boilingPoint} = Lookup[packet, {MeltingPoint, BoilingPoint}];
				If[!NullQ[meltingPoint] && !NullQ[boilingPoint],
					(meltingPoint) <= (boilingPoint),
					True
				]
			],
			True,
			Message -> Hold[Error::MeltingBoilingPoint],
			MessageArguments -> {identifier}
		],

		(* Solvent Tests *)
		Test["If UsedAsSolvent is True, State must be Liquid for " <> ToString[identifier] <> ":",
			If[MatchQ[Lookup[packet,UsedAsSolvent], True],
				MatchQ[Lookup[packet,State],Liquid],
				True
			],
			True,
			Message -> Hold[Error::UsedAsSolventSolid],
			MessageArguments -> {identifier}
		],

		Test["If ConcentratedBufferDiluent is populated for " <> ToString[identifier] <> ". The populated Model[Sample] must have UsedAsSolvent -> True:",
			If[!NullQ[Lookup[packet,ConcentratedBufferDiluent]],
				MatchQ[Lookup[solventPackets,UsedAsSolvent],True],
				True
			],
			True,
			Message -> Hold[Error::NonSolventConcentratedBufferDiluent],
			MessageArguments -> {identifier}
		],

		Test["If UsedAsSolvent is True or UsedAsMedia is True, Solvent and Media must be Null for " <> ToString[identifier] <> ":",
			If[MatchQ[Lookup[packet,UsedAsSolvent], True] || MatchQ[Lookup[packet,UsedAsMedia], True],
				MatchQ[Lookup[packet,Solvent],Null] && MatchQ[Lookup[packet,Media],Null],
				True
			],
			True,
			Message -> Hold[Error::UsedAsSolventTrueAndPopulatedSolvent],
			MessageArguments -> {identifier}
		],

		Test["If Solvent or Media is populated, UsedAsSolvent and UsedAsMedia must be False for " <> ToString[identifier] <> ":",
			If[MatchQ[Lookup[packet,Solvent], ObjectP[Model[Sample]]] || MatchQ[Lookup[packet,Media], ObjectP[Model[Sample]]],
				MatchQ[Lookup[packet,UsedAsSolvent],False] && MatchQ[Lookup[packet,UsedAsMedia],False],
				True
			],
			True,
			Message -> Hold[Error::UsedAsSolventTrueAndPopulatedSolvent],
			MessageArguments -> {identifier}
		],

		Test["If UsedAsMedia is set to True, then UsedAsSolvent must also be set to True for " <> ToString[identifier] <> ":",
			If[MatchQ[Lookup[packet, UsedAsMedia], True],
				MatchQ[Lookup[packet,UsedAsSolvent], True],
				True
			],
			True
		],

		Test["If Solvent is set to a Model[Sample], then Media cannot also be set to a Model[Sample], and vice versa, for " <> ToString[identifier] <> ":",
			If[MatchQ[Lookup[packet,Solvent], ObjectP[Model[Sample]]] && MatchQ[Lookup[packet,Media], ObjectP[Model[Sample]]],
				False,
				True
			],
			True
		],

		Test["If Living is set to True, then Solvent cannot be a Model[Sample], for " <> ToString[identifier] <> " (please use the Media field instead):",
			If[MatchQ[Lookup[packet,Living], True] && MatchQ[Lookup[packet,Solvent], ObjectP[Model[Sample]]],
				False,
				True
			],
			True
		],

		Test["If Living is set to False, then Media cannot be set to a Model[Sample], for " <> ToString[identifier] <> ":",
			If[MatchQ[Lookup[packet,Living], False] && MatchQ[Lookup[packet,Media], ObjectP[Model[Sample]]],
				False,
				True
			],
			True
		],

		Test["If Living is set to True, then neither UsedAsSolvent or UsedAsMedia can be set to True for " <> ToString[identifier] <> ":",
			If[MatchQ[Lookup[packet,Living], True],
				!(MatchQ[Lookup[packet, UsedAsSolvent], True] || MatchQ[Lookup[packet, UsedAsMedia], True]),
				True
			],
			True
		],

		Test["If Tablet is True, the State must be Solid:",
			If[TrueQ[Lookup[packet, Tablet]],
				SameQ[Lookup[packet, State], Solid],
				True
			],
			True
		],

		Test["If Fiber is True, the State must be Solid:",
			If[TrueQ[Lookup[packet, Fiber]],
				SameQ[Lookup[packet, State], Solid],
				True
			],
			True
		],

		Test["Fiber and Tablet must not be True at the same time:",
			If[TrueQ[Lookup[packet, Fiber]]&&TrueQ[Lookup[packet, Tablet]],
				False,
				True
			],
			True
		],

		Test["If FiberCircumference is populated, the sample must be Fiber:",
			If[Not[NullQ[Lookup[packet, FiberCircumference]]],
				TrueQ[Lookup[packet, Fiber]],
				True
			],
			True
		]
	}
];

Error::CompositionRequired="For the input(s), `1`, the option Composition is required. If you do not know the composition of this sample, please set the Composition to {{Null, Null}}. Please provide a composition for these sample(s) to upload a valid object.";
Error::SampleExpires="For the input(s), `1`, the options {ShelfLife, UnsealedShelfLife} must be non-Null if Expires->True and Expires must be set to True if these options are non-Null. Please fix these options to upload a valid object.";
Error::NonUniqueSampleName="There already exists an object with the given name for input(s), `1`. Please choose a different name or use the already uploaded model.";
Error::BothProductsAndKitProducts="The inputs, `1`, cannot be purchased via both a normal product and a kit product ( Products and KitProducts cannot both be populated). Please change these options to upload a valid sample.";
Error::InconsistentDefaultStorageCondition="The input(s), `1`, have a DefaultStorageCondition that is not consistent with the options {Flammable, Acid, Basic, Pyrophoric}. Please make sure that these options match in order to upload a valid model.";
Error::ConflictingTransportCondition="The input(s), `1`, have both TransportChilled and TransportWarmed set. Please only set one transport condition in order to upload a valid model.";
Error::UsedAsSolventSolid="The input(s), `1`, have UsedAsSolvent set as True, but have a Solid State. A sample must have Liquid State if it is UsedAsSolvent. Please change the State or UsedAsSolvent fields.";
Error::NonSolventConcentratedBufferDiluent="The input(s), `1`, have a ConcentratedBufferDiluent that is not UsedAsSolvent -> True. The ConcentratedBufferDiluent of a sample must be a solvent. Please change this option to a valid sample.";
Error::UsedAsSolventOrMediaTrueAndPopulatedSolventOrMedia="The input(s), `1`, have UsedAsSolvent set as True or have UsedAsMedia set to True and have a non Null Solvent or a non Null Media. If either UsedAsMedia or UsedAsSolvent are set to true for the sample, then Solvent and Media must both be Null. Please change the Solvent, Media, UsedAsMedia, and UsedAsSolvent fields.";

(* Rest of the options are shared with Model[Molecule]. *)

errorToOptionMap[Model[Sample]]:={
	"Error::NonUniqueSampleName"->{Name},
	"Error::AcidAndBase"->{Acid, Base},
	"Error::InvalidDensity"->{Density},
	"Error::VentilatedRequired"->{Pungent, Ventilated},
	"Error::RequiredOptions"->{Expires,DefaultStorageCondition,State,BiosafetyLevel,DefaultStorageCondition},
	"Error::NameIsNotPartOfSynonyms"->{Name, Synonyms},
	"Error::RequiredMSDSOptions"-> {MSDSRequired,Flammable,MSDSFile,NFPA,DOTHazardClass},
	"Error::IncompatibleMaterials"->{IncompatibleMaterials},
	"Error::MeltingBoilingPoint"->{MeltingPoint, BoilingPoint},

	"Error::SampleExpires"->{ShelfLife, UnsealedShelfLife, Expires},
	"Error::BothProductsAndKitProducts"->{Products,KitProducts},
	"Error::InconsistentDefaultStorageCondition"->{DefaultStorageCondition, Flammable, Acid, Base, Pyrophoric},
	"Error::ConflictingTransportCondition"->{TransportWarmed, TransportChilled},

	(* NOTE: this error is not from a VOQ test, but is for UploadSampleModel.*)
	(* It has to live in this map due for the automatic upload function framework to detect it as an invalid option *)
	"Error::MissingLivingOption"->{Living}
};


(* ::Subsection::Closed:: *)
(*validModelSampleMatrixQTests*)


validModelSampleMatrixQTests[packet:PacketP[Model[Sample,Matrix]]]:= {

	Test["There must be more than one component in the formula:",
		Length[Lookup[packet, Formula]],
		GreaterP[1]
	],

	Test["The contents of the Name field is a member of the Synonyms field:",
		Module[{synonyms, name},
			{synonyms, name} = Lookup[packet, {Synonyms, Name}];
			If[MatchQ[name, _String],
				MemberQ[synonyms, name],
				True
			]
		],
		True
	],

	(* physical fields filled in *)
	Test["State is a Solid if it has no solvent and only solid components, and Liquid otherwise:",
		If[NullQ[Lookup[packet, FillToVolumeSolvent]] && MatchQ[Lookup[packet, Formula][[All, 1]], {MassP..}],
			MatchQ[Lookup[packet, State], Solid],
			MatchQ[Lookup[packet, State], Liquid]
		],
		True
	],

	NullFieldTest[packet, {WettedMaterials}],

	Test["If MSDSRequired is True, then MSDSFile must be informed:",
		Lookup[packet, {MSDSRequired, MSDSFile}],
		{True, Except[NullP | {}]} | {False, _}
	],
	Test["If MSDSRequired is True, then Flammable must be informed:",
		Lookup[packet, {MSDSRequired, Flammable}],
		{True, Except[NullP | {}]} | {False, _}
	],
	Test["If MSDSRequired is True, then NFPA must be informed:",
		Lookup[packet, {MSDSRequired, NFPA}],
		{True, Except[NullP | {}]} | {False, _}
	],
	Test["If MSDSRequired is True, then DOTHazardClass must be informed:",
		Lookup[packet, {MSDSRequired, DOTHazardClass}],
		{True, Except[NullP | {}]} | {False, _}
	],

	Test["If MixUntilDissolved is populated, either MaxMixTime or MaxNumberOfMixes must be populated (and vice versa):",
		Lookup[packet, {MixUntilDissolved, MaxMixTime, MaxNumberOfMixes}],
		Alternatives[
			{Null | False, Null, Null},
			{True, TimeP, Null},
			{True, Null, NumericP}
		]
	],

	Test["If IncubationTime and MixTime are both populated, they must be equal to each other:",
		If[TimeQ[Lookup[packet, IncubationTime]] && TimeQ[Lookup[packet, MixTime]],
			Lookup[packet, IncubationTime] == Lookup[packet, MixTime],
			True
		],
		True
	],

	(* --- fixed amounts invariants --- *)
	(* if the formula field contains a chemical with a fixed amount, only one liquid can be in the formula *)
	Test["A formula with a fixed amounts can only have two components (the fixed amounts + one liquid):",
		Module[
			{formulaModels,formulaChems,nonFixedAliquots, fixedAliquotModel},

			formulaModels = (Lookup[packet,Formula])[[All,2]];

			formulaChems = Download[Cases[formulaModels,ObjectP[Model[Sample]]], Packet[FixedAmounts]];

			fixedAliquotModel = SelectFirst[formulaChems, MatchQ[Lookup[#, FixedAmounts],{(MassP|VolumeP)..}]&, Null];

			If[NullQ[fixedAliquotModel],
				Return[True]
			];

			nonFixedAliquots = DeleteCases[formulaModels,ObjectP[Lookup[fixedAliquotModel, Object]]];

			If[Length[nonFixedAliquots]==1,
				True,
				False
			]
		],
		True
	],

	(* if the formula field contains a chemical with a fixed amounts, the amount in the formula must match an amount in the FixedAmounts field *)
	Test["If a formula has a fixed amounts the amount in the formula must be the same as a value in the FixedAmounts field:",
		Module[
			{formulaModels,formulaChems,fixedAliquotModels, fixedAliquotFieldValues,
				fixedAliquotAmounts, fixedAliquotFormulaAmounts, fixedAliquotFormulaEntries},

			formulaModels = (Lookup[packet,Formula])[[All,2]];

			formulaChems = Download[Cases[formulaModels,ObjectP[Model[Sample]]], Object];

			fixedAliquotFieldValues = Download[formulaChems, FixedAmounts];

			fixedAliquotModels = PickList[
				formulaChems,
				fixedAliquotFieldValues,
				{(MassP|VolumeP)..}
			];
			If[fixedAliquotModels==={},
				Return[True]
			];

			fixedAliquotAmounts = Cases[fixedAliquotFieldValues, {(MassP|VolumeP)..}];

			fixedAliquotFormulaEntries = Select[Lookup[packet, Formula], MemberQ[fixedAliquotModels, Download[#[[2]], Object]]&];

			fixedAliquotFormulaAmounts = fixedAliquotFormulaEntries[[All,1]];

			(* First is justified here since we have a check that StockSolution has only one FixedAmounts component *)
			MemberQ[Flatten@fixedAliquotAmounts, EqualP[First@fixedAliquotFormulaAmounts]]
		],
		True
	],

	(* if the formula field contains a sample with a fixed amounts, the volume in the TransferOutSolventVolumes field must match the volume of the liquid *)
	Test["If a formula has a fixed amounts, the amount of liquid in the formula must match the corresponding volume in the fixed amounts's TransferOutSolventVolumes field:",
		Module[
			{formulaModels,formulaChems, formulaChemPackets, transferOutSolventVolumes,fixedAliquotAmounts,fixedAliquotFormulaEntries,fixedAliquotFormulaAmounts,pickedTransferOutSolventVolume,
				fixedAliquotModel, volumeFormulaEntry},

			formulaModels = (Lookup[packet,Formula])[[All,2]];

			formulaChems = Download[Cases[formulaModels,ObjectP[Model[Sample]]], Object];

			formulaChemPackets = Download[formulaChems, Packet[FixedAmounts, TransferOutSolventVolumes]];

			fixedAliquotModel = SelectFirst[formulaChemPackets, MatchQ[Lookup[#, FixedAmounts],{(MassP|VolumeP)..}]&, Null];

			If[NullQ[fixedAliquotModel],
				Return[True]
			];

			transferOutSolventVolumes = Lookup[fixedAliquotModel, TransferOutSolventVolumes];

			fixedAliquotAmounts = Lookup[fixedAliquotModel, FixedAmounts];

			fixedAliquotFormulaEntries = Select[Lookup[packet, Formula], MemberQ[fixedAliquotModel, Download[#[[2]], Object]]&];

			fixedAliquotFormulaAmounts = fixedAliquotFormulaEntries[[All,1]];

			pickedTransferOutSolventVolume = First[Flatten[PickList[transferOutSolventVolumes,fixedAliquotAmounts,#]&/@fixedAliquotFormulaAmounts]];

			volumeFormulaEntry = SelectFirst[Lookup[packet, Formula][[All, 1]], VolumeQ[#]&, 0 Liter];

			TrueQ[volumeFormulaEntry == pickedTransferOutSolventVolume]
		],
		True
	],


	(* --- unique fields --- *)
	NotNullFieldTest[packet, {Formula, ShelfLife, MSDSRequired, Preparable}],

	Test["If Mixer or MixRate are populated, MixType must be populated:",
		If[RPMQ[Lookup[packet, MixRate]] || MatchQ[Lookup[packet, Mixer], ObjectP[Model[Instrument]]],
			MatchQ[Lookup[packet, MixType], MixTypeP],
			True
		],
		True
	],

	Test["TotalVolume is informed if the matrix model has been prepared at least thrice in the lab via a StockSolution protocol:",
		Module[
			{totalVolume, objectsLength, objectPackets, actualObjectPackets},
			(* need to Download the Length of the Objects field *)
			(* doing this goofiness because the Objects field can be very long, and so in the packet it might be unevaluated behind a :>, in which case Downloading length from it won't work.  If we do the Lookup of the field directly and then take the length, that could work but might take much longer bc Downloading Length of a field is often much faster than getting the field itself *)
			objectsLength = Download[Lookup[packet, Object], Length[Objects]];

			(* only Download most recent 100 objects to avoid this infinitely ballooning if there are more than 100; if the necessary information isn't there, it's not going to be there if you get everything all together anyway *)
			(* need the Quiet because if in a notebook and a different user is also testing the VOQ, then they won't be allowed to Download all these fields since some objects won't be theirs *)
			(* basically, if the object doesn't exist, then that's because of ownership differences and not because anything is wrong *)
			{totalVolume, objectPackets} = If[objectsLength > 100,
				Quiet[Download[packet, {TotalVolume, Packet[Objects[[-100 ;; -1]][{Status, Source, DeveloperObject}]]}], Download::ObjectDoesNotExist],
				Quiet[Download[packet, {TotalVolume, Packet[Objects[{Status, Source, DeveloperObject}]]}], Download::ObjectDoesNotExist]
			];

			(* get the object packets that are not developer objects and came from actual stock solution protocols or transactions *)
			(* in case the stock solution was automatically generated in a SampleManipulation TotalVolume isn't going to be populated and that's okay *)
			actualObjectPackets = Select[objectPackets, Not[TrueQ[Lookup[#, DeveloperObject]]] && MatchQ[Lookup[#, Source], ObjectP[{Object[Protocol, StockSolution], Object[Transaction, Order]}]]&];

			If[
				And[
					Length[actualObjectPackets] >= 3,
					ContainsAny[Lookup[actualObjectPackets, Status, {}], {Stocked, Available, Discarded}] (* in case there is only one sample that's InUse that hasn't gotten a volume yet*)
				],
				MatchQ[totalVolume, Except[Null]],
				True
			]
		],
		True,
		TimeConstraint -> 180
	],

	Test["PreferredSpottingMethod is populated for any matrix models which were not generated automatically:",
		Module[{objectSources},
			objectSources = Download[packet, Objects[Source]];
			If[MemberQ[objectSources, ObjectP[{Object[Protocol, StockSolution], Object[Transaction, Order]}]],
				MatchQ[Lookup[packet, PreferredSpottingMethod], Except[Null]],
				True
			]
		],
		True
	],

	Test["The TotalVolume must be within a reasonable range of the sum of the Formula components:",
		Module[
			{formula, measuredTotalVolume, formulaLiquids, formulaLiquidVolumes, totalFormulaVolume, solvent, formulaSolids, formulaSolidVolumes, solidDensities},

			{formula, measuredTotalVolume, solvent} = Lookup[packet, {Formula, TotalVolume, FillToVolumeSolvent}];

			If[NullQ[measuredTotalVolume],
				Return[True]
			];

			formulaLiquids = Cases[formula, {_, _, _?VolumeQ}];
			formulaSolids = Cases[formula, {_, _, _?MassQ}];
			solidDensities = Download[formulaSolids[[All, 1]], Density];

			(*if it's only solids, return true*)
			If[MatchQ[formulaLiquids, {}], Return[True]];

			formulaLiquidVolumes = Map[
				Function[{formulaLiquidEntry}, formulaLiquidEntry[[2]] * formulaLiquidEntry[[3]]],
				formulaLiquids
			];

			(* estimate how much impact the solids will have on the volume, it's a bad guess but just take 1 gm to be about 1mL*)
			formulaSolidVolumes = MapThread[
				Function[{formulaSolidEntry, density},
					Module[{},
						If[Not[NullQ[density]],
							(formulaSolidEntry[[2]] * formulaSolidEntry[[3]]) / density,
							Unitless[Convert[(formulaSolidEntry[[2]] * formulaSolidEntry[[3]]), Gram]] Milliliter
						]
					]
				],
				{formulaSolids, solidDensities}
			];

			totalFormulaVolume = Total[Flatten[{formulaLiquidVolumes, formulaSolidVolumes}]];

			If[MatchQ[solvent, ObjectP[]],
				measuredTotalVolume > totalFormulaVolume,
				(0.7 * totalFormulaVolume) < measuredTotalVolume < (1.3 * totalFormulaVolume)
			]
		],
		True
	],

	Test["If a matrix has a deprecated component, it must also be deprecated:",
		Module[
			{formula, formulaComponents, deprecatedComponentQ, deprecatedQ},

			formula = Lookup[packet, Formula];
			formulaComponents = formula[[All, 2]];

			(* figure out if the matrix itself is deprecated *)
			deprecatedQ = Lookup[packet, Deprecated];

			(* Download the Deprecated field from all the components *)
			deprecatedComponentQ = Download[formulaComponents, Deprecated];

			(* If there is a deprecated component, then deprecatedQ must be True; otherwise, always True *)
			If[MemberQ[deprecatedComponentQ, True],
				TrueQ[deprecatedQ],
				True
			]
		],
		True
	],

	Test["If one or more component is available only in fixed amounts, VolumeIncrements must be populated:",
		Module[{components, fixedAmounts},
			components = Lookup[packet, Formula][[All, 2]];
			fixedAmounts = Quiet[Download[components, FixedAmounts], Download::FieldDoesntExist] /. {$Failed -> {}};
			{fixedAmounts, Lookup[packet, VolumeIncrements]}
		],
		{{{}..}, _} | {Except[{{}..}], {UnitsP[]..}}
	],

	Test["Unless the Model is deprecated, when UploadStockSolution[" <> ToString[Lookup[packet, Object], InputForm] <> ", Upload -> False] is called, function returns  " <> ToString[Lookup[packet, Object], InputForm] <> "  as output (i.e., combination of all stock solution parameters is valid). $PersonID must be set to the author of this solution to replicate this test:",
		If[!TrueQ[Lookup[packet, Deprecated]],
			Block[{$PersonID = Download[FirstOrDefault[Lookup[packet, Authors]], Object]},
				UploadStockSolution[Lookup[packet, Object], Upload -> False]
			],
			Lookup[packet, Object]
		],
		Alternatives @@ Flatten[{Lookup[packet, Object], Download[Lookup[packet, AlternativePreparations], Object]}],
		TimeConstraint -> 500
	]

};


(* ::Subsection::Closed:: *)
(*validModelSampleMechanismQTests*)


validModelSampleMechanismQTests[packet:PacketP[Model[ReactionMechanism]]]:={

	(* Specific tests *)
	NotNullFieldTest[packet,{
			Species,
			Structures,
			Strands,
			Reactants,
			ReactionProducts,
			ReactionMechanism,
			Reactions,
			ReactionType
		}
	],

	(* sync testing *)
	Test["Reactions match what's inside ReactionMechanism:",
		Module[{reactions,mech},
			{reactions,mech}=Lookup[packet,{Reactions,ReactionMechanism}];
			SameQ[reactions,mech[Reactions]]
		],
		True
	],
	Test["ReactionProducts match what's inside ReactionMechanism:",
		Module[{reactionProducts,mech},
			{reactionProducts,mech}=Lookup[packet,{ReactionProducts,ReactionMechanism}];
			MatchQ[reactionProducts,Computables`Private`reactionProductsComputable[mech]]
		],
		True
	],
	Test["Intermediates match what's inside ReactionMechanism:",
		Module[{intermediates,mech},
			{intermediates,mech}=Lookup[packet,{Intermediates,ReactionMechanism}];
			SameQ[intermediates,Computables`Private`intermediateSpeciesComputable[mech]]
		],
		True
	],
	Test["Reactants match what's inside ReactionMechanism:",
		Module[{reactants,mech},
			{reactants,mech}=Lookup[packet,{Reactants,ReactionMechanism}];
			SameQ[reactants,Computables`Private`reactantsComputable[mech]]
		],
		True
	],
	Test["Strands match what's inside ReactionMechanism:",
		Module[{strands,mech},
			{strands,mech}=Lookup[packet,{Strands,ReactionMechanism}];
			SameQ[strands,Computables`Private`strandsComputable[mech]]
		],
		True
	],
	Test["Structures match what's inside ReactionMechanism:",
		Module[{structures,mech},
			{structures,mech}=Lookup[packet,{Structures,ReactionMechanism}];
			SameQ[structures,Computables`Private`structuresComputable[mech]]
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelSampleMediaQTests*)


validModelSampleMediaQTests[packet:PacketP[Model[Sample, Media]]]:={

	Test["There must be at least one component in the formula:",
		Length[Lookup[packet, Formula]],
		GreaterEqualP[1]
	],

	Test["The contents of the Name field is a member of the Synonyms field:",
		Module[{synonyms,name},
			{synonyms,name}= Lookup[packet,{Synonyms,Name}];
			If[MatchQ[name,_String],
				MemberQ[synonyms,name],
				True
			]
		],
		True
	],

	(* Safety fields filled in *)
	Test["State is a Solid if it has no solvent and only solid components, and Liquid otherwise:",
		If[NullQ[Lookup[packet, FillToVolumeSolvent]] && MatchQ[Lookup[packet, Formula][[All, 1]], {MassP..}],
			MatchQ[Lookup[packet, State], Solid],
			MatchQ[Lookup[packet, State], Liquid]
		],
		True
	],

	Test["If MSDSRequired is True, then MSDSFile must be informed:",
		Lookup[packet,{MSDSRequired,MSDSFile}],
		{True,Except[NullP|{}]}|{False,_}
	],

	(* Fields that should be informed *)
	NotNullFieldTest[packet,{Formula,ShelfLife,MSDSRequired,NFPA,DOTHazardClass,BiosafetyLevel,Preparable}],

	Test["TotalVolume is informed if the media model has been prepared at least thrice in the lab via a StockSolution protocol:",
		Module[
			{totalVolume, objectsLength, objectPackets, actualObjectPackets},
			(* need to Download the Length of the Objects field *)
			(* doing this goofiness because the Objects field can be very long, and so in the packet it might be unevaluated behind a :>, in which case Downloading length from it won't work.  If we do the Lookup of the field directly and then take the length, that could work but might take much longer bc Downloading Length of a field is often much faster than getting the field itself *)
			objectsLength = Download[Lookup[packet, Object], Length[Objects]];

			(* only Download most recent 100 objects to avoid this infinitely ballooning if there are more than 100; if the necessary information isn't there, it's not going to be there if you get everything all together anyway *)
			(* need the Quiet because if in a notebook and a different user is also testing the VOQ, then they won't be allowed to Download all these fields since some objects won't be theirs *)
			(* basically, if the object doesn't exist, then that's because of ownership differences and not because anything is wrong *)
			{totalVolume, objectPackets} = If[objectsLength > 100,
				Quiet[Download[packet, {TotalVolume, Packet[Objects[[-100 ;; -1]][{Status, Source, DeveloperObject}]]}], Download::ObjectDoesNotExist],
				Quiet[Download[packet, {TotalVolume, Packet[Objects[{Status, Source, DeveloperObject}]]}], Download::ObjectDoesNotExist]
			];

			(* get the object packets that are not developer objects and came from actual stock solution protocols or transactions *)
			(* in case the stock solution was automatically generated in a SampleManipulation TotalVolume isn't going to be populated and that's okay *)
			actualObjectPackets = Select[objectPackets, Not[TrueQ[Lookup[#, DeveloperObject]]] && MatchQ[Lookup[#, Source], ObjectP[{Object[Protocol, StockSolution], Object[Transaction, Order]}]]&];

			If[
				And[
					Length[actualObjectPackets] >= 3,
					ContainsAny[Lookup[actualObjectPackets, Status, {}], {Stocked, Available, Discarded}] (* in case there is only one sample that's InUse that hasn't gotten a volume yet*)
				],
				MatchQ[totalVolume, Except[Null]],
				True
			]
		],
		True,
		TimeConstraint -> 180
	],

	(* Should be uninformed *)
	NullFieldTest[packet,{WettedMaterials,Flammable}],

	Test["If MixUntilDissolved is populated, either MaxMixTime or MaxNumberOfMixes must be populated (and vice versa):",
		Lookup[packet, {MixUntilDissolved, MaxMixTime, MaxNumberOfMixes}],
		Alternatives[
			{Null|False, Null, Null},
			{True, TimeP, Null},
			{True, Null, NumericP}
		]
	],

	Test["If IncubationTime and MixTime are both populated, they must be equal to each other:",
		If[TimeQ[Lookup[packet, IncubationTime]] && TimeQ[Lookup[packet, MixTime]],
			Lookup[packet, IncubationTime] == Lookup[packet, MixTime],
			True
		],
		True
	],

	Test["If Mixer or MixRate are populated, MixType must be populated:",
		If[RPMQ[Lookup[packet, MixRate]] || MatchQ[Lookup[packet, Mixer], ObjectP[Model[Instrument]]],
			MatchQ[Lookup[packet, MixType], MixTypeP],
			True
		],
		True
	],

	(* --- fixed aliquot invariants --- *)
	(* if the formula field contains a chemical with a fixed amount, only one liquid can be in the formula *)
	Test["A formula with a fixed amounts can only have two components (the fixed amounts + one liquid):",
		Module[
			{formulaModels,formulaChems,nonFixedAliquots, fixedAliquotModel},

			formulaModels = (Lookup[packet,Formula])[[All,2]];

			formulaChems = Download[Cases[formulaModels,ObjectP[Model[Sample]]], Packet[FixedAmounts]];

			fixedAliquotModel = SelectFirst[formulaChems, MatchQ[Lookup[#, FixedAmounts],{(MassP|VolumeP)..}]&, Null];

			If[NullQ[fixedAliquotModel],
				Return[True]
			];

			nonFixedAliquots = DeleteCases[formulaModels,ObjectP[Lookup[fixedAliquotModel, Object]]];

			If[Length[nonFixedAliquots]==1,
				True,
				False
			]
		],
		True
	],

	(* if the formula field contains a chemical with a fixed amounts, the amount in the formula must match the amount in the FixedAmounts field *)
	Test["If a formula has a fixed amounts the amount in the formula must be the same as the FixedAmounts value:",
		Module[
			{formulaModels,formulaChems,fixedAliquotModels, fixedAliquotFieldValues,
				fixedAliquotAmounts, fixedAliquotFormulaAmounts, fixedAliquotFormulaEntries},

			formulaModels = (Lookup[packet,Formula])[[All,2]];

			formulaChems = Download[Cases[formulaModels,ObjectP[Model[Sample]]], Object];

			fixedAliquotFieldValues = Download[formulaChems, FixedAmounts];

			fixedAliquotModels = PickList[
				formulaChems,
				fixedAliquotFieldValues,
				{(MassP|VolumeP)..}
			];
			If[fixedAliquotModels==={},
				Return[True]
			];

			fixedAliquotAmounts = Cases[fixedAliquotFieldValues, {(MassP|VolumeP)..}];

			fixedAliquotFormulaEntries = Select[Lookup[packet, Formula], MemberQ[fixedAliquotModels, Download[#[[2]], Object]]&];

			fixedAliquotFormulaAmounts = fixedAliquotFormulaEntries[[All,1]];

			MemberQ[fixedAliquotAmounts,EqualP[#]&/@fixedAliquotFormulaAmounts]
		],
		True
	],

	(* if the formula field contains a sample with a fixed amounts, the volume in the TransferOutSolventVolumes field must match the volume of the liquid *)
	Test["If a formula has a fixed amounts, the amount of liquid in the formula must match the corresponding volume in the fixed amounts's TransferOutSolventVolumes field:",
		Module[
			{formulaModels,formulaChems, formulaChemPackets, transferOutSolventVolumes,fixedAliquotAmounts,fixedAliquotFormulaEntries,fixedAliquotFormulaAmounts,pickedTransferOutSolventVolume,
				fixedAliquotModel, volumeFormulaEntry},

			formulaModels = (Lookup[packet,Formula])[[All,2]];

			formulaChems = Download[Cases[formulaModels,ObjectP[Model[Sample]]], Object];

			formulaChemPackets = Download[formulaChems, Packet[FixedAmounts, TransferOutSolventVolumes]];

			fixedAliquotModel = SelectFirst[formulaChemPackets, MatchQ[Lookup[#, FixedAmounts],{(MassP|VolumeP)..}]&, Null];

			If[NullQ[fixedAliquotModel],
				Return[True]
			];

			transferOutSolventVolumes = Lookup[fixedAliquotModel, TransferOutSolventVolumes];

			fixedAliquotAmounts = Lookup[fixedAliquotModel, FixedAmounts];

			fixedAliquotFormulaEntries = Select[Lookup[packet, Formula], MemberQ[fixedAliquotModel, Download[#[[2]], Object]]&];

			fixedAliquotFormulaAmounts = fixedAliquotFormulaEntries[[All,1]];

			pickedTransferOutSolventVolume = First[Flatten[PickList[transferOutSolventVolumes,fixedAliquotAmounts,#]&/@fixedAliquotFormulaAmounts]];

			volumeFormulaEntry = SelectFirst[Lookup[packet, Formula][[All, 1]], VolumeQ[#]&, 0 Liter];

			TrueQ[volumeFormulaEntry == pickedTransferOutSolventVolume]
		],
		True
	],


	(* --- unique fields --- *)
	(* required together recipe fields *)

	(* ----
	 TESTS FOR MAMMALIAN CELL CULTURE MEDIA
     ----- *)
	Test["If OrganismType is Mammalian, BaseMedium must be informed:",
		Lookup[packet,{OrganismType,BaseMedium}],
		{Mammalian,Except[NullP|{}]} | {Except[Mammalian],_}
	],
	Test["If OrganismType is Mammalian, HEPES must be informed:",
		Lookup[packet,{OrganismType,HEPES}],
		{Mammalian,Except[NullP|{}]} | {Except[Mammalian],_}
	],
	Test["If OrganismType is Mammalian, Glucose must be informed:",
		Lookup[packet,{OrganismType,Glucose}],
		{Mammalian,Except[NullP|{}]} | {Except[Mammalian],_}
	],
	Test["If OrganismType is Mammalian, PhenolRed must be informed:",
		Lookup[packet,{OrganismType,PhenolRed}],
		{Mammalian,Except[NullP|{}]} | {Except[Mammalian],_}
	],
	Test["If OrganismType is Mammalian, SodiumPyruvate must be informed:",
		Lookup[packet,	{OrganismType,SodiumPyruvate}],
		{Mammalian,Except[NullP|{}]} | {Except[Mammalian],_}
	],
	Test["If OrganismType is Mammalian, SodiumBicarbonate must be informed:",
		Lookup[packet,{OrganismType,SodiumBicarbonate}],
		{Mammalian,Except[NullP|{}]} | {Except[Mammalian],_}
	],

	Test["The TotalVolume must be within a reasonable range of the sum of the Formula components:",
		Module[
			{formula,measuredTotalVolume,formulaLiquids,formulaLiquidVolumes,totalFormulaVolume,solvent,formulaSolids,formulaSolidVolumes,solidDensities},

			{formula,measuredTotalVolume,solvent} = Lookup[packet,{Formula,TotalVolume,FillToVolumeSolvent}];

			If[NullQ[measuredTotalVolume],
				Return[True]
			];

			formulaLiquids = Cases[formula,{_,_,_?VolumeQ}];
			formulaSolids = Cases[formula,{_,_,_?MassQ}];
			solidDensities = Download[formulaSolids[[All,1]],Density];

			(*if it's only solids, return true*)
			If[MatchQ[formulaLiquids,{}],Return[True]];

			formulaLiquidVolumes = Map[
				Function[{formulaLiquidEntry},formulaLiquidEntry[[2]]*formulaLiquidEntry[[3]]],
				formulaLiquids
			];

			(* estimate how much impact the solids will have on the volume, it's a bad guess but just take 1 gm to be about 1mL*)
			formulaSolidVolumes = MapThread[
				Function[{formulaSolidEntry, density},
					Module[{},
						If[Not[NullQ[density]],
							(formulaSolidEntry[[2]]*formulaSolidEntry[[3]])/density,
							Unitless[Convert[(formulaSolidEntry[[2]]*formulaSolidEntry[[3]]),Gram]] Milliliter
						]
					]
				],
				{formulaSolids,solidDensities}
			];

			totalFormulaVolume = Total[Flatten[{formulaLiquidVolumes,formulaSolidVolumes}]];

			If[MatchQ[solvent, ObjectP[]],
				measuredTotalVolume > totalFormulaVolume,
				(0.7*totalFormulaVolume)<measuredTotalVolume<(1.3*totalFormulaVolume)
			]
		],
		True
	],
	Test["If the media has a deprecated component, it must also be deprecated:",
		Module[
			{formula, formulaComponents, deprecatedComponentQ, deprecatedQ},

			formula = Lookup[packet, Formula];
			formulaComponents = formula[[All, 2]];

			(* figure out if the media itself is deprecated *)
			deprecatedQ = Lookup[packet, Deprecated];

			(* Download the Deprecated field from all the components *)
			deprecatedComponentQ = Download[formulaComponents, Deprecated];

			(* If there is a deprecated component, then deprecatedQ must be True; otherwise, always True *)
			If[MemberQ[deprecatedComponentQ, True],
				TrueQ[deprecatedQ],
				True
			]
		],
		True
	],

	Test["If one or more component is available only in fixed amounts, VolumeIncrements must be populated:",
		Module[{components, fixedAmounts},
			components = Lookup[packet, Formula][[All, 2]];
			fixedAmounts = Quiet[Download[components, FixedAmounts], Download::FieldDoesntExist] /. {$Failed -> {}};
			{fixedAmounts, Lookup[packet, VolumeIncrements]}
		],
		{{{}..}, _} | {Except[{{}..}], {UnitsP[]..}}
	],

	Test["When UploadStockSolution[" <> ToString[Lookup[packet, Object], InputForm] <> ", Upload -> False] is called, function returns  "<> ToString[Lookup[packet, Object], InputForm] <>"  as output (i.e., combination of all stock solution parameters is valid). $PersonID must be set to the author of this solution to replicate this test:",
		Block[{$PersonID = Download[FirstOrDefault[Lookup[packet, Authors]], Object]},
			UploadStockSolution[Lookup[packet, Object], Upload -> False]
		],
		Alternatives @@ Flatten[{Lookup[packet, Object], Download[Lookup[packet, AlternativePreparations], Object]}],
		TimeConstraint -> 500
	]

};


(* ::Subsection::Closed:: *)
(*validModelSampleReactionQTests*)


validModelSampleReactionQTests[packet:PacketP[Model[Reaction]]]:={

	(* Specific tests *)
	NotNullFieldTest[packet,{Reactants,ReactionProducts,Reaction,ReactionType}],

	(*  *)
	Test["ReactionType should be compatible with Reactants and ReactionProducts:",
		Module[{reactionType, reactants,reactionProducts},
			{reactionType, reactants,reactionProducts}= Lookup[packet,{ReactionType, Reactants,ReactionProducts}];
			If[!MatchQ[reactionType,Null],
				MatchQ[
					reactionType,
					ClassifyReaction[reactants,reactionProducts]
				],
				True
			]
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelSampleStockSolutionQTests*)


validModelSampleStockSolutionQTests[packet : PacketP[Model[Sample, StockSolution]]] := {
	(* --- shared fields --- *)
	Test["State is a Solid if it has no solvent and only solid components, and Liquid otherwise:",
		If[NullQ[Lookup[packet, FillToVolumeSolvent]] && MatchQ[Lookup[packet, Formula][[All, 1]], {MassP..}],
			MatchQ[Lookup[packet, State], Solid],
			MatchQ[Lookup[packet, State], Liquid]
		],
		True
	],

	Test["The contents of the Name field is a member of the Synonyms field:",
		Module[{synonyms, name},
			{synonyms, name} = Lookup[packet, {Synonyms, Name}];
			If[MatchQ[name, _String],
				MemberQ[synonyms, name],
				True
			]
		],
		True
	],

	Test["If the model is not Deprecated and public, it must have a Name:",
		If[!MatchQ[Lookup[packet, Deprecated], True] && NullQ[Lookup[packet, Notebook]],
			MatchQ[Lookup[packet, Name], _String],
			True
		],
		True
	],

	Test["There must be more than one component in the formula when the formula of the model is specified:",
		If[!MatchQ[Lookup[packet, Formula], {}|NullP],
			GreaterEqualQ[Length[Lookup[packet, Formula]], 1],
			True
		],
		True
	],

	Test["The model must have either Formula or UnitOperations specified, not both:",
		Lookup[packet, {Formula, UnitOperations}],
		{{}|NullP, Except[NullP | {}]} | {Except[NullP | {}], {}|NullP}
	],

	(*Null*)
	NullFieldTest[packet, {WettedMaterials}],

	Test["If MSDSRequired is True, then MSDSFile must be informed:",
		Lookup[packet, {MSDSRequired, MSDSFile}],
		{True, Except[NullP | {}]} | {False, _}
	],
	Test["If MSDSRequired is True, then Flammable must be informed:",
		Lookup[packet, {MSDSRequired, Flammable}],
		{True, Except[NullP | {}]} | {False, _}
	],
	Test["If MSDSRequired is True, then NFPA must be informed:",
		Lookup[packet, {MSDSRequired, NFPA}],
		{True, Except[NullP | {}]} | {False, _}
	],
	Test["If MSDSRequired is True, then DOTHazardClass must be informed:",
		Lookup[packet, {MSDSRequired, DOTHazardClass}],
		{True, Except[NullP | {}]} | {False, _}
	],

	RequiredTogetherTest[packet, {MinpH, MaxpH}],
	RequiredTogetherTest[packet, {FillToVolumeSolvent, FillToVolumeMethod}],
	FieldComparisonTest[packet, {MinpH, NominalpH, MaxpH}, Less],

	Test["If MixUntilDissolved is populated, either MaxMixTime or MaxNumberOfMixes must be populated (and vice versa):",
		Lookup[packet, {MixUntilDissolved, MaxMixTime, MaxNumberOfMixes}],
		Alternatives[
			{Null | False, Null, Null},
			{True, TimeP, Null},
			{True, Null, NumericP}
		]
	],

	Test["If IncubationTime and MixTime are both populated, they must be equal to each other:",
		If[TimeQ[Lookup[packet, IncubationTime]] && TimeQ[Lookup[packet, MixTime]],
			Lookup[packet, IncubationTime] == Lookup[packet, MixTime],
			True
		],
		True
	],

	(* --- unique fields --- *)
	(* required together recipe fields *)
	NotNullFieldTest[packet, {MSDSRequired, BiosafetyLevel, Preparable}],

	AnyInformedTest[packet, {TotalVolume}];

	Test["If Mixer or MixRate are populated, MixType must be populated:",
		If[RPMQ[Lookup[packet, MixRate]] || MatchQ[Lookup[packet, Mixer], ObjectP[Model[Instrument]]],
			MatchQ[Lookup[packet, MixType], MixTypeP],
			True
		],
		True
	],

	(* TODO incorporate this Download into a big one above instead of all the ones I have here *)
	Test["TotalVolume is informed if the stock solution model has been prepared at least thrice in the lab via a StockSolution protocol:",
		Module[
			{totalVolume, objectsLength, objectPackets, actualObjectPackets},
			(* need to Download the Length of the Objects field *)
			(* doing this goofiness because the Objects field can be very long, and so in the packet it might be unevaluated behind a :>, in which case Downloading length from it won't work.  If we do the Lookup of the field directly and then take the length, that could work but might take much longer bc Downloading Length of a field is often much faster than getting the field itself *)
			objectsLength = Download[Lookup[packet, Object], Length[Objects]];

			(* only Download most recent 100 objects to avoid this infinitely ballooning if there are more than 100; if the necessary information isn't there, it's not going to be there if you get everything all together anyway *)
			(* need the Quiet because if in a notebook and a different user is also testing the VOQ, then they won't be allowed to Download all these fields since some objects won't be theirs *)
			(* basically, if the object doesn't exist, then that's because of ownership differences and not because anything is wrong *)
			{totalVolume, objectPackets} = If[objectsLength > 100,
				Quiet[Download[Lookup[packet, Object], {TotalVolume, Packet[Objects[[-100 ;; -1]][{Status, Source, DeveloperObject}]]}], Download::ObjectDoesNotExist],
				Quiet[Download[Lookup[packet, Object], {TotalVolume, Packet[Objects[{Status, Source, DeveloperObject}]]}], Download::ObjectDoesNotExist]
			];

			(* get the object packets that are not developer objects and came from actual stock solution protocols or transactions *)
			(* in case the stock solution was automatically generated in a SampleManipulation TotalVolume isn't going to be populated and that's okay *)
			actualObjectPackets = Select[objectPackets, Not[TrueQ[Lookup[#, DeveloperObject]]] && MatchQ[Lookup[#, Source], ObjectP[{Object[Protocol, StockSolution], Object[Transaction, Order]}]]&];

			If[
				And[
					Length[actualObjectPackets] >= 3,
					ContainsAny[Lookup[actualObjectPackets, Status, {}], {Stocked, Available, Discarded}] (* in case there is only one sample that's InUse that hasn't gotten a volume yet*)
				],
				MatchQ[totalVolume, Except[Null]],
				True
			]
		],
		True,
		TimeConstraint -> 180
	],

	(* --- fixed aliquot invariants --- *)

	(* if the formula field contains a chemical with a fixed amounts, only one liquid can be in the formula *)
	(* TODO incorporate this Download into a big one above instead of all the ones I have here *)
	Test["A formula with a fixed amounts can only have two components (the fixed amounts + one liquid):",
		Module[
			{formulaModels, formulaChems, nonFixedAliquots, fixedAliquotModel},

			formulaModels = (Lookup[packet, Formula])[[All, 2]];

			formulaChems = Download[Cases[formulaModels, ObjectP[Model[Sample]]], Packet[FixedAmounts]];

			fixedAliquotModel = SelectFirst[formulaChems, MatchQ[Lookup[#, FixedAmounts],{(MassP|VolumeP)..}]&, Null];

			If[NullQ[fixedAliquotModel],
				Return[True]
			];

			nonFixedAliquots = DeleteCases[formulaModels, ObjectP[Lookup[fixedAliquotModel, Object]]];

			If[Length[nonFixedAliquots] == 1,
				True,
				False
			]
		],
		True
	],

	(* if the formula field contains a chemical with a fixed amounts, the amount in the formula must match the amount in the FixedAmounts field *)
	(* TODO incorporate this Download into a big one above instead of all the ones I have here *)
	Test["If a formula has a fixed amounts the amount in the formula must be the same as a value in the FixedAmounts field:",
		Module[
			{formulaModels, formulaChems, fixedAliquotModels, fixedAliquotFieldValues,
				fixedAliquotAmounts, fixedAliquotFormulaAmounts, fixedAliquotFormulaEntries},

			formulaModels = (Lookup[packet, Formula])[[All, 2]];

			formulaChems = Download[Cases[formulaModels, ObjectP[Model[Sample]]], Object];

			fixedAliquotFieldValues = Download[formulaChems, FixedAmounts];

			fixedAliquotModels = PickList[
				formulaChems,
				fixedAliquotFieldValues,
				{(MassP|VolumeP)..}
			];
			If[fixedAliquotModels === {},
				Return[True]
			];

			fixedAliquotAmounts = Cases[fixedAliquotFieldValues, {(MassP|VolumeP)..}];

			fixedAliquotFormulaEntries = Select[Lookup[packet, Formula], MemberQ[fixedAliquotModels, Download[#[[2]], Object]]&];

			fixedAliquotFormulaAmounts = fixedAliquotFormulaEntries[[All, 1]];

			(* First is justified here since we have a check that StockSolution has only one FixedAmounts component *)
			MemberQ[Flatten@fixedAliquotAmounts, EqualP[First@fixedAliquotFormulaAmounts]]
		],
		True
	],

	(* if the formula field contains a sample with a fixed amounts, the volume in the TransferOutSolventVolumes field must match the volume of the liquid *)
	(* TODO incorporate this Download into a big one above instead of all the ones I have here *)
	Test["If a formula has a fixed amounts, the amount of liquid in the formula must match the corresponding volume in the fixed amounts's TransferOutSolventVolumes field:",
		Module[
			{formulaModels,formulaChems, formulaChemPackets, transferOutSolventVolumes,fixedAliquotAmounts,fixedAliquotFormulaEntries,fixedAliquotFormulaAmounts,pickedTransferOutSolventVolume,
				fixedAliquotModel, volumeFormulaEntry},

			formulaModels = (Lookup[packet, Formula])[[All, 2]];

			formulaChems = Download[Cases[formulaModels, ObjectP[Model[Sample]]], Object];

			formulaChemPackets = Download[formulaChems, Packet[FixedAmounts, TransferOutSolventVolumes]];

			fixedAliquotModel = SelectFirst[formulaChemPackets, MatchQ[Lookup[#, FixedAmounts],{(MassP|VolumeP)..}]&, Null];

			If[NullQ[fixedAliquotModel],
				Return[True]
			];

			transferOutSolventVolumes = Lookup[fixedAliquotModel, TransferOutSolventVolumes];

			fixedAliquotAmounts = Lookup[fixedAliquotModel, FixedAmounts];

			fixedAliquotFormulaEntries = Select[Lookup[packet, Formula], MemberQ[fixedAliquotModel, Download[#[[2]], Object]]&];

			fixedAliquotFormulaAmounts = fixedAliquotFormulaEntries[[All,1]];

			pickedTransferOutSolventVolume = First[Flatten[PickList[transferOutSolventVolumes,fixedAliquotAmounts,#]&/@fixedAliquotFormulaAmounts]];

			volumeFormulaEntry = SelectFirst[Lookup[packet, Formula][[All, 1]], VolumeQ[#]&, 0 Liter];

			TrueQ[volumeFormulaEntry == pickedTransferOutSolventVolume]
		],
		True
	],


	(* chemical components can be ordered *)
	(* TODO incorporate this Download into a big one above instead of all the ones I have here *)
	Test["Each public chemical component of a stock solution's formula must have a non-deprecated product:",
		Module[
			{formulaModels, formulaChemPackets, publicFormulaPackets, formulaProducts, formulaKitProducts,
				allProductsDeprecatedStatuses},

			(* lookup the formula components *)
			formulaModels = Lookup[packet, Formula][[All, 2]];

			(* select the chemical components *)
			formulaChemPackets = Download[Cases[formulaModels, ObjectP[Model[Sample]]], Packet[Notebook, Products, KitProducts]];

			(* get the public non-stock-solution components *)
			publicFormulaPackets = Select[formulaChemPackets, NullQ[Lookup[#, Notebook]] && Not[MatchQ[#, ObjectP[{Model[Sample, StockSolution], Model[Sample, Matrix], Model[Sample, Media]}]]]&];

			(* find the status of the Products of the public chemicals *)
			(* note that we are excluding components that are themselves stock solutions because those don't need products *)
			formulaProducts = Lookup[publicFormulaPackets, Products, {}];

			(* find the status of the KitProducts of the public chemicals *)
			formulaKitProducts = Lookup[publicFormulaPackets, KitProducts, {}];

			(* join the list of formulaProducts and formulaKitProducts for each individual chemical component (since a chemical component will either have Products or KitProducts) *)
			allProductsDeprecatedStatuses = MapThread[
				Join[#1, #2]&,
				{formulaProducts, formulaKitProducts}
			];

			(* make sure they have at least one product or kit product and that they aren't all Deprecated\[Rule]True *)
			MemberQ[Download[allProductsDeprecatedStatuses, Deprecated], {True...}]
		],
		False
	],

	(*misc*)
	FieldComparisonTest[packet, {MeltingPoint, BoilingPoint}, Less],

	(* TODO incorporate this Download into a big one above instead of all the ones I have here *)
	Test["If a stock solution has a deprecated component, it must also be deprecated:",
		Module[
			{formula, formulaComponents, deprecatedComponentQ, deprecatedQ},

			formula = Lookup[packet, Formula];
			formulaComponents = formula[[All, 2]];

			(* figure out if the stock solution itself is deprecated *)
			deprecatedQ = Lookup[packet, Deprecated];

			(* Download the Deprecated field from all the components *)
			deprecatedComponentQ = Download[formulaComponents, Deprecated];

			(* If there is a deprecated component, then deprecatedQ must be True; otherwise, always True *)
			If[MemberQ[deprecatedComponentQ, True],
				TrueQ[deprecatedQ],
				True
			]
		],
		True
	],

	(* TODO incorporate this Download into a big one above instead of all the ones I have here *)
	Test["If a stock solution has a private component, it must also be private:",
		Module[
			{formula, formulaComponents, privateComponentQ, privateQ},

			formula = Lookup[packet, Formula];
			formulaComponents = formula[[All, 2]]/.x:LinkP[]:>Download[x, Object];

			(* figure out if the stock solution itself is deprecated *)
			privateQ = !MatchQ[Lookup[packet, Notebook], Null];

			(* Download the Deprecated field from all the components *)
			privateComponentQ = !MatchQ[#, Null]&/@Download[formulaComponents, Notebook];

			(* If there is a deprecated component, then deprecatedQ must be True; otherwise, always True *)
			If[TrueQ[privateQ],
				True,
				!MemberQ[privateComponentQ, True]
			]
		],
		True
	],

	(* TODO incorporate this Download into a big one above instead of all the ones I have here *)
	Test["The stock solution's formula's units are consistent with the states of the components. (Tablets may be mass or integer):",
		Module[
			{formula, formulaComponents, formulaUnits, componentStates, checks, componentTabletBools, formulaAmounts},

			formula = Lookup[packet, Formula];
			formulaComponents = formula[[All, 2]];
			formulaUnits = Units[formula[[All, 1]]];
			formulaAmounts = Unitless[formula[[All, 1]]];

			componentStates = Download[formulaComponents, State];
			componentTabletBools = Quiet[Download[formulaComponents, Tablet], Download::FieldDoesntExist];

			checks = MapThread[
				Function[{unit, state, tabletBool, formulaAmount},
					Which[
						(* tablets *)
						TrueQ[tabletBool], CompatibleUnitQ[unit, Gram] || (MatchQ[unit, Null | UnitsP[Unit]] && Equal[formulaAmount, Round[formulaAmount]]),

						(* solids *)
						MatchQ[state, Solid], CompatibleUnitQ[unit, Gram],

						(* otherwise *)
						True, CompatibleUnitQ[unit, Liter]
					]
				],
				{formulaUnits, componentStates, componentTabletBools, formulaAmounts}
			];

			AllTrue[checks, TrueQ]
		],
		True
	],

	(* TODO incorporate this Download into a big one above instead of all the ones I have here *)
	Test["The TotalVolume must be within a reasonable range of the sum of the Formula components:",
		Module[
			{formula, measuredTotalVolume, formulaLiquids, formulaLiquidVolumes, totalFormulaVolume, solvent, formulaSolids, formulaSolidVolumes, solidDensities},

			{formula, measuredTotalVolume, solvent} = Lookup[packet, {Formula, TotalVolume, FillToVolumeSolvent}];

			If[NullQ[measuredTotalVolume],
				Return[True]
			];

			formulaLiquids = Cases[formula, {_, _, _?VolumeQ}];
			formulaSolids = Cases[formula, {_, _, _?MassQ}];
			solidDensities = Download[formulaSolids[[All, 1]], Density];

			(*if it's only solids, return true*)
			If[MatchQ[formulaLiquids, {}], Return[True]];

			formulaLiquidVolumes = Map[
				Function[{formulaLiquidEntry}, formulaLiquidEntry[[2]] * formulaLiquidEntry[[3]]],
				formulaLiquids
			];

			(* estimate how much impact the solids will have on the volume, it's a bad guess but just take 1 gm to be about 1mL*)
			formulaSolidVolumes = MapThread[
				Function[{formulaSolidEntry, density},
					Module[{},
						If[Not[NullQ[density]],
							(formulaSolidEntry[[2]] * formulaSolidEntry[[3]]) / density,
							Unitless[Convert[(formulaSolidEntry[[2]] * formulaSolidEntry[[3]]), Gram]] Milliliter
						]
					]
				],
				{formulaSolids, solidDensities}
			];

			totalFormulaVolume = Total[Flatten[{formulaLiquidVolumes, formulaSolidVolumes}]];

			If[MatchQ[solvent, ObjectP[]],
				measuredTotalVolume > totalFormulaVolume,
				(0.7 * totalFormulaVolume) < measuredTotalVolume < (1.3 * totalFormulaVolume)
			]
		],
		True
	],

	(* TODO incorporate this Download into a big one above instead of all the ones I have here *)
	Test["If one or more component is available only in fixed amounts, VolumeIncrements must be populated:",
		Module[{components, fixedAmounts},
			components = Lookup[packet, Formula][[All, 2]];
			fixedAmounts = Quiet[Download[components, FixedAmounts], Download::FieldDoesntExist] /. {$Failed -> {}};
			{fixedAmounts, Lookup[packet, VolumeIncrements]}
		],
		{{{}..}, _} | {Except[{{}..}], {UnitsP[]..}}
	],

	(* I don't think this one can actually be incorporated into the big Download above just because the checks are so elaborate that we just need the function itself *)
	Test["When UploadStockSolution[" <> ToString[Lookup[packet, Object], InputForm] <> ", Upload -> False] is called, function returns  " <> ToString[Lookup[packet, Object], InputForm] <> "  or its AlternativePreparations as output (i.e., combination of all stock solution parameters is valid). $PersonID must be set to the author of this solution to replicate this test:",
		Block[{$PersonID = Download[FirstOrDefault[Lookup[packet, Authors]], Object]},
			UploadStockSolution[Lookup[packet, Object], Upload -> False]
		],
		Alternatives @@ Flatten[{Lookup[packet, Object], Download[Lookup[packet, AlternativePreparations], Object]}],
		TimeConstraint -> 500
	],
	(*there is a helper generateSSPrice that can do this*)
	Test["If this model is in the catalog, it must have Price populated:",
		If[
			MemberQ[Catalog`Private`catalogObjs[],Lookup[packet,Object]]&&NullQ[Lookup[packet,Notebook]],
			MatchQ[Lookup[packet,Price],UnitsP[USD/Liter]|UnitsP[USD/Gram]],
			True
		],
		True
	]

};

(* ::Subsection::Closed:: *)
(*validModelSampleStockSolutionStandardQTests*)


validModelSampleStockSolutionStandardQTests[packet:PacketP[Model[Sample,StockSolution,Standard]]]:=
{
	NotNullFieldTest[packet,{StandardComponents,Preparable}],

	AnyInformedTest[packet,{StandardMolecularWeights,StandardConcentrations,StandardLengths,StandardMassConcentrations,ReferencePeaksNegativeMode,ReferencePeaksPositiveMode}],

	Test["If ReferencePeaksPositiveMode or ReferencePeaksNegativeMode is populated, CompatibleIonSource must be populated (and vice versa):",
		Lookup[packet, {ReferencePeaksPositiveMode, ReferencePeaksNegativeMode, CompatibleIonSource}],
		Alternatives[
			{Except[NullP|{}], _,IonSourceP},
			{_, Except[NullP|{}],IonSourceP},
			{_,_,Null}
		]
	],

	Test["If CompatibleIonSource is MALDI,PreferredSpottingMethod and PreferredMALDIMatrix are populated (and not, if ESI):",
		Lookup[packet, {CompatibleIonSource, PreferredSpottingMethod, PreferredMALDIMatrix}],
		Alternatives[
			{MALDI,SpottingMethodP,{ObjectP[]..}},
			{ESI,Null,{}},
			{Null,_,_}
		]
	]

};


(* ::Subsection::Closed:: *)
(* Test Registration *)


registerValidQTestFunction[Model[Sample],validModelSampleQTests];
registerValidQTestFunction[Model[Sample, Matrix],validModelSampleMatrixQTests];
registerValidQTestFunction[Model[ReactionMechanism],validModelSampleMechanismQTests];
registerValidQTestFunction[Model[Sample, Media],validModelSampleMediaQTests];
registerValidQTestFunction[Model[Reaction],validModelSampleReactionQTests];
registerValidQTestFunction[Model[Sample, StockSolution],validModelSampleStockSolutionQTests];
registerValidQTestFunction[Model[Sample, StockSolution, Standard],validModelSampleStockSolutionStandardQTests];
