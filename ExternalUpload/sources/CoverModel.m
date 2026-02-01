(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2028 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

(* ::Subsection::Closed:: *)
(*UploadCoverModel*)

(* ::Subsubsection::Closed:: *)
(*DefineOptions*)

DefineOptions[UploadCoverModel,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "Input Data",
			{
				OptionName -> Name,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Word
				],
				Description -> "The name which should be used to refer to the output cover model object in lieu of an automatically generated ID number, used to identify it in Constellation.",
				ResolutionDescription -> "Automatically constructed based on the CoverFootprint and CoverType option.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Stocked,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description->"Indicates if this item should be automatically purchased to maintain a stockpile in Emerald sites, so that it can be readily used in lab operations. As part of object verification, Emerald team member will generate an inventory object for this.",
				ResolutionDescription -> "Automatically set to False when creating new models; when modifying existing models, set the option to the same as current Stocked field in the cover model object.",
				Category -> "Product Specifications"
			},
			{
				OptionName -> ProductRelation,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> CoverProductRelationP
				],
				Description -> "Indicates how the new model you are trying to create is associated with the ProductInformation input. ProductModel indicate the new cover model is the product itself. DefaultCoverModel indicates the new cover model is the cover of the product. KitComponents indicate that the new cover model is part of a kit. KitComponentsCoverModel indicates the new cover model is the cover of one component of a kit.",
				Category -> "Product Specifications",
				ResolutionDescription -> "Automatically set to DefaultCoverModel when creating new models."
			},
			{
				OptionName -> Template,
				Default -> Null,
				HideNull -> False,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Item, Cap], Model[Item, Lid], Model[Item, PlateSeal]}],
					ObjectTypes -> {Model[Item, Cap], Model[Item, Lid], Model[Item, PlateSeal]}
				],
				Description -> "A cover model whose values will be used as defaults for any options not specified by the user, except product specifications.",
				Category -> "Product Specifications"
			},
			{
				OptionName -> CoverType,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> CoverTypeP
				],
				Description -> "The sealing mechanism of this cover model, which can be Crimp, Seal, Screw, Snap, Place, Pry and/or AluminumFoil. In addition to this option, ThreadType and CoverFootprint are used to determine if a cover is compatible with a given container.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of CoverType.",
				Category -> "Cover Information"
			},
			{
				OptionName -> CoverFootprint,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> CoverFootprintP
				],
				Description -> "The standardized shape and size of cap, seal or other coverings. Only containers with matching CoverFootprints can be covered by this cover model.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of CoverFootprint.",
				Category -> "Cover Information"
			},
			{
				OptionName -> WettedMaterials,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Null]
					],
					Adder[
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[MaterialP]
						]
					]
				],
				Category -> "Cover Information",
				HideNull -> False,
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of WettedMaterials.",
				Description -> "The materials of which this cover is made that may come in direct contact with fluids."
			},
			{
				OptionName -> ThreadType,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> String,
					Pattern :> NeckTypeP,
					Size -> Word
				],
				Description -> "The GPI/SPI Neck Finish designation of the screw cap that is used to determine compatible neck threadings. This option is only relevant if the CoverType option is set to Screw.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of ThreadType.",
				Category -> "Cover Information"
			},
			{
				OptionName -> Reusable,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				HideNull -> False,
				Description -> "Indicates if the cover is designed for multiple uses or if it is discarded after a single use. Reusable covers typically require cleaning and are hand washed or dishwashed after each use. If the cover is Reusable, cleaning conditions are set by CleaningMethod option.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of Reusable.",
				Category -> "Storage & Handling"
			},
			{
				OptionName -> CleaningMethod,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> CleaningMethodP
				],
				Description -> "The type of cleaning that is employed for this model of cover before reuse.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of CleaningMethod.",
				Category -> "Storage & Handling"
			},
			{
				OptionName -> Fragile,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if objects of this model are likely to be damaged if they are stored in a homogeneous pile. Fragile objects are stored individually or in individual positions of a rack.",
				ResolutionDescription -> "When creating new models, automatically set to True if WettedMaterials contains Glass. When modifying existing models, set the option to match the current field value.",
				Category -> "Storage & Handling"
			},
			{
				OptionName -> ExposedSurfaces,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if any sensitive portions of this cover are open to the external environment and prone to contamination.",
				ResolutionDescription -> "If creating a new object, resolves to False. For existing objects, Automatic resolves to the current field value.",
				Category -> "Storage & Handling"
			},
			{
				OptionName -> DefaultStorageCondition,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[Model[StorageCondition]]
					],
					Widget[
						Type -> Enumeration,
						Pattern :> SampleStorageTypeP
					]
				],
				Description -> "The environment in which a new cover of this model is stored when not in use by an experiment and not covered on any containers; whenever the cover is placed on container, its storage condition will be overwritten by the container. For reusable covers, when they are removed from container and cleaned, their storage condition will be restored to this DefaultStorageCondition.",
				ResolutionDescription -> "If ExposedSurfaces is True, resolves to Model[StorageCondition, \"Ambient Storage, Lined Enclosed\"], otherwise resolves to Model[StorageCondition, \"Ambient Storage\"]. For existing models, Automatic resolves to the current field value.",
				Category -> "Storage & Handling"
			},
			{
				OptionName -> StorageOrientation,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> StorageOrientationP
				],
				Description -> "Indicates how the object is situated while in storage. Upright indicates that the footprint dimension of the stored object is Width x Depth, Side indicates Depth x Height, Face indicates Width x Height, and Null indicates that there is no preferred orientation during storage.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of StorageOrientation.",
				Category -> "Storage & Handling"
			},
			{
				OptionName -> StorageOrientationImage,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Use existing cloud file" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[Object[EmeraldCloudFile]]
					],
					"Upload from computer" -> Widget[
						Type -> String,
						Pattern :> FilePathP,
						Size -> Line,
						PatternTooltip -> "The complete file path to the image file."
					]
				],
				Description -> "A file containing an image showing the designated orientation of this object in storage as defined by the StorageOrientation.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of StorageOrientationImage.",
				Category -> "Storage & Handling"
			},
			{
				OptionName -> RestingOrientation,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> (FaceUp | FaceDown)
				],
				Description -> "Indicates how lid should be placed when it's off the container.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of RestingOrientation.",
				Category -> "Storage & Handling"
			},
			{
				OptionName -> Sterile,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				HideNull -> False,
				Description -> "Indicates if this model of cover arrives free of microbial contamination from the manufacturer or is sterilized upon receiving.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of Sterile.",
				Category -> "Health & Safety"
			},
			{
				OptionName -> Sterilized,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if this model of cover is sterilized by autoclaving upon receiving and, if it is reusable, after being cleaned before it is reused.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of Sterilized.",
				Category -> "Health & Safety"
			},
			{
				OptionName -> SterilizationBag,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if this model of cover is sealed in an autoclave bag before autoclaving. The bag protects its sterility until it is used.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of SterilizationBag.",
				Category -> "Health & Safety"
			},
			{
				OptionName -> NucleaseFree,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if this model of cover is tested to be not contaminated with DNase and RNase by the manufacturer.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of NucleaseFree.",
				Category -> "Health & Safety"
			},
			{
				OptionName -> PyrogenFree,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if covers of this model are verified to be free from compounds that induce fever when introduced into the bloodstream, such as Endotoxins.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of PyrogenFree.",
				Category -> "Health & Safety"
			},
			{
				OptionName -> CrimpType,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> CrimpTypeP
				],
				Description -> "The compression technique used to mechanically deform the cap around the neck of the container to create a seal. Only applies if CoverType->Crimp.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of CrimpType.",
				Category -> "Crimp Information"
			},
			{
				OptionName -> CrimpingPressure,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterEqualP[0 PSI],
					Units -> {PSI, {Kilopascal, PSI, Bar}}
				],
				Description -> "The default pressure to set the crimping instrument to when securing or removing a cap of this model from a container. This field can only be set for crimped caps.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of CrimpingPressure.",
				Category -> "Crimp Information"
			},
			{
				OptionName -> SeptumRequired,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if a self-sealing membrane (i.e., septum) must be placed under the cap before it can be used. Septum compatibility is determined based on the CoverFootprint field.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of SeptumRequired.",
				Category -> "Specialty Cover"
			},
			{
				OptionName -> TaperGroundJointSize,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> GroundGlassJointSizeP
				],
				Description -> "The standardized size designation of the cap's conical textured glass connector. If populated, this cap must be secured to the container using a keck clamp that has the same TaperGroundJointSize.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of TaperGroundJointSize.",
				Category -> "Specialty Cover"
			},
			{
				OptionName -> Pierceable,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if this cap or plate seal can be pierced by a needle.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of Pierceable.",
				Category -> "Specialty Cover"
			},
			{
				OptionName -> Breathable,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates whether the cap either has holes which allows vapor to pass through, or is made of semi-permeable material that allows vapor to pass through.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of Breathable.",
				Category -> "Specialty Cover"
			},
			{
				OptionName -> MaxResealingGauge,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[10, 30, 1]
				],
				Description -> "The largest needle size that can be used on a cap with Pierceable -> True, and still leaves the cap resealable after piercing.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of MaxResealingGauge.",
				Category -> "Specialty Cover"
			},
			{
				OptionName -> MinPressure,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterEqualP[0 PSI],
					Units -> {PSI, {Millipascal, Millitorr, Millibar, Pascal, Torr, MillimeterMercury, Kilopascal, PSI, Bar}}
				],
				Description -> "If the cap forms air-tight seal, indicates the lowest internal pressure this cap can safely contain without seal failing.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of MinPressure.",
				Category -> "Operating Limits"
			},
			{
				OptionName -> MaxPressure,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterEqualP[0 PSI],
					Units -> {PSI, {Millipascal, Millitorr, Millibar, Pascal, Torr, MillimeterMercury, Kilopascal, PSI, Bar}}
				],
				Description -> "If the cap forms air-tight seal, indicates the highest internal pressure this cap can safely contain without seal failing.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of MaxPressure.",
				Category -> "Operating Limits"
			},
			{
				OptionName -> MinTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Kelvin],
					Units -> {Celsius, {Celsius, Kelvin, Fahrenheit}}
				],
				Description -> "Lowest temperature this type of cover can be exposed to and maintain structural integrity.",
				ResolutionDescription -> "If the WettedMaterials option is provided, automatically set to the MinTemperature of the material; if multiple materials are provided, the highest value will be used; if the ModelToUpdate is set, automatically set to match the field value of MinTemperature.",
				Category -> "Operating Limits"
			},
			{
				OptionName -> MaxTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Kelvin],
					Units -> {Celsius, {Celsius, Kelvin, Fahrenheit}}
				],
				Description -> "Highest temperature this type of cover can be exposed to and maintain structural integrity.",
				ResolutionDescription -> "If the WettedMaterials option is provided, automatically set to the MaxTemperature of the material; if multiple materials are provided, the lowest value will be used; if the ModelToUpdate is set, automatically set to match the field value of MaxTemperature.",
				Category -> "Operating Limits"
			},
			{
				OptionName -> MicrowaveSafe,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if the cap can be used for microwave synthesis or digestion.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of MicrowaveSafe.",
				Category -> "Microwave Reaction Cover Specification"
			},
			{
				OptionName -> ControlledPressureRelease,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if the cap can be vented to relieve a specified amount of pressure.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of ControlledPressureRelease.",
				Category -> "Microwave Reaction Cover Specification"
			},
			{
				OptionName -> BlowOffValve,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if this cap is automatically vented when the MaxPressure is reached.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of BlowOffValve.",
				Category -> "Microwave Reaction Cover Specification"
			},
			{
				OptionName -> ImageFile,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Use an uploaded file" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[Object[EmeraldCloudFile]]
					],
					"Upload from your PC" -> Widget[
						Type -> String,
						Pattern :> FilePathP,
						Size -> Line,
						PatternTooltip -> "The complete file path to the image file."
					],
					"Use file from URL" -> Widget[
						Type -> String,
						Pattern :> URLP,
						Size -> Line,
						PatternTooltip -> "In the format of a valid web address that can include or exclude http://."
					]
				],
				Description -> "A photo of this model of cover. This will be used to help identify this type of cover in lab operations. If possible, please provide stock image from manufacturer. If no image is provided, the cover model will be imaged by ECL upon receiving in lab.",
				Category -> "Physical Appearance"
			},
			{
				OptionName -> NotchPositions,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[
					Widget[
						Type -> Enumeration,
						Pattern :> NotchPositionP
					]
				],
				Description -> "The location of any cut-out Indentations in the corners of the lid.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of NotchPositions.",
				Category -> "Physical Appearance"
			},
			{
				OptionName -> Opaque,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if the exterior of this cover blocks the transmission of visible light.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of Opaque.",
				Category -> "Optical Information"
			},
			{
				OptionName -> MinTransparentWavelength,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Nanometer, 1 Millimeter],
					Units -> {Nanometer, {Nanometer, Micrometer, Millimeter}}
				],
				Description -> "Shortest wavelength this type of lid allows to pass through, thereby allowing measurement of the sample covered using light source with larger wavelength in spectroscopic application.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of MinTransparentWavelength.",
				Category -> "Optical Information"
			},
			{
				OptionName -> MaxTransparentWavelength,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Nanometer, 1 Millimeter],
					Units -> {Nanometer, {Nanometer, Micrometer, Millimeter}}
				],
				Description -> "Longest wavelength this type of lid allows to pass through, thereby allowing measurement of the sample covered using light source with smaller wavelength.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of MaxTransparentWavelength.",
				Category -> "Optical Information"
			},
			{
				OptionName -> Dimensions,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Null]
					],
					{
						"Width" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterP[0 Centimeter],
							Units -> {1, {Centimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
						],
						"Depth" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterP[0 Centimeter],
							Units -> {1, {Centimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
						],
						"Height" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterP[0 Centimeter],
							Units -> {1, {Centimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
						]
					}
				],
				Description -> "The external dimensions of this model of cover when the wetted surface is facing down.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of Dimensions.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> CondensationRings,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if the lid has circular low-profile rings to catch any condensation. Such rings ensures the condensed sample vapor to return to its original well.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of CondensationRings.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> NumberOfRings,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 30, 1]
				],
				Description -> "Number of individual condensation rings in the lid.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of NumberOfRings.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> Rows,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 100, 1]
				],
				Description -> "The number of condensation rings in the plate lid from front to back - in the shorter horizontal direction if the plate lid is not square.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of Rows.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> Columns,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 100, 1]
				],
				Description -> "The number of condensation rings in the plate from left to right - in the longer horizontal direction if the plate lid is not square.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of Columns.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> AspectRatio,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0.1, 10]
				],
				Description -> "Ratio of the number of columns of rings vs the number of rows of rings on the lid.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of AspectRatio.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> RingDiameter,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Millimeter, 1000 Millimeter],
					Units -> {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}
				],
				Description -> "Diameter of each round condensation ring.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of RingDiameter.",
				Category ->"Dimensions & Positions"
			},
			{
				OptionName -> HorizontalMargin,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Millimeter, 1000 Millimeter],
					Units -> {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}
				],
				Description -> "Distance from the edge of the plate lid to the edge of the first column of condensation rings, along the longer horizontal dimension.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of HorizontalMargin.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> VerticalMargin,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Millimeter, 1000 Millimeter],
					Units -> {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}
				],
				Description -> "Distance from the edge of the plate lid to the edge of the first row of condensation rings, along the shorter horizontal dimension.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of VerticalMargin.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> HorizontalPitch,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Millimeter, 1000 Millimeter],
					Units -> {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}
				],
				Description -> "Center-to-center distance from one condensation ring to the next in a given row.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of HorizontalPitch.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> VerticalPitch,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Millimeter, 1000 Millimeter],
					Units -> {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}
				],
				Description -> "Center-to-center distance from one condensation ring to the next in a given column.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of VerticalPitch.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> HorizontalOffset,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Millimeter, 1000 Millimeter],
					Units -> {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}
				],
				Description -> "Distance between the center of condensation ring at column 1 row 1 and the ring at column 1 row 2 in the X direction. Only applies to lids which the condensation rings are staggered or tilted across rows.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of HorizontalOffset.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> VerticalOffset,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Millimeter, 1000 Millimeter],
					Units -> {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}
				],
				Description -> "Distance between the center of condensation ring at column 1 row 1 and condensation ring at column 2 row 1 in the Y direction. Only applies to plates which the condensation rings are staggered or tilted across columns.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of VerticalOffset.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> LidThickness,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Millimeter, 1000 Millimeter],
					Units -> {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}
				],
				Description -> "Thickness of the lid material covering the opening portion of the corresponding container.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of LidThickness.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> InternalDimensions2D,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> {
					"X Dimension" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Millimeter, 1000 Millimeter],
						Units -> {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}
					],
					"Y Dimension" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Millimeter, 1000 Millimeter],
						Units -> {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}
					]
				},
				Description -> "The dimensions of the internal rectangular cross sections of the lid.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of InternalDimensions2D.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> DefaultStickerModel,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[Model[Item, Sticker]]
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Small, Large]
					]
				],
				Description -> "The type of sticker applied to covers of this model when they are stickered upon receiving and used to identify this cover in lab.",
				ResolutionDescription -> "Auto-resolved to Small if Barcode -> True when creating new cover model.",
				Category -> "Hidden"
			},
			{
				OptionName -> SealType,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> SealTypeP
				],
				Description -> "The mechanism of how this seal is attached to a plate.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of SealType.",
				Category -> "Cover Information"
			},
			{
				OptionName -> Product,
				Default -> Null,
				AllowNull -> True,
				HideNull -> False,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Object[Product]]
				],
				Description -> "Product ordering information for this model.",
				Category -> "Hidden"
			},
			{
				OptionName -> ProductDocumentation,
				Default -> Null,
				AllowNull -> True,
				HideNull -> False,
				Widget -> Alternatives[
					"Use an uploaded file" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[Object[EmeraldCloudFile]]
					],
					"Use file from URL" -> Widget[
						Type -> String,
						Pattern :> URLP,
						Size -> Line,
						PatternTooltip -> "In the format of a valid web address that can include or exclude http://."
					],
					"Upload from your PC" -> Widget[
						Type -> String,
						Pattern :> FilePathP,
						Size -> Line,
						PatternTooltip -> "The complete file path to the documentation file. This documentation file must be PDF format."
					]
				],
				Description -> "PDFs of product documentation provided by the supplier of this model.",
				Category -> "Hidden"
			},
			{
				OptionName -> ProductURL,
				Default -> Null,
				AllowNull -> True,
				HideNull -> False,
				Widget -> Widget[
					Type -> String,
					Pattern :> URLP,
					Size -> Line,
					PatternTooltip -> "In the format of a valid web address that can include or exclude http://."
				],
				Description -> "Supplier webpage for the product.",
				Category -> "Hidden"
			},
			{
				OptionName -> Barcode,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if this cap should have a barcode sticker placed on it. If caps are not barcoded, they are placed on a cap rack (which is barcoded) whenever they are taken off of containers. Caps must be barcoded if they are over 54mm (the diameter of a GL45 cap, which is the largest cover that we can fit on our cap racks).",
				ResolutionDescription -> "Automatically set to True for caps which width and depth are over 41 mm, and False for those are not.",
				Category -> "Hidden"
			},
			(* These options are only relevant for aspiration caps, thus hide it from users. we expect users would almost never create aspiration cap model *)
			{
				OptionName -> Positions,
				Default -> Null,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Null]
					],
					Adder[
						{
							"Name of Position" -> Widget[
								Type -> String,
								Pattern :> LocationPositionP,
								Size -> Line
							],
							"Footprint" -> Widget[
								Type -> Enumeration,
								Pattern :> (FootprintP|Open|Null)
							],
							"Max Width" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterP[0 Millimeter],
								Units -> {1, {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
							],
							"Max Depth" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterP[0 Millimeter],
								Units -> {1, {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
							],
							"Max Height" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterP[0 Millimeter],
								Units -> {1, {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
							]
						}
					]
				],
				Description -> "For aspiration caps, indicates the spatial definitions of the positions that exist in this model of cover, where MaxWidth and MaxDepth are the x and y dimensions of the maximum size of object that will fit in this position. MaxHeight is defined as the maximum height of object that can fit in this position without either encountering a barrier or creating a functional impediment to an experiment procedure.",
				Category -> "Hidden"
			},
			{
				OptionName -> PositionPlotting,
				Default -> Null,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Null]
					],
					Adder[
						{
							"Name of Position" -> Widget[
								Type -> String,
								Pattern :> LocationPositionP,
								Size -> Line
							],
							"X Offset" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Millimeter],
								Units -> {1, {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
							],
							"Y Offset" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Millimeter],
								Units -> {1, {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
							],
							"Z Offset" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Millimeter],
								Units -> {1, {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
							],
							"Crosssectional shape" -> Widget[
								Type -> Enumeration,
								Pattern :> CrossSectionalShapeP
							],
							"Rotation in degree" -> Widget[
								Type -> Number,
								Pattern :> RangeP[-180, 180]
							]
						}
					]
				],
				Description -> "For aspiration caps, indicates the parameters required to plot the position, where the offsets refer to the location of the center of the position relative to the close, bottom, left hand corner of the cover model's dimensions.",
				Category -> "Hidden"
			},
			{
				OptionName -> AspirationTubeLength,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Millimeter, 500 Millimeter],
					Units -> {Millimeter, {Millimeter, Centimeter, Inch, Foot}}
				],
				Description -> "The length of the tubing permanently attached to the cap that is used to aspirate liquid from a container to which this cap is attached, measured from the end of the tubing to the point where the tubing attaches to the cap.",
				Category -> "Hidden"
			},
			{
				OptionName -> LevelSensorType,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> LevelSensorTypeP
				],
				Description -> "The type of volume sensor mounting to which this aspiration cap connects for sensornet volume monitoring.",
				Category -> "Hidden"
			},
			{
				OptionName -> InnerDiameter,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Millimeter, 100 Millimeter],
					Units -> {Millimeter, {Millimeter, Centimeter, Inch}}
				],
				Description -> "The diameter of the hollow, fluid-containing portion of aspiration plumbing component.",
				Category -> "Hidden"
			},
			{
				OptionName -> OuterDiameter,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Millimeter, 100 Millimeter],
					Units -> {Millimeter, {Millimeter, Centimeter, Inch}}
				],
				Description -> "The diameter of the entire aspiration plumbing component, orthogonal to the flow of fluid.",
				Category -> "Hidden"
			},
			(* These two options are for liquid handler applications and should be measured or specified by developer only *)
			{
				OptionName -> LidPlateGripHeight,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Millimeter, 1000 Millimeter],
					Units -> {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}
				],
				Description -> "Distance the liquid handler arms should grip below the top edge of the lid to uncover when the lid is stacked on a container.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of LidPlateGripHeight.",
				Category -> "Hidden"
			},
			{
				OptionName -> LidStackGripHeight,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Millimeter, 1000 Millimeter],
					Units -> {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}
				],
				Description -> "Distance the liquid handler arms should grip below the top edge of the lid to remove it from the lid stack.",
				Category -> "Hidden"
			},
			{
				OptionName -> NewType,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives @@ Types[{
						Model[Item, Cap],
						Model[Item, Lid],
						Model[Item, PlateSeal]
					}]
				],
				Description -> "Indicates the new subtype of Model[Item] that should be created to replace the current Model[Item] input. This is meant for cases where user did not know what type of cover to create, and chose Model[Item] parent type.",
				Category -> "Hidden"
			},
			{
				OptionName -> PreferredWashBin,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[Container, WashBin]]
				],
				Description -> "The recommended dirty labware collection tray for dishwashing this cover.",
				ResolutionDescription -> "If Reusable -> True, automatically set to either regular or carboy washbin depending on the size.",
				Category -> "Hidden"
			}
		],
		{
			OptionName -> Force,
			Default -> False,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if new cover models will still be uploaded even if similar ones are already found in the database.",
			Category -> "Hidden"
		},
		ExternalUploadHiddenOptions,
		UnresolvedInputsOptions,
		SimulationOption
	}
];

