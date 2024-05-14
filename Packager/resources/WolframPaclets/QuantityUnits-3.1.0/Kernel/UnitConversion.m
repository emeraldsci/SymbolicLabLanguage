(*method for getting quantity in it's SI base unit form*)
c2sibu[n_?NumericQ] := n
c2sibu[q_Quantity?MixedUnitQ] := c2sibu[unmixMixedUnitQuantity[q]]
c2sibu[q:Quantity[mag_, unit_String]] := With[{target = getSIBaseUnit[unit]}, UnitConvert[q, target]]
c2sibu[q:Quantity[mag_, unit_]] := Block[{IUnitEnum, IUnitIt = 0}, Module[{qu1, qu2, num, den},
	qu1 = PowerExpand[(q /. {
		0 -> zero,
		0. -> zeroDot,
		Quantity -> Times,
		IndependentUnit[s_] :> makeInertIUnit[s],
		Interval -> InertInterval,
		d_DatedUnit :> extractDatedUnitValue[d],
		(s_String /; KnownUnitQ[s]) :> unitTableFValueLookup[s]
	}) /. ("Grams" -> (1/1000 "Kilograms"))
	];
	qu1 = qu1 /. InertIndependentUnit[s_] :> unmakeInertIUnit[s];
	num = Numerator[qu1]; den = Denominator[qu1]; 
	qu1 = If[Head[num] === Times, Cases[num, x_?KnownUnitQ], With[{n = num}, If[KnownUnitQ[n], {num}, 1]]]; 
	num = num /. x_?KnownUnitQ :> 1;
	qu2 = If[Head[den] === Times, Cases[den, x_?KnownUnitQ], With[{d = den}, If[KnownUnitQ[d], {den}, 1]]]; 
	den = den /. x_?KnownUnitQ :> 1;
	qu2 = With[{u = PowerExpand@Divide[Times@@qu1, Times@@qu2]}, Quantity[PowerExpand[num/den /. {InertInterval -> Interval, zero -> 0, zeroDot -> 0.}], u]];
	releaseExchangeRate[PowerExpand[qu2]]]
]

c2sibu[__] = $Failed

getSIBaseUnit[unit_] := With[{ud = UnitDimensions[unit]}, unitDimensionsToSIBaseUnit[ud]]

unitDimensionsToSIBaseUnit[{}] := "DimensionlessUnit"
unitDimensionsToSIBaseUnit[dim_List] := Times@@Replace[dim, {udim_String, n_} :> Power[dimensionBaseUnit[udim], n], {1}]
unitDimensionsToSIBaseUnit[___] := False

dimensionBaseUnit[udim_String] := Replace[Internal`$DimensionRules[udim], "Grams" -> "Kilograms"]

makeInertIUnit[s_] := With[{num = IUnitIt++}, Set[IUnitEnum[num], s]; InertIndependentUnit[num]]
unmakeInertIUnit[num_] := IndependentUnit[IUnitEnum[num]]
extractDatedUnitValue[DatedUnit[unit_, date_]] := getDatedUnitValue[unit, date] * "USDollars"

Unprotect[CurrencyConvert];
(*SetAttributes[CurrencyConvert,Listable];*)
CurrencyConvert[in_, target_, dates_] := With[{res = Catch[iHistoricalCurrencyConvert[in, target, dates], "iUnitConvert" | $tag]}, res /; res =!= False]
CurrencyConvert[_, _, _, args__]:=(Message[CurrencyConvert::argrx,CurrencyConvert, Length[{args}] + 3, 2]; False)
CurrencyConvert[arg1_, arg2_]:=With[{res = Catch[iUnitConvert[arg1, arg2], "iUnitConvert" | $tag]},res /; res =!= False]
CurrencyConvert[]:=(Message[CurrencyConvert::argrx,CurrencyConvert,0,3];Null/;False)

(*	conversion of historical currencies has two parts:	*
 * 	1: conversion between two currencies
 *	2: change in currency value over time
 *	Part 1 is handled via the call to MWACurrencyConvert in Internal`MWACompute
 *	Part 2 is handled via InflationAdjust.
 *	For operations which involve both(ie: convert $1.00 USD in 1990 to JPY in 2010) we use the following scheme:
 *	Step 1: adjust inflation to the target date(ie: adjust $1.00 USD in 1990 to it's value in 2010)
 *	Step 2: convert the resulting adjusted value between currenties(ie: $x USD in 2010 to JPY)
 *	(note: a user could always overwrite this by first converting the currencies for the origin date, and then adjusting for inflation)
 *	caveat: for artihmetic operations(ie: $1.00 USD in 1990 + 1 JPY in 2010) all conversions must follow our central
 *	arithmetic dogma and convert to(current) USD, and thus each operation involves it's own conversion.
 *)

(* historicalCurrencyConvert is used to intercept calls in convertToValue that would unnecissarily do extra conversions to contemporary USD *)
historicalCurrencyConvert[unit1_, unit2_, value_] := Which[
	sameCurrencyQ[unit1, unit2], QuantityMagnitude[InflationAdjust[Quantity[value, unit1], unit2]],
	sameCurrencyDateQ[unit1, unit2], QuantityMagnitude[iHistoricalCurrencyConvert[Quantity[value, unit1], unit2, extractDatedUnitCurrency[unit2]]],
	True, QuantityMagnitude[
		iHistoricalCurrencyConvert[
			InflationAdjust[Quantity[value, unit1], getCurrencyDate[unit2]] /. DatedUnit[unit_, _] :> unit,
			unit2,
			extractDatedUnitCurrency[unit2]
		]]
]

sameCurrencyQ[DatedUnit[unit_, _], unit_] := UnitDimensions[unit] === {{"MoneyUnit", 1}}
sameCurrencyQ[unit_, DatedUnit[unit_, _]] := UnitDimensions[unit] === {{"MoneyUnit", 1}}
sameCurrencyQ[DatedUnit[unit_, _], DatedUnit[unit_, _]] := UnitDimensions[unit] === {{"MoneyUnit", 1}}
sameCurrencyQ[__] := False

sameCurrencyDateQ[u__] := SameQ@@(getCurrencyDate[#]& /@ {u})

getCurrencyDate[DatedUnit[_, date_]] := DateObject[date, "Day", CalendarType -> "Gregorian", TimeZone -> $TimeZone]
getCurrencyDate[Except[_DatedUnit]] := Today

extractDatedUnitCurrency[unit_] := First[getCurrencyDate[unit]]

iHistoricalCurrencyConvert[q_, target_, dates_] := Module[{input, output, dateRange},
	input = normalizeHistoricalCurrencyConvertFirstArg[q];
	output = normalizeHistoricalCurrencyConvertSecondArg[target];
	dateRange = normalizeHistoricalCurrencyConvertDateRange[dates];
	generateHistoricalCurrencyConvertResults[input, output, dateRange]
]

normalizeHistoricalCurrencyConvertFirstArg[q_?QuantityQ] := If[UnitDimensions[q] === {{"MoneyUnit", 1}},
	q /. DatedUnit[u_, _] :> u,
	Message[CurrencyConvert::ncur, q];
	Throw[False, $tag]
]
normalizeHistoricalCurrencyConvertFirstArg[DatedUnit[u_String, _]] := normalizeHistoricalCurrencyConvertFirstArg[u]
normalizeHistoricalCurrencyConvertFirstArg[u_String] := With[{q = Quiet[Quantity[1, u]]},
	If[
		QuantityQ[q] && UnitDimensions[q] === {{"MoneyUnit", 1}},
		Quantity[1, u],
		Message[CurrencyConvert::ncur, u];
		Throw[False, $tag]
	]
]
normalizeHistoricalCurrencyConvertFirstArg[arg_] := (Message[CurrencyConvert::ncur, arg]; Throw[False, $tag])

normalizeHistoricalCurrencyConvertSecondArg[arg_] := QuantityUnit[normalizeHistoricalCurrencyConvertFirstArg[arg]]

generateHistoricalCurrencyConvertResults[Quantity[mag_, unit_], target_, dates_] := Module[{res, mval1, mval2, cc1, cc2},
	mval1 = unitTableFValueLookup[unit];
	mval2 = unitTableFValueLookup[target];
	cc1 = extractCurrencyCode[mval1];
	cc2 = extractCurrencyCode[mval2];
	mval1 = extractCurrencyNumericFactor[mval1] * mag;
	mval2 = extractCurrencyNumericFactor[mval2];
	res = Internal`MWACompute["CurrencyConversionMean", {cc1, cc2, dates}];
	res = extractMWAComputeResults[res];
	currencyConvertWrapperize[applyNumericFactor[applyNumericFactor[res, 1/mval2], mval1], target]
]

extractMWAComputeResults[expr_HoldComplete] := Module[{res = ReleaseHold[expr]},
	If[OptionQ[res],
		res = "Result" /. res
	];
	If[MatchQ[res, {{{_List, _?NumberQ}..}}],
		res,
		Message[CurrencyConvert::ncdat]; Throw[$Failed, $tag]
	]
]
applyNumericFactor[dat:{{{_List, _?NumberQ}..}}, factor_] := MapAt[Times[#,factor]&, dat, {All, All, 2}]

currencyConvertWrapperize[{{{_List, val_?NumberQ}}}, target_] := Quantity[val, target] (* return a single value for case of historical lookup on just one date *)
currencyConvertWrapperize[dat:{{{_List, _?NumberQ}..}}, target_] := TimeSeries[MapAt[Quantity[#, target]&, dat, {All, All, 2}]]

extractCurrencyCode[expr_] := With[{cc = Cases[expr, "ExchangeRateToUSD"[cc_String] :> cc, -1, 1]},
	If[Length[cc] === 1,
		First[cc],
		"USD"(*if there is no ExchangeRateToUSD then the currency is directly based on USD*)
	]
]

extractCurrencyNumericFactor[expr_] := ReplaceAll[expr, {"USDollars" -> 1, "ExchangeRateToUSD"[_String] -> 1}]

normalizeHistoricalCurrencyConvertDateRange[All] := {{1, 1, 1}, {3000, 1, 1}}
normalizeHistoricalCurrencyConvertDateRange[d_?Internal`PossibleDateQ] := {toHistoricalDateList[d], toHistoricalDateList[d]}
normalizeHistoricalCurrencyConvertDateRange[d:{_?Internal`PossibleDateQ, _?Internal`PossibleDateQ}] := toHistoricalDateList /@ d
normalizeHistoricalCurrencyConvertDateRange[d_] := (
	Message[CurrencyConvert::dspec, d];
	Throw[False, $tag]
)

toHistoricalDateList[arg_] := With[{d = Quiet[DateList[arg]]},
	If[MatchQ[d, {__Integer, _}],
		d,
		Message[CurrencyConvert::dspec, d];Throw[False, $tag]
	]
]

Unprotect[UnitConvert];
(*SetAttributes[UnitConvert,Listable];*)
UnitConvert[args__] := With[{res = Catch[doUnitConvert[handleNone[{args}]], "iUnitConvert" | $tag]}, res /; res =!= False]
UnitConvert[] := (Message[UnitConvert::argrx, UnitConvert, 0, 2]; Null /; False)

doUnitConvert[{args___}] := iUnitConvert[args]
doUnitConvert[args___] := iUnitConvert[args]

convertAssociation[input_String, target_]/; KnownUnitQ[input] := iUnitConvert[input, target] (*don't try and parse random strings in association*)
convertAssociation[input_?QuantityQ, target_] := iUnitConvert[input, target]
convertAssociation[input_List, target_] := Map[convertAssociation[#,target]&, input]
convertAssociation[input_Association, target_] := Map[convertAssociation[#,target]&, input] /; AssociationQ[input]
convertAssociation[input_TemporalData, target_] := convertTimeSeries[input, target]
convertAssociation[sa_?StructuredArray`StructuredArrayQ, newunit_] := StructuredArrayUnitConvert[sa, newunit]
convertAssociation[input_, _] := input(*all others pass through unevaluated*)

iUnitConvert[q_?QuantityQ, Dated[unit_, date_]?KnownUnitQ] := If[IntegerQ[date],
	iUnitConvert[q, DatedUnit[unit, {date}]],
	iUnitConvert[q, DatedUnit[unit, date]]
]
iUnitConvert[a_Association, target_:"SIBase"] := Map[convertAssociation[#, target]&, a] /; AssociationQ[a]
iUnitConvert[ts_TemporalData,target_:"SIBase"] := convertTimeSeries[ts,target]
iUnitConvert[sa_?StructuredArray`StructuredArrayQ, newunit_] := StructuredArrayUnitConvert[sa, newunit];
iUnitConvert[HoldPattern[x_Entity],___]:=x

iUnitConvert[_,_,args__] := (Message[UnitConvert::argrx, UnitConvert, Length[{args}] + 2, 2]; Throw[False, "iUnitConvert"])
iUnitConvert[] := (Message[UnitConvert::argrx, UnitConvert, 0]; Throw[False, "iUnitConvert"])
iUnitConvert[(exp_)?QuantityQ] := iUnitConvert[exp, "SIBase"]
iUnitConvert[(unit_)?KnownUnitQ] := iUnitConvert[unit, "SIBase"]
iUnitConvert[s_String] /; Not[KnownUnitQ[s]] := With[{q = Quantity[s]}, If[Quiet[QuantityQ[q]], iUnitConvert[q, "SIBase"], Throw[False, "iUnitConvert"]]]
iUnitConvert[n_?NumericQ] := n
iUnitConvert[exp_, "Base"] := iUnitConvert[exp, "SIBase"]
iUnitConvert[n_?NumericQ, "SIBase"]:=n
(*Outer-like Pseudolistability*)
iUnitConvert[q:{Quantity[_,unit_]..}, args_?KnownUnitQ] := With[{r = Catch[bulkUnitConvert[q, args], $tag]}, r /; r =!= False](*fallback is 'standard' evaluation*)
iUnitConvert[l_List, arg_List] /; Length[l] === Length[arg] := Which[
	ArrayDepth[l] > ArrayDepth[arg], Map[UnitConvert[#, arg]&, l],
	ArrayDepth[l] == ArrayDepth[arg], MapThread[UnitConvert, {l, arg}, ArrayDepth[l]],
	True, Message[UnitConvert::arrdpt]
]
	
iUnitConvert[l_List, arg___] := UnitConvert[#, arg]& /@ l
iUnitConvert[arg_, l_List] := UnitConvert[arg ,#]& /@ l
iUnitConvert[q_Quantity, unit_?KnownUnitQ] := With[{r=Catch[fastConvert[q, unit], $tag]}, r /; r =!= $Failed](*fallback is 'standard' evaluation*)
iUnitConvert[q_?QuantityQ, d_?DateObjectQ] := unitConvertForDate[q, d]
iUnitConvert[u_?KnownUnitQ, d_?DateObjectQ] := unitConvertForDate[Quantity[u], d]

$UnitSystems = {"SI", "SIBase", "Base", "Imperial", "Metric"};

iUnitConvert[n_?NumericQ, system_String] /; MemberQ[{"SI", "Imperial", "Metric"}, system] := n
iUnitConvert[s1_String, s2_String] /; Not[MemberQ[$UnitSystems, s2]] /; Or[Not[KnownUnitQ[s1]], Not[KnownUnitQ[s2]]] := With[
	{q1 = Quantity[s1], q2 = Quantity[s2]},
	If[Quiet[And[QuantityQ[q1], QuantityQ[q2]]], iUnitConvert[q1, q2], Throw[False, "iUnitConvert"]]]
iUnitConvert[s1_String, arg2_] /; Not[KnownUnitQ[s1]] := With[{q1 = Quantity[s1]}, If[Quiet[QuantityQ[q1]], iUnitConvert[q1, arg2], Throw[False, "iUnitConvert"]]]
iUnitConvert[arg1_, s2_String] /; And[Not[MemberQ[$UnitSystems, s2]], Not[KnownUnitQ[s2]]] := With[{q2 = Quantity[s2]}, 
	If[Quiet[QuantityQ[q2]], iUnitConvert[arg1, q2], Throw[False, "iUnitConvert"]]]
iUnitConvert[(u_)?KnownUnitQ, arg_] := With[{q = Quantity[1, u]}, 
  If[Quiet[Or[QuantityQ[q], NumericQ[q]]], iUnitConvert[q, arg], Throw[False, "iUnitConvert"]]]
iUnitConvert[HoldForm[u_], arg_] /; KnownUnitQ[u] := With[{q = Quantity[1, u]}, 
  If[Quiet[QuantityQ[q]], iUnitConvert[q, arg], Throw[False, "iUnitConvert"]]]
iUnitConvert[(q : Quantity[mag_, unit_])?QuantityQ, unit_] := q
	
uCF[oldunit_, newunit_] := With[{
	factor = QuantityMagnitude[Quantity[2, oldunit], newunit] - QuantityMagnitude[Quantity[1, oldunit], newunit], 
    constant = QuantityMagnitude[Quantity[0, oldunit], newunit]}, 
   Function[{value}, value*factor + constant]
]
iUnitConvert[(q_Quantity)?QuantityQ, HoldPattern[MixedRadix[args__]]] := iUnitConvert[q, MixedUnit[{args}]]
iUnitConvert[(quantity_Quantity)?QuantityQ, mr_MixedUnit] := MixedUnitConvert[quantity, mr]


iUnitConvert[(quantity_Quantity)?QuantityQ, "SIBase"] := Module[{q = quantity},
	If[MixedUnitQ[quantity], q = unmixMixedUnitQuantity[quantity]];
	c2sibu[q]
]

iUnitConvert[quantities:{_Quantity?QuantityQ..}, "SIBase"] := UnitConvert[#, "SIBase"]& /@ quantities

(*non SIBase systems don't include any official currencies, so these are return the input identity*)
iUnitConvert[(quantity_Quantity)?QuantityQ, unitsystem_String] /; And[hasCurrencyQ[quantity], MemberQ[{"SI", "Imperial", "Metric"}, unitsystem]] := quantity
iUnitConvert[(quantity_Quantity)?QuantityQ, unitsystem:("SI" | "Imperial" | "Metric")] := unitSystemConvert[quantity, unitsystem]

unitSystemConvert[quantity_, system_] := If[
	unitSystemMember[system, quantity],
	quantity,
	convertQuantityToUnitSystem[quantity, system]
]

Scan[
	Set[UnitSystemMappings[#], "Atomic"]&, {"Hartree", "Rydberg"}
];

Scan[
	Set[UnitSystemMappings[#], "Metric"]&, {"SI", "MKS", "CGS", "MKSA", "MKpS", "MKfS", "DKS", "AcceptedForUseWithSI", "RecognizedForUseWithSI", "All"}
];

Scan[
	Set[UnitSystemMappings[#], "Imperial"]&, 
		{
		"UKImperial", "UKImperialArea", "UKImperialCapacity",
		"UKImperialLiquid", "UKImperialDry", "UKImperialLength", 
		"UKImperialLiquid", "UKImperialLength", "UKImperialLinear", 
		"UKImperialNautical", "UKImperialSurveyors", "UKImperialVolume", 
		"UKImperialVolumeAndCapacity", "UKImperialArea", 
		"UKImperialCircular", "UKImperialWeight", 
		"UKImperialAvoirdupoisWeight", "UKImperialApothecariesWeight", 
		"UKImperialApothecariesWeight", "UKImperialTroyWeight", 
		"USCustomary", "USCustomaryArea", "USCustomaryLength", 
		"USCustomaryWeight", "USCustomaryAvoirdupoisWeight", 
		"USApothecariesCapacity", "USApothecariesWeight", "USArea", 
		"USCircular", "USDry", "USFluid", "USLinear", "USLiquid", 
		"USNautical", "USSurveyors", "USVolume", "USVolumeAndCapacity", 
		"USTroyWeight", "FootPoundSecond", "InchPoundSecond", "All"}
];

UnitSystemMappings[other_] := other

getUnitSystemList[u_String] := QuantityUnits`$UnitTable[u]["UnitSystem"]

getPrimaryDestX[u_String] := addSIBaseUnit[
	ReplaceAll[
		QuantityUnits`$UnitTable[u]["UnitPrimaryDestinationsX"],
		{"SIPrefixedList"[args__] :> Sequence[args], "MixedRadixUnit"[___] :> Nothing}
	],
	u]

addSIBaseUnit[l_List, unit_] := Append[l, QuantityUnit[UnitConvert[unit]]]
addSIBaseUnit[_, unit_] := {QuantityUnit[UnitConvert[unit]]}

unitSystemMember[system_, Quantity[_, unit_]] := unitSystemMember[system, unit]
unitSystemMember[system_, unit_String] := With[{usys = getUnitSystemList[unit]},
	MemberQ[UnitSystemMappings/@usys, UnitSystemMappings[system]]
]
unitSystemMember[system_, other_] := With[{subunits = Cases[other, s_String/;KnownUnitQ[s], -1]},
	If[subunits =!= {},
		AllTrue[subunits, unitSystemMember[system, #]&],
		False
	]
]
unitSystemMember[__] = False

convertQuantityToUnitSystem[q:Quantity[_, unit_String], system_] := Module[{targets = Select[getPrimaryDestX[unit], unitSystemMember[system, #]&]},
	selectBestFitQuantity[q, targets]
]
convertQuantityToUnitSystem[q:Quantity[_, unit_], system_] := fallbackUnitSystemConvert[q, system]

selectBestFitQuantity[q_Quantity, {}] := q
selectBestFitQuantity[q_Quantity, l_List] := Module[{conversion = UnitConvert[q,#]& /@ l, sel},
	sel = Cases[conversion, _?normallyBoundedQuantityQ];
	If[Length[sel] > 0,
		First[sel],
		First @ MinimalBy[conversion, Abs[QuantityMagnitude[#]]&]
	]
]

normallyBoundedQuantityQ[Quantity[n_?NumericQ, _]] := With[{v = Abs[n]},
	0.1 <= v <= 1000
]
normallyBoundedQuantityQ[Quantity[Interval[{n_?NumericQ, _}, ___], _]] := With[{v = Abs[n]},
	0.1 <= v <= 1000
]
normallyBoundedQuantityQ[__] := False

fallbackUnitSystemConvert[quantity_, system_] := With[{fq = c2sibu[quantity]},
	If[QuantityQ[fq],
		Switch[system,
			"SI", rescaleByValue[fq, "SI"],
			"Imperial", rescaleByValue[replaceWithImperialUnits[fq], "Imperial"],
			"Metric", rescaleByValue[replaceWithMetricUnits[fq], "Metric"]
		],
		fq
	]
]

rescaleByValue[quantity_, system_] := quantity (*TODO: improve this*)

replaceWithImperialUnits[quantity_] := With[{unit = (QuantityUnit[quantity] /. $ImperialReplacementUnits) /. $SecondaryImperialReplacements},
	UnitConvert[quantity, unit]
]

replaceWithMetricUnits[quantity_] := With[{unit = (QuantityUnit[quantity] /. $MetricReplacementUnits) /. $SecondaryMetricReplacements},
	UnitConvert[quantity, unit]
]

$MetricReplacementUnits = {"Kelvins" -> "DegreesCelsius", "KelvinsDifference" -> "DegreesCelsiusDifference"};
$ImperialReplacementUnits = {"Kelvins" -> "DegreesCelsius", "KelvinsDifference" -> "DegreesCelsiusDifference", "Meters" -> "Feet", "Kilograms" -> "Pounds"};

$SecondaryMetricReplacements = {"Meters"^3 -> "Liters"};
$SecondaryImperialReplacements = {"Feet"^3 -> "Gallons"};

iUnitConvert[(quantity_Quantity)?QuantityQ, targetunit_?KnownUnitQ] /; MixedUnitQ[quantity] := iUnitConvert[unmixMixedUnitQuantity[quantity],targetunit]

iUnitConvert[(quantity_Quantity)?QuantityQ, (targetunit_Quantity)?QuantityQ] := UnitConvert[quantity, QuantityUnit[targetunit]]
	
iUnitConvert[quantities:{(_Quantity)?QuantityQ..}, (targetunit_Quantity)?QuantityQ] := (UnitConvert[#, targetunit]& /@ quantities)
iUnitConvert[quantities:{(_Quantity)?QuantityQ..}, targetunit_?KnownUnitQ] := (UnitConvert[#, targetunit]& /@ quantities)

iUnitConvert[list:{(_Quantity)..}, targetunit_Quantity] := Map[
	If[Head[#] === Quantity, UnitConvert[#, targetunit], #, Message[UnitConvert::failed]; $Failed]&, 
	list]
iUnitConvert[list:{(_Quantity)?QuantityQ..}, targetunit_?KnownUnitQ] := Map[
	If[Head[#] === Quantity, UnitConvert[#, targetunit], #, Message[UnitConvert::failed]; $Failed]&,
	list]

iUnitConvert[n_?NumericQ, t_] /; MemberQ[{"DimensionlessUnit", "PureUnities"}, t] := n
iUnitConvert[n_?NumericQ, _?NumericQ] := n
iUnitConvert[n_?NumericQ, targ_?KnownUnitQ] := If[UnitDimensions[targ] === {},
	With[{value = iUnitConvert[targ, "SIBase"]}, Quantity[n / value, targ]], 
	Message[Quantity::compat, "DimensionlessUnit", targ]; Throw[$Failed, "iUnitConvert"]
	]
iUnitConvert[n_?NumericQ, targ_?QuantityQ] := If[UnitDimensions[targ] === {},
	With[{value = iUnitConvert[targ, "SIBase"], unit = QuantityUnit[targ]}, Quantity[n / value, unit]],
	Message[Quantity::compat, "DimensionlessUnit", QuantityUnit[targ]]; Throw[$Failed, "iUnitConvert"]
	]
iUnitConvert[(q_Quantity)?QuantityQ, n_?NumericQ] /; UnitDimensions[q] === {} := QuantityExpand[q]
iUnitConvert[(q_Quantity)?QuantityQ, n_?NumericQ] := (Message[Quantity::compat, "DimensionlessUnit", QuantityUnit[q]]; Throw[$Failed, "iUnitConvert"])
iUnitConvert[(q_Quantity)?QuantityQ, d_	] /; Not[KnownUnitQ[d]] := With[{res = Quantity[1, d]},
	If[QuantityQ[res],
		iUnitConvert[q, res],
		Throw[False, "iUnitConvert"]
	]
]
iUnitConvert[expr : Except[_Quantity | _List]] := iUnitConvert[expr, "SIBase"]

(*$AllowSloppyUnitConvertsion controls whether UnitConvert will permit sub-unit conversion when the input and target are incompatible*)
QuantityUnits`$AllowSloppyUnitConvertsion = False;

iUnitConvert[q:Quantity[_, unit_], target_] /; Not[CompatibleUnitQ[unit, target]] := If[
	QuantityUnits`$AllowSloppyUnitConvertsion,
	Module[{iud = UnitDimensions[unit], ud = UnitDimensions[target], tu},
		If[
			And[
				MatchQ[iud, {__List}],
				MatchQ[ud, {__List}],
				SubsetQ[iud /. n_Integer :> Abs[n], ud /. n_Integer :> Abs[n]],
				tu = getTargetUnitFromInputAndTargetUnit[q, target];
				CompatibleUnitQ[unit, tu]
			],
			iUnitConvert[q, tu],
			
			Message[Quantity::compat, unit, target]; 
			$Failed
		]
	],
	Message[Quantity::compat, unit, target]; $Failed
]
iUnitConvert[___] = False;

StructuredArrayUnitConvert[sa_, newunit_] := Which[
	QuantityArray`QuantityArrayQ[sa],
		QuantityArray`QuantityArrayUnitConvert[sa, newunit],
	True,
		UnitConvert[Normal[sa, StructuredArray], newunit]
];

unitConvertForDate[q:Quantity[_,unit_], date_DateObject] := Catch[With[{currency = getCurrencyFromUnit[unit]},
	UnitConvert[q, DatedUnit[currency, date]]
], $tag]

SetAttributes[getCurrencyFromUnit, HoldAll];
getCurrencyFromUnit[u_String] := If[UnitDimensions[u]==={{"MoneyUnit",1}}, u, Throw[False, $tag]]
getCurrencyFromUnit[HoldPattern[_MixedRadix]] := Throw[False, $tag]
getCurrencyFromUnit[DatedUnit[u_,_]] := If[UnitDimensions[u]==={{"MoneyUnit",1}}, u, Throw[False, $tag]]
getCurrencyFromUnit[u_?KnownUnitQ] := Module[{units=Cases[HoldComplete[u],_String,-1]},
	units=Select[units,UnitDimensions[#]==={{"MoneyUnit",1}}&];
	If[Length[units]===1, First[units], Throw[False,$tag]]
]
getCurrencyFromUnit[___] := Throw[False, $tag]

(*optimized version of cu that handles most common simple cases of conversion*)
fastConvert[q:Quantity[_, unit_],unit_] := q
fastConvert[q:Quantity[value_, unit_], targetUnit_] /; FreeQ[{unit, targetUnit}, MixedUnit] := If[
	fasttrackableUnitsQ[unit,targetUnit],
	unitConvert[q, targetUnit],
	$Failed
]
fastConvert[___] := $Failed

(*TODO: remove once InflationAdjust paclet is updated*)
InflationAdjustUnitConvert[q_?QuantityQ, unit_?KnownUnitQ] := Catch[If[
	CompatibleUnitQ[q, unit], 
	UnitConvert[q, unit],
	UnitConvert[q, getTargetUnitFromInputAndTargetUnit[q, unit]
]
], $tag]
InflationAdjustUnitConvert[args___] := UnitConvert[args]

dimensionsWithUnits[unit_] := Module[{rules = oUnitDimensions[unit, "ListUnits" -> True], du},
	If[FreeQ[unit, DatedUnit],
		rules,
		du = Cases[{unit}, _DatedUnit, -1];
		If[Length[du] === 1,
			Replace[rules, Verbatim[Rule]["MoneyUnit", {n_, _}] :> Rule["MoneyUnit", {n, du}], {1}],
			Throw[$Failed, $tag]
		]
	]
]

getTargetUnitFromInputAndTargetUnit[Quantity[_, unit_], target_] := Module[{iud = dimensionsWithUnits[unit], ud = dimensionsWithUnits[target]},
	createUnitReplacement[iud, ud]
]

createUnitReplacement[iud_, ud_] := Module[{rules},
	rules = With[{dim = First[#], unit = Last[Last[Last[#]]]},
		HoldPattern[Rule[dim, {n_, _}]] :> Rule[dim, {n, {unit}}]] & /@ ud;
	unitDimensionRulesToUnit[Replace[iud, rules, {1}]]
	
]

unitDimensionRulesToUnit[list_] := Times @@ Map[
	With[{udata = Last[#]},
		Power[Last[Last[udata]], First[udata]]
	] &,
	list
]

fasttrackableUnitsQ[___, HoldPattern[_MixedUnit|_MixedRadix], ___] := False
fasttrackableUnitsQ[unit_, targetUnit_]:= CompatibleUnitQ[unit, targetUnit]
fasttrackableUnitsQ[___] := False

unitTableFValueLookup[u_String] := QuantityUnits`$UnitTable[u]["FundamentalUnitValue"]
unitTableFValueLookup[_?NumericQ] := 1
unitTableFValueLookup[Times[u_, n_]] := Times[unitTableFValueLookup[u], unitTableFValueLookup[n]]
unitTableFValueLookup[Power[u_, n_]] := Power[unitTableFValueLookup[u], n]
unitTableFValueLookup[HoldForm[u_]] := unitTableFValueLookup[u]

unitTableFZValueLookup[u_String] := QuantityUnits`$UnitTable[u]["FundamentalZeroValue"]
unitTableFZValueLookup[_?NumericQ] := 1
unitTableFZValueLookup[Times[u_, n_]] := Times[unitTableFZValueLookup[u], unitTableFZValueLookup[n]]
unitTableFZValueLookup[Power[u_, n_]] := Power[unitTableFZValueLookup[u], n]
unitTableFZValueLookup[HoldForm[u_]] := unitTableFZValueLookup[u]

$baseUnitReplacements := $baseUnitReplacements = Thread[
	Rule[Append[Values[Internal`$DimensionRules], "Grams"(*because Alpha tables are weird...*)], 1]
];

removeBaseUnits[expr_] := ReplaceAll[expr, $baseUnitReplacements]

(* CUR(R)0|1 are memoized for fast lookup, but done on-demand to avoid excess load time *)
Scan[
	With[{unit = #}, 
		CUF0[unit] := CUF0[unit] = With[{fuv = removeBaseUnits@unitTableFValueLookup[unit], fzv = removeBaseUnits@unitTableFZValueLookup[unit]},
			If[fzv == 0,
				Times[fuv, #] &,
				Times[fuv, Plus[#, fzv]] &
			]
		];
		CUF1[unit] := CUF1[unit] = With[{fuv = removeBaseUnits@unitTableFValueLookup[unit], fzv = removeBaseUnits@unitTableFZValueLookup[unit]},
			If[fzv == 0,
				(#/fuv) &,
				(#/fuv - fzv) &
			]
		]
	] &,
	QuantityUnits`$UnitList
]

Scan[
	(
		CUF0R[#] := CUF0R[#] = (removeBaseUnits@unitTableFValueLookup[#]);
		CUF1R[#] := CUF1R[#] = (1/removeBaseUnits@unitTableFValueLookup[#]);
	) &,
	QuantityUnits`$UnitList
]

Scan[(* deal with the fact that traditionally 'TemperatureUnit' gets handled as 'TemperatureDifferenceUnit' in compound units *)
	With[{temp = StringReplace[#, "Difference" -> ""]}, compoundUnitReplacement[temp] = #] &,
	{
		"DegreesCelsiusDifference",
		"DegreesFahrenheitDifference",
		"DegreesRankineDifference",
		"DegreesReaumurDifference",
		"DegreesRoemerDifference",
		"DekakelvinsDifference",
		"KelvinsDifference",
		"MegakelvinsDifference",
		"MicrokelvinsDifference",
		"MillikelvinsDifference"
	}
 ]
compoundUnitReplacement[other_] := other

CUF0R[_?NumericQ] := 1
CUF0R[HoldForm[u_]] := CUF0R[u]
CUF0R[IndependentUnit[_]] := 1
CUF0R[DatedUnit[unit_, date_]] := getDatedUnitValue[unit, date]
CUF0R[Times[unit1_, unit2_]] := Times[CUF0R[compoundUnitReplacement@unit1], CUF0R[compoundUnitReplacement@unit2]]
CUF0R[Power[unit_, n_]] := Power[CUF0R[compoundUnitReplacement@unit], n]

CUF1R[_?NumericQ] := 1
CUF1R[HoldForm[u_]] := CUF1R[u]
CUF1R[IndependentUnit[_]] := 1
CUF1R[DatedUnit[unit_, date_]] := 1 / getDatedUnitValue[unit, date]
CUF1R[Times[unit1_, unit2_]] := Times[CUF1R[compoundUnitReplacement@unit1], CUF1R[compoundUnitReplacement@unit2]]
CUF1R[Power[unit_, n_]] := Power[CUF1R[compoundUnitReplacement@unit], n]

getDatedUnitValue[unit_, date_] := With[{value = Quiet[InflationAdjust[Quantity[1, DatedUnit[unit, date]], "USDollars"]]},
	If[QuantityQ[value],
		QuantityMagnitude[value],
		Message[UnitConvert::nodat];Throw[$Failed, $tag]
	]
]

getConversionRatio[arg_, value_] := (arg /. f_Function :> f[1]) value

convertToValue[arg1__, HoldForm[unit_], arg2___] := convertToValue[arg1, unit, arg2]
convertToValue[unit_String, targetUnit_String, value_] := CUF1[targetUnit][CUF0[unit][value]]
convertToValue[unit_String, targetUnit_, value_] := CUF1R[targetUnit]*CUF0[unit][value]
convertToValue[arg1___, unit_DatedUnit, arg2___] := historicalCurrencyConvert[arg1, unit, arg2]
convertToValue[unit_, targetUnit_String, value_] := CUF1[targetUnit][CUF0R[unit]*value]
convertToValue[unit_, targetUnit_, value_] := CUF1R[targetUnit]*CUF0R[unit]*value

unitConvert[q_, _?NumericQ] := unitConvert[q, "PureUnities"]
unitConvert[Quantity[val_, unit_], targetUnit_] := Quantity[releaseExchangeRate[convertToValue[unit, targetUnit, val]], targetUnit]

releaseExchangeRate[expr_] := ReplaceAll[expr, "ExchangeRateToUSD"[cur_] :> iGetExchangeRate[{cur, "USD"}]]

MixedUnitConvert[quantity_Quantity, MixedUnit[{units__}]] /; CompatibleUnitQ[quantity, units] := With[
  {order = Ordering[Quantity[1, #] & /@ {units}, All, Greater]}, 
  Module[{remainder = quantity, results = {}},
   With[
      {uc = UnitConvert[remainder, {units}[[#]]]}, 
      If[Length[results] < (Length[order] - 1), 
       AppendTo[results, IntegerPart[uc]]; remainder = (FractionalPart[uc] /. FractionalPart[Interval[i_]] :> Interval[FractionalPart[i]]), 
       AppendTo[results, uc]]] & /@ order; 
    results = Part[results, Ordering[order]];
    If[Not[FreeQ[results,Interval]],fixIntervalResults[results],
    With[{mag = MixedMagnitude[QuantityMagnitude[results]], unit = MixedUnit[QuantityUnit[results]]}, 
    If[QuantityQ[Quantity[mag, unit]],Quantity[mag, unit],$Failed]]
    ]
    ]
  ]
MixedUnitConvert[___]:=$Failed

(*bulk unit conversion is not condusive to temperature conversions, so back out if we see them*)
bulkConvertableQ[unit_, target_] := And[fasttrackableUnitsQ[unit, target], UnitDimensions[target] =!= {{"TemperatureUnit", 1}}]

bulkUnitConvert[_,"SI" | "Imperial"|"Metric"|"Base"|"SIBase"] := False
bulkUnitConvert[q:{Quantity[_,unit_]..}, unit_] := q
bulkUnitConvert[q:{Quantity[_,unit_]..}, HoldForm[unit_]] := q
bulkUnitConvert[q:{Quantity[_,unit_]..},targetUnit_]/;bulkConvertableQ[unit, targetUnit] := Module[{values, factor},
	values=QuantityMagnitude[q]; factor = releaseExchangeRate[convertToValue[unit,targetUnit,1]];
	Quantity[values*factor, targetUnit]
]
bulkUnitConvert[___] := False
(*-----NormalizeMixedUnitQuantity------*)
(*-this function is used in construction and validation of MixedUnit Quantity expressions-*)
(*-to avoid redundant validation and to speed things up, this utility calls low-level Alpha functions directly-*)
getOrdering[units_List]:= Ordering[
		removeFundamentalUnits[Map[
			unitTableElementLookup[(*lives in Typesetting.m*)
				#,
				"FundamentalUnitValue"
			]&,
			units]],
		All,
		Greater
]

removeFundamentalUnits[expr_] := ReplaceAll[expr,
{"Seconds" -> 1, 
 "Amperes" -> 1, 
 "Grams" -> 1, 
 "Meters" -> 1, 
 "USDollars" -> 1, 
 "Moles" -> 1, 
 "Kelvins" -> 1, 
 "Bits" -> 1, 
 "Radians" -> 1, 
 "Candelas" -> 1, 
 "Steradians" -> 1, 
 "KelvinsDifference" -> 1, 
 "Morgans" -> 1, 
 "DataPackets" -> 1, 
 "Samples" -> 1, 
 "InternationalUnits" -> 1}	
]

quickUnmix[q : Quantity[MixedMagnitude[mag_List], MixedUnit[units:{u_,___}]]] := With[
	{qs = Cases[Map[Quantity@@# &, Transpose[{mag, units}]],HoldPattern[_Quantity]]},  
  Quantity[Total[First[fastTrackConvert[#, u]] & /@ qs], u]]

fastTrackConvert[quantity:Quantity[_MixedMagnitude,__], targetUnit_] := unitConvert[quickUnmix[quantity], targetUnit]
fastTrackConvert[quantity:Quantity[Except[_MixedMagnitude],__], targetUnit_] := unitConvert[quantity, targetUnit]
fastTrackConvert[other_,___]:=other

convertTimeSeries[series_?TemporalData`StructurallyValidTemporalDataQ, targetUnit_] :=
 Module[{states = series["ValueList"], vals, res},
  vals = UnitConvert[states, targetUnit];(* validate result *)
  res = TemporalData`ReplaceStates[series, vals];
  If[TemporalData`StructurallyValidTemporalDataQ[res],
   res, Message[UnitConvert::tsq, series, targetUnit];$Failed
   ]] 
convertTimeSeries[___] := $Failed

getIntegerPart[quantity_] := Internal`InheritedBlock[{IntegerPart},
		Unprotect[IntegerPart];
		IntegerPart[Quantity[mag_, unit_]] := Quantity[IntegerPart[mag], unit];
		
		With[{res = IntegerPart[quantity]},
		If[FreeQ[res,IntegerPart],
			res,
			Throw[$Failed,"Normalizer"]
		]	
	]
]

getFractionalPart[quantity_] := Internal`InheritedBlock[{FractionalPart},
		Unprotect[FractionalPart];
		FractionalPart[Interval[i_]] := Interval[FractionalPart[i]];
		FractionalPart[Quantity[mag_, unit_]] := Quantity[FractionalPart[mag], unit];
		
		With[{res = FractionalPart[quantity]},
		If[FreeQ[res,FractionalPart],
			res,
			Throw[$Failed,"Normalizer"]
		]	
	]
]

(*TODO: add handler for Quantity[Interval[{_MixedMagnitude..*)
NormalizeMixedUnitQuantity[args___] := Catch[iNormalizeMixedUnitQuantity[args], "Normalizer"]
iNormalizeMixedUnitQuantity[quantity : Quantity[_MixedMagnitude, MixedUnit[units_List]]] := With[{order = getOrdering[units]}, 	
		Module[{remainder = quickUnmix[quantity], results = {}}, 
			Map[
				With[{uc = fastTrackConvert[remainder, units[[#]]]}, 
					If[
						Length[results] < (Length[order] - 1), 
						AppendTo[results, getIntegerPart[uc]]; remainder = getFractionalPart[uc], 
						AppendTo[results, uc]
					]
				] &,
				order];
			MixedMagnitude[Part[First/@results, Ordering[order]]]
		]
]
      
iNormalizeMixedUnitQuantity[___] := $Failed

SetAttributes[MixedRadixToMixedUnitQuantity, HoldAll];
MixedRadixToMixedUnitQuantity[args__] := Catch[iMixedRadixToMixedUnitQuantity[args], "MR2MUQ"]

SetAttributes[iMixedRadixToMixedUnitQuantity, HoldAll];
iMixedRadixToMixedUnitQuantity[Quantity[HoldPattern[m:(_List|_MixedRadix|_Interval)], HoldPattern[MixedRadix[units__]]]] := Module[{mag},
	Scan[If[!KnownUnitQ[#], Throw[$Failed, "MR2MUQ"]]&, {units}];
	If[!CompatibleUnitQ[units], Throw[$Failed, "MR2MUQ"]];
	mag = m /. MixedRadix[val__] :> MixedMagnitude[PadRight[{val},Length[{units}], 0]];
	{mag, MixedUnit[{units}]}
]
iMixedRadixToMixedUnitQuantity[Quantity[expr_, HoldPattern[MixedRadix[units__]]]] /; CompatibleUnitQ[units] := {MixedMagnitude[PadRight[{expr},Length[{units}], 0]], MixedUnit[{units}]}
iMixedRadixToMixedUnitQuantity[___] := $Failed

fixIntervalResults[list:{Quantity[Interval[{_,_}],__]..}]:=With[{low=list[[All,1,1,1]],high=list[[All,1,1,2]]},
	With[{mag=Interval[{MixedMagnitude[low],MixedMagnitude[high]}],unit=MixedUnit[QuantityUnit[list]]},
	If[QuantityQ[Quantity[mag,unit]],Quantity[mag,unit],$Failed]]
]
fixIntervalResults[___]:=$Failed

(*symbols was excised from System`, currently only used by QA for testing*)
QuantityAlternatives[quant:Quantity[_, unit_]?QuantityQ]:= With[{units = Select[UnitPrimaryDestinations[unit], CompatibleUnitQ[#, unit]&]},
	If[ListQ[units] && Length[units] > 1,
		If[KnownUnitQ[#], UnitConvert[quant, #], Nothing]& /@ units,
		{quant}
	]
]
	
predictionsSubstitutions = {"GregorianYears"->"Years"};

SetAttributes[UnitPrimaryDestinations,HoldFirst];
UnitPrimaryDestinations[u_HoldForm] := Module[{res=QuantityUnits`Private`PrimaryDestinationLookup[u]/.predictionsSubstitutions},
		If[
		ListQ[res],
		manageHeldForm/@res,
		{},
		{}]]
UnitPrimaryDestinations[u:Except[_HoldForm]]:=UnitPrimaryDestinations[HoldForm[u]]

QuantityPrimaryDestinationFunction[Quantity[_,unit_]?QuantityQ]:=UnitPrimaryDestinations[unit]
QuantityPrimaryDestinationFunction[___]:={}

manageHeldForm[unit_HoldForm]:=With[{uh = ReleaseHold[unit]}, If[HoldForm[uh] === unit,uh,unit,unit]]	
manageHeldForm[other___]:=other

(*fastest method available to push mixed-radix quantities to single-unit quantities*)
unmixMixedUnitQuantity[q:Quantity[(_MixedMagnitude|_Interval),_MixedUnit]]/;MixedUnitQ[q]:=umrq[q]
unmixMixedUnitQuantity[q:Quantity[_List,unit_List]]/;MixedUnitQ[q]:=unmixMixedUnitQuantity/@(Quantity[#,unit]&/@QuantityMagnitude[q])
unmixMixedUnitQuantity[something__]:=something

getSmallestMixedUnit[q:Quantity[_, _MixedUnit]?QuantityQ] := If[QuantityQ[#], QuantityUnit[#], {}]&[unmixMixedUnitQuantity[q]]
getSmallestMixedUnit[_] := {}

(*unmix mixed-radix quantity*)
umrq[(q : Quantity[MixedMagnitude[mag_List], MixedUnit[units_List]])?MixedUnitQ] := 
 With[{qs = Quantity[Sequence @@ #] & /@ Transpose[{mag, units}]}, 
  With[{u = Last[units]}, 
   Quantity[Total@QuantityMagnitude[UnitConvert[#, u] & /@ qs], u]
  ]
]
umrq[(q : Quantity[Interval[{lower_MixedMagnitude,upper_MixedMagnitude}], unit:MixedUnit[{u_,__}]])?MixedUnitQ] :=With[{
	v1 = QuantityMagnitude[UnitConvert[Quantity[lower, unit], u]],
	v2 = QuantityMagnitude[UnitConvert[Quantity[upper, unit], u]]}, 
	Quantity[Interval[{v1, v2}], u]]
umrq[other___]:=other

findLeastComplexUnit[q:Quantity[_, _String], ___] := q (*very basic filter; if the input is a 'simple' String unit, don't choose any alternatives *)

findLeastComplexUnit[input_, alternatives__] := Catch[
	Module[{list = {input, alternatives}},
		(*first pass; look for fewest number of component units; if there's no tie, return that one*)
		list = MinimalBy[list, Length[Cases[#, _String, -1]] &];
		If[Length[list] === 1, Throw[First[list], "findLeastComplexUnit"]];
		(* if none of the alternatives have fewer units than the original input, give back the input*)
		If[First[list] === input, Throw[input, "findLeastComplexUnit"]];
		(*second pass; look for the case with the most SI base units; if there is no tie, return that one*)
		list = MaximalBy[list, Length[Cases[#, u_String/; MemberQ[$baseUnits, u], -1]]&];
		If[Length[list] === 1, Throw[First[list], "findLeastComplexUnit"]];
		(*third pass; look for the case with the smallest sum of powers; if there is no tie, return taht one*)
		list = MinimalBy[list, Total[Cases[QuantityUnit[#], Power[_, n_] :> Abs[n], -1]]&];
		If[Length[list] === 1, Throw[First[list], "findLeastComplexUnit"]];
		(*final pass; take the first entry, which is the one 'closest' to the input quantity*)
		First[list]
	],
	"findLeastComplexUnit"
]

SetAttributes[UnitSimplify,Listable];
Options[UnitSimplify]={UnityDimensions->{}};

UnitSimplify[n_?NumericQ]:=n
UnitSimplify[(quan:Quantity[_,unit_])?QuantityQ]:= If[
	MemberQ[iUSFCRP, UnitDimensions[unit]],
	(* if UnitDimensions match most common reductions in iUSFCR convert directly *)
	iUnitConvert[quan, UnitDimensions[unit]/.iUSFCR],
	(* otherwise check possible reductions and then choose least complex result *)
	Module[{q = iSimplifyQuantity[quan]},
		findLeastComplexUnit[quan, q, iSimplifyQuantity[iQuantityReduce[q]], UnitConvert[quan]]
	]
]
UnitSimplify[(quan:Quantity[_,unit_])?QuantityQ,OptionsPattern[]]:=With[
	{res=Switch[Check[OptionValue[UnityDimensions],$Failed],
	Automatic,
	With[{r=nonDimensionalize[quan]},UnitSimplify[r]],
	{},
	UnitSimplify[quan],
	{_String..},
	With[{r=nonDimensionalize[quan,OptionValue[UnityDimensions]]},UnitSimplify[r]],
	_,
	Message[UnitSimplify::udim,OptionValue[UnityDimensions]];$Failed
	]},res/;res=!=$Failed]
UnitSimplify[ts_TemporalData] := unitSimplifyTimeSeries[ts]
(*UnitSimplify should borrow into any non-held expression:  bug(369374)*)
UnitSimplify[expr:(h_[__]), opts:OptionsPattern[]] := If[
	Intersection[Attributes[h], {HoldAll, HoldAllComplete, HoldFirst, HoldRest}] === {}, 
	Map[UnitSimplify[#, opts]&, expr],
	expr
] 
UnitSimplify[expr_, OptionsPattern[]] := expr
(*UnitSimplify[a_Association] := Map[unitSimplifyAssociation, a] /; AssociationQ[a]*)
UnitSimplify[_,args:Except[__?OptionQ]]:=(Message[UnitSimplify::argx,UnitSimplify,Length[{args}]+1];Null/;False)
UnitSimplify[]:=(Message[UnitSimplify::argx,UnitSimplify,0];Null/;False)

unitSimplifyAssociation[q_?QuantityQ] := UnitSimplify[q]
unitSimplifyAssociation[q_TemporalData] := UnitSimplify[q]
(*unitSimplifyAssociation[sa_StructuredArray] := StructuredArrayUnitSimplify[sa]*)
unitSimplifyAssociation[list_List] := Map[unitSimplifyAssociation[#]&, list]
unitSimplifyAssociation[a_Association] := Map[unitSimplifyAssociation[#]&, a] /; AssociationQ[a]
unitSimplifyAssociation[other_,___] := other

unitSimplifyTimeSeries[series_?TemporalData`StructurallyValidTemporalDataQ] :=
 Module[{states = series["ValueList"], vals, res},
  vals = UnitSimplify[states];(* validate result *)
  res = TemporalData`ReplaceStates[series, vals];
  If[TemporalData`StructurallyValidTemporalDataQ[res],
   res, Message[UnitSimplify::tsq, series];$Failed
   ]]
unitSimplifyTimeSeries[___] := $Failed

nonDimensionalize[q_Quantity,dimensions___] := 
 With[{ndim = constructnonDimensionalizer[UnitDimensions[q],dimensions]}, 
  With[{r = Quiet[Times[ndim, q]]}, 
   If[Quiet[Or[QuantityQ[r], NumericQ[r]]], r, q, q]]]
   
nonDimensionalize[x_,___] := x

constructnonDimensionalizer[dims_List, dimensions_:$nonDimensionalDimensions] := 
 With[{dimensionless = Cases[dims, {d_String, _?NumericQ} /; MemberQ[dimensions, d]]}, 
  Times @@ (With[{u = Power[Internal`DimensionToBaseUnit[#[[1]]], -#[[2]]]}, 
        Quantity[1, u]] & /@ dimensionless)]

constructnonDimensionalizer[___] := $Failed

$nonDimensionalDimensions = {"AngleUnit", "SolidAngleUnit"};

$baseUnits = {"Meters", "Kilograms", "Seconds", "Moles", "Amperes", "Kelvins", "Candelas"};
$derivedUnits = {"Newtons", "Joules", "Farads", "Pascals", "Coulombs", "Volts", "Watts", "Ohms", "Liters", "Webers", "Siemens", "Teslas", "Henries"};
$allSIrelatedUnits = Join[$baseUnits, $derivedUnits];

$zeroPassUnitPairs := $zeroPassUnitPairs = 
  Join @@ Outer[Rule[UnitDimensions[#1^#2], #1^#2] &, $baseUnits, {-2, -1, 1, 2}]
$zeroPassUnitDimensions := $zeroPassUnitPairs[[All, 1]]

$firstPassUnitPairs := $firstPassUnitPairs = 
  Join @@ Outer[Rule[UnitDimensions[#1^#2], #1^#2] &, $derivedUnits, {-2, -1, 1, 2}]
$firstPassUnitDimensions := $firstPassUnitPairs[[All, 1]]

$secondPassUnitPairs := $secondPassUnitPairs = DeleteDuplicatesBy[
  Map[Rule[UnitDimensions[Times @@ #], Times @@ #] &, 
   Tuples[$allSIrelatedUnits, 2]], First]
$secondPassUnitDimensions := $secondPassUnitPairs[[All, 1]]

$finalPassUnitPairs := $finalPassUnitPairs = DeleteDuplicatesBy[
  Flatten[Table[
    With[{u = i^j*n^m}, 
     Rule[UnitDimensions[u], 
      u]], {i, $allSIrelatedUnits}, {n, $allSIrelatedUnits}, {j, {-1, 
      1}}, {m, {-1, 1}}], 3], First]
$finalPassUnitDimensions := $finalPassUnitPairs[[All, 1]]

zeroPassQ[dims_] := MemberQ[$zeroPassUnitDimensions, dims]
firstPassQ[dims_] := MemberQ[$firstPassUnitDimensions, dims]
secondPassQ[dims_] := MemberQ[$secondPassUnitDimensions, dims]
finalPassQ[dims_] := MemberQ[$finalPassUnitDimensions, dims]

zeroPassSimplify[q_, dims_] := UnitConvert[q, dims /. $zeroPassUnitPairs]
firstPassSimplify[q_, dims_] := UnitConvert[q, dims /. $firstPassUnitPairs]
secondPassSimplify[q_, dims_] := UnitConvert[q, dims /. $secondPassUnitPairs]
finalPassSimplify[q_, dims_] := UnitConvert[q, dims /. $finalPassUnitPairs]


(*simplify compound unit expressions and check for complex components*)
iSimplifyQuantity[q:(Quantity[mag_, unit_])] := Catch[
   	Module[{res},
   		If[StringQ[unit], Throw[q, "iSimplifyQuantity"]];
   		With[{dims = UnitDimensions[unit]},
   			Switch[dims,
   				_?zeroPassQ, Throw[zeroPassSimplify[q, dims], "iSimplifyQuantity"],
   				_?firstPassQ, Throw[firstPassSimplify[q, dims], "iSimplifyQuantity"],
   				_?secondPassQ, Throw[secondPassSimplify[q, dims], "iSimplifyQuantity"],
   				_?finalPassQ, Throw[finalPassSimplify[q, dims], "iSimplifyQuantity"]
   			]
   		];
		res = With[{un = PowerExpand[unit]}, Quantity[mag, un]];
   		If[Or[QuantityQ[res],NumericQ[res]], 
   			res, 
   			With[{fixed=checkForI[res]},
   				If[Or[QuantityQ[fixed],NumericQ[res]],
   					fixed,
   					q
   				]]
   		]], "iSimplifyQuantity"]
iSimplifyQuantity[x___]:=x

(*used to remove complex components from unit part*)
checkForI[Quantity[mag_,unit_]]:=Module[{num,denom},
	num=Cases[Numerator[unit],_Complex,Infinity];
	denom=Cases[Denominator[unit],_Complex,Infinity];
	num=If[num==={},1,Times@@num];denom=If[denom==={},1,Times@@denom];
	With[{m=mag*(num/denom),u=DeleteCases[unit,_Complex,Infinity]},Quantity[m,u]]]
checkForI[___]:=$Failed

(*look at alternative quantities and find best fit*)
iQuantityReduce[quan_Quantity]:= 
 Module[{ul, un, qe}, 
  ul = UnitPrimaryDestinations[QuantityUnit[quan]];
  un = If[Length[ul] > 0, First[ul], 
  		Which[
  			hasCurrencyQ[quan](*too many calls to MWACompute*), {},
  			MixedUnitQ[quan], getSmallestMixedUnit[quan],
  			True, Quiet[QuantityUnit[iFilterUnits[quan]]](*choose best fitting unit from alternatives*)
   		], 
   $Failed];
  If[Head[un]=!=QuantityUnit,
  	If[un==="1"||un===1||un==={},
  		If[UnitDimensions[quan]==={},QuantityExpand[quan],Sqrt[quan^2]],(*alternative simplification*)
  		If[With[{u=un},Not[KnownUnitQ[u]]],
  			$Failed,
  			UnitConvert[quan, un],
  			$Failed]],
  	If[UnitDimensions[qe=QuantityExpand[quan]] === {},qe,quan,$Failed],
  	$Failed]]
  	
(*uses GenericConversions to try and simplify quantity, picks out output with least complex unit component*)
iFilterUnits[q:Quantity[_, unit_]] := Module[{res = alternativeUnitForms[unit], sunits},
	If[
		res==={},
		{},
		sunits = iSelectLeastComplexUnits[res];(*choose best fitting unit from alternatives*)
		First[sunits]
	]
]

alternativeUnitForms[unit:(Times | Power)[__]] := With[{sibu = QuantityUnit[c2sibu[Quantity[1, unit]]]},
	{sibu, unit}
]
alternativeUnitForms[unit_] := {unit}

(*take a list of input unit expressions and select the one with fewest terms*)
iSelectLeastComplexUnits[units_List] := 
 Module[{exps = Cases[{#}, _String, -1] & /@ units, sort, 
   longest, texps}, sort = Sort[exps, Length[#1] < Length[#2] &]; 
  longest = Length[First[sort]]; 
  texps = Select[sort, Length[#] == longest &]; 
  Part[units, Flatten[Position[exps, #] & /@ texps]]]

(*private alias to UnitConvert[_,"Base"*)
SetAttributes[QuantityExpand,Listable]
QuantityExpand[n_?NumericQ]:=n
QuantityExpand[(quan_Quantity)?QuantityQ]:= With[{res=UnitConvert[quan,"SIBase"]},
	If[QuantityQ[res],
		res,
		iSimplifyQuantity[checkExpandedQuantity[res]]]]

(*handle some edge-cases to ensure output unit is valid*)
checkExpandedQuantity[q:(Quantity)[mag_,unit_]]:=If[KnownUnitQ[unit], q, 
 Module[{components = 
    Cases[Cases[unit, _String, -1], 
     x_ /; Not[KnownUnitQ[x]]], np, 
   dp}, {np, 
    dp} = {Cases[Numerator[unit], 
     Power[u_, _] /; MemberQ[components, u], Infinity], 
    Cases[Denominator[unit], Power[u_, _] /; MemberQ[components, u], 
     Infinity]};
  With[{u = PowerExpand[unit /. (Rule[#, 1] & /@ components)], 
    m = (mag*Times @@ np)/Times @@ dp},
   Quantity[m, u]]]]
checkExpandedQuantity[res___]:=res

gettargetUnit[unitlist:{_Quantity..}] /; Length[unitlist] > 1 := 
Module[{units = unitlist[[All, 2]]},
	units = Flatten[{units, UnitPrimaryDestinations /@ units}];
	units = Commonest[Select[units, KnownUnitQ]];
	First[units]
 ]
gettargetUnit[unitlist:{_Quantity..}]/;Not[MemberQ[unitlist,$Failed]]/;Length[unitlist]===1 := 
QuantityUnit[First@unitlist]
gettargetUnit[unitlist:{_Quantity..}]/;MemberQ[unitlist,$Failed]:=gettargetUnit[Cases[unitlist,Except[$Failed]]]
gettargetUnit[l:{_?KnownUnitQ..}]/;Length[Union[l]]===1:=First[l]
gettargetUnit[l:{_?KnownUnitQ..}]:=gettargetUnit[Quantity[1,#]&/@l]
gettargetUnit[x__]:=x

iGatherAndConvertByDimension[list:{_?QuantityOrQuantityListQ...}] := Catch[
	With[
		{grouped = GatherBy[Flatten[list], UnitDimensions]},
		With[
			{rules = Flatten[Check[Thread[Rule[#, StandardizeQuantities[#]]], Throw[$Failed, $tag]]& /@ grouped]},
			list/.rules
		]
	],
$tag]
iGatherAndConvertByDimension[series_TemporalData] := commonUnitsTimeSeries[series]
iGatherAndConvertByDimension[a_Association] := commonUnitsAssociation[a]
iGatherAndConvertByDimension[___]:=$Failed

commonUnitsTimeSeries[series_?TemporalData`StructurallyValidTemporalDataQ] :=
 Module[{states = series["ValueList"], vals, res},
  vals = CommonUnits[states];(* validate result *)
  res = TemporalData`ReplaceStates[series, vals];
  If[TemporalData`StructurallyValidTemporalDataQ[res],
   res, Message[CommonUnits::tsq, series];$Failed
   ]]
commonUnitsTimeSeries[___] := $Failed

commonUnitsAssociation[a_?AssociationQ] := Module[{res, quantities = Cases[a,HoldPattern[q_Quantity]/;QuantityQ[q],{1,Infinity}]},
	If[quantities === {},
		a,
		res = iGatherAndConvertByDimension[quantities];
		If[UnsameQ[res, $Failed] && SameQ[Length[res], Length[quantities]],
			a/.Thread[Rule[quantities,res]],
			$Failed
		]
	]
]
commonUnitsAssociation[___] := $Failed

CommonUnits[qa_QuantityArray?ArrayQ] := QuantityArray`QuantityArrayCommonUnits[qa]
CommonUnits[args_]:=With[{res=Quiet[iGatherAndConvertByDimension[args]]},res/;Quiet[res=!=$Failed]]
CommonUnits[_,args__]:=(Message[CommonUnits::argx,CommonUnits,Length[{args}]+1];Null/;False)
CommonUnits[]:=(Message[CommonUnits::argx,CommonUnits,0];Null/;False)
StandardizeQuantities[args__]:=With[{res=iStandardizeQuantities[args]},res/;res=!=$Failed]
(*works only on compatible units*)
iStandardizeQuantities[l:{_?NumericQ..}]:=l
iStandardizeQuantities[l:{{_?NumericQ..}..}]:=l
iStandardizeQuantities[l:{_?NumericQ..},"DimensionlessUnit"]:=l
iStandardizeQuantities[l:{{_?NumericQ..}..},"DimensionlessUnit"]:=l
iStandardizeQuantities[l:{_?NumericQ...,_Quantity...,___}]/;Union[UnitDimensions/@l] === {{}} := UnitConvert[l]
iStandardizeQuantities[l_List,"DimensionlessUnit"]:=StandardizeQuantities[l,"PureUnities"]
iStandardizeQuantities[l:{Quantity[_,unit_]..}]:=l
iStandardizeQuantities[l:{Quantity[_,unit_]..},unit_]:=l
iStandardizeQuantities[l_List,target_]/;AllQuantityQ[l]/;Or@@(MixedUnitQ/@l):=iStandardizeQuantities[unmixMixedUnitQuantity/@l,target]
iStandardizeQuantities[l_List]/;AllQuantityQ[l]/;Or@@(MixedUnitQ/@l):=iStandardizeQuantities[unmixMixedUnitQuantity/@l]
iStandardizeQuantities[list_List]/;AllQuantityQ[list]/;Length[Union[QuantityUnit[list]]]===1:=list
iStandardizeQuantities[list_List]/; AllQuantityQ[list] /; CompatibleUnitQ[Union[QuantityUnit[list]]]:=Catch[
Module[{units=Union[QuantityUnit[list]],tu},
	tu=gettargetUnit[units];
	Table[(If[#===$Failed,Throw[$Failed,$tag],#]&[UnitConvert[i,tu]]),{i,list}]
],$tag]
iStandardizeQuantities[list_List]/;AllQuantityQ[list]:= 
Catch[Module[{un=gettargetUnit[list[[All, 2]]],res,resh},
 res=Table[(If[#===$Failed,Throw[$Failed,$tag],#]&[UnitConvert[i,un]]),{i,list}];
 resh=Union[QuantityUnit[res]];
 If[TrueQ[Length[resh]==1&&Head[resh]==List],res,$Failed]
 ],$tag]
iStandardizeQuantities[list_, Automatic]:=StandardizeQuantities[list]
iStandardizeQuantities[list_List,unit:(_Power|_Times|_String|_IndependentUnit|_Divide)]/;AllQuantityQ[list]/;KnownUnitQ[unit] := 
Catch[Module[{mult,res,resh},
	If[
		And[Length[Union[QuantityUnit[list]]]===1,CompatibleUnitQ[QuantityUnit[First[list]],unit],Not[isTemperatureQ[First[list]]]],
			mult=With[{u=QuantityUnit[First[list]]},QuantityMagnitude[UnitConvert[Quantity[1,u],unit]]];
			Quantity[mult*#,unit]&/@QuantityMagnitude[list],
 			res=Table[(If[#===$Failed,Throw[$Failed,$tag],#]&[UnitConvert[i,unit]]),{i,list}];
 			resh=Union[QuantityUnit[res]];
 			If[TrueQ[Length[resh]==1&&Head[resh]==List],res,$Failed],
 			$Failed]
 ],$tag]
iStandardizeQuantities[{list:_List..}]:=Catch[
	If[
		Not[CompatibleUnitQ[Flatten[{list}]]],
		iFindInCompatibleUnits[Sequence@@Flatten[{list}]];Throw[$Failed,$tag]
	];
	With[{target=gettargetUnit[Flatten[QuantityUnit[{list}]]]},
	Table[(If[#===$Failed,Throw[$Failed,$tag],#]&[StandardizeQuantities[i,target]]),{i,{list}}]],$tag
]
iStandardizeQuantities[{list:_List..},target:(_String|_Power|_Times|_Divide)]/;KnownUnitQ[target]:=Catch[
	If[
		Not[CompatibleUnitQ[Flatten[{list}]]],
		iFindInCompatibleUnits[Sequence@@Flatten[{list}]];Throw[$Failed,$tag]
		];
	Table[(If[Quiet[MatchQ[#,_StandardizeQuantities]],Throw[$Failed,$tag],#]&[StandardizeQuantities[i,target]]),{i,{list}}],$tag
]
iStandardizeQuantities[l_List] :=  l /; VectorQ[Flatten[l], NumericQ]
iStandardizeQuantities[l_List, "DimensionlessUnit"] :=  l /; VectorQ[Flatten[l], NumericQ] 
iStandardizeQuantities[l_List]/;AllQuantityQ[l]:=l
iStandardizeQuantities[___]=$Failed;

(*used to find appropriate unit associated with multiple Quantity expressions*)
CanonicalUnits[(quantity__Quantity)?QuantityQ]:=CanonicalUnits[{quantity}]
CanonicalUnits[(quantity__Quantity)?QuantityQ,"BestFit"]:=CanonicalUnits[{quantity},"BestFit"]
CanonicalUnits[{(quantities__Quantity)?QuantityQ}]/;Length[Union[QuantityUnit[{quantities}]]]===1:=ReleaseHold[QuantityUnit[First[{quantities}]]]
CanonicalUnits[{(quantities__Quantity)?QuantityQ}]:=Module[{cn=UnitConvert[{quantities},"SIBase"],unit},unit=Union[QuantityUnit[cn]];If[Length[unit]===1,ReleaseHold[First@unit],$Failed,$Failed]]
CanonicalUnits[{(quantities__Quantity)?QuantityQ},"BestFit"]:=Module[{cn=UnitConvert[{quantities},"SIBase"],unit},unit=Union[QuantityUnit[cn]];If[Length[unit]===1,gettargetUnit[{quantities}[[All,2]]],$Failed,$Failed]]
CanonicalUnits[___]:=$Failed

(*modularized exchange rate manager*)
If[Not[ValueQ[$UserExchangeRateTable]], $UserExchangeRateTable = {}];
iGetExchangeRate[l_List]:=If[
	MemberQ[$UserExchangeRateTable[[All,1]],First[l]],
	First[l]/.$UserExchangeRateTable,
	Which[$DynamicCurrencyConversion === False,
		iRetrieveExchangeRate[l],
		$DynamicCurrencyConversion === True,
		getMWACurrencyConvert[l],
		True,First[l]<>"/USD"]]

getMWACurrencyConvert[l_List] := With[{res = ReleaseHold[Internal`MWACompute["MWACurrencyConvert", l]]},
	addToUERT[l,If[validExchangeRateQ[res],
		res,
		Message[UnitConvert::conopen]; Throw[False, $tag]
	]]
]

validExchangeRateQ[n_?NumberQ] /; n > 0 := True
validExchangeRateQ[__] := False

iSetExchangeRateFromUSD[cur_String,rate_?NumericQ]:=If[
	Length[$UserExchangeRateTable]>0,
	$UserExchangeRateTable=Prepend[DeleteCases[$UserExchangeRateTable,Rule[cur,_]],cur->rate],
	$UserExchangeRateTable={cur->rate}
]
iClearExchangeRateFromUSD[cur_String]:=$UserExchangeRateTable=DeleteCases[$UserExchangeRateTable,Rule[cur,_]]
iRetrieveExchangeRate[{s_String,"USD"}]:=(s/.$UserExchangeRateTable)/.st_String:>(st<>"/USD")

Internal`QuantityToValue[args__] := Block[{DatedUnit},
	DatedUnit[u_,n_Integer]:=DatedUnit[u,{n}]; (*catch syntatic differences on same date*)
	With[{res = iQuantityToValue[args]}, res]
]
Options[iQuantityToValue] = {System`TargetUnits -> Automatic,"Compatibility"->All};
Internal`QuantityToValue::invld = "Invalid Quantity or TargetUnit specification";
iQuantityToValue[sa_?StructuredArray`StructuredArrayQ, options___?OptionQ] := Which[
	QuantityArray`QuantityArrayQ[sa],
		StructuredArray`QuantityArrayDump`getData[sa, options],
	True,
		iQuantityToValue[Normal[sa, StructuredArray], options]
];
iQuantityToValue[arg_,args___]/;Not[FreeQ[arg,MixedUnit]] := iQuantityToValue[arg/.q:Quantity[_,_MixedUnit]:>UnitSimplify[q],args]
iQuantityToValue[arg_,TargetUnits->q_Quantity]:=Catch[With[{qu=Check[QuantityUnit[q],Throw[$Failed,$tag]]},If[Head[qu]=!=QuantityUnit,iQuantityToValue[arg,TargetUnits->qu],$Failed,$Failed]],$tag]
iQuantityToValue[l_List]/;FreeQ[l,Quantity]:={l,"DimensionlessUnit"}
iQuantityToValue[l:{_List..}]/;FreeQ[l,Quantity]:={l,"DimensionlessUnit"}
iQuantityToValue[l_List,System`TargetUnits->Automatic]/;FreeQ[l,Quantity]:={l,"DimensionlessUnit"}
iQuantityToValue[n_?NumericQ..]:={n,"DimensionlessUnit"}
iQuantityToValue[q:(Quantity[Except[_MixedMagnitude], Except[_MixedUnit]])?QuantityQ] := Through[{QuantityMagnitude, QuantityUnit}[q]]
iQuantityToValue[(q:Quantity[_MixedMagnitude,_MixedUnit])?QuantityQ] := With[{quant=unmixMixedUnitQuantity[q]},{QuantityMagnitude[quant], QuantityUnit[quant]}]
iQuantityToValue[(q:Quantity[Except[_MixedMagnitude],unit:Except[_MixedUnit]])?QuantityQ,System`TargetUnits -> t_?KnownUnitQ] := {QuantityMagnitude[UnitConvert[q, t]], t}
iQuantityToValue[(q:Quantity[Except[_MixedMagnitude], unit:Except[_MixedUnit]])?QuantityQ, System`TargetUnits -> t_String] /; Not[KnownUnitQ[t]] := Catch[With[{u = 
     Check[QuantityUnit[Quantity[t]], 
      Throw[$Failed,$tag]]}, {QuantityMagnitude[UnitConvert[q, u]], u}],$tag]
iQuantityToValue[(q:Quantity[_MixedMagnitude,_MixedUnit])?QuantityQ,System`TargetUnits -> t_?KnownUnitQ] := With[{quant=unmixMixedUnitQuantity[q]},Internal`QuantityToValue[quant,System`TargetUnits->t]]
iQuantityToValue[(q:Quantity[_MixedMagnitude, _MixedUnit])?QuantityQ, System`TargetUnits -> t_String] /; Not[KnownUnitQ[t]] := Catch[With[{u = Check[QuantityUnit[Quantity[t]], Throw[$Failed,$tag]]}, 
   With[{quant = unmixMixedUnitQuantity[q]}, 
    Internal`QuantityToValue[quant, System`TargetUnits -> u]]],$tag]
iQuantityToValue[q : {Quantity[_, unit_]..}] /; KnownUnitQ[unit] := {QuantityMagnitude[q], QuantityUnit[Quantity[1,unit]]}
iQuantityToValue[q : {__Quantity}] /;Internal`SameUnitDimension[q] := 
 With[{sq = StandardizeQuantities[q]}, {QuantityMagnitude[sq], QuantityUnit[First@sq]}]
iQuantityToValue[q : {_Quantity..}, System`TargetUnits -> t_?KnownUnitQ] /; With[{l=Append[q,Quantity[1,t]]},Internal`SameUnitDimension[l]] := 
	With[{sq=StandardizeQuantities[q, t]}, {QuantityMagnitude[sq], t}]
iQuantityToValue[q : {_Quantity ..}, System`TargetUnits -> t_String] /;Not[KnownUnitQ[t]] /; With[{l = Append[q, Quantity[1, t]]}, Internal`SameUnitDimension[l]] := Catch[With[{u = Check[QuantityUnit[Quantity[t]], Throw[$Failed,$tag]]}, 
   With[{sq = StandardizeQuantities[q, u]}, {QuantityMagnitude[sq], u}]],$tag]
iQuantityToValue[q : {_Quantity..}, System`TargetUnits -> Automatic] := iQuantityToValue[q]
iQuantityToValue[(s__Quantity)?QuantityQ, opts___?OptionQ] := iQuantityToValue[{s}, opts]
iQuantityToValue[l:{(_Quantity)?QuantityQ..}]:=(iFindInCompatibleUnits[Sequence@@l];$Failed)
iQuantityToValue[l:{(_Quantity)?QuantityQ..},opts___?OptionQ]:=If[
	UnsameQ[All,"Compatibility"/.Flatten[{opts}]/.Options[iQuantityToValue]],
	iQuantityToValue[l,Sequence@@DeleteCases[{opts},HoldPattern[Rule["Compatibility",_]]]],
	With[{targ=(System`TargetUnits/.Flatten[{opts}]/.Options[iQuantityToValue])},
	(iFindInCompatibleUnits[Sequence@@If[targ=!=Automatic,Prepend[l,Quantity[1,targ]],l]];$Failed)]]
iQuantityToValue[m_?MixedQuantityMatrixQ,opts___?OptionQ]:=Switch[
	("Compatibility"/.Flatten[{opts}]/.Options[iQuantityToValue]),
	All,iQuantityMatrixToValue[m,opts],
	"Columnwise",iQuantityColumnwiseMatrixToValue[m,opts],
	"Rowwise",iQuantityRowwiseMatrixToValue[m,opts],
	_,Message[Internal`QuantityToValue::invld];$Failed
]
iQuantityToValue[a_?ArrayQ,opts___?OptionQ]:=Catch[If[VectorQ[a],Throw[$Failed,$tag]];Module[{r,units},
        r=Table[If[#===$Failed, Throw[$Failed,$tag], #]&[iQuantityToValue[i,opts]], {i, a}];
        With[{pt=Append[ConstantArray[All,ArrayDepth[r]-1],2]},
        	units=Flatten[Part[r,Sequence@@pt]];
        	If[CompatibleUnitQ[units],
        		If[Length[Union[units]]===1,
        			{Part[r,Sequence@@Drop[pt,-1],1],First@units},
        			iQuantityToValue[a,System`TargetUnits->First[units]]
        	],
        	iFindInCompatibleUnits[units];$Failed]
        ]],$tag]
iQuantityToValue[___] := (Message[Internal`QuantityToValue::invld]; $Failed)

Options[iQuantityMatrixToValue] = {System`TargetUnits -> Automatic,"Compatibility"->All}
iQuantityMatrixToValue[mat_?MixedQuantityMatrixQ,opts___?OptionQ]:=With[
	{res=If[(System`TargetUnits/.Flatten[{opts}]/.Options[iQuantityToValue])=!=Automatic,
		StandardizeQuantities[mat,(System`TargetUnits/.Flatten[{opts}]/.Options[iQuantityToValue])],
		StandardizeQuantities[mat]]},
		If[Quiet[MatchQ[res,_?MixedQuantityMatrixQ]],{QuantityMagnitude[#], First[Flatten[QuantityUnit[#]]]}&[res],$Failed]]
iQuantityMatrixToValue[___]:=(Message[Internal`QuantityToValue::invld]; $Failed)

Options[iQuantityColumnwiseMatrixToValue] = {System`TargetUnits -> Automatic,"Compatibility"->All}
iQuantityColumnwiseMatrixToValue[mat_?MixedQuantityMatrixQ,opts___?OptionQ]:=Catch[
	With[{tu=System`TargetUnits/.Flatten[{opts}]/.Options[iQuantityToValue]},
		Module[{res,it=0,tlist=If[
			tu=!=Automatic,
			If[Length[tu]=!=Length[mat[[1]]],
				Message[Internal`QuantityToValue::invld];Throw[$Failed,$tag],
				tu],
			ConstantArray[Automatic,Length[mat[[1]]]]]},
	res=Table[it++;If[Quiet[MatchQ[#,{_List,_?KnownUnitQ}]],#,Throw[$Failed,$tag]]&[Internal`QuantityToValue[i,System`TargetUnits->tlist[[it]]]],{i,Transpose[mat]}];
	{Transpose[res[[All,1]]],res[[All,2]]}]],$tag]
iQuantityColumnwiseMatrixToValue[___]:=(Message[Internal`QuantityToValue::invld]; $Failed)

Options[iQuantityRowwiseMatrixToValue] = {System`TargetUnits -> Automatic,"Compatibility"->All}
iQuantityRowwiseMatrixToValue[mat_?MixedQuantityMatrixQ,opts___?OptionQ]:=Catch[
	With[{tu=System`TargetUnits/.Flatten[{opts}]/.Options[iQuantityToValue]},
		Module[{res,it=0,tlist=If[
			tu=!=Automatic,
			If[Length[tu]=!=Length[mat],
				Message[Internal`QuantityToValue::invld];Throw[$Failed,$tag],
				tu],
			ConstantArray[Automatic,Length[mat]]]},
	res=Table[it++;If[Quiet[MatchQ[#,{_List,_?KnownUnitQ}]],#,Throw[$Failed,$tag]]&[Internal`QuantityToValue[i,System`TargetUnits->tlist[[it]]]],{i,mat}];
	{res[[All,1]],res[[All,2]]}]],$tag]
iQuantityRowwiseMatrixToValue[___]:=(Message[Internal`QuantityToValue::invld]; $Failed)


scanForUnit[data_List] := 
 First[Cases[data, q_Quantity :> QuantityUnit[q], 1, 
    1] /. {} :> {"PureUnities"}]

replaceAutomatic[{data_List, unit_}] := 
 ReplaceAll[data, Automatic :> Quantity[Automatic, unit]]

preprocess[array_?MatrixQ] := With[{data = Transpose[array]},
  With[{units = scanForUnit /@ data}, 
   Transpose[replaceAutomatic /@ Transpose[{data, units}]]]]
preprocess[data_?VectorQ] := 
 With[{units = scanForUnit[data]}, replaceAutomatic[{data, units}]]

(*special version of QuantityToValue which allows for columnwise handling of 'Automatic' parameters*)
Internal`QuantityArrayToNumericArray[arg_,opts___]:=Internal`QuantityToValue[preprocess[arg],opts]

(*internal utility for taking matrices of values and units and threading them, not currently used*)
Internal`GenerateQuantityMatrix[args___]:=With[{res=iGenerateQuantityMatrix[args]},res/;res=!=$Failed]

iGenerateQuantityMatrix[mags_?MatrixQ, units_?MatrixQ] /; Dimensions[mags] === Dimensions[units] := If[
	And @@ (KnownUnitQ /@ Flatten[units]),
	Block[{Quantity},(* avoid messages during quantity threading *)
		Thread /@ Thread[Quantity[mags, units]]
	],
	$Failed
]

iGenerateQuantityMatrix[___]=$Failed

SimplifyUnits[unit_?KnownUnitQ]:=With[{res=UnitSimplify[Quantity[1,unit]]},
	If[
		QuantityMagnitude[res]=!=1,
		{False},
		{True,QuantityUnit[res]/."DimensionlessUnit"->"PureUnities"}]
]

SimplifyUnits[rules:{Rule[QuantityUnit[_],_?KnownUnitQ]..}]:=Catch[Module[{results},
	results=Table[
		With[{res=SimplifyUnits[Last[i]]},
			If[SameQ[res,{False}], Throw[{False},$tag]];
			Rule[First[i],Last[res]]]
		,{i,rules}];
		{True,results}
	],$tag]
	
SimplifyUnits[other___]:={False}

standardizeUnits[l_?Internal`QuantityVectorQ, unit_] := 
	If[unit === Automatic,
		UnitConvert[l, QuantityUnit[First[l]]],
		UnitConvert[l, unit]
		]

FindCurrencyUnitValue[currency_String] := Catch[
	With[{res =unitTableFValueLookup[currency]},
		If[
			SameQ[res, None],
			Throw[$Failed, $tag]
		];
		Module[
			{cc = Cases[res, "ExchangeRateToUSD"[x_] :> x]},
			{
				If[cc == {}, 
					cc = {"USD"},
					cc
				],
				res /. {"ExchangeRateToUSD"[_] -> 1, "USDollars" -> 1}
			}
		]
	],
	$tag
]
FindCurrencyUnitValue[___]:=$Failed

$DefaultPhysicalConstants = {
	"PlanckConstant", 
	"BoltzmannConstant",
	"ReducedPlanckConstant",
	"GravitationalConstant",
	"SpeedOfLight",
	"AvogadroConstant",
	"ElectricConstant",
	"ElementaryCharge",
	"RydbergConstant",
	"FaradayConstant",
	"FineStructureConstant",
	"MolarGasConstant",
	"MagneticConstant"
};

makeRule[constant_String] := 
 Rule[constant, 
  IndependentUnit[constant]*QuantityUnit[UnitConvert[constant]]]

makeIdentityRule[constant_String] := Rule[IndependentUnit[constant], 1]

PhysicalConstantsFactor[dimensions_List, constants_List] := 
 Times @@ Map[
   With[{cases = Cases[dimensions, {#, n_} :> n]},
     If[cases =!= {}, PhysicalConstantValue[#]^First[cases], 1]] &, 
   constants]

Clear[preprocessQuantity];
preprocessQuantity[q : Quantity[v_, u_], 
  constants_List: $DefaultPhysicalConstants] := 
 If[Cases[HoldForm[u], Alternatives @@ constants, -1] =!= {}, 
  With[{unit = ReleaseHold[HoldForm[u] /. makeRule /@ constants]}, 
   With[{ud = UnitDimensions[Quantity[1, unit]], 
     outUnit = unit /. makeIdentityRule /@ constants}, 
    With[{vm = PhysicalConstantsFactor[ud, constants]}, 
     UnitConvert[Quantity[v*vm, outUnit]]]]], q]

Clear[preprocessQuantityExpression];
SetAttributes[preprocessQuantityExpression,HoldAll];
preprocessQuantityExpression[expr_] := 
 ReleaseHold[Hold[expr] /. q_Quantity :> preprocessQuantity[q]]   
 
Clear[PhysicalConstantRefactor];
PhysicalConstantRefactor[dimensions_] := Times @@ Map[
   With[{unit = QuantityUnit[UnitConvert[#[[1, 1]]]]/#[[1, 1]]},
     unit^#[[2]]] &, dimensions]

Clear[doSomething];
doSomething[v_, constants_List] := Catch[
  With[{factored = FactorList[v]},
   With[{constantsWithPowers = 
      Cases[factored, {PhysicalConstantValue[_String], _}]},
    If[Union[(constantsWithPowers /. {PhysicalConstantValue[
            s_String], _} :> s)] =!= constants, 
     Throw[$Failed, $tag]];
    PhysicalConstantRefactor[constantsWithPowers]
    ]],
  $tag]


Clear[postprocessQuantity];
postprocessQuantity[q : Quantity[v_, u_]] := 
 With[{constants = 
    Union[Cases[v, 
      PhysicalConstantValue[const_String] :> const, -1]]}, 
  If[constants =!= {},
   With[{unitFactor = doSomething[v, constants]},
    If[unitFactor =!= $Failed,
     Quantity @@ {v /. PhysicalConstantValue[_String] :> 1, 
       u/unitFactor},
     $Failed]],
   q]]

postprocessQuantity[q : Quantity[v_, u_], "Numericalize"] := ReleaseHold[
  Hold[q] /. PhysicalConstantValue[s_String] :> QuantityMagnitude[UnitConvert[s]]
  ]

Clear[postprocessQuantityExpression];
postprocessQuantityExpression[expr_] := (((ReleaseHold[ Hold[expr] /. q_Quantity :> postprocessQuantity[q]]) /. 
    PhysicalConstantValue[s_String] :> placeholder[s]/Quantity[QuantityUnit[UnitConvert[s]]]) /. 
  placeholder -> Quantity)
   
SetAttributes[Internal`PreprocessSymbolicQuantityExpression,HoldAll];
Internal`PreprocessSymbolicQuantityExpression[expr_] := preprocessQuantityExpression[expr]
Internal`PostprocessSymbolicQuantityExpression[expr_] := postprocessQuantityExpression[expr]

QuantityUnits`UnitConvertArray[values_, unit_, targetunit_] := 
 bulkConvertArray[values, unit, targetunit]
 
bulkConvertArray[values_, unit_, targetunit_] := 
 If[CompatibleUnitQ[unit, targetunit],
  Module[{fun = uCF[unit, targetunit]},
   fun[values]
   ]
  ,
  $Failed
  ]
  
addToUERT[{cur_, "USD"}, value_] /; TrueQ[$addFun] := CompoundExpression[
  iSetExchangeRateFromUSD[cur, value],
  value]
addToUERT[_, value_] := value

validExchangeRateQ[n_] := TrueQ[n > 0]
validExchangeRateQ[___] := False

SetAttributes[QuantityUnits`BlockedCurrencyConversion, HoldFirst];
(*First argument is the value for DynamicCurrencyConversion, other args are held and will evaluate after setup*)
QuantityUnits`BlockedCurrencyConversion[eval_, dcc_:True] := 
 Block[{$addFun = True, $UserExchangeRateTable = {}, $DynamicCurrencyConversion = dcc},
  eval
  ]
