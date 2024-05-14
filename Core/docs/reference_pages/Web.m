(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*PageSections*)


DefineUsage[PageSections,
	{
		BasicDefinitions -> {
			{"PageSections[objects]", "paths", "finds the Command Center Sections path of an object if one exists for the object."}
		},
		MoreInformation -> {
			"Only objects that were created in the Command Center page which has parsed SecionsJSON will have a path.",
			"The first part of the path will always be the Object[Notebook, Page] the input object is associated with."
		},
		Input :> {
			{"objects", ObjectReferenceP[] | {ObjectReferenceP[]..}, "The specific objects for which to find the paths."}
		},
		Output :> {
			{"paths", {ObjectReferenceP[Object[Notebook, Page]], __String} | {{ObjectReferenceP[Object[Notebook, Page]], __String}...}, "The paths for the input objects, starting with a Page object, and followed by String section names."}
		},
		SeeAlso -> {"Upload", "Download", "ObjectReferenceP"},
		Author -> {"platform"}
	}
];

DefineUsage[ImportJSONToAssociation,
	{
		BasicDefinitions -> {
			{"ImportJSONToAssociation[string]", "association", "converts a json string into a valid association."}
		},
		MoreInformation -> {
			"Converts a json string into an association. Will handle more unicode characters than the default ImportString function."
		},
		Input :> {
			{"string", _String, "The json string to be converted."}
		},
		Output :> {
			{"association", ListableP[_Association], "The association or list of associations of the provided json string."}
		},
		SeeAlso -> {"ExportAssociationToJSON"},
		Author -> {"platform"}
	}
];

DefineUsage[ExportAssociationToJSON,
	{
		BasicDefinitions -> {
			{"ExportAssociationToJSON[association]", "string", "converts a valid association into a json string."}
		},
		MoreInformation -> {
			"Converts an association to a json string. Will handle more unicode characters than the default ExportJSON function."
		},
		Input :> {
			{"association", _Association, "The association to be converted."}
		},
		Output :> {
			{"string", _String, "The json of the provided association."}
		},
		SeeAlso -> {"ImportJSONToAssociation"},
		Author -> {"platform"}
	}
];