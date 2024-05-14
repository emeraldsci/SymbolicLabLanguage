(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Team, Financing], {
	Description -> "A team which serves as a grouping for users for sharing notebook access privileges and which pays users' membership fees as well as finances experiments in notebooks.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> UserStatusP,
			Description -> "Indicates if a team has an active ECL account open or the account has been retired and retained for historical authorship information.",
			Category -> "Organizational Information",
			Abstract -> True,
			AdminWriteOnly->True
		},
		Internal->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if this team is internal to the Emerald Cloud Lab organization and are therefore not billed for use of Emerald Cloud Lab's services.",
			Category->"Organizational Information",
			AdminWriteOnly->True
		},
		Backlog -> { (* TODO: Kill this field entirely. *)
			Format -> Multiple,
			Class -> Link,
			Pattern :>  _Link,
			Relation ->  Object[Protocol]| Object[Qualification] | Object[Maintenance],
			Description -> "The team's protocols in the priority order they should be begin processing as soon as more open threads become available either by waiting for currently processing protocols to be completed or by purchasing additional threads for the team.",
			Category -> "Organizational Information" ,
			Abstract -> True,
			Developer -> True
		},
		Queue -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :>  _Link,
			Relation ->  Object[Protocol] | Object[Qualification] | Object[Maintenance],
			Description -> "The team's protocols in the priority order that they should be begin processing as soon as open threads become available.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		MaxThreads-> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0,1],
			Units -> None,
			Description -> "The total number of simultaneous experiments this team can process at any given time. Experiments exceeding this number will wait in the queue until an open thread becomes available on this team's account.",
			Category -> "Organizational Information",
			AdminWriteOnly->True
		},
		ThreadLog-> {
			Format -> Multiple,
			Class -> {Date,Date,Integer},
			Pattern :> {_?DateObjectQ, _?DateObjectQ, GreaterEqualP[0,1]},
			Headers -> {"Start Date", "End Date", "Thread Count"},
			Description-> "A history of assigned MaxThreads set by customer billing. A start date with a null end date indicates that this MaxThread number matches the current current MaxThreads count.",
			Category -> "Organizational Information"
		},
		MaxUsers -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0,1],
			Units -> None,
			Description -> "The maximum number of ECL users that this financing team has alloted.",
			Category -> "Organizational Information",
			AdminWriteOnly->True
		},
		NumberOfUsers -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0,1],
			Units -> None,
			Description -> "The number of ECL users currently on this team.",
			Category -> "Organizational Information"
		},
		Members -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User][FinancingTeams],
			Description -> "Users whose membership fees are financed by this team.",
			Category -> "Organizational Information"
		},
		NotebooksFinanced -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[LaboratoryNotebook][Financers],
			Description -> "Notebooks that this organization finances the cost of experiments and ongoing cost of storage for.",
			Category -> "Organizational Information"
		},
		FavoriteFolders -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Favorite, Folder][Team],
			Description -> "Favorite folders that this organization's members can store favorite objects in.",
			Category -> "Organizational Information"
		},
		DefaultNotebook -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[LaboratoryNotebook],
			Description -> "The Notebook to use for new object created by team members when no other Notebook should obviously be used.",
			Category -> "Organizational Information"
		},
		DefaultMailingAddress -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Site],
			Description -> "The default physical location of this team where samples may be shipped.",
			Category -> "Organizational Information"
		},
		BillingAddress -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Site],
			Description -> "The default address to use for billing.",
			Category -> "Organizational Information"
		},
		Sites -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Site][Teams],
			Description -> "Any physical locations of this team where samples may be shipped.",
			Category -> "Organizational Information"
		},
		ExperimentSites -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Site][FinancingTeams],
			Description -> "The experimental facilities where this team can perform experiments.",
			Category -> "Organizational Information",
			AdminWriteOnly -> True
		},
		DefaultExperimentSite->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container,Site],
			Description->"The physical location where experiments created by the members of this financing team will be run by default.",
			Category->"Organizational Information",
			Abstract->True
		},

		NextBillingCycle -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The upcoming date on which this team will receive a bill for their use of the Emerald Cloud Lab's services.",
			Category -> "Organizational Information",
			AdminWriteOnly->True
		},
		BillingCycleLog -> {
			Format -> Multiple,
			Class -> {Date, Real},
			Pattern :> {_?DateObjectQ,CurrencyP},
			Units -> {None,USD},
			Description -> "The history of billing statements issued to this team for use of the Emerald Cloud Lab's services.",
			Headers -> {"Date of Bill","Amount Due"},
			Category -> "Organizational Information",
			AdminWriteOnly->True
		},

		(*Billing fields*)
		BillingHistory -> {
			Format -> Multiple,
			Headers -> {"Billing End","Bill","Price Scheme","Site"},
			Class -> {Expression, Link, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link, _Link},
			Relation -> {Null, Object[Bill][Organization], Model[Pricing], Object[Container, Site]},
			Description -> "A summary of past bills and their pricing methods.",
			Category -> "Pricing Information",
			AdminWriteOnly->True
		},
		CurrentBills -> {
			Format -> Multiple,
			Headers -> {"Bill","Site"},
			Class -> {Link, Link},
			Pattern :> { _Link, _Link},
			Relation -> {Object[Bill], Object[Container, Site]},
			Description -> "The current bills accumulating charges for the cycle.",
			Category -> "Organizational Information",
			AdminWriteOnly->True
		},
		CurrentPriceSchemes -> {
			Format -> Multiple,
			Headers -> {"Price Scheme","Site"},
			Class -> {Link, Link},
			Pattern :> {_Link, _Link},
			Relation -> {Model[Pricing], Object[Container, Site]},
			Description -> "The pricing schemes followed for the forthcoming bills.",
			Category -> "Organizational Information",
			AdminWriteOnly->True
		},
		ConstellationUsageLog -> {
			Format -> Multiple,
			Headers -> {"Date","Number of Objects"},
			Class -> {Date, Real},
			Pattern :> {_?DateObjectQ, GreaterEqualP[0, 1.]},
			Units -> {None, None},
			Description -> "A historical accounting of the amount of data stored in the ECL Constellation database for this account.",
			Category -> "Organizational Information",
			AdminWriteOnly->True
		},

		(* Manifold Computations *)
		ComputationQueue -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Notebook, Computation][ComputationFinancingTeam],
			Description -> "The team's computations in the priority order that they should be executed as soon as open computational threads become available.",
			Category -> "Computations"
		},
		RunningComputations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Notebook, Computation][ComputationFinancingTeam],
			Description -> "All computations owned by this team which are currently being executed. The length of this field is the number of computational threads in use.",
			Category -> "Computations"
		},
		FailedComputations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Notebook, Computation][ComputationFinancingTeam],
			Description -> "All computations owned by this team which errored out while staging or running and are awaiting cleanup.",
			Category -> "Computations"
		},
		MaxComputationThreads -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0,1],
			Units -> None,
			Description -> "The total number of simulatenous computations this team can run at any given time. Any computations exceeding this number will wait in the computation queue until an open computational thread is available on this team's account.",
			Category -> "Computations",
			AdminWriteOnly -> True
		},
		ManifoldJobs -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Notebook, Job][ComputationFinancingTeam],
			Description -> "A list of Manifold jobs owned and financed by this team.",
			Category -> "Computations"
		}
	}
}]
