Unprotect[Quantity];
(*generic UpValue pattern*)
Quantity/:f_[q_Quantity,args___]/;quantityUpValueFunctionQ[f] := With[
	{res = Catch[dispatchQuantityUpValueFunction[f][q,args],"QuantityUpValueFlag"]},
	res /; res =!= "QuantityUpValueReturnUnevaluated"
]

(*---------Functions which have Quantity UpValues-----------*)
(*default value is False*)
quantityUpValueFunctionQ[_]=False;
(*trig functions*)
quantityUpValueFunctionQ[Sin]=True;
quantityUpValueFunctionQ[Cos]=True;
quantityUpValueFunctionQ[Tan]=True;
quantityUpValueFunctionQ[Csc]=True;
quantityUpValueFunctionQ[Cot]=True;
quantityUpValueFunctionQ[ArcSin]=True;
quantityUpValueFunctionQ[ArcCos]=True;
quantityUpValueFunctionQ[ArcTan]=True;
quantityUpValueFunctionQ[ArcCsc]=True;
quantityUpValueFunctionQ[ArcSec]=True;
quantityUpValueFunctionQ[ArcCot]=True;
quantityUpValueFunctionQ[Haversine]=True;
quantityUpValueFunctionQ[InverseHaversine]=True;
(*interval functions*)
quantityUpValueFunctionQ[IntervalMemberQ]=True;
quantityUpValueFunctionQ[IntervalUnion]=True;
quantityUpValueFunctionQ[IntervalIntersection]=True;
(*numerical functions*)
quantityUpValueFunctionQ[FractionalPart]=True;
quantityUpValueFunctionQ[IntegerPart]=True;
quantityUpValueFunctionQ[Round]=True;
quantityUpValueFunctionQ[Rescale]=True;
quantityUpValueFunctionQ[Clip]=True;
quantityUpValueFunctionQ[Mod]=True;
quantityUpValueFunctionQ[PowerMod]=True;
quantityUpValueFunctionQ[Quotient]=True;
quantityUpValueFunctionQ[QuotientRemainder]=True;
quantityUpValueFunctionQ[Divisible]=True;
quantityUpValueFunctionQ[Sign]=True;
quantityUpValueFunctionQ[Abs]=True;
quantityUpValueFunctionQ[Re]=True;
quantityUpValueFunctionQ[Im]=True;
quantityUpValueFunctionQ[Norm]=True;
quantityUpValueFunctionQ[Arg]=True;
quantityUpValueFunctionQ[Conjugate]=True;
quantityUpValueFunctionQ[Unitize]=True;
quantityUpValueFunctionQ[Fibonacci]=True;
quantityUpValueFunctionQ[Rationalize]=True;
quantityUpValueFunctionQ[Surd]=True;
quantityUpValueFunctionQ[Floor]=True;
quantityUpValueFunctionQ[Ceiling]=True;
(*predicates*)
quantityUpValueFunctionQ[CoprimeQ]=True;
quantityUpValueFunctionQ[EvenQ]=True;
quantityUpValueFunctionQ[OddQ]=True;
quantityUpValueFunctionQ[PrimeQ]=True;
(*list operations*)
quantityUpValueFunctionQ[Range]=True;

