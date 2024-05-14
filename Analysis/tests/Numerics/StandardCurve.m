(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*StandardCurve: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*AnalyzeStandardCurve*)


(* Define a pattern for nested fields  *)
nestedFieldQ[arg_Symbol]:=True;
nestedFieldQ[head_Symbol[arg_]]:=nestedFieldQ[arg];
nestedFieldQ[_]:=False;
nestedFieldP = _?nestedFieldQ|_Field|_Symbol;


(* Define Tests *)
DefineTests[AnalyzeStandardCurve,
	{
		Example[{Basic, "Given a CapillaryELISA protocol as input, run one standard curve analysis per analyte, matching data by analyte type:"},
			AnalyzeStandardCurve[
				Object[Protocol, CapillaryELISA,"AnalyzeStandardCurve Test CapillaryELISA Protocol 2"],
				FitType -> Linear,
				Output -> {Result,Preview}
			],
			{{ObjectP[Object[Analysis, StandardCurve]] ..}, _}
		],
		Example[{Basic, "Object fields where data is located can be explicitly specified in inputs. Input can be specified as a {Object(s),Field} pair, and standard data can be specified as a {Object(s),{xField,yField}} pair:"},
			AnalyzeStandardCurve[
				{{Object[Data,qPCR,"ASC Test qPCR Sample 1-1"],Object[Data,qPCR,"ASC Test qPCR Sample 1-2"]},QuantificationCycleAnalyses[QuantificationCycle]},
				{
					{Object[Data,qPCR,"ASC Test qPCR Standard 1-1"],Object[Data,qPCR,"ASC Test qPCR Standard 1-2"],Object[Data,qPCR,"ASC Test qPCR Standard 1-3"],Object[Data,qPCR,"ASC Test qPCR Standard 1-4"]},
					{QuantificationCycleAnalyses[QuantificationCycle],CopyNumberAnalyses[CopyNumber]}
				},
				StandardTransformationFunctions->{None,Function[{x},Log10[x]]},
				FitType->Linear,
				Output->Preview
			],
			ValidGraphicsP[]
		],
		Example[{Basic, "Input data can be specified as an object or list of objects. The field to pull data from is determined by the object type:"},
			AnalyzeStandardCurve[
				{Object[Data,qPCR,"ASC Test qPCR Sample 1-1"],Object[Data,qPCR,"ASC Test qPCR Sample 1-2"]},
				{{10 Cycle, 2.1},{20 Cycle, 5.8},{30 Cycle, 7.7}},
				FitType->Linear,
				Output->Preview
			],
			ValidGraphicsP[]
		],
		Example[{Basic, "When input data does not exists, the function will run AnalyzeFit on Standard Data"},
			AnalyzeStandardCurve[
				{{10 Cycle, 2.1},{20 Cycle, 5.8},{30 Cycle, 7.7}},
				FitType->Linear,
				Output->Preview
			],
			ValidGraphicsP[]
		],
		Example[{Basic, "Standard data can be Object[Analyze, StandardCurve], example 1. "},
			AnalyzeStandardCurve[
				12 Cycle,
				AnalyzeStandardCurve[{{10 Cycle, 2.1},{20 Cycle, 5.8},{30 Cycle, 7.7}}],
				FitType->Linear,
				Output->Preview
			],
			ValidGraphicsP[]
		],
		Example[{Basic, "Standard data can be Object[Analyze, StandardCurve], example 2. "},
			AnalyzeStandardCurve[
				{14 Cycle, 25 Cycle},
				AnalyzeStandardCurve[{{10 Cycle, 2.1},{20 Cycle, 5.8},{30 Cycle, 7.7}}],
				FitType->Linear,
				Output->Preview
			],
			ValidGraphicsP[]
		],
		Example[{Basic, "The input can be input data and Standard data which is Object[Analyze, StandardCurve]. "},
			AnalyzeStandardCurve[
				12 Cycle,
				AnalyzeStandardCurve[{{10 Cycle, 2.1},{20 Cycle, 5.8},{30 Cycle, 7.7}}],
				FitType->Linear,
				Output->Preview
			],
			ValidGraphicsP[]
		],
		Test["When the input is standard data only, ReferenceStandardCurve will be null",
			AnalyzeStandardCurve[simpleLineCoordinates,Upload->False][ReferenceStandardCurve],
			Null
		],
		Test["When the input is standard data only, the output should still contain AnalyzeFit results",
			AnalyzeStandardCurve[{{10 Cycle, 2.1},{20 Cycle, 5.8},{30 Cycle, 7.7}},Upload->False][RSquared],
			0.966708,
			EquivalenceFunction->RoundMatchQ[3]
		],
		Test["When the input is input data and Object[Analysis, StandardCurve] without ReferenceStandardCurve filled, ReferenceStandardCurve will be null",
			AnalyzeStandardCurve[12 Cycle, AnalyzeStandardCurve[{{10 Cycle, 2.1},{20 Cycle, 5.8},{30 Cycle, 7.7}}],Upload->False][ReferenceStandardCurve],
			ObjectP[Object[Analysis, StandardCurve]]
		],
		Test["When the input is input data and Object[Analysis, StandardCurve] without ReferenceStandardCurve filled, Standard Curve and Standard Curve Statistics should not be changed",
			AnalyzeStandardCurve[12 Cycle, AnalyzeStandardCurve[{{10 Cycle, 2.1},{20 Cycle, 5.8},{30 Cycle, 7.7}}],Upload->False][FStatistic],
			29.037,
			EquivalenceFunction->RoundMatchQ[2]
		],
		Test["If Object[Analysis, StandardCurve] has non-Null ReferenceStandardCurve, this object could not be used as standard data.",
			AnalyzeStandardCurve[12 Cycle, AnalyzeStandardCurve[15 Cycle, AnalyzeStandardCurve[{{10 Cycle, 2.1},{20 Cycle, 5.8},{30 Cycle, 7.7}}]],Upload->False],
			$Failed,
			Messages:>{Error::ExistingReferenceStandardCurve}
		],
		Example[{Basic, "Both input and standard data can be specified with physical units, and the expression used to fit the standard data can be changed:"},
			AnalyzeStandardCurve[{{2.3 Meter}, {11 Foot, 14 Foot}},
				QuantityArray[
					Table[{x,1.3x^2+RandomReal[3]-1},{x,0,5,0.2}],
					{Meter,Kilogram}
				],
				FitType->Polynomial,
				PolynomialDegree->2,
				Output->Preview
			],
			ValidGraphicsP[]
		],
		Example[{Basic, "Fit a standard curve to a list of {x,y} coordinates, and use the fit to transform input x-values to y-values:"},
			AnalyzeStandardCurve[{1.5,3.3},simpleLineCoordinates,Upload->False,Output->Preview],
			ValidGraphicsP[]
		],
		Test["Unitless data points as input:",
			AnalyzeStandardCurve[{1.0,2.0,3.0},simpleLineCoordinates,Upload->False][Replace[PredictedValues]],
			{1.0,2.0,3.0},
			EquivalenceFunction->Function[{x,y},MatchQ[RoundReals[Mean/@x,3],RoundReals[y,3]]]
		],
		Test["Data points with units as input:",
			AnalyzeStandardCurve[{3.3 Meter, 4.1 Meter},simpleLineWithUnits,Upload->False][Replace[PredictedValues]],
			Normal@QuantityArray[{3.3,4.1},Second],
			EquivalenceFunction->Function[{x,y},MatchQ[RoundReals[Mean/@x,3],RoundReals[y,3]]]
		],
		Test["QuantityArray input:",
			AnalyzeStandardCurve[QuantityArray[{1.2,2.3,3.4,4.5},Meter],simpleLineWithUnits,Upload->False][Replace[PredictedValues]],
			Normal@QuantityArray[{1.2,2.3,3.4,4.5},Second],
			EquivalenceFunction->Function[{x,y},MatchQ[RoundReals[Mean/@x,3],RoundReals[y,3]]]
		],
		Test["List of distributions as input:",
			stripAppendReplaceKeyHeads[AnalyzeStandardCurve[{NormalDistribution[0.5,0.2],NormalDistribution[1.0,0.5]},simpleLineCoordinates,Upload->False]][PredictedValues],
			{0.5,1.0},
			EquivalenceFunction->Function[{x,y},MatchQ[RoundReals[Mean/@x,3],RoundReals[y,3]]]
		],
		Test["List of QuantityDistributions as input:",
			stripAppendReplaceKeyHeads[AnalyzeStandardCurve[{QuantityDistribution[NormalDistribution[1.2,0.2],"Meter"],QuantityDistribution[NormalDistribution[2.5,0.5],"Meter"],QuantityDistribution[NormalDistribution[3.9,0.3],"Meter"]},simpleLineWithUnits,Upload->False]][PredictedValues],
			{1.2 Second,2.5 Second,3.9 Second},
			EquivalenceFunction->Function[{x,y},MatchQ[RoundReals[Mean/@x,3],RoundReals[y,3]]]
		],
		Example[{Additional, "Input data can be specified using distributions or quantity distributions:"},
			AnalyzeStandardCurve[
				{QuantityDistribution[NormalDistribution[1.2,0.2],"Meter"],QuantityDistribution[NormalDistribution[2.5,0.5],"Meter"],QuantityDistribution[NormalDistribution[3.9,0.3],"Meter"]},
				simpleLineWithUnits,
				Upload->False,
				Output->Preview
			],
			ValidGraphicsP[]
		],
		Test["Input contains datapoints with differing units with compatible dimensions:",
			AnalyzeStandardCurve[{4.5 Meter,12.1 Foot},{{3 Meter,3 Second},{4 Meter,-2 Second},{5 Meter,0 Second},{10 Meter,100 Second},{12 Meter,-100 Second}}][PredictedValues],
			Normal@QuantityArray[{7.737,10.398},Second],
			EquivalenceFunction->Function[{x,y},MatchQ[RoundReals[Mean/@x,3],RoundReals[y,3]]],
			Stubs:>{
				AnalyzeStandardCurve[{4.5 Meter,12.1 Foot},{{3 Meter,3 Second},{4 Meter,-2 Second},{5 Meter,0 Second},{10 Meter,100 Second},{12 Meter,-100 Second}}]=stripAppendReplaceKeyHeads[
					AnalyzeStandardCurve[
						{4.5 Meter,12.1 Foot},
						{{3 Meter,3 Second},{4 Meter,-2 Second},{5 Meter,0 Second},{10 Meter,100 Second},{12 Meter,-100 Second}},
						Upload->False
					]
				]
			}
		],
		Test["StandardData contains datapoints with differing units with compatible dimensions:",
			AnalyzeStandardCurve[{2.3` Meter},{{1 Meter,5.2 Kilogram},{2.1 Meter,3000 Gram},{300 Centimeter,1.1 Kilogram}}][PredictedValues],
			Normal@QuantityArray[{2.55},Kilogram],
			EquivalenceFunction->Function[{x,y},MatchQ[RoundReals[Mean/@x,3],RoundReals[y,3]]],
			Stubs:>{
				AnalyzeStandardCurve[{2.3` Meter},{{1 Meter,5.2 Kilogram},{2.1 Meter,3000 Gram},{300 Centimeter,1.1 Kilogram}}]=stripAppendReplaceKeyHeads[
					AnalyzeStandardCurve[
						{2.3` Meter},
						{{1 Meter,5.2 Kilogram},{2.1 Meter,3000 Gram},{300 Centimeter,1.1 Kilogram}},
						Upload->False
					]
				]
			}
		],
		Example[{Additional, "Specify multiple sets of input data, generating a list of predicted values for each input dataset:"},
			AnalyzeStandardCurve[{{4.0 Meter},{1.2,1.4,1.1},QuantityArray[{2.0,2.5,3.0,3.5},Meter]},simpleLineWithUnits,Upload->False,Output->Preview],
			ValidGraphicsP[]
		],
		Example[{Additional, "Use multiple objects, each containing multiple {x,y} coordinates, as input:"},
			AnalyzeStandardCurve[
				{Object[Data,ELISA,"ASC Test ELISA Sample 1"],Object[Data,ELISA,"ASC Test ELISA Sample 2"]},
				QuantityArray[{{0.0,0.0},{1.0,1.6},{2.0,2.0},{3.0,2.9},{4.0,4.1},{5.0,4.4},{6.0,6.1},{7.0,8.1}},{RFU,Mole/Liter}],
				Output->Preview
			],
			ValidGraphicsP[]
		],
		Example[{Additional, "Mix object inputs with numerical coordinate inputs:"},
			AnalyzeStandardCurve[
				{{20,25,15},{{Object[Data,qPCR,"ASC Test qPCR Sample 1-1"],Object[Data,qPCR,"ASC Test qPCR Sample 1-2"]},Field[QuantificationCycleAnalyses[QuantificationCycle]]},QuantityArray[{14.0,15.0,16.0},Cycle]},
				QuantityArray[{{5,5},{16,17},{23,21},{29,31}},{Cycle,"DimensionlessUnit"}],
				FitType->Linear
			],
			ObjectP[Object[Analysis,StandardCurve]]
		],
		Example[{Additional, "Use a combination of transformation functions and standard curve options to construct a logistic standard curve for Capillary ELISA data:"},
			PlotStandardCurve[
				AnalyzeStandardCurve[
					{Object[Data,ELISA,"ASC Test ELISA Sample 1"],Intensities},
					{Object[Data,ELISA,"ASC Test ELISA Standard 1"],{DilutionFactors,Intensities}},
					StandardTransformationFunctions->{Log10[#]&,None},
					InversePrediction->True,
					FitType->LogisticBase10,
					Upload->False
				],
				FrameLabel->{"Log[Dilution]","Fluorescence (RFU)"}
			],
			ValidGraphicsP[]
		],
		Example[{Options,InputField,"Specify what field in input objects data should be downloaded from. The input field option will supersede a field specified using the {object(s),field} input format:"},
			AnalyzeStandardCurve[
				{Object[Data,qPCR,"ASC Test qPCR Standard 1-3"],Object[Data,qPCR,"ASC Test qPCR Standard 1-4"]},
				{{100,2.2},{10000,3.3},{1000000,4.16},{100000000,5.2}},
				InputField -> CopyNumberAnalyses[CopyNumber],
				FitType->Linear
			][InputDataPoints],
			{{100000.},{1000000.}}
		],
		Example[{Options,InputTransformationFunction,"Apply the same transformation function to each input value:"},
			AnalyzeStandardCurve[{10,100,1000,10000},simpleLineCoordinates,InputTransformationFunction->Function[{x},N@Log10[x]]][InputDataPoints],
			{1.,2.,3.,4.},
			EquivalenceFunction->Function[{x,y},MatchQ[RoundReals[x,3],RoundReals[y,3]]]
		],
		Example[{Options,InputTransformationFunction,"Apply different transformations to each input value:"},
			AnalyzeStandardCurve[{{100},{100}},simpleLineCoordinates,InputTransformationFunction->{Function[{x},N@Log10[x]],Function[{x},N@Log[x]]}][InputDataPoints],
			{{2.},{4.605}},
			EquivalenceFunction->Function[{x,y},MatchQ[RoundReals[x,3],RoundReals[y,3]]]
		],
		Example[{Options,StandardData,"Use an existing AnalyzeFit object as a standard curve:"},
			AnalyzeStandardCurve[{1.0 Meter, 3.14159 Meter, 4.7 Meter},myLineFit,Upload->False,Output->Preview],
			ValidGraphicsP[]
		],
		Example[{Options,StandardData,"Use numerical coordinates as standard data:"},
			AnalyzeStandardCurve[{-1.8 Mole/Liter,1 Mole/Liter,1.4 Mole/Liter},
				QuantityArray[Table[{x,x^3+RandomReal[2.5]},{x,-2,2,0.1}],{Mole/Liter,RFU}],
				FitType->Cubic,Upload->False,Output->Preview
			],
			ValidGraphicsP[]
		],
		Example[{Options,StandardData,"A single object contains multiple {x,y} datapoints to use as standard data:"},
			AnalyzeStandardCurve[{1.0 RFU,2.0 RFU,3.0 RFU},
				Object[Data,ELISA,"ASC Test ELISA Standard 2"],
				FitType->Linear,Upload->False,Output->Preview
			],
			ValidGraphicsP[]
		],
		Example[{Options,StandardData,"List of objects, each containing one standard data point:"},
			AnalyzeStandardCurve[{16 Cycle, 19.1 Cycle, 21 Cycle},
				{Object[Data,qPCR,"ASC Test qPCR Standard 1-1"],Object[Data,qPCR,"ASC Test qPCR Standard 1-2"],Object[Data,qPCR,"ASC Test qPCR Standard 1-3"],Object[Data,qPCR,"ASC Test qPCR Standard 1-4"]},
				StandardTransformationFunctions->{None,Function[{x},Log10[x]]},
				FitType->Linear,
				Output->Preview
			],
			ValidGraphicsP[]
		],
		Example[{Options,StandardData,"Mixed numerical and object input as standard data:"},
			AnalyzeStandardCurve[{16.0 Cycle, 19.1 Cycle, 21 Cycle},
				{
					{Object[Data,qPCR,"ASC Test qPCR Standard 1-1"],1.0 Joule},
					{Object[Data,qPCR,"ASC Test qPCR Standard 1-2"],2.0 Joule},
					{Object[Data,qPCR,"ASC Test qPCR Standard 1-3"],3.0 Joule},
					{Object[Data,qPCR,"ASC Test qPCR Standard 1-4"],4.0 Joule}
				},
				FitType->Linear,
				Output->Preview
			],
			ValidGraphicsP[]
		],
		Test["Standard data contains a mixture of distributions and numbers:",
			PlotStandardCurve@AnalyzeStandardCurve[
				{NormalDistribution[1.5, 0.1]},
				{
					{NormalDistribution[1, 0.1],1},
					{NormalDistribution[2, 0.4],5},
					{3.1,12.4},
					{NormalDistribution[4.04, 0.2], 14}
				},
				FitType -> Linear,
				Upload -> False
			],
			ValidGraphicsP[]
		],
		Example[{Options,StandardFields,"Manually specify which fields to pull from standard data objects. Option values will take precendence over fields in {object(s),{xField,yFiled}} input format:"},
			AnalyzeStandardCurve[{1.0 RFU,2.0 RFU,3.0 RFU},
				Object[Data,ELISA,"ASC Test ELISA Standard 2"],
				StandardFields->{Intensities,Intensities},
				FitType->Linear,
				Output->Preview
			],
			ValidGraphicsP[]
		],
		Example[{Options,StandardFields,"Use None when only one dimension requires a field specification:"},
			AnalyzeStandardCurve[{1.4 Lumen, 2.2 Lumen, 3.6 Lumen},
				{
					{1.0 Lumen,Object[Data,qPCR,"ASC Test qPCR Standard 1-1"]},
					{2.0 Lumen,Object[Data,qPCR,"ASC Test qPCR Standard 1-2"]},
					{3.0 Lumen,Object[Data,qPCR,"ASC Test qPCR Standard 1-3"]},
					{4.0 Lumen,Object[Data,qPCR,"ASC Test qPCR Standard 1-4"]}
				},
				StandardFields->{None,QuantificationCycleAnalyses[QuantificationCycle]},
				FitType->Linear,
				Output->Preview
			],
			ValidGraphicsP[]
		],
		Example[{Options,StandardFields,"Default standard fields depend on Standard object type:"},
			mySCObject=AnalyzeStandardCurve[{18.1 Cycle},
				{Object[Data,qPCR,"ASC Test qPCR Standard 1-1"],Object[Data,qPCR,"ASC Test qPCR Standard 1-2"],Object[Data,qPCR,"ASC Test qPCR Standard 1-3"],Object[Data,qPCR,"ASC Test qPCR Standard 1-4"]},
				StandardTransformationFunctions->{None,Function[{x},Log10[x]]},
				FitType -> Linear
			];
			mySCObject[{StandardIndependentVariableData,StandardDependentVariableData}][[;;,1,2]],
			{nestedFieldP,nestedFieldP}
		],
		Example[{Options,StandardTransformationFunctions,"Use transformation functions to pre-process the standard data:"},
			AnalyzeStandardCurve[
				{15 Cycle},
				{Object[Data,qPCR,"ASC Test qPCR Standard 1-1"],Object[Data,qPCR,"ASC Test qPCR Standard 1-2"],Object[Data,qPCR,"ASC Test qPCR Standard 1-3"],Object[Data,qPCR,"ASC Test qPCR Standard 1-4"]},
				StandardTransformationFunctions -> {None,Function[{x},Log10[x]]},
				FitType -> Linear
			][StandardDataPoints],
			{{_Quantity,_?NumericQ}..}
		],
		Example[{Options,FitType,"Explicitly specify the type of expression to fit the standard curve to:"},
			AnalyzeStandardCurve[{1.5 Lumen,3.3 Lumen},
				QuantityArray[{{1,1},{2,3.9},{3,9.1},{4,19.3}}, {Lumen,RFU}],
				FitType -> Exponential, Output -> Preview],
			ValidGraphicsP[]
		],
		Example[{Options,FitType,"Set the degree of a polynomial fit:"},
			AnalyzeStandardCurve[{1.5 Mole/Liter,3.3 Mole/Liter},
				QuantityArray[{{1,1},{2,3.9},{3,9.1},{4,19.3}}, {Mole/Liter,RFU}],
				FitType -> Polynomial, PolynomialDegree->2, Output -> Preview],
			ValidGraphicsP[]
		],
		Example[{Options,FitType,"Use a user-defined Function as a fit expression:"},
			AnalyzeStandardCurve[{2.3,4.5},
				Table[{i,1.4*i+3*Sin[i]},{i,0,5,0.2}],
				FitType -> Function[{x},a*x+b*Sin[x]],Output -> Preview],
			ValidGraphicsP[]
		],
		Example[{Options,FitType,"The default fitting expression is chosen based on StandardData type:"},
			Quiet[
				AnalyzeStandardCurve[
					{1.0 RFU,2.0 RFU,3.0 RFU},
					Object[Data,ELISA,"ASC Test ELISA Standard 2"],
					FitType -> Automatic
				][ExpressionType],
				NonlinearModelFit::cvmit
			],
			LogisticBase10
		],
		Example[{Options,Template,"Use options and curve from an existing Standard Curve analysis:"},
			AnalyzeStandardCurve[Object[Data,ELISA,"ASC Test ELISA Sample 2"],Template->existingStandardCurveAnalysis,Upload->False,Output->Preview],
			ValidGraphicsP[],
			SetUp :> (
				ClearMemoization[];
				existingStandardCurveAnalysis=AnalyzeStandardCurve[
					{Object[Data,ELISA,"ASC Test ELISA Sample 1"],Automatic},
					Object[Data,ELISA,"ASC Test ELISA Standard 2"],
					StandardFields->{Intensities,DilutionFactors},
					StandardTransformationFunctions->{None,Function[{x},2.7*x]}
				];
			)
		],
		Example[{Options,InversePrediction,"Use inverse prediction to transform y-values to x-values:"},
			AnalyzeStandardCurve[{-3.2 RFU,0.0 RFU,5.2 RFU},
				QuantityArray[Table[{x,x^3+RandomReal[2.5]},{x,-2,2,0.1}],{Mole/Liter,RFU}],
				InversePrediction->True,FitType->Cubic,Upload->False,Output->Preview
			],
			ValidGraphicsP[]
		],
		Test["Incompatible units test works when Inverse Prediction is True:",
			AnalyzeStandardCurve[{-3.2 Joule,0.0 Joule,5.2 Joule},
				QuantityArray[Table[{x,x^3+RandomReal[2.5]},{x,-2,2,0.1}],{Mole/Liter,RFU}],
				InversePrediction->True,FitType->Cubic
			],
			$Failed,
			Messages:>{Error::StandardDataIncompatibleUnits,Error::InvalidOption}
		],
		Test["Extrapolation warning works for inverse prediction:",
			AnalyzeStandardCurve[{-10.2 RFU,0.0 RFU,10.2 RFU},
				QuantityArray[Table[{x,x^3+RandomReal[2.5]},{x,-2,2,0.1}],{Mole/Liter,RFU}],
				InversePrediction->True,FitType->Cubic,Upload->False,Output->Preview
			],
			ValidGraphicsP[],
			Messages:>{Warning::Extrapolation}
		],
		Test["Unspecified input units warning works for inverse prediction:",
			AnalyzeStandardCurve[{-5.2,0.0,5.2},
				QuantityArray[Table[{x,x^3+RandomReal[2.5]},{x,-2,2,0.1}],{Mole/Liter,RFU}],
				InversePrediction->True,FitType->Cubic,Upload->False,Output->Preview
			],
			ValidGraphicsP[],
			Messages:>{Warning::UnspecifiedUnits}
		],
		Test["Unspecified input units warning works for inverse prediction:",
			AnalyzeStandardCurve[{-5.2 RFU,0.0 RFU,5.2 RFU},
				Table[{x,x^3+RandomReal[2.5]},{x,-2,2,0.1}],
				InversePrediction->True,FitType->Cubic,Upload->False,Output->Preview
			],
			ValidGraphicsP[],
			Messages:>{Warning::UnspecifiedUnits}
		],
		Example[{Options,InversePrediction,"Use inverse prediction to transform y-values to x-values using an existing fit:"},
			AnalyzeStandardCurve[{1.0 Second, 3.14159 Second, 4.7 Second},myLineFit,InversePrediction->True,Upload->False,Output->Preview],
			ValidGraphicsP[]
		],
		Test["Unspecified input units warning works when standard data is supplied as an existing fit:",
			AnalyzeStandardCurve[{1.0, 3.14159, 4.7},myLineFit,Upload->False,Output->Preview],
			ValidGraphicsP[],
			Messages:>{Warning::UnspecifiedUnits}
		],
		Test["Unspecified input units warning works when standard data is supplied as an existing fit and inverse prediction is True:",
			AnalyzeStandardCurve[{1.0, 3.14159, 4.7},myLineFit,InversePrediction->True,Upload->False,Output->Preview],
			ValidGraphicsP[],
			Messages:>{Warning::UnspecifiedUnits}
		],
		Test["Unspecified input units warning works when standard data is supplied as an existing fit:",
			AnalyzeStandardCurve[{1.0 Meter, 3.14159 Meter, 4.7 Meter},myUnitlessLineFit,Upload->False,Output->Preview],
			ValidGraphicsP[],
			Messages:>{Warning::UnspecifiedUnits}
		],
		Test["Unspecified input units warning works when standard data is supplied as an existing fit and inverse prediction is True:",
			AnalyzeStandardCurve[{1.0 Meter, 3.14159 Meter, 4.7 Meter},myUnitlessLineFit,InversePrediction->True,Upload->False,Output->Preview],
			ValidGraphicsP[],
			Messages:>{Warning::UnspecifiedUnits}
		],
		Test["Incompatible units warning works when standard data is an existing fit:",
			AnalyzeStandardCurve[{1.0 RFU, 3.14159 RFU, 4.7 RFU},myLineFit],
			$Failed,
			Messages:>{Error::ExistingFitIncompatibleUnits,Error::InvalidOption}
		],
		Test["Incompatible units warning works when standard data is an existing fit with inverse prediction on:",
			AnalyzeStandardCurve[{1.0 RFU,3.14159 RFU,4.7 RFU},myLineFit,InversePrediction->True],
			$Failed,
			Messages:>{Error::ExistingFitIncompatibleUnits,Error::InvalidOption}
		],
		Test["Resolved options does not contain any instances of $Failed or Automatic (except Method, from AnalyzeFit):",
			DeleteCases[AnalyzeStandardCurve[{1.4 Lumen, 2.2 Lumen, 3.6 Lumen},
				{
					{1.0 Lumen,Object[Data,qPCR,"ASC Test qPCR Standard 1-1"]},
					{2.0 Lumen,Object[Data,qPCR,"ASC Test qPCR Standard 1-2"]},
					{3.0 Lumen,Object[Data,qPCR,"ASC Test qPCR Standard 1-3"]},
					{4.0 Lumen,Object[Data,qPCR,"ASC Test qPCR Standard 1-4"]}
				},
				StandardFields->{None,QuantificationCycleAnalyses[QuantificationCycle]},
				FitType->Linear,
				Output->Options,
				Upload->False
			],Method->Automatic],
			{(Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]])..}
		],
		Example[{Messages,"MissingStandardData","Standard data must be supplied for analysis:"},
			AnalyzeStandardCurve[{{1,2,3,4}},Automatic],
			$Failed,
			Messages:>{
				Error::MissingStandardData,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InconsistentUnitsAll","All input datasets must have compatible units:"},
			AnalyzeStandardCurve[
				{{3.14159 RFU},QuantityArray[{1.0,2.0},Meter]},
				simpleLineWithUnits
			],
			$Failed,
			Messages:>{
				Error::InconsistentUnitsAll,
				Error::InvalidInput
			}
		],
		Example[{Messages,"InconsistentUnitsEach","All datapoints within a single dataset must have compatible physical units:"},
			AnalyzeStandardCurve[
				{{1.0 Meter,2.0 RFU,3.0 Second},{2 Meter}},
				simpleLineWithUnits
			],
			$Failed,
			Messages:>{
				Error::InconsistentUnitsEach,
				Error::InvalidInput
			}
		],
		Example[{Messages,"ExistingFitIncompatibleUnits","The Units of the Fit object provided as a standard curve are incompatible with input units:"},
			myLineFit=AnalyzeFit[Normal@simpleLineWithUnits];
			AnalyzeStandardCurve[
				{3.14159 RFU},
				myLineFit
			],
			$Failed,
			Messages:>{
				Error::ExistingFitIncompatibleUnits,
				Error::InvalidOption
			}
		],
		Example[{Messages,"DefaultFitTypeUndefined","The standard data type is not associated with a default model type, and by default a linear fit will be constructed:"},
			AnalyzeStandardCurve[{17 Cycle, 21.1 Cycle, 23 Cycle},
				{Object[Data,qPCR,"ASC Test qPCR Standard 1-1"],Object[Data,qPCR,"ASC Test qPCR Standard 1-2"],Object[Data,qPCR,"ASC Test qPCR Standard 1-3"],Object[Data,qPCR,"ASC Test qPCR Standard 1-4"]},
				StandardTransformationFunctions->{None,Function[{x},Log10[x]]},
				Output->Preview
			],
			ValidGraphicsP[],
			Messages:>{
				Warning::DefaultFitTypeUndefined
			}
		],
		Example[{Messages,"DefaultFieldUndefined","Object(s) provided in StandardData do not have default fields defined, and StandardFields must be specified manually:"},
			AnalyzeStandardCurve[{21,22,23},
				Object[User,Emerald,Developer,"id:qdkmxzq7M3xx"]
			],
			$Failed,
			Messages:>{Error::DefaultFieldUndefined,Error::InvalidOption}
		],
		Example[{Messages,"EmptyStandardField","The object(s) and fields specified in StandardData and StandardFields point to one or more empty fields:"},
			AnalyzeStandardCurve[{12 Cycle,14.1 Cycle,18 Cycle},
				{
					Object[Data,qPCR,"ASC Test qPCR Standard 1-1"],
					Object[Data,qPCR,"ASC Test qPCR Standard 1-2"],
					Object[Data,qPCR,"ASC Test qPCR Standard 1-3"],
					Object[Data,qPCR,"ASC Test qPCR Standard 1-4"]
				},
				StandardFields->{QuantificationCycleAnalyses[QuantificationCycle],DataFile},
				FitType->Linear
			],
			$Failed,
			Messages:>{Error::EmptyStandardField,Error::InvalidOption}
		],
		Example[{Messages,"InvalidStandardField","The supplied StandardFields are not valid fields of the objects in StandardData:"},
			AnalyzeStandardCurve[{12 Cycle,14.1 Cycle,18 Cycle},
				{
					Object[Data,qPCR,"ASC Test qPCR Standard 1-1"],
					Object[Data,qPCR,"ASC Test qPCR Standard 1-2"],
					Object[Data,qPCR,"ASC Test qPCR Standard 1-3"],
					Object[Data,qPCR,"ASC Test qPCR Standard 1-4"]
				},
				StandardFields->{QuantificationCycleAnalyses[QuantificationCycle],Protein},
				FitType->Linear
			],
			$Failed,
			Messages:>{Error::InvalidStandardField,Error::InvalidOption}
		],
		Example[{Messages,"InvalidStandardDataFormat","The standard data specified by StandardData, StandardFields, and StandardTransformationFunctions must be a valid list of coordinates:"},
			AnalyzeStandardCurve[{12,14,16},
				Object[Data,ELISA,"Mismatched ELISA Data"],
				FitType->Linear
			],
			$Failed,
			Messages:>{Error::InvalidStandardDataFormat,Error::InvalidOption}
		],
		Example[{Messages,"InconsistentObjectTypes","If input data is provided as a list of objects, these objects must have the same type:"},
			AnalyzeStandardCurve[
				{
					{{Object[Data,qPCR,"ASC Test qPCR Sample 1-1"],Object[Data,ELISA,"ASC Test qPCR Sample 1-2"]},Automatic},
					{1,2,3},
					{{Object[Data,qPCR,"ASC Test qPCR Sample 1-1"],Object[Data,ELISA,"ASC Test qPCR Sample 1-2"]},Automatic},
					{{Object[Data,qPCR,"ASC Test qPCR Sample 1-1"],Object[Data,qPCR,"ASC Test qPCR Sample 1-2"]},Automatic}
				},
				{
					Object[Data,qPCR,"ASC Test qPCR Standard 1-1"],
					Object[Data,qPCR,"ASC Test qPCR Standard 1-2"],
					Object[Data,qPCR,"ASC Test qPCR Standard 1-3"],
					Object[Data,qPCR,"ASC Test qPCR Standard 1-4"]
				},
				StandardTransformationFunctions->{None,Function[{x},Log10[x]]},
				FitType->Linear
			],
			$Failed,
			Messages:>{Error::InconsistentObjectTypes,Error::InvalidInput}
		],
		Example[{Messages,"InconsistentObjectTypes","If standard data is provided as a list or mixed list of objects, these objects must have the same type:"},
			AnalyzeStandardCurve[{12 Cycle, 14.1 Cycle, 18 Cycle},
				{
					Object[Data,qPCR,"ASC Test qPCR Standard 1-1"],
					Object[Data,qPCR,"ASC Test qPCR Standard 1-2"],
					Object[Data,ELISA,"ASC Test qPCR Standard 1-3"],
					Object[Data,qPCR,"ASC Test qPCR Standard 1-4"]
				},
				StandardTransformationFunctions->{None,Function[{x},Log10[x]]},
				FitType->Linear
			],
			$Failed,
			Messages:>{Error::InconsistentObjectTypes,Error::InvalidOption}
		],
		Example[{Messages,"DefaultFieldUndefined","If the input data is provided as object(s) and these types do not have default fields defined, InputFields must be specified explicitly:"},
			AnalyzeStandardCurve[
				{
					{1,2,3},
					{Object[User,Emerald,Developer,"id:qdkmxzq7M3xx"],Automatic},
					{Object[User,Emerald,Developer,"id:qdkmxzq7M3xx"],Automatic},
					{{Object[Data,qPCR,"ASC Test qPCR Sample 1-1"],Object[Data,qPCR,"ASC Test qPCR Sample 1-2"]},Automatic}
				},
				{
					Object[Data,qPCR,"ASC Test qPCR Standard 1-1"],
					Object[Data,qPCR,"ASC Test qPCR Standard 1-2"],
					Object[Data,qPCR,"ASC Test qPCR Standard 1-3"],
					Object[Data,qPCR,"ASC Test qPCR Standard 1-4"]
				},
				StandardTransformationFunctions->{None,Function[{x},Log10[x]]},
				FitType->Linear
			],
			$Failed,
			Messages:>{Error::DefaultFieldUndefined,Error::InvalidInput}
		],
		Example[{Messages,"InvalidInputDataFormat","Input data must resolve to a list of numerical values, quantities, or distributions:"},
			AnalyzeStandardCurve[
				{
					{1,2,3},
					{1,2,3},
					{1,2,3}
				},
				simpleLineCoordinates,
				InputTransformationFunction->{Function[{x},1*x],Function[{x},{2.1*x,x}],Function[{x},3.2*x]}
			],
			$Failed,
			Messages:>{Error::InvalidInputDataFormat,Error::InvalidInput}
		],
		Example[{Messages,"StandardDataInconsistentUnits","Standard Data must have self-consistent units, i.e. all x- and y-values have the same units, respectively:"},
			AnalyzeStandardCurve[
		 		{1.0 Meter, 2.0 Meter},
		 		{{1.0 Second, 2.0 RFU}, {2.0 Mole/Liter, 3.0 RFU}, {3.0 Second, 4.0 RFU}}
		 	],
			$Failed,
			Messages:>{Error::StandardDataInconsistentUnits,Error::InvalidOption}
		],
		Example[{Messages,"StandardDataIncompatibleUnits","The independent variable units of standard data must be compatible with input data units:"},
			AnalyzeStandardCurve[
		 		{1.0 Meter, 2.0 Meter},
		 		{{1.0 Second,2.0 RFU},{2.0 Second,3.0 RFU},{3.0 Second,4.0 RFU}}
		 	],
			$Failed,
			Messages:>{Error::StandardDataIncompatibleUnits,Error::InvalidOption}
		],
		Example[{Messages,"InvalidProtocolField","Input Protocol objects must have valid, non-empty Data and StandardData fields:"},
			AnalyzeStandardCurve[
				Object[Protocol,CapillaryELISA,"AnalyzeStandardCurve Test CapillaryELISA Protocol 3"],
				FitType->Linear
			],
			$Failed,
			Messages:>{Error::InvalidProtocolField,Error::InvalidInput}
		],
		Example[{Messages,"AnalyzeFit","If there are failures during curve-fitting with AnalyzeFit, messages will be collected and grouped:"},
			AnalyzeStandardCurve[{4, 5}, {{3, 3}, {3, -2}, {3, 0}}, FitType -> Polynomial, PolynomialDegree -> 10],
			$Failed,
			Messages:>{Warning::SystemMessages,AnalyzeFit::InvalidPolynomialDegree,Error::InvalidOption,Error::AnalyzeFit}
		],
		Example[{Messages,"ProtocolAlreadySet","If the input is a Protocol, then the Protocol option will be unused. The hidden option Protocol is used to link standard curve analyses corresponding to the same protocol input, and is redundant in this case:"},
			AnalyzeStandardCurve[
				Object[Protocol,CapillaryELISA,"AnalyzeStandardCurve Test CapillaryELISA Protocol 2"],
				Protocol->Object[Protocol,CapillaryELISA,"Any Protocol"],
				Output -> {Result,Preview},
				FitType->Linear
			],
			{{ObjectP[Object[Analysis, StandardCurve]] ..}, _},
			Messages:>{Warning::ProtocolAlreadySet}
		],
		Example[{Messages,"DuplicateStandardData","Provide a warning message if user has specified multiple sets of Standard Data for the same analyte in input protocol:"},
			AnalyzeStandardCurve[
				Object[Protocol,CapillaryELISA,"AnalyzeStandardCurve Test CapillaryELISA Protocol Multiplex 2"],
				Output->{Result,Preview}
			],
			{{ObjectP[Object[Analysis, StandardCurve]]..}, _},
			Messages:>{Warning::DuplicateStandardData}
		],
		Example[{Messages,"UnspecifiedUnits","If Standard Curve has unitless independent variables, apply the input units and warn the user:"},
			AnalyzeStandardCurve[{3.3 Meter, 4.1 Meter},simpleLineCoordinates][PredictedValues],
			{3.3,4.1},
			EquivalenceFunction->Function[{x,y},MatchQ[RoundReals[Mean/@x,3],RoundReals[y,3]]],
			Messages:>{Warning::UnspecifiedUnits},
			Stubs:>{
				AnalyzeStandardCurve[{3.3 Meter, 4.1 Meter},simpleLineCoordinates]=stripAppendReplaceKeyHeads[
					AnalyzeStandardCurve[{3.3 Meter, 4.1 Meter},{{0.,0.},{1.,1.},{2.,2.},{3.,3.},{4.,4.},{5.,5.}},Upload->False]
				]
			}
		],
		Example[{Messages,"UnspecifiedUnits","If input data is unitless, apply the units of the Standard Curve and warn the user:"},
			AnalyzeStandardCurve[{3.3, 4.1},simpleLineWithUnits][PredictedValues],
			Normal@QuantityArray[{3.3,4.1},Second],
			EquivalenceFunction->Function[{x,y},MatchQ[RoundReals[Mean/@x,3],RoundReals[y,3]]],
			Messages:>{Warning::UnspecifiedUnits},
			Stubs:>{
				AnalyzeStandardCurve[{3.3, 4.1},simpleLineWithUnits]=stripAppendReplaceKeyHeads[
					AnalyzeStandardCurve[{3.3, 4.1},QuantityArray[{{0.,0.},{1.,1.},{2.,2.},{3.,3.},{4.,4.},{5.,5.}},{Meter,Second}],Upload->False]
				]
			}
		],
		Example[{Messages,"Extrapolation","Warn the user if input data is outside of the range of provided standard data:"},
			PlotStandardCurve@AnalyzeStandardCurve[{0.01 Kilometer},
				QuantityArray[{{0,-1},{1,4},{2,9},{3,2},{4,-3},{5,-1}},{Meter, RFU}],
				FitType -> Cubic,
				Upload -> False
			],
			ValidGraphicsP[],
			Messages:>{Warning::Extrapolation}
		],
		Example[{Messages,"InputFieldOverride","Warn the user if the InputField option is overriding a field specified by an {obj,field} pair:"},
			PlotStandardCurve@AnalyzeStandardCurve[
				{
					{Object[Data, MassSpectrometry,"id:O81aEBZw1ex1"],MaxMass},
					{Object[Data, MassSpectrometry,"id:O81aEBZw1ex1"],MinMass}
				},
				QuantityArray[{{0.0, 0.0},{2.0, 3.3},{4.0, 4.7},{6.0, 8.1},{8.0,9.7}},{Kilogram/Mole, RFU}],
				InputField->MinMass,
				FitType->Linear,
				Upload->False
			],
			ValidGraphicsP[],
			Messages:>{Warning::InputFieldOverride}
		],
		Example[{Messages,"StandardFieldOverride","Warn the user if the StandardData option is overriding standard data specified in input:"},
			PlotStandardCurve@AnalyzeStandardCurve[
				{1.0,2.0,3.0},
				{ {0.0,2.0,3.0,5.0}, {1.0,4.0,7.0,15.0} },
				StandardData->{{0,-1},{2,-4},{3,-7},{4,-15}},
				Upload->False
			],
			ValidGraphicsP[],
			Messages:>{Warning::StandardFieldOverride}
		],
		Example[{Messages,"StandardFieldOverride","Warn the user if the StandardFields option is overriding standard fields specified in input:"},
			AnalyzeStandardCurve[
				{1.0 RFU,2.0 RFU,3.0 RFU},
				{Object[Data,ELISA,"ASC Test ELISA Standard 2"],{Intensities,DilutionFactors}},
				StandardFields->{Intensities,Intensities},
				FitType->Linear,
				Output->Preview
			],
			ValidGraphicsP[],
			Messages:>{Warning::StandardFieldOverride}
		],
		Example[{Messages,"InputContainsTemporalLinks","Warn the user if either the input or standard data has been specified as a temporal link:"},
			AnalyzeStandardCurve[
				{1.0 RFU,2.0 RFU,3.0 RFU},
				{Link[Object[Data,ELISA,"ASC Test ELISA Standard 2"],DateObject["Now"]],{Intensities,DilutionFactors}},
				FitType->Linear,
				Output->Preview
			],
			ValidGraphicsP[],
			Messages:>{Warning::InputContainsTemporalLinks}
		],
		Test["Extrapolation testing valid if input data is unitless but standard data has units:",
			PlotStandardCurve@AnalyzeStandardCurve[{3.3, 6.1},simpleLineWithUnits,Upload->False],
			ValidGraphicsP[],
			Messages:>{Warning::UnspecifiedUnits,Warning::Extrapolation}
		],
		Test["Extrapolation testing valid if standard data is unitless but input data has units:",
			PlotStandardCurve@AnalyzeStandardCurve[{-3.3 Meter, 4.1 Meter},simpleLineCoordinates,Upload->False],
			ValidGraphicsP[],
			Messages:>{Warning::UnspecifiedUnits,Warning::Extrapolation}
		]
	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	SymbolSetUp:>(
		$CreatedObjects={};
		ClearMemoization[];
		Module[{allDataObjects,testProtocolObjects,testProtocolDataObjects,allObjects,existingObjects},

			(* Gather all the objects and models created in SymbolSetUp *)
			allDataObjects={
				Object[Data,ELISA,"ASC Test ELISA Sample 1"],
				Object[Data,ELISA,"ASC Test ELISA Sample 2"],
				Object[Data,ELISA,"ASC Test ELISA Standard 1"],
				Object[Data,ELISA,"ASC Test ELISA Standard 2"],
				Object[Data,ELISA,"Mismatched ELISA Data"],
				Object[Analysis,QuantificationCycle,"ASC Test QC Sample 1-1"],
				Object[Analysis,QuantificationCycle,"ASC Test QC Sample 1-2"],
				Object[Analysis,QuantificationCycle,"ASC Test QC Sample 2-1"],
				Object[Analysis,QuantificationCycle,"ASC Test QC Standard 1-1"],
				Object[Analysis,QuantificationCycle,"ASC Test QC Standard 1-2"],
				Object[Analysis,QuantificationCycle,"ASC Test QC Standard 1-3"],
				Object[Analysis,QuantificationCycle,"ASC Test QC Standard 1-4"],
				Object[Analysis,CopyNumber,"ASC Test CN Standard 1-1"],
				Object[Analysis,CopyNumber,"ASC Test CN Standard 1-2"],
				Object[Analysis,CopyNumber,"ASC Test CN Standard 1-3"],
				Object[Analysis,CopyNumber,"ASC Test CN Standard 1-4"],
				Object[Data,qPCR,"ASC Test qPCR Sample 1-1"],
				Object[Data,qPCR,"ASC Test qPCR Sample 1-2"],
				Object[Data,qPCR,"ASC Test qPCR Sample 2-1"],
				Object[Data,qPCR,"ASC Test qPCR Standard 1-1"],
				Object[Data,qPCR,"ASC Test qPCR Standard 1-2"],
				Object[Data,qPCR,"ASC Test qPCR Standard 1-3"],
				Object[Data,qPCR,"ASC Test qPCR Standard 1-4"],
				Model[Molecule,Protein,"AnalyzeStandardCurve Test Analyte 1"],
				Model[Molecule,Protein,"AnalyzeStandardCurve Test Analyte 2"],
				Model[Molecule,Protein,"AnalyzeStandardCurve Test Multiplex Analyte 1"],
				Model[Molecule,Protein,"AnalyzeStandardCurve Test Multiplex Analyte 2"],
				Model[Molecule,Protein,"AnalyzeStandardCurve Test Multiplex Analyte 3"],
				Model[Molecule,Protein,"AnalyzeStandardCurve Test Multiplex Analyte 4"],
				Model[Molecule,Protein,"AnalyzeStandardCurve Test Multiplex Analyte 5"],
				Model[Molecule,Protein,"AnalyzeStandardCurve Test Multiplex Analyte 6"],
				Model[Molecule,Protein,"AnalyzeStandardCurve Test Multiplex Analyte 7"],
				Model[Molecule,Protein,"AnalyzeStandardCurve Test Multiplex Analyte 8"]
			};

			(* Gather all protocols generated in SymbolSetUp for Unit Tests *)
			testProtocolObjects={
				Object[Protocol,CapillaryELISA,"AnalyzeStandardCurve Test CapillaryELISA Protocol 2"],
				Object[Protocol,CapillaryELISA,"AnalyzeStandardCurve Test CapillaryELISA Protocol 3"],
				Object[Protocol,CapillaryELISA,"AnalyzeStandardCurve Test CapillaryELISA Protocol Multiplex 2"]
			};

			(* Gather names of all data objects generated to populate test protocols *)
			testProtocolDataObjects=Join[
				Map[Object[Data,ELISA,"AnalyzeStandardCurve Test Multiplex ELISA data for Standard Sample "<>ToString[#]]&,Range[1,3]],
				Map[Object[Data,ELISA,"AnalyzeStandardCurve Test Multiplex ELISA data for Unknown Sample "<>ToString[#]]&,Range[1,10]],
				Map[Object[Data,ELISA,"AnalyzeStandardCurve Test ELISA data for Standard Sample "<>ToString[#]]&,Range[1,2]],
				Map[Object[Data,ELISA,"AnalyzeStandardCurve Test ELISA data for Unknown Sample "<>ToString[#]]&,Range[1,10]],
				Map[Object[Sample,"AnalyzeStandardCurve Test Sample "<>ToString[#]]&,Range[1,10]],
				Map[Object[Sample,"AnalyzeStandardCurve Test Standard "<>ToString[#]]&,Range[1, 2]],
				Map[Object[Sample,"AnalyzeStandardCurve Test Multiplex Standard "<>ToString[#]]&,Range[1,3]],
				Map[Object[Container,Vessel,"AnalyzeStandardCurve Test Container "<>ToString[#]]&,Range[1,10]],
				Map[Object[Container,Vessel,"AnalyzeStandardCurve Test Standard Container "<>ToString[#]]&,Range[1,2]],
				Map[Object[Container,Vessel,"AnalyzeStandardCurve Test Multiplex Standard Container "<>ToString[#]]&,Range[1,3]]
			];

			(* All object names generated for AnalyzeStandardCurve unit tests *)
			allObjects=Join[allDataObjects,testProtocolObjects,testProtocolDataObjects];

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(* Erase any test objects and models that we failed to erase in the last unit test *)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];

		(* Generate some fake data sets *)
		SeedRandom[123];
		sample1DataELISA=QuantityDistribution[NormalDistribution[RandomReal[{0.8*#,1.2*#}],RandomReal[{0,1}]],RFU]&/@{2.2};
		sample2DataELISA=QuantityDistribution[NormalDistribution[RandomReal[{0.8*#,1.2*#}],RandomReal[{0,1}]],RFU]&/@{5.0,5.0};
		standardXDataELISA=10^Range[-3,0,0.2];
		standardYDataELISA=QuantityDistribution[NormalDistribution[4*(1.0-(1.0/(1 +((3.0+#)/1.4)^6)))+RandomReal[0.2],RandomReal[0.02]],RFU]&/@Range[-3,0,0.2];
		standardXDataELISA2=(1.0-(1.0/(1 +(#/0.45)^3)))&/@Table[i,{i,0,1,0.05}];
		standardYDataELISA2=QuantityDistribution[NormalDistribution[RandomReal[{0.95*#,1.05*#}],RandomReal[{0,0.1}]],RFU]&/@Table[i,{i,0,10,0.5}];
		badXDataELISA=RandomReal[{0.8*#,1.0*#}]&/@{0.2,0.8,1.0};

		(* Upload test data objects for ELISA *)
		Upload[{
			<|
				Type->Object[Data,ELISA],
				Name->"ASC Test ELISA Sample 1",
				Replace[Intensities]->sample1DataELISA,
				DeveloperObject->True
			|>,
			<|
				Type->Object[Data,ELISA],
				Name->"ASC Test ELISA Sample 2",
				Replace[Intensities]->sample2DataELISA,
				DeveloperObject->True
			|>,
			<|
				Type->Object[Data,ELISA],
				Name->"ASC Test ELISA Standard 1",
				Replace[Intensities]->standardYDataELISA,
				Replace[DilutionFactors]->standardXDataELISA,
				DeveloperObject->True
			|>,
			<|
				Type->Object[Data,ELISA],
				Name->"ASC Test ELISA Standard 2",
				Replace[Intensities]->standardYDataELISA2,
				Replace[DilutionFactors]->standardXDataELISA2,
				DeveloperObject->True
			|>,
			<|
				Type->Object[Data,ELISA],
				Name->"Mismatched ELISA Data",
				Replace[Intensities]->standardYDataELISA,
				Replace[DilutionFactors]->badXDataELISA,
				DeveloperObject->True
			|>
		}];

		(* Create QuantificationCycle Analysis objects for Copy Number analysis *)
		sample1QCObjects=Upload[{
			<|
				Type->Object[Analysis,QuantificationCycle],
				Name->"ASC Test QC Sample 1-1",
				QuantificationCycle->16.9 Cycle,
				DeveloperObject->True
			|>,
			<|
				Type->Object[Analysis,QuantificationCycle],
				Name->"ASC Test QC Sample 1-2",
				QuantificationCycle->17.3 Cycle,
				DeveloperObject->True
			|>
		}];

		sample2QCObjects=Upload[{
			<|
				Type->Object[Analysis,QuantificationCycle],
				Name->"ASC Test QC Sample 2-1",
				QuantificationCycle->22.1 Cycle,
				DeveloperObject->True
			|>
		}];

		standard1QCObjects=Upload[{
			<|
				Type->Object[Analysis,QuantificationCycle],
				Name->"ASC Test QC Standard 1-1",
				QuantificationCycle->24.7 Cycle,
				DeveloperObject->True
			|>,
			<|
				Type->Object[Analysis,QuantificationCycle],
				Name->"ASC Test QC Standard 1-2",
				QuantificationCycle->21.6 Cycle,
				DeveloperObject->True
			|>,
			<|
				Type->Object[Analysis,QuantificationCycle],
				Name->"ASC Test QC Standard 1-3",
				QuantificationCycle->18.2 Cycle,
				DeveloperObject->True
			|>,
			<|
				Type->Object[Analysis,QuantificationCycle],
				Name->"ASC Test QC Standard 1-4",
				QuantificationCycle->15.0 Cycle,
				DeveloperObject->True
			|>
		}];

		(* Create CopyNumber Analysis objects *)
		standard1CopyObjects=Upload[{
			<|
				Type->Object[Analysis,CopyNumber],
				Name->"ASC Test CN Standard 1-1",
				CopyNumber->1000,
				DeveloperObject->True
			|>,
			<|
				Type->Object[Analysis,CopyNumber],
				Name->"ASC Test CN Standard 1-2",
				CopyNumber->10000,
				DeveloperObject->True
			|>,
			<|
				Type->Object[Analysis,CopyNumber],
				Name->"ASC Test CN Standard 1-3",
				CopyNumber->100000,
				DeveloperObject->True
			|>,
			<|
				Type->Object[Analysis,CopyNumber],
				Name->"ASC Test CN Standard 1-4",
				CopyNumber->1000000,
				DeveloperObject->True
			|>
		}];

		(* Create qPCR data objects linked to both QC and CopyNumber Analyses *)
		MapThread[
			Upload[<|
				Type->Object[Data,qPCR],
				Name->"ASC Test qPCR Standard 1-"<>ToString[#3],
				Replace[QuantificationCycleAnalyses]->Link[#1,Reference],
				Replace[CopyNumberAnalyses]->Link[#2,Data],
				DeveloperObject->True
			|>]&,
			{standard1QCObjects,standard1CopyObjects,Range[Length[standard1QCObjects]]}
		];

		MapThread[
			Upload[<|
				Type->Object[Data,qPCR],
				Name->"ASC Test qPCR Sample 1-"<>ToString[#2],
				Replace[QuantificationCycleAnalyses]->Link[#1,Reference],
				DeveloperObject->True
			|>]&,
			{sample1QCObjects,Range[Length[sample1QCObjects]]}
		];

		MapThread[
			Upload[<|
				Type->Object[Data,qPCR],
				Name->"ASC Test qPCR Sample 2-"<>ToString[#2],
				Replace[QuantificationCycleAnalyses]->Link[#1,Reference],
				DeveloperObject->True
			|>]&,
			{sample2QCObjects,Range[Length[sample2QCObjects]]}
		];

		(* Create some dummy analytes to test ELISA Protocol input *)
		Upload[{
			<|
				Type->Model[Molecule, Protein],
				Name->"AnalyzeStandardCurve Test Analyte 1",
				DeveloperObject->True
			|>,
			<|
				Type -> Model[Molecule, Protein],
				Name -> "AnalyzeStandardCurve Test Analyte 2",
				DeveloperObject->True
			|>,
			<|
				Type->Model[Molecule, Protein],
				Name->"AnalyzeStandardCurve Test Multiplex Analyte 1",
				DeveloperObject->True
			|>,
			<|
				Type->Model[Molecule, Protein],
				Name->"AnalyzeStandardCurve Test Multiplex Analyte 2",
				DeveloperObject->True
			|>,
			<|
				Type->Model[Molecule, Protein],
				Name->"AnalyzeStandardCurve Test Multiplex Analyte 3",
				DeveloperObject->True
			|>,
			<|
				Type->Model[Molecule, Protein],
				Name->"AnalyzeStandardCurve Test Multiplex Analyte 4",
				DeveloperObject->True
			|>,
			<|
				Type->Model[Molecule, Protein],
				Name->"AnalyzeStandardCurve Test Multiplex Analyte 5",
				DeveloperObject->True
			|>,
			<|
				Type->Model[Molecule, Protein],
				Name->"AnalyzeStandardCurve Test Multiplex Analyte 6",
				DeveloperObject->True
			|>,
			<|
				Type->Model[Molecule, Protein],
				Name->"AnalyzeStandardCurve Test Multiplex Analyte 7",
				DeveloperObject->True
			|>,
			<|
				Type->Model[Molecule, Protein],
				Name->"AnalyzeStandardCurve Test Multiplex Analyte 8",
				DeveloperObject->True
			|>
		}];
		
		Module[{testBench},
			
			(* Test bench to upload samples *)
			testBench = Upload[<|
				Type -> Object[Container, Bench],
				Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
				Name -> "Testing bench for AnalyzeStandardCurve" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>];
			
			(* Upload 10 fake samples for ELISA Protocol *)
			ECL`InternalUpload`UploadSample[
				ConstantArray[Model[Container,Vessel,"2mL Tube"],10],
				ConstantArray[{"Work Surface",testBench},10],
				Name->Map[("AnalyzeStandardCurve Test Container "<>ToString[#])&,Range[1,10]]
			];
			
			(* Upload two fake standards for ELISA Protocol *)
			ECL`InternalUpload`UploadSample[
				ConstantArray[Model[Container,Vessel,"2mL Tube"],2],
				ConstantArray[{"Work Surface",testBench},2],
				Name->Map[("AnalyzeStandardCurve Test Standard Container "<>ToString[#])&,Range[1,2]]
			];
			
			(* Upload multiplex standards for ELISA Protocol *)
			ECL`InternalUpload`UploadSample[
				ConstantArray[Model[Container,Vessel,"2mL Tube"],3],
				ConstantArray[{"Work Surface",testBench},3],
				Name->Map[("AnalyzeStandardCurve Test Multiplex Standard Container "<>ToString[#])&,Range[1,3]]
			];
			
		];

		ECL`InternalUpload`UploadSample[
			ConstantArray[Model[Sample,"Milli-Q water"],10],
			Map[{"A1",Object[Container,Vessel,"AnalyzeStandardCurve Test Container "<>ToString[#]]}&,Range[1,10]],
			InitialAmount->1 Milliliter,
			Name->Map[("AnalyzeStandardCurve Test Sample "<>ToString[#])&,Range[1,10]]
		];

		ECL`InternalUpload`UploadSample[
			ConstantArray[Model[Sample,StockSolution,"Filtered PBS, Sterile"],2],
			Map[{"A1",Object[Container,Vessel,"AnalyzeStandardCurve Test Standard Container "<>ToString[#]]}&,Range[1, 2]],
			InitialAmount->1 Milliliter,
			Name->Map[("AnalyzeStandardCurve Test Standard "<>ToString[#])&,Range[1, 2]]
		];

		ECL`InternalUpload`UploadSample[
			ConstantArray[Model[Sample,StockSolution,"Filtered PBS, Sterile"],3],
			Map[{"A1",Object[Container,Vessel,"AnalyzeStandardCurve Test Multiplex Standard Container "<>ToString[#]]}&,Range[1,3]],
			InitialAmount->1 Milliliter,
			Name->Map[("AnalyzeStandardCurve Test Multiplex Standard "<>ToString[#])&,Range[1,3]]
		];

		(* Create and upload Capillary ELISA Sample Data Objects *)
		nameList=Map[("AnalyzeStandardCurve Test ELISA data for Unknown Sample "<>ToString[#])&,Range[1,10]];

		(* Get names of samples *)
		samplesInList=Map[Object[Sample,"AnalyzeStandardCurve Test Sample "<>ToString[#]]&,Range[1,10]];

		(* Create a list of analyte names*)
		analyteList=Join[
			ConstantArray[Model[Molecule,Protein,"AnalyzeStandardCurve Test Analyte 1"],5],
			ConstantArray[Model[Molecule, Protein,"AnalyzeStandardCurve Test Analyte 2"],5]
		];

		(* Generate dummy dilution factor values*)
		dilutionFactorList=Flatten[ConstantArray[{{0.5,0.4,0.3,0.2,0.1},{0.5,0.1,0.05}},5],1];

		(* Generate dummy intensity values by adding noise to a line *)
		intensitiesList=Map[
			NormalDistribution[RandomReal[{90*#,110*#}]*RFU,RandomReal[{0,2}]*RFU]&,
			dilutionFactorList,
			{2}
		];

		(* Format packets for the dummy ELISA data objects *)
		allDataUploads=MapThread[
			<|
				Type->Object[Data,ELISA],
				Name->#1,
				Replace[SamplesIn]->{Link[#2, Data]},
				AssayType->CapillaryELISA,
				DataType->Unknown,
				Multiplex->False,
				Analyte->Link[#3],
				Replace[DilutionFactors]->#4,
				Replace[Intensities]->#5
			|>&,
			{nameList,samplesInList,analyteList,dilutionFactorList,intensitiesList}
		];

		(* Upload all of the test ELISA data objects corresponding to samples *)
		Upload[allDataUploads];

		(* Create and upload Capillary ELISA Sample Data Objects *)
		nameListStandard=Map[("AnalyzeStandardCurve Test ELISA data for Standard Sample "<>ToString[#])&,Range[1,2]];
		nameList=Map[("AnalyzeStandardCurve Test ELISA data for Unknown Sample "<>ToString[#])&,Range[1,10]];

		(* Get names of samples *)
		samplesInListStandard=Map[Object[Sample,"AnalyzeStandardCurve Test Standard "<>ToString[#]]&,Range[1,2]];

		(* Create a list of analyte names *)
		analyteListStandard={
			Model[Molecule, Protein,"AnalyzeStandardCurve Test Analyte 1"],
			Model[Molecule, Protein, "AnalyzeStandardCurve Test Analyte 2"]
		};

		(* Generate dummy dilution factor values*)
		dilutionFactorListStandard={
			{0.5,0.45,0.4,0.35,0.3,0.25,0.2,0.15,0.1,0.05,0.001},
			{0.5,0.25,0.1,0.05,0.02,0.01,0.005,0.001}
		};

		(* Generate dummy intensity values by adding noise to a line *)
		intensitiesListStandard=Map[
			NormalDistribution[RandomReal[{400*#, 410*#}]*RFU,RandomReal[{0, 1}]*RFU]&,
			dilutionFactorListStandard,
			{2}
		];

		(* Generate dummy compositions for ELISA test objects *)
		standardCompositionList={
			{Link[Model[Molecule,Protein,"AnalyzeStandardCurve Test Analyte 1"]],1000000 Picogram/Milliliter},
			{Link[Model[Molecule, Protein, "AnalyzeStandardCurve Test Analyte 2"]],2000 Picogram/Milliliter}
		};

		(* Format packets for the dummy ELISA data objects *)
		allStandardDataUploads=MapThread[
			<|
				Type->Object[Data,ELISA],
				Name->#1,
				Replace[SamplesIn]->{Link[#2, Data]},
				AssayType->CapillaryELISA,
				DataType->Standard,
				Multiplex->False,
				Analyte->Link[#3],
				Replace[DilutionFactors]->#4,
				Replace[Intensities]->#5,
				Replace[StandardCompositions]->{#6},
				DeveloperObject->True
			|>&,
			{
				nameListStandard,samplesInListStandard,analyteListStandard,
				dilutionFactorListStandard,intensitiesListStandard,standardCompositionList
			}
		];

		(* Upload Capillary ELISA Standard Data objects *)
		Upload[allStandardDataUploads];

		(* Create and upload Capillary ELISA Multiplex Sample Data Objects *)
		nameMultiplexList=Map[("AnalyzeStandardCurve Test Multiplex ELISA data for Unknown Sample "<>ToString[#])&,Range[1,10]];

		(* Get names of samples in multiplex samples *)
		samplesInMultiplexList=Map[Object[Sample,"AnalyzeStandardCurve Test Sample "<>ToString[#]]&,Range[1,10]];

		(* Get a list of multiplex analyte names *)
		multiplexAnalytes=Map[Model[Molecule,Protein,"AnalyzeStandardCurve Test Multiplex Analyte "<>ToString[#]]&,Range[1,8]];

		(* Duplicate the multiplex analyte list ten times, once for each sample *)
		analyteMultiplexList=ConstantArray[Link[multiplexAnalytes],10];

		(* Generate dummy dilution factor values for multiplex samples *)
		dilutionFactorMultiplexList=Flatten[ConstantArray[{{0.5,0.4,0.3,0.2,0.1},{0.5,0.1,0.02}},5],1];

		(* Generate fake multiplex intensity data for samples *)
		multiPlexIntensities=Map[{
				NormalDistribution[RandomReal[{90*#,110*#}]*RFU,RandomReal[{0,5}]*RFU],
				NormalDistribution[RandomReal[{90*#,110*#}]*RFU,RandomReal[{0,5}]*RFU],
				NormalDistribution[RandomReal[{200*#,250*#}]*RFU,RandomReal[{0,5}]*RFU],
				NormalDistribution[RandomReal[{300*#,320*#}]*RFU,RandomReal[{0,50}]*RFU],
				NormalDistribution[RandomReal[{25*#,30*#}]*RFU,RandomReal[{0,1}]*RFU],
				NormalDistribution[RandomReal[{500*#,600*#}]*RFU,RandomReal[{0,5}]*RFU],
				NormalDistribution[RandomReal[{90*#,110*#}]*RFU,RandomReal[{0,5}]*RFU],
				NormalDistribution[RandomReal[{90*#,110*#}]*RFU,RandomReal[{0,5}]*RFU]
			}&,
			dilutionFactorMultiplexList,
			{2}
		];

		(* Restructure the intensity data for upload *)
		multiPlexIntensitiesByAnalytes=Transpose[#]&/@multiPlexIntensities;
		multiPlexIntensitiesList=MapThread[{#1,#2}&,{analyteMultiplexList,multiPlexIntensitiesByAnalytes},2];

		(* Generate dummy concentration values (would be output by experiment). These should get replaced by analysis. *)
		multiPlexAssayConcentrations=Map[
			{
				NormalDistribution[RandomReal[{1000*#,1100*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter],
				NormalDistribution[RandomReal[{2000*#,2010*#}]*Picogram/Milliliter,RandomReal[{0, 0.5}]*Picogram/Milliliter],
				NormalDistribution[RandomReal[{4000*#,4500*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter],
			 	NormalDistribution[RandomReal[{300*#,320*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter],
				NormalDistribution[RandomReal[{50000*#,55000*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter],
				NormalDistribution[RandomReal[{500*#,600*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter],
				NormalDistribution[RandomReal[{90*#,110*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter],
				NormalDistribution[RandomReal[{90000*#,110000*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter]
			}&,
			dilutionFactorMultiplexList,
			{2}
		];

		(* Format multiplex sample concentrations for upload *)
		multiPlexAssayConcentrationsByAnalytes=Transpose[#]&/@multiPlexAssayConcentrations;
		multiPlexAssayConcentrationsList=MapThread[{#1,#2}&,{analyteMultiplexList,multiPlexAssayConcentrationsByAnalytes},2];

		(* Randomize final concentrations too *)
		multiPlexFinalConcentrations=Map[
			{
				NormalDistribution[RandomReal[{1000*#,1100*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter],
				NormalDistribution[RandomReal[{2000*#,2010*#}]*Picogram/Milliliter,RandomReal[{0, 0.5}]*Picogram/Milliliter],
				NormalDistribution[RandomReal[{4000*#,4500*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter],
			 	NormalDistribution[RandomReal[{300*#,320*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter],
				NormalDistribution[RandomReal[{50000*#,55000*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter],
				NormalDistribution[RandomReal[{500*#,600*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter],
				NormalDistribution[RandomReal[{90*#,110*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter],
				NormalDistribution[RandomReal[{90000*#,110000*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter]
			}&,
			ConstantArray[1, 10]
		];

		(* Format final multiplex sample concentrations *)
		multiPlexFinalConcentrationsList=MapThread[{#1,#2}&,{analyteMultiplexList,multiPlexFinalConcentrations},2];

		(* Format multiplex sample object packets *)
		allMultiPlexDataUploads=MapThread[
			<|
				Type->Object[Data,ELISA],
				Name->#1,
				Replace[SamplesIn]->{Link[#2,Data]},
				AssayType->CapillaryELISA,
				DataType->Unknown,
				Multiplex->True,
				Replace[MultiplexAnalytes]->#3,
				Replace[DilutionFactors]->#4,
				Replace[MultiplexIntensities]->#5,
				Replace[MultiplexAssayConcentrations]->#6,
				Replace[Concentrations]->#7
			|>&,
			{
				nameMultiplexList,samplesInMultiplexList,analyteMultiplexList,dilutionFactorMultiplexList,
				multiPlexIntensitiesList,multiPlexAssayConcentrationsList,multiPlexFinalConcentrationsList
			}
		];

		(* Upload multiplex sample data *)
		Upload[allMultiPlexDataUploads];

		(* Create and upload three Capillary ELISA Multiplex Standard Data Objects *)
		nameMultiplexListStandard=Map[("AnalyzeStandardCurve Test Multiplex ELISA data for Standard Sample "<>ToString[#])&,Range[1,3]];

		(* Get names of samples in multiplex samples *)
		samplesInMultiplexListStandard=Map[Object[Sample,"AnalyzeStandardCurve Test Multiplex Standard "<>ToString[#]]&,Range[1,3]];

		(* Duplicate the multiplex analyte list three times, once for each sample *)
		analyteMultiplexListStandard=ConstantArray[Link[multiplexAnalytes],3];

		(* Generate dummy dilution factor values for multiplex samples *)
		dilutionFactorMultiplexListStandard={
			{0.75,0.5,0.45,0.4,0.35,0.3,0.25,0.2,0.15,0.1,0.05,0.001},
			{0.75,0.5,0.25,0.1,0.05,0.02,0.01,0.005,0.001},
			{0.75,0.5,0.45,0.4,0.35,0.3,0.25,0.2,0.15,0.1,0.05,0.001}
		};

		(* Generate fake multiplex intensity data for standards *)
		multiPlexIntensitiesStandard=Map[
			{
				NormalDistribution[RandomReal[{90*#,110*#}]*RFU,RandomReal[{0, 5}]*RFU],
				NormalDistribution[RandomReal[{90*#,110*#}]*RFU,RandomReal[{0,5}]*RFU],
				NormalDistribution[RandomReal[{200*#,250*#}]*RFU,RandomReal[{0,5}]*RFU],
				NormalDistribution[RandomReal[{300*#,320*#}]*RFU,RandomReal[{0,50}]*RFU],
				NormalDistribution[RandomReal[{25*#,30*#}]*RFU,RandomReal[{0,1}]*RFU],
				NormalDistribution[RandomReal[{500*#,600*#}]*RFU,RandomReal[{0,5}]*RFU],
				NormalDistribution[RandomReal[{90*#,110*#}]*RFU,RandomReal[{0,5}]*RFU],
				NormalDistribution[RandomReal[{90*#,110*#}]*RFU,RandomReal[{0, 5}]*RFU]
			}&,
			dilutionFactorMultiplexListStandard,
			{2}
		];

		(* Format multiplex standard intensity data for upload *)
		multiPlexIntensitiesStandardByAnalytes=Transpose[#]&/@multiPlexIntensitiesStandard;
		multiPlexIntensitiesListStandard=MapThread[{#1,#2}&,{analyteMultiplexListStandard,multiPlexIntensitiesStandardByAnalytes},2];

		(* Generate dummy concentration values for multiplex standard data *)
		multiPlexAssayConcentrationsStandard=Map[
			{
				NormalDistribution[RandomReal[{1000*#,1100*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter],
				NormalDistribution[RandomReal[{2000*#,2010*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter],
				NormalDistribution[RandomReal[{4000*#,4500*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter],
				NormalDistribution[RandomReal[{300*#,320*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter],
				NormalDistribution[RandomReal[{50000*#,55000*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter],
				NormalDistribution[RandomReal[{500*#,600*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter],
				NormalDistribution[RandomReal[{90*#,110*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter],
				NormalDistribution[RandomReal[{90000*#,110000*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter]
			}&,
			dilutionFactorMultiplexListStandard,
			{2}
		];

		(* Restructure multiplex standard concentation data for upload *)
		multiPlexAssayConcentrationsStandardByAnalytes=Transpose[#]&/@multiPlexAssayConcentrationsStandard;
		multiPlexAssayConcentrationsListStandard=MapThread[{#1,#2}&,{analyteMultiplexListStandard,multiPlexAssayConcentrationsStandardByAnalytes},2];

		(* Generate final concentration values for multiplex standard data *)
		multiPlexFinalConcentrationsStandard=Map[
			{
				NormalDistribution[RandomReal[{1000*#,1100*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter],
				NormalDistribution[RandomReal[{2000*#,2010*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter],
				NormalDistribution[RandomReal[{4000*#,4500*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter],
				NormalDistribution[RandomReal[{300*#,320*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter],
				NormalDistribution[RandomReal[{50000*#,55000*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter],
				NormalDistribution[RandomReal[{500*#,600*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter],
				NormalDistribution[RandomReal[{90*#,110*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter],
				NormalDistribution[RandomReal[{90000*#,110000*#}]*Picogram/Milliliter,RandomReal[{0,0.5}]*Picogram/Milliliter]
			}&,
			ConstantArray[1, 3]
		];

		(* Restructure final multiplex standard concentration data for upload *)
		multiPlexFinalConcentrationsList=MapThread[{#1,#2}&,{analyteMultiplexListStandard,multiPlexFinalConcentrationsStandard},2];

		(* Assign analytes and concentrations to each channel in the multiplex *)
		multiPlexStandardCompositionList={
			{
				{Link[Model[Molecule,Protein,"AnalyzeStandardCurve Test Multiplex Analyte 1"]],1000000 Picogram/Milliliter},
				{Link[Model[Molecule,Protein,"AnalyzeStandardCurve Test Multiplex Analyte 2"]],1000000 Picogram/Milliliter},
				{Link[Model[Molecule,Protein,"AnalyzeStandardCurve Test Multiplex Analyte 3"]],1000000 Picogram/Milliliter},
				{Link[Model[Molecule,Protein,"AnalyzeStandardCurve Test Multiplex Analyte 4"]],1000000 Picogram/Milliliter},
				{Link[Model[Molecule,Protein,"AnalyzeStandardCurve Test Multiplex Analyte 5"]],1000000 Picogram/Milliliter},
				{Link[Model[Molecule,Protein,"AnalyzeStandardCurve Test Multiplex Analyte 6"]],1000000 Picogram/Milliliter},
				{Link[Model[Molecule,Protein,"AnalyzeStandardCurve Test Multiplex Analyte 7"]],1000000 Picogram/Milliliter},
				{Link[Model[Molecule,Protein,"AnalyzeStandardCurve Test Multiplex Analyte 8"]],1000000 Picogram/Milliliter}
			},
			{
				{Link[Model[Molecule,Protein,"AnalyzeStandardCurve Test Multiplex Analyte 1"]],2000 Picogram/Milliliter},
				{Link[Model[Molecule,Protein,"AnalyzeStandardCurve Test Multiplex Analyte 2"]],2000 Picogram/Milliliter},
				{Link[Model[Molecule,Protein,"AnalyzeStandardCurve Test Multiplex Analyte 3"]],2000 Picogram/Milliliter},
				{Link[Model[Molecule,Protein,"AnalyzeStandardCurve Test Multiplex Analyte 4"]],2000 Picogram/Milliliter}
			},
			{
				{Link[Model[Molecule,Protein,"AnalyzeStandardCurve Test Multiplex Analyte 1"]],1000000 Picogram/Milliliter}
			}
		};

		(* Format multiplex standard object packets *)
		allMultiPlexStandardDataUploads=MapThread[
			<|
				Type->Object[Data,ELISA],
				Name->#1,
				Replace[SamplesIn]->{Link[#2, Data]},
				AssayType->CapillaryELISA,
				DataType->Unknown,
				Multiplex->True,
				Replace[MultiplexAnalytes]->#3,
				Replace[DilutionFactors]->#4,
				Replace[MultiplexIntensities]->#5,
				Replace[MultiplexAssayConcentrations]->#6,
				Replace[Concentrations]->#7,
				Replace[StandardCompositions]->#8,
				DeveloperObject->True
			|>&,
			{
				nameMultiplexListStandard,samplesInMultiplexListStandard,analyteMultiplexListStandard,
				dilutionFactorMultiplexListStandard,multiPlexIntensitiesListStandard,
				multiPlexAssayConcentrationsListStandard,multiPlexFinalConcentrationsList,multiPlexStandardCompositionList
			}
		];

		(* Upload multiplex standard data *)
		Upload[allMultiPlexStandardDataUploads];

		(* Create a protocol with multiple standards and samples, matching by analyte *)
		Upload[<|
			Type->Object[Protocol,CapillaryELISA],
			Name->"AnalyzeStandardCurve Test CapillaryELISA Protocol 2",
			Replace[Data]->Map[Link[Object[Data,ELISA,#],Protocol]&,nameList],
			Replace[StandardData]->Map[Link[Object[Data,ELISA, #],Protocol]&,nameListStandard],
			DeveloperObject->True
		|>];

		(* Create a protocol which is missing StandardData, to test error messages *)
		Upload[<|
			Type->Object[Protocol,CapillaryELISA],
			Name->"AnalyzeStandardCurve Test CapillaryELISA Protocol 3",
			Replace[Data]->{Link[Object[Data,ELISA,"AnalyzeStandardCurve Test ELISA data for Unknown Sample 1"],Protocol]},
			DeveloperObject->True
		|>];

		(* Create a multiplex ELISA protocol *)
		Upload[<|
			Type->Object[Protocol,CapillaryELISA],
		  Name->"AnalyzeStandardCurve Test CapillaryELISA Protocol Multiplex 2",
		  Replace[Data]->Map[
				Link[Object[Data,ELISA,"AnalyzeStandardCurve Test Multiplex ELISA data for Unknown Sample "<>ToString[#]],Protocol]&,
				Range[1, 10]
			],
		  Replace[StandardData]->{
				Link[Object[Data,ELISA,"AnalyzeStandardCurve Test Multiplex ELISA data for Standard Sample 2"],Protocol],
		    Link[Object[Data,ELISA,"AnalyzeStandardCurve Test Multiplex ELISA data for Standard Sample 3"],Protocol]
			},
			DeveloperObject->True
		|>];

	),


	SymbolTearDown:>(
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	),


	Variables:>{
		simpleLineCoordinates,simpleLineWithUnits,myUnitlessLineFit,myLineFit
	},


	SetUp:>(
		simpleLineCoordinates={{0.,0.},{1.,1.},{2.,2.},{3.,3.},{4.,4.},{5.,5.}};
		simpleLineWithUnits=QuantityArray[simpleLineCoordinates,{Meter,Second}];
		myUnitlessLineFit = AnalyzeFit[Normal@simpleLineCoordinates];
		myLineFit=AnalyzeFit[Normal@simpleLineWithUnits];
	)
];


(* ::Subsection::Closed:: *)
(*AnalyzeStandardCurveOptions*)

DefineTests[AnalyzeStandardCurveOptions,
	{
		Example[{Basic,"Return a valid table of resolved options by default:"},
			AnalyzeStandardCurveOptions[{1.4 Lumen, 2.2 Lumen, 3.6 Lumen},
				{
					{1.0 Lumen,Object[Data,qPCR,"ASC Ops Test qPCR Standard 1-1"]},
					{2.0 Lumen,Object[Data,qPCR,"ASC Ops Test qPCR Standard 1-2"]},
					{3.0 Lumen,Object[Data,qPCR,"ASC Ops Test qPCR Standard 1-3"]},
					{4.0 Lumen,Object[Data,qPCR,"ASC Ops Test qPCR Standard 1-4"]}
				},
				FitType->Linear,
				StandardFields->{None,QuantificationCycleAnalyses[QuantificationCycle]}
			],
			_Grid
		],
		Test["Ensure that user-specified options are retained in resolvedOptions:",
			opsList=AnalyzeStandardCurveOptions[{1.4 Lumen, 2.2 Lumen, 3.6 Lumen},
				{
					{1.0 Lumen,Object[Data,qPCR,"ASC Ops Test qPCR Standard 1-1"]},
					{2.0 Lumen,Object[Data,qPCR,"ASC Ops Test qPCR Standard 1-2"]},
					{3.0 Lumen,Object[Data,qPCR,"ASC Ops Test qPCR Standard 1-3"]},
					{4.0 Lumen,Object[Data,qPCR,"ASC Ops Test qPCR Standard 1-4"]}
				},
				InputField->Cheese,
				FitType->Polynomial,
				PolynomialDegree->2,
				StandardFields->{None,QuantificationCycleAnalyses[QuantificationCycle]},
				OutputFormat->List
			];
			Lookup[opsList,{InputField,FitType,PolynomialDegree}],
			{Cheese,Polynomial,2}
		],
		Example[{Additional,"Options returned for protocol input are applied to all datasets:"},
			AnalyzeStandardCurveOptions[
				Object[Protocol, CapillaryELISA,"ASC Ops CapillaryELISA Protocol 2"],
				FitType -> Linear
			],
			_Grid
		],
		Example[{Options,OutputFormat,"If OutputFormat->List, returns the options as a list of rules:"},
			AnalyzeStandardCurveOptions[{1.4 Lumen, 2.2 Lumen, 3.6 Lumen},
				{
					{1.0 Lumen,Object[Data,qPCR,"ASC Ops Test qPCR Standard 1-1"]},
					{2.0 Lumen,Object[Data,qPCR,"ASC Ops Test qPCR Standard 1-2"]},
					{3.0 Lumen,Object[Data,qPCR,"ASC Ops Test qPCR Standard 1-3"]},
					{4.0 Lumen,Object[Data,qPCR,"ASC Ops Test qPCR Standard 1-4"]}
				},
				FitType->Linear,
				StandardFields->{None,QuantificationCycleAnalyses[QuantificationCycle]},
				OutputFormat->List
			],
			{_Rule..}
		],
		Example[{Options,"If no input data, Output->Options still returns a list of options."},
			AnalyzeStandardCurve[
				{{10 Cycle, 2.1},{20 Cycle, 5.8},{30 Cycle, 7.7}},
				FitType->Linear,
				Output->Options
			],
			{_Rule..}
		]
	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	SymbolSetUp:>(
		ClearMemoization[];
		$CreatedObjects={};

		Module[{allDataObjects,testProtocolObjects,testProtocolDataObjects,allObjects,existingObjects},

			(* Gather all the objects and models created in SymbolSetUp *)
			allDataObjects={
				Object[Data,ELISA,"ASC Ops Test ELISA Sample 1"],
				Object[Data,ELISA,"ASC Ops Test ELISA Sample 2"],
				Object[Data,ELISA,"ASC Ops Test ELISA Standard 1"],
				Object[Analysis,QuantificationCycle,"ASC Ops Test QC Sample 1-1"],
				Object[Analysis,QuantificationCycle,"ASC Ops Test QC Sample 1-2"],
				Object[Analysis,QuantificationCycle,"ASC Ops Test QC Sample 2-1"],
				Object[Analysis,QuantificationCycle,"ASC Ops Test QC Standard 1-1"],
				Object[Analysis,QuantificationCycle,"ASC Ops Test QC Standard 1-2"],
				Object[Analysis,QuantificationCycle,"ASC Ops Test QC Standard 1-3"],
				Object[Analysis,QuantificationCycle,"ASC Ops Test QC Standard 1-4"],
				Object[Analysis,CopyNumber,"ASC Ops Test CN Standard 1-1"],
				Object[Analysis,CopyNumber,"ASC Ops Test CN Standard 1-2"],
				Object[Analysis,CopyNumber,"ASC Ops Test CN Standard 1-3"],
				Object[Analysis,CopyNumber,"ASC Ops Test CN Standard 1-4"],
				Object[Data,qPCR,"ASC Ops Test qPCR Sample 1-1"],
				Object[Data,qPCR,"ASC Ops Test qPCR Sample 1-2"],
				Object[Data,qPCR,"ASC Ops Test qPCR Sample 2-1"],
				Object[Data,qPCR,"ASC Ops Test qPCR Standard 1-1"],
				Object[Data,qPCR,"ASC Ops Test qPCR Standard 1-2"],
				Object[Data,qPCR,"ASC Ops Test qPCR Standard 1-3"],
				Object[Data,qPCR,"ASC Ops Test qPCR Standard 1-4"],
				Model[Molecule,Protein,"ASC Ops Analyte 1"],
				Model[Molecule,Protein,"ASC Ops Analyte 2"]
			};

			(* Gather all protocols generated in SymbolSetUp for Unit Tests *)
			testProtocolObjects={
				Object[Protocol,CapillaryELISA,"ASC Ops CapillaryELISA Protocol 2"]
			};

			(* Gather names of all data objects generated to populate test protocols *)
			testProtocolDataObjects=Join[
				Map[Object[Data,ELISA,"ASC Ops ELISA data for Standard Sample "<>ToString[#]]&,Range[1,2]],
				Map[Object[Data,ELISA,"ASC Ops ELISA data for Unknown Sample "<>ToString[#]]&,Range[1,10]],
				Map[Object[Sample,"ASC Ops Sample "<>ToString[#]]&,Range[1,10]],
				Map[Object[Sample,"ASC Ops Standard "<>ToString[#]]&,Range[1, 2]],
				Map[Object[Container,Vessel,"ASC Ops Container "<>ToString[#]]&,Range[1,10]],
				Map[Object[Container,Vessel,"ASC Ops Standard Container "<>ToString[#]]&,Range[1,2]]
			];

			(* All object names generated for AnalyzeStandardCurve unit tests *)
			allObjects=Join[allDataObjects,testProtocolObjects,testProtocolDataObjects];

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(* Erase any test objects and models that we failed to erase in the last unit test *)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];

		standard1QCObjects=Upload[{
			<|
				Type->Object[Analysis,QuantificationCycle],
				Name->"ASC Ops Test QC Standard 1-1",
				QuantificationCycle->24.7 Cycle
			|>,
			<|
				Type->Object[Analysis,QuantificationCycle],
				Name->"ASC Ops Test QC Standard 1-2",
				QuantificationCycle->21.6 Cycle
			|>,
			<|
				Type->Object[Analysis,QuantificationCycle],
				Name->"ASC Ops Test QC Standard 1-3",
				QuantificationCycle->18.2 Cycle
			|>,
			<|
				Type->Object[Analysis,QuantificationCycle],
				Name->"ASC Ops Test QC Standard 1-4",
				QuantificationCycle->15.0 Cycle
			|>
		}];

		standard1CopyObjects=Upload[{
			<|
				Type->Object[Analysis,CopyNumber],
				Name->"ASC Ops Test CN Standard 1-1",
				CopyNumber->1000
			|>,
			<|
				Type->Object[Analysis,CopyNumber],
				Name->"ASC Ops Test CN Standard 1-2",
				CopyNumber->10000
			|>,
			<|
				Type->Object[Analysis,CopyNumber],
				Name->"ASC Ops Test CN Standard 1-3",
				CopyNumber->100000
			|>,
			<|
				Type->Object[Analysis,CopyNumber],
				Name->"ASC Ops Test CN Standard 1-4",
				CopyNumber->1000000
			|>
		}];

		MapThread[
			Upload[<|
				Type->Object[Data,qPCR],
				Name->"ASC Ops Test qPCR Standard 1-"<>ToString[#3],
				Replace[QuantificationCycleAnalyses]->Link[#1,Reference],
				Replace[CopyNumberAnalyses]->Link[#2,Data]
			|>]&,
			{standard1QCObjects,standard1CopyObjects,Range[Length[standard1QCObjects]]}
		];

		(* Create some dummy analytes to test ELISA Protocol input *)
		Upload[{
			<|
				Type->Model[Molecule, Protein],
				Name->"ASC Ops Analyte 1"
			|>,
			<|
				Type -> Model[Molecule, Protein],
				Name -> "ASC Ops Analyte 2"
			|>
		}];

		(* Upload 10 fake samples for ELISA Protocol *)
		Module[{testBench},
			
			(* Test bench to upload samples *)
			testBench = Upload[<|
				Type -> Object[Container, Bench],
				Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
				Name -> "Testing bench for AnalyzeStandardCurve" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>];
			
			(* create test containers, which will hold the water *)
			ECL`InternalUpload`UploadSample[
				ConstantArray[Model[Container,Vessel,"2mL Tube"],10],
				ConstantArray[{"Work Surface",testBench},10],
				Name->Map[("ASC Ops Container "<>ToString[#])&,Range[1,10]]
			];
			
			(* Upload two fake standards for ELISA Protocol *)
			ECL`InternalUpload`UploadSample[
				ConstantArray[Model[Container,Vessel,"2mL Tube"],2],
				ConstantArray[{"Work Surface",testBench},2],
				Name->Map[("ASC Ops Standard Container "<>ToString[#])&,Range[1,2]]
			];
		
		];

		ECL`InternalUpload`UploadSample[
			ConstantArray[Model[Sample,"Milli-Q water"],10],
			Map[{"A1",Object[Container,Vessel,"ASC Ops Container "<>ToString[#]]}&,Range[1,10]],
			InitialAmount->1 Milliliter,
			Name->Map[("ASC Ops Sample "<>ToString[#])&,Range[1,10]]
		];

		ECL`InternalUpload`UploadSample[
			ConstantArray[Model[Sample,StockSolution,"Filtered PBS, Sterile"],2],
			Map[{"A1",Object[Container,Vessel,"ASC Ops Standard Container "<>ToString[#]]}&,Range[1, 2]],
			InitialAmount->1 Milliliter,
			Name->Map[("ASC Ops Standard "<>ToString[#])&,Range[1, 2]]
		];

		(* Create and upload Capillary ELISA Sample Data Objects *)
		nameList=Map[("ASC Ops ELISA data for Unknown Sample "<>ToString[#])&,Range[1,10]];

		(* Get names of samples *)
		samplesInList=Map[Object[Sample,"ASC Ops Sample "<>ToString[#]]&,Range[1,10]];

		(* Create a list of analyte names*)
		analyteList=Join[
			ConstantArray[Model[Molecule,Protein,"ASC Ops Analyte 1"],5],
			ConstantArray[Model[Molecule, Protein,"ASC Ops Analyte 2"],5]
		];

		(* Generate dummy dilution factor values*)
		dilutionFactorList=Flatten[ConstantArray[{{0.5,0.4,0.3,0.2,0.1},{0.5,0.1,0.05}},5],1];

		(* Generate dummy intensity values by adding noise to a line *)
		SeedRandom[123];
		intensitiesList=Map[
			NormalDistribution[RandomReal[{90*#,110*#}]*RFU,RandomReal[{0,2}]*RFU]&,
			dilutionFactorList,
			{2}
		];

		(* Format packets for the dummy ELISA data objects *)
		allDataUploads=MapThread[
			<|
				Type->Object[Data,ELISA],
				Name->#1,
				Replace[SamplesIn]->{Link[#2, Data]},
				AssayType->CapillaryELISA,
				DataType->Unknown,
				Multiplex->False,
				Analyte->Link[#3],
				Replace[DilutionFactors]->#4,
				Replace[Intensities]->#5
			|>&,
			{nameList,samplesInList,analyteList,dilutionFactorList,intensitiesList}
		];

		(* Upload all of the test ELISA data objects corresponding to samples *)
		Upload[allDataUploads];

		(* Create and upload Capillary ELISA Sample Data Objects *)
		nameListStandard=Map[("ASC Ops ELISA data for Standard Sample "<>ToString[#])&,Range[1,2]];
		nameList=Map[("ASC Ops ELISA data for Unknown Sample "<>ToString[#])&,Range[1,10]];

		(* Get names of samples *)
		samplesInListStandard=Map[Object[Sample,"ASC Ops Standard "<>ToString[#]]&,Range[1,2]];

		(* Create a list of analyte names *)
		analyteListStandard={
			Model[Molecule, Protein,"ASC Ops Analyte 1"],
			Model[Molecule, Protein, "ASC Ops Analyte 2"]
		};

		(* Generate dummy dilution factor values*)
		dilutionFactorListStandard={
			{0.75,0.5,0.45,0.4,0.35,0.3,0.25,0.2,0.15,0.1,0.05,0.001},
			{0.75,0.5,0.25,0.1,0.05,0.02,0.01,0.005,0.001}
		};

		(* Generate dummy intensity values by adding noise to a line *)
		intensitiesListStandard=Map[
			NormalDistribution[RandomReal[{400*#, 410*#}]*RFU,RandomReal[{0, 1}]*RFU]&,
			dilutionFactorListStandard,
			{2}
		];

		(* Generate dummy compositions for ELISA test objects *)
		standardCompositionList={
			{Link[Model[Molecule,Protein,"ASC Ops Analyte 1"]],1000000 Picogram/Milliliter},
			{Link[Model[Molecule, Protein, "ASC Ops Analyte 2"]],2000 Picogram/Milliliter}
		};

		(* Format packets for the dummy ELISA data objects *)
		allStandardDataUploads=MapThread[
			<|
				Type->Object[Data,ELISA],
				Name->#1,
				Replace[SamplesIn]->{Link[#2, Data]},
				AssayType->CapillaryELISA,
				DataType->Standard,
				Multiplex->False,
				Analyte->Link[#3],
				Replace[DilutionFactors]->#4,
				Replace[Intensities]->#5,
				Replace[StandardCompositions]->{#6}
			|>&,
			{
				nameListStandard,samplesInListStandard,analyteListStandard,
				dilutionFactorListStandard,intensitiesListStandard,standardCompositionList
			}
		];

		(* Upload Capillary ELISA Standard Data objects *)
		Upload[allStandardDataUploads];

		(* Create a protocol with multiple standards and samples, matching by analyte *)
		Upload[<|
			Type->Object[Protocol,CapillaryELISA],
			Name->"ASC Ops CapillaryELISA Protocol 2",
			Replace[Data]->Map[Link[Object[Data,ELISA,#],Protocol]&,nameList],
			Replace[StandardData]->Map[Link[Object[Data,ELISA, #],Protocol]&,nameListStandard]
		|>];

	),

	SymbolTearDown:>(
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	)

];


(* ::Subsection::Closed:: *)
(*AnalyzeStandardCurvePreview*)

DefineTests[AnalyzeStandardCurvePreview,
	{
		Example[{Basic,"Given a CapiillaryELISA protocol as input, show standard curves for each analyte in different slides:"},
			AnalyzeStandardCurvePreview[
				Object[Protocol, CapillaryELISA,"ASC Preview CapillaryELISA Protocol 2"],
				FitType->Linear
			],
			SlideView[{ValidGraphicsP[]..}, ___],
      TimeConstraint->180
		],
		Example[{Basic,"If multiple input datasets are provided, they will be highlighted with different colors:"},
			AnalyzeStandardCurvePreview[{{0.2 Lumen,1 Lumen,3 Lumen},{QuantityDistribution[NormalDistribution[2.0,0.7],Lumen]}},
				QuantityArray[Table[{x,x^3+RandomReal[7*Max[x,1]]},{x,0,4,0.1}],{Lumen,RFU}],
				FitType->Cubic
			],
			ValidGraphicsP[],
      TimeConstraint->180
		],
		Example[{Basic,"Generate a preview for the standard curve analysis:"},
			AnalyzeStandardCurvePreview[{6 RFU, 11 RFU, 34 RFU},
				QuantityArray[{
						{0.`,0.`},{0.2`,0.21090505138173465`},{0.4`,1.3297556155106667`},{0.6000000000000001`,0.655734453042509`},{0.8`,1.0387548280020633`},{1.`,4.02662803092734`},{1.2000000000000002`,1.7360046289478346`},
						{1.4000000000000001`,7.814553854586216`},{1.6`,6.076096924027828`},{1.8`,6.666847745200002`},{2.`,11.506123168389644`},{2.2`,10.712746494728533`},{2.4000000000000004`,16.20548235772889`},
						{2.6`,27.726752410404977`},{2.8000000000000003`,28.58867545710098`},{3.`,29.709241602059812`},{3.2`,41.115878332677234`},{3.4000000000000004`,49.786698134955074`},{3.6`,55.499559387407885`},
						{3.8000000000000003`,70.79936509566826`},{4.`,67.70154081693205`}
					},
					{1,RFU}
				],
				InversePrediction->True,
				FitType->Exponential
			],
			ValidGraphicsP[],
			TimeConstraint->180
		],
		Example[{Basic, "Generate a preview when there is no input data"},
			AnalyzeStandardCurvePreview[
				{{10 Cycle, 2.1},{20 Cycle, 5.8},{30 Cycle, 7.7}}
			],
			ValidGraphicsP[]
		]
	},
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	SymbolSetUp:>(
		ClearMemoization[];
		$CreatedObjects={};

		Module[{allDataObjects,testProtocolObjects,testProtocolDataObjects,allObjects,existingObjects},

			(* Gather all the objects and models created in SymbolSetUp *)
			allDataObjects={
				Model[Molecule,Protein,"ASC Preview Analyte 1"],
				Model[Molecule,Protein,"ASC Preview Analyte 2"]
			};

			(* Gather all protocols generated in SymbolSetUp for Unit Tests *)
			testProtocolObjects={
				Object[Protocol,CapillaryELISA,"ASC Preview CapillaryELISA Protocol 2"]
			};

			(* Gather names of all data objects generated to populate test protocols *)
			testProtocolDataObjects=Join[
				Map[Object[Data,ELISA,"ASC Preview ELISA data for Standard Sample "<>ToString[#]]&,Range[1,2]],
				Map[Object[Data,ELISA,"ASC Preview ELISA data for Unknown Sample "<>ToString[#]]&,Range[1,10]],
				Map[Object[Sample,"ASC Preview Sample "<>ToString[#]]&,Range[1,10]],
				Map[Object[Sample,"ASC Preview Standard "<>ToString[#]]&,Range[1, 2]],
				Map[Object[Container,Vessel,"ASC Preview Container "<>ToString[#]]&,Range[1,10]],
				Map[Object[Container,Vessel,"ASC Preview Standard Container "<>ToString[#]]&,Range[1,2]]
			];

			(* All object names generated for AnalyzeStandardCurve unit tests *)
			allObjects=Join[allDataObjects,testProtocolObjects,testProtocolDataObjects];

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(* Erase any test objects and models that we failed to erase in the last unit test *)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];

		(* Create some dummy analytes to test ELISA Protocol input *)
		Upload[{
			<|
				Type->Model[Molecule, Protein],
				Name->"ASC Preview Analyte 1"
			|>,
			<|
				Type -> Model[Molecule, Protein],
				Name -> "ASC Preview Analyte 2"
			|>
		}];
		
		Module[{testBench},
			
			(* Test bench to upload samples *)
			testBench = Upload[<|
				Type -> Object[Container, Bench],
				Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
				Name -> "Testing bench for AnalyzeStandardCurve" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>];
			
			(* Upload 10 fake samples for ELISA Protocol *)
			ECL`InternalUpload`UploadSample[
				ConstantArray[Model[Container,Vessel,"2mL Tube"],10],
				ConstantArray[{"Work Surface",testBench},10],
				Name->Map[("ASC Preview Container "<>ToString[#])&,Range[1,10]]
			];
			
			(* Upload two fake standards for ELISA Protocol *)
			ECL`InternalUpload`UploadSample[
				ConstantArray[Model[Container,Vessel,"2mL Tube"],2],
				ConstantArray[{"Work Surface",testBench},2],
				Name->Map[("ASC Preview Standard Container "<>ToString[#])&,Range[1,2]]
			];
			
		];
		
		ECL`InternalUpload`UploadSample[
			ConstantArray[Model[Sample,"Milli-Q water"],10],
			Map[{"A1",Object[Container,Vessel,"ASC Preview Container "<>ToString[#]]}&,Range[1,10]],
			InitialAmount->1 Milliliter,
			Name->Map[("ASC Preview Sample "<>ToString[#])&,Range[1,10]]
		];

		ECL`InternalUpload`UploadSample[
			ConstantArray[Model[Sample,StockSolution,"Filtered PBS, Sterile"],2],
			Map[{"A1",Object[Container,Vessel,"ASC Preview Standard Container "<>ToString[#]]}&,Range[1, 2]],
			InitialAmount->1 Milliliter,
			Name->Map[("ASC Preview Standard "<>ToString[#])&,Range[1, 2]]
		];

		(* Create and upload Capillary ELISA Sample Data Objects *)
		nameList=Map[("ASC Preview ELISA data for Unknown Sample "<>ToString[#])&,Range[1,10]];

		(* Get names of samples *)
		samplesInList=Map[Object[Sample,"ASC Preview Sample "<>ToString[#]]&,Range[1,10]];

		(* Create a list of analyte names*)
		analyteList=Join[
			ConstantArray[Model[Molecule,Protein,"ASC Preview Analyte 1"],5],
			ConstantArray[Model[Molecule, Protein,"ASC Preview Analyte 2"],5]
		];

		(* Generate dummy dilution factor values*)
		dilutionFactorList=Flatten[ConstantArray[{{0.5,0.4,0.3,0.2,0.1},{0.5,0.1,0.05}},5],1];

		(* Generate dummy intensity values by adding noise to a line *)
		intensitiesList=Map[
			NormalDistribution[RandomReal[{90*#,110*#}]*RFU,RandomReal[{0,2}]*RFU]&,
			dilutionFactorList,
			{2}
		];

		(* Format packets for the dummy ELISA data objects *)
		allDataUploads=MapThread[
			<|
				Type->Object[Data,ELISA],
				Name->#1,
				Replace[SamplesIn]->{Link[#2, Data]},
				AssayType->CapillaryELISA,
				DataType->Unknown,
				Multiplex->False,
				Analyte->Link[#3],
				Replace[DilutionFactors]->#4,
				Replace[Intensities]->#5
			|>&,
			{nameList,samplesInList,analyteList,dilutionFactorList,intensitiesList}
		];

		(* Upload all of the test ELISA data objects corresponding to samples *)
		Upload[allDataUploads];

		(* Create and upload Capillary ELISA Sample Data Objects *)
		nameListStandard=Map[("ASC Preview ELISA data for Standard Sample "<>ToString[#])&,Range[1,2]];
		nameList=Map[("ASC Preview ELISA data for Unknown Sample "<>ToString[#])&,Range[1,10]];

		(* Get names of samples *)
		samplesInListStandard=Map[Object[Sample,"ASC Preview Standard "<>ToString[#]]&,Range[1,2]];

		(* Create a list of analyte names *)
		analyteListStandard={
			Model[Molecule, Protein,"ASC Preview Analyte 1"],
			Model[Molecule, Protein, "ASC Preview Analyte 2"]
		};

		(* Generate dummy dilution factor values*)
		dilutionFactorListStandard={
			{0.4,0.35,0.3,0.25,0.2,0.15,0.1,0.05,0.001},
			{0.25,0.1,0.05,0.02,0.01,0.005,0.001}
		};

		(* Generate dummy intensity values by adding noise to a line *)
		intensitiesListStandard=Map[
			NormalDistribution[RandomReal[{400*#, 410*#}]*RFU,RandomReal[{0, 1}]*RFU]&,
			dilutionFactorListStandard,
			{2}
		];

		(* Generate dummy compositions for ELISA test objects *)
		standardCompositionList={
			{Link[Model[Molecule,Protein,"ASC Preview Analyte 1"]],1000000 Picogram/Milliliter},
			{Link[Model[Molecule, Protein, "ASC Preview Analyte 2"]],2000 Picogram/Milliliter}
		};

		(* Format packets for the dummy ELISA data objects *)
		allStandardDataUploads=MapThread[
			<|
				Type->Object[Data,ELISA],
				Name->#1,
				Replace[SamplesIn]->{Link[#2, Data]},
				AssayType->CapillaryELISA,
				DataType->Standard,
				Multiplex->False,
				Analyte->Link[#3],
				Replace[DilutionFactors]->#4,
				Replace[Intensities]->#5,
				Replace[StandardCompositions]->{#6}
			|>&,
			{
				nameListStandard,samplesInListStandard,analyteListStandard,
				dilutionFactorListStandard,intensitiesListStandard,standardCompositionList
			}
		];

		(* Upload Capillary ELISA Standard Data objects *)
		Upload[allStandardDataUploads];

		(* Create a protocol with multiple standards and samples, matching by analyte *)
		Upload[<|
			Type->Object[Protocol,CapillaryELISA],
			Name->"ASC Preview CapillaryELISA Protocol 2",
			Replace[Data]->Map[Link[Object[Data,ELISA,#],Protocol]&,nameList],
			Replace[StandardData]->Map[Link[Object[Data,ELISA, #],Protocol]&,nameListStandard]
		|>];

	),

	SymbolTearDown:>(
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	)

];


(* ::Subsection::Closed:: *)
(*ValidAnalyzeStandardCurveQ*)


DefineTests[ValidAnalyzeStandardCurveQ,
	{
		Example[{Basic,"Given input data and options, returns a Boolean indicating the validity of the standard curve analysis call:"},
			ValidAnalyzeStandardCurveQ[{1.4 Lumen, 2.2 Lumen, 3.6 Lumen},
				{
					{1.0 Lumen,Object[Data,qPCR,"Valid ASC Test qPCR Standard 1-1"]},
					{2.0 Lumen,Object[Data,qPCR,"Valid ASC Test qPCR Standard 1-2"]},
					{3.0 Lumen,Object[Data,qPCR,"Valid ASC Test qPCR Standard 1-3"]},
					{4.0 Lumen,Object[Data,qPCR,"Valid ASC Test qPCR Standard 1-4"]}
				},
				FitType->Linear,
				StandardFields->{None,QuantificationCycleAnalyses[QuantificationCycle]}
			],
			True
		],
		Example[{Options,Verbose,"If Verbose->True, returns the passing and failing tests:"},
			ValidAnalyzeStandardCurveQ[{1.4 Lumen, 2.2 Lumen, 3.6 Lumen},
				{
					{1.0 Lumen,0.2 Mole/Liter},
					{2.0 Lumen,0.72 Mole/Liter},
					{3.0 Lumen,0.92 Mole/Liter},
					{4.0 Lumen,1.04 Mole/Liter}
				},
				FitType->Linear,
				Verbose->True
			],
			True
		],
		Example[{Options,OutputFormat,"If OutputFormat->TestSummary, returns a test summary instead of a Boolean:"},
			ValidAnalyzeStandardCurveQ[{1.4 Lumen, 2.2 Lumen, 3.6 Lumen},
				{
					{1.0 Lumen,0.2 Mole/Liter},
					{2.0 Lumen,0.72 Mole/Liter},
					{3.0 Lumen,0.92 Mole/Liter},
					{4.0 Lumen,1.04 Mole/Liter}
				},
				FitType->Linear,
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary
		]
	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	SymbolSetUp:>(
		ClearMemoization[];
		$CreatedObjects={};

		Module[{allObjects,existingObjects},

			(* Gather all the objects and models created in SymbolSetUp *)
			allObjects={
				Object[Analysis,QuantificationCycle,"Valid ASC Test QC Standard 1-1"],
				Object[Analysis,QuantificationCycle,"Valid ASC Test QC Standard 1-2"],
				Object[Analysis,QuantificationCycle,"Valid ASC Test QC Standard 1-3"],
				Object[Analysis,QuantificationCycle,"Valid ASC Test QC Standard 1-4"],
				Object[Analysis,CopyNumber,"Valid ASC Test CN Standard 1-1"],
				Object[Analysis,CopyNumber,"Valid ASC Test CN Standard 1-2"],
				Object[Analysis,CopyNumber,"Valid ASC Test CN Standard 1-3"],
				Object[Analysis,CopyNumber,"Valid ASC Test CN Standard 1-4"],
				Object[Data,qPCR,"Valid ASC Test qPCR Standard 1-1"],
				Object[Data,qPCR,"Valid ASC Test qPCR Standard 1-2"],
				Object[Data,qPCR,"Valid ASC Test qPCR Standard 1-3"],
				Object[Data,qPCR,"Valid ASC Test qPCR Standard 1-4"]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];

		standard1QCObjects=Upload[{
			<|
				Type->Object[Analysis,QuantificationCycle],
				Name->"Valid ASC Test QC Standard 1-1",
				QuantificationCycle->24.7 Cycle
			|>,
			<|
				Type->Object[Analysis,QuantificationCycle],
				Name->"Valid ASC Test QC Standard 1-2",
				QuantificationCycle->21.6 Cycle
			|>,
			<|
				Type->Object[Analysis,QuantificationCycle],
				Name->"Valid ASC Test QC Standard 1-3",
				QuantificationCycle->18.2 Cycle
			|>,
			<|
				Type->Object[Analysis,QuantificationCycle],
				Name->"Valid ASC Test QC Standard 1-4",
				QuantificationCycle->15.0 Cycle
			|>
		}];

		standard1CopyObjects=Upload[{
			<|
				Type->Object[Analysis,CopyNumber],
				Name->"Valid ASC Test CN Standard 1-1",
				CopyNumber->1000
			|>,
			<|
				Type->Object[Analysis,CopyNumber],
				Name->"Valid ASC Test CN Standard 1-2",
				CopyNumber->10000
			|>,
			<|
				Type->Object[Analysis,CopyNumber],
				Name->"Valid ASC Test CN Standard 1-3",
				CopyNumber->100000
			|>,
			<|
				Type->Object[Analysis,CopyNumber],
				Name->"Valid ASC Test CN Standard 1-4",
				CopyNumber->1000000
			|>
		}];

		MapThread[
			Upload[<|
				Type->Object[Data,qPCR],
				Name->"Valid ASC Test qPCR Standard 1-"<>ToString[#3],
				Replace[QuantificationCycleAnalyses]->Link[#1,Reference],
				Replace[CopyNumberAnalyses]->Link[#2,Data]
			|>]&,
			{standard1QCObjects,standard1CopyObjects,Range[Length[standard1QCObjects]]}
		];

	),

	SymbolTearDown:>(
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	)

];



(* ::Section:: *)
(*End Test Package*)
