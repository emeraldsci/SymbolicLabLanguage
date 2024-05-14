(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*CompatibleMaterialsQ*)


DefineUsage[CompatibleMaterialsQ,
{
	BasicDefinitions -> {
		{"CompatibleMaterialsQ[instrument,samples]","Boolean","checks the wetted materials of 'instrument' to determine whether any of the 'Samples' are chemically incompatible with any material in the 'instrument'."},
		{"CompatibleMaterialsQ[part,samples]","Boolean","checks the wetted materials of 'part' to determine whether any of the 'Samples' are chemically incompatible with any material in the 'part'."}
	},
	MoreInformation -> {
		"Compares the IncompatibleMaterials field of the samples' models with the WettedMaterials field in the instrument or part. Any overlap is interpreted as a chemical incompatibility.",
		"Chemical/material incompatibilities are based on a D rating (Severe Effect: Not recommended for any use) from this database: www.coleparmer.com/Chemical-Resistance",
		"For a chemical model, a list of incompatible materials can be found in the IncompatibleMaterials field.",
		"For an instruemnt or part model, a list of wetted materials can be found in the WettedMaterials field.",
		"If no information about compatibility is available for a given chemical, this function will assume that the chemical is universally compatible."
	},
	Input :> {
		{"instrument or part", ObjectP[{Model[Instrument],Object[Instrument],Object[Part], Model[Part]}], "The instrument/part or instrument/part model for which to check chemical compatibility of wetted materials with the samples."},
		{"Samples", ListableP[ObjectP[{Object[Sample],Model[Sample]}]],"The samples and models for which to check chemical compatibiliy with the wetted materials of the instrument."}
	},
	Output :> {
		{"Boolean", BooleanP, "A boolean indicating if the samples are chemically compatible with the instrument's or part's wetted materials."}
	},
	Sync -> Automatic,
	SeeAlso -> {
		"ExperimentStockSolution",
		"ExperimentSampleManipulation"
	},
	Author -> {"hayley", "mohamad.zandian"}
}];