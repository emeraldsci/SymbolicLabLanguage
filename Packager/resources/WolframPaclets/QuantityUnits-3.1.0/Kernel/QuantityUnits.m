(* ::Package:: *)

Block[{$Path},
	Quiet[Quantity]  (*ensure auto-loader doesn't fire during initialization*)
];

(* Mathematica Package *)
BeginPackage["QuantityUnits`"]

System`Quantity;
System`QuantityMagnitude;
System`QuantityUnit;
System`UnitDimensions;
System`UnitConvert;
System`CompatibleUnitQ;
System`CommonUnits;
System`UnitSimplify;
System`IndependentUnit;
System`IndependentPhysicalQuantity;
System`MixedUnit;
System`MixedMagnitude;
System`MixedRadixQuantity;
System`QuantityQ;
QuantityBox;
CanonicalUnits;
System`KnownUnitQ;
System`CurrencyConvert
System`DatedUnit;
System`UnityDimensions;
System`DimensionalCombinations;
System`IncludeQuantities;
Internal`QuantityIntervalHandler;
QuantityUnits`NormalizeUnitExpression;
QuantityUnits`$UnitTable;


System`TargetUnits;
$AutomaticUnitTimes = True;
$AutomaticUnitPlus = True;
Internal`$DisableQuantityUnits = False;
$AutomaticUnitParsing = If[
	Not[ValueQ[$AutomaticUnitParsing]],
	True,
	TrueQ[$AutomaticUnitParsing]
];

Begin["`Private`"]
	
(*turn off messages that would be issued during code initialization*)
Off[Quantity::unkunit];
Off[Quantity::argrx];
Off[IndependentUnit::invd];
Off[Quantity::nonopt];

$tag;(*private tag for use in Throw/Catch*)
$DatedUnitIdentity = True;
$QuantityVariableQuantityIdentity = False;

(*symbols to be protected/read protected*)
$ProtectedSymbols = {
	Quantity, CompatibleUnitQ, KnownUnitQ, CanonicalUnits,
	QuantityBox,UnitConvert,QuantityAlternatives,QuantityLabel,QuantityMagnitude,QuantityUnit,
	StandardizeQuantities,ToQuantity,UnitDimensions,oUnitDimensions,QuantityUnitBox,
	UnitExchangeRate,IndependentUnit,IndependentPhysicalQuantity,UnknownQuantity,UnitExchangeRate,iQuantityMatrixFunction,
	ToQuantityString,ToQuantityBox,System`MixedRadixQuantity,QuantityQ,CommonUnits,UnitSimplify,Internal`QuantityToValue,
	Internal`QuantityArrayToNumericArray, CurrencyConvert, QuantityVariableSantityCheck, DatedUnit, hfUnitQ,
	QuantityVariable, QuantityVariableIdentifier,QuantityVariablePhysicalQuantity, QuantityVariableDimensions, 
	QuantityVariableCanonicalUnit,StandardizeUnit, PureUnitiesQ, UnitCliqueQ, SimplifyUnits, NormalizeMixedUnitQuantity,
	DimensionalCombinations, UnityDimensions, QuantityArray, Internal`QuantityIntervalHandler,
	MixedRadixToMixedUnitQuantity, CompareQuantities, QuantityUnits`NormalizeUnitExpression};
	
Unprotect@@$ProtectedSymbols;
	
$DynamicCurrencyConversion:=If[PacletManager`$AllowInternet==True,True,False,False];
(*inherit usage info from paclet manager, as loading Alpha code will clobber this*)
usage = Quantity::usage;
Quantity::nores="Unable to load Units resources.  Please ensure that your $InstallationDirectory hasn't been corrupted.";

(*utility function used to load critical files; if anything goes awry it issues a message, ends the current context and bails out to QuantityUnitsLoader*)
getOrFail[file_String] := With[{r = If[
	FileExistsQ[file],
	Check[Get[file],$Failed,{DumpGet::bgabi, DumpGet::bgbf, DumpGet::bgcor, DumpGet::bgcom, DumpGet::bginc, DumpGet::bgmx, DumpGet::bgnew, 
  DumpGet::bgsid, DumpGet::bgsys, DumpGet::bgver, Get::noopen}],
	$Failed]},
	If[SameQ[r,$Failed],
		Message[Quantity::nores];
		End[];(*`Private`*)
		EndPackage[];(*QuantityUnits`*)
		Throw[$Failed,"NOGET"](*bail out to QuantityUnitsLoader.m*)
	]
]

getOrFail[___] := getOrFail["NotAFile"]

