(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Math: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*Probability and Statistics*)


(* ::Subsubsection::Closed:: *)
(*SumSquaredError*)


DefineTests[SumSquaredError,
{
		Example[
			{Basic,"Compute sum of squares of differences between two data sets:"},
			SumSquaredError[Map[#^2&,Range[-10,10]],Map[1.01#^2&,Range[-10,10]]],
			5.066600000000012`
		],
		Example[
			{Additional,"SSE is 0 if data sets are identical:"},
			SumSquaredError[Map[#^2&,Range[-10,10]],Map[#^2&,Range[-10,10]]],
			0
		],
		Example[
			{Basic,"Compute SSE between given Y points and given function applied to X points:"},
			SumSquaredError[
				{{0.1989`,1.0221799999999999`},{0.1987454545454546`,1.0156599999999998`},{0.19875454545454543`,1.013`},{0.19554545454545452`,0.99336`},{0.1918727272727273`,0.9683400000000002`}},
				0.1` +4.9` #1&
			],
			0.019204928990082738`
		],
		Example[
			{Basic,"Compute SSE between given Y points and given model applied to X points:"},
			SumSquaredError[
				{{0.1989`,1.0221799999999999`},{0.1987454545454546`,1.0156599999999998`},{0.19875454545454543`,1.013`},{0.19554545454545452`,0.99336`},{0.1918727272727273`,0.9683400000000002`}},
				A x+B,
				{A->4.9`,B->0.1`},
				x
			],
			0.019204928990082738`
		],
		Example[
			{Additional,"Compute SSE between given Y points and given model applied to X points:"},
			SumSquaredError[
				{{-3.`,23.546157360816583`},{-2.9`,24.402089641000764`},{-2.8`,21.352023413344682`},{-2.7`,20.381712856972936`},{-2.6`,17.798355988800676`},{-2.5`,17.646339550752092`},{-2.4`,16.07569557855101`},{-2.3`,16.33414635838127`},{-2.2`,13.250215383973472`},{-2.1`,14.284129687090095`},{-2.`,11.166355525097464`},{-1.9`,9.678430956040916`},{-1.7999999999999998`,10.094661760430562`},{-1.7`,8.096064691236558`},{-1.5999999999999999`,7.71828428863973`},{-1.5`,8.859277983518513`},{-1.4`,6.125916424196269`},{-1.2999999999999998`,7.642111143052418`},{-1.2`,4.7067274665835335`},{-1.0999999999999999`,4.758649169099828`},{-1.`,4.848685615189919`},{-0.8999999999999999`,3.291991980124317`},{-0.7999999999999998`,4.003722820690158`},{-0.6999999999999997`,2.723771157070937`},{-0.5999999999999996`,4.651888800713966`},{-0.5`,4.542696187093481`},{-0.3999999999999999`,1.719170645271576`},{-0.2999999999999998`,3.2544416556097047`},{-0.19999999999999973`,4.193298640779277`},{-0.09999999999999964`,4.2380419369185605`},{0.`,2.8967749247899564`},{0.10000000000000009`,3.800483398415004`},{0.20000000000000018`,5.317806729062614`},{0.30000000000000027`,4.375521260453884`},{0.40000000000000036`,3.6294216971695237`},{0.5`,5.592657294549707`},{0.6000000000000001`,6.778997934346473`},{0.7000000000000002`,6.095139099689176`},{0.8000000000000003`,7.450555343670381`},{0.9000000000000004`,7.754827270818378`},{1.`,9.573691598551784`},{1.1000000000000005`,9.049652452105919`},{1.2000000000000002`,9.855570670096693`},{1.2999999999999998`,11.189935768858266`},{1.4000000000000004`,12.669386650951143`},{1.5`,14.103231617688099`},{1.6000000000000005`,14.608633081433211`},{1.7000000000000002`,17.493864963717886`},{1.8000000000000007`,17.4924997711477`},{1.9000000000000004`,19.91646487573864`},{2.`,19.72847904726839`},{2.1000000000000005`,17.771931219673213`},{2.2`,22.10575943611327`},{2.3000000000000007`,23.455980381061355`},{2.4000000000000004`,24.43662346893549`},{2.5`,27.46069928146362`},{2.6000000000000005`,29.42772435835404`},{2.7`,31.391758685843577`},{2.8000000000000007`,35.130846496729156`},{2.9000000000000004`,35.58658272194542`},{3.`,37.89361968467397`}},
				A x^2+B x+C,
				{A->3.`,B->2.1`,C->5.5`},
				x
			],
			247.76558648578282`
		]
}];


(* ::Subsubsection::Closed:: *)
(*RSquared*)


DefineTests[RSquared,
{
		Example[
			{Basic,"Compute R-Squared between two data sets:"},
			RSquared[Range[-1,1,0.01`]^2+1,Range[-1,1,0.01`]^2+1+RandomReal[{-0.1`,0.1`},201]],
			_?NumericQ
		],
		Example[
			{Additional,"Compute R-Squared between two data sets:"},
			RSquared[Range[-1,1,0.01`]^2+1,Range[-1,1,0.01`]^2+1+RandomReal[{-0.05`,0.05`},201]],
			_?NumericQ
		],
		Example[
			{Basic,"Compute R-Squared between given Y points and given function applied to X points:"},
			RSquared[Transpose[{Range[-1,1,0.01`],Range[-1,1,0.01`]^2+1+RandomReal[{-0.1`,0.1`},201]}],#1^2+1&],
			_?NumericQ
		]
}];


(* ::Subsubsection::Closed:: *)
(*ConfidenceInterval*)


DefineTests[ConfidenceInterval,{

	Example[{Basic,"Compute 95% confidence interval for normal distribution:"},
		ConfidenceInterval[NormalDistribution[5,0.5]],
		{4.020018007729973`,5.979981992270027`},
		EquivalenceFunction->RoundMatchQ[10]
	],
	Example[{Basic,"Compute a different confidence level:"},
		ConfidenceInterval[NormalDistribution[5,0.5],75Percent],
		{4.424825309811996`,5.575174690188004`},
		EquivalenceFunction->RoundMatchQ[10]
	],
	Example[{Basic,"Compute 95% confidence interval for empirical distribution:"},
		ConfidenceInterval[EmpiricalDistribution[RandomVariate[NormalDistribution[5,0.5],100]]],
		{_?NumericQ,_?NumericQ}
	],
	Test["Compute 95% confidence interval for empirical distribution:",
		ConfidenceInterval[EmpiricalDistribution[{4.583191767203528`,4.882947325707477`,5.430624138496181`,4.688872940381477`,4.357972651618994`,5.655977962811695`,5.621496238921983`,4.952914863588532`,5.265754218071079`,4.666203173457432`,4.85028370886545`,5.5586187385804475`,5.0204445716238855`,5.325808042108589`,4.336694344224839`,4.210790723325978`,4.56156711825084`,4.5322312716577065`,4.6613409272570925`,5.187990985600197`,4.987674365550613`,4.485025233922878`,6.028696506550364`,4.46021599145205`,5.048371892048743`,4.696693372938526`,5.536062127291305`,5.640103910954112`,6.040091209930977`,5.655354175188813`,5.465898892282389`,5.086292625220639`,5.390469818664204`,4.5578238130317414`,4.030202124412162`,5.168627856243562`,5.169925946225429`,4.566628499369171`,5.917662981336145`,5.01818345316328`,4.568079724792037`,4.833853676977755`,5.678344309642911`,5.178028875031884`,4.864830187099486`,4.522872918448649`,4.703720856021945`,4.943173823904286`,4.627857831081637`,4.407275216054072`,4.6060260555464385`,3.775959346015714`,4.6876734473805`,5.622031930366861`,5.647983664290471`,4.4481428188745085`,5.272196397116788`,4.960321751207607`,4.600119338085349`,4.743602603416836`,4.986840376852222`,5.212559231370383`,4.84540935731523`,4.662065067859641`,5.670360976462443`,6.0125625260649755`,5.1239886664862295`,5.054704563171596`,5.334625659515873`,4.29167611572583`,5.3352489334590505`,5.11216714665946`,6.332004134249135`,4.8011367096290165`,4.490716688392284`,4.558723537067649`,5.0558262769747735`,4.7371076221471595`,4.295903710003564`,5.327533399945595`,5.194763615255908`,5.7845757496739285`,5.389793917003488`,4.769740195736789`,4.1333919121552`,5.307586471525032`,5.295600443352212`,4.634696269826588`,4.849557311632591`,4.674508470474692`,5.115979523621443`,4.947079396605033`,5.648082599213925`,5.766266854546689`,4.945300790948734`,5.035916583717832`,4.868095085382216`,4.711545576540841`,5.544722925840807`,5.298230631974605`}]],
		{4.1333919121552`,6.028696506550364`},
		EquivalenceFunction->RoundMatchQ[10]
	],

	Example[{Basic,"Compute 95% confidence interval for a set of values:"},
		ConfidenceInterval[RandomVariate[NormalDistribution[5,0.5],100]],
		{_?NumericQ,_?NumericQ}
	]


}];


(* ::Subsubsection::Closed:: *)
(*CoefficientOfVariation*)


DefineTests[CoefficientOfVariation,{

	Example[{Basic,"Compute coefficient of variation from a mean and standard deviation:"},
		CoefficientOfVariation[5.0,0.5],
		0.1
	],
	Example[{Basic,"Use the mean and standard deviation of the given distribution:"},
		CoefficientOfVariation[NormalDistribution[5.0,0.5]],
		0.1
	],
	Example[{Basic,"Interprets PlusMinus as mu\[PlusMinus]sigma:"},
		CoefficientOfVariation[5.0 \[PlusMinus] 0.5],
		0.1
	],
	Example[{Additional,"Given data distribution:"},
		CoefficientOfVariation[EmpiricalDistribution[{1.,2.,3.,4.,5.}]],
		0.471404,
		EquivalenceFunction->RoundMatchQ[3]
	]


}];


(* ::Subsection:: *)
(*Distribution Manipulation*)


(* ::Subsection::Closed:: *)
(*Distribution Sampling*)


(* ::Subsubsection::Closed:: *)
(*SampleFromDistribution*)


DefineTests[SampleFromDistribution,{

	Example[{Basic,"Sample from a distribution:"},
		SampleFromDistribution[NormalDistribution[0,1],25],
		{_?NumericQ..}
	],
	Example[{Basic,"Sample from two distributions:"},
		SampleFromDistribution[{NormalDistribution[-2,2],ExponentialDistribution[1]},25],
		{{_?NumericQ..},{_?NumericQ..}}
	],
	Example[{Basic,"View the distribution samples:"},
		Histogram[SampleFromDistribution[{NormalDistribution[-2,2],ExponentialDistribution[1]},5000],30],
		ValidGraphicsP[]
	],

	Example[{Options,SamplingMethod,"Sample from two normal distributions using each method, sum the resulting sample sets, then compare the result:"},
		Module[{naive,lhc,sobol},
			naive=Plus@@SampleFromDistribution[{NormalDistribution[-2,2],ExponentialDistribution[1]},6000,SamplingMethod->Random];
			lhc=Plus@@SampleFromDistribution[{NormalDistribution[-2,2],ExponentialDistribution[1]},6000,SamplingMethod->LatinHypercube];
			sobol=Plus@@SampleFromDistribution[{NormalDistribution[-2,2],ExponentialDistribution[1]},6000,SamplingMethod->Sobol];
			Grid[{{Histogram[naive,30,PlotLabel->"Random"],Histogram[lhc,30,PlotLabel->"LatinHypercube"],Histogram[sobol,30,PlotLabel->"Sobol"]}}]
		],
		Grid[{{ValidGraphicsP[], ValidGraphicsP[], ValidGraphicsP[]}}]
	]

}];


(* ::Subsection::Closed:: *)
(*Uncertainty Propagation & Prediction*)


(* ::Subsubsection:: *)
(*PropagateUncertainty*)


DefineTests[PropagateUncertainty,{
	Example[{Basic,"Transform a distribution:"},
		PropagateUncertainty[#^2&,NormalDistribution[]],
		ChiSquareDistribution[1]
	],

	Example[{Basic,"Add two uncertain values:"},
		PropagateUncertainty[A+B,{A\[Distributed]NormalDistribution[2,1],B\[Distributed]NormalDistribution[5,3]}],
		NormalDistribution[7,Sqrt[10]]
	],

	Example[{Basic,"Add two quantity distributions:"},
		PropagateUncertainty[A+B, {A\[Distributed]QuantityDistribution[NormalDistribution[2,1],"Meters"],B\[Distributed]QuantityDistribution[NormalDistribution[100,10],"Centimeters"]}],
		QuantityDistribution[NormalDistribution[300, 10 Sqrt[101]], "Centimeters"]
	],

	Example[{Basic,"Add one certain volume to two uncertain volumes:"},
		PropagateUncertainty[A+B+C,{A->25Microliter,B\[Distributed]NormalDistribution[100Microliter,2.5Microliter],C\[Distributed]NormalDistribution[50Microliter,2.5Microliter]}],
		NormalDistribution[Quantity[175.,"Microliters"],Quantity[3.5355339059327378`,"Microliters"]]
	],

	Example[{Basic,"Compute uncertainty in the volume of a sphere, based on uncertainty in radius measurement:"},
		PropagateUncertainty[4/3*Pi*R^3,{R\[Distributed]NormalDistribution[10.Centimeter,2.5Millimeter]}],
		If[$VersionNumber >= 12.0,
			QuantityDistribution[_TransformedDistribution,"Feet"^3],
			QuantityDistribution[_TransformedDistribution,"Millimeters"^3]
		]
	],

