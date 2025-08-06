(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Quantity System Compatibility & Installing EmeraldUnits*)

(* ::Subsubsection::Closed:: *)
(*canonicalUnitLookup*)


(* List of emerald unit symbols and their mathematica names *)
(*
	These are in a 'Hold' because otherwise the left side will evaluate (on re-load)
	which will make this stuff not work.
*)
canonicalUnitLookup=Hold[

	Unit -> "Unities",
	NoUnit -> "PureUnities",

	Gram -> "Grams",
	Pound -> "Pounds",
	Ton -> "ShortTons",
	Ounce -> "Ounces",
	Stone -> "Stones",
	Dalton -> "Grams" / "Moles",

	Molar -> "Molar",
	(*Byte \[Rule] "Bytes",*)  (* Byte is System` and has other uses *)
	Siemens -> "Siemens",
	USD -> "USDollars",
	Calorie -> "CaloriesThermochemical",
	Ampere -> "Amperes",
	Joule -> "Joules",
	Hertz -> "Hertz",
	Watt -> "Watts",
	Ohm -> "Ohms",
	Volt -> "Volts",
	Mole -> "Moles",
	Revolution -> "Revolutions",
	Lumen -> "Lumens",
	Coulomb -> "Coulombs",

	(* Temperature *)
	Celsius -> "DegreesCelsius",
	Kelvin -> "Kelvin",
	Fahrenheit -> "DegreesFahrenheit",

	(* Pressure *)
	Pascal -> "Pascals",
	PSI -> "PoundsForce" / "Inches"^2,
	Bar -> "Bars",
	Torr -> "Torr",
	MillimeterMercury -> "MillimetersOfMercury",
	Atmosphere -> "Atmospheres",

	(* time *)
	Second -> "Seconds",
	Minute -> "Minutes",
	Hour -> "Hours",
	Day -> "Days",
	Week -> "Weeks",
	Month -> "Months",
	Year -> "Years",
	Decade -> "Decades",
	Century -> "Centuries",
	Millennium -> "Millennia",

	(* distance *)
	Meter -> "Meters",
	Foot -> "Feet",
	Inch -> "Inches",
	Micron -> "Micrometers",
	Centimeter -> "Centimeters",
	Angstrom -> "Angstroms",
	Yard -> "Yards",
	Mile -> "Miles",

	(* volumes *)
	Liter -> "Liters",
	Gallon -> "Gallons",
	FluidOunce -> "FluidOunces",
	Quart -> "Quarts",
	Pint -> "Pints",
	Cup -> "Cups",

	Poise -> "Poise",

	RPM -> "Revolutions" / "Minutes",

	GravitationalAcceleration -> "StandardAccelerationOfGravity",

	(*Light*)
	Lux-> ("Lumens") / ("Feet")^2,

	(* dimensionless Units *)
	Percent -> "Percent",
	PPM -> "PartsPerMillion",
	PPB -> "PartsPerBillion",
	Dozen -> "Dozens",
	Gross -> "Grosses",

	(* angle *)
	Radian -> "Radians",
	AngularDegree -> "AngularDegrees",

	(* energy *)
	ElectronVolt -> "Electronvolts",

	(* magnets *)
	Tesla -> "Teslas",

	(* force *)
	Newton -> "Newtons",
	Millinewton -> "Millinewtons",

	(* torque *)
	PoundFoot -> ("PoundsForce" * "Feet"),

	InternationalUnit -> "InternationalUnits",
	MilliAbsorbanceUnit -> "Milli" * IndependentUnit["AbsorbanceUnit"],
	AbsorbanceUnit -> IndependentUnit["AbsorbanceUnit"], (* can't make this plural, because then dimensions are ambiguous with their AbsorbanceUnits *)
	ArbitraryUnit -> IndependentUnit["ArbitraryUnits"],
	Nucleotide -> IndependentUnit["Nucleotides"],
	BasePair -> IndependentUnit["Basepairs"],
	LSU -> IndependentUnit["Lsus"],
	RFU -> IndependentUnit["Rfus"],
	RefractiveIndexUnit -> IndependentUnit["RefractiveIndexUnits"],
	RLU -> IndependentUnit["Rlus"],
	AnisotropyUnit -> IndependentUnit["AnisotropyUnits"],
	MilliPolarizationUnit -> "Milli" * IndependentUnit["PolarizationUnits"],
	PolarizationUnit -> IndependentUnit["PolarizationUnits"],
	Pixel -> IndependentUnit["Pixels"],
	Cycle -> IndependentUnit["Cycles"],
	WeightVolumePercent -> IndependentUnit["WeightVolumePercent"],
	VolumePercent -> IndependentUnit["VolumePercent"],
	PercentConfluency -> IndependentUnit["PercentConfluency"],
	MassPercent -> IndependentUnit["MassPercent"],
	ISO -> IndependentUnit["ISO"],
	RRT -> IndependentUnit["RRT"],
	Event -> IndependentUnit["Events"],
	EmeraldCell -> IndependentUnit["Cells"],
	Particle -> IndependentUnit["Particles"],
	CFU -> IndependentUnit["Cfus"],
	Colony -> IndependentUnit["Colonies"],
	OD600 -> IndependentUnit["OD600s"],
	RelativeNephelometricUnit -> IndependentUnit["RelativeNephelometricUnits"],
	NephelometricTurbidityUnit -> IndependentUnit["NephelometricTurbidityUnits"],
	FormazinNephelometricUnit -> IndependentUnit["FormazinTurbidityUnits"],
	FormazinTurbidityUnit -> IndependentUnit["FormazinTurbidityUnits"]
];


(* ::Subsubsection::Closed:: *)
(*emeraldUnitLookup*)


(* An association that maps from the canonical unit to the emerald unit (both as strings for easier Hold-ing) *)
emeraldUnitLookup=<|
	"Unities" -> "Unit",
	"Kelvins" -> "Kelvin",
	"PureUnities" -> "NoUnit",
	"Grams" -> "Gram",
	"Pounds" -> "Pound",
	"ShortTons" -> "Ton",
	"Ounces" -> "Ounce",
	"Stones" -> "Stone",
	("Grams") / ("Moles") -> "Dalton",
	"Molar" -> "Molar",
	"Siemens" -> "Siemens",
	"USDollars" -> "USD",
	"CaloriesThermochemical" -> "Calorie",
	"Amperes" -> "Ampere",
	"Joules" -> "Joule",
	"Hertz" -> "Hertz",
	"Watts" -> "Watt",
	"Ohms" -> "Ohm",
	"Volts" -> "Volt",
	"Moles" -> "Mole",
	"Revolutions" -> "Revolution",
	"Lumens" -> "Lumen",
	"DegreesCelsius" -> "Celsius",
	"Kelvin" -> "Kelvin",
	"DegreesFahrenheit" -> "Fahrenheit",
	"Pascals" -> "Pascal",
	("PoundsForce") / ("Inches")^2 -> "PSI",
	("Lumens") / ("Feet")^2 -> "Lux",
	"Bars" -> "Bar",
	"Torr" -> "Torr",
	"MillimetersOfMercury" -> "MillimeterMercury",
	"Atmospheres" -> "Atmosphere",
	"Seconds" -> "Second",
	"Minutes" -> "Minute",
	"Hours" -> "Hour",
	"Days" -> "Day",
	"Weeks" -> "Week",
	"Months" -> "Month",
	"Years" -> "Year",
	"Decades" -> "Decade",
	"Centuries" -> "Century",
	"Millennia" -> "Millennium",
	"Meters" -> "Meter",
	"Feet" -> "Foot",
	"Inches" -> "Inch",
	"Micrometers" -> "Micron",
	"Centimeters" -> "Centimeter",
	"Angstroms" -> "Angstrom",
	"Yards" -> "Yard",
	"Miles" -> "Mile",
	"Liters" -> "Liter",
	"Gallons" -> "Gallon",
	"FluidOunces" -> "FluidOunce",
	"Quarts" -> "Quart",
	"Pints" -> "Pint",
	"Cups" -> "Cup",
	"Poise" -> "Poise",
	("Revolutions") / ("Minutes") -> "RPM",
	"StandardAccelerationOfGravity" -> "GravitationalAcceleration",
	"Percent" -> "Percent",
	"PartsPerMillion" -> "PPM",
	"PartsPerBillion" -> "PPB",
	"Dozens" -> "Dozen",
	"Grosses" -> "Gross",
	"Electronvolts" -> "ElectronVolt",
	"Newtons" -> "Newton",
	"InternationalUnits" -> "InternationalUnit",
	"Milli" * IndependentUnit["AbsorbanceUnit"] -> "MilliAbsorbanceUnit",
	IndependentUnit["AbsorbanceUnit"] -> "AbsorbanceUnit",
	IndependentUnit["ArbitraryUnits"] -> "ArbitraryUnit",
	IndependentUnit["Nucleotides"] -> "Nucleotide",
	IndependentUnit["Basepairs"] -> "BasePair",
	IndependentUnit["Lsus"] -> "LSU",
	IndependentUnit["Rfus"] -> "RFU",
	IndependentUnit["Rlus"] -> "RLU",
	"Milli" * IndependentUnit["AnisotropyUnits"] -> "MilliAnisotropyUnit",
	IndependentUnit["AnisotropyUnits"] -> "AnisotropyUnit",
	"Milli" * IndependentUnit["PolarizationUnits"] -> "MilliPolarizationUnit",
	IndependentUnit["PolarizationUnits"] -> "PolarizationUnit",
	IndependentUnit["Pixels"] -> "Pixel",
	IndependentUnit["Cycles"] -> "Cycle",
	IndependentUnit["WeightVolumePercent"] -> "WeightVolumePercent",
	IndependentUnit["VolumePercent"] -> "VolumePercent",
	IndependentUnit["PercentConfluency"] -> "PercentConfluency",
	IndependentUnit["MassPercent"] -> "MassPercent",
	IndependentUnit["ISO"] -> "ISO",
	IndependentUnit["RRT"] -> "RRT",
	IndependentUnit["Events"] -> "Event",
	"AngularDegrees" -> "AngularDegree",
	"Teslas" -> "Tesla",
	"Radians" -> "Radian",
	("Milliliters") / ("Minutes") -> "Milliliter/Minute",
	IndependentUnit["Cells"] -> "EmeraldCell",
	IndependentUnit["Particles"] -> "Particle",
	IndependentUnit["Cfus"] -> "CFU",
	IndependentUnit["Colonies"] -> "Colony",
	IndependentUnit["OD600s"] -> "OD600",
	IndependentUnit["RelativeNephelometricUnits"] -> "RelativeNephelometricUnit",
	IndependentUnit["NephelometricTurbidityUnits"] -> "NephelometricTurbidityUnit",
	IndependentUnit["FormazinTurbidityUnits"] -> "FormazinTurbidityUnit"
|>;


(* ::Subsubsection::Closed:: *)
(*canonicalPrefixedUnitLookup*)


(* code to generate list below *)
(*
prefixes = ToString/@MetricPrefixes;
baseUnits =Cases[EmeraldUnits`Private`canonicalUnitLookup[[;;,2]],_String];
prefixedUnit[{p_,u_}]:=StringJoin[p,ToLowerCase[StringTake[u,1]],StringTake[u,2;;]];
allPrefixUnitCombinations=Tuples[{prefixes,baseUnits}];
unitTable = Map[{#[[1]],#[[2]],prefixedUnit[#],KnownUnitQ[Evaluate[prefixedUnit[#]]]}&,allPrefixUnitCombinations];
knownUnits=Cases[unitTable,{_,_,u_,True}\[RuleDelayed]u];
prefixedUnitsLookup=Map[With[{stringName=If[StringTake[#,-1]==="s",StringTake[#,1;;-2],#]},Rule[Symbol[stringName],#]]&,knownUnits];
*)
(*
Dalton units generated separately because ours do not match mathematica's
Map[
  Symbol[# <> "dalton"] -> ((# <> "grams")/"Moles") &,
  ToString /@ MetricPrefixes
  ] // InputForm
*)
canonicalPrefixedUnitLookup=Hold[
	Yottagram -> "Yottagrams", Yottamolar -> "Yottamolar", Yottasiemen -> "Yottasiemens", Yottaampere -> "Yottaamperes",
	Yottajoule -> "Yottajoules", Yottahertz -> "Yottahertz", Yottawatt -> "Yottawatts", Yottaohm -> "Yottaohms",
	Yottavolt -> "Yottavolts", Yottamole -> "Yottamoles", Yottalumen -> "Yottalumens", Yottapascal -> "Yottapascals",
	Yottasecond -> "Yottaseconds", Yottameter -> "Yottameters", Yottaliter -> "Yottaliters",
	Yottaelectronvolt -> "Yottaelectronvolts", Zettagram -> "Zettagrams", Zettamolar -> "Zettamolar", Zettasiemen -> "Zettasiemens",
	Zettaampere -> "Zettaamperes", Zettajoule -> "Zettajoules", Zettahertz -> "Zettahertz", Zettawatt -> "Zettawatts",
	Zettaohm -> "Zettaohms", Zettavolt -> "Zettavolts", Zettamole -> "Zettamoles", Zettalumen -> "Zettalumens",
	Zettapascal -> "Zettapascals", Zettasecond -> "Zettaseconds", Zettameter -> "Zettameters", Zettaliter -> "Zettaliters",
	Zettaelectronvolt -> "Zettaelectronvolts", Exagram -> "Exagrams", Examolar -> "Examolar", Exasiemen -> "Exasiemens",
	Exaampere -> "Exaamperes", Exajoule -> "Exajoules", Exahertz -> "Exahertz", Exawatt -> "Exawatts", Exaohm -> "Exaohms",
	Exavolt -> "Exavolts", Examole -> "Examoles", Exalumen -> "Exalumens", Exapascal -> "Exapascals",
	Exasecond -> "Exaseconds", Exayear -> "Exayears", Exameter -> "Exameters", Exaliter -> "Exaliters",
	Exaelectronvolt -> "Exaelectronvolts", Petagram -> "Petagrams", Petamolar -> "Petamolar", Petasiemen -> "Petasiemens",
	Petaampere -> "Petaamperes", Petajoule -> "Petajoules", Petahertz -> "Petahertz", Petawatt -> "Petawatts",
	Petaohm -> "Petaohms", Petavolt -> "Petavolts", Petamole -> "Petamoles", Petalumen -> "Petalumens",
	Petapascal -> "Petapascals", Petasecond -> "Petaseconds", Petayear -> "Petayears", Petameter -> "Petameters",
	Petaliter -> "Petaliters", Petaelectronvolt -> "Petaelectronvolts", Teragram -> "Teragrams", Teramolar -> "Teramolar",
	Terasiemen -> "Terasiemens", Teraampere -> "Teraamperes", Terajoule -> "Terajoules", Terahertz -> "Terahertz",
	Terawatt -> "Terawatts", Teraohm -> "Teraohms", Teravolt -> "Teravolts", Teramole -> "Teramoles",
	Teralumen -> "Teralumens", Terapascal -> "Terapascals", Terasecond -> "Teraseconds", Terayear -> "Terayears",
	Terameter -> "Terameters", Teraangstrom -> "Teraangstroms", Teraliter -> "Teraliters", Teraelectronvolt -> "Teraelectronvolts",
	Gigagram -> "Gigagrams", Gigamolar -> "Gigamolar", Gigasiemen -> "Gigasiemens", Gigaampere -> "Gigaamperes",
	Gigajoule -> "Gigajoules", Gigahertz -> "Gigahertz", Gigawatt -> "Gigawatts", Gigaohm -> "Gigaohms",
	Gigavolt -> "Gigavolts", Gigamole -> "Gigamoles", Gigalumen -> "Gigalumens", Gigapascal -> "Gigapascals",
	Gigaatmosphere -> "Gigaatmospheres", Gigasecond -> "Gigaseconds", Gigayear -> "Gigayears", Gigameter -> "Gigameters",
	Gigaliter -> "Gigaliters", Gigaelectronvolt -> "Gigaelectronvolts", Megagram -> "Megagrams", Megamolar -> "Megamolar",
	Megasiemen -> "Megasiemens", MegacaloriesThermochemical -> "MegacaloriesThermochemical",
	Megaampere -> "Megaamperes", Megajoule -> "Megajoules", Megahertz -> "Megahertz", Megawatt -> "Megawatts",
	Megaohm -> "Megaohms", Megavolt -> "Megavolts", Megamole -> "Megamoles", Megalumen -> "Megalumens",
	Megapascal -> "Megapascals", Megabar -> "Megabars", Megaatmosphere -> "Megaatmospheres", Megasecond -> "Megaseconds",
	Megayear -> "Megayears", Megameter -> "Megameters", Megaliter -> "Megaliters", Megaelectronvolt -> "Megaelectronvolts",
	Kilogram -> "Kilograms", Kilopound -> "Kilopounds", Kilomolar -> "Kilomolar", Kilosiemen -> "Kilosiemens",
	KilocaloriesThermochemical -> "KilocaloriesThermochemical", Kiloampere -> "Kiloamperes", Kilojoule -> "Kilojoules",
	Kilohertz -> "Kilohertz", Kilowatt -> "Kilowatts", Kiloohm -> "Kiloohms", Kilovolt -> "Kilovolts",
	Kilomole -> "Kilomoles", Kilorevolution -> "Kilorevolutions", Kilolumen -> "Kilolumens", Kilopascal -> "Kilopascals",
	Kilobar -> "Kilobars", Kiloatmosphere -> "Kiloatmospheres", Kilosecond -> "Kiloseconds", Kiloyear -> "Kiloyears",
	Kilometer -> "Kilometers", Kilofeet -> "Kilofeet", Kiloangstrom -> "Kiloangstroms", Kiloyard -> "Kiloyards",
	Kiloliter -> "Kiloliters", Kiloelectronvolt -> "Kiloelectronvolts", Milligram -> "Milligrams", Milliounce -> "Milliounces",
	Millimolar -> "Millimolar", Millisiemen -> "Millisiemens", Milliampere -> "Milliamperes", Millijoule -> "Millijoules",
	Millihertz -> "Millihertz", Milliwatt -> "Milliwatts",
	Milliohm -> "Milliohms", Millivolt -> "Millivolts", Millimole -> "Millimoles", Millilumen -> "Millilumens",
	Millipascal -> "Millipascals", Millibar -> "Millibars", Millitorr -> "Millitorr", Milliatmosphere -> "Milliatmospheres",
	Millisecond -> "Milliseconds", Milliday -> "Millidays", Millimeter -> "Millimeters", Millimicron -> "Millimicrons",
	Millicentimeter -> "Millicentimeters", Milliangstrom -> "Milliangstroms", Milliyard -> "Milliyards",
	Milliliter -> "Milliliters", Millielectronvolt -> "Millielectronvolts", Microgram -> "Micrograms",
	Micropound -> "Micropounds", Micromolar -> "Micromolar", Microsiemen -> "Microsiemens", Microampere -> "Microamperes",
	Microjoule -> "Microjoules", Microhertz -> "Microhertz", Microwatt -> "Microwatts", Microohm -> "Microohms",
	Microvolt -> "Microvolts", Micromole -> "Micromoles", Microlumen -> "Microlumens",
	MicrodegreesCelsius -> "MicrodegreesCelsius", Micropascal -> "Micropascals", Microbar -> "Microbars",
	Microatmosphere -> "Microatmospheres", Microsecond -> "Microseconds", Microday -> "Microdays", Microcenturie -> "Microcenturies",
	Micrometer -> "Micrometers", Microinche -> "Microinches", Microliter -> "Microliters",
	Microelectronvolt -> "Microelectronvolts", Nanogram -> "Nanograms", Nanomolar -> "Nanomolar", Nanosiemen -> "Nanosiemens",
	Nanoampere -> "Nanoamperes", Nanojoule -> "Nanojoules", Nanohertz -> "Nanohertz", Nanowatt -> "Nanowatts",
	Nanoohm -> "Nanoohms", Nanovolt -> "Nanovolts", Nanomole -> "Nanomoles", Nanolumen -> "Nanolumens",
	Nanopascal -> "Nanopascals", Nanobar -> "Nanobars", Nanosecond -> "Nanoseconds", Nanocenturie -> "Nanocenturies",
	Nanometer -> "Nanometers", Nanoliter -> "Nanoliters", Nanoelectronvolt -> "Nanoelectronvolts", Picogram -> "Picograms",
	Picomolar -> "Picomolar", Picosiemen -> "Picosiemens", Picoampere -> "Picoamperes", Picojoule -> "Picojoules",
	Picohertz -> "Picohertz", Picowatt -> "Picowatts", Picoohm -> "Picoohms", Picovolt -> "Picovolts",
	Picomole -> "Picomoles", Picolumen -> "Picolumens", Picopascal -> "Picopascals", Picosecond -> "Picoseconds",
	Picometer -> "Picometers", Picomile -> "Picomiles", Picoliter -> "Picoliters", Picoelectronvolt -> "Picoelectronvolts",
	Femtogram -> "Femtograms", Femtomolar -> "Femtomolar", Femtosiemen -> "Femtosiemens", Femtoampere -> "Femtoamperes",
	Femtojoule -> "Femtojoules", Femtohertz -> "Femtohertz", Femtowatt -> "Femtowatts", Femtoohm -> "Femtoohms",
	Femtovolt -> "Femtovolts", Femtomole -> "Femtomoles", Femtolumen -> "Femtolumens", Femtopascal -> "Femtopascals",
	Femtosecond -> "Femtoseconds", Femtometer -> "Femtometers", Femtoliter -> "Femtoliters", Attogram -> "Attograms",
	Attomolar -> "Attomolar", Attosiemen -> "Attosiemens", Attoampere -> "Attoamperes", Attojoule -> "Attojoules",
	Attohertz -> "Attohertz", Attowatt -> "Attowatts", Attoohm -> "Attoohms", Attovolt -> "Attovolts",
	Attomole -> "Attomoles", Attolumen -> "Attolumens", Attopascal -> "Attopascals", Attosecond -> "Attoseconds",
	Attometer -> "Attometers", Attoliter -> "Attoliters", Zeptogram -> "Zeptograms", Zeptomolar -> "Zeptomolar",
	Zeptosiemen -> "Zeptosiemens", Zeptoampere -> "Zeptoamperes", Zeptojoule -> "Zeptojoules", Zeptohertz -> "Zeptohertz",
	Zeptowatt -> "Zeptowatts", Zeptoohm -> "Zeptoohms", Zeptovolt -> "Zeptovolts", Zeptomole -> "Zeptomoles",
	Zeptolumen -> "Zeptolumens", Zeptopascal -> "Zeptopascals", Zeptosecond -> "Zeptoseconds", Zeptometer -> "Zeptometers",
	Zeptoliter -> "Zeptoliters", Yoctogram -> "Yoctograms", Yoctomolar -> "Yoctomolar", Yoctosiemen -> "Yoctosiemens",
	Yoctoampere -> "Yoctoamperes", Yoctojoule -> "Yoctojoules", Yoctohertz -> "Yoctohertz", Yoctowatt -> "Yoctowatts",
	Yoctoohm -> "Yoctoohms", Yoctovolt -> "Yoctovolts", Yoctomole -> "Yoctomoles", Yoctopascal -> "Yoctopascals",
	Yoctosecond -> "Yoctoseconds", Yoctometer -> "Yoctometers", Yoctoliter -> "Yoctoliters", Millipoise -> "Millipoise", Micropoise -> "Micropoise",
	Centipoise -> "Centipoise", Yottadalton -> "Yottagrams" / "Moles", Zettadalton -> "Zettagrams" / "Moles",
	Exadalton -> "Exagrams" / "Moles", Petadalton -> "Petagrams" / "Moles", Teradalton -> "Teragrams" / "Moles",
	Gigadalton -> "Gigagrams" / "Moles", Megadalton -> "Megagrams" / "Moles", Kilodalton -> "Kilograms" / "Moles",
	Millidalton -> "Milligrams" / "Moles", Microdalton -> "Micrograms" / "Moles", Nanodalton -> "Nanograms" / "Moles",
	Picodalton -> "Picograms" / "Moles", Femtodalton -> "Femtograms" / "Moles", Attodalton -> "Attograms" / "Moles",
	Zeptodalton -> "Zeptograms" / "Moles", Yoctodalton -> "Yoctograms" / "Moles"
];


(* ::Subsubsection::Closed:: *)
(*emeraldPrefixedUnitLookup*)


(* This is an association since we don't need to hold b/c everything is a string. *)
(* Converts a QuantityUnit[...] into the emerald symbol of that symbol. *)
emeraldPrefixedUnitLookup=<|
	"Yottaohms" -> "Yottaohm", "Yottavolts" -> "Yottavolt", "Yottamoles" -> "Yottamole", "Yottalumens" -> "Yottalumen", "Yottapascals" -> "Yottapascal", "Yottaseconds" -> "Yottasecond", "Yottameters" -> "Yottameter",
	"Yottaliters" -> "Yottaliter", "Yottaelectronvolts" -> "Yottaelectronvolt", "Yottanewtons" -> "Yottanewton", "Zettagrams" -> "Zettagram", "Zettamolar" -> "Zettamolar", "Zettasiemens" -> "Zettasiemen",
	"Zettaamperes" -> "Zettaampere", "Zettajoules" -> "Zettajoule", "Zettahertz" -> "Zettahertz", "Zettawatts" -> "Zettawatt", "Zettaohms" -> "Zettaohm", "Zettavolts" -> "Zettavolt", "Zettamoles" -> "Zettamole",
	"Zettalumens" -> "Zettalumen", "Zettapascals" -> "Zettapascal", "Zettaseconds" -> "Zettasecond", "Zettameters" -> "Zettameter", "Zettaliters" -> "Zettaliter", "Zettaelectronvolts" -> "Zettaelectronvolt",
	"Zettanewtons" -> "Zettanewton", "Exagrams" -> "Exagram", "Examolar" -> "Examolar", "Exasiemens" -> "Exasiemen", "Exaamperes" -> "Exaampere", "Exajoules" -> "Exajoule", "Exahertz" -> "Exahertz", "Exawatts" -> "Exawatt",
	"Exaohms" -> "Exaohm", "Exavolts" -> "Exavolt", "Examoles" -> "Examole", "Exalumens" -> "Exalumen", "Exapascals" -> "Exapascal", "Exaseconds" -> "Exasecond", "Exayears" -> "Exayear", "Exameters" -> "Exameter",
	"Exaliters" -> "Exaliter", "Exaelectronvolts" -> "Exaelectronvolt", "Exanewtons" -> "Exanewton", "Petagrams" -> "Petagram", "Petamolar" -> "Petamolar", "Petasiemens" -> "Petasiemen", "Petaamperes" -> "Petaampere",
	"Petajoules" -> "Petajoule", "Petahertz" -> "Petahertz", "Petawatts" -> "Petawatt", "Petaohms" -> "Petaohm", "Petavolts" -> "Petavolt", "Petamoles" -> "Petamole", "Petalumens" -> "Petalumen", "Petapascals" -> "Petapascal",
	"Petaseconds" -> "Petasecond", "Petayears" -> "Petayear", "Petameters" -> "Petameter", "Petaliters" -> "Petaliter", "Petaelectronvolts" -> "Petaelectronvolt", "Petanewtons" -> "Petanewton", "Teragrams" -> "Teragram",
	"Teramolar" -> "Teramolar", "Terasiemens" -> "Terasiemen", "Teraamperes" -> "Teraampere", "Terajoules" -> "Terajoule", "Terahertz" -> "Terahertz", "Terawatts" -> "Terawatt", "Teraohms" -> "Teraohm", "Teravolts" -> "Teravolt",
	"Teramoles" -> "Teramole", "Teralumens" -> "Teralumen", "Terapascals" -> "Terapascal", "Teraseconds" -> "Terasecond", "Terayears" -> "Terayear", "Terameters" -> "Terameter", "Teraangstroms" -> "Teraangstrom", "Teraliters" -> "Teraliter",
	"Teraelectronvolts" -> "Teraelectronvolt", "Teranewtons" -> "Teranewton", "Gigagrams" -> "Gigagram", "Gigamolar" -> "Gigamolar", "Gigasiemens" -> "Gigasiemen", "Gigaamperes" -> "Gigaampere", "Gigajoules" -> "Gigajoule",
	"Gigahertz" -> "Gigahertz", "Gigawatts" -> "Gigawatt", "Gigaohms" -> "Gigaohm", "Gigavolts" -> "Gigavolt", "Gigamoles" -> "Gigamole", "Gigalumens" -> "Gigalumen", "Gigapascals" -> "Gigapascal", "Gigaatmospheres" -> "Gigaatmosphere",
	"Gigaseconds" -> "Gigasecond", "Gigayears" -> "Gigayear", "Gigameters" -> "Gigameter", "Gigaliters" -> "Gigaliter", "Gigaelectronvolts" -> "Gigaelectronvolt", "Giganewtons" -> "Giganewton", "Megagrams" -> "Megagram",
	"Megamolar" -> "Megamolar", "Megasiemens" -> "Megasiemen", "MegacaloriesThermochemical" -> "MegacaloriesThermochemical", "Megaamperes" -> "Megaampere", "Megajoules" -> "Megajoule", "Megahertz" -> "Megahertz",
	"Megawatts" -> "Megawatt", "Megaohms" -> "Megaohm", "Megavolts" -> "Megavolt", "Megamoles" -> "Megamole", "Megalumens" -> "Megalumen", "Megapascals" -> "Megapascal", "Megabars" -> "Megabar", "Megaatmospheres" -> "Megaatmosphere",
	"Megaseconds" -> "Megasecond", "Megayears" -> "Megayear", "Megameters" -> "Megameter", "Megaliters" -> "Megaliter", "Megaelectronvolts" -> "Megaelectronvolt", "Meganewtons" -> "Meganewton", "Kilograms" -> "Kilogram",
	"Kilopounds" -> "Kilopound", "Kilomolar" -> "Kilomolar", "Kilosiemens" -> "Kilosiemen", "KilocaloriesThermochemical" -> "KilocaloriesThermochemical", "Kiloamperes" -> "Kiloampere", "Kilojoules" -> "Kilojoule",
	"Kilohertz" -> "Kilohertz", "Kilowatts" -> "Kilowatt", "Kiloohms" -> "Kiloohm", "Kilovolts" -> "Kilovolt", "Kilomoles" -> "Kilomole", "Kilorevolutions" -> "Kilorevolution", "Kilolumens" -> "Kilolumen", "Kilopascals" -> "Kilopascal",
	"Kilobars" -> "Kilobar", "Kiloatmospheres" -> "Kiloatmosphere", "Kiloseconds" -> "Kilosecond", "Kiloyears" -> "Kiloyear", "Kilometers" -> "Kilometer", "Kilofeet" -> "Kilofeet", "Kiloangstroms" -> "Kiloangstrom", "Kiloyards" -> "Kiloyard",
	"Kiloliters" -> "Kiloliter", "Kiloelectronvolts" -> "Kiloelectronvolt", "Kilonewtons" -> "Kilonewton", "Milligrams" -> "Milligram", "Milliounces" -> "Milliounce", "Millimolar" -> "Millimolar", "Millisiemens" -> "Millisiemen",
	"Milliamperes" -> "Milliampere", "Millijoules" -> "Millijoule", "Millihertz" -> "Millihertz", "Milliwatts" -> "Milliwatt", "Milliohms" -> "Milliohm",
	"Millivolts" -> "Millivolt", "Millimoles" -> "Millimole", "Millilumens" -> "Millilumen", "Millipascals" -> "Millipascal", "Millibars" -> "Millibar", "Millitorr" -> "Millitorr", "Milliatmospheres" -> "Milliatmosphere",
	"Milliseconds" -> "Millisecond", "Millidays" -> "Milliday", "Millimeters" -> "Millimeter", "Millimicrometers" -> "Millimicrometer", "Millicentimeters" -> "Millicentimeter", "Milliangstroms" -> "Milliangstrom",
	"Milliyards" -> "Milliyard", "Milliliters" -> "Milliliter", "Millinewtons" -> "Millinewton", "Millielectronvolts" -> "Millielectronvolt", "Millinewtons" -> "Millinewton", "Micrograms" -> "Microgram", "Micropounds" -> "Micropound", "Micromolar" -> "Micromolar",
	"Microsiemens" -> "Microsiemen", "Microamperes" -> "Microampere", "Microjoules" -> "Microjoule", "Microhertz" -> "Microhertz", "Microwatts" -> "Microwatt", "Microohms" -> "Microohm", "Microvolts" -> "Microvolt",
	"Micromoles" -> "Micromole", "Microlumens" -> "Microlumen", "MicrodegreesCelsius" -> "MicrodegreesCelsiu", "Micropascals" -> "Micropascal", "Microbars" -> "Microbar", "Microatmospheres" -> "Microatmosphere",
	"Microseconds" -> "Microsecond", "Microdays" -> "Microday", "Microcenturies" -> "Microcenturie", "Micrometers" -> "Micrometer", "Microinches" -> "Microinche", "Microliters" -> "Microliter", "Microelectronvolts" -> "Microelectronvolt",
	"Micronewtons" -> "Micronewton", "Nanograms" -> "Nanogram", "Nanomolar" -> "Nanomolar", "Nanosiemens" -> "Nanosiemen", "Nanoamperes" -> "Nanoampere", "Nanojoules" -> "Nanojoule", "Nanohertz" -> "Nanohertz",
	"Nanowatts" -> "Nanowatt", "Nanoohms" -> "Nanoohm", "Nanovolts" -> "Nanovolt", "Nanomoles" -> "Nanomole", "Nanolumens" -> "Nanolumen", "Nanopascals" -> "Nanopascal", "Nanobars" -> "Nanobar", "Nanoseconds" -> "Nanosecond",
	"Nanocenturies" -> "Nanocenturie", "Nanometers" -> "Nanometer", "Nanoliters" -> "Nanoliter", "Nanoelectronvolts" -> "Nanoelectronvolt", "Nanonewtons" -> "Nanonewton", "Picograms" -> "Picogram", "Picomolar" -> "Picomolar",
	"Picosiemens" -> "Picosiemen", "Picoamperes" -> "Picoampere", "Picojoules" -> "Picojoule", "Picohertz" -> "Picohertz", "Picowatts" -> "Picowatt", "Picoohms" -> "Picoohm", "Picovolts" -> "Picovolt", "Picomoles" -> "Picomole",
	"Picolumens" -> "Picolumen", "Picopascals" -> "Picopascal", "Picoseconds" -> "Picosecond", "Picometers" -> "Picometer", "Picomiles" -> "Picomile", "Picoliters" -> "Picoliter", "Picoelectronvolts" -> "Picoelectronvolt",
	"Piconewtons" -> "Piconewton", "Femtograms" -> "Femtogram", "Femtomolar" -> "Femtomolar", "Femtosiemens" -> "Femtosiemen", "Femtoamperes" -> "Femtoampere", "Femtojoules" -> "Femtojoule", "Femtohertz" -> "Femtohertz",
	"Femtowatts" -> "Femtowatt", "Femtoohms" -> "Femtoohm", "Femtovolts" -> "Femtovolt", "Femtomoles" -> "Femtomole", "Femtolumens" -> "Femtolumen", "Femtopascals" -> "Femtopascal", "Femtoseconds" -> "Femtosecond",
	"Femtometers" -> "Femtometer", "Femtoliters" -> "Femtoliter", "Femtonewtons" -> "Femtonewton", "Attograms" -> "Attogram", "Attomolar" -> "Attomolar", "Attosiemens" -> "Attosiemen", "Attoamperes" -> "Attoampere",
	"Attojoules" -> "Attojoule", "Attohertz" -> "Attohertz", "Attowatts" -> "Attowatt", "Attoohms" -> "Attoohm", "Attovolts" -> "Attovolt", "Attomoles" -> "Attomole", "Attolumens" -> "Attolumen", "Attopascals" -> "Attopascal",
	"Attoseconds" -> "Attosecond", "Attometers" -> "Attometer", "Attoliters" -> "Attoliter", "Attonewtons" -> "Attonewton", "Zeptograms" -> "Zeptogram", "Zeptomolar" -> "Zeptomolar", "Zeptosiemens" -> "Zeptosiemen",
	"Zeptoamperes" -> "Zeptoampere", "Zeptojoules" -> "Zeptojoule", "Zeptohertz" -> "Zeptohertz", "Zeptowatts" -> "Zeptowatt", "Zeptoohms" -> "Zeptoohm", "Zeptovolts" -> "Zeptovolt", "Zeptomoles" -> "Zeptomole",
	"Zeptolumens" -> "Zeptolumen", "Zeptopascals" -> "Zeptopascal", "Zeptoseconds" -> "Zeptosecond", "Zeptometers" -> "Zeptometer", "Zeptoliters" -> "Zeptoliter", "Zeptonewtons" -> "Zeptonewton", "Yoctograms" -> "Yoctogram",
	"Yoctomolar" -> "Yoctomolar", "Yoctosiemens" -> "Yoctosiemen", "Yoctoamperes" -> "Yoctoampere", "Yoctojoules" -> "Yoctojoule", "Yoctohertz" -> "Yoctohertz", "Yoctowatts" -> "Yoctowatt", "Yoctoohms" -> "Yoctoohm",
	"Yoctovolts" -> "Yoctovolt", "Yoctomoles" -> "Yoctomole", "Yoctopascals" -> "Yoctopascal", "Yoctoseconds" -> "Yoctosecond", "Yoctometers" -> "Yoctometer", "Yoctoliters" -> "Yoctoliter", "Yoctonewtons" -> "Yoctonewton",
	"Millipoise" -> "Millipoise", "Micropoise" -> "Micropoise", "Centipoise" -> "Centipoise",
	"Yottagrams" / "Moles" -> "Yottadalton", "Zettagrams" / "Moles" -> "Zettadalton", "Exagrams" / "Moles" -> "Exadalton",
	"Petagrams" / "Moles" -> "Petadalton", "Teragrams" / "Moles" -> "Teradalton", "Gigagrams" / "Moles" -> "Gigadalton",
	"Megagrams" / "Moles" -> "Megadalton", "Kilograms" / "Moles" -> "Kilodalton", "Milligrams" / "Moles" -> "Millidalton",
	"Micrograms" / "Moles" -> "Microdalton", "Nanograms" / "Moles" -> "Nanodalton", "Picograms" / "Moles" -> "Picodalton",
	"Femtograms" / "Moles" -> "Femtodalton", "Attograms" / "Moles" -> "Attodalton", "Zeptograms" / "Moles" -> "Zeptodalton",
	"Yoctograms" / "Moles" -> "Yoctodalton", ("Grams") / ("Moles") -> "Dalton"
|>;


(* ::Subsubsection::Closed:: *)
(*quantityUnitToEmeraldUnit Function*)


(* This function takes a quantity and give you the Emerald unit symbol (as a string) that corresponds to that Quantity. *)
(* Ex. quantityToEmeraldUnit[10*Foot]="Foot" *)
quantityToEmeraldUnit[myQuantity_]:=Module[{quantityUnitToEmeraldUnitAssociation, quantityUnit},
	(* Join together our two associations to create the full association *)
	quantityUnitToEmeraldUnitAssociation=Join[emeraldUnitLookup, emeraldPrefixedUnitLookup];

	(* Convert our quantity into a QuantityUnit *)
	quantityUnit=QuantityUnit[myQuantity];

	(* See if this quantity unit exists in our association. If it doesn't, simply return its units as a string *)
	If[
		KeyExistsQ[quantityUnitToEmeraldUnitAssociation, quantityUnit],
		(* This Quantity exists in our Association, simply look it up. *)
		quantityUnitToEmeraldUnitAssociation[quantityUnit],
		(* This Quantity does not exist in our Association, return its InputForm as a string. *)
		ToString[InputForm[myQuantity/.quantity_Quantity:>QuantityUnit[quantity]]]
	]
];

SetAttributes[quantityToEmeraldUnit, Listable];


(* ::Subsubsection::Closed:: *)
(*quantityToSymbol Function*)


quantityToSymbol[myQuantity_Quantity]:=ToString[QuantityMagnitude[myQuantity]]<>" "<>quantityToEmeraldUnit[myQuantity];
quantityToSymbol[myInput_List]:=myInput /. {quantity_Quantity :> quantityToSymbol[quantity]};
quantityToSymbol[myInput_]:=ToString[myInput];


(* ::Subsubsection::Closed:: *)
(*canonicalUnitTypeLookup*)


canonicalUnitTypeLookup={
	"AmountUnit" -> "Moles",
	"AngleUnit" -> "Radians",
	"ElectricCurrentUnit" -> "Amperes",
	"InformationUnit" -> "Bytes",
	"LengthUnit" -> "Meters",
	"LuminousIntensityUnit" -> "Candelas",
	"MassUnit" -> "Grams",
	"MoneyUnit" -> "USDollars",
	"SolidAngleUnit" -> "Steradians",
	"TemperatureDifferenceUnit" -> "CelsiusDifference",
	"TemperatureUnit" -> "Celsius",
	"TimeUnit" -> "Seconds",
	other_String :> IndependentUnit[other]
};


(* ::Subsubsection::Closed:: *)
(*heldEmeraldUnitSymbols*)


heldEmeraldUnitSymbols=canonicalUnitLookup[[;;, 1]];


(* ::Subsubsection:: *)
(*unitDimensionLookup*)


legacyIndependentUnitDimension=If[$VersionNumber === 11.1, Identity, IndependentUnitDimension];

(*
		order matters here because this list is used backwards to go from dimension to unit
		The first entry for a dimenion is the one used for the inverse function
	*)
unitDimensionLookup:=Association[Map[Rule[Sort[First[#]], Last[#]]&, {
	{{"LengthUnit", 2}} -> "Area",
	{{"LengthUnit", 1}, {"TimeUnit", -1}} -> "Velocity",
	{{"AngleUnit", 1}, {"TimeUnit", -1}} -> "Angular Velocity",
	{{"RevolutionUnit", 1}, {"TimeUnit", -1}} -> "Frequency",
	{{"ElectricCurrentUnit", -2}, {"LengthUnit", 1}, {"MassUnit", 1}, {"TimeUnit", -3}} -> "Resistivity",
	{{"LengthUnit", 3}} -> "Volume",
	{{"AmountUnit", -1}, {"LengthUnit", 2}, {"MassUnit", 1}, {"TimeUnit", -2}} -> "Energy",
	{{"LengthUnit", 1}, {"MassUnit", 1}, {"TimeUnit", -2}} -> "Force",
	{{"TemperatureUnit", 1}} -> "Temperature",
	{{"AmountUnit", 1}, {"LengthUnit", -3}} -> "Concentration",
	{{"LengthUnit", -3}, {"MassUnit", 1}} -> "Concentration",
	{{"LengthUnit", 1}} -> "Distance",
	{{"LengthUnit", -1}} -> "Inverse Length",
	{{"TimeUnit", 1}} -> "Time",
	{{"LengthUnit", 2}, {"MassUnit", 1}, {"TimeUnit", -3}} -> "Power",
	{{"ElectricCurrentUnit", 1}} -> "Current",
	{{"ElectricCurrentUnit", -1}, {"LengthUnit", 2}, {"MassUnit", 1}, {"TimeUnit", -3}} -> "Voltage",
	{{"AmountUnit", 1}} -> "Amount",
	{{"AmountUnit", -1}, {"LengthUnit", 3}} -> "Per Molar",
	{{"MassUnit", 1}} -> "Mass",
	{{"LengthUnit", -3}, {"MassUnit", 1}} -> "Density",
	{{"LengthUnit", -1}, {"MassUnit", 1}, {"TimeUnit", -2}} -> "Pressure",
	{{"TimeUnit", -1}} -> "Frequency",
	{{"LengthUnit", 3}, {"TimeUnit", -1}} -> "Flow Rate",
	{{"ElectricCurrentUnit", 2}, {"LengthUnit", -3}, {"MassUnit", -1}, {"TimeUnit", 3}} -> "Conductance",
	UnitDimensions["Lumen"] -> "Luminescence",
	{{"LengthUnit", -1}, {"MassUnit", 1}, {"TimeUnit", -1}} -> "Viscosity",
	{{"AmountUnit", -1}, {"LengthUnit", 2}} -> "Extinction Coefficient",
	{{"LengthUnit", 2}, {"MassUnit", -1}} -> "Mass Extinction Coefficient",
	{{"AmountUnit", -1}, {"LengthUnit", 2}, {"MassUnit", 1}, {"TemperatureUnit", -1}, {"TimeUnit", -2}} -> "BindingEntropy",
	{{"AmountUnit", 1}, {"MassUnit", -1}} -> "Inverse Mol. Weight",
	{{"AmountUnit", -1}, {"MassUnit", 1}} -> "Mol. Weight",
	{{"AmountUnit", -1}, {legacyIndependentUnitDimension["ArbitraryUnits"], 1}, {"MassUnit", 1}} -> "Weight Strength",
	{{"AmountUnit", 1}, {legacyIndependentUnitDimension["ArbitraryUnits"], 1}, {"MassUnit", -1}} -> "Strength Per Weight",
	{{"LengthUnit", 1}, {"TimeUnit", -2}} -> "Acceleration",
	{{"ElectricCurrentUnit", 1}, {"TimeUnit", 1}} -> "Charge",
	{{"BiologicUnit", 1}} -> "Biologic Amount",
	(* below all rely on IndependentUnit in some way *)
	{{legacyIndependentUnitDimension["AbsorbanceUnit"], 1}} -> "Absorbance",
	{{legacyIndependentUnitDimension["ArbitraryUnits"], 1}} -> "Absorbance",
	{{legacyIndependentUnitDimension["ArbitraryUnits"], 1}, {"LengthUnit", 1}} -> "Absorbance Distance",
	{{legacyIndependentUnitDimension["ArbitraryUnits"], 1}, {"LengthUnit", -1}} -> "Absorbance Per Distance",
	{{legacyIndependentUnitDimension["ArbitraryUnits"], 1}, {"TimeUnit", -1}} -> "Absorbance Rate",
	{{legacyIndependentUnitDimension["ArbitraryUnits"], 1}, {"TimeUnit", 1}} -> "Absorbance Area",
	{{legacyIndependentUnitDimension["Nucleotides"], 1}} -> "Strand Length",
	{{legacyIndependentUnitDimension["Basepairs"], 1}} -> "Strand Length",
	{{legacyIndependentUnitDimension["ArbitraryUnits"], 1}} -> "Arbitrary Unit",
	{{legacyIndependentUnitDimension["Rfus"], 1}} -> "Fluorescence",
	{{legacyIndependentUnitDimension["RefractiveIndexUnits"], 1}} -> "Refractive Index",
	{{legacyIndependentUnitDimension["Lsus"], 1}} -> "Scattering Intensity",
	{{legacyIndependentUnitDimension["Rlus"], 1}} -> "Relative Luminescence",
	{{legacyIndependentUnitDimension["Event"], 1}} -> "Events",
	{{"LengthUnit", 1}, {legacyIndependentUnitDimension["Rfus"], 1}} -> "Fluorescence Area",
	{{"LengthUnit", -1}, {legacyIndependentUnitDimension["Rfus"], 1}} -> "Fluorescence Per Area",
	{{legacyIndependentUnitDimension["Rfus"], 1}, {"TimeUnit", 1}} -> "Fluorescence Time",
	{{legacyIndependentUnitDimension["Cycles"], 1}} -> "Cycles",
	{{legacyIndependentUnitDimension["WeightVolumePercent"], 1}} -> "WeightVolumePercent",
	{{legacyIndependentUnitDimension["MassPercent"], 1}} -> "MassPercent",
	{{legacyIndependentUnitDimension["VolumePercent"], 1}} -> "VolumePercent",
	{{legacyIndependentUnitDimension["PercentConfluency"], 1}} -> "PercentConfluency",
	{{legacyIndependentUnitDimension["EmeraldCredits"], 1}} -> "EmeraldCredits",
	{{legacyIndependentUnitDimension["Pixels"], 1}} -> "Distance",
	{{legacyIndependentUnitDimension["RRT"], 1}} -> "Relative Migration Time",
	{{legacyIndependentUnitDimension["Cells"], 1}} -> "Amount",
	{{legacyIndependentUnitDimension["Cells"], 1}, {"LengthUnit", -3}} -> "CellConcentration",
	{{legacyIndependentUnitDimension["Particles"], 1}} -> "ParticleCount",
	{{legacyIndependentUnitDimension["Particles"], 1}, {"LengthUnit", -3}} -> "ParticleConcentration",
	{{legacyIndependentUnitDimension["Cfus"], 1}} -> "CFU",
	{{legacyIndependentUnitDimension["Cfus"], 1}, {"LengthUnit", -3}} -> "CFUConcentration",
	{{legacyIndependentUnitDimension["Colonies"], 1}} -> "Colony",
	{{legacyIndependentUnitDimension["OD600s"], 1}} -> "OD600",
	{{legacyIndependentUnitDimension["RelativeNephelometricUnits"], 1}} -> "Turbidity",
	{{legacyIndependentUnitDimension["NephelometricTurbidityUnits"], 1}} -> "Turbidity",
	{{legacyIndependentUnitDimension["FormazinTurbidityUnits"], 1}} -> "Turbidity"
}]];



(* ::Subsubsection::Closed:: *)
(*metricPrefixLookup*)


metricPrefixLookup[]:={
	Yotta -> 10^24,
	Zetta -> 10^21,
	Exa -> 10^18,
	Peta -> 10^15,
	Tera -> 10^12,
	Giga -> 10^9,
	Mega -> 10^6,
	Kilo -> 10^3,
	Hecto -> 10^2,
	Deka -> 10^1,
	(*1\[Rule]10^0,*)
	Deci -> 10^-1,
	Centi -> 10^-2,
	Milli -> 10^-3,
	Micro -> 10^-6,
	Nano -> 10^-9,
	Pico -> 10^-12,
	Femto -> 10^-15,
	Atto -> 10^-18,
	Zepto -> 10^-21,
	Yocto -> 10^-24
};


(* ::Subsubsection::Closed:: *)
(*MetricPrefixesFull*)


Unprotect[MetricPrefixesFull];
MetricPrefixesFull=metricPrefixLookup[][[;;, 1]];
Protect[MetricPrefixesFull];




(* ::Subsubsection::Closed:: *)
(*MetricPrefixes*)


(* Prefixes where exponent is divisible by 3 *)
Unprotect[MetricPrefixes];
MetricPrefixes=Select[
	metricPrefixLookup[],
	Mod[Log10[#[[2]]], 3] === 0&
][[;;, 1]];
Protect[MetricPrefixes];



(* ::Subsubsection::Closed:: *)
(*Assign OwnValues to emerald unit symbols*)


(* Assign OwnValues to old unit symbols *)
setUnitSymbols[]:=MapThread[
	Module[{},
		Unprotect[#1];
		Set[#1, Quantity[1, #2]];
	]&,
	Transpose[List @@ List @@@ canonicalUnitLookup]
];

(* prefixed unit symbols *)
setPrefixedUnitSymbols[]:=MapThread[
	Module[{},
		Unprotect[#1];
		Set[#1, Quantity[1, #2]];
	]&,
	Transpose[List @@ List @@@ canonicalPrefixedUnitLookup]
];


(* ::Subsubsection::Closed:: *)
(*mergeUnitPrefix*)


baseUnitList=canonicalUnitLookup[[;;, 2]];
baseUnitQ=Function[un, MemberQ[baseUnitList, un]];


mergeUnitPrefix::UnknownResultantUnit="Unit `1` is not known.  This was created by merging unit `2` with prefix `3`";
mergeUnitPrefix[prefix_, q_Quantity]:=mergeUnitPrefix[prefix, QuantityMagnitude[q], QuantityUnit[q]];
mergeUnitPrefix[prefix_, val_, un_]:=With[
	{
		newUnit=mergeUnitPrefixSomewhere[prefix, un],
		stringPrefix=ToString[prefix]
	},
	If[!knownUnitQ[newUnit],
		Quantity[val, stringPrefix * un],
		Quantity[val, newUnit]
	]
];

mergeUnitPrefixUnit[prefix_, un_String]:=StringJoin[SymbolName[prefix], ToLowerCase[StringTake[un, 1]], StringTake[un, 2;;]];
mergeUnitPrefixUnit[prefix_, Times[s_String, rest_]]:=Times[mergeUnitPrefixUnit[prefix, s], rest];
knownUnitQ[x_]:=knownUnitQ[x]=KnownUnitQ[x];
(* MM12.2+ stops recognizing Celius.  older versions recognize both *)
knownUnitQ["Celsius"]=True;

nonMergeP="USDollars";
mergeableP=Except[nonMergeP, _String?baseUnitQ];
mergeUnitPrefixSomewhere[prefix_, Times[s:mergeableP, rest__]]:=With[
	{newUnit=mergeUnitPrefixUnit[prefix, s]},
	If[knownUnitQ[newUnit],
		newUnit * Times[rest],
		s * mergeUnitPrefixSomewhere[prefix, Times[rest]];
	]
];
mergeUnitPrefixSomewhere[prefix_, s_String?baseUnitQ]:=With[
	{newUnit=mergeUnitPrefixUnit[prefix, s]},
	If[knownUnitQ[newUnit],
		newUnit,
		s * Replace[prefix, metricPrefixLookup[]]
	]
];
mergeUnitPrefixSomewhere[prefix_, Times[pow:Power[s:mergeableP, -1], other__]]:=other * mergeUnitPrefixSomewhere[prefix, pow];
mergeUnitPrefixSomewhere[prefix_, Power[s:mergeableP, -1]]:=With[
	{inversePrefix=Lookup[Map[Reverse, metricPrefixLookup[]], 1 / Lookup[metricPrefixLookup[], prefix]]},

	With[
		{newUnit=mergeUnitPrefixUnit[inversePrefix, s]},
		If[knownUnitQ[newUnit],
			1 / newUnit,
			1 / s * Replace[prefix, metricPrefixLookup[]]
		]
	]
];
mergeUnitPrefixSomewhere[prefix_, Times[other_, rest__]]:=other * mergeUnitPrefixSomewhere[prefix, Times[rest]];
mergeUnitPrefixSomewhere[prefix_, other_]:=other * Replace[prefix, metricPrefixLookup[]];



(* ::Subsubsection::Closed:: *)
(*defineMetricPrefixUpValuesOnQ*)


(* ::Text:: *)
(*Can define these only on _Quantity since unit symbols have OwnValues and evaluate immediately*)


defineMetricPrefixUpValuesOnQ[2]:=Map[
	Function[
		prefix,
		TagSetDelayed[
			prefix,
			Times[prefix, q1_Quantity, q2_Quantity, rest___],
			mergeUnitPrefix[prefix, q1 * q2] * rest
		]
	],
	MetricPrefixesFull
];

defineMetricPrefixUpValuesOnQ[1]:=Map[
	Function[
		prefix,
		TagSetDelayed[
			prefix,
			Times[prefix, q_Quantity],
			mergeUnitPrefix[prefix, q]
		]
	],
	MetricPrefixesFull
];



(* ::Subsubsection::Closed:: *)
(*make Quantity[_,_Quantity] work*)


overloadQuantityOfQuantity[]:=Module[{},
	Unprotect[Quantity];
	Quantity[val_, q_Quantity]:=With[{mag=val * QuantityMagnitude[q], un=QuantityUnit[q]}, Quantity[mag, un]];

	(* this stopped working in MM12, so now have to do it ourselves *)
	If[$VersionNumber >= 12.0,
		Quantity[q_Quantity]:=q;
	];

	Protect[Quantity];
];



(* ::Subsubsection::Closed:: *)
(*make Quantity * stringUnit simplify*)


overloadQuantityTimesStringUnit[]:=Module[{},
	Unprotect[Quantity];
	Quantity/:Times[s_?knownUnitQ, q_Quantity]:=q * Quantity[1, s];
	Protect[Quantity];
];



(* ::Subsubsection::Closed:: *)
(*make Quantity * infinity work *)


overloadQuantityTimesInfinity[]:=Module[{},
	Unprotect[Quantity];
	Quantity/:Times[Infinity, q_Quantity]:=Quantity[Infinity, QuantityUnit[q]];
	Quantity/:Times[-Infinity, q_Quantity]:=Quantity[-Infinity, QuantityUnit[q]];
	Protect[Quantity];
];



(* ::Subsubsection::Closed:: *)
(*make QuantityArray[_,_Quantity] work*)


(*
	Allows mixtures of _Quantity, string unit specifications, and 'None'.
	'None' gets replaced by PureUnities
*)
overloadQuantityArrayOfQuantity[]:=Module[{},
	Unprotect[QuantityArray];
	PrependTo[
		DownValues[QuantityArray],
		HoldPattern[QuantityArray[mags_, uns_?(MatchQ[Flatten[{#1}], Except[{_String..}, {(_Quantity | None | _String | 1)..}]]&)]] :> With[
			{newUns=ReplaceAll[uns, {q_Quantity :> QuantityUnit[q], (None | 1) -> "DimensionlessUnit"}]},
			QuantityArray[mags, newUns]
		]
	];
	Protect[QuantityArray];
];


(* ::Subsubsection::Closed:: *)
(*make temperature comparisons work correctly*)


(* must force these to the top of the definition list *)
overloadQuantityComparisonsTemperature[]:=Module[{},
	Unprotect[Quantity];
	With[
		{temperatureStringUnitP="DegreesCelsius" | "DegreesFahrenheit" | "Kelvins" | "Celsius"},
		UpValues[Quantity]=Join[
			{
				HoldPattern[(h:Greater)[q1:Quantity[_, temperatureStringUnitP], q2:Quantity[_, temperatureStringUnitP]]] :> h[QuantityMagnitude[UnitConvert[q1, "Kelvins"]], QuantityMagnitude[UnitConvert[q2, "Kelvins"]]],
				HoldPattern[(h:Less)[q1:Quantity[_, temperatureStringUnitP], q2:Quantity[_, temperatureStringUnitP]]] :> h[QuantityMagnitude[UnitConvert[q1, "Kelvins"]], QuantityMagnitude[UnitConvert[q2, "Kelvins"]]],
				HoldPattern[(h:GreaterEqual)[q1:Quantity[_, temperatureStringUnitP], q2:Quantity[_, temperatureStringUnitP]]] :> h[QuantityMagnitude[UnitConvert[q1, "Kelvins"]], QuantityMagnitude[UnitConvert[q2, "Kelvins"]]],
				HoldPattern[(h:LessEqual)[q1:Quantity[_, temperatureStringUnitP], q2:Quantity[_, temperatureStringUnitP]]] :> h[QuantityMagnitude[UnitConvert[q1, "Kelvins"]], QuantityMagnitude[UnitConvert[q2, "Kelvins"]]],
				HoldPattern[(h:Equal)[q1:Quantity[_, temperatureStringUnitP], q2:Quantity[_, temperatureStringUnitP]]] :> h[QuantityMagnitude[UnitConvert[q1, "Kelvins"]], QuantityMagnitude[UnitConvert[q2, "Kelvins"]]]
			},
			UpValues[Quantity]
		];
		Protect[Quantity];
	]
];


OnLoad[
	(*
		MM 13.2 allows 
			Dozen > 50  [1]
		but not 
			50 < Dozen  [2]
		To get around this, we add overloads to comparison functions
		that match on first arugment being numeric and second being quantity,
		then  we just flip the sign and swap the arguments,
		turning [2] into [1]
	*)
	If[$VersionNumber > 13.0,
		Quantity[1,"Meters"]; (* make sure its defs are loaded, otherwise it will erase our changes later *)
		Unprotect[Quantity];
		Quantity /: Greater[x_?NumericQ,y_Quantity] := Less[y,x];
		Quantity /: Less[x_?NumericQ,y_Quantity] := Greater[y,x];
		Quantity /: GreaterEqual[x_?NumericQ,y_Quantity] := LessEqual[y,x];
		Quantity /: LessEqual[x_?NumericQ,y_Quantity] := GreaterEqual[y,x];
		Protect[Quantity];
	];
];

(* ::Subsubsection::Closed:: *)
(*make dimensionless * dimensionless work correctly*)


(*
	These shenanigans are to fix the bug introduced in 11.0 that causes Numeric*DimensionlessQuantity to convert to numeric always,
		and DimensionslessQuantity*DimensionlessQuantity to error.
	Remove this stuff after they fix these bugs in MM 11.?
*)
fixDimensionlessQuantityMultiplication[]:=Module[{},
	(* fixed in V12 *)
	If[$VersionNumber < 12,
		With[
			{
				dimensionslessQuantityP=_Quantity?(MatchQ[UnitDimensions[#], {}]&),
				metricPrefP=Alternatives @@ (Core`Private`metricPrefixLookup[][[;;, 1]])
			},
			Unprotect[Quantity];
			UpValues[Quantity]=Join[
				{
					HoldPattern[(q1:dimensionslessQuantityP) * (q2:dimensionslessQuantityP)] :> UnitConvert[q1, "DimensionlessUnit"] * UnitConvert[q2, "DimensionlessUnit"],
					HoldPattern[(q:dimensionslessQuantityP) * num_?NumericQ] :> Quantity[num * QuantityMagnitude[q], Evaluate[QuantityUnit[q]]],
					HoldPattern[(q:dimensionslessQuantityP) * pref:metricPrefP] :> Quantity[QuantityMagnitude[q], QuantityUnit[q] * Evaluate[ToString[pref]]]
				},
				UpValues[Quantity]
			];
			Protect[Quantity];
		]
	];
];



(* ::Subsubsection::Closed:: *)
(*freeUnitFrameBox Overwriting*)


unitShorthandRules=<|
	"AbsorbanceUnit" -> "AU",
	"ArbitraryUnits" -> "Arb.",
	"Nucleotide" -> "nt",
	"Basepairs" -> "bp",
	"Lsus" -> "LSU",
	"Rfus" -> "RFU",
	"Rlus" -> "RLU",
	"AnisotropyUnit" -> "A",
	"PolarizationUnit" -> "P",
	"Cfus" -> "CFU"
|>;

overloadQuantityFreeUnitFrameBox[]:=Module[{},
	QuantityUnits`Private`freeUnitFrameBox[unitName:Alternatives @@ Keys[unitShorthandRules]]:=With[
		{unitTranslation=unitShorthandRules[unitName]},
		FrameBox[
			StyleBox[
				MakeBoxes[unitTranslation],
				ShowStringCharacters -> False
			],
			FrameMargins -> 1,
			FrameStyle -> GrayLevel[0.85`],
			BaselinePosition -> Baseline,
			RoundingRadius -> 3,
			StripOnInput -> False
		]
	]
];


