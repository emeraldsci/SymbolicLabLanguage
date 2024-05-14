(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification, Autoclave], {
	Description->"A protocol that verifies the functionality of the autoclave target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		Indicator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				(* TODO: Remove Model[Sample]/Object[Sample] here after item migration *)
				Model[Sample],
				Object[Sample],
				Model[Item],
				Object[Item]
			],
			Description -> "Biological indicator that will be autoclaved and therefore should not exhibit fluorescence if properly sterilized.",
			Category -> "Sterilizing"
		},
		BioHazardBag -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				(* TODO: Remove Model[Sample]/Object[Sample] here after item migration *)
				Model[Sample],
				Object[Sample],
				Object[Item],
				Model[Item]
			],
			Description -> "The biohazard waste bag in which the biological indicator will be placed before autoclaving.",
			Category -> "Sterilizing"
		},
		AutoclaveTape -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				(* TODO: Remove Model[Sample]/Object[Sample] here after item migration *)
				Model[Sample],
				Object[Sample],			
				Model[Item],
				Object[Item]
			],
			Description -> "Adhesive tape that can withstand autoclave chamber conditions.",
			Category -> "Sterilizing"
		},
		IncubationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			Description -> "The length of time for which the biological indicators should be incubated.",
			Category -> "Incubation"
		},
		IndicatorReader -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The instrument used to measure the fluorescence from the biological indicators used to verify the sterilization capabiliy of the autoclave.",
			Category -> "Incubation"
		},
		ControlIndicator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				(* TODO: Remove Model[Sample]/Object[Sample] here after item migration *)
				Model[Sample],
				Object[Sample],			
				Model[Item],
				Object[Item]
			],
			Description -> "Control Biological indicator that will not be autoclaved and therefore should exibit fluorescence.",
			Category -> "Incubation"
		},
		Vortex -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The instrument used to vortex the biological indicators used to verfiy the sterilization capabiliy of the autoclave.",
			Category -> "Incubation"
		},
		IndicatorPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			(* TODO: Remove Model[Sample]/Object[Sample] here after item migration *)
			Relation -> {Model[Sample]| Object[Sample]| Object[Item] | Model[Item], Object[Instrument] | Model[Instrument], Null},
			Description -> "Specifies the position in the sterilization indicator reader into which the Indicator will be placed.",
			Category -> "Placements",
			Headers -> {"Test Indicator","Destination Instrument","Destination Position"},
			Developer -> True
		},
		ControlPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			(* TODO: Remove Model[Sample]/Object[Sample] here after item migration *)			
			Relation -> {Model[Sample]| Object[Sample]| Object[Item] | Model[Item], Object[Instrument] | Model[Instrument], Null},
			Description -> "Specifies the position in the sterilization indicator reader into which the ControlIndicator will be placed.",
			Category -> "Placements",
			Headers -> {"Control Indicator","Destination Instrument","Destination Position"},
			Developer -> True
		},
		IndicatorStripColorChange -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the printed strip on the label of the biological indicator has changed from rose to brown. This color change confirms that the biological indicator has been exposed to the steam sterilization process. This color change does not indicate that the sterilization process was sufficient to achieve sterility.",
			Category -> "Experimental Results"
		},
		IndicatorFluorescence -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FluorescenceReaderResultP,
			Description -> "Indicates if the fluorescence reading for the autoclaved biological indicator is positive or negative. A negative reading is the expected result for a successful sterilization.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		ControlFluorescence -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FluorescenceReaderResultP,
			Description -> "Indicates if the fluorescence reading for the un-autoclaved, control biological indicator is positive or negative. A positive reading is the expected result since the control indicator was not autoclaved.",
			Category -> "Experimental Results",
			Abstract -> True
		}
	}
}];
