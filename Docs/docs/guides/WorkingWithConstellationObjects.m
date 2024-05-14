(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Working With Constellation Objects",
	Abstract -> "The ECL Constellation automatically coordinates and organizes scientific data coming to and from the lab into a vast network of linked data objects.\nInformation is organized into Constellation objects by breaking into a set of Fields which each contain a value (e.g. The MolecularWeight Field of the Object representing Ethanol is 46.07 Gram/Mole). The collection of which Fields are available for a given object is defined by the Type of object it is. So for instance Constellation objects of Type Object[Data,Chromatography] have Fields storing their Absorbance data, Pressure Data, Gradient information, etc. whereas Constellation objects of Type Object[Sample] have a different set of fields storing the volume of the sample, the weight of the sample, the conditions under which the sample should be stored etc. In addition to storing values, fields in Constellation objects can also store links to other Constellation objects in their Fields. This structure allows you to easily explore lines of inquiry and answer any follow-up questions about your data, analysis, instrumentation, or any other aspect of your experiments by exploring the network of links. So if you're looking a given data object and you want to know the temperature in the room recorded from the sensor nearest to the instrument at the time the experiment that generated that data was run, you could surf from the data object via its Protocol field to protocol object and then look at the protocol object's EnvironmentalData Field to find a link to the temperature sensor readings from the sensor nearest to the instrument at the time at which the protocol was conducted in the lab.",
	Reference -> {
		"Visualizing Object Information" -> {
			{Inspect, "Presents a tabular view of all of the fields stored for a given Constellation object."},
			{PlotObject, "Provides a visual representation of the information stored in the given Constellation object."},
			{PlotTable, "Given a list of Objects and a list of fields within those objects, generates a table which presents the values of Fields in the provided objects."}
		},

		"Interacting with the Constellation database" -> {
			{Download, "Returns any values stored in a Constellation object's field or all of the objects fields if requested."},
			{Upload, "Adds information to a Constellation object's fields or generates a new Constellation object containing the provided field information."},
			{Search, "Queries all Constellation objects you have access to find those with field values matching specific criteria."},
			{DatabaseMemberQ, "Checks to see if a provided Object ID can be found in Constellation."},
			{NamedObject, "Replaces the ID of Objects with their Names."}
		},

		"Object List Functions" -> {
			{ObjectMap, "For each object in a list, applies a given function to the values of that object's fields."},
			{ObjectSelect, "Given a list of objects, selects those with fields matching the provided criteria."}
		},
		"Validating" -> {

		},
		"Calculate Options" -> {

		},
		"Preview" -> {
			{PlotTablePreview,"Previews the list which presents the values of Fields in the provided objects or Fields in these objects."}
		}

	},
	RelatedGuides -> {
		GuideLink["ObjectOntology"],
		GuideLink["EmeraldCloudFiles"],
		GuideLink["IncludingLiteratureReferences"],
		GuideLink["ConstellationUtilityFunctions"]
	}
]