(* ::Subsubsection::Closed:: *)
(* assign UpValues to Cell to use as a unit *)


overloadCellUnit[]:=Module[{},
	Unprotect[Cell];
	Cell/:Times[x_, Cell]:=x * Quantity[1, EmeraldCell];
	Cell/:Power[Cell, n_]:=Power[Quantity[1, EmeraldCell], n];
	Protect[Cell];
];


(* ::Subsubsection::Closed:: *)
(*installEmeraldUnits*)


installEmeraldUnits[]:=Module[{},

	List @@ (ClearAll /@ heldEmeraldUnitSymbols);
	List @@ (ClearAll /@ canonicalPrefixedUnitLookup[[;;, 1]]);
	ClearAll /@ MetricPrefixesFull;

	overloadQuantityFreeUnitFrameBox[];

	setUnitSymbols[];

	setPrefixedUnitSymbols[];

	defineMetricPrefixUpValuesOnQ[2];
	defineMetricPrefixUpValuesOnQ[1];
	overloadQuantityOfQuantity[];
	overloadQuantityTimesStringUnit[];
	overloadQuantityTimesInfinity[];
	overloadQuantityComparisonsTemperature[];
	(* remove this after they fix this bug in MM 11.? *)
	fixDimensionlessQuantityMultiplication[];

	(* QA stuff *)
	overloadQuantityArrayOfQuantity[];

	(* set Cell UpValues *)
	overloadCellUnit[];
];


