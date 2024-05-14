(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotFluorescenceKinetics*)


DefineOptions[PlotFluorescenceKinetics,
	optionsJoin[
		Options:>{
			{
				OptionName->ExcitationWavelength,
				Default->Automatic,
				Description->"Indicates that only data generated at this excitation wavelength should be plotted.",
				AllowNull->True,
				Category->"Data Specifications",
				Widget->Widget[Type->Quantity,Pattern:>RangeP[0 Nanometer,1000 Nanometer],Units->Alternatives[Nanometer]]
			},
			{
				OptionName->EmissionWavelength,
				Default->Automatic,
				Description->"Indicates that only data generated at this emission wavelength should be plotted.",
				AllowNull->True,
				Category->"Data Specifications",
				Widget->Widget[Type->Quantity,Pattern:>RangeP[0 Nanometer,1000 Nanometer],Units->Alternatives[Nanometer]]
			},
			{
				OptionName->DualEmissionWavelength,
				Default->Automatic,
				Description->"Indicates that only data generated at this dual emission wavelength should be plotted.",
				AllowNull->True,
				Category->"Data Specifications",
				Widget->Widget[Type->Quantity,Pattern:>RangeP[0 Nanometer,1000 Nanometer],Units->Alternatives[Nanometer]]
			},

			(* Hide the Peaks,Fractions, and Ladders options *)
			ModifyOptions[EmeraldListLinePlot,
				{
					Peaks,PeakLabels,PeakLabelStyle,
					Fractions,FractionColor,FractionHighlights,
					FractionHighlightColor,Ladder,Prolog,Epilog
				},
				Category->"Hidden"
			]
		},
		generateSharedOptions[Object[Data,FluorescenceKinetics],
			EmissionTrajectories,
			PlotTypes->{LinePlot},
			SecondaryData->{},
			CategoryUpdates->{
				OptionFunctions->"Hidden",
				PrimaryData->"Data Specifications",
				SecondaryData->"Data Specifications",
				Display->"Hidden",
				IncludeReplicates->"Data Specifications",
				Zoomable->"Image Format"
			}
		]
	],
	SharedOptions :> {
		EmeraldListLinePlot
	}
];

(* Messages *)
PlotFluorescenceKinetics::NoTrajectory="Raw data could not be resolved for inputs `1`. Please use Inspect[] to verify that the requested fields and wavelengths have corresponding data.";

(* Raw Data Definition *)
PlotFluorescenceKinetics[primaryData:rawPlotInputP,inputOptions:OptionsPattern[PlotFluorescenceKinetics]]:=Module[
	{originalOps,safeOps,plotOutputs,wavelengthOps},

	(* Convert the original options into a list *)
	originalOps=ToList[inputOptions];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotFluorescenceKinetics,originalOps];

	(* Call raw to packet to get options *)
	plotOutputs=rawToPacket[primaryData,Object[Data,FluorescenceKinetics],PlotFluorescenceKinetics,SafeOptions[PlotFluorescenceKinetics, ToList[inputOptions]]];

	(* Hide wavelength ops because they are unused for raw data *)
	wavelengthOps={
		ExcitationWavelength->Null,
		EmissionWavelength->Null,
		DualEmissionWavelength->Null
	};

	(* Return the output *)
	processELLPOutput[plotOutputs,safeOps,wavelengthOps]
];

