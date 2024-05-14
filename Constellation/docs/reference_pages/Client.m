(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineUsage[ProductionQ,
	{
		BasicDefinitions -> {{
			"ProductionQ[]",
			"isProduction",
			"returns True if SLL is communicating with the laboratory's database."
		}},
		MoreInformation -> {},
		Input :> {},
		Output :> {{
			"isProduction",
			True | False,
			"True if SLL is communicating with the laboratory's database, otherwise False."
		}},
		SeeAlso -> {"Login", "Logout", "Download", "Upload", "Search"},
		Author -> {"platform"}
	}
];

DefineUsage[ConstellationObjectReferenceAssoc,
	{
		BasicDefinitions -> {
			{"ConstellationObjectReferenceAssoc[objectRef]", "encodedRef", "returns an association in the format used in Constellation APIs."}
		},
		MoreInformation -> {},
		Input :> {
			{"objectRef", ObjectReferenceP[], "A given object or model reference."}
		},
		Output :> {
			{"encodedRef", _Association, "An association with the type and the name or ID."}
		},
		SeeAlso -> {"Login", "Logout", "Download", "Upload", "Search"},
		Author -> {"platform"}
	}
];

DefineUsage[Rfc3339ToDateObject,
	{
		BasicDefinitions -> {
			{"Rfc3339ToDateObject[string]", "date", "returns a date object in the format used in Constellation APIs."}
		},
		Input :> {
			{"string", _String, "A date string used in Constellation APIs."}
		},
		Output :> {
			{"date", _DateObject, "A date object representing the date string provided."}
		},
		TestsRequired -> False,
		SeeAlso -> {"DateObjectToRFC3339"},
		Author -> {"platform"}
	}
];

DefineUsage[DateObjectToRFC3339,
	{
		BasicDefinitions -> {
			{"DateObjectToRFC3339[date]", "string", "returns a string in the format used in Constellation APIs."}
		},
		Input :> {
			{"date", _DateObject, "A date object to be converted to a date string used in Constellation APIs."}
		},
		Output :> {
			{"string", _String, "A date string representing the date used in Constellation APIs."}
		},
		TestsRequired -> False,
		SeeAlso -> {"Rfc3339ToDateObject"},
		Author -> {"platform"}
	}
];