(*---------Dispatch Functions for Quantity UpValues-----------*)
(*trig functions*)
dispatchQuantityUpValueFunction[Sin]=quantityTrigFunction[Sin];
dispatchQuantityUpValueFunction[Cos]=quantityTrigFunction[Cos];
dispatchQuantityUpValueFunction[Tan]=quantityTrigFunction[Tan];
dispatchQuantityUpValueFunction[Csc]=quantityTrigFunction[Csc];
dispatchQuantityUpValueFunction[Cot]=quantityTrigFunction[Cot];
dispatchQuantityUpValueFunction[ArcSin]=quantityTrigFunction[ArcSin];
dispatchQuantityUpValueFunction[ArcCos]=quantityTrigFunction[ArcCos];
dispatchQuantityUpValueFunction[ArcTan]=quantityTrigFunction[ArcTan];
dispatchQuantityUpValueFunction[ArcCsc]=quantityTrigFunction[ArcCsc];
dispatchQuantityUpValueFunction[ArcSec]=quantityTrigFunction[ArcSec];
dispatchQuantityUpValueFunction[ArcCot]=quantityTrigFunction[ArcCot];
dispatchQuantityUpValueFunction[Haversine]=quantityTrigFunction[Haversine];
dispatchQuantityUpValueFunction[InverseHaversine]=quantityTrigFunction[InverseHaversine];
(*interval functions*)
dispatchQuantityUpValueFunction[IntervalMemberQ]=quantityIntervalMemberQ;
dispatchQuantityUpValueFunction[IntervalUnion]=quantityIntervalUnion;
dispatchQuantityUpValueFunction[IntervalIntersection]=quantityIntervalIntersection;
(*numerical functions*)
dispatchQuantityUpValueFunction[FractionalPart]=quantityFractionalPart;
dispatchQuantityUpValueFunction[IntegerPart]=quantityIntegerPart;
dispatchQuantityUpValueFunction[Round]=quantityRound;
dispatchQuantityUpValueFunction[Rescale]=quantityRescale;
dispatchQuantityUpValueFunction[Clip]=quantityClip;
dispatchQuantityUpValueFunction[Mod]=quantityMod;
dispatchQuantityUpValueFunction[PowerMod]=quantityPowerMod;
dispatchQuantityUpValueFunction[Quotient]=quantityQuotient;
dispatchQuantityUpValueFunction[QuotientRemainder]=quantityQuotientRemainder;
dispatchQuantityUpValueFunction[Divisible]=quantityDivisible;
dispatchQuantityUpValueFunction[Sign]=quantitySign;
dispatchQuantityUpValueFunction[Abs]=quantityAbs;
dispatchQuantityUpValueFunction[Re]=quantityRe;
dispatchQuantityUpValueFunction[Im]=quantityIm;
dispatchQuantityUpValueFunction[Norm]=quantityNorm;
dispatchQuantityUpValueFunction[Arg]=quantityArg;
dispatchQuantityUpValueFunction[Conjugate]=quantityConjugate;
dispatchQuantityUpValueFunction[Unitize]=quantityUnitize;
dispatchQuantityUpValueFunction[Fibonacci]=quantityFibonacci;
dispatchQuantityUpValueFunction[Rationalize]=quantityRationalize;
dispatchQuantityUpValueFunction[Surd]=quantitySurd;
dispatchQuantityUpValueFunction[Floor]=quantityFloor;
dispatchQuantityUpValueFunction[Ceiling]=quantityCeiling;
(*predicates*)
dispatchQuantityUpValueFunction[CoprimeQ]=quantityCoprimeQ;
dispatchQuantityUpValueFunction[EvenQ]=quantityEvenQ;
dispatchQuantityUpValueFunction[OddQ]=quantityOddQ;
dispatchQuantityUpValueFunction[PrimeQ]=quantityPrimeQ;
(*list operations*)
dispatchQuantityUpValueFunction[Range]=quantityRange;
(*catch-all for anything that slips through for some reason...*)
dispatchQuantityUpValueFunction[_]:= Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

(*---------Implementation Functions for Quantity UpValues-----------*)
(*----Most functions here make call-backs to functions elsewhere----*)
(*trig functions*)
trigOperableQ[x_?QuantityQ] := And[
	$AutomaticUnitTimes == True,
	MemberQ[{{}, {{"AngleUnit", 1}}, {{"SolidAngleUnit", 1}}}, UnitDimensions[x]]
]
trigOperableQ[__] := False

quantityTrigFunction[fun_][q_?trigOperableQ] := Block[{$AutomaticUnitTimes = False, res}, 
	res = evaluateTrigFunction[fun[q]];
	If[res === $Failed, 
		Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"],
		res]
]
quantityTrigFunction[_][__] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

(*interval functions*)
quantityIntervalMemberQ[x_?QuantityQ, y_] := TrueQ[QuantityIntervalQ[x, y]]
quantityIntervalMemberQ[__] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

quantityIntervalUnion[x_?QuantityQ, y_?QuantityQ] := With[
	{res = QuantityIntervalUnion[x, y]}, 
	If[res === $Failed, 
		Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"],
		res]
]
quantityIntervalUnion[__] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

quantityIntervalIntersection[x_?QuantityQ, y_?QuantityQ] := With[
	{res = QuantityIntervalIntersection[x, y]},
	If[res === $Failed,
		Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"],
		res]
]
quantityIntervalIntersection[__] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

	
(*numerical functions*)
quantityFractionalPart[x_?QuantityQ] := With[{res = iQuantityFractionalPart[x]}, 
	If[res === $Failed, 
		Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"],
		res]
]
quantityFractionalPart[__] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

quantityIntegerPart[x_?QuantityQ] := With[{res = iQuantityIntegerPart[x]}, 
	If[res === $Failed, 
		Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"],
		res]
]
quantityIntegerPart[__] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

quantityRound[x_?QuantityQ, y___] := With[{res = iQuantityRound[x,y]}, 
	If[res === $Failed, 
		Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"],
		res]
]
quantityRound[__] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

quantityRescale[x_?QuantityQ,y___] := With[{res = iQuantityRescale[x,y]}, 
	If[res === $Failed, 
		Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"],
		res]
]
quantityRescale[__] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

quantityClip[x_?QuantityQ,y___] := With[{res = iQuantityClip[x,y]}, 
	If[res === $Failed, 
		Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"],
		res]
]
quantityClip[__] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

quantityMod[x_?QuantityQ,y__] /; CompatibleUnitQ[x,y] := With[{res = iQuantityMod[x,y]}, 
	If[res === $Failed, 
		Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"],
		res]
]
quantityMod[__] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

