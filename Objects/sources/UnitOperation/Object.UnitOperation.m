DefineObjectType[Object[UnitOperation],{
	Description->"A detailed set of parameters that specifies a single step in a larger protocol in the laboratory.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(* --- Organizational Information --- *)
		Protocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol, ManualSamplePreparation][InputUnitOperations],
				Object[Protocol, ManualSamplePreparation][OptimizedUnitOperations],
				Object[Protocol, ManualSamplePreparation][CalculatedUnitOperations],
				Object[Protocol, ManualSamplePreparation][OutputUnitOperations],
				Object[Protocol, RoboticSamplePreparation][InputUnitOperations],
				Object[Protocol, RoboticSamplePreparation][OptimizedUnitOperations],
				Object[Protocol, RoboticSamplePreparation][CalculatedUnitOperations],
				Object[Protocol, RoboticSamplePreparation][OutputUnitOperations],
				Object[Protocol, ManualCellPreparation][InputUnitOperations],
				Object[Protocol, ManualCellPreparation][OptimizedUnitOperations],
				Object[Protocol, ManualCellPreparation][CalculatedUnitOperations],
				Object[Protocol, ManualCellPreparation][OutputUnitOperations],
				Object[Protocol, RoboticCellPreparation][InputUnitOperations],
				Object[Protocol, RoboticCellPreparation][OptimizedUnitOperations],
				Object[Protocol, RoboticCellPreparation][CalculatedUnitOperations],
				Object[Protocol, RoboticCellPreparation][OutputUnitOperations],
				Object[Protocol][BatchedUnitOperations]
			],
			Description -> "The sample or cell preparation protocol that will direct the execution of this unit operation in the laboratory, along with other unit operations specified in the preparation protocol.",
			Category -> "General"
		},
		Subprotocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol]
			],
			Description -> "The protocol that was executed to perform this unit operation in the lab if Preparation->Manual.",
			Category -> "General",
			Developer -> True
		},
		Preparation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PreparationMethodP,
			Description -> "Indicates if this unit operation is carried out primarily robotically or manually. Manual unit operations are executed by a laboratory operator and robotic unit operations are executed by a liquid handling work cell.",
			Category -> "General"
		},
		WorkCell -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WorkCellP,
			Description -> "Indicates the work cell that this primitive will be run on if Preparation->Robotic.",
			Category -> "General"
		},
		UnitOperationType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> UnitOperationTypeP,
			Description -> "The type of this unit operation. Input Unit Operations contain the direct options specified by the user when calling ExperimentSample/CellPreparation. Optimized Unit Operations are functionally equivalent to the Input Unit Operations, but are rearranged and combined for optimized execution in the laboratory. Calculated Unit Operations are based off of the Optimized Unit Operations and contain the fully calculated set of options for laboratory execution. Output Unit Operations are based on the Calculated Unit Operations and contain additional experimental results (data objects etc). Batched Unit Operations contain the information necessary to process a single batch in a standalone manual protocol (ex. a Transfer protocol).",
			Category -> "General"
		},
		DateStarted -> { (* NOTE: VOQ that this field can only be set if UnitOperationType\[Rule]Output *)
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date at which this unit operation started to be executed in the lab..",
			Category -> "General"
		},
		DateCompleted -> { (* NOTE: VOQ that this field can only be set if UnitOperationType\[Rule]Output *)
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date at which this unit operation's execution was finished.",
			Category -> "General"
		},
		LabeledObjects -> {
			Format -> Multiple,
			Class -> {String,Link},
			Pattern :> {_String,_Link},
			Relation -> {
				Null,
				Alternatives[
					Model[Sample],
					Object[Sample],
					Model[Container],
					Object[Container],
					Model[Item],
					Object[Item],
					Model[Part],
					Object[Part],
					Model[Plumbing],
					Object[Plumbing]
				]
			},
			Description -> "Relates a LabelSample/LabelContainer's label to the sample or container which fulfilled the label during execution.",
			Category -> "General",
			Headers -> {"Label","Object"}
		},
		FutureLabeledObjects -> {
			Format -> Multiple,
			Class -> Expression,
			(* futureLabel_String -> Alternatives[{existingLabel_String, relationToFutureLabel:(Container|LocationPositionP)}, labelField_LabelField] *)
			Pattern :> (_String -> Alternatives[{_String, Container|LocationPositionP}, _LabelField]),
			Relation -> Null,
			Units -> None,
			Description -> "LabeledObjects will not exist until the protocol has finished running in the lab (created at parse time). For example, destination samples that are given labels are only created by Transfer's parser and therefore can only be added to the LabeledObjects field after parse time.",
			Category -> "General",
			Developer -> True
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "General",
			Developer -> True
		},
		RequiredResources -> {
			Format -> Multiple,
			Class -> {Link, Expression, Integer, Expression},
			Pattern :> {_Link, _Symbol, _Integer, _Integer|_Symbol},
			Relation -> {Object[Resource][Requestor], Null, Null, Null},
			Units -> {None, None, None, None},
			Headers->{"Resource","Field Name","Field Position", "Field Index"},
			Description -> "All resources which will be used by this program and the field, ordinal, and index in this program to which they refer.",
			Category -> "Resources",
			Developer -> True
		},
		PreparedSamples -> {
			Format -> Multiple,
			Class -> {String, Expression, Integer, Expression, String},
			Pattern :> {_String, _Symbol, _Integer, _Integer|_Symbol,_String},
			Relation -> {Null, Null, Null, Null, Null},
			Units -> {None, None, None, None, None},
			Description -> "Prepared Samples that are used in this protocol and a description of the field in which a prepared sample's resolved object is stored. Position and index are Null when a prepared sample's resolution is stored in a single field.",
			Category -> "General",
			Headers->{"Label","Field Name","Field Position", "Field Index", "Container Position"},
			Developer -> True
		},
		EnvironmentalData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "Measurements of environmental conditions (temperature and humidity) recorded during the execution of this unit operation.",
			Category -> "Experimental Results"
		},
		Data -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "Any primary data generated by this unit operation.",
			Category -> "Experimental Results"
		},
		Incubate -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[BooleanP|Null],
			Description -> "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment.",
			Category -> "Preparatory Incubation"
		},
		Thaw -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[BooleanP|Null],
			Description -> "Indicates if any frozen SamplesIn should be incubated until visibly liquid prior to starting the experiment.",
			Category -> "Preparatory Incubation"
		},
		IncubationTemperatureReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment.",
			Category -> "Preparatory Incubation",
			Migration -> SplitField
		},
		IncubationTemperatureExpression -> {
			Format -> Multiple, 
			Class -> Expression,
			Pattern :> ListableP[Ambient|Null|GreaterEqualP[0 Kelvin]],
			Description -> "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment.",
			Category -> "Preparatory Incubation",
			Migration -> SplitField
		},
		IncubationTime -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[Alternatives[GreaterEqualP[0 Second],Null]],
			Description -> "Duration for which SamplesIn should be incubated at the IncubationTemperature prior to starting the experiment.",
			Category -> "Preparatory Incubation"
		},
		AnnealingTime -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[Alternatives[GreaterEqualP[0 Second],Null]],
			Description -> "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment.",
			Category -> "Preparatory Incubation"
		},
		Mix -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[Alternatives[BooleanP,Null]],
			Description -> "Indicates if this sample should be mixed while incubated, prior to starting the experiment.",
			Category -> "Preparatory Incubation"
		},
		MixType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[Alternatives[MixTypeP,None,Null]],
			Description -> "Indicates the style of motion used to mix the sample, prior to starting the experiment.",
			Category -> "Preparatory Incubation"
		},
		MixUntilDissolved -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[Alternatives[BooleanP,Null]],
			Description -> "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute. Any mixing/incubation will occur prior to starting the experiment.",
			Category -> "Preparatory Incubation"
		},
		MaxIncubationTime -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[Alternatives[GreaterEqualP[0 Second],Null]],
			Description ->"Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. This occurs prior to starting the experiment.",
			Category -> "Preparatory Incubation"
		},
		IncubationInstrument -> {
			Format -> Multiple,
			Class->Expression,
			Pattern:>ListableP[Alternatives[
				ObjectP[{Model[Instrument],Object[Instrument]}],
				Null
			]],
			Description ->"The instrument used to perform the Mix and/or Incubation, prior to starting the experiment.",
			Category -> "Preparatory Incubation"
		},
		IncubateAliquotContainerLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment.",
			Category -> "Preparatory Incubation",
			Migration -> SplitField
		},
		IncubateAliquotContainerExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[{_Integer|_String, ObjectP[{Model[Container], Object[Container]}]}|Null|ObjectP[{Model[Container], Object[Container]}]],
			Relation -> Null,
			Description -> "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment.",
			Category -> "Preparatory Incubation",
			Migration -> SplitField
		},
		IncubateAliquotDestinationWell -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[_String|Null],
			Description ->"The desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed.",
			Category -> "Preparatory Incubation"
		},
		IncubateAliquotReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :>GreaterEqualP[0 Liter],
			Units->Liter,
			Description ->"The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation.",
			Category -> "Preparatory Incubation",
			Migration -> SplitField
		},
		IncubateAliquotExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[Alternatives[All,Null,GreaterEqualP[0 Liter]]],
			Description ->"The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation.",
			Category -> "Preparatory Incubation",
			Migration -> SplitField
		},
		Centrifuge->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[Alternatives[BooleanP,Null]],
			Description ->  "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified).",
			Category -> "Preparatory Centrifugation"
		},
		CentrifugeInstrument->{
			Format -> Multiple,
			Class->Expression,
			Pattern:>ListableP[
				Alternatives[
					ObjectP[{Model[Instrument],Object[Instrument]}],
					Null
				]
			],
			Description ->"The centrifuge that will be used to spin the provided samples prior to starting the experiment.",
			Category -> "Preparatory Centrifugation"
		},
		CentrifugeIntensity->{
			Format -> Multiple,
			Class->Expression,
			Pattern:>ListableP[GreaterP[0 RPM] | GreaterP[0 GravitationalAcceleration] | Null],
			Description -> "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment.",
			Category -> "Preparatory Centrifugation"
		},
		CentrifugeTime->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[Alternatives[GreaterEqualP[0 Second],Null]],
			Description -> "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment.",
			Category -> "Preparatory Centrifugation"
		},
		CentrifugeTemperatureReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment.",
			Category -> "Preparatory Centrifugation",
			Migration -> SplitField
		},
		CentrifugeTemperatureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[Ambient|Null|GreaterEqualP[0 Kelvin]],
			Description -> "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment.",
			Category -> "Preparatory Centrifugation",
			Migration -> SplitField
		},
		CentrifugeAliquotContainerLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment.",
			Category -> "Preparatory Centrifugation",
			Migration->SplitField
		},
		CentrifugeAliquotContainerExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[{_Integer|_String, ObjectP[{Model[Container], Object[Container]}]}|Null|ObjectP[{Model[Container], Object[Container]}]],
			Relation -> Null,
			Description -> "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment.",
			Category -> "Preparatory Centrifugation",
			Migration->SplitField
		},
		CentrifugeAliquotDestinationWell -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[Alternatives[_String,Null]],
			Description ->"The desired position in the corresponding AliquotContainer in which the aliquot samples will be placed.",
			Category -> "Preparatory Centrifugation"
		},
		CentrifugeAliquotReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milliliter],
			Units -> Milliliter,
			Description -> "The amount of a sample that should be transferred from the input samples into aliquots.",
			Category -> "Preparatory Centrifugation",
			Migration->SplitField
		},
		CentrifugeAliquotExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[Alternatives[All,Null,GreaterEqualP[0*Milliliter]]],
			Description -> "The amount of a sample that should be transferred from the input samples into aliquots.",
			Category -> "Preparatory Centrifugation",
			Migration->SplitField
		},

		Filtration -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[Alternatives[BooleanP,Null]],
			Description ->"Indicates if the SamplesIn should be filter prior to starting the experiment or any aliquoting. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified).",
			Category -> "Preparatory Filtering"
		},
		FiltrationType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[Alternatives[FiltrationTypeP,Null]],
			Description ->"The type of filtration method that should be used to perform the filtration.",
			Category -> "Preparatory Filtering"
		},
		FilterInstrument -> {
			Format -> Multiple,
			Class->Expression,
			Pattern:>ListableP[
				Alternatives[
					ObjectP[{Model[Instrument],Object[Instrument]}],
					Null
				]
			],
			Description ->"The instrument that should be used to perform the filtration.",
			Category -> "Preparatory Filtering"
		},
		FilterLink -> {
			Format -> Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Container, Plate, Filter],
				Object[Container, Plate, Filter],
				Model[Container, Vessel, Filter],
				Object[Container, Vessel, Filter],
				Model[Item, Filter],
				Object[Item, Filter],
				Model[Item, ExtractionCartridge],
				Object[Item, ExtractionCartridge]
			],
			Description -> "The filter that should be used to remove impurities from the samples.",
			Category -> "Preparatory Filtering",
			Migration -> SplitField
		},
		FilterString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "The filter that should be used to remove impurities from the samples.",
			Category -> "Preparatory Filtering",
			Migration -> SplitField
		},
		FilterExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[_String|Null|ObjectP[{
				Model[Container, Plate, Filter],
				Object[Container, Plate, Filter],
				Model[Container, Vessel, Filter],
				Object[Container, Vessel, Filter],
				Model[Item, Filter],
				Object[Item, Filter]}
			]],
			Description -> "The filter that should be used to remove impurities from the samples.",
			Category -> "Preparatory Filtering",
			Migration -> SplitField
		},
		FilterMaterial -> {
			Format -> Multiple,
			Class->Expression,
			Pattern :> ListableP[FilterMembraneMaterialP|Null],
			Description -> "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment.",
			Category -> "Preparatory Filtering"
		},
		PrefilterMaterial -> {
			Format -> Multiple,
			Class->Expression,
			Pattern :> ListableP[FilterMembraneMaterialP|Null],
			Description -> "The material from which the prefilter filtration membrane should be made of to remove impurities from the SamplesIn prior to starting the experiment.",
			Category -> "Preparatory Filtering"
		},
		FilterPoreSize -> {
			Format -> Multiple,
			Class->Expression,
			Pattern :> ListableP[FilterSizeP|Null],
			Description ->  "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment.",
			Category -> "Preparatory Filtering"
		},
		PrefilterPoreSize -> {
			Format -> Multiple,
			Class->Expression,
			Pattern :> ListableP[FilterSizeP|Null],
			Description ->  "The pore size of the filter; all particles larger than this should be removed during the filtration.",
			Category -> "Preparatory Filtering"
		},
		FilterSyringe -> {
			Format -> Multiple,
			Class->Expression,
			Pattern:>ListableP[Alternatives[
				ObjectP[{Model[Container],Object[Container]}],
				Null
			]],
			Description -> "The syringe used to force that sample through a filter.",
			Category -> "Preparatory Filtering"
		},
		FilterHousingLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument],
				Model[Instrument, FilterBlock],
				Object[Instrument, FilterBlock]
			],
			Description -> "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane.",
			Category -> "Preparatory Filtering",
			Migration->SplitField
		},
		FilterHousingExpression -> {
			Format -> Multiple,
			Class->Expression,
			Pattern:>ListableP[Alternatives[
				ObjectP[{
					Model[Instrument],
					Object[Instrument],
					Model[Instrument, FilterBlock],
					Object[Instrument, FilterBlock]
				}],
				Null
			]],
			Description -> "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane.",
			Category -> "Preparatory Filtering",
			Migration->SplitField
		},
		FilterIntensity -> {
			Format -> Multiple,
			Class->Expression,
			Pattern:>ListableP[GreaterP[0 RPM] | GreaterP[0 GravitationalAcceleration] | Null],
			Description ->"The rotational speed or force at which the samples will be centrifuged during filtration.",
			Category -> "Preparatory Filtering"
		},
		FilterTime -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :>ListableP[GreaterEqualP[0 Minute]|Null],
			Description ->"The amount of time for which the samples will be centrifuged during filtration.",
			Category -> "Preparatory Filtering"
		},
		FilterTemperature -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :>ListableP[GreaterEqualP[0 Celsius]|Null],
			Description ->"The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration.",
			Category -> "Preparatory Filtering"
		},
		FilterContainerOutLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired.",
			Category -> "Preparatory Filtering",
			Migration->SplitField
		},
		FilterContainerOutString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired.",
			Category -> "Preparatory Filtering",
			Migration->SplitField
		},
		FilterContainerOutExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[{_Integer|_String, ObjectP[{Model[Container], Object[Container]}]}|Null|ObjectP[{Model[Container],Object[Container]}]],
			Relation -> Null,
			Description -> "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired.",
			Category -> "Preparatory Filtering",
			Migration->SplitField
		},

		FilterAliquotDestinationWell -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[Alternatives[_String,Null]],
			Description -> "The desired position in the corresponding AliquotContainer in which the aliquot samples will be placed.",
			Category -> "Preparatory Filtering"
		},
		FilterAliquotContainerLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment.",
			Category -> "Preparatory Filtering",
			Migration->SplitField
		},
		FilterAliquotContainerString -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[Alternatives[_String,Null]],
			Relation -> Null,
			Description -> "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment.",
			Category -> "Preparatory Filtering",
			Migration->SplitField
		},
		FilterAliquotContainerExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[{_Integer|_String, ObjectP[{Model[Container], Object[Container]}]}|Null|ObjectP[{Model[Container],Object[Container]}]],
			Relation -> Null,
			Description -> "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment.",
			Category -> "Preparatory Filtering",
			Migration->SplitField
		},
		FilterAliquotReal->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Liter],
			Units -> Liter Milli,
			Description -> "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration.",
			Category -> "Preparatory Filtering",
			Migration -> SplitField
		},
		FilterAliquotExpression->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[Alternatives[All,Null,GreaterP[0*Milli*Liter]]],
			Description -> "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration.",
			Category -> "Preparatory Filtering",
			Migration -> SplitField
		},
		FilterSterile->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[Alternatives[BooleanP,Null]],
			Description -> "Indicates if the filtration of the samples should be done in a sterile environment.",
			Category -> "Preparatory Filtering"
		},

		Aliquot->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[Alternatives[BooleanP,Null]],
			Description -> "Indicates if aliquots are taken from the SamplesIn and transferred into new AliquotSamples which are prepared and used in lieu of the SamplesIn for the manual unit operation.",
			Category -> "Aliquoting",
			Developer -> True
		},
		AliquotSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "Samples corresponding to aliquots of SamplesIn generated during sample preparation and intended for use in this experiment.",
			Category -> "Aliquoting"
		},
		AliquotAmountVariableUnit -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0*Milliliter] | GreaterEqualP[0*Milligram],
			Description -> "The amount of a sample that should be transferred from the input samples into aliquots.",
			Category -> "General",
			Migration->SplitField
		},
		AliquotAmountInteger -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Description -> "The amount of a sample that should be transferred from the input samples into aliquots.",
			Category -> "General",
			Migration->SplitField
		},
		AliquotAmountExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[Alternatives[All,Null,GreaterEqualP[0*Milliliter],GreaterEqualP[0*Milligram],GreaterP[0, 1]]],
			Description -> "The amount of a sample that should be transferred from the input samples into aliquots.",
			Category -> "General",
			Migration->SplitField
		},
		(* Todo: N-Multiples *)
		TargetConcentration -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GreaterEqualP[0 Micromolar] | GreaterEqualP[0 Gram / Liter] | {(GreaterP[0 Molar] | GreaterP[0 Gram / Liter] | Null)..},
			Description -> "The desired final concentration of analyte in the aliquot samples after dilution of aliquots of the input samples with the ConcentratedBuffer and BufferDiluent (or AssayBuffer).",
			Category -> "Aliquoting"
		},
		(* Todo: N-Multiples *)
		TargetConcentrationAnalyte -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ObjectP[IdentityModelTypes] | {(ObjectP[IdentityModelTypes] | Null)..},
			Description -> "For each member of TargetConcentration, the substance whose final concentration is attained with TargetConcentration.",
			Category -> "Aliquoting",
			IndexMatching -> TargetConcentration
		},
		ConcentratedBufferLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample] | Model[Sample],
			Description -> "The concentrated buffer source which is added to each of the AliquotSamples to obtain 1x buffer concentration after dilution of the AliquotSamples which are used in lieu of the SamplesIn for the manual unit operation.",
			Category -> "Aliquoting",
			Migration -> SplitField
		},
		ConcentratedBufferString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "The concentrated buffer which should be diluted by the BufferDilutionFactor in the final solution (i.e., the combination of the sample, ConcentratedBuffer, and BufferDiluent).",
			Category -> "Aliquoting",
			Migration -> SplitField
		},
		ConcentratedBufferExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[_String|Null|ObjectP[{Object[Sample],Model[Sample]}]],
			Description -> "The concentrated buffer which should be diluted by the BufferDilutionFactor in the final solution (i.e., the combination of the sample, ConcentratedBuffer, and BufferDiluent).",
			Category -> "Aliquoting",
			Migration -> SplitField
		},
		BufferDilutionFactor -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[Alternatives[GreaterP[0],Null]],
			Description -> "The dilution factor by which the concentrated buffer is diluted in preparing the AliquotSamples to obtain a 1x buffer concentration after dilution of the AliquotSamples which are used in lieu of the SamplesIn for the manual unit operation.",
			Category -> "Aliquoting"
		},
		BufferDiluentLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample] | Model[Sample],
			Description -> "The diluent used to dilute the concentration of the concentrated buffer in preparing the AliquotSamples which are used in lieu of the SamplesIn for the manual unit operation.",
			Category -> "Aliquoting",
			Migration -> SplitField
		},
		BufferDiluentString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "The buffer used to dilute the aliquot sample such that ConcentratedBuffer is diluted by BufferDilutionFactor in the final solution.",
			Category -> "Aliquoting",
			Migration -> SplitField
		},
		BufferDiluentExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[_String|ObjectP[{Object[Sample],Model[Sample]}]|Null],
			Description -> "The buffer used to dilute the aliquot sample such that ConcentratedBuffer is diluted by BufferDilutionFactor in the final solution.",
			Category -> "Aliquoting",
			Migration -> SplitField
		},
		AssayBufferLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample] | Model[Sample],
			Description -> "The desired buffer for the AliquotSamples which are used in lieu of the SamplesIn for the manual unit operation.",
			Category -> "Aliquoting",
			Migration -> SplitField
		},
		AssayBufferString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "The buffer sample used to dilute the final sample in ContainerOut.",
			Category -> "Aliquoting",
			Migration -> SplitField
		},
		AssayBufferExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[_String|ObjectP[{Object[Sample],Model[Sample]}]|Null],
			Description -> "The buffer sample used to dilute the final sample in ContainerOut.",
			Category -> "Aliquoting",
			Migration -> SplitField
		},
		AliquotSampleStorageCondition -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[SampleStorageTypeP|Disposal|Null],
			Description -> "Indicates the conditions under which the aliquoted samples are stored after the unit operation is completed.",
			Category -> "Sample Post-Processing"
		},
		DestinationWell -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[_String|Null],
			Description -> "For each member of DestinationLink, the desired position in the corresponding destination in which the transferred samples will be placed.",
			Category -> "Aliquoting"
		},
		(* AliquotContainer *)
		AliquotContainerLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired.  This option will resolve to be the length of the SamplesIn * NumberOfReplicates.",
			Category -> "Aliquoting",
			Migration->SplitField
		},
		AliquotContainerString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired.  This option will resolve to be the length of the SamplesIn * NumberOfReplicates.",
			Category -> "Aliquoting",
			Migration->SplitField
		},
		AliquotContainerExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :>ListableP[
				Alternatives[
					{_Integer|_String, ObjectP[{Model[Container], Object[Container]}]},
					_String,
					Null,
					ObjectP[{Model[Container],Object[Container]}]
				]
			],
			Relation -> Null,
			Description -> "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired.  This option will resolve to be the length of the SamplesIn * NumberOfReplicates.",
			Category -> "Aliquoting",
			Migration->SplitField
		},
		AliquotPreparation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ListableP[PreparationMethodP|Null],
			Description -> "Indicates if the aliquotting should occur manually or on a robotic liquid handler.",
			Category -> "Aliquoting"
		},
		ConsolidateAliquots->{
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if identical aliquots should be consolidated in a single sample.",
			Category -> "Aliquoting"
		},
		AssayVolume->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[GreaterEqualP[0*Milliliter]|Null],
			Description -> "The desired total volume of the aliquoted sample plus dilution buffer.",
			Category -> "Aliquoting"
		},
		AliquotSampleLabel->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[_String|Null],
			Description -> "The label of the samples, after they are aliquotted.",
			Category -> "The label of the samples, after they are aliquotted.",
			Category -> "Aliquoting"
		},
		SamplesInStorageCondition -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[SampleStorageTypeP|Disposal|Null],
			Description -> "Indicates the conditions under which the source samples are stored after the unit operation is completed.",
			Category -> "Sample Post-Processing"
		},
		MeasureWeight->{
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the weight of the solid samples modified in the course of the experiment are measured after running the experiment.",
			Category -> "Sample Post-Processing"
		},
		MeasureVolume->{
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the volume of the liquid samples modified in the course of the experiment are measured after running the experiment.",
			Category -> "Sample Post-Processing"
		},
		ImageSample->{
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the samples that are modified in the course of the experiment are imaged after running the experiment.",
			Category -> "Sample Post-Processing"
		},
		SamplesOutStorageCondition->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[SampleStorageTypeP|Disposal|Null],
			Description -> "The non-default conditions under which any new samples generated by this experiment should be stored after the protocol is completed. If left unset, the new samples will be stored according to their Models' DefaultStorageCondition.",
			Category -> "Sample Post-Processing"
		},
		NumberOfReplicates->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0,1],
			Units->None,
			Description -> "Number of times each of the input samples should be analyzed using identical experimental parameters.",
			Category -> "General"
		},
		RoboticUnitOperations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[UnitOperation],
			Description -> "The list of all robotic unit operations that indicate what will actually happen on the liquid handling deck when this unit operation is performed robotically.",
			Category -> "General"
		},
		UnresolvedUnitOperationOptions -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> {_Rule...},
			Description -> "The options that were fed into this unit operation prior to calling Sample or Cell Preparation.",
			Category -> "General",
			Developer -> True
		},
		ResolvedUnitOperationOptions -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> {_Rule...},
			Description -> "The resolved options for this unit operation after calling Sample or Cell Preparation.",
			Category -> "General",
			Developer -> True
		}
	}
}];