(* ::Subsubsection::Closed:: *)
(*run installation*)


(* ::Text:: *)
(*This must happen before the rest of the file because those definition patterns rely on the assigned symbols set here*)


installEmeraldUnits[];
OnLoad[installEmeraldUnits[]];



(* ::Subsection::Closed:: *)
(*Unit Array helpers*)


(* ::Subsubsection::Closed:: *)
(*compatibleUnitArraysQ*)


(*
	Check if two arrays of units match in size and unit dimension at all levels
*)
compatibleUnitArraysQ[unitSpecA_, unitSpecB_]:=With[
	{
		dimsA=UnitDimension[unitSpecA],
		dimsB=UnitDimension[unitSpecB]
	},
	And[
		SameQ[Dimensions[dimsA], Dimensions[dimsB]],
		MatchQ[dimsA, dimsB]
	]
];


(* ::Subsubsection::Closed:: *)
(*compatibleQuantityArraysQ*)


(*
	Check if two QAs have the same size and unit dimensions at all levels
*)
compatibleQuantityArraysQ[qaA_, qaB_]:=With[
	{
		unsA=QuantityUnit[qaA],
		unsB=QuantityUnit[qaB]
	},
	And[
		SameQ[Dimensions[unsA], Dimensions[unsB]],
		compatibleUnitArraysQ[unsA, unsB]
	]
];


(* ::Subsubsection::Closed:: *)
(*subUnitArrayQ*)


subUnitArrayQ[bigUnitArray_, smallUnitArray_]:=
	subArrayQ[UnitDimensions[bigUnitArray], UnitDimensions[smallUnitArray]];


(* ::Subsubsection::Closed:: *)
(*subArrayQ*)


subArrayQ[bigArray_, smallArray_]:=With[
	{
		bigDims=Dimensions[bigArray],
		smallDims=Dimensions[smallArray]
	},
	And[
		MatchQ[bigDims, Prepend[smallDims, ___Integer]],
		MatchQ[bigArray, nestRepeatedPattern[smallArray, Length[bigDims] - Length[smallDims]]]
	]
];



(* ::Subsubsection::Closed:: *)
(*nestPattern*)


