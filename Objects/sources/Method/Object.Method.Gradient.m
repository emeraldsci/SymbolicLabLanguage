

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Method, Gradient], {
	Description->"A method containing parameters specifying a solvent gradient utilized by an HPLC run.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the gradient is run.",
			Category -> "General",
			Abstract -> True
		},
		FlowRate -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], GreaterEqualP[(0*(Liter*Milli))/Minute]}...} | GreaterEqualP[(0*(Liter*Milli))/Minute]),
			Description -> "The speed of the mobile phase over time.",
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
		BufferA -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The first solution used in the mobile phase.",
			Category -> "Reagents",
			Abstract -> True
		},
		BufferB -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The second solution used in the mobile phase.",
			Category -> "Reagents",
			Abstract -> True
		},
		BufferC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The third solution used in the mobile phase.",
			Category -> "Reagents",
			Abstract -> True
		},
		BufferD -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The four solution used in the mobile phase.",
			Category -> "Reagents",
			Abstract -> True
		},
		BufferE -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The fifth solution used in the mobile phase.",
			Category -> "Reagents"
		},
		BufferF -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The sixth solution used in the mobile phase.",
			Category -> "Reagents"
		},
		BufferG -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The seventh solution used in the mobile phase.",
			Category -> "Reagents"
		},
		BufferH -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The eighth solution used in the mobile phase.",
			Category -> "Reagents"
		},
		GradientA -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "The percentage of Buffer A in the composition over time, in the form: {Time, % Buffer A}.",
			Category -> "General"
		},
		GradientB -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "The percentage of Buffer B in the composition over time, in the form: {Time, % Buffer B}.",
			Category -> "General"
		},
		GradientC -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "The percentage of Buffer C in the composition over time, in the form: {Time, % Buffer C}.",
			Category -> "General"
		},
		GradientD -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "The percentage of Buffer D in the composition over time, in the form: {Time, % Buffer D}.",
			Category -> "General"
		},
		GradientE -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "The percentage of BufferE in the composition over time, in the form: {Time, % BufferE} or a single % BufferE for the entire run.",
			Category -> "General"
		},
		GradientF -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "The percentage of BufferF in the composition over time, in the form: {Time, % BufferF} or a single % BufferF for the entire run.",
			Category -> "General"
		},
		GradientG -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "The percentage of BufferG in the composition over time, in the form: {Time, % BufferG} or a single % BufferG for the entire run.",
			Category -> "General"
		},
		GradientH -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "The percentage of BufferH in the composition over time, in the form: {Time, % BufferH} or a single % BufferH for the entire run.",
			Category -> "General"
		},
		Gradient -> {
			Format -> Multiple,
			Class -> {
				Real,
				Real,
				Real,
				Real,
				Real,
				Real,
				Real,
				Real,
				Real,
				Real
			},
			Pattern :> {
				GreaterEqualP[0*Minute],
				RangeP[0*Percent, 100*Percent],
				RangeP[0*Percent, 100*Percent],
				RangeP[0*Percent, 100*Percent],
				RangeP[0*Percent, 100*Percent],
				RangeP[0*Percent, 100*Percent],
				RangeP[0*Percent, 100*Percent],
				RangeP[0*Percent, 100*Percent],
				RangeP[0*Percent, 100*Percent],
				GreaterEqualP[(0*(Liter*Milli))/Minute]
			},
			Units -> {
				Minute,
				Percent,
				Percent,
				Percent,
				Percent,
				Percent,
				Percent,
				Percent,
				Percent,
				(Liter Milli)/Minute
			},
			Description -> "Definition of buffer composition as a function of time where composition at the points in between is assumed to be a line joining the points.",
			Headers -> {
				"Time",
				"Buffer A Composition",
				"Buffer B Composition",
				"Buffer C Composition",
				"Buffer D Composition",
				"Buffer E Composition",
				"Buffer F Composition",
				"Buffer G Composition",
				"Buffer H Composition",
				"Flow Rate"
			},
			Category -> "General"
		},
		RefractiveIndexReferenceLoading -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Open,Closed],
			Description -> "For each member of Gradient, the status of HPLC refactive index detector reference loading valves. When set to Open, buffer and sample are loaded into the reference cell during this gradient step.",
			Category -> "General",
			IndexMatching -> Gradient
		},
		GradientStart -> {
			Format -> Single,
			Class -> Real,
			Pattern :> PercentP,
			Units -> Percent,
			Description -> "For linear gradients, the initial Buffer B percentage.",
			Category -> "General"
		},
		GradientEnd -> {
			Format -> Single,
			Class -> Real,
			Pattern :> PercentP,
			Units -> Percent,
			Description -> "For linear gradients, the final Buffer B percentage.",
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
			Description -> "The amount of time to equilibrate at GradientStart before starting the gradient.",
			Category -> "General"
		},
		FlushTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> TimeP,
			Units -> Minute,
			Description -> "The amount of time to flush at 100% Buffer B at the end of the gradient.",
			Category -> "General"
		}
	}
}];