(* ::Subsubsection::Closed:: *)
(*Function*)

(* Core overload *)
UploadCoverModel[myMixedInput:ListableP[Alternatives[TypeP[{Model[Item, Cap], Model[Item, Lid], Model[Item, PlateSeal]}], Model[Item], ObjectP[{Model[Item, Cap], Model[Item, Lid], Model[Item, PlateSeal]}]]], myProductInfo:ListableP[Alternatives[Null, ObjectP[Object[Product]], ObjectP[Object[EmeraldCloudFile]], _String]], ops:OptionsPattern[]] := uploadContainerCoverModelCore[
	myMixedInput,
	myProductInfo,
	ReplaceRule[
		ToList[ops],
		{
			UnresolvedInputs -> {myMixedInput, myProductInfo}
		}
	],
	UploadCoverModel
];

(* No Product info overload *)
UploadCoverModel[myMixedInput:ListableP[Alternatives[TypeP[{Model[Item, Cap], Model[Item, Lid], Model[Item, PlateSeal]}], Model[Item], ObjectP[{Model[Item, Cap], Model[Item, Lid], Model[Item, PlateSeal]}]]], ops:OptionsPattern[]] := uploadContainerCoverModelCore[
	myMixedInput,
	If[MatchQ[myMixedInput, _List], ConstantArray[Null, Length[myMixedInput]], Null],
	ReplaceRule[
		ToList[ops],
		{
			UnresolvedInputs -> {myMixedInput, Null}
		}
	],
	UploadCoverModel
];

