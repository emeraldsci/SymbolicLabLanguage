(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(*RCFToRPM*)

DefineUsage[RCFToRPM,
	{
		BasicDefinitions -> {
			{"RCFToRPM[RCF, radius]", "RPM", "converts the provided 'RCF' value into RPM given the provided 'radius'."},
			{"RCFToRPM[RCF, object]", "RPM", "converts the provided 'RCF' value into RPM given the radius in the provided rotor 'object'."},
			{"RCFToRPM[RCF, model]", "RPM", "converts the provided 'RCF' value into RPM given the radius in the provided model rotor 'model'."}
		},
		MoreInformation -> {
			""
		},
		Input :> {
			{"RCF", AccelerationP, "The RCF value to be convert into RPM."},
			{"radius", DistanceP, "The radius of the rotor for which the conversion is being made."},
			{"object", ObjectP[Object[Container, CentrifugeRotor]], "The object of the centrifuge rotor."},
			{"model", ObjectP[Model[Container, CentrifugeRotor]], "The model object of the centrifuge rotor."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"RPMToRCF",
			"GravitationalAcceleration"
		},
		Author -> {"axu", "dirk.schild", "josh.kenchel", "paul", "frezza"}
	}];


(* ::Subsubsection::Closed:: *)
(*RPMToRCF*)

DefineUsage[RPMToRCF,
	{
		BasicDefinitions -> {
			{"RPMToRCF[RPM, radius]", "RCF", "converts the provided 'RPM' value into RCF given the provided 'radius'."},
			{"RPMToRCF[RPM, object]", "RCF", "converts the provided 'RPM' value into RCF given the radius in the provided rotor 'object'."},
			{"RPMToRCF[RPM, model]", "RCF", "converts the provided 'RPM' value into RCF given the radius in the provided model rotor 'model'."}
		},
		MoreInformation -> {
			""
		},
		Input :> {
			{"RPM", RPMP, "The RPM value to be convert into RCF."},
			{"radius", DistanceP, "The radius of the rotor for which the conversion is being made."},
			{"object", ObjectP[Object[Container, CentrifugeRotor]], "The object of the centrifuge rotor."},
			{"model", ObjectP[Model[Container, CentrifugeRotor]], "The model object of the centrifuge rotor."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"RCFToRPM",
			"GravitationalAcceleration"
		},
		Author -> {"axu", "dirk.schild", "josh.kenchel", "paul", "frezza"}
	}];