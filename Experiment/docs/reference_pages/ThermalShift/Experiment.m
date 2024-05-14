(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentThermalShift*)

DefineUsage[ExperimentThermalShift,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentThermalShift[Samples]","Protocol"},
				Description->"creates a 'Protocol' object for measuring sample fluorescence during heating and cooling (melting curve analysis) to determine shifts in thermal stability of 'Samples' under varying conditions.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples to be analyzed for thermal stability.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False,
							NestedIndexMatching->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol object(s) describing how to run the thermal shift experiment.",
						Pattern:>ListableP[ObjectP[Object[Protocol,ThermalShift]]]
					}
				}
			}
		},

		MoreInformation -> {
			"For nucleic acids, uses extrinsic fluorescence to monitor structural changes in analytes during a temperature ramp.",
			"For proteins, uses intrinsic or extrinsic fluorescence and static light scattering to monitor structural changes in analytes during a temperature ramp.",
			"Assays using extrinsic fluorescent dyes are also referred to as Differential Scanning Fluorimetry (DSF) or ThermoFlour Assay.",
			"Samples for this experiment can be prepared by pooling multiple samples and bringing to volume with buffer.",
			"    - To indicate that samples should be pooled, wrap the corresponding input samples in additional curly brackets, e.g. {{s1,s2},{s3,s4}}.",
			"    - Providing samples or containers in a flat list indicates that each sample should be measured individually and not be pooled.",
			"    - Providing samples in a plate indicates that each sample in the plate should be measured individually (e.g. myPlate or {myPlate}). If you wish to pool all samples in the plate, wrap the plate in additional list (e.g. {{myPlate}}).",
			"Each sample used in this experiment can be prepared using serial dilution or custom dilution curves prior to pooling.",
			"    - To indicate that samples should be serially diluted, use the SerialDilutionCurve option.",
			"    - To define custom dilutions use the DilutionCurve option.",
			"    - Any dilution curve options should be index matched to the samples within each pool. (e.g. for sample pool {s1,s2}, if SerialDilution of s1 is desired indicate SerialDilution->{{VolumeP,VolumeP,_Integer},Null}. This will create serial dilutions of s1, where each dilution is pooled with the desired volume of undiluted s2.)"
		},
		SeeAlso -> {
			"ExperimentThermalShiftOptions",
			"ValidExperimentThermalShiftOptions",
			"ExperimentUVMelting",
			"AnalyzeMeltingPoint",
			"AnalyzeThermodynamics",
			"PlotAbsorbanceThermodynamics",
			"PlotThermodynamics",
			"PlotMeltingPoint",
			"ExperimentFluorescenceKinetics",
			"ExperimentqPCR",
			"AnalyzeThermalShift"
		},
		Tutorials -> {},
		Author -> {"dima", "steven", "simon.vu", "millie.shah", "spencer.clark"}
	}
]