(* ContainerModel or SampleModel as Product Info overload *)
(* This may sound weird but we kind of want to allow user creating a shell CoverModel object from a ContainerModel or even SampleModel. *)
(* Developers who are in charge of verification will need to find the corresponding product *)
UploadCoverModel[myMixedInput:ListableP[Alternatives[TypeP[{Model[Item, Cap], Model[Item, Lid], Model[Item, PlateSeal]}], Model[Item], ObjectP[{Model[Item, Cap], Model[Item, Lid], Model[Item, PlateSeal]}]]], myModel:ListableP[ObjectP[{Model[Container], Model[Sample]}]], ops:OptionsPattern[]] := uploadContainerCoverModelCore[
	myMixedInput,
	If[MatchQ[myMixedInput, _List], ConstantArray[Null, Length[myMixedInput]], Null],
	ReplaceRule[
		ToList[ops],
		{
			UnresolvedInputs -> {myMixedInput, myModel}
		}
	],
	UploadCoverModel
];

$CoverModelStringToTypeLookup = <|
	"Bottle or carboy cap" -> Model[Item, Cap],
	"Tube or vial cap" -> Model[Item, Cap],
	"Stopper or septa" -> Model[Item, Cap],
	"Plate lid" -> Model[Item, Lid],
	"Plate seal" -> Model[Item, PlateSeal],
	"Others" -> Model[Item]
