(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*Location*)


DefineUsage[Location,
{
	BasicDefinitions -> {
		{"Location[item]", "address", "generates an absolute 'address' specifying the location of 'item' within the ECL's facilities."},
		{"Location[item,date]", "address", "generates an absolute 'address' specifying the location of 'item' within the ECL's facilities on the provided 'date' in the past."}
	},
	MoreInformation -> {
		"'Location' can operate on any Object whose physical location is tracked in the ECL (samples, containers, instruments, parts, and plumbing items).",
		"The function returns '{}' if the supplied item has no Container, or if LevelsUp->0 is specified."
	},
	Input :> {
		{"item", Types[{Object[Sample], Object[Container], Object[Instrument], Object[Part], Object[Sensor], Object[Item], Object[Plumbing], Object[Wiring]}], "An SLL sample, container, instrument, part, or plumbing item."},
		{"date", _DateObject, "A date in the past at which location information is desired."}
	},
	Output :> {
		{"address", _Grid, "A table containing the absolute 'address' of 'item' within the ECL's facilities."}
	},
	Behaviors -> {
		"ReverseMapping"
	},
	Sync -> Automatic,
	SeeAlso -> {
		"PlotContainer",
		"UploadLocation"
	},
	Author -> {"malav.desai", "xu.yi", "charlene.konkankit", "cgullekson", "ben", "cheri"}
}];


(* ::Subsubsection::Closed:: *)
(*PlaceItems*)


DefineUsage[PlaceItems,
{
	BasicDefinitions -> {
		{"PlaceItems[items,destination]","placements","returns a set of 'placements' in open locations within the 'destination' that have the proper footprints to fit the 'items'."}
	},
	MoreInformation -> {
		"Each list of items is considered as a single \"item group\" that must all have possible placements into the destination for this function to return Placements.",
		"Placements are not guaranteed to be returned in the same order as the Positions field from the destinations (or any contents of the destinations).",
		"Duplicates models in an item group are treated as distinct items.",
		"Duplicate objects in an item group are collapsed.",
		"Uses openLocations internally to determine single item possibilities, then eliminates duplicated locations to generate set of placements for an item group."
	},
	Input :> {
		{"items",{ObjectP[{Model[Instrument],Model[Container],Model[Sample],Model[Part], Model[Sensor],Model[Plumbing],Model[Wiring],Object[Instrument],Object[Container],Object[Sample],Object[Part], Object[Sensor],Object[Plumbing],Object[Wiring]}]..},"A group of items that define a series of valid movements of many items to different positions in the destination."},
		{"destination",ObjectP[{Model[Instrument],Model[Container],Object[Instrument],Object[Container]}],"The container you wish to place the items into."}
	},
	Output :> {
		{"placements",{PlacementP..},"Specific placements for instructing movement of the items to the destination."}
	},
	Behaviors -> {
		"ReverseMapping"
	},
	Sync -> Automatic,
	SeeAlso -> {
		"openLocations",
		"UploadLocation",
		"validPlacementQ",
		"Location",
		"PlotLocation",
		"PlotContents"
	},
	Author -> {"robert", "alou"}
}];


(* ::Subsubsection::Closed:: *)
(*Placement*)


