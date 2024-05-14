pqinfo[pq_, prop_] := Module[{res = QuantityVariableLookup[pq, prop]}, 
    	If[Head[res] =!= QuantityVariableLookup, 
     		res /. {RowBox[List["RowNoSeparators", "["]] -> "", 
     			RowBox[List["\[InvisibleSpace]", "\[ThickSpace]", "\[InvisibleSpace]"]] -> ""}, 
     	Message[QuantityVariable::unkpq, pq]; $Failed, 
     	Message[QuantityVariable::unkpq, pq]; $Failed]
]

(* physical quantity variable formatting *)
makeTag[pq_String] := Module[{name=pqinfo[pq, "PhysicalQuantitySingularName"]},
	If[!StringQ[name],
		" "<>Replace[StringReplace[pq, RegularExpression["[[:upper:]]"] :> ToLowerCase["$0"]], "" -> "unitless"],
		" "<>name
	]
]
makeTag[IndependentPhysicalQuantity[pq_String]] := " " <> StringReplace[pq, RegularExpression["[[:upper:]]"] :> ToLowerCase["$0"]]
makeTag[pq_List]:=Module[{r=Times@@(Power[First[#],Last[#]]&/@(pq/.IndependentUnitDimension[x_String]:>x))},
	If[pq==={},
		" unitless",
 		StringJoin[" ",StringReplace[ToString[r, InputForm],"\""->""]]
 	]
 ];
makeTag[pq_] := StringJoin[" ",ToString[pq/.{x:IndependentPhysicalQuantity[_String]:>StringTrim[makeTag[x]],
	x_String :> StringTrim[makeTag[x]]}, InputForm]] 

SetAttributes[makeVariableBoxes, HoldAllComplete]
makeVariableBoxes[x_, fmt_] := Replace[HoldComplete[x],
  {
   HoldComplete[s_String] /; StringLength[s] == 1 :> 
    StyleBox["\"" <> s <> "\""],
   HoldComplete[s_String] :> "\"" <> s <> "\"",
   HoldComplete[h_[s_String, rest___]] /; StringLength[s] == 1 :>
        MakeBoxes[
     h[Style[s, StripOnInput -> True], rest], 
     fmt],
   HoldComplete[other_] :> MakeBoxes[other, fmt]
   }
  ]
	
QuantityVariable /: MakeBoxes[QuantityVariable[x_?(UnsameQ[#,None]&), pq_?LooksLikeAPQQ,___], fmt_] := With[{t = makeTag[pq]}, 
 TemplateBox[{makeVariableBoxes[x, fmt], MakeBoxes[pq, fmt]}, 
  "QuantityVariable", 
  DisplayFunction -> (TooltipBox[
      StyleBox[#1, FontColor->GrayLevel[.4], 
       ShowStringCharacters -> False], 
      RowBox[{"Quantity variable:", t}], 
      TooltipStyle -> "TextStyling"] &)]]
     
QuantityVariable /: OutputForm[QuantityVariable[x_?(UnsameQ[#,None]&), ___]]:=x;

QuantityVariable /: MakeBoxes[QuantityVariable[pq_?LooksLikeAPQQ], fmt_] := With[{t = makeTag[pq]}, 
 TemplateBox[{makeVariableBoxes[pq, fmt], MakeBoxes[pq, fmt]}, 
  "QuantityVariable", 
  DisplayFunction -> (TooltipBox[
      StyleBox[#1, FontColor->GrayLevel[.4], 
       ShowStringCharacters -> False], 
      RowBox[{"Quantity variable:", t}], 
      TooltipStyle -> "TextStyling"] &)]];

SetAttributes[QuantityVariable,HoldRest]
QuantityVariable[q_Quantity,___]/;TrueQ[$QuantityVariableQuantityIdentity]:=q

SetAttributes[LooksLikeAPQQ, HoldAllComplete];(*emulating Quantity typesetting*)
LooksLikeAPQQ[_String] := True;
LooksLikeAPQQ[IndependentPhysicalQuantity[_String]] := True;
LooksLikeAPQQ[{}] := True;
LooksLikeAPQQ[pq_List] := dimensionsListQ[pq];
LooksLikeAPQQ[Power[x_, p_]] := LooksLikeAPQQ[x];
LooksLikeAPQQ[Times[args__]] := AllTrue[DeleteCases[List[args],1], LooksLikeAPQQ];
LooksLikeAPQQ[Divide[args__]] := AllTrue[DeleteCases[List[args],1], LooksLikeAPQQ];
LooksLikeAPQQ[__] := False;

dimensionsListQ[pq_List]:=If[MatchQ[pq,{{_String|IndependentUnitDimension[_String],_?NumericQ}..}],
	If[Complement[DeleteCases[pq[[All,1]],_IndependentUnitDimension],$dimunitrules[[All,1]]]==={},
		True,
		False
	],
	False
]
dimensionsListQ[__] := False

SetAttributes[{QuantityVariableIdentifier,QuantityVariablePhysicalQuantity,QuantityVariableDimensions,QuantityVariableCanonicalUnit}, Listable];

QuantityVariableIdentifier[]:=(Message[QuantityVariableIdentifier::argx, QuantityVariableIdentifier, 0];Null/;False)
QuantityVariableIdentifier[d_QuantityVariable] := First@d /; Length[d] > 0;
QuantityVariableIdentifier[input_QuantityVariable[___]] := QuantityVariableIdentifier[input]
QuantityVariableIdentifier[Derivative[__][input_QuantityVariable][__]] := QuantityVariableIdentifier[input]
QuantityVariableIdentifier[arg:Except[_Symbol]]:=(Message[QuantityVariableIdentifier::qvprm, arg, 1];Null/;False) 
QuantityVariableIdentifier[_,args__]:=(Message[QuantityVariableIdentifier::argx, QuantityVariableIdentifier, Length[{args}]+1];Null/;False)

QuantityVariablePhysicalQuantity[]:=(Message[QuantityVariablePhysicalQuantity::argx, QuantityVariablePhysicalQuantity, 0];Null/;False)
QuantityVariablePhysicalQuantity[d_QuantityVariable] := d[[2]] /; Length[d] > 1;
QuantityVariablePhysicalQuantity[d_QuantityVariable] := d[[1]] /; Length[d] === 1;
QuantityVariablePhysicalQuantity[input_QuantityVariable[___]] := QuantityVariablePhysicalQuantity[input]
QuantityVariablePhysicalQuantity[Derivative[__][input_QuantityVariable][__]] := QuantityVariablePhysicalQuantity[input]
QuantityVariablePhysicalQuantity[arg:Except[_Symbol]]:=(Message[QuantityVariablePhysicalQuantity::qvprm, arg, 1];Null/;False) 
QuantityVariablePhysicalQuantity[_,args__]:=(Message[QuantityVariablePhysicalQuantity::argx, QuantityVariablePhysicalQuantity, Length[{args}]+1];Null/;False)

QuantityVariableDimensions[args_]:=With[{res=If[StringQ[pq],
		oQuantityVariableDimensions[QuantityVariable[pq]],
		oQuantityVariableDimensions[args]
	]},Sort[DeleteCases[(List@@@res),{"DimensionlessUnit",_}]]/;res=!=$Failed]
QuantityVariableDimensions[_,args__]:=(Message[QuantityVariableDimensions::argx,QuantityVariableDimensions,Length[{args}]+1];Null/;False)
QuantityVariableDimensions[]:=(Message[QuantityVariableDimensions::argx,QuantityVariableDimensions,0];Null/;False)

(*oUnitDimensions returns a list of physical dimension rules*)
SetAttributes[oQuantityVariableDimensions,Listable];
(*convert a combination of PQs and Quantities, including derivatives, into a mixture of canonical units: 
	used by QuantityVariableDimensions and QuantityVariableCanonicalUnit*)
convertPQCombinations[args_] := Module[{converted = (args /. QuantityVariable[arg__][__] :> QuantityVariable[arg])},
	(*remove logarthms and exponentials, these functions should return dimensionless numbers*)
	converted = converted /. {Log[__]->1, Exp[_]->1};
	(*remove instances of possible cancellation by removing numerical factors from Plus arguments *)
	converted = converted //. Plus[f___, Times[_?NumericQ, pq_QuantityVariable], e___] :> Plus[f, pq, e];
 	converted = converted /. {Derivative[n_][input_QuantityVariable][var_QuantityVariable] :> canonunit[input, {var, n}], 
     	Derivative[n_, no__][input_QuantityVariable][var_QuantityVariable, varo__QuantityVariable] :> 
      		canonunit[input, Transpose[{Prepend[{varo}, var], Prepend[{no}, n]}]]};
  	converted = converted /. {QuantityVariable[pq_List, ___] | QuantityVariable[_, pq_List, ___] :> canonunit[pq]};
  	converted = converted /. {qv_QuantityVariable :> breakupQuantityVariable[qv]};
  	converted = converted /. {qv_QuantityVariable :> canonunit2[qv], HoldPattern[Quantity[q_]] :> Quantity[1, q]};
  	If[FreeQ[converted, QuantityVariable | $Failed], 
   		PowerExpand[ReleaseHold[converted]], 
   		$Failed
   	]
]
oQuantityVariableDimensions[args_?(Not[FreeQ[#,QuantityVariable]]&)]:=Module[
	{converted=convertPQCombinations[args]},
	If[FreeQ[converted,$Failed],
		converted=UnitDimensions[converted];
		If[MatchQ[converted,{{_,_?NumericQ}..}]||MatchQ[converted,{}],converted,$Failed],
		$Failed
	]
]
oQuantityVariableDimensions[args_?(FreeQ[#,QuantityVariable|Quantity]&)]:=Module[
	{newarg=(args/.x_String:>QuantityVariable[x])/.
		IndependentPhysicalQuantity[QuantityVariable[x_]]:>QuantityVariable[IndependentPhysicalQuantity[x]]},
	If[FreeQ[newarg,QuantityVariable],
		$Failed,
		oQuantityVariableDimensions[newarg]
	]
]
oQuantityVariableDimensions[___]:=$Failed

$dimunitrules={"AmountUnit" -> "Moles", "ElectricCurrentUnit" -> "Amperes", "LengthUnit" -> "Meters", "LuminousIntensityUnit" -> "Candelas", 
	"MassUnit" -> "Kilograms", "TemperatureUnit" -> "Kelvins", "TimeUnit" -> "Seconds", "AngleUnit" -> "Radians", "InformationUnit" -> "Bits", 
	"MoneyUnit" -> "USDollars", "PersonUnit" -> "People", "SolidAngleUnit" -> "Steradians", "TemperatureDifferenceUnit" -> "KelvinsDifference",
	IndependentPhysicalQuantity -> IndependentUnit
};

Clear[canonunit];
canonunit[QuantityVariable[_, pq_String, ___]]:=canonunit[pq]
canonunit[QuantityVariable[_, pq_IndependentPhysicalQuantity, ___]]:=canonunit[pq]
canonunit[QuantityVariable[pq_String]]:=canonunit[pq]
canonunit[QuantityVariable[pq_IndependentPhysicalQuantity, ___]]:=canonunit[pq]
canonunit[QuantityVariable[_, pq_List, ___]]:=canonunit[pq]
canonunit[QuantityVariable[pq_List]]:=canonunit[pq]
canonunit[pq_List]:=Module[{},
	If[dimensionsListQ[pq],
		Quantity[Times@@(Power[First[#],Last[#]]&/@((pq/.$dimunitrules)/.IndependentUnitDimension->IndependentUnit))],
		If[pq==={},Quantity["PureUnities"],$Failed]
	]
];
canonunit[pq_String]:=Module[{unit=qvQuantityVariableLookup[pq, "Unit"]},
	If[FreeQ[unit, $Failed],
		If[unit===1,
			1,
			Quantity[unit]
		],
		Message[QuantityVariable::unkpq,pq];
		$Failed
	]
]
canonunit[IndependentPhysicalQuantity[pq_String]]:=Quantity[IndependentUnit[pq]]
canonunit[input_,{var_,n_Integer}] := Module[
	{base = canonunit2[input], reduce = canonunit2[var]},
   	base=If[MatchQ[base,_Quantity],
   		QuantityUnit[base],
   		If[base===1,1,Message[QuantityVariable::unkpq,input];$Failed]
   	];
   	reduce=If[MatchQ[reduce,_Quantity],
   		QuantityUnit[reduce],
   		If[reduce===1,1,Message[QuantityVariable::unkpq,var];$Failed]
   	];
   	If[FreeQ[{reduce,base}, $Failed],
		{reduce,base}={reduce,base}/."PureUnities"->1;
		Quantity[base/reduce^n],
		$Failed
	]
]
canonunit[input_,dx:{{_,_Integer}..}] := Module[
	{base = canonunit2[input], 
   		reduce=(canonunit2[#[[1]]]^#[[2]]&)/@dx},
   	base=If[MatchQ[base,_Quantity],
   		QuantityUnit[base],
   		If[base===1,1,Message[QuantityVariable::unkpq,input];$Failed]
   	];
   	reduce=If[MatchQ[#,_Quantity],QuantityUnit[#],If[#===1,1,$Failed]]&/@reduce;
   	If[FreeQ[{reduce,base}, $Failed],
		{reduce,base}={reduce,base}/."PureUnities"->1;
		Quantity[base/Times@@reduce],
		$Failed
	]
]
canonunit[___]:=$Failed

Clear[canonunit2]
canonunit2[qv_QuantityVariable]:=Module[{pq=breakupQuantityVariable[qv]},
	pq/.x_QuantityVariable:>canonunit[x]
]

breakupQuantityVariable[qv_QuantityVariable]:=Module[{pq=QuantityVariablePhysicalQuantity[qv]},
	If[ListQ[pq],
		QuantityVariable[pq],
		pq=ReplaceAll[pq,x_String:>QuantityVariable[x]];
		ReplaceAll[pq,IndependentPhysicalQuantity[QuantityVariable[x_]]:>
			QuantityVariable[IndependentPhysicalQuantity[x]]]
	]
]

$convertunitdim={"AmountUnit" -> "Moles", "AngleUnit" -> "AngularDegrees", "ElectricCurrentUnit" -> "Amperes", 
	"InformationUnit" -> "Bytes", "LengthUnit" -> "Meters", "LuminousIntensityUnit" -> "Candelas", 
	"MassUnit" -> "Kilograms", "MoneyUnit" -> "USDollars", "SolidAngleUnit" -> "Steradians", 
	"TemperatureDifferenceUnit" -> "KelvinsDifference", "TemperatureUnit" -> "Kelvins", "TimeUnit" -> "Seconds", IndependentUnitDimension ->IndependentUnit};

qvQuantityVariableLookup[{},"Unit"]:="PureUnities"
qvQuantityVariableLookup[IndependentPhysicalQuantity[pq_],"Unit"]:=IndependentUnit[pq]
qvQuantityVariableLookup[pq_String,"Unit"]:=With[{unit=QuantityVariableLookup[pq,"CanonicalUnit"]/.HoldForm[Divide[a_, b_]] :> HoldForm[Times[a, Power[b, -1]]]},
	With[{un=ReleaseHold[unit]},If[MatchQ[unit,_QuantityVariableLookup],$Failed,If[Equal[unit,HoldForm[un]],un,unit,unit]]]]
qvQuantityVariableLookup[udl:{{_String|_IndependentUnitDimension,_?NumericQ}..},"Unit"]:=Module[{res},
	If[Complement[DeleteCases[udl[[All,1]],_IndependentUnitDimension],$convertunitdim[[All,1]]]=!={},Return[$Failed]];
	res=udl/.$convertunitdim;
	Times@@(Power[First[#],Last[#]]&/@res)
]
qvQuantityVariableLookup[pq_?(FreeQ[#,QuantityVariable]&),"Unit"]:=With[{units=((ReplaceAll[pq,x_String:>QuantityVariable[x]])/.
				IndependentPhysicalQuantity[QuantityVariable[x_]]:>QuantityVariable[IndependentPhysicalQuantity[x]])/.QuantityVariable[x_]:>qvQuantityVariableLookup[x,"Unit"]},
	If[FreeQ[units,$Failed],
		With[{un=ReleaseHold[units]},If[Equal[units,HoldForm[un]],un,units,units]],
		$Failed
	]]
qvQuantityVariableLookup[IndependentPhysicalQuantity[pq_],"Dimensions"]:=IndependentUnit[pq]
qvQuantityVariableLookup[pq_,"Dimensions"]:=With[{unit=QuantityVariableLookup[pq,"CanonicalUnit"]},
	If[unit===$Failed||MatchQ[unit,_QuantityVariableLookup],$Failed,UnitDimensions[Quantity[1,unit]]]]
qvQuantityVariableLookup[__]:=$Failed

QuantityVariableCanonicalUnit[args__]:=With[{res=iQuantityVariableCanonicalUnit[args]},
	res/;res=!=$Failed
]

iQuantityVariableCanonicalUnit[]:=(Message[QuantityVariableCanonicalUnit::argx, QuantityVariableCanonicalUnit, 0];$Failed)
iQuantityVariableCanonicalUnit[QuantityVariable[_,pq_,___]]:=
	Module[{res=Quiet[canonunit2[QuantityVariable[pq]]]},
	If[SameQ[res,$Failed],Message[QuantityVariable::unkpq,pq];Return[$Failed]];
	res=QuantityUnit[res]/."PureUnities"->1;
	PowerExpand[ReleaseHold[res]]]
iQuantityVariableCanonicalUnit[QuantityVariable[pq_]]:=iQuantityVariableCanonicalUnit[QuantityVariable["",pq]]
iQuantityVariableCanonicalUnit[pq_String]:=iQuantityVariableCanonicalUnit[QuantityVariable["",pq]]
iQuantityVariableCanonicalUnit[args_?(Not[FreeQ[#,QuantityVariable]]&)]:=
	Module[{res=Quiet[convertPQCombinations[args]]},
	If[SameQ[res,$Failed],Message[QuantityVariable::unkpq,args];Return[$Failed]];
	res=QuantityUnit[res]/.{"PureUnities"->"DimensionlessUnit", 1->"DimensionlessUnit"};
	If[MatchQ[args,QuantityVariable["",_String]],
		res,(*in single PQ case leave as is, to cover ratios better*)
		PowerExpand[ReleaseHold[res]]
	]
]
iQuantityVariableCanonicalUnit[arg:Except[_QuantityVariable]]:=(Message[QuantityVariableCanonicalUnit::qvprm, arg, 1];$Failed) 
iQuantityVariableCanonicalUnit[_,args__]:=(Message[QuantityVariableCanonicalUnit::argx, QuantityVariableCanonicalUnit, Length[{args}]+1];$Failed)
iQuantityVariableCanonicalUnit[___]:=$Failed

Clear[pqCheck]
pqCheck[pq_String] := qvQuantityVariableLookup[pq, "Dimensions"]
pqCheck[IndependentPhysicalQuantity[pq_String]] := IndependentUnit[pq]
pqCheck[qv:QuantityVariable[pq_]] := Quiet[Check[QuantityVariableDimensions[qv],$Failed]]
pqCheck[qv:QuantityVariable[_, pq_, ___]] := Quiet[Check[QuantityVariableDimensions[qv],$Failed]]
pqCheck[___] := $Failed

checkPQs[input_List] := Module[{pqs = input}, 
	pqs = {#, pqCheck[#]} & /@ pqs;
  	If[FreeQ[pqs, $Failed], 
  		True, 
   		pqs = Cases[pqs, {x_, $Failed} :> x] /. {QuantityVariable[pq_] :> pq, QuantityVariable[_, pq_, ___] :> pq};
   		Message[QuantityVariable::unkpq, #] & /@ pqs; False
   	]
]
checkPQs[___] := False

checkGoalPQ[input_]:=Module[{dim=Quiet[QuantityVariableDimensions[input],{QuantityVariableDimensions::qvprm}]},
	If[MatchQ[dim,_List],True,False]
]

Options[DimensionalCombinations] = SortBy[#, ToString]&@{IncludeQuantities -> {}, GeneratedParameters -> C};
Options[iqvCombinations] = {GeneratedParameters -> C};
Options[trimConstants] = {GeneratedParameters -> C};
$standardconstants = "PhysicalConstants" -> {Quantity[1, "BoltzmannConstant"], 
    Quantity[1, "ElectricConstant"], 
    Quantity[1, "GravitationalConstant"], 
    Quantity[1, "MagneticConstant"], Quantity[1, "PlanckConstant"], 
    Quantity[1, "SpeedOfLight"]};

System`DimensionalCombinations[listofPQs_?checkPQs,opts:OptionsPattern[]] := Module[{res,
	pqs = If[StringQ[#], QuantityVariable[#], #] & /@ listofPQs, method=MatchQ[OptionValue[GeneratedParameters],None],
	quantities=OptionValue[System`IncludeQuantities]/.$standardconstants,qdimensions,
	pqdimensions},
	quantities=If[ListQ[quantities],Flatten[quantities],{quantities}];
	quantities=Flatten[If[MatchQ[#,_Quantity], #, If[MatchQ[#,_String|_IndependentUnit],Quantity[#], {}]] & /@ quantities];
	qdimensions=DeleteCases[{#, UnitDimensions[#]} & /@ quantities,{_,UnitDimensions[_]}];
  	pqdimensions = DeleteCases[checkDimensions /@ pqs,$Failed];
  	
  	pqdimensions=Join[pqdimensions,qdimensions];
  	If[pqdimensions==={},Return[{}]];
  	
  	res=If[method,
  		DeleteDuplicates[Flatten[Select[DeleteCases[iqvCombinations /@ Subsets[pqdimensions], {}], FreeQ[#, _C, \[Infinity]] &]], SameQ[#1, #2] || SameQ[(#1)^-1, #2] &],
  		iqvCombinations[pqdimensions,FilterRules[{opts},Options[iqvCombinations]]]
  	];
  	If[listofPQs=!={},(*currently listofPQs is always a list of length>0 but we might want to support 
  		dimensionless combinations of quantities in the future, this test lays the groundwork for this*)
  		DeleteCases[res,_?(FreeQ[#,QuantityVariable]&)],
  		res
  	]
]
System`DimensionalCombinations[listofPQs_?checkPQs,dimension_?checkGoalPQ,opts:OptionsPattern[]] := Module[{res,
	pqs = If[StringQ[#], QuantityVariable[#], #] & /@ listofPQs, method=MatchQ[OptionValue[GeneratedParameters],None],
	quantities=OptionValue[System`IncludeQuantities]/.$standardconstants,qdimensions,
	pqdimensions,lhs=checkDimensions[If[MatchQ[dimension,_String|_IndependentPhysicalQuantity], QuantityVariable[dimension], dimension]]},
	If[Not[FreeQ[lhs,$Failed]],Return[{}]];
	quantities=If[ListQ[quantities],Flatten[quantities],{quantities}];
	quantities=Flatten[If[MatchQ[#,_Quantity], #, If[MatchQ[#,_String],Quantity[#], {}]] & /@ quantities];
	qdimensions=DeleteCases[{#, UnitDimensions[#]} & /@ quantities,{_,UnitDimensions[_]}];
  	pqdimensions = DeleteCases[checkDimensions /@ pqs,$Failed];
  	
  	pqdimensions=Join[pqdimensions,qdimensions];
  	If[pqdimensions==={},Return[{}]];
  	
  	res=If[method,
  		DeleteDuplicates[Flatten[Select[DeleteCases[iqvCombinations[#,lhs]& /@ Subsets[pqdimensions], {}], FreeQ[#, _C, \[Infinity]] &]], SameQ[#1, #2] || SameQ[(#1)^-1, #2] &],
  		iqvCombinations[pqdimensions,lhs,FilterRules[{opts},Options[iqvCombinations]]]
  	];
  	If[listofPQs=!={},(*currently listofPQs is always a list of length>0 but we might want to support 
  		dimensional combinations of quantities in the future, this test lays the groundwork for this*)
  		DeleteCases[res,_?(FreeQ[#,QuantityVariable]&)],
  		res
  	]
]

iqvCombinations[pqdimensions_, opts : OptionsPattern[]] := Module[{dimensionrules, units, ansatz, expansion, sol, result}, 
  	units = Cases[Flatten[pqdimensions[[All, 2]]], _String|_IndependentUnitDimension];
  	dimensionrules = (#1 -> Times @@ ((Power @@@ #2))) & @@@ pqdimensions;
  	ansatz = 1 == Product[Power[pqdimensions[[i, 1]], Unique[]], {i, Length[pqdimensions]}];
  	expansion = PowerExpand[Log /@ (ansatz /. dimensionrules)];
  	sol = SolveAlways[expansion, Log /@ units];
	sol = trimConstants[#, "LHS", opts] & /@ sol;
	sol = Cases[sol, List[_Rule ..], Infinity];(*grab lists of replacement rules*)
	sol = removeRoots/@sol;(*remove powers of 1/n by multiplying them out*)
  	result = If[sol === {}, {}, Flatten[DeleteCases[ansatz[[2]] /. sol/. None -> 1, 1]]]
]
      
iqvCombinations[pqdimensions_, lhs_, opts : OptionsPattern[]] := Module[
	{dimensionrules, units, ansatz, expansion, sol, result}, 
  	units = Cases[Flatten[pqdimensions[[All, 2]]], _String|_IndependentUnitDimension];
  	dimensionrules = (#1 -> Times @@ ((Power @@@ #2))) & @@@ Join[pqdimensions, {lhs}];
  	ansatz = lhs[[1]] == Product[Power[pqdimensions[[i, 1]], Unique[]], {i, Length[pqdimensions]}];
  	expansion = PowerExpand[Log /@ (ansatz /. dimensionrules)];
  	sol = SolveAlways[expansion, Log /@ units];
  	sol = DeleteCases[trimConstants[#, "LHS", opts] & /@ sol, $Failed];
	sol = Cases[sol, List[_Rule ..], Infinity];(*grab lists of replacement rules*)
  	If[lhs==={},sol = removeRoots/@sol];(*remove powers of 1/n by multiplying them out but only if 
  		we lack a specific set of unit dimensions to match to*)
  	result = If[sol === {}, {}, Flatten[DeleteCases[ansatz[[2]] /. sol/. None -> 1, 1]/.HoldPattern[Quantity[1, (_String|_IndependentUnitDimension)^0]]:>1]]
]


checkDimensions[pq_] := Module[{dim = QuantityVariableDimensions[pq]}, 
  	If[dim === {}, 
   		Message[DimensionalCombinations::dim, First[pq]]; 
   		Return[$Failed]
   	];
  	If[ListQ[dim], {pq, dim}, $Failed]
]
checkDimensions[___] := $Failed

trimConstants[list_?(VectorQ[#, Function[{x}, MatchQ[x, _Rule]]] &), opts : OptionsPattern[]] := Module[
	{l = list, sublist, constant = OptionValue[GeneratedParameters], factor, rhs = list[[All, 2]], default=1}, 
  	If[Not[FreeQ[list, Log[_]]], Return[$Failed]];
  	If[Element[rhs, Reals], 
  		factor = GCD @@ (Rationalize /@ rhs);
   		If[factor === 0, Return[$Failed], factor = 1/factor];
   		l = Rule[#[[1]], #[[2]]*factor] & /@ l;
   		Return[l]
   	];
  	sublist = Select[Union[Level[l[[All, 2]], {-1}]], Not[TrueQ[Element[#, Reals]]] &];
  	factor = (Join[Rationalize /@ (rhs /. (# -> default & /@ sublist)), Cases[rhs, Rational[_, _], Infinity]]);
  	If[Length[factor] === 1, 
  		factor = 1, 
  		If[AllTrue[factor, # === 0 &],
  			default=2;
  			factor = (Join[Rationalize /@ (rhs /. (# -> default & /@ sublist)), Cases[rhs, Rational[_, _], Infinity]])
  		];
  		factor = 1/(GCD @@ factor)
  	];
  	If[Length[sublist] === 1, 
  		sublist = sublist[[1]];
   		l = Map[#[[1]] -> factor*#[[2]] &, l];
		{Append[l /. sublist -> default, sublist -> factor], Append[l /. sublist -> 0, sublist -> 0]}, 
   		sublist = MapIndexed[#1 -> factor*constant[#2[[1]]] &, sublist];
   		l = Map[#[[1]] -> Expand[factor*#[[2]]] &, l];
   		Join[l /. sublist, sublist]
   	]
]
trimConstants[list_?(VectorQ[#, Function[{x}, MatchQ[x, _Rule]]] &), "LHS", opts : OptionsPattern[]] :=
Module[
	{l = list, sublist, constant = OptionValue[GeneratedParameters], rhs = list[[All, 2]], default=1}, 
  	If[Not[FreeQ[list, Log[_]]], Return[$Failed]];
  	If[Element[rhs, Reals], Return[l]];
  	sublist = Select[Union[Level[l[[All, 2]], {-1}]], Not[TrueQ[Element[#, Reals]]] &];
  	If[Length[sublist] === 1, 
  		sublist = sublist[[1]];
   		l = Map[#[[1]] -> #[[2]] &, l];
		{Append[l /. sublist -> default, sublist -> 1], Append[l /. sublist -> 0, sublist -> 0]}, 
   		sublist = MapIndexed[#1 -> constant[#2[[1]]] &, sublist];
   		l = Map[#[[1]] -> Expand[#[[2]]] &, l];
   		Join[l /. sublist, sublist]
   	]
]
trimConstants[_] := $Failed

Clear[removeRoots];
(* remove fractional powers from combination results to avoid duplication of results 
	(i.e. a^2 b/c vs. a Sqrt[b/c]) *)
removeRoots[rules:{_Rule..}]:=Module[{fractions=Cases[rules,Rational[_, n_]:>n,Infinity],lcm,res=rules},
	If[fractions==={},
		rules,
		lcm=LCM@@fractions;
		res[[All,2]]=lcm*res[[All,2]];
		res
	]
]
removeRoots[_]:=$Failed

Clear[QV2Q];
QV2Q[HoldPattern[QuantityVariable[_, pq_String, ___]]] := 
 With[{units = qvQuantityVariableLookup[pq, "Unit"]}, 
  If[units == $Failed, Throw[$Failed, $tag]];
  	Quantity[1, units]
  ]
QV2Q[HoldPattern[QuantityVariable[_, pq_IndependentPhysicalQuantity, ___]]] := 
 With[{units = qvQuantityVariableLookup[pq, "Unit"]}, 
  If[units == $Failed, Throw[$Failed, $tag]];
  	Quantity[1, units]
  ]
QV2Q[HoldPattern[QuantityVariable[pq_String]]] := QV2Q[QuantityVariable["", pq]]
QV2Q[HoldPattern[QuantityVariable[pq_IndependentPhysicalQuantity]]] := QV2Q[QuantityVariable["", pq]]

QuantityVariableSantityCheck[expr_,specified___] := 
 Catch[With[{rules = 
     Cases[expr, q_QuantityVariable :> Rule[q, QV2Q[q]], -1]},
   If[SameQ[rules, {}], Throw[True, $tag]];
   If[MatchQ[
     Quiet[
     	Check[SeparateUnits[expr /. rules, specified], 
     		Throw[$Failed, $tag],
     		{Quantity::compat}],
     	{Quantity::compat}], 
     _SeparateUnits],
    Throw[$Failed, $tag],
    True]], $tag]

(****Nondimensionalize Code*****)
(*SOLVE CODE*)
(*helper functions*)
convertDerivatives[n_List,s_,v_List,rules_, symbolrules_]:=Module[
	{news=s/.symbolrules,factor=s/.rules,newv=v/.symbolrules,vfactor=v/.rules},
	vfactor=(vfactor/newv)^-n/.List->Times;
	(factor/news)*vfactor*Derivative[Sequence@@n][news]
		[Sequence@@newv]
]
convertFunctions[s_,v_List,rules_,symbolrules_]:=Module[
	{news=s/.symbolrules,factor=s/.rules,newv=v/.symbolrules},
	(factor/news)*news[Sequence@@newv]
]
extractLeadingCoefficient[equ_,symbols_,gv_]:=Module[
	{coeff=Flatten[Replace[Evaluate[equ/.Equal->List],Plus[x_,y__]:>{x,y},{1}]],dpos},
	(*first order 'coeff' by largest degree Derivative present*)
	dpos=SortBy[Cases[#,Derivative[n__][s_][__]:>{Max[n],s},Infinity],First]&/@coeff;
	dpos=dpos/.{}->{{-1,0}};
	If[MatchQ[dpos,{{{-1,0}}..}],
		(*no derivitives*)
		dpos=Cases[#,s_?(MemberQ[symbols,#]&)[__]:>{0,s},Infinity]&/@coeff;
		dpos=dpos/.{}->{{-1,0}};
		If[MatchQ[dpos,{{{-1,0}}..}]&&FreeQ[First[equ],Plus],(*i.e. all symbols and one side consists of a single symbol*)
			dpos[[1]]={{-2,0}}(*downscore so we don't get 1 on LHS*)
		]
	];
	dpos=dpos[[All,1,1]];
	dpos=FirstPosition[dpos,Max[dpos]];
	dpos=First[coeff[[dpos]]]/.{Derivative[__][_][__]->1,s_?(MemberQ[symbols,#]&)[__]->1};
	If[FreeQ[First[equ],Plus]&&FreeQ[Last[equ],Plus](*do we remove this restriction*),
		(*we need to remove any introduced symbols, user or otherwise, from the factor before we divide both sides *)
		(* logarithms need to be stripped of internal symbols, a Log of just symbols is set to unity*)
		dpos=dpos/.Log[x_]:>removeInternlSymbols[Log,x,symbols,gv];
		(dpos/.{s_?(MemberQ[symbols,#]&)->1,gv[_Integer]->1}),
		dpos
	]
]

removeInternlSymbols[Log,arg_,s_,gv_]:=Module[{res=If[FreeQ[arg,Log],arg,arg/.Log[x_]:>removeInternlSymbols[Log,x,s,gv]]},
	res=res/.{symbol_?(MemberQ[s,#]&)->1,gv[_Integer]->1};
	If[res===1,1,Log[res]]
]

Clear[pickSolution,nonDimensionalSolver,iNondimensionalize]
pickSolution[{}]:=None
pickSolution[sol_List]:=Module[{sort=SortBy[sol,Count[#,_QuantityVariable,Infinity]&]},
	First[sort]
];

(*nonDimensionalSolver*)
nonDimensionalSolver[equ_,originalsymbols_List,newsymbols_List,symbol_,extraqs_,constant_]:=Module[
	{srules=MapThread[Rule,{originalsymbols,newsymbols}],
		quants=Union[Cases[equ,_Quantity,Infinity]],
		qvs=Union[Cases[equ,_QuantityVariable,Infinity]],j=0,
	sols,rules1,rules2={},othersymbols,removesymbols,ndequ,factor,i,tsol},
	(*assemble allowed Quantities to use in solutions*)
	quants=Quantity/@Union[Flatten@Cases[Join[quants,extraqs],_String,Infinity]];
	(*assemble initial list of other QVs to use in solutions*)
	othersymbols=Complement[qvs,originalsymbols];
	
	(* stage 1: create rules to remove old symbols *)
	sols=Table[
		(*solve for all possible combinations using established QVs and Quantities*)
		sols=DimensionalCombinations[othersymbols,i,IncludeQuantities->quants,GeneratedParameters->None];
		(*pick best solution*)
		sols=pickSolution[sols];
		(*if no solution create one of the form "canonical quantity"*)
		If[sols===None,
			factor=ReleaseHold[QuantityVariableCanonicalUnit[i]];
			j=j+1;
			factor=Quantity[constant[j],factor];
			(*TODO: added option for allow user supplied symbol for added quantities*)
			AppendTo[quants,factor];
			factor,
			sols
		],
	{i,originalsymbols}];
	rules1=MapThread[Rule,{originalsymbols,newsymbols*sols}];
	
	(*recursively remove remaining QVs *)
	sols={};
	i=0;
	ndequ=simplifyEquation[equ,originalsymbols,Join[rules1,rules2],srules,newsymbols,symbol];
	removesymbols=Union[Cases[ndequ,_QuantityVariable,Infinity]];
	While[Length[removesymbols]>0&&i<Length[othersymbols],
		{tsol,factor,j}=secondarySolve[removesymbols,quants,constant,j];
		quants=Join[quants,factor];
		AppendTo[sols,tsol];
		i=i+1;
		srules=Append[srules,Rule[First[removesymbols],symbol[i]]]; (*so we have a complete list of original symbol to final symbol rules*)
		tsol=Rule[First[removesymbols],symbol[i]*Last[tsol]];
		rules2=Append[rules2,tsol];
		(*redefine rules1 incrementally*)
		rules1=(rules1/.rules2)/.symbol[__]->1;
		(*redefine rules2 incrementally*)
		rules2=rules2[[All,2]]/.rules2;
		rules2=MapThread[Rule,{sols[[All,1]],rules2}];
		ndequ=simplifyEquation[equ,originalsymbols,Join[rules1,rules2],srules,newsymbols,symbol];
		removesymbols=Union[Cases[ndequ,_QuantityVariable,Infinity]];(*TODO: possibly improve order - order by frequency*)
	];
	
	If[Not[FreeQ[rules2,Alternatives@@removesymbols]],
		Message[System`NondimensionalizationTransform::nsol];Return[$Failed]
	];
	
	rules1=generateRules[equ,originalsymbols,Join[rules1,rules2],srules,newsymbols];

	Association[Prepend[rules1,"ReducedForm"->(ndequ/.Quantity[0,_]->0)]]
]

naturalUnitSolver[equ_,originalsymbols_List,newsymbols_List,symbol_,method_,constant_]:=Module[
	{srules=MapThread[Rule,{originalsymbols,newsymbols}],srules2,replacementrules=naturalUnitsTranslation[method],
		qvs=Union[Cases[equ,_QuantityVariable,Infinity]],dim,j,
	sols,rules1,rules2={},othersymbols,ndequ,factor,i,tsol},
	(*assemble initial list of other QVs to use in solutions*)
	othersymbols=Complement[qvs,originalsymbols];
	
	(* create rules to remove old symbols *)
	sols=Table[
		(*get dimensions*)
		dim=QuantityVariableDimensions[i];
		constructQuantity[dim,replacementrules],
	{i,originalsymbols}];
	rules1=MapThread[Rule,{originalsymbols,newsymbols*sols}];
	
	(* create rules to remove unspecified symbols *)
	sols=Table[
		(*get dimensions*)
		dim=QuantityVariableDimensions[i];
		{i,constructQuantity[dim,replacementrules]},
	{i,othersymbols}];
	rules2=MapIndexed[Rule[First[#1],symbol[First[#2]]*Last[#1]]&,sols];
	srules2=MapIndexed[Rule[First[#1],symbol[First[#2]]]&,sols];
	
	(*apply to equation*)
	sols=Join[rules1,rules2];
	ndequ=simplifyEquation[equ,originalsymbols,sols,srules,newsymbols,symbol];
	srules=Join[srules,srules2];
	sols=generateRules[equ,originalsymbols,sols,srules,newsymbols];

	Association[Prepend[sols,"ReducedForm"->(ndequ/.Quantity[0,_]->0)]]
]

(*construct quantity factor from PQ dimensions and replacement rules for quantity dimensions*)
constructQuantity[dimensions_,rules_]:=Module[{res=dimensions/.rules},
	(*apply power*)
	res=Power[First[#],Last[#]]&/@res;
	Times@@res
]
secondarySolve[symbols_,quants_,constant_,j_]:=Module[{s=First[symbols],os=Rest[symbols],sol,factor,jp},
	(*solve for all possible combinations using established QVs and Quantities*)
	sol=DimensionalCombinations[os,s,IncludeQuantities->quants,GeneratedParameters->None];
	(*pick best solution*)
	sol=pickSolution[sol];
	(*if no solution create one of the form "canonical quantity"*)
	If[sol===None,
		factor=ReleaseHold[QuantityVariableCanonicalUnit[s]];
		jp=j+1;
		factor=Quantity[constant[jp],factor];
		{{s,factor},{factor},jp},
		{{s,sol},{},j}
	]
]
simplifyEquation[equ_,originalsymbols_,rules_,srules_,newsymbols_,gv_]:=Module[{ndequ},
	(* pass 1: transform derivatives *)
	ndequ=(equ/.Derivative[n__][s_?(MemberQ[originalsymbols,#]&)][v__]:>
		convertDerivatives[{n},s,{v},rules, srules]);
	(* pass 2: transform functions *)
	ndequ=(ndequ/.s_?(MemberQ[originalsymbols,#]&)[v__]:>
		convertFunctions[s,{v},rules, srules]);
	(* pass 3: transform remaining symbols*)
	ndequ=ndequ/.rules;
	
	(* remove factor from leading term *)
	If[ListQ[ndequ],
		factorAndExpand[#,newsymbols,gv]&/@ndequ,
		factorAndExpand[ndequ,newsymbols,gv]
	]
]

generateRules[equ_,originalsymbols_,rules_,srules_,newsymbols_]:=Module[{drules,frules,nsymbols=srules[[All,2]],
	Rdrules,Rfrules,Rosrules,Rsrules=Reverse/@srules,
	multipliers,nrules=Rule[#,1]&/@srules[[All,2]]},
	multipliers=rules[[All,2]]/.nrules;
	(*get forward and backward multipliers*)
	multipliers={"NondimensionalizationMultipliers"->Association[MapThread[Rule,{rules[[All,1]],multipliers}]],
		"DimensionalizationMultipliers"->Association[MapThread[Rule,{srules[[All,2]],1/multipliers}]]};
	(* pass 1: extract derivatives and make rules *)
	drules=DeleteDuplicates@Cases[equ,Derivative[n__][s_?(MemberQ[originalsymbols,#]&)][v__]:>(
		Derivative[n][s][v]->convertDerivatives[{n},s,{v},rules,srules]),Infinity];
	Rdrules=(Module[{d=First@Cases[Last[#],Derivative[__][_][__],Infinity]},d->(First[#]/Last[#]/.d->1)])&/@drules;
	(*TODO: come up with a way to create more general rules - i.e. not derivative order specific *)
	(* pass 2: extract functions and make rules *)
	frules=DeleteDuplicates@Cases[equ,s_?(MemberQ[originalsymbols,#]&)[v__]:>(
		s[v]->convertFunctions[s,{v},rules,srules]),Infinity];
	Rfrules=(Module[{f=First@Cases[Last[#],_?(MemberQ[nsymbols,#]&)[__],Infinity]},f->(First[#]/Last[#]/.f->1)])&/@frules;
	(* pass 3: trim rules down to the remaining symbols*)
	Rosrules=(Module[{s=First@Cases[Last[#],_?(MemberQ[nsymbols,#]&),Infinity]},s->(First[#]/Last[#]/.s->1)])&/@rules;
	PowerExpand[Join[{"NondimensionalizationRules"->Join[drules,frules,rules],
		"DimensionalizationRules"->Join[Rdrules,Rfrules,Rosrules]},multipliers]]
]


factorAndExpand[ndequ_,newsymbols_,gv_]:=Module[{factor},
	factor=extractLeadingCoefficient[ndequ,newsymbols,gv];
	Expand[Simplify@PowerExpand[ndequ[[1]]/factor]]==Expand[Simplify@PowerExpand[ndequ[[2]]/factor]]
]

(*testing input*)
inertQ[symbol_]:=Quiet[Module[{s1=symbol[1.],s2=symbol[1]},If[Head[s1]===Head[s2]===symbol,True,
	Message[System`NondimensionalizationTransform::ninert, symbol];False]]];
pqTest[expr_]:=Module[{qv=Cases[expr,_QuantityVariable,Infinity]},
	Quiet[Check[QuantityVariableDimensions/@qv;True,False,{QuantityVariable::unkpq}],
		{QuantityVariable::unkpq}]
]
testEquationQ[equ_,vi_]:=Module[{fqv=Cases[equ,v_QuantityVariable[__]:>v,Infinity],
	qv=Cases[equ,_QuantityVariable,Infinity],dfqv=Cases[equ,Derivative[__][v_QuantityVariable][__]:>v,Infinity]},
	fqv=Union[fqv,dfqv];
	If[Complement[fqv,vi]=!={},
		Message[System`NondimensionalizationTransform::invpq2,vi];Return[False]
	];
	qv=Union[qv,fqv];
	If[Complement[vi,qv]=!={},
		Message[System`NondimensionalizationTransform::invequ,vi];Return[False]
	];
	True
]

(*alternate QuantityVariableDimensions that can handle dimensionless symbols within a term*)
oTermDimensions[args_]:=Module[
	{converted=convertPQCombinations[args]},
	If[FreeQ[converted,$Failed],
		(*this should be a single Quantity, perhaps times some other symbols. 
			We need just the Quantity for dimension checking*)
		converted=converted/.HoldPattern[Times[___,q_Quantity,___]]:>q;
		converted=UnitDimensions[converted];
		If[MatchQ[converted,{{_,_?NumericQ}..}]||MatchQ[converted,{}],converted,args],
		args (* most likely to fail in testBalanceQ *)
	]
]

testBalanceQ[equ_List]:=And@@(testBalanceQ/@equ);
testBalanceQ[equ_]:=Module[{terms,nequ=equ/.{TildeEqual|Greater|GreaterEqual|LessEqual|Less|TildeTilde|Greater->Equal}},
	nequ=Expand[If[MatchQ[nequ,_Equal],equ[[1]]+equ[[2]],equ]];
	If[MatchQ[nequ,_Plus],terms=List@@nequ,Return[False]];(*if a single term we want it to fail*)
	terms=oTermDimensions/@terms;
	terms = terms /. {x_, _UnitDimensions ..} :> x;
	SameQ @@ terms
]
formatEquation[eqs_List]:=formatEquation/@eqs
formatEquation[eq_Equal]:=eq
formatEquation[eq_]:=Module[{meq=eq/.{TildeEqual|Greater|GreaterEqual|LessEqual|Less|TildeTilde|Greater->Equal}},
	If[Head[meq]===Equal,
		meq,
		eq==0
	]
]

(*main code*)
Options[System`NondimensionalizationTransform]={GeneratedParameters->C,System`GeneratedQuantityMagnitudes->K,IncludeQuantities->{},UnitSystem->Automatic};
System`NondimensionalizationTransform["Properties"]:=Sort[{"PropertyAssociation", "ReducedForm", "NondimensionalizationRules", 
		"DimensionalizationRules", "NondimensionalizationMultipliers", "DimensionalizationMultipliers"}]
System`NondimensionalizationTransform[equ_,vinitial_,vfinal_,opts:OptionsPattern[]]:=With[
	{res=iNondimensionalize[equ,vinitial,vfinal,"ReducedForm",
		OptionValue[IncludeQuantities],OptionValue[GeneratedParameters],OptionValue[System`GeneratedQuantityMagnitudes],
		OptionValue[UnitSystem]]},
	res/;res=!=$Failed
	]
System`NondimensionalizationTransform[equ_,vinitial_,vfinal_,prop_,opts:OptionsPattern[]]:=With[
	{res=iNondimensionalize[equ,vinitial,vfinal,prop,
		OptionValue[IncludeQuantities],OptionValue[GeneratedParameters],OptionValue[System`GeneratedQuantityMagnitudes],
		OptionValue[UnitSystem]]},
	res/;res=!=$Failed
	]

(*internal code*)	
iNondimensionalize[equ_,vi:Except[_List],vf_,prop_,quantities_,symbol_,constant_,method_]:=If[
	Length[vi]===0||MatchQ[vi,_QuantityVariable],
	iNondimensionalize[equ,{vi},vf,prop,quantities,symbol,constant,method],
	$Failed
]
iNondimensionalize[equ_,vi_List,vf:Except[_List],prop_,quantities_,symbol_,constant_,method_]:=
	iNondimensionalize[equ,vi,{vf},prop,quantities,symbol,constant,method]
iNondimensionalize[equ_,uservi_List,vf_List,prop_,qs_,s_,c_,m_]:=Module[{quantities,symbol,fequ=equ,
	constant,method,result,equqvs=Cases[equ,_QuantityVariable,Infinity],vi},
	(* check original and final variables*)
	If[Length[uservi]=!=Length[vf],Message[System`NondimensionalizationTransform::nmtch];Return[$Failed]];
	equqvs=(QuantityVariableIdentifier[#]->#)&/@equqvs;
	vi=If[MatchQ[#,_QuantityVariable],#,#/.equqvs]&/@uservi;
	If[!MatchQ[vi,{QuantityVariable[_?(FreeQ[#,QuantityVariable|Quantity]&),_?(FreeQ[#,QuantityVariable|Quantity]&)]..}],Message[System`NondimensionalizationTransform::invpq1];Return[$Failed]];
	(* check and format equation(s)*)
	If[Not[pqTest[equ]&&pqTest[vi]],Message[System`NondimensionalizationTransform::invpq1];Return[$Failed]];
	If[testEquationQ[fequ,vi],
		If[testBalanceQ[fequ],
			fequ=formatEquation[fequ],
			Message[System`NondimensionalizationTransform::unbal];Return[$Failed]
		],
		Return[$Failed]
	];
	fequ=fequ/.Quantity[None,u__]:>Quantity[1,u];(*remove formatting tricks*)
	(* test vf are inert symbols *)
	If[!AllTrue[vf,inertQ],Return[$Failed]];
	If[!FreeQ[vf,QuantityVariable|Quantity],Message[System`NondimensionalizationTransform::qv];Return[$Failed]];
	
	(*check property is valid*)
	If[prop==="Properties",Return[Sort@{"PropertyAssociation", "ReducedForm", "NondimensionalizationRules", 
		"DimensionalizationRules", "NondimensionalizationMultipliers", "DimensionalizationMultipliers"}]];
	If[!MemberQ[{All, "PropertyAssociation", "ReducedForm", "NondimensionalizationRules", 
		"DimensionalizationRules", "NondimensionalizationMultipliers", "DimensionalizationMultipliers"},prop],
		Message[System`NondimensionalizationTransform::notprop,prop,System`NondimensionalizationTransform];Return[$Failed]];
	
	(*check and format quantities*)
	quantities=If[ListQ[qs],Flatten[qs],{qs}];
	quantities=Flatten[If[MatchQ[#,_Quantity], #, If[MatchQ[#,_String],Quantity[#], {}]] & /@ 
		quantities];
	(*check symbol is inert*)
	symbol=If[inertQ[s],s,C];
	constant=If[inertQ[c],c,K];
	If[constant===None,Message[System`NondimensionalizationTransform::ngc,c];constant=K];
	
	(*check method options*)
	Which[m===Automatic,
			method=None,
		!MemberQ[{"GaussianNaturalUnits", "GaussianQuantumChromodynamicsUnits", "HartreeAtomicUnits", 
			"LorentzHeavisideNaturalUnits", "LorentzHeavisideQuantumChromodynamicsUnits", "PlanckUnits", 
			"RydbergAtomicUnits", "StonyUnits", "DeSitterUnits"},m],
			Message[System`NondimensionalizationTransform::bdmtd,m];
			Return[$Failed],
		True,
			method=m
	];
	result=If[method===None,
		nonDimensionalSolver[fequ,vi,vf,symbol,quantities,constant],
		naturalUnitSolver[fequ,vi,vf,symbol,method,constant]
	];
	If[!MemberQ[{All,"PropertyAssociation"},prop],
		result=result[prop]
	];
	(*tweak results if original equation included an alternate relation*)
	Which[MemberQ[{All,"PropertyAssociation"},prop],
		fequ=result["ReducedForm"];
		fequ=tweakRelation[fequ,equ];
		Prepend[result,"ReducedForm"->fequ],
		prop==="ReducedForm",
		tweakRelation[result,equ],
		True,
		result
	]
]

tweakRelation[nequ_,equ_Equal]:=nequ
tweakRelation[nequ_,equ_List]:=MapThread[tweakRelation,{nequ,equ}]
tweakRelation[nequ_,equ_]:=Module[{h=Head[equ]},
	If[MatchQ[h,TildeEqual|Greater|GreaterEqual|LessEqual|Less|TildeTilde|Greater],
		nequ/.Equal->h,
		nequ
	]
]

naturalUnitsTranslation["PlanckUnits"] = { 
	"LengthUnit" -> Quantity[1, (Sqrt["ReducedPlanckConstant"] Sqrt["GravitationalConstant"])/Sqrt["SpeedOfLight"]^3], 
	"MassUnit" -> Quantity[1, (Sqrt["ReducedPlanckConstant"] Sqrt["SpeedOfLight"])/Sqrt["GravitationalConstant"]],
	"TimeUnit" -> Quantity[1, (Sqrt["ReducedPlanckConstant"] Sqrt["GravitationalConstant"])/Sqrt["SpeedOfLight"]^5],
	"TemperatureUnit" -> Quantity[1, (Sqrt["ReducedPlanckConstant"] Sqrt["SpeedOfLight"]^5)/
		(Sqrt["GravitationalConstant"] "BoltzmannConstant")],
	"ElectricCurrentUnit" -> Quantity[Sqrt[4 Pi], (Sqrt["ElectricConstant"] "SpeedOfLight"^3)/Sqrt["GravitationalConstant"]]};
naturalUnitsTranslation["StonyUnits"] = { 
	"LengthUnit" -> Quantity[1/Sqrt[4 Pi], (Sqrt["GravitationalConstant"] "ElementaryCharge")/("SpeedOfLight"^2 Sqrt["ElectricConstant"])], 
	"MassUnit" -> Quantity[1/Sqrt[4 Pi], ("ElementaryCharge")/(Sqrt["GravitationalConstant"] Sqrt["ElectricConstant"] )],
	"TimeUnit" -> Quantity[1/Sqrt[4 Pi], (Sqrt["GravitationalConstant"] "ElementaryCharge")/("SpeedOfLight"^3 Sqrt["ElectricConstant"])],
	"TemperatureUnit" -> Quantity[1/Sqrt[4 Pi], ("SpeedOfLight"^2 "ElementaryCharge")/
		(Sqrt["GravitationalConstant"] "BoltzmannConstant" Sqrt["ElectricConstant"])],
	"ElectricCurrentUnit" -> Quantity[Sqrt[4 Pi], ("SpeedOfLight"^3 Sqrt["ElectricConstant"])/(Sqrt["GravitationalConstant"])]};
naturalUnitsTranslation["HartreeAtomicUnits"] = { 
	"LengthUnit" -> Quantity[4 Pi, ("ReducedPlanckConstant"^2 "ElectricConstant")/("ElectronMass" "ElementaryCharge"^2)], 
	"MassUnit" -> Quantity[1, "ElectronMass"],
	"TimeUnit" -> Quantity[(4 Pi)^2, ("ReducedPlanckConstant"^3 "ElectricConstant"^2)/("ElectronMass" "ElementaryCharge"^4)],
	"TemperatureUnit" -> Quantity[1/(4 Pi)^2, ("ElectronMass" "ElementaryCharge"^4)/
		("ReducedPlanckConstant"^2 "ElectricConstant"^2 "BoltzmannConstant")],
	"ElectricCurrentUnit" -> Quantity[1/(16*Pi^2), ("ElectronMass"*"ElementaryCharge"^5)/
    	("ElectricConstant"^2*"ReducedPlanckConstant"^3)]};
naturalUnitsTranslation["RydbergAtomicUnits"] = { 
	"LengthUnit" -> Quantity[Pi, ("ReducedPlanckConstant"^2 "ElectricConstant")/("ElectronMass" "ElementaryCharge"^2)], 
	"MassUnit" -> Quantity[2, "ElectronMass"],
	"TimeUnit" -> Quantity[2 Pi^2, ("ReducedPlanckConstant"^3 "ElectricConstant"^2)/("ElectronMass" "ElementaryCharge"^4)],
	"TemperatureUnit" -> Quantity[2/(8 Pi)^2, ("ElectronMass" "ElementaryCharge"^4)/
		("ReducedPlanckConstant"^2 "ElectricConstant"^2 "BoltzmannConstant")],
	"ElectricCurrentUnit" -> Quantity[1/(32*Sqrt[2]*Pi^2), ("ElectronMass"*"ElementaryCharge"^5)/
 		("ElectricConstant"^2*"ReducedPlanckConstant"^3)]};
naturalUnitsTranslation["LorentzHeavisideQuantumChromodynamicsUnits"] = { 
	"LengthUnit" -> Quantity[1, ("ReducedPlanckConstant")/("ProtonMass" "SpeedOfLight")], 
	"MassUnit" -> Quantity[1, "ProtonMass"],
	"TimeUnit" -> Quantity[1, ("ReducedPlanckConstant")/("ProtonMass" "SpeedOfLight"^2)],
	"TemperatureUnit" -> Quantity[1, ("ProtonMass" "SpeedOfLight"^2)/"BoltzmannConstant"],
	"ElectricCurrentUnit" -> Quantity[1/Sqrt[4 Pi], ("ProtonMass" "SpeedOfLight"^2 "ElementaryCharge")/
		("ReducedPlanckConstant" Sqrt["FineStructureConstant"])]};
naturalUnitsTranslation["GaussianQuantumChromodynamicsUnits"] = { 
	"LengthUnit" -> Quantity[1, ("ReducedPlanckConstant")/("ProtonMass" "SpeedOfLight")], 
	"MassUnit" -> Quantity[1, "ProtonMass"],
	"TimeUnit" -> Quantity[1, ("ReducedPlanckConstant")/("ProtonMass" "SpeedOfLight"^2)],
	"TemperatureUnit" -> Quantity[1, ("ProtonMass" "SpeedOfLight"^2)/"BoltzmannConstant"],
	"ElectricCurrentUnit" -> Quantity[1, ("ProtonMass" "SpeedOfLight"^2 "ElementaryCharge")/
    	("ReducedPlanckConstant" Sqrt["FineStructureConstant"])]};
naturalUnitsTranslation["LorentzHeavisideNaturalUnits"] = { 
	"LengthUnit" -> Quantity[1, ("ReducedPlanckConstant" "SpeedOfLight")/"Electronvolts"], 
	"MassUnit" -> Quantity[1, "Electronvolts"/"SpeedOfLight"^2],
	"TimeUnit" -> Quantity[1, "ReducedPlanckConstant"/"Electronvolts"],
	"TemperatureUnit" -> Quantity[1, "Electronvolts"/"BoltzmannConstant"],
	"ElectricCurrentUnit" -> Quantity[1/Sqrt[4 Pi], ("Electronvolts" "ElementaryCharge")/
    	("ReducedPlanckConstant" Sqrt["FineStructureConstant"])]};
naturalUnitsTranslation["GaussianNaturalUnits"] = { 
	"LengthUnit" -> Quantity[1, ("ReducedPlanckConstant" "SpeedOfLight")/"Electronvolts"], 
	"MassUnit" -> Quantity[1, "Electronvolts"/"SpeedOfLight"^2],
	"TimeUnit" -> Quantity[1, "ReducedPlanckConstant"/"Electronvolts"],
	"TemperatureUnit" -> Quantity[1, "Electronvolts"/"BoltzmannConstant"],
	"ElectricCurrentUnit" -> Quantity[1, ("Electronvolts" "ElementaryCharge")/
		("ReducedPlanckConstant" Sqrt["FineStructureConstant"])]};
naturalUnitsTranslation["DeSitterUnits"] = { 
	"LengthUnit" -> Quantity[1, 1/Sqrt["CosmologicalConstantValueDarkEnergyBased"]], 
	"MassUnit" -> Quantity[1, "SpeedOfLight"^2/
		(Sqrt["CosmologicalConstantValueDarkEnergyBased"]*"GravitationalConstant")],
	"TimeUnit" -> Quantity[1, 1/(Sqrt["CosmologicalConstantValueDarkEnergyBased"]*"SpeedOfLight")],
	"TemperatureUnit" -> Quantity[1, "SpeedOfLight"^4/("BoltzmannConstant"*
		Sqrt["CosmologicalConstantValueDarkEnergyBased"]*"GravitationalConstant")],
	"ElectricCurrentUnit" -> Quantity[Sqrt[4 Pi], "SpeedOfLight"^3*Sqrt["ElectricConstant"]/
		Sqrt["GravitationalConstant"]]};