|>;

(* user-friendly string overload *)
UploadCoverModel[myNewCover:UploadCoverModelTypeStringP, myProductInfo:Alternatives[Null, ObjectP[Object[Product]], ObjectP[Object[EmeraldCloudFile]], _String], ops:OptionsPattern[]] := With[
	{myCoverType = Lookup[$CoverModelStringToTypeLookup, myNewCover]},
	uploadContainerCoverModelCore[
		myCoverType,
		myProductInfo,
		ReplaceRule[
			ToList[ops],
			{
				UnresolvedInputs -> {myNewCover, myProductInfo}
			}
		],
		UploadCoverModel
	]
];

(* user-friendly string no-product overload *)
UploadCoverModel[myNewCover:UploadCoverModelTypeStringP, ops:OptionsPattern[]] := With[
	{myCoverType = Lookup[$CoverModelStringToTypeLookup, myNewCover]},
	uploadContainerCoverModelCore[
		myCoverType,
		Null,
		ReplaceRule[
			ToList[ops],
			{
				UnresolvedInputs -> {myNewCover, Null}
			}
		],
		UploadCoverModel
	]
];

(* user-friendly string and Container/Sample Model overload *)
UploadCoverModel[myNewCover:UploadCoverModelTypeStringP, myModel:ListableP[ObjectP[{Model[Container], Model[Sample]}]], ops:OptionsPattern[]] := With[
	{myCoverType = Lookup[$CoverModelStringToTypeLookup, myNewCover]},
	uploadContainerCoverModelCore[
		myCoverType,
		Null,
		ReplaceRule[
			ToList[ops],
			{
				UnresolvedInputs -> {myNewCover, myModel}
			}
		],
		UploadCoverModel
	]
];