DefineUsage[Placement,
	{
		BasicDefinitions -> {
			{"Placement[placementRules]","primitive","generates a 'primitive' that describes a placement of an item into a destination according to 'placementRules'."}
		},
		MoreInformation->{
			"Placements contains a set of mandatory and optional keys that describes the placement.",
			"Required Keys:",
     		"\tItem,Destination",
			"Optional Keys:",
     		"\tPosition,Layout"
		},
		Input:>{
			{
				"placementRules",
				PlacementP,
				"Specific key/value pairs specifying the items/destinations involved in the desired placement."
			}
		},
		Output:>{
			{"primitive",PlacementP,"A placement primitive containing information for execution of a placement of an item into a destination."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"PlaceItem",
			"UploadLocation",
			"validPlacementQ",
			"Location",
			"PlotLocation",
			"PlotContents"
		},
		Author->{"robert", "alou"}
	}
];



(* ::Subsubsection::Closed:: *)
(*openLocations*)


DefineUsage[openLocations,
	{
		BasicDefinitions -> {
			{"openLocations[destination]","locations","returns all empty 'locations' within 'destination'."},
			{"openLocations[destination,item]","locations","returns all empty 'locations' within 'destination' that can accommodate 'item'."},
			{"openLocations[destination,item,layout]","locations","returns all empty 'locations' in 'destination' that can accommodate 'item', where 'destination' is configured according to 'layout'."}
		},
		Input :> {
			{"destination",ObjectP[{Model[Instrument],Model[Container],Object[Instrument],Object[Container]}],"A desired location for the provided item to be moved."},
			{"item",ObjectP[{Model[Instrument],Model[Container],Model[Sample],Model[Part], Model[Sensor],Model[Plumbing],Model[Wiring],Object[Instrument],Object[Container],Object[Sample],Object[Part], Object[Sensor],Object[Plumbing],Object[Wiring]}],"The object that is intended to move into the destination."},
			{"layout",ObjectP[Model[DeckLayout]],"An object describing how the destination is configured."}
		},
		Output :> {
			{"locations",{{ObjectP[{Model[Container],Model[Instrument],Object[Container],Object[Instrument]}],LocationPositionP}..}, "Locations in the destination that are unoccupied and can serve as destinations for item placements."}
		},
		Behaviors -> {
			"ReverseMapping"
		},
		Sync -> Automatic,
		SeeAlso -> {
			"UploadLocation",
			"validPlacementQ",
			"PlaceItems",
			"Location",
			"PlotLocation",
			"PlotContents"
		},
		Author -> {"robert", "alou"}
	}
];


(* ::Subsubsection::Closed:: *)
(*validPlacementQ*)

DefineUsage[validPlacementQ,
{
	BasicDefinitions -> {
		{"validPlacementQ[item,{destination,position}]","boolean","indicates if the 'item' has the proper footprint to be located in the provided 'position' of the 'destination'."},
		{"validPlacementQ[item,destination]","boolean","indicates if the 'item' has the proper footprint to be located in at least one position of the 'destination'."},
		{"validPlacementQ[placement]","boolean","returns a Boolean indicating if the provided placement of an item has the proper footprint to fit into the given destination of the 'placement'."}
	},
	AdditionalDefinitions -> {
		{"validPlacementQ[items,destination]","boolean","returns a 'boolean' indicating if the 'items' can be collectively placed in a set of positions of 'destination'."}
	},
	MoreInformation -> {
		"The placement of an item into a destination is considered valid if the destination has an open position whose footprint matches the item's footprint.",
		"An open position can be found at any layer of a destination's contents unless specified by the LevelsDown option."
	},
	Input :> {
		{"item",ObjectP[{Model[Instrument],Model[Container],Model[Sample],Model[Part], Model[Sensor],Model[Plumbing],Model[Wiring],Object[Instrument],Object[Container],Object[Sample],Object[Part], Object[Sensor],Object[Plumbing],Object[Wiring]}],"The object that is intended to move into the destination."},
		{"destination",ObjectP[{Model[Instrument],Model[Container],Object[Instrument],Object[Container]}],"A desired location for the provided item to be moved."},
		{"position",LocationPositionP,"The desired position in the destination for the provided item."},
		{"placement",PlacementP,"A placement primitive containing placement information to be validated."}
	},
	Output :> {
		{"boolean",BooleanP, "A boolean indicating that the requested placement's item can fit into an open location in the destination provided."}
	},
	Behaviors -> {
		"ReverseMapping"
	},
	Sync -> Automatic,
	SeeAlso -> {
		"UploadLocation",
		"openLocations",
		"PlaceItems",
		"Location",
		"PlotLocation",
		"PlotContents"
	},
	Author -> {"robert", "alou"}
}];

(* ::Subsubsection::Closed:: *)
(*PlotContents*)

With[
	{locationTypes=LocationTypes,locationContainerModelTypes=LocationContainerModelTypes},

	DefineUsage[PlotContents,{
		BasicDefinitions->{

			{
				Definition->{"PlotContents[obj]","plot"},
				Description->"generates a plot of an item 'obj' and its immediate contents.",
				Inputs:>{
					{
						InputName->"obj",
						Description->"An item whose contents will be plotted.",
						Widget->Alternatives[
							"Enter object(s):"->Widget[Type->Expression,Pattern:>ObjectP[locationTypes],Size->Line],
							"Select object(s):"->Widget[Type->Object,Pattern:>ObjectP[locationTypes]]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A plot of 'obj' and its contents.",
						Pattern:>_Graphics|_Graphics3D
					}
				}
			},
			{
				Definition->{"PlotContents[mod]","plot"},
				Description->"generates a plot of the physical layout of a container or instrument model 'mod'.",

				Inputs:>{
					{
						InputName->"mod",
						Description->"A container or instrument model whose layout will be plotted.",
						Widget->Alternatives[
							"Enter model(s):"->Widget[Type->Expression,Pattern:>ObjectP[locationContainerModelTypes],Size->Line],
							"Select model(s):"->Adder@Widget[Type->Object,Pattern:>ObjectP[locationContainerModelTypes]]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A plot of 'obj' and its contents.",
						Pattern:>_Graphics|_Graphics3D
					}
				}
			},
			{
				Definition->{"PlotContents[pos]","plot"},
				Description->"generates a plot of the location of a position 'pos' in its parent container within the ECL facility.",

				Inputs:>{
					{
						InputName->"pos",
						Description->"A position in an item whose contents will be plotted.",
						Widget->Widget[Type->Expression,Pattern:>{ObjectReferenceP[locationContainerModelTypes], _String},Size->Line]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A plot of 'obj' and its contents.",
						Pattern:>_Graphics|_Graphics3D
					}
				}
			}
		},
		MoreInformation -> {
			"Map->False will attempt to combine all inputs and return a single plot. If this is not possible (i.e., if the input location graphs are disconnected), inputs will be combined into the minimum number of connected location graphs.",
			"If LiveDisplay->True (default), individual containers can be clicked to re-draw the container plot with focus on the clicked object.",
			"LiveDisplay is only compatible with PlotType->Plot2D.",
			"If both LevelsUp and NearestUp or LevelsUp and NearestDown are specified, the Nearest_ option will take precedence and the Levels_ option will be set to Infinity.",
			"Duplicates in input will be deleted and duplicated items will be plotted only once."
		},
		Sync -> Automatic,
		Preview->True,
		SeeAlso -> {
			"PlotLocation",
			"Location"
		},
		Author -> {"andrey.shur", "lei.tian"}
	}]
];


(* ::Subsubsection::Closed:: *)
(*PlotLocation*)


DefineUsage[PlotLocation,
	{
		BasicDefinitions -> {
			{
				Definition->{"PlotLocation[obj]","plot"},
				Description->"generates a plot of the location of an item 'obj' within the ECL facility in which it is located.",
				Inputs:>{
					{
						InputName->"obj",
						Description->"An item whose location within the ECL facility will be plotted.",
						Widget->Widget[Type->Expression,Pattern:>ObjectP[LocationTypes],Size->Line]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A plot of the location of 'obj' within the ECL.",
						Pattern:>ValidGraphicsP[]
					}
				}
			},
			{
				Definition->{"PlotLocation[pos]", "plot"},
				Description->"generates a plot of the location of a position 'pos' in its parent container within the ECL facility.",
				Inputs:>{
					{
						InputName->"pos",
						Description->"A position in an item whose location within the ECL facility will be plotted.",
						Widget->{
							"Item"->Widget[Type->Expression,Pattern:>ObjectReferenceP[LocationContainerTypes],Size->Line],
							"Position in the item"->Widget[Type->String,Pattern:>_String,Size->Line]
						}
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A plot of the location of 'obj' within the ECL.",
						Pattern:>ValidGraphicsP[]
					}
				}
			}
		},
		MoreInformation -> {
			"Map->False will attempt to combine all inputs and return a single plot. If this is not possible (i.e., if the input location graphs are disconnected), inputs will be combined into the minimum number of connected location graphs.",
			"If LiveDisplay->True (default), individual containers can be clicked to re-draw the container plot with focus on the clicked object.",
			"LiveDisplay is only compatible with PlotType->Plot2D.",
			"If both LevelsUp and NearestUp or LevelsUp and NearestDown are specified, the Nearest_ option will take precedence and the Levels_ option will be set to Infinity.",
			"Duplicates in input will be deleted and duplicated items will be plotted only once."
		},
		Sync -> Automatic,
		SeeAlso -> {
			"PlotContents",
			"Location"
		},
		Author -> {"malav.desai", "andrey.shur", "charlene.konkankit", "cgullekson", "ben", "marie.wu"},
		Preview->True
	}
];



(* ::Subsubsection::Closed:: *)
(*ToBarcode*)


DefineUsage[ToBarcode,
{
	BasicDefinitions -> {
		{"ToBarcode[object]", "barcode", "converts an SLL Object (sample, instrument, or container) into an inventory barcode using the barcode database."}
	},
	Input :> {
		{"object", ObjectP[{Object[Sample],Object[Part], Object[Sensor],Object[Container], Object[Plumbing], Object[Wiring], Object[Instrument]}], "Sample you wish to Convert into a barcode."}
	},
	Output :> {
		{"barcode", _String, "Barcode for the provided 'object'."}
	},
	SeeAlso -> {
		"ToObject",
		"ObjectP"
	},
	Author -> {
		"platform"
	},
	Guides -> {

	},
	Tutorials -> {

	}
}];


(* ::Subsubsection::Closed:: *)
(*ToObject*)


DefineUsage[ToObject,
{
	BasicDefinitions -> {
		{"ToObject[barcode]", "object", "converts a barcode into an (sample, instrument, or container) object it represents using the barcode database."},
		{"ToObject[barcodes]", "objects", "converts a single string of consecutively-scanned barcodes into the sample objects they represent using the barcode database."},
		{"ToObject[]", "object", "launches a user interface to scan sample stickers (s) and returns the list of samples."}
	},
	Input :> {
		{"barcode", BarcodeP, "Barcode you wish to Convert into a sample object."},
		{"barcodes", _String, "A string of consecutively-scanned barcodes you wish to Convert into sample objects."}
	},
	Output :> {
		{"object", ObjectP[{Object[Sample],Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring], Object[Container], Object[Instrument]}], "SLL Objects that the provided 'barcode' represents."},
		{"objects", {ObjectP[{Object[Sample],Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring], Object[Container], Object[Instrument]}]}, "SLL Objects that the provided string of consecutively-scanned 'barcodes' represents."}
	},
	SeeAlso -> {
		"ToBarcode",
		"CreateID"
	},
	Author -> {
		"platform"
	},
	Guides -> {

	},
	Tutorials -> {

	}
}];