(*
	Example[{Basic,"Compute concentration from uncertain amount and volume:"},
		PropagateUncertainty[Amount/Volume,{Amount\[Distributed]NormalDistribution[10Micromole,25Nanomole],Volume\[Distributed]NormalDistribution[50.Milliliter,150.Microliter]}],
		_?uncertaintyPacketQ
	],
*)

	Example[{Additional,"Given list of constant values, no distributions:"},
		PropagateUncertainty[A+B,{A->1,B->2}],
		DataDistribution["Empirical", {{1}, {3}, False}, 1, 1]
	],

	Example[{Additional,"Given list of constant values, no distributions, using Empirical method:"},
		PropagateUncertainty[A+B,{A->1,B->2},Method->Empirical],
		_DataDistribution
	],

	Example[{Additional,"Can mix certain and uncertain values in any arrangement:"},
		PropagateUncertainty[C+A/(B+G),{A\[Distributed]NormalDistribution[3,1],B->4,C\[Distributed]NormalDistribution[5,2],G->6}],
		NormalDistribution[53/10,Sqrt[401]/10]
	],

	Example[{Additional,"Given multivariate distribution:"},
		PropagateUncertainty[A+B,{{A,B}\[Distributed]MultinormalDistribution[{3,5},{{2,1/2},{1/2,1}}]}],
		NormalDistribution[8,2]
	],

	Example[{Additional,"Given mixture of univariate and multivariate distributions, using Parametric method:"},
		PropagateUncertainty[A+B*C,{{A,B}\[Distributed]MultinormalDistribution[{3,5},{{2,1/2},{1/2,1}}],C\[Distributed]NormalDistribution[10,3]},Method->Parametric],
		NormalDistribution[53,Sqrt[337]]
	],

	Example[{Additional,"Use multivariate distributions to correlate variables, which affects the variance of the resulting distribution:"},
		{
			PropagateUncertainty[A+B,{{A,B}\[Distributed]MultinormalDistribution[{3,5},{{2,1/2},{1/2,1}}]}],
			PropagateUncertainty[A+B,{A\[Distributed]NormalDistribution[3,2],B\[Distributed]NormalDistribution[5,1]}]
		},
		{NormalDistribution[8,2],NormalDistribution[8,Sqrt[5]]}
	],


	Example[{Additional,"Given quantity expression, return QuantityDistribution:"},
		PropagateUncertainty[Quantity[A+B,"Meters"],{A\[Distributed]NormalDistribution[3,2],B\[Distributed]NormalDistribution[5,4]}],
		QuantityDistribution[NormalDistribution[8, 2*Sqrt[5]], "Meters"]
	],

	Test["Make sure fixed-value rules work in empirical case:",
		PropagateUncertainty[
			A/(C+2)+2*B,
			{
				A\[Distributed]UniformDistribution[{0.5,5}],
				B->2.5,
				C->0.1
			},
			Method->Empirical,
			NumberOfSamples->15,
			Output->All
		],
		_?(And[
			uncertaintyPacketQ[#],
			MatchQ[Lookup[#,{Distribution,Method,NumberOfSamples,Mean,StandardDeviation}],{_DataDistribution,Empirical,_Integer,_?NumericQ,_?NumericQ}]
		]&)
	],

	Example[{Options,Method,"Sample to obtain empirical distribution:"},
		PropagateUncertainty[A+B,{A\[Distributed]NormalDistribution[2,1],B\[Distributed]NormalDistribution[5,3]},Method->Empirical,Output->All],
		_?(And[
			uncertaintyPacketQ[#],
			MatchQ[Lookup[#,{Distribution,Method,NumberOfSamples}],{_DataDistribution,Empirical,_Integer}]
		]&)
	],

	Example[{Options,Method,"Sample from mixture of univariate and multivariate distributions:"},
		PropagateUncertainty[A+B*C,{{A,B}\[Distributed]MultinormalDistribution[{3,5},{{2,1/2},{1/2,1}}],C\[Distributed]NormalDistribution[10,3]},Method->Empirical,Output->All],
		_?(And[
			uncertaintyPacketQ[#],
			MatchQ[Lookup[#,{Distribution,Method,NumberOfSamples}],{_DataDistribution,Empirical,_Integer}]
		]&)
	],

	Example[{Options,NumberOfSamples,"Specify number of samples to use for creating empirical distribution:"},
		PropagateUncertainty[A+B,{A\[Distributed]NormalDistribution[2,1],B\[Distributed]NormalDistribution[5,3]},Method->Empirical,NumberOfSamples->123,Output->All],
		_?(And[
			uncertaintyPacketQ[#],
			MatchQ[Lookup[#,{Distribution,Method,NumberOfSamples}],{_DataDistribution,Empirical,123}]
		]&)
	],

	Example[{Options,SamplingMethod,"Specify sampling method to use for empirical distribution:"},
		PropagateUncertainty[A+B,{A\[Distributed]NormalDistribution[2,1],B\[Distributed]NormalDistribution[5,3]},Method->Empirical,SamplingMethod->Sobol,Output->All],
		_?(And[
			uncertaintyPacketQ[#],
			MatchQ[Lookup[#,{Distribution,Method,NumberOfSamples}],{_DataDistribution,Empirical,_Integer}]
		]&)
	],

	Example[{Options,ConfidenceLevel,"Specify confidence interval as a percentage:"},
		PropagateUncertainty[A,{A\[Distributed]NormalDistribution[0,1]},ConfidenceLevel->90*Percent,Output->All],
		_?(And[
			uncertaintyPacketQ[#],
			MatchQ[Lookup[#,{Distribution,Method,ConfidenceInterval}],{_NormalDistribution,TransformedDistribution,{-Sqrt[2]*InverseErfc[1/10],Sqrt[2]*InverseErfc[1/10]}}]
		]&)
	],

	Example[{Options,Output,"Specify value to return:"},
		PropagateUncertainty[A+B,{A\[Distributed]NormalDistribution[2,1],B\[Distributed]NormalDistribution[5,3]},Output->Mean],
		7
	],

	Example[{Attributes,HoldFirst,"Expressions are held before evaluation:"},
		PropagateUncertainty[NormalDistribution[]/NormalDistribution[]],
		CauchyDistribution[0,1]
	],

	Example[{Issues,"Parametric method makes approximations that can miss features resulting from highly nonlinear transforms:"},
		Module[{empDist,parDist},
			empDist=PropagateUncertainty[A^2,{A\[Distributed]NormalDistribution[5,1.5]},Method->Empirical,NumberOfSamples->50000];
			parDist=PropagateUncertainty[A^2,{A\[Distributed]NormalDistribution[5,1.5]},Method->Parametric];
			Row[{Show[
				Histogram[empDist[[2,2]],{2},"PDF"],
				Plot[Evaluate[PDF[parDist,x]],{x,-1,150}],
				FrameLabel->{"x","PDF[x]"},
				PlotLabel->"Comparing uncertainty propagation methods",
				ImageSize->500
			],SwatchLegend[ColorData[97]/@{1,2},{"Parametric First Order Approximation","Empirical Sampled Distribution"},LabelStyle->{Bold,16}]
		}]],
		Row[{ValidGraphicsP[],_SwatchLegend}]
	],

	Test["NormalDistribution with 0 StandardDeviation is handled without error:",
		PropagateUncertainty[A+B,{A\[Distributed]NormalDistribution[2,1],B\[Distributed]NormalDistribution[5,0]}],
		NormalDistribution[7,1]
	],

	Test["Empirical with single data point in parametric case:",
		PropagateUncertainty[
			A + B, {A -> 1*Meter,
			B \[Distributed] EmpiricalDistribution[{Centimeter}]}
		],
		QuantityDistribution[DataDistribution["Empirical", {{1}, {101}, False}, 1, 1], "Centimeters"]

	],

	Test["Given single number:",
		PropagateUncertainty[3.],
		DataDistribution["Empirical", {{1.}, {3.}, False}, 1, 1]
	],

	Test["Given single parametric distribution:",
		PropagateUncertainty[NormalDistribution[3.,2.]],
		NormalDistribution[3.,2.]
	],

	Test["Distribution with units:",
		1/NormalDistribution[3 Meter,2 Meter],
		_QuantityDistribution
	],

	Test["Operations with distribution with units:",
		1 Meter/NormalDistribution[3 Meter,2 Meter],
		_TransformedDistribution
	],

	Test["Given single parametric distribution, Method->Empirical:",
		PropagateUncertainty[NormalDistribution[3.,2.],Method->Empirical],
		_DataDistribution
	],

	Test["Given single data distribution:",
		PropagateUncertainty[DataDistribution["Empirical", {{1.}, {3.}, False}, 1, 1]],
		DataDistribution["Empirical", {{1.}, {3.}, False}, 1, 1]
	],

	Test["Given single data distribution, Method->Empirical:",
		PropagateUncertainty[DataDistribution["Empirical", {{1.}, {3.}, False}, 1, 1],Method->Empirical],
		DataDistribution["Empirical", {{1.}, {3.}, False}, 1, 1]
	],

	Test["Given operation on single data distribution:",
		PropagateUncertainty[X,{X\[Distributed]EmpiricalDistribution[{1,2,3}*Meter]}],
		DataDistribution["Empirical", {{1/3, 1/3, 1/3}, {1, 2, 3}, False}, 1, 3, "Meters"]
	],

	Test["Given operation on two data distributions:",
		PropagateUncertainty[X*Y,{X\[Distributed]EmpiricalDistribution[{1,2,3}*Meter],Y\[Distributed]EmpiricalDistribution[{5,6,7,8}*Inch]},NumberOfSamples->20],
		_DataDistribution
	],

	Test["Given multiple small data distributions, sample all permutations:",
		PropagateUncertainty[A*B*C,{A\[Distributed]EmpiricalDistribution[{1,2,3}],B\[Distributed]EmpiricalDistribution[{4,5}],C\[Distributed]EmpiricalDistribution[{9,2}]}],
		DataDistribution["Empirical", {{1/12, 1/12, 1/12, 1/12, 1/12, 1/12, 1/12, 1/12, 1/12, 1/12, 1/12, 1/12}, {8, 10, 16, 20, 24, 30, 36, 45, 72, 90, 108, 135}, False}, 1, 12]
	],

	Test["Parsing input expression with units:",
		PropagateUncertainty[
			EmpiricalDistribution[{1, 2, 3}*Meter]*(2*Gram)
		],
		QuantityDistribution[DataDistribution["Empirical", {{1/3, 1/3, 1/3}, {2, 4, 6}, False}, 1, 3], "Grams"*"Meters"]
	],

	Test["Parsing input expression through variables:",
		Module[{dist,val},
			dist = EmpiricalDistribution[{1, 2, 3}*Meter];
			val = 2*Gram;
			PropagateUncertainty[
				dist*val
			]
		],
		QuantityDistribution[DataDistribution["Empirical", {{1/3, 1/3, 1/3}, {2, 4, 6}, False}, 1, 3], "Grams"*"Meters"]
	],

	Test["Parsing input expression through variables with QuantityDistribution:",
		Module[{dist,val},
			dist = QuantityDistribution[EmpiricalDistribution[{1, 2, 3}], Meter];
			val = 2*Gram;
			PropagateUncertainty[
				dist*val
			]
		],
		DataDistribution["Empirical", {{1/3, 1/3, 1/3}, {2, 4, 6}, False}, 1, 3, "Grams"*"Meters"]
	]



}];



(* ::Subsubsection::Closed:: *)
(*MeanPrediction*)


DefineTests[MeanPrediction,{

	Example[{Basic,"Predict y-value based on fixed x-value:"},
		MeanPrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],2.5*Centimeter],
		QuantityDistribution[NormalDistribution[124.81784486502073`,1.880797627474872`],"Milliliters"],
		EquivalenceFunction->RoundMatchQ[8]
	],
	Example[{Basic,"Predict y-value based on uncertain x-value:"},
		MeanPrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],NormalDistribution[2.5,0.05]],
		QuantityDistribution[NormalDistribution[124.81784486502073`,6.203088445215597`],"Milliliters"],
		EquivalenceFunction->RoundMatchQ[8]
	],

	Example[{Basic,"Predict y-value based on fixed x-value, including units:"},
		MeanPrediction[Object[Analysis,Fit,"id:1ZA60vwODJnM"],0.5*Second],
		QuantityDistribution[NormalDistribution[0.13210000000000005, 0.02836583170230101], "Meters"],
		EquivalenceFunction->RoundMatchQ[8]
	],
	Example[{Basic,"Predict y-value based on uncertain x-value, including units:"},
		MeanPrediction[Object[Analysis,Fit,"id:1ZA60vwODJnM"],QuantityDistribution[NormalDistribution[0.5,0.04],Second]],
		QuantityDistribution[NormalDistribution[0.13210000000000005, 0.046962946748973715], "Meters"],
		EquivalenceFunction->RoundMatchQ[8]
	],

	Example[{Options,Method,"Predict y-value based on fixed x-value by sampling:"},
		MeanPrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],2.5*Centimeter,Method->Empirical],
		_DataDistribution
	],
	Example[{Options,Method,"Predict y-value based on uncertain x-value by sampling:"},
		MeanPrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],NormalDistribution[2.5,0.05],Method->Empirical],
		_DataDistribution
	],

	Example[{Options,NumberOfSamples,"Specify number of samples to use for empirical distribution:"},
		MeanPrediction[Object[Analysis,Fit,"id:1ZA60vwODJnM"],0.5*Second,Method->Empirical,NumberOfSamples->123],
		DataDistribution["Empirical",_,1,123,"Meters"]
	]




}];



(* ::Subsubsection::Closed:: *)
(*SinglePrediction*)


DefineTests[SinglePrediction,{

	Example[{Basic,"Predict y-value based on fixed x-value:"},
		SinglePrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],2.5*Centimeter],
		QuantityDistribution[NormalDistribution[124.81784486502073`,9.95337099555528`],"Milliliters"],
		EquivalenceFunction->RoundMatchQ[8]
	],
	Example[{Basic,"Predict y-value based on uncertain x-value:"},
		SinglePrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],NormalDistribution[2.5,0.05]],
		QuantityDistribution[NormalDistribution[124.81784486502073`,11.576290455876324`],"Milliliters"],
		EquivalenceFunction->RoundMatchQ[8]
	],

	Example[{Basic,"Time to distance, known input:"},
		SinglePrediction[Object[Analysis,Fit,"id:1ZA60vwODJnM"],0.5*Second],
		QuantityDistribution[NormalDistribution[0.13210000000000005, 0.1007171022909096], "Meters"],
		EquivalenceFunction->RoundMatchQ[8]
	],
	Example[{Basic,"Time to distance, uncertain input:"},
		SinglePrediction[Object[Analysis,Fit,"id:1ZA60vwODJnM"],QuantityDistribution[NormalDistribution[0.5,0.04],Second]],
		QuantityDistribution[NormalDistribution[0.13210000000000005, 0.10744688293785551], "Meters"],
		EquivalenceFunction->RoundMatchQ[8]
	],

	Example[{Options,Method,"Predict y-value based on fixed x-value by sampling:"},
		SinglePrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],2.5*Centimeter,Method->Empirical],
		_DataDistribution
	],
	Example[{Options,Method,"Predict y-value based on uncertain x-value by sampling:"},
		SinglePrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],NormalDistribution[2.5,0.05],Method->Empirical],
		_DataDistribution
	],

	Example[{Options,NumberOfSamples,"Specify number of samples to use for empirical distribution:"},
		SinglePrediction[Object[Analysis,Fit,"id:1ZA60vwODJnM"],0.5*Second,Method->Empirical,NumberOfSamples->123],
		DataDistribution["Empirical",_,1,123,"Meters"]
	]


}];