(* Packet Definition *)
(* PlotFluorescenceKinetics[objs:plotInputP,inputOptions:OptionsPattern[PlotFluorescenceKinetics]]:= *)
(* PlotLuminescenceKinetics will call on PlotFluorescenceKinetics to plot its graph *)
PlotFluorescenceKinetics[objs:ListableP[ObjectP[{Object[Data, FluorescenceKinetics],Object[Data,LuminescenceKinetics]}],2],inputOptions:OptionsPattern[PlotFluorescenceKinetics]]:=Module[
	{
		originalOps,safeOps,packetToELLPResult,resolvedWavelengths,resolvedWavelengthOps,
		suppliedExcitationWavelength,suppliedEmissionWavelength,suppliedDualEmissionWavelength,packets,updatedPackets
	},

	(* Convert the original options into a list *)
	originalOps=ToList[inputOptions];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotFluorescenceKinetics,originalOps];

	(* Get the option values of the wavelength fields *)
	{
		suppliedExcitationWavelength,
		suppliedEmissionWavelength,
		suppliedDualEmissionWavelength
	}=Lookup[safeOps,{
		ExcitationWavelength,
		EmissionWavelength,
		DualEmissionWavelength
	}];

	(* Download input object packets *)
	packets=Download[Flatten[ToList[objs]]];

	(* Update Packets, mapping over inputs if a list is provided *)
	{updatedPackets,resolvedWavelengths}=Transpose@Map[
		Function[packet,
			Module[
				{
					emissionWavelengths,excitationWavelengths,dualEmissionWavelengths,
					requestedExcitationWavelength,requestedEmissionWavelength,requestedDualEmissionWavelength,
					resolvedWavelengths,emissionTrajectories,updatedPack
				},

				(* Get all the wavelengths used from our data packet *)
				{excitationWavelengths,emissionWavelengths,dualEmissionWavelengths}=Map[
					(* If only emission wavelengths are supplied *)
					If[MatchQ[#,Null|{}],
						ConstantArray[Null,Length[Lookup[packet,EmissionWavelengths]]],
						Round[#]
					]&,
					Lookup[packet,{ExcitationWavelengths,EmissionWavelengths,DualEmissionWavelengths},Null]
				];

				(* Resolve emission and excitation wavelength options - excitation will resolve to Null for LK protocols *)
				{requestedExcitationWavelength,requestedEmissionWavelength,requestedDualEmissionWavelength}=Switch[
					(* Check each supplied option*)
					{suppliedExcitationWavelength,suppliedEmissionWavelength,suppliedDualEmissionWavelength},

					(* Use first wavelength if all automatic *)
					{Automatic,Automatic,Automatic},{FirstOrDefault[excitationWavelengths],FirstOrDefault[emissionWavelengths],FirstOrDefault[dualEmissionWavelengths]},

					(* If all are valid, use the supplied values *)
					{DistanceP,DistanceP,DistanceP},{suppliedExcitationWavelength,suppliedEmissionWavelength,suppliedDualEmissionWavelength},

					(* Choose the first emission wavelength which corresponds to the supplied excitation wavelength *)
					{DistanceP,_,_},{
						suppliedExcitationWavelength,
						First[PickList[emissionWavelengths,excitationWavelengths,suppliedExcitationWavelength],$Failed],
						First[PickList[dualEmissionWavelengths,excitationWavelengths,suppliedExcitationWavelength],$Failed]
					},

					(* Choose the first excitation wavelength which corresponds to the supplied emission wavelength *)
					{_,DistanceP,_},{
						First[PickList[excitationWavelengths,emissionWavelengths,suppliedEmissionWavelength],$Failed],
						suppliedEmissionWavelength,
						First[PickList[dualEmissionWavelengths,emissionWavelengths,suppliedEmissionWavelength],$Failed]
					},

					(* Choose the first excitation wavelength which corresponds to the supplied dual emission wavelength *)
					{_,_,_DistanceP},{
						First[PickList[excitationWavelengths,dualEmissionWavelengths,suppliedDualEmissionWavelength],$Failed],
						First[PickList[emissionWavelengths,dualEmissionWavelengths,suppliedDualEmissionWavelength],$Failed],
						suppliedDualEmissionWavelength
					},
					_,{Null,Null,Null}
				];

				(* Bundle together *)
				resolvedWavelengths={requestedExcitationWavelength,requestedEmissionWavelength,requestedDualEmissionWavelength};

				(* Plot the first trajectory which has the appropriate wavelengths *)
				If[MemberQ[{requestedExcitationWavelength,requestedEmissionWavelength,requestedDualEmissionWavelength},$Failed],
					{$Failed,$Failed},
					Module[{requestedTrajectory,requestedDualTrajectory},

						(* Primary raw data *)
						requestedTrajectory=If[MemberQ[{requestedExcitationWavelength,requestedEmissionWavelength},DistanceP],
							First[
								MapThread[
									If[MatchQ[{requestedExcitationWavelength,requestedEmissionWavelength},{#1,#2}],
										#3,
										Nothing
									]&,
									{excitationWavelengths,emissionWavelengths,Lookup[packet,EmissionTrajectories]}
								],
								$Failed
							],
							(* Raw trajectory sent in so we don't have wavelength info *)
							First[Lookup[packet,EmissionTrajectories]]
						];

						(* Secondary raw data *)
						requestedDualTrajectory=If[MatchQ[requestedDualEmissionWavelength,DistanceP],
							First[
								MapThread[
									If[MatchQ[{requestedExcitationWavelength,requestedDualEmissionWavelength},{#1,#2}],
										#3,
										Nothing
									]&,
									{excitationWavelengths,dualEmissionWavelengths,Lookup[packet,DualEmissionTrajectories]}
								],
								$Failed
							],
							(* Raw trajectory sent in so we don't have wavelength info *)
							First[Lookup[packet,DualEmissionTrajectories],{}]
						];

						(* Return $Failed if data could not be resolved *)
						updatedPack=If[MatchQ[requestedTrajectory,$Failed],
							$Failed,
							Append[packet,{EmissionTrajectories->requestedTrajectory,DualEmissionTrajectories->requestedDualTrajectory}]
						];

						(* Return packets and resolved wavelengths *)
						{updatedPack,resolvedWavelengths}
					]
				]
			]
		],
		packets
	];

	(* Return early if resolution failed *)
	If[MemberQ[updatedPackets,$Failed],
		Message[PlotFluorescenceKinetics::NoTrajectory,Part[ToList[objs],Flatten@Position[updatedPackets,$Failed]]];
		Return[Lookup[safeOps,Output]/.{
			Result->$Failed,
			Preview->Null,
			Options->$Failed,
			Tests->{}
		}]
	];

	(* Convert resolved wavelengths into a list of options *)
	resolvedWavelengthOps=MapThread[
		((#1->#2)/.{$Failed->Null})&,
		{{ExcitationWavelength,EmissionWavelength,DualEmissionWavelength},First[resolvedWavelengths]}
	];

	(* Otherwise call packetToELLP *)
	plotOutputs=packetToELLP[
		Unflatten[updatedPackets,ToList[objs]],
		PlotFluorescenceKinetics,
		(* NOTE - packetToELLP takes originalOps, not safeOps *)
		originalOps
	];

	(* Return the output *)
	processELLPOutput[plotOutputs,safeOps,resolvedWavelengthOps]
]