nestRepeatedPattern[p_, d_]:=Nest[{#..}&, p, d];


(* ::Subsection:: *)
(*Unit Type Groups*)


(* ::Subsubsection::Closed:: *)
(*TimeUnits*)


Unprotect[TimeUnits];
TimeUnits={Millennium, Century, Decade, Year, Month, Week, Day, Hour, Minute, Second};
timeUnitStrings=QuantityUnit /@ TimeUnits;
Protect[TimeUnits];


(* ::Subsubsection::Closed:: *)
(*TemperatureUnits*)


Unprotect[TemperatureUnits];
TemperatureUnits={Celsius, Centigrade, Fahrenheit, Kelvin};
Protect[TemperatureUnits];


(* ::Subsubsection::Closed:: *)
(*EnergyUnits*)


Unprotect[EnergyUnits];
EnergyUnits={Calorie / Mole, Joule / Mole};
Protect[EnergyUnits];


(* ::Subsubsection::Closed:: *)
(*DistanceUnits*)


Unprotect[DistanceUnits];
DistanceUnits={Meter, Angstrom, Foot, Yard, Inch, Mile};
Protect[DistanceUnits];


(* ::Subsubsection::Closed:: *)
(*volumeUnits*)


Unprotect[volumeUnits];
volumeUnits={Liter, Gallon, FluidOunce, Quart, Pint, Cup};
Protect[volumeUnits];


(* ::Subsubsection::Closed:: *)
(*massUnits*)


Unprotect[massUnits];
massUnits={Gram, Pound, Ounce, Stone, Ton};
Protect[massUnits];


(* ::Subsubsection::Closed:: *)
(*MolecularWeightUnits*)


Unprotect[MolecularWeightUnits];
MolecularWeightUnits={Gram / Mole, Dalton};
Protect[MolecularWeightUnits];


(* ::Subsubsection::Closed:: *)
(*PressureUnits*)


Unprotect[PressureUnits];
PressureUnits={PSI, Bar, Pascal, Torr};
Protect[PressureUnits];


(* ::Subsubsection::Closed:: *)
(*LightUnits*)


Unprotect[LightUnits];
LightUnits={Lux};
Protect[LightUnits];


(* ::Subsection:: *)
(*Unit Types & Patterns*)


(* ::Text:: *)
(*Need this section early in the file because they are used in definition patterns.*)


(* ::Subsubsection::Closed:: *)
(*KnownUnitP*)


(* ::Text:: *)
(*This is fast because knownUnitQ caches*)


KnownUnitP=_?knownUnitQ;


(* ::Subsubsection::Closed:: *)
(*stringUnitP*)

Authors[stringUnitP]:={"xu.yi"};
stringUnitP=_String | HoldPattern[Power[_String, _Integer]] | HoldPattern[Times[(_String | Power[_String, _Integer])..]];


(* ::Subsubsection::Closed:: *)
(*UnitDimensionP*)


knownUnitDimensions=Values[unitDimensionLookup];
unitDimensionQ[thing_String]:=MemberQ[knownUnitDimensions, thing];
UnitDimensionP=_String?unitDimensionQ;


(* ::Subsubsection::Closed:: *)
(*UnitsP*)


UnitsP[]:=(_?QuantityQ | _?NumericQ);

(* use With to evaluate dimensions once ahead of time, instead of every time the pattern is evaluated *)
UnitsP[qFixed:UnitsP[]]:=With[
	{udFixed=UnitDimensions[qFixed]},
	PatternTest[
		UnitsP[],
		Function[
			qTest,
			MatchQ[
				UnitDimensions[qTest],
				udFixed
			]
		]
	]
];

UnitsP[unitString_?knownUnitQ]:=With[
	{udFixed=UnitDimensions[Quantity[1, unitString]]},
	PatternTest[
		UnitsP[],
		Function[
			qTest,
			MatchQ[
				UnitDimensions[qTest],
				udFixed
			]
		]
	]
];

UnitsP[dimensionString:UnitDimensionP]:=With[
	{unitStringExpression=dimensionStringToUnitExpression[dimensionString]},
	UnitsP[Quantity[1, unitStringExpression]]
];

UnitsP[arg:(UnitsP[] | KnownUnitP | UnitDimensionP), increment_Quantity]:=With[
	{
		p=UnitsP[arg]
	},
	PatternTest[
		p,
		Function[qTest, MatchQ[Mod[qTest, increment], 0 * increment | 0. * increment]]
	]
];


(* ::Subsubsection::Closed:: *)
(*exactUnitP*)


exactUnitP[qs:{UnitsP[]..}]:=With[
	{uns=DeleteDuplicates[QuantityUnit[qs]]},
	PatternTest[_, Function[arg, MemberQ[uns, QuantityUnit[arg]]]]
];
exactUnitP[q:UnitsP[]]:=With[
	{un=QuantityUnit[q]},
	PatternTest[_, Function[arg, MatchQ[un, QuantityUnit[arg]]]]
];


(* ::Subsubsection::Closed:: *)
(*prefixedUnitP*)


prefixedUnitP[q:Quantity[mag_, 1 / s_String]]:=exactUnitP[Append[1 / (MetricPrefixes * 1 / q), q]];
prefixedUnitP[q:UnitsP[]]:=exactUnitP[Append[MetricPrefixes * q, q]];


(* ::Subsubsection::Closed:: *)
(*mergeMetricPrefix*)


mergeMetricPrefix[prefix_String, un_String]:=With[
	{merged=StringJoin[prefix, ToLowerCase[StringTake[un, 1]], StringTake[un, 2;;]]},
	If[KnownUnitQ[merged],
		merged,
		prefix * un
	]
];
mergeMetricPrefix[prefix_, un_]:=prefix * un;


(* ::Subsubsection::Closed:: *)
(*splitMetricPrefix*)


allMetricPrefixes={"Yotta", "Zetta", "Exa", "Peta", "Tera", "Giga", "Mega", "Kilo", "Hecto", "Deka", "Deci", "Centi", "Milli", "Micro", "Nano", "Pico", "Femto", "Atto", "Zepto", "Yocto"};

splitMetricPrefix[un_String]:=Module[{results},
	results=StringCases[un, (p:Alternatives @@ allMetricPrefixes)~~rest__ :> {p, StringJoin[ToUpperCase[StringTake[rest, 1]], StringTake[rest, 2;;]]}];
	Which[
		(* no prefix, return itself *)
		MatchQ[results, {}],
		{1, un},
		(* has a prefix and prefix-less thing is a unit *)
		knownUnitQ[results[[1, 2]]],
		First[results],
		(* looks like it has a prefix but remainder of string is not a unit (e.g. Microns) *)
		True,
		{1, un}
	]
];
splitMetricPrefix[Times[prefix:(Alternatives @@ allMetricPrefixes), unit_]]:={prefix, unit};
splitMetricPrefix[Power[unit_, exponent_]]:=With[{split=splitMetricPrefix[unit]}, {First[split], Last[split]^exponent}];
splitMetricPrefix[prefix:(Alternatives @@ allMetricPrefixes)]:={prefix, 1};
splitMetricPrefix[q_Quantity]:=With[{split=splitMetricPrefix[QuantityUnit[q]]}, {First[split], Quantity[Last[split]]}];
splitMetricPrefix[num_?NumericQ]:={1, 1};
splitMetricPrefix[un_]:={1, un};



(* ::Subsubsection::Closed:: *)
(*prefixedUnitQ*)


prefixedUnitQ[q_Quantity]:=prefixedUnitQ[QuantityUnit[q]];
prefixedUnitQ[un_String]:=StringMatchQ[un, Alternatives @@ allMetricPrefixes~~__];
prefixedUnitQ[prefix:(Alternatives @@ allMetricPrefixes)]:=True;
prefixedUnitQ[Times[prefix:(Alternatives @@ allMetricPrefixes), unit_]]:=True;
prefixedUnitQ[_]:=False;



(* ::Subsubsection::Closed:: *)
(*unitWithoutPrefix*)


(*unitWithoutPrefix[val_]:=Last[splitMetricPrefix[val]];*)


unitWithoutPrefix[num_?NumericQ]:=1;
unitWithoutPrefix[val_Quantity]:=Quantity[unitWithoutPrefix[QuantityUnit[val]]];
unitWithoutPrefix[unit_]:=ReplaceAll[unit, {
	s_String :> Last[splitMetricPrefix[s]],
	p:(allMetricPrefixes) :> 1
}];




(* ::Subsubsection::Closed:: *)
(*UnitsQ*)


UnitsQ[q:UnitsP[]]:=True;
UnitsQ[q1:UnitsP[], q2:UnitsP[]]:=compatibleUnitQold[q1, q2];
UnitsQ[_]:=False;
UnitsQ[_, _]:=False;
SetAttributes[UnitsQ, Listable];



(* ::Subsubsection::Closed:: *)
(*unitSpecItemP*)


unitSpecItemP=UnitsP[] | KnownUnitP | None;



(* ::Subsubsection::Closed:: *)
(*unitsArrayPatternQ*)

Authors[unitsArrayPatternQ]:={"scicomp", "brad"};

unitsArrayPatternQ[patt_List]:=nestedRepeatedUnitsMatchQ[patt];
unitsArrayPatternQ[_]:=False;
nestedRepeatedUnitsMatchQ[unitSpecItemP | {unitSpecItemP..}]:=True;
nestedRepeatedUnitsMatchQ[{Verbatim[Repeated][patt_, ___]}]:=nestedRepeatedUnitsMatchQ[patt];
nestedRepeatedUnitsMatchQ[_]:=False;


(* ::Subsubsection::Closed:: *)
(*QuantityArrayP*)


OnLoad[
	General::InvalidUnitPattern="Invalid unit pattern specification `1`"
];

Which[
	($VersionNumber > 13.1),
	(
		quantityArrayRawP = _QuantityArray;
		quantityArrayRawP1D = _QuantityArray?(Length[Dimensions[#]]===1&);
		quantityArrayRawP2D = _QuantityArray?(Length[Dimensions[#]]===2&);
		quantityArrayRawPCoordinates = _QuantityArray?(MatchQ[Dimensions[#],{_Integer,2}]&);
		quantityArrayRawPTriplets = _QuantityArray?(MatchQ[Dimensions[#],{_Integer,3}]&);
	),

	($VersionNumber > 12.0),
	(
		quantityArrayRawP=Verbatim[QuantityArray][Verbatim[StructuredArray`StructuredData][__]];
		quantityArrayRawP1D=Verbatim[QuantityArray][Verbatim[StructuredArray`StructuredData][{_Integer}, __]];
		quantityArrayRawP2D=Verbatim[QuantityArray][Verbatim[StructuredArray`StructuredData][{_Integer, _Integer}, __]];
		quantityArrayRawPCoordinates=Verbatim[QuantityArray][Verbatim[StructuredArray`StructuredData][{_Integer, 2}, __]];
		quantityArrayRawPTriplets=Verbatim[QuantityArray][Verbatim[StructuredArray`StructuredData][{_Integer, 3}, __]];
	),

	True,
	(
		quantityArrayRawP=Verbatim[StructuredArray][QuantityArray, _, _];
		quantityArrayRawP1D=Verbatim[StructuredArray][QuantityArray, {_Integer}, _];
		quantityArrayRawP2D=Verbatim[StructuredArray][QuantityArray, {_Integer, _Integer}, _];
		quantityArrayRawPCoordinates=Verbatim[StructuredArray][QuantityArray, {_Integer, 2}, _];
		quantityArrayRawPTriplets=Verbatim[StructuredArray][QuantityArray, {_Integer, 3}, _]
	)
];

QuantityArrayP[]=quantityArrayRawP;
QuantityArrayP[depth_Integer]:=(quantityArrayRawP)?(QuantityArrayQ[#, depth]&);
QuantityArrayP[unitSpec_?unitsArrayPatternQ]:=(quantityArrayRawP)?(QuantityArrayQ[#, unitSpec]&);
QuantityArrayP[badUnitSpec_]:=Message[QuantityArrayP::InvalidUnitPattern, badUnitSpec];



(* ::Subsubsection::Closed:: *)
(*compatibleQuantityArrayQ*)

Authors[compatibleQuantityArrayQ]:={"scicomp", "brad"};
compatibleQuantityArrayQ[qa:QuantityArrayP[], unitSpec_]:=With[
	{
		qaun=QuantityUnit[qa],
		unitListStrings=ReplaceAll[unitSpec, q_Quantity :> QuantityUnit[q]]
	},
	And[
		MatchQ[Dimensions[qaun], Prepend[Dimensions[unitListStrings], ___]],
		compareQExpandedDimensions[qaun, unitListStrings, compUnits]
	]
];
Authors[compatibleQuantityArrayQ]:={"scicomp", "brad"};
compatibleQuantityArrayQ[_, _]:=False;

compareQExpandedDimensions[val_, patt_, compQ_]:=With[
	{out=Catch[nestedComp[val, patt, compQ], "NestedComparison"]},
	If[MatchQ[out, False], False, True]
];

nestedComp[val_, patt_, compQ_]:=Which[
	compQ[val, patt],
	True,
	AtomQ[val],
	Throw[False, "NestedComparison"],
	True,
	Map[nestedComp[#, patt, compQ]&, val]
];


compUnits[first_, second_]:=Which[
	MatchQ[first, second],
	True,
	MatchQ[Dimensions[first], Dimensions[second]],
	And @@ MapThread[compatibleUnitQold, {Flatten[{first}], Flatten[{second}]}],
	True,
	False
];

(* tell if two quantites specified have the same units (not just compatible, but actually the same; thus, sameUnitsQ[25 Celsius, 200 Kelvin] would return False but sameUnitsQ[25 Celsius, -23 Celsius] would return True) *)
sameUnitsQ[args__]:=With[{allUnits = QuantityUnit /@ ToList[args]},
	If[MemberQ[allUnits, _QuantityUnit],
		False,
		SameQ @@ allUnits
	]
];

(* ::Subsubsection::Closed:: *)
(*QuantityArrayQ*)


QuantityArrayQ[qa:QuantityArrayP[], depth_Integer]:=MatchQ[ArrayDepth[qa], depth];

QuantityArrayQ[qa:QuantityArrayP[], qaUnitSpec:QuantityArrayP[]]:=QuantityArrayQ[qa, QuantityUnit[qaUnitSpec]];

(* with unit spec, which is used to define size of array *)
QuantityArrayQ[qa:QuantityArrayP[], unitPattern_]:=With[
	{
		qadims=Dimensions[qa],
		qaun=QuantityUnit[qa],
		unitPatternStrings=ReplaceAll[unitPattern, {q_Quantity :> QuantityUnit[q], None -> "DimensionlessUnit"}]
	},
	(* units are compatible *)
	Or[
		(* first check for exact match -- this is really fast *)
		MatchQ[qaun, unitPatternStrings],
		(* if that fails, check compatibility of every base element *)
		With[
			{unitPatternCompatibleP=ReplaceAll[unitPatternStrings, u:KnownUnitP :> (_?(compatibleUnitQold[#, u]&))]},
			MatchQ[qaun, unitPatternCompatibleP]
		]
	]
];


(*
	If MM 13.2, CompatbileUnitQ allows lists to be compatibile with singletons, which is a change in behavior.
	For now, to get back old behavior, return False if comparing list to singleton.
*)
If[$VersionNumber>13.1,
	(
		(* old CompatibleUnitQ worked on two non-lists, and worked on two lists *)
		compatibleUnitQold[x:Except[_List],y:Except[_List]] := CompatibleUnitQ[x,y];
		compatibleUnitQold[x_List,y_List] := CompatibleUnitQ[x,y];
		(* but did not work on one list and one singleton *)
		compatibleUnitQold[_List,Except[_List]] := False;
		compatibleUnitQold[Except[_List],_List] := False;
		(* anything else, leave alone *)
		compatibleUnitQold[else___] := CompatibleUnitQ[else];
	),
	(
		compatibleUnitQold[args___] := CompatibleUnitQ[args];
	)
];

(* QA with any unit spec and size *)
QuantityArrayQ[QuantityArrayP[]]:=True;

(* anything else is False *)
QuantityArrayQ[_]:=False;
QuantityArrayQ[_, _]:=False;


(* ::Subsubsection::Closed:: *)
(*QuantityCoordinatesQ*)

QuantityCoordinatesQ[qa:{{Quantity[_, xunit_], Quantity[_, yunit_]} ..}]:=True;
QuantityCoordinatesQ[qa:quantityArrayRawPCoordinates]:=True;
QuantityCoordinatesQ[qa:quantityArrayRawPCoordinates, {xunit:unitSpecItemP, yunit:unitSpecItemP}]:=QuantityArrayQ[qa, {{xunit, yunit}..}];
QuantityCoordinatesQ[_, {xunit:unitSpecItemP, yunit:unitSpecItemP}]:=False;

QuantityCoordinatesQ[_]:=False;



(* ::Subsubsection::Closed:: *)
(*QuantityCoordinatesP*)


QuantityCoordinatesP[{xunit:unitSpecItemP, yunit:unitSpecItemP}]:=_?(QuantityCoordinatesQ[#, {xunit, yunit}]&);
QuantityCoordinatesP[]:=_?QuantityCoordinatesQ;


(* ::Subsubsection::Closed:: *)
(*QuantityVectorQ*)


QuantityVectorQ[qa:quantityArrayRawP1D]:=True;
QuantityVectorQ[qa:quantityArrayRawP1D, unit:unitSpecItemP]:=Module[
	{unitStrings, ub},

	(* convert unit spec to mathematica's string unit represetnation *)
	unitStrings=ReplaceAll[unit, {q_Quantity :> QuantityUnit[q], None -> "DimensionlessUnit"}];

	(* UnitBlock - smallest representation of QA's units *)
	ub=qa["UnitBlock"];

	matrixUnitCheck[unitStrings, ub]

];
QuantityVectorQ[_, unit:unitSpecItemP]:=False;

QuantityVectorQ[_]:=False;



(* ::Subsubsection::Closed:: *)
(*QuantityMatrixQ*)


QuantityMatrixQ[qa:quantityArrayRawP2D]:=True;

QuantityMatrixQ[qa:quantityArrayRawP2D, units:ListableP[unitSpecItemP]]:=Module[
	{unitStrings, ub},

	(* convert unit spec to mathematica's string unit represetnation *)
	unitStrings=ReplaceAll[units, {q_Quantity :> QuantityUnit[q], None -> "DimensionlessUnit"}];

	(* UnitBlock - smallest representation of QA's units *)
	ub=qa["UnitBlock"];

	matrixUnitCheck[unitStrings, ub]

];


(*
	UnitSpec a singleton and UnitBlock a singleton
*)
matrixUnitCheck[unitSpec:Except[_List], unitBlock:Except[_List]]:=
	compatibleUnitQold[{unitSpec}, {unitBlock}];

(*
	UnitSpec a singleton and UnitBlock a vector
*)
matrixUnitCheck[unitSpec:Except[_List], unitBlock_?VectorQ]:=compatibleUnitQold[{unitSpec}, unitBlock];


(*
	UnitSpec a singleton and UnitBlock a matrix
*)
matrixUnitCheck[unitSpec:Except[_List], unitBlock_?MatrixQ]:=compatibleUnitQold[{unitSpec}, unitBlock];



(*
	UnitSpec a vector and UnitBlock a singleton
*)
matrixUnitCheck[unitSpec_?VectorQ, unitBlock:Except[_List]]:=
	compatibleUnitQold[unitSpec, {unitBlock}];


(*
	UnitSpec a vector and UnitBlock a vector
*)
(* unit block exactly matches unit spec *)
matrixUnitCheck[unitSpec_?VectorQ, unitSpec_?VectorQ]:=True;
(* size mismatch between block and spec *)
matrixUnitCheck[unitSpec_?VectorQ, unitBlock_?VectorQ]:=False/;Length[unitSpec] =!= Length[unitBlock];
(* otherwise check compatibility *)
matrixUnitCheck[unitSpec_?VectorQ, unitBlock_?VectorQ]:=
	AllTrue[Transpose[{unitSpec, unitBlock}], compatibleUnitQold];

(*
	UnitSpec a vector and UnitBlock a matrix
*)
(* size mismatch between block and spec *)
matrixUnitCheck[unitSpec_?VectorQ, unitBlock_?MatrixQ]:=False/;Last[Dimensions[unitBlock]] =!= Length[unitSpec];
(* otherwise check compatibility *)
matrixUnitCheck[unitSpec_?VectorQ, unitBlock_?MatrixQ]:=
	AllTrue[Range[Length[unitSpec]], compatibleUnitQold[{unitSpec[[#]]}, unitBlock[[;;, #]]]&];

(*
	UnitSpec a matrix and UnitBlock a singleton
*)
matrixUnitCheck[unitSpec_?MatrixQ, unitBlock:Except[_List]]:=compatibleUnitQold[unitSpec, {unitBlock}];


(*
	UnitSpec a matrix and UnitBlock a vector
*)
(* size mismatch between block and spec *)
matrixUnitCheck[unitSpec_?MatrixQ, unitBlock_?VectorQ]:=False/;Last[Dimensions[unitSpec]] =!= Length[unitBlock];
(* otherwise check compatibility *)
matrixUnitCheck[unitSpec_?MatrixQ, unitBlock_?VectorQ]:=
	AllTrue[Range[Length[unitBlock]], compatibleUnitQold[unitSpec[[;;, #]], {unitBlock[[#]]}]&];


(*
	UnitSpec a matrix and UnitBlock a matrix
*)
(* spec and block identical *)
matrixUnitCheck[unitSpec_?MatrixQ, unitSpec_?MatrixQ]:=True;
(* size mismatch between block and spec *)
matrixUnitCheck[unitSpec_?MatrixQ, unitBlock_?MatrixQ]:=False/;Dimensions[unitSpec] =!= Dimensions[unitBlock];
(* otherwise check compatibility *)
matrixUnitCheck[unitSpec_?MatrixQ, unitBlock_?MatrixQ]:=
	AllTrue[Range[Last[Dimensions[unitSpec]]], compatibleUnitQold[unitSpec[[;;, #]], unitBlock[[;;, #]]]&];






QuantityMatrixQ[_, (unitSpecItemP | {unitSpecItemP..})]:=False;

QuantityMatrixQ[_]:=False;



(* ::Subsubsection::Closed:: *)
(*QuantityMatrixP*)


QuantityMatrixP[units:{unitSpecItemP..}]:=_?(QuantityMatrixQ[#, units]&);
QuantityMatrixP[]:=_?QuantityMatrixQ;


(* ::Subsubsection:: *)
(*unitQDimensionLookup*)


unitQDimensionLookup[]:=Map[Rule[First[#], Sort[Last[#]]]&, {
	{DimensionlessP, DimensionlessQ} -> {},
	{AreaP, AreaQ} -> {{"LengthUnit", 2}},
	{SpeedP, SpeedQ} -> {{"LengthUnit", 1}, {"TimeUnit", -1}},
	If[$VersionNumber >= 12.0,
		{AngularVelocityP, AngularVelocityQ} -> {{"RevolutionUnit", 1}, {"TimeUnit", -1}},
		{AngularVelocityP, AngularVelocityQ} -> {{"AngleUnit", 1}, {"TimeUnit", -1}}
	],
	{ResistivityP, ResistivityQ} -> {{"ElectricCurrentUnit", -2}, {"LengthUnit", 3}, {"MassUnit", 1}, {"TimeUnit", -3}},
	{VolumeP, VolumeQ} -> {{"LengthUnit", 3}},
	{EnergyP, EnergyQ} -> {{"AmountUnit", -1}, {"LengthUnit", 2}, {"MassUnit", 1}, {"TimeUnit", -2}},
	{FirstOrderRateP, FirstOrderRateQ} -> {{"TimeUnit", -1}},
	{SecondOrderRateP, SecondOrderRateQ} -> {{"AmountUnit", -1}, {"LengthUnit", 3}, {"TimeUnit", -1}},
	{TemperatureP, TemperatureQ} -> {{"TemperatureUnit", 1}},
	{TemperatureRampRateP, TemperatureRampRateQ} -> {{"TemperatureUnit", 1}, {"TimeUnit", -1}},
	{ConcentrationP, ConcentrationQ} -> {{"AmountUnit", 1}, {"LengthUnit", -3}},
	{MassConcentrationP, MassConcentrationQ} -> {{"LengthUnit", -3}, {"MassUnit", 1}},
	{DistanceP, DistanceQ} -> {{"LengthUnit", 1}},
	{TimeP, TimeQ} -> {{"TimeUnit", 1}},
	{PowerP, PowerQ} -> {{"LengthUnit", 2}, {"MassUnit", 1}, {"TimeUnit", -3}},
	{CurrentP, CurrentQ} -> {{"ElectricCurrentUnit", 1}},
	{VoltageP, VoltageQ} -> {{"ElectricCurrentUnit", -1}, {"LengthUnit", 2}, {"MassUnit", 1}, {"TimeUnit", -3}},
	{AmountP, AmountQ} -> {{"AmountUnit", 1}},
	{PerMolarP, PerMolarQ} -> {{"AmountUnit", -1}, {"LengthUnit", 3}},
	{MassP, MassQ} -> {{"MassUnit", 1}},
	{DensityP, DensityQ} -> {{"LengthUnit", -3}, {"MassUnit", 1}},
	{PressureP, PressureQ} -> {{"LengthUnit", -1}, {"MassUnit", 1}, {"TimeUnit", -2}},
	{FrequencyP, FrequencyQ} -> {{"TimeUnit", -1}},
	{FlowRateP, FlowRateQ} -> {{"LengthUnit", 3}, {"TimeUnit", -1}},
	{ConductanceP, ConductanceQ} -> {{"ElectricCurrentUnit", 2}, {"LengthUnit", -3}, {"MassUnit", -1}, {"TimeUnit", 3}},
	{ConductanceAreaP, ConductanceAreaQ} -> {{"ElectricCurrentUnit", 2}, {"LengthUnit", -3}, {"MassUnit", -1}, {"TimeUnit", 4}},
	{ConductancePerTimeP, ConductancePerTimeQ} -> {{"ElectricCurrentUnit", 2}, {"LengthUnit", -3}, {"MassUnit", -1}, {"TimeUnit", 2}},
	{LuminescenceP, LuminescenceQ} -> UnitDimensions["Lumen"],
	{ViscosityP, ViscosityQ} -> {{"LengthUnit", -1}, {"MassUnit", 1}, {"TimeUnit", -1}},
	If[$VersionNumber >= 12.0,
		{RPMP, RPMQ} -> {{"RevolutionUnit", 1}, {"TimeUnit", -1}},
		{RPMP, RPMQ} -> {{"AngleUnit", 1}, {"TimeUnit", -1}}
	],
	{ByteP, ByteQ} -> {{"InformationUnit", 1}},
	{CurrencyP, CurrencyQ} -> {{"MoneyUnit", 1}},
	{EntropyP, EntropyQ} -> {{"AmountUnit", -1}, {"LengthUnit", 2}, {"MassUnit", 1}, {"TemperatureUnit", -1}, {"TimeUnit", -2}},
	{ExtinctionCoefficientP, ExtinctionCoefficientQ} -> {{"AmountUnit", -1}, {"LengthUnit", 2}},
	{MassExtinctionCoefficientP, MassExtinctionCoefficientQ} -> {{"LengthUnit", 2}, {"MassUnit", -1}},

	{MolecularWeightLuminescenceAreaP, MolecularWeightLuminescenceAreaQ} -> UnitDimensions["Grams" * "Lumens" / "Moles"],
	{MolecularWeightP, MolecularWeightQ} -> {{"AmountUnit", -1}, {"MassUnit", 1}},
	{MolecularWeightStrengthP, MolecularWeightStrengthQ} -> {{"AmountUnit", -1}, {legacyIndependentUnitDimension["ArbitraryUnits"], 1}, {"MassUnit", 1}},
	{StrengthPerMolecularWeightP, StrengthPerMolecularWeightQ} -> {{"AmountUnit", 1}, {legacyIndependentUnitDimension["ArbitraryUnits"], 1}, {"MassUnit", -1}},
	{InverseMolecularWeightP, InverseMolecularWeightQ} -> {{"AmountUnit", 1}, {"MassUnit", -1}},
	{LuminescencePerMolecularWeightP, LuminescencePerMolecularWeightQ} -> UnitDimensions["Moles" * "Lumens" / "Grams"],

	{AccelerationP, AccelerationQ} -> {{"LengthUnit", 1}, {"TimeUnit", -2}},

	(* below all rely on IndependentUnit in some way *)
	{AbsorbanceUnitP, AbsorbanceQ} -> {{legacyIndependentUnitDimension["AbsorbanceUnit"], 1}},
	{AbsorbanceDistanceP, AbsorbanceDistanceQ} -> {{legacyIndependentUnitDimension["AbsorbanceUnit"], 1}, {"LengthUnit", 1}},
	{AbsorbancePerDistanceP, AbsorbancePerDistanceQ} -> {{legacyIndependentUnitDimension["AbsorbanceUnit"], 1}, {"LengthUnit", -1}},
	{AbsorbanceRateP, AbsorbanceRateQ} -> {{legacyIndependentUnitDimension["AbsorbanceUnit"], 1}, {"TimeUnit", -1}},
	{AbsorbanceAreaP, AbsorbanceAreaQ} -> {{legacyIndependentUnitDimension["AbsorbanceUnit"], 1}, {"TimeUnit", 1}},
	{NucleotideP, NucleotideQ} -> {{legacyIndependentUnitDimension["Nucleotides"], 1}},
	{ArbitraryUnitP, ArbitraryUnitQ} -> {{legacyIndependentUnitDimension["ArbitraryUnits"], 1}},
	{BasePairP, BasePairQ} -> {{legacyIndependentUnitDimension["Basepairs"], 1}},
	{FluorescenceUnitP, FluorescenceQ} -> {{legacyIndependentUnitDimension["Rfus"], 1}},
	{FluorescenceAreaP, FluorescenceAreaQ} -> {{"LengthUnit", 1}, {legacyIndependentUnitDimension["Rfus"], 1}},
	{FluorescencePerAreaP, FluorescencePerAreaQ} -> {{"LengthUnit", -1}, {legacyIndependentUnitDimension["Rfus"], 1}},
	{FluorescenceTimeP, FluorescenceTimeQ} -> {{legacyIndependentUnitDimension["Rfus"], 1}, {"TimeUnit", 1}},
	{TimeOfFlightAreaP, TimeOfFlightAreaQ} -> {{legacyIndependentUnitDimension["ArbitraryUnits"], 1}, {"TimeUnit", 1}},
	{PixelP, PixelQ} -> {{legacyIndependentUnitDimension["Pixels"], 1}},
	{PixelAreaP, PixelAreaQ} -> {{legacyIndependentUnitDimension["Pixels"], 2}},
	{PixelsPerDistanceP, PixelsPerDistanceQ} -> {{"LengthUnit", -1}, {legacyIndependentUnitDimension["Pixels"], 1}},
	{ChemicalShiftP, ChemicalShiftQ} -> {},
	{CycleP, CycleQ} -> {{legacyIndependentUnitDimension["Cycles"], 1}},
	{ChemicalShiftStrengthP, ChemicalShiftStrengthQ} -> {{legacyIndependentUnitDimension["ArbitraryUnits"], 1}},
	{StrengthPerChemicalShiftP, StrengthPerChemicalShiftQ} -> {{legacyIndependentUnitDimension["ArbitraryUnits"], 1}},
	{ISOP, ISOQ} -> {{legacyIndependentUnitDimension["ISO"], 1}},
	{RRTP, RRTQ} -> {{legacyIndependentUnitDimension["RRT"], 1}},
	{PercentP, PercentQ} -> {},
	{PercentRateP, PercentRateQ} -> {{"TimeUnit", -1}},
	{MassPercentP, MassPercentQ} -> {{legacyIndependentUnitDimension["MassPercent"], 1}},
	{VolumePercentP, VolumePercentQ} -> {{legacyIndependentUnitDimension["VolumePercent"], 1}},
	{PercentConfluencyP, PercentConfluencyQ} -> {{legacyIndependentUnitDimension["PercentConfluency"], 1}},
	{WeightVolumePercentP, WeightVolumePercentQ} -> {{legacyIndependentUnitDimension["WeightVolumePercent"], 1}},
	{NoUnitP, NoUnitQ} -> {},
	{CellConcentrationP, CellConcentrationQ} -> {{legacyIndependentUnitDimension["Cells"], 1}, {"LengthUnit", -3}},
	{ParticleCountP, ParticleCountQ} -> {{legacyIndependentUnitDimension["Particles"], 1}},
	{ParticleConcentrationP, ParticleConcentrationQ} -> {{legacyIndependentUnitDimension["Particles"], 1}, {"LengthUnit", -3}},
	{CFUP, CFUQ} -> {{legacyIndependentUnitDimension["Cfus"], 1}},
	{ColonyCountP, ColonyCountQ} -> {{legacyIndependentUnitDimension["Colonies"], 1}},
	{CFUConcentrationP, CFUConcentrationQ} -> {{legacyIndependentUnitDimension["Cfus"], 1}, {"LengthUnit", -3}},
	{OD600P, OD600Q} -> {{legacyIndependentUnitDimension["OD600s"], 1}},
	{RelativeNephelometricUnitP,RelativeNephelometricUnitQ} -> {{legacyIndependentUnitDimension["RelativeNephelometricUnits"], 1}},
	{NephelometricTurbidityUnitP,NephelometricTurbidityUnitQ} -> {{legacyIndependentUnitDimension["NephelometricTurbidityUnits"], 1}},
	{FormazinTurbidityUnitP,FormazinTurbidityUnitQ} -> {{legacyIndependentUnitDimension["FormazinTurbidityUnits"], 1}}
}];


(* ::Subsubsection::Closed:: *)
(*Auto-write Q fcns from unitQDimensionLookup*)


(*
	only evaluate when fNameP is a symbol.  If evaluating after it already has been assigned
	a pattern, then messages get thrown (e.g. on double-load of emerald)
*)
writeTypePQDefinitions[{fNameP_Symbol, fNameQ_Symbol} -> uDims_]:=Module[{},

	(* If we have a dimensionless unit or see "Percent" in the dimensions somewhere, don't check for "Percent". Otherwise, be strict and don't allow it. *)
	(* This is because MatchQ[1 Percent*Milliliter, VolumeP] matches and we don't want it to. *)
	If[Length[uDims] == 0 || MemberQ[uDims, "Percent", Infinity] || StringContainsQ[ToString[fNameP], "Percent"],
		fNameQ[q:UnitsP[]]:=MatchQ[UnitDimensions[q], uDims],
		fNameQ[q:UnitsP[]]:=And[MatchQ[UnitDimensions[q], uDims], !MemberQ[q, "Percent", Infinity]]
	];

	fNameQ[_]:=False;
	fNameP=PatternTest[UnitsP[], fNameQ];
	SetAttributes[fNameQ, Listable];
];


(* write the definitions *)
Map[writeTypePQDefinitions, unitQDimensionLookup[]];


(* ::Subsubsection::Closed:: *)
(*PositiveQuantityQ*)


SetAttributes[PositiveQuantityQ, Listable];
PositiveQuantityQ[myInput_?QuantityQ]:=Positive[myInput];
PositiveQuantityQ[_]:=False;


(* ::Subsubsection::Closed:: *)
(*PositiveQuantityP*)


PositiveQuantityP=_?PositiveQuantityQ;


(* ::Subsection::Closed:: *)
(*QuantityFunction*)


(* ::Text:: *)
(*Need this near top so things can match on QuantityFunctionP in definitions*)


(* ::Subsubsection::Closed:: *)
(*QuantityFunction*)


UnitFunction=QuantityFunction;

QuantityFunction::InputSizeMismatch="Given number of inputs does not match number of function inputs.";
QuantityFunction::UnitMismatch="Units on given inputs `1` are not compatible with function input units `2`.";

QuantityFunction[f_Function, inputUnits:{(_Quantity | 1)..}, outputUnit:(_Quantity | 1)][args___]:=Module[{},

	If[!SameQ[Length[inputUnits], Length[{args}]],
		Message[QuantityFunction::InputSizeMismatch];
		Return[$Failed]
	];

	(* flatten some stuff here in the checks b/c each element of the sequence args could be singleton or list *)
	If[!AllTrue[Transpose[{inputUnits, {args}}], Or[MatchQ[Flatten[{#[[2]]}], {_?NumericQ..}], compatibleUnitQold[Flatten[{#[[2]], #[[1]]}]]]&],
		Message[QuantityFunction::UnitMismatch, Units[{args}], inputUnits];
		Return[$Failed]
	];

	With[
		{rawArgs=MapThread[If[MatchQ[Flatten[{#2}], {_?NumericQ..}], #2, QuantityMagnitude[#2, #1]]&, {inputUnits, {args}}]},
		outputUnit * f @@ rawArgs
	]

];

QuantityFunction[f_Function, ListableP[(None | 1)], (None | 1)]:=f;

QuantityFunction[f_Function, inputUnit:(UnitsP[] | None), outputUnit:(UnitsP[] | None)]:=
	QuantityFunction[f, {Replace[inputUnit, None -> 1]}, Replace[outputUnit, None -> 1]];

QuantityFunction[f_Function, inputUnits:{(UnitsP[] | None)..}, outputUnit:(UnitsP[] | None)]/;MemberQ[inputUnits, None]:=
	QuantityFunction[f, Replace[inputUnits, None -> 1, {1}], Replace[outputUnit, None -> 1]];

QuantityFunction/:InverseFunction[QuantityFunction[f_Function, {inputUnit_}, outputUnit_]]:=
	QuantityFunction[InverseFunction[f], {outputUnit}, inputUnit];


(* ::Subsubsection::Closed:: *)
(*QuantityFunctionP*)


QuantityFunctionP[]:=QuantityFunction[_Function, {UnitsP[]..}, UnitsP[]];
QuantityFunctionP[input_Quantity, output_Quantity]:=QuantityFunction[_Function, {UnitsP[input]}, UnitsP[output]];
QuantityFunctionP[input:{_Quantity..}, output_Quantity]:=QuantityFunction[
	_Function,
	Map[UnitsP[#]&, input],
	UnitsP[output]
];


(* ::Subsection::Closed:: *)
(*Arrays & Coordinates*)



(* ::Subsubsection::Closed:: *)
(*parseUnitComparison*)


SetAttributes[parseUnitComparison, HoldFirst];
parseUnitComparison[(f:(GreaterP | GreaterEqualP | LessP | LessEqualP))[q_]]:=With[
	{qm=QuantityMagnitude[q], qu=QuantityUnit[q]},
	{MatchQ[#, f[qm]]&, qu}
];
parseUnitComparison[(f:(GreaterP | GreaterEqualP | LessP | LessEqualP))[q_, inc_]]:=With[
	{qm=QuantityMagnitude[q], qu=QuantityUnit[q], incn=Unitless[inc, QuantityUnit[q]]},
	{MatchQ[#, f[qm, incn]]&, qu}
];
parseUnitComparison[(f:RangeP)[q1_, q2_]]:=With[
	{q1m=QuantityMagnitude[q1], q1u=QuantityUnit[q1], q2m=Unitless[q2, QuantityUnit[q1]]},
	{MatchQ[#, f[q1m, q2m]]&, q1u}
];
parseUnitComparison[(f:RangeP)[q1_, q2_, dq_]]:=With[
	{q1m=QuantityMagnitude[q1], q1u=QuantityUnit[q1], q2m=Unitless[q2, QuantityUnit[q1]], dqm=Unitless[dq, QuantityUnit[q1]]},
	{MatchQ[#, f[q1m, q2m, dq]]&, q1u}
];

parseUnitComparison[other_]:=With[{evaluated=other},
	parseUnitComparisonEvaluated[evaluated]
];

parseUnitComparisonEvaluated[spec_Quantity]:=With[
	{qu=QuantityUnit[spec]},
	{NumericQ, qu}
];

parseUnitComparisonEvaluated[spec_String]:={NumericQ, spec};

parseUnitComparisonEvaluated[spec:None]:={NumericQ, "DimensionlessUnit"};

parseUnitComparisonEvaluated[spec:DateObject]:={DateObjectQ, "DimensionlessUnit"};
parseUnitComparisonEvaluated[spec:Date]:={MatchQ[#, _DateObject | _String]&, "DimensionlessUnit"};

parseUnitComparisonEvaluated[spec_?NumericQ]:={NumericQ, "DimensionlessUnit"};



(* ::Subsubsection::Closed:: *)
(*NumericListCoordinatesQ*)

Authors[NumericListCoordinatesQ]:={"scicomp", "brad"};
SetAttributes[NumericListCoordinatesP, HoldFirst];
NumericListCoordinatesP[yComp_]:=_List?(NumericListCoordinatesQ[#, yComp]&);


(* ::Subsubsection::Closed:: *)
(*NumericListCoordinatesQ*)


SetAttributes[NumericListCoordinatesQ, HoldRest];

NumericListCoordinatesQ[ql_List]:=
	And[
		MatrixQ[ql, NumericQ],
		MatchQ[Last[Dimensions[ql]], 2]
	];
NumericListCoordinatesQ[_]:=False;

NumericListCoordinatesQ[nums_List, {xComp_, yComp_}]:=Module[
	{xC, xUnit, yC, yUnit, xRaw, yRaw, qlConverted},

	If[!NumericListCoordinatesQ[nums], Return[False]];
	{xC, xUnit}=parseUnitComparison[xComp];
	{yC, yUnit}=parseUnitComparison[yComp];
	{xRaw, yRaw}=Transpose[nums];
	And[
		AllTrue[xRaw, xC],
		AllTrue[yRaw, yC]
	]
];
NumericListCoordinatesQ[_, _]:=False;


(* ::Subsubsection::Closed:: *)
(*QuantityListCoordinatesP*)


(*
SetAttributes[QuantityListCoordinatesP,HoldFirst];
QuantityListCoordinatesP[]:=_List?(QuantityListCoordinatesQ[#]&)
QuantityListCoordinatesP[yComp_]:=_List?(QuantityListCoordinatesQ[#,yComp]&)
*)



(* ::Subsubsection::Closed:: *)
(*QuantityListCoordinatesQ*)


(*
SetAttributes[QuantityListCoordinatesQ,HoldRest];

QuantityListCoordinatesQ[ql_List]:=
	And[
		MatrixQ[ql,QuantityQ],
		MatchQ[Last[Dimensions[ql]],2]
	];
QuantityListCoordinatesQ[_]:=False;

QuantityListCoordinatesQ[ql_List,{xComp_,yComp_}]:=Module[
	{xC,xUnit,yC,yUnit,xRaw,yRaw,qlConverted},

	If[!QuantityListCoordinatesQ[ql], Return[False]];

	{xC,xUnit} = parseUnitComparison[xComp];
	{yC,yUnit} = parseUnitComparison[yComp];

	qlConverted = Quiet[Check[UnitConvert[ql,{xUnit,yUnit}],$Failed]];
	If[MatchQ[qlConverted,$Failed],Return[False]];
	{xRaw,yRaw} = Transpose[QuantityMagnitude[qlConverted]];
	And[
		AllTrue[xRaw,xC],
		AllTrue[yRaw,yC]
	]
];
QuantityListCoordinatesQ[_,_]:=False;

*)




(* ::Subsubsection::Closed:: *)
(*ListCoordinatesP*)


SetAttributes[ListCoordinatesP, HoldFirst];
ListCoordinatesP[]:=_List?(ListCoordinatesQ[#]&);
ListCoordinatesP[yComp_]:=_List?(ListCoordinatesQ[#, yComp]&);


(* ::Subsubsection::Closed:: *)
(*ListCoordinatesQ*)


SetAttributes[ListCoordinatesQ, HoldRest];

ListCoordinatesQ[ql_List]:=
	And[
		MatrixQ[ql],
		MatchQ[Last[Dimensions[ql]], 2]
	];
ListCoordinatesQ[_]:=False;

ListCoordinatesQ[ql_List, {xComp_, yComp_}]:=Module[
	{xC, xUnit, yC, yUnit, xRaw, yRaw},

	If[!ListCoordinatesQ[ql], Return[False]];

	{xC, xUnit}=parseUnitComparison[xComp];
	{yC, yUnit}=parseUnitComparison[yComp];

	(* Need to split dimensions and convert separately b/c dates can't be converted by themselves (but can inside QAs) *)
	{xRaw, yRaw}=Transpose[ql];
	xRaw=quietSafeCheckConvert[xRaw, xUnit, xComp];
	If[MatchQ[xRaw, $Failed], Return[False]];
	yRaw=quietSafeCheckConvert[yRaw, yUnit, yComp];
	If[MatchQ[yRaw, $Failed], Return[False]];
	And[
		AllTrue[xRaw, xC],
		AllTrue[yRaw, yC]
	]
];
ListCoordinatesQ[_, _]:=False;


quietSafeCheckConvert[vals_, targetUnit_, Date | DateObject]:=vals;
quietSafeCheckConvert[vals_, targetUnit_, unitSpec_]:=Quiet[Check[QuantityMagnitude[UnitConvert[vals, targetUnit]], $Failed]];



(* ::Subsubsection::Closed:: *)
(*QuantityArrayCoordinatesP*)


Authors[QuantityArrayCoordinatesP]:={"scicomp", "brad"};
SetAttributes[QuantityArrayCoordinatesP, HoldFirst];
QuantityArrayCoordinatesP[]:=_?(QuantityArrayCoordinatesQ[#]&);
QuantityArrayCoordinatesP[yComp_]:=_?(QuantityArrayCoordinatesQ[#, yComp]&);


(* ::Subsubsection::Closed:: *)
(*QuantityArrayCoordinatesQ*)


SetAttributes[QuantityArrayCoordinatesQ, HoldRest];

Authors[QuantityArrayCoordinatesQ]:={"scicomp", "brad"};

QuantityArrayCoordinatesQ[qa:QuantityArrayP[]]:=
	And[
		MatrixQ[qa],
		MatchQ[Last[Dimensions[qa]], 2]
	];
QuantityArrayCoordinatesQ[_]:=False;

(* short cut to faster check if unit sepc is units, and NOT comparison functions (e.g. GreaterP[...])) *)
QuantityArrayCoordinatesQ[qa:QuantityArrayP[],{x:(_Quantity|_Symbol|_?NumericQ),y:(_Quantity|_Symbol|_?NumericQ)}]:=
	QuantityMatrixQ[qa,{x,y}]



QuantityArrayCoordinatesQ[qa:QuantityArrayP[], {xComp_, yComp_}]:=Module[
	{xC, xUnit, yC, yUnit, xRaw, yRaw, qlConverted},

	If[!QuantityArrayCoordinatesQ[qa], Return[False]];

	{xC, xUnit}=parseUnitComparison[xComp];
	{yC, yUnit}=parseUnitComparison[yComp];

	qlConverted=Quiet[Check[UnitConvert[qa, {xUnit, yUnit}], $Failed]];
	If[MatchQ[qlConverted, $Failed], Return[False]];
	{xRaw, yRaw}=Transpose[QuantityMagnitude[qlConverted]];
	And[
		AllTrue[xRaw, xC],
		AllTrue[yRaw, yC]
	]
];
QuantityArrayCoordinatesQ[_, _]:=False;


(* ::Subsubsection::Closed:: *)
(*UnitCoordinatesP*)


SetAttributes[UnitCoordinatesP, HoldFirst];
UnitCoordinatesP[]:=_?(UnitCoordinatesQ[#]&);
UnitCoordinatesP[yComp_]:=_?(UnitCoordinatesQ[#, yComp]&);


(* ::Subsubsection::Closed:: *)
(*UnitCoordinatesQ*)


SetAttributes[UnitCoordinatesQ, HoldRest];

UnitCoordinatesQ[in:QuantityArrayP[]]:=QuantityArrayCoordinatesQ[in];
UnitCoordinatesQ[in_List]:=
	Or[NumericListCoordinatesQ[in], ListCoordinatesQ[in]];
UnitCoordinatesQ[_]:=False;

UnitCoordinatesQ[in:QuantityArrayP[], {xComp_, yComp_}]:=QuantityArrayCoordinatesQ[in, {xComp, yComp}];
UnitCoordinatesQ[in_List, {xComp_, yComp_}]:=
	(*Or[NumericListCoordinatesQ[in,{xComp,yComp}],ListCoordinatesQ[in,{xComp,yComp}]];*)
	ListCoordinatesQ[in, {xComp, yComp}];
UnitCoordinatesQ[_, _]:=False;




(* ::Subsection::Closed:: *)
(*Distributions*)


(* ::Subsubsection::Closed:: *)
(*DistributionQ*)


(* QD *)
DistributionQ[dist_QuantityDistribution, unitSpec_]:=QuantityDistributionQ[dist, unitSpec];



(* ::Subsubsection::Closed:: *)
(*DistributionQ*)


(* use mathematica's function, don't care about units *)
(* need TrueQ b/c DistributionParameterQ doesn't always evaluate *)
DistributionQ[dist_]:=TrueQ[DistributionParameterQ[dist]];

(* QD *)
DistributionQ[dist_QuantityDistribution, unitSpec_]:=QuantityDistributionQ[dist, unitSpec];

(* empirical with units *)
DistributionQ[dist_DataDistribution, unitSpec_]:=EmpiricalDistributionQ[dist, unitSpec];

(* anything else is false *)
DistributionQ[dist_, unitSpec_]:=False;




(* ::Subsubsection::Closed:: *)
(*DistributionP*)


DistributionP[]:=_?(DistributionQ[#]&);
DistributionP[unitSpec_]:=_?(DistributionQ[#, unitSpec]&);


(* ::Subsubsection::Closed:: *)
(*QuantityDistributionQ*)


(* valid QD distribution with any unit *)
QuantityDistributionQ[QuantityDistribution[d_?DistributionParameterQ, un:Except[_List, _?EmeraldUnits`Private`knownUnitQ]]]:=True;
QuantityDistributionQ[QuantityDistribution[d_?DistributionParameterQ, un:{_?EmeraldUnits`Private`knownUnitQ..}]]:=True;
(* else *)
QuantityDistributionQ[_]:=False;

(* valid QD distribution with specific units *)
QuantityDistributionQ[QuantityDistribution[d_?DistributionParameterQ, un:Except[_List, _?EmeraldUnits`Private`knownUnitQ]], unitSpec_]:=
	UnitsQ[Quantity[un], Quantity[unitSpec]];
QuantityDistributionQ[QuantityDistribution[d_?DistributionParameterQ, un:{_?EmeraldUnits`Private`knownUnitQ..}], unitSpec_List]:=
	And @@ MapThread[UnitsQ[Quantity[#1], Quantity[#2]]&, {un, unitSpec}];
(* else *)
QuantityDistributionQ[_, _]:=False;



(* ::Subsubsection::Closed:: *)
(*QuantityDistributionP*)


QuantityDistributionP[]:=_?QuantityDistributionQ;
QuantityDistributionP[unitSpec_]:=_?(QuantityDistributionQ[#, unitSpec]&);



(* ::Subsubsection::Closed:: *)
(*EmpiricalDistributionQ*)


(* empirical data distribution with no units *)
EmpiricalDistributionQ[DataDistribution["Empirical", _, _, _]]:=True;

(* empirical data distribution with any units *)
EmpiricalDistributionQ[DataDistribution["Empirical", _, _, _, un_]]:=True;

(* empirical data distribution inside QuantityDistribution *)
EmpiricalDistributionQ[QuantityDistribution[DataDistribution["Empirical", _, _, _], _]]:=True;

(* else, any units *)
EmpiricalDistributionQ[_]:=False;

(* empirical data distribution with specific units *)
EmpiricalDistributionQ[QuantityDistribution[DataDistribution["Empirical", _, _, _], un_], unitSpec_]:=UnitsQ[Quantity[un], Quantity[unitSpec]];
EmpiricalDistributionQ[DataDistribution["Empirical", _, _, _, un:Except[_List]], unitSpec_]:=UnitsQ[Quantity[un], Quantity[unitSpec]];
EmpiricalDistributionQ[DataDistribution["Empirical", _, _, _, un:{Except[_List]..}], unitSpec_List]:=And @@ MapThread[UnitsQ[Quantity[#1], Quantity[#2]]&, {un, unitSpec}];
(* unitless ED matching on dimensionless unit spec *)
EmpiricalDistributionQ[DataDistribution["Empirical", _, _, _], unitSpec_]:=UnitsQ[1, unitSpec];
EmpiricalDistributionQ[DataDistribution["Empirical", _, _, _], unitSpec_List]:=And @@ Map[UnitsQ[1, #2]&, unitSpec];


(* else, specific units *)
EmpiricalDistributionQ[_, _]:=False;



(* ::Subsubsection::Closed:: *)
(*EmpiricalDistributionP*)


EmpiricalDistributionP[]:=_?EmpiricalDistributionQ;
EmpiricalDistributionP[unitSpec_]:=_?(EmpiricalDistributionQ[#, unitSpec]&);



(* ::Subsubsection:: *)
(*EmpiricalDistributionPoints*)

DefineOptions[EmpiricalDistributionPoints,
	Options :> {
		{MaximumDistributionPoints -> 10000, GreaterP[0, 1], "The maximum number of distribution points that will be generated by this function."}
	}
];


(*
	Getting the point set out of an empirical distribution is tricky because they do not store their full set of points.
	Instead they store a list of unique points along with relative weights of each unique point, and a count of total points.
	In most cases we can simply multiply the weights by the total number of points to figure out how many times each point should actually be repeated in the set.
	But in some cases (e.g. after UnitConvert, for some reason), the total number of points gets reduced, making it impossible to fully reconstruct the original set.
	In these cases we instead use the least common multiple (LCM) of the weight denominators to find the smallest total number of points that allows each weight to be scaled to an integer count.
*)
EmpiricalDistributionPoints[DataDistribution["Empirical", {weights_, pts_, _}, _, n_], ops:OptionsPattern[EmpiricalDistributionPoints]]:=EmpiricalDistributionPoints[weights, pts, n, ops];
(* if units on distribution, strip them, get points, then add back as a QuantityArray *)
EmpiricalDistributionPoints[DataDistribution["Empirical", {weights_, pts_, _}, _, n_, units_], ops:OptionsPattern[EmpiricalDistributionPoints]]:=QuantityArray[EmpiricalDistributionPoints[weights, pts, n, ops], units];
EmpiricalDistributionPoints[QuantityDistribution[DataDistribution["Empirical", {weights_, pts_, _}, _, n_], units_], ops:OptionsPattern[EmpiricalDistributionPoints]]:=QuantityArray[EmpiricalDistributionPoints[weights, pts, n, ops], units];
(* reconstruct point set from weights, points, and sample size *)
EmpiricalDistributionPoints[weights_, pts_, n_, ops:OptionsPattern[EmpiricalDistributionPoints]]:=Module[
	{maxTotalPoints, sigFigs, rawTotalPoints, totalPoints, pointCounts, repeatedPoints},

	(* The maximum value of TotalPoints for which the total number of points is less the MaximumDistributionPoints *)
	maxTotalPoints=OptionValue[MaximumDistributionPoints] / Total[weights, Infinity];

	(* The number of sigfigs to keep in the weights, which is modulated by maxTotalPoints *)
	sigFigs=Ceiling[Log10[OptionValue[MaximumDistributionPoints]]];

	(* find the total number of points that should be in the data set *)
	rawTotalPoints=If[MatchQ[Rationalize[RoundReals[weights * n, sigFigs], 0], {_Integer..}],
		(* If weights*n are all integers, assume n is correct  *)
		n,
		(* otherwise, find smallest possible point counts that result in each count being an integer *)
		LCM @@ Denominator[Rationalize[RoundReals[weights, sigFigs], 0]]
	];

	(* Set total points to the maximum if that threshold was exceeded *)
	totalPoints=Min[rawTotalPoints, maxTotalPoints];

	(* number of times each point should be repeated to get the full set *)
	pointCounts=Round[weights * totalPoints];

	(* repeat each point based on its count *)
	repeatedPoints=MapThread[Table, {pts, pointCounts}];

	(* Flatten at top level to return single set of points (do not completely flatten, because multivariate case will have more lists inside) *)
	Flatten[repeatedPoints, 1]
];

(* Also works on SampleDistribution, so probably should change the name... *)
EmpiricalDistributionPoints[sd:SampleDistribution[values_]]:=sd["DataPoints"];



(* ::Subsubsection::Closed:: *)
(*EmpiricalDistributionJoin*)


EmpiricalDistributionJoin[dists:(EmpiricalDistributionP[]..)]:=Module[{pointSets},
	(* extract the sets of points from each empirical distribution *)
	pointSets=Map[EmpiricalDistributionPoints, {dists}];
	(* join the sets together and put them in a new empirical distribution *)
	EmpiricalDistribution[Join @@ pointSets]
];




(* ::Subsection::Closed:: *)
(*Unit Manipulation*)


(* ::Subsubsection::Closed:: *)
(*Unitless*)


Unitless[qd:DistributionP[]]:=QuantityMagnitude[qd];

Unitless[qd:DistributionP[], newUnit_]:=With[
	{newUnitString=ReplaceAll[newUnit, q_Quantity :> QuantityUnit[q]]},
	QuantityMagnitude[UnitConvert[qd, QuantityUnit[newUnit]]]
];



Unitless[qa:QuantityArrayP[]]:=QuantityMagnitude[qa];
Unitless[qa:QuantityArrayP[], newUnits_]:=With[
	{newStringUnits=ReplaceAll[newUnits, q_Quantity :> QuantityUnit[q]]},
	With[{qanew=UnitConvert[qa, newStringUnits]},
		If[MatchQ[Flatten[qanew], {$Failed..}],
			Return[qanew],
			QuantityMagnitude[qanew]
		]
	]
];

Unitless[q:UnitsP[]]:=QuantityMagnitude[q];

Unitless[Quantity[val1_, sameUnit_], Quantity[val2_, sameUnit_]]:=val1;
Unitless[q1:UnitsP[], q2:(UnitsP[] | KnownUnitP)]:=With[
	{convertedUnits=UnitConvert[q1, q2]},
	If[convertedUnits === $Failed,
		$Failed,
		QuantityMagnitude[convertedUnits]
	]
];

(* List *)
Unitless[lst:{UnitsP[]...}]:=QuantityMagnitude[lst];
Unitless[lst:{UnitsP[]...}, newUnit:(UnitsP[] | KnownUnitP)]:=Unitless[#, newUnit]& /@ lst;
Unitless[lst1:{UnitsP[]...}, lst2:{UnitsP[]...}]:=MapThread[Unitless, {lst1, lst2}]/;SameQ[Length[lst1], Length[lst2]];
Unitless[lst1:{_List..}, lst2_List]:=Map[
	With[{itemsToConvert=#},
		MapThread[Unitless, {itemsToConvert, lst2}]
	]&,
	lst1
]/;And @@ Map[SameQ[Length[#], Length[lst2]]&, lst1];


(* pull out the pure function *)
Unitless[qf:QuantityFunctionP[]]:=First[qf];
Unitless[qf:QuantityFunctionP[], inUnits:ListableP[UnitsP[]], outUnit:UnitsP[]]:=
	First[Convert[qf, inUnits, outUnit]];


Unitless[expr_]:=ReplaceAll[expr, {q_Quantity :> QuantityMagnitude[q], qa:QuantityArrayP[] :> QuantityMagnitude[qa]}];
Unitless[expr_, newUnit:UnitsP[]]:=With[
	{qu=QuantityUnit[newUnit]},
	ReplaceAll[expr, {
		q_Quantity :> Unitless[q, qu],
		qa:QuantityArrayP[] :> Unitless[qa, qu]}
	]
];


(* ::Subsubsection::Closed:: *)
(*Units*)


Units::InconsistentUnits="Units are not consistent above level `1`.";
Units::InvalidLevel="Level `1` is deeper than the dimensions of the array.";


Units[qd:QuantityDistributionP[]]:=With[{un=QuantityUnit[qd]},
	If[MatchQ[un, _List],
		Quantity /@ un,
		Quantity[un]
	]
];



Units[qa:QuantityArrayP[]]:=With[
	{uns=QuantityUnit[qa]},
	ReplaceAll[uns, {x:Except[List | _List] :> Quantity[x]}]
];

Units[q:UnitsP[]]:=With[{un=QuantityUnit[q]}, Quantity[1, un]];
Units[q:PlusMinus[m_, s_]]:=With[{un=QuantityUnit[m]}, Quantity[1, un]];


Units[list_List]:=Map[Units, list];
(* can't use this b/c it conflicts with QA definition *)
(*SetAttributes[Units,{Listable}];*)


(* ::Text:: *)
(*QuantityArrays*)


(*
	Automatic level spec
*)
Units[qa:QuantityArrayP[], levelSpec:Automatic]:=Module[
	{
		uns=QuantityUnit[qa],
		dims=Dimensions[qa],
		initialLevel,
		finalLevel,
		subuns
	},

	initialLevel=Switch[dims,
		{_Integer}, 1,
		{__Integer}, Length[dims] - 1
	];

	finalLevel=initialLevel;
	subuns=Nest[#[[1]]&, uns, finalLevel];

	While[!subArrayQ[uns, subuns],
		finalLevel=finalLevel - 1;
		If[finalLevel > Length[dims],
			(
				Return[$Failed]
			)
		];
		subuns=Nest[First[#]&, uns, finalLevel];
	];

	Units[qa, {finalLevel}]

];


(*
	with single level specified
*)
Units[qa:QuantityArrayP[], {levelSpec_Integer}]:=Module[
	{
		uns=QuantityUnit[qa],
		dims=Dimensions[qa],
		subuns
	},

	If[
		levelSpec > Length[dims],
		Message[Units::InvalidLevel, levelSpec];
		Return[$Failed]
	];

	(* pull units at specified level *)
	subuns=Nest[First[#]&, uns, levelSpec];

	If[
		!subUnitArrayQ[uns, subuns],
		Message[Units::InconsistentUnits, levelSpec];
		Return[$Failed]
	];

	(* turn the string units into quantities *)
	ReplaceAll[subuns, x:Except[List | _List] :> Quantity[x]]
];


(*
	Integer level
*)
Units[qa:QuantityArrayP[], levelSpec_Integer]:=Module[
	{
		patt
	},

	patt=Units[qa, {levelSpec}];

	If[MatchQ[patt, Null | $Failed],
		Return[patt]
	];

	nestRepeatedPattern[patt, levelSpec]
];



(* ::Subsubsection::Closed:: *)
(*UnitBase*)


UnitBase[item:UnitsP[]]:=unitWithoutPrefix[item];

UnitBase[unit:KnownUnitP]:=unitWithoutPrefix[unit];

UnitBase[s:UnitDimensionP]:=Module[{uDims, newUnit},
	newUnit=dimensionStringToUnitExpression[s];
	UnitSimplify[Quantity[1, newUnit]]
];

UnitBase[s:UnitDimensionP, All]:=With[
	{sDims=UnitDimensions[UnitBase[s]]},
	DeleteDuplicates[
		Join[
			{UnitBase[s]},
			Select[List @@ canonicalUnitLookup[[;;, 1]], UnitDimensions[#] == sDims&]
		]
	]
];

SetAttributes[UnitBase, {Listable}];


dimensionStringToUnitExpression[dimensionString_String]:=With[
	(* delete duplicates to get first dimension match from the list *)
	{dimensionList=Association[Reverse /@ Normal@DeleteDuplicates[unitDimensionLookup]][dimensionString]},
	If[MatchQ[dimensionList, _Missing],
		$Failed,
		dimensionListToUnitExpression[dimensionList]
	]
];


dimensionListToUnitExpression[dimensionList_]:=ReplaceAll[Times @@ Power @@@ dimensionList, canonicalUnitTypeLookup];


(* ::Subsubsection::Closed:: *)
(*UnitFlatten*)


UnitFlatten[item:UnitsP[]]:=UnitConvert[item, UnitBase[item]];
SetAttributes[UnitFlatten, {Listable}];



(* ::Subsubsection::Closed:: *)
(*UnitDimension*)


(* explicitly write this def, because Percent is unitless dimension, so comes back as unknown *)
UnitDimension[Quantity[mag_, "Percent"]]:="Percent";

UnitDimension[item:UnitsP[]]:=Module[{dimensions, unitDescription},

	dimensions=UnitDimensions[item];
	unitDescription=unitDimensionLookup[dimensions];

	If[MatchQ[unitDescription, _Missing],
		"Unknown quantity",
		unitDescription
	]
];

UnitDimension[strUn:KnownUnitP]:=UnitDimension[Quantity[1, strUn]];
SetAttributes[UnitDimension, Listable];



(* ::Subsubsection::Closed:: *)
(*CanonicalUnit*)


CanonicalUnit[q:Quantity[0, unit_]]:=Quantity[QuantityUnit[UnitConvert[Quantity[1, unit], "SIBase"]]];
CanonicalUnit[q:Quantity[0.`, unit_]]:=Quantity[QuantityUnit[UnitConvert[Quantity[1, unit], "SIBase"]]];
CanonicalUnit[q_Quantity]:=Quantity[QuantityUnit[UnitConvert[q, "SIBase"]]];
CanonicalUnit[num_?NumericQ]:=1;
CanonicalUnit[dimension_String]:=Module[{stringUnit},
	stringUnit=EmeraldUnits`Private`dimensionStringToUnitExpression[dimension];
	If[MatchQ[stringUnit, _Missing | $Failed],
		$Failed,
		Quantity[stringUnit]
	]
];

SetAttributes[CanonicalUnit, Listable];



(* ::Subsection::Closed:: *)
(*Unit Conversions*)


(* ::Subsubsection::Closed:: *)
(*Convert*)


Convert::NotConvertable="Can not Convert between Units `1` and `2`.";

(*
	Failed QA conversions can be really slow.
	To speed things up, first convert the first element of the array to check for failures.
	If that fails, abort immediately.
	If it passes, attempt to convert the entire thing
*)
Convert[qa:QuantityArrayP[], newUnit_]:=If[
	And[
		Dimensions[qa] =!= Dimensions[newUnit], (* can't take first element only in this case *)
		unitConvertCheck[qa[[1]], newUnit] === $Failed
	],
	$Failed,
	unitConvertCheck[
		(* This ensures any held units get converted to the correct units in 12.2+, e.g. KilocaloriesThermochemical->ThermochemicalKilocalories *)
		(* Part[qa,All] introduces a small amount of overhead, but at time of writing it's ~1 order of magnitude faster than the actual conversion *)
		If[$VersionNumber >= 12.2, Part[qa, All], qa],
		newUnit
	]
];
Convert[qas:{QuantityArrayP[]..}, newUnit_]:=If[
	And[
		Dimensions[qas] =!= Dimensions[newUnit], (* can't take first element only in this case *)
		Dimensions[qas[[1]]] =!= Dimensions[newUnit], (* can't take first element only in this case *)
		unitConvertCheck[qas[[1, 1]], newUnit] === $Failed === $Failed
	],
	$Failed,
	unitConvertCheck[qas, newUnit]
];

unitConvertCheck[val_, un_]:=Check[
	UnitConvert[val, un /. {q_Quantity :> q, 1 -> "DimensionlessUnit"}], (* need this weird ReplaceAll here b/c UnitConvert barfs on '1' as a unit for QAs, but is fine in the other definitions *)
	$Failed
];


Convert[qd:QuantityDistributionP[], newUnit_]:=UnitConvert[qd, If[MatchQ[newUnit, ListableP[_?QuantityQ]], QuantityUnit[newUnit], newUnit]];

Convert[items:{UnitsP[]..}, newUnit:(UnitsP[] | KnownUnitP)]:=Module[
	{oldUnits, oldUnit, unitBases},

	unitBases=Units[items];

	Which[
		MatchQ[unitBases, {newUnit..}],
		items, (* Items are already in the correct Units, return unaltered *)
		(SameQ @@ unitBases),
		Convert[Unitless[items], FirstOrDefault[unitBases], newUnit] * If[MatchQ[newUnit, _Quantity], newUnit, Quantity[newUnit]],
		True, Convert[#, newUnit]& /@ items (* Items are in mix Units, no choice but to Convert each individually *)
	]
];

(* if contains distributions, can't multiply to scale it *)
Convert[items:{(UnitsP[] | _?DistributionParameterQ)..}, newUnit:(UnitsP[] | KnownUnitP)]:=Module[
	{oldUnits, oldUnit, unitBases},

	unitBases=Units[items];

	Which[
		MatchQ[unitBases, {newUnit..}],
		items, (* Items are already in the correct Units, return unaltered *)
		True, Convert[#, newUnit]& /@ items (* Items are in mix Units, no choice but to Convert each individually *)
	]
];


(* need special definition for temperatures b/c their conversions are not just scaling *)
Convert[items:ListableP[_?NumericQ], oldUnit:TemperatureP, newUnit:TemperatureP]:=
	Quiet[
		Check[
			QuantityMagnitude[UnitConvert[QuantityArray[items, oldUnit], newUnit]],
			Unitless[Map[Convert[# * oldUnit, newUnit]&, items]],
			{UnitConvert::conv}
		],
		{UnitConvert::conv}
	];

(* fast conversion when units are not attached to the numbers *)
Convert[items:ListableP[_?NumericQ], oldUnit:(UnitsP[] | KnownUnitP | None), newUnit:(UnitsP[] | KnownUnitP | None)]:=With[
	{convertedUnit=UnitConvert[Replace[oldUnit, None -> 1], Replace[newUnit, None -> 1]]},
	If[convertedUnit === $Failed,
		$Failed,
		With[{sharedConversion=Unitless[convertedUnit]},
			sharedConversion * items
		]
	]
];

(* can't just multiple distributions, so add units and convert normally *)
Convert[item:Except[_QuantityDistribution, _?DistributionParameterQ], oldUnit:(UnitsP[] | KnownUnitP | None), newUnit:(UnitsP[] | KnownUnitP | None)]:=
	Unitless[
		QuantityDistribution[item, oldUnit],
		newUnit
	];
Convert[items:{Except[_QuantityDistribution, _?DistributionParameterQ]..}, oldUnit:(UnitsP[] | KnownUnitP | None), newUnit:(UnitsP[] | KnownUnitP | None)]:=With[
	{},
	Unitless[
		Map[QuantityDistribution[#, oldUnit]&, items],
		newUnit
	]
];

Convert[items:{_QuantityDistribution..}, oldUnit:(UnitsP[] | KnownUnitP | None), newUnit:(UnitsP[] | KnownUnitP | None)]:=With[
	{},
	Unitless[
		Map[QuantityDistribution[#, oldUnit]&, items],
		newUnit
	]
];


Convert[currentValue:UnitsP[], newUnit:(UnitsP[] | KnownUnitP)]:=With[
	{converted=UnitConvert[currentValue, newUnit]},
	If[MatchQ[converted, _UnitConvert], $Failed, converted]
];

Convert[items:{{(UnitsP[] | _?DistributionParameterQ)..}..}, newUnits:{(UnitsP[] | KnownUnitP)..}]:=Module[
	{transposedItems, convertedItems},

	transposedItems=Transpose[items];
	convertedItems=MapThread[
		Convert,
		{transposedItems, newUnits}
	];

	If[MemberQ[convertedItems, $Failed, 2],
		$Failed,
		Transpose[convertedItems]
	]
];
Convert[items:{{{(UnitsP[])..}..}..}, newUnits:{(UnitsP[] | KnownUnitP | None)..}]:=Convert[#, newUnits]& /@ items;

Convert[NormalDistribution[m:UnitsP[], s:UnitsP[]], newUnit:(UnitsP[] | KnownUnitP)]:=NormalDistribution @@ Convert[{m, s}, newUnit];
Convert[PlusMinus[m:UnitsP[], s:UnitsP[]], newUnit:(UnitsP[] | KnownUnitP)]:=PlusMinus @@ Convert[{m, s}, newUnit];

(*
	converting empirical data distribution is a bit messy because mathematica is incomplete/inconsistent with
	these distribution conversions compared to how it converts other things.
	need extra resolution for the unitless case
*)
Convert[d:DataDistribution["Empirical", ___], newUnit:(UnitsP[] | KnownUnitP | None)]:=Module[
	{targetUnit, distributionUnit},
	(* resolve target unit to a string expression or None, b/c that is what these distributions use in unitless case *)
	targetUnit=Replace[newUnit, {
		q_Quantity :> QuantityUnit[q],
		(_?NumericQ | "DimensionlessUnit") -> None
	}];

	distributionUnit=d["Units"];
	(* when UnitConvert fails on these distributions it returns half-evaluated, so instead catch the bad cases first and return $Failed like we do in other cases *)
	Which[
		And[distributionUnit === None, targetUnit === None],
		d,
		compatibleUnitQold[distributionUnit, targetUnit],
		(*
				extract points, convert, put back in distribution.  must do it this way b/c if you UnitConvert directly on
				DataDistribution it will collapse the number of points if it can, which can make it impossible to recreate the data set.
			*)
		EmpiricalDistribution[UnitConvert[EmpiricalDistributionPoints[d], targetUnit]],
		True,
		(
			Message[Quantity::compat, distributionUnit, targetUnit];
			$Failed
		)
	]
];



(*
	QuantityFunction converting
	Scale the input and output of the pure function
*)
Convert[
	QuantityFunction[f_, oldInputUnits:{UnitsP[]..}, oldOutputUnit:UnitsP[]],
	newInputUnits:{UnitsP[]..},
	newOutputUnit:UnitsP[]
]:=Module[
	{inputScalings, outputScaling, slotUpdateRules},

	If[Length[oldInputUnits] =!= Length[newInputUnits],
		Message[];
		Return[$Failed]
	];

	inputScalings=MapThread[Convert[1, #1, #2]&, {oldInputUnits, newInputUnits}];
	outputScaling=Convert[1, oldOutputUnit, newOutputUnit];
	(* need to use Table b/c otherwise Slots confuse Map *)
	slotUpdateRules=Table[
		With[
			{ix=ix},
			Slot[ix] -> Slot[ix] / inputScalings[[ix]]
		],
		{ix, 1, Length[inputScalings]}
	];

	With[
		{fNew=Function[Evaluate[ReplaceAll[f @@ slotUpdateRules[[;;, 1]], slotUpdateRules] * outputScaling]]},
		QuantityFunction[fNew, newInputUnits, newOutputUnit]
	]

];

Convert[qf:QuantityFunctionP[], newInputUnit:UnitsP[], newOutputUnit:UnitsP[]]:=Convert[qf, {newInputUnit}, newOutputUnit];



nestedItemListQ[in_List]:=AllTrue[in, NumericQ];
nestedItemListQ[in_]:=False;

Convert[items:{_?nestedItemListQ..}, oldUnits:{(UnitsP[] | KnownUnitP | None)..}, newUnits:{(UnitsP[] | KnownUnitP | None)..}]:=Module[
	{transposedItems, convertedItems},

	transposedItems=Transpose[items];
	convertedItems=MapThread[
		Convert,
		{transposedItems, Replace[oldUnits, None -> 1, {1}], Replace[newUnits, None -> 1, {1}]}
	];

	If[MemberQ[convertedItems, $Failed],
		$Failed,
		Transpose[convertedItems]
	]
];

doubleNestedItemListQ[in_List]:=AllTrue[in, nestedItemListQ];
doubleNestedItemListQ[in_]:=False;
Convert[items:{_?doubleNestedItemListQ..}, oldUnits:{(UnitsP[] | KnownUnitP | None)..}, newUnits:{(UnitsP[] | KnownUnitP | None)..}]:=
	Convert[#, oldUnits, newUnits]& /@ items;


Convert[nulls:ListableP[Null | {}], _, _]:=nulls;
Convert[nulls:ListableP[Null | {}], _]:=nulls;

(* Define the value we want to round to by default *)
$RoundIncrement=0.01;


(* ::Subsubsection::Closed:: *)
(*UnitScale*)


DefineOptions[UnitScale,
	Options :> {
		{Simplify -> True, BooleanP, "If True, UnitSimplify is called on the input before scaling."},
		{Round->False, BooleanP | RangeP[-Infinity, Infinity], "Indicates if numbers should be rounded after conversion. When Round->True the value is rounded to $RoundIncrement."}
	}
];


(* unitless things remain unchanged *)
UnitScale[n_?NumericQ, ops:OptionsPattern[]]:=n;

UnitScale[q_Quantity, ops:OptionsPattern[]]:=Module[

	{qSimplified, possibleUnits, converted, best, mags, order, bestPos, out, mag, un, roundRequest, round, hertzInput},

	(* check if input has unit of hertz *)
	hertzInput=StringContainsQ[ToString[QuantityUnit[q]],"Hertz"|"hertz"];

	(* First simplify our unit, if requested *)
	(* do not simplify PSI into kPa *)
	(* do not simplify Hertz into Curies *)
	qSimplified=If[
		And[
			TrueQ[OptionDefault[OptionValue[Simplify]]],
			!And[MatchQ[$ECLApplication, Engine], MatchQ[Units[q], Quantity[1, Times[Power["Inches", -2], "PoundsForce"]]]],
			!hertzInput
		],
		UnitSimplify[q],
		q
	];

	mag=QuantityMagnitude[qSimplified];
	un=QuantityUnit[qSimplified];

	(* if magnitude is zero, leave it be *)
	If[ MatchQ[mag, 0 | 0.],
		Return[qSimplified];
	];

	(* Write a little function to round for us *)
	roundRequest=OptionDefault[OptionValue[Round]];
	round[x_]:=Switch[roundRequest,
		NumericP,Round[x,roundRequest],
		True,Round[x,$RoundIncrement],
		_,x
	];

	(* if already has a good magnitude, leave it *)
	(* not true for hours and compound units *)
	If[ And[MatchQ[un, _String], 1. <= N[mag] < 1000., Not[MemberQ[timeUnitStrings, un]]],
		Return[round[qSimplified/. r_Rational :> N[r]]];
	];

	possibleUnits=getPossibleUnits[qSimplified];

	(* Convert to all possible times *)
	converted=UnitConvert[qSimplified, QuantityUnit[possibleUnits]];

	(* strip out magnitudes for faster comparisons and sorting *)
	mags=Abs[QuantityMagnitude[converted]];

	(* get ordering so we can take the first *)
	order=Ordering[mags];

	(* take smallest value bigger than 1 *)
	(* NOTE: these are not always <1000, e.g. for units with powers like Meter^2 *)
	bestPos=FirstPosition[mags[[order]], _?(# >= 1&)];

	(* return best case available *)
	out=Which[
		(* smallest value > 1 *)
		MatchQ[bestPos, {_Integer}],
		converted[[order]][[First[bestPos]]],
		(* if everything < 1, take largest *)
		Max[mags] < 1,
		Last[converted[[order]]],
		(* anything else (don't think it should hit this) *)
		True,
		First[converted[[order]]]
	];

	round[out /. r_Rational :> N[r]]

];

UnitScale[dist:(_?QuantityDistributionQ | _?DistributionParameterQ), ops:OptionsPattern[]]:=
	Convert[dist, QuantityUnit[UnitScale[Mean[dist], ops]]];

UnitScale[qa:QuantityArrayP[], ops:OptionsPattern[]]:=Module[
	{means, scaledMeans},
	means=Normal[Mean[qa]];
	scaledMeans=UnitScale[means, ops];
	UnitConvert[qa, QuantityUnit[scaledMeans]]
];

UnitScale[in_List, ops:OptionsPattern[]]:=Map[UnitScale[#, ops]&, in];


metricPrefixesForMetricForm=10^Range[24, -24, -3] /. (Reverse /@ metricPrefixLookup[]);

getPossibleUnits[q_?NumericQ]:={q};

(* if magnitude is zero, leave Units as-is, otherwise it converts to tiniest prefix *)
getPossibleUnits[q:Quantity[0 | 0., un_]]:={q};

getPossibleUnits[q:Quantity[mag_, Power[base_, exp_]]]:=getPossibleUnits[Quantity[1, base]]^Abs[exp]/;exp > 0;
getPossibleUnits[q:Quantity[mag_, Power[base_, exp_]]]:=With[{posExp=Abs[exp]}, 1 / getPossibleUnits[Quantity[1, base^posExp]]]/;exp < 0;

(* special per molars *)
getPossibleUnits[q:prefixedUnitP[1 / Molar]]:=1 / (metricPrefixesForMetricForm * Molar);

(* for everything else, get dimensions once because everything else uses them *)
getPossibleUnits[q_Quantity]:=getPossibleUnits[q, UnitDimensions[q]];

getPossibleUnits[q_Quantity, {}]:={q};

(* For a fraction of a second express with prefix * second *)
getPossibleUnits[q_Quantity, {{"TimeUnit", 1}}]:=Second metricPrefixesForMetricForm/;(-1 Second < q < 1 Second);
getPossibleUnits[q_Quantity, {{"TimeUnit", 1}}]:=TimeUnits;
getPossibleUnits[q_Quantity, {{"TemperatureUnit", 1}}]:={q};
(* Force numerator to Celsius, scale denominator as we do with time *)
getPossibleUnits[q_Quantity, {{"TemperatureUnit", 1}, {"TimeUnit", -1}}]:=Celsius / getPossibleUnits[Celsius / q, {{"TimeUnit", 1}}];
getPossibleUnits[q_Quantity, {{"LengthUnit", 3}, {"TimeUnit", -1}}]:=With[
	{timeUnit=Units[Liter / q]},
	(metricPrefixesForMetricForm * Liter) / timeUnit
];
getPossibleUnits[q_Quantity, {{"LengthUnit", -3}, {"MoneyUnit", 1}, {"TimeUnit", -1}}]:=Module[
	{nonTimePiece, qflat, timePiece},
	qflat=UnitFlatten[q];
	nonTimePiece=USD / Meter^3;
	timePiece=1 / (qflat / nonTimePiece);
	nonTimePiece / getPossibleUnits[timePiece, {{"TimeUnit", 1}}]
];

(* anything else, memozie case with unity magnitude  *)
getPossibleUnits[q:Quantity[1, un_], ud_]:=getPossibleUnits[Quantity[1, un], ud]=metricPrefixesForMetricForm * Units[UnitFlatten[q]];
getPossibleUnits[q:Quantity[mag_, un_], ud_]:=getPossibleUnits[Quantity[1, un], ud];


(* ::Subsubsection::Closed:: *)
(*UnitForm*)


(* Use hold to prevent units from evaluating prematurely *)
unitPrefixShorthands = Hold[Yotta -> "Y", Zetta -> "Z", Exa -> "E", Peta -> "P", Tera -> "T", Giga -> "G", Mega -> "M", Kilo -> "k", Hecto -> "h", Deca -> "da", 1 -> "", Deci -> "d", Centi -> "c", Milli -> "m", Micro -> "\[Mu]", Nano -> "n", Pico -> "p", Femto -> "f", Atto -> "a", Zepto -> "z", Yocto -> "y"];
unitPostfixShorthands = Hold[
	AbsorbanceUnit -> "AU",
	Ampere -> "Amp.",
	Angstrom -> "\[CapitalARing]",
	AnisotropyUnit -> "A",
	ArbitraryUnit -> "Arb.",
	Atmosphere -> "atm",
	Bar -> "Bar",
	BasePair -> "bp",
	Calorie -> "Cal",
	Calorie / (Kelvin * Mole) -> "e.u.",
	Celsius -> "\[Degree]C",
	Centigrade -> "\[Degree]C",
	Century -> "Centuries",
	Cycle -> "Cycles",
	Dalton -> "Da",
	Day -> "Days",
	Decade -> "Decades",
	Fahrenheit -> "\[Degree]F",
	Gram -> "g",
	Joule -> "J",
	Liter -> "L",
	Liter / (Centimeter * Mole) -> "L/(cm Mol.)",
	Liter / Mole -> "\!\(\*SuperscriptBox[\(M\), \(-1\)]\)",
	Lumen -> "lm",
	Lux -> "Lux",
	LSU -> "LSU",
	Kelvin -> "K",
	Hertz -> "Hz",
	Hour -> "Hrs.",
	Meter -> "m",
	Millennium -> "Millennia",
	Minute -> "Min.",
	Mole -> "Mol.",
	Mole / Liter -> "M",
	Month -> "Mo.",
	None -> "",
	Nucleotide -> "nt",
	Pascal -> "Pa",
	Percent -> "%",
	PolarizationUnit -> "P",
	PPM -> "PPM",
	PSI -> "PSI",
	RFU -> "RFU",
	RLU -> "RLU",
	Second -> "s",
	Siemens -> "S",
	USD -> "$",
	Volt -> "V",
	Watt -> "W",
	Week -> "Weeks",
	Year -> "Yr."
];


DefineOptions[UnitForm,
	Options :> {
		{Metric -> True, True | False, "If True, converts to UnitScale before formatting."},
		{Format -> Plain, Formatted | Plain, "If Formatted, returns the output in a formatted string. Plain returns the output in a string with no formatting."},
		{Number -> Automatic, Automatic | True | False, "If True, will include the number in the string: i.e. 2 Micro Molar -> \"2 [\[Mu]M]\" if true or \"[\[Mu]M]\" if false."},
		{Round->False, BooleanP | RangeP[-Infinity, Infinity], "Indicates if numbers should be rounded in their final form. When Round->True the value is rounded to $RoundIncrement."},
		{Brackets -> True, True | False, "If True, includes brackets ( ) or [ ] around the unit type in the string."},
		(* This function uses certain custom conversions which are added with Prepend. ReplaceRule isn't loaded at this time *)
		{PrefixShorthand :> DeleteDuplicates[Prepend[List @@ unitPrefixShorthands, Micro -> "\[Micro]"]], _List | Null, "List of rules specifying how to handle the metric prefixes such as Micro -> \"\[Micro]\"."},
		{PostfixShorthand :> DeleteDuplicates[Prepend[List @@ unitPostfixShorthands, Second -> "Seconds"]], _List | Null, "List of rules specifying how to handle the core Units such as years ->\"Yr\"."}
	}];


stringUnitShorthandRules[{prefixRules_List, postfixRules_List}]:=stringUnitShorthandRules[{prefixRules, postfixRules}]=Join[
	{"molar" -> "M", "Molar" -> "M", "DegreesCelsius" -> "\[Degree]C", "DegreesFahrenheit" -> "\[Degree]F", "DegreesKelvin" -> "K", "ThermochemicalKilocalories" -> "kcal"},
	MapAt[ToString, prefixRules, {;;, 1}],
	MapAt[QuantityUnit, postfixRules, {;;, 1}],
	Cases[MapAt[QuantityUnit, OptionValue[UnitForm, PostfixShorthand], {;;, 1}], Rule[IndependentUnit[left_String], right_] :> Rule[left, right]],
	MapAt[(ToLowerCase[StringTake[#, 1]]<>StringTake[#, 2;;])&, Cases[MapAt[QuantityUnit, postfixRules, {;;, 1}], r:Rule[_String, val_] :> r], {;;, 1}]
];

(* need this to memoize the default option lookup, because Options[UnitForm] is crazy slow due to the huge list of quantities in one of the options *)
unitFormOptionDefaults[ops___]:=unitFormOptionDefaults[ops]=OptionDefaults[UnitForm, ToList[ops]];

UnitForm[q_?CurrencyQ, ops:OptionsPattern[]]:=CurrencyForm[q, PassOptions[UnitForm, CurrencyForm, ops]];
UnitForm[q:Quantity[val_, un_]?QuantityQ, ops:OptionsPattern[]]:=Module[
	{inverseUnitQ, preString, spacerString, bracketOp, stringRules, valString, unitsShorthanded, unitsString, bracketChars, value, unit,
		unitPrefixesMerged, stringStringRules, safeOps, roundRequest,round},

	(* use memoizing helper to get safe options b/c this step is very slow and 'ops' is usually empty *)
	safeOps=unitFormOptionDefaults[ops];
	roundRequest=Lookup[safeOps, "Round"];

	round[x_]:=Switch[roundRequest,
		NumericP,Round[x,roundRequest],
		True,Round[x,$RoundIncrement],
		_,x
	];

	spacerString=" ";

	{value, unit}=If[Lookup[safeOps, "Metric"],
		{QuantityMagnitude[#], QuantityUnit[#]}&[UnitScale[q,Round->roundRequest]],
		{round[val], un}
	];

	bracketOp=Lookup[safeOps, "Brackets"];
	bracketChars=Which[
		bracketOp === False,
		{"", ""},
		And[bracketOp === True, molarQ[q]],
		{"[", "]"},
		True,
		{"(", ")"}
	];

	stringRules=stringUnitShorthandRules[Lookup[safeOps, {"PrefixShorthand", "PostfixShorthand"}]];
	stringStringRules=Cases[stringRules, r:Rule[_String, _] :> r];

	valString=Switch[{Lookup[safeOps, "Number"], Lookup[safeOps, "Format"]},
		{True | Automatic, Plain},
		ToString[value],
		{True | Automatic, _},
		ToString[TraditionalForm[value]],
		{False, _},
		""
	];

	inverseUnitQ=And[Lookup[safeOps, "Format"] === Formatted, MatchQ[unit, Power[_String | _IndependentUnit, _Integer]]];

	unitsShorthanded=unit /. u:IndependentUnit[str_String] :> str /. Times -> mergeStringPrefix /. stringRules /. str_String :> StringReplace[str, stringStringRules];

	unitsString=If[inverseUnitQ,
		"\!\(\*SuperscriptBox[\("<>First[unitsShorthanded]<>"\), \("<>ToString[Last[unitsShorthanded]]<>"\)]\)",
		StringReplace[ToString[InputForm[unitsShorthanded]], {"\"" -> "", "*" -> ""}]
	];

	preString="";

	StringJoin[
		preString,
		valString,
		spacerString,
		First[bracketChars],
		unitsString,
		Last[bracketChars]
	]
];

UnitForm[None, ___]:="";

UnitForm[n_?NumericQ, ops:OptionsPattern[]]:=ToString[n];

UnitForm[strUn:KnownUnitP, ops:OptionsPattern[]]:=UnitForm[Quantity[1, strUn], ops, Number -> False];


SetAttributes[UnitForm, {Listable}];


stringPrefixes=Alternatives @@ (ToString /@ MetricPrefixes);
mergeStringPrefix[first___, pref:stringPrefixes, other:Except[stringPrefixes, _String], rest___]:=mergeStringPrefix[first, pref<>other, rest];
mergeStringPrefix[first___, other:Except[stringPrefixes, _String], pref:stringPrefixes, rest___]:=mergeStringPrefix[first, pref<>other, rest];
mergeStringPrefix[first___, pref:Power[stringPrefixes, n_], other:Except[Power[stringPrefixes, _], Power[_String, n_]], rest___]:=mergeStringPrefix[first, Power[First[pref]<>First[other], n], rest];
mergeStringPrefix[first___, other:Except[Power[stringPrefixes, _], Power[_String, n_]], pref:Power[stringPrefixes, n_], rest___]:=mergeStringPrefix[first, Power[First[pref]<>First[other], n], rest];
mergeStringPrefix[other___]:=Times[other];


molarQ[q_Quantity]:=molarQ[QuantityUnit[q]];
molarQ[s_String]:=StringMatchQ[s, "Molar" | (___~~"molar")];
molarQ[_]:=False;


(* ::Subsubsection::Closed:: *)
(*CurrencyForm*)


DefineOptions[CurrencyForm,
	Options :> {
		{Units -> Automatic, Automatic | Penny | Dollar | Grand | Million | Billion, "The nearest reasonable unit to round to.  By Default rounds to the most reasonable unit place."},
		{Symbol -> "$", _String, "Symbol to place before the value."},
		{Commas -> True, True | False, "If true will place commas between each 3 orders of magnitude (eg. 10000 -> 10,000)."},
		{Brackets -> True, True | False, "If true will use () for negative numbers and - if False."},
		{Shorthand -> True, True | False, "If true will replace the 0's places with short hand letters eg: 13202 -> $13k."}
	}];

CurrencyForm::TooLarge="Error: You've got too much cash to represent properly.";


CurrencyForm[input:(0 | 0.0), ops:OptionsPattern[CurrencyForm]]:="$0.00";
CurrencyForm[input_?CurrencyQ, ops:OptionsPattern[CurrencyForm]]:=CurrencyForm[Unitless[input, USD], ops];
CurrencyForm[input_?NumericQ/;Abs[input] >= 1000000000000, ops:OptionsPattern[CurrencyForm]]:=(Message[CurrencyForm::TooLarge];"$$$");
CurrencyForm[input_?NumericQ/;Abs[input] < 1000000000000, ops:OptionsPattern[CurrencyForm]]:=Module[{units, frontRound, frontString, backString, finalFront, finalBack, sansSign},

	(* If Units are not set, determine what the value should be *)
	units=Switch[OptionDefault[OptionValue[Units]],
		(Penny | Dollar | Grand | Million | Billion), (OptionValue[Units]),
		Automatic, Automatic
	] /. Automatic -> Which[Abs[input] >= 1000000000, Billion, Abs[input] >= 1000000, Million, Abs[input] >= 1000, Grand, Abs[input] >= 100, Dollar, True, Penny];

	(* Determine what to round the number before the decimal to base on the Units *)
	frontRound=Switch[units,
		Penny, 1,
		Dollar, 1,
		USD, 1,
		Grand, 1000,
		Million, 1000000,
		Billion, 1000000000
	];

	(* Construct up the part of the expression before the decimal *)
	frontString=ToString[Round[IntegerPart[Abs[input]], frontRound], InputForm];
	finalFront=If[(OptionValue[Shorthand]),
		Switch[units,
			Billion, If[Abs[input] < 1000000000, "0k", If[(OptionValue[Commas]), addCommas[StringDrop[frontString, -9]], StringDrop[frontString, -9]]<>"B"],
			Million, If[Abs[input] < 1000000, "0k", If[(OptionValue[Commas]), addCommas[StringDrop[frontString, -6]], StringDrop[frontString, -6]]<>"M"],
			Grand, If[Abs[input] < 1000, "0k", If[(OptionValue[Commas]), addCommas[StringDrop[frontString, -3]], StringDrop[frontString, -3]]<>"k"],
			Dollar, If[(OptionValue[Commas]), addCommas[frontString], frontString],
			_, If[(OptionValue[Commas]), addCommas[frontString], frontString]
		],
		If[(OptionValue[Commas]), addCommas[frontString], frontString]
	];

	(* Construct up the part of the expression before the decimal *)
	backString=ToString[Round[FractionalPart[Abs[input]], $RoundIncrement], OutputForm];
	finalBack=If[MatchQ[units, Penny], StringPadRight[StringDrop[backString, 1], 3, "0"], ""];

	sansSign=(OptionValue[Symbol])<>finalFront<>finalBack;

	If[(OptionValue[Brackets]),
		If[input < 0, "(", ""]<>sansSign<>If[input < 0, ")", ""],
		If[input < 0, "-", ""]<>sansSign
	]
];
SetAttributes[CurrencyForm, {Listable}];

addCommas[""]:="";
addCommas[input_?(StringMatchQ[#, (DigitCharacter..)]&)]:=Module[{groupedBy3, wcommas},
	groupedBy3=PartitionRemainder[Reverse[Characters[input]], 3];
	wcommas=Flatten[Prepend[#, ","]& /@ groupedBy3];
	StringJoin[Most[Reverse[wcommas]]]
];

(* ::Subsection::Closed:: *)
(*Unit Comparisons*)


(*
	Need this because mathematica's Mod is often wrong due to numerical round.  For example, try Mod[0.5,0.1]
	Also, Round behaves differently when given one Quantity and one Numeric,
	so in those cases we want to convert to the common unit before rounding.
	See e.g. Round[2*Dozen,Percent] vs Round[2*Dozen,3] vs Round[3,2*Dozen]
*)
modRound[m_?NumericQ, n_Quantity, del_]:=Quiet[modRound[Convert[m, Units[n]], n, del], Quantity::compat];
modRound[m_Quantity, n_?NumericQ, del_]:=Quiet[modRound[Convert[m, Units[n]], n, del], Quantity::compat];
modRound[m_, n_, del_]:=With[{q=Round[m / n, 1]}, Round[Abs[m - q * n], del]];



(* ::Subsubsection:: *)
(*Auto-write*)


writeComparisonPatternRedirects[pName_Symbol, qName_Symbol, funcItCalls_Symbol]:=With[
	{validArgs=_?NumericQ | UnitsP[] | _?DateObjectQ | DistributionP[] },

	(* p -> q *)
	SetDelayed[
		pName[fixedQuantity:validArgs],
		PatternTest[
			_,
			Function[
				qName[Slot[1], fixedQuantity]
			]
		]
	];

	(* p -> q *)
	If[ funcItCalls =!= Equal,
		SetDelayed[
			pName[fixedQuantity:validArgs, increment:validArgs],
			PatternTest[
				_,
				Function[
					qName[Slot[1], fixedQuantity, increment]
				]
			]
		]
	]

];

writeQuantityComparisonPatternFunction[qName_Symbol, funcItCalls_Symbol]:=Module[{},


	(* distribution cases *)
	SetDelayed[
		qName[testQuantity:DistributionP[], fixedQuantity:DistributionP[]],
		qName[Mean[testQuantity], Mean[fixedQuantity]]
	];
	SetDelayed[
		qName[testQuantity_, fixedQuantity:DistributionP[]],
		qName[testQuantity, Mean[fixedQuantity]]
	];
	SetDelayed[
		qName[testQuantity:DistributionP[], fixedQuantity_],
		qName[Mean[testQuantity], fixedQuantity]
	];

	(* numeric case *)
	SetDelayed[
		qName[testQuantity_, fixedQuantity_?NumericQ],
		Quiet[
			TrueQ[funcItCalls[testQuantity, fixedQuantity]],
			{General::nord2, Less::nord2, LessEqual::nord2, Greater::nord2, GreaterEqual::nord2, Equal::nord2}
		]
	];

	(* quantity super simple yet popular case *)
	SetDelayed[
		qName[testQuantity:Quantity[magnitudeA_, units_], fixedQuantity:Quantity[magnitudeB_, units_]],
		Quiet[
			TrueQ[funcItCalls[magnitudeA, magnitudeB]],
			{General::nord2, Less::nord2, LessEqual::nord2, Greater::nord2, GreaterEqual::nord2, Equal::nord2}
		]
	];

	(* quantity general case *)
	SetDelayed[
		qName[testQuantity_, fixedQuantity:UnitsP[]],
		If[Quiet[UnitsQ[testQuantity] && compatibleUnitQold[fixedQuantity, testQuantity], {Quantity::unkunit}],
			Quiet[
				TrueQ[funcItCalls[testQuantity, fixedQuantity]],
				{General::nord2, Less::nord2, LessEqual::nord2, Greater::nord2, GreaterEqual::nord2, Equal::nord2}
			],
			False
		]
	];


];


writeDateComparisonPatternFunction[qName_Symbol, funcItCalls_Symbol]:=Module[{},

	(* date case *)
	SetDelayed[
		qName[testDate_, fixedDate_?DateObjectQ],
		If[DateObjectQ[testDate],
			Quiet[
				TrueQ[funcItCalls[AbsoluteTime[testDate], AbsoluteTime[fixedDate]]],
				{General::nord2, Less::nord2, LessEqual::nord2, Greater::nord2, GreaterEqual::nord2, Equal::nord2}
			],
			False
		]
	];

];


writeDateComparisonWithIncrementPatternFunction[qName_, funcItCalls:Except[Equal, _Symbol]]:=Module[{},

	(* date case *)
	SetDelayed[
		qName[testDate_, fixedDate_?DateObjectQ, increment:UnitsP[]],
		With[{zeroVal=0 * increment},
			And[
				qName[testDate, fixedDate],
				(* Weirdly, precision for Dates is different than the precision for Units. *)
				(* Seems to be 27^-9 but use 10^-8 to be sure since this seems to change *)
				Equal[modRound[Abs[DateObject[AbsoluteTime[testDate]] - DateObject[AbsoluteTime[fixedDate]]], increment, 10.^-8 * increment], zeroVal]
			]
		]];

];


writeQuantityComparisonWithIncrementPatternFunction[qName_, funcItCalls:Except[Equal, _Symbol]]:=Module[{},


	(* distribution cases *)
	SetDelayed[
		qName[testQuantity:DistributionP[], fixedQuantity:DistributionP[], increment_],
		qName[Mean[testQuantity], Mean[fixedQuantity], increment]
	];
	SetDelayed[
		qName[testQuantity_, fixedQuantity:DistributionP[], increment_],
		qName[testQuantity, Mean[fixedQuantity], increment]
	];
	SetDelayed[
		qName[testQuantity:DistributionP[], fixedQuantity_, increment_],
		qName[Mean[testQuantity], fixedQuantity, increment]
	];

	(* integer + 1 increment *)
	(* in this case increment condition is just that value is an integer *)
	SetDelayed[
		qName[testQuantity_, fixedQuantity_Integer, increment:1],
		And[
			qName[testQuantity, fixedQuantity],
			If[MatchQ[testQuantity, _Quantity],
				Equal[Mod[Abs[Convert[testQuantity, 1] - fixedQuantity], increment], 0],
				IntegerQ[testQuantity]
			]
		]];

	(* integer + integer increment *)
	SetDelayed[
		qName[testQuantity_, fixedQuantity_Integer, increment_Integer],
		And[
			qName[testQuantity, fixedQuantity],
			If[MatchQ[testQuantity, _Quantity],
				Equal[Mod[Abs[Convert[testQuantity, 1] - fixedQuantity], increment], 0],
				Equal[Mod[Abs[testQuantity - fixedQuantity], increment], 0]
			]
		]];

	(* numeric *)
	SetDelayed[
		qName[testQuantity_, fixedQuantity_?NumericQ, increment_?NumericQ],
		With[{zeroVal=0 * increment},
			And[
				qName[testQuantity, fixedQuantity],
				Equal[modRound[Abs[testQuantity - fixedQuantity], increment, 10.^-12 * increment], zeroVal]
			]
		]];


	(* quantity or mixed *)
	SetDelayed[
		qName[testQuantity_, fixedQuantity:UnitsP[], increment:UnitsP[]],
		With[{zeroVal=0 * increment},
			And[
				qName[testQuantity, fixedQuantity],
				Equal[modRound[Abs[testQuantity - fixedQuantity], increment, 10.^-12 * increment], zeroVal]
			]
		]]


];




writeComparisonPatternFunction[pName_, qName_, funcItCalls_]:=(
	writeComparisonPatternRedirects[pName, qName, funcItCalls];
	writeDateComparisonPatternFunction[qName, funcItCalls];
	writeDateComparisonWithIncrementPatternFunction[qName, funcItCalls];
	writeQuantityComparisonPatternFunction[qName, funcItCalls];
	writeQuantityComparisonWithIncrementPatternFunction[qName, funcItCalls];
);

MapThread[writeComparisonPatternFunction, Transpose[{
	{EqualP, EqualQ, Equal},
	{GreaterP, GreaterQ, Greater},
	{GreaterEqualP, GreaterEqualQ, GreaterEqual},
	{LessP, LessQ, Less},
	{LessEqualP, LessEqualQ, LessEqual}
}]];


(* ::Subsubsection:: *)
(*RangeP*)


DefineOptions[RangeP,
	Options :> {
		{Inclusive -> All, Left | Right | All | None, "Defines which comparisons are inclusive (e.g. LessEqual vs Less)."}
	}
];

RangeP::InvalidIncrement="Increment has to be non-zero.";

(* overloads with no options so we don't call OptionValue since first call takes 1ms on every execution *)
RangeP[lower:UnitsP[], upper:UnitsP[]]:=With[
	{
		leftComparator=First@comparatorsFromInclusiveOption[All],
		rightComparator=Last@comparatorsFromInclusiveOption[All]
	},
	PatternTest[
		UnitsP[],
		Function[
			testQuantity,
			Which[
				(* we can compare to only one quantity instead of lower and upper because we already know that lower and upper are compatible units *)
				(* adding the sameUnitsQ check to get a performance boost if we have exactly the same units and can short circuit *)
				sameUnitsQ[lower, testQuantity, upper],
					With[{lowerMag = QuantityMagnitude[lower], testMag = QuantityMagnitude[testQuantity], upperMag = QuantityMagnitude[upper]},
						And[leftComparator[lowerMag, testMag], rightComparator[testMag, upperMag]]
					],
				Quiet[compatibleUnitQold[lower, testQuantity], {Quantity::unkunit}],
					And[leftComparator[lower, testQuantity], rightComparator[testQuantity, upper]], (* explicitly written like this to avoid the three-argument version of comparison functions which miss the upvalues we added *)
				True, False
			]
		]
	]
]/;(sameUnitsQ[lower, upper] || Quiet[compatibleUnitQold[lower, upper], {Quantity::unkunit}]);

RangeP[lower_?DateObjectQ, upper_?DateObjectQ]:=With[
	{
		leftComparator=First@comparatorsFromInclusiveOption[All],
		rightComparator=Last@comparatorsFromInclusiveOption[All]
	},
	PatternTest[
		_,
		Function[
			testDate,
			If[
				DateObjectQ[testDate],
				And[leftComparator[AbsoluteTime[lower], AbsoluteTime[testDate]], rightComparator[AbsoluteTime[testDate], AbsoluteTime[upper]]], (* explicitly written like this to avoid the three-argument version of comparison functions which miss the upvalues we added *)
				False
			]
		]
	]
];

RangeP[lower:UnitsP[], upper:UnitsP[], ops:OptionsPattern[RangeP]]:=With[
	{
		leftComparator=First@comparatorsFromInclusiveOption[OptionDefault[OptionValue[Inclusive]]],
		rightComparator=Last@comparatorsFromInclusiveOption[OptionDefault[OptionValue[Inclusive]]],
		firstPattern=If[NumericQ[lower], _?NumericQ, _?QuantityQ]
	},
	PatternTest[
		UnitsP[],
		Function[
			testQuantity,
			Which[
				(* we can compare to only one quantity instead of lower and upper because we already know that lower and upper are compatible units *)
				(* in addition, if we have the same units (i.e., only Celsius, not a mix of Celsius and Kelvin), stripping off the unit and doing the comparison on the numbers is substantially faster *)
				sameUnitsQ[lower, testQuantity, upper],
					With[{lowerMag = QuantityMagnitude[lower], testMag = QuantityMagnitude[testQuantity], upperMag = QuantityMagnitude[upper]},
						And[leftComparator[lowerMag, testMag], rightComparator[testMag, upperMag]]
					],
				Quiet[compatibleUnitQold[lower, testQuantity], {Quantity::unkunit}],
					And[leftComparator[lower, testQuantity], rightComparator[testQuantity, upper]], (* explicitly written like this to avoid the three-argument version of comparison functions which miss the upvalues we added *)
				True, False
			]
		]
	]
]/;(sameUnitsQ[lower, upper] || Quiet[compatibleUnitQold[lower, upper], {Quantity::unkunit}]);


(* RangeP[lower, upper] for date *)
RangeP[lower_?DateObjectQ, upper_?DateObjectQ, ops:OptionsPattern[RangeP]]:=With[
	{
		leftComparator=First@comparatorsFromInclusiveOption[OptionDefault[OptionValue[Inclusive]]],
		rightComparator=Last@comparatorsFromInclusiveOption[OptionDefault[OptionValue[Inclusive]]]
	},
	PatternTest[
		_,
		Function[
			testDate,
			If[
				DateObjectQ[testDate],
				(* explicitly written like this to avoid the three-argument version of comparison functions which miss the upvalues we added *)
				And[leftComparator[AbsoluteTime[lower], AbsoluteTime[testDate]], rightComparator[AbsoluteTime[testDate], AbsoluteTime[upper]]],
				False
			]
		]
	]
];


RangeP[-Infinity, Infinity, ops:OptionsPattern[]]:=UnitsP[1];
RangeP[Quantity[-Infinity, un_], Quantity[Infinity, un_], ops:OptionsPattern[]]:=UnitsP[Quantity[1, un]];


RangeP[lower:UnitsP[], upper:UnitsP[], increment:UnitsP[], ops:OptionsPattern[RangeP]]:=With[
	{zeroVal=0 * increment},
	PatternTest[
		RangeP[lower, upper, ops],
		Function[
			testQuantity,
			Equal[modRound[testQuantity - lower, increment, 10.^-12 * increment], zeroVal]
		]
	]
]/;(sameUnitsQ[lower, upper] || Quiet[compatibleUnitQold[lower, upper], {Quantity::unkunit}]);


(* RangeP[lower, upper, increment] for date *)
RangeP[lower_?DateObjectQ, upper_?DateObjectQ, increment:UnitsP[], ops:OptionsPattern[RangeP]]:=With[
	{zeroVal=0 * increment},
	PatternTest[
		RangeP[lower, upper, ops],
		Function[
			testDate,
			Equal[modRound[Abs[DateObject[AbsoluteTime[testDate]] - DateObject[AbsoluteTime[lower]]], increment, 10.^-12 * increment], zeroVal]
		]
	]
];

RangeP[increment:UnitsP[]/;QuantityMagnitude[increment]==0]:=Message[RangeP::InvalidIncrement];

RangeP[increment:UnitsP[], ops:OptionsPattern[]]:=With[
	{zeroVal=0 * increment},
	PatternTest[
		UnitsP[],
		Function[
			testQuantity,
			Equal[modRound[testQuantity, increment, 10.^-12 * increment], zeroVal]
		]
	]
];


comparatorsFromInclusiveOption[All]:={LessEqual, LessEqual};
comparatorsFromInclusiveOption[None]:={Less, Less};
comparatorsFromInclusiveOption[Left]:={LessEqual, Less};
comparatorsFromInclusiveOption[Right]:={Less, LessEqual};

(*
	Need this to allow for Infinity in the bounds
*)
compatibleUnitInfinityQ[Infinity | -Infinity, _?NumericQ]:=True;
compatibleUnitInfinityQ[_?NumericQ, Infinity | -Infinity]:=True;
compatibleUnitInfinityQ[Infinity | -Infinity, Infinity | -Infinity]:=True;
compatibleUnitInfinityQ[a_, b_]:=compatibleUnitQold[a, b];


(* ::Subsubsection:: *)
(*RangeQ*)


DefineOptions[RangeQ,
	Options :> {
		{Inclusive -> True, BooleanP, "If set to true will inclusively accept any values in the range (greater than or equal to the min and geater than or equal to the max)."}
	}];

RangeQ::IncompatibleDimensions="Dimensions of array `1` do not match dimensions of range list `2`.";
RangeQ::NotConvertable="Cannot convert `1`, `2` and `3` into same Units for comparison.  Check compatibleUnitQold for possible conversion.";


(* --- Core function Numeric Quantities --- *)
RangeQ[value_?NumericQ, span:(List | Span)[min:(_?InfiniteNumericQ | Null), max:(_?InfiniteNumericQ | Null)], ops:OptionsPattern[RangeQ]]:=With[
	{
		minN=Replace[min, Null -> -Infinity],
		maxN=Replace[max, Null -> Infinity],
		comp=Switch[OptionDefault[OptionValue[Inclusive]], True, LessEqual, False, Less]
	},
	And[comp[minN, value], comp[value, maxN]]
];

(* --- Unit version --- *)
RangeQ[value_?UnitsQ, span:(List | Span)[min:(_?UnitsQ | Null), max:(_?UnitsQ | Null)], ops:OptionsPattern[RangeQ]]:=Module[{numMin, numMax, unitList},

	(* Safely defuse inifinate values *)
	numMin=If[MatchQ[min, Times[_?UnitsQ, DirectedInfinity[-1]] | DirectedInfinity[-1]],
		Null,
		min
	];
	numMax=If[MatchQ[max, Times[_?UnitsQ, DirectedInfinity[1]] | DirectedInfinity[1]],
		Null,
		max
	];

	(* Select out any non null constraints safely difusing infinity *)
	unitList=Cases[{numMin, numMax}, Except[Null]];

	(* If there are no constraints, or the Units are all convertable *)
	If[MatchQ[unitList, {}] || compatibleUnitQold[Prepend[unitList, value]],
		Module[{valueUnits, unitlessValue, unitlessMin, unitlessMax},

			(* Obtain the Units of the value, by checking to see what has values on it *)
			valueUnits=Which[
				!MatchQ[value, 0 | Null], Units[value],
				!MatchQ[numMin, 0 | Null], Units[numMin],
				!MatchQ[numMax, 0 | Null], Units[numMax],
				(* In the edge case that everything is 0, Null, or infinity, Bypass unit converson *)
				MatchQ[value, 0 | Null] && MatchQ[numMin, 0 | Null] && MatchQ[numMax, 0 | Null], Return[RangeQ[value, Span[numMin, numMax], ops]]
			];

			(* Strip the Units of A and B, converting to A Units during the removal *)
			unitlessValue=Unitless[value, valueUnits];
			unitlessMin=If[MatchQ[numMin, Null], Null, Unitless[numMin, valueUnits]];
			unitlessMax=If[MatchQ[numMax, Null], Null, Unitless[numMax, valueUnits]];

			(* Check to see if the Unitless quantities are the same *)
			RangeQ[unitlessValue, Span[unitlessMin, unitlessMax], PassOptions[RangeQ, ops]]

		],
		Message[RangeQ::NotConvertable, value, numMin, numMax]
	]
];



(* ::Text:: *)
(*Overloads*)


(*Map over values*)
RangeQ[values:{_?NumericQ...}, span:(List | Span)[(_?InfiniteNumericQ | Null), (_?InfiniteNumericQ | Null)], ops:OptionsPattern[RangeQ]]:=With[
	{options=OptionDefaults[RangeQ, ToList[ops]]},

	Map[
		RangeQ[#, span, Apply[Sequence, options]]&,
		values
	]
];
RangeQ[values:{_?UnitsQ...}, span:(List | Span)[(_?UnitsQ | Null), (_?UnitsQ | Null)], ops:OptionsPattern[RangeQ]]:=With[
	{options=OptionDefaults[RangeQ, ToList[ops]]},

	Map[
		RangeQ[#, span, Apply[Sequence, options]]&,
		values
	]
];

(*Map over spans*)
RangeQ[value:_?NumericQ, spans:{((List | Span)[(_?InfiniteNumericQ | Null), (_?InfiniteNumericQ | Null)])...}, ops:OptionsPattern[RangeQ]]:=With[
	{options=OptionDefaults[RangeQ, ToList[ops]]},

	Map[
		RangeQ[value, #, Apply[Sequence, options]]&,
		spans
	]
];
RangeQ[value:_?UnitsQ, spans:{((List | Span)[(_?UnitsQ | Null), (_?UnitsQ | Null)])...}, ops:OptionsPattern[RangeQ]]:=With[
	{options=OptionDefaults[RangeQ, ToList[ops]]},

	Map[
		RangeQ[value, #, Apply[Sequence, options]]&,
		spans
	]
];

(*MapThread over values and spans*)
RangeQ[values:{_?NumericQ...}, spans:{((List | Span)[(_?InfiniteNumericQ | Null), (_?InfiniteNumericQ | Null)])...}, ops:OptionsPattern[RangeQ]]:=With[
	{options=OptionDefaults[RangeQ, ToList[ops]]},

	MapThread[
		RangeQ[#1, #2, Apply[Sequence, options]]&,
		{values, spans}
	]
];
RangeQ[values:{_?UnitsQ...}, spans:{((List | Span)[(_?UnitsQ | Null), (_?UnitsQ | Null)])...}, ops:OptionsPattern[RangeQ]]:=With[
	{options=OptionDefaults[RangeQ, ToList[ops]]},

	MapThread[
		RangeQ[#1, #2, Apply[Sequence, options]]&,
		{values, spans}
	]
];


(* ::Text:: *)
(*QuantityArray*)


RangeQ[qa:quantityArrayRawP1D, span:Span[min:(_?UnitsQ | Null), max:(_?UnitsQ | Null)], ops:OptionsPattern[RangeQ]]:=Module[
	{unit, minRaw, maxRaw, qaRaw, comp, inclusiveBool},
	inclusiveBool=OptionDefault[OptionValue[Inclusive]];
	unit=Units[min];

	minRaw=Check[
		Unitless[min, unit],
		Return[$Failed],
		{Quantity::compat}
	];

	maxRaw=Check[
		Unitless[max, unit],
		Return[$Failed],
		{Quantity::compat}
	];

	qaRaw=Check[
		Unitless[qa, unit],
		Return[$Failed],
		{Quantity::compat}
	];

	comp=Switch[inclusiveBool,
		True, LessEqual,
		False, Less
	];

	With[{c=comp},
		AllTrue[qaRaw, And[c[minRaw, #], c[#, maxRaw]]&]
	]

];


RangeQ[qa:quantityArrayRawP2D, spans:{Span[_?UnitsQ | Null, _?UnitsQ | Null]..}, ops:OptionsPattern[RangeQ]]:=Module[
	{mins, maxs, units, minsRaw, maxsRaw, qaRaw, comp, inclusiveBool},

	If[!MatchQ[Length[spans], Last[Dimensions[qa]]],
		Message[RangeQ::IncompatibleDimensions, qa, spans];
		Return[$Failed];
	];

	inclusiveBool=OptionDefault[OptionValue[Inclusive]];

	mins=spans[[;;, 1]];
	maxs=spans[[;;, 2]];

	(* get list of units for each component of second dimension *)
	units=Units[mins];

	qaRaw=Check[
		Unitless[qa, units],
		Return[$Failed],
		{Quantity::compat}
	];

	minsRaw=Check[
		Unitless[mins, units],
		Return[$Failed],
		{Quantity::compat}
	];

	maxsRaw=Check[
		Unitless[maxs, units],
		Return[$Failed],
		{Quantity::compat}
	];

	comp=Switch[inclusiveBool,
		True, LessEqual,
		False, Less
	];

	And @@ MapThread[And @@ Map[Function[val, And[comp[#2, val], comp[val, #3]]], #1]&, {Transpose[qaRaw], minsRaw, maxsRaw}]

];


(* ::Subsubsection::Closed:: *)
(*All_ comparisons*)


(* ::Text:: *)
(*Numerical arrays*)


Function[
	{compF, comp},
	(* Any size array compared to scalar value *)
	compF[narray_?(ArrayQ[#, _, NumericQ]&), val_?NumericQ]:=With[
		{d=Dimensions[narray]},
		AllTrue[narray, comp[#, val]&, Length[d]]
	];
	(* Any size array compared to list of values *)
	compF[narray_?(ArrayQ[#, _, NumericQ]&), vals:{_?NumericQ..}]:=With[
		{dims=Dimensions[narray], l=Length[vals]},
		If[!MatchQ[Last[dims], l], Return[False]];
		AllTrue[narray, And @@ Thread[comp[#, vals]]&, Length[dims] - 1]
	];
] @@@ {
	{AllGreater, Greater},
	{AllGreaterEqual, GreaterEqual},
	{AllLess, Less},
	{AllLessEqual, LessEqual}
};


(* ::Text:: *)
(*Quantity Arrays*)


(* turn it into a numerical array comparison problem *)


Function[
	compF,
	(* Any size array compared to scalar value *)
	compF[qa:QuantityArrayP[], val:UnitsP[]]:=With[
		{d=Dimensions[qa], narray=Quiet[Check[Unitless[qa, val], $Failed]], nval=Unitless[val]},
		If[MatchQ[narray, $Failed], Return[False]];
		compF[narray, nval]
	];
	(* Any size array compared to list of values *)
	compF[qa:QuantityArrayP[], vals:{UnitsP[]..}]:=With[
		{d=Dimensions[qa], narray=Quiet[Check[Unitless[qa, vals], $Failed]], nvals=Unitless[vals]},
		If[MatchQ[narray, $Failed], Return[False]];
		compF[narray, nvals]
	];
] /@ {AllGreater, AllGreaterEqual, AllLess, AllLessEqual};


(* ::Subsection::Closed:: *)
(*Array Patterns*)


(* ::Subsubsection::Closed:: *)
(*MatrixP*)


MatrixP[]:=_?MatrixQ;
MatrixP[patt_]:=PatternTest[_, And[MatrixQ[#], MatchQ[Flatten[#], {patt...}]]&];


(* ::Subsection::Closed:: *)
(*QuantityPartition*)


(* ::Subsubsection::Closed:: *)
(*QuantityPartition Options and Messages*)


DefineOptions[QuantityPartition,
	Options :> {
		{MinPartition -> Null, Null | PositiveQuantityP | (_Integer), "The minimum size of a partition that will be returned."}
	}
];

QuantityPartition::IncompatibleUnits="Some provided quantities are not in compatible units. Please check compatibleUnitQold on the inputs, and (if provided) the MinPartition option value.";
QuantityPartition::MinAboveMax="The provided MinPartition option, `1`, exceeds the requested maximum partition size (`2`). Please ensure that the minimum partition size cutoff is below the maximum partiion size.";


(* ::Subsubsection::Closed:: *)
(*QuantityPartition*)


QuantityPartition[myAmountToPartition:PositiveQuantityP | GreaterP[0], myMaxPartition:PositiveQuantityP | GreaterP[0], myOptions:OptionsPattern[]]:=Module[
	{minPartitionAmount, rawPartitions},

	(* default any unspecified or incorrectly-specified options and assign options to local variables *)
	minPartitionAmount=OptionDefault[OptionValue[MinPartition]];

	(* return an error if the amount to partition and max partition size are not in compatible units;
		 include the option value if present *)
	Which[
		!NullQ[minPartitionAmount] && MatchQ[myAmountToPartition, GreaterP[0]] && !MatchQ[myMaxPartition, GreaterP[0]],
		Message[QuantityPartition::IncompatibleUnits];
		Return[$Failed],
		!NullQ[minPartitionAmount] && MatchQ[myAmountToPartition, Except[GreaterP[0]]] && MatchQ[minPartitionAmount, GreaterP[0]],
		Message[QuantityPartition::IncompatibleUnits];
		Return[$Failed],
		!NullQ[minPartitionAmount] && !compatibleUnitQold[myAmountToPartition, myMaxPartition, minPartitionAmount],
		Message[QuantityPartition::IncompatibleUnits];
		Return[$Failed],
		!compatibleUnitQold[myAmountToPartition, myMaxPartition],
		Message[QuantityPartition::IncompatibleUnits];
		Return[$Failed]
	];

	(* if the min partition size is smaller than the max, throw an error *)
	If[!NullQ[minPartitionAmount] && minPartitionAmount >= myMaxPartition,
		Message[QuantityPartition::MinAboveMax, minPartitionAmount, myMaxPartition];
		Return[$Failed]
	];

	(* Split up the amount into workable pieces *)
	rawPartitions=DeleteCases[
		If[myAmountToPartition > myMaxPartition,
			Append[Table[myMaxPartition, {Floor[myAmountToPartition / myMaxPartition]}], Mod[myAmountToPartition, myMaxPartition]],
			{myAmountToPartition}
		],
		Alternatives[Quantity[0 | 0., _], 0, 0.]
	];

	(* Remove overly small partitions, if that option was provided *)
	If[!NullQ[minPartitionAmount],
		DeleteCases[rawPartitions, LessP[minPartitionAmount]],
		rawPartitions
	]
];


(* ::Subsection::Closed:: *)
(*Unit Blobs*)


(* ::Subsubsection::Closed:: *)
(*QuantityArray*)


installEmeraldQuantityArrayBlobs[]:=Module[{},

	(* initialize QuantityArray's FormatValues by calling it *)
	QuantityArray[{}, "Meters"];
	(*
		these lines are critical.  if you don't display the QA, it doesn't trigger the BoxFormAutoLoad,
		which is what makes the other formatting definitions
	  therefore we must call MakeBoxes directly to get them to load, and clear the autoload
	  this seems to be a new thing in 11.3
	*)
	MakeBoxes[QuantityArray[StructuredArray`StructuredData[{1}, {{1}, "Meters", {{1}}}]], StandardForm];
	Unprotect[QuantityArray];

	PrependTo[FormatValues[QuantityArray],
		HoldPattern[
			MakeBoxes[
				qa_QuantityArray,
				StandardForm
			]/; And[
				BoxForm`UseIcons,
				(* 
					this checks validity, since pattern now has to be just _QuantityArray.
					Without this line invalid QuantityArrays can get stuck in display loops,
					because the returned unevaluated expression also matches _QuantityArray,
					so it tries to render again, etc..
				*)
				Or[
					StructuredArray`HeldStructuredArrayQ[qa],
					System`Private`ValidQ[Unevaluated[qa]]
				]
		]] :> With[
			{outputBoxes=ToBoxes[
				(* shorten a QA if it's longer than a certain length *)
				Tooltip[With[{n=Length[qa]},
					(*
						Turn the QA into a list of quantities, for display in the blob.
						Note: DO NOT use 'Normal', because it converts dimensionless things like Percentages into the '1' unit
					*)
					If[n <= 30,
						QA2AQ[qa],
						(* show just the first 2 and last 2 elements, with Skeleon in the midde *)
						Join[QA2AQ[qa[[1;;2]]], {Skeleton[n - 4]}, QA2AQ[qa[[-2;;]]]]
					]
				], QuantityArray]
			]
			},
			(* use InterpretationBox so copy-paste works *)
			InterpretationBox[outputBoxes, qa]
			(* flag to turn it on and off *)
		]/;TrueQ[$QuantityArrayBlobs]
	];
	Protect[QuantityArray];

	$QuantityArrayBlobs=True;

];

installEmeraldQuantityArrayBlobsStructuredArray[]:=Module[{},

	(* initialize QuantityArray's FormatValues by calling it *)
	QuantityArray[{}, "Meters"];
	(*
		these lines are critical.  if you don't display the QA, it doesn't trigger the BoxFormAutoLoad,
		which is what makes the other formatting definitions
	  therefore we must call MakeBoxes directly to get them to load, and clear the autoload
	  this seems to be a new thing in 11.3
	*)
	MakeBoxes[StructuredArray[QuantityArray, {1}, StructuredArray`StructuredData[QuantityArray, {1}, "Meters", {{1}}]], StandardForm];

	Unprotect[StructuredArray];

	PrependTo[FormatValues[StructuredArray],
		HoldPattern[
			MakeBoxes[
				qa:StructuredArray[QuantityArray, dims_, qdata_],
				StandardForm
			]/;BoxForm`UseIcons && System`Private`ValidQ[Unevaluated[qa]]
		] :> With[
			{outputBoxes=ToBoxes[
				(* shorten a QA if it's longer than a certain length *)
				Tooltip[With[{n=Length[qa]},
					(*
						Turn the QA into a list of quantities, for display in the blob.
						Note: DO NOT use 'Normal', because it converts dimensionless things like Percentages into the '1' unit
					*)
					If[n <= 30,
						QA2AQ[qa],
						(* show just the first 2 and last 2 elements, with Skeleon in the midde *)
						Join[QA2AQ[qa[[1;;2]]], {Skeleton[n - 4]}, QA2AQ[qa[[-2;;]]]]
					]
				], QuantityArray]
			]
			},
			(* use InterpretationBox so copy-paste works *)
			InterpretationBox[outputBoxes, qa]
			(* flag to turn it on and off *)
		]/;TrueQ[$QuantityArrayBlobs]
	];
	Protect[StructuredArray];

	$QuantityArrayBlobs=True;

];

listableQuantity[in___]:=Quantity[in];
SetAttributes[listableQuantity, Listable];
(* QuantityArray to Array of Quantities *)
QA2AQ[qa_]:=With[
	{uns=QuantityUnit[qa], mags=QuantityMagnitude[qa]},
	listableQuantity[mags, uns]
];

(*
	Special definition for multiplying two quantities with unit magnitude.
	Just makes it a little faster.
*)
If[$LazyLoading,
	Quantity[1, "Meters"];
	Unprotect[Quantity];

	(*Units should be able to cancel each other under division. e.g. Quantity[1, "Meters"]/Quantity[1, "Meters"] should be 1.*)
	PrependTo[UpValues[Quantity], HoldPattern[Times[Quantity[1, unA_], Quantity[1, unB_]]] :>
     If[UnitDimensions[unA]===UnitDimensions[1/unB],
		 UnitSimplify[Quantity[1, unA*unB]],
		 Quantity[1, unA * unB]
	 ]
	];

	Protect[Quantity];
];


(* need Onload because definitions not associated with our symbols *)
OnLoad[

	(*
		TEMPORARY -- remove this when redmine 1730 is resolved.
		We force install UnitTable paclet 12.2.3, but some of the junk from the prevoius
		paclet version sometimes lingers until you Quit kernel.
		To get around this for now we force mathematica to have the desired unit dimensions for "Lumens"
		this is used by MM to evaluate UnitDimensions["Lumens"]
	*)
	If[
		QuantityUnits`$UnitTable["Lumens"]["UnitDimensions"] == "LuminousIntensityUnit" "SolidAngleUnit",
		(
			QuantityUnits`$UnitTable["Lumens"]["UnitDimensions"] = ( "AngleUnit"^2) "LuminousIntensityUnit";
			QuantityUnits`$UnitTable["Lumens"]["FundamentalUnitValue"] = "Candelas" *("Radians"^2);
		)
	];


	If[$VersionNumber > 12.0,
		installEmeraldQuantityArrayBlobs[],
		installEmeraldQuantityArrayBlobsStructuredArray[]
	];
	updateUnitPaclets[];
];



(* Hard code the TextString conversions for ECL units (TextString[quantity]) *)
unitTextStringForms = {
	"AbsorbanceUnit" -> "AbsorbanceUnit",
	"Ampere" -> "A",
	"Angstrom" -> "\[CapitalARing]",
	"AngularDegree" -> "\[Degree]",
	"AnisotropyUnit" -> "AnisotropyUnits",
	"ArbitraryUnit" -> "ArbitraryUnits",
	"Atmosphere" -> "atm",
	"Bar" -> "bar",
	"BasePair" -> "Basepairs",
	"Calorie" -> "thermochemical calories",
	"Celsius" -> "\[Degree]C",
	"Centimeter" -> "cm",
	"Century" -> "centuries",
	"CFU" -> "Cfus",
	"Colony" -> "Colonies",
	"Coulomb" -> "C",
	"Cup" -> "c",
	"Cycle" -> "Cycles",
	"Dalton" -> "g/mol",
	"Day" -> "days",
	"Decade" -> "decades",
	(*"Dozen" -> "doz.", Ignore this unit. Not useful and causes a headache because the unit ends with "." and doz could also be deci-ounce*)
	"ElectronVolt" -> "eV",
	"EmeraldCell" -> "Cells",
	"Event" -> "Events",
	"Fahrenheit" -> "\[Degree]F",
	"FluidOunce" -> "fl oz",
	"Foot" -> "ft",
	"FormazinNephelometricUnit" -> "FormazinTurbidityUnits",
	"FormazinTurbidityUnit" -> "FormazinTurbidityUnits",
	"Gallon" -> "gal",
	"Gram" -> "g",
	"GravitationalAcceleration" -> "standard accelerations due to gravity on the surface of the earth",
	"Gross" -> "gross",
	"Hertz" -> "Hz",
	"Hour" -> "h",
	"Inch" -> "in",
	"InternationalUnit" -> "IU",
	"ISO" -> "ISO",
	"Joule" -> "J",
	"Kelvin" -> "K",
	"KilocaloriesThermochemical" -> "thermochemical kilocalories",
	"Liter" -> "L",
	"LSU" -> "Lsus",
	"Lumen" -> "lm",
	"Lux" -> "lumens per foot squared",
	"MassPercent" -> "MassPercent",
	"MegacaloriesThermochemical" -> "thermochemical megacalories",
	"Meter" -> "m",
	"Micron" -> "\[Mu]m",
	"Mile" -> "mi",
	"Millennium" -> "millennia",
	"MilliAbsorbanceUnit" -> "milli AbsorbanceUnit",
	"MillimeterMercury" -> "mmHg",
	"Millimicron" -> "millimicrons",
	"Millinewton" -> "mN",
	"MilliPolarizationUnit" -> "milli PolarizationUnits",
	"Minute" -> "min",
	"Molar" -> "M",
	"Mole" -> "mol",
	"Month" -> "mo",
	"NephelometricTurbidityUnit" -> "NephelometricTurbidityUnits",
	"Newton" -> "N",
	"Nucleotide" -> "Nucleotides",
	"OD600" -> "OD600s",
	"Ohm" -> "\[CapitalOmega]",
	"Ounce" -> "oz",
	"Particle" -> "Particles",
	"Pascal" -> "Pa",
	"Percent" -> "%",
	"PercentConfluency" -> "PercentConfluency",
	"Pint" -> "pt",
	"Pixel" -> "Pixels",
	"Poise" -> "P",
	"PolarizationUnit" -> "PolarizationUnits",
	"Pound" -> "lb",
	"PoundFoot" -> "ft\[ThinSpace]lbf",
	"PPB" -> "ppb",
	"PPM" -> "ppm",
	"PSI" -> "pounds\[Hyphen]force per inch squared",
	"Quart" -> "qt",
	"Radian" -> "rad",
	"RefractiveIndexUnit" -> "RefractiveIndexUnits",
	"RelativeNephelometricUnit" -> "RelativeNephelometricUnits",
	"Revolution" -> "rev",
	"RFU" -> "Rfus",
	"RLU" -> "Rlus",
	"RPM" -> "rev/min",
	"RRT" -> "RRT",
	"Second" -> "s",
	"Siemens" -> "S",
	"Stone" -> "stone",
	"Tesla" -> "T",
	"Ton" -> "sh tn",
	"Torr" -> "Torr",
	"Unit" -> "U",
	"USD" -> "$",
	"Volt" -> "V",
	"VolumePercent" -> "VolumePercent",
	"Watt" -> "W",
	"Week" -> "wk",
	"WeightVolumePercent" -> "WeightVolumePercent",
	"Yard" -> "yd",
	"Year" -> "yr"
};

(* Hard code the ToString conversions for ECL units (ToString[quantity]) *)
unitToStringForms = {
	"AbsorbanceUnit" -> "AbsorbanceUnit",
	"Ampere" -> "ampere",
	"Angstrom" -> "\[ARing]ngstr\[ODoubleDot]m",
	"AngularDegree" -> "degree",
	"AnisotropyUnit" -> "AnisotropyUnits",
	"ArbitraryUnit" -> "ArbitraryUnits",
	"Atmosphere" -> "atmosphere",
	"Bar" -> "bar",
	"BasePair" -> "Basepairs",
	"Calorie" -> "thermochemical calorie",
	"Celsius" -> "degree Celsius",
	"Centimeter" -> "centimeter",
	"Century" -> "century",
	"CFU" -> "Cfus",
	"Colony" -> "Colonies",
	"Coulomb" -> "coulomb",
	"Cup" -> "cup",
	"Cycle" -> "Cycles",
	"Dalton" -> "gram per mole",
	"Day" -> "day",
	"Decade" -> "decade",
	"Dozen" -> "dozen",
	"ElectronVolt" -> "electronvolt",
	"EmeraldCell" -> "Cells",
	"Event" -> "Events",
	"Fahrenheit" -> "degree Fahrenheit",
	"FluidOunce" -> "fluid ounce",
	"Foot" -> "foot",
	"FormazinNephelometricUnit" -> "FormazinTurbidityUnits",
	"FormazinTurbidityUnit" -> "FormazinTurbidityUnits",
	"Gallon" -> "gallon",
	"Gram" -> "gram",
	"GravitationalAcceleration" -> "standard acceleration due to gravity on the surface of the earth",
	"Gross" -> "gross",
	"Hertz" -> "hertz",
	"Hour" -> "hour",
	"Inch" -> "inch",
	"InternationalUnit" -> "international unit",
	"ISO" -> "ISO",
	"Joule" -> "joule",
	"Kelvin" -> "kelvin",
	"KilocaloriesThermochemical" -> "thermochemical kilocalorie",
	"Liter" -> "liter",
	"LSU" -> "Lsus",
	"Lumen" -> "lumen",
	"Lux" -> "lumen per foot squared",
	"MassPercent" -> "MassPercent",
	"MegacaloriesThermochemical" -> "thermochemical megacalorie",
	"Meter" -> "meter",
	"Micron" -> "micrometer",
	"Mile" -> "mile",
	"Millennium" -> "millennium",
	"MilliAbsorbanceUnit" -> "milli AbsorbanceUnit",
	"MillimeterMercury" -> "millimeter of mercury",
	"Millimicron" -> "millimicron",
	"Millinewton" -> "millinewton",
	"MilliPolarizationUnit" -> "milli PolarizationUnits",
	"Minute" -> "minute",
	"Molar" -> "molar",
	"Mole" -> "mole",
	"Month" -> "month",
	"NephelometricTurbidityUnit" -> "NephelometricTurbidityUnits",
	"Newton" -> "newton",
	"Nucleotide" -> "Nucleotides",
	"OD600" -> "OD600s",
	"Ohm" -> "ohm",
	"Ounce" -> "ounce",
	"Particle" -> "Particles",
	"Pascal" -> "pascal",
	"Percent" -> "percent",
	"PercentConfluency" -> "PercentConfluency",
	"Pint" -> "pint",
	"Pixel" -> "Pixels",
	"Poise" -> "poise",
	"PolarizationUnit" -> "PolarizationUnits",
	"Pound" -> "pound",
	"PoundFoot" -> "foot pound\[Hyphen]force",
	"PPB" -> "part per billion",
	"PPM" -> "part per million",
	"PSI" -> "pound\[Hyphen]force per inch squared",
	"Quart" -> "quart",
	"Radian" -> "radian",
	"RefractiveIndexUnit" -> "RefractiveIndexUnits",
	"RelativeNephelometricUnit" -> "RelativeNephelometricUnits",
	"Revolution" -> "revolution",
	"RFU" -> "Rfus",
	"RLU" -> "Rlus",
	"RPM" -> "revolution per minute",
	"RRT" -> "RRT",
	"Second" -> "second",
	"Siemens" -> "siemens",
	"Stone" -> "stone",
	"Tesla" -> "tesla",
	"Ton" -> "short ton",
	"Torr" -> "torr",
	"Unit" -> "unity",
	"USD" -> "US dollar",
	"Volt" -> "volt",
	"VolumePercent" -> "VolumePercent",
	"Watt" -> "watt",
	"Week" -> "week",
	"WeightVolumePercent" -> "WeightVolumePercent",
	"Yard" -> "yard",
	"Year" -> "year"
};

unitToStringPluralForms = {
	"AbsorbanceUnit" -> "AbsorbanceUnit",
	"Ampere" -> "amperes",
	"Angstrom" -> "\[ARing]ngstr\[ODoubleDot]m",
	"AngularDegree" -> "degrees",
	"AnisotropyUnit" -> "AnisotropyUnits",
	"ArbitraryUnit" -> "ArbitraryUnits",
	"Atmosphere" -> "atmospheres",
	"Bar" -> "bars",
	"BasePair" -> "Basepairs",
	"Calorie" -> "thermochemical calories",
	"Celsius" -> "degrees Celsius",
	"Centimeter" -> "centimeters",
	"Century" -> "centuries",
	"CFU" -> "Cfus",
	"Colony" -> "Colonies",
	"Coulomb" -> "coulombs",
	"Cup" -> "cups",
	"Cycle" -> "Cycles",
	"Dalton" -> "grams per mole",
	"Day" -> "days",
	"Decade" -> "decades",
	"Dozen" -> "dozen",
	"ElectronVolt" -> "electronvolts",
	"EmeraldCell" -> "Cells",
	"Event" -> "Events",
	"Fahrenheit" -> "degrees Fahrenheit",
	"FluidOunce" -> "fluid ounces",
	"Foot" -> "feet",
	"FormazinNephelometricUnit" -> "FormazinTurbidityUnits",
	"FormazinTurbidityUnit" -> "FormazinTurbidityUnits",
	"Gallon" -> "gallons",
	"Gram" -> "grams",
	"GravitationalAcceleration" -> "standard accelerations due to gravity on the surface of the earth",
	"Gross" -> "gross",
	"Hertz" -> "hertz",
	"Hour" -> "hours",
	"Inch" -> "inches",
	"InternationalUnit" -> "international units",
	"ISO" -> "ISO",
	"Joule" -> "joules",
	"Kelvin" -> "kelvins",
	"KilocaloriesThermochemical" -> "thermochemical kilocalories",
	"Liter" -> "liters",
	"LSU" -> "Lsus",
	"Lumen" -> "lumens",
	"Lux" -> "lumens per foot squared",
	"MassPercent" -> "MassPercent",
	"MegacaloriesThermochemical" -> "thermochemical megacalorie",
	"Meter" -> "meters",
	"Micron" -> "micrometers",
	"Mile" -> "miles",
	"Millennium" -> "millennia",
	"MilliAbsorbanceUnit" -> "milli AbsorbanceUnit",
	"MillimeterMercury" -> "millimeters of mercury",
	"Millimicron" -> "millimicrons",
	"Millinewton" -> "millinewtons",
	"MilliPolarizationUnit" -> "milli PolarizationUnits",
	"Minute" -> "minutes",
	"Molar" -> "molar",
	"Mole" -> "moles",
	"Month" -> "months",
	"NephelometricTurbidityUnit" -> "NephelometricTurbidityUnits",
	"Newton" -> "newtons",
	"Nucleotide" -> "Nucleotides",
	"OD600" -> "OD600s",
	"Ohm" -> "ohms",
	"Ounce" -> "ounces",
	"Particle" -> "Particles",
	"Pascal" -> "pascals",
	"Percent" -> "percent",
	"PercentConfluency" -> "PercentConfluency",
	"Pint" -> "pints",
	"Pixel" -> "Pixels",
	"Poise" -> "poise",
	"PolarizationUnit" -> "PolarizationUnits",
	"Pound" -> "pounds",
	"PoundFoot" -> "foot pounds\[Hyphen]force",
	"PPB" -> "parts per billion",
	"PPM" -> "parts per million",
	"PSI" -> "pounds\[Hyphen]force per inch squared",
	"Quart" -> "quarts",
	"Radian" -> "radians",
	"RefractiveIndexUnit" -> "RefractiveIndexUnits",
	"RelativeNephelometricUnit" -> "RelativeNephelometricUnits",
	"Revolution" -> "revolutions",
	"RFU" -> "Rfus",
	"RLU" -> "Rlus",
	"RPM" -> "revolutions per minute",
	"RRT" -> "RRT",
	"Second" -> "seconds",
	"Siemens" -> "siemens",
	"Stone" -> "stone",
	"Tesla" -> "teslas",
	"Ton" -> "short tons",
	"Torr" -> "torr",
	"Unit" -> "unities",
	"USD" -> "US dollars",
	"Volt" -> "volts",
	"VolumePercent" -> "VolumePercent",
	"Watt" -> "watts",
	"Week" -> "weeks",
	"WeightVolumePercent" -> "WeightVolumePercent",
	"Yard" -> "yards",
	"Year" -> "years"
};

(* Function to parse a quantity out of a string *)
DefineOptions[StringToQuantity,
	Options :> {
		{Server -> Automatic, Alternatives[Automatic, BooleanP], "Indicates if the function should contact the Wolfram server for units interpretation if local string methods fail. Defaults to False in Engine and True otherwise."},
		{Debug -> False, BooleanP, "Indicates if debugging information is printed to the terminal."}
	}
];

(* Dev notes *)
(* String matching is done in a case-insensitive manner. If case doesn't matter when matching a set of rules, use the lower case word on the LHS. Note that case *does* matter for the RHS and MM typically only recognizes capitalized words *)
(* If case sensitivity is required, such as for unit symbols, use CaseSensitive to wrap around rules *)

(* Helper for Echoing when debugging only *)
stringToQuantityDebugQ = False;
stringToQuantityDebugEcho[args___] := If[stringToQuantityDebugQ, Echo[args], args];

StringToQuantity[{}] := {};
StringToQuantity[myString_String, myOptions : OptionsPattern[StringToQuantity]] := First[StringToQuantity[{myString}, myOptions]];
StringToQuantity[myStrings : {_String..}, myOptions : OptionsPattern[StringToQuantity]] := Module[
	{
		serverOption, sanitizedStrings, standardizedStrings,
		combinedReplacementRules, debugOption
	},

	(* Should we contact the server if local conversion fails? *)
	serverOption = Module[{specifiedServerOption},

		(* Unresolved server option *)
		specifiedServerOption = OptionDefault[OptionValue[Server]];

		(* Disable Quantity in engine if left Automatic as it doesn't work. Maybe a licensing thing *)
		If[MatchQ[specifiedServerOption, Automatic],
			!MatchQ[$ECLApplication, Engine],
			specifiedServerOption
		]
	];

	(* Are we debugging? *)
	debugOption = OptionDefault[OptionValue[Debug]];
	stringToQuantityDebugQ = debugOption;

	(* Sanitize the input strings *)
	sanitizedStrings = Module[
		{whitespaceTrimmed},

		(* Trim off whitespace *)
		whitespaceTrimmed = StringTrim[myStrings];

		StringReplace[
			whitespaceTrimmed,
			{
				(* Ensure there's a space between number and units - helps make ToExpression more consistent *)
				(* Make sure we only match the first switch between the number and the units *)
				(* Alternatives with "." account for cases where a float has a trailing ., such as 1.ms *)
				x : Alternatives[DigitCharacter, DigitCharacter ~~ "."] ~~ Whitespace... ~~ y : Except[Alternatives[DigitCharacter, "."]] :> x <> " " <> y,

				(* Add a space between $ and number. Unique case of units coming first *)
				x : "$" ~~ y : DigitCharacter :> x <> " " <> y
			},
			1
		]
	];

	stringToQuantityDebugEcho["Generating string replacement rules ", Now];

	(* Generate the memoized replacement rules *)
	combinedReplacementRules = stringToQuantityReplacementRules[];

	stringToQuantityDebugEcho["String replacement rules generated ", Now];
	stringToQuantityDebugEcho["Performing replacements ", Now];

	(* Perform the actual replacement *)
	(* The idea here is to convert the input string into a standardized string form that MM ToExpression can handle *)
	(* This means that this function doesn't have to interpret the mathematical operators in the unit *)
	(* MM only recognizes Meter as a unit, so convert meter, meters, Meters, m -> Meter *)
	standardizedStrings = StringReplace[
		sanitizedStrings,
		combinedReplacementRules,

		(* We do case insensitive as individual rules can use CaseSensitive to override this *)
		IgnoreCase -> True
	];

	stringToQuantityDebugEcho["Replacements completed ", Now];

	(* Attempt to convert our standardized string to an expression *)
	(* Check we get a valid quantity out and use Wolfram Interpretation as a fall back if requested *)
	MapThread[
		With[{expression = Quiet[ToExpression[#2]]},
			Which[
				(* If ToExpression returned a valid quantity or plain number, return it *)
				Or[QuantityQ[expression], NumberQ[expression]],
				(
					stringToQuantityDebugEcho[#1 <> " converted locally as " <> #2];
					expression
				),

				(* If not and the Wolfram server is an option, hit it with the original string (~0.5 s per string, hence why this function exists...) *)
				TrueQ[serverOption],
				(
					stringToQuantityDebugEcho[#1 <> " converted by Wolfram. Local expression: " <> #2];
					Quantity[#1]
				),

				(* Otherwise return $Failed *)
				True,
				(
					stringToQuantityDebugEcho[#1 <> " conversion failed. Local expression: " <> #2];
					$Failed
				)
			]
		] &,
		{myStrings, standardizedStrings}
	]
];

(* Generate and memoize string replacement rules *)
(* The idea here is to convert the input string into a standardized string form that MM ToExpression can handle *)
(* This means that this function doesn't have to interpret the mathematical operators in the unit *)
(* MM only recognizes Meter as a unit, so convert meter, meters, Meters, m -> Meter *)
stringToQuantityReplacementRules[] := Set[
	stringToQuantityReplacementRules[],
	Module[
		{
			toStringReversalLookup, textStringReversalLookup, metricPrefixLookup, fullFormMetricPrefixes,
			shortFormMetricPrefixes, prefixedUnitsPluralLookup, canonicalUnitsPluralLookup, prefixedUnitsCapitalizationLookup, canonicalUnitsCapitalizationLookup,
			prefixedUnitsPlurals, canonicalUnitsPlurals, prefixedUnits, canonicalUnits, unitSymbolLookup, unitSymbols, metricPrefixCapitalizationRules,
			combinedReplacementRules, additionalPlurals
		},

		(* Add custom plurals. LHS is case insensitive, but keep lower case for convention. RHS needs to be the form of the unit recognized by ToExpression - typically capitalized *)
		additionalPlurals = {
			(* Poise is sometimes pluralized as poises (normally Poise) *)
			"poises" -> "Poise"
		};

		(* Create lookup to reverse ToString[quantity] *)
		(* e.g. "8 degrees Celsius" -> "8 Celsius" *)
		(* These are typically words / phrases - so treat case insensitive. "degrees Celsius" == "degrees celsius" *)
		toStringReversalLookup = DeleteDuplicates[Join[
			ToLowerCase[Last[#]] -> First[#] & /@ unitToStringForms,
			ToLowerCase[Last[#]] -> First[#] & /@ unitToStringPluralForms
		]];

		(* Create lookup to reverse TextString[quantity] *)
		(* e.g. "8 \[Degree]C" -> "8 Celsius" *)
		(* These are typically symbols or abbreviations - so treat case sensitive. "m" != "M" *)
		textStringReversalLookup = DeleteDuplicates[Last[#] -> First[#] & /@ unitTextStringForms];

		(* Create a lookup of shortform metric prefixes, to full form names *)
		(* e.g. "\[Mu]" -> "Micro", "M" -> "Mega", "m" -> "Milli" *)
		metricPrefixLookup = Module[{fullList},

			(* Convert the full list from Held symbols to strings and swap order *)
			fullList = (Last[#] -> ToString[First[#]]) & /@ (List @@ unitPrefixShorthands);

			(* Filter out any unhelpful rules, such as for no prefix *)
			Select[fullList, !MatchQ[First[#], ""] &]
		];

		(* Get lists of known full-form and short-form metric prefixes *)
		fullFormMetricPrefixes = ToLowerCase /@ Values[metricPrefixLookup];
		shortFormMetricPrefixes = Keys[metricPrefixLookup];

		(* Rules for capitalizing full form metric prefixes. Key must be lowercase despite case-insensitive matching so that it's easy to look up values manually *)
		(* e.g. "milli" -> "Milli" *)
		metricPrefixCapitalizationRules =  AssociationThread[ToLowerCase /@ fullFormMetricPrefixes, Capitalize /@ fullFormMetricPrefixes];

		(* Create a lookup of known prefixed unit plurals to recognized singular forms *)
		(* e.g. "millimeters" -> "Millimeter" *)
		prefixedUnitsPluralLookup = Module[{ruleList, convertedStrings},

			(* Convert the association to a list of rules, as StringReplace can't work with the former *)
			ruleList = Replace[emeraldPrefixedUnitLookup, Association[x__] :> List[x], {0}];

			(* Some keys are in the form ("Unit1" / "Unit 2"). Convert these to a single string "Unit1/Unit2" *)
			convertedStrings = If[!StringQ[First[#]],
				(* ToString of the InputForm gives us what we want, but puts in explicit " around the strings. So remove those *)
				{ToLowerCase[StringReplace[ToString[InputForm[#]], "\"" -> ""]], Last[#]},
				{ToLowerCase[First[#]], Last[#]}
			] & /@ ruleList;

			(* Return only those that are String -> String for sure *)
			Cases[convertedStrings, HoldPattern[_String -> _String]]
		];

		(* Get lists of known singular and plural prefixed units *)
		prefixedUnits = Values[prefixedUnitsPluralLookup];
		prefixedUnitsPlurals = Keys[prefixedUnitsPluralLookup];

		(* Create a lookup of known canonical unit plurals to recognized singular forms *)
		(* e.g. "meters" -> "Meter" *)
		canonicalUnitsPluralLookup = Module[{ruleList, convertedStrings, augmentedRules},

			(* Convert the association to a list of rules, as StringReplace can't work with the former *)
			ruleList = Replace[emeraldUnitLookup, Association[x__] :> List[x], {0}];

			(* Some keys are in the form ("Unit1" / "Unit 2"). Convert these to a single string "Unit1/Unit2" *)
			convertedStrings = If[!StringQ[First[#]],
				(* ToString of the InputForm gives us what we want, but puts in explicit " around the strings. So remove those *)
				ToLowerCase[StringReplace[ToString[InputForm[First[#]]], "\"" -> ""]] -> Last[#],
				ToLowerCase[First[#]] -> Last[#]
			] & /@ ruleList;

			(* Append any custom rules *)
			augmentedRules = Join[
				convertedStrings,
				additionalPlurals
			];

			(* Return only those that are String -> String for sure *)
			Cases[augmentedRules, HoldPattern[_String -> _String]]
		];

		(* Get lists of known singular and plural canonical units *)
		canonicalUnits = Values[canonicalUnitsPluralLookup];
		canonicalUnitsPlurals = Keys[canonicalUnitsPluralLookup];

		(* Create a lookup to capitalize known units *)
		(* e.g. "milligram" -> "Milligram" and "gram" -> "Gram" *)
		prefixedUnitsCapitalizationLookup = AssociationThread[ToLowerCase /@ prefixedUnits, Capitalize /@ prefixedUnits];
		canonicalUnitsCapitalizationLookup = AssociationThread[ToLowerCase /@ canonicalUnits, Capitalize /@ canonicalUnits];

		(* Create a lookup from known unit symbols/abbreviations. Case matters here *)
		(* e.g. "m" -> "Meter", "\[CapitalARing]" -> "Angstrom" *)
		unitSymbolLookup = Module[{rawList, filteredList},

			(* Convert the full list from Held symbols to strings. Ensure compound units (Unit1 / Unit2) are converted sensibly using InputForm *)
			rawList = (Last[#] -> First[#] &) /@ List @@ (
				unitPostfixShorthands /. HoldPattern[x_ -> y_] :> (ToString[Unevaluated[InputForm[x]]] -> y)
			);

			(* Filter out any conversions we don't want *)
			(* We want Celsius not Centigrade *)
			filteredList = Select[rawList, !MatchQ[Last[#], Alternatives["Centigrade", "None"]] &];

			(* Return only those that are String -> String for sure *)
			Cases[filteredList, HoldPattern[_String -> _String]]
		];

		(* Get list of recognized unit symbols *)
		unitSymbols = Keys[unitSymbolLookup];

		(* Create the string patterns to match and combine all the replacement rules *)
		combinedReplacementRules = Module[
			{
				toStringRules, textStringRules, prefixedUnitsRules, prefixedUnitsCapitalizationRules, canonicalUnitsRules,
				canonicalUnitsCapitalizationRules, prefixCapitalizationRules, unitSymbolRules, sortRules, startOfUnitP, endOfUnitP,
				customReplacements
			},

			(* Sort rules so that longer words match first *)
			(* This is important if we might partially match a unit with another *)
			(* For example, \[Degree]C - is this degrees celsius, or angular degrees * Coulombs? *)
			sortRules[rules_] := ReverseSortBy[rules, StringLength[First[#]] &];

			(* In the following rules you might see the following *)
			(*
				space1 : Ensures we're matching whole words only. WordBoundary works in most cases but not if the unit contains a symbol, so also check Whitespace or start of string
				prefix : Test if we can match a prefix before a canonical unit
				" " : Sometimes the prefix and unit may already have a space. Milli Meter = Millimeter
				space2: As for space 1

				Parentheses: If we match a unit as prefix + canonical unit it means we didn't find the composite prefix-unit in SLL. For example, there's not much call for YottaCelsius
				If we find "Yottacelsius" we therefore split into "Yotta Celsius". Add parentheses as it's possible we had "Yottacelsius^3" which becomes "(Yotta Celsius)^3"
			*)
			(* The reason I match a general string expression rather than explicitly check each replacement is that StringReplace will only match each part of a string once *)
			(* So each string expression is designed to match a whole 'word'/unit *)
			(* In this case StringReplace's property is actually quite useful. It means "Millimeter" won't match "meter" as we already matched it with "Millimeter" *)
			(* And \[Degree]C won't match "Angular Degree" and "Coulomb" because it already matched "Degrees Celsius" *)

			(* Make some patterns for matching the start and end of a unit *)
			startOfUnitP = Alternatives[WordBoundary, Whitespace, StartOfString];
			endOfUnitP = Alternatives[WordBoundary, Whitespace, EndOfString];

			(* ToString reversals *)
			toStringRules = {
				StringExpression[
					space1 : startOfUnitP,
					toStringPhrase : Alternatives @@ Keys[sortRules[toStringReversalLookup]],
					space2 : endOfUnitP
				] :> Module[{converted},

					converted = space1 <> (ToLowerCase[toStringPhrase] /. toStringReversalLookup) <> space2;

					stringToQuantityDebugEcho["toStringRules converted " <> ToString[{space1, toStringPhrase, space2}] <> " to " <> converted];

					converted
				],
				StringExpression[
					space1 : startOfUnitP,
					prefix : Alternatives[Alternatives @@ fullFormMetricPrefixes, ""],
					" "...,
					toStringPhrase : Alternatives @@ Keys[sortRules[toStringReversalLookup]],
					space2 : endOfUnitP
				] :> Module[{converted},

					converted = space1 <> "(" <> (ToLowerCase[prefix] /. metricPrefixCapitalizationRules) <> " " <> (ToLowerCase[toStringPhrase] /. toStringReversalLookup) <> ")" <> space2;

					stringToQuantityDebugEcho["toStringRules converted " <> ToString[{space1, prefix, toStringPhrase, space2}] <> " to " <> converted];

					converted
				]
			};

			(* TextString reversals *)
			(* CaseSensitive ensures we match in CaseSensitive manner even though StringReplace is set to non-sensitive *)
			textStringRules = {
				(* Match without prefix first - as there is no space between a prefix, we need to prioritize min -> Minute over Milli Inch *)
				StringExpression[
					space1 : startOfUnitP,
					textStringPhrase : Alternatives @@ (CaseSensitive /@ Keys[sortRules[textStringReversalLookup]]),
					space2 : endOfUnitP
				] :> Module[{converted},
					converted = space1 <> (textStringPhrase /. textStringReversalLookup) <> space2;

					stringToQuantityDebugEcho["textStringRules converted " <> ToString[{space1, textStringPhrase, space2}] <> " to " <> converted];

					converted
				],
				StringExpression[
					space1 : startOfUnitP,
					prefix : Alternatives[Alternatives @@ (CaseSensitive /@ shortFormMetricPrefixes)],
					(* No space allowed between short form prefix and units *)
					textStringPhrase : Alternatives @@ (CaseSensitive /@ Keys[sortRules[textStringReversalLookup]]),
					space2 : endOfUnitP
				] :> Module[{converted},
					converted = space1 <> "(" <> (prefix /. metricPrefixLookup) <> " " <> (textStringPhrase /. textStringReversalLookup) <> ")" <> space2;

					stringToQuantityDebugEcho["textStringRules converted " <> ToString[{space1, prefix, textStringPhrase, space2}] <> " to " <> converted];

					converted
				]
			};

			(* Prefixed units - plurals first *)
			(* Match whole words as prefix is already attached. Case-insensitive *)
			prefixedUnitsRules = StringExpression[
				space1 : startOfUnitP,
				unit : Alternatives @@ prefixedUnitsPlurals,
				space2 : endOfUnitP
			] :> Module[{converted},
				converted = space1 <> (ToLowerCase[unit] /. prefixedUnitsPluralLookup) <> space2;

				stringToQuantityDebugEcho["prefixedUnitsRules converted " <> ToString[{space1, unit, space2}] <> " to " <> converted];

				converted
			];

			(* Prefixed units - ensure singulars are capitalized *)
			(* Match whole words as prefix is already attached. Case-insensitive *)
			prefixedUnitsCapitalizationRules = StringExpression[
				space1 : startOfUnitP,
				unit : Alternatives @@ prefixedUnits,
				space2 : endOfUnitP
			] :> Module[{converted},
				converted = space1 <> (ToLowerCase[unit] /. prefixedUnitsCapitalizationLookup) <> space2;

				stringToQuantityDebugEcho["prefixedUnitsCapitalizationRules converted " <> ToString[{space1, unit, space2}] <> " to " <> converted];

				converted
			];

			(* Canonical units - plurals first. Try with full metric prefixes *)
			canonicalUnitsRules = {
				StringExpression[
					space1 : startOfUnitP,
					unit : Alternatives @@ canonicalUnitsPlurals,
					space2 : endOfUnitP
				] :> Module[{converted},
					converted = space1 <> (ToLowerCase[unit] /. canonicalUnitsPluralLookup) <> space2;

					stringToQuantityDebugEcho["canonicalUnitsRules converted " <> ToString[{space1, unit, space2}] <> " to " <> converted];

					converted
				],
				StringExpression[
					space1 : startOfUnitP,
					prefix : Alternatives[Alternatives @@ fullFormMetricPrefixes, ""],
					" "...,
					unit : Alternatives @@ canonicalUnitsPlurals,
					space2 : endOfUnitP
				] :> Module[{converted},
					converted = space1 <> "(" <> (ToLowerCase[prefix] /. metricPrefixCapitalizationRules) <> " " <> (ToLowerCase[unit] /. canonicalUnitsPluralLookup) <> ")" <> space2;

					stringToQuantityDebugEcho["canonicalUnitsRules converted " <> ToString[{space1, prefix, unit, space2}] <> " to " <> converted];

					converted
				]
			};

			(* Canonical units - ensure singular units are capitalized *)
			canonicalUnitsCapitalizationRules = {
				StringExpression[
					space1 : startOfUnitP,
					unit : Alternatives @@ canonicalUnits,
					space2 : endOfUnitP
				] :> Module[{converted},
					converted = space1 <> (ToLowerCase[unit] /. canonicalUnitsCapitalizationLookup) <> space2;

					stringToQuantityDebugEcho["canonicalUnitsCapitalizationRules converted " <> ToString[{space1, unit, space2}] <> " to " <> converted];

					converted
				],
				StringExpression[
					space1 : startOfUnitP,
					prefix : Alternatives[Alternatives @@ fullFormMetricPrefixes, ""],
					" "...,
					unit : Alternatives @@ canonicalUnits,
					space2 : endOfUnitP
				] :> Module[{converted},
					converted = space1 <> "(" <> (ToLowerCase[prefix] /. metricPrefixCapitalizationRules) <> " " <> (ToLowerCase[unit] /. canonicalUnitsCapitalizationLookup) <> ")" <> space2;

					stringToQuantityDebugEcho["canonicalUnitsCapitalizationRules converted " <> ToString[{space1, prefix, unit, space2}] <> " to " <> converted];

					converted
				]
			};

			(* Full-form prefix last chance. Convert any loose prefixes, just in case the text has weird ordering *)
			prefixCapitalizationRules = StringExpression[
				space1 : startOfUnitP,
				prefix : Alternatives @@ fullFormMetricPrefixes,
				space2 : endOfUnitP
			] :> Module[{converted},
				converted = space1 <> (ToLowerCase[prefix] /. metricPrefixCapitalizationRules) <> space2;

				stringToQuantityDebugEcho["prefixCapitalizationRules converted " <> ToString[{space1, prefix, space2}] <> " to " <> converted];

				converted
			];

			(* Final rules for unit symbols and abbreviations *)
			(* These are all case sensitive *)
			(* There is no space between a unit and its prefix, but there is (should be) a space between two separate units *)
			(* E.g. ms will be interpreted as milliseconds and m s will be interpreted as meter-seconds *)
			unitSymbolRules = {
				StringExpression[
					space1 : startOfUnitP,
					unit : Alternatives @@ (CaseSensitive /@ ReverseSortBy[unitSymbols, StringLength]),
					space2 : endOfUnitP
				] :> Module[{converted},
					converted = space1 <> (unit /. unitSymbolLookup) <> space2;

					stringToQuantityDebugEcho["unitSymbolRules converted " <> ToString[{space1, unit, space2}] <> " to " <> converted];

					converted
				],
				StringExpression[
					space1 : startOfUnitP,
					prefix : Alternatives @@ (CaseSensitive /@ shortFormMetricPrefixes),
					unit : Alternatives @@ (CaseSensitive /@ ReverseSortBy[unitSymbols, StringLength]),
					space2 : endOfUnitP
				] :> Module[{converted},
					converted = space1 <> "(" <> (prefix /. metricPrefixLookup) <> " " <> (unit /. unitSymbolLookup) <> ")" <> space2;

					stringToQuantityDebugEcho["unitSymbolRules converted " <> ToString[{space1, prefix, unit, space2}] <> " to " <> converted];

					converted
				]
			};

			(* Add in some edge case custom replacements *)
			customReplacements = {
				"megohm" -> "Megaohm",
				"megaohms" -> "Megaohm",
				"kilohm" -> "Kiloohm",
				"kilohms" -> "Kiloohm",
				"sqft" -> "Foot^2",
				"'" -> "Foot",
				"\"" -> "Inch"
			};

			(* Register memoization if we got this far *)
			If[!MemberQ[$Memoization, EmeraldUnits`Private`stringToQuantityReplacementRules],
				AppendTo[$Memoization, EmeraldUnits`Private`stringToQuantityReplacementRules]
			];

			(* Combine the match rules. Order matters - the earliest match will be used *)
			Flatten[{
				toStringRules,
				textStringRules,
				prefixedUnitsRules,
				prefixedUnitsCapitalizationRules,
				canonicalUnitsRules,
				canonicalUnitsCapitalizationRules,
				prefixCapitalizationRules,
				unitSymbolRules,
				customReplacements
			}]
		]
	]
];