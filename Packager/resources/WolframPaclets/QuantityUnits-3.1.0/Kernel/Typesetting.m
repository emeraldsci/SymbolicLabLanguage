(*need to reinitialize MakeBoxes rules since loading Alpha code clobbered these*)
Unprotect[Quantity];
BoxForm`MakeConditionalTextFormattingRule[System`Quantity];
BoxForm`MakeConditionalTextFormattingRule[System`MixedRadixQuantity];

System`Quantity /: MakeBoxes[x:System`Quantity[_,u_?LooksLikeAUnitQ], fmt_] /;And[UnsameQ[$UnitMBF,True], KnownUnitQ[u]]:=
    Block[{boxes = Catch[QuantityBox[x, fmt], $typesettingFailureFlag]}, boxes /; boxes =!= $Failed]
    
System`MixedRadixQuantity /: MakeBoxes[x_System`MixedRadixQuantity, fmt_]/;UnsameQ[$UnitMBF,True] /;Quiet[QuantityQ[x]] :=
    Block[{boxes = Catch[QuantityBox[Evaluate[x], fmt], $typesettingFailureFlag]}, boxes /; boxes =!= $Failed]

Format[(q:Quantity[mag_, unit_])?QuantityQ, OutputForm]:= Switch[unit,
	_MixedUnit, toMixedUnitQuantityString[q],
	_, ToString[StringForm["`1` `2`", quantityMagToStringForm[mag], longName[q]], OutputForm]
]

SetAttributes[quantityMagToStringForm, HoldAllComplete];(*no evaluation leaks during typesetting*)
quantityMagToStringForm[i:Interval[{min_, max_}]] := StringJoin[ToString[min], " to ", ToString[max]]
quantityMagToStringForm[other_] := other

