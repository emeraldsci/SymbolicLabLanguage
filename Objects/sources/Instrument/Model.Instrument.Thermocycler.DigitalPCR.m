

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, Thermocycler, DigitalPCR],{
	Description->"Model of a device that partitions samples into nanoliter droplets, uses polymerase chain reaction to amplify target genes and reads fluorescence signals from droplets to quantify copy numbers of DNA or RNA.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		(* Droplet generation properties *)

		DropletGeneratorProcessTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Minute],
			Units->Minute,
			Description->"The duration of time taken to complete sample emulsification for all wells in a 96-well assay plate.",
			Category->"Operating Limits"
		},
		DropletGeneratingGroups->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{ListableP[WellP]..},
			Description->"List of well indices that are processed for droplet generation in parallel.",
			Category->"Instrument Specifications"
		},

		(* Droplet reading properties *)

		DropletReaderProcessTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Minute],
			Units->Minute,
			Description->"The duration of time taken to detect fluorescence signals from droplets in all the wells of a 96-well cartridge.",
			Category->"Operating Limits"
		},
		DropletSizeCutoffs->{
			Format->Single,
			Class->{Real,Real},
			Pattern:>{GreaterP[0*Nanoliter],GreaterP[0*Nanoliter]},
			Units->{Nanoliter,Nanoliter},
			Description->"The volumetric range used by the instrument to qualify droplets for fluorescence signal detection. Droplets with volumes outside the range are ignored.",
			Headers->{"Minimum Volume","Maximum Volume"},
			Category->"Instrument Specifications"
		}
	}
}]