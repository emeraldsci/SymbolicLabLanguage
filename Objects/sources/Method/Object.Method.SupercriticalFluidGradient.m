

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Method, SupercriticalFluidGradient], {
	Description->"A method containing parameters specifying a binary solvent gradient utilized by an SFC run.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The column temperature at which the gradient is run.",
			Category -> "General",
			Abstract -> True
		},
		FlowRate -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],GreaterEqualP[0 Milliliter/Minute]}...}|GreaterEqualP[0 Milliliter/Minute]),
			Description -> "The flow rate at which the gradient is run.",
			Category -> "General"
		},
		InitialFlowRate ->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*(Liter*Milli))/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "The starting flow rate used by this gradient.",
			Category -> "General"
		},
		CosolventA -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The model used as Cosolvent A in this gradient.",
			Category -> "Reagents",
			Abstract -> True
		},
		CosolventB -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The model used as Cosolvent B in this gradient.",
			Category -> "Reagents",
			Abstract -> True
		},
		CosolventC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The model used as Cosolvent C in this gradient.",
			Category -> "Reagents",
			Abstract -> True
		},
		CosolventD -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The model used as Cosolvent D in this gradient.",
			Category -> "Reagents",
			Abstract -> True
		},
		CO2Gradient -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "The percentage of CO2 in the composition over time, in the form: {Time, % CO2}.",
			Category -> "General"
		},
		GradientA -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "The percentage of Cosolvent A in the composition over time, in the form: {Time, % Cosolvent A}.",
			Category -> "General"
		},
		GradientB -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "The percentage of Cosolvent B in the composition over time, in the form: {Time, % Cosolvent B}.",
			Category -> "General"
		},
		GradientC -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "The percentage of Cosolvent C in the composition over time, in the form: {Time, % Cosolvent C}.",
			Category -> "General"
		},
		GradientD -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "The percentage of Cosolvent D in the composition over time, in the form: {Time, % Cosolvent D}.",
			Category -> "General"
		},
		Gradient -> {
			Format -> Multiple,
			Class -> {Real, Real, Real, Real, Real, Real, Real, Real},
			Pattern :> {
				GreaterEqualP[0*Minute],
				RangeP[0*Percent, 100*Percent],
				RangeP[0*Percent, 100*Percent],
				RangeP[0*Percent, 100*Percent],
				RangeP[0*Percent, 100*Percent],
				RangeP[0*Percent, 100*Percent],
				RangeP[1000*PSI,6000*PSI],
				GreaterEqualP[(0*(Liter*Milli))/Minute]
			},
			Units -> {Minute, Percent, Percent, Percent, Percent, Percent, PSI, (Liter Milli)/Minute},
			Description -> "Definition of composition as a function of time where composition at the points in between is assumed to be a line joining the points except for the Back Pressure.",
			Headers -> {"Time", "CO2 Composition","Cosolvent A Composition","Cosolvent B Composition", "Cosolvent C Composition","Cosolvent D Composition","BackPressure","Flow Rate"},
			Category -> "General"
		},
		GradientStart -> {
			Format -> Single,
			Class -> Real,
			Pattern :> PercentP,
			Units -> Percent,
			Description -> "For linear gradients, the initial Cosolvent B percentage.",
			Category -> "General"
		},
		GradientEnd -> {
			Format -> Single,
			Class -> Real,
			Pattern :> PercentP,
			Units -> Percent,
			Description -> "For linear gradients, the final Cosolvent B percentage.",
			Category -> "General"
		},
		GradientDuration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> TimeP,
			Units -> Minute,
			Description -> "For linear gradients, the duration to reach GradientEnd from GradientStart.",
			Category -> "General"
		},
		EquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> TimeP,
			Units -> Minute,
			Description -> "The amount of time to equilibrate at GradientStart before starting the Gradient A.",
			Category -> "General"
		},
		FlushTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> TimeP,
			Units -> Minute,
			Description -> "The amount of time to flush at 100% Cosolvent B at the end of the Gradient A.",
			Category -> "General"
		},
		BackPressure -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> {{TimeP,GreaterP[0*PSI]}...}|GreaterP[0*PSI],
			Description -> "The applied pressure differential between the exit of the flow path and the atmosphere.",
			Category -> "General"
		}
	}
}];