installDefaultVerificationFunction[UploadCoverModel, "coverModel", {Model[Item, Cap], Model[Item, PlateSeal], Model[Item, Lid]}];


(* ::Subsubsection::Closed:: *)
(*Option function: UploadCoverModelOptions*)

DefineOptions[UploadCoverModelOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (Table | List)],
			Description -> "Determines whether the function returns a table or a list of the options.",
			Category -> "Protocol"
		}
	},
	SharedOptions :> {UploadCoverModel}
];

(* Single input overload *)
UploadCoverModelOptions[myInput:_, myOptions:OptionsPattern[]]:=UploadCoverModelOptions[myInput, Null, myOptions];

(* Double input overload *)
UploadCoverModelOptions[myInput:_, myProductInfo_, myOptions:OptionsPattern[]]:=Module[
	{listedOps, outOps, options},

	(* get the options as a list *)
	listedOps=ToList[myOptions];

	outOps=DeleteCases[listedOps, (OutputFormat -> _) | (Output -> _)];

	options=UploadCoverModel[myInput, myProductInfo, Append[outOps, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOps, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, UploadCoverModel],
		options
	]
];

(* ::Subsubsection::Closed:: *)
(*Valid function: ValidUploadCoverModelQ*)

DefineOptions[ValidUploadCoverModelQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {UploadCoverModel}
];