toMixedUnitQuantityString[Quantity[MixedMagnitude[values_List], MixedUnit[units_List]]] := 
	StringJoin[
		Riffle[ToString[StringForm["`1` `2`", First[#], longName[Quantity@@#]]] & /@ Transpose[{values, units}], " "]
	]
toMixedUnitQuantityString[___] := "$Failed" (*fall-back case; shouldn't ever get hit...*)

(*TODO: put in TypesetInit.m*)
protected = Unprotect[TemplateBox]

$QuantityStyles = Alternatives[
	"Quantity",
	"QuantityPostfix",
	"QuantityUnitPostfix",
	"QuantityPrefix",
	"QuantityPrefixUnit",
	"QuantityPrefixPostfix",
	"QuantityPrefixUnitPostfix"
]
TemplateBox /: MakeExpression[TemplateBox[{val_, _, _, interp__}, $QuantityStyles, ___], fmt_] := MakeExpression[RowBox[{"Quantity", "[", RowBox[{val, ",", Sequence @@ Riffle[{interp}, ","]}], "]"}], fmt];
TemplateBox /: MakeExpression[TemplateBox[{__, interp_, _}, $QuantityStyles, ___], fmt_] := MakeExpression[interp, fmt];

Protect @@ protected;

(*============================================*)
(*primary display function for QuantityForm, called from Source/Output c-code*)
ToQuantityBox[q_?QuantityQ,fmt_]:=ToQuantityBox[q,fmt,{}]
ToQuantityBox[q_?QuantityQ,fmt_,s_String]:=ToQuantityBox[q,fmt,{s}]
ToQuantityBox[q_?QuantityQ,fmt_,list:{_String...}]:=
With[{specs=Sort[Union[list]],bad=Complement[list,{"Abbreviation", "LongForm", "SingularForm"}]},
 With[{display=If[TrueQ[Length[bad]>0],
	list,
	Switch[specs,
	{},"UnitAbbreviation",
	{"Abbreviation"},"UnitAbbreviation",
	{"Abbreviation","LongForm"},"UnitAbbreviationWithDescription",
	{"Abbreviation","SingularForm"},"UnitAbbreviation",
	{"Abbreviation","LongForm","SingularForm"},"UnitAbbreviationWithSingularDescription",
	{"LongForm"},"UnitDescription",
	{"LongForm","SingularForm"},"UnitSingularDescription",
	{"SingularForm"},"UnitAbbreviation",
	_, "UnitAbbreviation"]]},
	Switch[display,
	"UnitAbbreviation",
	QuantityLabel[q,"Format"->"FullUnitLabel"],
	"UnitDescription",
	QuantityLabel[q,"Format"->"UnitString"],
	"UnitAbbreviationWithDescription",
	QuantityLabel[q,"Format"->"FullUnitLabelWithDescription"],
	"UnitSingularDescription",
	QuantityLabel[q,"Format"->"UnitString","Singular"->True],
	"UnitAbbreviationWithSingularDescription",
	QuantityLabel[q,"Format"->"FullUnitLabelWithDescription","Singular"->True],
	{"PlotLabel"},
	With[{un=QuantityUnit[q]},
		TooltipBox[QuantityLabel[un,"Format"->"FullUnitLabel"],QuantityLabel[un,"Format"->"UnitString"]]],
	_,
	(Message[QuantityForm::form,display];Block[{$UnitMBF=True},
	RowBox[{"QuantityForm","[",RowBox[{MakeBoxes[q,fmt],",",MakeBoxes[list,fmt]}],"]"}]])
]]]

ToQuantityBox[un_?KnownUnitQ,fmt_]:=ToQuantityBox[un,fmt,{}]
ToQuantityBox[un_?KnownUnitQ,fmt_,s_String]:=ToQuantityBox[un,fmt,{s}]
ToQuantityBox[un_?KnownUnitQ,fmt_,list:{_String...}]:=
With[{specs=Sort[Union[list]],bad=Complement[list,{"Abbreviation", "LongForm", "SingularForm"}]},
 With[{display=If[TrueQ[Length[bad]>0],
	list,
	Switch[specs,
	{},"UnitAbbreviation",
	{"Abbreviation"},"UnitAbbreviation",
	{"Abbreviation","LongForm"},"UnitAbbreviationWithDescription",
	{"Abbreviation","SingularForm"},"UnitAbbreviation",
	{"Abbreviation","LongForm","SingularForm"},"UnitAbbreviationWithSingularDescription",
	{"LongForm"},"UnitDescription",
	{"LongForm","SingularForm"},"UnitSingularDescription",
	{"SingularForm"},"UnitAbbreviation",
	_, "UnitAbbreviation"]]},
Switch[display,
	"UnitAbbreviation",
	QuantityLabel[un,"Format"->"FullUnitLabel"],
	"UnitDescription",
	QuantityLabel[un,"Format"->"UnitString"],
	"UnitAbbreviationWithDescription",
	QuantityLabel[un,"Format"->"FullUnitLabelWithDescription"],
	"UnitSingularDescription",
	QuantityLabel[un,"Format"->"UnitString","Singular"->True],
	"UnitAbbreviationWithSingularDescription",
	QuantityLabel[un,"Format"->"FullUnitLabelWithDescription","Singular"->True],
	{"PlotLabel"},
	TooltipBox[QuantityLabel[un,"Format"->"FullUnitLabel"],QuantityLabel[un,"Format"->"UnitString"]],
	_,
	(Message[QuantityForm::form,display];RowBox[{"QuantityForm","[",RowBox[{MakeBoxes[un,fmt],",",MakeBoxes[list,fmt]}],"]"}])
]]]

ToQuantityBox[q_?QuantityQ,fmt_,other___]:=(Message[QuantityForm::form,other];RowBox[{"QuantityForm","[",RowBox[{MakeBoxes[q,fmt],",",MakeBoxes[other,fmt]}],"]"}])
ToQuantityBox[un_?KnownUnitQ,fmt_,other___]:=(Message[QuantityForm::form,other];RowBox[{"QuantityForm","[",RowBox[{MakeBoxes[un,fmt],",",MakeBoxes[other,fmt]}],"]"}])
ToQuantityBox[nq_,fmt_,list:Except[_List]]/;MemberQ[{"Abbreviation", "LongForm", "SingularForm","PlotLabel"},list]:=ToQuantityBox[nq,fmt,{list}]
ToQuantityBox[nq_,fmt_,list_List]/;Complement[list,{"Abbreviation", "LongForm", "PlotLabel", "SingularForm"}]==={}:=Block[{Quantity},
	Quantity/:MakeBoxes[x:(_Quantity)?QuantityQ,fmt]/;UnsameQ[$UnitMBF,True]:=ToQuantityBox[x,fmt,list];
	MakeBoxes[nq,fmt]
]
ToQuantityBox[nq_,fmt_,other___]:=(Message[QuantityForm::form,other];RowBox[{"QuantityForm","[",RowBox[{MakeBoxes[nq,fmt],",",MakeBoxes[other,fmt]}],"]"}])
ToQuantityBox[other___]:=(Message[QuantityForm::notunit];RowBox[{"QuantityForm","[",MakeBoxes[other],"]"}])

(*OutputForm display function for QuantityForm, called from Source/Output c-code (ToString[QuantityForm[...]])*)
ToQuantityString[q_?QuantityQ]:=ToQuantityString[q,{}]
ToQuantityString[q_?QuantityQ,s_String]:=ToQuantityString[q,{s}]
ToQuantityString[q_?QuantityQ,list:{_String...}]:=
With[{specs=Sort[Union[list]],bad=Complement[list,{"Abbreviation", "LongForm", "SingularForm"}]},
 With[{display=If[TrueQ[Length[bad]>0],
	list,
	Switch[specs,
	{},"UnitAbbreviation",
	{"Abbreviation"},"UnitAbbreviation",
	{"Abbreviation","LongForm"},"UnitAbbreviationWithDescription",
	{"Abbreviation","SingularForm"},"UnitAbbreviation",
	{"Abbreviation","LongForm","SingularForm"},"UnitAbbreviationWithSingularDescription",
	{"LongForm"},"UnitDescription",
	{"LongForm","SingularForm"},"UnitSingularDescription",
	{"SingularForm"},"UnitAbbreviation",
	_, "UnitAbbreviation"]]},
Switch[display,
	"UnitAbbreviation",
	getStringForm[QuantityLabel[q,"Format"->"FullUnitLabel"]],
	"UnitDescription",
	QuantityLabel[q,"Format"->"UnitString","OutputForm"->True],
	"UnitAbbreviationWithDescription",
	getStringForm[QuantityLabel[q,"Format"->"FullUnitLabelWithDescription"]],
	"UnitSingularDescription",
	QuantityLabel[q,"Format"->"UnitString","Singular"->True],
	"UnitAbbreviationWithSingularDescription",
	getStringForm[QuantityLabel[q,"Format"->"FullUnitLabelWithDescription","Singular"->True]],
	_,
	(Message[QuantityForm::form,display];"QuantityForm["<>ToString[q,InputForm]<>","<>ToString[display]<>"]")
]]]


ToQuantityString[un_?KnownUnitQ]:=ToQuantityString[un,{}]
ToQuantityString[un_?KnownUnitQ,s_String]:=ToQuantityString[un,{s}]
ToQuantityString[un_?KnownUnitQ,list:{_String...}]:=
With[{specs=Sort[Union[list]],bad=Complement[list,{"Abbreviation", "LongForm", "SingularForm"}]},
 With[{display=If[TrueQ[Length[bad]>0],
	list,
	Switch[specs,
	{},"UnitAbbreviation",
	{"Abbreviation"},"UnitAbbreviation",
	{"Abbreviation","LongForm"},"UnitAbbreviationWithDescription",
	{"Abbreviation","SingularForm"},"UnitAbbreviation",
	{"Abbreviation","LongForm","SingularForm"},"UnitAbbreviationWithSingularDescription",
	{"LongForm"},"UnitDescription",
	{"LongForm","SingularForm"},"UnitSingularDescription",
	{"SingularForm"},"UnitAbbreviation",
	_, "UnitAbbreviation"]]},
	Switch[display,
	"UnitAbbreviation",
	getStringForm[QuantityLabel[un,"Format"->"FullUnitLabel"]],
	"UnitDescription",
	QuantityLabel[un,"Format"->"UnitString"],
	"UnitAbbreviationWithDescription",
	getStringForm[QuantityLabel[un,"Format"->"FullUnitLabelWithDescription"]],
	"UnitSingularDescription",
	QuantityLabel[un,"Format"->"UnitString","Singular"->True],
	"UnitAbbreviationWithSingularDescription",
	getStringForm[QuantityLabel[un,"Format"->"FullUnitLabelWithDescription","Singular"->True]],
	_,
	(Message[QuantityForm::form,display];"QuantityForm["<>ToString[un,InputForm]<>","<>ToString[display]<>"]")
]]]

ToQuantityString[nq_,list:Except[_List]]/;MemberQ[{"Abbreviation", "LongForm", "PlotLabel", "SingularForm"},list]:=ToQuantityString[nq,{list}]
ToQuantityString[nq_,list_List]/;Complement[list,{"Abbreviation", "LongForm",  "PlotLabel", "SingularForm"}]==={}:=Block[{Quantity},
	Format[(q:Quantity[_,_])?QuantityQ,OutputForm]:=ToQuantityString[q,list];
	ToString[nq]
]
ToQuantityString[q_?QuantityQ,other___]:=(Message[QuantityForm::form,other];"QuantityForm["<>ToString[q,InputForm]<>","<>ToString[other]<>"]")
ToQuantityString[un_?KnownUnitQ,other___]:=(Message[QuantityForm::form,other];"QuantityForm["<>ToString[un,InputForm]<>"]")
ToQuantityString[a1_,other_]:=(Message[QuantityForm::notunit];"QuantityForm["<>ToString[a1,InputForm]<>","<>ToString[other,InputForm]<>"]")
ToQuantityString[other_]:=(Message[QuantityForm::notunit];"QuantityForm["<>ToString[other,InputForm]<>"]")

getStringForm[label_]:=ToString[DisplayForm[label],NumberMarks->False]

sanitizeUnitPart[Quantity[m_, u_]] := With[{unit = ReplaceAll[HoldComplete[u], HoldPattern[Divide[x_, y_]] :> Times[x, Power[y, -1]]]},
	reconstructQuantity[m, unit]
]
sanitizeUnitPart[other_] := other

reconstructQuantity[m_, HoldComplete[expr_]] := Quantity[m, expr]
reconstructQuantity[m_, u_] := Quantity[m, u]

getUnitBoxList[q_] := addUnitBoxes[
	Through[
		{unitTableDefaultStyle, unitTableGetPrefixBoxes, unitTableGetPostfixBoxes}[q]
		],
	q
]

unitTableGetStyleAndDisplayBoxes[q_?QuantityQ, form_] := Block[{$removed = {} (*used only for compound unit case*)},
		addUnitStyle[getUnitBoxList[q],form]
	]
unitTableGetStyleAndDisplayBoxes[__] := Throw[$Failed, $typesettingFailureFlag]

replaceStringFunctions[expr_] := ReplaceAll[
	expr,
	{
		"SingleLetterItalicForm"[e_, ___] :> Style[e, Italic],
		"UnicodeSupportBlock"[e_, ___] :> e,
		"UnitBoxWrapper"[___, "StringBoxes" -> e_, ___] :> e
	}
]

styleReplacement[expr_] := ReplaceAll[
	expr,
	{
		TemplateBox[args_, "RowDefault"] :> RowBox[args]
	}
]
unitTableElementLookup["DimensionlessUnit" | "PureUnities", "UnitShortName" | "UnitSingularName" | "UnitPluralName"] := ""
unitTableElementLookup[IndependentUnit[s_String], "UnitShortName" | "UnitSingularName" | "UnitPluralName"] := Framed[
	Style[s,ShowStringCharacters -> False],
	FrameMargins -> 1,
	FrameStyle -> GrayLevel[0.85],
	BaselinePosition -> Baseline,
	RoundingRadius -> 3,
	StripOnInput -> False
]
unitTableElementLookup[u_String, elem_] := replaceStringFunctions[QuantityUnits`$UnitTable[u][elem]]
unitTableElementLookup[__] := None

unitTableGetPrefixBoxes[q_] := unitTableLookupFunction[q, "UnitPrefix"]
unitTableGetPostfixBoxes[q_] := unitTableLookupFunction[q, "UnitPostfix"]

unitTableDefaultStyle[Quantity[_, u_String]] := unitTableElementLookup[u, "DefaultStyle"]
unitTableDefaultStyle[Quantity[m_, DatedUnit[u_, date_]]] := unitTableDefaultStyle[Quantity[m, u]]
unitTableDefaultStyle[Quantity[_, IndependentUnit[u_String]]] := Default
unitTableDefaultStyle[_] := Automatic

unitTableLookupFunction[Quantity[_, u_String], elem_] := unitTableElementLookup[u, elem]
unitTableLookupFunction[Quantity[m_, DatedUnit[u_, date_]], elem_] := unitTableLookupFunction[Quantity[m, u], elem]
(*no prefix/postfix for indepdendent units*)
unitTableLookupFunction[Quantity[_, IndependentUnit[s_String]], elem_] := None

(*compound case*)
(* in the case of compound units we look for prefix/postfix units only from the numerator, and if there are any only use the first,	*
 * and then remove it from the list of units to format in the "UnitBoxes" portion of typesetting later on.							*)
unitTableLookupFunction[Quantity[expr_, unit_], elem_] := Module[{num = Numerator[Unevaluated[unit]], pos, index},
	If[MatchQ[num, _Times], num = List @@ num, num = {num}];
	pos = Position[num, u_ /; unitTableElementLookup[u, elem] =!= None, 1, 1];
	If[MatchQ[pos, {_}],
		index = pos[[1, 1]];
		index = num[[index]];
		AppendTo[$removed, index];
		unitTableElementLookup[index, elem],
		
		None
	]
]

getCompoundUnitBoxes[Quantity[_, unit_]] := Module[{num = Numerator[Unevaluated[unit]], den = Denominator[Unevaluated[unit]]},
	If[MatchQ[num, _Times], num = List @@ num, num = {num}];
	If[MatchQ[den, _Times], den = List @@ den, den = {den}];
	(*remove any units which have already generated prefix/postfix boxes*)
	num = DeleteCases[num, Alternatives @@ $removed];
	(* sort by unit dimensions *)
	num = num[[Ordering[MLTRank /@ num]]];
	den = den[[Ordering[MLTRank /@ den]]];
	
	ToNDBoxes[num, den]
]
(* unit dimensions ranking taken from W|A source *)
MLTRank[u_^_.] := If[KnownUnitQ[u], 
	Switch[UnitDimensions[u],
		{} | {{"PersonUnit", _}}, 1,
		{{"MassUnit", _}}, 2,
		{{"LengthUnit", _}}, 3,
		{{"TimeUnit", _}}, 4,
		{{"ElectricCurrentUnit", _}}, 5,
		{{"TemperatureUnit", _}}, 6,
		{{"AmountUnit", _}}, 7,
		{{"LuminousIntensityUnit", _}}, 8,
		_, 9
		],
	10
]

addUnitBoxes[{style_, None, None}, Quantity[n_, u_String]] := Module[{boxes = unitTableElementLookup[u, "UnitShortName"]},
	If[boxes === None,
		boxes = If[
			TrueQ[Abs[n] == 1],
			unitTableElementLookup[u, "UnitSingularName"],
			unitTableElementLookup[u, "UnitPluralName"]
		]
	];
	With[{b = boxes},
		{None, None, If[b === "", b, MakeBoxes[b, TraditionalForm]] }
	]
]
addUnitBoxes[{style_, pre_, post_}, Quantity[n_, u_String]] := {pre, post, None}
addUnitBoxes[{style_, pre_, post_}, q_] := {pre, post, getCompoundUnitBoxes[q]}

ToNDBoxes[{}, {d_^n_.}] := ToPerBox[d, n]
ToNDBoxes[{1}, {d_^n_.}] := Module[
	{gray = Replace[unitTableElementLookup[d, "UnitShortName"], {_unitTableElementLookup | "" -> "Long", _ -> unitTableElementLookup[d, "DefaultStyle"]}]},
	If[
		gray === "Long",
		ToPerBox[d, n],
		ToSlashBox[d^n]
	]
]
ToNDBoxes[{1} | {}, {den__}] := Module[
	{unit = Replace[Times[den], {{{u_, _}, ___} -> u, _ -> None}], gray},
	Which[
		unit =!= None, ToNDBoxes[{1}, {unit}], 
		gray = Replace[{den}, d_^_. :> Replace[unitTableElementLookup[d, "UnitShortName"], {_unitTableElementLookup | "" -> "Long", _ -> unitTableElementLookup[d, "DefaultStyle"]}], {1}];
		MemberQ[gray, "Long"], RowBox[Replace[{den}, x_^n_. :> ToPerBox[x, n], {1}]],
		True, ToSlashBox[den]
	]
]
ToNDBoxes[num_, {1} | {}] := RowBox[UnitPowerBox[num, "P"]]
ToNDBoxes[num_, {d_}] := RowBox[
	Join[
		UnitPowerBox[num, "P"],
		{
			If[
				MatchQ[num, {___, _Power}],
				"\[NegativeMediumSpace]",
				"\[InvisibleSpace]"
			],
			"\"/\"",
			"\[InvisibleSpace]",
			UnitPowerBox[d, "S"]
		}
	]
]
ToNDBoxes[num_, den_] := RowBox[
	Join[
		UnitPowerBox[num, "P"], 
		{
			If[
				MatchQ[num, {___, _Power}],
				"\[NegativeMediumSpace]",
				"\[InvisibleSpace]"
			],
			"\"/(\"",
			"\[InvisibleSpace]"
		},
		UnitPowerBox[den, "S"],
		{
			"\[InvisibleSpace]",
			"\")\""
		}
	]
]

ToPerBox[d_, n_] := Module[{id, in, name},
	{id, in} = If[
		n == 1,
		{d, n},
		Replace[d^n, {{{u_, _}, ___} :> {u, 1}, _ -> {d, n}}]
	];
	name = MakeBoxes[#, TraditionalForm] &[
		unitTableElementLookup[id, "UnitSingularName"] /. _unitTableElementLookup | None -> ToLowerCase[ToString@id]
	];
	Replace[
		in, 
		{
			1 :> RowBox[{"\"per \"", "\[InvisibleSpace]", name}],
			e_Rational :> RowBox[{"\"per \"", "\[InvisibleSpace]", SuperscriptBox[name, ToBoxes[e, TraditionalForm]]}],
			e_ :> RowBox[{"\"per \"", "\[InvisibleSpace]", SuperscriptBox[name, MakeBoxes[e, TraditionalForm]]}]
		}
	]
]

ToSlashBox[d_] := RowBox[{"\"/\"", "\[InvisibleSpace]", UnitPowerBox[d, "S"]}]
ToSlashBox[d__] := RowBox[Flatten@{"\"/(\"", "\[InvisibleSpace]", UnitPowerBox[{d}, "S"], "\[InvisibleSpace]", "\")\""}]

UnitPowerBox[u_, plurality_] := With[{short = shortname[u, plurality]}, MakeBoxes[short, TraditionalForm]]
UnitPowerBox[u_^n_, plurality_] := With[{short = shortname[u, plurality]}, MakeBoxes[Power[short, n], TraditionalForm]]
UnitPowerBox[u_List, plurality_] := Riffle[
	MapThread[
		UnitPowerBox,
		{u, Append[Table["S", {Length[u] - 1}], plurality]}
	],
	Replace[Most@u, {_Power -> "\[InvisibleSpace]", _ -> "\[ThinSpace]"}, {1}]
]

shortname[u:(_String | _IndependentUnit | _DatedUnit), plurality_] := Module[{name = unitTableElementLookup[u, "UnitShortName"]},
	Which[
		!MatchQ[name, None | ""], name,
		name = unitTableElementLookup[u, Switch[plurality, "S", "UnitSingularName", _, "UnitPluralName"]];
		!MatchQ[name, _unitTableElementLookup | ""], name,
		True, ToLowerCase[ToString[u]]
	]
]
shortname[u_Times, plurality_] := Map[
	shortname[#, plurality]&, 
	u
]
(*catch-all case to handle deeply nested unit exprs without re-implementing UnitPowerBox again*)
shortname[other_, plurality_] := RawBoxes[UnitPowerBox[other, plurality]]


addUnitStyle[{pre_, post_, label_}, form_] := Module[{styleName, boxes},
	{styleName, boxes} = Switch[{pre, post, label},
		{None, None, Except[None]}, {"Quantity", {label}},
		{None, Except[None], None}, {"QuantityPostfix", {post}},
		{None, Except[None], Except[None]}, {"QuantityUnitPostfix", {post, label}},
		{Except[None], None, None}, {"QuantityPrefix", {pre}},
		{Except[None], None, Except[None]}, {"QuantityPrefixUnit", {pre, label}},
		{Except[None], Except[None], None}, {"QuantityPrefixPostfix", {pre, post}},
		{Except[None], Except[None], Except[None]}, {"QuantityPrefixUnitPostfix", {pre, post, label}},
		 _, {"Quantity", ""}(*fallback;blank label*)
	];
	If[SameQ[form, TraditionalForm], styleName = StringJoin[styleName, "TF"]];
	{styleName, styleReplacement[boxes]}
]

(*long names*)
longName[Quantity[n_, u_String]] := Module[{long},
	If[
		TrueQ[Abs[n] == 1],
		long = unitTableElementLookup[u, "UnitSingularName"];
		If[long === None,
			long = unitTableElementLookup[u, "UnitPluralName"]
		],
		long = unitTableElementLookup[u, "UnitPluralName"];
		If[long === None,
			long = unitTableElementLookup[u, "UnitSingularName"]]
	];
	If[
		long === None,
		long = ToString[u]
	];
	long
]

extractUnitPowers[expr_] := Module[{res},
	res = Cases[expr, u_IndependentUnit :> {u, Exponent[PowerExpand@expr, u]}, {0, Infinity}];
	Join[Cases[ReplaceAll[expr, _IndependentUnit -> 1], u_String :> {u, Exponent[PowerExpand@expr, u]}, {0, Infinity}], res]
]

longName[Quantity[n_, unit_]] := Module[{num, den},
	{num, den} = Through[{Numerator, Denominator}[Unevaluated[unit]]];
	num = extractUnitPowers[num];
	den = extractUnitPowers[den];
	MUnitName[
		TrueQ[Abs[n] === 1],
		num[[Ordering[MLTRank /@ num[[All, 1]]]]],
		den[[Ordering[MLTRank /@ den[[All, 1]]]]]
	]
]

UnitToString[e_, IndependentUnit[u_]] := u
UnitToString[1, x_] := Module[{string = unitTableElementLookup[x, "UnitSingularName"]},
	If[
		string =!= None,
		string,
		string = unitTableElementLookup[x, "UnitPluralName"];
		If[string =!= None,
			string,
			string = unitTableElementLookup[x, "UnitShortName"];
			If[string =!= None,
				string,
				ToString[x]
			]
		]
	]
]

UnitToString[_, x_] := Module[{string = unitTableElementLookup[x, "UnitPluralName"]},
	If[
		string =!= None,
		string,
		string = unitTableElementLookup[x, "UnitSingularName"];
		If[string =!= None,
			string,
			string = unitTableElementLookup[x, "UnitShortName"];
			If[string =!= None,
				string,
				ToString[x]
			]
		]
	]
]

MUnitName[x01_, num_, den_] := Switch[
	{num, den},
	{{}, {}}, None,
	{_, {}}, MUnitName[x01, num],
	{{}, _}, Row[{Replace[den, {{{_, 1}} -> "reciprocal", _ -> "per"}], " ", MUnitName[x01, den]}],
	_, StringTemplate["`1` per `2`"][MUnitName[x01, num], MUnitName[True, den]]
]

MUnitName[True, ls_] := Row[Riffle[MUnitName[{UnitToString[1, #[[1]]], #[[2]]}] & /@ ls, " "]]

MUnitName[False, ls_] := StringJoin[
	Riffle[
		Append[
			MUnitName[{UnitToString[1, #[[1]]], #[[2]]}] & /@ Most[ls],
			MUnitName[{UnitToString[2, ls[[-1, 1]]], ls[[-1, 2]]}]
		],
		" "
	]
]

MUnitName[{x1_, 0}] := x1
MUnitName[{x1_, 1}] := x1
MUnitName[{x1_, 2}] := StringTemplate["`1` squared"][x1]
MUnitName[{x1_, 3}] := StringTemplate["`1` cubed"][x1]
MUnitName[{x1_, 4}] := StringTemplate["`1` to the fourth"][x1]
MUnitName[{x1_, 5}] := StringTemplate["`1` to the fifth"][x1]
MUnitName[{x1_, 1/2}] := StringTemplate["square root `1`"][x1]
MUnitName[{x1_, 1/3}] := StringTemplate["cube root `1`"][x1]
MUnitName[{x1_, 1/4}] := StringTemplate["`1` to the one fourth"][x1]
MUnitName[{x1_, 2/3}] := StringTemplate["`1` to the two thirds"][x1]
MUnitName[{x1_, n_}] := StringTemplate["`1` to the `2`"][x1, ToString[n, InputForm]]
(**)
$UnitDisplayCache=System`Utilities`HashTable[];
$UnitDisplayCacheSize=0;
$MaxCacheSize=50;

SetAttributes[UnitDisplayCacheContainsQ,HoldAll];
UnitDisplayCacheContainsQ[unit_]:=System`Utilities`HashTableContainsQ[$UnitDisplayCache,HoldForm[unit]]
UnitDisplayCacheContainsQ[___]:=False

UnitDisplayCacheAdd[heldform_,boxes_]:=(If[TrueQ[$UnitDisplayCacheSize>=$MaxCacheSize],
	Clear[$UnitDisplayCache];$UnitDisplayCache=System`Utilities`HashTable[];$UnitDisplayCacheSize=1;,
	$UnitDisplayCacheSize++];
	System`Utilities`HashTableAdd[$UnitDisplayCache,heldform,boxes]);
UnitDisplayCacheGet[heldform_, form_]:= handleQuantityTypsetForm[System`Utilities`HashTableGet[$UnitDisplayCache,heldform], form]

handleQuantityTypsetForm[tb:TemplateBox[boxes_, qform_String, opts___], TraditionalForm] := If[StringMatchQ[qform, __~~"TF"],
	tb,
	TemplateBox[boxes, qform <> "TF", opts]
]
handleQuantityTypsetForm[boxes_, _] := boxes

SetAttributes[getUnitDisplayForm,HoldAll];
getUnitDisplayForm[unit_, 1, form_] := QuantityUnitBox[Quantity[1,unit], form] (*don't used cached name for unity values*)

getUnitDisplayForm[unit_,None, form_] := With[{hf=HoldForm[unit]},
	UnitDisplayCacheGet[hf, form]/.{
		ToString[$UnitDisplayTemporaryVariable]->InterpretationBox["\[InvisibleSpace]", 1],
		ToString[$UnitDisplayTemporaryValue] ->None}]
		
getUnitDisplayForm[unit_, n_, form_]:=With[{hf=HoldForm[unit]},
	UnitDisplayCacheGet[hf, form]/.{
		ToString[$UnitDisplayTemporaryVariable]->makeNumberValue[n, unit, form], 
		ToString[$UnitDisplayTemporaryValue] -> MakeBoxes[n, form]}]

(*SetAttributes[makeNumberValue, HoldAll]*)

$2digitCurrencyPattern = Alternatives["USDollars", "Euros",
	"AfghanAfghani", "AlbanianLeke", "ArmenianDram", "NetherlandsAntillesGuilders", "AngolaKwanzaReajustado",
	"AngolaNewKwanza", "AngolanKwanza", "AngolanKwanza1990", "ArgentinaAustral", "ArgentinaPesoArgentino",
	"ArgentinaPesoLey", "ArgentinaPesoMonedaNacional", "ArgentinePesos", "AustralianDollars", "ArubanFlorins",
	"AustralianPound", "NetherlandsAntilleanGuilder", "AzerbaijanAzerbaijanianManat", "AzerbaijaniManat",
	"AzerbaijanSovietRuble", "BosnianHerzegovinianMaraka", "BarbadianDollars", "BangladeshiTaka", "BulgarianLev1999",
	"BulgarianLeva", "BermudaDollars", "BruneiDollars", "BolivianBolivianos", "BolivianBolivianos1962", 
	"BoliviaPesoBoliviano", "BrazilCruzado", "BrazilCruzeiro", "BrazilCruzeiroNovo", "BrazilCruzeiroReal",
	"BrazilianReais", "BrazilNewCruzado", "BahamianDollars", "BhutanNgultrum", "BotswanaPula", "BelizeDollars",
	"CanadianDollars", "CongoleseFranc", "CongoleseFranc1967", "ZaireanNewZaire", "ZaireanZaire", "SwissFrancs",
	"ChineseYuan", "ColombianPesos", "CostaRicanColones", "CubanConvertiblePesos", "CubanPesos", "CzechKoruny",
	"DanishKroner", "DominicanPesos", "AlgerianDinars", "EgyptianPounds", "EritreanNakfas", "EthiopianBirr",
	"EstonianKrooni", "LatvianLati", "LithuanianLitai", "SlovakKorun", "SlovenianTolarjev", "FijianDollars",
	"FalklandIslandsPounds", "BritishPounds", "GibraltarPounds", "GuernseyPounds", "IsleOfManPounds", 
	"JerseyPounds", "GeorgiaGeorgianCoupon", "GeorgianLari", "GeorgiaSovietRuble", "GhanaCedi1967", "GhanaCedi2007",
	"GhanaGhanaianPound", "GhanianCedis", "GambianDalasi", "GambianPound", "GuatemalaQuetzales", "GuyaneseDollars",
	"HongKongDollars", "HonduranLempiras", "CroatiaCroatianDinar", "CroatianKuna", "CroatiaYugoslavDinar", 
	"CroatiaYugoslavHardDinar", "HaitiGourdes", "HungarianForints", "IndonesianRupiahs", "IndonesiaOldRupiah",
	"IsraeliLira", "IsraeliShekels", "OldShekel", "IndianRupees", "IranianRials", "JamaicanDollars", "JamaicanPound",
	"EastAfricanShilling", "KenyanShillings", "KyrgyzstanSom", "CambodianRiels", "NorthKoreanWon", "CaymanIslandsDollars",
	"KazakhstanTenge", "LaoKips", "LebanesePounds", "SriLankaRupees", "LiberianDollars", "LesothoMaloti", "LibyanPound",
	"MoroccanDirhams", "MoldovanLei", "MacedonianDenars", "MyanmarKyat", "MongolianTugrik", "MacauPatacas", 
	"MaldivesRufiyaa", "MalawiKwacha", "MexicanPesos", "MexicanPesos1992", "MalayaAndBritishBorneoDollar", 
	"MalaysianRinggits", "MozambiqueEscudo", "MozambiqueMeticais", "MozambiqueMetical", "NamibianDollars",
	"NigeriaNigerianPound", "NigerianNaira", "NicaraguaCordobas", "NorwegianKroner", "NepaleseRupees", "CookIslandsDollars",
	"NewZealandDollars", "NewZealandPound", "PitcairnIslandsDollars", "PeruInti", "PeruvianSoles", "PeruvianSoles1985",
	"PapuaNewGuineaKina", "PhilippinePesos", "PakistaniRupees", "PolishZlotych", "PolishZlotych1994", "QatarRials",
	"RomanianLei", "SerbianDinars", "RussianRubles", "RussianRubles1997", "RussianSovietRubles", "SaudiArabianRiyals",
	"SolomonIslandsDollars", "SeychellesRupees", "SudanesePounds", "SudanesePounds1992", "SudanSudaneseDinar", 
	"SwedishKronor", "SingaporeDollars", "SaintHelenaPounds", "SierraLeoneLeones", "SomaliShillings", "SurinameDollars",
	"SurinameSurinamGuilder", "SaoTomeDobras", "ElSalvadorColones", "SyrianPounds", "SwazilandEmalangeni", "ThaiBaht",
	"TajikistanSomoni", "TurkmenManat", "TongaPaanga", "TurkeyOldTurkishLira", "TurkishLiras", "BritishWestIndiesDollar", 
	"TrinidadTobagoDollars", "TaiwanDollars", "TanzanianShillings", "UkraineHryven", "UkraineKarbovanet",
	"UkraineSovietRuble", "UruguayanPesos", "UruguayanPesos1972", "UruguayNuevoPeso", "UzbekistanSom", 
	"VenezuelanBolivares", "SamoanTala", "EastCaribbeanDollars", "SouthYemeniDinar", "SouthAfricanPound",
	"SouthAfricanRand", "ZambianKwacha", "ZambianKwacha2012"
];
$3digitCurrencyPattern = Alternatives[
	"BahrainiDinars", "IraqiDinars", "JordanianDinars", "KuwaitiDinars", "LibyanDinars", "OmaniRials", "TunisianDinars"
];
SetAttributes[makeNumberValue, HoldFirst];

makeNumberValue[n_Real, $2digitCurrencyPattern, form_] := With[{boxes = If[TrueQ[-10^6 < n < 10^6],
	Quiet[Parenthesize[
	NumberForm[n, {Infinity, 2},  DigitBlock -> 3, NumberSeparator -> "\[ThinSpace]"], 
	form, Mod], {NumberForm::sigz}],
	Parenthesize[n, form, Mod]
	]},
	InterpretationBox[boxes, n, Selectable -> False]
]
makeNumberValue[n_Real, $3digitCurrencyPattern, form_] := With[{boxes = If[TrueQ[-10^6 < n < 10^6],
	Quiet[Parenthesize[
	NumberForm[n, {Infinity, 3},  DigitBlock -> 3, NumberSeparator -> "\[ThinSpace]"], 
	form, Mod], {NumberForm::sigz}],
	Parenthesize[n, form, Mod]
	]},
	InterpretationBox[boxes, n, Selectable -> False]
]
makeNumberValue[i:Interval[{min_, max_}], _, form_] := With[{minbox = MakeBoxes[min, form], maxbox = MakeBoxes[max, form]},
	InterpretationBox[
	RowBox[{"(", "\[InvisibleSpace]", minbox, StyleBox["\"to\"", FontSize -> Inherited -2], maxbox, "\[InvisibleSpace]", ")"}],
	i,
	Selectable -> False
	]
]
makeNumberValue[n_, _, form_] := If[BoxForm`NumberFormStatus[] === PercentForm,
	Parenthesize[NumberForm[n], form, Mod],
	Parenthesize[n, form, Mod]
]


(*box constructor called from Startup/typesetinit.m *)
SetAttributes[QuantityBox,HoldAllComplete];

QuantityBox[Quantity[n_,unit_?UnitDisplayCacheContainsQ], form_:StandardForm]:=Quiet[getUnitDisplayForm[unit, n, form], {Part::partw}]
QuantityBox[q:Quantity[_, _?KnownUnitQ],fmt__]:= With[{quantity = sanitizeUnitPart[q]}, QuantityUnitBox[quantity,fmt]]
	
QuantityBox[q:Quantity[___],fmt__]:= Block[{$UnitMBF=True},MakeBoxes[q,fmt]]
QuantityBox[other_,fmt__]:=MakeBoxes[other,fmt]

SetAttributes[LooksLikeAUnitQ,HoldAllComplete];(*utility to avoid unneeded evaluation leaks in typesetting*)
LooksLikeAUnitQ[__]=False
LooksLikeAUnitQ[_String]=True
LooksLikeAUnitQ[_Times]=True
LooksLikeAUnitQ[_Power]=True
LooksLikeAUnitQ[_Divide]=True
LooksLikeAUnitQ[_DatedUnit]=True
LooksLikeAUnitQ[_IndependentUnit]=True
LooksLikeAUnitQ[_MixedUnit]=True
LooksLikeAUnitQ[1]=True

(*these units use characters which aren't included with standard Windows fonts*)
$fonttroubleunits = Alternatives["PercentPercent", "ApothecariesPounds","ApothecariesOunces", "ApothecariesScruples"];

SetAttributes[getunitBoxes, HoldRest];
getunitBoxes[num_, unit_] := With[{b = Last[addUnitBoxes[{Default, None, None}, Quantity[num, unit]]]},
	If[b === "" || b === None,
		longName[Quantity[num, unit]],
		b
	]
]

(*display box for IndependentUnits*)
freeUnitFrameBox[s_String]:=FrameBox[StyleBox[MakeBoxes[s],ShowStringCharacters -> False], 
     FrameMargins -> 1,
     FrameStyle -> GrayLevel[0.85],
     BaselinePosition -> Baseline,
     RoundingRadius -> 3,
     StripOnInput -> False]
     
FreeUnitForm/:MakeBoxes[FreeUnitForm[x_String],_]:=freeUnitFrameBox[x]

(*used to prevent Alpha form output from escaping, shouldn't ever end up with this being output*)
SetAttributes[qlsafe,HoldFirst];

qlsafe[arg1_,args___]:=Module[
	{ql=QuantityLabel[arg1,args]},
	If[Head[ql]=!=QuantityLabel,ql,With[{u=Quiet[Check[ql[[1,2]],"unk"]]},Message[Quantity::unkunit,u]];"UnknownUnit",Message[qlsafe::failed];$Failed]]


(*QuantityLabel is used to create the various display forms associated with Quantity & unit labels*)
Options[QuantityLabel] = {Format -> Automatic, "Singular"->False, "OutputForm"->False};
Attributes[QuantityLabel] = {HoldAll};

(*allows HoldForm, for things like Meters/Meters*)
QuantityLabel[HoldForm[args__],opts___]:=QuantityLabel[args,opts]

QuantityLabel[Quantity[val_,IndependentUnit[s_String]],OptionsPattern[]]:=Switch[OptionValue[Format],
	"UnitString",
	ToString[val]<>" "<>s,
	"FullUnitLabelWithDescription",
	RowBox[{MakeBoxes[val]," ",freeUnitFrameBox[s]}],
	"UnitLabel",
	RowBox[{MakeBoxes[val]," ",freeUnitFrameBox[s]}],
	"UnitPrefixLabel",
	"",
	"UnitPostfixLabel",
	"",
	"FullUnitLabel",
	RowBox[{MakeBoxes[val]," ",freeUnitFrameBox[s]}],
	"TypesetUnit"|Automatic,
	Row[{val," ",s}],
	_,
	Message[QuantityLabel::bdfmt,OptionValue[Format]];$Failed]
	
QuantityLabel[IndependentUnit[s_String],OptionsPattern[]]:=Switch[OptionValue[Format],
	"UnitPrefixLabel",
	"",
	"UnitLabel",
	freeUnitFrameBox[s],
	"UnitPostfixLabel",
	"",
	"FullUnitLabel",
	freeUnitFrameBox[s],
	"FullUnitLabelWithDescription",
	RowBox[{"",freeUnitFrameBox[s],"",StyleBox[RowBox[{" (",MakeBoxes[s],")"}],FontColor -> GrayLevel[0.5]]}],
	"TypesetUnit"|Automatic|"UnitString",
	s,
	_,
	Message[QuantityLabel::bdfmt,OptionValue[Format]];$Failed]
	
(*protection against edge-cases where independent units sneak into alpha formatting*)
QuantityLabel[IndependentUnit[s_Symbol],OptionsPattern[]]/;KnownUnitQ[s]:=""

QuantityLabel[DatedUnit[u_,___],o:OptionsPattern[]]:=QuantityLabel[u,o]
QuantityLabel[Quantity[val_,DatedUnit[u_,___]],o:OptionsPattern[]] := QuantityLabel[Quantity[val,u],o]

(*general case*)
QuantityLabel[unit:(_String|_Power|_Times|_Divide), opts:OptionsPattern[]]/;KnownUnitQ[unit] := 
Module[
	{num=If[TrueQ[OptionValue["Singular"]],1,2,2]},
	If[Head[unit] === Times || Head[unit] === Integer,
		Switch[OptionValue[Format],
			"UnitString",
			longName[Quantity[num, unit]],
			"UnitLabel",
			getunitBoxes[num, unit],
			"UnitPrefixLabel",
			unitTableGetPrefixBoxes[Quantity[num, unit]],
			"UnitPostfixLabel",
			unitTableGetPostfixBoxes[Quantity[num, unit]],
			"TypesetUnit",
			unitFunction2String[unit],
			"FullUnitLabel",
			UnitAbbreviation[unit,opts],
			"FullUnitLabelWithDescription",
			RowBox[{
				UnitAbbreviation[unit,opts],
				StyleBox[RowBox[{
					"(",
					longName[Quantity[num,unit]],
					")"}],
					FontColor -> GrayLevel[0.5]
				]
			}],
			"TypesetUnit"|Automatic,
			unitFunction2String[unit],
			_,
			Message[QuantityLabel::bdfmt,OptionValue[Format]];$Failed
		],
		Switch[OptionValue[Format],
			"UnitLabel",
			getunitBoxes[num, unit],
			"UnitPrefixLabel",
			unitTableGetPrefixBoxes[Quantity[num, unit]],
			"UnitPostfixLabel",
			unitTableGetPostfixBoxes[Quantity[num, unit]],
			"FullUnitLabel",
			UnitAbbreviation[unit,opts],
			"FullUnitLabelWithDescription",
			RowBox[{
				UnitAbbreviation[unit,opts],
				StyleBox[RowBox[{"(",longName[Quantity[num, unit]],")"}],FontColor -> GrayLevel[0.5]]
			}],
			"TypesetUnit"|Automatic|"UnitString",
			If[Head[unit]=!=Symbol&&Head[unit]=!=Power,
			unit,
			longName[Quantity[num, unit]]
			],
			_,
			Message[QuantityLabel::bdfmt,OptionValue[Format]];$Failed]
		]
	]
	
(*general case for just unit*)
QuantityLabel[unit_,opts:OptionsPattern[]]/;Head[unit]=!=Quantity/;KnownUnitQ[unit]:= 
Module[{num=If[TrueQ[OptionValue["Singular"]],1,2,2]},
	If[Head[unit] === Times || Head[unit] === Integer,
		Switch[OptionValue[Format],
			"UnitString",
			longName[Quantity[num, unit]],
			"UnitLabel",
			getunitBoxes[num, unit],
			"UnitPrefixLabel",
			unitTableGetPrefixBoxes[Quantity[num, unit]],
			"UnitPostfixLabel",
			unitTableGetPostfixBoxes[Quantity[num, unit]],
			"TypesetUnit",
			unitFunction2String[unit],
			"FullUnitLabel",
			UnitAbbreviation[unit,opts],
			"FullUnitLabelWithDescription",
			RowBox[{UnitAbbreviation[unit,opts],
				StyleBox[RowBox[{"(",longName[Quantity[num, unit]],")"}],FontColor -> GrayLevel[0.5]]
			}],
			"TypesetUnit"|Automatic,
			unitFunction2String[unit],
			_,
			Message[QuantityLabel::bdfmt,OptionValue[Format]];$Failed
		],
		Switch[OptionValue[Format],
			"UnitLabel",
			getunitBoxes[num, unit],
			"UnitPrefixLabel",
			unitTableGetPrefixBoxes[Quantity[num, unit]],
			"UnitPostfixLabel",
			unitTableGetPostfixBoxes[Quantity[num, unit]],
			"FullUnitLabel",
			UnitAbbreviation[unit,opts],
			"FullUnitLabelWithDescription",
			RowBox[{UnitAbbreviation[unit,opts],
				StyleBox[RowBox[{"(",longName[Quantity[num, unit]],")"}],FontColor -> GrayLevel[0.5]]}],
			"TypesetUnit"|Automatic|"UnitString",
			If[
				Head[unit]=!=Symbol&&Head[unit]=!=Power,
				unit,
				longName[Quantity[num, unit]]
			],
			_,
			Message[QuantityLabel::bdfmt,OptionValue[Format]];$Failed]
		]
	]


(*pattern used to check for various spaces in formatting*)
whitespacepattern=(WhitespaceCharacter|"\[ThinSpace]"|""|"\[ThickSpace]"|"\[InvisibleSpace]");	

Options[QuantityUnits`ToQuantityShortString] = {"SpecialFormattingCharacters" -> True};

QuantityUnits`ToQuantityShortString[q_Quantity?QuantityQ, opts:OptionsPattern[]] := stringifyQuantity[q, opts]
QuantityUnits`ToQuantityShortString[___] := $Failed 

stringifyQuantity[q:Quantity[mag_, unit_MixedUnit], opts:OptionsPattern[]] := Module[{boxes = getMixedRadixMagnitudeAndUnitBoxes[mag, unit, StandardForm], part},
		If[ListQ[boxes] && Divisible[Length[boxes], 2],
			part = Partition[boxes, Length[boxes]/2];
			If[
				stringifyableBoxesQ[{"Mixed", Last[part]}],
				Catch[
					mixedquantityBoxesToString[q, part, OptionValue[QuantityUnits`ToQuantityShortString, {opts}, "SpecialFormattingCharacters"]],
					"quantityStringifyBailOut"
				],
				ToString[q]
			],
			ToString[q]
	]
]

stringifyQuantity[q:Quantity[mag_,unit_], opts:OptionsPattern[]] := Module[{boxes = unitTableGetStyleAndDisplayBoxes[q, OutputForm]},
		If[stringifyableBoxesQ[boxes],
			Catch[
				quantityBoxesToString[q, boxes, OptionValue[QuantityUnits`ToQuantityShortString, {opts}, "SpecialFormattingCharacters"]],
				"quantityStringifyBailOut"
			],
			ToString[q]
	]
]

stringifyQuantity[other_, OptionsPattern[]] := ToString[other]

$permissableBoxPattern = Alternatives[FormBox[_, TraditionalForm], _String];
$permissableBoxContainer = RowBox[{$permissableBoxPattern..}];

stringifyableBoxesQ[{_String, {$permissableBoxPattern..}}] := True
stringifyableBoxesQ[{_String, boxes:{$permissableBoxContainer..}}] := FreeQ[boxes, SubscriptBox|SuperscriptBox]
stringifyableBoxesQ[___] := False

$boxReplacementRules = {RowBox -> Row, FormBox[text_String, TraditionalForm] :> text, "None" -> Nothing};

boxStringCleanup[boxes_] := ReplaceRepeated[
	boxes,
	{s_String /; StringMatchQ[s, "\"" ~~ __ ~~ "\""] :> ToExpression[s]}
]

quantityBoxesToRowSequence[input_, boxes_] := Quiet[
	Check[
		boxStringCleanup[ReplaceAll[boxes, $boxReplacementRules]],
		Throw[QuantityLabel[input, Format -> "UnitString", "OutputForm" ->True], "quantityStringifyBailOut"]
	]
]

mixedquantityBoxesToString[q_, boxes_, sfc_] := Module[{row = quantityBoxesToRowSequence[q, boxes]},
	quantityStringCleanup[ToString[Row[Join@@Riffle[Transpose[row], {{" "}}]]], sfc]
]

quantityBoxesToString[input:Quantity[mag_, unit_], {template_, boxes_}, sfc_] := Module[{row = quantityBoxesToRowSequence[input, boxes]},
	quantityStringCleanup[ToString[Switch[template,
		"Quantity", Row[{makeQuantityStringNumber[mag, unit], " ", Sequence@@row}],
		"QuantityPostfix", Row[{makeQuantityStringNumber[mag, unit], Sequence@@row}],
		"QuantityUnitPostfix", Row[{makeQuantityStringNumber[mag, unit], Row[row, " "]}],
		"QuantityPrefix", Row[{Sequence@@row, makeQuantityStringNumber[mag, unit]}],
		"QuantityPrefixUnit", Row[Insert[row, Row[{makeQuantityStringNumber[mag, unit], " "}], 2]],
		"QuantityPrefixPostfix", Row[Insert[row, makeQuantityStringNumber[mag, unit], 2]],
		"QuantityPrefixUnitPostfix", Row[Insert[Insert[row, makeQuantityStringNumber[mag, unit], 2], " ", 4]]
	]], sfc]
]

makeQuantityStringNumber[n_, _] := n

quantityStringNumberFormat[n_Real, $2digitCurrencyPattern] := If[TrueQ[-10^6 < n < 10^6],
	NumberForm[n, {Infinity, 2},  DigitBlock -> 3, NumberSeparator -> ""],
	n
]
quantityStringNumberFormat[n_Real, $3digitCurrencyPattern] := If[TrueQ[-10^6 < n < 10^6],
	NumberForm[n, {Infinity, 3},  DigitBlock -> 3, NumberSeparator -> ""],
	n
]
quantityStringNumberFormat[other_, _] := other

quantityStringCleanup[string_String, False] := StringReplace[string, {"\[VeryThinSpace]" -> "", "\[InvisibleSpace]" -> ""}]
quantityStringCleanup[other_, _] := other

composeQuantityRowIntoString[row_] := ToString[row, OutputForm]


quantityToExplicitString[{mag_, unit_, of_}] := With[{fmt = If[TrueQ[of], OutputForm, StandardForm]},
	ToString[
		StringForm["`1` `2`", mag, longName[Quantity[mag, unit]]],
		fmt
	]
]

(*general case for quantities*)
QuantityLabel[Quantity[mag_, unit:Except[_MixedUnit]], opts:OptionsPattern[]] := 
Switch[OptionValue[Format],
	"UnitString",
	ToString[StringForm["`1` `2`",mag, longName[Quantity[If[TrueQ[OptionValue["Singular"]], 1, mag], unit]]],If[OptionValue["OutputForm"],OutputForm,StandardForm,StandardForm]],
	"UnitLabel",
	RowBox[{makeNumberValue[mag, unit, StandardForm]," ",QuantityLabel[unit,opts]}],
	"UnitPrefixLabel",
	RowBox[{QuantityLabel[unit,opts], makeNumberValue[mag, unit, StandardForm]}],
	"UnitPostfixLabel",
	RowBox[{makeNumberValue[mag, unit, StandardForm], QuantityLabel[unit,opts]}],
	"FullUnitLabel",
	(QuantityAbbreviation[mag,unit,opts]/.Slot[1] -> makeNumberValue[mag, unit, StandardForm]),
	"FullUnitLabelWithDescription",
	With[{box=(QuantityAbbreviation[mag,unit,opts]/.Slot[1] -> makeNumberValue[mag, unit, StandardForm])},
	RowBox[{box,StyleBox[RowBox[{"(", longName[Quantity[mag, unit]],")"}],FontColor -> GrayLevel[0.5]]}]],
	"TypesetUnit"|Automatic,
	Row[{mag," ",QuantityLabel[unit,opts]}],
	_,
	Message[QuantityLabel::bdfmt,OptionValue[Format]];$Failed
]

QuantityLabel[list_List, opts___?OptionQ] := Row[QuantityLabel[#,opts]&/@list]

(*general case for singular-cases*)
QuantityLabel[Quantity[one_, unit_], opts:OptionsPattern[]]/;Abs[one]===1:=
Switch[OptionValue[Format],
	"UnitString",
	ToString[StringForm["`1` `2`", one, longName[Quantity[one, unit]]],If[OptionValue["OutputForm"],OutputForm,StandardForm,StandardForm]],
	"UnitLabel",
	RowBox[{MakeBoxes[one]," ",QuantityLabel[unit,"Singular"->True,opts]}],
	"UnitPrefixLabel",
	RowBox[{QuantityLabel[unit,"Singular"->True,opts],MakeBoxes[one]}],
	"UnitPostfixLabel",
	RowBox[{MakeBoxes[one],QuantityLabel[unit,"Singular"->True,opts]}],
	"FullUnitLabel",
	(QuantityAbbreviation[1,unit]/.Slot[1]->MakeBoxes[one]),
	"FullUnitLabelWithDescription",
	With[{box=(QuantityAbbreviation[1,unit]/.Slot[1]->MakeBoxes[one])},
	RowBox[{box,StyleBox[RowBox[{"(",longName[Quantity[one, unit]],")"}],FontColor -> GrayLevel[0.5]]}]],
	"TypesetUnit"|Automatic,
	Row[{one," ",QuantityLabel[unit,"Singular"->True,opts]}],
	_,
	Message[QuantityLabel::bdfmt,OptionValue[Format]];$Failed
]

QuantityLabel[q:Quantity[i:Interval[{lower_,upper_}], unit_MixedUnit], opts:OptionsPattern[]] := With[
	{box1 = QuantityLabel[Quantity[lower, unit],opts], box2 = QuantityLabel[Quantity[upper, unit],opts]},
	Switch[OptionValue[Format],
	"UnitString",
	StringJoin[box1," to ", box2],
	_,
	RowBox[{box1, " to ", box2}]
]
]

QuantityLabel[q_Quantity,opts:OptionsPattern[]]/;MixedUnitQ[q]:=Switch[
	OptionValue[Format],
	"UnitString",
	StringJoin[Riffle[QuantityLabel[#,opts]&/@mixedRadix2List[q]," "]],
	"UnitLabel",
	RowBox[Riffle[QuantityLabel[#,opts]&/@mixedRadix2List[q]," "]],
	"UnitPrefixLabel",
	RowBox[Riffle[QuantityLabel[#,opts]&/@mixedRadix2List[q]," "]],
	"UnitPostfixLabel",
	RowBox[Riffle[QuantityLabel[#,opts]&/@mixedRadix2List[q]," "]],
	"FullUnitLabel",
	MixedUnitLabel[q],
	"FullUnitLabelWithDescription",
	With[{names=Riffle[With[{u=#[[2]]},longName[Quantity[2, u]]]&/@mixedRadix2List[q],","]},
	RowBox[{MixedUnitLabel[q],StyleBox[RowBox[{"(",Sequence@@names,")"}],FontColor -> GrayLevel[0.5]]}]],
	"TypesetUnit"|Automatic,
	Row[Riffle[QuantityLabel[#,opts]&/@mixedRadix2List[q]," "]],
	_,
	Message[QuantityLabel::bdfmt,OptionValue[Format]];$Failed
]

MixedUnitLabel[q_?MixedUnitQ]:=With[{mags=QuantityMagnitude[q],units=QuantityUnit[q]},
	With[{bx=RowBox[{Sequence@@(RowBox/@Transpose[{First[mags],iMixedUnitBox/@First[units]}])}]},
		StyleBox[bx,ShowStringCharacters->False]]]

mixedRadix2List[Quantity[MixedMagnitude[m_List], MixedUnit[u_List]]] := Quantity[Sequence @@ #] & /@ Transpose[{m,u}]
mixedRadix2List[q_Quantity]/;MixedUnitQ[q]:=Quantity[Sequence @@ #] & /@ Transpose[{List@@QuantityMagnitude[q], List@@QuantityUnit[q]}]

(*typesetting for units, not currently exposed*)
SetAttributes[unitFunction2String,HoldFirst];

unitFunction2String[exp_]:=
Module[{u1=Union@Cases[HoldForm[exp],_IndependentUnit,Infinity],rest,un, rules},
	rest=HoldForm[exp]/._IndependentUnit->1;
	un = Union@Cases[rest, _String, Infinity];
	un = Flatten@Prepend[un,u1];
	rules = Rule[#, QuantityLabel[#]] & /@ un; 
	HoldForm[exp] /. rules]

(*generates displaybox form for mixed-radix*)
makedisplayboxes[list_] := 
 Module[{n = Length[list], s, content}, s = Array[Slot, n]; 
  content = 
   Flatten@Riffle[
     List[s[[#]], " ", StyleBox[ToBoxes[list[[#]]], "QuantityUnitLabels"]] & /@ 
      Range[n], " "]; RowBox[content]]


DatedUnitBox[{n_Integer}] := MakeBoxes[n]
DatedUnitBox[l:{_?NumberQ..}] := DatedUnitBox[DateObject[l]]
DatedUnitBox[HoldPattern[dObj_?DateObjectQ]] := ToBoxes[DateString[dObj]]
DatedUnitBox[other_] := ToBoxes[other]
(*TemplateBox for Quantity expressions*)
SetAttributes[QuantityUnitBox,HoldAll];
QuantityUnitBox[Quantity[],___]:=RowBox[{"Quantity","[","]"}]

QuantityUnitBox[q:Quantity[val_, unit:IndependentUnit[u_String]],form_] := With[
{value = Which[SameQ[val, None], InterpretationBox["\[InvisibleSpace]", 1], True, makeNumberValue[val, unit, form]]},
   Module[{style, boxes},
   {style, boxes} = unitTableGetStyleAndDisplayBoxes[q, form];
   
   TemplateBox[{
   	value, 
   	Sequence @@ boxes,
   	u,
   	MakeBoxes[unit]
   	}, style, SyntaxForm->Mod]
]]
  
QuantityUnitBox[q:Quantity[val_,DatedUnit[u_,date_]],form___]:=With[{boxes=RowBox[{
	QuantityUnitBox[Quantity[val,u],form],
	"\[InvisibleSpace]",
	StyleBox[RowBox[{"(",StyleBox[ToBoxes[QuantityLabel[u]],ShowStringCharacters->False],DatedUnitBox[date],")"}],FontColor -> GrayLevel[0.5]]}]},
	InterpretationBox[boxes,q]]
QuantityUnitBox[Quantity[val_,DatedUnit[u_]],form___]:=QuantityUnitBox[Quantity[val,u],form]
QuantityUnitBox[q:Quantity[val_,u_],form___] /; Not[FreeQ[u,DatedUnit]] := 
	With[{dus=Cases[u,_DatedUnit,-1]},
		With[{labels=RowBox[Riffle[makeDatedUnitLabel/@dus,","]],un=HoldForm[u]/.DatedUnit[unit_,_]:>unit},
			With[{boxes=RowBox[{
	QuantityUnitBox[Quantity[val,un], form],
	"\[InvisibleSpace]",
	StyleBox[RowBox[{"(",labels,")"}],FontColor -> GrayLevel[0.5]]
}]},InterpretationBox[boxes,q]]
]]

makeDatedUnitLabel[DatedUnit[unit_,date_]]:=With[{label=StyleBox[ToBoxes[QuantityLabel[unit]],ShowStringCharacters->False]},
	RowBox[{label,DatedUnitBox[date]}]]
	
(*don't cache becaues of singular/plural clash*)
QuantityUnitBox[input:Quantity[1,unit:Except[_MixedUnit]],form_]:=iQuantityUnitBox[Quantity[1,unit],form]

QuantityUnitBox[input:Quantity[e_,unit:Except[_MixedUnit]], form:StandardForm]:=With[
 	{b=iQuantityUnitBox[Quantity[$UnitDisplayTemporaryVariable,unit],form]},
 	 (If[Not[UnitDisplayCacheContainsQ[unit]],UnitDisplayCacheAdd[HoldForm[unit],b]];
 	   getUnitDisplayForm[unit, e, form])]
 	   
QuantityUnitBox[input:Quantity[e_,unit:Except[_MixedUnit]],form_] := iQuantityUnitBox[input,form]


SetAttributes[QuantityAbbreviation, HoldAll];
Options[QuantityAbbreviation]={"Singular"->Automatic,"Format"->Automatic};
QuantityAbbreviation[e_, unit_, OptionsPattern[]] := Block[{$removed = {} (*used only for compound unit case*)},
Module[
	{pre, post, label, out, num = Switch[OptionValue["Singular"], True, 1, _, e]}, 
	{pre, post, label} = getUnitBoxList[Quantity[num, unit]];
	out = makeStandardDisplay[pre, post, label];
	If[
		hasFontTroubleUnitQ[unit],
		StyleBox[out,FontFamily -> "Arial Unicode MS"],
		(out/.{"\[NegativeMediumSpace]" -> "\[InvisibleSpace]"}),
		out
	]
]]

SetAttributes[UnitAbbreviation, HoldAll];
Options[UnitAbbreviation] = {"Singular" -> Automatic, "Format" -> Automatic};
UnitAbbreviation[unit_, OptionsPattern[]] := Block[{$removed = {} (*used only for compound unit case*)},
Module[
	{pre, post, label, out, num = Switch[OptionValue["Singular"], True, 1, _, 2]}, 
	{pre, post, label} = getUnitBoxList[Quantity[num, unit]];
	out = makeUnitDisplay[pre, post, label];
	If[hasFontTroubleUnitQ[unit], 
		StyleBox[out, FontFamily -> "Arial Unicode MS"],
		(out/.{"\[NegativeMediumSpace]" -> "\[InvisibleSpace]"}),
		out
	]
]]


SetAttributes[hasFontTroubleUnitQ,HoldAll];
hasFontTroubleUnitQ[expr_]:=If[
	MemberQ[{"Windows", "Windows-x86-64"}, $SystemID],
	If[FreeQ[expr, $fonttroubleunits],
		False,
		True,
		True],
	False,
	False]


makeStandardDisplay[pre_, post_, label_] := 
 With[{after = 
    If[SameQ[post, None], If[SameQ[label,None],"\[InvisibleSpace]",RowBox[{" ",label}]], 
     If[SameQ[label, None], post, 
      RowBox[{post, " ", label}]]]}, 
  If[SameQ[pre, None],
   StyleBox[RowBox[{#1,"\[InvisibleSpace]",after}], 
    ShowStringCharacters -> False], 
   StyleBox[
    RowBox[{pre, "\[InvisibleSpace]", #1, "\[InvisibleSpace]",
      after}], ShowStringCharacters -> False]]]
      
makeUnitDisplay[pre_, post_, label_] := 
 With[{after = 
    If[SameQ[post, None], 
     If[SameQ[label, None], "\[InvisibleSpace]", 
      label], 
     If[SameQ[label, None], post, 
      RowBox[{post, " ", label}]]]}, 
  If[SameQ[pre, None], 
   StyleBox[after, 
    ShowStringCharacters -> False], 
   StyleBox[
    RowBox[{pre, "\[InvisibleSpace]", after}], 
    ShowStringCharacters -> False]]]

SetAttributes[iQuantityUnitBox,HoldAll];
   
iQuantityUnitBox[q:Quantity[val_, unit:Except[_MixedUnit]],form_] := With[
	{value = Which[
		SameQ[val,None],InterpretationBox["\[InvisibleSpace]",1],
		True, makeNumberValue[val, unit, form]]},
	Module[{style, boxes},
	{style, boxes} = unitTableGetStyleAndDisplayBoxes[q, form];
   TemplateBox[{
   	value, 
   	Sequence @@ boxes,
   	ToString[longName[q] /. {$Failed -> "", None -> ""}],
   	MakeBoxes[unit]
   	}, style, SyntaxForm->Mod]
]]
      
QuantityUnitBox[q:Quantity[value_, unit:Except[_MixedUnit]], form_] :=  iQuantityUnitBox[q,form]
       
QuantityUnitBox[q:Quantity[MixedMagnitude[{0..}], _MixedUnit], form_] /; And[UnsameQ[$ShowZero,True], QuantityQ[q]] := Block[{$ShowZero = True},
	QuantityUnitBox[q, form]
	]
	
QuantityUnitBox[q:Quantity[_MixedMagnitude, _MixedUnit],form_]/; QuantityQ[q] := ToMixedUnitQuantityTemplateBox[q,form]
    
QuantityUnitBox[q:Quantity[mag:Interval[{lower_,upper_}],unit_MixedUnit]]/;QuantityQ[q] := With[{
	box1=QuantityUnitBox[Quantity[lower,unit]],
	box2=QuantityUnitBox[Quantity[upper,unit]]},
InterpretationBox[RowBox[{
	box1,
	StyleBox["\"to\"", FontColor->GrayLevel[.4], ShowStringCharacters -> False],
	box2
	}],Quantity[mag,unit]]] /; SameQ[Length[lower],Length[upper],Length[unit]]

QuantityUnitBox[Quantity[q1_,q2___],other___]/;Head[q1]===Pattern:=MakeBoxes[Quantity[q1,q1],other]
QuantityUnitBox[other___]:= Block[{Quantity},MakeBoxes[other]]

MixedUnitBox[{arg_,unit_}]:=With[{box = (iMixedUnitBox[unit]/. {"\[NegativeMediumSpace]" -> "\[InvisibleSpace]"})},
	Which[SameQ[box,$Failed],
		$Failed,
		
		And[SameQ[arg,"0"],UnsameQ[$ShowZero,True]],
		"",
		
		True,(*else*)
		$ShowZero = False;(*ensure that only leading zeros would be shown*)
		TemplateBox[{arg},"QuantityUnit",DisplayFunction->(RowBox[{#,"\[InvisibleSpace]",box}]&)]
	]
]

iMixedUnitBox[unit_] := Module[
	{mb=unitTableLookupFunction[Quantity[2, unit], "MixedRadix"]},
	If[mb=!=None,
		mb,
		RowBox[{"\[ThinSpace]",QuantityLabel[unit,"Format"->"UnitLabel"]}],
		$Failed]
]

getMixedRadixLabel[MixedUnit[units_List]] := StringJoin[
	Riffle[
		longName[Quantity[2, #]] & /@ units /. {$Failed -> "", None -> ""},
		 ","
	]
]
getMixedRadixLabel[___] := ""

qmuNumber[1]="1"
qmuNumber[2]="2"
qmuNumber[3]="3"
qmuNumber[4]="4"
qmuNumber[5]="5"
qmuNumber[6]="6"

getMixedRadixStyle[MixedUnit[units_List], form_] := If[
	1 <= Length[units] <= 6,
	StringJoin[
		"QuantityMixedUnit",
		If[SameQ[form,TraditionalForm],"TF",""], 
		qmuNumber[Length[units]]
	],
	StringJoin[
		"QuantityMixedUnitGeneric",(*fall-back style*)
		If[SameQ[form,TraditionalForm],"TF",""]
	]
]
getMixedRadixStyle[___] := "QuantityMixedUnitGeneric"

getMixedRadixMagnitudeAndUnitBoxes[MixedMagnitude[mag_List],MixedUnit[units_List], form_] := With[{
	mags = Parenthesize[#, form, Mod] & /@ mag, 
	unitLabels = iMixedUnitBox[#] & /@ units /. {"\[NegativeMediumSpace]" -> "\[InvisibleSpace]"}
},
  If[1 <= Length[units] <= 6, 
	Join[mags, unitLabels], 
	{RowBox[RowBox /@ Transpose[{
		mags, 
		ConstantArray["\[InvisibleSpace]", Length[units]], 
		unitLabels}]
	]}
  ]
]

getMixedRadixInterpBoxes[q : Quantity[_, MixedUnit[units_List]]] := If[TrueQ[1 <= Length[units] <= 6],
  MakeBoxes[units],
  Block[{Quantity},MakeBoxes[q]]
  ]

ToMixedUnitQuantityTemplateBox[q : Quantity[mag_MixedMagnitude, units_MixedUnit], form_] := With[{
	style = getMixedRadixStyle[units, form], 
	boxes = getMixedRadixMagnitudeAndUnitBoxes[mag, units, form], 
	interp = {getMixedRadixInterpBoxes[q]}, 
	tip = {getMixedRadixLabel[units]}
},
	TemplateBox[Join[boxes, tip,interp], style]
]
  
ToMixedUnitQuantityTemplateBox[other___] := Block[{Quantity},MakeBoxes[other]]
