(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Timesheet], {
	Description->"A record of the hours worked for a given day. Each operator will have one timesheet created for them each day. If they aren't scheduled to work their schedule shift dates will be Null and the status will immediately get set to completed.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Operator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> LinkP[],
			Relation -> Object[User,Emerald],
			Description -> "The operator working during this timesheet.",
			Category -> "Organizational Information"
		},
		TimesheetDay -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _DateObject,
			Description -> "The day recorded by this timesheet. For night shifts, this will be the day at shift start.",
			Category -> "Organizational Information"
		},
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> TimesheetStatusP,
			Description -> "Current status of the timesheet (whether its recording is complete or incomplete).",
			Category -> "Organizational Information"
		},
		ShiftTime -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ShiftTimeP,
			Description -> "The hours that the operator is scheduled to work on a regular basis - options include Morning, Night, Swing. Occasionally operators may be asked to work off of their regular shift schedule when taking overtime or rebalancing shift headcounts.",
			Category -> "Organizational Information"
		},
		ShiftName -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ShiftNameP,
			Description -> "The team name given to a collection of operators who are scheduled together to work on a given set of days. Options include Alpha and Bravo.",
			Category -> "Organizational Information"
		},
		ScheduledShiftStart -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _DateObject,
			Description -> "The intended start time for the shift represented in this timesheet.",
			Category -> "Organizational Information"
		},
		ScheduledShiftEnd -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _DateObject,
			Description -> "The intended end time for the shift represented in this timesheet.",
			Category -> "Organizational Information"
		},
		ClockInDate -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _DateObject,
			Description -> "The actual start time for the shift represented in this timesheet (ie: when the operator clocked in).",
			Category -> "Organizational Information"
		},
		ClockOutDate -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _DateObject,
			Description -> "The actual end time for the shift represented in this timesheet (ie: when the operator clocked out).",
			Category -> "Organizational Information"
		},
		LateClockIn -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> TimesheetDiscrepancyTypeP,
			Description -> "If the operator clocked in late, the type of late clock in (excused or unexcused).",
			Category -> "Organizational Information"
		},
		Absense -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> TimesheetDiscrepancyTypeP,
			Description -> "If the operator never clocked in, the type of absense (excused or unexcused).",
			Category -> "Organizational Information"
		},
		EarlyClockOut -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> TimesheetDiscrepancyTypeP,
			Description -> "If the operator clocked out early, the type of early clock out (excused or unexcused).",
			Category -> "Organizational Information"
		},
		LateClockOut -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> TimesheetDiscrepancyTypeP,
			Description -> "If the operator clocked out late, the type of late clock out (excused or unexcused).",
			Category -> "Organizational Information"
		},
		BreakLog -> {
			Format -> Multiple,
			Class -> {Date, Date, Expression},
			Pattern :> {_DateObject, _DateObject, BreakTypeP},
			Relation -> {Null, Null, Null},
			Description -> "A log of breaks taken during this shift.",
			Headers -> {"Start Date", "End Date", "Break Type"},
			Category -> "Organizational Information"
		},
		DeputyTimesheetID -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> _Integer,
			Description -> "The identifier used in Deputy for this timesheet.",
			Category -> "Organizational Information",
			Developer -> True
		},
		DeputyShiftID -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> _Integer,
			Description -> "The identifier used in Deputy for the scheduled shift associated with this timesheet.",
			Category -> "Organizational Information",
			Developer -> True
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True,
			AdminWriteOnly -> True
		}
	}
}];