(* ::Subsubsection::Closed:: *)
(*ForwardPrediction*)


DefineTests[ForwardPrediction,{

	Example[{Basic,"Predict y-value based on fixed x-value:"},
		ForwardPrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],2.5*Centimeter],
		QuantityDistribution[NormalDistribution[124.81784486502073`,9.95337099555528`],"Milliliters"],
		EquivalenceFunction->RoundMatchQ[8]
	],
	Example[{Basic,"Predict y-value based on uncertain x-value:"},
		ForwardPrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],NormalDistribution[2.5,0.05]],
		QuantityDistribution[NormalDistribution[124.81784486502073`,11.576290455876324`],"Milliliters"],
		EquivalenceFunction->RoundMatchQ[8]
	],

	Example[{Basic,"Time to distance, known input:"},
		ForwardPrediction[Object[Analysis,Fit,"id:1ZA60vwODJnM"],0.5*Second],
		QuantityDistribution[NormalDistribution[0.13210000000000005, 0.1007171022909096], "Meters"],
		EquivalenceFunction->RoundMatchQ[8]
	],
	Example[{Basic,"Time to distance, uncertain input:"},
		ForwardPrediction[Object[Analysis,Fit,"id:1ZA60vwODJnM"],QuantityDistribution[NormalDistribution[0.5,0.04],Second]],
		QuantityDistribution[NormalDistribution[0.13210000000000005, 0.10744688293785551], "Meters"],
		EquivalenceFunction->RoundMatchQ[8]
	],

	Example[{Options,Method,"Predict y-value based on fixed x-value by sampling:"},
		ForwardPrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],2.5*Centimeter,Method->Empirical],
		_DataDistribution
	],
	Example[{Options,Method,"Predict y-value based on uncertain x-value by sampling:"},
		ForwardPrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],NormalDistribution[2.5,0.05],Method->Empirical],
		_DataDistribution
	],

	Example[{Options,NumberOfSamples,"Specify number of samples to use for empirical distribution:"},
		ForwardPrediction[Object[Analysis,Fit,"id:1ZA60vwODJnM"],0.5*Second,Method->Empirical,NumberOfSamples->123],
		DataDistribution["Empirical",_,1,123,"Meters"]
	],
	Example[{Options,PredictionMethod,"Predict single prediction error of y-value based on fixed x-value by sampling:"},
		ForwardPrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],2.5*Centimeter,Method->Empirical,PredictionMethod->Single],
		_DataDistribution
	],
	Example[{Options,PredictionMethod,"Predict mean prediction error of y-value based on fixed x-value by sampling:"},
		ForwardPrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],2.5*Centimeter,Method->Empirical,PredictionMethod->Mean],
		_DataDistribution
	]


}];



