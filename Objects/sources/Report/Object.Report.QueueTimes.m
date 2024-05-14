(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Report, QueueTimes], {
	Description->"A nightly report of the average queue time for each protocol type, based on data from recently executed protocols. This information is then used to forecast queue times for future protocols.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		QueueInterval -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[1 Day],
			Units -> Day,
			Description -> "The intervening time period up to the DateCreated during which ProtocolQueueTimes is calculated.",
			Category -> "Queue Information"
		},
		ProtocolQueueTimes -> {
			Format -> Multiple,
			Class -> {Expression, Real},
			Pattern :> {TypeP[{Object[Protocol],Object[Maintenance],Object[Qualification]}], GreaterP[0 Hour]},
			Relation -> {Null, Null},
			Units -> {None, Hour},
			Description -> "A list of protocol types and and the average amount of time a protocol of that type spends in the ECL queue before being executed.",
			Category -> "Queue Information",
			Headers -> {"Protocol Type","Queue Time"}
		},
		AverageQueueTime  -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Hour],
			Units -> Hour,
			Description -> "Average amount of time a protocol (across all protocol/maintenance/Qualification types) spends in the ECL queue before being executed.",
			Category -> "Queue Information"
		},
		MinQueueTime  -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Hour],
			Units -> Hour,
			Description -> "Average queue time of the 5 protocols (across all protocol types) that spent the least time in the ECL queue before being executed.",
			Category -> "Queue Information"
		}
	}
}];
