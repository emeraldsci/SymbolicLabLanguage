(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotFluorescenceThermodynamics*)


DefineOptions[PlotFluorescenceThermodynamics,
	optionsJoin[
		generateSharedOptions[
			Object[Data, FluorescenceThermodynamics], 
			{CoolingCurve, MeltingCurve},
			PlotTypes->{LinePlot},
			DefaultUpdates->{
				IncludeReplicates->True,
				OptionFunctions->{arrowEpilog},
				Fractions->{}
			},
			AllowNullUpdates->{
				Fractions->False
			},
			CategoryUpdates->{
				CoolingCurve->"Hidden",
				MeltingCurve->"Hidden",
				RawCoolingCurve->"Hidden",
				RawMeltingCurve->"Hidden",
				SecondaryData->"Hidden",
				Display->"Hidden",
				IncludeReplicates->"Hidden",
				Peaks->"Hidden",
				OptionFunctions->"Hidden"
			}
		],
	Options:>{
	
			ModifyOptions[EmeraldListLinePlot,{Reflected,SecondYUnit,SecondYCoordinates,SecondYColors,SecondYRange,SecondYStyle},Category->"Hidden"],
			ModifyOptions[EmeraldListLinePlot,{PeakLabels,PeakLabelStyle,ErrorBars,ErrorType},Category->"Hidden"],
			ModifyOptions[EmeraldListLinePlot,
				{
					{
						OptionName->Scale,
						AllowNull->False,
						Category->"Hidden"
					}
				}
			],
			
			{
				OptionName->ArrowheadSize,
				Description->"The size of the arrows to lay atop the traces indicating the direction of the data.",
				Default->Medium,
				AllowNull->False,
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>Tiny|Small|Medium|Large],
					Widget[Type->Number,Pattern:>GreaterP[0],Min->0]
				],
				Category->"Plot Style"
			}
			
		}
	],
	SharedOptions :> {
		EmeraldListLinePlot
	}
];


(* Packet Definition *)
(* PlotFluorescenceThermodynamics[infs:plotInputP,inputOptions:OptionsPattern[PlotFluorescenceThermodynamics]]:= *)
PlotFluorescenceThermodynamics[infs:ListableP[ObjectP[Object[Data, FluorescenceThermodynamics]],2],inputOptions:OptionsPattern[PlotFluorescenceThermodynamics]]:=Module[
	{safeOps,ellpOutput},
	safeOps=SafeOptions[PlotFluorescenceThermodynamics,ToList[inputOptions]];	
	ellpOutput=packetToELLP[infs,PlotFluorescenceThermodynamics,{inputOptions}];
	processELLPOutput[ellpOutput,safeOps]
];
