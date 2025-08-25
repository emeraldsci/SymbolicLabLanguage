(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*Search*)


DefineTests[toSearchQuery, {
	Test["Two types returns two queries:",
		toSearchQuery[{Object[Data, Chromatography], Object[Data, Volume]}],
		{searchQueryP, searchQueryP}
	],
	Test["Nested lists returns nested queries:",
		toSearchQuery[{{Object[Data, Chromatography], Object[Data, Volume]}, {Object[Analysis, Peaks]}}],
		{{searchQueryP,searchQueryP},{searchQueryP}}
	],
	Test["Duplicated types get filtered out:",
		toSearchQuery[{Object[Data, Chromatography], Object[Data, Volume], Object[Data, Chromatography]}],
		{searchQueryP, searchQueryP}
	],
	Test["Duplicated types get filtered from inner lists, but outer lists NOT filtered (that filtering happens in sendSearch):",
		toSearchQuery[{{Object[Data, Chromatography], Object[Data, Volume], Object[Data, Chromatography]}, {Object[Analysis, Peaks]}, {Object[Analysis, Peaks]}}],
		{{searchQueryP, searchQueryP}, {searchQueryP}, {searchQueryP}}
	]
}];


DefineTests[sendSearch, {
	Test["Given four sets of queries, where two are identical in both types and clauses, this should only perform an actual search on 3 of them, but return 4 sets of results:",
		Module[{searchQueries},
			searchQueries = Constellation`Private`toSearchQuery[{
				{Object[Data, Chromatography],Object[Data, Volume], Object[Data, Chromatography]},
				{Object[Analysis, Peaks]}, {Object[Analysis, Peaks]}, {Object[Analysis, Peaks]}},
				{DateCreated >  Yesterday, DateCreated > Today, DateCreated > Tomorrow, DateCreated > Today}
			];
			(*
				Can't use the Variables option to define 'counter' because the stub where its used gets Constellation`Private context
				So we give it some arbitrary unique context to be safe avoiding possible name collisions
			*)
			sendSearch`Test`counter=0;
			Reap[sendSearch[searchQueries],"search counter"]
		],
		{
			(* This means it returned 4 sets of results, with the fourth result being a duplicate of the second search *)
			{ {1}, {2}, {3}, {2} },
			(* this means it only made 3 actual search calls *)
			{ {{1}, {2}, {3}}} (*extra list because of Reap behavior *)
		},
		Stubs:> {
			(* Sow is to count how many times this gets hit. Don't care what it returns, just need to check sizes at end *)
			sendSearch[{searchQueryP..}] = Sow[{++sendSearch`Test`counter},"search counter"]
		}
	]
}];


DefineTests[Search,
	{
		Example[{Basic, "Find all objects of a type:"},
			Search[Object[Instrument, HPLC]],
			{ObjectReferenceP[Object[Instrument, HPLC]]..}
		],
		Example[{Options, Date, "Find all objects of a type that existed at the time of the provided timestamp:"},
			Search[Object[Instrument, HPLC], Date -> Now],
			{ObjectReferenceP[Object[Instrument, HPLC]]..}
		],
		Example[{Basic, "Find all objects of a type that meet the given criteria:"},
			Search[Model[Item, Column], MaxFlowRate > 1 Milliliter / Minute && SeparationMode == (IonExchange | SizeExclusion | Affinity)],
			{ObjectReferenceP[Model[Item, Column]]..}
		],
		Example[{Basic, "Find all objects of multiple types:"},
			Search[{Model[Instrument, Balance], Model[Sample]}],
			{ObjectReferenceP[{Model[Instrument, Balance], Model[Sample]}]..}
		],
		Example[{Basic, "Find all objects of multiple sets of types. The objects will be separated to match the way the types were separated in the input:"},
			Search[{{Object[Instrument, HPLC]}, {Model[Instrument, Balance], Model[Sample]}}],
			{{ObjectReferenceP[Object[Instrument, HPLC]]..}, {ObjectReferenceP[{Model[Instrument, Balance], Model[Sample]}]..}}
		],
		Example[{Basic, "Apply search criteria using searching through links:"},
			Search[Object[Sample], Model[ShelfLife] < 1 Day],
			{ObjectReferenceP[Object[Sample]]..},
			TimeConstraint -> 10000
		],

		Example[{Additional, "Searching a super-type searches across all its sub-types :"},
			Search[Model[Container]],
			{ObjectReferenceP[Model[Container]]..}
		],
		Example[{Additional, "Searching for an empty list of types returns an empty list:"},
			Search[{}],
			{}
		],
		Test["Searching for an empty list of types returns an empty list when date is specified:",
			Search[{}, Date -> Now],
			{}
		],
		Test["Searching for an empty list of types with a condition returns an empty list:",
			Search[{}, TestID == testId],
			{}
		],

		Test["Searching for an empty list of types with a condition returns an empty list when Date is specified:",
			Search[{}, TestID == testId, Date -> Now],
			{}
		],

		Test["Search on one set of types with an empty list of types (and an empty list of search criteria) returns an empty list:",
			Search[{}, {}, MaxResults -> 1],
			{}
		],

		Test["Search on one set of types with an empty list of lists of types returns an empty list:",
			Search[{{}}, MaxResults -> 1],
			{{}}
		],

		Test["Search on one set of types with an empty list of lists of types returns an empty list when Date is specified:",
			Search[{{}}, MaxResults -> 1, Date -> Now],
			{{}}
		],

		Test["Search on one set of types with an empty list of lists of types (and a single search criteria) returns an empty list:",
			Search[{{}}, Status == InUse, MaxResults -> 1],
			{{}}
		],

		Test["Search multiple sets of types at once with the same search criteria, allowing empty lists:",
			Search[
				{
					{Object[Instrument, HPLC], Object[Container, Plate]},
					{}
				},
				(Status == InUse) && (DeveloperObject == True),
				MaxResults -> 5
			],
			{
				{Repeated[ObjectP[{Object[Instrument, HPLC], Object[Container, Plate]}], {1, 5}]},
				{}
			}
		],

		Test["Search multiple sets of types at once with different criteria for each set, allowing empty lists:",
			Search[
				{
					{Object[Instrument, HPLC], Object[Container, Plate]},
					{}
				},
				{
					(Status == InUse) && (DeveloperObject == True),
					(Status == Available) && (DeveloperObject == True)
				},
				MaxResults -> 5
			],
			{
				{Repeated[ObjectP[{Object[Instrument, HPLC], Object[Container, Plate]}], {1, 5}]},
				{}
			}
		],

		(* kevin is not sure this case should behave this way, but an empty list is better than an erroneous OptionsPattern[] match *)
		Test["Search with a list of types but an empty list of conditions returns an empty list:",
			Search[{Object[Instrument, HPLC], Object[Container, Plate]}, {}, MaxResults -> 5],
			{}
		],

		Test["Search with equalities:",
			Search[
				Object[Container],
				And[
					Name == StringExpression["Search Test: fields", ___],
					DeveloperObject == True
				]
			][Name],
			{OrderlessPatternSequence[
				"Search Test: fields 1",
				"Search Test: fields 2",
				"Search Test: fields 3",
				"Search Test: fields 4"
			]}
		],

		Test["Search with equalities and Field expressions:",
			Search[
				Object[Container],
				And[
					Field[Name] == StringExpression["Search Test: fields", ___],
					Field[DeveloperObject] == True
				]
			][Name],
			{OrderlessPatternSequence[
				"Search Test: fields 1",
				"Search Test: fields 2",
				"Search Test: fields 3",
				"Search Test: fields 4"
			]}
		],

		Test["Accidental usages of '=' are replaced with '==':",
			Search[
				Object[Container],
				And[
					Name=StringExpression["Search Test: fields", ___],
					DeveloperObject=True
				],
				SubTypes -> False
			][Name],
			{OrderlessPatternSequence[
				"Search Test: fields 1",
				"Search Test: fields 2",
				"Search Test: fields 3"
			]}
		],

		Test["Search with Part on the RHS should proceed",
			Search[Model[Item,Column],ChromatographyType=={HPLC}[[1]],MaxResults->5],
			{ObjectReferenceP[Model[Item, Column]]..}
		],

		Test["Search with a Part reference in the where clause",
			Search[Object[Part,InformationTechnology],Model==Model[Part,InformationTechnology,"Zebra Printer, GX430T w/ LCD"]],
			{ObjectReferenceP[Object[Part, InformationTechnology]]..}
		],

		Test["Search should not return duplicates",
			Search[{Object[Example], Object[Example, Data]}, Name==name],
			{ObjectP[Object[Example,Data]]},
			Variables :> {name},
			SetUp :> {
				name=CreateUUID[];
				Upload[<|Type->Object[Example,Data],Name->name|>];
			}
		],

		Example[{Additional, "Search with comparison and conditional operators like equality and greater than:"},
			Search[Model[Item, Column], ChromatographyType == HPLC && MaxFlowRate > 2 Milliliter / Minute],
			{ObjectReferenceP[Model[Item, Column]]..}
		],

		Example[{Additional, "Operators", "Use '==' (equal) in the search conditions:"},
			Search[Model[Item, Column], ChromatographyType == HPLC],
			{ObjectReferenceP[Model[Item, Column]]..}
		],
		Example[{Additional, "Operators", "Usage of '===' is equivalent to '==':"},
			MatchQ[
				Search[Model[Container, Plate], Treatment == (NonTreated | TissueCultureTreated)],
				Search[Model[Container, Plate], Treatment === (NonTreated | TissueCultureTreated)]
			],
			True
		],
		Example[{Additional, "Operators", "Usage of 'Equal' is equivalent to '==':"},
			MatchQ[
				Search[Model[Container, Plate], Treatment == (NonTreated | TissueCultureTreated)],
				Search[Model[Container, Plate], Equal[Treatment, (NonTreated | TissueCultureTreated)]]
			],
			True
		],

		Example[{Additional, "Operators", "Use '!=' (unequal) in the search conditions:"},
			Search[Model[Item, Column], ChromatographyType != HPLC],
			{ObjectReferenceP[Model[Item, Column]]..}
		],

		Example[{Additional, "Operators", "Use '>' (greater than) in the search conditions:"},
			Search[Model[Item, Column], MaxFlowRate > 1 Milliliter / Minute],
			{ObjectReferenceP[Model[Item, Column]]..}
		],
		Example[{Additional, "Operators", "Usage of 'Greater' is equivalent to '>':"},
			MatchQ[
				Search[Model[Item, Column], MaxFlowRate > 1 Milliliter / Minute],
				Search[Model[Item, Column], Greater[MaxFlowRate, 1 Milliliter / Minute]]
			],
			True
		],

		Example[{Additional, "Operators", "Use '<' (less than) in the search conditions:"},
			Search[Model[Item, Column], MaxFlowRate < 1 Milliliter / Minute],
			{ObjectReferenceP[Model[Item, Column]]..}
		],
		Example[{Additional, "Operators", "Usage of 'Less' is equivalent to '<':"},
			MatchQ[
				Search[Model[Item, Column], MaxFlowRate < 1 Milliliter / Minute],
				Search[Model[Item, Column], Less[MaxFlowRate, 1 Milliliter / Minute]]
			],
			True
		],

		Example[{Additional, "Operators", "Use '>=' (greater or equal to) in the search conditions:"},
			Search[Model[Item, Column], MaxFlowRate >= 1 Milliliter / Minute],
			{ObjectReferenceP[Model[Item, Column]]..}
		],
		Example[{Additional, "Operators", "Usage of 'GreaterEqual' is equivalent to '>=':"},
			MatchQ[
				Search[Model[Item, Column], MaxFlowRate >= 1 Milliliter / Minute],
				Search[Model[Item, Column], GreaterEqual[MaxFlowRate, 1 Milliliter / Minute]]
			],
			True
		],

		Example[{Additional, "Operators", "Use '<=' (less or equal to) in the search conditions:"},
			Search[Model[Item, Column], MaxFlowRate <= 1 Milliliter / Minute],
			{ObjectReferenceP[Model[Item, Column]]..}
		],
		Example[{Additional, "Operators", "Usage of 'LessEqual' is equivalent to '<=':"},
			MatchQ[
				Search[Model[Item, Column], MaxFlowRate <= 1 Milliliter / Minute],
				Search[Model[Item, Column], LessEqual[MaxFlowRate, 1 Milliliter / Minute]]
			],
			True
		],

		Example[{Additional, "Operators", "Use '&&' (and) in the search conditions:"},
			Search[Model[Item, Column], ChromatographyType == HPLC && MaxFlowRate > 1 Milliliter / Minute],
			{ObjectReferenceP[Model[Item, Column]]..}
		],
		Example[{Additional, "Operators", "Usage of 'And' is equivalent to '&&':"},
			MatchQ[
				Search[Model[Item, Column], ChromatographyType == HPLC && MaxFlowRate > 1 Milliliter / Minute],
				Search[Model[Item, Column], And[ChromatographyType == HPLC, MaxFlowRate > 1 Milliliter / Minute]]
			],
			True
		],

		Example[{Additional, "Operators", "Use '||' (or) in the search conditions:"},
			Search[Model[Item, Column], ChromatographyType == HPLC || MaxFlowRate > 1 Milliliter / Minute],
			{ObjectReferenceP[Model[Item, Column]]..}
		],
		Example[{Additional, "Operators", "Usage of 'Or' is equivalent to '||':"},
			MatchQ[
				Search[Model[Item, Column], ChromatographyType == HPLC || MaxFlowRate > 1 Milliliter / Minute],
				Search[Model[Item, Column], Or[ChromatographyType == HPLC, MaxFlowRate > 1 Milliliter / Minute]]
			],
			True
		],

		Example[{Additional, "Apply multiple search criteria to the same field:"},
			Search[Object[Protocol], And[DateCreated < Now, DateCreated > Now - 7 Day]],
			{ObjectReferenceP[Object[Protocol]]..}
		],
		Example[{Additional, "Search for objects that are linked to a specific object as given by ID:"},
			Search[Object[Instrument, HPLC], Model == Model[Instrument, HPLC, "id:N80DNjlYwwJq"]],
			{ObjectReferenceP[Object[Instrument, HPLC]]..}
		],
		Example[{Additional, "Search for objects that are linked to a specific object as given by Name:"},
			Search[Object[Instrument, HPLC], Model == Model[Instrument, HPLC, "UltiMate 3000"]],
			{ObjectReferenceP[Object[Instrument, HPLC]]..}
		],
		Example[{Additional, "Length", "Search for objects with a multiple field that is a specific length:"},
			Search[Object[Product], Length[Orders] > 100],
			{ObjectReferenceP[Object[Product]]..}
		],
		Example[{Additional, "Length", "Search for objects with a multiple field that is a specific length using search through links:"},
			Search[Object[Protocol], Length[IncubateSamplePreparation[[IncubationInstrument]][Objects]] > 5],
			{ObjectReferenceP[Object[Protocol]]..}
		],
		Example[{Additional, "Length", "Searching for a field with a length of zero or a value of Null is identical:"},
			{Search[Object[Example,Data], Random == Null && TestIdentifier == testId], Search[Object[Example,Data], Length[Random] == 0 && TestIdentifier == testId]},
			{{obj1}, {obj1}},
			Variables:>{testId, obj1, obj2},
			SetUp :> (
				testId = "Search Test: " <> CreateUUID[];
				{obj1, obj2}=Upload[{
					<|
						Type -> Object[Example, Data],
						TestIdentifier -> testId,
						Replace[Random] -> {}
					|>,
					<|
						Type -> Object[Example, Data],
						TestIdentifier -> testId,
						Replace[Random] -> {1.0}
					|>
				}];
			)
		],
		Example[{Additional, "Max", "Search for the objects that have the maximum value for a given numerical field:"},
			Search[Object[Sample], Max[Volume]],
			ListableP[ObjectReferenceP[Object[Sample]]],
			TimeConstraint -> 5000
		],
		Example[{Additional, "Min", "Search for the objects that have the minimum value for a given numerical field:"},
			Search[Object[Sample], Min[Volume]],
			ListableP[ObjectReferenceP[Object[Sample]]],
			TimeConstraint -> 5000
		],
		Example[{Additional, "Operations on Multiple Fields", "Search on specific indexes of an indexed multiple field:"},
			Search[Object[Instrument, HPLC], StatusLog[[2]] == Available],
			{ObjectReferenceP[Object[Instrument, HPLC]]..}
		],
		Example[{Additional, "Operations on Multiple Fields", "Search on specific named indexes of a named multiple field:"},
			Search[Model[Instrument], Positions[[Footprint]] == Plate],
			{ObjectReferenceP[Model[Instrument]]..}
		],
		Example[{Additional, "Operations on Multiple Fields", "Search on specific indexes of a named multiple field:"},
			Search[Model[Instrument], Positions[[2]] == Plate],
			{ObjectReferenceP[Model[Instrument]]..}
		],
		Example[{Additional, "Operations on Multiple Fields", "Search through links on specific indexes of an indexed multiple field:"},
			Search[Object[Protocol], CompletedTasks[[3]][Name] == "thomas"],
			{ObjectReferenceP[Object[Protocol]]..}
		],
		Example[{Additional, "Operations on Multiple Fields", "Search through links on specific indexes of a named multiple field:"},
			Search[Object[Protocol], IncubateSamplePreparation[[IncubationInstrument]][Name] == "IsoTemp 110"],
			{ObjectReferenceP[Object[Protocol]]..}
		],
		Example[{Additional, "Field", "Fields can be held with the Field head to prevent early evaluation when using Length. (This is useful when the field is passed as a variable to Search.):"},
			With[{searchCondition=Field[Length[StatusLog]]},
				Search[Object[Instrument, HPLC], searchCondition > 100]
			],
			{ObjectReferenceP[Object[Instrument, HPLC]]..}
		],
		Example[{Additional, "Field", "Fields can be held with the Field head to prevent early evaluation when using Part. (This is useful when the field is passed as a variable to Search.):"},
			With[{searchCondition=Field[Formula[[2]]] == Model[Sample, "Milli-Q water"]},
				Search[Model[Sample, StockSolution], searchCondition, MaxResults -> 5]],
			{ObjectReferenceP[Model[Sample, StockSolution]]..}
		],
		Example[{Additional, "Field", "The Field head can be used in a subset of search conditions:"},
			Module[{modelsToCheck, typesToSearch, searchConditions},
				modelsToCheck={Model[Container, Vessel, "2mL Tube"],
					Model[Sample, "Methanol"]};
				typesToSearch={Object @@ Download[#, Type]} & /@ modelsToCheck;
				searchConditions=If[MatchQ[#, ObjectP[Model[Container, Vessel]]],
					Model == # && Field[Length[Contents]] >= 2,
					Model == # && Status == Stocked
				] & /@ modelsToCheck;
				Search[typesToSearch, Evaluate[searchConditions], MaxResults -> 2]
			],
			Block[{$SearchMaxDateCreated=(Now-1Week)},
				Search[{{Object[Container, Vessel]}, {Object[Sample]}}, {Model == Model[Container, Vessel, "2mL Tube"] && Length[Contents] >= 2, Model == Model[Sample, "Methanol"] && Status == Stocked}, MaxResults -> 2]
			],
			Stubs:>{
				(* NOTE: Don't include newly created objects since we will be running in parallel with other tests on manifold. *)
				$SearchMaxDateCreated=(Now-1Week)
			}
		],
		(* -- COMPARATOR CONDITIONS TESTS -- *)
		(* -- ANY -- *)
		Example[{Additional, "Any/All/Exactly", "Multiple fields can be searched using the Any syntax. In the following example, stock solutions will be returned which are incompatible with CarbonSteel:"},
			results=Search[Model[Sample, StockSolution], Any[IncompatibleMaterials == CarbonSteel], MaxResults->5];
			And @@ ((MemberQ[#, CarbonSteel]&) /@ Download[results, IncompatibleMaterials]),
			True,
			Variables :> {results},
			Stubs:>{
				(* NOTE: Don't include newly created objects since we will be running in parallel with other tests on manifold. *)
				$SearchMaxDateCreated=(Now-1Week)
			}
		],
		Example[{Additional, "Any/All/Exactly", "Multiple fields can be searched using the Any syntax. In the following example, stock solutions will be returned which have a component under 1 Micromolar:"},
			results=Search[Model[Sample, StockSolution], Any[Composition[[1]] <= 1 Micromolar], MaxResults->5];
			MemberQ[Download[results, Composition][[1, All, 1]], LessEqualP[1 Micromolar]],
			True,
			Variables :> {results},
			Stubs:>{
				(* NOTE: Don't include newly created objects since we will be running in parallel with other tests on manifold. *)
				$SearchMaxDateCreated=(Now-1Week)
			}
		],
		Example[{Additional, "Any/All/Exactly", "Multiple fields can be searched using the Exactly syntax. In the following example, stock solutions with this exact set of Incompatible Materials (with the order taken into account):"},
			results=Search[Model[Sample, StockSolution], Exactly[IncompatibleMaterials == {Nitrile, CPVC, EPDM, Hypalon, NaturalRubber, Neoprene, Noryl, Polycarbonate, Polyurethane, PVC, Silicone, Viton}], SubTypes->False];
			And @@ ((MatchQ[#, {Nitrile, CPVC, EPDM, Hypalon, NaturalRubber, Neoprene, Noryl, Polycarbonate, Polyurethane, PVC, Silicone, Viton}]&) /@ Download[results, IncompatibleMaterials]),
			True,
			Variables :> {results}
		],
		Example[{Additional, "Any/All/Exactly", "Multiple fields can be searched using the All syntax. In the following example, samples will be returned whose incompatible materials are all Polyurethane:"},
			results=Search[Model[Sample], All[IncompatibleMaterials == Polyurethane], MaxResults->5];
			And @@ ((MatchQ[#, {Polyurethane..}]&) /@ Download[results, IncompatibleMaterials]),
			True,
			Variables :> {results},
			Stubs:>{
				(* NOTE: Don't include newly created objects since we will be running in parallel with other tests on manifold. *)
				$SearchMaxDateCreated=(Now-1Week)
			}
		],
		Test["Any syntax with two comparators using Or and ==:",
			results=Search[Model[Sample, StockSolution], Any[VolumeIncrements == 250 Milliliter] || Any[VolumeIncrements == 500 Milliliter], MaxResults->5];
			And @@ ((MemberQ[#, 250. Milliliter | 500. Milliliter]&) /@ Download[results, VolumeIncrements]),
			True,
			Variables :> {results},
			Stubs:>{
				(* NOTE: Don't include newly created objects since we will be running in parallel with other tests on manifold. *)
				$SearchMaxDateCreated=(Now-1Week)
			}
		],
		Test["Any syntax with two comparators using And and inequalities:",
			results=Search[Model[Sample, StockSolution], Any[VolumeIncrements >= 250 Milliliter] && Any[VolumeIncrements <= 500 Milliliter], MaxResults->5];
			And @@ ((MemberQ[#, GreaterEqualP[250 Milliliter]] && MemberQ[#, LessEqualP[500 Milliliter]]&) /@ Download[results, VolumeIncrements]),
			True,
			Stubs:>{
				(* NOTE: Don't include newly created objects since we will be running in parallel with other tests on manifold. *)
				$SearchMaxDateCreated=(Now-1Week)
			}
		],
		Test["Any syntax with two comparators using Or and inequalities:",
			results=Search[Model[Sample, StockSolution], Any[VolumeIncrements >= 250 Milliliter] || Any[VolumeIncrements <= 500 Milliliter], MaxResults->5];
			And @@ ((MemberQ[#, GreaterEqualP[250 Milliliter]] || MemberQ[#, LessEqualP[500 Milliliter]]&) /@ Download[results, VolumeIncrements]),
			True,
			Variables :> {results},
			Stubs:>{
				(* NOTE: Don't include newly created objects since we will be running in parallel with other tests on manifold. *)
				$SearchMaxDateCreated=(Now-1Week)
			}
		],
		Test["Any syntax across two fields:",
			results=Search[Model[Sample, StockSolution], Any[FillToVolumeRatios < 0.5 || FillToVolumeRatios > 1], MaxResults->5];
			And @@ ((MemberQ[#, LessP[0.5] | GreaterP[1]]&) /@ Download[results, FillToVolumeRatios]),
			True,
			Variables :> {results},
			Stubs:>{
				(* NOTE: Don't include newly created objects since we will be running in parallel with other tests on manifold. *)
				$SearchMaxDateCreated=(Now-1Week)
			}
		],
		Example[{Additional, "Any/All/Exactly", "Any syntax can be used to search on indexed multiple fields:"},
			results=Search[Object[Sample], Any[VolumeLog[[2]] == 0.5 Liter], MaxResults->5];
			And @@ ((MemberQ[#, 0.5 Liter]&) /@ Download[results, VolumeLog[[All, 2]]]),
			True,
			Variables :> {results},
			Stubs:>{
				(* NOTE: Don't include newly created objects since we will be running in parallel with other tests on manifold. *)
				$SearchMaxDateCreated=(Now-1Week)
			}
		],

		(* -- ALL -- *)
		Test["All syntax with ==:",
			results=Search[Model[Sample], All[IncompatibleMaterials == Polyurethane], MaxResults->5];
			And @@ ((MatchQ[#, {Polyurethane..}]&) /@ Download[results, IncompatibleMaterials]),
			True,
			Variables :> {results},
			Stubs:>{
				(* NOTE: Don't include newly created objects since we will be running in parallel with other tests on manifold. *)
				$SearchMaxDateCreated=(Now-1Week)
			}
		],
		Test["All syntax with one comparator:",
			results=Search[Model[Sample, StockSolution], All[FillToVolumeRatios > 0.9`], MaxResults->5];
			And @@ ((MatchQ[#, {GreaterP[0.9]..}]&) /@ Download[results, FillToVolumeRatios]),
			True,
			Variables :> {results},
			Stubs:>{
				(* NOTE: Don't include newly created objects since we will be running in parallel with other tests on manifold. *)
				$SearchMaxDateCreated=(Now-1Week)
			}
		],
		Test["All syntax with two comparators:",
			results=Search[Model[Sample, StockSolution], All[FillToVolumeRatios > 0.5 && FillToVolumeRatios < 1], MaxResults->5];
			And @@ ((MatchQ[#, {RangeP[0.5, 1]..}]&) /@ Download[results, FillToVolumeRatios]),
			True,
			Variables :> {results},
			Stubs:>{
				(* NOTE: Don't include newly created objects since we will be running in parallel with other tests on manifold. *)
				$SearchMaxDateCreated=(Now-1Week)
			}
		],
		Test["All syntax with two comparators using Or and ==:",
			results=Search[Model[Sample, StockSolution], All[VolumeIncrements == 250 Milliliter] || All[VolumeIncrements == 500 Milliliter], MaxResults->5];
			And @@ ((MatchQ[#, {(250. Milliliter | 500. Milliliter)..}]&) /@ Download[results, VolumeIncrements]),
			True,
			Variables :> {results},
			Stubs:>{
				(* NOTE: Don't include newly created objects since we will be running in parallel with other tests on manifold. *)
				$SearchMaxDateCreated=(Now-1Week)
			}
		],
		Test["All syntax with two comparators using And and inequalities:",
			results=Search[Model[Sample, StockSolution], All[VolumeIncrements >= 250 Milliliter] && All[VolumeIncrements <= 500 Milliliter], MaxResults->5];
			And @@ ((MatchQ[#, {GreaterEqualP[250. Milliliter]..}] && MatchQ[#, {LessEqualP[500. Milliliter]..}]&) /@ Download[results, VolumeIncrements]),
			True,
			Variables :> {results},
			Stubs:>{
				(* NOTE: Don't include newly created objects since we will be running in parallel with other tests on manifold. *)
				$SearchMaxDateCreated=(Now-1Week)
			}
		],
		Test["All syntax with two comparators using Or and inequalities:",
			results=Search[Model[Sample, StockSolution], All[VolumeIncrements >= 250 Milliliter] || All[VolumeIncrements <= 500 Milliliter], MaxResults->5];
			And @@ ((MatchQ[#, {GreaterEqualP[250. Milliliter]..}] || MatchQ[#, {LessEqualP[500. Milliliter]..}]&) /@ Download[results, VolumeIncrements]),
			True,
			Variables :> {results},
			Stubs:>{
				(* NOTE: Don't include newly created objects since we will be running in parallel with other tests on manifold. *)
				$SearchMaxDateCreated=(Now-1Week)
			}
		],
		Test["All syntax across two fields:",
			results=Search[Model[Sample, StockSolution], All[FillToVolumeRatios < 0.5 || FillToVolumeRatios > 1], MaxResults->5];
			And @@ (MatchQ[#1, {(LessP[0.5`] | GreaterP[1])..}]&) /@ Download[results, FillToVolumeRatios],
			True,
			Variables :> {results},
			Stubs:>{
				(* NOTE: Don't include newly created objects since we will be running in parallel with other tests on manifold. *)
				$SearchMaxDateCreated=(Now-1Week)
			}
		],
		Test["All syntax using an indexed multiple field:",
			results=Search[Object[Sample], All[VolumeLog[[2]] == 0.5 Liter], MaxResults->5];
			And @@ ((MatchQ[#, {(0.5 Liter)..}]&) /@ Download[results, VolumeLog[[All, 2]]]),
			True,
			Variables :> {results},
			Stubs:>{
				(* NOTE: Don't include newly created objects since we will be running in parallel with other tests on manifold. *)
				$SearchMaxDateCreated=(Now-1Week)
			}
		],

		(* -- EXACTLY -- *)
		Test["Exactly syntax with == on a Multiple Real field:",
			results=Search[Model[Sample, StockSolution], Exactly[FillToVolumeRatios == {0.990491, 0.990562}], SubTypes->False];
			And @@ ((MatchQ[#, {0.990491, 0.990562}]&) /@ Download[results, FillToVolumeRatios]),
			True,
			Variables :> {results}
		],
		Test["Exactly syntax with == on a Multiple Real field using empty list:",
			results=Search[Model[Sample, StockSolution], Exactly[FillToVolumeRatios == {}], SubTypes->False];
			And @@ ((MatchQ[#, {}]&) /@ Download[results, FillToVolumeRatios]),
			True,
			Variables :> {results},
			Stubs:>{
				(* NOTE: Don't include newly created objects since we will be running in parallel with other tests on manifold. *)
				$SearchMaxDateCreated=(Now-1Week)
			}
		],
		Test["Exactly syntax with == on a Multiple String field:",
			results=Search[Model[Sample], Exactly[Synonyms == {"Milli-Q water", "Type 1", "Type 1 water", "Ultrapure"}], SubTypes->False];
			And @@ ((MatchQ[#, {"Milli-Q water", "Type 1", "Type 1 water", "Ultrapure"}]&) /@ Download[results, Synonyms]),
			True,
			Variables :> {results}
		],

		(* -- SEARCH THROUGH LINKS TESTS -- *)
		Test["Search through links using a whole lot of traversals:",
			Search[Object[Protocol], CompletedTasks[[3]][FinancingTeams][Administrators][Name] == "frezza"],
			{ObjectReferenceP[Object[Protocol]]..}
		],
		Test["Single Link Field->Single Quantity Field:",
			With[{results=Search[Object[Example,Analysis],DataAnalysisTimeless[Temperature]==30 Celsius && Name=="Example Analysis " <> $SessionUUID]},
				Length[results]==1 && First[results[DataAnalysisTimeless]][Name] == "Example Timeless Data " <> $SessionUUID
			],
			True
		],
		Test["Single Link Field->Single Date Field:",
			With[{results=Search[Object[Data, Appearance], Protocol[DateCompleted] > (Today - 5 Day)]},
				And @@ ((MatchQ[#, GreaterP[(Today - 5 Day)]]&) /@ Download[results, Protocol[DateCompleted]])
			],
			True,
			Stubs:>{
				(* NOTE: Don't include newly created objects since we will be running in parallel with other tests on manifold. *)
				$SearchMaxDateCreated=(Now-1Week)
			}
		],
		Test["Single Link Field->Single Enumeration Field:",
			With[{results=Search[Object[Data, Chromatography], Protocol[Priority] == True && Name=="Search HPLC Test Data " <> $SessionUUID]},
				Length[results]==1 && First[results[Protocol]][Name] == "Search HPLC Test Protocol " <> $SessionUUID
			],
			True
		],
		Test["Single Link Field->Single String Field:",
			With[{results=Search[Object[Data, Chromatography], Protocol[Name] == "Search HPLC Test Protocol " <> $SessionUUID]},
				Length[results]==1 && First[results[Protocol]][Name] == "Search HPLC Test Protocol " <> $SessionUUID
			],
			True
		],
		Test["Single Link Field->Single Link Field:",
			With[{results=Search[Object[Data, Chromatography], Protocol[Data] == Object[Data, Chromatography, "Search HPLC Test Data "<>$SessionUUID]]},
				Length[results]==1 && First[results[Protocol]][Name] == "Search HPLC Test Protocol " <> $SessionUUID
			],
			True
		],
		Test["Single Link Field->Indexed Single Field (subindex):",
      With[{results=Search[Object[Data, Chromatography],
				Name == "Search HPLC Test Data " <> $SessionUUID &&
        Protocol[ColumnTighteningWrench][[1]] == Object[Item, Wrench, "Search Test Wrench " <> $SessionUUID]]},
				Length[results]==1 && First[results[Protocol]][Name] == "Search HPLC Test Protocol " <> $SessionUUID
			],
			True
		],
		Test["Single Link Field->Named Single Field (subname):",
			With[{results=Search[Object[Data, Chromatography],
				Protocol[FractionContainers][Positions][[Footprint]] == Open &&
        Name == "Search HPLC Test Data " <> $SessionUUID]},
				Length[results]==1 && First[results[Protocol]][Name] == "Search HPLC Test Protocol " <> $SessionUUID
			],
			True
		],
		Test["Single Link Field->Length of Multiple Field:",
			With[{results=Search[Object[Data, Chromatography], Length[Protocol[FractionContainers]] == 1 && Name == "Search HPLC Test Data " <> $SessionUUID]},
				Length[results]==1 && First[results[Protocol]][Name] == "Search HPLC Test Protocol " <> $SessionUUID
			],
			True
		],
		Test["Indexed Single Link Field->Single Field:",
		  With[{results=Search[Object[Data, Chromatography],
				Name == "Search HPLC Test Data " <> $SessionUUID &&
        Protocol[ColumnTighteningWrench][[1]][Name] == "Search Test Wrench " <> $SessionUUID]},
				Length[results]==1 && First[results[Protocol]][Name] == "Search HPLC Test Protocol " <> $SessionUUID
			],
			True
		],
		Test["Single Link Field->Contains of Multiple Field:",
		  With[{results=Search[Object[Data, Chromatography],
				Name=="Search HPLC Test Data " <> $SessionUUID &&
        Protocol[FractionContainers] ==Model[Container, "Search Test Container " <> $SessionUUID]]},
				Length[results]==1 && First[results[Protocol]][Name] == "Search HPLC Test Protocol " <> $SessionUUID
			],
			True
		],
		Test["Single Link Field->Single Link Field->Single Field:",
			With[{results=Search[Object[Protocol,HPLC],Data[Protocol][Name]=="Search HPLC Test Protocol "<>$SessionUUID]},
				Length[results]==1 && First[results][Name] == "Search HPLC Test Protocol " <> $SessionUUID
			],
			True
		],
		Test["Multiple Link Field->Single Field:",
			With[{results=Search[Object[Data, Chromatography],
				Name=="Search HPLC Test Data " <> $SessionUUID &&
        Protocol[FractionContainers][Name] == "Search Test Container " <> $SessionUUID]},
				Length[results]==1 && First[results[Protocol]][Name] == "Search HPLC Test Protocol " <> $SessionUUID
			],
			True
		],
		Test["Multiple Link Field->Multiple Link Field:",
			With[{results=Search[Object[Protocol, HPLC],
				Name=="Search HPLC Test Protocol " <> $SessionUUID &&
        Data[Protocol][FractionContainers][Name] == "Search Test Container " <> $SessionUUID]},
				Length[results]==1&& First[results][Name] == "Search HPLC Test Protocol " <> $SessionUUID
			],
			True
		],
		Test["Search through links with units on indexed multiple:",
			With[{results=Search[Object[Data, Chromatography],
				Protocol[FractionContainers][Positions][[MaxWidth]] == 1Meter &&
        Name=="Search HPLC Test Data " <> $SessionUUID]},
				Length[results]==1&& First[results[Protocol]][Name] == "Search HPLC Test Protocol " <> $SessionUUID
			],
			True
		],

		(* this should be made an Additional example as soon as SyncDocumentation can stop expanding the functions in it *)
		Test["Usage of 'Equal is equivalent to '==':",
			Search[
				Object[Container],
				And[
					Equal[Name, StringExpression["Search Test: fields", ___]],
					Equal[DeveloperObject, True]
				],
				SubTypes -> False
			][Name],
			{OrderlessPatternSequence[
				"Search Test: fields 1",
				"Search Test: fields 2",
				"Search Test: fields 3"
			]}
		],

		Test["Search with comparison and conditional operators like equality and greater than:",
			Search[
				Object[Container],
				And[
					Name=StringExpression["Search Test: fields", ___],
					TareWeight >= 300,
					DeveloperObject == True
				],
				SubTypes -> False
			][Name],
			{"Search Test: fields 2"}
		],

		Test["Search with comparison and conditional operators when using Field expressions:",
			Search[
				Object[Container],
				And[
					Field[Name] == StringExpression["Search Test: fields", ___],
					Field[TareWeight] >= 200.0,
					Field[DeveloperObject] == True
				],
				SubTypes -> False
			][Name],
			{"Search Test: fields 2"}
		],

		Test["Search with multiple conditionals on the same Field works:",
			Search[
				Object[Container],
				And[
					Name == StringExpression["Search Test: fields", ___],
					TareWeight > 150,
					TareWeight <= 300,
					DeveloperObject == True
				],
				SubTypes -> False
			][Name],
			{"Search Test: fields 2"}
		],

		Test["Search with Field and non Field expressions:",
			Search[
				Object[Container],
				And[
					Name == StringExpression["Search Test: fields", ___],
					Field[Status] == InUse,
					DeveloperObject == True
				],
				SubTypes -> False
			][Name],
			{OrderlessPatternSequence[
				"Search Test: fields 1",
				"Search Test: fields 2"
			]}
		],

		(* this should be made an Additional example as soon as SyncDocumentation can stop expanding the functions in it *)
		Test["Function forms of operators can be used:",
			Search[
				Object[Container],
				And[
					Equal[Name, StringExpression["Search Test: fields", ___]],
					GreaterEqual[TareWeight, 200],
					Equal[DeveloperObject, True]
				],
				SubTypes -> False
			][Name],
			{"Search Test: fields 2"}
		],

		Example[{Messages, "NotLoggedIn", "Returns $Failed and throws a message if you are not logged in:"},
			Search[Object[Container]],
			$Failed,
			Messages :> {
				Search::NotLoggedIn
			},
			Stubs :> {
				loggedInQ[]:=False
			}
		],
		Example[{Messages, "AmbiguousType", "Ambiguous Type Message:"},
			Message[Search::AmbiguousType, 1];,
			Null,
			Messages :> {
				Search::AmbiguousType
			}
		],
		Test["Returns $Failed and throws a NotLoggedIn message if not logged in for non-base Search overload:",
			Search[
				{
					{Object[Sample], Object[Container, Plate]},
					{Object[Container, Rack]}
				},
				MaxResults -> 5
			],
			$Failed,
			Messages :> {
				Search::NotLoggedIn
			},
			Stubs :> {
				loggedInQ[]:=False
			}
		],

		Test["Dates work for equalities and inequalities:",
			{
				Search[
					Object[Container],
					And[
						Name=StringExpression["Search Test: fields", ___],
						DateStocked < THEYEAR2000,
						DeveloperObject == True
					],
					SubTypes -> False
				][Name],
				Search[
					Object[Container],
					And[
						Name=StringExpression["Search Test: fields", ___],
						DateStocked == THEYEAR2000,
						DeveloperObject == True
					],
					SubTypes -> False
				][Name],
				Search[
					Object[Container],
					And[
						Name=StringExpression["Search Test: fields", ___],
						DateStocked > THEYEAR2000,
						DeveloperObject == True
					],
					SubTypes -> False
				][Name]
			},
			{
				{"Search Test: fields 1"},
				{"Search Test: fields 2"},
				{"Search Test: fields 3"}
			}
		],

		Test["Equalities work with fields which are links:",
			Search[
				Object[Container],
				And[
					Name == objName,
					Cap == link,
					DeveloperObject == True
				],
				SubTypes -> False
			],
			{obj},
			Variables :> {obj, objName},
			SetUp :> ({obj, objName, link, linkName}=setupSearchLink[])
		],

		Test["Search for an object with a specific Model:",
			Module[
				{model, object, result},
				model=Upload[<|Type -> Model[Example, Data]|>];
				object=Upload[<|Type -> Object[Example, Data], Model -> Link[model, Objects]|>];
				result=Search[Object[Example, Data], Model == model, SubTypes -> False];

				MatchQ[result, {object}]
			],
			True
		],

		Test["Wrapping Length around a field name does the predicate on the length of that multiple field:",
			Search[
				Object[Container],
				And[
					Name == StringExpression["Search Test: fields", ___],
					Length[StatusLog] == 2,
					DeveloperObject == True
				],
				SubTypes -> False
			][Name],
			{"Search Test: fields 2"}
		],

		Test["Works with indexed multiples while using infix Part syntax:",
			Search[
				Object[Container],
				And[
					Name == StringExpression["Search Test: fields", ___],
					StatusLog[[2]] == InUse,
					DeveloperObject == True
				],
				SubTypes -> False
			][Name],
			{OrderlessPatternSequence[
				"Search Test: fields 1",
				"Search Test: fields 2"
			]}
		],

		Test["Search within a named field using the name of the sub-field:",
			Search[
				Object[Example, Data],
				And[
					Name == StringExpression["Download Test: named fields ", ___],
					NamedSingle[[UnitColumn]] > Quantity[20, "Nanometers"],
					DeveloperObject == True
				],
				SubTypes -> False,
				MaxResults -> 5
			],
			{Repeated[Object[Example, Data, _String], 3]}
		],

		Test["Search within a named field using the index of the sub-field:",
			Search[
				Object[Example, Data],
				And[
					Name == StringExpression["Download Test: named fields ", ___],
					NamedSingle[[1]] > Quantity[20, "Nanometers"],
					DeveloperObject == True
				],
				SubTypes -> False,
				MaxResults -> 5
			],
			{Repeated[Object[Example, Data, _String], 3]}
		],

		Test["Fields can be held with the Field head to prevent evaluation:",
			With[{heldField=Field[Length[StatusLog]]},
				Search[
					Object[Container],
					And[
						Name=StringExpression["Search Test: fields", ___],
						heldField > 1,
						DeveloperObject == True
					],
					SubTypes -> False
				]
			][Name],
			{"Search Test: fields 2"}
		],

		Test["Field expressions may contain Length:",
			Search[
				Object[Container],
				And[
					Name == StringExpression["Search Test: fields", ___],
					Length[StatusLog] == 2,
					DeveloperObject == True
				]
			][Name],
			{"Search Test: fields 2"}
		],

		Test["Fields will evaluate, even when passed directly:",
			Search[
				Object[Container],
				And[
					Name=StringExpression["Search Test: fields", ___],
					Field[Length[StatusLog]] == 2,
					DeveloperObject == True
				],
				SubTypes -> False
			][Name],
			{"Search Test: fields 2"}
		],

		Test["Searching links will work with Names:",
			Search[
				Object[Container],
				(Cap == Object[Item, Cap, linkName]) && (DeveloperObject == True),
				SubTypes -> False
			],
			{obj},
			Variables :> {linkName, obj},
			SetUp :> ({obj, objName, link, linkName}=setupSearchLink[])
		],

		Test["Searching a super-Type searches across all its sub-Types:",
			Search[
				Object[Container],
				And[
					Name=StringExpression["Search Test: fields", ___],
					DeveloperObject == True
				]
			][Name],
			{OrderlessPatternSequence[
				"Search Test: fields 1",
				"Search Test: fields 2",
				"Search Test: fields 3",
				"Search Test: fields 4"
			]}
		],

		Example[{Messages, "MissingField", "The fields being searched for must exist in the type:"},
			Search[Object[Data, Chromatography], Status == Available],
			$Failed,
			Messages :> {
				Message[Search::MissingField, {{Status}}, {Object[Data, Chromatography]}]
			}
		],

		Test["The fields in a Field expression must exist in the type:",
			Search[Object[Data, Chromatography], Field[Foo] == "Taco", SubTypes -> False],
			$Failed,
			Messages :> {
				Message[Search::MissingField, {{Foo}}, {Object[Data, Chromatography]}]
			}
		],

		Example[{Messages, "InvalidSearchValues", "Fails if values are not valid search values:"},
			Search[Object[Container, Plate], Name == Mass[4], SubTypes -> False],
			$Failed,
			Messages :> {
				Search::InvalidSearchValues
			}
		],

		Example[{Messages, "InvalidSearchValues", "When searching with StringExpressions, the value must be strings or ___:"},
			Search[Object[Container, Plate], Name == StringExpression[WordCharacter..], SubTypes -> False],
			$Failed,
			Messages :> {
				Search::InvalidSearchValues
			}
		],

		Example[{Messages, "InvalidSearchQuery", "Fails if no valid conditions are supplied:"},
			Search[Object[Sample], Mass, SubTypes -> False],
			$Failed,
			Messages :> {
				Search::InvalidSearchQuery
			}
		],

		Example[{Messages, "MissingType", "Returns $Failed if type does not exist:"},
			Search[Object[Does, Not, Exist]],
			$Failed,
			Messages :> {
				Message[Search::MissingType, {Object[Does, Not, Exist]}]
			}
		],

		Example[{Messages, "MissingType", "Returns $Failed if any of the given types do not exist:"},
			Search[{Object[Sample], Object[Does, Not, Exist]}],
			$Failed,
			Messages :> {
				Message[Search::MissingType, {Object[Does, Not, Exist]}]
			}
		],

		Example[{Messages, "OptionLength", "Returns $Failed if MaxResults is a list that does not match the length of the inputs:"},
			Search[
				{Object[Sample], Object[Instrument]},
				{Status == Available, Status == InUse},
				MaxResults -> {20, 30, 40}
			],
			$Failed,
			Messages :> {
				Message[Search::OptionLength, MaxResults, 3, 2]
			}
		],

		Example[{Messages, "OptionLength", "Returns $Failed if SubTypes is a list and input arguments are not:"},
			Search[Object[Sample], SubTypes -> {True, False}],
			$Failed,
			Messages :> {
				Message[Search::OptionLength, SubTypes, 2, 0]
			}
		],

		Test["Limits the results to the number specified:",
			Search[Object[Sample], DeveloperObject == True, MaxResults -> 5, SubTypes -> False],
			{Repeated[ObjectP[Object[Sample]], {1, 5}]}
		],
		Example[{Options, MaxResults, "Limits the results to the number specified:"},
			Search[Model[Item, Column], MaxResults -> 5],
			{Repeated[ObjectP[Model[Item, Column]], {1, 5}]}
		],
		Test["Limits the results with SubTypes->True to the number specified:",
			Search[
				Object[Container],
				DeveloperObject == True,
				MaxResults -> 5,
				SubTypes -> True
			],
			{Repeated[ObjectP[Object[Container]], {5}]}
		],
		Test["Limits the results of multiple queries to different lengths:",
			Search[
				{Object[Item, Column], Object[Container, Plate]},
				{
					(Status == Available) && (DeveloperObject == True),
					(Status == InUse) && (DeveloperObject == True)
				},
				MaxResults -> {1, 2},
				SubTypes -> False
			],
			{
				{Repeated[ObjectP[Object[Item]], {1}]},
				{Repeated[ObjectP[Object[Container, Plate]], {2}]}
			}
		],
		Example[{Options, MaxResults, "Limits the results of multiple queries to different lengths:"},
			Search[
				{Object[Item], Model[Container, Plate]},
				{(Status == (Stocked | Available | InUse)) && (Model == Model[Item, Column, "id:1ZA60vwOKBrM"]), (Rows == 8) && (NumberOfWells == 96)},
				MaxResults -> {1, 2}
			],
			{
				{Repeated[ObjectP[Object[Item]], {1}]},
				{Repeated[ObjectP[Model[Container, Plate]], {2}]}
			}
		],
		Example[{Additional, "MapThread", "Search for multiple sets of types at once:"},
			Search[
				{
					{Object[Sample], Object[Container, Plate]},
					{Object[Container, Rack]}
				},
				MaxResults -> 5
			],
			{
				{Repeated[ObjectP[{Object[Sample], Object[Container, Plate]}], {1, 5}]},
				{Repeated[ObjectP[Object[Container, Rack]], {1, 5}]}
			}
		],

		Example[{Additional, "MapThread", "Search multiple sets of types at once with the same search criteria:"},
			Search[
				{
					{Object[Protocol, HPLC], Object[Protocol, PNASynthesis]},
					{Object[Protocol, MassSpectrometry]}
				},
				(Status == Completed) && (DateStarted < Now - 1Month),
				MaxResults -> 5
			],
			{
				{Repeated[ObjectP[{Object[Protocol, HPLC], Object[Protocol, PNASynthesis]}], {1, 5}]},
				{Repeated[ObjectP[Object[Protocol, MassSpectrometry]], {1, 5}]}
			}
		],

		Example[{Additional, "MapThread", "Search multiple sets of types at once with different criteria for each set:"},
			Search[
				{
					{Object[Protocol, HPLC], Object[Protocol, PNASynthesis]},
					{Object[Container, Rack]}
				},
				{
					Status == Completed && DateStarted < Now - 1Month,
					Status == Available
				},
				MaxResults -> 5
			],
			{
				{Repeated[ObjectP[{Object[Protocol, HPLC], Object[Protocol, PNASynthesis]}], {1, 5}]},
				{Repeated[ObjectP[Object[Container, Rack]], {1, 5}]}
			}
		],

		Example[{Additional, "MapThread", "Search with a different criteria for each type:"},
			Search[
				{Object[Container, Rack], Object[Data, Chromatography]},
				{
					(Status == InUse) && (DeveloperObject == True),
					DeveloperObject == True
				},
				MaxResults -> 5
			],
			{
				{Repeated[ObjectP[Object[Container, Rack]], {1, 5}]},
				{Repeated[ObjectP[Object[Data, Chromatography]], {1, 5}]}
			}
		],

		Example[{Messages, "MapThread", "The length of the search conditions list must be the same as the length of the types list:"},
			Search[{Object[Data, Chromatography], Object[Sample]}, {Name == "Whatever"}],
			$Failed,
			Messages :> {
				Search::MapThread
			}
		],

		Test["Indexed matched searching fails when a list of lists of types is a different length than the list of search clauses:",
			Search[
				{
					{Object[Sample]},
					{Object[Item, Consumable], Object[Sample]}, {Object[Example, Data], Object[User, Emerald, Operator]}
				},
				{Name == "Whatever"}
			],
			$Failed,
			Messages :> {
				Search::MapThread
			}
		],

		Test["Search using Alternatives inside an Equality:",
			Search[
				Object[Container],
				And[
					Name=StringExpression["Search Test: fields", ___],
					Status == (InUse | Discarded),
					DeveloperObject == True
				],
				SubTypes -> False
			][Name],
			{OrderlessPatternSequence[
				"Search Test: fields 1",
				"Search Test: fields 2",
				"Search Test: fields 3"
			]}
		],
		Example[{Additional, "Alternatives", "Use '|' (alternatives) in the search conditions. Note that parentheses must be used around the alternatives when the `|` syntax is used:"},
			Search[
				Model[Item, Column],
				SeparationMode == (ReversePhase | IonExchange)
			],
			{ObjectReferenceP[Model[Item, Column]]..}
		],
		Example[{Additional, "Alternatives", "Usage of 'Alternatives' is equivalent to '|':"},
			Search[Model[Item, Column], SeparationMode == Alternatives[ReversePhase, IonExchange]],
			Search[Model[Item, Column], SeparationMode == (ReversePhase | IonExchange)]
		],

		Test["Search for objects where a string field starts with a specific string:",
			Search[Object[Container, Rack], Name == ("Download Test"~~___) && DeveloperObject == True],
			PatternTest[
				{ObjectP[Object[Container, Rack]]..},
				Function[objects,
					AllTrue[
						Download[objects, Name],
						StringStartsQ["Download Test"]
					]
				]
			]
		],
		Example[{Additional, "Strings", "Search for objects where a string field starts with a specific string (by default, is case sensitive):"},
			Search[Model[Sample], StringContainsQ[Name, "Methanol"]],
			PatternTest[
				{ObjectP[Model[Sample]]..},
				Function[objects,
					AllTrue[
						Download[objects, Name],
						StringContainsQ["Methanol"]
					]
				]
			],
			Stubs:>{
				(* NOTE: Don't include newly created objects since we will be running in parallel with other tests on manifold. *)
				$SearchMaxDateCreated=(Now-1Week)
			}
		],
		Example[{Additional, "Strings", "Search for objects where a string field starts with a specific string (case insensitive):"},
			Search[Model[Sample], StringContainsQ[Name, "Methanol", IgnoreCase -> True]],
			PatternTest[
				{ObjectP[Model[Sample]]..},
				Function[objects,
					AllTrue[
						Download[objects, Name],
						StringContainsQ["Methanol" | "methanol"]
					]
				]
			],
			Stubs:>{
				(* NOTE: Don't include newly created objects since we will be running in parallel with other tests on manifold. *)
				$SearchMaxDateCreated=(Now-1Week)
			}
		],
		Test["Search for objects where a string field contains a specific string:",
			Search[Object[Container, Rack], Name == (___~~"oad Test Ra"~~___) && DeveloperObject == True],
			PatternTest[
				{ObjectP[Object[Container, Rack]]..},
				Function[objects,
					AllTrue[
						Download[objects, Name],
						StringContainsQ["oad Test Ra"]
					]
				]
			],
			Stubs:>{
				(* NOTE: Don't include newly created objects since we will be running in parallel with other tests on manifold. *)
				$SearchMaxDateCreated=(Now-1Week)
			}
		],
		Example[{Additional, "Strings", "Search for objects where a string field contains a specific string:"},
			Search[Model[Sample], Name == (___~~"Methanol"~~___)],
			PatternTest[
				{ObjectP[Model[Sample]]..},
				Function[objects,
					AllTrue[
						Download[objects, Name],
						StringContainsQ["Methanol"]
					]
				]
			],
			Stubs:>{
				(* NOTE: Don't include newly created objects since we will be running in parallel with other tests on manifold. *)
				$SearchMaxDateCreated=(Now-1Week)
			}
		],
		Test["Search for objects where a string field ends with a specific string (2):",
			(* work around some silly race condition where multiple things match this *)
			MemberQ[
				Download[
					Search[Object[Container, Rack], Name == (___~~"d Test Rack") && DeveloperObject == True],
					Name
				],
				"Download Test Rack"
			],
			True,
			Stubs:>{
				(* NOTE: Don't include newly created objects since we will be running in parallel with other tests on manifold. *)
				$SearchMaxDateCreated=(Now-1Week)
			}
		],
		Example[{Additional, "Strings", "Search for objects where a string field ends with a specific string:"},
			Search[Model[Sample], Name == (___~~"Water")],
			PatternTest[
				{ObjectP[Model[Sample]]..},
				Function[objects,
					AllTrue[
						Download[objects, Name],
						StringEndsQ["Water"]
					]
				]
			],
			Stubs:>{
				(* NOTE: Don't include newly created objects since we will be running in parallel with other tests on manifold. *)
				$SearchMaxDateCreated=(Now-1Week)
			}
		],

		Example[{Messages, "Alternatives", "The Alternatives syntax `|` must be wrapped in parentheses:"},
			Search[Object[Sample], Status == InUse | Inactive],
			$Failed,
			Messages :> {
				Message[Search::Alternatives]
			}
		],

		Test["Not-Equals operator works:",
			Search[
				Object[Container],
				And[
					Name == StringExpression["Search Test: fields", ___],
					Status != InUse,
					DeveloperObject == True
				],
				SubTypes -> False
			][Name],
			{"Search Test: fields 3"}
		],

		Test["Length operator works on Links:",
			Search[
				Object[Container],
				And[
					Name == objName,
					Length[Cap] == 1,
					DeveloperObject == True
				],
				SubTypes -> False
			],
			{obj},
			Variables :> {obj, objName},
			SetUp :> ({obj, objName, link, linkName}=setupSearchLink[])
		],

		Test["Null searches work:",
			Search[
				Object[Container],
				And[
					Name == StringExpression["Search Test: fields", ___],
					StatusLog == Null,
					DeveloperObject == True
				],
				SubTypes -> False
			][Name],
			{"Search Test: fields 3"}
		],

		Test["Not equals searches also return things where the field's value is Null:",
			Search[
				Object[Container],
				And[
					Name == StringExpression["Search Test: fields", ___],
					TareWeight != 150,
					DeveloperObject == True
				],
				SubTypes -> False
			][Name],
			{OrderlessPatternSequence[
				"Search Test: fields 2",
				"Search Test: fields 3"
			]}
		],

		Test["And expressions limit the search results correctly:",
			With[{notATestId="alksdjfkdj"<>CreateUUID[]},
				Search[Object[Example, Data], TestIdentifier == notATestId && Number > 0.0, SubTypes -> False]
			],
			_List?(Length[#] == 0 &)
		],

		Test["Nested ORs execute correctly:",
			Search[
				Object[Container],
				And[
					Name == StringExpression["Search Test: fields", ___],
					(Status == Discarded || DateStocked == THEYEAR2000),
					DeveloperObject == True
				],
				SubTypes -> False
			][Name],
			{OrderlessPatternSequence[
				"Search Test: fields 2",
				"Search Test: fields 3"
			]}
		],

		Test["Large unit conversions that trigger scientifc notation work:",
			{
				Search[
					Object[Container],
					And[
						Name == StringExpression["Search Test: fields", ___],
						TareWeight > 300000000 Micro Gram,
						DeveloperObject == True
					],
					SubTypes -> False
				],
				Search[
					Object[Container],
					And[
						Name == StringExpression["Search Test: fields", ___],
						TareWeight > 299999999 Micro Gram,
						DeveloperObject == True
					],
					SubTypes -> False
				][Name]
			},
			{
				{},
				{"Search Test: fields 2"}
			}
		],

		Test["Large number of criteria will still work tho is probably slow:",
			Search[
				Object[Container],
				And[
					Apply[Or,
						Table[Name == StringExpression["Search Test: fields", ___],
							{100}]
					],
					DeveloperObject == True
				],
				SubTypes -> False
			][Name],
			{OrderlessPatternSequence[
				"Search Test: fields 1",
				"Search Test: fields 2",
				"Search Test: fields 3"
			]}
		],

		Test["Search for an object where an indexed field matches some portion of a string:",
			Module[
				{uuid, newId},
				uuid=CreateUUID[];
				newId=Upload[
					<|
						Type -> Object[Example, Data],
						IndexedSingle -> {1, StringJoin["foo ", uuid, " bar"], Null}
					|>
				];
				MatchQ[Search[Object[Example, Data], IndexedSingle[[2]] == (___~~uuid~~" bar")], {newId}]
			],
			True
		],

		Test["When SubTypes is true, search in sub-types of the given type:",
			Search[
				Object[Container],
				And[
					Name == StringExpression["Search Test: fields", ___],
					DeveloperObject == True
				],
				SubTypes -> True
			][Name],
			Search[
				Types[Object[Container]],
				And[
					Name == StringExpression["Search Test: fields", ___],
					DeveloperObject == True
				],
				SubTypes -> False
			][Name]
		],
		Example[{Options, SubTypes, "When SubTypes is true, the given type and all of its subtypes are searched:"},
			Search[Model[Container, Plate], SubTypes -> True],
			{ObjectReferenceP[{Model[Container, Plate], Model[Container, Plate, Filter]}]..}
		],
		Example[{Options, SubTypes, "When SubTypes is false, only the given type and none of its subtypes are searched:"},
			Search[Model[Container, Plate], SubTypes -> True],
			{ObjectReferenceP[Model[Container, Plate]]..}
		],
		Example[{Options, Notebooks, "Limits search to the given list of laboratory notebooks (by default public objects are included in the result, to exclude set PublicObjects to False):"},
			Module[{result},
				result=Search[Object[Example, Data], Number == 10., Notebooks -> {notebook}, PublicObjects->False];
				And[MemberQ[result,privateObject],FreeQ[result,publicObject]]
			],
			True,
			Variables :> {notebook,publicObject,privateObject},
			SetUp:>{
				notebook=Upload[<|Type->Object[LaboratoryNotebook]|>];

				Block[{$Notebook=notebook},
					privateObject = Upload[
						<|
							Type->Object[Example,Data],
							Number->10
						|>
					];
				];

				publicObject = Upload[
					<|
						Type->Object[Example,Data],
						Number->10
					|>
				];
			}
		],
		Example[{Options, PublicObjects, "Allows inclusion or exclusion of public notebooks when specifying notebooks to search on:"},
			Module[{result},
				result=Search[Object[Example, Data], Number == 10., Notebooks -> {notebook}, PublicObjects -> True];
				ContainsAll[result, {publicObject,privateObject}]
			],
			True,
			Variables :> {notebook,publicObject,privateObject},
			SetUp:>{
				notebook=Upload[<|Type->Object[LaboratoryNotebook]|>];

				Block[{$Notebook=notebook},
					privateObject = Upload[
						<|
							Type->Object[Example,Data],
							Number->10
						|>
					];
				];

				publicObject = Upload[
					<|
						Type->Object[Example,Data],
						Number->10
					|>,
					AllowPublicObjects -> True
				];
			}
		],
		Example[{Options, Notebooks, "Limits search to the given list of laboratory notebooks for multiple searches:"},
			Length /@ Search[{Object[Example, Data], Object[Example, Data]}, {Number == 10, Number == 10}, Notebooks -> {{Object[LaboratoryNotebook, "123"]}, Null}, MaxResults -> 1],
			0, 1],
		Example[{Options, Notebooks, "Allow inclusion or exclusion of public objects for multiple searches:"},
			Length /@ Search[{Object[Example, Data], Object[Example, Data]}, {Number == 10, Number == 10}, Notebooks -> {{Object[LaboratoryNotebook, "123"]}, {Object[LaboratoryNotebook, "123"]}}, PublicObjects -> {True, False}, MaxResults -> 1],
			1, 0],
		Example[{Options, Notebooks, "Allow inclusion or exclusion of public objects for multiple searches with a single query clause:"},
			Length /@ Search[{Object[Example, Data], Object[Example, Data]}, Number == 10, Notebooks -> {{Object[LaboratoryNotebook, "123"]}, {Object[LaboratoryNotebook, "123"]}}, PublicObjects -> {True, False}, MaxResults -> 1],
			1, 0],

		Test["Objects are returned in order of creation, but truncated by MaxResults to those most recently created:",
			Module[
				{id, u1, u2, u3, u4},
				id=CreateUUID[];

				(* create three objects separately *)
				u1=Upload@<|Type -> Object[Example, Data], TestIdentifier -> id, Temperature -> 45.0|>;
				u2=Upload@<|Type -> Object[Example, Data], TestIdentifier -> id, Temperature -> 13.1|>;
				u3=Upload@<|Type -> Object[Example, Data], TestIdentifier -> id, Temperature -> 27.3|>;
				u4=Upload@<|Type -> Object[Example, Data], TestIdentifier -> id, Temperature -> 35.5|>;

				(* update the middle one *)
				Upload@<|Object -> u2, Temperature -> 13.7|>;

				(* confirm the results are ordered as we expect *)
				Search[Object[Example, Data], TestIdentifier == id, MaxResults -> 3] == {u2, u3, u4} &&
					Search[Object[Example, Data], TestIdentifier == id] == {u1, u2, u3, u4}
			],
			True
		],

		Test["Notebooks option test:",
			Block[{id, u1, u2, u3, u4, $Notebook=Object[LaboratoryNotebook, "123"]},
				id=CreateUUID[];
				u1=Upload[<|Type -> Object[Example, Data], TestIdentifier -> id, Temperature -> 10.1|>];
				u2=Upload[<|Type -> Object[Example, Data], TestIdentifier -> id, Temperature -> 20.2|>];
				u3=Upload[<|Type -> Object[Example, Data], TestIdentifier -> id, Temperature -> 30.3|>];
				u4=Upload[<|Type -> Object[Example, Data], TestIdentifier -> id, Temperature -> 40.4|>];
				Length[Search[Object[Example, Data], TestIdentifier == id, Notebooks -> {Object[LaboratoryNotebook, "123"]}]]],
			4
		],

		Test["Notebooks option test, one notebook out of two:",
			Block[{id, u1, u2, u3, u4, $Notebook=Object[LaboratoryNotebook, "1"]},
				id=CreateUUID[];
				u1=Upload[<|Type -> Object[Example, Data], TestIdentifier -> id, Temperature -> 10.1|>];
				u2=Upload[<|Type -> Object[Example, Data], TestIdentifier -> id, Temperature -> 20.2|>];
				$Notebook=Object[LaboratoryNotebook, "2"];
				u3=Upload[<|Type -> Object[Example, Data], TestIdentifier -> id, Temperature -> 30.3|>];
				u4=Upload[<|Type -> Object[Example, Data], TestIdentifier -> id, Temperature -> 40.4|>];
				Length[Search[Object[Example, Data], TestIdentifier == id, Notebooks -> {Object[LaboratoryNotebook, "1"]}]]],
			2
		],

		Test["PublicObjects option test:",
			Block[{id, u1, u2, u3,
				u4, $Notebook=Object[LaboratoryNotebook, "123"]},
				id=CreateUUID[];
				u1=Upload[<|Type -> Object[Example, Data], TestIdentifier -> id, Temperature -> 10.1|>];
				u2=Upload[<|Type -> Object[Example, Data], TestIdentifier -> id, Temperature -> 20.2|>];
				u3=Upload[<|Type -> Object[Example, Data], TestIdentifier -> id, Temperature -> 30.3|>];
				u4=Upload[<|Type -> Object[Example, Data], TestIdentifier -> id, Temperature -> 40.4|>];
				{Length[
					Search[Object[Example, Data],
						Notebooks -> {Object[LaboratoryNotebook, "123"]},
						PublicObjects -> True, MaxResults -> 10]],
					Length[
						Search[Object[Example, Data], TestIdentifier == id,
							Notebooks -> {Object[LaboratoryNotebook, "123"]},
							PublicObjects -> False, MaxResults -> 10]]}
			],
			{10, 4}
		],

		Test["Another PublicObjects option test:",
			Module[{id, u1},
				id=CreateUUID[];
				u1=Upload[
					<|Type -> Object[Example, Data], TestIdentifier -> id, Temperature -> 10.1|>,
					AllowPublicObjects -> True
				];
				Block[{u3, $Notebook=Object[LaboratoryNotebook, "123"]},
					u3=Upload[<|Type -> Object[Example, Data], TestIdentifier -> id,
						Temperature -> 30.3|>];

					{Search[Object[Example, Data], TestIdentifier == id, Notebooks -> {Object[LaboratoryNotebook, "123"]}, PublicObjects -> True] == {u1, u3},
						Search[Object[Example, Data], TestIdentifier == id, Notebooks -> {Object[LaboratoryNotebook, "123"]}, PublicObjects -> False] == {u3}}
				]
			],
			{True, True}
		],

		Example[{Messages, "Error", "Search errors happen on things like network problems:"},
			Search[Model[Item, Column], SeparationMode == ReversePhase],
			$Failed,
			Messages :> {Search::Error},
			Stubs :> {
				ConstellationRequest[___]:={HTTPError[None, "Server error."]}
			}
		],

		Example[{Messages, "ComputableField", "Computable fields cannot be searched:"},
			Search[Object[Sample], ModelName == "Ethanol"],
			$Failed,
			Messages :> {
				Message[Search::ComputableField, {{ModelName}}, {Object[Sample]}]
			}
		],

		Example[{Messages, "CloudFileField", "Cloud file fields cannot be searched:"},
			Search[
				Object[EmeraldCloudFile],
				CloudFile == ECL`EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-dev", "a0956ce18c6342c3a42da4060d67941a.jpg", "xRO9n3vk1D0lSYDzN8JwP64lfqjWPmLEXRNY"]
			],
			$Failed,
			Messages :> {
				Message[Search::CloudFileField, {{CloudFile}}, {Object[EmeraldCloudFile]}]
			}
		],

		Example[{Messages, "InvalidField", "Compressed fields cannot be searched:"},
			Search[Object[Analysis, Fit], ResolvedOptions == 4],
			$Failed,
			Messages :> {
				Message[Search::InvalidField, {{ResolvedOptions}}, {Object[Analysis, Fit]}]
			}
		],

		Test["Filters out Developer Objects by default:",
			Module[
				{id, devObject, object, foundObjects},
				id=CreateUUID[];
				devObject=Upload[<|Type -> Object[Example, Data], DeveloperObject -> True, TestIdentifier -> id|>];
				object=Upload[<|Type -> Object[Example, Data], TestIdentifier -> id|>];
				foundObjects=Search[Object[Example, Data], TestIdentifier == id];
				{
					MemberQ[foundObjects, devObject],
					MemberQ[foundObjects, object]
				}
			],
			{False, True}
		],

		Test["If the DeveloperObject field is specified as a condition, do not filter them out:",
			Module[
				{id, devObject, object, foundObjects},
				id=CreateUUID[];
				devObject=Upload[<|Type -> Object[Example, Data], DeveloperObject -> True, TestIdentifier -> id|>];
				object=Upload[<|Type -> Object[Example, Data], TestIdentifier -> id|>];
				foundObjects=Search[Object[Example, Data], TestIdentifier == id && DeveloperObject == True];
				{
					MemberQ[foundObjects, devObject],
					MemberQ[foundObjects, object]
				}
			],
			{True, False}
		],
		Test["If the $DeveloperSearch global flag is provided, exclusively return developer objects:",
			Module[
				{id, devObject, object, foundObjects},
				id=CreateUUID[];
				devObject=Upload[<|Type -> Object[Example, Data], DeveloperObject -> True, TestIdentifier -> id|>];
				object=Upload[<|Type -> Object[Example, Data], TestIdentifier -> id|>];
				foundObjects=Block[
					{$DeveloperSearch=True},
					Search[Object[Example, Data], TestIdentifier == id]
				];
				{
					MemberQ[foundObjects, devObject],
					MemberQ[foundObjects, object]
				}
			],
			{True, False}
		],
		Test["If the $RequiredSearchName global flag is provided, exclusively return objects that have the specified string in its Name:",
			Module[
				{id, yesObj, noObj, foundObjects},
				id=CreateUUID[];
				yesObj=Upload[<|Type -> Object[Example, Data], Name -> "Yes find this object" <> id, TestIdentifier -> id|>];
				noObj=Upload[<|Type -> Object[Example, Data], Name -> "No do not find this object" <> id, TestIdentifier -> id|>];
				foundObjects=Block[
					{$RequiredSearchName = "Yes"},
					Search[Object[Example, Data], TestIdentifier == id]
				];
				{
					MemberQ[foundObjects, yesObj],
					MemberQ[foundObjects, noObj]
				}
			],
			{True, False}
		],
		Test["If the $SearchMaxDateCreated global flag is provided, exclusively return objects that were created before $SearchMaxDateCreated (via the DateCreated field):",
			Module[
				{foundObjects},

				(* Make a brand new object to make sure we don't find it. *)
				Upload[<|Type -> Object[Example, Data]|>];

				foundObjects=Block[
					{$SearchMaxDateCreated = (Now-1 Week)},
					Search[Object[Example, Data]]
				];

				Download[foundObjects, DateCreated]
			],
			{(LessEqualP[(Now-1 Week)] | Null)..}
		],
		Test["If the $RequiredSearchName global flag is provided but the Name variable is also set, ignore $RequiredSearchName:",
			Module[
				{id, yesObj, noObj, foundObjects},
				id=CreateUUID[];
				yesObj=Upload[<|Type -> Object[Example, Data], Name -> "Yes find this object" <> id, TestIdentifier -> id|>];
				noObj=Upload[<|Type -> Object[Example, Data], Name -> "No do not find this object" <> id, TestIdentifier -> id|>];
				foundObjects=Block[
					{$RequiredSearchName = "Yes"},
					Search[Object[Example, Data], TestIdentifier == id && StringContainsQ[Name, "find this object", IgnoreCase -> False]]
				];
				{
					MemberQ[foundObjects, yesObj],
					MemberQ[foundObjects, noObj]
				}
			],
			{True, True}
		],
		Test["If the $RequiredSearchName global flag is provided and $DeveloperSearch = True, make sure both things are accounted for:",
			Module[
				{id, yesObj, noObj, foundObjects},
				id=CreateUUID[];
				yesObj=Upload[<|Type -> Object[Example, Data], Name -> "Yes find this object" <> id, DeveloperObject -> True, TestIdentifier -> id|>];
				noObj=Upload[<|Type -> Object[Example, Data], Name -> "No do not find this object" <> id, TestIdentifier -> id|>];
				foundObjects=Block[
					{$RequiredSearchName = "Yes", $DeveloperSearch = True},
					Search[Object[Example, Data], TestIdentifier == id]
				];
				{
					MemberQ[foundObjects, yesObj],
					MemberQ[foundObjects, noObj]
				}
			],
			{True, False}
		],
		Test["If the $RequiredSearchName global flag is provided and $DeveloperSearch = True, make sure both things are accounted for (2):",
			Module[
				{id, yesObj, noObj, foundObjects},
				id=CreateUUID[];
				yesObj=Upload[<|Type -> Object[Example, Data], Name -> "Yes find this object" <> id, DeveloperObject -> True, TestIdentifier -> id|>];
				noObj=Upload[<|Type -> Object[Example, Data], Name -> "No do not find this object" <> id, TestIdentifier -> id|>];
				foundObjects=Block[
					{$RequiredSearchName = "Neither object", $DeveloperSearch = True},
					Search[Object[Example, Data], TestIdentifier == id]
				];
				{
					MemberQ[foundObjects, yesObj],
					MemberQ[foundObjects, noObj]
				}
			],
			{False, False}
		],
		Test["Search with multiple != <value> works:",
			Search[
				Object[Container, GasCylinder],
				(Status != Discarded) && (DeveloperObject == True),
				MaxResults -> 2,
				SubTypes -> False
			],
			{Repeated[ObjectP[Object[Container, GasCylinder]], {1, 2}]}
		],

		Test["Filters out Developer Objects from search with no conditions:",
			With[
				{devObject=Upload[<|Type -> Object[Example, Data], DeveloperObject -> True|>]},
				MemberQ[
					Search[Object[Example, Data], MaxResults -> 50],
					devObject
				]
			],
			False
		],

		Test["Length 0, == null are identical on multiple fields:",
			Search[
				Object[Example, Data],
				(TestIdentifier == testId) && (Random == Null),
				SubTypes -> False
			],
			Search[
				Object[Example, Data],
				(TestIdentifier == testId) && (Length[Random] == 0),
				SubTypes -> False
			],
			Variables :> {testId},
			SetUp :> (
				testId="Search Test: "<>CreateUUID[];
				Upload[{
					<|
						Type -> Object[Example, Data],
						TestIdentifier -> testId,
						Replace[Random] -> {}
					|>
				}];
			)
		],

		Test["Length 0, == null are identical on single fields:",
			Complement[
				Search[
					Object[Example, Data],
					(TestIdentifier == testId) && (Length[Number] == 0),
					SubTypes -> False
				],
				Search[
					Object[Example, Data],
					(TestIdentifier == testId) && (Number == Null),
					SubTypes -> False
				]
			],
			{},
			Variables :> {testId},
			SetUp :> (
				testId="Search Test: "<>CreateUUID[];
				Upload[{
					<|
						Type -> Object[Example, Data],
						TestIdentifier -> testId
					|>
				}];
			)
		],

		Test["Length 0 doesn't contain items with Length != 0:",
			Map[Length,
				Map[#[Random] &,
					Search[
						Object[Example, Data],
						(TestIdentifier == testId) && (Length[Random] == 0),
						SubTypes -> False
					]
				],
				1
			],
			{0, 0},
			Variables :> {testId},
			SetUp :> (
				testId="Search Test: "<>CreateUUID[];
				Upload[{
					<|
						Type -> Object[Example, Data],
						TestIdentifier -> testId,
						Replace[Random] -> {}
					|>,
					<|
						Type -> Object[Example, Data],
						TestIdentifier -> testId,
						Replace[Random] -> {1.0, 2.0, 3.0}
					|>,
					<|
						Type -> Object[Example, Data],
						TestIdentifier -> testId
					|>
				}];
			)
		],

		Test["Length > 0 doesn't contain items with Length == 0:",
			Map[Length,
				Map[#[Random] &,
					Search[
						Object[Example, Data],
						(TestIdentifier == testId) && (Length[Random] > 0),
						SubTypes -> False
					]
				],
				1
			],
			{3},
			Variables :> {testId},
			SetUp :> (
				testId="Search Test: "<>CreateUUID[];
				Upload[{
					<|
						Type -> Object[Example, Data],
						TestIdentifier -> testId,
						Replace[Random] -> {}
					|>,
					<|
						Type -> Object[Example, Data],
						TestIdentifier -> testId,
						Replace[Random] -> {1.0, 2.0, 3.0}
					|>
				}];
			)
		],

		Test["Length is zero for never-set fields, set to empty fields, and set then emptied fields:",
			With[
				{newIds3=Upload[{
					<|
						Type -> Object[Example, Data],
						TestIdentifier -> testId
					|>,
					<|
						Type -> Object[Example, Data],
						TestIdentifier -> testId,
						Replace[Random] -> {}
					|>,
					<|
						Type -> Object[Example, Data],
						TestIdentifier -> testId,
						Replace[Random] -> {1.0, 2.0, 3.0}
					|>
				}]},

				Upload[{<|Object -> newIds3[[3]], Replace[Random] -> {}|>}];

				Complement[
					Search[
						Object[Example, Data],
						TestIdentifier == testId && Length[Random] == 0,
						SubTypes -> False
					],
					newIds3
				]
			],
			{},
			Variables :> {testId},
			SetUp :> (testId="Search Test: "<>CreateUUID[];)
		],

		Test["Overwriting a single link with appending to a multiple means the link is no longer a hit when Searching that link:",
			Module[
				{obj1, obj2, obj3, check},
				{obj1, obj2, obj3}=Upload[{<|Type -> Object[Example, Data]|>, <|Type -> Object[Example, Data]|>, <|Type -> Object[Example, Data]|>}];

				Upload[<| Object -> obj1, Append[TestRun] -> {{1.1, Link[obj3, TestName]}}|>];
				(* check it comes back from the search. *)
				check=MemberQ[Search[Object[Example, Data], TestName == obj1], obj3];
				If[Not[check], Return[$Failed]];

				(* overwrite with the new link *)
				Upload[<| Object -> obj2, Append[TestRun] -> {{2.1, Link[obj3, TestName]}}|>];
				check=Length[Search[Object[Example, Data], TestName == obj1]];
				(* obj3 should no longer show up in the search for objects linked to obj1, and in fact there should be nothing linked to obj1 anymore *)
				If[check =!= 0, Return[$Failed]];

				True (* otherwise the test passes *)
			],
			True
		],

		Test["Search on an indexed multiple field == Null:",
			Search[Object[Example, Data], GroupedMultipleAppendRelation == Null, MaxResults -> 1],
			{ObjectReferenceP[Object[Example, Data]]...}
		],

		Test["Search on a multiple field == Null:",
			Search[Object[Example, Data], Random == Null, MaxResults -> 1],
			{ObjectReferenceP[Object[Example, Data]]...}
		],

		Test["Search on Length of a multiple field == 0:",
			Search[Object[Example, Data], Length[GroupedMultipleAppendRelation] == 0, MaxResults -> 1],
			{ObjectReferenceP[Object[Example, Data]]...}
		],

		Test["Search on Length of an indexed multiple field == 0:",
			Search[Object[Example, Data], Length[Random] == 0, MaxResults -> 1],
			{ObjectReferenceP[Object[Example, Data]]...}
		],

		Test["Searching for a date range on a big type should be reasonably quick:",
			(* Should take < 15 seconds, giving it lots of wiggle room / timing space. *)
			AbsoluteTiming[TimeConstrained[Search[Object[Program, ProcedureEvent],
				DateCreated >= "2017-05-15T00:00:00-07:00" &&
					DateCreated <= "2017-05-16T00:00:00-07:00"];, 60]],
			{_?(# < 50 &), Null}
		],
		Test["Search on a multiple field with date as the first type should work:",
			Search[Object[Sample], VolumeLog != Null, MaxResults -> 3],
			{ObjectReferenceP[Object[Sample]]...}
		],
		Example[{Additional, "VariableUnit", "Quantities with different units can be searched for in VariableUnit fields:"},
			Search[Model[Sample], ExtinctionCoefficients[[ExtinctionCoefficient]] > 200000 Liter / (Centimeter * Mole), MaxResults -> 10],
			{ObjectReferenceP[Model[Sample]]..}
		],
		Example[{Additional, "VariableUnit", "Quantities with different units can be searched for in VariableUnit fields:"},
			Search[Model[Sample], (ExtinctionCoefficients[[ExtinctionCoefficient]] > 200000 Liter / (Centimeter * Mole)) || ExtinctionCoefficients[[ExtinctionCoefficient]] > 0 Milli Liter / (Milli Gram * Centimeter), MaxResults -> 10],
			{ObjectReferenceP[Model[Sample]]..}
		],
		Test["Quantities with different units can be searched for in VariableUnit fields (volume):",
			Search[
				Object[Example, Data],
				VariableUnitData >= (2 Liter) && TestIdentifier == testID && DeveloperObject == True
			],
			(* both 3 G and 2 L are >= 2 L *)
			{obj1, obj2},
			Variables :> {testID, obj1, obj2, obj3},
			SetUp :> (
				testID=CreateUUID[];
				{obj1, obj2, obj3}=Upload[{
					<| Type -> Object[Example, Data], VariableUnitData -> 3 Gallon, TestIdentifier -> testID, DeveloperObject -> True |>,
					<| Type -> Object[Example, Data], VariableUnitData -> 2 Liter, TestIdentifier -> testID, DeveloperObject -> True |>,
					<| Type -> Object[Example, Data], VariableUnitData -> 7 Kilogram, TestIdentifier -> testID, DeveloperObject -> True |>
				}]
			)
		],

		Test["Quantities with different units can be searched for in VariableUnit fields (weight):",
			Search[
				Object[Example, Data],
				VariableUnitData == (7 Kilogram) && TestIdentifier == testID && DeveloperObject == True
			],
			{obj3},
			Variables :> {testID, obj1, obj2, obj3},
			SetUp :> (
				testID=CreateUUID[];
				{obj1, obj2, obj3}=Upload[{
					<| Type -> Object[Example, Data], VariableUnitData -> 3 Gallon, TestIdentifier -> testID, DeveloperObject -> True |>,
					<| Type -> Object[Example, Data], VariableUnitData -> 2 Liter, TestIdentifier -> testID, DeveloperObject -> True |>,
					<| Type -> Object[Example, Data], VariableUnitData -> 7 Kilogram, TestIdentifier -> testID, DeveloperObject -> True |>
				}]
			)
		],

		Test["When no units are used in a search on a VariableUnit field, errors are given:",
			Search[
				Object[Example, Data],
				VariableUnitData == 7 && TestIdentifier == testID && DeveloperObject == True
			],
			$Failed,
			Messages :> {
				Message[Search::Error]
			},
			Variables :> {testID, obj1, obj2, obj3},
			SetUp :> (
				testID=CreateUUID[];
				{obj1, obj2, obj3}=Upload[{
					<| Type -> Object[Example, Data], VariableUnitData -> 3 Gallon, TestIdentifier -> testID, DeveloperObject -> True |>,
					<| Type -> Object[Example, Data], VariableUnitData -> 2 Liter, TestIdentifier -> testID, DeveloperObject -> True |>,
					<| Type -> Object[Example, Data], VariableUnitData -> 7 Kilogram, TestIdentifier -> testID, DeveloperObject -> True |>
				}]
			)
		],

		Test["Mixtures of simple (meter) and complex (newton) VariableUnit values don't overlap in eachother's searches:",
			{Search[Object[Example, Data], VariableUnitWeightOrLength >= (1 Newton) && TestIdentifier == testID && DeveloperObject == True],
				Search[Object[Example, Data], VariableUnitWeightOrLength >= (1 Inch) && TestIdentifier == testID && DeveloperObject == True]},
			{{obj1}, {obj2}},
			Variables :> {testID, obj1, obj2},
			SetUp :> (
				testID=CreateUUID[];
				{obj1, obj2}=Upload[{
					<| Type -> Object[Example, Data], VariableUnitWeightOrLength -> 7 Newton, TestIdentifier -> testID, DeveloperObject -> True |>,
					<| Type -> Object[Example, Data], VariableUnitWeightOrLength -> 2 Inch, TestIdentifier -> testID, DeveloperObject -> True |>
				}]
			)
		],

		Test["Mixtures of different normalized units work with AND:",
			Search[
				Object[Example, Data],
				(VariableUnitWeightOrLength >= (1 Newton) && VariableUnitWeightOrLength >= (0 Inch)) && TestIdentifier == testID && DeveloperObject == True
			],
			{},
			Variables :> {testID, obj1, obj2},
			SetUp :> (
				testID=CreateUUID[];
				{obj1, obj2}=Upload[{
					<| Type -> Object[Example, Data], VariableUnitWeightOrLength -> 7 Newton, TestIdentifier -> testID, DeveloperObject -> True |>,
					<| Type -> Object[Example, Data], VariableUnitWeightOrLength -> 2 Inch, TestIdentifier -> testID, DeveloperObject -> True |>
				}]
			)
		],

		Test["Mixtures of different normalized units work with OR:",
			Search[
				Object[Example, Data],
				(VariableUnitWeightOrLength >= (1 Newton) || VariableUnitWeightOrLength >= (0 Inch)) && TestIdentifier == testID && DeveloperObject == True
			],
			{obj1, obj2},
			Variables :> {testID, obj1, obj2},
			SetUp :> (
				testID=CreateUUID[];
				{obj1, obj2}=Upload[{
					<| Type -> Object[Example, Data], VariableUnitWeightOrLength -> 7 Newton, TestIdentifier -> testID, DeveloperObject -> True |>,
					<| Type -> Object[Example, Data], VariableUnitWeightOrLength -> 2 Inch, TestIdentifier -> testID, DeveloperObject -> True |>
				}]
			)
		],

		Test["Both normalized and uploaded units can be searched for in VariableUnit fields:",
			{Search[Object[Example, Data], VariableUnitWeightOrLength == (1 Meter) && TestIdentifier == testID && DeveloperObject == True],
				Search[Object[Example, Data], VariableUnitWeightOrLength == (5000 / 127 Inch) && TestIdentifier == testID && DeveloperObject == True],
				Search[Object[Example, Data], VariableUnitWeightOrLength == (39.37007874015748 Inch) && TestIdentifier == testID && DeveloperObject == True],
				Search[Object[Example, Data], VariableUnitWeightOrLength == (39.3701 Inch (* rounded *)) && TestIdentifier == testID && DeveloperObject == True]},
			{{obj}, {obj}, {obj}, {(* :crying_cat_face: *)}},
			Variables :> {testID, obj},
			SetUp :> (
				testID=CreateUUID[];
				obj=Upload[<| Type -> Object[Example, Data], VariableUnitWeightOrLength -> 1 Meter, TestIdentifier -> testID, DeveloperObject -> True |>];
				Upload[<| Type -> Object[Example, Data], VariableUnitWeightOrLength -> 7 Meter, TestIdentifier -> testID, DeveloperObject -> True |>];
			)
		],

		Test["Unsupported (server-side) units can't be searched for in VariableUnit fields:",
			Search[
				Object[Example, Data],
				(* radiant intensity, including SolidAngleUnit	*)
				VariableWildcard == (Quantity[1, "Watts"] / Quantity[1, "People"])
			],
			$Failed,
			Messages :> {
				Message[Search::Error]
			}
		],

		Test["Some gnarly units work:",
			{Search[Object[Example, Data], VariableWildcard == (Quantity[3.1709791983764587*^-13, "Newtons"]) && TestIdentifier == testID && DeveloperObject == True],
				Search[Object[Example, Data], VariableWildcard == (22075200000000 * Centimeter * 1 Gram / (1 Second) / (1 Year)) && TestIdentifier == testID && DeveloperObject == True]},
			{{obj1}, {obj2}},
			Variables :> {testID, obj1, obj2},
			SetUp :> (
				testID=CreateUUID[];
				obj1=Upload[<| Type -> Object[Example, Data], VariableWildcard -> (1.0 Centimeter * 1 Gram / (1 Second) / (1 Year)), TestIdentifier -> testID, DeveloperObject -> True |>];
				obj2=Upload[<| Type -> Object[Example, Data], VariableWildcard -> (7 Newton), TestIdentifier -> testID, DeveloperObject -> True |>];
				Upload[<| Type -> Object[Example, Data], VariableWildcard -> 7 Meter, TestIdentifier -> testID, DeveloperObject -> True |>];
			)
		],

		Test["Search with AND on multiple indexed fields:",
			Module[
				{s1, s2, formulas} ,
				s1=Model[Sample, "id:1ZA60vLr1Yqa"];
				s2=Model[Sample, "id:kEJ9mqRJ6NP8"];
				formulas=Search[Model[Sample, StockSolution], And[(Formula[[2]] == s1), (Formula[[2]] == s2)]][Formula];
				MatchQ[formulas, formulas // Select[MatchQ[{OrderlessPatternSequence[{_, LinkP[s1]}, {_, LinkP[s2]}, ___]}]]]
			],
			True
		],

		Test["Search with AND where fields are Null:",
			Module[
				{results},
				results=Search[Object[Protocol, ImageSample], Length[ContainersIn] > 2 && ImagerFilePaths != Null];
				{AllTrue[Length /@ results[ContainersIn], TrueQ[# > 2]&], AllTrue[results[ImagerFilePaths], TrueQ[Length[#] > 0]&]}
			],
			{True, True}
		],

		Test["Search with AND where DeveloperObject is not defaulted to False:",
			Module[
				{results},
				results=Search[Object[Qualification, EngineBenchmark], OperationStatus == (OperatorReady) && (DeveloperObject == (True | False) || DeveloperObject == Null)];
				{AllTrue[results[OperationStatus], MatchQ[OperatorReady]], AllTrue[results[DeveloperObject], MatchQ[True | False | Null]]}
			],
			{True, True}
		],

		Test["Search with time only evaluates the proper versions of an Object:",
			Module[
				{timeBeforeChanges, testID, resultWithoutTime, resultWithTime, obj},
				testID=CreateUUID[];
				obj=Upload[<| Type -> Object[Example, Data], VariableUnitWeightOrLength -> 1 Meter, TestIdentifier -> testID, DeveloperObject -> True |>];

				(* Right now, objlog can't be super granular to the millisecond, so adding a buffer *)
				Pause[1];
				timeBeforeChanges=Now;
				Pause[1];

				obj=Upload[<|Object -> obj, VariableUnitWeightOrLength -> 3 Meter|>];
				resultWithoutTime=Search[Object[Example, Data], VariableUnitWeightOrLength == (1 Meter) && TestIdentifier == testID && DeveloperObject == True];
				resultWithTime=Search[Object[Example, Data], VariableUnitWeightOrLength == (1 Meter) && TestIdentifier == testID && DeveloperObject == True, Date -> timeBeforeChanges];
				Length /@ {resultWithoutTime, resultWithTime}
			],
			{0, 1}
		],
		Example[{Options, IgnoreTime, "Search with IgnoreTime returns the latest value:"},
			resultWithoutTime= Search[Object[Example, Data], VariableUnitWeightOrLength == (1 Meter) &&
						TestIdentifier == testID && DeveloperObject == True];
			resultWithTime=
				Search[Object[Example, Data],
					VariableUnitWeightOrLength == (1 Meter) &&
						TestIdentifier == testID && DeveloperObject == True,
					Date -> timeBeforeChanges];
			resultWithTimeLatestValue=
				Search[Object[Example, Data],
					VariableUnitWeightOrLength == (3 Meter) &&
						TestIdentifier == testID && DeveloperObject == True,
					Date -> timeBeforeChanges ];
			resultWithIgnoreTime=
				Search[Object[Example, Data],
					VariableUnitWeightOrLength == (3 Meter) &&
						TestIdentifier == testID && DeveloperObject == True,
					Date -> timeBeforeChanges, IgnoreTime -> True ];
			Length /@ {resultWithoutTime, resultWithTime,
				resultWithTimeLatestValue, resultWithIgnoreTime}, {0, 1, 0, 1},
			Variables :> {timeBeforeChanges, testID, resultWithoutTime, resultWithTime, resultWithTimeLatestValue, resultWithIgnoreTime,
				obj},
			SetUp :> (
				testID=CreateUUID[];
				obj=Upload[<|Type -> Object[Example, Data],
					VariableUnitWeightOrLength -> 1 Meter, TestIdentifier -> testID,
					DeveloperObject -> True|>];
				Pause[1];
				timeBeforeChanges=Now;
				Pause[1];
				obj=Upload[<|Object -> obj, VariableUnitWeightOrLength -> 3 Meter|>];
				Pause[3];
			)
		],
		Test["Search across temporal link with IgnoreTime:",
			(
				result1=Search[Object[Example, Data],
					OneWayLinkTemporal[StringData] == "2" && TestIdentifier == testID];
				result2=Search[Object[Example, Data],
					OneWayLinkTemporal[StringData] == "2" &&
						TestIdentifier == testID, IgnoreTime -> True];
				result3=Search[Object[Example, Data],
					OneWayLinkTemporal[StringData] == "3" &&
						TestIdentifier == testID, IgnoreTime -> True];
				Length /@ {result1, result2, result3}
			),
			{1, 0, 1},
			Variables :> {testID, data1, time1, analysis2, data2, time2, time3, time4,
				time5, time7, result1, result2, result3},
			SetUp :> (
				testID=CreateUUID[];
				analysis2=
					Upload[<|Type -> Object[Example, Analysis], StringData -> "2"|>];

				Pause[1];
				time2=Now;
				Upload[<|Object -> analysis2, StringData -> "3"|>];

				Pause[1];
				time3=Now;
				Pause[1];
				time4=Now;
				data2=
					Upload[<|Type -> Object[Example, Data], Number -> 5,
						OneWayLink -> Link[analysis2],
						OneWayLinkTemporal -> Link[analysis2, time2],
						TestIdentifier -> testID|>];

				Pause[1];
				time5=Now;
				Upload[<|Object -> data2, Number -> 6,
					OneWayLink -> Link[analysis2],
					OneWayLinkTemporal -> Link[analysis2, time3]|>];

				Pause[1];
				Upload[<|Object -> data2, Number -> 7,
					OneWayLinkTemporal -> Link[analysis2, time2]|>];

				Pause[1];
			)
		],
		Test["Field wrapper doesn't error around Part:",
			Search[Object[Transaction, Order], Field[Products[KitComponents][[ProductModel]]] == Model[Container, Vessel, Dialysis, "id:J8AY5jD5l4OE"], MaxResults -> 1],
			{ObjectP[Object[Transaction, Order]]}
		],

		Test["Field wrapper doesn't error around Part in middle:",
			Search[Object[Protocol, HPLC], Field[CompletedTasks[[3]][FinancingTeams][Administrators][Name]] == "frezza", MaxResults -> 1],
			{ObjectP[Object[Protocol, HPLC]]}
		],

		Test["Field wrapper doesn't error around two Parts:",
			Search[Object[Transaction, Order], Field[Products[KitComponents][[ProductModel]][Composition][[2]]] == Model[Molecule, "Water"], MaxResults -> 1],
			{ObjectP[Object[Transaction, Order]]}
		],
		Test["Field wrapper doesn't error around Length:",
			Search[Object[Transaction, Order], Field[Length[Products[KitComponents]]] > 2, MaxResults -> 1],
			{ObjectP[Object[Transaction, Order]]}
		],
		Example[{Additional, "Search respects timeless objects. (The original value at historical time was 1 degree Celsius):"},
			MemberQ[Search[Object[Example, TimelessData], Temperature == Quantity[10000.`, "DegreesCelsius"], Date -> historicalTime], timelessObj],
			True,
			TimeConstraint -> 10000
		],
		Test["Search respects timeless objects search for old value:",
			FreeQ[Search[Object[Example, TimelessData], Temperature == Quantity[1.`, "DegreesCelsius"], Date -> historicalTime], timelessObj],
			True,
			TimeConstraint -> 10000
		],
		Example[{Additional, "Search respects timeless object through links. (The original value at historical time was 1 degree Celsius):"},
			MemberQ[Search[Object[Example, Analysis], DataAnalysisTimeless[Temperature] == Quantity[10000.`, "DegreesCelsius"], Date -> historicalTime], temporalObjThatHasLinkToTimelessObj],
			True,
			TimeConstraint -> 10000
		],
		Test["Search respects timeless object through links when searching for old value:",
			FreeQ[Search[Object[Example, Analysis], DataAnalysisTimeless[Temperature] == Quantity[1.`, "DegreesCelsius"], Date -> historicalTime], temporalObjThatHasLinkToTimelessObj],
			True,
			TimeConstraint -> 10000
		],
		Test["Old values of timeless objects can be searched when debugTime is set:",
			MemberQ[Search[Object[Example, Analysis], DataAnalysisTimeless[Temperature] == Quantity[1.`, "DegreesCelsius"]], temporalObjThatHasLinkToTimelessObj],
			True,
			SetUp :> setDebugTime[historicalTime],
			TearDown :> clearDebugTime[],
			TimeConstraint -> 10000
		],
		Test["Search on Max with SubTypes -> True returns a single result:",
			Length@Search[Model[Molecule], Max[MolecularWeight]],
			1
		],
		Test["Search on Min with SubTypes -> True returns a single result:",
			Length@Search[Model[Molecule], Min[MolecularWeight]],
			1
    ],
		Test["Can Search on Type using Alternatives:",
			Search[{Object[Qualification]},
				Type != (Alternatives @@ {Object[Qualification, Training, ColumnHandling], Object[Qualification, Training, DangerZone]}), MaxResults -> 1],
			_
		],
		Test["Can search on types defined as an expression:",
			Greater[Length@Search[Object[UnitTest, Function], Function == Object[User, Emerald]], 0],
			True,
			SetUp :> Upload[<|Type -> Object[UnitTest, Function],Function -> Object[User, Emerald]|>]
    ],
		Test["Allow Model[x] and Object[x] to get interpreted as Expressions rather than Links when on the RHS of the query:",
			Search[Object[Product], ProductModel[Type] == Model[Container]],
			_
    ],
		Test["Traversals involving parts at the end get parsed without warning:",
			Search[Object[Transaction, Order], Products == Object[Product, "Test Product for search traversal with parts at end " <> $SessionUUID] ||
						Products[KitComponents][[ProductModel]] == Model[Sample, "Test model for search traversal with parts at end " <> $SessionUUID], MaxResults -> 1],
			_,
			SetUp :> Upload[{<|Type -> Object[Product], Name ->  "Test Product for search traversal with parts at end " <> $SessionUUID|>, <|Type -> Model[Sample], Name -> "Test model for search traversal with parts at end " <> $SessionUUID|>}]
		],
		Test["Traversals involving parts in the middle get parsed without warning:",
			Search[Object[Transaction, Order], Products == Object[Product, "Test Product for search traversal with parts at middle " <> $SessionUUID] ||
					Products[KitComponents][[ProductModel]][Name] == "pavan", MaxResults -> 1],
			_,
			SetUp :> Upload[{<|Type -> Object[Product], Name ->  "Test Product for search traversal with parts at middle " <> $SessionUUID|>}]
		],
		Test["Throw message when attempting to use the Nothing keyword:",
			Search[Object[Sample], Model == Model[Sample, "Acetonitrile, HPLC Grade"] && Or[Nothing, Notebook == Null], MaxResults -> 10],
			$Failed,
			Messages :> {
				Search::InvalidSearchQuery
			}
		],
		Test["Can auto-infer and convert units with fractional value to Real:",
			Download[Upload[<|
				Type->Object[Data,Microscope],
				Temperature->1/3
			|>], Temperature],
			N@Quantity[1/3, "DegreesCelsius"]
		],
		Test["Can properly handle string patterns that contain a '%' character in conditions:",
			{
				Search[Object[Example, Data], Name == (___~~ $SessionUUID <> "%" ~~___)][Name],
				Search[Object[Example, Data], StringContainsQ[Field[Name], $SessionUUID <> "%"]][Name]
			},
			{
				{$SessionUUID <> "% Test Data Object"},
				{$SessionUUID <> "% Test Data Object"}
			},
			SetUp :> Upload[{
				<|Type -> Object[Example, Data], Name -> $SessionUUID <> "% Test Data Object"|>,
				<|Type -> Object[Example, Data], Name -> $SessionUUID <> " No-Percent Test Data Object"|>
			}]
		]
		(*
		 Test["Units works when searching through links:",
			Module[{sample, container},
				sample = Upload[<|Type -> Object[Sample], Name -> "Test Search Through Links Units" <> $SessionUUID, Volume -> 5 Liter|>];
				container = Upload[<|Type -> Object[Container], Append[Contents] -> {"A1", Link[sample, Container]}|>];
				{Length@Search[Object[Container], Name == "Test Search Through Links Units" <> $SessionUUID && Contents[[2]][Volume] < 100 Microliter],
					Length@Search[Object[Container], Name == "Test Search Through Links Units" <> $SessionUUID && Contents[[2]][Volume] > 100 Microliter]}
			],
			{0,1}
		] *)
	},
	SymbolSetUp :> (
		Module[
			{columnWrench, container, hplcProtocol, hplcData, dataTimeless, data, analysis},

			columnWrench = Upload[<|Type->Object[Item, Wrench], Name->"Search Test Wrench " <> $SessionUUID|>];
			container = Upload[<|Type->Model[Container], Name->"Search Test Container " <> $SessionUUID,Replace[Positions]->{<|Name->"Fake Reservoir Slot",Footprint->Open,MaxWidth->1Meter,MaxDepth->1Meter,MaxHeight->Null|>}|>];
			hplcProtocol=Upload[<|Type->Object[Protocol, HPLC], Priority->True, Name -> "Search HPLC Test Protocol " <> $SessionUUID, DateCompleted ->Now, ColumnTighteningWrench->{Link[columnWrench], Null}, Replace[FractionContainers]->{Link[container]}|>];
			hplcData = Upload[<|Type->Object[Data, Chromatography], Protocol->Link[hplcProtocol, Data], Name->"Search HPLC Test Data " <> $SessionUUID|>];
			dataTimeless=Upload[<|Type->Object[Example,TimelessData],Temperature->30 Celsius,Name->"Example Timeless Data "<>$SessionUUID|>];
			data=Upload[<|Type->Object[Example,Data],Temperature->30 Celsius,NamedSingle-><|UnitColumn->4 Nano Meter, MultipleLink -> Null|>,Name->"Example Data "<>$SessionUUID|>];
			analysis=Upload[<|Type->Object[Example,Analysis],DataAnalysisTimeless->Link[dataTimeless,DataAnalysis],DataAnalysis->Link[data,DataAnalysis],Name->"Example Analysis "<>$SessionUUID|>];
		];
		{timelessObj, temporalObjThatHasLinkToTimelessObj, historicalTime}=setupTimelessObject[];
		setupSearchObjects[];
		setupSearchFields[];
		setupNamedFields[];
		setupNotebookNamed123[];
		setupNotebookNamed1[];
		setupNotebookNamed2[];
		setupDownloadExampleObjects[];
	),
	SymbolTearDown :> (
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	),
	Stubs :> {
		$DisableVerbosePrinting=False
	}
];

setupSearchObjects[]:=(
	idempotentUpload[Object[Container], "Search Test: container 1",
		<|
			DeveloperObject -> True,
			Status -> InUse
		|>
	];
	idempotentUpload[Object[Container, Plate], "Search Test: plate 1",
		<|
			DeveloperObject -> True,
			Status -> InUse
		|>
	];
	idempotentUpload[Object[Container, Plate], "Search Test: plate 2",
		<|
			DeveloperObject -> True,
			Status -> InUse
		|>
	];
	idempotentUpload[Object[Container, Plate], "Search Test: plate 3",
		<|
			DeveloperObject -> True,
			Status -> Available
		|>
	];
	idempotentUpload[Object[Container, Rack], "Search Test: rack 1",
		<|
			DeveloperObject -> True,
			Status -> InUse
		|>
	];
	idempotentUpload[Object[Container, Rack], "Search Test: rack 2",
		<|
			DeveloperObject -> True,
			Status -> Available
		|>
	];
	idempotentUpload[Object[Instrument, HPLC], "Search test: hplc 1",
		<|
			DeveloperObject -> True
		|>
	];
	idempotentUpload[Object[Instrument, HPLC], "Search Test: hplc 2",
		<|
			DeveloperObject -> True
		|>
	];
	idempotentUpload[Object[Data, Chromatography], "Search Test: chromatography 1",
		<|
			DeveloperObject -> True
		|>
	];
	idempotentUpload[Object[Container, GasCylinder], "Search Test: cylinder 2",
		<|
			Status -> InUse,
			DeveloperObject -> True
		|>
	];
	idempotentUpload[Object[Container, GasCylinder], "Search Test: cylinder 2",
		<|
			Status -> InUse,
			DeveloperObject -> True
		|>
	];
	idempotentUpload[Object[Sample], "Search Test: sample 1",
		<|
			DeveloperObject -> True,
			Status -> Available
		|>
	];
);

THEYEAR2000=DateObject[{2000, 1, 1, 0, 0, 0}, "Instant", "Gregorian", -8.];

setupSearchFields[]:=(
	idempotentUpload[Object[Container], "Search Test: fields 1",
		<|
			DateStocked -> (THEYEAR2000 - Quantity[1, "Day"]),
			Status -> InUse,
			Replace[StatusLog] -> {{Now, InUse, Null}},
			TareWeight -> 150,
			DeveloperObject -> True
		|>
	];
	idempotentUpload[Object[Container], "Search Test: fields 2",
		<|
			DateStocked -> THEYEAR2000,
			Status -> InUse,
			Replace[StatusLog] -> {{Now, InUse, Null}, {Now, InUse, Null}},
			TareWeight -> 300,
			DeveloperObject -> True
		|>
	];
	idempotentUpload[Object[Container], "Search Test: fields 3",
		<|
			DateStocked -> THEYEAR2000 + Quantity[1, "Day"],
			Status -> Discarded,
			DeveloperObject -> True
		|>
	];
	idempotentUpload[Object[Container, Rack], "Search Test: fields 4",
		<|
			Status -> Discarded,
			DeveloperObject -> True
		|>
	];
);


setupSearchLink[]:=Module[
	{obj, objName, link, linkName},

	linkName="Search Test Analysis Hook"<>CreateUUID[];
	objName="objName"<>CreateUUID[];

	link=Upload[<|
		Type -> Object[Item, Cap],
		Name -> linkName,
		DeveloperObject -> True
	|>];

	obj=Upload[<|
		Type -> Object[Container],
		Cap -> Link[link, CappedContainer],
		Name -> objName,
		DeveloperObject -> True
	|>];

	{obj, objName, link, linkName}
];


DefineTests[
	parallelSearch,
	{
		Example[{Basic,"Search multiple sets of types at once with different criteria for each set, allowing empty lists:"},
			parallelSearch[
				{Object[Instrument, HPLC], Object[Container, Plate]},
				{
					(Status == InUse) && (DeveloperObject == True),
					(Status == Available) && (DeveloperObject == True)
				},
				MaxResults -> 5
			],
			{
				{Repeated[ObjectP[Object[Instrument, HPLC]], {0, 5}]},
				{Repeated[ObjectP[Object[Container, Plate]], {0, 5}]}
			}
		],
		Example[{Basic,"All search queries are done in parallel:"},
			Module[{types},
				
				types = Types[Object[Instrument]];
				
				With[{clauses = Table[(Status == Available) && (DeveloperObject == True),Length[types]]},
					parallelSearch[types,clauses]
				]
			],
			{{ObjectP[Object[Instrument]]...}..}
		],
		Example[{Basic,"Because the queries are done in parallel, the runtime should be faster than Search:"},
			Module[{types},
				
				types = RandomChoice[Types[Object[Instrument]],20];
				
				With[{clauses = Table[(Status == Available) && (DeveloperObject == True),Length[types]]},
					{RepeatedTiming[parallelSearch[types,clauses]][[1]],RepeatedTiming[Search[types,clauses]][[1]]}
				]
			],
			_?((#[[1]]<#[[2]])&)
		]
	}
]
