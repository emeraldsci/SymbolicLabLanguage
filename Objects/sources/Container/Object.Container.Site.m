(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Container, Site], {
	Description -> "A ECL location or ECL user location.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(* Organizational Information *)
		Teams -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Team, Financing][Sites],
			Description -> "The teams located at this site.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		FinancingTeams -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Team, Financing][ExperimentSites],
			Description -> "The teams allowed to run experiments at this physical location.",
			Category -> "Organizational Information",
			Abstract -> True,
			AdminWriteOnly->True
		},
		CompanyName -> {
			Format -> Single,
			Class -> String,
			Pattern :> CompanyNameP,
			Description -> "The name of the company to which packages should be shipped.",
			Category -> "Organizational Information",
			Abstract->True
		},
		AttentionName -> {
			Format -> Single,
			Class -> String,
			Pattern :> AttentionNameP,
			Description -> "The name of the individual to whom packages should be directed.",
			Category -> "Organizational Information",
			Abstract->True
		},
		StreetAddress-> {
			Format -> Single,
			Class -> String,
			Pattern :> StreetAddressP,
			Description -> "The street address of where samples should be shipped to this site (just the local road and street number, and any unit numbers only).",
			Category -> "Organizational Information",
			Abstract -> True
		},
		StreetAddress2 -> {
			Format -> Single,
			Class -> String,
			Pattern :> StreetAddressP,
			Description -> "An optional second line for the street address where samples should be shipped to this site.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		City-> {
			Format -> Single,
			Class -> String,
			Pattern :> CityP,
			Description ->"The city where this site is located for shipping purposes.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		State-> {
			Format -> Single,
			Class -> String,
			Pattern :> UnitedStateAbbreviationP|AustralianStatesP|MalaysianStatesP,
			Description -> "The state in which this site is located for shipping purposes.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Province-> {
			Format -> Single,
			Class -> String,
			Pattern :> CanadianProvincesP,
			Description -> "The province in which this site is located for shipping purposes.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Locality-> {
			Format -> Single,
			Class -> String,
			Pattern :> LocalityP,
			Description -> "The locality in which this site is located for shipping purposes.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		County-> {
			Format -> Single,
			Class -> String,
			Pattern :> CountyP,
			Description -> "The county in which this site is located for shipping purposes.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		PostalCode-> {
			Format -> Single,
			Class -> String,
			Pattern :> PostalCodeP,
			Description -> "The postal code of this site for shipping purposes.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		PhoneNumber -> {
			Format -> Single,
			Class -> String,
			Pattern :> PhoneNumberP,
			Description -> "A phone number at which a contact at this site can be reached.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Country -> {
			Format -> Single,
			Class -> String,
			Pattern :> CountryP,
			Description ->"The country where this site is located for shipping purposes.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		EmeraldFacility->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this is an ECL operated facility.",
			Category -> "Organizational Information",
			Abstract->True
		},
		PublicPath->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The internet protocol address and path used to access the public cloud folder for this site.",
			Category -> "Organizational Information",
			Abstract->False,
			Developer->True
		},
		PDUScheduler->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The internet protocol address responsible for controlling the power distribution units for this site.",
			Category -> "Organizational Information",
			Abstract->False,
			Developer->True
		},
		NetworkDomain->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The internet protocol name appended to the end of a fully qualified domain name (FQDN) to fully describe the network address of a device using human-friendly names.",
			Category -> "Organizational Information",
			Abstract->False,
			Developer->True
		},
		(* Inventory *)
		WastePrices ->{
			Format -> Multiple,
			Class -> {Expression, Real},
			Pattern :> {WasteTypeP,GreaterEqualP[0 USD/Kilogram]},
			Description -> "The pricing rate the ECL charges for disposing of the chemical waste users generate in the course of running experiments.",
			Units -> {None, USD/Kilogram},
			Headers -> {"Waste Type", "Cost/Weight"},
			Category -> "Inventory",
			Developer->True
		},
		ReceivingContainer->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The room or building into which this order will be received.",
			Category -> "Inventory"
		},
		PackageShelves -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "Shelves in which non-SLL or personal items should be stored when recieved.",
			Category -> "Inventory"
		},
		DryingShelves -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "Shelves on which operators are instructed to place items out to dry after the items are cleaned.",
			Category -> "Inventory"
		},
		(* Shipping Information *)
		RepresentativeDestinations -> {
			Format -> Multiple,
			Class -> {PostalCodeRegion->String,StreetAddress->String,City->String,State->String,PostalCode->String},
			Pattern :> {PostalCodeRegion->Patterns`Private`postalCodeRegionP,StreetAddress->StreetAddressP,City->CityP,State->InternationalStateP,PostalCode->PostalCodeP},
			Description -> "Addresses from within a particular postal code region to consider as destinations for shipments originating from this site for the purposes of shipment price estimation.",
			Headers->{PostalCodeRegion->"Represented Postal Code Region",StreetAddress->"Street Address",City->"City",State->"State",PostalCode->"PostalCode"},
			Category -> "Shipping Information",
			Developer -> True
		},
		(* -- Operations Information -- *)
		OperationsMetrics -> {
			Format -> Single,
			Class -> {
				HistoricalQueue -> Link,
				CurrentQueue -> Link,
				HistoricalCompletion -> Link,
				CurrentCompletion -> Link
			},
			Pattern :> {
				HistoricalQueue -> _Link,
				CurrentQueue -> _Link,
				HistoricalCompletion -> _Link,
				CurrentCompletion -> _Link
			},
			Relation -> {
				HistoricalQueue -> Object[EmeraldCloudFile],
				CurrentQueue -> Object[EmeraldCloudFile],
				HistoricalCompletion -> Object[EmeraldCloudFile],
				CurrentCompletion -> Object[EmeraldCloudFile]
			},
			Description -> "The laboratory operations metrics with respect to protocol execution for this site.",
			Category -> "Operations Information"
		},
		SpecificRecertificationLearning-> {
			Format -> Multiple,
			Class -> {
				StartDate -> Date,
				EndDate -> Date,
				Quizzes -> Expression,
				Practicals -> Expression
			},
			Pattern :> {
				StartDate -> _?DateObjectQ,
				EndDate -> _?DateObjectQ,
				Quizzes -> {ObjectP[]...},
				Practicals -> {ObjectP[]...}
			},
			Description -> "Training modules which should be re-enqueued during the given time periods, as quiz-only or with practicals, in order to give operators on-demand.",
			Category -> "Operations Information"
		},
		RecertificationCompletionTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Day, 1 Day],
			Units->Minute,
			Description->"The length of time given to complete a recertification training module after it has been enqueued, after which training must be completed before any certifications including the module will be invalidated.",
			Category -> "Operations Information"
		},
		ShiftSchedule ->{
			Format -> Multiple,
			Class -> {Expression, Expression, Expression, Expression, Expression},
			Pattern :> {ShiftNameP,ShiftTimeP,DayNameP,_?TimeObjectQ,_?TimeObjectQ},
			Description -> "The days and times worked by operators on all distinct shifts at this facility.",
			Headers -> {"Shift Name","Shift Time","Day","Start Time", "End Time"},
			Category -> "Operations Information",
			Developer->True
		},
		Governor -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Description -> "The multiplier applied to the smallest upcoming shift in a given time frame to determine the maximum number of allowed processing protocols.",
			Category -> "Organizational Information",
			Developer -> True
		},
		GovernorTimeFrame -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Hour,
			Description -> "The number of days to look ahead when determining the smallest shift to consider when enforcing the maximum number of allowed processing protocols.",
			Category -> "Organizational Information",
			Developer -> True
		},
		GovernorPerformanceLog -> {
			Format -> Multiple,
			Class -> {
				DateUpdated -> Date,
				Governor -> Real,
				GovernorTimeFrame -> Real,
				UpdatedBy -> Link,
				AverageOperatorStartTime -> Real,
				AverageOperatorReadyTime -> Real,
				ProtocolStatusTimes -> Expression
			},
			Pattern :> {
				DateUpdated -> _?DateObjectQ,
				Governor -> GreaterP[0],
				GovernorTimeFrame -> GreaterP[0 Minute],
				UpdatedBy -> _Link,
				AverageOperatorStartTime -> TimeP,
				AverageOperatorReadyTime -> TimeP,
				ProtocolStatusTimes -> _Association
			},
			Relation -> {
				DateUpdated -> Null,
				Governor ->Null,
				GovernorTimeFrame ->Null,
				UpdatedBy -> Object[User,Emerald],
				AverageOperatorStartTime ->Null,
				AverageOperatorReadyTime ->Null,
				ProtocolStatusTimes ->Null
			},
			Units -> {
				DateUpdated -> None,
				Governor -> None,
				GovernorTimeFrame -> Hour,
				UpdatedBy -> None,
				AverageOperatorStartTime -> Hour,
				AverageOperatorReadyTime -> Hour,
				ProtocolStatusTimes -> Hour
			},
			Description -> "The protocol wait times with the given governor settings, recorded each time governor parameters are modified.",
			Category -> "Organizational Information",
			Developer -> True
		},
		TimeZoneEntity -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The geographical time-zone entity within which the site resides.",
			Category -> "Organizational Information"
		},
		SensornetLogs-> {
			Format -> Multiple,
			Class -> {
				Name -> String,
				Frequency -> Real,
				FileName -> String
			},
			Pattern :> {
				Name -> SensorLogTypeP,
				Frequency -> GreaterEqualP[0 Second],
				FileName -> _String
			},
			Units -> {
				Name -> None,
				Frequency -> Second,
				FileName -> None
			},
			Description -> "The log files which will contain periodically queried sensor readings.",
			Category -> "Organizational Information",
			Developer -> True
		},
		SensornetLogsDirectory -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The relative filepath to the directory containing current Sensornet logs from the appropriate public path.",
			Category -> "Organizational Information",
			Developer -> True
		},
		SensornetLogsArchiveDirectory -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The relative filepath to the directory containing archived Sensornet logs from the appropriate public path.",
			Category -> "Organizational Information",
			Developer -> True
		},
		NitrogenPressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "The sensor recording the delivered pressure of gas to the house Nitrogen line.",
			Category -> "Sensor Information"
		},
		ArgonPressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "The sensor recording the delivered pressure of gas to the house Argon line.",
			Category -> "Sensor Information"
		},
		CarbonDioxidePressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "The sensor recording the delivered pressure of gas to the house CO2 line.",
			Category -> "Sensor Information"
		},
		NitrogenPressure -> {
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*PSI],
			Units->PSI,
			Description -> "The target delivered pressure of gas to the house Nitrogen line.",
			Category -> "Sensor Information"
		},
		ArgonPressure -> {
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*PSI],
			Units->PSI,
			Description -> "The target delivered pressure of gas to the house Argon line.",
			Category -> "Sensor Information"
		},
		CarbonDioxidePressure -> {
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*PSI],
			Units->PSI,
			Description -> "The target delivered pressure of gas to the house CO2 line.",
			Category -> "Sensor Information"
		},
		ProcessingQualificationLimit -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Description -> "The maximum number of processing qualifications allowed in the queue when enqueuing new protocols via Autorun.",
			Category -> "Organizational Information",
			Developer -> True
		},
		AvailableExperiments->{
			Format->Multiple,
			Class -> Expression,
			Pattern :> ExperimentFunctionP,
			Description -> "A list of experiment functions supported by this site's equipment configuration.",
			Category->"Organizational Information"
		}
	}
}];
