(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Object Ontology",
	Abstract -> "Every Constellation object has a specific type which defines the fixed set of fields available to upload and download information to and from the object. So for instance Object[Instrument,MassSpectrometer,\"Sparkey\"] is a MALDI-ToF mass spectroscopy instrument at the ECL-2 facility, and this object is of type Object[Instrument, MassSpectrometer]. Object[Instrument, MassSpectrometer] contains fields pertaining to mass spectrometers such as the kind of MassAnalyzer it uses, the MaxMass and MinMass the instrument is capable of resolving, etc.  Objects of more detailed subtypes such Object[Instrument, MassSpectrometer] also can contain all the fields pertaining to their parent type Object[Instrument] which include more general things like a link to the Manufacturer, or the DateInstalled, etc.\nThis guide contains a collection of functions for listing the different types of objects and what fields are in those objects (as well as functions for testing if something is an object of a given type or if something contains a given field) as well as some utility functions to check if something is a well composed object ID or link to an object.",
	Reference -> {
		"Working with the Many Different Types of Objects" -> {
			{Types, "Provides a list of all types or subtypes of Constellation objects."},
			{TypeQ, "Checks if inputs match a given Constellation types or subtypes."},
			{TypeP, "Pattern definitions matching Constellation types and subtypes."}
		},

		"Working with Fields within these Types of Objects" -> {
			{Fields, "Provides a list of all fields available to a given type of Constellation Object."},
			{FieldQ, "Checks if inputs match a fields in Constellation for a given type or subtype."},
			{FieldP, "Pattern definitions matching Constellation types and subtypes."},
			{SingleFieldQ, "Checks if the field definition is a Single field."},
			{MultipleFieldQ, "Checks if the field definition is a Multiple field."},
			{ComputableFieldQ, "Returns True if a given field is computable."},
			{FieldReferenceP, "Is a pattern which matches any field reference or matches a specific field reference if a type or a type and a field are specified."},
			{NamedFieldQ, "Checks if the field definition is a named field."}
		},

		"Working with references to Constellation objects" -> {
			{Object, "Wrapper for referring to a Constellation object."},
			{Model, "Wrapper for referring to a special Constellation object which denotes model based information that likely applies to many objects."},
			{Link, "Wrapper for a clickable link to a Constellation object or a link to a specific field within a Constellation object."},
			{ObjectQ, "Checks if inputs match Constellation objects of a given type or subtype."},
			{ObjectP, "Pattern definitions matching Constellation objects of a given type or subtype."},
			{ObjectReferenceQ,"Checks if inputs match Constellation objects of a defined Model or Objet type. Return False for Links."},
			{LinkedObject, "Returns the object associated with the link."},
			{ObjectReferenceP, "Returns a Object/Model pattern that matches the pattern of the input, or matches any Object/Model pattern if no input was provided."},
			{LinkP, FieldReferenceP}
		}
	},
	RelatedGuides -> {
		GuideLink["WorkingWithConstellationObjects"],
		GuideLink["EmeraldCloudFiles"],
		GuideLink["IncludingLiteratureReferences"],
		GuideLink["ConstellationUtilityFunctions"]
	}
]
