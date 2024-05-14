

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, Thermocycler, DigitalPCR],{
	Description->"Device that partitions samples into nanoliter droplets, uses polymerase chain reaction to amplify target genes and uses fluorescence signals from droplets to quantify copy numbers of DNA or RNA.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{

		(* Droplet generation properties *)
		DropletGeneratorProcessTime->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],DropletGeneratorProcessTime]],
			Pattern:>GreaterP[0],
			Description->"The duration of time taken to complete sample emulsification in a 96-well assay plate.",
			Category->"Operating Limits"
		},
		DropletGeneratingGroups->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],DropletGeneratingGroups]],
			Pattern:>ListableP[{WellP..}],
			Description->"List of well indices that are processed for droplet generation in parallel.",
			Category->"Instrument Specifications"
		},

		(* Droplet reading properties *)

		DropletReaderProcessTime->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],DropletReaderProcessTime]],
			Pattern:>GreaterP[0],
			Description->"The duration of time taken to detect fluorescence signals from droplets in all the wells of a 96-well cartridge.",
			Category->"Operating Limits"
		},
		DropletSizeCutoffs->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],DropletSizeCutoffs]],
			Pattern:>{GreaterP[0],GreaterP[0]},
			Description->"The volumetric range used by the instrument to qualify droplets for fluorescence signal detection. Droplets with volumes outside the range are ignored.",
			Category->"Instrument Specifications"
		}
	}
}]