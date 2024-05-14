(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, PlateTilter], {
	Description->"A model instrument used for tilting plates on a robotic liquid handler.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		MaxAngle->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*AngularDegree],
			Units->AngularDegree,
			Description->"The maximum angle of tilt that this plate tilter can perform.",
			Category->"Operating Limits"
		}
	}
}];
