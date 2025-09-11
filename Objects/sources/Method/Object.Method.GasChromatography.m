

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Method, GasChromatography], {
	Description->"A method containing all required inlet, column, and oven setpoints to run a GC experiment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* Hardware specs *)
		(* Column *)
		ColumnLength->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*Meter],
			Units->Meter,
			Relation->Null,
			Description->"The length(s) of the column(s), in order of installation, for which this separation method was designed.",
			Category->"Instrument Specifications"
		},
		ColumnDiameter->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*Milli*Meter],
			Units->Milli*Meter,
			Relation->Null,
			Description->"The diameter(s) of the column(s), in order of installation, for which this separation method was designed.",
			Category->"Instrument Specifications"
		},
		ColumnFilmThickness->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*Micro*Meter],
			Units->Micro*Meter,
			Relation->Null,
			Description->"The film thickness(es) of the column(s), in order of installation, for which this separation method was designed.",
			Category->"Instrument Specifications"
		},
		(* Liner *)
		InletLinerVolume->{ (* TODO: INLETLINERVOLUME *)
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Micro*Liter],
			Units->Micro*Liter,
			Relation->Null,
			Description->"The volume of the inlet liner for which this separation method was designed.",
			Category->"Instrument Specifications"
		},
		(* Detector *)
		Detector->{
			Format->Single,
			Class->Expression,
			Pattern:>GCDetectorP,
			Relation->Null,
			Description->"The detector used with this GC method.",
			Category->"Instrument Specifications"
		},
		(* Carrier gas *)
		CarrierGas->{
			Format->Single,
			Class->Expression,
			Pattern:>GCCarrierGasP,
			Relation->Null,
			Description->"The carrier gas used to separate analytes on the column during this GC method.",
			Category->"Instrument Specifications"
		},
		(* Inlet method *)
		(* septum purge *)
		InletSeptumPurgeFlowRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Milli*Liter/Minute],
			Relation->Null,
			Units->Milli*Liter/Minute,
			Description -> "The flow rate of carrier gas that will be passed through the inlet septum purge valve, which will continuously flush the volume inside the inlet between the inlet septum and the inlet liner.",
			Category -> "General"
		},
		(* inlet temperature soon to be rolled into only 2 fields *)
		InitialInletTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Relation->Null,
			Units->Celsius,
			Description -> "The desired inlet temperature when the InletTemperatureMode is Isothermal, or the temperature at which the InletTemperatureProfile will begin if the InletTemperature is TemperatureProfile.",
			Category -> "General"
		},
		InitialInletTemperatureDuration->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Minute],
			Relation->Null,
			Units->Minute,
			Description -> "The amount of time into the separation to hold the Inlet at its InitialInletTemperature before starting the InletTemperatureProfile.",
			Category -> "General"
		},
		InletTemperatureProfile->{
			Format->Multiple,
			Class->Expression,
			Pattern:>Alternatives[
				{{GreaterEqualP[0*Minute],GreaterP[0*Kelvin]}..},
				{{GreaterP[0*Kelvin/Minute],GreaterP[0*Kelvin],GreaterEqualP[0*Minute]}..},
				GreaterP[0*Kelvin],
				Isothermal
			],
			Relation->Null,
			Description -> "The ramp rate, temperature set point, and set point hold time that will be applied to the inlet during sample separation in the column.",
			Category -> "General"
		},
		(* inlet behavior *)
		SplitRatio->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0],
			Relation->Null,
			Units->None,
			Description -> "The ratio of flow rate out of the inlet vaporization chamber that passes into the inlet split vent to the flow rate out of the inlet vaporization chamber that passes into the capillary column.",
			Category -> "General"
		},
		SplitVentFlowRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[Milli*Liter/Minute],
			Relation->Null,
			Units->Milli*Liter/Minute,
			Description -> "The desired flow rate through the inlet that will exit the inlet through the inlet split vent during sample injection.",
			Category -> "General"
		},
		SplitlessTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Minute],
			Relation->Null,
			Units->Minute,
			Description -> "The amount of time the split valve will remain closed after injecting the sample into the inlet.",
			Category -> "General"
		},
		InitialInletPressure->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*PSI],
			Relation->Null,
			Units->PSI,
			Description -> "The pressure at which the inlet will be held for the duration of the InitialInletTime, beginning at sample injection.",
			Category -> "General"
		},
		InitialInletTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Minute],
			Relation->Null,
			Units->Minute,
			Description -> "The time after which the column head pressure will be returned from the InitialInletPressure to the column setpoint following a pulsed injection.",
			Category -> "General"
		},
		GasSaver->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Relation->Null,
			Description -> "Indicates whether the gas saver will be used during the experiment. The gas saver reduces flow through the split vent during sample separation, reducing Helium consumption.",
			Category -> "General"
		},
		GasSaverFlowRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[Milli*Liter/Minute],
			Relation->Null,
			Units->Milli*Liter/Minute,
			Description -> "The desired gas flow rate that the total inlet flow will be reduced to when the gas saver is activated.",
			Category -> "General"
		},
		GasSaverActivationTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Minute],
			Relation->Null,
			Units->Minute,
			Description -> "The amount of time after the beginning of each run that the gas saver will be activated.",
			Category -> "General"
		},
		SolventEliminationFlowRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[Milli*Liter/Minute],
			Relation->Null,
			Units->Milli*Liter/Minute,
			Description -> "The flow rate of carrier gas that will be passed through the inlet and out the split vent in an attempt to selectively remove solvent from the inlet during a solvent vented injection.",
			Category -> "General"
		},
		InitialColumnFlowRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Milli*Liter/Minute],
			Relation->Null,
			Units->Milli*Liter/Minute,
			Description -> "The initial column flowrate set point during the column method.",
			Category -> "General"
		},
		InitialColumnPressure->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*PSI],
			Relation->Null,
			Units->PSI,Description -> "The initial column pressure set point during the column method.",
			Category -> "General"
		},
		InitialColumnAverageVelocity->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Centi*Meter/Second],
			Relation->Null,
			Units->Centi*Meter/Second,Description -> "The initial column average linear velocity set point during the column method.",
			Category -> "General"
		},
		InitialColumnResidenceTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Minute],
			Relation->Null,
			Units->Minute,Description -> "The initial column holdup time set point during the column method.",
			Category -> "General"
		},
		InitialColumnSetpointDuration->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Minute],
			Relation->Null,
			Units->Minute,Description -> "The amount of time into the method to hold the column at its initial pressure or flow rate before starting a pressure or flow rate profile.",
			Category -> "General"
		},
		ColumnPressureProfile->{
			Format->Single,
			Class->Expression,
			Pattern:>Alternatives[
				{{GreaterEqualP[0*Minute],GreaterP[0*PSI]}..},
				{{GreaterP[0*PSI/Minute],GreaterP[0*PSI],GreaterEqualP[0*Minute]}..},
				GreaterP[0*PSI],
				ConstantPressure
			],
			Relation->Null,
			Description -> "The column head pressure profile that will be set during the column method.",
			Category -> "General"
		},
		ColumnFlowRateProfile->{
			Format->Single,
			Class->Expression,
			Pattern:>Alternatives[
				{{GreaterEqualP[0*Minute],GreaterP[0*Milli*Liter/Minute]}..},
				{{GreaterP[0*Milli*Liter/Minute/Minute],GreaterP[0*Milli*Liter/Minute],GreaterEqualP[0*Minute]}..},
				GreaterP[0*Milli*Liter/Minute],
				ConstantFlowRate
			],
			Relation->Null,
			Description -> "The column flow rate profile that will be set during the column method.",
			Category -> "General"
		},
		(* Column oven method *)
		OvenEquilibrationTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Minute],
			Relation->Null,
			Units->Minute,
			Description -> "The amount of time the column oven was allowed to equilibrate before a separation is started.",
			Category -> "General"
		},
		InitialOvenTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Relation->Null,
			Units->Celsius,
			Description -> "The desired column oven temperature setpoint prior to the column oven temperature Profile.",
			Category -> "General"
		},
		InitialOvenTemperatureDuration->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Minute],
			Relation->Null,
			Units->Minute,
			Description -> "The amount of time into the separation to hold the column oven at its OvenInitialTemperature before starting the column oven temperature Profile.",
			Category -> "General"
		},
		OvenTemperatureProfile->{
			Format->Single,
			Class->Expression,
			Pattern:>Alternatives[
				{{GreaterEqualP[0*Minute],GreaterP[0*Kelvin]}..},
				{{GreaterEqualP[0*Kelvin/Minute],GreaterP[0*Kelvin],GreaterEqualP[0*Minute]}..},
				{GreaterP[0*Kelvin],GreaterP[0*Minute]},
				Isothermal
			],
			Relation->Null,
			Description -> "The temperature profile that will be used in the column oven during the sample analysis.",
			Category -> "General"
		},
		PostRunOvenTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Relation->Null,
			Units->Celsius,
			Description -> "The temperature setpoint after the end of the column oven temperature profile.",
			Category -> "General"
		},
		PostRunOvenTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Minute],
			Relation->Null,
			Units->Minute,
			Description -> "The time the PostRunOvenTemperature setpoint after the end of the column oven temperature profile will be maintained.",
			Category -> "General"
		},
		PostRunFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter/Minute],
			Units -> Milliliter/Minute,
			Relation -> Null,
			Description -> "The flow rate that will be flowed through the column once the separation is completed.",
			Category -> "General"
		},
		PostRunPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 PSI],
			Units -> PSI,
			Relation -> Null,
			Description -> "The pressure that will be applied to the column once the separation is completed.",
			Category -> "General"
		}

		(* --- Computed fields TODO: ADD SYMBOLS TO MANIFEST --- *)
		(*
		MethodDuration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> TimeP,
			Units -> Minute,
			Description -> "The length of the separation method, which is set to the length of the ColumnOvenTemperatureProfile.",
			Category -> "General"
		},
		MMIStartTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature at the beginning of the ColumnOvenTemperatureProfile.",
			Category -> "General"
		},
		MMIEndTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature at the end of the MMITemperatureProfile.",
			Category -> "General"
		},
		ColumnStartPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature at the beginning of the temperature program.",
			Category -> "General"
		},
		ColumnEndPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature at the end of the temperature program.",
			Category -> "General"
		},
		ColumnStartFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature at the beginning of the temperature program.",
			Category -> "General"
		},
		ColumnEndFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature at the end of the temperature program.",
			Category -> "General"
		},
		ColumnOvenStartTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature at the beginning of the MMITemperatureProfile.",
			Category -> "General"
		},
		ColumnOvenEndTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature at the end of the ColumnOvenTemperatureProfile.",
			Category -> "General"
		}*)
		(* --- End computed --- *)
	}
}];
