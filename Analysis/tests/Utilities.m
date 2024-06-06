(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Utilities: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*Numeric Utilities*)


(* ::Subsubsection::Closed:: *)
(*InvertData*)


DefineTests[InvertData,
	{
		Example[
			{Basic, "Invert simple list:"},
			InvertData[{{1, 2}, {3, 4}, {5, 6}}],
			{{1, 6}, {3, 4}, {5, 2}}
		],
		Example[
			{Basic, "Invert given data:"},
			InvertData[Transpose[{Range[0, 1, 0.01`], Sin[40 Range[0, 1, 0.01`]]}]],
			{{0.`, 0.0005169080060414277`}, {0.01`, -0.38890143430260904`}, {0.02`, -0.7168391828934814`}, {0.03`, -0.9315221779611849`}, {0.04`, -0.9990566950354637`}, {0.05`, -0.9087805188196403`}, {0.06`, -0.6749462725451095`}, {0.07`, -0.33447124214986323`}, {0.08`, 0.0588910514336215`}, {0.09`, 0.4430373513008935`}, {0.1`, 0.7573194033139697`}, {0.11`, 0.9521189818955574`}, {0.12`, 0.996681516841882`}, {0.13`, 0.8839715637261946`}, {0.14`, 0.6317835458783622`}, {0.15`, 0.2799324062049672`}, {0.16`, -0.11603229684445215`}, {0.17`, -0.49359644313256756`}, {0.18`, -0.7931509558431112`}, {0.19`, -0.9674027640254449`}, {0.2`, -0.9888413386173404`}, {0.21`, -0.854082000082239`}, {0.22`, -0.5844002848857203`}, {0.23`, -0.22237300609420452`}, {0.24`, 0.17484368922902116`}, {0.25`, 0.5445380188954113`}, {0.26`, 0.8283433770916951`}, {0.27`, 0.981453138072533`}, {0.28`, 0.9796946371573584`}, {0.29`, 0.8233455029747502`}, {0.3`, 0.5370898260064764`}, {0.31`, 0.16612108345435084`}, {0.32`, -0.23099291709549752`}, {0.33`, -0.591556606701183`}, {0.34`, -0.8586449068504554`}, {0.35000000000000003`, -0.9900904476888291`}, {0.36`, -0.9651408685432366`}, {0.37`, -0.7877351593692749`}, {0.38`, -0.48588178084775824`}, {0.39`, -0.10723674429340091`}, {0.4`, 0.2884202246711066`}, {0.41000000000000003`, 0.6386235903539915`}, {0.42`, 0.888083941587546`}, {0.43`, 0.9974169740476376`}, {0.44`, 0.9493614059241654`}, {0.45`, 0.7515041547777176`}, {0.46`, 0.43508253007793496`}, {0.47000000000000003`, 0.05005254888440891`}, {0.48`, -0.342798020813854`}, {0.49`, -0.6814467120620942`}, {0.5`, -0.9124283427215862`}, {0.51`, -0.9992759921366278`}, {0.52`, -0.928278326071199`}, {0.53`, -0.7106443148999385`}, {0.54`, -0.38073358364889864`}, {0.55`, 0.009368217296445214`}, {0.56`, 0.3980725911274775`}, {0.5700000000000001`, 0.7240116640502888`}, {0.58`, 0.9357268232005803`}, {0.59`, 0.9997929001426692`}, {0.6`, 0.9060952700126653`}, {0.61`, 0.6694267283840657`}, {0.62`, 0.32715203411076355`}, {0.63`, -0.06669116451943347`}, {0.64`, -0.44992368626934787`}, {0.65`, -0.7620415424735613`}, {0.66`, -0.9537681864866566`}, {0.67`, -0.9948341969055177`}, {0.68`, -0.8787561536446812`}, {0.6900000000000001`, -0.62386022741035`}, {0.7000000000000001`, -0.2703888803018242`}, {0.71`, 0.12585253410247044`}, {0.72`, 0.5023062090266125`}, {0.73`, 0.7995383866656552`}, {0.74`, 0.9706226417132268`}, {0.75`, 0.9885485320989033`}, {0.76`, 0.8504859538853694`}, {0.77`, 0.5782319524517733`}, {0.78`, 0.21476944830192568`}, {0.79`, -0.18251882097454664`}, {0.8`, -0.5509097732356492`}, {0.81`, -0.8322425773017422`}, {0.8200000000000001`, -0.9821009693580994`}, {0.8300000000000001`, -0.9768256043862172`}, {0.84`, -0.8172493465204004`}, {0.85`, -0.5285657781139824`}, {0.86`, -0.15635168704236857`}, {0.87`, 0.240628505959816`}, {0.88`, 0.5997003572203067`}, {0.89`, 0.8641743166989976`}, {0.9`, 0.9922957614491571`}, {0.91`, 0.9638371324798022`}, {0.92`, 0.7832914215566914`}, {0.93`, 0.4791628265944564`}, {0.9400000000000001`, 0.09946656555633104`}, {0.9500000000000001`, -0.29585167070334395`}, {0.96`, -0.6443798249388258`}, {0.97`, -0.8910929650353993`}, {0.98`, -0.9970405109017637`}, {0.99`, -0.9454956746208667`}, {1.`, -0.7445962524733074`}}
		],
		Example[
			{Additional, "No change in inverting singleton list:"},
			InvertData[{{0, 0}}],
			{{0, 0}}
		]
	}];



(* ::Subsubsection::Closed:: *)
(*LinearFunctionQ*)


DefineTests[LinearFunctionQ, {
	Example[
		{Basic, "Test whether one function is a linear function:"},
		LinearFunctionQ[(75# + 2)&],
		True
	],
	Example[
		{Basic, "A non-linear function will not pass LinearFunctionQ:"},
		LinearFunctionQ[(75#^2 + 4# + 2)&],
		False
	],
	Example[
		{Attributes, Listable, "Test whether several functions is are linear functions:"},
		LinearFunctionQ[{(75# + 2)&, (3# - 1)&}],
		{True, True}
	],
	Example[
		{Additional, "A function with zero slope will not pass LinearFunctionQ:"},
		LinearFunctionQ[(0# + 7)&],
		False
	],
	Test[
		"A numeric zero slope:",
		LinearFunctionQ[(0.# + 7)&],
		False
	],
	Example[
		{Options, Log, "Use the Log Option to allow logarithmic functions to pass LinearFunctionQ:"},
		LinearFunctionQ[(75Log10[#] + 2)&, Log -> True],
		True
	],
	Test[
		"Unsimplified linear function:",
		LinearFunctionQ[(3# + 7 - # + 1 / 4)&],
		True
	],
	Test[
		"Another unsimplified linear function:",
		LinearFunctionQ[(2#^2 + 3# + 7 - #^2 / 0.5)&],
		True
	],
	Test[
		"Unsimplified linear function with log:",
		LinearFunctionQ[(Log[2#^2 + 3# - #^2 / 0.5] + 4)&, Log -> True],
		True
	],
	Example[
		{Additional, "The function is only checking linearity with respect to the first variable:"},
		LinearFunctionQ[#2&],
		False
	],
	Example[
		{Additional, "The function is only checking linearity with respect to the first variable:"},
		LinearFunctionQ[#1 + #2^2&],
		True
	],
	Test[
		"The function will pull out the appropriate log base automatically:",
		LinearFunctionQ[75 Log[2, #1] + 2&, Log -> True],
		True
	]
}];

(* ::Subsubsection::Closed:: *)
(*LinearFunctionQ*)