(* ::Subsubsection::Closed:: *)
(*InversePrediction*)


DefineTests[InversePrediction,{

	(* Basics *)
	Example[{Basic,"Predict x-value based on a fixed y-value without a unit:"},
		InversePrediction[Object[Analysis, Fit, "id:1ZA60vwODJnM"],0.6],
		QuantityDistributionP[],
		EquivalenceFunction->MatchQ
	],

	Example[{Basic,"Predict x-value based on a distribution of y-values:"},
		InversePrediction[Object[Analysis, Fit, "id:1ZA60vwODJnM"],NormalDistribution[0.6,0.1]],
		QuantityDistributionP["Second"],
		EquivalenceFunction->MatchQ
	],

	Example[{Basic,"Predict x-value based on a fixed y-value with unit:"},
		InversePrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],	100*Milliliter],
		QuantityDistributionP[Centi Meter],
		EquivalenceFunction->MatchQ
	],

	(* Additional *)
	Example[{Additional,"Predict x-value based on a fixed y-value with unit for a piecewise fit function:"},
		InversePrediction[Object[Analysis, Fit, "id:7X104vndnrKZ"],	10*Milliliter],
		QuantityDistributionP[],
		EquivalenceFunction->MatchQ
	],

	Example[{Options,Method,"Predict mean prediction error of x-value based on fixed x-value by Empirical sampling:"},
		InversePrediction[Object[Analysis, Fit, "id:1ZA60vwODJnM"],0.6,Method->Empirical],
		QuantityDistributionP[],
		EquivalenceFunction->MatchQ
	],
	Example[{Options,NumberOfSamples,"Predict mean prediction error of x-value based on a distribution of x-value by specifying the number of Monte-Carlo samples:"},
	InversePrediction[Object[Analysis, Fit, "id:1ZA60vwODJnM"],NormalDistribution[0.6, 0.1], NumberOfSamples -> 100],
		QuantityDistributionP[],
		EquivalenceFunction->MatchQ
	],
	Example[{Options,PredictionMethod,"Predict mean prediction error of x-value based on a distribution of x-value when only the error in fit function parameters is taken into account:"},
	InversePrediction[Object[Analysis, Fit, "id:1ZA60vwODJnM"],NormalDistribution[0.6, 0.1], PredictionMethod -> Mean],
		QuantityDistributionP[],
		EquivalenceFunction->MatchQ
	],
	Example[{Options,EstimatedValue,"Predict mean prediction error of x-value based on a distribution of x-value by specifying the approximate value of x which is useful when there are multiple answers:"},
	InversePrediction[Object[Analysis, Fit, "id:1ZA60vwODJnM"],NormalDistribution[0.6, 0.1], EstimatedValue -> 0.85],
		QuantityDistributionP[],
		EquivalenceFunction->MatchQ
	]

}];


