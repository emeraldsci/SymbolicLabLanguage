(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(*<MIGRATION-TAG: DO-NOT-MIGRATE>*)

DefineObjectType[Object[Example, Data], {
	Description->"Fake data for unit testing",
	CreatePrivileges->Developer,
	Fields -> {
		DataAnalysis -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Example, Analysis][DataAnalysis],
			Description -> "Example analysis of this example data.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		DataAnalysisTemporal -> {
			Format -> Multiple,
			Class -> TemporalLink,
			Pattern :> _Link,
			Relation -> Object[Example, Analysis][DataAnalysis],
			Description -> "Example analysis of this historical example data.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?TemperatureQ,
			Units -> Celsius,
			Description -> "The temperature of the example data.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		Number -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?NumericQ,
			Units -> None,
			Description -> "A number.",
			Category -> "Experiments & Simulations",
			Required -> True,
			Abstract -> False
		},
		Random -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> _?NumericQ,
			Units -> None,
			Description -> "A set of random numbers to append for the example data.",
			Category -> "Experiments & Simulations",
			Required -> True,
			Abstract -> False
		},
		TemperatureDistribution -> {
			Format -> Single,
			Class -> Distribution,
			Pattern :> DistributionP[Celsius],
			Units -> Celsius,
			Description -> "A distribution of temperatures.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		Strands -> {
			Format -> Multiple,
			Class -> {Integer, Expression},
			Pattern :> {_Integer, _?StrandQ},
			Units -> {None, None},
			Headers -> {"strand number", "strand"},
			Description -> "Storing weird strand expressions.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		Time -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> _?TimeQ,
			Units -> Second,
			Description -> "A list of times.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		VariableUnitData -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> GreaterP[0 Gram] | GreaterP[0 Liter],
			Description -> "A mass or a volume, with normalized units.",
			Category -> "Experiments & Simulations"
		},
		VariableUnitWeightOrLength -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> UnitsP[Newton] | UnitsP[Meter],
			Description -> "A weight or a length, with normalized units.",
			Category -> "Experiments & Simulations"
		},
		VariableWildcard -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> UnitsP[],
			Description -> "A weight or a length, with normalized units.",
			Category -> "Experiments & Simulations"
		},
		GroupedUnits -> {
			Format -> Multiple,
			Class -> {String, Real},
			Pattern :> {_String, _?TimeQ},
			Units -> {None, Second},
			Headers -> {"string", "time"},
			Description -> "Grouped multiple with Units.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		Replace -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> _?NumericQ,
			Units -> None,
			Description -> "A set of random numbers to replace for the example data.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		ReplaceAll -> {
			Format -> Multiple,
			Class -> {Real, Expression},
			Pattern :> {_?NumericQ, _Symbol},
			Units -> {None, None},
			Headers -> {"number", "symbol"},
			Description -> "A grouped set of random numbers and symbols to replace for the example data.",
			Category -> "Experiments & Simulations",
			Required -> True,
			Abstract -> False
		},
		ReplaceRepeated -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Example, Data][TestName],
			Description -> "A set of relations to test dangling deletion for the example data.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		TestRun -> {
			Format -> Multiple,
			Class -> {Real, Link},
			Pattern :> {_?NumericQ, _Link},
			Relation -> {Null, Object[Example, Data][TestName]},
			Units -> {None, None},
			Headers -> {"number", "test name"},
			Description -> "A grouped set of random numbers and relations to test dangling deletion for the example data.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		TestName -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> {Object[Example, Data][ReplaceRepeated], Object[Example, Data][TestRun, 2]},
			Description -> "A single relation to test dangling deletion for the example data.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		TestIdentifier -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "A string to group together all the data created for a single unit test.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "A string field for uniqueness for delete unit test.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		SingleRelation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Example, Data][SingleRelationAmbiguous],
			Description -> "A single relation.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		SingleRelationAmbiguous -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> {Object[Example, Data][SingleRelation], Object[Example, Data][SingleRelationAmbiguous]},
			Description -> "An ambiguous single relation.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		MultipleAppendRelation -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Example, Data][MultipleAppendRelationAmbiguous],
			Description -> "A multiple append relation.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		MultipleAppendRelationAmbiguous -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> {Object[Example, Data][MultipleAppendRelation], Object[Example, Data][MultipleAppendRelationAmbiguous]},
			Description -> "An ambiguous multiple append relation.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		MultipleReplaceRelation -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Example, Data][MultipleReplaceRelationAmbiguous],
			Description -> "A multiple replace relation.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		MultipleReplaceRelationAmbiguous -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> {Object[Example, Data][MultipleReplaceRelation], Object[Example, Data][MultipleReplaceRelationAmbiguous]},
			Description -> "An ambiguous multiple replace relation.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		GroupedMultipleAppendRelation -> {
			Format -> Multiple,
			Class -> {String, Link},
			Pattern :> {_String, _Link},
			Relation -> {Null, Object[Example, Data][GroupedMultipleAppendRelationAmbiguous, 2]},
			Headers -> {"string", "link"},
			Description -> "A grouped multiple append relation.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		GroupedMultipleAppendRelationAmbiguous -> {
			Format -> Multiple,
			Class -> {String, Link},
			Pattern :> {_String, _Link},
			Relation -> {Null, {Object[Example, Data][GroupedMultipleAppendRelation, 2], Object[Example, Data][GroupedMultipleAppendRelationAmbiguous, 2]}},
			Headers -> {"string", "link"},
			Description -> "An ambiguous grouped multiple append relation.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		GroupedMultipleReplaceRelation -> {
			Format -> Multiple,
			Class -> {String, Link},
			Pattern :> {_String, _Link},
			Relation -> {Null, Object[Example, Data][GroupedMultipleReplaceRelationAmbiguous, 2]},
			Headers -> {"string", "link"},
			Description -> "A grouped multiple replace relation.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		GroupedMultipleReplaceRelationAmbiguous -> {
			Format -> Multiple,
			Class -> {String, Link},
			Pattern :> {_String, _Link},
			Relation -> {Null, {Object[Example, Data][GroupedMultipleReplaceRelation, 2], Object[Example, Data][GroupedMultipleReplaceRelationAmbiguous, 2]}},
			Headers -> {"string", "link"},
			Description -> "An ambiguous grouped multiple replace relation.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		PersonRelation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Example, Person, Emerald][DataRelation],
			Description -> "Person who made this data.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		Compressed -> {
			Format -> Single,
			Class -> Compressed,
			(*Fake pattern gets around ValidTypeQ*)
			Pattern :> _?(True&),
			Units -> None,
			Description -> "A compressed field.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		AppendRelation1 -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Example, Data][AppendRelation2],
			Description -> "A multiple append relation.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		AppendRelation2 -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Example, Data][AppendRelation1],
			Description -> "A multiple append relation.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		S3Single -> {
			Format -> Single,
			Class -> EmeraldCloudFile,
			Pattern :> EmeraldFileP,
			Description -> "Single field which stores an EmeraldCloudFile.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		S3MultipleAppend -> {
			Format -> Multiple,
			Class -> EmeraldCloudFile,
			Pattern :> EmeraldFileP,
			Description -> "MultipleAppend field which stores an EmeraldCloudFile.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		S3MultipleReplace -> {
			Format -> Multiple,
			Class -> EmeraldCloudFile,
			Pattern :> EmeraldFileP,
			Description -> "MultipleReplace field which stores an EmeraldCloudFile.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		S3IndexedSingle -> {
			Format -> Single,
			Class -> {String, EmeraldCloudFile},
			Pattern :> {_String, EmeraldFileP},
			Headers -> {"string", "file"},
			Description -> "IndexedSingle field which stores an EmeraldCloudFile.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		S3IndexedMultiple -> {
			Format -> Multiple,
			Class -> {String, EmeraldCloudFile},
			Pattern :> {_String, EmeraldFileP},
			Headers -> {"string", "file"},
			Description -> "IndexedMultiple field which stores an EmeraldCloudFile.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		S3NamedSingle -> {
			Format -> Single,
			Class -> {Label -> String, File -> EmeraldCloudFile},
			Pattern :> {Label -> _String, File -> EmeraldFileP},
			Headers -> {Label -> "A file description.", File -> "A file."},
			Description -> "Named single test field which stores an EmeraldCloudFile.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		S3NamedMultiple -> {
			Format -> Multiple,
			Class -> {Label -> String, File -> EmeraldCloudFile},
			Pattern :> {Label -> _String, File -> EmeraldFileP},
			Headers -> {Label -> "A file description.", File -> "A file."},
			Description -> "Named multiple test field which stores an EmeraldCloudFile.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		QuantityArray1D -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{Meter..}],
			Units -> Meter,
			Description -> "Holds a 1D QuantityArray of distances.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		QuantityArray2D -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Second, Meter}..}],
			Units -> {Second, Meter},
			Description -> "Holds a single 2D QuantityArray of {time,distance} points.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		QuantityArray2DMultiple -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Second, Meter}..}],
			Units -> {Second, Meter},
			Description -> "Holds a list of 2D QuantityArray of {time,distance} points.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		QuantityArrayIndexedMultiple -> {
			Format -> Multiple,
			Class -> {String, Real, QuantityArray},
			Pattern :> {_String, _?MassQ, QuantityArrayP[{{Second, Meter}..}]},
			Units -> {None, Gram, {Second, Meter}},
			Headers -> {"string", "quantity", "quantity array"},
			Description -> "QuantityArray in an indexed multiple.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		IndexedCloudFile -> {
			Format -> Multiple,
			Class -> {Integer, EmeraldCloudFile},
			Pattern :> {_Integer, EmeraldFileP},
			Units -> {None, None},
			Headers -> {"integer", "file"},
			Description -> "Indexed multiple field with cloud file.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		IndexedSingle -> {
			Format -> Single,
			Class -> {Integer, String, Link},
			Pattern :> {_Integer, _String, _Link},
			Relation -> {Null, Null, Object[Example, Data][IndexedSingleBacklink]},
			Units -> {Meter, None, None},
			Headers -> {"meters", "string", "link"},
			Description -> "Indexed single test field.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		IndexedSingleBacklink -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Example, Data][IndexedSingle, 3],
			Description -> "Backlink test for indexed single.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		NamedSingle -> {
			Format -> Single,
			Class -> {UnitColumn -> Real, MultipleLink -> Link},
			Pattern :> {UnitColumn -> GreaterP[0 Nanometer], MultipleLink -> _Link},
			Units -> {UnitColumn -> Nanometer, MultipleLink -> None},
			Relation -> {
				UnitColumn -> Null,
				MultipleLink -> Object[Example, Data][NamedMultiple, SingleLink]
			},
			Headers -> {
				UnitColumn -> "A column with units.",
				MultipleLink -> "A column with links."
			},
			Description -> "Named single test field.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		NamedMultiple -> {
			Format -> Multiple,
			Class -> {UnitColumn -> Real, SingleLink -> Link},
			Pattern :> {UnitColumn -> GreaterP[0 Nanometer], SingleLink -> _Link},
			Units -> {UnitColumn -> Nanometer, SingleLink -> None},
			Relation -> {
				UnitColumn -> Null,
				SingleLink -> Object[Example, Data][NamedSingle, MultipleLink]
			},
			Headers -> {
				UnitColumn -> "A column with units.",
				SingleLink -> "A column with links."
			},
			Description -> "Named multiple test field.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		FitFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _Function,
			Description -> "Example of an expression field.",
			Category -> "Analysis & Reports"
		},
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Active | Inactive | InUse,
			Description -> "Example of an expression field that is an enumeration of values.",
			Category -> "Experiments & Simulations"
		},
		ComputableName -> {
			Format -> Computable,
			Pattern :> _String,
			Expression :> SafeEvaluate[{Field[Name]}, StringJoin[ToString[Field[Name]], " - ", DateString[]]],
			Description -> "TestName + DateString.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		BooleanField -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "A yes or no field.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		BigData -> {
			Format -> Single,
			Class -> BigCompressed,
			Pattern :> _List,
			Description -> "A large list of data.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		BigDataQuantityArray -> {
			Format -> Single,
			Class -> BigQuantityArray,
			Pattern :> BigQuantityArrayP[{Minute, Meter Nano, AbsorbanceUnit Milli}],
			Units -> {Minute, Meter Nano, AbsorbanceUnit Milli},
			Description -> "A big QA.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		IndexedMultipleBigDataQuantityArray -> {
			Format -> Multiple,
			Class -> {Integer, BigQuantityArray},
			Pattern :> {_Integer, BigQuantityArrayP[{Minute, Meter Nano}]},
			Relation -> {Null, Null},
			Headers -> {"An integer.", "A list of data points."},
			Description -> "Indexed multiple test field which stores a BigQuantityArray.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		NamedMultipleBigDataQuantityArray -> {
			Format -> Multiple,
			Class -> {Number -> Integer, Data -> BigQuantityArray},
			Pattern :> {Number -> _Integer, Data -> BigQuantityArrayP[{Minute, Meter Nano}]},
			Relation -> {Number -> Null, Data -> Null},
			Headers -> {Number -> "An integer.", Data -> "A list of data points."},
			Description -> "Named multiple test field which stores a BigQuantityArray.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		IntegerQuantity -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> _?TimeQ,
			Units -> Second,
			Description -> "An integer number of seconds.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		CFSingle -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Single field which stores an EmeraldCloudFile.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		CFMultiple -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "MultipleAppend field which stores an EmeraldCloudFile.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},

		CFIndexedSingle -> {
			Format -> Single,
			Class -> {String, Link},
			Pattern :> {_String, _Link},
			Relation -> {Null, Object[EmeraldCloudFile]},
			Headers -> {"string", "file"},
			Description -> "IndexedSingle field which stores an EmeraldCloudFile.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		CFIndexedMultiple -> {
			Format -> Multiple,
			Class -> {String, Link},
			Pattern :> {_String, _Link},
			Relation -> {Null, Object[EmeraldCloudFile]},
			Headers -> {"string", "file"},
			Description -> "IndexedMultiple field which stores an EmeraldCloudFile.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		CFIndexing -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			Description -> "IndexedMultiple field which stores an EmeraldCloudFile.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		CFNamedSingle -> {
			Format -> Single,
			Class -> {Label -> String, File -> Link},
			Pattern :> {Label -> _String, File -> _Link},
			Relation -> {Label -> Null, File -> Object[EmeraldCloudFile]},
			Headers -> {Label -> "A file description.", File -> "A file."},
			Description -> "Named single test field which stores an EmeraldCloudFile.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		CFNamedMultiple -> {
			Format -> Multiple,
			Class -> {Label -> String, File -> Link},
			Pattern :> {Label -> _String, File -> _Link},
			Relation -> {Label -> Null, File -> Object[EmeraldCloudFile]},
			Headers -> {Label -> "A file description.", File -> "A file."},
			Description -> "Named multiple test field which stores an EmeraldCloudFile.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		OneWayLink -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Example, Analysis],
			Description -> "A link without a backlink.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		OneWayLinkTemporal -> {
			Format -> Single,
			Class -> TemporalLink,
			Pattern :> _Link,
			Relation -> Object[Example, Analysis],
			Description -> "A temporal link without a backlink.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		ForwardLink -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Example, Data][BackLink],
			Description -> "A forward link.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		BackLink -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Example, Data][ForwardLink],
			Description -> "A backlink.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		}
	}
}];
