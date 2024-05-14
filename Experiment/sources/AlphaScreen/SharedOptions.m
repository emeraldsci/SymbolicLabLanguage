(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*Optics Options*)


DefineOptionSet[AlphaScreenOpticsOptions :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName -> SampleLabel,
			Default -> Automatic,
			Description -> "A user defined word or phrase used to identify the samples for which alpha screen measurements are taken, for use in downstream unit operations.",
			AllowNull -> False,
			Category -> "General",
			Widget -> Widget[
				Type -> String,
				Pattern :> _String,
				Size -> Word
			],
			UnitOperation -> True
		},
		{
			OptionName -> SampleContainerLabel,
			Default -> Automatic,
			Description -> "A user defined word or phrase used to identify the containers holding the samples for which alpha screen measurements are taken, for use in downstream unit operations.",
			AllowNull -> False,
			Category -> "General",
			Widget -> Widget[
				Type -> String,
				Pattern :> _String,
				Size -> Word
			],
			UnitOperation -> True
		}
	],
	{
		OptionName -> ReadTemperature,
		Default -> 37 Celsius,
		Description -> "The temperature at which the measurement will be taken in the plate reader.",
		AllowNull -> False,
		Widget -> Alternatives[
			Widget[Type -> Quantity, Pattern :> RangeP[$AmbientTemperature, 45 Celsius], Units :> {1, {Celsius, {Celsius, Fahrenheit}}}],
			Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
		],
		Category -> "Optics"
	},
	{
		OptionName -> ReadEquilibrationTime,
		Default -> 2 Minute,
		Description -> "The length of time for which the assay plates should equilibrate at the assay temperature in the plate reader before being read.",
		AllowNull -> False,
		Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, 2 Hour], Units :> {1, {Minute, {Second, Minute, Hour}}}],
		Category -> "Optics"
	},
	{
		OptionName -> PlateReaderMix,
		Default -> Automatic,
		Description -> "Indicates if samples should be mixed inside the plate reader chamber before the samples are read.",
		ResolutionDescription -> "Automatically set to True if any other plate reader mix options are specified.",
		AllowNull -> False,
		Widget -> Alternatives[
			Widget[Type -> Enumeration, Pattern :> BooleanP],
			Widget[Type -> Enumeration, Pattern :> Alternatives[Automatic]]
		],
		Category -> "Optics"
	},
	{
		OptionName -> PlateReaderMixTime,
		Default -> Automatic,
		Description -> "The amount of time samples should be mixed inside the plate reader chamber before the samples are read.",
		ResolutionDescription -> "Automatically set to 30 second if PlateReaderMix is True and any other plate reader mix options are specified.",
		AllowNull -> True,
		Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1 Second, 1 Hour], Units :> {1, {Second, {Second, Minute, Hour}}}],
		Category -> "Optics"
	},
	{
		OptionName -> PlateReaderMixRate,
		Default -> Automatic,
		Description -> "The rate at which the plate is agitated inside the plate reader chamber before the samples are read.",
		ResolutionDescription -> "Automatically set to 700 RPM if PlateReaderMix is True and any other plate reader mix options are specified.",
		AllowNull -> True,
		Widget -> Widget[Type -> Quantity, Pattern :> RangeP[100 RPM, 700 RPM], Units :> RPM],
		Category -> "Optics"
	},
	{
		OptionName -> PlateReaderMixMode,
		Default -> Automatic,
		Description -> "The pattern of motion which should be employed to shake the plate before the samples are read.",
		ResolutionDescription -> "Automatically set to DoubleOrbital if PlateReaderMix is True and any other plate reader mix options are specified.",
		AllowNull -> True,
		Widget -> Widget[Type -> Enumeration, Pattern :> MechanicalShakingP],
		Category -> "Optics"
	},
	{
		OptionName -> Gain,
		Default -> Automatic,
		Description -> "The gain which should be applied to the signal reaching the primary detector photomultiplier tube (PMT). This is specified as a direct voltage.",
		ResolutionDescription -> "Automatic set to 3600 Microvolt.",
		AllowNull -> False,
		Widget -> Alternatives[
			Widget[Type -> Quantity, Pattern :> RangeP[1 Microvolt, 4095 Microvolt], Units :> Microvolt],
			Widget[Type -> Enumeration, Pattern :> Alternatives[Automatic]]
		],
		Category -> "Optics"
	},
	{
		OptionName -> FocalHeight,
		Default -> Automatic,
		Description -> "The distance from the focal point to the lens that collect the light to the primary detector photomultiplier tube (PMT).",
		ResolutionDescription -> "Automatic set to Auto, which indicates that the focal height will be selected by the instrument.",
		AllowNull -> False,
		Widget -> Alternatives[
			Widget[Type -> Quantity, Pattern :> RangeP[0 Millimeter, 25 Millimeter], Units :> Millimeter],
			Widget[Type -> Enumeration, Pattern :> Alternatives[Auto]]
		],
		Category -> "Optics"
	},
	{
		OptionName -> SettlingTime,
		Default -> 0 Millisecond,
		Description -> "The time between the movement of the plate and the beginning of the measurement. It reduces potential vibration of the samples in plate due to the stop and go motion of the plate carrier.",
		AllowNull -> False,
		Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Second, 1 Second], Units :> {1, {Second, {Millisecond, Second}}}],
		Category -> "Optics"
	},
	{
		OptionName -> ExcitationTime,
		Default -> 80 Millisecond,
		Description -> "The time that the samples will be excited by the light source and the singlet Oxygen is generated.",
		AllowNull -> False,
		Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0.01 Second, 1 Second], Units :> {1, {Second, {Millisecond, Second}}}],
		Category -> "Optics"
	},
	{
		OptionName -> DelayTime,
		Default -> 120 Millisecond,
		Description -> "The time between end of excitation and start of the emission signal integration. It allows the singlet Oxygen to react with the acceptor beads and reduces potential auto-fluorescent noise generated by biomolecular components.",
		AllowNull -> False,
		Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Second, 2 Second], Units :> {1, {Second, {Millisecond, Second}}}],
		Category -> "Optics"
	},
	{
		OptionName -> IntegrationTime,
		Default -> 300 Millisecond,
		Description -> "The amount of time for which the emission signal is integrated.",
		AllowNull -> False,
		Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0.01 Second, 2 Second], Units :> {1, {Second, {Millisecond, Second}}}],
		Category -> "Optics"
	},
	{
		OptionName -> ExcitationWavelength,
		Default -> 680 Nanometer,
		Description -> "The excitation wavelength determined by the AlphaScreen laser.",
		AllowNull -> False,
		Widget -> Widget[Type -> Quantity, Pattern :> RangeP[300 Nanometer, 700 Nanometer, 1 Nanometer], Units :> {1, {Nanometer, {Nanometer, Micrometer, Meter}}}],
		Category -> "Optics"
	},
	{
		OptionName -> EmissionWavelength,
		Default -> 570 Nanometer,
		Description -> "The emission wavelength determined by the optical filter.",
		AllowNull -> False,
		Widget -> Widget[
			Type -> Enumeration,
			Pattern :> Alternatives[
				570 Nanometer,
				615 Nanometer,
				665 Nanometer,
				620 Nanometer
			]
		],
		Category -> "Optics"
	},
	{
		OptionName -> RetainCover,
		Default -> False,
		Description -> "Indicates if the plate seal or lid on the assay container should not be taken off during measurement to decrease evaporation. It is strongly recommended not to retain a cover because AlphaScreen can only read from top.",
		AllowNull -> False,
		Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
		Category -> "Optics"
	},
	{
		OptionName -> ReadDirection,
		Default -> Row,
		Description -> "Indicates the order in which wells should be read by specifying the plate path the instrument should follow when measuring signal. Default sets to Row, where the plate is read from left to right for each row.",
		AllowNull -> False,
		Widget -> Widget[Type -> Enumeration, Pattern :> ReadDirectionP],
		Category -> "Optics"
	},
	{
		OptionName -> MoatWells,
		Default -> Automatic,
		Description -> "Indicates if moat wells are set to decrease evaporation from the assay samples during the experiment.",
		ResolutionDescription -> "Automatically set to True if any other moat options are specified.",
		AllowNull -> True,
		Widget -> Alternatives[
			Widget[Type -> Enumeration, Pattern :> BooleanP],
			Widget[Type -> Enumeration, Pattern :> Alternatives[Automatic]]
		],
		Category -> "Sample Handling"
	},
	{
		OptionName -> MoatSize,
		Default -> Automatic,
		Description -> "Indicates the number of concentric perimeters of wells which should be filled with MoatBuffer in order to decrease evaporation from the assay samples during the run.",
		ResolutionDescription -> "Automatically set to 1 if any other moat options are specified. Resolves Null if MoatWells is False.",
		AllowNull -> True,
		Widget -> Widget[Type -> Number, Pattern :> GreaterEqualP[0, 1]],
		Category -> "Sample Handling"
	},
	{
		OptionName -> MoatVolume,
		Default -> Automatic,
		Description -> "Indicates the volume which should be added to each moat well.",
		ResolutionDescription -> "Automatically set to the minimum volume of the assay plate if any other moat options are specified.",
		AllowNull -> True,
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter
		],
		Category -> "Sample Handling"
	},
	{
		OptionName -> MoatBuffer,
		Default -> Automatic,
		Description -> "Indicates the buffer which should be used to fill each moat well.",
		ResolutionDescription -> "Automatically set to Model[Sample,\"Milli-Q water\"] if any other moat options are specified.]",
		AllowNull -> True,
		Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]],
		Category -> "Sample Handling"
	},
	WorkCellOption,
	SimulationOption,
	PreparationOption
}];
