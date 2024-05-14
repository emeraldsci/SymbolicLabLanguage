(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification, Autoclave], {
	Description->"Definition of a set of parameters for a qualification protocol that verifies the functionality of an autoclave.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		AutoclaveProgram -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AutoclaveProgramP,
			Description -> "The autoclave sterilization program to test.",
			Category -> "General",
			Abstract -> True
		},
		IndicatorReaderModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument],
			Description -> "The model of instrument used to measure the fluorescence from the biological indicators used to verfiy the sterilization capabiliy of the autoclave.",
			Category -> "General"
		},
		BioHazardBagModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			(* TODO: Remove Model[Sample]/Object[Sample] here after item migration *)
			Relation -> Model[Sample]|Model[Item],
			Description -> "The model of biohazard waste bag in which the biological indicator will be placed before autoclaving.",
			Category -> "General"
		},
		IndicatorModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			(* TODO: Remove Model[Sample]/Object[Sample] here after item migration *)			
			Relation -> Model[Sample]|Model[Item],
			Description -> "The model of biological indicator that will be autoclaved and therefore should not exibit fluorescence.",
			Category -> "General"
		},
		ControlIndicatorModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			(* TODO: Remove Model[Sample]/Object[Sample] here after item migration *)			
			Relation -> Model[Sample]|Model[Item],
			Description -> "The model of biological indicator that will not be autoclaved and therefore should exibit fluorescence.",
			Category -> "General"
		},
		IncubationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			Description -> "The length of time for which the biological indicators should be incubated.",
			Category -> "General"
		},
		VortexModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument],
			Description -> "The model of instrument used to vortex the biological indicators used to verfiy the sterilization capabiliy of the autoclave.",
			Category -> "General"
		},
		AutoclaveTapeModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			(* TODO: Remove Model[Sample]/Object[Sample] here after item migration *)			
			Relation -> Model[Sample]|Model[Item],
			Description -> "The model of adhesive tape that can withstand autoclave chamber conditions.",
			Category -> "General",
			Developer -> True
		}
	}
}];