(* Single input overload *)
ValidUploadCoverModelQ[myInput_, myOptions:OptionsPattern[]]:=ValidUploadCoverModelQ[myInput, Null, myOptions];

(* Double input overload *)
ValidUploadCoverModelQ[myInput_, myProductInfo_, myOptions:OptionsPattern[]]:=Module[
	{preparedOptions, functionTests, initialTestDescription, allTests, verbose, outputFormat},

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[ToList[myOptions], Output -> Tests], {Verbose, OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=UploadCoverModel[myInput, myProductInfo, preparedOptions];

	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests=If[MatchQ[functionTests, $Failed],
		{Test[initialTestDescription, False, True]},

		Module[{initialTest},
			initialTest=Test[initialTestDescription, True, True];

			Join[{initialTest}, functionTests]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat}=OptionDefault[OptionValue[{Verbose, OutputFormat}]];

	(* Run the tests as requested *)
	RunUnitTest[<|"ValidUploadCoverModelQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose]["ValidUploadCoverModelQ"]
];

(* ::Subsubsection::Closed:: *)
(*Verification pre-checking*)
coverModelVerificationPreCheck[myCoverModel:ListableP[ObjectP[{Model[Item, Cap], Model[Item, Lid], Model[Item, PlateSeal]}]]] := Module[
	{
		listedModels, allModelPackets, deprecatedQs, replacedObjectQs, requireTypeChangeQs, inproperProductInfoQs,
		replacementObjects, productInfo, productObjectAsInfoQs, allErrorBools, productObjectAsInput, productPackets
	},

	listedModels = ToList[myCoverModel];

	allModelPackets = Quiet[
		Download[listedModels,
			Packet[Deprecated, ReplacementObject, UnresolvedInputs, UnresolvedOptions, ProductURL, ProductDocumentationFiles, Products, KitProducts]
		],
		{Download::FieldDoesntExist}
	];

	(* If download fails, return $Failed *)

	If[MatchQ[allModelPackets, $Failed] || MatchQ[allModelPackets, _List?(MemberQ[#, $Failed]&)],
		Return[$Failed]
	];

	(* Find all the Object[Product] in the UnresolvedInput *)
	productObjectAsInput = Map[
		Function[{packet},
			Module[{typeInput, productInfoInput},

				(* Extract the Type and ProductInformation input from UnresolvedInputs *)
				{typeInput, productInfoInput} = If[Length[Lookup[packet, UnresolvedInputs]] == 2,
					Lookup[packet, UnresolvedInputs],
					{Null, Null}
				];

				If[MatchQ[productInfoInput, ObjectP[Object[Product]]],
					productInfoInput,
					Null
				]
			]
		],
		allModelPackets
	];

	(* Do a second download on the Object[Product] *)
	productPackets = Quiet[
		Download[productObjectAsInput,
			Packet[ProductModel, DefaultCoverModel, KitComponents]
		],
		{Download::FieldDoesntExist}
	];

	(* Map over packets to find problem *)
	{
		deprecatedQs,
		replacedObjectQs,
		requireTypeChangeQs,
		inproperProductInfoQs,
		productObjectAsInfoQs,
		replacementObjects,
		productInfo
	} = Transpose[
		MapThread[
			Function[{packet, productPacket},
				Module[
					{
						deprecatedQ, replacedObjectQ, typeInput, productInfoInput, requireTypeChangeQ, inproperProductInfoQ,
						replacementObject, productObjectAsInfoQ, unresolvedOptions, productRelation, productInfoPopulated,
						coverModelsInProductPacket, object
					},
					(* Check if the model is deprecated *)
					deprecatedQ = TrueQ[Lookup[packet, Deprecated]];
					(* Check if the model has ReplacementObject *)
					replacementObject = Download[Lookup[packet, ReplacementObject], Object];
					replacedObjectQ = MatchQ[replacementObject, ObjectP[]];
					(* Extract the Type and ProductInformation input from UnresolvedInputs *)
					{typeInput, productInfoInput} = If[Length[Lookup[packet, UnresolvedInputs]] == 2,
						Lookup[packet, UnresolvedInputs],
						{Null, Null}
					];

					(* If the Type is Model[Item], not one of the children types, record error *)
					requireTypeChangeQ = MatchQ[typeInput, (Model[Item] | "Others")];

					(* extract all cover models in the Product packet *)
					coverModelsInProductPacket = Download[
						Cases[productPacket, ObjectP[{Model[Item, Cap], Model[Item, Lid], Model[Item, PlateSeal]}], Infinity],
						Object
					];
					(* Find the current object *)
					object = Lookup[packet, Object];

					(* Check that if the cover model appears in the product packet *)
					productInfoPopulated = Or[
						MemberQ[Lookup[packet, {ProductURL, ProductDocumentationFiles, Products, KitProducts}, Null], Except[({} | Null | $Failed)]],
						MemberQ[coverModelsInProductPacket, object]
					];

					(* If the ProductInformation is a sample or container model, record error here. Resolve the error if any of the product-related fields are populated *)
					inproperProductInfoQ = (!productInfoPopulated) && MatchQ[productInfoInput, ObjectP[{Model[Item], Model[Sample], Model[Container]}]];
					(* If the ProductInformation is an Object[Product], indicate here. Resolve the error if any of the product-related fields are populated *)
					productObjectAsInfoQ = (!productInfoPopulated) && MatchQ[productInfoInput, ObjectP[Object[Product]]];

					(* Extract the unresolved options *)
					unresolvedOptions = Lookup[packet, UnresolvedOptions];

					productRelation = Lookup[unresolvedOptions, ProductRelation, Null];

					{
						deprecatedQ,
						replacedObjectQ,
						requireTypeChangeQ,
						inproperProductInfoQ,
						productObjectAsInfoQ,
						replacementObject,
						productInfoInput
					}
				]
			],
			{allModelPackets, productPackets}
		]
	];

	(* Throw errors *)
	If[MemberQ[deprecatedQs, True],
		Message[Error::ModelIsDeprecated, PickList[listedModels, deprecatedQs]]
	];

	If[MemberQ[replacedObjectQs, True],
		Message[Error::ObjectReplaced, PickList[listedModels, replacedObjectQs], PickList[replacementObjects, replacedObjectQs]]
	];

	If[MemberQ[requireTypeChangeQs, True],
		Message[Warning::UserDidNotSpecifyType, PickList[listedModels, requireTypeChangeQs]]
	];

	If[MemberQ[inproperProductInfoQs, True],
		Message[Error::ProductNotProvided, PickList[listedModels, inproperProductInfoQs], PickList[productInfo, inproperProductInfoQs]]
	];

	If[MemberQ[productObjectAsInfoQs, True],
		Message[Error::DoubleCheckProduct, PickList[listedModels, productObjectAsInfoQs], PickList[productInfo, productObjectAsInfoQs]]
	];

	(* Collect all error bools. Note: True means error. Also note: ignore the requireTypeChangeQs, which triggers a warning not error *)
	allErrorBools = Flatten[{
		deprecatedQs,
		replacedObjectQs,
		inproperProductInfoQs,
		productObjectAsInfoQs
	}];

	If[MemberQ[allErrorBools, True],
		False,
		True
	]

];