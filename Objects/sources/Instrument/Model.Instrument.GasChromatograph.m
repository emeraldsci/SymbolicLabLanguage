(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, GasChromatograph], {
	Description->"The model for a gas chromatograph used to separate and analyze the components of mixtures of compounds.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* --- Instrument Specifications ---*)
		Detectors -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (MassSpectrometer|FlameIonizationDetector|ThermalConductivityDetector|BarrierDischargeIonizationDetector), (* What the heck is this pattern, GCDetectorTypeP *)
			Description -> "A list of detectors that can be installed on the instrument.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Scale -> { (* prep-GC would be epic! *)
			Format -> Multiple,
			Class -> Expression,
			Pattern :> PurificationScaleP,
			Description -> "Indicates if the instrument is intended to separate material (Preparative) and therefore collect fractions and/or analyze properties of the material (Analytical).",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		CarrierGases -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (Helium|Dihydrogen|Dinitrogen) (* TODO: CarrierGasP *),
			Description -> "A list of the carrier gases that can be plumbed to the instrument.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Inlets -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (SplitSplitless|Multimode|OnlineGasSampling|OnlineLiquidSampling), (* TODO: GCInletTypeP *)
			Description -> "Inlets that can be installed on this instrument. SplitSplitless inlets can flash vaporize a sample and force it either totally (splitless) or partially (split) onto the column for analysis, while the Multimode inlet allows for solvent venting with multiple injections, prior to a temperature programmed vaporization of the sample, pushing it onto the column in either split or splitless mode. OnlineGasSampling/OnlineLiquidSampling inlets can inject a sample loop containing gas/liquid into the inlet and onto the column.", (* The sampling technique(s) that may be used to inject a sample onto the column. LiquidInjection samples the liquid component of a sample, while HeadspaceInjection samples the gas in the space above a sample in the vial. SPMEInjection will adsorb a subset of the sample onto a fiber, which can then be heated inside the injector to release these compounds for analysis. *)
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		ColumnOvenSize -> {
			Format -> Single,
			Class -> {Real, Real, Real},
			Pattern :> {GreaterP[0*Centi*Meter],GreaterP[0*Centi*Meter],GreaterP[0*Centi*Meter]},
			Units -> {Centi Meter,Centi Meter,Centi Meter},
			Description -> "The dimensions of the GC column oven in centimeters, in order Height, Width, Depth.",
			Headers -> {"Height","Width","Depth"},
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		ImportFileTemplates -> {
			Format -> Multiple,
			Class -> {String,Link},
			Pattern :> {_String,_Link},
			Relation -> {Null,Object[EmeraldCloudFile]},
			Description -> "Files used as templates to import protocol methods into the instrument's software.",
			Headers -> {"Filename","Cloud File"},
			Category -> "Instrument Specifications",
			Developer -> True
		},
		(* --- Operating Limits --- *)
		MaxInletPressure->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*PSI],
			Units->PSI,
			Description->"The maximum inlet pressure that can be set on this instrument.",
			Category->"Operating Limits",
			Abstract->True
		},
		MaxNumberOfColumns -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The maximum number of unique columns (on unique cages) that can be installed in the column oven simultaneously.",
			Category -> "Operating Limits"
		},
		MinColumnOvenTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The minimum temperature at which the column oven can incubate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxColumnOvenTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The maximum temperature at which the column oven can incubate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxColumnCageDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Inch],
			Units -> Inch,
			Description -> "The maximum column cage outside diameter that can be accommodated inside of the column oven.",
			Category -> "Operating Limits"
		}
				(* KEEP THINKING: HOW ABOUT INSTALLED DETECTOR PARAMETERS? Maybe these parameters go on the Object[Instrument] *)
	}
}];
