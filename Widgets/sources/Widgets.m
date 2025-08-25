(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*Ps & Qs*)


(* ::Subsubsection::Closed:: *)
(*Private Option/Input List Patterns*)


(* A P&Q that check for the minimal set of keys necessary to build a pattern for an option packet. *)
minimalOptionPacketQ[x_List]:=MatchQ[Association@x,
	(* KeyValuePattern only requires that these keys exist inside of x. It does not require a direct match (there can be extra keys in x). *)
	KeyValuePattern[{OptionName->_,Default->_,AllowNull->_,Description->_,Widget->_}]
];
minimalOptionPacketQ[x_]:=False;

minimalOptionPacketP=_?minimalOptionPacketQ;


(* A P&Q that check for the minimal set of keys necessary to build a pattern for an input packet. *)
minimalInputPacketQ[x_List]:=MatchQ[Association@x,
	(* KeyValuePattern only requires that these keys exist inside of x. It does not require a direct match (there can be extra keys in x). *)
	KeyValuePattern[{InputName->_,Widget->_,Description->_}]
];
minimalInputPacketQ[x_]:=False;

minimalInputPacketP=_?minimalInputPacketQ;


(* ::Subsubsection::Closed:: *)
(*Private Units Widget Patterns*)


(* Pattern for an atomic unit - ex. {1,{Meter,{Meter}}} *)
atomicUnitP={_?NumberQ,{_?QuantityQ,{_?QuantityQ..}}};


(*
	Pattern for an atomic unit - ex.
	CompoundUnit[
		{1,{Meter,{Millimeter,Meter,Kilometer}}},
		{1,{Kilogram,{Kilogram,Gram}}},
		{-1,{Second,{Millisecond,Second,Minute,Hour}}}
	]

	Compound Units, Alternative Units, and Atomic Units can all be contained within CompoundUnit[...].

	This pattern is recursive so evaluation is delayed until runtime via PatternTest.
*)
compoundUnitQ[x_]:=MatchQ[x,CompoundUnit[widgetUnitsP..]];

compoundUnitP=_?compoundUnitQ;


(*
	Pattern for an alternatives unit.

	Compound Units, Alternative Units, and Atomic Units can all be contained within Alternatives[...].

	This pattern is recursive so evaluation is delayed until runtime via PatternTest.
*)
alternativesUnitQ[x_]:=MatchQ[x,Verbatim[Alternatives][widgetUnitsP..]];

alternativesUnitP=_?alternativesUnitQ;


(* Pattern for the units field in a widget. The units field can either be an alternative (of atomic and compound units), an atomic unit, or a compound unit. *)
widgetUnitsQ[x_]:=MatchQ[x,
	Alternatives[
		atomicUnitP,
		compoundUnitP,
		alternativesUnitP
	]
];

widgetUnitsP=_?widgetUnitsQ;


(* ::Subsubsection::Closed:: *)
(*Public Atomic Widget Patterns*)