(* $UnitReplacementRules is temporary until QA tests that use it are updated *) 
$UnitReplacementRules = AssociationMap[Identity,QuantityUnits`$UnitList];

(*load various unit modules; fail if any of them aren't found*)
getOrFail[FileNameJoin[{DirectoryName[$InputFileName],"UnitQFunctions.m"}]]
getOrFail[FileNameJoin[{DirectoryName[$InputFileName],"UnitConversion.m"}]]
getOrFail[FileNameJoin[{DirectoryName[$InputFileName],"Typesetting.m"}]]
getOrFail[FileNameJoin[{DirectoryName[$InputFileName],"QuantityVariables.m"}]]
getOrFail[FileNameJoin[{DirectoryName[$InputFileName],"UpValues.m"}]]

(*====================================================*)
Unprotect[QuantityMagnitude];
(*Attributes[QuantityMagnitude] = {Listable }*)
QuantityMagnitude[arr_?Developer`PackedArrayQ] := arr
QuantityMagnitude[n_?NumericQ]:=n
QuantityMagnitude[n_DirectedInfinity] := n
QuantityMagnitude[Quantity[magnitude_List,_List]]:=magnitude
QuantityMagnitude[(Quantity[magnitude_,_])?QuantityQ]:=magnitude
QuantityMagnitude[sa_?StructuredArray`StructuredArrayQ] := With[{res = StructuredArrayQuantityMagnitude[sa]}, res /; res =!= $Failed];
QuantityMagnitude[sa_?StructuredArray`StructuredArrayQ, unit_] := With[{res = StructuredArrayQuantityMagnitude[sa, unit]}, res /; res =!= $Failed];
QuantityMagnitude[list:(_List|_?ArrayQ)] := Map[QuantityMagnitude, list]
QuantityMagnitude[ts_TemporalData] := With[{res=quantityMagnitudeTimeSeries[ts]}, res/;res=!=$Failed]
QuantityMagnitude[ts_TemporalData, unit_?KnownUnitQ] := With[{res=quantityMagnitudeTimeSeries[ts, unit]}, res /; res=!=$Failed]
QuantityMagnitude[a_Association] := Map[quantityMagnitudeAssociation, a] /; AssociationQ[a]
QuantityMagnitude[a_Association, unit_?KnownUnitQ] := Map[quantityMagnitudeAssociation[#,unit]&, a] /; AssociationQ[a]
QuantityMagnitude[q_,unit_] := With[{r= qmagConvert[q, unit]}, r /; r=!=$Failed]
HoldPattern[Except[QuantityMagnitude[_]|QuantityMagnitude[_,_],QuantityMagnitude[args___]]]  := (
	ArgumentCountQ[QuantityMagnitude, Length[{args}], 1, 2]; Null /; False
)
      
qmagResultQ[expr_] := FreeQ[expr, $Failed|UnitConvert]

qmagConvert[q_, unit_] := With[{r = UnitConvert[q,unit]},
	If[qmagResultQ[r], QuantityMagnitude[r], $Failed]
]

quantityMagnitudeAssociation[q_?QuantityQ, target___] := QuantityMagnitude[q,target]
quantityMagnitudeAssociation[q_TemporalData, target___] := QuantityMagnitude[q, target]
quantityMagnitudeAssociation[sa_?StructuredArray`StructuredArrayQ, target___] := StructuredArrayQuantityMagnitude[sa, target]
quantityMagnitudeAssociation[list_List, target___] := Map[quantityMagnitudeAssociation[#,target]&, list]
quantityMagnitudeAssociation[a_Association, target___] := Map[quantityMagnitudeAssociation[#,target]&, a] /; AssociationQ[a]
quantityMagnitudeAssociation[other_,___] := other

quantityMagnitudeTimeSeries[series_?TemporalData`StructurallyValidTemporalDataQ, target___] :=
 Module[{states = series["ValueList"], vals, res},
  vals = QuantityMagnitude[states, target];(* validate result *)
  res = TemporalData`ReplaceStates[series, vals];
  If[TemporalData`StructurallyValidTemporalDataQ[res],
   res, Message[QuantityMagnitude::tsq, series];$Failed
   ]]
quantityMagnitudeTimeSeries[___] := $Failed

quantityUnitTimeSeries[series_?TemporalData`StructurallyValidTemporalDataQ] :=
 Module[{states = series["ValueList"], vals, res},
  vals = QuantityUnit[states];(* validate result *)
  res = TemporalData`ReplaceStates[series, vals];
  If[TemporalData`StructurallyValidTemporalDataQ[res],
   res, Message[QuantityUnit::tsq, series];$Failed
   ]]
quantityUnitTimeSeries[___] := $Failed

(* Action on the various types of structured arrays *)
StructuredArrayQuantityMagnitude[sa_] := Which[
	QuantityArray`QuantityArrayQ[sa],
		QuantityArray`QuantityArrayMagnitude[sa],
	True,
		QuantityMagnitude[Normal[sa, StructuredArray]]
];
StructuredArrayQuantityMagnitude[sa_, unit_] := Which[
	QuantityArray`QuantityArrayQ[sa],
		QuantityArray`QuantityArrayMagnitude[sa, unit],
	True,
		QuantityMagnitude[Normal[sa, StructuredArray], unit]
];

Unprotect[QuantityUnit];
(*Attributes[QuantityUnit] = {Listable }*)
QuantityUnit[_?NumericQ]:="DimensionlessUnit"
QuantityUnit[_DirectedInfinity] := "DimensionlessUnit"
QuantityUnit[Quantity[_,u_MixedUnit]]:=u
QuantityUnit[Quantity[_,DatedUnit[s_String,date_?IntegerQ]]]/;KnownUnitQ[s]:=DatedUnit[s,{date}]
QuantityUnit[Quantity[_,u:DatedUnit[_String,___]]]/;KnownUnitQ[u]:=u
QuantityUnit[Quantity[_,units:{(_String|_Times|_Power|_Divide)..}]]:=units(*//HoldForm*)
QuantityUnit[(q:Quantity[_,u_])?QuantityQ]:=With[{res=StandardizeUnit[u]},
	If[SameQ[res,False],
		HoldForm[u],
		res
	]]
QuantityUnit[Quantity[_,i:IndependentUnit[_String]]]:=i
QuantityUnit[sa_?StructuredArray`StructuredArrayQ] := With[{res = StructuredArrayQuantityUnit[sa]}, res /; res =!= $Failed];
QuantityUnit[ts_TemporalData] := With[{res=quantityUnitTimeSeries[ts]}, res/;res=!=$Failed]
QuantityUnit[a_Association] := Map[quantityUnitAssociation, a] /; AssociationQ[a]
QuantityUnit[list:(_List|_?ArrayQ)] := Map[QuantityUnit,list]
QuantityUnit[_,args__]:=(Message[QuantityUnit::argx,QuantityUnit,Length[{args}]+1];Null/;False)
QuantityUnit[]:=(Message[QuantityUnit::argx,QuantityUnit,0];Null/;False)

quantityUnitAssociation[q_?QuantityQ] := QuantityUnit[q]
quantityUnitAssociation[q_TemporalData] := QuantityUnit[q]
quantityUnitAssociation[sa_?StructuredArray`StructuredArrayQ] := StructuredArrayQuantityUnit[sa]
quantityUnitAssociation[list_List] := Map[quantityUnitAssociation[#]&, list]
quantityUnitAssociation[a_Association] := Map[quantityUnitAssociation[#]&, a] /; AssociationQ[a]
quantityUnitAssociation[n_?NumericQ] := "DimensionlessUnit"
quantityUnitAssociation[other_,___] := other
(* Action on the various types of structured arrays *)
StructuredArrayQuantityUnit[sa_] := Which[
	QuantityArray`QuantityArrayQ[sa],
		QuantityArray`QuantityArrayUnit[sa],
	True,
		QuantityUnit[Normal[sa, StructuredArray]]
];

SetAttributes[StandardizeUnit,HoldAll];
StandardizeUnit[u_]:=With[{rf=Sort[Cases[HoldForm[u],_String,-1]]},
	If[UnsameQ[Sort[Cases[List[u],_String,-1]],rf],(*if the held form differs from the unheld form, return held*)
		False,
		u(*/."DimensionlessUnit"->1 removing due to bug(292460)*),(*safe to evaluate u; won't lose any units*)
		False
	]]

Unprotect[UnitDimensions];
SetAttributes[UnitDimensions,Listable];
UnitDimensions[args_] := With[{res = Catch[unitTableDimensionLookup[args], $tag]},
	res /; res =!= $Failed
]
UnitDimensions[args___] := (System`Private`Arguments[UnitDimensions[args], {1, 1}]; Null /; False)

unitTableDimensionLookup[q_?QuantityQ] := unitTableDimensionLookup[QuantityUnit[q]]
unitTableDimensionLookup[HoldForm[u_]] := unitTableDimensionLookup[u]
unitTableDimensionLookup[u_?KnownUnitQ] := unitTableDimensionExprToListForm[unitTableDimensionsLookup[u]]
unitTableDimensionLookup[s_String] := With[{q = Quantity[s]}, If[QuantityQ[q], unitTableDimensionLookup[q], Throw[$Failed, $tag]]]
unitTableDimensionLookup[_?NumericQ] := {}
unitTableDimensionLookup[t_TemporalData] := unitDimensionsTimeSeries[t]
unitTableDimensionLookup[___] := Throw[$Failed, $tag]

unitTableDimensionExprToListForm[expr_] := With[{e = ReplaceAll[expr, {Times -> List, Power -> List}]},
	dimensionListPowerExpand[e]
]

dimensionListPowerExpand[_?NumberQ] := {}
dimensionListPowerExpand[l : {_String | _IndependentUnitDimension, Except[_String | _IndependentUnitDimension | _List]}] := {l}
dimensionListPowerExpand[l_List] := Map[If[ListQ[#], #, {#, 1}] &, l]
dimensionListPowerExpand[dim_] := {{dim, 1}}

unitTableDimensionsLookup[u_String] := QuantityUnits`$UnitTable[u]["UnitDimensions"]
unitTableDimensionsLookup[_?NumericQ] := 1
unitTableDimensionsLookup[Times[u_, n_]] := Times[unitTableDimensionsLookup[u],unitTableDimensionsLookup[n]]
unitTableDimensionsLookup[Power[u_, n_]] := With[{dim = unitTableDimensionsLookup[u]}, 
	If[
		NumericQ[dim],(* test is to avoid bad behavior in PowerExpand for edge-cases like "SunEarthMassRatio"^0.2 which are inherently dimensionless still *)
		dim,
		PowerExpand[Power[dim, n]]
	]
]
unitTableDimensionsLookup[IndependentUnit[u_String]] := IndependentUnitDimension[u]
unitTableDimensionsLookup[(Dated | DatedUnit)[u_, ___]] := unitTableDimensionsLookup[u]
unitTableDimensionsLookup[MixedUnit[{u_?KnownUnitQ, ___}]] := unitTableDimensionsLookup[u]

unitDimensionsTimeSeries[series_?TemporalData`StructurallyValidTemporalDataQ] :=
 Module[{states = series["ValueList"], vals, res},
  vals = UnitDimensions[states];(* validate result *)
  res = TemporalData`ReplaceStates[series, vals];
  If[TemporalData`StructurallyValidTemporalDataQ[res],
   res, Message[UnitDimensions::tsq, series];$Failed
   ]]
unitDimensionsTimeSeries[___] := $Failed

getFirstUnitFromMixedUnitQuantity[HoldPattern[Quantity[_, MixedUnit[{unit_, ___}]]]] := unit
getFirstUnitFromMixedUnitQuantity[other_] := QuantityUnit[other]

(*oUnitDimensions returns a list of physical dimension rules*)
SetAttributes[oUnitDimensions,Listable];
oUnitDimensions[arg_] := oUnitDimensionsForm[UnitDimensions[arg]]
(*special case for quantitysolver.mc code*)
oUnitDimensions[unit_, "ListUnits"->True]:= Which[
	QuantityQ[unit], ListUnitDimensions[unit],
	KnownUnitQ[unit], ListUnitDimensions[Quantity[1,unit]],
	NumericQ[unit], {"DimensionlessUnit" -> 1},
	True, $Failed
]
oUnitDimensions[___]:=$Failed
(*to 'legacy' form used internally by some utilities. TODO: update/remove all uses of this*)
oUnitDimensionsForm[{}] = {"DimensionlessUnit"->1};
oUnitDimensionsForm[l_List] := Rule @@@ l

(*ListUnitDimensions is used via oUnitDimensions[_,"ListUnits"->True], primarily for SeparateUnits*)
ListUnitDimensions[(q1:Quantity[_, units_])?QuantityQ]:= 
 Module[
  {u = Cases[{units}, x_String/;KnownUnitQ[x], Infinity], 
  	i=Cases[{units},x_IndependentUnit/;KnownUnitQ[x],Infinity],
  	dim = oUnitDimensions[units], s, m, all, alld, g},
  u=Flatten[{u,i}];
  s = Select[u, With[{ud=oUnitDimensions[#]},Length[ud] === 1&&First[ud][[2]]===1 ]&];
  m = DeleteCases[{With[{un = #}, Union[Cases[QuantityUnit@QuantityExpand[Quantity[1, un]], _String, -1]]] & /@Complement[u, s]},_?NumericQ, Infinity];
  all = Union[Flatten[{s, m}]];
  alld = {#, oUnitDimensions[#]} & /@ all;
  g = {#[[1, 2, 1, 1]], #[[All, 1]]} & /@ Gather[alld, #1[[2]] == #2[[2]] &];
  g = DeleteCases[g, x_ /; Not[MemberQ[dim[[All, 1]], x[[1]]]]];
  If[g==={},g={{"DimensionlessUnit", {"PureUnities"}}}];
  (Rule[#[[1]], # /. dim] & /@ g)/.HoldPattern[st_String -> {n_Integer, {IndependentUnit[n_Integer]}}] -> (st -> {n, {IndependentUnit[st]}})]
ListUnitDimensions[other___]:=oUnitDimensions[other]


(*call c-code for Quantity in Table to generate ranges*)
iGenerateQuantityRange[l_Quantity, u_Quantity]/;CompatibleUnitQ[l, u]/;And[NumericQuantityQ[l],NumericQuantityQ[u]] := 
 With[{di = QuantityUnit[l]}, Table[i, {i, l, u, Quantity[1, di]}]]
iGenerateQuantityRange[l_Quantity, u_Quantity, d_Quantity]/;CompatibleUnitQ[l, u, d] /; And[NumericQuantityQ[l],NumericQuantityQ[u], NumericQuantityQ[d]]:= 
 With[{di = UnitConvert[d, QuantityUnit[l]]}, Table[i, {i, l, u, di}]]
iGenerateQuantityRange[___]=$Failed;

addValues[MixedMagnitude[a_List], MixedMagnitude[b_List]] := MixedMagnitude[Map[Total, Transpose[{a,b}]]]
addValues[a_, b_] := a + b
	
callfastPlus[Quantity[val1_, unit_], Quantity[val2_, unit_]] := Quantity[addValues[val1, val2], unit]
callfastPlus[args__] := fastPlus@@ReplaceAll[{args}, mixed_?MixedUnitQ :> unmixMixedUnitQuantity[mixed]]

fastPlus[q1:Quantity[val1_, unit1_], q2:Quantity[val2_, unit2_]] := With[{res = Catch[doFastPlus[{val1, unit1}, {val2, unit2}], $tag]},
	Catch[If[
		SameQ[res, $Failed],
		If[
			temperatureAdditionQ[q1, q2],
			doTemperaturePlus[{val1, unit1}, {val2, unit2}],
			UnevaluatedPlus[q1, q2]
		],
		res
	], $tag]
]
fastPlus[args___] := UnevaluatedPlus[args]

getTemperatureValue[unit_] := unitTableFValueLookup[unit] /. "KelvinsDifference" -> "Kelvins"

doTemperaturePlus[{val1_, unit1_}, {val2_, unit2_}] := Module[
	{uv1 = getTemperatureValue[unit1], uv2 = getTemperatureValue[unit2], scale, unit},
	{scale, unit} =  getTemperatureScaleAndValue[{uv1, unit1}, {uv2, unit2}];
	Quantity[Total[{val1, val2} {uv1, uv2}/scale], unit]
]

getTemperatureScaleAndValue[{uv1_, unit1_}, {uv2_, unit2_}] :=
	If[
		SameQ[UnitDimensions[unit1], UnitDimensions[unit2]],
		First @ Sort @ {{uv1, unit1}, {uv2, unit2}},
		If[
			UnitDimensions[unit1] === $tempDimension,
			{uv1, unit1},
			{uv2, unit2}
		]
	]


$tempDiffDimension = {{"TemperatureDifferenceUnit", 1}};
$tempDimension = {{"TemperatureUnit", 1}};

temperatureAdditionQ[q1:Quantity[_, unit1_], q2:Quantity[_, unit2_]] := With[{ud1 = UnitDimensions[unit1], ud2 = UnitDimensions[unit2]},
	Which[
		Sort[{ud1, ud2}] === {$tempDiffDimension, $tempDimension},
		True,
		
		SameQ[ud1, ud2, $tempDimension],
		sameTemperatureScaleQ[q1, q2],
		
		True,
		Message[Quantity::compat, unit1, unit2];
		Throw[UnevaluatedPlus[q1,q2], $tag]
	]
]


$kelvinUnits = {
	"Attokelvins", 
	"Centikelvins", 
	"Decikelvins", 
	"Dekakelvins",
	"Dimikelvins",
	"Exakelvins", 
	"Femtokelvins", 
	"Gigakelvins", 
	"Hebdokelvins", 
	"Hectokelvins", 
	"Hellakelvins", 
	"Kelvins", 
	"Kilokelvins", 
	"Lactakelvins", 
	"Megakelvins", 
	"Micrikelvins", 
	"Microkelvins", 
	"Millikelvins", 
	"Myriakelvins", 
	"Myriokelvins", 
	"Nanokelvins", 
	"Petakelvins", 
	"Picokelvins", 
	"Terakelvins", 
	"Vendekakelvins", 
	"Vendekokelvins", 
	"Wekakelvins", 
	"Wekokelvins", 
	"Xennakelvins", 
	"Xennokelvins", 
	"Yoctokelvins", 
	"Yottakelvins", 
	"Zeptokelvins", 
	"Zettakelvins"
};

temperatureScaleLookup[__] = None;
Scan[
	Set[temperatureScaleLookup[#], "Kelvin"]&,
	$kelvinUnits
]

sameTemperatureScaleQ[q1:Quantity[_,unit1_], q2:Quantity[_,unit2_]] := If[
	SameQ[temperatureScaleLookup[unit1], temperatureScaleLookup[unit2], "Kelvin"],
	True,
	Message[Quantity::temp, unit1, unit2]; 
	Throw[UnevaluatedPlus[q1, q2], $tag]
]

doFastPlus[{val1_, unit1_}, {val2_, unit2_}] /; CompatibleUnitQ[unit1, unit2] := Module[
	{uv1 = getFValue[unit1], uv2 = getFValue[unit2], scale, unit},
	{scale, unit} =  First @ Sort @ {{uv1, unit1}, {uv2, unit2}};(*TODO: remove Sort in favor of faster ordering*)
	Quantity[Total[{val1, val2} {uv1, uv2}/scale], unit]
]
doFastPlus[___] := $Failed

FValueableQ[res_]:= UnsameQ[Cases[res, _String, -1], {"Kelvins"}]

getFValue[unit_] := If[!FValueableQ[#], Throw[$Failed, $tag], releaseExchangeRate[#]] &[PowerExpand[unitTableFValueLookup[unit]]]

handleNone[val_] := ReplaceAll[val, None->1]

qqPlus[q1:(Quantity[val1_,unit_])?QuantityQ,Quantity[val2_,unit_]]/;Not[MixedUnitQ[q1]]:=Quantity[handleNone[val1+val2],unit]

qqPlus[(Quantity[val1_,unit_IndependentUnit])?QuantityQ,Quantity[val2_,unit_IndependentUnit]]:=With[{total=handleNone[val1+val2]},Quantity[total,unit]]
	
(*unless IndependentUnit expressions are the same they are treated as incompatible*)
qqPlus[q1:(Quantity[_,unit1_IndependentUnit])?QuantityQ,q2:Quantity[_,unit2_IndependentUnit]] /; UnsameQ[unit1, unit2] := Block[
	{},
	Message[Quantity::compat,unit1,unit2];q1+q2]
	
(*general case for addition*)
qqPlus[(x_Quantity)?QuantityQ,(y_Quantity)?QuantityQ] := With[{res=handleNone[callfastPlus[x,y]]}, res]
qqPlus[arg1_, arg2_] := UnevaluatedPlus[arg1, arg2]

(* can be overloaded for logarithmic units to perform customized addition *)
iSameUnitQuantityPlus[list:{__MixedMagnitude},unit_MixedUnit] := Quantity[
	MixedMagnitude[Total /@ Transpose[list /. MixedMagnitude :> Identity]],
	unit
]
iSameUnitQuantityPlus[list_, unit_] := Quantity[Total[list], unit]

iCompatibleQuantityPlus[{q_Quantity}] := {q}
iCompatibleQuantityPlus[list_] := Map[ (* apply qqPlus to add different compatible quantities, and deal with possible failure *)
	ApplyqqPlus, 
	GatherBy[list, UnitDimensions]
]

RemoveUnevaluatedPlus[e_]:=Block[{UnevaluatedPlus},Replace[If[AtomQ[e],UnevaluatedPlus[e],Flatten[e, Infinity, UnevaluatedPlus]], HoldPattern[UnevaluatedPlus][a__] :> Sequence[a]]]

ApplyqqPlus[{}] := 0
ApplyqqPlus[{q_}] := q
ApplyqqPlus[list_] := RemoveUnevaluatedPlus[Fold[qqPlus, list]]

iQuantityPlus[{q1_Quantity,q2_Quantity}] := With[{res = handleNone[callfastPlus[q1,q2]]}, {res} /; QuantityQ[res]] (*fast-track for common 2-arg form*)
iQuantityPlus[list_] := iCompatibleQuantityPlus[ 
	Map[
		If[ Length[#] == 1, First[#], iSameUnitQuantityPlus[QuantityMagnitude[#], QuantityUnit[First[#]]]]&, 
		GatherBy[list /. mixed_?MixedUnitQ :> unmixMixedUnitQuantity[mixed], QuantityUnit]
	]
]

quantityCombineWithNumeric[qlist_List, num_?NumericQ] := Module[{ud, pos, ppos, expanded},
	ud = UnitDimensions /@ qlist;
	pos = Position[ ud, {}, {1}, Heads->False];
	If[ pos === {},
		Plus[num, ApplyqqPlus[qlist]]
		,
		expanded = Extract[qlist, pos, QuantityExpand];
		ppos = Position[ expanded, Except[_?QuantityQ], {1}, Heads->False];
		(Total[Extract[expanded, ppos]] + num) + Plus[ApplyqqPlus[Join[ Delete[expanded, ppos], Delete[qlist, pos] ]] ]
	]
]

quantityCombineWithNumeric[qlist_List, e_Plus] /; NumericQ[First[e]] := Plus[quantityCombineWithNumeric[qlist, First[e]], Rest[e]]

quantityCombineWithNumeric[qlist_List, e_] := Plus[e, ApplyqqPlus[qlist]]

System`Quantity/:HoldPattern[Plus][Shortest[e1___],q_Quantity?QuantityQ,Longest[e2___]] /; $AutomaticUnitPlus===True := Block[{$AutomaticUnitPlus=False}, Module[{arg,qplus,oplus, res},
res = Catch[
	arg = GatherBy[{q,e1,e2},QuantityQ];
	arg = MapAt[iQuantityPlus, arg, 1];
	Switch[Length[arg],
		1, Plus[ApplyqqPlus[First[arg]]],
		2, {qplus, oplus} = MapAt[Total, arg, 2];
		   quantityCombineWithNumeric[qplus, oplus],
		_, (System`Private`SystemAssert[False]; Total[Total /@ arg])
	],
	$tag 
];
	res /; res =!= False
]]

Unprotect[Quantity];
(*UpValues for Times operations*)

System`Quantity/:HoldPattern[Times][Shortest[e1___],q_Quantity?QuantityQ,Longest[e2___]] /; $AutomaticUnitTimes===True := Block[{$AutomaticUnitTimes=False}, 
Module[{arg,qprod,oprod},
	arg = GatherBy[{q,e1,e2},QuantityQ];
	arg = MapAt[qTimes, arg, 1];
	Switch[Length[arg],
		1, First[arg],
		2, {qprod, oprod} = MapAt[Times@@#&, arg, 2];
		   quantityTimesCombineWithNumeric[qprod, oprod],
		_, (System`Private`SystemAssert[False]; Apply[Times, arg, {0, 1}])
	]
]]

ParseUnevaluatedqqTimes[e_]:=Block[{qqTimes},Replace[If[AtomQ[e],qqTimes[e],Flatten[e, Infinity, qqTimes]], HoldPattern[qqTimes][a__] :> Times[a]]]

quantityTimesCombineWithNumeric[q_?QuantityQ, t_Times] := With[{vals = List@@t},
	Module[{n = Position[vals,_?NumericQ, {1}, Infinity, Heads->False]},
	If[n === {},
		ParseUnevaluatedqqTimes[qqTimes[q, Sequence@@t]],
		ParseUnevaluatedqqTimes[qqTimes[qqTimes[q, Sequence@@Extract[vals, n]],Sequence@@Delete[vals,n]]]
	]
]]
quantityTimesCombineWithNumeric[q_?QuantityQ, expr:Except[_Times]] := ParseUnevaluatedqqTimes[qqTimes[q,expr]]
quantityTimesCombineWithNumeric[other_, args___] := Times[other, args]

quantityTimesNumericQ[expr_] := Or[NumericQ[expr], MatchQ[expr, Interval[{_?NumericQ, _?NumericQ}..]]]

qqTimes[(q1_Quantity)?QuantityQ,(q2_Quantity)?QuantityQ]/;SameQ[UnitDimensions[q1],{},UnitDimensions[q2]]:=With[
	{n=QuantityExpand/@{q1,q2}},Times@@n]
qqTimes[(x_Quantity)?QuantityQ,y:(_Quantity?QuantityQ..)]/;justInertUnitQ[x]:=Block[{$AutomaticUnitTimes=False},
	With[{mag=Times@@QuantityMagnitude[{x,y}],unit=Times@@QuantityUnit[{x,y}]},With[{res=If[unit=!=1,Quantity[mag,unit],mag]},res(*/;res=!=t*)]]]	
qqTimes[(x:Quantity[None,unit_])?QuantityQ,y__?quantityTimesNumericQ]:=Block[{$AutomaticUnitTimes=False},
	Quantity[Times[y],unit]]
qqTimes[(x:Quantity[val_,unit_])?QuantityQ,y__?quantityTimesNumericQ]:=Block[{$AutomaticUnitTimes=False},
	Quantity[timesValues[val, y], unit]
]

timesValues[MixedMagnitude[val_], y__] := With[{n=Times[y]}, MixedMagnitude[Times[val, n]]]
timesValues[val_, y__] := Times[y, val]

(* 	To avoid introducing finite precision values during times, avoid non-dimensionalization if certain PCs are present.
	see bug(368864) for more details. 
	We currently have 4 possible methods, and default to checking if the unit only contains PCs.
 *)
QuantityUnits`$TimesNondimensionalizationMethod = "AllConstants";
nonRealNondimensionalizationQ[unit_] := Switch[QuantityUnits`$TimesNondimensionalizationMethod,
	"AllConstants", UnsameQ[Complement[Cases[unit, _String, -1],$physicalConstantList], {}],
	"AnyConstants", FreeQ[unit, Alternatives@@$physicalConstantList],
	"Value",MatchQ[convertToValue[unit, "PureUnities", 1], Except[_Real]],
	"All", True,
	_, False
]

$physicalConstantList = {"AccelerationAssociatedWithCosmologicalExpansionRate",
"AlphaParticleMass", "AngstromStar", "AstronomicalUnit",
"AtomicMassConstantEnergyEquivalent", "AtomicMassUnit",
"AtomicSpecificHeatConstant", "AtomicUnitOfElectricChargeDensity",
"AtomicUnitOfElectricConductance", "AtomicUnitOfElectricCurrent",
"AtomicUnitOfElectricDipoleMoment",
"AtomicUnitOfElectricFieldStrength",
"AtomicUnitOfElectricFieldStrengthGradient",
"AtomicUnitOfElectricFirstHyperpolarizability",
"AtomicUnitOfElectricPermittivity",
"AtomicUnitOfElectricPolarizability",
"AtomicUnitOfElectricPotential",
"AtomicUnitOfElectricQuadrupoleMoment",
"AtomicUnitOfElectricSecondHyperpolarizability", "AtomicUnitOfForce",
"AtomicUnitOfFrequency", "AtomicUnitOfMagneticDipoleMoment",
"AtomicUnitOfMagneticFlux", "AtomicUnitOfMagneticFluxDensity",
"AtomicUnitOfMagneticInduction", "AtomicUnitOfMagnetizability",
"AtomicUnitOfMomentum", "AtomicUnitOfPressure",
"AtomicUnitOfTemperature", "AtomicUnitOfTime",
"AtomicUnitOfVelocity", "AtomStructuralConstant", "AvogadroConstant",
"AvogadroNumber", "BlackHoleConjecturedFinalMass",
"BlackHoleCriticalTemperature", "BohrMagneton",
"BohrQuadrupoleMagneton", "BohrRadius", "BoltzmannConstant",
"CeresSunMassRatio", "Cesium133HyperfineSplittingFrequency",
"ClassicalElectronRadius", "ClassicalProtonRadius",
"ConductanceQuantum", "CosmologicalConstant", "CosmologicalRadius",
"CoulombConstant", "CurieConstantSquareRootMultiplier",
"DeuteronMagneticMoment", "DeuteronMass", "EarthMass",
"EarthMoonMassRatio", "EddingtonConstant4",
"EinsteinConstantSpeedOfLightSquared",
"EinsteinConstantSpeedOfLightToTheFourth",
"ElectricBohrDipoleMoment", "ElectricBohrQuadrupoleMoment",
"ElectricConstant", "ElectromagneticCouplingConstant",
"ElectromagneticInteractionStrengthAtZBosonMass",
"ElectronAbsoluteMass", "ElectronChargeMassRatio",
"ElectronComptonFrequency", "ElectronComptonWavelength",
"ElectronGFactor", "ElectronMagneticMoment",
"ElectronMagneticMomentAnomaly", "ElectronMass",
"ElectronProtonElectricGravitationalForceRatio",
"ElectronProtonMassRatio", "ElectronRelativeAtomicMass",
"ElectronSchroedingerConstant", "ElectronWaveMass",
"ElementaryCharge", "FaradayConstant", "FermiCouplingConstant",
"FineStructureConstant", "FirstFowlerNordheimConstant",
"FirstRadiationConstant",
"FirstRadiationConstantForSpectralRadiance",
"FixedNucleusAtomSchroedingerConstant", "GalacticUnit",
"GaussianGravitationalConstant", "GeocentricGravitationalConstant",
"GravitationalConstant",
"GravitationalConstantPerSpeedOfLightSquared",
"GravitationalCouplingConstantElectronElectron",
"GravitationalCouplingConstantElectronProton",
"GravitationalCouplingConstantProtonProton",
"GravitationalPermeability", "HartreeEnergy", "HBarCProduct",
"HiggsVacuumExpectationValue", "HydrogenAtomSchroedingerConstant",
"IdealGasMolarVolume", "InvariantSlowness",
"InverseConductanceQuantum", "InverseFineStructureConstant",
"JosephsonConstant", "KovtunSonStarinetBound",
"LatticeSpacing220OfSilicon", "LorentzUnit", "LorenzNumber",
"LoschmidtConstant", "MagneticConstant", "MagneticCoulombConstant",
"MagneticCouplingConstant", "MagneticFineStructureConstant",
"MagneticFluxQuantum", "MeanSolarIrradiance",
"MillimagneticFluxQuantum", "MolarGasConstant", "MolarMassConstant",
"MolarPlanckConstant", "MONDConstant", "MONDLength",
"MonochromaticRadiation540THzLuminousEfficacy", "MoonEarthMassRatio",
"MuonComptonWavelength", "MuonGFactor", "MuonMagneticMoment",
"MuonMass", "NaturalUnitOfEnergy", "NaturalUnitOfLength",
"NaturalUnitOfMomentum", "NaturalUnitOfTime",
"NeutronComptonWavelength", "NeutronMagneticMoment", "NeutronMass",
"NonlinearQEDEffectsOnsetElectromagneticEnergyDensity",
"NuclearMagneton", "PallasSunMassRatio", "Parsecs", "PlanckArea",
"PlanckConstant", "PlanckMass", "PlanckTemperature", "PlanckTime",
"PlanckVolume", "ProtonComptonWavelength", "ProtonElectronMassRatio",
"ProtonMagneticMoment", "ProtonMass",
"ProtonProtonElectricGravitationalForceRatio",
"ProtonRMSChargeRadius", "QCDScale", "QuadraticHiggsCoefficient",
"QuantizedHallConductance",
"QuantumChannelThermalConductanceConstant",
"QuarticHiggsCoefficient", "RadiationConstant",
"ReducedElectromagneticPlanckConstant", "ReducedFermiConstant",
"ReducedPlanckConstant", "ReducedPlanckMass",
"RelativisticReducedPlanckMass", "RichardsonDushmanConstant",
"RydbergConstant", "RydbergConstantHydrogen", "RydbergEnergy",
"RydbergFrequency", "RydbergWavelength", "SackurTetrodeConstant",
"SchottkyNordheimBarrierConstant", "SchottkyNordheimConstant",
"SecondFowlerNordheimConstant", "SecondRadiationConstant",
"SignedElementaryCharge", "SolarConstant", "SolarMassParameter",
"SolarSchwarzschildRadius", "SommerfeldNordheimConstant",
"SpacetimeAtomAvogadroNumber", "SpeedOfLight", "SpeedOfSound",
"StandardAccelerationOfGravity", "StefanBoltzmannConstant",
"StrongCouplingConstant", "StrongInteractionStrengthAtZBosonMass",
"SunEarthMassRatio", "SunErisMassRatio", "SunJupiterMassRatio",
"SunMarsMassRatio", "SunMercuryMassRatio", "SunNeptuneMassRatio",
"SunPlutoMassRatio", "SunSaturnMassRatio", "SunUranusMassRatio",
"SunVenusMassRatio", "TauComptonWavelength", "TauMass",
"ThompsonLampardCalculableCapacitorCapacitance",
"ThomsonCrossSection", "UniverseAge", "UniverseVacuumEnergyDensity",
"VacuumImpedance", "VestaSunMassRatio", "VonKlitzingConstant",
"WaterIcePoint", "WaterTriplePointTemperature", "WBosonMass",
"WeakHyperchargeCouplingConstant", "WeakIsospinCouplingConstant",
"WeakMixingAngleConstant", "WeinbergAngle",
"WienFrequencyDisplacementLawConstant",
"WienWavelengthDisplacementLawConstant",
"YukawaBottomQuarkCouplingConstant",
"YukawaCharmQuarkCouplingConstant",
"YukawaDownQuarkCouplingConstant", "YukawaElectronCouplingConstant",
"YukawaMuonCouplingConstant", "YukawaStrangeQuarkCouplingConstant",
"YukawaTauonCouplingConstant", "YukawaTopQuarkCouplingConstant",
"YukawaUpQuarkCouplingConstant", "ZBosonMass"};(*Select[EntityList["PhysicalConstant"], StringQ[QuantityUnit[#["Quantity"]]] &]*)

PossibleMultiplicands[unit_] := If[
	And[unitTableDimensionsLookup[unit] === 1, nonRealNondimensionalizationQ[unit]], 
	{1},
	getPossibleMultiplicands[unit]
]

getPossibleMultiplicands[unit_] := Module[{udims, rules},
  udims = Cases[unit, u_String :> {unitTableDimensionsLookup[u], u}, Infinity];
  udims = Split[Sort[udims], First@#1 === First@#2 &][[All, All, 2]];
  rules = Join @@@ Tuples[Replace[udims, u_ :> (Thread[u -> #] & /@ u), {1}]];
  rules = Prepend[#, f_IndependentUnit -> f] & /@ (Join @@@ Tuples[Replace[udims, u_ :> (Thread[u -> #] & /@ u), {1}]]);
  ((unit /. # &) /@ rules) /. Times[1., val_] :> val (*see bug(291868)*)]

timesOrderFunction[{unit_}, _, _] := {1} (*don't bother sorting if only 1 unit is possible*)
timesOrderFunction[units_, inunit_, value_]:= With[{res = Catch[
	Ordering[
	Abs[
		Log[
			Map[convertToValue[inunit,#,value]&, units] - 1.3
		]
	]
],$tag]}, If[UnsameQ[res,$Failed],res,{1}]]
 
qTimes[{expr_}] := expr
qTimes[l_List] := iqTimes[l]

iqTimes[q_List] := Catch[
  Module[{units, quantity, possible, ord, unmixed = q /. mixed_?MixedUnitQ:> unmixMixedUnitQuantity[mixed]},
  	With[{vlist = unmixed[[All,1]], ulist=unmixed[[All,2]]},

   units = Times@@ulist;
   quantity = Quantity[Times@@vlist, units];
   
   If[SameQ[units, 1],
   	Times@@vlist,
   	possible = Catch[PossibleMultiplicands[units], $tag];
   	If[possible === $Failed, possible = {units}];
   	ord = First[ timesOrderFunction[possible, units, Times@@vlist]];
   	If[possible === {},
   		quantity,
   		UnitConvert[quantity, possible[[ord]]]
   	]
   ]
  ]], $tag]

qTimes[___] := $Failed

(*UpValues for Power operations*)
System`Quantity/:Power[(x_Quantity)?QuantityQ,y_]/;$AutomaticUnitTimes===True := Block[{$AutomaticUnitTimes = False},
	With[{res = iQuantityPower[x,y]}, res /; res =!= $Failed]
]
	

iQuantityPower[_, 0] := 1
iQuantityPower[_, 0.] := 1.	
iQuantityPower[Quantity[None, unit_], n_] := iQuantityPower[Quantity[1, unit], n]
iQuantityPower[HoldPattern[Quantity[val_, unit_String]], y_?NumericQ] /; y=!=1 := Quantity[val^y, unit^y]
iQuantityPower[x:Quantity[val_,unit_IndependentUnit],y_?NumericQ] /; y=!=1 /; justInertUnitQ[x] := Quantity[val^y,unit^y]
iQuantityPower[x:Quantity[_, _MixedUnit], y_?NumericQ] /; y=!=1 := iQuantityPower[unmixMixedUnitQuantity[x],y]
iQuantityPower[x_,y_?NumericQ] /; y=!=1 :=If[
	specialPowerCaseQ[x],
	nonDimPower[x,y],
	QuantityPowerFunction[x,y]
]
iQuantityPower[___] := $Failed

specialPowerCaseQ[x:Quantity[_, unit_]] := specialPowerCaseQ[x] = UnitDimensions[x] === {}
specialPowerCaseQ[___] := False

simplePower[Quantity[val_, unit_], n_] := 
 With[{u = PowerExpand[unit^n]},
  If[TrueQ[u == 1],
  	val^n,
  	Quantity[val^n, u]
  	]
 ]

SetAttributes[trivialPowerCaseQ,HoldAll];
trivialPowerCaseQ[__]=False

normalizeQuantity[quantity:Quantity[_, unit_]]/; trivialPowerCaseQ[unit] := quantity 

normalizeQuantity[quantity:Quantity[val_, unit_]] := Block[
	{ord, possible=Catch[PossibleMultiplicands[unit],$tag]},
   	Switch[ possible,
   		{1}|{unit}|$Failed, Set[trivialPowerCaseQ[unit],True];quantity(*something else?*),
   		_,
   		ord = First[timesOrderFunction[possible, unit, val]];
   		UnitConvert[quantity, possible[[ord]]]
   	]
]
normalizeQuantity[other_] := other (*shouldn't hit this case?*)

QuantityPowerFunction[q_Quantity, n_] := normalizeQuantity[simplePower[q, n]]


nonDimPower[_, 0] := 1
nonDimPower[_, 0.] := 1.
nonDimPower[x_Quantity,y_] := With[{r=Map[Power[#,y]&,x,{1}]},
	Which[QuantityQ[r], r,
		NumericQ[r], r,
		r[[2]] === 1, MapAt[Power[#,y]&,x,{1}],
		True, Power[x,y]
	]]

quantityToTrigValue[q_] := QuantityMagnitude[c2sibu[q]]

evaluateTrigFunction[fun_] := ReplaceRepeated[fun, q_Quantity?QuantityQ :> QuantityMagnitude[c2sibu[q]]]

QuantityIntervalUnion[q1:Quantity[Interval[i1:{_,_}],u1_],q2:Quantity[Interval[i2:{_,_}],u2_]] := If[CompatibleUnitQ[q1,q2],
	With[{interval=IntervalUnion[First[Internal`QuantityToValue[q1]], First[Internal`QuantityToValue[q2, TargetUnits -> u1]]]},
		Quantity[interval,u1]],
	$Failed,
	$Failed
]
QuantityIntervalUnion[___]:=$Failed

QuantityIntervalIntersection[q1:Quantity[Interval[i1:{_,_}],u1_],q2:Quantity[Interval[i2:{_,_}],u2_]] := If[
	CompatibleUnitQ[q1,q2],
	With[{values = {QuantityMagnitude[q1, u1], QuantityMagnitude[q2, u1]}},
		With[{interval = IntervalIntersection@@values},
			If[MatchQ[interval, _Interval],
				Quantity[interval, u1],
				$Failed
			]]
		],
	$Failed,
	$Failed
]
QuantityIntervalIntersection[___]:=$Failed

Internal`QuantityIntervalHandler[int:{(_Quantity)?QuantityQ,(_Quantity)?QuantityQ}..]/;CompatibleUnitQ[int] := With[{
	res=UnitConvert[{int},First[First[{int}]]]},
	With[{m=QuantityMagnitude[res],u=QuantityUnit[First[First[{int}]]]},
		Quantity[Interval@@m,u]
	]/;res=!=$Failed
]
Internal`QuantityIntervalHandler[___] := False	
		
(*special function for Rounding; uses gqc for evaluation*)
iQuantityRound[(q_Quantity)?MixedUnitQ,args___]:=Quiet[Check[
	With[{ou=QuantityUnit[q],umrq=unmixMixedUnitQuantity[q]},UnitConvert[iQuantityRound[umrq,args],ou]],$Failed]]

iQuantityRound[q_Quantity, q2_Quantity] := Module[{tu = QuantityUnit[q2]}, 
  With[{qu = UnitConvert[q, tu],qa = QuantityMagnitude[q2]}, 
 With[{res=gqc[Quantity[Round[#1, qa], #2] &, qu]},If[res=!=$Failed,First[res],res]]]]
iQuantityRound[q_Quantity, n_?NumericQ] := With[{res=gqc[Quantity[Round[#1, n], #2] &, q]},If[res=!=$Failed,First[res],res]]
iQuantityRound[q_Quantity] := With[{res=gqc[Quantity[Round[#1], #2] &, q]},If[res=!=$Failed,First[res],res]]

iQuantityRound[___]:=$Failed
 
(*gcq for fractional part*)
iQuantityFractionalPart[x_?QuantityQ]/;MixedUnitQ[x]:=Quiet[Check[With[{umrq=unmixMixedUnitQuantity[x]},iQuantityFractionalPart[umrq]],$Failed]]
iQuantityFractionalPart[x_?QuantityQ]/;Not[MixedUnitQ[x]]:= First[gqc[Quantity[FractionalPart[#1], #2]&, x]]
iQuantityFractionalPart[___]:=$Failed

iQuantityIntegerPart[x_?QuantityQ] := First[gqc[Quantity[IntegerPart[#1], #2]&, x]]
iQuantityIntegerPart[___] := $Failed
(*utility functions for rescaling*)
iSelectLargestUnit[list_List] /; And @@ (KnownUnitQ /@ list) := QuantityUnit[
  Max[Sequence @@ (With[{u = #}, Quantity[1, u]] & /@ list)]
]

iSelectSmallesttUnit[list_List] /; And @@ (KnownUnitQ /@ list) := QuantityUnit[
  Min[Sequence @@ (With[{u = #}, Quantity[1, u]] & /@ list)]
]

(*rescaling function; dimensionless with 2 arguments, otherwise dimensions based on 3rd argument*)
iQuantityRescale[(orig_Quantity)?MixedUnitQ,args___]:=Quiet[Check[With[{nargs=unmixMixedUnitQuantity[orig]},iQuantityRescale[nargs,args]],$Failed]]
iQuantityRescale[{orig_Quantity..}]/;MemberQ[orig,_?MixedUnitQ]:=Quiet[Check[With[{nargs=unmixMixedUnitQuantity/@orig},iQuantityRescale[nargs]],$Failed]]
iQuantityRescale[orig_Quantity,args1:{_Quantity..}]/;MemberQ[args1,_?MixedUnitQ]:=Quiet[Check[With[{nargs=unmixMixedUnitQuantity/@args1},iQuantityRescale[orig,nargs]],$Failed]]
iQuantityRescale[orig_Quantity,args1:{_Quantity..},args2:{_Quantity..}]/;MemberQ[args1,_?MixedUnitQ]||MemberQ[args2,_?MixedUnitQ]:=Quiet[Check[With[{nargs1=unmixMixedUnitQuantity/@args1,nargs2=unmixMixedUnitQuantity/@args2},iQuantityRescale[orig,nargs1,nargs2]],$Failed]]
iQuantityRescale[orig_Quantity, {lq_Quantity, uq_Quantity}] := With[{unit = QuantityUnit[orig]}, 
  With[{oq = UnitConvert[orig, unit], 
    rqs = QuantityMagnitude[UnitConvert[#, unit] & /@ {lq, uq}]}, 
   First@First@gqc[Quantity[Rescale[#1, rqs], #2] &, 
    oq]]]

iQuantityRescale[orig_Quantity, {lq_Quantity, uq_Quantity}, {tlq_Quantity, tuq_Quantity}] := 
 With[{unit = iSelectSmallesttUnit[QuantityUnit[{tlq, tuq}]]}, 
  With[{oq =UnitConvert[orig, unit], 
    rqs = QuantityMagnitude[UnitConvert[#, unit] & /@ {lq, uq}], 
    oqs = QuantityMagnitude[UnitConvert[#, unit] & /@ {tlq, tuq}]}, 
  With[{res=gqc[Quantity[Rescale[#1, rqs, oqs], #2] &, oq]},If[MatchQ[res,_List],First[res],MapAt[First,res,1]]]]]    
  
iQuantityRescale[l:{(__Quantity)}]/;Not[MemberQ[l,_?MixedUnitQ]]:=With[{unit=iSelectLargestUnit[QuantityUnit[l]]},
	With[{qs = StandardizeQuantities[l,unit]},
	With[{res=First@gqc[Quantity[Rescale[#1], #2]&,qs]},
		If[Internal`QuantityVectorQ[res],
			res[[All,1]],
			First@res]
	]]]
iQuantityRescale[___]:=$Failed

CompareQuantities[q1_, q2_] /; CompatibleUnitQ[q1, q2] := With[{v1 = QuantityMagnitude[UnitConvert[q1]], v2 = QuantityMagnitude[UnitConvert[q2]]},
  Which[
   v1 == v2, Equal,
   v1 > v2, Greater,
   v1 < v2, Less,
   v1 != v2, Unequal,
   True, $Failed
   ]
  ]

(*uses Ordering to locate Min/Max *)
QMinMax[f : (Min | Max | MinMax), (q1_Quantity)?MixedUnitQ, args__Quantity]:=Quiet[Check[With[{umrq=unmixMixedUnitQuantity[q1]},QMinMax[f,umrq,args]],$Failed]]
QMinMax[f : (Min | Max | MinMax), (q1_Quantity), args__Quantity]/;MemberQ[{args},_?MixedUnitQ]:=Quiet[Check[With[{umrqs=unmixMixedUnitQuantity/@{args}},QMinMax[f,q1,Sequence@@umrqs]],$Failed]]
QMinMax[Min, q:Quantity[Interval[{l_,_},___], __]] /; QuantityQ[q] := With[{u=QuantityUnit[q]},
	If[Head[u] =!= MixedUnit, Quantity[l, u], $Failed]
]
QMinMax[Max, q:Quantity[Interval[___,{_,t_}], __]] /; QuantityQ[q] := With[{u=QuantityUnit[q]},
	If[Head[u] =!= MixedUnit, Quantity[t, u], $Failed]
]
QMinMax[MinMax, q:Quantity[i_Interval, __]] /; QuantityQ[q] := With[{u=QuantityUnit[q]},
	If[Head[u] =!= MixedUnit, Quantity[MinMax[i], u], $Failed]
]
QMinMax[f : (Min | Max | MinMax), args___Quantity] := With[
	{rule = Switch[f, Min, Interval[{l_, _}, ___] :> l, Max, Interval[___, {_, u_}] :> u, MinMax, i_Interval :> MinMax[i]]},
	iQMinMax[f, Replace[{args}, rule, {2}]]
]
QMinMax[f : (Min | Max | MinMax), q_Quantity, e1___, q1_Quantity, e2___] := With[{args = {e1,q1,e2}},
With[{quantities = Cases[args,_Quantity]},
	f[QMinMax[f, q, Sequence@@quantities],f[Complement[args,quantities]]]
]]
QMinMax[___]:=$Failed

iQMinMax[f_, {q1_, q2___}] := Module[{unit = QuantityUnit[q1], values},
	values = Replace[QuantityMagnitude[UnitConvert[{q1, q2}, unit]], {None -> 1}, {1}];
	If[Element[DeleteCases[values,_DirectedInfinity], Reals],
		Extract[{q1, q2}, Ordering[values, If[f === Min, 1, -1], NumericalOrder]],
		$Failed,
		$Failed
	]
]

(* TODO: move to UpValues.m *)
System`Quantity/:HoldPattern[Min][Shortest[e1___],(x_Quantity)?QuantityQ,Longest[e2___]] := With[{res=QMinMax[Min,x,e1,e2]},res /; res =!= $Failed]
System`Quantity/:HoldPattern[Max][Shortest[e1___],(x_Quantity)?QuantityQ,Longest[e2___]] := With[{res=QMinMax[Max,x,e1,e2]},res /; res =!= $Failed]
System`Quantity/:HoldPattern[MinMax][Shortest[e1___],(x_Quantity)?QuantityQ,Longest[e2___]] := With[{res=QMinMax[MinMax,x,e1,e2]},res /; res =!= $Failed]


iQuantityClip[args__] := If[CompatibleUnitQ[Flatten[{args}]],
  iquantityClip[args],
  iFindInCompatibleUnits@@Flatten[{args}]; $Failed]
  
iquantityClip[q:Quantity[x_, unit_]] := iquantityClip[q, {Quantity[-1, unit], Quantity[1, unit]}]
iquantityClip[q_Quantity, {min_, max_}] := iquantityClip[q, {min, max}, {min, max}]
iquantityClip[x:Quantity[_, unit_], {min_Quantity, max_Quantity}, {vmin_Quantity, vmax_Quantity}] := Module[{
	r = QuantityMagnitude@UnitConvert[{x, {min, max}, {vmin, vmax}}, x]},
  Quantity[Clip @@ r, unit]
  ]
(*generalized function for use in matrix functions; not currently in use, but references in quantities.mc*)
iQuantityMatrixFunction[mat_?Internal`QuantityMatrixQ,fun_,dim_Integer,unitfun_]/;With[{ma = Flatten[mat]}, Internal`SameUnitDimension[ma]] := Catch[
 Module[{m, u, var, res}, If[UniformQuantityMatrixQ[mat],
 		{m=QuantityMagnitude[mat],u=QuantityUnit[mat[[1,1]]]},
 			m = SeparateUnits[mat];
 			If[MatchQ[m, {_, _, _}], {m, u, var} = SeparateUnits[mat], Throw[Defer[fun[mat]], "iQMF"]]
 	]; 
  res = Check[fun[m],$Failed]; 
  If[res=!=$Failed,With[{unit = unitfun[u]}, MapAt[Quantity[#, unit] &, res, dim]],Defer[fun[mat]]]], "iQMF"]
 iQuantityMatrixFunction[mat_?Internal`QuantityMatrixQ,fun_,None]/;With[{ma = Flatten[mat]}, Internal`SameUnitDimension[ma]] := Catch[
 Module[{m, u, var}, If[UniformQuantityMatrixQ[mat],
 		{m=QuantityMagnitude[mat],u=QuantityUnit[mat[[1,1]]]},
 			m = SeparateUnits[mat];
 			If[MatchQ[m, {_, _, _}], {m, u, var} = SeparateUnits[mat], Throw[Defer[fun[mat]], "iQMF"]]
 	]; 
  Check[fun[m],$Failed]], "iQMF"]
iQuantityMatrixFunction[mat_?Internal`QuantityMatrixQ,fun_,All,unitfunction_]/;With[{ma = Flatten[mat]}, Internal`SameUnitDimension[ma]] := Catch[
 Module[{m, u, var, res}, 
 	If[UniformQuantityMatrixQ[mat],
 		{m=QuantityMagnitude[mat],u=QuantityUnit[mat[[1,1]]]},
 			m = SeparateUnits[mat];
 			If[MatchQ[m, {_, _, _}], {m, u, var} = SeparateUnits[mat], Throw[Defer[fun[mat]], "iQMF"]]
 	]; 
  res = Check[fun[m],$Failed]; 
  If[res=!=$Failed,With[{unit = unitfunction[u]}, Quantity[res, unit]],Defer[fun[mat]]]], "iQMF"]
iQuantityMatrixFunction[mat_?Internal`QuantityMatrixQ,arg_,fun_,All,unitfunction_]/;With[{ma = Flatten[mat]}, Internal`SameUnitDimension[ma]] := Catch[
 Module[{m, u, var, res}, If[UniformQuantityMatrixQ[mat],
 		{m=QuantityMagnitude[mat],u=QuantityUnit[mat[[1,1]]]},
 			m = SeparateUnits[mat];
 			If[MatchQ[m, {_, _, _}], {m, u, var} = SeparateUnits[mat], Throw[Defer[fun[mat]], "iQMF"]]
 	]; 
  res = Check[fun[m,arg],$Failed]; 
  If[res=!=$Failed,With[{unit = unitfunction[u]}, Quantity[res, unit]],Defer[fun[mat]]]], "iQMF"]
iQuantityMatrixFunction[mat_?MatrixQ,fun_,___]:=(Message[Quantity::compatu];Defer[fun[mat]])
iQuantityMatrixFunction[___]:=(Message[Quantity::compatu];$Failed)

(*quotient and mod code, using gqc*)
SetAttributes[iQuantityMod, Listable]
iQuantityMod[(q1:Quantity[_, unit1_])?QuantityQ,(q2:Quantity[_, unit2_])?QuantityQ]/;CompatibleUnitQ[unit1, unit2]:= 
With[{tq=If[MixedUnitQ[q2], UnitConvert[q2], q2]},
With[{q = UnitConvert[q1, tq]}, First[gqc[Quantity[Mod[#1, QuantityMagnitude[tq]], #2] &, q]]]]
iQuantityMod[(q1:Quantity[_, unit1_])?QuantityQ,(q2:Quantity[_, unit2_])?QuantityQ,(d:Quantity[_, unit3_])?QuantityQ]/;CompatibleUnitQ[unit1, unit2,unit3]:= 
With[{tq=If[MixedUnitQ[q2], UnitConvert[q2], q2]},
With[{q = UnitConvert[q1, tq],dm=QuantityMagnitude[UnitConvert[d, tq]]}, First[gqc[Quantity[Mod[#1, QuantityMagnitude[tq],dm], #2] &, q]]]]
iQuantityMod[(q:Quantity[_, unit_])?QuantityQ, n_?NumericQ] /; UnitDimensions[unit] === {} := With[{v= UnitConvert[q]},
	Mod[v,n]
]
iQuantityMod[(q:Quantity[_, unit_])?QuantityQ, n_?NumericQ, d_] /; CompatibleUnitQ[unit,n,d] := With[{v= UnitConvert[q], di = UnitConvert[d]},
	Mod[v, n, di]
]
iQuantityMod[___]=$Failed;  

SetAttributes[iQuantityPowerMod,Listable]
iQuantityPowerMod[(q1:Quantity[_, unit1_])?QuantityQ,b_?NumericQ,(q2:Quantity[_, unit2_])?QuantityQ]/;CompatibleUnitQ[unit1, unit2] := 
With[{tq=If[MixedUnitQ[q2], UnitConvert[q2], q2]},
With[{q = UnitConvert[q1, tq]}, First[gqc[Quantity[PowerMod[#1,b,QuantityMagnitude[tq]], #2] &, q]]]]
iQuantityPowerMod[___]=$Failed;
  
SetAttributes[iQuantityQuotient, Listable]
iQuantityQuotient[(q1:Quantity[_,unit1_])?QuantityQ,(q2:Quantity[_,unit2_])?QuantityQ]/;CompatibleUnitQ[unit1, unit2]:= 
 With[{tq = If[MixedUnitQ[q2], UnitConvert[q2], q2],quant = If[MixedUnitQ[q1],UnitConvert[q1],q1]},
 	With[{q = UnitConvert[quant, tq]},First@First[gqc[Quantity[Quotient[#1, QuantityMagnitude[tq]], #2] &, q]]]]
iQuantityQuotient[(q1:Quantity[_,unit1_])?QuantityQ,(q2:Quantity[_,unit2_])?QuantityQ,(d:Quantity[_,unit3_])?QuantityQ]/;CompatibleUnitQ[unit1, unit2,unit3] := 
 With[{tq = If[MixedUnitQ[q2], UnitConvert[q2], q2],quant = If[MixedUnitQ[q1],UnitConvert[q1],q1]},
 	With[{q = UnitConvert[quant, tq], dm = QuantityMagnitude[UnitConvert[d,tq]]},First@First[gqc[Quantity[Quotient[#1, QuantityMagnitude[tq],dm], #2] &, q]]]]
iQuantityQuotient[___]=$Failed;

SetAttributes[iQuantityQuotientRemainder, Listable]
iQuantityQuotientRemainder[(q1:Quantity[_, unit1_])?QuantityQ,(q2:Quantity[_, unit2_])?QuantityQ]/;CompatibleUnitQ[unit1, unit2] := 
With[{tq=If[MixedUnitQ[q2], UnitConvert[q2], q2]},
 With[{q = UnitConvert[q1, tq]},
   MapAt[First, First[gqc[Quantity[QuotientRemainder[#1, QuantityMagnitude[tq]], #2] &, q]], 1]]]
iQuantityQuotientRemainder[___]=$Failed;

SetAttributes[iQuantityDivisible, Listable];
iQuantityDivisible[(q1:Quantity[mag1_, unit1_])?QuantityQ,(q2:Quantity[mag2_, unit2_])?QuantityQ]/;CompatibleUnitQ[unit1, unit2] := 
With[{m = QuantityMagnitude[{q1, UnitConvert[q2, unit1]}]}, Divisible @@ m]
iQuantityDivisible[___]=$Failed;

iQuantityRationalize[(q:Quantity[_, unit1_])?QuantityQ,(q2:Quantity[_, unit2_])?QuantityQ]/;CompatibleUnitQ[unit1, unit2] := 
 With[{m = QuantityMagnitude[UnitConvert[q2, unit1]]}, Rationalize[q, m]]
iQuantityRationalize[___]=$Failed;
  
iQuantitySurd[Quantity[mag_, unit_], root_?IntegerQ] := With[{
	m = Surd[mag, root], 
	u = PowerExpand[Power[unit,1/root]](*what about held units?*)
},
	Quantity[m, u]
]
iQuantitySurd[___] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

quantityFloorCeilingFunction[fun_, q_Quantity, a_] /; CompatibleUnitQ[q, a] := Module[
{step, val = UnitConvert[q, a]},
	If[Or[QuantityQ[val],NumericQ[val]],
	val = QuantityMagnitude[val];
	step = QuantityMagnitude[a];
	If[NumericQ[step],
		With[{unit = QuantityUnit[a]},
			Quantity[fun[val, step], unit]
		],
		Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]],
	Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]
	]
]
quantityFloorCeilingFunction[___] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

iQuantityFloor[Quantity[mag_, unit_]] := Quantity[Floor[mag], unit]
iQuantityFloor[q_Quantity, a_] := quantityFloorCeilingFunction[Floor, q, a]
iQuantityFloor[___] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

iQuantityCeiling[Quantity[mag_, unit_]] := Quantity[Ceiling[mag], unit]
iQuantityCeiling[q_Quantity, a_] := quantityFloorCeilingFunction[Ceiling, q, a]
iQuantityCeiling[___] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

(*DownValues for Quantity to tweak behavior, and make HoldRest behavior more user-friendly*)
System`Quantity[mag_, HoldForm[args__]] := Quantity[mag, args]

(*_____________________________________*)

(*evaluation rules for Quantity & MixedRadixQuantity*)
System`MixedRadixQuantity[m_List,u_List]/;Length[m]==Length[u]/;ArrayDepth[m]==1:=With[{mag=MixedMagnitude[m],unit=MixedUnit[u]},With[{res=Quantity[mag,unit]},res/;Quiet[QuantityQ[res],{Quantity::unkunit}]]]
System`MixedRadixQuantity[]:=(Message[MixedRadixQuantity::argrx,MixedRadixQuantity,0,2];Null/;False)
System`MixedRadixQuantity[arg_]:=(Message[MixedRadixQuantity::argrx,MixedRadixQuantity,1,2];Null/;False)
System`MixedRadixQuantity[_,_,arg__]:=(Message[MixedRadixQuantity::argrx,MixedRadixQuantity,Length[{arg}]+2,2];Null/;False)

System`Quantity[HoldPattern[System`MixedRadix][m__], HoldPattern[System`MixedRadix][u__]] /; Length[{m}] === Length[{u}] := (
	Message[Quantity::mradix];
	Quantity[MixedMagnitude[{m}], MixedUnit[{u}]]
)
System`Quantity[q_Quantity,unit_] /; $AutomaticUnitTimes===True /; FreeQ[QuantityMagnitude[q],Quantity]:=Times[Quantity[1,unit],q]

System`DatedUnit[s_String] /; And[TrueQ[$DatedUnitIdentity], KnownUnitQ[s]] := s
(*System`DatedUnit[s_String,date_]/;Not[KnownUnitQ[s]]:= With[{res=Quantity[1,s]},(DatedUnit[QuantityUnit[res],date])/;Quiet[QuantityQ[res]]]*)

SetAttributes[Quantity,{HoldRest,NHoldRest}];
(*---------------------------------------*)

(*GenericQuantityComparison used to apply numerical functions*)
gqc[fn_,quan_Quantity]/;justInertUnitQ[quan]:=Quiet[Module[
	{unit,values},
	unit=QuantityUnit[quan];
	If[Not[MatchQ[unit,_QuantityUnit]],
		values=QuantityMagnitude[quan];
		If[Not[MatchQ[values,_QuantityMagnitude]],
			{fn[values,unit]},
			False],
	False]
],{Function::slotn}]

gqc[fn_,list__Quantity]/;MemberQ[{list},_?justInertUnitQ]:=Quiet[Module[
	{units,unit,values,res},
	units=QuantityUnit[{list}];
	If[FreeQ[units,_QuantityUnit],
	If[CompatibleUnitQ[units],
		unit=First[units];
		If[ListQ[unit],unit=First[unit]];
		values=QuantityMagnitude[UnitConvert[{list},unit]];
		If[FreeQ[values,_QuantityMagnitude],
			res=fn[values],
			False],
		iFindInCompatibleUnits[list];False],
	False]
],{Function::slotn}]

(*GenericQuantityComparison via Alpha framework*)
gqc[fn_,list__] := Module[{units, unit, values, res},
	units = QuantityUnit[{list}];
	Which[
		!FreeQ[units, $Failed],
		$Failed,
		
		unit = First[units]; If[ListQ[unit], unit = First[unit]];
		(*so a single unit, not mixed radix.This is unfortunate for QuantityPlus, but necessary for QuantityRatio.At any rate, it was previously for mixed radix.*)
		values = QuantityMagnitude[UnitConvert[{list}, unit]];
		!FreeQ[values, $Failed],
		$Failed,
		
		res = fn[values, unit];
		res = res /. n_?NumberQ /; Precision[n] < 1 :> SetPrecision[n, 1];
		!FreeQ[res, $Failed],
		$Failed, 
		
		True, res
	]
]

Unprotect[Quantity];

(*dispatch table for going from oUnitDimensions rules to their SIBase units*)
Unprotect[Internal`DimensionToBaseUnit, Internal`$UnitDimensions, Internal`$DimensionRules];

If[!AssociationQ[Internal`$DimensionRules], 
Internal`$DimensionRules = Association[
	"AmountUnit" -> "Moles",
	"AngleUnit" -> "Radians",
	"ApparentMagnitudesUnit" -> "ApparentMagnitudes",
	"ArrivalUnit" -> "Arrivals",
	"BackUnit" -> "Backs",
	"BacteriumUnit" -> "Bacteria",
	"BagelUnit" -> "Bagels",
	"BagUnit" -> "Bags",
	"BarUnit" -> "BarUnits",
	"BatchUnit" -> "Batches",
	"BeanUnit" -> "Beans",
	"BiocapacityUnit" -> "GlobalHectares",
	"BiologicUnit" -> "InternationalUnits",
	"BirdUnit" -> "Birds",
	"BiscuitUnit" -> "Biscuits",
	"BiteUnit" -> "Bites",
	"BottleUnit" -> "Bottles",
	"BowlUnit" -> "Bowls",
	"BoxUnit" -> "BoxUnits",
	"BreastUnit" -> "Breasts",
	"BulbUnit" -> "Bulbs",
	"BunchUnit" -> "Bunches",
	"BundleUnit" -> "Bundles",
	"BunUnit" -> "Buns",
	"BurritoUnit" -> "Burritos",
	"BusinessUnit" -> "Businesses",
	"CakeUnit" -> "Cakes",
	"CanUnit" -> "Cans",
	"CaponUnit" -> "Capons",
	"CartonUnit" -> "Cartons",
	"CaseUnit" -> "CaseUnits",
	"ChopUnit" -> "Chops",
	"CloveUnit" -> "Cloves",
	"ContainerUnit" -> "Containers",
	"CookieUnit" -> "Cookies",
	"CornDogUnit" -> "CornDogs",
	"CrackerUnit" -> "Crackers",
	"CupUnit" -> "CupUnits",
	"CutletUnit" -> "Cutlets",
	"CutUnit" -> "Cuts",
	"DataPacketUnit" -> "DataPackets",
	"DepartureUnit" -> "Departures",
	"DrinkUnit" -> "Drinks",
	"DropperfulUnit" -> "Dropperfuls",
	"DrumstickUnit" -> "Drumsticks",
	"EarUnit" -> "Ears",
	"EelUnit" -> "Eels",
	"EggRollUnit" -> "EggRolls",
	"EggUnit" -> "Eggs",
	"ElectricCurrentUnit" -> "Amperes",
	"EnchiladaUnit" -> "Enchiladas",
	"EventUnit" -> "Events",
	"ExampleUnit" -> "Examples",
	"FiletUnit" -> "Filets",
	"FishUnit" -> "Fishes",
	"GeneticLinkageUnit" -> "Morgans",
	"GlassUnit" -> "Glasses", 
	"HeadUnit" -> "HeadUnits",
	"HerringUnit" -> "Herrings",
	"InformationUnit" -> "Bits",
	"ItemUnit" -> "Items",
	"JarUnit" -> "Jars",
	"JugUnit" -> "Jugs",
	"LargeItemUnit" -> "LargeItems",
	"LeafUnit" -> "Leaves",
	"LengthUnit" -> "Meters",
	"LinkUnit" -> "LinkUnits", 
	"LiverUnit" -> "Livers",
	"LoafUnit" -> "Loaves",
	"LuminousIntensityUnit" -> "Candelas",
	"MassUnit" -> "Kilograms",
	"MediumItemUnit" -> "MediumItems",
	"MoneyUnit" -> "USDollars",
	"MooneyViscosityUnit" -> "MooneyUnits",
	"MugUnit" -> "Mugs",
	"NuggetUnit" -> "Nuggets",
	"ObservedWindIntensityUnit" -> "BeaufortScaleNumbers",
	"OrderUnit" -> "Orders",
	"PackageUnit" -> "Packages",
	"PacketUnit" -> "Packets",
	"PackUnit" -> "Packs",
	"PadUnit" -> "Pads",
(*	"ParticleUnit" -> First[{}],*)
	"PastryUnit" -> "Pastries",
	"PattyUnit" -> "Patties",
	"PersonUnit" -> "People",
	"PieceUnit" -> "Pieces",
	"PizzaUnit" -> "Pizzas",
	"PortionUnit" -> "Portions",
	"PouchUnit" -> "Pouches",
	"PretzelUnit" -> "Pretzels",
	"PrismCorrectionUnit" -> "PrismDiopters",
(*	"ProtonUnit" -> First[{}], *)
	"PruneUnit" -> "Prunes",
	"RackUnit" -> "Racks", 
	"RibUnit" -> "Ribs", 
	"RoastUnit" -> "Roasts", 
	"RollUnit" -> "Rolls", 
	"RoundUnit" -> "Rounds", 
	"RuskUnit" -> "Rusks", 
	"SampleUnit" -> "Samples", 
	"SandwichUnit" -> "Sandwiches", 
	"ScoopUnit" -> "Scoops", 
	"ServingUnit" -> "Servings", 
	"SetUnit" -> "Sets", 
	"ShankUnit" -> "Shanks", 
	"SharesUnit" -> "Shares", 
	"SipUnit" -> "Sips", 
	"SliceUnit" -> "Slices", 
	"SmallItemUnit" -> "SmallItems", 
	"SolidAngleUnit" -> "Steradians", 
	"SprigUnit" -> "Sprigs", 
	"StalkUnit" -> "Stalks", 
	"SteakUnit" -> "Steaks", 
	"StickUnit" -> "Sticks", 
	"StripUnit" -> "Strips", 
	"SubUnit" -> "Subs", 
	"TacoUnit" -> "Tacos", 
	"TamaleUnit" -> "Tamales",
	"TemperatureDifferenceUnit" -> "KelvinsDifference", 
	"TemperatureUnit" -> "Kelvins",
	"ThighUnit" -> "Thighs",
	"TimeUnit" -> "Seconds", 
	"TortillaUnit" -> "Tortillas", 
	"VirusUnit" -> "Viruses", 
	"WaferUnit" -> "Wafers", 
	"WaffleUnit" -> "Waffles", 
	"WedgeUnit" -> "Wedges", 
	"WingUnit" -> "Wings",
	"WrapUnit" -> "Wraps",
	"PhotonUnit" -> "Photons",
	"ProtonUnit" -> "Protons",
	"ElectronUnit" -> "Electrons",
	"ParticleUnit" -> "Particles"
]
]

Internal`$UnitDimensions = Keys[Internal`$DimensionRules];

Internal`DimensionToBaseUnit["DimensionlessUnit"]="PureUnities";
Internal`DimensionToBaseUnit[dim_String] := dim/.Internal`$DimensionRules/."Grams"->"Kilograms"
Internal`DimensionToBaseUnit[IndependentUnitDimension[dim_]] := IndependentUnit[dim]

(*____Internal Utilities_____*)
(*	used by various data analysis functions to pull out values from quantity datasets and track unit
*	Returns data in the form {values,unit} and only operates on compatible unit sets
*	also handled numerical cases
*)
Quantity/:HoldPattern[System`Private`InternalNormal][q_Quantity?QuantityQ, Quantity] := If[
	MemberQ[{{},{{"AngleUnit", 1}},{{"SolidAngleUnit", 1}},{{"PersonUnit", 1}}},UnitDimensions[q]],
	Replace[QuantityMagnitude[UnitConvert[q]], QuantityMagnitude[arg_]:>arg],
	q
]

Quantity/:Rotate[something_, q_Quantity?QuantityQ, args___] /; UnitDimensions[q] === {{"AngleUnit",1}} := Module[
	{res = QuantityMagnitude[q, "Radians"]},
	If[NumericQ[res],
		res = Rotate[something, res, args],
		res = $Failed
	];
	res /; res =!= $Failed
]

getUnitSystem[]:=Module[{res="Result" /. ReleaseHold[Internal`MWACompute["MWAUnitSystem", Internal`MWASymbols`MWAUnitSystem[]]]},
	If[MemberQ[{"Metric","Imperial"},res],
		res,
		"Metric"
	]
]


SetAttributes[EvaluateWithQuantityArithmetic, HoldAll]
EvaluateWithQuantityArithmetic[ e_ ] :=
    Block[{$AutomaticUnitPlus=True, $AutomaticUnitTimes=True},
        e
    ]

QuantityUnits`RemoveZeroQuantity[expr_] := expr //. Quantity[val:(0 | 0.), _]?QuantityQ :> val
(******************************************************************************************************************)

(*internal utility used for testing compatibility*)
SetAttributes[Internal`SameUnitDimension,{HoldFirst,Orderless}];
Internal`SameUnitDimension[q:((_Quantity)?QuantityQ..)]:=With[{units=QuantityUnit[{q}]},Internal`SameUnitDimension[units]]
Internal`SameUnitDimension[n_?NumericQ.., q:((_Quantity)?QuantityQ..)] := Union[UnitDimensions /@ {q}] === {}
Internal`SameUnitDimension[l_List]:=With[{units=QuantityUnit[l]},Internal`SameUnitDimension[units]]
Internal`SameUnitDimension[unit_?KnownUnitQ]:=True
Internal`SameUnitDimension[unit_, units__] :=TrueQ[KnownUnitQ[unit] && CompatibleUnitQ[unit, units]]
Internal`SameUnitDimension[{units__}] :=Internal`SameUnitDimension[units]
Internal`SameUnitDimension[___] = False

(*_______End of Internal Utilities*)
With[{s=$ProtectedSymbols},SetAttributes[s,{ReadProtected}]];

(*keep various flags & symbols from triggering Dynamic updating*)
Internal`SetValueNoTrack[{
	$iFixFlag,
	$AutomaticUnitParsing, $AutomaticUnitPlus, $AutomaticUnitTimes,
	Quantity, $UnitMBF,
	$UnitDisplayCacheSize, $UnitDisplayCache,
	$UserExchangeRateTable, $KnownUnitQCache, $KnownUnitQCacheSize,
	$CompatibleUnitQCache, $CompatibleUnitQCacheSize, $DatedUnitIdentity,
	$DCCRecurssionFlag, $RecFlag, $ShowZero,
	DatedUnit (*fix for 273616 *)}, 
True];

(*protect symbols, turn back on messages*)
Protect@@$ProtectedSymbols;

(*after everythings been initialized set up some pre-computed rules for the SI-base form of common SI-derived units for Suggestions Bar*)
iUSFCR = With[{q = UnitConvert[Quantity[#]]},Rule[UnitDimensions[q], #]]&/@
    {"Newtons", "Joules", "Farads", "Pascals", "Coulombs",
  "Volts", "Watts", "Ohms", "Liters", "Webers", "Hertz", "Siemens", "Teslas", "Henries"};
iUSFCRP = iUSFCR[[All,1]];

(*QuantityToValue message off by default*)
Off[Internal`QuantityToValue::invld];
On[Quantity::unkunit];
On[Quantity::argrx];
On[IndependentUnit::invd];
On[Quantity::nonopt];

End[]

EndPackage[]
