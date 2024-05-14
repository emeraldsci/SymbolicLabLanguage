$QueryTimeout=Automatic;

blueBox[text_String]:=If[Head[$FrontEnd]===FrontEndObject,
DisplayTemporary[
 Internal`LoadingPanel[text]],
  Print[text],
  Print[text]]

(*basic utilities to access/modify system quantity-cache*)
addToUHT[input_String,quantity_Quantity]:=Internal`SetQuantityCache[input,quantity];
addToUHT[___]:=$Failed
getFromUHT[input_String]:=If[
	And[
		UnsameQ[$QUnitInputAliasesFailed,True],
		System`Utilities`HashTableContainsQ[QUnitInputAliases,input]
		],
	With[{u=System`Utilities`HashTableGet[QUnitInputAliases,input]},
		Quantity[1,u]],
	Internal`CheckQuantityCache[input],
	Internal`CheckQuantityCache[input]
	]
getFromUHT[___]:=$Failed

ClearQuantityCache[]:=(Clear[$UnitDisplayCache,$KnownUnitQCache,$CompatibleUnitQCache];
$UnitDisplayCache=System`Utilities`HashTable[];
$KnownUnitQCache=System`Utilities`HashTable[];
$CompatibleUnitQCache=System`Utilities`HashTable[];
$UnitDisplayCacheSize=0;
$KnownUnitQCacheSize=0;
$CompatibleUnitQCacheSize=0;);

(*get paclet units and unit short name aliases from UnitAliases.m; bail out if not found*)
getOrFail[FileNameJoin[{DirectoryName[$InputFileName],"UnitAliases.m"}]]

Unprotect[DatedQuantityToDatedUnitQuantity];
SetAttributes[DatedQuantityToDatedUnitQuantity, HoldAll];
DatedQuantityToDatedUnitQuantity[Quantity[mag_, unit_]] := With[{u = ReplaceAll[unit, d_Dated :> DatedToDatedUnit[d]]},
	Quantity[mag, u]
]

DatedToDatedUnit[Dated[u_, date_]] := With[{d = If[IntegerQ[date], {date}, date]},
	DatedUnit[u, d]
]

QuantityUnits`$ParseTimeConstraint = 10;
(*parse units using special WolframAlpha[] flag*)
ToQuantity[""] = $Failed
ToQuantity[input_String] /; TrueQ[$AutomaticUnitParsing] := With[{r = getFromUHT[input]},
	If[
		r=!=$Failed,
		r,
		Module[{bb},
			TimeConstrained[
					bb=blueBox["Interpreting unit \""<>input<>"\"...."];
					With[{res = Internal`MWACompute["MWAToQuantity", input, "MessageHead" -> Quantity, TimeConstraint -> QuantityUnits`$ParseTimeConstraint]},
						Quiet[NotebookDelete[bb]];
						If[MatchQ[res, HoldComplete[_Quantity]],
							Block[{$AutomaticUnitParsing=False},
								Module[{q=Quiet[ReleaseHold[res]]},
									If[QuantityQ[q],
										q; addToUHT[input,q]; q,
										$Failed,
										$Failed
									]
								]
							],
							$Failed,
							$Failed
						]
					],
				($QueryTimeout /. { Automatic -> 15}),
				Message[Quantity::timeout,Quantity]; $Failed
			]
		]
	]
]
ToQuantity[Quantity[mag_, unit_String]] := With[{res = ToQuantity[unit]},
	If[res =!= $Failed,
		If[Not[MixedUnitQ[res]],
			With[{u = QuantityUnit[res]},
				Quantity[mag, u]
			],
			res * mag
		],
		$Failed,
		$Failed
	]
]
(*interpret units passed up from kernel-code w/out triggering down-code*)
ToQuantity[UnknownQuantity[mag_, unit_String]] := With[{res = ToQuantity[unit]},
	If[res =!= $Failed,
		If[Not[MixedUnitQ[res]],
			With[{m = mag,u = QuantityUnit[res]},
				Quantity[m, u]],
		res*mag],$Failed,$Failed]]
ToQuantity[UnknownQuantity[mag_, (Dated|DatedUnit)[unit_String]]]:=ToQuantity[UnknownQuantity[mag,unit]]

ToQuantity[UnknownQuantity[mag_, Dated[unit_, date_]]] := With[{d = If[IntegerQ[date], {date}, date]},
	Quantity[mag, DatedUnit[unit, d]]
]
	
ToQuantity[UnknownQuantity[mag_, DatedUnit[unit_String,date_]]]:=If[
	And[KnownUnitQ[unit],DateObjectQ[date]],(*quick validation for DateObject's which might not have validated*)
	Quantity[mag,DatedUnit[unit,date]],
	If[Not[Or[NumericQ[date],MatchQ[date,{_?NumericQ..}],DateObjectQ[date]]],
	$Failed,
	With[{res=ToQuantity[unit]},If[res=!=$Failed,If[Not[MixedUnitQ[res]],
		With[{m=mag,u=DatedUnit[QuantityUnit[res],date]},Quantity[m,u]],
		$Failed],$Failed,$Failed]]]
]
ToQuantity[q:UnknownQuantity[mag_,unit_]]/;Not[FreeQ[HoldForm[unit],DatedUnit]]:= Catch[
	With[{u=Cases[HoldForm[unit],_DatedUnit,-1],test=unit/._DatedUnit->1},
	If[Not[Or[Quiet[QuantityQ[Quantity[1,test]]],NumericQ[test]]],Throw[$Failed,$tag]];
	Module[{rules=parseDatedUnits[u]},
		(q/.rules)/.UnknownQuantity->Quantity
	]	
], $tag]
ToQuantity[___]:=$Failed

parseDatedUnits[{}]:=Throw[$Failed,$tag]
parseDatedUnits[u_List]:= Table[
	With[{r=ToQuantity[UnknownQuantity[1,i]/.DatedUnit[s_String,_]:>s]},
		If[SameQ[r,$Failed],Throw[$Failed,$tag]];
		Rule[i,DatedUnit[QuantityUnit[r],i[[2]]]]],
		{i, u}
]
parseDatedUnits[___]:=Throw[$Failed,$tag]

$KnownUnitQCache = System`Utilities`HashTable[];
$KnownUnitQCacheSize = 0;

SetAttributes[KnownUnitQCacheContainsQ, HoldAll];
KnownUnitQCacheContainsQ[unit_] := Quiet[Check[(*possible messages from 268125*)
 System`Utilities`HashTableContainsQ[$KnownUnitQCache, HoldForm[unit]],False]]
KnownUnitQCacheContainsQ[___] := False

KnownUnitQCacheAdd[
   heldform_] := (If[TrueQ[$KnownUnitQCacheSize >= $MaxCacheSize], 
    Clear[$KnownUnitQCache]; $KnownUnitQCache = 
     System`Utilities`HashTable[]; $KnownUnitQCacheSize = 
     1;, $KnownUnitQCacheSize++];
   System`Utilities`HashTableAdd[$KnownUnitQCache, heldform, Null]);

Attributes[KnownUnitQ] = {HoldAll};
KnownUnitQ[]:=(Message[KnownUnitQ::argx,KnownUnitQ,0];Null/;False)
KnownUnitQ[expr_]:=If[
	KnownUnitQCacheContainsQ[expr], 
	True, 
 	With[{r = iKnownUnitQ[expr]}, 
  		If[
  			TrueQ[r], 
  			KnownUnitQCacheAdd[HoldForm[expr]]; True, 
  			False,
  			False]],
  	False]
KnownUnitQ[_,args__]:=(Message[KnownUnitQ::argx,KnownUnitQ,Length[{args}]+1];Null/;False)

iKnownUnitOr1Q[expr_] := Or[iKnownUnitQ[expr], expr === 1]

Attributes[iKnownUnitQ] = Attributes[iKnownUnitOr1Q] = {HoldAll};
iKnownUnitQ[unit_String] := MemberQ[QuantityUnits`$UnitList, unit]
iKnownUnitQ[Times[args__]] := AllTrue[{args}, iKnownUnitOr1Q]
iKnownUnitQ[Power[unit_, Except[_String]]] := iKnownUnitQ[unit]
iKnownUnitQ[IndependentUnit[_String]] := True
iKnownUnitQ[MixedUnit[{args__}]] := And[AllTrue[{args}, KnownUnitQ], Internal`SameUnitDimension[args]]
iKnownUnitQ[_?NumericQ] := False
iKnownUnitQ[(Dated|DatedUnit)[unit_String,date_]] := With[{d = date},(*deal with funkyness in held unit*)
	And[
		KnownUnitQ[unit],
		Or[
			NumericQ[d],
			MatchQ[d,{_?NumericQ..}],
			DateObjectQ[d]
		]
	]
]
iKnownUnitQ[HoldForm[expr_]] := iKnownUnitQ[expr]
iKnownUnitQ[_] = False;

(*fast method for picking out currency-inclusive quantities*)
hasCurrencyQ[Quantity[_, unit_]] := hasCurrencyQ[unit]
hasCurrencyQ[unit_] := Not[FreeQ[unitTableDimensionsLookup[unit], "MoneyUnit"]]
hasCurrencyQ[__]=False;

couldBeACurrencyQ[input_]:=With[{res=hasCurrencyQ[input]},
	If[TrueQ[res],
		True,
		If[MatchQ[input,_String|_DatedUnit],
			With[{q=Quiet[Quantity[1,input]]},
			Quiet[
				TrueQ[And[
					QuantityQ[q],
					hasCurrencyQ[q]
					]]
				]
			],
			False
		]
	]
]
couldBeACurrencyQ[___]:=False

hasDatedUnitQ[target_String]:=False
hasDatedUnitQ[_DatedUnit]:=True
hasDatedUnitQ[h:(_Times|_Power|_Divide|_HoldForm)]:=Not[FreeQ[Hold[h],DatedUnit]]
hasDatedUnitQ[(q_Quantity)?QuantityQ]:=hasDatedUnitQ[QuantityUnit[q]]
hasDatedUnitQ[__]=False;

(*only documented to work on pairs of Quantities, but also functions for various other cases when needed*)
Unprotect[CompatibleUnitQ];
CompatibleUnitQ[] := True
CompatibleUnitQ[l : (_List ..)] := With[{s = Union[Flatten[{l}]]}, CompatibleUnitQ @@ s]
CompatibleUnitQ[ l : (_?Developer`ListRepresentationQ ..)] :=
  CompatibleUnitQ[ Replace[{l}, {
      s_SparseArray :> {s["NonzeroValues"], If[ TrueQ[s["Density"]==1], {}, s["Background"]]}, 
      s_?StructuredArray`StructuredArrayQ :> If[Head[s] === QuantityArray, Map[Quantity[1, #] &, Flatten[{s["UnitBlock"]}]], Normal[s]]
  }, {1}]]
CompatibleUnitQ[arg1_] := Block[{$PureUnitiesFlag = True}, 
  With[{carg1 = iCompatibleUnitQFixArg[arg1]/.DatedUnit[unit_,_]:>unit}, 
   If[UnsameQ[carg1, $Failed], True, False, False]]]
CompatibleUnitQ[arg1_, arg2_] := Block[{$PureUnitiesFlag = True}, 
  With[{carg1 = iCompatibleUnitQFixArg[arg1]/.DatedUnit[unit_,_]:>unit, 
    carg2 = iCompatibleUnitQFixArg[arg2]/.DatedUnit[unit_,_]:>unit}, 
   If[And[UnsameQ[carg1, $Failed], UnsameQ[carg2, $Failed]], 
    iCompatibleUnitQ[carg1, carg2], False, False]]]
CompatibleUnitQ[arg1_, arg2_, args__] := Catch[iThreadAndCatchCompatibility[arg1, arg2, args],$tag]

grabFirstQuantityFromMixedUnit[HoldPattern[Quantity[MixedMagnitude[{v1_,__}],MixedUnit[{u_,__}]]]]:= With[
	{q=Quantity[v1,u]},
	If[Quiet[QuantityQ[q]],
		q,
		$Failed,
		$Failed]
]

iThreadAndCatchCompatibility[arg1_, args__] := (Scan[With[{r = CompatibleUnitQ[arg1, #]}, 
     If[Not[TrueQ[r]], Throw[False,$tag]]] &, {args}]; True)

iCompatibleUnitQFixArg[n_?NumericQ] := Quantity[1, "PureUnities"]
iCompatibleUnitQFixArg[(q_Quantity)?QuantityQ] := If[MixedUnitQ[q], grabFirstQuantityFromMixedUnit[q], q, q]
iCompatibleUnitQFixArg[s_String] := If[KnownUnitQ[s], 
	Quantity[1, s], 
  	With[{r = Quantity[s]}, 
   		If[Quiet[QuantityQ[r]], 
   			r, 
   			$Failed, 
   			$Failed]
   	]
]

iCompatibleUnitQFixArg[MixedUnit[{unit_, __}]?KnownUnitQ] := Quantity[1, unit]
iCompatibleUnitQFixArg[unit_?KnownUnitQ] := Quantity[1, unit]
iCompatibleUnitQFixArg[HoldForm[unit_?KnownUnitQ]] := Quantity[1, unit]
iCompatibleUnitQFixArg[_] := $Failed

iCompatibleUnitQ[u_, u_] := True
iCompatibleUnitQ[Quantity[_,u_],Quantity[_,u_]] := True (*same unit; 265320*)
iCompatibleUnitQ[arg1_, arg2_] := SameQ[UnitDimensions[arg1], UnitDimensions[arg2]]

AllQuantityQ[data_List]/;Not[Developer`PackedArrayQ[data]] := FreeQ[QuantityQ[#]& /@ data, False]
AllQuantityQ[___]:=False

(*overload Internal`PossibleQuantityQ with c-code QuantityQ function once QuantityUnits` has been loaded*)
Unprotect[Internal`PossibleQuantityQ];
Internal`PossibleQuantityQ[args__]:=QuantityQ[args]
Protect[Internal`PossibleQuantityQ];

MixedUnitQ[(Quantity[MixedMagnitude[mag_List], MixedUnit[unit_List]])?QuantityQ] := TrueQ[Length[mag] === Length[unit]]
MixedUnitQ[(Quantity[Interval[{MixedMagnitude[l_], MixedMagnitude[u_]}], MixedUnit[unit_]])?QuantityQ] := TrueQ[And[SameQ[Length[l], Length[u], Length[unit]]]]
MixedUnitQ[___]=False;

(*used for psudo-listable functions, currently just CommonUnits*)
QuantityOrQuantityListQ[input__] := iQuantityOrQuantityListQ[input]
iQuantityOrQuantityListQ[_?QuantityQ]:=True
iQuantityOrQuantityListQ[_?NumericQ] := True
iQuantityOrQuantityListQ[list_List]:=And@@(iQuantityOrQuantityListQ/@list)
iQuantityOrQuantityListQ[arg1_,args__]:=iQuantityOrQuantityListQ[{arg1,args}]
iQuantityOrQuantityListQ[{}] := True
iQuantityOrQuantityListQ[] := True
iQuantityOrQuantityListQ[___]:=False

justInertUnitQ[Quantity[_,_IndependentUnit]]:=True
justInertUnitQ[Quantity[_,Power[_IndependentUnit,_]]]:=True
justInertUnitQ[___]:=False

checkforInertUnit[q_Quantity]:=q
checkforInertUnit[n_?NumericQ]:=n
checkforInertUnit[t_Times]:=If[MatchQ[t,Times[___,_IndependentUnit]],With[{m=DeleteCases[t,_IndependentUnit],u=Times@@Cases[t,_IndependentUnit]},Quantity[m,u]],t]
checkforInertUnit[other___]:=other

isTemperatureQ[x_Quantity]:=MatchQ[getUnitDimensions[x], {"TemperatureUnit"->_}]
isTemperatureQ[___]:=False

UniformUnitCheck[{Quantity[_,unit_]..}]:=True
UniformUnitCheck[___]:=False

QuantityIntervalQ[l_List, q_Quantity] := Or @@ (QuantityIntervalQ[#, q] & /@ l);

QuantityIntervalQ[int : Quantity[Interval[{lo_, hi_}], unit_], q_Quantity] := 
 If[Quantity[lo, unit] <= q <= Quantity[hi, unit], True, False, False]

QuantityIntervalQ[l : Quantity[_List, _?KnownUnitQ], q_] := QuantityIntervalQ[Thread[l], q]

QuantityIntervalQ[int : Quantity[Interval[{lo_, hi_}], unit_], q_Quantity] := 
 If[Quantity[lo, unit] <= q <= Quantity[hi, unit], True, False, False]
 
QuantityIntervalQ[Interval[{q1_Quantity,q2_Quantity}],q_] := 
 If[q1 <= q <= q2, True, False, False]
 
QuantityIntervalQ[___] := False

(*testing function for matrix function arguments*)
UniformQuantityMatrixQ[_?Statistics`Library`RealMatrixQ]:=True
UniformQuantityMatrixQ[mat_?MatrixQ]:=MatchQ[mat,HoldForm[{{Quantity[_,unit_]..}..}]]
UniformQuantityMatrixQ[___]:=False

iQuantityCoprimeQ[(q__Quantity)?QuantityQ] /; CompatibleUnitQ[q] :=
With[{qs = QuantityMagnitude[StandardizeQuantities[{q}]]},CoprimeQ[Sequence @@ qs]]
iQuantityCoprimeQ[___]=$Failed;

(*test to handle cases like Quantity[a,b]*)
SetAttributes[hfUnitQ,HoldFirst];
hfUnitQ[unit_] := 
 With[{c = Cases[Hold[unit], _String, Infinity]}, 
  Length[c] =!= Length[Union[c]]]

(*utility function used in oQuantity DownCode*)
PureUnitiesQ[___]=False;
PureUnitiesQ["PureUnities"]=True;
PureUnitiesQ["DimensionlessUnit"]=True;
PureUnitiesQ["DimensionlessUnits"]=True;

badTDQ[Infinity]=False
badTDQ[i_Integer]:=Negative[i]
badTDQ[___]=True

(*test function that returns True for Or[QuantityMatrixQ,RealMatrixQ,Columnwise compatible units]*)
MixedQuantityMatrixQ[_?Statistics`Library`RealMatrixQ]:=False
MixedQuantityMatrixQ[_?Internal`QuantityMatrixQ]:=True
MixedQuantityMatrixQ[_?Internal`ColumnwiseQuantityVectorQ]:=True
MixedQuantityMatrixQ[mat_?MatrixQ]:=Catch[Apply[And,
        Table[If[#===False, Throw[False,$tag], #]&[Statistics`Library`RealVectorQ[i] ||Internal`QuantityVectorQ[i]], {i, mat}]
        ],$tag]/;Not[FreeQ[mat[[1]],Quantity]]
MixedQuantityMatrixQ[___]=False;

(*messaging function used to pick out incompatibility in operations*)
iFindInCompatibleUnits[args__]:=Module[{units=Union[QuantityUnit[{args}]],second},
			second=Quiet[Check[First[Select[units, Not[CompatibleUnitQ[First[units], #]]&]],"fail"]];
			If[second=!="fail",Message[Quantity::compat,
				First[units],
				second],Message[Quantity::compatu]]
		]

(*new QuantityUnits` context predicates suggested by jose*)

QuantityUnits`IntegerQuantityQ[(Quantity[mag_,__])?QuantityQ] := IntegerQ[mag]
QuantityUnits`IntegerQuantityQ[___] := False

QuantityUnits`MachineIntegerQuantityQ[(Quantity[mag_,__])?QuantityQ] := Developer`MachineIntegerQ[mag]
QuantityUnits`MachineIntegerQuantityQ[___]:=False

QuantityUnits`MachineNumberQuantityQ[(Quantity[mag_,__])?QuantityQ] := MachineNumberQ[mag]
QuantityUnits`MachineNumberQuantityQ[___]:=False

QuantityUnits`NumberQuantityQ[(Quantity[mag_,__])?QuantityQ] := NumberQ[mag]
QuantityUnits`NumberQuantityQ[___]:=False

QuantityUnits`NumericQuantityQ[(Quantity[mag_,__])?QuantityQ] := NumericQ[mag]
QuantityUnits`NumericQuantityQ[___]:=False

QuantityUnits`RealValuedNumberQuantityQ[(Quantity[mag_,__])?QuantityQ] :=Internal`RealValuedNumberQ[mag]
QuantityUnits`RealValuedNumberQuantityQ[___]:=False

QuantityUnits`RealValuedNumericQuantityQ[(Quantity[mag_,__])?QuantityQ] := Internal`RealValuedNumericQ[mag]
QuantityUnits`RealValuedNumericQuantityQ[___]:=False