(* AssociationMatchQ is necessary for all of these patterns because Mathematica's default Association matching is extremely buggy. *)

(* Valid_Widget Ps and Qs are recursive. _Widget Ps and Qs are not recursive. *)


(* ::Subsubsubsection::Closed:: *)
(*Enumeration*)


(* Does a deep check to make sure that the given enumeration widget is valid. *)
ValidEnumerationWidgetQ[x_Widget]:=With[{myAssociation=x[[1]]},
	And[
		(* Make sure that the enumeration widget matches the basic definition. *)
		Or[
			AssociationMatchQ[myAssociation,
				<|
					Type->Enumeration,
					Pattern:>_,
					Items->_List,
					PatternTooltip->_String,
					Identifier->_String
				|>
			],
			AssociationMatchQ[myAssociation,
				<|
					Type->Enumeration,
					Pattern:>_,
					Items:>_List,
					PatternTooltip->_String,
					Identifier->_String
				|>
			]
		],
		(* Make sure that Pattern (evaluated) matches _Alternatives. *)
		MatchQ[myAssociation[Pattern],_Alternatives],

		(* Make sure that the pattern is consistent with the items key. *)
		(* We need an addition DeleteDuplicates because Union[...] sometimes has bugs with quantities. *)
		SameQ[Union[DeleteDuplicates[Union[myAssociation[Items],List@@Flatten[myAssociation[Pattern]]]]],Union[myAssociation[Items]]]
	]
];

ValidEnumerationWidgetP=_?ValidEnumerationWidgetQ;

(* Does a shallow check to see if the given widget is an enumeration widget. *)
EnumerationWidgetP=Verbatim[Widget][KeyValuePattern[Type->Enumeration]];
EnumerationWidgetQ=(MatchQ[#,EnumerationWidgetP]&);


(* ::Subsubsubsection::Closed:: *)
(*Number*)


(* Does a deep check to make sure that the given number widget is valid. *)
ValidNumberWidgetQ[x_Widget]:=Module[
	{myAssociation,heldPattern,heldInequalityPattern,minimumPatternValue,maximumPatternValue,incrementPatternValue,
	minimumPatternValueHandlingInfinity,maximumPatternValueHandlingInfinity,incrementPatternValueHandlingInfinity},

	(* Extract the association from the widget. *)
	myAssociation=x[[1]];

	(* Make sure that the number widget matches the basic definition. If it doesn't return False. *)
	(* We do this imperative Return[...] such that we don't have to waste time constructing the patterns for Min, Max, and Increment. *)
	If[
		!AssociationMatchQ[myAssociation,
			<|
				Type->Number,
				Pattern:>Evaluate[InequalityP],
				Min->_?NumberQ|Null,
				Max->_?NumberQ|Null,
				Increment->_?NumberQ|Null,
				PatternTooltip->_String,
				Identifier->_String
			|>
		],
		Return[False];
	];

	(* Check that the values inside of the widget are consistent with each other. *)

	(* Extract the pattern from the association and hold it. *)
	heldPattern=Extract[myAssociation,Key[Pattern],Hold];

	(* Now we will check that the values of Min, Max, and Increment match the pattern. *)

	(* The held pattern is the inequality is simply the held pattern *)
	heldInequalityPattern=heldPattern;

	(* Extract the minimum value from the pattern. *)
	minimumPatternValue=Switch[heldInequalityPattern,
		(* RangeP[minimum,maximum] *)
		Hold[_RangeP],
			Extract[heldInequalityPattern,{1,1}],

		(* GreaterP[minimum] and GreaterEqualP[minimum] *)
		Hold[_GreaterP]|Hold[_GreaterEqualP],
			Extract[heldInequalityPattern,{1,1}],

		(* LessP[maximum] and LessEqualP[maximum] *)
		Hold[_LessP]|Hold[_LessEqualP],
			Null,

		(* Catch All, we should never get here *)
		_,
			Null
	];

	(* Make sure that if our minimum is set to Inifinity, we set it to Null. *)
	minimumPatternValueHandlingInfinity=If[MatchQ[minimumPatternValue,\[Infinity]|-\[Infinity]],
		Null,
		minimumPatternValue
	];

	(* Extract the maximum value from the pattern. *)
	maximumPatternValue=Switch[heldInequalityPattern,
		(* RangeP[minimum,maximum] *)
		Hold[_RangeP],
			Extract[heldInequalityPattern,{1,2}],

		(* GreaterP[minimum] and GreaterEqualP[minimum] *)
		Hold[_GreaterP]|Hold[_GreaterEqualP],
			Null,

		(* LessP[maximum] and LessEqualP[maximum] *)
		Hold[_LessP]|Hold[_LessEqualP],
			Extract[heldInequalityPattern,{1,1}],

		(* Catch All, we should never get here *)
		_,
			Null
	];

	(* Make sure that if our minimum is set to Inifinity, we set it to Null. *)
	maximumPatternValueHandlingInfinity=If[MatchQ[maximumPatternValue,\[Infinity]|-\[Infinity]],
		Null,
		maximumPatternValue
	];

	(* Extract the increment value from the pattern. *)
	incrementPatternValue=Switch[heldInequalityPattern,
		(* RangeP[minimum,maximum,increment] *)
		Hold[RangeP[_,_,_]]|Hold[RangeP[_,_,_,Inclusive->_]],
			Extract[heldInequalityPattern,{1,3}],

		(* GreaterP[minimum,increment] and GreaterEqualP[minimum,increment] *)
		Hold[GreaterP[_,_]]|Hold[GreaterP[_,_,Inclusive->_]]|Hold[GreaterEqualP[_,_]]|Hold[GreaterEqualP[_,_,Inclusive->_]],
			Extract[heldInequalityPattern,{1,2}],

		(* LessP[maximum,increment] and LessEqualP[maximum,increment] *)
		Hold[LessP[_,_]]|Hold[LessP[_,_,Inclusive->_]]|Hold[LessEqualP[_,_]]|Hold[LessEqualP[_,_,Inclusive->_]],
			Extract[heldInequalityPattern,{1,2}],

		(* Otherwise, the increment value isn't provided. *)
		_,
			Null
	];

	(* Make sure that if our minimum is set to Inifinity, we set it to Null. *)
	incrementPatternValueHandlingInfinity=If[MatchQ[incrementPatternValue,\[Infinity]|-\[Infinity]],
		Null,
		incrementPatternValue
	];

	(* Check that Min, Max, and Increment match their constructed patterns. *)
	And[
		(* Make sure that Min matches the minimum value specified in the pattern. *)
		MatchQ[myAssociation[Min],minimumPatternValueHandlingInfinity],

		(* Make sure that Max matches the maximum value specified in the pattern. *)
		MatchQ[myAssociation[Max],maximumPatternValueHandlingInfinity],

		(* Make sure that Increment matches the increment value specified in the pattern. *)
		MatchQ[myAssociation[Increment],incrementPatternValueHandlingInfinity]
	]
];

ValidNumberWidgetP=_?ValidNumberWidgetQ;

(* Does a shallow check to see if the given widget is an number widget. *)
NumberWidgetP=Verbatim[Widget][KeyValuePattern[Type->Number]];
NumberWidgetQ=(MatchQ[#,NumberWidgetP]&);


(* ::Subsubsubsection::Closed:: *)
(*Quantity*)


(* Does a deep check to make sure that the given quantity widget is valid. *)
ValidQuantityWidgetQ[x_Widget]:=Module[
	{myAssociation,heldPattern,heldInequalityPatterns,minimumPatternValues,maximumPatternValues,incrementPatternValues,unitPattern,
	minimumPatternValuesHandlingInfinity,maximumPatternValuesHandlingInfinity,incrementPatternValuesHandlingInfinity,
	uniqueUnitDimensionsFromUnits,unitsFromPattern,uniqueUnitDimensionsFromPattern},

	(* Extract the association from the widget. *)
	myAssociation=x[[1]];

	(* Make sure that the quantity widget matches the basic definition. If it doesn't return False. *)
	(* We do this imperative Return[...] such that we don't have to waste time constructing the patterns for Min, Max, and Increment. *)
	If[
		!AssociationMatchQ[myAssociation,
			<|
				Type->Quantity,
				Pattern:>_,
				Min->_?QuantityQ|Null,
				Max->_?QuantityQ|Null,
				Increment->_?QuantityQ|Null,
				PatternTooltip->_String,
				Units->widgetUnitsP,
				Identifier->_String
			|>
		],
		Return[False];
	];

	(* Make sure that the pattern matches InequalityP or Alternatives. AssociationMatchQ has trouble with matching on Alternatives. *)
	If[!MatchQ[Extract[myAssociation,Key[Pattern],Hold],Hold[Evaluate[InequalityP]]|Hold[_Alternatives]],
		Return[False];
	];

	(* Check that the values inside of the widget are consistent with each other. *)

	(* Extract the pattern from the association and hold it. *)
	heldPattern=Extract[myAssociation,Key[Pattern],Hold];

	(* Now we will check that the values of Min, Max, and Increment match the pattern. *)

	(* Pull the inequality patterns out of the held pattern. *)
	heldInequalityPatterns=If[MatchQ[heldPattern,Hold[_Alternatives]],
		With[{insertMe=heldPattern},holdCompositionSingleton[insertMe]],
		ToList[heldPattern]
	];

	(* Extract the minimum value from the pattern. *)
	minimumPatternValues=Map[Function[{heldInequalityPattern},
		Switch[heldInequalityPattern,
			(* RangeP[minimum,maximum] *)
			Hold[_RangeP],
				Extract[heldInequalityPattern,{1,1}],

			(* GreaterP[minimum] and GreaterEqualP[minimum] *)
			Hold[_GreaterP]|Hold[_GreaterEqualP],
				Extract[heldInequalityPattern,{1,1}],

			(* LessP[maximum] and LessEqualP[maximum] *)
			Hold[_LessP]|Hold[_LessEqualP],
				Null,

			(* Catch All, we should never get here *)
			_,
				Message[Widget::QuantityMinValue]; Return[$Failed];
		]],
		heldInequalityPatterns
	];

	(* Make sure that if our minimum is set to Inifinity, we set it to Null. *)
	minimumPatternValuesHandlingInfinity=minimumPatternValues/.{Infinity|-Infinity->Null};

	(* Extract the maximum value from the pattern. *)
	maximumPatternValues=Map[Function[{heldInequalityPattern},
		Switch[heldInequalityPattern,
			(* RangeP[minimum,maximum] *)
			Hold[_RangeP],
				Extract[heldInequalityPattern,{1,2}],

			(* GreaterP[minimum] and GreaterEqualP[minimum] *)
			Hold[_GreaterP]|Hold[_GreaterEqualP],
				Null,

			(* LessP[maximum] and LessEqualP[maximum] *)
			Hold[_LessP]|Hold[_LessEqualP],
				Extract[heldInequalityPattern,{1,1}],

			(* Catch All, we should never get here *)
			_,
				Message[Widget::QuantityMaxValue]; Return[$Failed];
		]],
		heldInequalityPatterns
	];

	(* Make sure that if our minimum is set to Inifinity, we set it to Null. *)
	maximumPatternValuesHandlingInfinity=maximumPatternValues/.{Infinity|-Infinity->Null};

	(* Extract the increment value from the pattern. *)
	incrementPatternValues=Map[Function[{heldInequalityPattern},
		Switch[heldInequalityPattern,
			(* RangeP[minimum,maximum,increment] *)
			Hold[RangeP[_,_,_]]|Hold[RangeP[_,_,_,Inclusive->_]],
				Extract[heldInequalityPattern,{1,3}],

			(* GreaterP[minimum,increment] and GreaterEqualP[minimum,increment] *)
			Hold[GreaterP[_,_]]|Hold[GreaterP[_,_,Inclusive->_]]|Hold[GreaterEqualP[_,_]]|Hold[GreaterEqualP[_,_,Inclusive->_]],
				Extract[heldInequalityPattern,{1,2}],

			(* LessP[maximum,increment] and LessEqualP[maximum,increment] *)
			Hold[LessP[_,_]]|Hold[LessP[_,_,Inclusive->_]]|Hold[LessEqualP[_,_]]|Hold[LessEqualP[_,_,Inclusive->_]],
				Extract[heldInequalityPattern,{1,2}],

			(* Otherwise, the increment value isn't provided. *)
			_,
				Null
		]],
		heldInequalityPatterns
	];

	(* Make sure that if our minimum is set to Inifinity, we set it to Null. *)
	incrementPatternValuesHandlingInfinity=incrementPatternValues/.{Infinity|-Infinity->Null};

	(* Construct a pattern for this Quantity widget's units. This GenerateInputPattern call is recursive. The Pattern that is returned is Held. *)
	unitPattern=GenerateInputPattern[myAssociation[Units]];

	(* Get all of the unique unit dimensions from our Units key. unitPattern does the unique unit dimension filtering for us already. *)
	uniqueUnitDimensionsFromUnits=UnitDimensions/@Cases[unitPattern,_Quantity,Infinity];

	(* Extract all of the units from our Pattern key. *)
	unitsFromPattern=Cases[ReleaseHold[heldPattern],_Quantity,Infinity];

	(* Get all of the unique unit dimensions from our Pattern key. *)
	uniqueUnitDimensionsFromPattern=Keys[GroupBy[unitsFromPattern,UnitDimensions]];

	(* Check that all of our constructed patterns match their keys. *)
	And[
		(* Check for $Failed when building the pattern of the units. *)
		!SameQ[unitPattern,$Failed],

		(* Make sure that Min matches the minimum value specified in the pattern. *)
		MatchQ[myAssociation[Min],Alternatives@@minimumPatternValuesHandlingInfinity],

		(* Make sure that Max matches the maximum value specified in the pattern. *)
		MatchQ[myAssociation[Max],Alternatives@@maximumPatternValuesHandlingInfinity],

		(* Make sure that Increment matches the increment value specified in the pattern. *)
		MatchQ[myAssociation[Increment],Alternatives@@incrementPatternValuesHandlingInfinity],

		(* Check that all of Min, Max, and Increment all match the pattern of our specified units. *)
		Or@@(MatchQ[#,Null|ReleaseHold[unitPattern]]&)/@minimumPatternValuesHandlingInfinity,
		Or@@(MatchQ[#,Null|ReleaseHold[unitPattern]]&)/@maximumPatternValuesHandlingInfinity,
		Or@@(MatchQ[#,Null|ReleaseHold[unitPattern]]&)/@incrementPatternValuesHandlingInfinity,

		(* Make sure that all of our units are accounted for in our pattern (in terms of unit dimensions). *)
		ContainsExactly[uniqueUnitDimensionsFromUnits,uniqueUnitDimensionsFromPattern]
	]
];

ValidQuantityWidgetP=_?ValidQuantityWidgetQ;

(* Does a shallow check to see if the given widget is an quantity widget. *)
QuantityWidgetP=Verbatim[Widget][KeyValuePattern[Type->Quantity]];
QuantityWidgetQ=(MatchQ[#,QuantityWidgetP]&);

(* ::Subsubsubsection::Closed:: *)
(*Molecule*)

(* Does a deep check to make sure that the given molecule widget is valid. *)
ValidMoleculeWidgetQ[x_Widget]:=AssociationMatchQ[x[[1]],
	<|
		Type->Molecule,
		Pattern:>Verbatim[MoleculeP],
		PatternTooltip->_String,
		Identifier->_String
	|>
];

ValidMoleculeWidgetP=_?ValidMoleculeWidgetQ;

(* Does a shallow check to see if the given widget is a color widget. *)
MoleculeWidgetP=Verbatim[Widget][KeyValuePattern[Type->Molecule]];
MoleculeWidgetQ=(MatchQ[#,MoleculeWidgetP]&);


(* ::Subsubsubsection::Closed:: *)
(*Color*)


(* Does a deep check to make sure that the given color widget is valid. *)
ValidColorWidgetQ[x_Widget]:=AssociationMatchQ[x[[1]],
	<|
		Type->Color,
		Pattern:>Verbatim[ColorP],
		PatternTooltip->_String,
		Identifier->_String
	|>
];

ValidColorWidgetP=_?ValidColorWidgetQ;

(* Does a shallow check to see if the given widget is a color widget. *)
ColorWidgetP=Verbatim[Widget][KeyValuePattern[Type->Color]];
ColorWidgetQ=(MatchQ[#,ColorWidgetP]&);


(* ::Subsubsubsection::Closed:: *)
(*Date*)


(* Does a deep check to make sure that the given date widget is valid. *)
ValidDateWidgetQ[x_Widget]:=Module[
	{myAssociation,heldPattern,minimumPatternValue,maximumPatternValue,incrementPatternValue},

	(* Extract the association from the widget. *)
	myAssociation=x[[1]];

	(* Make sure that the Date widget matches the general pattern first before doing deeper checks. *)
	If[!AssociationMatchQ[myAssociation,
			<|
				Type->Date,
				Pattern:>_,
				TimeSelector->BooleanP,
				Min->_?DateObjectQ|Null,
				Max->_?DateObjectQ|Null,
				Increment->_Quantity|Null,
				PatternTooltip->_String,
				Identifier->_String
			|>
		],
		Return[False];
	];

	(* Extract the pattern from the association and hold it. *)
	heldPattern=Extract[myAssociation,Key[Pattern],Hold];

	(* Make sure that the pattern is specified correctly before continuing. *)
	If[!MatchQ[heldPattern,Hold[Evaluate[InequalityP]]|Hold[Verbatim[_?DateObjectQ]]],
		Message[Widget::DatePatternValue];
		Return[False];
	];

	(* Make sure that the InequalityP pattern no longer matches the InequalityP heads once evaluated. If it still does, this means the pattern is failing to evaluate and something is wrong. *)
	If[MatchQ[heldPattern,Hold[Evaluate[InequalityP]]]&&MatchQ[ReleaseHold[heldPattern],InequalityP],
		Message[Widget::DateInequalityPatternValue];
		Return[False];
	];

	(* Make sure that the Min, Max, and Increment values are consistent with the pattern. *)

	(* Extract the minimum value from the pattern. *)
	minimumPatternValue=Switch[heldPattern,
		(* _?DateObjectQ *)
		Hold[Verbatim[_?DateObjectQ]],
			Null,

		(* RangeP[minimum,maximum] *)
		Hold[_RangeP],
			Extract[heldPattern,{1,1}],

		(* GreaterP[minimum] and GreaterEqualP[minimum] *)
		Hold[_GreaterP]|Hold[_GreaterEqualP],
			Extract[heldPattern,{1,1}],

		(* LessP[maximum] and LessEqualP[maximum] *)
		Hold[_LessP]|Hold[_LessEqualP],
			Null,

		(* Catch All, we should never get here *)
		_,
			With[{insertMe=heldPattern},Message[Widget::DateMinValue,ToString[HoldForm[insertMe]]]]; Return[$Failed];
	];

	(* Extract the maximum value from the pattern. *)
	maximumPatternValue=Switch[heldPattern,
		(* _?DateObjectQ *)
		Hold[Verbatim[_?DateObjectQ]],
			Null,

		(* RangeP[minimum,maximum] *)
		Hold[_RangeP],
			Extract[heldPattern,{1,2}],

		(* GreaterP[minimum] and GreaterEqualP[minimum] *)
		Hold[_GreaterP]|Hold[_GreaterEqualP],
			Null,

		(* LessP[maximum] and LessEqualP[maximum] *)
		Hold[_LessP]|Hold[_LessEqualP],
			Extract[heldPattern,{1,1}],

		(* Catch All, we should never get here *)
		_,
			With[{insertMe=heldPattern},Message[Widget::DateMaxValue,ToString[HoldForm[insertMe]]]]; Return[$Failed];
	];

	(* Extract the increment value from the pattern. *)
	incrementPatternValue=Switch[heldPattern,
		(* _?DateObjectQ *)
		Hold[Verbatim[_?DateObjectQ]],
			Null,

		(* RangeP[minimum,maximum,increment] *)
		Hold[RangeP[_,_,_]]|Hold[RangeP[_,_,_,Inclusive->_]],
			Extract[heldPattern,{1,3}],

		(* GreaterP[minimum,increment] and GreaterEqualP[minimum,increment] *)
		Hold[GreaterP[_,_]]|Hold[GreaterP[_,_,Inclusive->_]]|Hold[GreaterEqualP[_,_]]|Hold[GreaterEqualP[_,_,Inclusive->_]],
			Extract[heldPattern,{1,2}],

		(* LessP[maximum,increment] and LessEqualP[maximum,increment] *)
		Hold[LessP[_,_]]|Hold[LessP[_,_,Inclusive->_]]|Hold[LessEqualP[_,_]]|Hold[LessEqualP[_,_,Inclusive->_]],
			Extract[heldPattern,{1,2}],

		(* Otherwise, the increment value isn't provided. *)
		_,
			Null
	];

	(* Make sure that the Min, Max, and Increment values from the Pattern match the keys. *)
	And[
		(* Make sure that Min matches the minimum value specified in the pattern. *)
		MatchQ[myAssociation[Min],minimumPatternValue],

		(* Make sure that Max matches the maximum value specified in the pattern. *)
		MatchQ[myAssociation[Max],maximumPatternValue],

		(* Make sure that Increment matches the increment value specified in the pattern. *)
		MatchQ[myAssociation[Increment],incrementPatternValue]
	]
];

ValidDateWidgetP=_?ValidDateWidgetQ;

(* Does a shallow check to see if the given widget is an date widget. *)
DateWidgetP=Verbatim[Widget][KeyValuePattern[Type->Date]];
DateWidgetQ=(MatchQ[#,DateWidgetP]&);


(* ::Subsubsubsection::Closed:: *)
(*String*)


(* Does a deep check to make sure that the given string widget is valid. *)
ValidStringWidgetQ[x_Widget]:=AssociationMatchQ[x[[1]],
	<|
		Type->String,
		Pattern:>_,
		Size->TextBoxSizeP,
		PatternTooltip->_String,
		BoxText->_String|Null,
		Identifier->_String
	|>
];

ValidStringWidgetP=_?ValidStringWidgetQ;

(* Does a shallow check to see if the given widget is an string widget. *)
StringWidgetP=Verbatim[Widget][KeyValuePattern[Type->String]];
StringWidgetQ=(MatchQ[#,StringWidgetP]&);


(* ::Subsubsubsection::Closed:: *)
(*Object*)


(* Does a deep check to make sure that the given object widget is valid. *)
ValidObjectWidgetQ[x_Widget]:=AssociationMatchQ[x[[1]],
	<|
		Type->Object,
		Pattern:>Alternatives[
			(* Regular ObjectP definitions *)
			_ObjectP,
			Verbatim[ListableP][_ObjectP],

			(* SamplePreparation definitions *)
			Verbatim[Alternatives][Verbatim[ObjectP][_],Verbatim[_String]],
			Verbatim[ListableP][Verbatim[Alternatives][Verbatim[ObjectP][_],Verbatim[_String]]]
		],
		ObjectTypes->{TypeP[]...},
		ObjectBuilderFunctions->{_Symbol...},
		Dereference->{(_Object|_Model->_Field)...},
		OpenPaths->{{(ObjectP[Object[Catalog]]|_String)..}...},
		Select->_,
		PatternTooltip->_String,
		Identifier->_String,
		PreparedSample->BooleanP,
		PreparedContainer->BooleanP
	|>
];

ValidObjectWidgetP=_?ValidObjectWidgetQ;

(* Does a shallow check to see if the given widget is an object widget. *)
ObjectWidgetP=Verbatim[Widget][KeyValuePattern[Type->Object]];
ObjectWidgetQ=(MatchQ[#,ObjectWidgetP]&);


(* ::Subsubsubsection::Closed:: *)
(*Field Reference*)


(* Does a deep check to make sure that the given field reference widget is valid. *)
ValidFieldReferenceWidgetQ[x_Widget]:=And[
	AssociationMatchQ[x[[1]],
		<|
			Type->FieldReference,
			Pattern:>_FieldReferenceP,
			ObjectTypes->{TypeP[]..},
			ObjectBuilderFunctions->{_Symbol...},
			Fields->_List,
			PatternTooltip->_String,
			Identifier->_String
		|>
	],
	(* Make sure that the provided fields are valid. *)
	(* This is much faster than doing {FieldP[]..} *)
	ContainsAll[Fields[Output->Short],x[Fields]]
];

ValidFieldReferenceWidgetP=_?ValidFieldReferenceWidgetQ;

(* Does a shallow check to see if the given widget is an field reference widget. *)
FieldReferenceWidgetP=Verbatim[Widget][KeyValuePattern[Type->FieldReference]];
FieldReferenceWidgetQ=(MatchQ[#,FieldReferenceWidgetP]&);


(* ::Subsubsubsection::Closed:: *)
(*Primitive*)


(* Does a deep check to make sure that the given primitive widget is valid. *)
ValidPrimitiveWidgetQ[x_Widget]:=AssociationMatchQ[x[[1]],
	<|
		Type->Primitive,
		Pattern:>_,
		PrimitiveTypes->{_Symbol..},

		(* NOTE: PrimitiveKeyValuePairs is deprecated. *)
		PrimitiveKeyValuePairs -> {(_Symbol->{((_Symbol|Verbatim[Optional][_Symbol])->ValidWidgetP)..})...}|Null,

		PatternTooltip->_String,
		Identifier->_String
	|>
];

ValidPrimitiveWidgetP=_?ValidPrimitiveWidgetQ;

(* Does a shallow check to see if the given widget is an primitive widget. *)
PrimitiveWidgetP=Verbatim[Widget][KeyValuePattern[Type->Primitive]];
PrimitiveWidgetQ=(MatchQ[#,PrimitiveWidgetP]&);


(* ::Subsubsubsection::Closed:: *)
(*MultiSelect*)


(* Does a deep check to make sure that the given multi select widget is valid. *)
ValidMultiSelectWidgetQ[x_Widget]:=With[{myAssociation=x[[1]]},
	And[
		AssociationMatchQ[myAssociation,
			<|
				Type->MultiSelect,
				Pattern:>DuplicateFreeListableP[_Alternatives],
				Items->_List,
				PatternTooltip->_String,
				Identifier->_String
			|>
		],
		MatchQ[myAssociation[Pattern],Verbatim[Evaluate[DuplicateFreeListableP[Alternatives@@myAssociation[Items]]]]]
	]
];

ValidMultiSelectWidgetP=_?ValidMultiSelectWidgetQ;

(* Does a shallow check to see if the given widget is an multiselect widget. *)
MultiSelectWidgetP=Verbatim[Widget][KeyValuePattern[Type->MultiSelect]];
MultiSelectWidgetQ=(MatchQ[#,MultiSelectWidgetP]&);


(* ::Subsubsubsection::Closed:: *)
(*Expression*)


(* Does a deep check to make sure that the given expression widget is valid. *)
ValidExpressionWidgetQ[x_Widget]:=AssociationMatchQ[x[[1]],
	<|
		Type->Expression,
		Pattern:>_,
		Size->TextBoxSizeP,
		BoxText->_String|Null,
		PatternTooltip->_String,
		Identifier->_String
	|>
];

ValidExpressionWidgetP=_?ValidExpressionWidgetQ;

(* Does a shallow check to make sure that the given widget is an expression widget. *)
ExpressionWidgetP=Verbatim[Widget][KeyValuePattern[Type->Expression]];
ExpressionWidgetQ=(MatchQ[#,ExpressionWidgetP]&);

(* ::Subsubsubsection::Closed:: *)
(*UnitOperation*)

(* Does a deep check to make sure that the given unit operation widget is valid. *)
ValidUnitOperationWidgetQ[x_Widget]:=AssociationMatchQ[x[[1]],
	<|
		Type->UnitOperation,
		Pattern:>_,
		PatternTooltip->_String,
		Identifier->_String
	|>
];

ValidUnitOperationWidgetP=_?ValidUnitOperationWidgetQ;

(* Does a shallow check to make sure that the given widget is a unit operation widget. *)
UnitOperationWidgetP=Verbatim[Widget][KeyValuePattern[Type->UnitOperation]];
UnitOperationWidgetQ=(MatchQ[#,UnitOperationWidgetP]&);

(* ::Subsubsubsection::Closed:: *)
(*Head*)

(* Does a deep check to make sure that the given unit operation widget is valid. *)
ValidHeadWidgetQ[x_Widget]:=AssociationMatchQ[x[[1]],
	<|
		Type->Head,
		Head->_Symbol,
		Widget->ValidWidgetP,
		Pattern:>_,
		PatternTooltip->_String,
		Identifier->_String
	|>
];

ValidHeadWidgetP=_?ValidHeadWidgetQ;

(* Does a shallow check to make sure that the given unit operation widget is valid. *)
HeadWidgetP=Verbatim[Widget][KeyValuePattern[Type->Head]];
HeadWidgetQ=(MatchQ[#,HeadWidgetP]&);


(* ::Subsubsection::Closed:: *)
(*Public Widget Collection Patterns*)


(* ::Subsubsubsection::Closed:: *)
(*Atomic Widgets*)


(* Private pattern for an atomic widget. *)
ValidAtomicWidgetP=Alternatives[
	ValidEnumerationWidgetP,
	ValidNumberWidgetP,
	ValidQuantityWidgetP,
	ValidColorWidgetP,
	ValidDateWidgetP,
	ValidStringWidgetP,
	ValidObjectWidgetP,
	ValidFieldReferenceWidgetP,
	ValidPrimitiveWidgetP,
	ValidUnitOperationWidgetP,
	ValidMultiSelectWidgetP,
	ValidExpressionWidgetP,
	ValidMoleculeWidgetP,
	ValidHeadWidgetP
];

ValidAtomicWidgetQ=(MatchQ[#,ValidAtomicWidgetP]&);

AtomicWidgetP=Alternatives[
	EnumerationWidgetP,
	NumberWidgetP,
	QuantityWidgetP,
	ColorWidgetP,
	DateWidgetP,
	StringWidgetP,
	ObjectWidgetP,
	FieldReferenceWidgetP,
	PrimitiveWidgetP,
	UnitOperationWidgetP,
	MultiSelectWidgetP,
	ExpressionWidgetP,
	MoleculeWidgetP,
	HeadWidgetP
];

AtomicWidgetQ=(MatchQ[#,AtomicWidgetP]&);


(* ::Subsubsubsection::Closed:: *)
(*Adder*)


(* Private question for an adder widget. *)
ValidAdderWidgetQ[x_]:=MatchQ[x,
	Adder[
		ValidWidgetP,
		Orientation->OrientationP
	]
];

ValidAdderWidgetP=_?ValidAdderWidgetQ;

AdderWidgetP=_Adder;
AdderWidgetQ=(MatchQ[#,AdderWidgetP]&);


(* ::Subsubsubsection::Closed:: *)
(*Alternatives*)


(* Private question for an alternatives of widgets. *)
ValidAlternativesWidgetQ[x_]:=MatchQ[x,
	Verbatim[Alternatives][
		Alternatives[
			_String->ValidWidgetP,
			ValidWidgetP
		]..
	]
];

(* Private pattern for an alternatives of widgets. This pattern is recursive so evaluation is delayed until runtime. *)
ValidAlternativesWidgetP=_?ValidAlternativesWidgetQ;

(* Here we have to be recursive because we don't want to match on any Alternatives[...]. *)
AlternativesWidgetQ[x_]:=MatchQ[x,
	AlternativesWidgetP
];
AlternativesWidgetP=Verbatim[Alternatives][
	Alternatives[
		_String->_,
		_
	]..
];


(* ::Subsubsubsection::Closed:: *)
(*List*)


(* Private question for a list of widgets. *)
ValidListWidgetQ[x_]:=MatchQ[x,
	{
		Rule[_String, ValidWidgetP]..
	}
];

ValidListWidgetP=_?ValidListWidgetQ;

ListWidgetQ[x_]:=MatchQ[x,
	ListWidgetP
];
ListWidgetP={
	Rule[_String, _]..
};


(* ::Subsubsubsection::Closed:: *)
(*Span*)


(* Private question for a span of widgets. *)
ValidSpanWidgetQ[x_]:=MatchQ[x,
	Span[
		ValidNumberWidgetP|ValidQuantityWidgetP|ValidDateWidgetP,
		ValidNumberWidgetP|ValidQuantityWidgetP|ValidDateWidgetP
	]
];

ValidSpanWidgetP=_?ValidSpanWidgetQ;

(* We have to be recursive here because we don't want to match on any Span[..]. *)
SpanWidgetQ[x_]:=MatchQ[x,
	SpanWidgetP
];
SpanWidgetP=Span[
	NumberWidgetP|QuantityWidgetP|DateWidgetP,
	NumberWidgetP|QuantityWidgetP|DateWidgetP
];

(* ::Subsubsubsection::Closed:: *)
(*UnitOperationMethod*)

(* Does a deep check to make sure that the given expression widget is valid. *)
ValidUnitOperationMethodWidgetQ[x_Widget]:=AssociationMatchQ[x[[1]],
	<|
		Type->UnitOperationMethod,
		Pattern:>_,
		Methods->{_Symbol..},
		Widget->WidgetP,
		PatternTooltip->_String,
		Identifier->_String
	|>
];

ValidUnitOperationMethodWidgetP=_?ValidUnitOperationMethodWidgetQ;

(* Does a shallow check to make sure that the given widget is an expression widget. *)
UnitOperationMethodWidgetP=Verbatim[Widget][KeyValuePattern[Type->UnitOperationMethod]];
UnitOperationMethodWidgetQ=(MatchQ[#,UnitOperationMethodWidgetP]&);


(* ::Subsubsubsection::Closed:: *)
(*Widget*)


(* Public question that matches on an atomic widget, adder widget, alternatives of widgets, or list of widgets. *)
ValidWidgetQ[myWidget_]:=MatchQ[myWidget,
	Alternatives[
		ValidAtomicWidgetP,
		ValidAdderWidgetP,
		ValidAlternativesWidgetP,
		ValidListWidgetP,
		ValidSpanWidgetP,
		ValidUnitOperationMethodWidgetP
	]
];


(* Public pattern that matches on an atomic widget, adder widget, alternatives of widgets, or list of widgets. This pattern is recursive. *)
ValidWidgetP=_?ValidWidgetQ;


(* Alternatives, List, and SpanWidgetP are recursive so we have to SetDelay here. *)
WidgetQ[myWidget_]:=MatchQ[myWidget,
	Alternatives[
		AtomicWidgetP,
		AdderWidgetP,
		AlternativesWidgetP,
		ListWidgetP,
		SpanWidgetP,
		UnitOperationMethodWidgetP
	]
];


WidgetP=Alternatives[
	AtomicWidgetP,
	AdderWidgetP,
	AlternativesWidgetP,
	ListWidgetP,
	SpanWidgetP,
	UnitOperationMethodWidgetP
];


(* Public pattern that represents the allowed types of widgets. *)
WidgetTypeP=Alternatives[
	Enumeration,
	Number,
	Quantity,
	Color,
	Date,
	String,
	Object,
	FieldReference,
	Primitive,
	MultiSelect,
	Expression,
	Adder,
	List,
	Molecule,
	UnitOperation,
	UnitOperationMethod,
	Head
];


WidgetTypeQ[x_]:=MatchQ[x,WidgetTypeP];


(* ::Subsection:: *)
(*Short Hand Functions*)


(* ::Subsubsection::Closed:: *)
(*Private Helper Functions*)


(* ::Subsubsubsection::Closed:: *)
(*addPatternTooltip*)


(* ::Subsubsubsubsection::Closed:: *)
(*addPatternTooltip Helper Functions*)


listToText[myList_List]:=Module[{distributedHeldListWithFormatting,patternToolTip},
	(* Depending on the length of the list, format the result differently. *)
	distributedHeldListWithFormatting=Switch[Length[myList],
		(* If there is only one element in the list, there is no formatting to do. *)
		1,
			myList,
		(* If there are two elements in the list, add an "or" between them. *)
		2,
			Insert[myList," or ",-2],
		_,
		(* Otherwise, there are more than 2 elements. Riffle in commas and then add "or" before the last element. *)
			Insert[Riffle[myList,", "],"or ",-2]
	];

	(* The generated pattern tool tip is the HoldForm of all of our elements in the list in combination of them being string joined. *)
	patternToolTip=StringJoin[
		(
			If[MatchQ[#,_Hold],
				ToString[Extract[#,{1},HoldForm]],
				ToString[#]
			]
		&)/@distributedHeldListWithFormatting
	]
];


(* ::Subsubsubsubsection::Closed:: *)
(*Number*)


(* Helper function that generates a PatternTooltip for a Number widget. *)
(* Takes in the keys of a Number widget and returns the PatternToolTip string. *)
addPatternTooltip[myAssociation_Association,Number]:=Module[
	{heldPattern,patternToolTip,myMinimum,myMaximum,myIncrement},

	(* Extract the pattern from the association and hold it. *)
	heldPattern=Extract[myAssociation,Key[Pattern],Hold];

	(* Extract the Minimum, Maximum, and Increment values from our association. *)
	(* If they are set to Null, swap out a value that will look better in the PatternTooltip. *)
	myMinimum=If[SameQ[myAssociation[Min],Null],
		ToString[-Infinity],
		ToString[myAssociation[Min]]
	];

	myMaximum=If[SameQ[myAssociation[Max],Null],
		ToString[Infinity],
		ToString[myAssociation[Max]]
	];

	myIncrement=If[SameQ[myAssociation[Increment],Null],
		ToString[None],
		ToString[myAssociation[Increment]]
	];

	(* Generate a PatternTooltip string from the widget's Pattern. *)
	patternToolTip=Switch[heldPattern,
		(* RangeP[Min, Max, Increment], by default is include on both sides *)
		Hold[RangeP[_,_,_]]|Hold[RangeP[_,_,_,Inclusive->All]],
			"Number must be greater than or equal to " <> myMinimum <> " and less than or equal to " <> myMaximum <> " in increments of " <> myIncrement <> ".",

		(* RangeP[Min, Max, Increment, Inclusive\[Rule]Left] *)
		Hold[RangeP[_,_,_,Inclusive->Left]],
			"Number must be greater than or equal to " <> myMinimum <> " and less than " <> myMaximum <> " in increments of " <> myIncrement <> ".",

		(* RangeP[Min, Max, Increment, Inclusive\[Rule]Right] *)
		Hold[RangeP[_,_,_,Inclusive->Right]],
			"Number must be greater than " <> myMinimum <> " and less than or equal to " <> myMaximum <> " in increments of " <> myIncrement <> ".",

		(* RangeP[Min, Max, Increment, Inclusive\[Rule]None] *)
		Hold[RangeP[_,_,_,Inclusive->None]],
			"Number must be greater than " <> myMinimum <> " and less than " <> myMaximum <> " in increments of " <> myIncrement <> ".",

		(* RangeP[Min, Max], by default is include on both sides *)
		Hold[RangeP[_,_]]|Hold[RangeP[_,_,Inclusive->All]],
			"Number must be greater than or equal to " <> myMinimum <> " and less than or equal to " <> myMaximum <> ".",

		(* RangeP[Min, Max, Inclusive\[Rule]Left] *)
		Hold[RangeP[_,_,Inclusive->Left]],
			"Number must be greater than or equal to " <> myMinimum <> " and less than " <> myMaximum <> ".",

		(* RangeP[Min, Max, Inclusive\[Rule]Right] *)
		Hold[RangeP[_,_,Inclusive->Right]],
			"Number must be greater than " <> myMinimum <> " and less than or equal to " <> myMaximum <> ".",

		(* RangeP[Min, Max, Inclusive\[Rule]None] *)
		Hold[RangeP[_,_,Inclusive->None]],
			"Number must be greater than " <> myMinimum <> " and less than " <> myMaximum <> ".",

		(* GreaterP[value] *)
		Hold[GreaterP[_]],
			"Number must be greater than " <> myMinimum <> ".",

		(* GreaterP[value,increment] *)
		Hold[GreaterP[_,_]],
			"Number must be greater than " <> myMinimum <> " in increments of " <> myIncrement <> ".",

		(* GreaterEqualP[value] *)
		Hold[GreaterEqualP[_]],
			"Number must be greater than or equal to " <> myMinimum <> ".",

		(* GreaterEqualP[value,increment] *)
		Hold[GreaterEqualP[_,_]],
			"Number must be greater than or equal to " <> myMinimum <> " in increments of " <> myIncrement <> ".",

		(* LessP[value] *)
		Hold[LessP[_]],
			"Number must be less than " <> myMaximum <> ".",

		(* LessP[value,increment] *)
		Hold[LessP[_,_]],
			"Number must be less than " <> myMaximum <> " in increments of " <> myIncrement <> ".",

		(* LessEqualP[value] *)
		Hold[LessEqualP[_]],
			"Number must be less than or equal to " <> myMaximum <> ".",

		(* LessEqualP[value,increment] *)
		Hold[LessEqualP[_,_]],
			"Number must be less than or equal to " <> myMaximum <> " in increments of " <> myIncrement <> ".",

		(* If we don't have a matching template, simply convert the pattern into a string, verbatim. *)
		_,
			ToString[Extract[heldPattern,{1},HoldForm]]
	];

	(* Return our association with the new PatternTooltip key. *)
	patternToolTip
];


(* ::Subsubsubsubsection::Closed:: *)
(*Quantity*)


(* Helper function that generates a PatternTooltip for a Quantity widget. *)
(* Takes in the keys of a Quantity widget and returns the PatternToolTip string. *)
addPatternTooltip[myAssociation_Association,Quantity]:=Module[
	{heldPattern,heldInequalityPatterns,minimumPatternValues,maximumPatternValues,incrementPatternValues,tooltips,cleanedTooltips},

	(* Extract the pattern from the association and hold it. *)
	heldPattern=Extract[myAssociation,Key[Pattern],Hold];

	(* Pull the inequality patterns out of the held pattern. *)
	(* e.g. transform Hold[GreaterP[0 Gram]|GreaterP[0 Liter]] to {Hold[GreaterP[0 Gram]],Hold[GreaterP[0 Liter]]}*)
	heldInequalityPatterns=If[MatchQ[heldPattern,Hold[_Alternatives]],
		With[{insertMe=heldPattern},holdCompositionSingleton[insertMe]],
		ToList[heldPattern]
	];

	(* Get the Min, Max, and Increment for each each element of the pattern *)
	{minimumPatternValues,maximumPatternValues,incrementPatternValues}=Transpose[quantityRange/@heldInequalityPatterns];

	(* Write a description for each element of the entire pattern *)
	tooltips=MapThread[
		Function[{heldPatternElement,min,max,increment},
			Module[{minimumString,maximumString,incrementString},

				(* If min/max/increment is Null, swap out a value that will look better in the PatternTooltip. *)
				minimumString=If[SameQ[min,Null],
					ToString[-Infinity],
					ToString[min]
				];

				maximumString=If[SameQ[max,Null],
					ToString[Infinity],
					ToString[max]
				];

				incrementString=If[SameQ[increment,Null],
					ToString[None],
					ToString[myAssociation[Increment]]
				];

				(* Generate a PatternTooltip string from the pattern element *)
				Switch[heldPatternElement,
					(* RangeP[Min, Max, Increment], by default is include on both sides *)
					Hold[RangeP[_,_,_]]|Hold[RangeP[_,_,_,Inclusive->All]],
					"Quantity must be greater than or equal to " <> minimumString <> " and less than or equal to " <> maximumString <> " in increments of " <> incrementString,

					(* RangeP[Min, Max, Increment, Inclusive\[Rule]Left] *)
					Hold[RangeP[_,_,_,Inclusive->Left]],
					"Quantity must be greater than or equal to " <> minimumString <> " and less than " <> maximumString <> " in increments of " <> incrementString,

					(* RangeP[Min, Max, Increment, Inclusive\[Rule]Right] *)
					Hold[RangeP[_,_,_,Inclusive->Right]],
					"Quantity must be greater than " <> minimumString <> " and less than or equal to " <> maximumString <> " in increments of " <> incrementString,

					(* RangeP[Min, Max, Increment, Inclusive\[Rule]None] *)
					Hold[RangeP[_,_,_,Inclusive->None]],
					"Quantity must be greater than " <> minimumString <> " and less than " <> maximumString <> " in increments of " <> incrementString,

					(* RangeP[Min, Max], by default is include on both sides *)
					Hold[RangeP[_,_]]|Hold[RangeP[_,_,Inclusive->All]],
					"Quantity must be greater than or equal to " <> minimumString <> " and less than or equal to " <> maximumString,

					(* RangeP[Min, Max, Inclusive\[Rule]Left] *)
					Hold[RangeP[_,_,Inclusive->Left]],
					"Quantity must be greater than or equal to " <> minimumString <> " and less than " <> maximumString,

					(* RangeP[Min, Max, Inclusive\[Rule]Right] *)
					Hold[RangeP[_,_,Inclusive->Right]],
					"Quantity must be greater than " <> minimumString <> " and less than or equal to " <> maximumString,

					(* RangeP[Min, Max, Inclusive\[Rule]None] *)
					Hold[RangeP[_,_,Inclusive->None]],
					"Quantity must be greater than " <> minimumString <> " and less than " <> maximumString,

					(* GreaterP[value] *)
					Hold[GreaterP[_]],
					"Quantity must be greater than " <> minimumString,

					(* GreaterP[value,increment] *)
					Hold[GreaterP[_,_]],
					"Quantity must be greater than " <> minimumString <> " in increments of " <> incrementString,

					(* GreaterEqualP[value] *)
					Hold[GreaterEqualP[_]],
					"Quantity must be greater than or equal to " <> minimumString,

					(* GreaterEqualP[value,increment] *)
					Hold[GreaterEqualP[_,_]],
					"Quantity must be greater than or equal to " <> minimumString <> " in increments of " <> incrementString,

					(* LessP[value] *)
					Hold[LessP[_]],
					"Quantity must be less than " <> maximumString,

					(* LessP[value,increment] *)
					Hold[LessP[_,_]],
					"Quantity must be less than " <> maximumString <> " in increments of " <> incrementString,

					(* LessEqualP[value] *)
					Hold[LessEqualP[_]],
					"Quantity must be less than or equal to " <> maximumString,

					(* LessEqualP[value,increment] *)
					Hold[LessEqualP[_,_]],
					"Quantity must be less than or equal to " <> maximumString <> " in increments of " <> incrementString,

					(* If we don't have a matching template, simply convert the pattern into a string, verbatim. *)
					_,
					"Quantity must match: "<>ToString[Extract[heldPattern,{1},HoldForm]]
				]
			]
		],
		{heldInequalityPatterns,minimumPatternValues,maximumPatternValues,incrementPatternValues}
	];

	(* So that the full description can read as a clean sentence remove the redundant 'Quantity must be/match' *)
	cleanedTooltips=Prepend[
		StringDelete[#,"Quantity must be "|"Quantity must"]&/@Rest[tooltips],
		First[tooltips]
	];

	(* Return our new PatternTooltip key, riffling in or to make a complete sentence *)
	StringRiffle[cleanedTooltips," or "]<>"."
];


(* ::Subsubsubsubsection::Closed:: *)
(*String*)


(* Helper function that generates a PatternTooltip for an String widget. *)
addPatternTooltip[myAssociation_Association,String]:=Module[{heldPattern,patternString},
	(* Extract the pattern from the association and hold it. *)
	heldPattern=Extract[myAssociation,Key[Pattern],Hold];

	(* If the held pattern is simply _String, return "String must be a string." *)
	If[SameQ[heldPattern,Hold[_String]],
		"String must be a string.",

		(* Otherwise, return "String must be a string that matches the pattern: [Pattern]. *)
		(* Convert the held pattern into a string. *)
		patternString=ToString[Extract[heldPattern,{1},HoldForm]];

		(* Return our new PatternTooltip key. *)
		"String must be a string that matches the pattern: "<>patternString<>"."
	]
];


(* ::Subsubsubsubsection::Closed:: *)
(*Expression*)


(* Helper function that generates a PatternTooltip for an Expression widget. *)
addPatternTooltip[myAssociation_Association,Expression]:=Module[{heldPattern,patternString},
	(* Extract the pattern from the association and hold it. *)
	heldPattern=Extract[myAssociation,Key[Pattern],Hold];

	(* If the held pattern is simply _, return "Expression must be an expression." *)
	If[SameQ[heldPattern,Hold[_String]],
		"Expression must be an expression.",

		(* Otherwise, return "Expression must be an expression that matches the pattern: [Pattern]. *)
		(* Convert the held pattern into a string. *)
		patternString=ToString[Extract[heldPattern,{1},HoldForm]];

		(* Return our new PatternTooltip key. *)
		"Expression must be an expression that matches the pattern: "<>patternString<>"."
	]
];


(* ::Subsubsubsubsection::Closed:: *)
(*Enumeration*)


(* Helper function that generates a PatternTooltip for an Enumeration widget. *)
addPatternTooltip[myAssociation_Association,Enumeration]:=Module[{heldPattern,heldPatternExpanded,heldPatternList,distributedHeldList,patternToolTip},
	(* Extract the pattern from the association. *)
	heldPattern=Extract[myAssociation,Key[Pattern]];

	(* If the pattern doesn't yet match Hold[_Alternatives], evaluate the symbol inside of the hold. *)
	(* This is because we could have something like a=1|2|3|4; Pattern\[RuleDelayed]a *)
	heldPatternExpanded=If[!MatchQ[heldPattern,Hold[_Alternatives]],
		With[{insertMe=Extract[myAssociation,Key[Pattern]]},Hold[insertMe]],
		heldPattern
	];

	(* Convert the Alternatives into a list. This gives us Hold[myListOfAlternatives]. *)
	heldPatternList=heldPatternExpanded/.{Alternatives->List};

	(* Distribute the Hold to be inside of the list. *)
	distributedHeldList=With[{insertMe=heldPatternList},holdCompositionSingleton[insertMe]];

	(* Construct the PatternTooltip, depending on the number of items in our Alternatives[...]. *)
	patternToolTip=If[Length[distributedHeldList]>1,
		"Enumeration must be either "<>listToText[distributedHeldList]<>".",
		"Enumeration must be "<>listToText[distributedHeldList]<>"."
	];

	(* Return our new PatternTooltip key. *)
	patternToolTip
];

(* ::Subsubsubsubsection::Closed:: *)
(*Molecule*)
addPatternTooltip[myAssociation_Association,Molecule]:="Molecule must be a molecule. Consult the ?Molecule documentation for more information";

(* ::Subsubsubsubsection::Closed:: *)
(*Color*)


(* Helper function that generates a PatternTooltip for a Color widget. *)
addPatternTooltip[myAssociation_Association,Color]:="Color must be a color selection.";


(* ::Subsubsubsubsection::Closed:: *)
(*Date*)


(* Helper function that generates a PatternTooltip for a Date widget. *)
(* Takes in the keys of a Quantity widget and returns the PatternToolTip string. *)
addPatternTooltip[myAssociation_Association,Date]:=Module[
	{heldPattern,patternToolTip,myMinimum,myMaximum,myIncrement},

	(* Extract the pattern from the association and hold it. *)
	heldPattern=Extract[myAssociation,Key[Pattern],Hold];

	(* Extract the Minimum, Maximum, and Increment values from our association. *)
	(* If they are set to Null, swap out a value that will look better in the PatternTooltip. *)
	myMinimum=If[SameQ[myAssociation[Min],Null],
		ToString[-Infinity],
		DateString[myAssociation[Min]]
	];

	myMaximum=If[SameQ[myAssociation[Max],Null],
		ToString[Infinity],
		DateString[myAssociation[Max]]
	];

	myIncrement=If[SameQ[myAssociation[Increment],Null],
		ToString[None],
		ToString[myAssociation[Increment]]
	];

	(* Generate a PatternTooltip string from the widget's Pattern. *)
	Switch[heldPattern,
		Hold[Verbatim[_?DateObjectQ]],
			"Date must be a valid date.",

		(* RangeP[Min, Max, Increment], by default is include on both sides *)
		Hold[RangeP[_,_,_]]|Hold[RangeP[_,_,_,Inclusive->All]],
			"Date must be less than or equal to " <> myMaximum <> " and greater than or equal to " <> myMinimum <> " in increments of " <> myIncrement <> ".",

		(* RangeP[Min, Max, Increment, Inclusive\[Rule]Left] *)
		Hold[RangeP[_,_,_,Inclusive->Left]],
			"Date must be less than or equal to " <> myMaximum <> " and greater than " <> myMinimum <> " in increments of " <> myIncrement <> ".",

		(* RangeP[Min, Max, Increment, Inclusive\[Rule]Right] *)
		Hold[RangeP[_,_,_,Inclusive->Right]],
			"Date must be less than " <> myMaximum <> " and greater than or equal to " <> myMinimum <> " in increments of " <> myIncrement <> ".",

		(* RangeP[Min, Max, Increment, Inclusive\[Rule]None] *)
		Hold[RangeP[_,_,_,Inclusive->None]],
			"Date must be less than " <> myMaximum <> " and greater than " <> myMinimum <> " in increments of " <> myIncrement <> ".",

		(* RangeP[Min, Max], by default is include on both sides *)
		Hold[RangeP[_,_]]|Hold[RangeP[_,_,Inclusive->All]],
			"Date must be less than or equal to " <> myMaximum <> " and greater than or equal to " <> myMinimum <> ".",

		(* RangeP[Min, Max, Inclusive\[Rule]Left] *)
		Hold[RangeP[_,_,Inclusive->Left]],
			"Date must be less than or equal to " <> myMaximum <> " and greater than " <> myMinimum <> ".",

		(* RangeP[Min, Max, Inclusive\[Rule]Right] *)
		Hold[RangeP[_,_,Inclusive->Right]],
			"Date must be less than " <> myMaximum <> " and greater than or equal to " <> myMinimum <> ".",

		(* RangeP[Min, Max, Inclusive\[Rule]None] *)
		Hold[RangeP[_,_,Inclusive->None]],
			"Date must be less than " <> myMaximum <> " and greater than " <> myMinimum <> ".",

		(* GreaterP[value] *)
		Hold[GreaterP[_]],
			"Date must be greater than " <> myMinimum <> ".",

		(* GreaterP[value,increment] *)
		Hold[GreaterP[_,_]],
			"Date must be greater than " <> myMinimum <> " in increments of " <> myIncrement <> ".",

		(* GreaterEqualP[value] *)
		Hold[GreaterEqualP[_]],
			"Date must be greater than or equal to " <> myMinimum <> ".",

		(* GreaterEqualP[value,increment] *)
		Hold[GreaterEqualP[_,_]],
			"Date must be greater than or equal to " <> myMinimum <> " in increments of " <> myIncrement <> ".",

		(* LessP[value] *)
		Hold[LessP[_]],
			"Date must be less than " <> myMaximum <> ".",

		(* LessP[value,increment] *)
		Hold[LessP[_,_]],
			"Date must be less than " <> myMaximum <> " in increments of " <> myIncrement <> ".",

		(* LessEqualP[value] *)
		Hold[LessEqualP[_]],
			"Date must be less than or equal to " <> myMaximum <> ".",

		(* LessEqualP[value,increment] *)
		Hold[LessEqualP[_,_]],
			"Date must be less than or equal to " <> myMaximum <> " in increments of " <> myIncrement <> ".",

		(* If we don't have a matching template, simply convert the pattern into a string, verbatim. *)
		_,
			ToString[Extract[heldPattern,{1},HoldForm]]
	]
];


(* ::Subsubsubsubsection::Closed:: *)
(*Object*)


(* Helper function that generates a PatternTooltip for an Object widget. *)
addPatternTooltip[myAssociation_Association,Object]:=Module[{heldPattern,objectList,preparedSampleQ,patternToolTip},
	(* Extract the pattern from the association and hold it. *)
	heldPattern=Extract[myAssociation,Key[Pattern],Hold];

	(* Convert the ObjectP into a list. *)
	objectList=FirstCase[heldPattern,ObjectP[x_]:>x];

	(* See if our object widget allows for prepared samples. *)
	preparedSampleQ=Lookup[myAssociation,PreparedSample,False]||Lookup[myAssociation,PreparedContainer,False];

	(* Generate a PatternTooltip string from the widget's Pattern. *)
	(* If there was nothing inside of the ObjectP[], this means that all objects are allowed. *)
	patternToolTip=If[MatchQ[heldPattern,Hold[ObjectP[]]],
		(* Any object is allowed. *)
		"Object must be an object of any type"<>If[preparedSampleQ," or a prepared sample",""]<>".",
		(* Only certain objects are allowed. *)
		"Object must be an object of type or subtype "<>listToText[ToList[objectList]]<>If[preparedSampleQ," or a prepared sample",""]<>"."
	];

	(* Return our new PatternTooltip key. *)
	patternToolTip
];


(* ::Subsubsubsubsection::Closed:: *)
(*FieldReference*)


(* Helper function that generates a PatternTooltip for an Object widget. *)
addPatternTooltip[myAssociation_Association,FieldReference]:=Module[{heldPattern,objectTypesString,fieldTypesString,patternToolTip},
	(* Extract the pattern from the association and hold it. *)
	heldPattern=Extract[myAssociation,Key[Pattern],Hold];

	(* Construct our explanation of the allowed fields. *)
	fieldTypesString=Switch[myAssociation[Fields],
		(* If we allow all fields, just say from any field. *)
		Fields[myAssociation[ObjectTypes],Output->Short],
			" followed by any field from that object",
		(* Otherwise, list the specific fields that are okay. *)
		_,
			" followed by one of the fields: "<>listToText[myAssociation[Fields]]
	];

	objectTypesString=Switch[myAssociation[ObjectTypes],
		(* If we are allowing all objects, don't overwhelm the string explanation. Just say of any object type. *)
		Types[],
			"from any object type",
		(* Otherwise, list the specific object types that are okay. *)
		_,
			"from an object of type "<>listToText[myAssociation[ObjectTypes]]
	];

	(* Generate a PatternTooltip string from the widget's Pattern. *)
	patternToolTip="FieldReference must be "<>objectTypesString<>fieldTypesString<>".";

	(* Return our new PatternTooltip key. *)
	patternToolTip
];

(* ::Subsubsubsubsection::Closed:: *)
(*UnitOperationMethod*)


(* Helper function that generates a PatternTooltip for a UnitOperation widget. *)
addPatternTooltip[myAssociation_Association,UnitOperationMethod]:=Module[{methods},
	(* Extract the Methods key from the widget. *)
	methods=myAssociation[Methods];

	"Unit Operation Method must be "<>listToText[methods]<>"."
];

(* ::Subsubsubsubsection::Closed:: *)
(*UnitOperation*)


(* Helper function that generates a PatternTooltip for a UnitOperation widget. *)
addPatternTooltip[myAssociation_Association,UnitOperation]:=Module[{heldPattern},
	(* Extract the pattern from the association and hold it. *)
	heldPattern=Extract[myAssociation,Key[Pattern],Hold];

	"Unit Operation must match "<>ToString[Extract[heldPattern,{1},HoldForm]]<>"."
];

addPatternTooltip[myAssociation_Association,Head]:="Must include a valid widget";

(* ::Subsubsubsubsection::Closed:: *)
(*Primitive*)


(* Helper function that generates a PatternTooltip for a Primitive widget. *)
addPatternTooltip[myAssociation_Association,Primitive]:=Module[{primitiveTypes},
	(* Extract the PrimitiveTypes key from the widget. *)
	primitiveTypes=myAssociation[PrimitiveTypes];

	"Primitive must be a primitive with head "<>listToText[primitiveTypes]<>"."
];


(* ::Subsubsubsubsection::Closed:: *)
(*MultiSelect*)


(* Helper function that generates a PatternTooltip for a Primitive widget. *)
addPatternTooltip[myAssociation_Association,MultiSelect]:=Module[{heldPattern,heldPatternExpanded,multiSelectList,patternString},
	(* Extract the pattern from the association and hold it. *)
	heldPattern=Extract[myAssociation,Key[Pattern],Hold];

	(* If the pattern doesn't yet match Hold[Verbatim[DuplicateFreeListableP][Verbatim[Alternatives][x__]]], evaluate the symbol inside of the hold. *)
	(* This is because we could have something like a=1|2|3|4; Pattern\[RuleDelayed]DuplicateFreeListableP[a] *)
	heldPatternExpanded=If[!MatchQ[heldPattern,Hold[DuplicateFreeListableP[Verbatim[Alternatives][x__]]]],
		With[{insertMe=Extract[myAssociation/.{DuplicateFreeListableP->Identity},Key[Pattern]]},Hold[insertMe]],
		heldPattern
	];

	(* The pattern is in the form DuplicateFreeListableP[_Alternatives]. Extract the Alternatives from the DuplicateFreeListableP and use that to create the PatternTooltip. *)
	multiSelectList=ReleaseHold[heldPatternExpanded/.{Hold[DuplicateFreeListableP[Verbatim[Alternatives][x__]]]:>{x}, Alternatives->List}];

	(* Create the final string. *)
	patternString="Multiselect must be a selection of one or more of "<>listToText[multiSelectList]<>".";

	(* Return our new PatternTooltip key. *)
	patternString
];

(* ::Subsubsubsubsection::Closed:: *)
(*Head*)

(* Helper function that generates a PatternTooltip for a Head widget. *)
addPatternTooltip[myAssociation_Association,Head]:=Module[
  {
    symbolWrapper
  },
  (* Get the head out of the head widget *)
	symbolWrapper=Lookup[myAssociation,Head];

	"Must be of the form " <> ToString[symbolWrapper] <> "[...]."
];


(* ::Subsubsubsubsection::Closed:: *)
(*addPatternTooltip Main Function*)


(* If the key PatternTooltip doesn't exist in the association, automatically generate the PatternTooltip from the Pattern and add it to the association. *)
(* Takes in the keys of a widget and returns the PatternToolTip string. *)
addPatternTooltip::InvalidWidgetType="Widget type `1` does not have a PatternTooltip key. Please do not call PatternToolTip with this widget type.";

addPatternTooltip[myAssociation_Association]:=Module[{widgetType},
	(* Check for the PatternTooltip key. If it already exists, then simply return the association. *)
	If[KeyExistsQ[myAssociation,PatternTooltip]&&!MatchQ[myAssociation[PatternTooltip],_Missing],
		Return[myAssociation]
	];

	(* Otherwise, the PatternTooltip key doesn't exist. We have to generate it. *)

	(* Extract the Type of the widget. *)
	widgetType=myAssociation[Type];

	(* Make sure that our widget has a valid type. *)
	If[MatchQ[widgetType,WidgetTypeP],
		(* Call the respective helper function and return its result in a new association. *)
		Append[myAssociation,PatternTooltip->addPatternTooltip[myAssociation,widgetType]],
		(* Otherwise, we were somehow given an invalid widget type. *)
		Message[addPatternTooltip::InvalidWidgetType];
		$Failed
	]
];

OverallPatternTooltip::UnknownWidget = "The widget, `1`, wasn't recognized. Please call ValidWidgetQ to verify the widget is valid. If it is valid please file a bug report indicating OverallPatternTooltip needs to be updated to support this new widget style."
fullPatternTooltip[widget_,patternString_]:=Module[{substring},

	(* Handle options in compound widgets like 'Orientation->Vertical' - these can be skipped *)
	If[MatchQ[widget,_Symbol->_Symbol|_Symbol],
		Return[patternString]
	];

	If[MatchQ[widget,_Widget],
		(* -- Atomic Widget Case -- *)
		Module[{widgetString,cleanedString,lowercaseString},
			widgetString = widget[PatternTooltip];

			(* Get just the core string since the full description doesn't make sense when combining with other full descriptions *)
			cleanedString = StringTrim[
				StringReplace[widgetString,{WordCharacter..~~(" must be either " | " must be ")~~meat___~~"." :> meat}],
				"."
			];

			(* If the widget description doesn't start with a symbol after removing any 'must be's then lowercase-ify that first letter *)
			lowercaseString = If[MatchQ[widget[Type],Enumeration],
				cleanedString,
				StringReplace[cleanedString, firstLetter : (StartOfString ~~ _) :> ToLowerCase[firstLetter]]
			];

			StringJoin[patternString, lowercaseString]
		],

		(* -- Compount Widgets Case -- *)
		Module[{childWidgets,childStrings},

			(* Strip Adder/Alternatives and get widgets within *)
			childWidgets = List@@widget;

			(* If our root widget has labels just show these *)
			(* Tuples will have a direct list of labels tuple:{time->widget,flowRate->widget} *)
			childStrings = If[MatchQ[widget,{(_String->_)..}],
				StringRiffle[widget[[All, 1]], {"",", ",""}],

				(* Adders and Alternatives need to have head replaced with list before we recognize the label rule pattern *)
				Module[{substrings},

					(* Since not all widgets are required to have labels map over and handle each case *)
					substrings = Map[
						If[MatchQ[#,(_String->_)],
							First[#],
							fullPatternTooltip[#, patternString]
						]&,
						childWidgets
					];

					(* Move any Nulls to the end of the string since they look ugly *)
					SortBy[substrings, Position[{Except["Null"],"Null"},#]&]
				]
			];

			(* Construct our final string for this widget *)
			substring = Switch[Head[widget],
				(* Adders mean we will have at least one element in our list *)
				Adder, "list of one or more "<>childStrings<>" entries",

				(* Add an or between each option *)
				Alternatives, StringRiffle[childStrings, " or "],

				(* For tuples show the different widgets in a list *)
				List, "{"<>childStrings<>"}",

				(* Spans are only between numbers, units or dates so the 'anything' should make sense *)
				Span, StringJoin["a span from anything ", childStrings[[1]], " to anything ", childStrings[[2]]],

				(* Throw an error if we couldn't detect our widget *)
				_, Message[OverallPatternTooltip::UnknownWidget,ToString[widget,InputForm]]; $Failed
			];

			(* Join our string to the overall string - this lets us recursively build up the full tooltip *)
			StringJoin[patternString, substring]
		]
	]
];




(* Authors definition for OverallPatternTooltip *)
Authors[OverallPatternTooltip]:={"scicomp", "brad"};

OverallPatternTooltip[widget:WidgetP]:=Module[{string},
	string=Capitalize[fullPatternTooltip[widget,""]];
	If[!StringMatchQ[StringLast[string],PunctuationCharacter],
		string<>".",
		string
	]
];


(* ::Subsubsubsection::Closed:: *)
(*Enumeration*)


Widget::EnumerationPatternValue="The value for the key Pattern must match _Alternatives for the Enumeration widget. Please change the value of this key.";
Widget::EnumerationItemsValue="The value for the key Items must be consistent with the given Pattern. The Pattern must match Alternatives@@Items. Please change the value of this key.";
Widget::EnumerationInvalidKeys="The Enumeration widget does not take keys `1`. Please change the value of this key.";

(* Takes in an association of keys and checks that they can be used to specify an enumeration widget. Autofills the keys that it can based on the given information. Returns an enumration widget. *)
enumerationWidget[myAssociation_Association]:=Module[
	{validKeys,invalidKeys,defaultItems,defaultValues,widgetAssociationWithDefaults,associationWithPatternTooltip},

	(* Define the valid keys for this widget. *)
	validKeys={Type, Pattern, Items, PatternTooltip, Identifier};

	(* Get the set difference between the valid keys and the keys in the given association. This gives us the invalid keys in the association. *)
	invalidKeys=Complement[Union[validKeys,Keys[myAssociation]],validKeys];

	(* If there are invalid keys, return $Failed. *)
	If[Length[invalidKeys]!=0,
		Message[Widget::EnumerationInvalidKeys,invalidKeys]; Return[$Failed];
	];

	(* Make sure that the enumeration widget's pattern is specified as an alternatives. *)
	If[!MatchQ[myAssociation[Pattern],_Alternatives],
		Message[Widget::EnumerationPatternValue]; Return[$Failed];
	];

	(* If the Items key is provided, make sure that the pattern is consistent with the items key. *)
	If[KeyExistsQ[myAssociation,Items]&&!MatchQ[Flatten[Lookup[myAssociation,Pattern]],Verbatim[Evaluate[Alternatives@@myAssociation[Items]]]],
		Message[Widget::EnumerationItemsValue]; Return[$Failed];
	];

	(* No more checks to perform. Construct the widget. *)

	(* Compute the default value for the Items key. *)
	(* We have to flatten the Alternatives here if someone gives us ex. (FitTypeP|Automatic) *)
	defaultItems=Module[{heldPattern},
		(* Get the held pattern. *)
		heldPattern = Extract[myAssociation, Key[Pattern], Hold];

		(* If the pattern immediately mattches Alternatives[...], then just get the items that way. *)
		If[MatchQ[heldPattern, Verbatim[Hold][_Alternatives]],
			Items -> List@@Flatten[myAssociation[Pattern]],
			Module[{ownValues},
				(* Otherwise, get the ownvalues for the symbol. *)
				(* Try to get the OwnValues for the pattern. *)
				ownValues = Quiet[Extract[myAssociation, Key[Pattern], Hold] /. {Hold -> OwnValues}];

				(* If the ownvalues match RuleDelayed, then we're in business. *)
				If[MatchQ[ownValues, {Verbatim[RuleDelayed][_, Verbatim[Alternatives][_Symbol..]], ___}],
					Module[{heldItems},
						(* Extract the alternatives, convert to list without evaluating, wrapped in Hold. *)
						heldItems=Extract[ownValues /. {Alternatives->List}, {1,2}, Hold];

						With[{insertMe=heldItems},
							ReleaseHold@holdCompositionList[
								RuleDelayed,
								{
									Hold[Items],
									insertMe
								}
							]
						]
					],
					Items -> List@@Flatten[myAssociation[Pattern]]
				]
			]
		]
	];

	(* Define the defaults for the optional keys of the number widget. *)
	defaultValues=Association@{defaultItems,Identifier->CreateUUID[]};

	(* Add the PatternTooltip to the input association. This function doesn't do anything if the tooltip is already specified in the association. *)
	associationWithPatternTooltip=addPatternTooltip[myAssociation];

	(* Fill out the optional keys with default values if they are not specified. *)
	(* NOTE: we need to do this to preserve our delayed rule. *)
	widgetAssociationWithDefaults=Join[defaultValues, associationWithPatternTooltip];

	(* Return the widget. *)
	Widget[widgetAssociationWithDefaults]
];


(* ::Subsubsubsection::Closed:: *)
(*Number*)


Widget::NumberPatternValue="The value for the key Pattern must match InequalityP for the Number widget. Please change the value of this key.";
Widget::NumberMinValue="The value for the key Min must match the given pattern for the Number widget. Please change the value of this key.";
Widget::NumberMaxValue="The value for the key Max must match the given pattern for the Number widget. Please change the value of this key.";
Widget::NumberIncrementValue="The value for the key Increment must match the given pattern for the Number widget. Please change the value of this key.";
Widget::NumberInvalidKeys="The Number widget does not take keys `1`. Please remove these keys.";

(* Takes in an association of keys and checks that they can be used to specify a number widget. Autofills the keys that it can based on the given information. Returns a number widget. *)
numberWidget[myAssociation_Association]:=Module[
	{validKeys,invalidKeys,heldPattern,heldInequalityPattern,minimumPatternValue,maximumPatternValue,
	incrementPatternValue,associationWithPatternTooltip,defaultValues,missingKeys,widgetAssociationWithDefaults,
	minimumPatternValueHandlingInfinity,maximumPatternValueHandlingInfinity,incrementPatternValueHandlingInfinity},

	(* Define the valid keys for this widget. *)
	validKeys={Type, Pattern, Min, Max, Increment, PatternTooltip, Identifier};

	(* Get the set difference between the valid keys and the keys in the given association. This gives us the invalid keys in the association. *)
	invalidKeys=Complement[Union[validKeys,Keys[myAssociation]],validKeys];

	(* If there are invalid keys, return $Failed. *)
	If[Length[invalidKeys]!=0,
		Message[Widget::NumberInvalidKeys,invalidKeys]; Return[$Failed];
	];

	(* Extract the pattern from the association and hold it. *)
	heldPattern=Extract[myAssociation,Key[Pattern],Hold];

	(* Make sure that the pattern provided matches InequalityP. *)
	If[!MatchQ[heldPattern,Hold[Evaluate[InequalityP]]],
		Message[Widget::NumberPatternValue]; Return[$Failed];
	];

	(* Now we will check that the values of Min, Max, and Increment match the pattern. *)

	(* The held pattern is the inequality is simply the held pattern *)
	heldInequalityPattern=heldPattern;

	(* Extract the minimum value from the pattern. *)
	minimumPatternValue=Switch[heldInequalityPattern,
		(* RangeP[minimum,maximum] *)
		Hold[_RangeP],
			Extract[heldInequalityPattern,{1,1}],

		(* GreaterP[minimum] and GreaterEqualP[minimum] *)
		Hold[_GreaterP]|Hold[_GreaterEqualP],
			Extract[heldInequalityPattern,{1,1}],

		(* LessP[maximum] and LessEqualP[maximum] *)
		Hold[_LessP]|Hold[_LessEqualP],
			Null,

		(* Catch All, we should never get here *)
		_,
			Null
	];

	(* Make sure that if our minimum is set to Inifinity, we set it to Null. *)
	minimumPatternValueHandlingInfinity=If[MatchQ[minimumPatternValue,\[Infinity]|-\[Infinity]],
		Null,
		minimumPatternValue
	];

	(* Extract the maximum value from the pattern. *)
	maximumPatternValue=Switch[heldInequalityPattern,
		(* RangeP[minimum,maximum] *)
		Hold[_RangeP],
			Extract[heldInequalityPattern,{1,2}],

		(* GreaterP[minimum] and GreaterEqualP[minimum] *)
		Hold[_GreaterP]|Hold[_GreaterEqualP],
			Null,

		(* LessP[maximum] and LessEqualP[maximum] *)
		Hold[_LessP]|Hold[_LessEqualP],
			Extract[heldInequalityPattern,{1,1}],

		(* Catch All, we should never get here *)
		_,
			Null
	];

	(* Make sure that if our minimum is set to Inifinity, we set it to Null. *)
	maximumPatternValueHandlingInfinity=If[MatchQ[maximumPatternValue,\[Infinity]|-\[Infinity]],
		Null,
		maximumPatternValue
	];

	(* Extract the increment value from the pattern. *)
	incrementPatternValue=Switch[heldInequalityPattern,
		(* RangeP[minimum,maximum,increment] *)
		Hold[RangeP[_,_,_]]|Hold[RangeP[_,_,_,Inclusive->_]],
			Extract[heldInequalityPattern,{1,3}],

		(* GreaterP[minimum,increment] and GreaterEqualP[minimum,increment] *)
		Hold[GreaterP[_,_]]|Hold[GreaterP[_,_,Inclusive->_]]|Hold[GreaterEqualP[_,_]]|Hold[GreaterEqualP[_,_,Inclusive->_]],
			Extract[heldInequalityPattern,{1,2}],

		(* LessP[maximum,increment] and LessEqualP[maximum,increment] *)
		Hold[LessP[_,_]]|Hold[LessP[_,_,Inclusive->_]]|Hold[LessEqualP[_,_]]|Hold[LessEqualP[_,_,Inclusive->_]],
			Extract[heldInequalityPattern,{1,2}],

		(* Otherwise, the increment value isn't provided. *)
		_,
			Null
	];

	(* Make sure that if our minimum is set to Inifinity, we set it to Null. *)
	incrementPatternValueHandlingInfinity=If[MatchQ[incrementPatternValue,\[Infinity]|-\[Infinity]],
		Null,
		incrementPatternValue
	];

	(* Make sure that Min, if specified, matches the minimum value specified in the pattern. *)
	If[KeyExistsQ[myAssociation,Min]&&!MatchQ[myAssociation[Min],minimumPatternValueHandlingInfinity],
		Message[Widget::NumberMinValue]; Return[$Failed];
	];

	(* Make sure that Max, if specified, matches the maximum value specified in the pattern. *)
	If[KeyExistsQ[myAssociation,Max]&&!MatchQ[myAssociation[Max],maximumPatternValueHandlingInfinity],
		Message[Widget::NumberMaxValue]; Return[$Failed];
	];

	(* Make sure that Increment, if specified, matches the increment value specified in the pattern. *)
	If[KeyExistsQ[myAssociation,Increment]&&!MatchQ[myAssociation[Increment],incrementPatternValueHandlingInfinity],
		Message[Widget::NumberIncrementValue]; Return[$Failed];
	];

	(* There are no more checks. Construct the widget. *)

	(* Define the defaults for the optional keys of the number widget. *)
	defaultValues=<|Min->minimumPatternValueHandlingInfinity,Max->maximumPatternValueHandlingInfinity,Increment->incrementPatternValueHandlingInfinity,Identifier->CreateUUID[]|>;

	(* Get the missing keys in the association. *)
	missingKeys=Complement[Keys[defaultValues],Keys[myAssociation]];

	(* Fill out the optional keys with default values if they are not specified. *)
	widgetAssociationWithDefaults=Append[myAssociation,(#->defaultValues[#]&)/@missingKeys];

	(* Add the PatternTooltip to the input association. This function doesn't do anything if the tooltip is already specified in the association. *)
	associationWithPatternTooltip=addPatternTooltip[widgetAssociationWithDefaults];

	(* Return the constructed widget. *)
	Widget[associationWithPatternTooltip]
];


(* ::Subsubsubsection::Closed:: *)
(*Quantity*)


(* ::Subsubsubsubsection::Closed:: *)
(*Helper Functions for Expanding Unit Short-hands*)


(*

	The short hands that the user can supply are:

	{Milliliter,{Microliter,Milliliter,Liter}} -> {1,{Milliliter,{Microliter,Milliliter,Liter}}}
	Foot -> {1,Foot,{Foot}}

	We have to do this recursively (can't use blind pattern matching) because context matters.

*)


(* Atomic Unit Helper Function *)
Widget::UnknownUnitShortHand="Unable to expand the unit short hand `1`. Please change the value of this unit.";

(* Resolves the unit short hands inside of myUnit. *)
(* Takes in the unit short hand (explained above) and returns the expanded unit in the form {1,_,{__}}. *)
expandUnitShortHand[myUnit_]:=Module[{},
	Switch[myUnit,
		(* If myUnit is a Unit, expand using the rule Foot -> {1,Foot,{Foot}}. *)
		_?QuantityQ,
			{1,{myUnit,{myUnit}}},

		(* If myUnit matches {_?QuantityQ,{_?QuantityQ..}}, expand to {1,{_?QuantityQ,{_?QuantityQ..}}}. *)
		{_?QuantityQ,{_?QuantityQ..}},
			{1,myUnit},

		(* If myUnit matches atomicUnitP ({_?NumberQ,{_?QuantityQ,{_?QuantityQ..}}}), there is nothing to expand. *)
		atomicUnitP,
			myUnit,

		(* Otherwise, this is not a valid short-hand. Return $Failed. *)
		_,
			Message[Widget::UnknownUnitShortHand,ToString[myUnit]]; $Failed
	]
];


(* Alternatives Unit Helper Function *)

(* Resolves the unit short hands inside of myUnit which is in the form Alternatives[_?QuantityQ..]. *)
(* Takes in the unit short hand (explained above) and returns the expanded unit in the form {1,_,{__}}. *)
expandUnitShortHand[myUnit:Verbatim[Alternatives][(_?QuantityQ)..]]:=Module[{groupedUnits,groupedUnitsWithLeader,expandedShortHands},
	(* Expand each of the unit short-hands inside of the Alternatives. *)
	groupedUnits=Values[GroupBy[List@@myUnit, UnitDimensions]];
	groupedUnitsWithLeader=({#[[1]],#}&)/@groupedUnits;
	expandedShortHands=expandUnitShortHand/@groupedUnitsWithLeader;

	(* Check for $Failed. *)
	If[MemberQ[expandedShortHands,$Failed],
		Return[$Failed];
	];

	(* Otherwise, pop back up the stack and return our expanded Alternatives WidgetUnit if we have more than one group. *)
	If[Length[expandedShortHands] > 1,
		Alternatives@@expandedShortHands,
		First[expandedShortHands]
	]
];

(* Alternatives Unit Helper Function *)

(* Resolves the unit short hands inside of myUnit which is in the form Alternatives[moreWidgetUnits..]. *)
(* Takes in the unit short hand (explained above) and returns the expanded unit in the form {1,_,{__}}. *)
expandUnitShortHand[myUnit_Alternatives]:=Module[{expandedShortHands},
	(* Expand each of the unit short-hands inside of the Alternatives. *)
	expandedShortHands=expandUnitShortHand/@(List@@myUnit);

	(* Check for $Failed. *)
	If[MemberQ[expandedShortHands,$Failed],
		Return[$Failed];
	];

	(* Otherwise, pop back up the stack and return our expanded Alternatives WidgetUnit. *)
	Alternatives@@expandedShortHands
];


(* CompoundUnit Helper Function *)

(* Resolves the unit short hands inside of myUnit, which is in the form CompoundUnit[moreWidgetUnits..]. *)
(* Takes in the unit short hand (explained above) and returns the expanded unit in the form {1,_,{__}}. *)
expandUnitShortHand[myUnit_CompoundUnit]:=Module[{expandedShortHands},
	(* Expand each of the unit short-hands inside of the CompoundUnit. *)
	expandedShortHands=expandUnitShortHand/@(List@@myUnit);

	(* Check for $Failed. *)
	If[MemberQ[expandedShortHands,$Failed],
		Return[$Failed];
	];

	(* Otherwise, pop back up the stack and return our expanded CompoundUnit WidgetUnit. *)
	CompoundUnit@@expandedShortHands
];


(* ::Subsubsubsubsection::Closed:: *)
(*Main Function*)


Widget::QuantityPatternValue="The value for the key Quantity must match InequalityP or _Alternatives for the Quantity widget. Please change the value of this key.";
Widget::QuantityMinValue="The value for the key Min must match the given pattern for the Quantity widget. Please change the value of this key.";
Widget::QuantityMaxValue="The value for the key Max must match the given pattern for the Quantity widget. Please change the value of this key.";
Widget::QuantityIncrementValue="The value for the key Increment must match the given pattern for the Quantity widget. Please change the value of this key.";
Widget::QuantityMissingUnitsKey="The key Units must be specified to create a Quantity widget. Please change the value of this key.";
Widget::QuantityInvalidKeys="The Quantity widget does not take keys `1`. Please change the value of this key.";
Widget::QuantityPatternUnits="The unit of the `1` value in the Quantity widget (`2`) does not match the units of the Units key (`3`) in the given Pattern `4`. Please change the value of this unit.";
Widget::QuantityPatternUnitMismatch="The units in the Unit key have unique unit dimensions of `1` but the units in the Pattern key have unique unit dimension of `2`. The Unit and Pattern keys are mismatched. Please change the values of these keys.";

(* Takes in an association of keys and checks that they can be used to specify an quantity widget. Autofills the keys that it can based on the given information. Returns a quantity widget. *)
quantityWidget[myAssociation_Association]:=Module[
	{validKeys,invalidKeys,expandedUnits,heldPattern,heldInequalityPatterns,
	minimumPatternValues,maximumPatternValues,incrementPatternValues,
	unitPattern,associationWithPatternTooltip,defaultValues,missingKeys,widgetAssociationWithExpandedUnits,
	widgetAssociationWithDefaults,
	uniqueUnitDimensionsFromUnits,unitsFromPattern,uniqueUnitDimensionsFromPattern},

	(* Define the valid keys for this widget. *)
	validKeys={Type, Pattern, Min, Max, Increment, Units, PatternTooltip, Identifier};

	(* Get the set difference between the valid keys and the keys in the given association. This gives us the invalid keys in the association. *)
	invalidKeys=Complement[Union[validKeys,Keys[myAssociation]],validKeys];

	(* If there are invalid keys, return $Failed. *)
	If[Length[invalidKeys]!=0,
		Message[Widget::QuantityInvalidKeys,invalidKeys]; Return[$Failed];
	];

	(* Make sure that the units key is provided. *)
	If[!KeyExistsQ[myAssociation,Units],
		Message[Widget::QuantityMissingUnitsKey,invalidKeys]; Return[$Failed];
	];

	(* Expand the short hands inside of the Units key. *)
	expandedUnits=expandUnitShortHand[myAssociation[Units]];

	(* Check for $Failed. *)
	If[MatchQ[expandedUnits,$Failed],
		(* The helper function expandUnitShortHand throws messages if it finds problems. *)
		Return[$Failed];
	];

	(* Extract the pattern from the association and hold it. *)
	heldPattern=Extract[myAssociation,Key[Pattern],Hold];

	(* Make sure that the pattern provided matches InequalityP or Alternatives. *)
	If[!MatchQ[heldPattern,Hold[Evaluate[InequalityP]]|Hold[_Alternatives]],
		Message[Widget::QuantityPatternValue]; Return[$Failed];
	];

	(* Pull the inequality patterns out of the held pattern. *)
	heldInequalityPatterns=If[MatchQ[heldPattern,Hold[_Alternatives]],
		With[{insertMe=heldPattern},holdCompositionSingleton[insertMe]],
		ToList[heldPattern]
	];

	(* Now we will check that the values of Min, Max, and Increment match the pattern. *)
	{minimumPatternValues,maximumPatternValues,incrementPatternValues}=Transpose[quantityRange/@heldInequalityPatterns];

	(* Make sure that Min, if specified, matches the minimum value specified in the pattern. *)
	If[KeyExistsQ[myAssociation,Min]&&!MatchQ[myAssociation[Min],Alternatives@@minimumPatternValues],
		Message[Widget::QuantityMinValue]; Return[$Failed];
	];

	(* Make sure that Max, if specified, matches the maximum value specified in the pattern. *)
	If[KeyExistsQ[myAssociation,Max]&&!MatchQ[myAssociation[Max],Alternatives@@maximumPatternValues],
		Message[Widget::QuantityMaxValue]; Return[$Failed];
	];

	(* Make sure that Increment, if specified, matches the increment value specified in the pattern. *)
	If[KeyExistsQ[myAssociation,Increment]&&!MatchQ[myAssociation[Increment],Alternatives@@incrementPatternValues],
		Message[Widget::QuantityIncrementValue]; Return[$Failed];
	];

	(* Construct a pattern for this Quantity widget's units. This GenerateInputPattern call is recursive. The Pattern that is returned is Held. *)
	unitPattern=GenerateInputPattern[expandedUnits];

	(* GenerateInputPattern does additional checks (to make sure unit dimensions are the same). Check for $Failed. *)
	If[MatchQ[unitPattern,$Failed],
		(* If something went wrong, GenerateInputPattern would have thrown messages. *)
		Return[$Failed];
	];

	(* Otherwise, make sure that the Min, Max, and Increment values all match the unitPattern. This also guarentees that the Pattern key is in the correct Units. *)

	(* If the units do not match, return the following error message (provided here for formatting reference). *)
	(* Widget::QuantityPatternUnits="The unit of the `1` value in the Quantity widget (`2`) does not match the units of the Units key (`3`) in the given Pattern `4`". *)

	(* Check the units of the minimum value. *)
	If[!Or@@(MatchQ[#,Null|ReleaseHold[unitPattern]]&)/@minimumPatternValues,
		Message[Widget::QuantityPatternUnits,"minimum",ToString[myAssociation],ToString[minimumPatternValues],ToString[HoldForm[myAssociation[Pattern]]]]; Return[$Failed];
	];

	(* Check the units of the maximum value. *)
	If[!Or@@(MatchQ[#,Null|ReleaseHold[unitPattern]]&)/@maximumPatternValues,
		Message[Widget::QuantityPatternUnits,"maximum",ToString[myAssociation],ToString[maximumPatternValues],ToString[HoldForm[myAssociation[Pattern]]]]; Return[$Failed];
	];

	(* Check the units of the increment value. *)
	If[!Or@@(MatchQ[#,Null|ReleaseHold[unitPattern]]&)/@incrementPatternValues,
		Message[Widget::QuantityPatternUnits,"increment",ToString[myAssociation],ToString[incrementPatternValues],ToString[HoldForm[myAssociation[Pattern]]]]; Return[$Failed];
	];

	(* Make sure that all of our units are accounted for in our pattern (in terms of unit dimensions). *)
	(* For example, if our units are Alternatives[Gram, Liter], the pattern is an alternatives between units of the same dimension of Gram and Liter. *)

	(* Get all of the unique unit dimensions from our Units key. unitPattern does the unique unit dimension filtering for us already. *)
	uniqueUnitDimensionsFromUnits=UnitDimensions/@Cases[unitPattern,_Quantity,Infinity];

	(* Extract all of the units from our Pattern key. *)
	unitsFromPattern=Cases[ReleaseHold[heldPattern],_Quantity,Infinity];

	(* Get all of the unique unit dimensions from our Pattern key. *)
	uniqueUnitDimensionsFromPattern=Keys[GroupBy[unitsFromPattern,UnitDimensions]];

	(* If the two sets are not the same, throw an Error. *)
	If[!ContainsExactly[uniqueUnitDimensionsFromUnits,uniqueUnitDimensionsFromPattern],
		Message[Widget::QuantityPatternUnitMismatch,ToString[uniqueUnitDimensionsFromUnits],ToString[uniqueUnitDimensionsFromPattern]]; Return[$Failed];
	];

	(* Make sure that for each unique unit from our units key, *)

	(* There are no more checks. Construct the widget. *)

	(* Define the defaults for the optional keys of the number widget. *)
	defaultValues=<|Min->minimumPatternValues[[1]],Max->maximumPatternValues[[1]],Increment->incrementPatternValues[[1]],Identifier->CreateUUID[]|>;

	(* Get the missing keys in the association. *)
	missingKeys=Complement[Keys[defaultValues],Keys[myAssociation]];

	(* Fill out the optional keys with default values if they are not specified. *)
	widgetAssociationWithDefaults=Append[myAssociation,(#->defaultValues[#]&)/@missingKeys];

	(* Replace the provided Units key with the expanded version. *)
	widgetAssociationWithExpandedUnits=Append[widgetAssociationWithDefaults,{Units->expandedUnits}];

	(* Add the PatternTooltip to the input association. This function doesn't do anything if the tooltip is already specified in the association. *)
	associationWithPatternTooltip=addPatternTooltip[widgetAssociationWithExpandedUnits];

	(* Return the constructed widget. *)
	Widget[associationWithPatternTooltip]
];

(*
	quantityRange - extract the min,max and increment from a quantity widget pattern (e.g. RangeP[0 Gram,10 Gram])
		Input: heldInequalityPattern - a held Greater/Less/Range pattern
		Output: {min,max,increment}
*)
(* NOTE: We memoize this function because calls to it can add up in SLL loading. *)
quantityRange[heldInequalityPattern_]:=quantityRange[heldInequalityPattern]=Module[
	{heldInequalityPatterns,minimumPatternValues,minimumPatternValuesHandlingInfinity,maximumPatternValues,
	maximumPatternValuesHandlingInfinity,incrementPatternValues,incrementPatternValuesHandlingInfinity},

	(* Extract the minimum value from the pattern. *)
	{minimumPatternValues,maximumPatternValues}=Switch[heldInequalityPattern,
		(* RangeP[minimum,maximum] *)
		Hold[_RangeP],
		{
			Extract[heldInequalityPattern,{1,1}],
			Extract[heldInequalityPattern,{1,2}]
		},

		(* GreaterP[minimum] and GreaterEqualP[minimum] *)
		Hold[_GreaterP]|Hold[_GreaterEqualP],
		{
			Extract[heldInequalityPattern,{1,1}],
			Null
		},

		(* LessP[maximum] and LessEqualP[maximum] *)
		Hold[_LessP]|Hold[_LessEqualP],
		{
			Null,
			Extract[heldInequalityPattern,{1,1}]
		},

		(* Catch All, we should never get here *)
		_,
		Return[$Failed];
	];

	(* Make sure that if our minimum or maximum is set to Infinity, we set it to Null. *)
	{minimumPatternValuesHandlingInfinity, maximumPatternValuesHandlingInfinity}={
		minimumPatternValues, maximumPatternValues
	}/.{Infinity|-Infinity->Null};

	(* Extract the increment value from the pattern. *)
	incrementPatternValues=Switch[heldInequalityPattern,
		(* RangeP[minimum,maximum,increment] *)
		Hold[RangeP[_,_,Except[Inclusive->_]]]|Hold[RangeP[_,_,_,Inclusive->_]],
		Extract[heldInequalityPattern,{1,3}],

		(* GreaterP[minimum,increment] and GreaterEqualP[minimum,increment] *)
		Hold[GreaterP[_,_]]|Hold[GreaterP[_,_,Inclusive->_]]|Hold[GreaterEqualP[_,_]]|Hold[GreaterEqualP[_,_,Inclusive->_]],
		Extract[heldInequalityPattern,{1,2}],

		(* LessP[maximum,increment] and LessEqualP[maximum,increment] *)
		Hold[LessP[_,_]]|Hold[LessP[_,_,Inclusive->_]]|Hold[LessEqualP[_,_]]|Hold[LessEqualP[_,_,Inclusive->_]],
		Extract[heldInequalityPattern,{1,2}],

		(* Otherwise, the increment value isn't provided. *)
		_,
		Null
	];

	(* Make sure that if our minimum is set to Infinity, we set it to Null. *)
	incrementPatternValuesHandlingInfinity=incrementPatternValues/.{Infinity|-Infinity->Null};

	{minimumPatternValuesHandlingInfinity,maximumPatternValuesHandlingInfinity,incrementPatternValuesHandlingInfinity}
];


(* ::Subsubsubsection::Closed:: *)
(*Color*)


Widget::ColorPatternValue="The value for the key Pattern must match Verbatim[ColorP] for the Color widget. Please change the value of this key.";
Widget::ColorInvalidKeys="The Color widget does not take keys `1`. Please remove these keys.";

(* Takes in an association of keys and checks that they can be used to specify an color widget. Autofills the keys that it can based on the given information. Returns a color widget. *)
colorWidget[myAssociation_Association]:=Module[{validKeys,invalidKeys,associationWithPatternTooltip},
	(* Define the valid keys for this widget. *)
	validKeys={Type,Pattern,PatternTooltip,Identifier};

	(* Get the set difference between the valid keys and the keys in the given association. This gives us the invalid keys in the association. *)
	invalidKeys=Complement[Union[validKeys,Keys[myAssociation]],validKeys];

	(* If there are invalid keys, return $Failed. *)
	If[Length[invalidKeys]!=0,
		Message[Widget::ColorInvalidKeys,invalidKeys]; Return[$Failed];
	];

	(* Make sure that the color widget's pattern is specified as Verbatim[ColorP]. *)
	If[!MatchQ[myAssociation[Pattern],Verbatim[ColorP]],
		Message[Widget::ColorPatternValue]; Return[$Failed];
	];

	(* No more checks to perform. Return the widget. *)

	(* Add the PatternTooltip to the input association. This function doesn't do anything if the tooltip is already specified in the association. *)
	associationWithPatternTooltip=addPatternTooltip[myAssociation];

	Widget[Append[associationWithPatternTooltip,Identifier->CreateUUID[]]]
];


(* ::Subsubsubsection::Closed:: *)
(*Date*)


Widget::DatePatternValue="The value for the key Pattern must match Verbatim[_?DateObjectQ] or InequalityP for the Date widget. Please change the value of this key.";
Widget::DateInequalityPatternValue="The value for the key Pattern matches InequalityP but is misspecified and is not evaluating. Please change the value of this key.";
Widget::DateTimeSelectorValue="The value for the key TimeSelector must match BooleanP for the Date widget. Please change the value of this key.";
Widget::DateMissingTimeSelectorKey="The key TimeSelector must be specified to create a Date widget. Please include this key.";
Widget::DateInvalidKeys="The Date widget does not take keys `1`. Please remove these keys.";
Widget::InvalidMinValue="The value for the key Min must match the Pattern key and must be either a DateObject or Null. It is currently `1`. Please change the value of this key.";
Widget::InvalidMaxValue="The value for the key Max must match the Pattern key and must be either a DateObject or Null. It is currently `1`. Please change the value of this key.";
Widget::InvalidIncrementValue="The value for the key Increment must match the Pattern key and must be either a Quantity or Null. It is currently `1`. Please change the value of this key.";

(* Takes in an association of keys and checks that they can be used to specify a date widget. Autofills the keys that it can based on the given information. Returns a date widget. *)
dateWidget[myAssociation_Association]:=Module[
	{validKeys,invalidKeys,heldPattern,minimumPatternValue,maximumPatternValue,incrementPatternValue,
	defaultMinimumValue,defaultMaximumValue,defaultIncrementValue,defaultValues,associationWithPatternTooltip,
	missingKeys,widgetAssociationWithDefaults},

	(* Define the valid keys for this widget. *)
	validKeys={Type,Pattern,TimeSelector,Min,Max,Increment,PatternTooltip,Identifier};

	(* Get the set difference between the valid keys and the keys in the given association. This gives us the invalid keys in the association. *)
	invalidKeys=Complement[Union[validKeys,Keys[myAssociation]],validKeys];

	(* If there are invalid keys, return $Failed. *)
	If[Length[invalidKeys]!=0,
		Message[Widget::DateInvalidKeys,invalidKeys]; Return[$Failed];
	];

	(* Extract the pattern from the association and hold it. *)
	heldPattern=Extract[myAssociation,Key[Pattern],Hold];

	(* Make sure that the pattern matches InequalityP or _?DateObjectQ. AssociationMatchQ has trouble with matching on Alternatives. *)
	If[!MatchQ[heldPattern,Hold[Evaluate[InequalityP]]|Hold[Verbatim[_?DateObjectQ]]],
		Message[Widget::DatePatternValue];
		Return[$Failed];
	];

	(* Make sure that the InequalityP pattern no longer matches the InequalityP heads once evaluated. If it still does, this means the pattern is failing to evaluate and something is wrong. *)
	If[MatchQ[heldPattern,Hold[Evaluate[InequalityP]]]&&MatchQ[ReleaseHold[heldPattern],InequalityP],
		Message[Widget::DateInequalityPatternValue];
		Return[$Failed];
	];

	(* Make sure that TimeSelector is provided. *)
	If[!KeyExistsQ[myAssociation,TimeSelector],
		Message[Widget::DateMissingTimeSelectorKey]; Return[$Failed];
	];

	(* Make sure that TimeSelector matches BooleanP. *)
	If[!MatchQ[myAssociation[TimeSelector], BooleanP],
		Message[Widget::DateTimeSelectorValue]; Return[$Failed];
	];

	(* Make sure that the Min, Max, and Increment values are consistent with the pattern. *)

	(* Extract the minimum value from the pattern. *)
	minimumPatternValue=Switch[heldPattern,
		(* _?DateObjectQ *)
		Hold[Verbatim[_?DateObjectQ]],
			Null,

		(* RangeP[minimum,maximum] *)
		Hold[_RangeP],
			Extract[heldPattern,{1,1}],

		(* GreaterP[minimum] and GreaterEqualP[minimum] *)
		Hold[_GreaterP]|Hold[_GreaterEqualP],
			Extract[heldPattern,{1,1}],

		(* LessP[maximum] and LessEqualP[maximum] *)
		Hold[_LessP]|Hold[_LessEqualP],
			Null,

		(* Catch All, we should never get here *)
		_,
			With[{insertMe=heldPattern},Message[Widget::InvalidMinValue,ToString[HoldForm[insertMe]]]]; Return[$Failed];
	];

	(* Get the default value for the minimum value. *)
	defaultMinimumValue=If[KeyExistsQ[myAssociation,Min],
		myAssociation[Min],
		minimumPatternValue
	];

	(* Extract the maximum value from the pattern. *)
	maximumPatternValue=Switch[heldPattern,
		(* _?DateObjectQ *)
		Hold[Verbatim[_?DateObjectQ]],
			Null,

		(* RangeP[minimum,maximum] *)
		Hold[_RangeP],
			Extract[heldPattern,{1,2}],

		(* GreaterP[minimum] and GreaterEqualP[minimum] *)
		Hold[_GreaterP]|Hold[_GreaterEqualP],
			Null,

		(* LessP[maximum] and LessEqualP[maximum] *)
		Hold[_LessP]|Hold[_LessEqualP],
			Extract[heldPattern,{1,1}],

		(* Catch All, we should never get here *)
		_,
			With[{insertMe=heldPattern},Message[Widget::InvalidMaxValue,ToString[HoldForm[insertMe]]]]; Return[$Failed];
	];

	(* Get the default value for the maximum value. *)
	defaultMaximumValue=If[KeyExistsQ[myAssociation,Max],
		myAssociation[Max],
		maximumPatternValue
	];

	(* Extract the increment value from the pattern. *)
	incrementPatternValue=Switch[heldPattern,
		(* _?DateObjectQ *)
		Hold[Verbatim[_?DateObjectQ]],
			Null,

		(* RangeP[minimum,maximum,increment] *)
		Hold[RangeP[_,_,_]]|Hold[RangeP[_,_,_,Inclusive->_]],
			Extract[heldPattern,{1,3}],

		(* GreaterP[minimum,increment] and GreaterEqualP[minimum,increment] *)
		Hold[GreaterP[_,_]]|Hold[GreaterP[_,_,Inclusive->_]]|Hold[GreaterEqualP[_,_]]|Hold[GreaterEqualP[_,_,Inclusive->_]],
			Extract[heldPattern,{1,2}],

		(* LessP[maximum,increment] and LessEqualP[maximum,increment] *)
		Hold[LessP[_,_]]|Hold[LessP[_,_,Inclusive->_]]|Hold[LessEqualP[_,_]]|Hold[LessEqualP[_,_,Inclusive->_]],
			Extract[heldPattern,{1,2}],

		(* Otherwise, the increment value isn't provided. *)
		_,
			Null
	];

	(* Get the default value for the minimum value. *)
	defaultIncrementValue=If[KeyExistsQ[myAssociation,Increment],
		myAssociation[Increment],
		incrementPatternValue
	];

	(* Make sure that our extracted Min, Max, Increment values match the values given by the keys. *)
	If[!SameQ[minimumPatternValue,defaultMinimumValue]||!MatchQ[defaultMinimumValue,_?DateObjectQ|Null],
		Message[Widget::InvalidMinValue, ToString[defaultMinimumValue]]; Return[$Failed];
	];

	If[!SameQ[maximumPatternValue,defaultMaximumValue]||!MatchQ[defaultMaximumValue,_?DateObjectQ|Null],
		Message[Widget::InvalidMaxValue, ToString[defaultMaximumValue]]; Return[$Failed];
	];

	If[!SameQ[incrementPatternValue,defaultIncrementValue]||!MatchQ[defaultIncrementValue,_Quantity|Null],
		Message[Widget::InvalidIncrementValue, ToString[defaultIncrementValue]]; Return[$Failed];
	];

	(* There are no more checks. Construct the widget. *)

	(* Define the defaults for the optional keys of the field reference widget. *)
	defaultValues=<|Max->defaultMaximumValue,Min->defaultMinimumValue,Increment->defaultIncrementValue,Identifier->CreateUUID[]|>;

	(* Get the missing keys in the association. *)
	missingKeys=Complement[validKeys,Keys[myAssociation]];

	(* Fill out the optional keys with default values if they are not specified. *)
	widgetAssociationWithDefaults=Append[myAssociation,(#->defaultValues[#]&)/@missingKeys];

	(* Add the PatternTooltip to the input association. This function doesn't do anything if the tooltip is already specified in the association. *)
	associationWithPatternTooltip=addPatternTooltip[widgetAssociationWithDefaults];

	Widget[associationWithPatternTooltip]
];


(* ::Subsubsubsection::Closed:: *)
(*String*)


Widget::StringSizeValue="The value for the key Size must match TextBoxSizeP for the String widget. Please change the value of this key.";
Widget::StringBoxTextValue="The value for the key BoxText must match _String|Null for the String widget. Please change the value of this key.";
Widget::StringMissingSizeKey="The key Size must be specified to create a String widget. Please change the value of this key.";
Widget::StringInvalidKeys="The String widget does not take keys `1`. Please remove these keys.";

(* Takes in an association of keys and checks that they can be used to specify a string widget. Autofills the keys that it can based on the given information. Returns a string widget. *)
stringWidget[myAssociation_Association]:=Module[{validKeys,invalidKeys,associationWithPatternTooltip,defaultValues,missingKeys,widgetAssociationWithDefaults},
	(* Define the valid keys for this widget. *)
	validKeys={Type, Pattern, Size, BoxText, PatternTooltip, Identifier};

	(* Get the set difference between the valid keys and the keys in the given association. This gives us the invalid keys in the association. *)
	invalidKeys=Complement[Union[validKeys,Keys[myAssociation]],validKeys];

	(* If there are invalid keys, return $Failed. *)
	If[Length[invalidKeys]!=0,
		Message[Widget::StringInvalidKeys,invalidKeys]; Return[$Failed];
	];

	(* Make sure that Size is provided. *)
	If[!KeyExistsQ[myAssociation,Size],
		Message[Widget::StringMissingSizeKey]; Return[$Failed];
	];

	(* Make sure that Size matches TextBoxSizeP. *)
	If[!MatchQ[myAssociation[Size], TextBoxSizeP],
		Message[Widget::StringSizeValue]; Return[$Failed];
	];

	(* Make sure that BoxText, if specified, matches _String|Null. *)
	If[KeyExistsQ[myAssociation,BoxText]&&!MatchQ[myAssociation[BoxText], _String|Null],
		Message[Widget::StringBoxTextValue]; Return[$Failed];
	];

	(* There are no more checks. Construct the widget. *)

	(* Add the PatternTooltip to the input association. This function doesn't do anything if the tooltip is already specified in the association. *)
	associationWithPatternTooltip=addPatternTooltip[myAssociation];

	(* Define the defaults for the optional keys of the string widget. *)
	defaultValues=<|BoxText->Null,Identifier->CreateUUID[]|>;

	(* Get the missing keys in the association. *)
	missingKeys=Complement[validKeys,Keys[associationWithPatternTooltip]];

	(* Fill out the optional keys with default values if they are not specified. *)
	widgetAssociationWithDefaults=Append[associationWithPatternTooltip,(#->defaultValues[#]&)/@missingKeys];

	(* Return the constructed widget. *)
	Widget[widgetAssociationWithDefaults]
];

(* ::Subsubsubsection::Closed:: *)
(*Molecule*)

Widget::MoleculePatternValue="The value for the key Pattern must match ListableP[_MoleculeP] for the Molecule widget. Please change the value of this key.";
Widget::MoleculeInvalidKeys="The Molecule widget does not take keys `1`. The valid set of keys is {Type, Pattern, PatternTooltip, Identifier}. Please remove these keys.";

moleculeWidget[myAssociation_Association]:=Module[
	{validKeys,invalidKeys,associationWithPatternTooltip},

	(* Define the valid keys for this widget. *)
	validKeys={Type, Pattern, PatternTooltip, Identifier};

	(* Get the set difference between the valid keys and the keys in the given association. This gives us the invalid keys in the association. *)
	invalidKeys=Complement[Keys[myAssociation],validKeys];

	(* If there are invalid keys, return $Failed. *)
	If[Length[invalidKeys]!=0,
		Message[Widget::MoleculeInvalidKeys,invalidKeys]; Return[$Failed];
	];

	(* Make sure that the object widget's pattern matches _MoleculeP. *)
	If[!MatchQ[myAssociation[Pattern], Verbatim[MoleculeP]],
		Message[Widget::MoleculePatternValue]; Return[$Failed];
	];

	(* Add the PatternTooltip to the input association. This function doesn't do anything if the tooltip is already specified in the association. *)
	associationWithPatternTooltip=addPatternTooltip[myAssociation];

	Widget[Append[associationWithPatternTooltip,Identifier->CreateUUID[]]]
];

(* ::Subsubsubsection::Closed:: *)
(*Object*)


(* Create an association of the Object[Catalog, ID]\[Rule]packet and Object[Catalog,Name]\[Rule]packet. Memoize this function so it is fast on subsequent calls. *)

downloadCatalogObjects[memoizationString_]:=Module[{myCatalogAssociation},
	(* Check to see if we're logged in. If we're logged in, download all of the catalogs and cache them. *)
	If[!MatchQ[$PersonID,ObjectP[Object[User]]],
		(* We are not logged in. Return $Failed. *)
		$Failed,

		(* add this function as memoized *)
		If[!MemberQ[$Memoization, downloadCatalogObjects],
			AppendTo[$Memoization, downloadCatalogObjects]
		];

		(* Otherwise, we are logged in. Download all of the catalogs and create an association. *)
		myCatalogAssociation=Association[
			(
				Sequence@@{
					Object[Catalog,#[ID]]->#,
					Object[Catalog,#[Name]]->#,
					#[Folder]->#
				}
			&)/@Download[Search[Object[Catalog]]]
		];

		(* Cache our created association. *)
		downloadCatalogObjects["Memoization"]=myCatalogAssociation;

		(* Return the association. *)
		myCatalogAssociation
	]
];


Widget::ObjectPatternValue="The value for the key Pattern must match Hold[_ObjectP]|Hold[ListableP[_ObjectP]] for the Object widget. Please change the value of this key.";
Widget::ObjectObjectTypesValue="The value for the key ObjectTypes must match {TypeP[]...} for the Object widget. Please change the value of this key.";
Widget::ObjectObjectBuildersValue="The value for the key ObjectBuilderFunctions must match {_Symbol...} for the Object widget. Please change the value of this key.";
Widget::ObjectInvalidKeys="The Object widget does not take keys `1`. The valid set of keys is {Type, Pattern, ObjectTypes, ContainersToSamples, ObjectBuilderFunctions}. Please remove these keys.";
Widget::ObjectInvalidDereferencePattern="The Object widget's field Dereference does not match its basic pattern of {((_Object|_Model)\[Rule]_Field)...}. Please change the value of `1`.";
Widget::ObjectOpenPathsValue="The value for the key OpenPaths must match {{ObjectP[Object[Catalog]]..}...} for the Object widget. Please change the value of this key.";
Widget::ObjectOpenPathsContents="The child `1` is not located in the contents field of the parent `2`. Please change the value of the OpenPaths key.";
Widget::ObjectOpenPathRoot="The OpenPath does not begin with the Root catalog object. All OpenPaths must start with Object[Catalog,\"Root\"]. Please change the value of the OpenPaths key.";

(* Takes in an association of keys and checks that they can be used to specify an object widget. Autofills the keys that it can based on the given information. Returns an object widget. *)
objectWidget[myAssociation_Association]:=Module[
	{validKeys,invalidKeys,defaultObjectTypesRaw,defaultObjectTypes,defaultValues,defaultContainersToSamplesValue,
	missingKeys,widgetAssociationWithDefaults,objectBuilders,objectBuilderTypes,defaultObjectBuilderTypes,
	defaultObjectBuilderFunctions,containsOnlyVessel,catalogObjects,openPathsBooleans,associationWithPatternTooltip,
	defaultPreparedSample,defaultPreparedContainer,associationWithPreparedPattern},

	(* Define the valid keys for this widget. *)
	validKeys={Type, Pattern, ObjectTypes, ObjectBuilderFunctions, Dereference, OpenPaths, Select, PatternTooltip, Identifier, PreparedSample, PreparedContainer};

	(* Get the set difference between the valid keys and the keys in the given association. This gives us the invalid keys in the association. *)
	invalidKeys=Complement[Keys[myAssociation],validKeys];

	(* If there are invalid keys, return $Failed. *)
	If[Length[invalidKeys]!=0,
		Message[Widget::ObjectInvalidKeys,invalidKeys]; Return[$Failed];
	];

	(* Make sure that the object widget's pattern matches _ObjectP. *)
	If[!MatchQ[
			Extract[myAssociation,Key[Pattern],Hold],
			Alternatives[
				Hold[_ObjectP],
				Hold[ListableP[_ObjectP]],
				Hold[Verbatim[Alternatives][Verbatim[ObjectP][_],Verbatim[_String]]],
				Hold[Verbatim[ListableP][Verbatim[Alternatives][Verbatim[ObjectP][_],Verbatim[_String]]]]
			]
		],
		Message[Widget::ObjectPatternValue]; Return[$Failed];
	];

	(* Make sure that Dereference, if it is specified, is of a valid format. *)
	If[KeyExistsQ[myAssociation,Dereference],
		(* If the Dereference key doesn't match its basic pattern, return $Failed. *)
		If[!MatchQ[myAssociation[Dereference],{((_Object|_Model)->_Field)...}],
			Message[Widget::ObjectInvalidDereferencePattern,myAssociation[Dereference]]; Return[$Failed];
		];
	];

	(* Resolve objectTypes. If the ObjectTypes key isn't provided, parse it out of the pattern. *)
	defaultObjectTypesRaw=If[!KeyExistsQ[myAssociation,ObjectTypes],
		(* The ObjectTypes key doesn't exist. *)
		(* First, see if our pattern is ObjectP[] or ListableP[ObjectP[]]. *)
		If[MatchQ[Extract[myAssociation,Key[Pattern],Hold],Hold[ObjectP[]]]||MatchQ[Extract[myAssociation,Key[Pattern],Hold],Hold[ListableP[ObjectP[]]]],
			(* Return Types[] since no Objects were given. *)
			Types[],
			(* Types must be given inside of the ObjectP[]. Extract them. *)
			(* Figure out if our pattern is ObjectP[...] or ListableP[ObjectP[..]]. *)
			If[MatchQ[Extract[myAssociation,Key[Pattern],Hold],Hold[_ObjectP]],
				(* Our pattern is ObjectP[...]. *)
				Extract[
					Extract[myAssociation,Key[Pattern],Hold],
					{1,1}
				],
				(* Otherwise, our pattern is ListableP[ObjectP[...]]. *)
				Extract[
					Extract[myAssociation,Key[Pattern],Hold],
					{1,1,1}
				]
			]
		],
		myAssociation[ObjectTypes]
	];

	(* Use our default object types if the ObjectTypes key is not specified. *)
	defaultObjectTypes=If[SameQ[Lookup[myAssociation,ObjectTypes,Null],Null],
		(* The ObjectTypes key is not specified. *)
		(* Make sure that defaultObjectTypesRaw matches _List. If not, wrap it in a list head. (It is possible to have a single ObjectType). *)
		ToList[defaultObjectTypesRaw],
		(* Otherwise, simply use the specified key. *)
		ToList[Lookup[myAssociation,ObjectTypes]]
	];

	(* Make sure that ObjectTypes matches {TypeP[]...}. *)
	If[!ContainsAll[Types[],defaultObjectTypes],
		Message[Widget::ObjectObjectTypesValue]; Return[$Failed];
	];

	(* Resolve the default value of ContainersToSamples. *)
	(* ContainersToSamples will always default to False since we are sunsetting it. *)
	defaultContainersToSamplesValue=MatchQ[Extract[myAssociation,Key[Pattern],Hold],Hold[ListableP[_ObjectP]]];

	(* Compute the default value for ObjectBuilders. *)
	(* $ObjectBuilders is in the form <|Type\[Rule]UploadFunctionForType,...|>. Get the Types. *)
	objectBuilderTypes=Keys[$ObjectBuilders];

	(* Get the object builder types that show up in our Object widget. *)
	defaultObjectBuilderTypes=(If[Length[Intersection[Types[#],defaultObjectTypes]]>0,
		#,
		Nothing
	]&)/@objectBuilderTypes;

	(* Pull out the function names for these object builders. *)
	defaultObjectBuilderFunctions=($ObjectBuilders[#]&)/@defaultObjectBuilderTypes;

	(* Resolve ObjectBuilders. If the ObjectBuilderFunctions key isn't provided, default it to functions that we calculated above. *)
	objectBuilders=Lookup[myAssociation,ObjectBuilderFunctions,defaultObjectBuilderFunctions];

	(* Make sure that ObjectBuilderFunctions matches {_Symbol..}. *)
	If[!MatchQ[objectBuilders,{_Symbol...}],
		Message[Widget::ObjectObjectBuildersValue]; Return[$Failed];
	];

	(* Make sure that our specified OpenPaths is valid. *)
	If[!MatchQ[Lookup[myAssociation,OpenPaths,Null],Null|{}],
		(* OpenPath was specified, make sure that it is valid. *)
		(* OpenPath should match {{_String..}...} *)
		If[!MatchQ[Lookup[myAssociation,OpenPaths,Null],{{(ObjectP[Object[Catalog]]|_String)..}...}],
			Message[Widget::ObjectOpenPathsValue]; Return[$Failed];
		];

		(* Deeply check validity by downloading all catalog objects. *)
		catalogObjects=downloadCatalogObjects["Memoization"];

		(* If we are not logged in, we cannot download the catalog objects and therefore cannot check the validity of the open paths. *)
		If[MatchQ[catalogObjects, _Association],
			(* For each OpenPath, make sure that the proceeding path is contained within the Contents of the parent Catalog. *)
			openPathsBooleans=Function[{currentOpenPath},
				(* First, make sure that the first member of our OpenPath is the root catalog. *)
				If[!MatchQ[
						First[currentOpenPath],
						"Root"|"Public Objects"|Object[Catalog,catalogObjects["Public Objects"][ID]]|Object[Catalog,"Root"]
					],
					Message[Widget::ObjectOpenPathRoot];
					(* Return False *)
					False,

					(* Otherwise, our open path is okay, make sure it's valid. *)
					Module[{previousCatalogObject,isInContentsBooleans,contentsInformation},
						(* Define a variable that stores the previous Catalog ID. *)
						previousCatalogObject=Object[Catalog,"Root"];

						(* For each open path, make sure that it exists in the previous catalog object. *)
						isInContentsBooleans=Function[{currentCatalog},
							(* If our previous catalog object is set to Null, there was a failure upstream, return False. *)
							If[SameQ[previousCatalogObject,Null],
								False,

								(* Get all of the information for the catalogs in the contents. *)
								(* Create a map from Folder\[Rule]Object ID *)

								contentsInformation=Quiet@Association@(Function[{catalogLink},
									Module[{object},
										(* Convert the link into an object. *)
										object=catalogLink/.Link[x_,__]:>x;

										(* Return Folder\[Rule]Object ID *)
										Lookup[catalogObjects, object][Folder]->object
									]
								]/@Download[Lookup[catalogObjects, previousCatalogObject], Contents]);

								(* Are we given an Object ID or a folder name? *)
								If[MatchQ[currentCatalog,_String] && MatchQ[contentsInformation, _Association],
									(* We were given a folder name. *)
									(* Make sure it exists in the keys of our created map. *)
									If[!MemberQ[Keys[contentsInformation],currentCatalog],
										Message[Widget::ObjectOpenPathsContents,currentCatalog,previousCatalogObject];
										(* Set our previous catalog to be Null and return false. *)
										previousCatalogObject=Null;
										False,

										(* Otherwise, set our next catalog appropriately and return True. *)
										previousCatalogObject=contentsInformation[currentCatalog];
										True
								],

									(* We were given an object ID. *)
									(* Make sure it exists in the values of our created map. *)
									If[!MemberQ[Values[contentsInformation],currentCatalog],
										Message[Widget::ObjectOpenPathsContents,currentCatalog,previousCatalogObject];
										(* Set our previous catalog to be Null and return false. *)
										previousCatalogObject=Null;
										False,

										(* Otherwise, set our next catalog appropriately and return True. *)
										previousCatalogObject=currentCatalog;
										True
									]
								]
							]
						]/@Rest[currentOpenPath];

						(* Perform an And on these booleans *)
						And@@isInContentsBooleans
					]
				]
			]/@Lookup[myAssociation,OpenPaths,Null];

			(* If not all of the paths are valid, return $Failed *)
			If[!And@@openPathsBooleans,
				Return[$Failed];
			];
		]
	];
	(* There are no more checks. Construct the widget. *)

	(* Default PreparedSample to True if the user didn't specify PreparedContainer\[Rule]False and if we can select an Object[Sample] or one of its subtypes in the ObjecTypes key. *)
	defaultPreparedSample=Which[
		KeyExistsQ[myAssociation, PreparedSample],
			Lookup[myAssociation, PreparedSample],
		!MatchQ[Lookup[myAssociation,PreparedContainer,True],False]&&MemberQ[defaultObjectTypes,Alternatives@@Types[{Object[Sample]}]],
			True,
		True,
			False
	];

	(* Default PreparedContainer to True if the user didn't specify PreparedSample\[Rule]False and if we can select an Object[Container] or one of its subtypes in the ObjecTypes key. *)
	defaultPreparedContainer=Which[
		KeyExistsQ[myAssociation, PreparedContainer],
			Lookup[myAssociation, PreparedContainer],
		!MatchQ[Lookup[myAssociation,PreparedSample,True],False]&&MemberQ[defaultObjectTypes,Alternatives@@Types[{Object[Container]}]],
			True,
		True,
			False
	];

	(* Define the defaults for the optional keys of the field reference widget. *)
	defaultValues=<|ObjectTypes->defaultObjectTypes,ObjectBuilderFunctions->objectBuilders,Dereference->{},Identifier->CreateUUID[], OpenPaths->{}, Select->Null, PreparedSample->defaultPreparedSample, PreparedContainer->defaultPreparedContainer|>;

	(* Get the missing keys in the association. *)
	missingKeys=Complement[validKeys,Keys[myAssociation]];

	(* Fill out the optional keys with default values if they are not specified. *)
	widgetAssociationWithDefaults=Append[myAssociation,(#->defaultValues[#]&)/@missingKeys];

	(* Add the PatternTooltip to the input association. This function doesn't do anything if the tooltip is already specified in the association. *)
	associationWithPatternTooltip=addPatternTooltip[widgetAssociationWithDefaults];

	(* If PreparedSample or PreparedContainer are True, then append _String to our pattern. *)
	(* Patterns for object widgets are enforced to match ObjectP[...] so the developer has no way of adding this - it's simply a hidden backend thing. *)
	associationWithPreparedPattern=If[defaultPreparedSample||defaultPreparedContainer,
		(* Overwrite the existing Pattern key in the association. *)
		Append[
			associationWithPatternTooltip,
			(* Add Alternatives of _String to the Pattern RuleDelayed. *)
			(* Note: We need to use With[...] when calling holdCompositionList since it is Attribute HoldAll. *)
			With[{updatedPattern=With[{heldPattern=Extract[associationWithPatternTooltip,Key[Pattern],Hold]},holdCompositionList[Alternatives,{heldPattern,Hold[_String]}]]},
				(* Then, put it in RuleDelayed form. *)
				ReleaseHold[
					holdCompositionList[
						RuleDelayed,
						{
							Hold[Pattern],
							updatedPattern
						}
					]
				]
			]
		],
		associationWithPatternTooltip
	];

	(* Return the constructed widget. *)
	Widget[associationWithPreparedPattern]
];


(* ::Subsubsubsection::Closed:: *)
(*FieldReference*)


Widget::FieldReferencePatternValue="The value for the key Pattern must match _FieldReferenceP for the Field Reference widget. Please change the value of this key.";
Widget::FieldReferenceFieldsValue="The value for the key Fields must match {FieldP[ObjectTypes, Output\[Rule]Short]..} for the Field Reference widget. Please change the value of this key.";
Widget::FieldReferenceInvalidKeys="The Field Reference widget does not take keys `1`. Please remove these keys.";
Widget::FieldReferenceObjectTypesValue="The value for the key ObjectTypes does not match {TypeP[]..}. Please change the value of this key.";

(* Takes in an association of keys and checks that they can be used to specify a field reference widget. Autofills the keys that it can based on the given information. Returns a field reference widget. *)
fieldReferenceWidget[myAssociation_Association]:=Module[
	{validKeys,invalidKeys,defaultFieldsValue,defaultValues,missingKeys,widgetAssociationWithDefaults,
	defaultObjectTypes,objectBuilderTypes,defaultObjectBuilderTypes,defaultObjectBuilderFunctionsm,
	defaultObjectBuilderFunctions,objectBuilders,defaultFields,associationWithPatternTooltip},

	(* Define the valid keys for this widget. *)
	validKeys={Type,Pattern,ObjectTypes,Fields,ObjectBuilderFunctions,PatternTooltip,Identifier};

	(* Get the set difference between the valid keys and the keys in the given association. This gives us the invalid keys in the association. *)
	invalidKeys=Complement[Union[validKeys,Keys[myAssociation]],validKeys];

	(* If there are invalid keys, return $Failed. *)
	If[Length[invalidKeys]!=0,
		Message[Widget::FieldReferenceInvalidKeys,invalidKeys]; Return[$Failed];
	];

	(* Make sure that the field reference widget's pattern matches _FieldReferenceP. *)
	If[!MatchQ[Extract[myAssociation,Key[Pattern],Hold],Hold[_FieldReferenceP]],
		Message[Widget::FieldReferencePatternValue]; Return[$Failed];
	];

	(* Make sure that ObjectTypes, if provided, matches {TypeP[]..}. *)
	If[KeyExistsQ[myAssociation,ObjectTypes]&&!MatchQ[myAssociation[ObjectTypes], {TypeP[]..}],
		Message[Widget::FieldReferenceObjectTypesValue]; Return[$Failed];
	];

	(* Make sure that Fields, if provided, matches {FieldP[myAssociation[ObjectTypes], Output\[Rule]Short]..}. *)
	If[KeyExistsQ[myAssociation,Fields]&&!ContainsAll[Fields[myAssociation[ObjectTypes], Output->Short],ToList[myAssociation[Fields]]],
		Message[Widget::FieldReferenceFieldsValue]; Return[$Failed];
	];

	(* Calculate the default value of ObjectTypes. *)
	defaultObjectTypes=If[!KeyExistsQ[myAssociation,ObjectTypes],
		(* There is no ObjectTypes key in this association. Try to look it up from the pattern. *)
		Switch[Extract[myAssociation,Key[Pattern],Hold],
			(* If we match Hold[FieldReferenceP[]], return all objects. *)
			Hold[FieldReferenceP[]],
				Types[],
			(* If we match Hold[FieldReferenceP[_]]|Hold[FieldReferenceP[_,_]], take that one type. *)
			Hold[FieldReferenceP[_]]|Hold[FieldReferenceP[_,_]],
				ToList[Extract[Extract[myAssociation,Key[Pattern],Hold],{1,1}]],
			_,
				Message[Widget::FieldReferencePatternValue]; Return[$Failed];
		],
		(* There is an ObjectTypes key in this association. Simply return that key's value. *)
		myAssociation[ObjectTypes]
	];

	(* Compute the default value for ObjectBuilderFunctions. *)
	(* $ObjectBuilders is in the form <|Type\[Rule]UploadFunctionForType,...|>. Get the Types. *)
	objectBuilderTypes=Keys[$ObjectBuilders];

	(* Get the object builder types that show up in our FieldReference widget. *)
	defaultObjectBuilderTypes=(If[Length[Intersection[Types[#],defaultObjectTypes]]>0,
		#,
		Nothing
	]&)/@objectBuilderTypes;

	(* Pull out the function names for these object builders. *)
	defaultObjectBuilderFunctions=($ObjectBuilders[#]&)/@defaultObjectBuilderTypes;

	(* Resolve ObjectBuilders. If the ObjectBuilders key isn't provided, default it to functions that we calculated above. *)
	objectBuilders=Lookup[myAssociation,ObjectBuilderFunctions,defaultObjectBuilderFunctions];

	(* Make sure that ObjectBuilders matches {_Symbol..}. *)
	If[!MatchQ[objectBuilders,{_Symbol...}],
		Message[Widget::ObjectObjectBuildersValue]; Return[$Failed];
	];

	(* Calculate the default fields. *)
	defaultFields=If[!KeyExistsQ[myAssociation,Fields],
		(* Extract the valid fields from the pattern *)
		Switch[Extract[myAssociation,Key[Pattern],Hold],
			(* If we match Hold[FieldReferenceP[]], return all objects. *)
			Hold[FieldReferenceP[]]|Hold[FieldReferenceP[_]],
				Fields[defaultObjectTypes,Output->Short],
			(* If we match Hold[FieldReferenceP[_,_]], take that one type. *)
			Hold[FieldReferenceP[_,_]],
				ToList[Extract[Extract[myAssociation,Key[Pattern],Hold],{1,2}]],
			_,
				Message[Widget::FieldReferencePatternValue]; Return[$Failed];
		],
		myAssociation[Fields]
	];

	(* There are no more checks. Construct the widget. *)

	(* Define the defaults for the optional keys of the field reference widget. *)
	defaultValues=<|ObjectTypes->defaultObjectTypes,Fields->defaultFields,ObjectBuilderFunctions->objectBuilders,Identifier->CreateUUID[]|>;

	(* Get the missing keys in the association. *)
	missingKeys=Complement[validKeys,Keys[myAssociation]];

	(* Fill out the optional keys with default values if they are not specified. *)
	widgetAssociationWithDefaults=Append[myAssociation,(#->defaultValues[#]&)/@missingKeys];

	(* Add the PatternTooltip to the input association. This function doesn't do anything if the tooltip is already specified in the association. *)
	associationWithPatternTooltip=addPatternTooltip[widgetAssociationWithDefaults];

	(* Return the constructed widget. *)
	Widget[associationWithPatternTooltip]
];

(* ::Subsubsubsection::Closed:: *)
(*UnitOperationMethod*)

Widget::UnitOperationMethodInvalidKeys="The UnitOperationMethod widget does not take keys `1`. Please remove these keys.";
Widget::UnitOperationMethodMethodsKeyRequired="The Methods key is required to construct a UnitOperationMethod widget. Please provide this key.";
Widget::UnitOperationMethodWidgetKeyRequired="The Widget key is required to construct a UnitOperationMethod widget. The Widget key must match WidgetP. Please provide this key.";

(* Takes in an association of keys and checks that they can be used to specify a primitive widget. Autofills the keys that it can based on the given information. Returns a primitive widget. *)
unitOperationMethodWidget[myAssociation_Association]:=Module[
	{validKeys,invalidKeys,primitiveSetInformation,allPrimitivesInformation,autoFilledWidget,associationWithPatternTooltip,heldPrimitiveSetPattern},

	(* Define the valid keys for this widget. *)
	(* NOTE: PrimitiveKeyValuePairs going to be deprecated in favor of PrimitiveMethods/PrimitiveOptionDefinitions/PrimitiveDescriptions/PrimitiveCategories. *)
	validKeys={Type, Pattern, Methods, Widget, PatternTooltip, Identifier};

	(* Get the set difference between the valid keys and the keys in the given association. This gives us the invalid keys in the association. *)
	invalidKeys=Complement[Union[validKeys,Keys[myAssociation]],validKeys];

	(* If there are invalid keys, return $Failed. *)
	If[Length[invalidKeys]!=0,
		Message[Widget::UnitOperationMethodInvalidKeys,invalidKeys]; Return[$Failed];
	];

	If[!KeyExistsQ[myAssociation,Methods],
		Message[Widget::UnitOperationMethodMethodsKeyRequired];
		Return[$Failed];
	];

	If[!KeyExistsQ[myAssociation,Widget] || !MatchQ[myAssociation[Widget], _Widget],
		Message[Widget::UnitOperationMethodWidgetKeyRequired];
		Return[$Failed];
	];

	(* There are no more checks. Construct the widget. *)

	(* Autofill out the rest of the missing options in the widget -- either using the new way if we were given a primitive *)
	(* set, or via the old way if we were given PrimitiveKeyValuePairs. *)
	autoFilledWidget=Module[{defaultValues, missingKeys},
		(* Define the defaults for the optional keys of the primitive widget. *)
		defaultValues=<|
			Identifier->CreateUUID[]
		|>;

		(* Get the missing keys in the association. *)
		missingKeys=Complement[validKeys,Keys[myAssociation]];

		(* Fill out the optional keys with default values if they are not specified. *)
		Append[myAssociation,(#->defaultValues[#]&)/@missingKeys]
	];

	(* Add the PatternTooltip to the input association. This function doesn't do anything if the tooltip is already specified in the association. *)
	associationWithPatternTooltip=addPatternTooltip[autoFilledWidget];

	(* Return the constructed widget. *)
	Widget[associationWithPatternTooltip]
];

(* ::Subsubsubsection::Closed:: *)
(*UnitOperation*)

Widget::UnitOperationInvalidKeys="The UnitOperation widget does not take keys `1`. Please remove these keys.";

(* Takes in an association of keys and checks that they can be used to specify a primitive widget. Autofills the keys that it can based on the given information. Returns a primitive widget. *)
unitOperationWidget[myAssociation_Association]:=Module[
	{validKeys,invalidKeys,autoFilledWidget,associationWithPatternTooltip},

	(* Define the valid keys for this widget. *)
	(* NOTE: PrimitiveKeyValuePairs going to be deprecated in favor of PrimitiveMethods/PrimitiveOptionDefinitions/PrimitiveDescriptions/PrimitiveCategories. *)
	validKeys={Type, Pattern, PatternTooltip, Identifier};

	(* Get the set difference between the valid keys and the keys in the given association. This gives us the invalid keys in the association. *)
	invalidKeys=Complement[Union[validKeys,Keys[myAssociation]],validKeys];

	(* If there are invalid keys, return $Failed. *)
	If[Length[invalidKeys]!=0,
		Message[Widget::UnitOperationInvalidKeys,invalidKeys]; Return[$Failed];
	];

	(* There are no more checks. Construct the widget. *)

	(* Autofill out the rest of the missing options in the widget -- either using the new way if we were given a primitive *)
	(* set, or via the old way if we were given PrimitiveKeyValuePairs. *)
	autoFilledWidget=Module[{defaultValues, missingKeys},
		(* Define the defaults for the optional keys of the primitive widget. *)
		defaultValues=<|
			Identifier->CreateUUID[]
		|>;

		(* Get the missing keys in the association. *)
		missingKeys=Complement[validKeys,Keys[myAssociation]];

		(* Fill out the optional keys with default values if they are not specified. *)
		Append[myAssociation,(#->defaultValues[#]&)/@missingKeys]
	];

	(* Add the PatternTooltip to the input association. This function doesn't do anything if the tooltip is already specified in the association. *)
	associationWithPatternTooltip=addPatternTooltip[autoFilledWidget];

	(* Return the constructed widget. *)
	Widget[associationWithPatternTooltip]
];

(* ::Subsubsubsection::Closed:: *)
(*Primitive*)


Widget::PrimitivePrimitiveTypesValue="The value for the key PrimitiveTypes must match {_Symbol..} for the Primitive widget. Please change the value of this key.";
Widget::PrimitivePrimitiveKeyValuePairsValue="The value for the key PrimitiveKeyValuePairs must match {(_Symbol\[Rule]{((_Symbol|Verbatim[Optional][_Symbol])\[Rule]WidgetP)..})..} for the Primitive widget. Please change the value of this key.";
Widget::PrimitivePrimitiveKeyValuePairsPrimitiveSet="The key PrimitiveKeyValuePairs must be specified to create a Primitive widget if the pattern given is not a primitive set pattern registered by calling DefinePrimitiveSet[...]. Conversely, if a pattern is given that was registered via DefinePrimitiveSet[...], the PrimitiveKeyValuePairs option cannot be specified. The PrimitiveKeyValuePairs option is deprecated in favor of using DefinePrimitiveSet[...]. Please include/exclude this key or ensure that the pattern given to the widget was created by calling DefinePrimitiveSet[...].";
Widget::PrimitiveInvalidKeys="The Primitive widget does not take keys `1`. Please remove these keys.";
Widget::PrimitiveMissingPrimitiveKeyValuePairsKey="The Primitive widget was unable to find information for the given primitive set pattern in the global $PrimitiveSetPrimitiveLookup. Please ensure that DefinePrimitiveSet[...] has been called for your primitive set pattern.";

(* Takes in an association of keys and checks that they can be used to specify a primitive widget. Autofills the keys that it can based on the given information. Returns a primitive widget. *)
primitiveWidget[myAssociation_Association]:=Module[
	{validKeys,invalidKeys,primitiveSetInformation,allPrimitivesInformation,autoFilledWidget,associationWithPatternTooltip},

	(* Define the valid keys for this widget. *)
	(* NOTE: PrimitiveKeyValuePairs going to be deprecated in favor of PrimitiveMethods/PrimitiveOptionDefinitions/PrimitiveDescriptions/PrimitiveCategories. *)
	validKeys={Type, Pattern, PrimitiveTypes, PrimitiveKeyValuePairs, PatternTooltip, Identifier};

	(* Get the set difference between the valid keys and the keys in the given association. This gives us the invalid keys in the association. *)
	invalidKeys=Complement[Union[validKeys,Keys[myAssociation]],validKeys];

	(* If there are invalid keys, return $Failed. *)
	If[Length[invalidKeys]!=0,
		Message[Widget::PrimitiveInvalidKeys,invalidKeys]; Return[$Failed];
	];

	(* Make sure that PrimitiveKeyValuePairs is matches {(_Symbol\[Rule]{((_Symbol|Verbatim[Optional][_Symbol])\[Rule]WidgetP)..})..}. *)
	If[KeyExistsQ[myAssociation,PrimitiveKeyValuePairs]&&!MatchQ[myAssociation[PrimitiveKeyValuePairs], {(_Symbol->{((_Symbol|Verbatim[Optional][_Symbol])->WidgetP)..})..}],
		Message[Widget::PrimitivePrimitiveKeyValuePairsValue]; Return[$Failed];
	];

	(* Make sure that PrimitiveTypes, if specified, matches {_Symbol..}. *)
	If[KeyExistsQ[myAssociation,PrimitiveTypes]&&!MatchQ[myAssociation[PrimitiveTypes], {_Symbol..}],
		Message[Widget::PrimitivePrimitiveTypesValue]; Return[$Failed];
	];

	(* Try to lookup the backend information about the given pattern from the primitive set lookup. *)
	(* If we weren't given the PrimitiveKeyValuePairs option, we MUST be able to find information from this lookup. *)
	(* NOTE: The keys in $PrimitiveSetPrimitiveLookup are the held version of the primitive set pattern. *)
	primitiveSetInformation=Lookup[$PrimitiveSetPrimitiveLookup, Extract[myAssociation,Key[Pattern],Hold], {}];

	allPrimitivesInformation=Lookup[primitiveSetInformation, Primitives, {}];

	(* EITHER a primitive set can be given OR primitive key value pairs can be given (the old way). *)
	If[(MatchQ[allPrimitivesInformation, {}] && !KeyExistsQ[myAssociation,PrimitiveKeyValuePairs])||(MatchQ[primitiveSetInformation, Except[{}]] && KeyExistsQ[myAssociation,PrimitiveKeyValuePairs]),
		Message[Widget::PrimitiveMissingPrimitiveKeyValuePairsKey]; Return[$Failed];
	];

	(* There are no more checks. Construct the widget. *)

	(* Autofill out the rest of the missing options in the widget -- either using the new way if we were given a primitive *)
	(* set, or via the old way if we were given PrimitiveKeyValuePairs. *)
	autoFilledWidget=Module[{defaultValues, missingKeys},
		(* Define the defaults for the optional keys of the primitive widget. *)
		defaultValues=<|
			PrimitiveTypes->Keys[allPrimitivesInformation],

			PrimitiveKeyValuePairs->Map[
				Function[{primitiveInformation},
					Lookup[primitiveInformation, PrimitiveHead]->Map[
						Function[{optionDefinition},
							If[MemberQ[Lookup[primitiveInformation, InputOptions], Lookup[optionDefinition, "OptionSymbol"]],
								Lookup[optionDefinition, "OptionSymbol"]->Lookup[optionDefinition, "Widget"],
								Optional[Lookup[optionDefinition, "OptionSymbol"]]->Lookup[optionDefinition, "Widget"]
							]
						],
						Lookup[primitiveInformation, OptionDefinition]
					]
				],
				Values[allPrimitivesInformation]
			],
			Identifier->CreateUUID[]
		|>;

		(* Get the missing keys in the association. *)
		missingKeys=Complement[validKeys,Keys[myAssociation]];

		(* Fill out the optional keys with default values if they are not specified. *)
		Append[myAssociation,(#->defaultValues[#]&)/@missingKeys]
	];

	(* Add the PatternTooltip to the input association. This function doesn't do anything if the tooltip is already specified in the association. *)
	associationWithPatternTooltip=addPatternTooltip[autoFilledWidget];

	(* Return the constructed widget. *)
	Widget[associationWithPatternTooltip]
];


(* ::Subsubsubsection::Closed:: *)
(*MultiSelect*)


Widget::MultiSelectPatternValue="The value for the key Pattern must match DuplicateFreeListableP[_Alternatives] for the MultiSelect widget. Please change the value of this key.";
Widget::MultiSelectItemsValue="The value for the key Items must be consistent with the given Pattern. The Pattern should match DuplicateFreeListableP[Alternatives@@Items]. Please change the value of this key.";
Widget::MultiSelectInvalidKeys="The MultiSelect widget does not take keys `1`. Please remove these keys.";

(* Takes in an association of keys and checks that they can be used to specify a MultiSelect widget. Autofills the keys that it can based on the given information. Returns a MultiSelect widget. *)
multiSelectWidget[myAssociation_Association]:=Module[
	{validKeys,invalidKeys,heldPattern,heldPatternExpanded,multiSelectList,defaultValues,missingKeys,associationWithPatternTooltip,widgetAssociationWithDefaults},

	(* Define the valid keys for this widget. *)
	validKeys={Type, Pattern, Items, PatternTooltip, Identifier};

	(* Get the set difference between the valid keys and the keys in the given association. This gives us the invalid keys in the association. *)
	invalidKeys=Complement[Union[validKeys,Keys[myAssociation]],validKeys];

	(* If there are invalid keys, return $Failed. *)
	If[Length[invalidKeys]!=0,
		Message[Widget::MultiSelectInvalidKeys,invalidKeys]; Return[$Failed];
	];

	(* Pull out the pattern and hold it. *)
	heldPattern=Extract[myAssociation,Key[Pattern],Hold];

	(* If the pattern doesn't yet match Hold[Verbatim[DuplicateFreeListableP][Verbatim[Alternatives][x__]]], evaluate the symbol inside of the hold. *)
	(* This is because we could have something like a=1|2|3|4; Pattern\[RuleDelayed]DuplicateFreeListableP[a] *)
	heldPatternExpanded=If[!MatchQ[heldPattern,Hold[Verbatim[DuplicateFreeListableP][Verbatim[Alternatives][x__]]]],
		With[{insertMe=Extract[myAssociation/.{DuplicateFreeListableP->Identity},Key[Pattern]]},Hold[insertMe]],
		heldPattern
	];

	(* The pattern is in the form DuplicateFreeListableP[_Alternatives]. Extract the Alternatives from the DuplicateFreeListableP and use that to create the PatternTooltip. *)
	multiSelectList=ReleaseHold[heldPatternExpanded/.{Hold[DuplicateFreeListableP[Verbatim[Alternatives][x__]]]:>{x}, Alternatives->List}];

	(* Make sure that the MultiSelect widget's pattern is specified as an alternatives. *)
	If[!MatchQ[heldPattern,Hold[DuplicateFreeListableP[_Alternatives]]] && !MatchQ[heldPatternExpanded, Hold[_Alternatives]],
		Message[Widget::MultiSelectPatternValue]; Return[$Failed];
	];

	(* Make sure that if the items are specified, it matches the pattern. *)
	If[KeyExistsQ[myAssociation,Items]&&!MatchQ[myAssociation[Pattern],Verbatim[Evaluate[ListableP[Alternatives@@myAssociation[Items]]]]],
		Message[Widget::MultiSelectItemsValue]; Return[$Failed];
	];

	(* No more checks to perform. Construct the widget. *)

	(* Add the PatternTooltip to the input association. This function doesn't do anything if the tooltip is already specified in the association. *)
	associationWithPatternTooltip=addPatternTooltip[myAssociation];

	(* Define the defaults for the optional keys of the number widget. *)
	defaultValues=<|Items->multiSelectList,Identifier->CreateUUID[]|>;

	(* Get the missing keys in the association. *)
	missingKeys=Complement[Keys[defaultValues],Keys[associationWithPatternTooltip]];

	(* Fill out the optional keys with default values if they are not specified. *)
	widgetAssociationWithDefaults=Append[associationWithPatternTooltip,(#->defaultValues[#]&)/@missingKeys];

	(* Return the widget. *)
	Widget[widgetAssociationWithDefaults]
];


(* ::Subsubsubsection::Closed:: *)
(*Expression*)


Widget::ExpressionMissingSizeKey="The key Size must be specified to create a Expression widget. Please include this key.";
Widget::ExpressionSizeValue="The value for the key Size must match TextBoxSizeP for the Expression widget. Please change the value of this key.";
Widget::ExpressionInvalidKeys="The Expression widget does not take keys `1`. Please remove these keys.";

(* Takes in an association of keys and checks that they can be used to specify an expression widget. Autofills the keys that it can based on the given information. Returns an expression widget. *)
expressionWidget[myAssociation_Association]:=Module[{validKeys,invalidKeys,defaultValues,missingKeys,widgetAssociationWithDefaults,associationWithPatternTooltip},
	(* Define the valid keys for this widget. *)
	validKeys={Type, Pattern, Size, BoxText, PatternTooltip, Identifier};

	(* Get the set difference between the valid keys and the keys in the given association. This gives us the invalid keys in the association. *)
	invalidKeys=Complement[Union[validKeys,Keys[myAssociation]],validKeys];

	(* If there are invalid keys, return $Failed. *)
	If[Length[invalidKeys]!=0,
		Message[Widget::ExpressionInvalidKeys,invalidKeys]; Return[$Failed];
	];

	(* Make sure that Size is provided. *)
	If[!KeyExistsQ[myAssociation,Size],
		Message[Widget::ExpressionMissingSizeKey]; Return[$Failed];
	];

	(* Make sure Size matches TextBoxSizeP. *)
	If[!MatchQ[myAssociation[Size],TextBoxSizeP],
		Message[Widget::ExpressionSizeValue]; Return[$Failed];
	];

	(* No more checks to perform. *)

	(* Add the PatternTooltip to the input association. This function doesn't do anything if the tooltip is already specified in the association. *)
	associationWithPatternTooltip=addPatternTooltip[myAssociation];

	(* Define the defaults for the optional keys of the primitive widget. *)
	defaultValues=<|BoxText->Null,Identifier->CreateUUID[]|>;

	(* Get the missing keys in the association. *)
	missingKeys=Complement[validKeys,Keys[associationWithPatternTooltip]];

	(* Fill out the optional keys with default values if they are not specified. *)
	widgetAssociationWithDefaults=Append[associationWithPatternTooltip,(#->defaultValues[#]&)/@missingKeys];

	(* Return the widget. *)
	Widget[widgetAssociationWithDefaults]
];

(* ::Subsubsubsection::Closed:: *)
(*Head*)

Widget::HeadMissingHeadKey="The key Head must be specified to create a Head widget. Please include this key.";
Widget::HeadMissingWidgetKey="The key Widget must be specified to create a Head widget. Please include this key.";
Widget::HeadInvalidKeys="The Head widget does not take keys `1`. Please remove these keys.";
Widget::HeadPatternInformed="The Head widget will automatically determine the pattern field. Please don't include this key.";

(* Takes in an association of keys and checks that they can be used to specify an expression widget. Autofills the keys that it can based on the given information. Returns a head widget. *)
headWidget[myAssociation_Association]:=Module[
  {
    validKeys,invalidKeys,associationWithPatternTooltip,defaultValues,missingKeys,widgetAssociationWithDefaults,delayedRule
  },
	(* Define the valid keys for this widget *)
  validKeys = {Type, Head, Widget, Pattern, PatternTooltip, Identifier};

	(* Get the set difference between the valid keys and the keys in the given association. This gives us the invalid keys in the association. *)
	invalidKeys=Complement[Union[validKeys,Keys[myAssociation]],validKeys];

	(* If there are invalid keys, return $Failed. *)
	If[Length[invalidKeys]!=0,
		Message[Widget::HeadInvalidKeys,invalidKeys];
		Return[$Failed];
	];

	(* Make sure that Head is provided. *)
	If[!KeyExistsQ[myAssociation,Head],
		Message[Widget::HeadMissingHeadKey];
		Return[$Failed];
	];

	(* Make sure that Widget is provided. *)
	If[!KeyExistsQ[myAssociation,Widget],
		Message[Widget::HeadMissingWidgetKey];
		Return[$Failed];
	];

	(* Make sure that Widget is provided. *)
	If[KeyExistsQ[myAssociation,Pattern],
		Message[Widget::HeadPatternInformed];
		Return[$Failed];
	];

	(* No more checks to perform *)

	(* Add the PatternTooltip to the input association. This function doesn't do anything if the tooltip is already specified in the association. *)
	associationWithPatternTooltip=addPatternTooltip[myAssociation];

	(* Create the delayed rule Pattern :> GenerateInputPattern[Widget[myAssociation]] making sure to have everything evaluate (or not) correctly *)
	delayedRule=With[{insertMe=GenerateInputPattern[Widget[myAssociation]]},holdCompositionList[RuleDelayed,{Hold[Pattern],insertMe}]];

	(* Define the defaults for the optional keys of the primitive widget. *)
	defaultValues=<|Identifier->CreateUUID[]|>;

	(* Get the missing keys in the association. *)
	missingKeys=Complement[validKeys,Keys[associationWithPatternTooltip]];

	(* Fill out the optional keys with default values if they are not specified as well as the Pattern key. *)
	widgetAssociationWithDefaults=Join[Append[associationWithPatternTooltip,(#->defaultValues[#]&)/@missingKeys],<|First[delayedRule]|>];

	(* Return the widget. *)
	Widget[widgetAssociationWithDefaults]
];


(* ::Subsubsection::Closed:: *)
(*Public Short Hand Function*)


(* ::Subsubsubsection::Closed:: *)
(*Widget*)


Widget::InvalidType="Type `1` is not a valid widget type. Refer to WidgetTypeP to see the valid widget types.";
Widget::MissingTypeKey="The key Type must be specified to create a widget.";
Widget::MissingAssociationSequence="The sequence could not be converted to an association: `1`";
Widget::MissingPatternKey="The key Pattern must be specified to create a widget.";
Widget::PatternSetDelayed="The key Pattern must be specified as SetDelayed (:>).";
Widget::InvalidPatternTooltipValue="The value for the key PatternTooltip must match _String. Please change the value of this key.";

(* The widget short hand function will match on any sequence of inputs that does not contain an association as one of the inputs. *)
Widget[mySequence:(Except[_Association])..]:=Module[{inputAssociation,widgetType},
	(* Convert our sequence into an association. *)
	inputAssociation=Association[mySequence];

	If[MatchQ[Keys@inputAssociation, _Keys],
		Message[Widget::MissingAssociationSequence, Hold[mySequence]]; Return[$Failed];
	];

	(* Make sure that the Type key exists. *)
	If[!KeyExistsQ[inputAssociation,Type],
		Message[Widget::MissingTypeKey]; Return[$Failed];
	];

	(* Get the type of this widget from the input association. *)
	widgetType=inputAssociation[Type];

	(* Make sure that the specified widget type is valid. *)
	If[!MatchQ[widgetType,WidgetTypeP],
		Message[Widget::InvalidType,widgetType]; Return[$Failed];
	];

	(* Make sure that the pattern key is specified. *)
	(* NOTE: Head widgets do not require the pattern key *)
	If[(!MatchQ[widgetType,Head])&&(!KeyExistsQ[inputAssociation,Pattern]),
		Message[Widget::MissingPatternKey]; Return[$Failed];
	];

	(* Make sure that the pattern key is specified as set delayed. *)
	(* NOTE: Head widgets do not require the pattern key *)
	If[(!MatchQ[widgetType,Head])&&(!MatchQ[inputAssociation,KeyValuePattern[Pattern:>_]]),
		Message[Widget::PatternSetDelayed]; Return[$Failed];
	];

	(* Make sure that the value of PatternTooltip matches _String, if it is specified. *)
	If[KeyExistsQ[inputAssociation,PatternTooltip]&&!MatchQ[inputAssociation[PatternTooltip],_String],
		Message[Widget::InvalidPatternTooltipValue]; Return[$Failed];
	];

	(* The required keys (Type and Pattern) exist. Construct the widget. *)
	(* Switch to the appropriate helper function based on the widget type. Return the result. *)
	Switch[widgetType,
		Enumeration,
			enumerationWidget[inputAssociation],
		Number,
			numberWidget[inputAssociation],
		Quantity,
			quantityWidget[inputAssociation],
		Color,
			colorWidget[inputAssociation],
		Molecule,
			moleculeWidget[inputAssociation],
		Date,
			dateWidget[inputAssociation],
		String,
			stringWidget[inputAssociation],
		Object,
			objectWidget[inputAssociation],
		FieldReference,
			fieldReferenceWidget[inputAssociation],
		Primitive,
			primitiveWidget[inputAssociation],
		UnitOperationMethod,
			unitOperationMethodWidget[inputAssociation],
		UnitOperation,
			unitOperationWidget[inputAssociation],
		MultiSelect,
			multiSelectWidget[inputAssociation],
		Expression,
			expressionWidget[inputAssociation],
		Head,
			headWidget[inputAssociation]
	]
];


(* ::Subsubsubsection::Closed:: *)
(*Adder*)


Adder::InvalidWidget="The given widget does not match WidgetP. Please reformat your input.";

Adder[myWidget_]:=Module[{},
	(* Make sure that our singleton argument is a valid widget. *)
	If[!MatchQ[myWidget,WidgetP],
		Message[Adder::InvalidWidget]; Return[$Failed];
	];

	(* Return our adder. *)
	(* By default, the orientation of the adder is vertical.*)
	Adder[
		myWidget,
		Orientation->Vertical
	]
];


(* ::Subsubsubsection::Closed:: *)
(*Alternatives*)


(* There is no short hand function. *)


(* ::Subsubsubsection::Closed:: *)
(*Tuples*)


(* There is no short hand function. *)


(* ::Subsubsubsection::Closed:: *)
(*Span*)


(* There is no short hand function. *)


(* ::Subsection::Closed:: *)
(*Pattern Builder*)


(* ::Subsubsection::Closed:: *)
(*Hold Helper Function*)


(* Given f and Hold[g[x]], return Hold[f[g[x]]] without evaluating anything. *)
holdComposition[f_,Hold[expr__]]:=Hold[f[expr]];
SetAttributes[holdComposition,HoldAll];


(* Given Hold[f[a[x],b[x],..]], returns {Hold[a[x]],Hold[b[x]]. *)
holdCompositionSingleton[heldItem_Hold]:=Module[{lengthOfHolds},
	(* Get the number of items inside of the f[...] head. *)
	lengthOfHolds=Length[Extract[heldItem,{1}]];

	(* Extract each item inside of the f[...] head and wrap it in a hold. *)
	Extract[heldItem,{1,#},Hold]&/@Range[lengthOfHolds]
];
SetAttributes[holdCompositionSingleton,HoldAll];


(* Given f and {Hold[a[x]], Hold[b[x]]..}, returns Hold[f[a[x],b[x]..]]. *)
holdCompositionList[f_,{helds___Hold}]:=Module[{joinedHelds},
	(* Join the held heads. *)
	joinedHelds=Join[helds];

	(* Swap the outter most hold with f. Then hold the result. *)
	With[{insertMe=joinedHelds},holdComposition[f,insertMe]]
];
SetAttributes[holdCompositionList,HoldAll];


(* ::Subsubsection::Closed:: *)
(*GenerateInputPattern Unit Functions*)


Options[GenerateInputPattern]={Tooltips->False};


(* ::Subsubsubsection::Closed:: *)
(*Atomic Extracted Unit*)


(* When myUnit is already in the form List[_List..], returns the input. This unit is already expanded. *)
extractUnit[myUnit:List[_List..]]:=myUnit;


(* ::Subsubsubsection::Closed:: *)
(*Atomic Unit*)


GenerateInputPattern::MainUnitNotProvidedInUnitsList="In the atomic WidgetUnit `1`, the main unit `2` is not contained within the other unit list `3`. Please add this unit to the full list of units.";

(* Returns the unit of the Atomic Unit *)
(* The Unit of an atomic unit (which is in the form {_?NumberQ,{_?QuantityQ,{_?QuantityQ...}}}) is simply the {2,1} argument from the list raised to the {1} power.  *)
extractUnit[myUnit:atomicUnitP]:=Module[{unit,power,otherUnits},
	(* Extract the unit from the {_?NumberQ,{_?QuantityQ,{_?QuantityQ...}}}) form. *)
	unit=Extract[myUnit,{2,1}];

	(* Extract the power from the {_?NumberQ,{_?QuantityQ,{_?QuantityQ...}}}) form. *)
	power=(Extract[myUnit,{1}]);

	(* Check that the other units in the atomic unit match the main unit. *)
	(* Get the other units. *)
	otherUnits=Extract[myUnit,{2,2}];

	(* Make sure that the main unit is contained within the other units. *)
	If[!MemberQ[otherUnits,unit],
		Message[GenerateInputPattern::MainUnitNotProvidedInUnitsList,ToString[myUnit],ToString[unit],ToString[otherUnits]]; Return[$Failed];
	];

	(* No more checks, return the main unit. *)
	{unit^power}
];


(* ::Subsubsubsection::Closed:: *)
(*Alternatives Unit*)


(* Returns the unit of the Alternatives Unit. *)
(* The alternatives unit is in the form Alternatives[widgetUnitsP..]. Returns the alternatives of units if they are of a different unit dimension, otherwise, returns only one of the units. *)
extractUnit[myUnit_Alternatives]:=Module[{allUnits},
	(* The unit of an alternatives unit is simply the pattern of one of the units inside of the alternatives. *)

	(* First check to make sure that all of the units inside of the alternatives are equivalent. *)
	(* Gather up all of the patterns of the units inside of the alternatives. *)
	allUnits=extractUnit/@(List@@myUnit);

	(* Check for $Failed. *)
	If[MemberQ[allUnits,$Failed],
		Return[$Failed];
	];

	(* Get one of each unit type. *)
	Flatten[allUnits]
];


(* ::Subsubsubsection::Closed:: *)
(*Compound Unit*)


(* Return the unit of a compound unit (which is in the form CompoundUnit[widgetUnitsP..]). Returns a list of the possible combinations of the units (via Tuples). *)
extractUnit[myUnit_CompoundUnit]:=Module[{allUnits},
	(* The unit of the compound unit is simply the units of the WidgetUnits it contains, multiplied. *)

	(* Extract all of the units from the CompoundUnit. *)
	allUnits=extractUnit/@(List@@myUnit);

	(* Check for $Failed. *)
	If[MemberQ[allUnits,$Failed],
		Return[$Failed];
	];

	(* Multiply all of our units to one another. Make sure that there is not un-necessary nesting. *)
	(Times@@#&)/@(Flatten[Tuples[allUnits],{1}])
];


(* ::Subsubsubsection::Closed:: *)
(*Main Function*)


(* To build a units pattern for a WidgetUnit object, simply extract the units from the WidgetUnits object and wrap that in UnitsP[]. Returns the pattern as Held.*)
GenerateInputPattern[myUnit:widgetUnitsP,OptionsPattern[]]:=Module[
	{units,heldUnitPatterns},
	(* Get the unit from myUnit. *)
	units=extractUnit[myUnit];

	(* Wrap Hold[UnitsP[#]] around each of our units. *)
	heldUnitPatterns=(Hold[UnitsP[#]]&)/@units;

	(* Check for $Failed. Otherwise, create the pattern and return. *)
	If[!MemberQ[heldUnitPatterns,$Failed]&&!SameQ[heldUnitPatterns,$Failed],
		(* If heldUnitPatterns is of length 1, don't wrap alternatives around the result. *)
		If[Length[heldUnitPatterns]==1,
			(* Return Hold[UnitsP[#]]. *)
			heldUnitPatterns[[1]],
			(* Use our helper function to make our list of held unit patterns a held alternatives {Hold[UnitsP[a]], Hold[UnitsP[b]]..} \[Rule] Hold[Alternatives[UnitsP[a],UnitsP[b]..]]. *)
			With[{insertMe=heldUnitPatterns},holdCompositionList[Alternatives,insertMe]]
		],
		$Failed
	]
];


(* ::Subsubsection::Closed:: *)
(*GenerateInputPattern Widget Functions*)


(* ::Subsubsubsection::Closed:: *)
(*Enumeration Widget*)


(* The pattern of an atomic widget is simply contained in the pattern field. Returns the pattern as Hold. *)
(*GenerateInputPattern[myWidget:AtomicWidgetP,OptionsPattern[]]:=Extract[myWidget,Key[Pattern],Hold];*)
GenerateInputPattern[myWidget:EnumerationWidgetP,options:OptionsPattern[]]:=Module[{rawHeldPattern,heldPattern},
	(* Extract the pattern from the widget. *)
	rawHeldPattern=Extract[myWidget,Key[Pattern],Hold];

	(* If there is only one item in the Alternatives[...], just use Hold[...]. *)
	heldPattern=If[MatchQ[rawHeldPattern,Hold[Verbatim[Alternatives][_]]],
		Extract[rawHeldPattern,{1,1},Hold],
		rawHeldPattern
	];

	(* Return a Tooltip if asked. *)
	If[!MatchQ[ToList[options], {}] && TrueQ[OptionValue[Tooltips]],
		With[{ptt=Lookup[myWidget[[1]],Key[PatternTooltip],$Failed]},
			If[MatchQ[ptt,$Failed],
				Hold[Evaluate[Tooltip[heldPattern,ReleaseHold[heldPattern]]]],
				Hold[Evaluate[Tooltip[heldPattern,ptt]]]
			]
		],
		heldPattern
	]
];


(* ::Subsubsubsection::Closed:: *)
(*Atomic Widget*)


(* The pattern of an atomic widget is simply contained in the pattern field. Returns the pattern as Hold. *)
(*GenerateInputPattern[myWidget:AtomicWidgetP,OptionsPattern[]]:=Extract[myWidget,Key[Pattern],Hold];*)
GenerateInputPattern[myWidget:AtomicWidgetP,options:OptionsPattern[]]:=With[
		{heldPatt=Extract[myWidget,Key[Pattern],Hold]},
		If[!MatchQ[ToList[options], {}] && TrueQ[OptionValue[Tooltips]],
			With[{ptt=Lookup[myWidget[[1]],Key[PatternTooltip],$Failed]},
				If[MatchQ[ptt,$Failed],
					Hold[Evaluate[Tooltip[heldPatt,ReleaseHold[heldPatt]]]],
					Hold[Evaluate[Tooltip[heldPatt,ptt]]]
				]
			],
			heldPatt
		]
	];


(* ::Subsubsubsection::Closed:: *)
(*UnitOperationMethod Widget*)


(* The pattern of an atomic widget is simply contained in the pattern field. Returns the pattern as Hold. *)
(*GenerateInputPattern[myWidget:UnitOperationMethodWidgetP,OptionsPattern[]]:=Extract[myWidget,Key[Pattern],Hold];*)
GenerateInputPattern[myWidget:UnitOperationMethodWidgetP,options:OptionsPattern[]]:=With[
	{heldPatt=Extract[myWidget,Key[Pattern],Hold]},
	If[!MatchQ[ToList[options], {}] && TrueQ[OptionValue[Tooltips]],
		With[{ptt=Lookup[myWidget[[1]],Key[PatternTooltip],$Failed]},
			If[MatchQ[ptt,$Failed],
				Hold[Evaluate[Tooltip[heldPatt,ReleaseHold[heldPatt]]]],
				Hold[Evaluate[Tooltip[heldPatt,ptt]]]
			]
		],
		heldPatt
	]
];

(* ::Subsubsubsection::Closed:: *)
(*Head Widget*)

(* The pattern of a Head widget is Symbol[pattern of the contained widget] *)
GenerateInputPattern[myWidget:HeadWidgetP,ops:OptionsPattern[]]:=Module[
  {
    containedWidget,symbolWrapper,widgetPattern,result
  },
  (* Extract the contained widget from the Widget field of the head widget *)
	containedWidget=Lookup[myWidget[[1]],Widget];

	(* Extract the symbol wrapper from the Head field of the head widget *)
	symbolWrapper=Lookup[myWidget[[1]],Head];

	(* Get the pattern for the widget *)
	widgetPattern=GenerateInputPattern[containedWidget,ops];

	(* Combine the widget pattern with the head wrapper *)
	result=With[{insertMe1=Verbatim[symbolWrapper],insertMe2=widgetPattern},holdComposition[insertMe1,insertMe2]];

	(* Return the result *)
	result
];

(* ::Subsubsubsection::Closed:: *)
(*Alternatives Widget*)


(* The pattern of an Alternatives widget is the combination of the patterns from each widget. *)
GenerateInputPattern[myWidget:AlternativesWidgetP,ops:OptionsPattern[]]:=Module[{widgetsList,filteredWidgetsList,widgetPatterns,result},
	(* An alternatives widget is of the form Alternatives[(widget|rule)..]. Swap the Alternatives head for a List head. *)
	widgetsList=List@@myWidget;

	(* We may have labels on our widgets inside of our Alternatives[...]. If we find these labels, strip them out (we don't need them to generate the pattern. *)
	filteredWidgetsList=(
		(* Do we have a label on our widget? *)
		If[MatchQ[#,_Rule],
			(* We do, strip it out. *)
			#[[2]],
			(* We don't, do nothing. *)
			#
		]
	&)/@widgetsList;

	(* Get the patterns for each of the widget. These patterns are all returned as Held. *)
	widgetPatterns=GenerateInputPattern[#,ops]&/@filteredWidgetsList;

	(* Combine the patterns from each widget via an Alternatives. *)
	(* holdCompositionList is a helper function that removes the Hold[...] heads from the widgetPatterns list before it is wrapped in Alternatives[...]. *)
	result=With[{insertMe=widgetPatterns},holdCompositionList[Alternatives,insertMe]];

	(* Return the result. *)
	result
];


(* ::Subsubsubsection::Closed:: *)
(*Adder Widget*)


(* The pattern of an Adder widget is the Repeated[...] version of the contained widget. *)
GenerateInputPattern[myWidget:AdderWidgetP,ops:OptionsPattern[]]:=Module[{widgetPattern,repeatedPattern,result},
	(* An adder widget only contains one widget (contained as the first argument to the Adder[...]). Extract it. GenerateInputPattern returns this pattern as Held. *)
	widgetPattern=GenerateInputPattern[myWidget[[1]],ops];

	(* Our result is Hold[List[Repeated[widgetPattern]]]. *)
	repeatedPattern=With[{insertMe=widgetPattern},holdComposition[Repeated,insertMe]];
	result=With[{insertMe=repeatedPattern},holdComposition[List,insertMe]];

	(* Return the result. *)
	result
];


(* ::Subsubsubsection::Closed:: *)
(*Tuple Widget*)


(* The pattern of an Tuple widget is the Tuple version of the contained widgets. *)
GenerateInputPattern[myWidget:ListWidgetP,ops:OptionsPattern[]]:=GenerateInputPattern[myWidget,ops]=Module[{listWidgets,heldWidgetPatterns,result},
	(* The tuples widget is specified as {Rule[_String, WidgetP]..}. Pull out the widget from each of these list indexes. *)
	listWidgets=(myWidget[[#]][[2]]&)/@Range[Length[myWidget]];

	(* Convert each of these widgets into a pattern. GenerateInputPattern returns each of these patterns as Held. *)
	heldWidgetPatterns=(GenerateInputPattern[#,ops]&/@listWidgets);

	(* Convert this list of held patterns into a list of held patterns. {Hold[a],Hold[b],Hold[c]} \[Rule] Hold[List[a,b,c]]}*)
	result=With[{insertMe=heldWidgetPatterns},holdCompositionList[List,insertMe]];

	(* Return the result. *)
	result
];


(* ::Subsubsubsection::Closed:: *)
(*Span Widget*)


(* The pattern of an Span widget is the Span version of the contained widgets. *)
GenerateInputPattern[myWidget:SpanWidgetP,ops:OptionsPattern[]]:=Module[{listWidgets,heldWidgetPatterns,result},
	(* The tuples widget is specified as Span[myWidget1,myWidget2]. Swap the Span head for a List head. *)
	listWidgets=List@@myWidget;

	(* Convert each of these widgets into a pattern. GenerateInputPattern returns each of these patterns as Held. *)
	heldWidgetPatterns=(GenerateInputPattern[#,ops]&/@listWidgets);

	(* Convert this list of held patterns into a held span. {Hold[a],Hold[b]} \[Rule] Hold[Span[a,b]]}*)
	result=With[{insertMe=heldWidgetPatterns},holdCompositionList[Span,insertMe]];

	(* Return the result. *)
	result
];

(* ::Subsubsubsection::Closed:: *)
(*Head Widget*)


(* The pattern of an Span widget is the Head version of the contained widgets. *)
GenerateInputPattern[myWidget:SpanWidgetP,ops:OptionsPattern[]]:=Module[{listWidgets,heldWidgetPatterns,result},

	(* GenerateInputPattern around inside widget, Verbatim around that, use hold helper functions above, replace surrounding hold with verbatimin had (holdCompositionList) *)

	(* The tuples widget is specified as Span[myWidget1,myWidget2]. Swap the Span head for a List head. *)
	listWidgets=List@@myWidget;

	(* Convert each of these widgets into a pattern. GenerateInputPattern returns each of these patterns as Held. *)
	heldWidgetPatterns=(GenerateInputPattern[#,ops]&/@listWidgets);

	(* Convert this list of held patterns into a held span. {Hold[a],Hold[b]} \[Rule] Hold[Span[a,b]]}*)
	result=With[{insertMe=heldWidgetPatterns},holdCompositionList[Span,insertMe]];

	(* Return the result. *)
	result
];


(* ::Subsubsection::Closed:: *)
(*GenerateInputPattern Option/Input List Function*)


(* ::Subsubsubsection::Closed:: *)
(*Option Function*)


GenerateInputPattern::InvalidWidget="The given widget, `1`, does not match WidgetP. Please reformat your input.";
GenerateInputPattern::MissingRequiredKey="Unable to build a pattern for the given input/options packet or widget, `1`, because a required key is missing. For options, the required keys are {OptionName, Default, AllowNull, Description}. For input, the required keys are {InputName, Description, Widget}. Please include these required keys. For a widget, run ValidWidgetQ.";
GenerateInputPattern::AllowNull="The value of AllowNull in the options list needs to match BooleanP. Please reformat your input.";

(* GenerateInputPattern builds a pattern from an options packet. GenerateInputPattern is private because it should only be called by internal Emerald functions. *)
GenerateInputPattern[optionsPacket:minimalOptionPacketP,ops:OptionsPattern[]]:=Module[
	{optionsAssociation,widget,widgetPattern,singletonPatternWithDefault,combinedAlternatives,patternWithIndexMatching,
	allowNullPattern,patternsList,heldFinalPattern,singletonPatternsList,heldFinalSingletonPattern,listablePattern,
	heldFinalPoolingPattern},

	(* Convert the given list of option rules into an association. *)
	optionsAssociation=Association[optionsPacket];

	(* Make sure that AllowNull matches BooleanP, if not, return $Failed. *)
	If[!MatchQ[optionsAssociation[AllowNull],BooleanP],
		Message[GenerateInputPattern::AllowNull]; Return[$Failed];
	];

	(* Extract the widget. *)
	widget=optionsAssociation[Widget];

	(* Make sure that the widget matches WidgetP. If it does not, return $Failed. *)
	If[!MatchQ[widget,WidgetP],
		Message[GenerateInputPattern::InvalidWidget, widget]; Return[$Failed];
	];

	(* Get the pattern of the widget. This is returned as held. *)
	widgetPattern=GenerateInputPattern[widget,ops];

	(* Apply the post-processing keys (Default, AllowNull, IndexMatchingInput) to the widget pattern. *)

	(* First, add the default to the singleton pattern if it isn't automatic. *)
	singletonPatternWithDefault=If[!SameQ[optionsAssociation[Default],Automatic],
		(* The default is not automatic. Do not add the default to the singleton pattern. *)
		widgetPattern,

		(* The default is automatic. Add it to the singleton pattern. *)
		With[{insertMe=widgetPattern,insertMe2=optionsAssociation[Default]},
			holdCompositionList[Alternatives,{insertMe,Hold[insertMe2]}]
		]
	];

	(* Create a pattern for the AllowNull key. *)
	allowNullPattern=Hold[Null];

	(* If AllowNull->True, add Null to the singleton pattern. *)
	heldFinalSingletonPattern=If[optionsAssociation[AllowNull],
		singletonPatternsList={singletonPatternWithDefault,allowNullPattern};
		With[{insertMe=singletonPatternsList},holdCompositionList[Alternatives,insertMe]],

		(* Otherwise, return the singleton with the default. *)
		singletonPatternWithDefault
	];

	(* Apply the IndexMatching to the overall pattern. This only applies to the pattern of the widget. *)
	(* First, we check to see if we're pooling (Pooled\[Rule]True). *)
	(* If that's not set, check to see if we're IndexMatching (but not pooled). This means IndexName\[Rule]Except[Null]. *)
	(* Otherwise, use the raw pattern of the widget. *)
	(* We return this new pattern as Held. *)
	heldFinalPattern=If[MatchQ[Lookup[optionsAssociation,NestedIndexMatching,Null],True],
		(* First compute the ListableP version. *)
		listablePattern=With[{insertMe=heldFinalSingletonPattern},holdComposition[ListableP,insertMe]];

		(* Then compute the ListableP[ListableP[_]] pattern. *)
		With[{insertMe=listablePattern},holdComposition[ListableP,insertMe]],

		(* ELSE: We're not pooling, are we index matching? *)
		If[!MatchQ[Lookup[optionsAssociation,Key[IndexMatching],Null],Null],
			(* IndexMatching should be applied. Wrap the singleton in ListableP[...]. *)
			With[{insertMe=heldFinalSingletonPattern},holdComposition[ListableP,insertMe]],

			(* Index Matching key is not set. *)
			(* Return the singleton pattern. *)
			heldFinalSingletonPattern
		]
	];

	(* If we were pooling, insert a pooling pattern (only one ListableP instead of two). Otherwise, set it to Null. *)
	heldFinalPoolingPattern=If[MatchQ[Lookup[optionsAssociation,NestedIndexMatching,Null],True],
		(* Compute the ListableP version (only one layer). *)
		With[{insertMe=heldFinalSingletonPattern},holdComposition[ListableP,insertMe]],
		Null
	];

	(* Return the held final pattern and the held singleton pattern. *)
	With[{insertMe=heldFinalPattern,insertMe2=heldFinalSingletonPattern,insertMe3=heldFinalPoolingPattern},
		<|
			Pattern:>insertMe,
			SingletonPattern:>insertMe2,
			PooledPattern:>insertMe3
		|>
	]
];


(* ::Subsubsubsection::Closed:: *)
(*Input Function*)


(* GenerateInputPattern builds a pattern from an inputs packet. *)
GenerateInputPattern[inputsPacket:minimalInputPacketP,ops:OptionsPattern[]]:=Module[
	{inputAssociation,widget,widgetPattern,combinedAlternatives,heldFinalPattern,listablePattern,heldFinalPoolingPattern},

	(* Convert the given list of input rules into an association. *)
	inputAssociation=Association[inputsPacket];

	(* Extract the widget. *)
	widget=inputAssociation[Widget];

	(* Make sure that the widget matches WidgetP. If it does not, return $Failed. *)
	If[!MatchQ[widget,WidgetP],
		Message[GenerateInputPattern::InvalidWidget,widget]; Return[$Failed];
	];

	(* Get the pattern of the widget. *)
	widgetPattern=GenerateInputPattern[widget,ops];

	(* Apply the post-processing keys (IndexName) to the widget pattern. *)

	(* We apply the IndexMatching. This only applies to the pattern of the widget. *)
	(* First, we check to see if we're pooling (Pooled\[Rule]True). *)
	(* If that's not set, check to see if we're IndexMatching (but not pooled). This means IndexName\[Rule]Except[Null]. *)
	(* Otherwise, use the raw pattern of the widget. *)
	(* We return this new pattern as Held. *)
	heldFinalPattern=If[MatchQ[Lookup[inputAssociation,NestedIndexMatching,Null],True],
		(* First compute the ListableP version. *)
		listablePattern=With[{insertMe=widgetPattern},holdComposition[ListableP,insertMe]];

		(* Then compute the ListableP[ListableP[_]] pattern. *)
		With[{insertMe=listablePattern},holdComposition[ListableP,insertMe]],

		(* ELSE: We're not pooling, are we index matching? *)
		If[!MatchQ[Lookup[inputAssociation,IndexName,Null],Null],
			(* Set the pattern as ListableP. *)
			With[{insertMe=widgetPattern},holdComposition[ListableP,insertMe]],

			(* Do not set the pattern as ListableP. Return the plain pattern. *)
			widgetPattern
		]
	];

	(* If we were pooling, insert a pooling pattern (only one ListableP instead of two). Otherwise, set it to Null. *)
	heldFinalPoolingPattern=If[MatchQ[Lookup[inputAssociation,NestedIndexMatching,Null],True],
		(* Compute the ListableP version (only one layer). *)
		With[{insertMe=widgetPattern},holdComposition[ListableP,insertMe]],
		Null
	];

	(* Return the held final pattern and the held singleton pattern. *)
	With[{insertMe=heldFinalPattern,insertMe2=widgetPattern,insertMe3=heldFinalPoolingPattern},
		<|
			Pattern:>insertMe,
			SingletonPattern:>insertMe2,
			PooledPattern:>insertMe3
		|>
	]
];


(* ::Subsubsubsection::Closed:: *)
(*Base Case*)


(* The only way we can get here is if a widget was not provided. *)
GenerateInputPattern[x_,OptionsPattern[]]:=Module[{},
	Message[GenerateInputPattern::MissingRequiredKey,ToString[x]];

	$Failed
];


(* ::Subsection::Closed:: *)
(*De-Referencing*)


OnLoad[

	Widget::NoKeyExists="The key `1` could not be found for this type of Widget. Please call the function Keys on your widget to see a known list of keys for this given Widget type.";

	Unprotect[Widget];

	(* Keys[myWidget] returns the keys inside of the Widget association *)
	Widget /: Keys[myWidget_Widget]:=Keys[myWidget[[1]]];

	(* Make each individual key inside of a widget de-reference-able. *)
	Widget /: (myWidget_Widget)[mySymbol_Symbol]:=Module[{},
		If[MemberQ[Keys[myWidget],mySymbol],
			myWidget[[1]][mySymbol],
			Message[Widget::NoKeyExists,mySymbol]; $Failed
		]
	];

	(* Make each individual key inside of a widget de-reference-able via Extract. *)
	Widget /: Extract[myWidget_Widget,myKey_,head_]:=Extract[myWidget[[1]],myKey,head];

];