quantityPowerMod[x_?QuantityQ,y__] /; CompatibleUnitQ[x,y] := With[{res = iQuantityPowerMod[x,y]}, 
	If[res === $Failed, 
		Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"],
		res]
]
quantityPowerMod[__] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

quantityQuotient[x_?QuantityQ,y__] /; CompatibleUnitQ[x,y] := With[{res = iQuantityQuotient[x,y]}, 
	If[res === $Failed, 
		Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"],
		res]
]
quantityQuotient[__] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

quantityQuotientRemainder[x_?QuantityQ,y__] /; CompatibleUnitQ[x,y] := With[{res = iQuantityQuotientRemainder[x,y]}, 
	If[res === $Failed, 
		Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"],
		res]
]
quantityQuotientRemainder[__] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

quantityDivisible[x_?QuantityQ,y__] := With[{res = iQuantityDivisible[x,y]}, 
	If[res === $Failed, 
		Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"],
		res]
]
quantityDivisible[__] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

quantityDivisible[x_?QuantityQ,y__] := With[{res = iQuantityDivisible[x,y]}, 
	If[res === $Failed, 
		Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"],
		res]
]

quantitySign[(Quantity[m_,unit_])?QuantityQ] := Sign[m/.None->1]
quantitySign[__] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

quantityAbs[(Quantity[m_,unit_])?QuantityQ] := With[{mag=Abs[m]/.Abs[None]->None}, Quantity[mag,unit]]
quantityAbs[__] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

quantityRe[HoldPattern[(Quantity[mag_, unit_])?QuantityQ]] := Quantity[Re[mag], unit]
quantityRe[__] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

quantityIm[HoldPattern[(Quantity[mag_, unit_])?QuantityQ]]:= Quantity[Im[mag], unit]
quantityIm[__] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

quantityNorm[HoldPattern[(Quantity[mag_, unit_])?QuantityQ]]:= Quantity[Norm[mag], unit]
quantityNorm[HoldPattern[(Quantity[mag_, unit_])?QuantityQ], p_]:= Quantity[Norm[mag, p], unit]
quantityNorm[__] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

quantityArg[HoldPattern[(Quantity[mag_?NumericQ, __])?QuantityQ]]:= Arg[mag]
quantityArg[__] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

quantityConjugate[HoldPattern[(Quantity[mag_, unit_])?QuantityQ]]:= Quantity[Conjugate[mag], unit]
quantityConjugate[__] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

quantityUnitize[HoldPattern[(Quantity[mag_, unit_])?QuantityQ]] := Quantity[Unitize[mag], unit]
quantityUnitize[__] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

quantityFibonacci[HoldPattern[(Quantity[mag_, unit_])?QuantityQ]] := Quantity[Fibonacci[mag],unit]
quantityFibonacci[HoldPattern[(Quantity[mag_, unit_])?QuantityQ], p_]:= Quantity[Fibonacci[mag,p],unit]
quantityFibonacci[__] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

quantityRationalize[x_?QuantityQ, y_?QuantityQ] := With[{res = iQuantityRationalize[x,y]}, 
	If[res === $Failed, 
		Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"],
		res]
]
quantityRationalize[__] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

quantitySurd[x_?QuantityQ, y_] := iQuantitySurd[x,y]
quantitySurd[__]:= Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

quantityFloor[x_?QuantityQ, y___] := iQuantityFloor[x,y]
quantityFloor[__]:= Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

quantityCeiling[x_?QuantityQ, y___] := iQuantityCeiling[x,y]
quantityCeiling[__]:= Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

(*predicates*)
quantityCoprimeQ[x_?QuantityQ, y___] := With[{res = iQuantityCoprimeQ[x,y]}, 
	If[res === $Failed, 
		Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"],
		res]
]
quantityCoprimeQ[__] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

quantityEvenQ[HoldPattern[(Quantity[mag_, _])?QuantityQ]] := EvenQ[mag]
quantityEvenQ[__] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

quantityOddQ[HoldPattern[(Quantity[mag_, _])?QuantityQ]] := OddQ[mag]
quantityOddQ[__] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

quantityPrimeQ[HoldPattern[(Quantity[mag_, _])?QuantityQ]] := PrimeQ[mag]
quantityPrimeQ[__] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

(*list operations*)
quantityRange[HoldPattern[x:(Quantity[_,unit_])?QuantityQ]] := With[
	{res = iGenerateQuantityRange[Quantity[1,unit],x]}, 
	If[res === $Failed, 
		Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"],
		res]
]
quantityRange[x_?QuantityQ, y__] := With[
	{res = iGenerateQuantityRange[x,y]}, 
	If[res === $Failed, 
		Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"],
		res]
]
quantityRange[__] := Throw["QuantityUpValueReturnUnevaluated","QuantityUpValueFlag"]

