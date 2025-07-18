(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*AnalyzeAirBubbleLikelihood*)


(* ::Subsection:: *)
(*AnalyzeAirBubbleLikelihood*)

(* The function is currently used in all parsers for LC experiments. However, it is not exported for public use yet (we can export it once the publication is online) *)
DefineUsage[AnalyzeAirBubbleLikelihood,
	{
		BasicDefinitions -> {
			{
				Definition -> {"AnalyzeAirBubbleLikelihood[data]", "updatedData"},
				Description -> "uses the Liquid Chromatography Air Bubble Anomaly Detector Machine Learning Model to analyze the liquid chromatography data pressure trace(s) to predict the likelihood of air bubbles.",
				Inputs :> {
					{
						InputName -> "data",
						Description -> "Chromatography or ChromatographyMassSpectra data object(s) with pressure trace(s) to be analyzed with the Liquid Chromatography Air Bubble Anomaly Detector Machine Learning Model to predict the likelihood of air bubbles during the injection and updated with the results.",
						Widget -> Widget[
							Type->Object,
							Pattern:>ObjectP[{Object[Data,Chromatography],Object[Data,ChromatographyMassSpectra]}]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "updatedData",
						Description -> "Updated Chromatography or ChromatographyMassSpectra data object(s) with the predicted AirBubbleLikelihood populated.",
						Pattern :> {ObjectP[{Object[Data,Chromatography],Object[Data,ChromatographyMassSpectra]}]..}
					}
				}
			},
			{
				Definition -> {"AnalyzeAirBubbleLikelihood[pressureChromatograms]", "airBubbleLikelihoods"},
				Description -> "uses the Liquid Chromatography Air Bubble Anomaly Detector Machine Learning Model to analyze the pressure chromatogram(s) to predict the likelihood of air bubbles.",
				Inputs :> {
					{
						InputName -> "pressureChromatograms",
						Description -> "The pressure data over time to be analyzed with the Liquid Chromatography Air Bubble Anomaly Detector Machine Learning Model to predict the likelihood of air bubbles during the data collection time.",
						Widget -> Widget[
							Type->Expression,
							Pattern:>ListableP[
								Alternatives[
									{{TimeP,PressureP}..},
									QuantityCoordinatesP[{Minute, PSI}],
									BigQuantityArrayP[{Minute, PSI}]
								]
							],
							Size->Line
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "airBubbleLikelihoods",
						Description -> "The predicted percentage air bubble likelihood for the provided data.",
						Pattern :> {PercentP..}
					}
				}
			},
			{
				Definition -> {"AnalyzeAirBubbleLikelihood[pressureTraces]", "airBubbleLikelihoods"},
				Description -> "uses the Liquid Chromatography Air Bubble Anomaly Detector Machine Learning Model to analyze the pressure trace(s) to predict the likelihood of air bubbles.",
				Inputs :> {
					{
						InputName -> "pressureTraces",
						Description -> "The pressure data list to be analyzed with the Liquid Chromatography Air Bubble Anomaly Detector Machine Learning Model to predict the likelihood of air bubbles.",
						Widget -> Widget[
							Type->Expression,
							Pattern:>ListableP[{PressureP..}],
							Size->Line
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "airBubbleLikelihoods",
						Description -> "The predicted percentage air bubble likelihood for the provided data.",
						Pattern :> {PercentP..}
					}
				}
			}
		},
		MoreInformation->{
			"AnalyzeAirBubbleLikelihood can only analyze up to 1000 pressure points in one data set.",
			"For any data set with more than 80 pressure points, AnalyzeAirBubbleLikelihood automatically drops the first 40 pressure points to eliminate bad bubble prediction results from the initial pressure fluctuations. If the data set has fewer than 80 pressure points, no points are removed.",
			"AnalyzeAirBubbleLikelihood function only works on Mathematica version 13.2 or higher (including the ECL Command Center Desktop application).",
			"AnalyzeAirBubbleLikelihood is executed automatically to update the data objects as part of HPLC, FPLC, LCMS, SupercriticalFluidChromatography and IonChromatography protocols."
		},
		SeeAlso -> {
			"ExperimentHPLC",
			(* These functions can be removed from the usage if we want to make the function user-facing. Currently these are included here so it is clear where the function is being used. *)
			"InternalExperiment`Private`parseHPLC",
			"InternalExperiment`Private`parseLCMS",
			"InternalExperiment`Private`parseFPLC",
			"InternalExperiment`Private`parseSFC",
			"InternalExperiment`Private`parseIonChromatography",
			"InternalExperiment`Private`importChromeleon",
			"InternalExperiment`Private`importMassLynx",
			"InternalExperiment`Private`importChemStation",
			"InternalExperiment`Private`importUnicorn",
			"InternalExperiment`Private`importAnalyst",
			"InternalExperiment`Private`importChromeleon7"
		},
		Author -> {"axu"}
	}
];
