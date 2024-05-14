(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data,AcousticLiquidHandling],{
	Description->"Information related to the preparation performed on the sample by an acoustic liquid handler.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		(* ---------- Transfer Information ---------- *)
		SourcePosition->{
			Format->Single,
			Class->{String,Link},
			Pattern:>{WellPositionP,_Link},
			Relation->{Null,Object[Container,Plate]},
			Description->"The well in the plate that the source sample is located.",
			Headers->{"Source Well","Source Plate"},
			Category -> "General"
		},
		ResolvedManipulations->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleManipulationP,
			Description->"A list of individual transfers out of the source sample in the order they were performed.",
			Category -> "General"
		},
		TransferHistory->{
			Format->Multiple,
			Class->{
				Date,
				Real,
				Link,
				String,
				Real,
				Real
			},
			Pattern:>{
				_?DateObjectQ,
				GreaterEqualP[0*Nanoliter],
				_Link,
				WellPositionP,
				DistanceP,
				DistanceP
			},
			Units->{
				None,
				Nanoliter,
				None,
				None,
				Micrometer,
				Micrometer
			},
			Relation->{
				Null,
				Null,
				Object[Container,Plate],
				Null,
				Null,
				Null
			},
			Description->"For each transfer out of the source sample, date/time transferred, transfer volume, destination well, destination plate, and destination well offset from the center of the well.",
			Headers->{
				"Date Transferred",
				"Transfer Volume",
				"Destination Plate",
				"Destination Well",
				"Destination Well X Offset",
				"Destination Well Y Offset"
			},
			Category -> "General"
		},

		(* ---------- Experimental Results ---------- *)
		InitialVolume->{
			Format->Single,
			Class->Real,
			Pattern:>_?VolumeQ,
			Units->Microliter,
			Description->"The volume of the source sample, measured by an acoustic liquid handler before the transfer.",
			Category->"Experimental Results"
		},
		TransferVolume->{
			Format->Single,
			Class->Real,
			Pattern:>_?VolumeQ,
			Units->Nanoliter,
			Description->"The total volume that was transferred out from the source sample during manipulations.",
			Category->"Experimental Results"
		},
		FinalVolume->{
			Format->Single,
			Class->Real,
			Pattern:>_?VolumeQ,
			Units->Nanoliter,
			Description->"The volume of the source sample, measured by an acoustic liquid handler after completion of the transfer.",
			Category->"Experimental Results",
			Abstract->True
		},
		WellFluidHeight->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Meter],
			Units->Millimeter,
			Description->"The distance from the well bottom to the surface of the liquid, measured by an acoustic liquid handler after completion of the transfer.",
			Category->"Experimental Results"
		},
		FluidAnalysis->{
			Format->Single,
			Class->{
				String,
				VariableUnit
			},
			Pattern:>{
				_String,
				Alternatives[GreaterEqualP[0*Percent],UnitP[(Kilogram/(Second*Meter^2))]]
			},
			Units->{
				None,
				None
			},
			Headers->{
				"Fluid Type",
				"Fluid Composition"
			},
			Description->"The percentage equivalent of DMSO or Glycerol in the sample, or Acoustic Impedance of the sample, measured by the acoustic liquid handler.",
			Category->"Experimental Results"
		}
	}
}];