(* ::Subsection::Closed:: *)
(*Distribution Blobs*)


(* ::Subsubsection::Closed:: *)
(*distributionBlobQ*)


(* checks if a distribution blob is valid *)
distributionBlobQ[distBlob_,exprFormat:(Numeric|Symbolic)]:=distributionBlobQ[distBlob,exprFormat,Null];
distributionBlobQ[distBlob_,exprFormat:(Numeric|Symbolic),distFormat:(Continuous|Discrete|Data|Null)]:=Module[{distBlobHeads},
	distBlobHeads=If[MatchQ[Head[#],Symbol],#,Head[#]]&/@Level[distBlob,Infinity];
	And[
		(* distribution blob must have an InterpretationBox *)
		MatchQ[Head[distBlob],InterpretationBox],

		(* distribution blob must contain a TooltipBox *)
		MemberQ[distBlobHeads,TooltipBox],

		Switch[exprFormat,
			(* if the input expression is "Symbolic", distribution blob must not contain a GraphicsBox *)
			Symbolic,
				!MemberQ[distBlobHeads,GraphicsBox],

			(* if the input expression is "Numeric", distribution blob must contain a GraphicsBox *)
			Numeric,
				Switch[distFormat,
					Continuous,
						MemberQ[distBlobHeads,GraphicsBox],

					Discrete,
						And[MemberQ[distBlobHeads,GraphicsBox],MemberQ[distBlobHeads,DiscretePlot]],

					Data,
						And[MemberQ[distBlobHeads,GraphicsBox],MemberQ[distBlobHeads,DataDistribution]]
				]
		]
	]
];


(* ::Subsubsection::Closed:: *)
(*generateDistributionTests*)


SetAttributes[univariateDistributionPermutations,HoldFirst];
univariateDistributionPermutations[in:(distHead_[pars___]),generateFormat:(All|Numeric|Symbolic)]:=Module[
	{symbolicPars,a,b,c,d,e,f,g},
	(* extract symbolic parameters from input parameters *)
	symbolicPars=If[MatchQ[distHead,UniformDistribution|DiscreteUniformDistribution],
		{Take[{a,b,c,d,e,f,g},Length[pars]]},
		Take[{a,b,c,d,e,f,g},Length[{pars}]]
	];

	Switch[generateFormat,
		(* if generateFormat is "All", then return a list with all permutations *)
		All,
		{
			in,
			QuantityDistribution[in,"Meters"],
			distHead@@symbolicPars,
			QuantityDistribution[distHead@@symbolicPars,"Meters"]
		},

		(* else, return a list with only "Numeric"/"Symbolic" permtuations *)
		Numeric|Symbolic,
		{in,QuantityDistribution[in,"Meters"]}
	]
];

generatePermutationNames[All]:={" (Numeric) blob is displayed:"," (Numeric, Quantity) blob is displayed:"," (Symbolic) blob is displayed:"," (Symbolic, Quantity) blob is displayed:"};
generatePermutationNames[Numeric]:={" (Numeric) blob is displayed:"," (Numeric, Quantity) blob is displayed:"};
generatePermutationNames[Symbolic]:={" (Symbolic) blob is displayed:"," (Symbolic, Quantity) blob is displayed:"};

generatePermutationTests[description_String, expressionUnderTest_, expected_List,generateFormat:(All|Numeric|Symbolic)]:=Module[{},

	Sequence@@MapThread[
		Test[description<>#1,
			ToBoxes[#2],
			#3,
			Stubs:>{$DistributionBlobs=True,$DistributionBlobTiming=5}
		]&,
		{
			generatePermutationNames[generateFormat],
			univariateDistributionPermutations[expressionUnderTest,generateFormat],
			expected
		}
	]
];

generateDistributionTests[expressionsUnderTest_List, expected_List,generateFormat:(All|Numeric|Symbolic)]:=Module[{distributionTests},
	distributionTests=generatePermutationTests[
		ToString[Head[#]],
		#,
		expected,
		generateFormat
	]&/@expressionsUnderTest;
	Sequence@@distributionTests
];


(* ::Subsubsection::Closed:: *)
(*DistributionBlobs*)


DefineTests[DistributionBlobs,With[
	{
		distContinuousExpressions={
			HalfNormalDistribution[3],
			ChiSquareDistribution[3],
			(*
				any value below 4 for the inverse chi square will create an
				indeterminate variance and occasionaly the sampling will break
				the distribution.
			*)
			InverseChiSquareDistribution[5],
			StudentTDistribution[3],
			ChiDistribution[3],
			RayleighDistribution[3],
			MaxwellDistribution[3],
			ExponentialDistribution[3],
			LogNormalDistribution[3,2],
			InverseGaussianDistribution[3,2],
			FRatioDistribution[3,2],
			NoncentralStudentTDistribution[3,2],
			NoncentralChiSquareDistribution[3,2],
			WeibullDistribution[3,2],
			ParetoDistribution[3,2],
			LogisticDistribution[3,2],
			LevyDistribution[3,2],
			LaplaceDistribution[3,2],
			InverseGammaDistribution[3,2],
			GumbelDistribution[3,2],
			GammaDistribution[3,2],
			ExtremeValueDistribution[3,2],
			CauchyDistribution[3,2],
			BetaDistribution[3,2],
			NormalDistribution[3,2],
			UniformDistribution[{1,5}]
		},
		distDiscreteExpressions={
			BernoulliDistribution[0.5],
			GeometricDistribution[0.5],
			LogSeriesDistribution[0.5],
			PoissonDistribution[3],
			ZipfDistribution[3],
			BinomialDistribution[3,0.5],
			NegativeBinomialDistribution[3,0.5],
			BetaBinomialDistribution[3,0.5,20],
			BetaNegativeBinomialDistribution[3,2,5],
			HypergeometricDistribution[10,50,100],
			DiscreteUniformDistribution[{1,5}]
		},
		distDerivedNumericExpressions={
			TransformedDistribution[u^2,u\[Distributed]BetaDistribution[8,3]],
			TransformedDistribution[u+2,u\[Distributed]ZipfDistribution[3]],
			SplicedDistribution[{1,2},{1,2,3},{ExponentialDistribution[.2],ExponentialDistribution[3]}],
			TruncatedDistribution[{1,\[Infinity]},NormalDistribution[]],
			MixtureDistribution[{2,1},{NormalDistribution[],NormalDistribution[2,1/2]}],
			MixtureDistribution[{4,3},{PoissonDistribution[8],GeometricDistribution[0.3]}],
			ParameterMixtureDistribution[GammaDistribution[2,\[Beta]],\[Beta]\[Distributed]UniformDistribution[{1,2}]]
		},
		distDerivedSymbolicExpressions={
			TransformedDistribution[u^2,u\[Distributed]BetaDistribution[a,b]],
			ParameterMixtureDistribution[GammaDistribution[2,\[Beta]],\[Beta]\[Distributed]UniformDistribution[{a,b}]],
			CompoundPoissonDistribution[\[Lambda],PascalDistribution[n,p]]
		},
		distDataNumericExpressions={
			EmpiricalDistribution[{1,1,2,3}]
		},
		distDataSymbolicExpressions={
			EmpiricalDistribution[{a,a,b,b,c,d,e}]
		},
		distContinuousExpected={
			_?(distributionBlobQ[#,Numeric,Continuous]&),
			_?(distributionBlobQ[#,Numeric,Continuous]&),
			_?(distributionBlobQ[#,Symbolic]&),
			_?(distributionBlobQ[#,Symbolic]&)
		},
		distDiscreteExpected={
			_?(distributionBlobQ[#,Numeric,Discrete]&),
			_?(distributionBlobQ[#,Numeric,Discrete]&),
			_?(distributionBlobQ[#,Symbolic]&),
			_?(distributionBlobQ[#,Symbolic]&)
		},
		distDerivedNumericExpected={
			_?(distributionBlobQ[#,Numeric,Continuous]&),
			_?(distributionBlobQ[#,Numeric,Continuous]&)
		},
		distDerivedSymbolicExpected={
			_?(distributionBlobQ[#,Symbolic]&),
			_?(distributionBlobQ[#,Symbolic]&)
		},
		distDataNumericExpected={
			_?(distributionBlobQ[#,Numeric,Data]&),
			_?(distributionBlobQ[#,Numeric,Data]&)
		},
		distDataSymbolicExpected={
			_?(distributionBlobQ[#,Symbolic]&),
			_?(distributionBlobQ[#,Symbolic]&)
		}
	},

	{
	(* --- Continuous Distributions --- *)
		generateDistributionTests[distContinuousExpressions,distContinuousExpected,All],

		(* --- Discrete Distributions --- *)
		generateDistributionTests[distDiscreteExpressions,distDiscreteExpected,All],

		(* --- Derived Distributions --- *)
		generateDistributionTests[distDerivedNumericExpressions,distDerivedNumericExpected,Numeric],
		generateDistributionTests[distDerivedSymbolicExpressions,distDerivedSymbolicExpected,Symbolic],

		(* --- Data Distributions --- *)
		generateDistributionTests[distDataNumericExpressions,distDataNumericExpected,Numeric],
		generateDistributionTests[distDataSymbolicExpressions,distDataSymbolicExpected,Symbolic]
	}
]];



(* ::Subsection::Closed:: *)
(*Distribution Algebra*)


(* ::Subsubsection::Closed:: *)
(*Distribution Algebra*)


Authors[DistributionAlgebra]:={"brad"};
DefineTests[DistributionAlgebra,{
	Test["Multiple of a NormalDistribution is a NormalDistribution:",
		3*NormalDistribution[3,2],
		NormalDistribution[9,6]
	],
	Test["Affine transformation of a LogisticDistribution is a LogisticDistribution:",
		3*LogisticDistribution[-2,2]+5,
		LogisticDistribution[-1,6]
	],
	Test["Reciprocal of a CauchyDistribution is a CauchyDistribution:",
		1/CauchyDistribution[1,3],
		CauchyDistribution[1/10,3/10]
	],
	Test["Power of an ExponentialDistribution is a WeibullDistribution:",
		ExponentialDistribution[0.5]^4,
		WeibullDistribution[1/4,16.`]
	],
	Test["Sum of PoissonDistributions is a PoissonDistribution:",
		PoissonDistribution[5]+PoissonDistribution[10],
		PoissonDistribution[15]
	],
	Test["Sum of BernoulliDistributions is a BinomialDistribution:",
		BernoulliDistribution[0.1]+BernoulliDistribution[0.1]+BernoulliDistribution[0.1],
		BinomialDistribution[3,0.1`]
	],
	Test["Product of LogNormalDistributions is a LogNormalDistribution:",
		LogNormalDistribution[-1,2]*LogNormalDistribution[1,3],
		LogNormalDistribution[0,Sqrt[13]]
	],
	Test["Minimum of two GeometricDistributions is a GeometricDistribution:",
		Min[GeometricDistribution[0.5],GeometricDistribution[0.3]],
		GeometricDistribution[0.65`]
	],
	Test["Quotient of two Standard NormalDistributions is a CauchyDistribution:",
		NormalDistribution[]/NormalDistribution[],
		_TransformedDistribution
	],
	Test["Difference of two ExponentialDistributions is a LaplaceDistribution:",
		TransformedDistribution[u - v, Distributed[{u, v},ProductDistribution[{ExponentialDistribution[1/3], 2}]]],
		LaplaceDistribution[0, 3]
	],
	Test["Sum of a NormalDistribution and an ExponentialDistribution is a TransformedDistribution:",
		NormalDistribution[]+ExponentialDistribution[0.5],
		_TransformedDistribution
	],
	Test["Cube of a NormalDistribution is a TransformedDistribution:",
		NormalDistribution[]^3,
		_TransformedDistribution
	],
	Test["Sum of PoissonDistributions is a PoissonDistribution (Quantity):",
		QuantityDistribution[PoissonDistribution[5],"Meters"]+QuantityDistribution[PoissonDistribution[10],"Meters"],
		QuantityDistribution[PoissonDistribution[15],"Meters"]
	],
	Test["Product of LogNormalDistributions is a LogNormalDistribution (Quantity):",
		QuantityDistribution[LogNormalDistribution[-1,2],"Meters"]*QuantityDistribution[LogNormalDistribution[1,3],"Meters"],
		QuantityDistribution[LogNormalDistribution[0,Sqrt[13]],"Meters"^2]
	],
	Test["Sum of EmpiricalDistributions is a DataDistribution:",
		EmpiricalDistribution[{1,2,3}]+EmpiricalDistribution[{4,5}],
		DataDistribution["Empirical", {{1/6, 1/3, 1/3, 1/6}, {5, 6, 7, 8}, False}, 1, 6]
	],
	Test["Sum of an EmpiricalDistribution and a NormalDistribution is a DataDistribution:",
		EmpiricalDistribution[{1,2,3}]+NormalDistribution[],
		DataDistribution["Empirical",_,1,_Integer]
	],
	Test["Sum of EmpiricalDistributions is a DataDistribution (Quantity):",
		EmpiricalDistribution[{1,2,3}*Meter]+EmpiricalDistribution[{4,5}*Centimeter],
		DataDistribution["Empirical", {{1/6, 1/6, 1/6, 1/6, 1/6, 1/6}, {104, 105, 204, 205, 304, 305}, False}, 1, 6, "Centimeters"]
	],


	Test["QuantityDistribution * quantity works with variables:",
		Module[{dist,val},
			dist = QuantityDistribution[EmpiricalDistribution[{1, 2, 3}], Meter];
			val = 2*Gram;
			dist*val
		],
		DataDistribution["Empirical", {{1/3, 1/3, 1/3}, {2, 4, 6}, False}, 1, 3, "Grams"*"Meters"]
	],
	Test["QuantityDistribution * quantity works:",
		QuantityDistribution[EmpiricalDistribution[{1, 2, 3}], Meter]*Quantity[2, "Grams"],
		DataDistribution["Empirical", {{1/3, 1/3, 1/3}, {2, 4, 6}, False}, 1, 3, "Grams"*"Meters"]
	]



}];


(* ::Subsection::Closed:: *)
(*SampleDistribution*)


DefineTests[SampleDistribution,{
	Example[{Basic,"A distribution that is a sample:"},
		SampleDistribution[{1,2,3,4}],
		SampleDistribution[{1,2,3,4}]
	],
	Example[{Basic,"Compute its Mean:"},
		Mean[SampleDistribution[{1,2,3,4}]],
		5/2
	],
	Example[{Basic,"Compute its StandardDeviation:"},
		StandardDeviation[SampleDistribution[{1,2,3,4}]],
		Sqrt[5/3]
	],
	Example[{Basic,"A sample distribution with units:"},
		SampleDistribution[{1, 2, 3, 4} Meter],
		SampleDistribution[{1, 2, 3, 4} Meter]
	],
	Example[{Additional,"SampleDistribution uses sample standard deviation, unlike EmpiricalDistribution which uses population standard deviation:"},
		{StandardDeviation[SampleDistribution[Range[4]]],StandardDeviation[EmpiricalDistribution[Range[4]]]},
		{Sqrt[5/3],Sqrt[5/4]}
	],
	Example[{Additional,"SubValues:"},
		{SampleDistribution[{1,2,3,4}]["DataPoints"],SampleDistribution[{1,2,3,4}]["SampleSize"]},
		{{1,2,3,4},4}
	],
	Example[{Additional,"Transform SampleDistribution into EmpiricalDistribution:"},
		EmpiricalDistribution[SampleDistribution[Range[4]]]===EmpiricalDistribution[Range[4]],
		True
	],
	Example[{Additional,"Transform EmpiricalDistribution into SampleDistribution:"},
		SampleDistribution[EmpiricalDistribution[Range[4]]]===SampleDistribution[Range[4]],
		True
	],
	Example[{Additional,"Multiply two sample distribuitons:"},
		SampleDistribution[Range[4]]*SampleDistribution[Range[5,12]],
		SampleDistribution[Sort@{5, 6, 7, 8, 9, 10, 11, 12, 10, 12, 14, 16, 18, 20, 22, 24, 15, 18, 21, 24, 27, 30, 33, 36, 20,
			24, 28, 32, 36, 40, 44, 48}]
	],
	Example[{Additional,"Divide two sample distribuitons:"},
		SampleDistribution[Range[4]]/SampleDistribution[Range[5,12]],
		SampleDistribution[Sort@{1/5, 1/6, 1/7, 1/8, 1/9, 1/10, 1/11, 1/12, 2/5, 1/3, 2/7, 1/4, 2/9, 1/5, 2/11, 1/6, 3/5, 1/2,
			3/7, 3/8, 1/3, 3/10, 3/11, 1/4, 4/5, 2/3, 4/7, 1/2, 4/9, 2/5, 4/11, 1/3}]
	],

	Example[{Additional,"Strip off the units:"},
		Unitless[SampleDistribution[Range[4]*Meter]],
		SampleDistribution[{1, 2, 3, 4}]
	],
	Example[{Additional,"Convert the units:"},
		Convert[SampleDistribution[Range[4]*Minute],Second],
		SampleDistribution[{Quantity[60, "Seconds"], Quantity[120, "Seconds"], Quantity[180, "Seconds"],
			Quantity[240, "Seconds"]}]
	],

	Example[{Attributes,Protected,"SampleDistribution is protected:"},
		SampleDistribution[{3, 4}] = 5,
		5,
		Messages:>{Set::write}
	],

	Test["Blob works:",
		ToBoxes[SampleDistribution[{1,2,3,4}]],
		_InterpretationBox
	],

	Test["Multiplication by quantity works:",
		SampleDistribution[{1, 2, 3}]*Volt,
		SampleDistribution[{Quantity[1, "Volts"], Quantity[2, "Volts"], Quantity[3, "Volts"]}]
	],

	Test["QuantityUnit does NOT work:",
		QuantityUnit[QuantityUnit[SampleDistribution[Range[5, 12]*Meter]]],
		_QuantityUnit
	],

	Test["Multiplying by 1. works:",
		SampleDistribution[{1, 2} Minute]*1.,
		SampleDistribution[{Quantity[1., "Minutes"], Quantity[2., "Minutes"]}]
	],

	Test["Handles weirdness where units don't simplify in some cases:",
		SampleDistribution[{1, 2, 3}]*Minute,
		SampleDistribution[{Quantity[1, "Minutes"], Quantity[2, "Minutes"], Quantity[3, "Minutes"]}]
	],


	Test["PropagateUncertainty is not reducing number of points when they're identical:",
		1/SampleDistribution[{1 Minute, 1 Minute}],
		SampleDistribution[{Quantity[1, "Minutes"^(-1)], Quantity[1, "Minutes"^(-1)]}]
	]

}]


DefineTests[fitAnalysisParameterDistribution,{

	Test["Only have best fit parameters:",
		fitAnalysisParameterDistribution[{Null, Null, {{x, 1, 2}, {y, 3, 4}}}],
		{x -> 1, y -> 3}
	],

	Test["Have covariance matrix:",
		fitAnalysisParameterDistribution[{Null, {{5, 1}, {1, 4}}, {{x, 1, 2}, {y, 3, 4}}}],
		Distributed[{x, y}, MultinormalDistribution[{1, 3}, {{5., 1.}, {1., 4.}}]]
	],

	Test["Have full distribution:",
		fitAnalysisParameterDistribution[{EmpiricalDistribution[{{10, 15}, {11, 14}, {9, 16}}], {{2/3, -(2/3)}, {-(2/3), 2/3}}, {{x, 10, 2/3}, {y, 15, 2/3}}}],
		Distributed[{x, y}, EmpiricalDistribution[{{10, 15}, {11, 14}, {9, 16}}]]
	]

}];



(* ::Section:: *)
(*End Test Package*)
