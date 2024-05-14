(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*AnalyzeCompensationMatrix*)


(* Define Tests *)
DefineTests[AnalyzeCompensationMatrix,
	{
		(*** Basic Usage ***)
		Example[{Basic,"Compute a compensation matrix from a flow cytometry protocol with CompensationSamplesIncluded of True. The compensation matrix is used to correct for fluorophore spillover between detectors:"},
			AnalyzeCompensationMatrix[
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test 15 Detectors Protocol"]
			],
			ObjectP[Object[Analysis,CompensationMatrix]]
		],
		Example[{Basic,"Retrieve the numerical compensation matrix from a CompensationMatrix analysis object:"},
			AnalyzeCompensationMatrix[
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test Protocol"]
			][CompensationMatrix]//MatrixForm,
			SquareNumericMatrixP//MatrixForm
		],
		Example[{Basic,"Compute a compensation matrix for each flow cytometry protocol in a list:"},
			AnalyzeCompensationMatrix[{
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test 15 Detectors Protocol"],
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test Protocol"],
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test with Unstained Sample Protocol"]
			}],
			{ObjectP[Object[Analysis,CompensationMatrix]]..}
		],
		Example[{Basic,"If the input protocol contains CompensationSamples which contain both positive and negative controls, the command builder preview will generate an interactive app which can be used to set the thresholds between positive and negative populations. Please load the function call in the builder to use this app:"},
			AnalyzeCompensationMatrixPreview[
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test Protocol"]
			],
			_DynamicModule,
			Stubs:>{
				AnalyzeCompensationMatrixPreview[
					Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test Protocol"]
				]=DynamicModule[{localSymbol},
					Column[{
						AnalyzeCompensationMatrixPreview[Object[Protocol,FlowCytometry,"AnalyzeCompensationMatrix Unit Test Protocol"],PreviewSymbol->localSymbol],
						Spacer[10],
						Row[{Style["DetectionThresholds: ",14,Bold],Dynamic@PreviewValue[localSymbol,DetectionThresholds]}]
					},Alignment->Center]
				]
			}
		],
		Example[{Basic,"If the input protocol contains an UnstainedSample, it will be used as a universal negative. Thresholds will not be used because populations will be clearly defined. The preview will show the separation between the positive and negative populations for each compensation sample:"},
			AnalyzeCompensationMatrixPreview[
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test with Unstained Sample Protocol"]
			],
			Alternatives[
				Grid[{{Pane[_DynamicModule, ___], _Toggler}}, ___] /; ECL`$CCD ,
				Pane[_DynamicModule,___]
			]
		],

		(*** Options ***)
		Example[{Options,Detectors,"Specify a subset of the detectors to use for CompensationMatrix analysis. Detectors present in the protocol but not specified here will be presumed not to spillover into other channels:"},
			AnalyzeCompensationMatrix[
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test with Unstained Sample Protocol"],
				Detectors->{"488 FSC", "488 SSC", "488 593/52"}
			],
			obj:ObjectP[Object[Analysis,CompensationMatrix]]/;MatchQ[obj[Detectors],{"488 FSC","488 SSC","488 593/52"}]
		],
		Example[{Options,DetectionLabels,"Override the DetectionLabels in the input protocol. For illustrative purposes, the function call below overrides labels with the identity models for some standard amino acids:"},
			AnalyzeCompensationMatrix[
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test with Unstained Sample Protocol"],
				Detectors->{"488 FSC", "488 SSC", "488 593/52"},
				DetectionLabels->{Model[Molecule,"Glycine"],Model[Molecule,"L-Alanine"],Model[Molecule,"L-Tryptophan"]}
			],
			obj:ObjectP[Object[Analysis,CompensationMatrix]]/;MatchQ[Download[obj[DetectionLabels],Name],{"Glycine","L-Alanine","L-Tryptophan"}]
		],
		Example[{Options,DetectionThresholds,"If input protocol does not use an unstained global negative, for each detector (and corresponding AdjustmentSampleData), specify the signal threshold above which a cell will be considered to be positive for the label assigned to that detector:"},
			AnalyzeCompensationMatrix[
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test Protocol"],
				Detectors->{"488 FSC", "488 SSC", "488 593/52"},
				DetectionThresholds->{0.10, 0.25, 0.05}
			],
			obj:ObjectP[Object[Analysis,CompensationMatrix]]/;MatchQ[obj[DetectionThresholds],{0.10 Second*ArbitraryUnit, 0.25 Second*ArbitraryUnit, 0.05 Second*ArbitraryUnit}]
		],
		Example[{Options,DetectionThresholds,"If the input protocol uses an unstained sample as a global negative (i.e. UnstainedSampleData is informed), then DetectionThresholds will be ignored:"},
			AnalyzeCompensationMatrix[
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test with Unstained Sample Protocol"],
				Detectors->{"488 FSC", "488 SSC", "488 593/52"},
				DetectionThresholds->{0.10, 0.25, 0.05}
			],
			obj:ObjectP[Object[Analysis,CompensationMatrix]]/;MatchQ[obj[DetectionThresholds],{}],
			Messages:>{Warning::UnusedThresholds}
		],
		Example[{Options,Template,"Use option settings from an existing analysis object in this compensation matrix analysis. Here, the Detectors and DetectionThreshold options are inherited from the template analysis object:"},
			AnalyzeCompensationMatrix[
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test Protocol"],
				Template->AnalyzeCompensationMatrix[
					Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test Protocol"],
					Detectors->{"488 FSC", "488 SSC", "488 593/52"},
					DetectionThresholds->{0.10, 0.15, 0.20}
				]
			],
			obj:ObjectP[Object[Analysis,CompensationMatrix]]/;MatchQ[obj[DetectionThresholds],{0.10 Second*ArbitraryUnit, 0.15 Second*ArbitraryUnit, 0.20 Second*ArbitraryUnit}]
		],

		(*** Messages ***)
		Example[{Messages,"AdjustmentDataNotFound","Warning shows if input protocol has AdjustmentSamplesIncluded equal to True, but one or more AdjustmentSamples (index-matched to Detectors) do not have a corresponding data object in AdjustmentSampleData. Analysis will proceed, and the detectors missing AdjustmentSampleData will be assumed not to spillover into other detectors:"},
			AnalyzeCompensationMatrix[
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test Missing Detectors Protocol"]
			],
			ObjectP[Object[Analysis,CompensationMatrix]],
			Messages:>{Warning::AdjustmentDataNotFound}
		],
		Example[{Messages,"UnusedThresholds","DetectionThresholds cannot be used if the input protocol has UnstainedSampleData. This unstained sample data is treated as a global negative, so the thresholding option will be ignored:"},
			AnalyzeCompensationMatrix[
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test with Unstained Sample Protocol"],
				Detectors -> {"488 FSC", "405 FSC", "488 SSC"},
				DetectionThresholds -> 0.5
			],
			ObjectP[Object[Analysis,CompensationMatrix]],
			Messages:>{Warning::UnusedThresholds}
		],
		Example[{Messages,"DetectorsNotInProtocol","All detectors in the Detectors option must be a member of the Detectors field of input protocol:"},
			AnalyzeCompensationMatrix[
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test Protocol"],
				Detectors->{"488 FSC", "405 FSC", "488 SSC", "488 525/35", "488 593/52", "488 750LP"}
			],
			$Failed,
			Messages:>{Error::DetectorsNotInProtocol}
		],
		Example[{Messages,"DuplicateDetectors","The Detectors option cannot contain duplicates:"},
			AnalyzeCompensationMatrix[
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test Protocol"],
				Detectors->{"488 525/35","488 525/35","488 525/35"}
			],
			$Failed,
			Messages:>{Error::DuplicateDetectors}
		],
		Example[{Messages,"DetectorsNotSet","The DetectionLabels option cannot be set unless the Detectors option has been explicitly set:"},
			AnalyzeCompensationMatrix[
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test Protocol"],
				DetectionLabels->Model[Molecule, Oligomer, "Probe GFP 6"]
			],
			$Failed,
			Messages:>{Error::DetectorsNotSet}
		],
		Example[{Messages,"DetectorsNotSet","The DetectionThresholds option cannot be set unless the Detectors option has been explicitly set:"},
			AnalyzeCompensationMatrix[
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test Protocol"],
				DetectionThresholds->{1000.0, 2000.0}
			],
			$Failed,
			Messages:>{Error::DetectorsNotSet}
		],
		Example[{Messages,"EmptyPartition","CompensationMatrix cannot be calculated if thresholds do not result in separation of adjustment data into a positive and negative population:"},
			AnalyzeCompensationMatrix[
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test Protocol"],
				DetectionThresholds->{0.5, 100.0, 0.5, 0.5, 0.5}
			],
			$Failed,
			Messages:>{Error::EmptyPartition}
		],
		Example[{Messages,"NoCompensationSamplesFound","Error shows if no compensation could be found in input protocol. The input protocol must have CompensationSamplesIncluded equal to True, and have one or more data objects linked in its AdjustmentSampleData field:"},
			AnalyzeCompensationMatrix[
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test Empty Protocol"]
			],
			$Failed,
			Messages:>{Error::NoCompensationSamplesFound}
		],

		(*** Tests ***)
		Test["Check numerical values of CompensationMatrix for protocol which uses thresholds:",
			Lookup[
				AnalyzeCompensationMatrix[
					Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test Protocol"],
					Upload->False
				],
				CompensationMatrix
			],
			{
				{1.0141962436534502`, -0.08131372374303977`, -0.10056520082855339`, -0.01789976385647132`, -0.004783214218071684`},
				{-0.06409774726118908`, 1.0098725633405403`, 0.010384631128254624`, -0.006818755360116877`, -0.0736479952512376`},
				{-0.08886463283259739`, -0.01637014138345055`, 1.0132515377588291`, -0.03595840769876182`, -0.03326829407207554`},
				{0.00015280567747967482`, -0.03946123285492717`, -0.06962163129322613`, 1.0055406688938981`, -0.04555007534300384`},
				{0.008383523554627162`, -0.058478026616638354`,-0.049516646712629175`, -0.04955665589208239`, 1.0085473631147523`}
			},
			EquivalenceFunction->RoundMatchQ[4]
		],
		Test["Check numerical values of CompensationMatrix for protocol which uses unstained sample as global negative:",
			Lookup[
				AnalyzeCompensationMatrix[
					Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test with Unstained Sample Protocol"],
					Upload->False
				],
				CompensationMatrix
			],
			{
				{1.0328645434208479, -0.03479887125683807, -0.07175065037323018, -0.048063868320866704, -0.12277451767513294},
				{-0.08251250560931431, 1.0307331866519536, -0.08288685523677713, -0.12013786525522657, -0.07232640443175721},
				{-0.059636667512000106, -0.0324611325431354, 1.0219106113885164, -0.0789599104334192, -0.062102278619772376},
				{-0.1008886061060978, -0.12146040046252592, -0.11877688785128662, 1.0389875414247525, -0.04565255138541273},
				{-0.12520493052392712, -0.07154350521172144, -0.014196766332146513, -0.08261112688691538, 1.030698844909526}
			},
			EquivalenceFunction->RoundMatchQ[4]
		],
		Test["Check numerical values of CompensationMatrix for protocol which uses thresholds, with some unspecified samples:",
			Lookup[
				AnalyzeCompensationMatrix[
					Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test Missing Detectors Protocol"],
					Upload->False
				],
				CompensationMatrix
			],
			{
				{0.9999028223700444`,-0.03145120410260263`,-0.05936278634033254`,0.`,0.`},
				{-0.00941769526617231`,1.0015647162844825`,-0.015200177858720703`,0.`,0.`},
				{0.007323450536829295`,-0.08082398961977265`,1.0008337069612447`,0.`,0.`},
				{-0.04741274844698342`,-0.07893437412410036`,0.023717195706209747`,1.`,0.`},
				{-0.03408556797955341`,-0.047339709189417725`,-0.0429611165254511`,0.`,1.`}
			},
			Messages:>{Warning::AdjustmentDataNotFound},
			EquivalenceFunction->RoundMatchQ[4]
		],
		Test["Check numerical values of CompensationMatrix for protocol which uses unstained sample as global negative, with some unspecified samples:",
			Lookup[
				AnalyzeCompensationMatrix[
					Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test with Unstained Sample Missing Detectors Protocol"],
					Upload->False
				],
				CompensationMatrix
			],
			{
				{1.0208010360550048, -0.1129041968790818, -0.12663609152909366, 0., 0.},
				{-0.05165103635461167, 1.012725421686928, -0.07473734995839174, 0., 0.},
				{-0.1093082143853221, -0.07493725178489583, 1.020572931614181, 0., 0.},
				{-0.026517360618353927, -0.12356946408345373, -0.11259201110795121, 1., 0.},
				{-0.10666008994318053, -0.11080830421770076, -0.09463110949282347, 0., 1.}
			},
			Messages:>{Warning::AdjustmentDataNotFound},
			EquivalenceFunction->RoundMatchQ[4]
		],
		Test["Setting only a subset of detectors will reduce the size of the CompensationMatrix:",
			Lookup[
				AnalyzeCompensationMatrix[
					Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test Protocol"],
					Detectors->{"488 FSC", "488 SSC", "488 593/52"},
					Upload->False
				],
				CompensationMatrix
			],
			{
				{1.0089920091178153`,-0.10099929269021603`,-0.011602011534846838`},
				{-0.08998804754889576`,1.0109364297022883`,-0.036199714712688846`},
				{0.004554995692955985`,-0.05235460682712462`,1.0018763220077034`}
			},
			EquivalenceFunction->RoundMatchQ[4]
		],
		Test["Changing thresholds changes the numerical value of the CompensationMatrix:",
			Lookup[
				AnalyzeCompensationMatrix[
					Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test Protocol"],
					Detectors->{"488 FSC", "488 SSC", "488 593/52"},
					DetectionThresholds->{0.50, 0.02, 0.03},
					Upload->False
				],
				CompensationMatrix
			],
			{
				{1.0038949837935942, -0.04370395248637553, -0.04302335087857912},
				{-0.08944842391079205, 1.0048863948735651, -0.046261032460246924},
				{0.0016661321531765488, -0.019901014769676213, 1.0009209081233763}
			},
			EquivalenceFunction->RoundMatchQ[4]
		],
		Test["Graphics in the interactive app are valid:",
			AnalyzeCompensationMatrix[
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test Protocol"],
				Upload->False,
				Output->Preview
			],
			app_/;Module[
				{tabview,tabGraphics,validChecks},

				(* Extract the tab view from the DynamicModule, and strip dynamics *)
				tabview=FirstCase[app,_TabView,Missing,{0,Infinity}];

				(* Extract graphics from each page of the tabview. *)
				(* First index gets contents of tab view, {All,-1,-1} extracts from rule {val,{label\[Rule]graphic}} *)
				(* The last 2 index extracts the second element from LocatorPane (first is the locator point) *)
				tabGraphics=Block[{ECL`$CCD = False}, Staticize/@tabview[[1,All,-1,-1,2]]];

				(* Each tab graphic is enclosed in a grid, so check each one *)
				validChecks=MatchQ[#,Grid[{{ValidGraphicsP[]},{_SwatchLegend}},___]]&/@tabGraphics;

				(* True if all tab graphics were valid *)
				And@@validChecks
			]
		],
		(*
		Test["Graphics in the non-interactive app are valid:",
			AnalyzeCompensationMatrix[
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test with Unstained Sample Protocol"],
				Upload->False,
				Output->Preview
			],
			app_/;Module[
				{tabview,tabGraphics,validChecks},

				(* Extract the tab view from the DynamicModule, and strip dynamics *)
				tabview=FirstCase[app,_TabView,Missing,{0,Infinity}];

				(* Extract graphics from each page of the tabview. *)
				(* First index gets contents of tab view, {All,-1,-1} extracts from rule {val,{label\[Rule]graphic}} *)
				(* The last 2 index extracts the second element from LocatorPane (first is the locator point) *)
				tabGraphics=Block[{ECL`$CCD = False}, Staticize/@tabview[[1,All,-1,-1,2]]];

				(* Each tab graphic is enclosed in a grid, so check each one *)
				validChecks=MatchQ[#,Grid[{{ValidGraphicsP[]},{_SwatchLegend}},___]]&/@tabGraphics;

				(* True if all tab graphics were valid *)
				And@@validChecks
			]
		],
		*)
		Test["Updating the DetectionThresholds option updates the interactive preview app:",
			With[
				{
					preview=AnalyzeCompensationMatrix[
						Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test Protocol"],
						Upload->False,
						Output->Preview
					]
				},
				LogPreviewChanges[
					PreviewSymbol[AnalyzeCompensationMatrix],
					DetectionThresholds->{0.1, 0.2, 0.3, 0.4, 0.5}
				];
				preview
			],
			app_/;Module[
				{contents,tabview,tabGraphics,validChecks,validTabGraphicsQ,tabThresholds,validThresholds},

				(* Extract the tab view from the DynamicModule, and strip dynamics *)
				tabview=FirstCase[app,_TabView,Missing,{0,Infinity}];

				(* Extract graphics from each page of the tabview. *)
				(* First index gets contents of tab view, {All,-1,-1} extracts from rule {val,{label\[Rule]graphic}} *)
				(* The last 2 index extracts the second element from LocatorPane (first is the locator point) *)
				tabGraphics=Block[{ECL`$CCD = False},Staticize /@ tabview[[1,All,-1,-1,2]]];

				(* Each tab graphic is enclosed in a grid, so check each one *)
				validChecks=MatchQ[#,Grid[{{ValidGraphicsP[]},{_SwatchLegend}},___]]&/@tabGraphics;

				(* True if all tab graphics were valid *)
				validTabGraphicsQ=And@@validChecks;

				(* Extract threshold values from the graphic *)
				tabThresholds=Cases[tabGraphics,r:Rule[GridLines,_]:>Last[r],10][[All,1,1]];

				(* Check that our updated thresholds have appeared in the graphic *)
				validThresholds=MatchQ[tabThresholds,{0.1, 0.2, 0.3, 0.4, 0.5}];

				(* True of graphics and threshodls are valid *)
				And[validTabGraphicsQ,validThresholds]
			]
		]
	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	(* Create test objects when tests start *)
	SymbolSetUp:>(
		(* Reset the created objects list and set a random seed *)
		$CreatedObjects={};
		SeedRandom[123];

		(* Erase any objects we missed in the last unit test run *)
		Module[{allObjects,existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Sample, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentSample 1"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentSample 2"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentSample 3"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentSample 4"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentSample 5"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentSample 6"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentSample 7"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentSample 8"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentSample 9"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentSample 10"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentSample 11"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentSample 12"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentSample 13"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentSample 14"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentSample 15"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test AdjustmentSample 1"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test AdjustmentSample 2"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test AdjustmentSample 3"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test AdjustmentSample 4"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test AdjustmentSample 5"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test Missing Detectors AdjustmentSample 1"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test Missing Detectors AdjustmentSample 2"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test Missing Detectors AdjustmentSample 3"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test Missing Detectors UnstainedSample"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test UnstainedSample"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test with Unstained Sample AdjustmentSample 1"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test with Unstained Sample AdjustmentSample 2"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test with Unstained Sample AdjustmentSample 3"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test with Unstained Sample AdjustmentSample 4"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test with Unstained Sample AdjustmentSample 5"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test with Unstained Sample Missing Detectors AdjustmentSample 1"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test with Unstained Sample Missing Detectors AdjustmentSample 2"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test with Unstained Sample Missing Detectors AdjustmentSample 3"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test with Unstained Sample Missing Detectors UnstainedSample"],
				Object[Sample, "AnalyzeCompensationMatrix Unit Test with Unstained Sample UnstainedSample"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentData 1"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentData 2"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentData 3"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentData 4"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentData 5"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentData 6"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentData 7"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentData 8"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentData 9"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentData 10"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentData 11"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentData 12"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentData 13"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentData 14"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test 15 Detectors AdjustmentData 15"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test AdjustmentData 1"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test AdjustmentData 2"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test AdjustmentData 3"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test AdjustmentData 4"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test AdjustmentData 5"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test Missing Detectors AdjustmentData 1"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test Missing Detectors AdjustmentData 2"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test Missing Detectors AdjustmentData 3"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test Missing Detectors UnstainedData"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test UnstainedData"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test with Unstained Sample AdjustmentData 1"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test with Unstained Sample AdjustmentData 2"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test with Unstained Sample AdjustmentData 3"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test with Unstained Sample AdjustmentData 4"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test with Unstained Sample AdjustmentData 5"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test with Unstained Sample Missing Detectors AdjustmentData 1"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test with Unstained Sample Missing Detectors AdjustmentData 2"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test with Unstained Sample Missing Detectors AdjustmentData 3"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test with Unstained Sample Missing Detectors UnstainedData"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrix Unit Test with Unstained Sample UnstainedData"],
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test 15 Detectors Protocol"],
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test Missing Detectors Protocol"],
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test Protocol"],
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test with Unstained Sample Missing Detectors Protocol"],
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test with Unstained Sample Protocol"],
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrix Unit Test Empty Protocol"]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

			(* Create test protocols *)
			Analysis`Private`makeCompensationMatrixTestProtocol[15,15,1000,False,"AnalyzeCompensationMatrix Unit Test 15 Detectors"];
			Analysis`Private`makeCompensationMatrixTestProtocol[5,5,100,False,"AnalyzeCompensationMatrix Unit Test"];
			Analysis`Private`makeCompensationMatrixTestProtocol[5,5,100,True,"AnalyzeCompensationMatrix Unit Test with Unstained Sample"];
			Analysis`Private`makeCompensationMatrixTestProtocol[5,3,100,False,"AnalyzeCompensationMatrix Unit Test Missing Detectors"];
			Analysis`Private`makeCompensationMatrixTestProtocol[5,3,100,True,"AnalyzeCompensationMatrix Unit Test with Unstained Sample Missing Detectors"];
			Upload[<|Type->Object[Protocol,FlowCytometry],Name->"AnalyzeCompensationMatrix Unit Test Empty Protocol",CompensationSamplesIncluded->False|>];
		];
	)

	(* Erase test objects when testing is complete*)
	(*SymbolTearDown:>(
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	)*)
];


(* ::Subsection::Closed:: *)
(*AnalyzeCompensationMatrixOptions*)


(* Define Tests *)
DefineTests[AnalyzeCompensationMatrixOptions,
	{
		Example[{Basic, "Return the resolved options for a single flow cytometry protocol:"},
			AnalyzeCompensationMatrixOptions[
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors Protocol"]
			],
			_Grid
		],
		Example[{Basic, "Return the resolved options for multiple flow cytometry protocols:"},
			AnalyzeCompensationMatrixOptions[
				{
					Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test with Unstained Sample Missing Detectors Protocol"],
					Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test with Unstained Sample Protocol"]
				}
			],
			_Grid,
			Messages:>{Warning::AdjustmentDataNotFound}
		],
		Example[{Options, OutputFormat, "By default, AnalyzeCompensationMatrixOptions returns a table:"},
			AnalyzeCompensationMatrixOptions[
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test Protocol"],
				OutputFormat->Table
			],
			_Grid
		],
		Example[{Options, OutputFormat, "Return the resolved options as a list:"},
			AnalyzeCompensationMatrixOptions[
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test Protocol"],
				OutputFormat->List
			],
			{
				Detectors->{FlowCytometryDetectorP..},
				DetectionLabels->Null,
				DetectionThresholds->Repeat[UnitsP[],5],
				Template->Null
			}
		]
	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	(* Create test objects when tests start *)
	SymbolSetUp:>(
		(* Reset the created objects list and set a random seed *)
		$CreatedObjects={};
		SeedRandom[123];

		(* Erase any objects we missed in the last unit test run *)
		Module[{allObjects,existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentSample 1"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentSample 2"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentSample 3"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentSample 4"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentSample 5"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentSample 6"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentSample 7"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentSample 8"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentSample 9"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentSample 10"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentSample 11"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentSample 12"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentSample 13"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentSample 14"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentSample 15"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test AdjustmentSample 1"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test AdjustmentSample 2"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test AdjustmentSample 3"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test AdjustmentSample 4"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test AdjustmentSample 5"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test Missing Detectors AdjustmentSample 1"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test Missing Detectors AdjustmentSample 2"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test Missing Detectors AdjustmentSample 3"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test Missing Detectors UnstainedSample"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test UnstainedSample"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test with Unstained Sample AdjustmentSample 1"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test with Unstained Sample AdjustmentSample 2"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test with Unstained Sample AdjustmentSample 3"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test with Unstained Sample AdjustmentSample 4"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test with Unstained Sample AdjustmentSample 5"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test with Unstained Sample Missing Detectors AdjustmentSample 1"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test with Unstained Sample Missing Detectors AdjustmentSample 2"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test with Unstained Sample Missing Detectors AdjustmentSample 3"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test with Unstained Sample Missing Detectors UnstainedSample"],
				Object[Sample, "AnalyzeCompensationMatrixOptions Unit Test with Unstained Sample UnstainedSample"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentData 1"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentData 2"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentData 3"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentData 4"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentData 5"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentData 6"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentData 7"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentData 8"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentData 9"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentData 10"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentData 11"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentData 12"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentData 13"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentData 14"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors AdjustmentData 15"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test AdjustmentData 1"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test AdjustmentData 2"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test AdjustmentData 3"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test AdjustmentData 4"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test AdjustmentData 5"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test Missing Detectors AdjustmentData 1"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test Missing Detectors AdjustmentData 2"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test Missing Detectors AdjustmentData 3"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test Missing Detectors UnstainedData"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test UnstainedData"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test with Unstained Sample AdjustmentData 1"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test with Unstained Sample AdjustmentData 2"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test with Unstained Sample AdjustmentData 3"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test with Unstained Sample AdjustmentData 4"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test with Unstained Sample AdjustmentData 5"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test with Unstained Sample Missing Detectors AdjustmentData 1"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test with Unstained Sample Missing Detectors AdjustmentData 2"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test with Unstained Sample Missing Detectors AdjustmentData 3"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test with Unstained Sample Missing Detectors UnstainedData"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test with Unstained Sample UnstainedData"],
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test 15 Detectors Protocol"],
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test Missing Detectors Protocol"],
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test Protocol"],
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test with Unstained Sample Missing Detectors Protocol"],
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrixOptions Unit Test with Unstained Sample Protocol"]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

			(* Create test protocols *)
			Analysis`Private`makeCompensationMatrixTestProtocol[15,15,1000,False,"AnalyzeCompensationMatrixOptions Unit Test 15 Detectors"];
			Analysis`Private`makeCompensationMatrixTestProtocol[5,5,100,False,"AnalyzeCompensationMatrixOptions Unit Test"];
			Analysis`Private`makeCompensationMatrixTestProtocol[5,5,100,True,"AnalyzeCompensationMatrixOptions Unit Test with Unstained Sample"];
			Analysis`Private`makeCompensationMatrixTestProtocol[5,3,100,False,"AnalyzeCompensationMatrixOptions Unit Test Missing Detectors"];
			Analysis`Private`makeCompensationMatrixTestProtocol[5,3,100,True,"AnalyzeCompensationMatrixOptions Unit Test with Unstained Sample Missing Detectors"];
		];
	),

	(* Erase test objects when testing is complete*)
	SymbolTearDown:>(
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	)
];


(* ::Subsection::Closed:: *)
(*AnalyzeCompensationMatrixPreview*)


(* Define Tests *)
DefineTests[AnalyzeCompensationMatrixPreview,
	{
		Example[{Basic, "The compensation matrix preview returns an interactive app for setting the thresholds between positive and negative populations in each compensation sample:"},
			AnalyzeCompensationMatrixPreview[
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test Protocol"]
			],
			_Pane,
			Stubs:>{
				AnalyzeCompensationMatrixPreview[Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test Protocol"]] = 
					Block[{ECL`$CCD},Staticize@AnalyzeCompensationMatrixPreview[	Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test Protocol"],	Template -> Null (* just to avoid hitting this same definition *)]]
			}
		],
		Example[{Basic, "The preview is not interactive if an unstained sample is used as a universal negative for compensation, since the positive and negative populations will be pre-defined and no thresholds are used:"},
			AnalyzeCompensationMatrixPreview[
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample Protocol"]
			],
			_Pane,
			Stubs:>{
				AnalyzeCompensationMatrixPreview[Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample Protocol"]] = 
					Block[{ECL`$CCD},Staticize@AnalyzeCompensationMatrixPreview[Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample Protocol"],	Template -> Null (* just to avoid hitting this same definition *)]]
			}

		],
		Example[{Basic, "Preview the compensation matrix analysis for a list of compensation matrix protocols. Each preview will be placed in a separate slide within a SlideView:"},
			AnalyzeCompensationMatrixPreview[
				{
					Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test Protocol"],
					Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample Protocol"]
				}
			],
			SlideView[{Pane[___]..}, ___],
			Stubs:>{
				AnalyzeCompensationMatrixPreview[{
					Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test Protocol"],
					Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample Protocol"]
				}] = 
					Block[{ECL`$CCD},Staticize@AnalyzeCompensationMatrixPreview[	{
					Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test Protocol"],
					Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample Protocol"]
				},	Template -> Null (* just to avoid hitting this same definition *)]]
			}

		]
	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	(* Create test objects when tests start *)
	SymbolSetUp:>(
		(* Reset the created objects list and set a random seed *)
		$CreatedObjects={};
		SeedRandom[123];

		(* Erase any objects we missed in the last unit test run *)
		Module[{allObjects,existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentSample 1"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentSample 2"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentSample 3"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentSample 4"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentSample 5"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentSample 6"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentSample 7"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentSample 8"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentSample 9"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentSample 10"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentSample 11"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentSample 12"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentSample 13"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentSample 14"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentSample 15"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test AdjustmentSample 1"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test AdjustmentSample 2"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test AdjustmentSample 3"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test AdjustmentSample 4"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test AdjustmentSample 5"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test Missing Detectors AdjustmentSample 1"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test Missing Detectors AdjustmentSample 2"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test Missing Detectors AdjustmentSample 3"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test Missing Detectors UnstainedSample"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test UnstainedSample"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample AdjustmentSample 1"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample AdjustmentSample 2"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample AdjustmentSample 3"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample AdjustmentSample 4"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample AdjustmentSample 5"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample Missing Detectors AdjustmentSample 1"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample Missing Detectors AdjustmentSample 2"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample Missing Detectors AdjustmentSample 3"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample Missing Detectors UnstainedSample"],
				Object[Sample, "AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample UnstainedSample"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentData 1"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentData 2"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentData 3"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentData 4"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentData 5"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentData 6"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentData 7"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentData 8"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentData 9"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentData 10"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentData 11"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentData 12"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentData 13"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentData 14"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors AdjustmentData 15"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test AdjustmentData 1"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test AdjustmentData 2"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test AdjustmentData 3"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test AdjustmentData 4"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test AdjustmentData 5"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test Missing Detectors AdjustmentData 1"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test Missing Detectors AdjustmentData 2"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test Missing Detectors AdjustmentData 3"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test Missing Detectors UnstainedData"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test UnstainedData"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample AdjustmentData 1"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample AdjustmentData 2"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample AdjustmentData 3"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample AdjustmentData 4"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample AdjustmentData 5"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample Missing Detectors AdjustmentData 1"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample Missing Detectors AdjustmentData 2"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample Missing Detectors AdjustmentData 3"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample Missing Detectors UnstainedData"],
				Object[Data, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample UnstainedData"],
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test 15 Detectors Protocol"],
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test Missing Detectors Protocol"],
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test Protocol"],
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample Missing Detectors Protocol"],
				Object[Protocol, FlowCytometry, "AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample Protocol"]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

			(* Create test protocols *)
			Analysis`Private`makeCompensationMatrixTestProtocol[15,15,1000,False,"AnalyzeCompensationMatrixPreview Unit Test 15 Detectors"];
			Analysis`Private`makeCompensationMatrixTestProtocol[5,5,100,False,"AnalyzeCompensationMatrixPreview Unit Test"];
			Analysis`Private`makeCompensationMatrixTestProtocol[5,5,100,True,"AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample"];
			Analysis`Private`makeCompensationMatrixTestProtocol[5,3,100,False,"AnalyzeCompensationMatrixPreview Unit Test Missing Detectors"];
			Analysis`Private`makeCompensationMatrixTestProtocol[5,3,100,True,"AnalyzeCompensationMatrixPreview Unit Test with Unstained Sample Missing Detectors"];
		];
	),

	(* Erase test objects when testing is complete*)
	SymbolTearDown:>(
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	)
];


(* ::Subsection::Closed:: *)
(*ValidAnalyzeCompensationMatrixQ*)


(* Define Tests *)
DefineTests[ValidAnalyzeCompensationMatrixQ,
	{
		Example[{Basic, "Validate input for a single flow cytometry protocol:"},
			ValidAnalyzeCompensationMatrixQ[
				Object[Protocol, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors Protocol"]
			],
			True
		],
		Example[{Basic, "Validate input of multiple flow cytometry protocols:"},
			ValidAnalyzeCompensationMatrixQ[
				{
					Object[Protocol, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test Protocol"],
					Object[Protocol, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test with Unstained Sample Protocol"]
				}
			],
			True
		],
		Example[{Basic, "Validate input and options for a single flow cytometry protocol. This call is invalid because DetectionThresholds cannot be specified unless Detectors are explicitly set:"},
			ValidAnalyzeCompensationMatrixQ[
				Object[Protocol, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors Protocol"],
				DetectionThresholds->{1000.0, 7777.0}
			],
			False,
			Messages:>{Error::DetectorsNotSet}
		],
		Example[{Options, OutputFormat, "By default, ValidAnalyzeCompensationMatrixQ returns a boolean:"},
			ValidAnalyzeCompensationMatrixQ[
				Object[Protocol, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test Protocol"],
				OutputFormat->Boolean
			],
			True
		],
		Example[{Options, OutputFormat, "Return an EmeraldTestSummary:"},
			ValidAnalyzeCompensationMatrixQ[
				Object[Protocol, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test Protocol"],
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary
		],
		Example[{Options, Verbose, "Print verbose output indicating test passage/failure for each test:"},
			ValidAnalyzeCompensationMatrixQ[
				Object[Protocol, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test Protocol"],
				Verbose->True
			],
			True
		],
		Example[{Options, Verbose, "Print verbose messages for failures only:"},
			ValidAnalyzeCompensationMatrixQ[
				Object[Protocol, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test Protocol"],
				DetectionThresholds->{1000.0, 7777.0},
				Verbose->Failures
			],
			False,
			Messages:>{Error::DetectorsNotSet}
		]
	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	(* Create test objects when tests start *)
	SymbolSetUp:>(
		(* Reset the created objects list and set a random seed *)
		$CreatedObjects={};
		SeedRandom[123];

		(* Erase any objects we missed in the last unit test run *)
		Module[{allObjects,existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentSample 1"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentSample 2"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentSample 3"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentSample 4"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentSample 5"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentSample 6"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentSample 7"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentSample 8"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentSample 9"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentSample 10"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentSample 11"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentSample 12"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentSample 13"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentSample 14"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentSample 15"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test AdjustmentSample 1"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test AdjustmentSample 2"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test AdjustmentSample 3"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test AdjustmentSample 4"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test AdjustmentSample 5"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test Missing Detectors AdjustmentSample 1"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test Missing Detectors AdjustmentSample 2"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test Missing Detectors AdjustmentSample 3"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test Missing Detectors UnstainedSample"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test UnstainedSample"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test with Unstained Sample AdjustmentSample 1"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test with Unstained Sample AdjustmentSample 2"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test with Unstained Sample AdjustmentSample 3"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test with Unstained Sample AdjustmentSample 4"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test with Unstained Sample AdjustmentSample 5"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test with Unstained Sample Missing Detectors AdjustmentSample 1"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test with Unstained Sample Missing Detectors AdjustmentSample 2"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test with Unstained Sample Missing Detectors AdjustmentSample 3"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test with Unstained Sample Missing Detectors UnstainedSample"],
				Object[Sample, "ValidAnalyzeCompensationMatrixQ Unit Test with Unstained Sample UnstainedSample"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentData 1"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentData 2"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentData 3"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentData 4"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentData 5"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentData 6"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentData 7"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentData 8"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentData 9"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentData 10"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentData 11"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentData 12"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentData 13"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentData 14"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors AdjustmentData 15"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test AdjustmentData 1"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test AdjustmentData 2"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test AdjustmentData 3"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test AdjustmentData 4"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test AdjustmentData 5"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test Missing Detectors AdjustmentData 1"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test Missing Detectors AdjustmentData 2"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test Missing Detectors AdjustmentData 3"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test Missing Detectors UnstainedData"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test UnstainedData"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test with Unstained Sample AdjustmentData 1"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test with Unstained Sample AdjustmentData 2"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test with Unstained Sample AdjustmentData 3"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test with Unstained Sample AdjustmentData 4"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test with Unstained Sample AdjustmentData 5"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test with Unstained Sample Missing Detectors AdjustmentData 1"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test with Unstained Sample Missing Detectors AdjustmentData 2"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test with Unstained Sample Missing Detectors AdjustmentData 3"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test with Unstained Sample Missing Detectors UnstainedData"],
				Object[Data, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test with Unstained Sample UnstainedData"],
				Object[Protocol, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors Protocol"],
				Object[Protocol, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test Missing Detectors Protocol"],
				Object[Protocol, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test Protocol"],
				Object[Protocol, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test with Unstained Sample Missing Detectors Protocol"],
				Object[Protocol, FlowCytometry, "ValidAnalyzeCompensationMatrixQ Unit Test with Unstained Sample Protocol"]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

			(* Create test protocols *)
			Analysis`Private`makeCompensationMatrixTestProtocol[15,15,1000,False,"ValidAnalyzeCompensationMatrixQ Unit Test 15 Detectors"];
			Analysis`Private`makeCompensationMatrixTestProtocol[5,5,100,False,"ValidAnalyzeCompensationMatrixQ Unit Test"];
			Analysis`Private`makeCompensationMatrixTestProtocol[5,5,100,True,"ValidAnalyzeCompensationMatrixQ Unit Test with Unstained Sample"];
			Analysis`Private`makeCompensationMatrixTestProtocol[5,3,100,False,"ValidAnalyzeCompensationMatrixQ Unit Test Missing Detectors"];
			Analysis`Private`makeCompensationMatrixTestProtocol[5,3,100,True,"ValidAnalyzeCompensationMatrixQ Unit Test with Unstained Sample Missing Detectors"];
		];
	),

	(* Erase test objects when testing is complete*)
	SymbolTearDown:>(
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	)
];
