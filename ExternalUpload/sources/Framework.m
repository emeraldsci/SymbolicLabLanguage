(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*Helper Parser Functions (UploadMolecule/UploadSampleModel)*)


(* ::Subsubsection::Closed:: *)
(*PubChem CID To Association (parsePubChemCID)*)


(* Helper function to go from a PubChem CID (Compound ID) to an association of relevant information. *)
(* We do not memoize this function because it should always be called by another memoized function. *)
(* These other higher level functions check if they fail and do not memoize if so. This is because the *)
(* PubChem API can sometimes spuriously return errors or not connect and we do not want to memoize a bad result. *)
parsePubChemCID[cid_]:=Module[
	{pubChemCIDURL, filledURL, httpResponse, bodyResponse, jsonResponse, mainJSON, identifiersJSON, name, computedDescriptorsJSON, molecularFormula, radioactive,
		iupac, inchi, inchiKey, otherIdentifiersJSON, cas, unii, synonymsJSON, synonyms, physicalPropertiesJSON, computedPropertiesJSON,
		molecularWeight, simulatedLogP, logP, experimentalPropertiesJSON, state, pka, viscosity, meltingPoint, boilingPoint, hazardous, flammable,
		pyrophoric, waterReactive, fuming, pCodes, safetyJSON, unNumber, dotHazardClass, nfpaHazards, structureFileURL, imageFileURL},

	(* The following is the template URL of the PubChem API for CIDs. The CID goes in `1`. *)
	pubChemCIDURL="https://pubchem.ncbi.nlm.nih.gov/rest/pug_view/data/compound/`1`/JSON/";

	(* Fill out the template URL with the given CID. *)
	filledURL=StringTemplate[pubChemCIDURL][ToString[cid]];

	(* Get the body of the response from this URL. *)
	httpResponse=ManifoldEcho[URLRead[filledURL], "URLRead[\""<>ToString[filledURL]<>"\"]"];
	bodyResponse=Quiet[httpResponse["Body"]];

	(* Some of the entries on PubChem have bad UTF-8 encodings. Export as a correct UTF-8 encoding in order to generate a valid JSON response. *)
	jsonResponse=Quiet[ImportString[ExportString[bodyResponse, "Text", CharacterEncoding -> "UTF8"], "RawJSON"]];

	(* If an error was returned, return a $Failed. Throw a message in the higher level function that called this one. *)
	If[MatchQ[jsonResponse, _Failure | $Failed | KeyValuePattern["Fault" -> _]],
		Return[$Failed];
	];

	(* There should only be one response packet. Pull out the main data from it. *)
	mainJSON=jsonResponse["Record"]["Section"];

	(* -- Parse out the names and identifiers section. -- *)
	identifiersJSON=SelectFirst[mainJSON, (KeyExistsQ[#, "TOCHeading"] && #["TOCHeading"] == "Names and Identifiers"&)]["Section"];

	(* Parse out the primary identifying name. *)
	name=Quiet[Check[
		Module[{nameAssociation},
			jsonResponse["Record"]["RecordTitle"]
		],
		Null
	]];

	(* Parse out the molecular formula. *)
	molecularFormula=Quiet[Check[
		Module[{molecularFormulaAssociation},
			(* Get the association that contains the IUPAC Name. *)
			molecularFormulaAssociation=SelectFirst[identifiersJSON, (KeyExistsQ[#, "TOCHeading"] && #["TOCHeading"] == "Molecular Formula"&)];

			(* Sometimes there can be junk inside (text description) of the StringValue field. *)
			(* Sort strings from shortest \[Rule] longest (we don't want the long description), and resolve based on majority vote. *)
			First[Sort[Commonest[Cases[Lookup[molecularFormulaAssociation["Information"], Key["Value"]], PatternUnion[_String, Except["Italics" | "Superscript" | "Subscript"]], Infinity]]]]
		],
		Null
	]];

	(* Parse our radioactive information. *)
	radioactive=Quiet[Check[
		Module[{descriptionAssociation, descriptions},
			(* Being radioactive is a pretty big deal for a chemical - all radioactive examples I could find *)
			(* mentioned the word "radioactive" in the chemical description. *)
			(* Look for the work radioactive in the description and iff we find it, return True. *)

			descriptionAssociation=SelectFirst[identifiersJSON, (KeyExistsQ[#, "TOCHeading"] && #["TOCHeading"] == "Record Description"&)];

			(* Get the string descriptions for this molecule. *)
			(* Filter out any failed extractions. *)
			descriptions=Cases[(#["StringValue"]&) /@ descriptionAssociation["Information"], PatternUnion[_String, Except["Italics" | "Superscript" | "Subscript"]], Infinity];

			(* String join the descriptions and search for the word "radioactive" *)
			StringContainsQ[ToLowerCase[StringJoin[descriptions]], "radioactive"]
		],
		Null
	]];

	(* -- Computed Descriptors -- *)
	computedDescriptorsJSON=SelectFirst[identifiersJSON, (KeyExistsQ[#, "TOCHeading"] && #["TOCHeading"] == "Computed Descriptors"&)];

	(* Parse out the IUPAC name. *)
	iupac=Quiet[Check[
		Module[{iupacAssociation},
			(* Get the association that contains the IUPAC Name. *)
			iupacAssociation=SelectFirst[computedDescriptorsJSON["Section"], (KeyExistsQ[#, "TOCHeading"] && #["TOCHeading"] == "IUPAC Name"&)];

			First[Commonest[Cases[Lookup[iupacAssociation["Information"], Key["Value"]], PatternUnion[_String, Except["Italics" | "Superscript" | "Subscript"]], Infinity]]]
		],
		Null
	]];

	(* Parse out the InChI. *)
	inchi=Quiet[Check[
		Module[{inchiAssociation},
			(* Get the association that contains the IUPAC Name. *)
			inchiAssociation=SelectFirst[computedDescriptorsJSON["Section"], (KeyExistsQ[#, "TOCHeading"] && #["TOCHeading"] == "InChI"&)];

			First[Commonest[Cases[Lookup[inchiAssociation["Information"], Key["Value"]], PatternUnion[_String, Except["Italics" | "Superscript" | "Subscript"]], Infinity]]]
		],
		Null
	]];

	(* Parse out the InChIKey. *)
	inchiKey=Quiet[Check[
		Module[{inchiKeyAssociation},
			(* Get the association that contains the IUPAC Name. *)
			inchiKeyAssociation=SelectFirst[computedDescriptorsJSON["Section"], (KeyExistsQ[#, "TOCHeading"] && #["TOCHeading"] == "InChIKey"&)];

			First[Commonest[Cases[Lookup[inchiKeyAssociation["Information"], Key["Value"]], PatternUnion[_String, Except["Italics" | "Superscript" | "Subscript"]], Infinity]]]
		],
		Null
	]];

	(* -- Other Identifiers -- *)
	otherIdentifiersJSON=SelectFirst[identifiersJSON, (KeyExistsQ[#, "TOCHeading"] && #["TOCHeading"] == "Other Identifiers"&)];

	(* Parse out the CAS. *)
	cas=Quiet[Check[
		Module[{casAssociation, casValues},
			(* Get the association that contains the IUPAC Name. *)
			casAssociation=SelectFirst[otherIdentifiersJSON["Section"], (KeyExistsQ[#, "TOCHeading"] && #["TOCHeading"] == "CAS"&)];

			First[Commonest[Cases[Lookup[casAssociation["Information"], Key["Value"]], PatternUnion[_String, Except["Italics" | "Superscript" | "Subscript"]], Infinity]]]
		],
		Null
	]];

	(* Parse out the UNII. *)
	unii=Quiet[Check[
		Module[{uniiAssociation, uniiValues},
			(* Get the association that contains the IUPAC Name. *)
			uniiAssociation=SelectFirst[otherIdentifiersJSON["Section"], (KeyExistsQ[#, "TOCHeading"] && #["TOCHeading"] == "UNII"&)];

			First[Commonest[ToUpperCase /@ Cases[Lookup[uniiAssociation["Information"], Key["Value"]], PatternUnion[_String, Except["Italics" | "Superscript" | "Subscript"]], Infinity]]]
		],
		Null
	]];

	(* Parse out the UN Number. This is an international shipping number assigned by the United Nations. *)
	(* We will need it laster to figure out the DOT information (DOT links up to UN) . *)
	unNumber=Quiet[Check[
		Module[{unAssociation, unValues},
			(* Get the association that contains the IUPAC Name. *)
			unAssociation=SelectFirst[otherIdentifiersJSON["Section"], (KeyExistsQ[#, "TOCHeading"] && #["TOCHeading"] == "UN Number"&)];

			First[Commonest[Cases[Lookup[unAssociation["Information"], Key["Value"]], PatternUnion[_String, Except["Italics" | "Superscript" | "Subscript"]], Infinity]]]
		],
		Null
	]];

	synonymsJSON=SelectFirst[identifiersJSON, (KeyExistsQ[#, "TOCHeading"] && #["TOCHeading"] == "Synonyms"&)];
	(* Parse out the Synonyms. *)
	synonyms=Quiet[Check[
		Module[{synonymsAssociation},
			(* Get the association that contains the IUPAC Name. *)
			synonymsAssociation=SelectFirst[synonymsJSON["Section"], (KeyExistsQ[#, "TOCHeading"] && #["TOCHeading"] == "MeSH Entry Terms"&)];

			(* Pull out all of the synonyms. *)
			Cases[Lookup[synonymsAssociation["Information"], Key["Value"]], PatternUnion[_String, Except["Italics" | "Superscript" | "Subscript" | "Information" | "Value"]], Infinity]
		],
		{}
	]];

	(* -- Parse out the physical properties of this chemical. -- *)
	physicalPropertiesJSON=SelectFirst[mainJSON, (KeyExistsQ[#, "TOCHeading"] && #["TOCHeading"] == "Chemical and Physical Properties"&)]["Section"];

	computedPropertiesJSON=SelectFirst[physicalPropertiesJSON, (KeyExistsQ[#, "TOCHeading"] && #["TOCHeading"] == "Computed Properties"&)];

	(* Pull out the molecular weight *)
	molecularWeight=Quiet[Check[
		Module[{molecularWeightAssociation, potentialMolecularWeight},
			molecularWeightAssociation=SelectFirst[computedPropertiesJSON["Section"], (KeyExistsQ[#, "TOCHeading"] && #["TOCHeading"] == "Molecular Weight"&)];

			potentialMolecularWeight=With[{
				mass=molecularWeightAssociation["Information"][[1]]["Value"]["Number"][[1]],
				stringMass=ToExpression[molecularWeightAssociation["Information"][[1]]["Value"]["StringWithMarkup"][[1]]["String"]],
				unit=molecularWeightAssociation["Information"][[1]]["Value"]["Unit"]
			},
				Which[
					MatchQ[mass,GreaterP[0]],
					Quantity[mass, unit],
					MatchQ[stringMass,GreaterP[0]],
					Quantity[stringMass, unit],
					True,
					$Failed
				]
			];

			If[MatchQ[potentialMolecularWeight, _?QuantityQ] && MatchQ[potentialMolecularWeight, UnitsP[Gram / Mole]],
				potentialMolecularWeight,
				Null
			]
		],
		Null
	]];

	(* Pull out the simulated LogP. *)
	simulatedLogP=Quiet[Check[
		Module[{logPAssociation, potentialLogP},
			logPAssociation=SelectFirst[computedPropertiesJSON["Section"], (KeyExistsQ[#, "TOCHeading"] && #["TOCHeading"] == "XLogP3"&)];

			potentialLogP=logPAssociation["Information"][[1]]["Value"]["Number"][[1]];

			If[MatchQ[potentialLogP, _?NumericQ],
				potentialLogP,
				Null
			]
		],
		Null
	]];

	(* -- Experimental Properties -- *)
	experimentalPropertiesJSON=SelectFirst[physicalPropertiesJSON, (KeyExistsQ[#, "TOCHeading"] && #["TOCHeading"] == "Experimental Properties"&)];

	(* Pull out the LogP. *)
	logP=Quiet[Check[
		(* NOTE: have to protect LogP here because the ToExpression can sometimes change the LogP string into our symbol. *)
		Module[{logPAssociation, potentialLogPs, LogP},
			logPAssociation=Lookup[SelectFirst[experimentalPropertiesJSON["Section"], (#["TOCHeading"] == "LogP"&)], "Information"];

			potentialLogPs=Commonest@Cases[
				Flatten[{
					Quiet[StringCases[Lookup[Cases[Flatten@Lookup[Lookup[logPAssociation, "Value"], "StringWithMarkup"][[All, 1]], _Association], "String"], x : NumberString :> ToExpression[x]]],
					Quiet[StringCases[Flatten@Lookup[Lookup[logPAssociation, "Value"], "Number"][[All, 1]], x : NumberString :> ToExpression[x]]]
				}],
				_?NumericQ
			];

			If[Length[potentialLogPs] > 0,
				(* See if there is a most common LogP that we parsed out. *)
				If[Length[Commonest[potentialLogPs]] == 1,
					(* There is a most common LogP. Return that. *)
					First[Commonest[potentialLogPs]],
					(* There is not a most common LogP, Return the Median. *)
					N[Median[potentialLogPs]]
				],
				Null
			]
		],
		Null
	]];

	(* Get the state of matter *)
	state=Quiet[Check[
		Module[{physicalDescription, joinedDescriptions, solidCounts, liquidCounts, gasCounts},
			physicalDescription=Lookup[SelectFirst[experimentalPropertiesJSON["Section"], (#["TOCHeading"] == "Physical Description"&)], "Information"];

			(* For each of the physical descriptions, string join them together. *)
			joinedDescriptions=ToLowerCase[
				StringJoin[
					Riffle[
						(Lookup[#, Key["StringValue"], " "]&) /@ physicalDescription,
						" "]
				]
			];

			(* Count the number of times that Solid, Liquid, and Gas show up in the text. *)
			solidCounts=Length[StringPosition[joinedDescriptions, "solid"]];
			liquidCounts=Length[StringPosition[joinedDescriptions, "liquid"]];
			gasCounts=Length[StringPosition[joinedDescriptions, "gas"]];

			Switch[First[FirstPosition[{solidCounts, liquidCounts, gasCounts}, Max[{solidCounts, liquidCounts, gasCounts}]]],
				1,
				Solid,
				2,
				Liquid,
				3,
				Gas
			]
		],
		Null
	]];

	(* Parse out pH. This will tell us *)
	pka=Quiet[Check[
		Module[{pkaAssociation, pkaStrings, digitPattern, pKaParsedStrings},
			pkaAssociation=Lookup[SelectFirst[experimentalPropertiesJSON["Section"], (#["TOCHeading"] == "Dissociation Constants"&)], "Information"];

			(* Parse out the pKa strings *)
			pkaStrings=Cases[Lookup[pkaAssociation, Key["Value"], {}], _String, Infinity];

			(* Define a pattern for things that can show up in our pKa *)
			digitPattern=DigitCharacter | "." | "-" | "+" | ";";

			(* The pKa string is always in the form pKa=___ or pKa=___; pKb=___ or pKa=___ at 25 deg; pKb=___ at 25 deg *)
			(* Try to pull out the pKa value from the string. *)
			pKaParsedStrings=Flatten[(
				ToExpression[
					StringCases[#, {
						"pKa = "~~x:digitPattern.. :> x,
						"pKa="~~x:digitPattern.. :> x,
						"pKa ="~~x:digitPattern.. :> x
					}]
				]&
			) /@ pkaStrings];

			(* Return the median of the parsed strings that match NumericP *)
			If[Length[Cases[pKaParsedStrings, NumericP]] > 0,
				Median[Cases[pKaParsedStrings, NumericP]],
				Null
			]
		],
		Null
	]];

	(* Parse out viscosity. *)
	viscosity=Quiet[Check[
		Module[{viscosityAssociation, viscosityStrings, viscosityParsedStrings, medianViscosity},
			viscosityAssociation=Lookup[SelectFirst[experimentalPropertiesJSON["Section"], (#["TOCHeading"] == "Viscosity"&)], "Information"];

			(* Parse out the pKa strings *)
			viscosityStrings=Cases[Lookup[viscosityAssociation, Key["Value"], {}], _String, Infinity];

			(* The pKa string is always in the form ____ at __ deg C. *)
			(* Try to pull out the pKa value from the string. *)
			viscosityParsedStrings=(N[Quantity[First[StringSplit[#, "at"]]]]&) /@ viscosityStrings;

			(* Take the median of the parsed strings. *)
			medianViscosity=Quiet[Median[Cases[viscosityParsedStrings, _?QuantityQ]]];

			(* If we were able to succesfully calculate a median value, convert it to Centipoise and return. *)
			If[MatchQ[medianViscosity, _?QuantityQ] && MatchQ[medianViscosity, ViscosityP],
				UnitConvert[medianViscosity, Centipoise],
				Null
			]
		],
		Null
	]];

	(* Get the melting point *)
	meltingPoint=Quiet[Check[
		Module[
			{meltingPointDescriptionAssociations, meltingPointDescriptions, meltingPoints, filteredMeltingPoints},

			(* Get all of the string descriptions of the melting point. *)
			meltingPointDescriptionAssociations=Lookup[SelectFirst[experimentalPropertiesJSON["Section"], (#["TOCHeading"] == "Melting Point"&)], "Information"];
			meltingPointDescriptions=Cases[Lookup[meltingPointDescriptionAssociations, Key["Value"]], _String, Infinity];

			(* For each of the descriptions, try to parse it into a quantity. Return Null if the parsing fails. *)
			meltingPoints=Map[
				Function[{meltingPointDescription},
					Module[{parsedQuantity},
						(* Attempt to parse the description into a quantity. If it fails, return Null. *)
						Quiet[Check[
							(* Parse the description into a quantity. *)
							parsedQuantity=Quantity[meltingPointDescription];

							(* If the parsed quantity matches an Interval *)
							If[MatchQ[parsedQuantity, Quantity[_Interval, _]],
								(* Average the min and max *)
								N[(Min[parsedQuantity] + Max[parsedQuantity]) / 2],
								(* Otherwise, return the quantity. *)
								parsedQuantity
							]
							, Null]]
					]
				],
				meltingPointDescriptions];

			(* Filter out the Nulls from the melting points. *)
			filteredMeltingPoints=Cases[meltingPoints, TemperatureP];

			(* If we ended up with any successful parsings, return the median. Otherwise, return Null. *)
			If[Length[filteredMeltingPoints] > 0,
				(* See if there is a most common melting point that we parsed out. *)
				If[Length[Commonest[filteredMeltingPoints]] == 1,
					(* There is a most common melting point. Return that. *)
					First[Commonest[filteredMeltingPoints]],
					(* There is not a most common melting point, Return the Median. *)
					N[Median[filteredMeltingPoints]]
				],
				Null
			]
		],
		Null
	]];

	(* Get the boiling point *)
	boilingPoint=Quiet[Check[
		Module[
			{boilingPointDescriptionAssociations, boilingPointDescriptions, boilingPoints, filteredBoilingPoints},

			(* Get all of the string descriptions of the boiling point. *)
			boilingPointDescriptionAssociations=Lookup[SelectFirst[experimentalPropertiesJSON["Section"], (#["TOCHeading"] == "Boiling Point"&)], "Information"];
			boilingPointDescriptions=Cases[Lookup[boilingPointDescriptionAssociations, Key["Value"]], _String, Infinity];

			(* For each of the descriptions, try to parse it into a quantity. Return Null if the parsing fails. *)
			boilingPoints=Map[
				Function[{boilingPointDescription},
					Module[{parsedQuantity},
						(* Attempt to parse the description into a quantity. If it fails, return Null. *)
						Quiet[Check[
							(* Parse the description into a quantity. *)
							parsedQuantity=Quantity[boilingPointDescription];

							(* If the parsed quantity matches an Interval *)
							If[MatchQ[parsedQuantity, Quantity[_Interval, _]],
								(* Average the min and max *)
								N[(Min[parsedQuantity] + Max[parsedQuantity]) / 2],
								(* Otherwise, return the quantity. *)
								parsedQuantity
							]
							, Null]]
					]
				],
				boilingPointDescriptions];

			(* Filter out the Nulls from the boiling points. *)
			filteredBoilingPoints=Cases[boilingPoints, TemperatureP];

			(* If we ended up with any successful parsings, return the median. Otherwise, return Null. *)
			If[Length[filteredBoilingPoints] > 0,
				(* See if there is a most common boiling point that we parsed out. *)
				If[Length[Commonest[filteredBoilingPoints]] == 1,
					(* There is a most common boiling point. Return that. *)
					First[Commonest[filteredBoilingPoints]],
					(* There is not a most common boiling point, Return the Median. *)
					N[Median[filteredBoilingPoints]]
				],
				Null
			]
		],
		Null
	]];

	(* -- Safety and Hazards Information Properties -- *)
	safetyJSON=SelectFirst[mainJSON, (KeyExistsQ[#, "TOCHeading"] && #["TOCHeading"] == "Safety and Hazards"&)]["Section"];

	(* Parse out the Precautionary Statement Codes from the GHS Classification description. *)
	(* These Precautionary Statement Codes (P-Codes) will inform us of the Health & Safety fields. *)
	pCodes=Quiet[Check[
		Module[{hazardsAssociation, ghsClassificationAssociation, ghsInformation, ghsStrings},
			hazardsAssociation=Lookup[SelectFirst[safetyJSON, (KeyExistsQ[#, "TOCHeading"] && #["TOCHeading"] == "Hazards Identification"&)], "Section"];
			ghsClassificationAssociation=SelectFirst[hazardsAssociation, (#["TOCHeading"] == "GHS Classification"&)];

			(* Actuall pull out the HTML that displays the GHS classification now. *)
			ghsInformation=SelectFirst[ghsClassificationAssociation["Information"], (#["Name"] == "Precautionary Statement Codes"&)];

			(* Get the strings.*)
			ghsStrings=ghsInformation["Value"]["StringWithMarkup"][[1]]["String"];

			(* If we weren't able to get the GHS strings, return an empty list. *)
			If[!MatchQ[ghsStrings, _String],
				Null,
				(* The P-Codes are in the format P### where # is a number. *)
				(* Pull out all of the P-Codes from the GHS Information. *)
				StringCases[ghsStrings, "P"~~DigitCharacter~~DigitCharacter~~DigitCharacter]
			]
		],
		Null
	]];

	(* Figure out if this chemical is hazardous. *)
	hazardous=Quiet[Check[
		Module[{hazardsAssociation, ghsClassificationAssociation, ghsInformation, ghsStrings},
			hazardsAssociation=Lookup[SelectFirst[safetyJSON, (KeyExistsQ[#, "TOCHeading"] && #["TOCHeading"] == "Hazards Identification"&)], "Section"];
			ghsClassificationAssociation=SelectFirst[hazardsAssociation, (#["TOCHeading"] == "GHS Classification"&)];

			(* Actuall pull out the HTML that displays the GHS classification now. *)
			ghsInformation=SelectFirst[ghsClassificationAssociation["Information"], (#["Name"] == "GHS Classification"&)];

			(* Get the strings.*)
			ghsStrings=Cases[Lookup[ghsInformation, Key["Value"]], _String, Infinity];

			(* PubChem displays the string "Reported as not meeting GHS hazard criteria..." if the majority of *)
			(* sources which it pulls from say that it is not hazardous. Search for this string. *)
			If[!SameQ[pCodes, Null],
				!StringContainsQ[ghsStrings, "Reported as not meeting GHS hazard criteria"],
				Null
			]
		],
		Null
	]];

	(* Figure out from the P-Codes if this chemical is Flammable. *)
	flammable=Quiet[Check[
		Module[{flammablePCodes},
			(* The following are the P-Codes that indicate that this chemical is Flammable. *)
			flammablePCodes={"P210", "P211", "P220", "P221", "P241", "P242", "P243", "P244", "P250", "P251", "P283", "P370", "P371", "P372"};

			(* Do our P-Codes contain any of these? *)
			If[!SameQ[pCodes, Null],
				ContainsAny[pCodes, flammablePCodes],
				Null
			]
		],
		Null
	]];

	(* Figure out from the P-Codes if this chemical is pyrophoric. *)
	pyrophoric=Quiet[Check[
		Module[{pyrophoricPCodes},
			(* The following are the P-Codes that indicate that this chemical is pyrophoric. *)
			pyrophoricPCodes={"P222", "P231", "P232"};

			(* Do our P-Codes contain any of these? *)
			If[!SameQ[pCodes, Null],
				ContainsAny[pCodes, pyrophoricPCodes],
				Null
			]
		],
		Null
	]];

	(* Figure out from the P-Codes if this chemical is water reactive. *)
	waterReactive=Quiet[Check[
		Module[{waterReactivePCodes},
			(* The following are the P-Codes that indicate that this chemical is pyrophoric. *)
			waterReactivePCodes={"P222", "P223", "P231", "P232"};

			(* Do our P-Codes contain any of these? *)
			If[!SameQ[pCodes, Null],
				ContainsAny[pCodes, waterReactivePCodes],
				Null
			]
		],
		Null
	]];

	(* Figure out from the P-Codes if this chemical is fuming (releases rumes on exposure to air). *)
	fuming=Quiet[Check[
		Module[{fumingPCodes},
			(* The following are the P-Codes that indicate that this chemical is pyrophoric. *)
			fumingPCodes={"P260", "P261", "P284", "P285", "P304", "P403"};

			(* Do our P-Codes contain any of these? *)
			If[!SameQ[pCodes, Null],
				ContainsAny[pCodes, fumingPCodes],
				Null
			]
		],
		Null
	]];

	(* Lookup the safety and hazard properties. *)
	nfpaHazards=Quiet[Check[
		Module[{hazardsAssociation, nfpaAssociations, fireRating, healthRatingPacket, healthRating, reactivityRatingPacket, reactivityRating},
			(* Pull out the Safety & Hazards Properties section. *)
			hazardsAssociation=Lookup[SelectFirst[safetyJSON, (KeyExistsQ[#, "TOCHeading"] && #["TOCHeading"] == "Safety and Hazard Properties"&)], "Section"];

			(* Pull out the NFPA sections. *)
			nfpaAssociations=Select[hazardsAssociation, (MatchQ[#["TOCHeading"], "NFPA Fire Rating" | "NFPA Health Rating" | "NFPA Reactivity Rating"]&)];

			(* If there is more than one NFPA, we can parse them. *)
			If[Length[nfpaAssociations] > 1,
				Module[{fireRatingPacket},
					(* NFPA ratings that aren't included are implicitly 0. No idea why PubChem does this. *)
					fireRatingPacket=SelectFirst[nfpaAssociations, (#["TOCHeading"] == "NFPA Fire Rating"&)];

					(* If there is a fire rating, set it. Otherwise, it is implicitly 0. *)
					fireRating=If[Length[fireRatingPacket] > 1,
						ToExpression[First[fireRatingPacket["Information"]]["Value"]["StringWithMarkup"][[1]]["String"]],
						0
					];

					(* NFPA ratings that aren't included are implicitly 0. No idea why PubChem does this. *)
					healthRatingPacket=SelectFirst[nfpaAssociations, (#["TOCHeading"] == "NFPA Health Rating"&)];

					(* If there is a health rating, set it. Otherwise, it is implicitly 0. *)
					healthRating=If[Length[healthRatingPacket] > 1,
						ToExpression[First[healthRatingPacket["Information"]]["Value"]["StringWithMarkup"][[1]]["String"]],
						0
					];

					(* NFPA ratings that aren't included are implicitly 0. No idea why PubChem does this. *)
					reactivityRatingPacket=SelectFirst[nfpaAssociations, (#["TOCHeading"] == "NFPA Reactivity Rating"&)];

					(* If there is a reactivity rating, set it. Otherwise, it is implicitly 0. *)
					reactivityRating=If[Length[reactivityRatingPacket] > 1,
						ToExpression[First[reactivityRatingPacket["Information"]]["Value"]["StringWithMarkup"][[1]]["String"]],
						0
					];

					(* PubChem doesn't store information about the special hazard. Return an empty list for now, thinking about how to get this information. *)
					{healthRating, fireRating, reactivityRating, {}}
				],
				(* If there are no NFPA Associations, then return Null. *)
				Null
			]
		],
		Null
	]];

	(* Parse the DOT Hazard Class using the DOT Hazardous materials table. *)
	dotHazardClass=Quiet[Check[
		Module[{dotData, chemicalRecord, dotHazardNumber},
			(* If we were able to find a UN number before, use that to look up the DOT Hazard Class. *)
			If[!SameQ[unNumber, Null],
				(* Import our DOT Hazard dataset and look for this UN Number. *)
				dotData=First[ImportCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "2839ab6f678c00e033bbb46e1d53638b.xls"]]];

				(* The UN Number in this dataset is in the 4th column. Do a search for the UN Number. *)
				chemicalRecord=SelectFirst[dotData, (#[[2]] == "UN"<>ToString[unNumber]&)];

				(* From our dataset, the DOT Hazard number is in the 3rd column. *)
				dotHazardNumber=chemicalRecord[[1]];

				(* Convert this Hazard number into the correct Emerald string that matches DOTHazardClassP. *)
				Switch[dotHazardNumber,
					0.,
					"Class 0",
					1.1,
					"Class 1 Division 1.1 Mass Explosion Hazard",
					1.2,
					"Class 1 Division 1.2 Projection Hazard",
					1.3,
					"Class 1 Division 1.3 Fire, Blast, or Projection Hazard",
					1.4,
					"Class 1 Division 1.4 Limited Explosion",
					1.5,
					"Class 1 Division 1.5 Insensitive Mass Explosion Hazard",
					1.6,
					"Class 1 Division 1.6 Insensitive No Mass Explosion Hazard",
					2.1,
					"Class 2 Division 2.1 Flammable Gas Hazard",
					2.2,
					"Class 2 Division 2.2 Non-Flammable Gas Hazard",
					2.3,
					"Class 2 Division 2.3 Toxic Gas Hazard",
					3.,
					"Class 3 Flammable Liquids Hazard",
					4.1,
					"Class 4 Division 4.1 Flammable Solid Hazard",
					4.2,
					"Class 4 Division 4.2 Spontaneously Combustible Hazard",
					4.3,
					"Class 4 Division 4.3 Dangerous when Wet Hazard",
					5.1,
					"Class 5 Division 5.1 Oxidizers Hazard",
					5.2,
					"Class 5 Division 5.2 Organic Peroxides Hazard",
					6.1,
					"Class 6 Division 6.1 Toxic Substances Hazard",
					6.2,
					"Class 6 Division 6.2 Infectious Substances Hazard",
					7.,
					"Class 7 Division 7 Radioactive Material Hazard",
					8.,
					"Class 8 Division 8 Corrosives Hazard",
					9.,
					"Class 9 Miscellaneous Dangerous Goods Hazard",
					_,
					Null
				],
				(* Otherwise, we don't currently have a way of looking up the DOT Hazard Class. Return Null. *)
				Null
			]
		],
		Null
	]];

	(* -- Misc -- *)
	(* Having the PubChem ID buys us a few more things *)
	structureFileURL="https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/"<>ToString[cid]<>"/record/SDF/?record_type=2d&response_type=display";
	imageFileURL="https://pubchem.ncbi.nlm.nih.gov/image/imagefly.cgi?cid="<>ToString[cid]<>"&width=500&height=500";


	(* Chemicals should all be BSL-1? *)
	(* DefaultStorageCondition *)
	(* IncompatibleMaterials *)
	(* Resolve StorageCondition based on safety information. *)

	(* Return an association with our constructed information. *)
	<|
		Name -> name,
		MolecularWeight -> molecularWeight,
		MolecularFormula -> molecularFormula,
		StructureFile -> structureFileURL,
		StructureImageFile -> imageFileURL,
		CAS -> cas,
		UNII -> unii,
		IUPAC -> iupac,
		InChI -> inchi,
		InChIKey -> inchiKey,
		Synonyms -> synonyms,
		State -> state,
		pKa -> pka,
		(* Additional scraping data that we should only lookup if we're being called from SimulateLogPartitionCoefficient. *)
		If[MatchQ[ExternalUpload`Private`$SimulatedLogP, True],
			SimulatedLogP -> simulatedLogP,
			Nothing
		],
		LogP -> logP,
		BoilingPoint -> boilingPoint,
		MeltingPoint -> meltingPoint,
		Viscosity -> viscosity,
		Radioactive -> radioactive,
		ParticularlyHazardousSubstance -> TrueQ[hazardous],
		MSDSRequired -> Not /@ TrueQ[hazardous],
		DOTHazardClass -> dotHazardClass,
		NFPA -> nfpaHazards,
		Flammable -> flammable,
		Pyrophoric -> pyrophoric,
		WaterReactive -> waterReactive,
		Fuming -> fuming,
		Ventilated -> TrueQ[fuming],
		PubChemID -> ToExpression[cid],

		(* Automatically populate the native representation if we have the InChI. *)
		If[MatchQ[inchi, InChIP],
			Molecule -> Molecule[inchi],
			Nothing
		]
	|>
];



(* ::Subsubsection::Closed:: *)
(*PubChem CID to Association (parsePubChem) *)


parsePubChem[PubChem[myPubChemID_]]:=Module[
	{result},

	(* Attempt to query PubChem using this PubChem ID. If the PubChem server errors out, set our result to #Failed.*)
	result=Quiet[
		Check[
			parsePubChemCID[ToString[myPubChemID]],
			$Failed]
	];

	(* If the query didn't fail, memoize it. *)
	If[!SameQ[result, $Failed],
		parsePubChem[PubChem[myPubChemID]]=result;
	];

	(* Return the result. *)
	result
];



(* ::Subsubsection::Closed:: *)
(*Chemical Identifier to Association (parseChemicalIdentifier)*)


(* This helper function takes in a chemical identifier (including name) and returns an association of PubChem information. *)
parseChemicalIdentifier[identifier_String]:=Module[
	{result, pubChemNameURL, filledURL, jsonResponse, cid},
	result=Quiet[
		Check[
			(* The following is the template URL of the PubChem API for CIDs. The CID goes in `1`. *)
			pubChemNameURL="https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/name/JSON?name=`1`";

			(* Fill out the template URL with the given CID. *)
			filledURL=StringTemplate[pubChemNameURL][EncodeURIComponent[identifier]];

			(* Make a POST request to this URL. *)
			jsonResponse=ManifoldEcho[Quiet[URLExecute[filledURL, "RawJSON"]], "URLExecute[\""<>ToString[filledURL]<>"\", \"RawJSON\"]"];

			(* If an error was returned, return $Failed. Throw a message in the higher level function that called this one. *)
			If[MemberQ[jsonResponse, _Failure],
				Return[$Failed];
			];

			(* Extract the CID from the JSON packet. *)
			cid=jsonResponse["PC_Compounds"][[1]]["id"]["id"]["cid"];

			(* Use the CID to association parser. *)
			parsePubChemCID[cid],

			(* If something happened, return $Failed. Our high-level functions check for this. *)
			$Failed
		]
	];

	(* Iff the result is not $Failed, memoize. *)
	If[!SameQ[result, $Failed],
		parseChemicalIdentifier[identifier]=result;
	];

	(* Return the result. *)
	result
];


(* ::Subsubsection::Closed:: *)
(*InChI to Association (parseInChI)*)

(* Overload for MM 12.3.1 which uses the Head ExternalIdentified[], instead of a direct string *)
parseInChI[ExternalIdentifier["InChI", identifier_String]]:=parseInChI[identifier];
(* This helper function takes in an InChI and returns an association of PubChem information. *)
parseInChI[identifier_String]:=Module[
	{result, pubChemInChIURL, filledURL, jsonResponse, cid},

	result=Quiet[
		Check[
			(* The following is the template URL of the PubChem API for CIDs. The CID goes in `1`. *)
			pubChemInChIURL="https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/inchi/JSON?inchi=`1`";

			(* Fill out the template URL with the given CID. *)
			filledURL=StringTemplate[pubChemInChIURL][EncodeURIComponent[identifier]];

			(* Make a POST request to this URL. *)
			jsonResponse=ManifoldEcho[
				Quiet[URLExecute[filledURL, "RawJSON"]],
				"Quiet[URLExecute[\""<>ToString[filledURL]<>"\", \"RawJSON\"]]"
			];

			(* If an error was returned, return $Failed. Throw a message in the higher level function that called this one. *)
			If[MemberQ[jsonResponse, _Failure],
				Return[$Failed];
			];

			(* Extract the CID from the JSON packet. *)
			cid=jsonResponse["PC_Compounds"][[1]]["id"]["id"]["cid"];

			(* Use the CID to association parser. *)
			parsePubChemCID[cid],

			(* If something happened, return $Failed. Our high-level functions check for this. *)
			$Failed
		]
	];

	(* Iff the result is not $Failed, memoize. *)
	If[!SameQ[result, $Failed],
		parseInChI[identifier]=result;
	];

	(* Return the result. *)
	result
];


(* ::Subsubsection::Closed:: *)
(*ThermoFisher to Association (parseThermoURL)*)


parseThermoURL[url_String]:=Module[
	{result, response, thermoWebsite, casList, generalCASList, casInformation, productID, msdsURL, msdsPage, msdsString, cas,
		pubChemInformation, informationWithMSDS, thermoName},

	(* Wrap our computation with Quiet[] and Check[] because sometimes contacting the web server can result in an error. *)
	result=Quiet[
		Check[

			(* Download the HTML for the website. *)
			response = ManifoldEcho[
				URLRead[HTTPRequest[url, <|Method -> "GET"|>]],
				"URLRead[HTTPRequest[\""<>ToString[url]<>"\", <|Method -> \"GET\"|>]]"
			];
			thermoWebsite = {response["Body"]};

			(* Return early if the URLRead failed *)
			If[MatchQ[thermoWebsite, {Missing["NotAvailable", "Body"]}],
				Return[$Failed]
			];

			(* Get the product number from the ThermoFisher URL. *)
			(* If for some reason the URL doesnt match this pattern, look for it in the thermoWebsite. *)
			(* If it can't be found in the URL or site content, set it to empty string *)
			productID = FirstCase[
				{
					StringCases[url, "/catalog/product/"~~x:(DigitCharacter | WordCharacter | "-").. :> x],
					StringCases[First[thermoWebsite], "\"productId\":\""~~x:(DigitCharacter | WordCharacter | "-")..~~"\"" :> x]
				},
				Except[{}],
				""
			];

			(* Attempt to parse out the name of this chemical from the page. *)
			thermoName = Quiet[Check[
				Module[{rawStringName},
					(* Pull out the string within the <title> ... </title> *)
					rawStringName = FirstOrDefault[First[StringCases[thermoWebsite, Shortest["<title" ~~ ___ ~~ ">" ~~ x__ ~~ "</title>"] :> x]]];

					(* Convert all HTML entities into empty strings (Mathematica can't handle these) *)
					If[MatchQ[rawStringName, Null],
						Null,
						StringReplace[rawStringName, {
							("&#" | "&")~~(DigitCharacter | WordCharacter)..~~";" :> "",
							" | "~~(DigitCharacter..)~~"-"~~__ -> ""
						}]
					]
				],
				(* We failed to get the name, return Null. *)
				Null
			]];

			(* Extract the CAS Number as a list. *)
			casList = First[
				StringCases[
					First[thermoWebsite],
					{
						"CAS number: "~~x:DigitCharacter..~~"-"~~y:DigitCharacter..~~"-"~~z:DigitCharacter..~~"<" -> {x, y, z},
						"CAS\",\"value\":\""~~x:DigitCharacter..~~"-"~~y:DigitCharacter..~~"-"~~z:DigitCharacter..~~"\"" -> {x, y, z},
						"CAS\",\n"~~Whitespace..~~"\"value\": \""~~x:DigitCharacter..~~"-"~~y:DigitCharacter..~~"-"~~z:DigitCharacter..~~"\"" -> {x, y, z}
					}
				],
				{}
			];

			(* If we successfully extracted CAS Number: XXX-XXX-XXX, use that. Otherwise, look for CAS in a more general way.*)
			generalCASList = If[Length[casList] > 0,
				{casList},
				StringCases[First[thermoWebsite], x:DigitCharacter..~~"-"~~y:DigitCharacter..~~"-"~~z:DigitCharacter.. -> {x, y, z}]
			];

			(* Download the information via PubChem via CAS or PubChemID *)
			casInformation = If[Length[generalCASList] > 0,
				(* Join the three extracted numbers to get the CAS. *)
				cas = StringJoin[Riffle[First[Commonest[generalCASList]], "-"]];

				(* Download the PubChem information via CAS. *)
				parseChemicalIdentifier[cas],

				(* Otherwise, we can't get information from the CAS. *)
				$Failed
			];

			(* Finally, if we couldn't get information from the InChIKey and we successfully parsed out a name, look for information from the name of the chemical. *)
			pubChemInformation = If[MatchQ[casInformation, $Failed] && !MatchQ[thermoName, Null],
				Module[{parsedByName},
					parsedByName = parseChemicalIdentifier[thermoName];

					If[!MatchQ[parsedByName, $Failed],
						parsedByName,
						casInformation
					]
				],
				casInformation
			];

			(* Attempt to get the MSDS Information. If we fail, that's okay - default to Null. *)
			msdsURL = Quiet[Check[

				(* Construct the URL to the MSDS of this chemical. *)
				msdsPage = "https://assets.thermofisher.com/TFS-Assets/LSG/SDS/"<>productID<>"_MTR-NALT_EN.pdf";

				(* Download the PDF and convert it to Plaintext. *)
				msdsString = Import[msdsPage, "Plaintext"];

				(* If we successfully got the URL and imported the body in plain text, return the msdsPage as the URL *)
				(* If we failed to get the PDF in Plaintext, msdsURL should be Null *)
				If[Length[StringCases[msdsString, "Safety Data Sheet"]] > 0,
					msdsPage,
					Null
				],

				(* Return Null if we encounter an error. *)
				Null
			]];

			(* Append MSDSFile\[Rule]msdsURL and MSDSRequired\[Rule]True *)
			(* MSDSRequired\[Rule]True should always be set when using a product URL to parse a chemical. *)
			informationWithMSDS = If[!MatchQ[pubChemInformation, $Failed],
				Merge[{<|MSDSFile -> msdsURL, MSDSRequired -> True|>, pubChemInformation}, (First[ToList[#]]&)],
				(* If something happened, return $Failed. Otherwise the whole association remains unevualated. *)
				$Failed
			];

			(* If the name parsing succeeded, return our association with the new name. *)
			If[!SameQ[thermoName, Null],
				(* The name parsing succeeded. Convert the association to a list so that we can replace the name. Then convert it back to an association. *)
				Module[{associationAsList, listWithName},
					(* Convert the association to a list. *)
					associationAsList = Normal[informationWithMSDS];

					(* Replace the name with our newly parsed name. *)
					listWithName = associationAsList /. (Name -> _) -> (Name -> thermoName);

					(* Convert it back to an association *)
					Association @@ listWithName
				],
				(* The name parsing didn't succeed. Return the original name. *)
				informationWithMSDS
			],

			(* If something happened, return $Failed. Our high-level functions check for this. *)
			$Failed
		]
	];

	(* Only memoize if the result wasn't Null. This is because the ThermoFisher server can sometimes fail or *)
	(* lock us out if we're making too many requests. *)
	If[!SameQ[result, $Failed],
		parseThermoURL[url] = result;
	];

	(* Return our result. *)
	result
];


(* ::Subsubsection::Closed:: *)
(*Sigma to Association (parseSigmaURL)*)


parseSigmaURL[url_String]:=Module[
	{result, sigmaWebsite, casList, generalCASList, cas, pubChemInformation, msdsURL,
		sigmaID, sigmaMSDSPage, msdsBody, msdsID, potentialMSDSURL, potentialMSDSBody,
		informationWithMSDS, sigmaName, inchiKeyList, casInformation, inchiKeyInformation},

	(* Wrap our computation with Quiet[] and Check[] because sometimes contacting the web server can result in an error. *)
	result = Quiet[
		Check[
			(* Download the HTML for the website. *)
			sigmaWebsite = {
				ManifoldEcho[
					URLRead[
						HTTPRequest[
							url,
							<|
								Method -> "GET",
								(* this is a header that we found can work to get a response for now, but just so people keep an eye sigma may block us at any time b/c we run unit tests and ping their website too often *)
								"Headers" -> {
									"accept-language" -> "en-US,en;q=0.9",
									"user-agent" -> "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Mobile Safari/537.36"
								}
							|>
						]
					]["Body"],
					"URLRead[HTTPRequest[\""<>ToString[url]<>"\", <|Method -> \"GET\", \"Headers\" -> {\"accept-language\" -> \"en-US,en;q=0.9\", \"user-agent\" -> \"Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Mobile Safari/537.36\"}|>]][\"Body\"]"
				]
			};

			(* Return early if the URLRead failed *)
			If[MatchQ[sigmaWebsite, {Missing["NotAvailable", "Body"]}],
				Return[$Failed]
			];

			(* Attempt to parse out the name of this chemical from the page. *)
			sigmaName = Quiet[Check[
				Module[{rawStringName},
					(* Pull out the string within the <title> ... </title> *)
					rawStringName = FirstOrDefault[
						StringCases[
							First[sigmaWebsite],
							{
								Shortest["\"title\":\"" ~~ x__ ~~ " " ~~ DigitCharacter.. ~~ "-" ~~ DigitCharacter.. ~~ "-" ~~ DigitCharacter ~~ "\",\"description\""] :> {x},
								Shortest["\"title\":\"" ~~ x__ ~~ " |"] :> {x}
							}
						],
						""
					];

					(* Convert all HTML entities into empty strings (Mathematica can't handle these) *)
					(* Also remove the | Sigma-Aldrich from the name. This shows up in the page title for styling. *)
					If[MatchQ[rawStringName, Null],
						Null,
						StringReplace[rawStringName, {
							"&#"~~(DigitCharacter | WordCharacter)..~~";" :> "",
							" | Sigma-Aldrich" -> "",
							" | "~~(DigitCharacter..)~~"-"~~__ -> ""
						}]
					]
				],
				(* We failed to get the name, return Null. *)
				Null
			]];

			(* Extract the CAS Number as a list. *)
			casList = FirstOrDefault[
				StringCases[
					First[sigmaWebsite],
					{
						"CAS No.: "~~x:DigitCharacter..~~"-"~~y:DigitCharacter..~~"-"~~z:DigitCharacter..~~";" -> {x, y, z},
						"casNumber\":\""~~x:DigitCharacter..~~"-"~~y:DigitCharacter..~~"-"~~z:DigitCharacter..~~"\"" -> {x, y, z},
						"CAS Number: "~~x:DigitCharacter..~~"-"~~y:DigitCharacter..~~"-"~~z:DigitCharacter..~~";" -> {x, y, z}
					}
				],
				{}
			];

			(* If we successfully extracted CAS Number: XXX-XXX-XXX, use that. Otherwise, look for CAS in a more general way.*)
			generalCASList = If[Length[casList] > 0,
				{casList},
				StringCases[First[sigmaWebsite], x:DigitCharacter..~~"-"~~y:DigitCharacter..~~"-"~~z:DigitCharacter.. -> {x, y, z}]
			];

			(* Download the information via PubChem via CAS or PubChemID *)
			casInformation = If[Length[generalCASList] > 0,
				(* Join the three extracted numbers to get the CAS. *)
				cas = StringJoin[Riffle[First[Commonest[generalCASList]], "-"]];

				(* Download the PubChem information via CAS. *)
				parseChemicalIdentifier[cas],

				(* Otherwise, we can't get information from the CAS. *)
				$Failed
			];

			(* If we couldn't get information from CAS, try to get the InChIKey. *)
			inchiKeyInformation = If[MatchQ[casInformation, $Failed],
				(* Look for the InChIKey. *)
				inchiKeyList = FirstOrDefault[
					StringCases[
						First[sigmaWebsite],
						{
							"InChI key\",\"values\":[\""~~x:LetterCharacter..~~"-"~~y:LetterCharacter..~~"-"~~z:LetterCharacter..~~"\"]"->{x~~"-"~~y~~"-"~~z},
							x:(WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~"-"~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~"-"~~WordCharacter):>{x}
						}
					],
					{}
				];

				(* Get PubChem information from the PubChem CID *)
				If[Length[inchiKeyList]==0,
					$Failed,
					parseChemicalIdentifier[First[inchiKeyList]]
				],
				(* Otherwise, we already have info from the CAS, use that. *)
				casInformation
			];

			(* Finally, if we couldn't get information from the InChIKey and we successfully parsed out a name, look for information from the name of the chemical. *)
			pubChemInformation = If[MatchQ[inchiKeyInformation, $Failed] && !MatchQ[sigmaName, Null],
				parseChemicalIdentifier[sigmaName],
				inchiKeyInformation
			];

			(* Attempt to get the MSDS Information. If we fail, that's okay - default to Null. *)
			msdsURL = Quiet[Check[
				(* Pull out the Product key from the Sigma website. *)
				sigmaID = StringTrim[
					First[
						FirstOrDefault[
							StringCases[
								First[sigmaWebsite],
								{
									"<strong itemprop=\"productKey\">"~~x:(DigitCharacter | WordCharacter | "-" | "_" | " ")..~~"</strong>" :> {x},
									Shortest["\"productKey\":\""~~x:__~~"\""] :> {x}
								}
							],
							""
						]
					]
				];

				(* Make a request to the Sigma MSDS searcher. *)
				(* DO NOT use the Emerald specific POST/GET functions here as they do not store the cookies. *)
				sigmaMSDSPage = Module[{productType},
					(* First extract the type of product from the URL. If it isnt found set to Null*)
					productType = FirstOrDefault[
						StringCases[url, "/product/" ~~ x : (WordCharacter ..) ~~ "/" :> x],
						Null
					];

					(* If we have a sigmaID and a productType, use these to get the MSDS URL. *)
					If[!MatchQ[productType, Null] && !MatchQ[sigmaID, Null],
						"https://www.sigmaaldrich.com/MSDS/MSDS/DisplayMSDSPage.do?country=US&language=en&productNumber="<>sigmaID<>"&brand="<>ToUpperCase[productType],
						Null
					]
				];

				(* Read from the MSDS page URL *)
				msdsBody = URLRead[
					HTTPRequest[
						sigmaMSDSPage,
						<|
							Method -> "GET",
							(* this is a header that we found can work to get a response for now, but just so people keep an eye sigma may block us at any time b/c we run unit tests and ping their website too often *)
							"Headers" -> {
								"accept-language" -> "en-US,en;q=0.9",
								"user-agent" -> "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Mobile Safari/537.36"
							}
						|>
					]
				]["Body"];

				(* 10/22/21 - The sigma website now directly returns the PDF from this request *)
				If[Length[StringCases[msdsBody, "PDF"]] > 0,
					(* If we have the PDF already, just return that for the msds URL *)
					sigmaMSDSPage,
					(* If we don't, default to the previous code *)
					(* Try and find the resolved MSDS ID from the page. Cookies are nesessary for this request, however, they are stored by using the URLRead[...] function. *)
					msdsID = FirstOrDefault@StringCases[msdsBody, "/MSDS/MSDS/PrintMSDSAction.do?name=msdspdf_"~~x:DigitCharacter.. :> x];

					If[!MatchQ[msdsID, _String],
						Null,
						(* Put together the potential MSDS URL. *)
						potentialMSDSURL = "https://www.sigmaaldrich.com/MSDS/MSDS/PrintMSDSAction.do?name=msdspdf_"<>msdsID;

						(* Download the body of the potential MSDS url. *)
						potentialMSDSBody = URLRead[
							HTTPRequest[
								potentialMSDSURL,
								<|
									Method -> "GET",
									(* this is a header that we found can work to get a response for now, but just so people keep an eye sigma may block us at any time b/c we run unit tests and ping their website too often *)
									"Headers" -> {
										"accept-language" -> "en-US,en;q=0.9",
										"user-agent" -> "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Mobile Safari/537.36"
									}
								|>
							]
						]["Body"];

						(* Check that the URL returned a PDF header. If so, it is good. If not, return Null. *)
						If[Length[StringCases[potentialMSDSBody, "PDF"]] > 0,
							potentialMSDSURL,
							Null
						]
					]
				],
				(* Return Null if we encounter an error. *)
				Null
			]];

			(* Append MSDSFile\[Rule]msdsURL and MSDSRequired\[Rule]True *)
			(* MSDSRequired\[Rule]True should always be set when using a product URL to parse a chemical. *)
			informationWithMSDS = If[!MatchQ[pubChemInformation, $Failed],
				Merge[{<|MSDSFile -> msdsURL, MSDSRequired -> True|>, pubChemInformation}, (First[ToList[#]]&)],
				(* If something happened, return $Failed. Otherwise the whole association remains unevualated. *)
				$Failed
			];

			(* If the name parsing succeeded, return our association with the new name. *)
			If[!SameQ[sigmaName, Null],
				(* The name parsing succeeded. Convert the association to a list so that we can replace the name. Then convert it back to an association. *)
				Module[{associationAsList, listWithName},
					(* Convert the association to a list. *)
					associationAsList = Normal[informationWithMSDS];

					(* Replace the name with our newly parsed name. *)
					listWithName = associationAsList /. (Name -> _) -> (Name -> sigmaName);

					(* Convert it back to an association *)
					Association @@ listWithName
				],
				(* The name parsing didn't succeed. Return the original name. *)
				informationWithMSDS
			],

			(* If something happened, return $Failed. Our high-level functions check for this. *)
			$Failed
		]
	];


	(* Only memoize if the result wasn't Null. This is because the ThermoFisher server can sometimes fail or *)
	(* lock us out if we're making too many requests. *)
	If[!SameQ[result, $Failed],
		parseSigmaURL[url]=result;
	];

	(* Return our result. *)
	result
];


(* ::Subsubsection::Closed:: *)
(* findSDS *)

DefineOptions[findSDS,
	Options :> {
		{Vendor -> All, Alternatives[All, ListableP[_String]], "Ordered list of preferred vendors to return SDS from. Matches vendor URL. Function will attempt to return an SDS in all cases, even if one can't be sourced from a listed Vendor."},
		{Manufacturer -> All, Alternatives[All, ListableP[_String]], "Ordered list of preferred manufacturer to return SDS from. Matches manufacturer name. Function will attempt to return an SDS in all cases, even if one can't be sourced from a listed manufacturer."},
		{Product -> All, Alternatives[All, ListableP[_String]], "A list of preferred product numbers to return the SDS for. Matches any part of SDS database entry. Function will attempt to return an SDS in all cases, even if one can't be sourced with the specified product identifier."},
		{Output -> Open, Alternatives[URL, ValidatedURL, TemporaryFile, Open, CloudFile], "The format to return the SDS in. URL returns the best URL. ValidatedURL returns the best URL that's confirmed to return a pdf. Temporary file downloads the pdf and returns the local file reference. Open opens the pdf. Cloud file uploads the pdf to constellation and returns the cloud file."}
	}
];

(* Pretty much every part of this function is memoized to reduce pinging of servers and reduce the chance we hit any rate limits *)
findSDS[myIdentifier: Alternatives[_String, CASNumberP], myOptions : OptionsPattern[findSDS]] := Module[
	{safeOptions, vendorOption, outputOption, productOption, manufacturerOption, sdsData, filteredSDSData, sortedSDSData, validatedURL, downloadedPDF},

	(* Parse the options *)
	safeOptions = SafeOptions[findSDS, ToList[myOptions]];
	{vendorOption, manufacturerOption, productOption, outputOption} = Lookup[safeOptions, {Vendor, Manufacturer, Product, Output}];

	(* Get a list of associations from Chemical Safety website, each detailing a link to an SDS *)
	sdsData = searchChemicalSafetySDS[myIdentifier];

	(* There are likely many entries in the table so filter down and sort *)

	(* Filter out data we don't want *)
	filteredSDSData = If[MatchQ[sdsData, {}],
		sdsData,
		Module[{gatheredByCAS, sortedByCASFrequency, filteredByCAS},

			(* Filter by CAS number. Redundant if the input was a CAS but helps figure out the most likely chemical if name was provided *)
			(* Gather the information by CAS number *)
			gatheredByCAS = GatherBy[sdsData, Lookup[#, "CAS"] &];

			(* Sort the data by frequency the CAS appeared *)
			sortedByCASFrequency = SortBy[gatheredByCAS, Length];

			(* Take the most frequent cas number found, unless it's blank. In that case, use the second most frequent if possible *)
			filteredByCAS = If[GreaterQ[Length[sortedByCASFrequency], 1] && MatchQ[Lookup[sortedByCASFrequency[[-1, 1]], "CAS"], ""],
				sortedByCASFrequency[[-2]],
				sortedByCASFrequency[[-1]]
			];

			(* Filter out anything with no URL *)
			Select[filteredByCAS, MatchQ[Lookup[#, "URL"], URLP] &]
		]
	];

	(* Now sort the data from best to worst *)
	sortedSDSData = Module[{defaultVendorPriority, defaultManufacturerPriority, manufacturerOrdering, vendorOrdering},

		(* Default scores we give to prioritize vendors *)
		(* These strings match the URL *)
		(* Sigma are good but their website is incredibly twitchy with rate limits - I hit one whilst opening links in my browser whilst developing this function *)
		defaultVendorPriority = {
			"sigmaaldrich" -> 1,
			"thermofisher" -> 4,
			"fishersci" -> 3
		};

		(* Default scores we give to prioritize manufacturers *)
		(* These match the manufacturer field in words *)
		(* Sigma are good but their website is incredibly twitchy with rate limits - I hit one whilst opening links in my browser whilst developing this function *)
		defaultManufacturerPriority = {
			"Sigma Aldrich" -> 3,
			"Sigma" -> 3,
			"Aldrich" -> 3,
			"Thermo Fisher" -> 4,
			"Fisher Scientific" -> 4,
			"Alfa Aesar" -> 2,
			"VWR" -> 2
		};

		(* Compute the manufacturer priority *)
		manufacturerOrdering = Module[{completePriorityList, sanitizedManufacturers},
			(* Add any user specified priorities to the top of the list *)
			completePriorityList = If[MatchQ[manufacturerOption, All],
				defaultManufacturerPriority,
				Join[
					(# -> 50) & /@ ToList[manufacturerOption], (* Weight strongly if we match manufacturer *)
					defaultManufacturerPriority
				]
			];

			(* Sanitize the values *)
			sanitizedManufacturers = DeleteDuplicates[(StringReplace[ToLowerCase[First[#]], Whitespace -> ""] -> Last[#]) & /@ completePriorityList];

			(* Return the ranking, higher is better *)
			sanitizedManufacturers
		];


		(* Compute the manufacturer priority *)
		vendorOrdering = Module[{completePriorityList, sanitizedVendors},
			(* Add any user specified priorities to the top of the list *)
			completePriorityList = If[MatchQ[vendorOption, All],
				defaultVendorPriority,
				Join[
					(# -> 50) & /@ ToList[vendorOption],  (* Weight strongly if we match vendor *)
					defaultVendorPriority
				]
			];

			(* Sanitize the values *)
			sanitizedVendors = DeleteDuplicates[(StringReplace[ToLowerCase[First[#]], Whitespace -> ""] -> Last[#]) & /@ completePriorityList];

			(* Return the ranking, higher is better *)
			sanitizedVendors
		];

		(* No default prioritization for product numbers *)

		(* Sort the data *)
		ReverseSortBy[
			filteredSDSData,

			(* Compute a simple integer that represents the ordering priority of the entry *)
			Module[{url, manufacturer, productPriority, manufacturerPriority, vendorPriority},

				{url, manufacturer} = Lookup[#, {"URL", "Manufacturer"}];

				(* Compute the priority of the product matching. Just a binary True/False if the URL contains the product identifiers *)
				productPriority = If[MatchQ[productOption, All],
					(* No priority if no product specified *)
					0,

					(* Otherwise check if the url contains the product ID. Weight overwhelmingly if we find a match *)
					StringContainsQ[
						url,
						(* Compare in lower case and remove spaces *)
						Alternatives @@ StringReplace[ToLowerCase[ToList[productOption]], Whitespace -> ""],
						IgnoreCase -> True
					] /. {True -> 100, False -> 0}
				];

				(* Now deduce the manufacturer for this entry *)
				(* For every match, StringCases will return the priority number associated with it. Max will then either return the max priority found, or 0 if none found *)
				manufacturerPriority = Max[{
					0,
					StringCases[
						StringReplace[ToLowerCase[manufacturer], Whitespace -> ""],
						manufacturerOrdering,
						IgnoreCase -> True,
						Overlaps -> All
					]
				}];

				(* Now deduce the vendor priority for this entry *)
				(* For every match, StringCases will return the priority number associated with it. Max will then either return the max priority found, or 0 if none found *)
				vendorPriority = Max[{
					0,
					StringCases[
						StringReplace[ToLowerCase[url], Whitespace -> ""],
						vendorOrdering,
						IgnoreCase -> True,
						Overlaps -> All
					]
				}];

				(* Add up all the priority weightings *)
				Total[
					{
						productPriority,
						vendorPriority,
						manufacturerPriority
					}
				]
			]&
		]
	];

	(* Return the requested output *)

	(* Return early if we just want a URL without contacting the server and validating *)
	If[MatchQ[outputOption, URL],
		Return[First[Lookup[sortedSDSData, "URL", {}], Null]]
	];

	(* In all other cases, first download the contents of the URL to make sure it's a real pdf *)
	{validatedURL, downloadedPDF} = Module[
		{scanResult},

		(* Scan over all of the potential SDS in order and exit as soon as one works *)
		scanResult = Scan[
			Module[{url, downloadResult},

				url = Lookup[#, "URL"];

				(* Try and import the PDF, and check if the result is valid *)
				(* Returns either the valid File or $Failed. Function memoizes *)
				downloadResult = downloadAndValidateSDSURL[url];

				(* If the pdf is valid, return early and break the loop *)
				If[MatchQ[downloadResult, _File],
					Return[{url, downloadResult}]
				]
			] &,
			sortedSDSData
		];

		If[MatchQ[scanResult, {URLP, _File}],
			scanResult,
			{Null, Null}
		]
	];

	(* Return the output *)
	Which[
		(* Return the URL that we checked works *)
		MatchQ[outputOption, ValidatedURL],
		validatedURL,

		(* Return the path to the downloaded pdf *)
		MatchQ[outputOption, TemporaryFile],
		downloadedPDF,

		(* If user wants to open the SDS, use SystemOpen if we have one *)
		MatchQ[outputOption, Open] && !MatchQ[downloadedPDF, Null],
		SystemOpen[downloadedPDF],

		(* Otherwise return Null if we didn't have an SDS *)
		MatchQ[outputOption, Open],
		Null,

		(* If the user wants a cloud file, upload the pdf and return the cloud file *)
		MatchQ[outputOption, CloudFile],
		UploadCloudFile[downloadedPDF],

		(* Fall back - we shouldn't get here. Return both *)
		True,
		{validatedURL, downloadedPDF}
	]
];



(* Internal memoized function to perform an SDS search request with Chemical Safety website *)
searchChemicalSafetySDS[myIdentifier: Alternatives[_String, CASNumberP]] := Module[
	{casNumberQ, httpRequest, httpResponse, parsedData},

	(* Determine if the input is a cas number or not *)
	casNumberQ = MatchQ[myIdentifier, CASNumberP];

	(* Assemble the http request for ChemicalSafety.com *)
	httpRequest = Module[{searchCriteria},

		(* List of parameters to search by - we'll search by name or by cas *)
		searchCriteria = If[casNumberQ,
			{"cas|" <> myIdentifier},
			{"name|" <> myIdentifier}
		];

		<|
			"URL" -> "https://chemicalsafety.com/sds1/sds_retriever.php?action=search",
			"Headers" -> Association[
				"ContentType" -> "application/json"
			],
			"Method" -> "POST",
			"Body" -> <|
				"IsContains" -> False,
				"IncludeSynonyms" -> False,
				"SearchSdsServer" -> False,
				"HostName" -> "sfs website",
				"Remote" -> "209.105.189.138",
				"Bee" -> "stevia",
				"Action" -> "search",
				"Criteria" -> searchCriteria
			|>
		|>
	];

	(* Perform the request *)
	httpResponse = HTTPRequestJSON[httpRequest];

	(* Return $Failed if not successful *)
	If[!MatchQ[httpResponse, _Association],
		Return[$Failed]
	];

	(* Parse the response *)
	parsedData = Module[
		{columnNames, rowData, associationData},

		(* Lookup and sanitize the column names *)
		columnNames = Lookup[Lookup[httpResponse, "cols"], "prompt"] /. <|
			"MANUFACTURER" -> "Manufacturer",
			"HTTP REF" -> "URL"
		|>;

		rowData = Lookup[httpResponse, "rows"];

		(* Convert each entry into an association *)
		associationData = Map[
			AssociationThread[columnNames -> #] &,
			rowData
		];

		(* Drop keys we don't want *)
		KeyDrop[associationData, {"HASMSDS", "HPHRASES_IDS", "SDSSERVER"}]
	];

	(* Memoize result if successful *)
	If[MatchQ[parsedData, {_Association...}],
		(
			If[!MemberQ[$Memoization, ExternalUpload`Private`searchChemicalSafetySDS],
				AppendTo[$Memoization, ExternalUpload`Private`searchChemicalSafetySDS]
			];
			Set[searchChemicalSafetySDS[myIdentifier], parsedData]
		)
	];

	(* Return the data *)
	parsedData
];


(* ::Subsubsection::Closed:: *)
(* File/CloudFile Handling *)


(* Internal memoized function to perform HTTPRequest when validating URLs *)
downloadAndValidateURL[url_String, fileNameIdentifier : _String, fileValidationFunction : _Function] := Module[
	{filePath, downloadedFile, validFileQ, returnValue},

	(* Location to (attempt to) download file to *)
	filePath = Module[
		{splitFileName, fileNameIdentifierStem, fileNameIdentifierExtension},

		(* Split off the extension from the file name *)
		splitFileName = StringSplit[fileNameIdentifier, "."];

		(* Parse out the extension from the rest of the name *)
		{fileNameIdentifierStem, fileNameIdentifierExtension} = If[EqualQ[Length[splitFileName], 1],
			{First[splitFileName], ""},
			{StringRiffle[Most[splitFileName], "."], Last[splitFileName]}
		];

		(* Assemble the file name *)
		FileNameJoin[{$TemporaryDirectory, ToString[Unique[fileNameIdentifierStem]] <> "." <> fileNameIdentifierExtension}]
	];

	(* Attempt to download the file *)
	downloadedFile = URLDownload[
		HTTPRequest[url,
			<|
				Method -> "GET",
				"Headers" -> {
					"accept-language" -> "en-US,en;q=0.9",
					"user-agent" -> "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Mobile Safari/537.36"
				}
			|>
		],
		filePath,
		TimeConstraint -> 3
	];

	(* Check if we got something *)
	validFileQ = Quiet[Check[
		TrueQ[fileValidationFunction[downloadedFile]],
		False
	]];

	(* We'll return either the file or $Failed *)
	returnValue = If[validFileQ,
		downloadedFile,
		$Failed
	];

	(* Memoize the result - even if failed *)
	If[!MemberQ[$Memoization, ExternalUpload`Private`downloadAndValidateURL],
		AppendTo[$Memoization, ExternalUpload`Private`downloadAndValidateURL]
	];
	Set[downloadAndValidateURL[url, fileNameIdentifier, fileValidationFunction], returnValue];

	(* Return the result *)
	returnValue
];

(* Handy wrappers to prevent divergence when called from multiple places and ensure we hit memoization *)
(* SDS *)
downloadAndValidateSDSURL[url : URLP] := downloadAndValidateURL[
	url,
	"sds.pdf",
	And[
		(* First check the file format - FileFormat isn't outfoxed by incorrect extensions- we may have downloaded HTML to a .pdf filename but this will show it's still HTML *)
		MatchQ[FileFormat[#], "PDF"],

		(* If the file truly appears to be PDF format, import it and check we can read some text *)
		Quiet[Check[
			StringContainsQ[Import[#, "Plaintext"], Alternatives["safety data sheet", CaseSensitive["CAS"], CaseSensitive["GHS"]], IgnoreCase -> True],
			False
		]]
	]&
];

(* Structure Image File *)
downloadAndValidateStructureImageFileURL[url : URLP] := downloadAndValidateURL[
	url,
	"structureimage.png",
	(* Check that we get an image when we import the file *)
	ImageQ[Import[#]]&
];

(* Structure File *)
downloadAndValidateStructureFileURL[url : URLP] := downloadAndValidateURL[
	url,
	"structure.sdf",
	(* Check that we get a valid molecule when we import the structure file *)
	MatchQ[Import[#], {_Molecule..}]&
];


(* Internal memoized function for validating local files *)
validateLocalFile[filePath : FilePathP, fileValidationFunction : _Function] := Module[
	{validFileQ, returnValue},

	(* Validate the file using the supplied function *)
	validFileQ = Quiet[Check[
		TrueQ[fileValidationFunction[filePath]],
		False
	]];

	(* We'll return either the file or $Failed *)
	returnValue = If[validFileQ,
		File[filePath],
		$Failed
	];

	(* Memoize the result - even if failed *)
	If[!MemberQ[$Memoization, ExternalUpload`Private`validateLocalFile],
		AppendTo[$Memoization, ExternalUpload`Private`validateLocalFile]
	];
	Set[validateLocalFile[filePath, fileValidationFunction], returnValue];

	(* Return the result *)
	returnValue
];

(* Handy wrappers to prevent divergence when called from multiple places and ensure we hit memoization *)
(* Structure File *)
validateStructureFilePath[filePath : FilePathP] := validateLocalFile[
	filePath,
	MatchQ[Import[#], {_Molecule..}] &
];

(* Structure Image File *)
validateStructureImageFilePath[filePath : FilePathP] := validateLocalFile[
	filePath,
	ImageQ[Import[#]] &
];


(* Helper for uploading a file to AWS and returning constellation cloud file packet. Memoized to prevent re-uploading *)
pathToCloudFilePacket[file : Alternatives[FilePathP, _File]] := (pathToCloudFilePacket[file] = Module[
	{},

	(* Register memoization *)
	If[!MemberQ[$Memoization, ExternalUpload`Private`pathToCloudFilePacket],
		AppendTo[$Memoization, ExternalUpload`Private`pathToCloudFilePacket]
	];

	(* Upload the file to AWS and return the un-uploaded constellation packet *)
	UploadCloudFile[file, Upload -> False]
]);


(* ::Subsection::Closed:: *)
(*Shared Option Sets*)


(* ::Subsubsection::Closed:: *)
(*IdentityModelHealthAndSafetyOptions*)


DefineOptionSet[
	IdentityModelHealthAndSafetyOptions :>
		{
			IndexMatching[
				IndexMatchingInput -> "Input Data",
				{
					OptionName -> Radioactive,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if pure samples of this molecule emit substantial ionizing radiation.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> Ventilated,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if pure samples of this molecule must be handled in a ventilated enclosures.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> Pungent,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if pure samples of this molecule must be handled in a ventilated enclosures.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> Flammable,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if pure samples of this molecule are easily set aflame under standard conditions.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> Acid,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if pure samples of this molecule are strong acids (pH <= 2) and require dedicated secondary containment during storage.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> Base,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if pure samples of this molecule are strong bases (pH >= 12) and require dedicated secondary containment during storage.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> Pyrophoric,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if pure samples of this molecule can ignite spontaneously upon exposure to air.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> WaterReactive,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if pure samples of this molecule react spontaneously upon exposure to water.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> Fuming,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if pure samples of this molecule emit fumes spontaneously when exposed to air.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> HazardousBan,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if pure samples of this molecule are currently banned from usage in the ECL because the facility isn't yet equiped to handle them.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> ExpirationHazard,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if pure samples of this molecule become hazardous once they are expired and must be automatically disposed of when they pass their expiration date.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> ParticularlyHazardousSubstance,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if exposure to this substance has the potential to cause serious and lasting harm. A substance is considered particularly harmful if it is categorized by any of the following GHS classifications (as found on a MSDS): Reproductive Toxicity (H340, H360, H362),  Acute Toxicity (H300, H310, H330, H370, H373), Carcinogenicity (H350).",
					Category -> "Health & Safety"
				},
				{
					OptionName -> DrainDisposal,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if pure samples of this molecule may be safely disposed down a standard drain.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> MSDSRequired,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if an MSDS is applicable for this model.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> MSDSFile,
					Default -> Null,
					AllowNull -> True,
					Widget -> Alternatives[
						Widget[Type -> String, Pattern :> URLP, Size -> Line],
						Widget[Type -> Object, Pattern :> ObjectP[Object[EmeraldCloudFile]], PatternTooltip -> "A cloud file stored on Constellation that ends in .PDF."]
					],
					Description -> "URL of the MSDS (Materials Safety Data Sheet) PDF file.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> NFPA,
					Default -> Null,
					AllowNull -> True,
					Widget -> {
						"Health" -> Widget[Type -> Enumeration, Pattern :> 0 | 1 | 2 | 3 | 4],
						"Flammability" -> Widget[Type -> Enumeration, Pattern :> 0 | 1 | 2 | 3 | 4],
						"Reactivity" -> Widget[Type -> Enumeration, Pattern :> 0 | 1 | 2 | 3 | 4],
						"Special" -> Alternatives[
							Widget[
								Type -> MultiSelect,
								Pattern :> DuplicateFreeListableP[Oxidizer | WaterReactive | Aspyxiant | Corrosive | Acid | Bio | Poisonous | Radioactive | Cryogenic | Null]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[{}]
							]
						]
					},
					Description -> "The National Fire Protection Association (NFPA) 704 hazard diamond classification for the substance.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> DOTHazardClass,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> DOTHazardClassP],
					Description -> "The Department of Transportation hazard classification of the substance.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> BiosafetyLevel,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BiosafetyLevelP],
					Description -> "The Biosafety classification of the substance.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> DoubleGloveRequired,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if working with this substance required wearing two pairs of gloves.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> LightSensitive,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Determines if the sample reacts or degrades in the presence of light and should be stored in the dark to avoid exposure.",
					Category -> "Storage Information"
				},

				{
					OptionName -> IncompatibleMaterials,
					Default -> Null,
					AllowNull -> True,
					Widget -> With[{insertMe=Flatten[None | MaterialP]}, Adder[Widget[Type -> Enumeration, Pattern :> insertMe]]],
					Description -> "A list of materials that would be damaged if wetted by this model.",
					Category -> "Compatibility"
				},
				{
					OptionName -> LiquidHandlerIncompatible,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if pure samples of this molecule cannot be reliably aspirated or dispensed on an automated liquid handling robot.",
					Category -> "Compatibility"
				},
				{
					OptionName -> PipettingMethod,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Method, Pipetting]]],
					Description -> "The pipetting parameters used to manipulate pure samples of this model.",
					Category -> "Compatibility"
				},
				{
					OptionName -> UltrasonicIncompatible,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if pure samples of this molecule cannot be performed via the ultrasonic distance method due to vapors interfering with the reading.",
					Category -> "Compatibility"
				}
			]
		}
];


(* ::Subsubsection::Closed:: *)
(*ModelSampleHealthAndSafetyOptions*)


DefineOptionSet[
	ModelSampleHealthAndSafetyOptions :>
		{
			IndexMatching[
				IndexMatchingInput -> "Input Data",
				{
					OptionName -> State,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Solid, Liquid, Gas]],
					Description -> "The physical state of the sample when well solvated at room temperature and pressure.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> SampleHandling,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> SampleHandlingP],
					Description -> "The method by which this sample should be manipulated in the lab when transfers out of the sample are requested.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> CellType,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> CellTypeP],
					Description -> "The primary types of cells that are contained within this sample.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> CultureAdhesion,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> CultureAdhesionP],
					Description -> "The default type of cell culture (adherent or suspension) that should be performed when growing these cells. If a cell line can be cultured via an adherent or suspension culture, this is set to the most common cell culture type for the cell line.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> Sterile,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates that this model of sample arrives free of both microbial contamination and any microbial cell samples from the manufacturer, or is prepared free of both microbial contamination and any microbial cell samples by employing autoclaving, sterile filtration, or mixing exclusively sterile components with aseptic techniques during the course of experiments, as well as during sample storage and handling.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> AsepticHandling,
					Default -> Null,
					Description -> "Indicates if aseptic techniques are expected for handling this model of sample. Aseptic techniques include sanitization, autoclaving, sterile filtration, mixing exclusively sterile components, and transferring in a biosafety cabinet during experimentation and storage.",
					AllowNull -> True,
					Category -> "Health & Safety",
					Widget -> Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					]
				},
				{
					OptionName -> DefaultStorageCondition,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[StorageCondition]]],
					Description -> "The condition in which samples of this model are stored when not in use by an experiment; this condition may be overridden by the specific storage condition of any given sample.",
					Category -> "Storage Information"
				},
				{
					OptionName -> Expires,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if samples of this model expire after a given amount of time.",
					Category -> "Storage Information"
				},
				{
					OptionName -> ShelfLife,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 * Day], Units -> {1, {Day, {Day, Month, Year}}}],
					Description -> "The length of time after DateCreated that samples of this model are recommended for use before they should be discarded.",
					Category -> "Storage Information"
				},
				{
					OptionName -> UnsealedShelfLife,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 * Day], Units -> {1, {Day, {Day, Month, Year}}}],
					Description -> "The length of time after DateUnsealed that samples of this model are recommended for use before they should be discarded.",
					Category -> "Storage Information"
				},
				{
					OptionName -> TransportTemperature,
					Default -> Null,
					Description -> "The temperature that samples of this model should be incubated at while transported between instruments during experimentation.",
					AllowNull -> True,
					Category -> "Storage Information",
					Widget -> Widget[
						Type -> Quantity,
						Pattern :> Alternatives[RangeP[-86*Celsius, 10*Celsius], RangeP[30*Celsius, 105*Celsius]],
						Units -> Celsius
					]
				},
				{
					OptionName -> Anhydrous,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if this sample does not contain water.",
					Category -> "Health & Safety"
				}
			],
			IdentityModelHealthAndSafetyOptions
		}
];


(* ::Subsubsection::Closed:: *)
(*ObjectSampleHealthAndSafetyOptions*)


DefineOptionSet[
	ObjectSampleHealthAndSafetyOptions :>
		{
			IndexMatching[
				IndexMatchingInput -> "Input Data",
				{
					OptionName -> State,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Solid, Liquid, Gas]],
					Description -> "The physical state of the sample when well solvated at room temperature and pressure.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> SampleHandling,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> SampleHandlingP],
					Description -> "The method by which this sample should be manipulated in the lab when transfers out of the sample are requested.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> CellType,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> CellTypeP],
					Description -> "The primary types of cells that are contained within this sample.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> CultureAdhesion,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> CultureAdhesionP],
					Description -> "The type of cell culture that is currently being performed to grow these cells.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> Sterile,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates that this sample arrives free of both microbial contamination and any microbial cell samples from the manufacturer, or is prepared free of both microbial contamination and any microbial cell samples by employing autoclaving, sterile filtration, or mixing exclusively sterile components with aseptic techniques during experimentation and storage.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> StorageCondition,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[StorageCondition]], OpenPaths -> {{Object[Catalog, "Root"], "Storage Conditions"}}],
					Description -> "The condition in which this sample gets stored in when not used by an experiment.",
					Category -> "Storage Information"
				},
				{
					OptionName -> Expires,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if samples of this model expire after a given amount of time.",
					Category -> "Storage Information"
				},
				{
					OptionName -> ShelfLife,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 * Day], Units -> {1, {Day, {Day, Month, Year}}}],
					Description -> "The length of time after DateCreated that samples of this model are recommended for use before they should be discarded.",
					Category -> "Storage Information"
				},
				{
					OptionName -> UnsealedShelfLife,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 * Day], Units -> {1, {Day, {Day, Month, Year}}}],
					Description -> "The length of time after DateUnsealed that samples of this model are recommended for use before they should be discarded.",
					Category -> "Storage Information"
				},
				{
					OptionName -> TransportTemperature,
					Default -> Null,
					Description -> "The temperature that this sample should be heated or refrigerated while transported between instruments during experimentation.",
					AllowNull -> True,
					Category -> "Storage Information",
					Widget -> Widget[
						Type->Quantity,
						Pattern:>Alternatives[RangeP[-86*Celsius, 10*Celsius], RangeP[30*Celsius, 105*Celsius]],
						Units -> {1, {Celsius, {Celsius, Fahrenheit, Kelvin}}}
					]
				},
				{
					OptionName -> TransferTemperature,
					Default -> Null,
					Description -> "The temperature that this sample should be at before any transfers using this sample occur.",
					AllowNull -> True,
					Category -> "Storage Information",
					Widget -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[4 Celsius, 90 Celsius],
						Units -> Celsius
					]
				},
				{
					OptionName -> Anhydrous,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if this sample does not contain water.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> ExpirationDate,
					Default -> Null,
					Description -> "Date after which this sample is considered expired and users will be warned about using it in protocols.",
					AllowNull -> True,
					Category -> "Health & Safety",
					Widget -> Widget[
						Type -> Date,
						Pattern :> _?DateObjectQ,
						TimeSelector -> True
					]
				},
				{
					OptionName -> AutoclaveUnsafe,
					Default -> Null,
					Description -> "Indicates if this sample cannot be safely autoclaved.",
					AllowNull -> True,
					Category -> "Health & Safety",
					Widget -> Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					]
				},
				{
					OptionName -> InertHandling,
					Default -> Null,
					Description -> "Indicates if this sample must be handled in a glove box.",
					AllowNull -> True,
					Category -> "Health & Safety",
					Widget -> Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					]
				},
				{
					OptionName -> AsepticHandling,
					Default -> Null,
					Description -> "Indicates if aseptic techniques are followed for this sample. Aseptic techniques include sanitization, autoclaving, sterile filtration, mixing exclusively sterile components, and transferring in a biosafety cabinet during experimentation and storage.",
					AllowNull -> True,
					Category -> "Health & Safety",
					Widget -> Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					]
				},
				{
					OptionName -> GloveBoxIncompatible,
					Default -> Null,
					Description -> "Indicates if this sample cannot be used inside of the glove box due high volatility and/or detrimental reactivity with the catalyst in the glove box that is used to remove traces of water and oxygen. Sulfur and sulfur compounds (such as H2S, RSH, COS, SO2, SO3), halides, halogen (Freon), alcohols, hydrazine, phosphene, arsine, arsenate, mercury, and saturation with water may deactivate the catalyst.",
					AllowNull -> True,
					Category -> "Compatibility",
					Widget -> Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					]
				},
				{
					OptionName -> GloveBoxBlowerIncompatible,
					Default -> Null,
					Description -> "Indicates that the glove box blower must be turned off to prevent damage to the catalyst in the glove box that is used to remove traces of water and oxygen, when manipulating this sample inside of the glove box.",
					AllowNull -> True,
					Category -> "Compatibility",
					Widget -> Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					]
				},
				{
					OptionName -> RNaseFree,
					Default -> Null,
					Description -> "Indicates that this sample is free of any RNases.",
					AllowNull -> True,
					Category -> "Health & Safety",
					Widget -> Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					]
				},
				{
					OptionName -> NucleicAcidFree,
					Default -> Null,
					Description -> "Indicates if this sample is presently considered to be not contaminated with DNA and RNA.",
					AllowNull -> True,
					Category -> "Health & Safety",
					Widget -> Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					]
				},
				{
					OptionName -> PyrogenFree,
					Default -> Null,
					Description -> "Indicates if this sample is presently considered to be not contaminated with endotoxin.",
					AllowNull -> True,
					Category -> "Health & Safety",
					Widget -> Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					]
				},
				{
					OptionName -> AsepticTransportContainerType,
					Default -> Null,
					Description -> "Indicates how this sample is contained in an aseptic barrier and if it needs to be unbagged before being used in a protocol, maintenance, or qualification.",
					AllowNull -> True,
					Category -> "Storage Information",
					Widget -> Widget[
						Type -> Enumeration,
						Pattern :> AsepticTransportContainerTypeP
					]
				}
			],
			IdentityModelHealthAndSafetyOptions
		}
];


(* ::Subsubsection::Closed:: *)
(*ExternalUploadHiddenOptions*)


DefineOptionSet[
	ExternalUploadHiddenOptions :>
		{
			IndexMatching[
				IndexMatchingInput -> "Input Data",
				{
					OptionName -> Cache,
					Default -> {},
					AllowNull -> False,
					Widget -> Widget[Type -> Expression, Pattern :> _List, Size -> Line],
					Description -> "The download cache.",
					Category -> "Hidden"
				},
				{
					OptionName -> Upload,
					Default -> True,
					AllowNull -> False,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if the database changes resulting from this function should be made immediately or if upload packets should be returned.",
					Category -> "Hidden"
				},
				{
					OptionName -> Output,
					Default -> Result,
					AllowNull -> True,
					Widget -> Alternatives[
						Widget[Type -> Enumeration, Pattern :> CommandBuilderOutputP],
						Adder[Widget[Type -> Enumeration, Pattern :> CommandBuilderOutputP]]
					],
					Description -> "Indicate what the function should return.",
					Category -> "Hidden"
				}
			]
		}
];


(* ::Subsubsection::Closed:: *)
(*CellOptions*)


DefineOptionSet[
	CellOptions :>
		{
			IndexMatching[
				IndexMatchingInput -> "Input Data",
				{
					OptionName -> CellType,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> CellTypeP],
					Description -> "The primary types of cells that are contained within this sample.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> CultureAdhesion,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> CultureAdhesionP],
					Description -> "The default type of cell culture (adherent or suspension) that should be performed when growing these cells. If a cell line can be cultured via an adherent or suspension culture, this is set to the most common cell culture type for the cell line.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> Name,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line],
					Description -> "The name of the identity model.",
					Category -> "Organizational Information"
				},
				{
					OptionName -> DefaultSampleModel,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Sample]]],
					Description -> "Specifies the model of sample that will be used if this model is specified to be used in an experiment.",
					Category -> "Organizational Information"
				},
				{
					OptionName -> Synonyms,
					Default -> Null,
					AllowNull -> True,
					Widget -> Adder[Widget[Type -> String, Pattern :> _String, Size -> Word]],
					Description -> "List of possible alternative names this model goes by.",
					Category -> "Organizational Information"
				},
				{
					OptionName -> ATCCID,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> String, Pattern :> _String, Size -> Word],
					Description -> "The American Type Culture Collection (ATCC) identifying number of this cell line.",
					Category -> "Organizational Information"
				},
				{
					OptionName -> Species,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Species]]],
					Description -> "The species that this cell was originally cultivated from.",
					Category -> "Organizational Information"
				},

				{
					OptionName -> Diameter,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 * Micro * Meter], Units -> (Micro * Meter)],
					Description -> "The average diameter of an individual cell.",
					Category -> "Organizational Information"
				},
				{
					OptionName -> DoublingTime,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 * Hour], Units -> {1, {Hour, {Day, Hour, Minute}}}],
					Description -> "The average period of time it takes for a population of these cells to double in number during their exponential growth phase in its preferred media.",
					Category -> "Organizational Information"
				},
				{
					OptionName -> Viruses,
					Default -> Null,
					AllowNull -> True,
					Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Virus]]]],
					Description -> "Viruses that are known to be carried by this cell line.",
					Category -> "Organizational Information"
				},
				{
					OptionName -> cDNAs,
					Default -> Null,
					AllowNull -> True,
					Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Molecule, cDNA]]]],
					Description -> "The cDNA models that this cell line produces.",
					Category -> "Organizational Information"
				},
				{
					OptionName -> Transcripts,
					Default -> Null,
					AllowNull -> True,
					Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Molecule, Transcript]]]],
					Description -> "The transcript models that this cell line produces.",
					Category -> "Organizational Information"
				},
				{
					OptionName -> Lysates,
					Default -> Null,
					AllowNull -> True,
					Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Lysate]]]],
					Description -> "The model of the contents of this cell when lysed.",
					Category -> "Organizational Information"
				},
				{
					OptionName -> PreferredLiquidMedia,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Sample,Media]]],
					Description -> "The recommended liquid media for the growth of the cells.",
					Category -> "General"
				},
				{
					OptionName -> PreferredSolidMedia,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Sample,Media]]],
					Description -> "The recommended solid media for the growth of the cells.",
					Category -> "General"
				},
				{
					OptionName -> PreferredFreezingMedia,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Sample]]],
					Description -> "The recommended media for cryopreservation of these cells, often containing additives that protect the cells during freezing.",
					Category -> "General"
				},
				{
					OptionName -> ThawCellsMethod,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[Object[Method, ThawCells]]],
					Description -> "The default method by which to thaw cryovials of this cell line.",
					Category -> "General"
				},
				{
					OptionName -> DetectionLabels,
					Default -> Null,
					AllowNull -> True,
					Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Molecule]]]],
					Description -> "Indicate the tags (e.g. GFP, Alexa Fluor 488) that the cell contains, which can indicate the presence and amount of particular features or molecules in the cell. Allowed Model[Molecule] as DetectionLabels must have DetectionLabel->True.",
					Category -> "Physical Properties"
				},
				{
					OptionName -> PreferredColonyHandlerHeadCassettes,
					Default -> Null,
					AllowNull -> True,
					Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Part,ColonyHandlerHeadCassette]]]],
					Description -> "The ColonyHandlerHeadCassettes that are designed to pick this cell type from a solid gel.",
					Category -> "General"
				},
				{
					OptionName -> FluorescentExcitationWavelength,
					Default -> Null,
					AllowNull -> True,
					Widget -> {
						"Minimum Wavelength" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Nanometer], Units -> Nanometer],
						"Maximum Wavelength" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Nanometer], Units -> Nanometer]
					},
					Description -> "The range of wavelengths that causes the cell to be in an excited state.",
					Category -> "General"
				},
				{
					OptionName -> FluorescentEmissionWavelength,
					Default -> Null,
					AllowNull -> True,
					Widget -> {
						"Minimum Wavelength" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Nanometer], Units -> Nanometer],
						"Maximum Wavelength" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Nanometer], Units -> Nanometer]
					},
					Description -> "The detectable range of wavelengths this cell will emit through fluorescence after being put into an excited state.",
					Category -> "General"
				},
				{
					OptionName -> StandardCurves,
					Default -> Null,
					AllowNull -> True,
					Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Object[Analysis,StandardCurve]]]],
					Description -> "The standard curves used to convert between a combination of cell concentration units, Cell/Milliliter, OD600, CFU/Milliliter, RelativeNephelometricUnit, NephelometricTurbidityUnit, FormazinTurbidityUnit, and FormazinNephelometricUnit. If there exist multiple standard curves between the same units, the more recently generated curve will be used in calculations.",
					Category -> "General"
				},
				{
					OptionName -> StandardCurveProtocols,
					Default -> Null,
					AllowNull -> True,
					Widget -> Adder[Alternatives[Widget[Type -> Object, Pattern :> ObjectP[{Object[Protocol,Nephelometry], Object[Protocol,AbsorbanceIntensity]}]],Widget[Type -> Expression, Pattern :> Null, Size -> Line]]],
					Description -> "The protocol that generated the data used to determine the standard curve.",
					Category -> "General"
				}
			],

			IdentityModelHealthAndSafetyOptions,

			IndexMatching[
				IndexMatchingInput -> "Input Data",
				(* Overwrite some of the safety options with different defaults. *)
				{
					OptionName -> State,
					Default -> Liquid,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Solid, Liquid, Gas]],
					Description -> "The physical state of the sample when well solvated at room temperature and pressure.",
					Category -> "Physical Properties"
				},
				{
					OptionName -> MSDSRequired,
					Default -> True,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if an MSDS is applicable for this model.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> Flammable,
					Default -> False,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if pure samples of this molecule are easily set aflame under standard conditions.",
					Category -> "Health & Safety"
				},

				{
					OptionName -> ReferenceImages,
					Default -> Null,
					AllowNull -> True,
					Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Object[Data]]]],
					Description -> "Reference microscope images exemplifying the typical appearance of this cell line.",
					Category -> "Experimental Results"
				}
			],

			ExternalUploadHiddenOptions
		}
];


(* ::Subsection::Closed:: *)
(*API Helpers*)


(* ::Subsubsection::Closed:: *)
(*retryConnection*)


Warning::APIConnection="A connection to the scraping API was not able to be formed. Please try re-running this function again and check your firewall settings or any input URLs (if applicable).";

(* Given a command, retries numberOfRetries times if it gets $Failed. *)
retryConnection[command_, numberOfRetries_Integer]:=Module[{i, commandResult},
	(* Keep retrying our command until we get a non $Failed result. *)
	(* Sorry functional programming gods. *)
	For[i=1, i <= numberOfRetries, i++,
		commandResult=Evaluate[command];

		If[!SameQ[commandResult, $Failed],
			Return[commandResult];
		];

		Pause[2^i];
	];

	(* We tried multiple times but get $Failed every time. Return $Failed. *)
	Message[Warning::APIConnection];
	$Failed
];

SetAttributes[retryConnection, HoldAll];


(* ::Subsubsection::Closed:: *)
(*resolveTemplateOptions*)


DefineOptions[resolveTemplateOptions,
	Options :> {
		{Exclude -> {}, {(_Symbol)..}, "List of option names that should not be replaced with values from the template."}
	}
];


resolveTemplateOptions[
	funcName:_Symbol,
	tempObj:Null,
	userOps_List,
	safeOps_List,
	ops:OptionsPattern[resolveTemplateOptions]
]:=safeOps;
(* Emergency Demo-related Fix. To be compressed later *)
resolveTemplateOptions[
	UploadSampleModel,
	tempObj:PacketP[],
	userOps_List,
	safeOps_List,
	ops:OptionsPattern[resolveTemplateOptions]
]:=Module[
	{listedOps, nonReusableFields, userOpsSpecified, defaultedOps, templateDefaultedRules,
		rulesReplaceEmptyLists, rulesWithoutEmptyList, replacedFormsSafeOps, replacedSafeOps, opsWithpKa, opsWithNFPA, finalizedOptions},

	(* Make sure we are dealing with lists of options *)
	listedOps=ToList[ops];

	(* A list of fields that should never be taken as*)
	nonReusableFields=OptionDefault[OptionValue[Exclude]];

	(* Determine which options the user specified *)
	userOpsSpecified=First /@ ToList[userOps];

	(* Determine which ops to pull from the template *)
	defaultedOps=DeleteCases[
		First /@ ToList[safeOps],
		Alternatives @@ Join[userOpsSpecified, ToList[nonReusableFields]]
	];

	(* Create a list of rules where defaulted options pull their value from the template object *)
	templateDefaultedRules=ReplaceAll[
		(# -> Lookup[tempObj, #])& /@ defaultedOps,
		xLink:LinkP[] :> Most[xLink](* Trim the IDs from any links discovered *)
	];

	(* Replace the multiple fields that get {} from the object with Null values instead *)
	rulesReplaceEmptyLists=If[
		MatchQ[Lookup[templateDefaultedRules, #], {}],
		# -> Null,
		# -> Lookup[templateDefaultedRules, #]
	]& /@ {
		AlternativeForms,
		pKa,
		PreferredMALDIMatrix,
		IncompatibleMaterials
	};

	rulesWithoutEmptyList=ReplaceRule[
		templateDefaultedRules,
		rulesReplaceEmptyLists
	];

	replacedFormsSafeOps=If[
		MatchQ[
			Lookup[rulesWithoutEmptyList, AlternativeForms],
			{ObjectP[Model[Sample]]..}
		],
		ReplaceRule[
			rulesWithoutEmptyList,
			AlternativeForms -> Append[
				Lookup[rulesWithoutEmptyList, AlternativeForms],
				Link[tempObj, AlternativeForms]
			]
		],
		ReplaceRule[
			rulesWithoutEmptyList,
			AlternativeForms -> {Link[tempObj, AlternativeForms]}
		]
	];

	(* pKa needs to be de-listed. *)
	opsWithpKa=ReplaceRule[
		replacedFormsSafeOps,
		pKa -> First[tempObj[pKa], Null]
	];

	(* NFPA is in a different format for easier command builderizing. *)
	(* If NFPA is specified, make it in the correct form. *)
	opsWithNFPA=If[MatchQ[tempObj[NFPA], NFPAP],
		ReplaceRule[
			opsWithpKa,
			NFPA -> {Lookup[tempObj[NFPA], Health], Lookup[tempObj[NFPA], Flammability], Lookup[tempObj[NFPA], Reactivity], Lookup[tempObj[NFPA], Special]}
		],
		ReplaceRule[
			opsWithpKa,
			NFPA -> Null
		]
	];

	(* Replace safe ops with rules pulled from the template obj*)
	replacedSafeOps=ReplaceRule[
		safeOps,
		opsWithNFPA
	];

	(* Make sure that we don't overwrite any user options. *)
	finalizedOptions=Normal[Join[Association[replacedSafeOps], Association[ToList[userOps]]]];

	(* Pass the final list through safe ops, and convert any links found into Links without IDs  *)
	Quiet[SafeOptions[UploadSampleModel, finalizedOptions]]
];

resolveTemplateOptions[
	funcName:_Symbol,
	tempObj:PacketP[],
	userOps_List,
	safeOps_List,
	ops:OptionsPattern[resolveTemplateOptions]
]:=Module[
	{listedOps, nonReusableFields, userOpsSpecified, defaultedOps, templateDefaultedRules, replacedSafeOps},

	(* Make sure we are dealing with lists of options *)
	listedOps=ToList[ops];

	(* A list of fields that should never be taken as*)
	nonReusableFields=OptionDefault[OptionValue[Exclude]];

	(* Determine which options the user specified *)
	userOpsSpecified=First /@ ToList[userOps];

	(* Determine which ops to pull from the template *)
	defaultedOps=DeleteCases[
		First /@ ToList[safeOps],
		Alternatives @@ Join[userOpsSpecified, ToList[nonReusableFields]]
	];

	(* Create a list of rules where defaulted options pull their value from the template object *)
	templateDefaultedRules=ReplaceAll[
		(# -> Lookup[tempObj, #])& /@ defaultedOps,
		xLink:LinkP[] :> Most[xLink](* Trim the IDs from any links discovered *)
	];

	(* Replace safe ops with rules pulled from the template obj*)
	replacedSafeOps=ReplaceRule[
		safeOps,
		templateDefaultedRules
	];

	(* Pass the final list through safe ops, and convert any links found into Links without IDs  *)
	SafeOptions[funcName, replacedSafeOps]
];


(* ::Subsection::Closed:: *)
(*Hold Helper Functions (Stolen from Widgets)*)


(* Given f and Hold[g[x]], return Hold[f[g[x]]] without evaluating anything. *)
holdComposition[f_, Hold[expr__]]:=Hold[f[expr]];
SetAttributes[holdComposition, HoldAll];


(* Given Hold[f[a[x],b[x],..]], returns {Hold[a[x]],Hold[b[x]]. *)
holdCompositionSingleton[heldItem_Hold]:=Module[{lengthOfHolds},
	(* Get the number of items inside of the f[...] head. *)
	lengthOfHolds=Length[Extract[heldItem, {1}]];

	(* Extract each item inside of the f[...] head and wrap it in a hold. *)
	Extract[heldItem, {1, #}, Hold]& /@ Range[lengthOfHolds]
];
SetAttributes[holdCompositionSingleton, HoldAll];


(* Given f and {Hold[a[x]], Hold[b[x]]..}, returns Hold[f[a[x],b[x]..]]. *)
holdCompositionList[f_, {helds___Hold}]:=Module[{joinedHelds},
	(* Join the held heads. *)
	joinedHelds=Join[helds];

	(* Swap the outter most hold with f. Then hold the result. *)
	With[{insertMe=joinedHelds}, holdComposition[f, insertMe]]
];
SetAttributes[holdCompositionList, HoldAll];


(* ::Subsection::Closed:: *)
(*Packet Formatting*)


(* Given a type and a list of resolved options, formats the options into a change packet. If no append input is provide, default it to false (normal behavior)*)
generateChangePacket[myType_, resolvedOptions_List, myOptions:OptionsPattern[]]:=generateChangePacket[myType, resolvedOptions, False, myOptions];
(* Given a type and a list of resolved options, formats the options into a change packet. *)
generateChangePacket[myType_, resolvedOptions_List, appendInput:BooleanP, myOptions:OptionsPattern[]]:=Module[{existingPacket, fields, convertedPacket, diffedPacket},
	(* Get the existing packet, if we were given one. *)
	existingPacket=Lookup[ToList[myOptions], ExistingPacket, <||>];
	(* Get the definition of this type. *)
	fields=Association@Lookup[LookupTypeDefinition[myType], Fields];

	(* For each of our options, see if it exists as a field of the same name in the object. *)
	convertedPacket=Association@KeyValueMap[
		Function[{optionSymbol, optionValue},
			Module[{fieldDefinition, formattedOptionSymbol},
				(* If this option doesn't exist as a field, do not include it in the change packet. *)
				If[!KeyExistsQ[fields, optionSymbol] || MatchQ[optionValue, Null],
					Nothing,

					(* Get the information about this specific field. *)
					fieldDefinition=Association@Lookup[fields, optionSymbol];
					(* Format our option symbol. *)
					(*If the Append options is true, switch the multiple field options to Append, otherwise Replace as usual*)
					formattedOptionSymbol=If[
						appendInput,
						Switch[{Lookup[fieldDefinition, Format], optionSymbol},
							{Single, Notebook},
							Transfer[optionSymbol],
							{Single,_},
							optionSymbol,
							{Multiple,_},
							Append[optionSymbol]
						],
						Switch[{Lookup[fieldDefinition, Format], optionSymbol},
							{Single, Notebook},
							Transfer[optionSymbol],
							{Single,_},
							optionSymbol,
							{Multiple,_},
							Replace[optionSymbol]
						]
					];

					(* Based on the class of our field, we have to format the values differently. *)
					Switch[Lookup[fieldDefinition, Class],
						Link,
						(* Are we dealing with a cloud file field? *)
						Switch[Lookup[fieldDefinition, Relation],
							Object[EmeraldCloudFile],
							(* If we already have a cloud file, just use that *)
							If[MatchQ[optionValue, ObjectP[Object[EmeraldCloudFile]]],
								formattedOptionSymbol -> Link[optionValue],
								Module[{heldFormattedOptionValue},
									(* Convert any URLs to be uploaded on real upload of the packet. *)
									heldFormattedOptionValue=With[{insertMe=optionValue},
										Replace[
											Hold[insertMe],
											{
												(* If our string is a URL, then try and download it. Otherwise, pass directly to UploadCloudFile. *)
												string_String :> If[MatchQ[string, URLP],
													With[{downloaded=Quiet[First[URLDownload[string]]]},
														If[MatchQ[downloaded, "ConnectionFailure"],
															Null,
															Link[UploadCloudFile[downloaded]]
														]
													],
													Link[Quiet[UploadCloudFile[string]]]
												]
											},
											{1}
										]
									];

									(* Compose the Field\[RuleDelayed]Value, getting rid of the holds. *)
									With[{insertMe1=formattedOptionSymbol, insertMe2=heldFormattedOptionValue},
										ReleaseHold[
											holdCompositionList[Rule, {Hold[insertMe1], insertMe2}]
										]
									]
								]
							],
							_,
							Module[{relationsList, backlinkMap},
								(* Convert our Relation field into a list of relations. *)
								relationsList=If[MatchQ[Lookup[fieldDefinition, Relation], _Alternatives],
									List @@ Lookup[fieldDefinition, Relation],
									ToList[Lookup[fieldDefinition, Relation]]
								];

								(* Build the type \[Rule] backlink mapping. *)
								backlinkMap=(
									If[!MatchQ[#, TypeP[]],
										obj:ObjectReferenceP[Head[#]] :> Link[obj, Sequence @@ #],
										obj:ObjectReferenceP[Head[#]] :> Link[obj]
									]
										&) /@ relationsList;

								(* Apply the backlink mapping. *)
								formattedOptionSymbol -> (optionValue /. {link_Link :> Download[link, Object]}) /. backlinkMap
							]
						],
						_,
						formattedOptionSymbol -> optionValue
					]
				]
			]
		],
		Association@resolvedOptions
	];

	(* Only include our key in our change packet if it is different than in our existing packet, if we have one. *)
	diffedPacket=If[MatchQ[existingPacket, <||>],
		convertedPacket,
		Association @@ KeyValueMap[
			Function[{key, value},
				Module[{strippedField},
					strippedField=(key /. {(Replace[field_]|Transfer[field_]) :> field});
					If[KeyExistsQ[existingPacket, strippedField] && MatchQ[Lookup[existingPacket, strippedField] /. {link_Link :> RemoveLinkID[link]}, value],
						(* Don't include the field *)
						Nothing,
						(* Otherwise, include the field. *)
						key -> value
					]
				]

			],
			convertedPacket
		]
	];

	(* Append the fields required to upload the object. *)
	Join[
		diffedPacket,
		<|
			(* Only add Authors if it's in the type definition. *)
			If[KeyExistsQ[fields, Authors],
				Replace[Authors] -> {Link[$PersonID]},
				Nothing
			],
			(*more custom stuff that might pertain to specific upload functions*)
			(*Upload Column specific*)
			If[MemberQ[Keys@resolvedOptions, ConnectorType],
				Switch[Lookup[resolvedOptions, ConnectorType],
					FemaleFemale, Replace[Connectors] -> {{"Column Inlet", Threaded, "10-32", 0.18 Inch, 0.18 Inch, Female}, {"Column Outlet", Threaded, "10-32", 0.18 Inch, 0.18 Inch, Female}},
					FemaleMale, Replace[Connectors] -> {{"Column Inlet", Threaded, "10-32", 0.18 Inch, 0.18 Inch, Female}, {"Column Outlet", Threaded, "10-32", 0.18 Inch, 0.18 Inch, Male}}
				],
				Nothing
			],
			(* If we're changing the Composition field, add a sample history card. *)
			(* Note: since SampleHistory has timestamp, we are not appending date (3rd column) of composition *)
			If[KeyExistsQ[diffedPacket, Replace[Composition] && !MatchQ[myType, TypeP[Model[Sample]]]],
				Append[SampleHistory] -> {
					DefinedComposition[<|
						Date -> Now,
						Composition -> Map[{#[[1]], #[[2]]}&,(Lookup[diffedPacket, Replace[Composition]] /. {link_Link :> Download[link, Object]})],
						ResponsibleParty -> Download[$PersonID, Object]
					|>]
				},
				Nothing
			]
		|>
	]
];


(* Change any change heads in our packet. Make sure to keep DelayedRules from evaluating the RHS. *)
stripChangePacket[myChangePacket_Association, myOptions:OptionsPattern[]]:=Module[{existingPacket, nonChangePacket, fullPacket, fields, nonComputableFields, notIncludedFields},
	(* Get the existing packet, if we were given one. *)
	existingPacket=Lookup[ToList[myOptions], ExistingPacket, <||>];

	(* Get rid of the Replace|Append heads. *)
	nonChangePacket=Association@Map[
		Function[changeField,
			ReplaceAll[changeField, {(Replace | Append | Transfer)[head_] :> head}]
		],
		Normal[myChangePacket]
	];

	(* Merge the existing packet with our change packet. *)
	fullPacket=Join[existingPacket, nonChangePacket];

	(* Get the object definition. *)
	fields=Lookup[LookupTypeDefinition[Lookup[myChangePacket, Type]], Fields];

	(* Get all non-computable fields. *)
	nonComputableFields=Cases[fields, Verbatim[Rule][_, KeyValuePattern[Class -> Except[Computable]]]][[All, 1]];

	(* Add Null/{} values for keys that don't exist in the change packet. *)
	(* Note: Never include Object. *)
	notIncludedFields=Complement[nonComputableFields, Append[Keys[fullPacket], Object]];

	(* Add these fields to the packet. *)
	Join[
		fullPacket,
		Association@Map[
			(If[MatchQ[Lookup[Lookup[fields, #], Format], Single],
				# -> Null,
				# -> {}
			]&),
			notIncludedFields
		]
	]
];


(* ::Subsection::Closed:: *)
(*Error Throwing*)


(* Get the full Error::MyError\[Rule]listOfCorrespondingInvalidOptions for the type given and all the supertypes of that type. *)
lookupInvalidOptionMap[myType_]:=Flatten[ValidObjectQ`Private`errorToOptionMap /@ NestWhileList[Most[#]&, myType, (Length[#] != 1&)]];


(* ::Subsection::Closed:: *)
(*Sister Functions*)

LazyLoading[$DelayDefaultUploadFunction, InstallValidQFunction, DownValueTrigger -> True];

InstallValidQFunction[myFunction_, myType_]:=Module[{validQFunctionString, validQFunctionSymbol, stringInputName},
	(* Do surgery to add Valid <> myFunction <> Q. *)
	validQFunctionString="Valid"<>ToString[myFunction]<>"Q";
	validQFunctionSymbol=ToExpression["ECL`"<>validQFunctionString];

	(* Install the usage rules. *)
	stringInputName=ToLowerCase[ToString[Last[myType]]];

	(* Install usage rules. *)
	DefineUsage[validQFunctionSymbol,
		{
			BasicDefinitions -> {
				{
					Definition -> {validQFunctionString<>"["<>stringInputName<>"Name]", "isValid"<>stringInputName<>"Model"},
					Description -> "returns a boolean that indicates if a valid "<>ToString[myType]<>" will be generated from the inputs of this function.",
					Inputs :> {
						{
							InputName -> stringInputName<>"Name",
							Description -> "The common name of this "<>stringInputName<>".",
							Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line]
						}
					},
					Outputs :> {
						{
							OutputName -> "isValid"<>stringInputName<>"Model",
							Description -> "A boolean that indicates if the resulting "<>ToString[myType]<>" is valid.",
							Pattern :> BooleanP
						}
					}
				}
			},
			SeeAlso -> {
				"UploadOligomer",
				"UploadProtein",
				"UploadAntibody",
				"UploadCarbohydrate",
				"UploadPolymer",
				"UploadResin",
				"UploadSolidPhaseSupport",
				"UploadLysate",
				"UploadVirus",
				"UploadMammalianCell",
				"UploadBacterialCell",
				"UploadYeastCell",
				"UploadTissue",
				"UploadMaterial",
				"UploadSpecies",
				"UploadProduct",
				"Upload",
				"Download",
				"Inspect"
			},
			Author -> {
				"lige.tonggu"
			}
		}
	];

	(* Install the options. *)
	DefineOptions[validQFunctionSymbol,
		Options :> {
			VerboseOption,
			OutputFormatOption
		},
		SharedOptions :> {myFunction}
	];

	(* Install the downvalue. *)
	validQFunctionSymbol[myInput_, myOptions:OptionsPattern[]]:=Module[
		{preparedOptions, functionTests, initialTestDescription, allTests, verbose, outputFormat},

		(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
		preparedOptions=Normal@KeyDrop[Append[ToList[myOptions], Output -> Tests], {Verbose, OutputFormat}];

		(* Call the function to get a list of tests *)
		functionTests=myFunction[myInput, Sequence @@ preparedOptions];

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
		RunUnitTest[<|"TestResults" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose]["TestResults"]
	];
];

LazyLoading[$DelayDefaultUploadFunction, InstallOptionsFunction,
	DownValueTrigger -> True];

InstallOptionsFunction[myFunction_, myType_]:=Module[{optionsFunctionString, optionsFunctionSymbol, stringInputName},

	(* Do surgery to add myFunction <> Options. *)
	optionsFunctionString=ToString[myFunction]<>"Options";
	optionsFunctionSymbol=ToExpression["ECL`"<>optionsFunctionString];

	(* Install the usage rules. *)
	stringInputName=ToLowerCase[ToString[Last[myType]]];

	(* Install usage rules. *)
	DefineUsage[optionsFunctionSymbol,
		{
			BasicDefinitions -> {
				{
					Definition -> {optionsFunctionString<>"["<>stringInputName<>"Name]", stringInputName<>"Options"},
					Description -> "returns a list of options as they will be resolved by "<>ToString[myFunction]<>"[].",
					Inputs :> {
						{
							InputName -> stringInputName<>"Name",
							Description -> "The common name of this "<>stringInputName<>".",
							Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line]
						}
					},
					Outputs :> {
						{
							OutputName -> stringInputName<>"Options",
							Description -> "A list of resolved options as they will be resolved by "<>ToString[myFunction]<>"[].",
							Pattern :> {Rule..}
						}
					}
				}
			},
			SeeAlso -> {
				"UploadOligomer",
				"UploadProtein",
				"UploadAntibody",
				"UploadCarbohydrate",
				"UploadPolymer",
				"UploadResin",
				"UploadSolidPhaseSupport",
				"UploadLysate",
				"UploadVirus",
				"UploadMammalianCell",
				"UploadBacterialCell",
				"UploadYeastCell",
				"UploadTissue",
				"UploadMaterial",
				"UploadSpecies",
				"UploadProduct",
				"Upload",
				"Download",
				"Inspect"
			},
			Author -> {
				"lige.tonggu"
			}
		}
	];

	(* Install the options. *)
	DefineOptions[optionsFunctionSymbol,
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
		SharedOptions :> {myFunction}
	];

	(* Install the downvalue. *)
	optionsFunctionSymbol[myInput_, myOptions:OptionsPattern[]]:=Module[
		{listedOps, outOps, options},

		(* get the options as a list *)
		listedOps=ToList[myOptions];

		outOps=DeleteCases[listedOps, (OutputFormat -> _) | (Output -> _)];

		options=myFunction[myInput, Sequence @@ Append[outOps, Output -> Options]];

		(* Return the option as a list or table *)
		If[MatchQ[Lookup[listedOps, OutputFormat, Table], Table],
			LegacySLL`Private`optionsToTable[options, myFunction],
			options
		]
	];
];


(* ::Subsection:: *)
(*Install Tests*)

LazyLoading[$DelayDefaultUploadFunction, InstallIdentityModelTests,
	DownValueTrigger -> True, UpValueTriggers -> {Tests, Examples, RunUnitTest}];

InstallIdentityModelTests[myFunction_, basicDescription_, defaultFunctionArguments_List]:=InstallIdentityModelTests[
	myFunction, basicDescription, defaultFunctionArguments, {}
];

InstallIdentityModelTests[myFunction_, basicDescription_, defaultFunctionArguments_List, symbolSetUpObjectsToDelete:ListableP[ObjectP[]]]:=Module[{createExample, testsForOptions, optionDefinition, options, listOfTests},
	(* Helper function that will create an Example[...] with myDescription, myFunction, and myArguments. *)
	createExample[myDescription_, myFunctionSymbol_, myArguments_]:=Module[{heldFunctionCall, heldDescription},
		(* First we have to create Hold[myFunctionSymbol[myArguments]] and Hold[myDescription]. *)
		heldFunctionCall=With[{insertMe=(Sequence @@ myArguments)},
			holdCompositionList[myFunctionSymbol, {Hold[insertMe]}]
		];
		heldDescription=With[{insertMe=myDescription},
			Hold[insertMe]
		];

		(* holdCompositionList creates Hold[Example[...]], then Example is HoldRest so we ReleaseHold. *)
		ReleaseHold@With[{insertMe1=heldDescription, insertMe2=heldFunctionCall},
			holdCompositionList[
				Example,
				{
					insertMe1,
					insertMe2,
					Hold[ObjectP[]|_Grid|BooleanP],

					(* SetUp and TearDown are the same for all examples. *)
					Hold[
						SetUp :> {
							$CreatedObjects={};
						}
					],
					Hold[
						TearDown :> {
							EraseObject[$CreatedObjects, Force -> True];
							Unset[$CreatedObjects];
						}
					]
				}
			]
		]
	];

	(* Create a big dictionary of option name to information about the default test for that option. *)
	testsForOptions=Association@{
		Name -> <|
			Description -> "Use the Name option to set the name of this new identity model:",
			AdditionalOptions -> {Name -> "My New Identity Model #"<>CreateUUID[]}
		|>,
		Synonyms -> <|
			Description -> "Use the Synonyms option add additional names that this identity model goes by:",
			AdditionalOptions -> {Synonyms -> {"Novel Compound #4"}}
		|>,
		ExtinctionCoefficients -> <|
			Description -> "Use the ExtinctionCoefficients option to set the Extinction Coefficient of this uploaded identity model. This field is in the format {{Wavelength,ExtinctionCoefficient}..}:",
			AdditionalOptions -> {ExtinctionCoefficients -> {{260 Nanometer, 13400 Liter / (Centimeter * Mole)}}}
		|>,
		Density -> <|
			Description -> "Use the Density option to set the density of this uploaded identity model:",
			AdditionalOptions -> {Density -> 1.10 Gram / (Centimeter^3)}
		|>,
		MeltingPoint -> <|
			Description -> "Use the MeltingPoint option to provide the temperature at which the solid form of this identity model will melt:",
			AdditionalOptions -> {MeltingPoint -> 343.5 Celsius}
		|>,
		BoilingPoint -> <|
			Description -> "Use the BoilingPoint option to provide the temperature at which the liquid form of this identity model will evaporate:",
			AdditionalOptions -> {BoilingPoint -> 189 Celsius}
		|>,
		VaporPressure -> <|
			Description -> "Use the VaporPressure option to provide the equilibrium pressure of this identity model when it is in thermodynamic equilibrium with its condensed phase:",
			AdditionalOptions -> {VaporPressure -> 0.049 Kilo * Pascal}
		|>,
		Viscosity -> <|
			Description -> "Use the Viscosity option to provide the internal friction of this identity model, measured by the force per unit area resisting a flow between parallel layers of liquid:",
			AdditionalOptions -> {Viscosity -> Quantity[0.8949, "Centipoise"]}
		|>,
		pKa -> <|
			Description -> "Use the pKa option to specify the logarithmic acid dissociation constant for the hydrogen ions present in this identity model:",
			AdditionalOptions -> {pKa -> {2.37}}
		|>,
		pH -> <|
			Description -> "Use the pH option to specify the logarithmic concentration of hydrogen ions of a pure sample of this identity model at room temperature and pressure:",
			AdditionalOptions -> {pH -> {6.7}}
		|>,
		Radioactive -> <|
			Description -> "Use the Radioactive option to specify if this pure samples of this identity model contain unstable atomic nucleuses which lose energy by radiation:",
			AdditionalOptions -> {Radioactive -> False}
		|>,
		Ventilated -> <|
			Description -> "Use the Ventilated option to specify that the pure samples of this identity model need to be handled in a ventilated enclosure:",
			AdditionalOptions -> {Ventilated -> True}
		|>,
		Pungent -> <|
			Description -> "Use the Pungent option to indicate that pure samples of this identity model have a strong odor:",
			AdditionalOptions -> {Pungent -> True, Ventilated -> True}
		|>,
		Acid -> <|
			Description -> "Use the Acid option to specify that pure samples of this identity model are strong acids:",
			AdditionalOptions -> {Acid -> False}
		|>,
		Base -> <|
			Description -> "Use the Base option to specify that pure samples of this identity model are strong bases:",
			AdditionalOptions -> {Base -> False}
		|>,
		Pyrophoric -> <|
			Description -> "Use the Pyrophoric option to specify that pure samples of this identity model ignite spontaneously with contact with air:",
			AdditionalOptions -> {Pyrophoric -> False}
		|>,
		WaterReactive -> <|
			Description -> "Use the WaterReactive option to specify that pure samples of this identity model react violently with contact with water:",
			AdditionalOptions -> {WaterReactive -> False}
		|>,
		Fuming -> <|
			Description -> "Use the Fuming option to specify that pure samples of this identity model produce fumes when exposed to air:",
			AdditionalOptions -> {Fuming -> False}
		|>,
		HazardousBan -> <|
			Description -> "Use the HazardousBan option to indicate that sample that contain this identity model are currently banned from usage in the ECL because the facility isn't yet equipped to handle them:",
			AdditionalOptions -> {HazardousBan -> False}
		|>,
		ExpirationHazard -> <|
			Description -> "Use the ExpirationHazard option to indicate that samples that contain this identity model are hazardous when they become expired:",
			AdditionalOptions -> {ExpirationHazard -> False}
		|>,
		ParticularlyHazardousSubstance -> <|
			Description -> "Use the ParticularlyHazardousSubstance option to specify that special precautions should be taken in handling samples that contain this identity model. This option should be set to True if the GHS Classification of the identity model is an of the following: Reproductive Toxicity (H340, H360, H362),  Acute Toxicity (H300, H310, H330, H370, H373), Carcinogenicity (H350):",
			AdditionalOptions -> {ParticularlyHazardousSubstance -> False}
		|>,
		DrainDisposal -> <|
			Description -> "Use the DrainDisposal option to specify that pure samples of this identity model can be safely disposed down a standard drain:",
			AdditionalOptions -> {DrainDisposal -> True}
		|>,
		MSDSRequired -> <|
			Description -> "Use the MSDSRequired option to indicate that an MSDS file must be supplied for this identity model. An MSDS file is required by SLL the identity model is detected to be hazardous, however, it is best to always provide an MSDS when possible:",
			AdditionalOptions -> {MSDSRequired -> False}
		|>,
		NFPA -> <|
			Description -> "Use the NFPA option to specify the National Fire Potection Association (NFPA) 704 Hazard diamond classification of this substance. This option is specified in the format {HealthRating,FlammabilityRating,ReactivityRating,SpecialConsiderationsList}. The valid symbols to include in SpecialConsiderationsList are Oxidizer|WaterReactive|Aspyxiant|Corrosive|Acid|Bio|Poisonous|Radioactive|Cryogenic|Null. The following identity model, as an NFPA of {1,0,0,{Radioactive}} which means that its Health rating is 1, its Flammability rating is 0, and its Reactivity rating is 0. This identity model has no special considerations:",
			AdditionalOptions -> {NFPA -> {1, 0, 0, {Radioactive}}}
		|>,
		DOTHazardClass -> <|
			Description -> "Use the DOTHazardClass option to set the DOT Hazard Class of this uploaded identity model. The valid values of this option can be found by evaluating DOTHazardClassP. The following identity model is part of DOT Hazard Class 0:",
			AdditionalOptions -> {DOTHazardClass -> "Class 0"}
		|>,
		LightSensitive -> <|
			Description -> "Use the LightSensitive option to specify if the identity model is light sensitive and special precautions should be taken to make sure that samples that contain this identity model should be handled in a dark room:",
			AdditionalOptions -> {LightSensitive -> False}
		|>,
		LiquidHandlerIncompatible -> <|
			Description -> "Use the LiquidHandlerIncompatible option to specify that pure samples of this identity model cannot be reliably aspirated or dispensed by a liquid handling robot (ex. Methanol):",
			AdditionalOptions -> {LiquidHandlerIncompatible -> False}
		|>,
		UltrasonicIncompatible -> <|
			Description -> "Use the UltrasonicIncompatible option to specify that volume measurements of pure samples of this identity model cannot be performed via the ultrasonic distance method due to vapors interfering with the reading (ex. Methanol):",
			AdditionalOptions -> {UltrasonicIncompatible -> False}
		|>,
		LiteratureReferences -> <|
			Description -> "Use the LiteratureReferences option to link to scholarly articles that mention this identity model:",
			AdditionalOptions -> {LiteratureReferences -> {Object[Report, Literature, "Doorbar HPV Review"]}}
		|>,
		PolymerType -> <|
			Description -> "Use the PolymerType option to indicate the type of polymer the oligomer is composed of (not counting modifications):",
			AdditionalOptions -> {PolymerType -> DNA}
		|>,
		State -> <|
			Description -> "Use the State option to set the state of matter (Solid, Liquid, Gas) of a pure sample of this identity model at room temperature and standard pressure:",
			AdditionalOptions -> {State -> Solid}
		|>,
		Flammable -> <|
			Description -> "Use the Flammable option to indicate if pure samples of this identity model easily combust:",
			AdditionalOptions -> {Flammable -> False}
		|>,
		BiosafetyLevel -> <|
			Description -> "Use the BiosafetyLevel option to specify the biosafety level of this identity model. The valid value of this options can be found by evaluating BiosafetyLevelP (\"BSL-1\",\"BSL-2\",\"BSL-3\",\"BSL-4\"):",
			AdditionalOptions -> {BiosafetyLevel -> "BSL-1"}
		|>,
		IncompatibleMaterials -> <|
			Description -> "Use the IncompatibleMaterials option to specify the list of materials that would become damaged if wetted by this identity model. Use MaterialP to see the materials that can be used in this field. Specify {None} if there are no IncompatibleMaterials:",
			AdditionalOptions -> {IncompatibleMaterials -> {None}}
		|>,
		Enthalpy -> <|
			Description -> "Use the enthalpy option to indicate the expected binding enthalpy for the binding of this oligomer. If Watson-Crick paring is not present in this structure, the Enthalpy is calculated with the structure bound to its reverse complement:",
			AdditionalOptions -> {Enthalpy -> Quantity[0., ("KilocaloriesThermochemical") / ("Moles")]}
		|>,
		Entropy -> <|
			Description -> "Use the entropy option to indicate the expected binding entropy for the binding of this oligomer. If Watson-Crick paring is not present in this structure, the Entropy is calculated with the structure bound to its reverse complement:",
			AdditionalOptions -> {Entropy -> Quantity[0., ("CaloriesThermochemical") / ("Kelvins" "Moles")]}
		|>,
		FreeEnergy -> <|
			Description -> "Use the free energy option to indicate the expected Gibbs Free Energy for the binding of oligomer at 37 Celsius. If Watson-Crick paring is not present in this structure, the Gibbs Free Energy is calculated with the structure bound to its reverse complement:",
			AdditionalOptions -> {Entropy -> 0 CaloriePerMoleKelvin}
		|>,

		(* Model[Molecule, Protein, Antibody] *)
		Species -> <|
			Description -> "Use the species option to indicate the species that the antibody was raised. Determines the type of secondary antibody required for labeling:",
			AdditionalOptions -> {Species -> Model[Species, "Human"]}
		|>,
		Target -> <|
			Description -> "Use the Target option to indicate the protein or antibody targets to which this antibody binds selectively:",
			AdditionalOptions -> {Target -> {Model[Molecule, Protein, "id:D8KAEvG676ML"], Model[Molecule, Protein, "id:wqW9BP7JmJZO"], Model[Molecule, Protein, "id:J8AY5jD676MB"], Model[Molecule, Protein, "id:8qZ1VW0676Jn"], Model[Molecule, Protein, "id:rea9jlRPmPB3"]}}
		|>,
		SecondaryAntibodies -> <|
			Description -> "Use the SecondaryAntibodies option to indicate the other antibodies that bind to this antibody and can be used for labeling:",
			AdditionalOptions -> {SecondaryAntibodies -> {Model[Molecule, Protein, Antibody, "id:lYq9jRxPaPal"]}}
		|>,
		Isotype -> <|
			Description -> "Indicate the subgroup of immunoglobulin this antibody belongs to, based on variations within the constant regions of its heavy and/or light chains.",
			AdditionalOptions -> {Isotype -> IgA}
		|>,
		Clonality -> <|
			Description -> "Specify whether the antibody is produced by one type of cells to recognize a single epitope (monoclonal) or several types of immune cells to recognize multiple epitopes (polyclonal):",
			AdditionalOptions -> {Clonality -> Monoclonal}
		|>,
		AssayTypes -> <|
			Description -> "Indicate the types of experiments in which this antibody is known to perform well in:",
			AdditionalOptions -> {AssayTypes -> {Western, FlowCytometry, ELISA, Immunohistochemistry, Immunoprecipitation, Immunofluorescence, ChromatinImmunoprecipitation}}
		|>,
		RecommendedDilution -> <|
			Description -> "Indicate the dilution that is recommended for use of this identity model in an assay:",
			AdditionalOptions -> {RecommendedDilution -> 0.5}
		|>,

		(* Model[Cell] *)
		DetectionLabels -> <|
			Description -> "Indicate the tags that the cell contains, which can indicate the presence and amount of particular features or molecules in the cell:",
			AdditionalOptions -> {DetectionLabels -> {Model[Molecule, Protein, "id:WNa4ZjKVdVLE"]}}
		|>,

		(* Model[Cell, Mammalian] *)
		CellType -> <|
			Description -> "Indicate the general type of the cell line (Mammalian, Bacterial, or Yeast):",
			AdditionalOptions -> {CellType -> Mammalian}
		|>,
		CultureAdhesion -> <|
			Description -> "Indicate the culture type of the cell line (Adherent or Suspension):",
			AdditionalOptions -> {CultureAdhesion -> Adherent}
		|>,

		(* Model[Cell, Bacteria] *)
		Antibiotics -> <|
			Description -> "Specify the antimicrobial substances that kill or inhibit the growth of this strain of bacteria:",
			AdditionalOptions -> {Antibiotics -> {Model[Molecule, "id:eGakldJvLvA4"]}}
		|>,
		Hosts -> <|
			Description -> "Specify the species that are known to carry this strain of bacteria:",
			AdditionalOptions -> {Hosts -> {Model[Species, "Human"]}}
		|>,
		GramStain -> <|
			Description -> "Indicate whether this strain of bacteria has a layer of peptidoglycan in its cell wall:",
			AdditionalOptions -> {GramStain -> Positive}
		|>,
		Flagella -> <|
			Description -> "Indicate the type of flagella that protrude from this bacterium's cell wall:",
			AdditionalOptions -> {Flagella -> Monotrichous}
		|>,
		Length -> <|
			Description -> "The length of a single bacterium's body along its longest dimension.",
			AdditionalOptions -> {Length -> 5 Micrometer}
		|>,

		(* Model[Molecule, Carbohydrate] *)
		GlyTouCanID -> <|
			Description -> "Specify the GlyTouCan IDs for this carbohydrate:",
			AdditionalOptions -> {GlyTouCanID -> {"1"}}
		|>,
		WURCS -> <|
			Description -> "Specify the Web3 Unique Representation of Carbohydate Structures notation for this carbohydrate:",
			AdditionalOptions -> {WURCS -> "1"}
		|>,
		MonoisotopicMass -> <|
			Description -> "The monoisotopic, underivatised, uncharged mass of this carbohydrate, calculated from experimental data for individual monosaccarides.",
			AdditionalOptions -> {MonoisotopicMass -> 200 Gram / Mole}
		|>,

		(* Model[Lysate] *)
		Cell -> <|
			Description -> "Specify the model of cell line that this lysate is extracted from:",
			AdditionalOptions -> {Cell -> Model[Cell, "HEK293"]}
		|>,

		(* Model[Virus] *)
		GenomeType -> <|
			Description -> "Specify the type of genetic material carried by the virus:",
			AdditionalOptions -> {GenomeType -> "+ssRNA"}
		|>,
		Taxonomy -> <|
			Description -> "Specify the taxonomic class of the virus as defined by its phenotypic characteristics:",
			AdditionalOptions -> {Taxonomy -> Coronavirus}
		|>,
		LatentState -> <|
			Description -> "Specify the state of the virus in a latently infected cell:",
			AdditionalOptions -> {LatentState -> Integrated}
		|>,
		CapsidGeometry -> <|
			Description -> "Specify the virus's capsid structure:",
			AdditionalOptions -> {CapsidGeometry -> Helical}
		|>
	};

	(* Get the options for this function. *)
	optionDefinition=OptionDefinition[myFunction];
	options=Lookup[OptionDefinition[myFunction], "OptionSymbol"];

	(* Construct our giant list of tests. *)
	listOfTests=Flatten[{
		(* Create the basic example given to us as input. *)
		createExample[{Basic, basicDescription}, myFunction, defaultFunctionArguments],

		(* Map over our big option dictionary, adding additional option examples if we have them. *)
		KeyValueMap[
			Function[{option, optionInformation},
				(* Only include this additional example if the option is part of our function AND (the option found in AdditionalOptions matches the pattern if it's in the AdditionalOptions). *)
				If[MemberQ[options, option] && !MemberQ[Cases[defaultFunctionArguments, _Rule][[All, 1]], option],
					(* Join the additional options at the end of the default function arguments. *)
					createExample[{Options, option, Lookup[optionInformation, Description]}, myFunction, Flatten[{defaultFunctionArguments, Lookup[optionInformation, AdditionalOptions, {}]}]],
					Nothing
				]
			],
			testsForOptions
		]
	}];

	(* Install the tests. *)
	If[Length[ToList[symbolSetUpObjectsToDelete]]>0,
		With[{insertMe1=myFunction, insertMe2=listOfTests, insertMe3=ToList[symbolSetUpObjectsToDelete]},
			DefineTests[
				insertMe1,
				insertMe2,
				SymbolSetUp :> {
					Off[Warning::APIConnection];

					$CreatedObjects={};

					Module[{existingObjs},
						existingObjs = PickList[insertMe3, DatabaseMemberQ[insertMe3]];
						EraseObject[existingObjs, Force -> True, Verbose -> False]
					]
				},
				SymbolTearDown :> {
					On[Warning::APIConnection];

					EraseObject[$CreatedObjects, Force -> True, Verbose -> False];

					Unset[$CreatedObjects];
				}
			]
		],
		With[{insertMe1=myFunction, insertMe2=listOfTests},
			DefineTests[
				insertMe1,
				insertMe2,
				SymbolSetUp :> {
					Off[Warning::APIConnection];
					$CreatedObjects={};
				},
				SymbolTearDown :> {
					On[Warning::APIConnection];
					EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
					Unset[$CreatedObjects];
				}
			]
		]
	];
];


(* ::Subsection:: *)
(*Install Default Upload Function*)



LazyLoading[$DelayDefaultUploadFunction, InstallDefaultUploadFunction, DownValueTrigger -> True, UpValueTriggers -> {Usage}];


(* Overload to install using the default option resolver. *)
InstallDefaultUploadFunction[myFunction_, myType_, options:OptionsPattern[]]:=InstallDefaultUploadFunction[myFunction, myType, resolveDefaultUploadFunctionOptions, options];

(* Overload that specifies the option resolver to use. *)
InstallDefaultUploadFunction[myFunction_, myType_, myOptionResolver_Symbol, options:OptionsPattern[]]:=Module[
	{installNameOverload, installObjectOverload, stringInputName, singletonOverloadSymbol, singletonFunctionPattern, listableFunctionPattern},

	(* Default InstallNameOverload\[Rule]True and InstallObjectOverload\[Rule]True. *)
	installNameOverload=Lookup[ToList[options], InstallNameOverload, True];
	installObjectOverload=Lookup[ToList[options], InstallObjectOverload, True];

	(* Install the usage rules. *)
	stringInputName=ToLowerCase[ToString[Last[myType]]];

	DefineUsage[myFunction,
		{
			BasicDefinitions -> {

				If[TrueQ[installNameOverload] && TrueQ[installObjectOverload],
					{
						Definition -> {ToString[myFunction]<>"[Inputs]", stringInputName<>"Model"},
						Description -> "creates/updates a model '"<>stringInputName<>"Model' that contains the information given about the "<>stringInputName<>".",
						Inputs :> {
							IndexMatching[
								{
									InputName -> "Inputs",
									Description -> "The new names and/or existing objects that should be updated with information given about the "<>stringInputName<>".",
									Widget -> Alternatives[
										With[{insertMe=myType},
											Widget[Type -> Object, Pattern :> ObjectP[insertMe]]
										],
										Widget[Type -> String, Pattern :> _String, Size -> Line]
									]
								},
								IndexName -> "Input Data"
							]
						},
						Outputs :> {
							{
								OutputName -> stringInputName<>"Model",
								Description -> "The model that represents this "<>stringInputName<>".",
								Pattern :> ObjectP[myType]
							}
						},
						(* Hidden definition to call our functions with (ValidInputLengthsQ, etc.) *)
						CommandBuilder -> False
					},
					Nothing
				],

				If[TrueQ[installNameOverload],
					{
						Definition -> {ToString[myFunction]<>"["<>Capitalize[stringInputName]<>"Name]", stringInputName<>"Model"},
						Description -> "returns a new model '"<>stringInputName<>"Model' that contains the information given about the "<>stringInputName<>".",
						Inputs :> {
							IndexMatching[
								{
									InputName -> Capitalize[stringInputName]<>"Name",
									Description -> "The common name of this "<>stringInputName<>".",
									Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line]
								},
								IndexName -> "Input Data"
							]
						},
						Outputs :> {
							{
								OutputName -> stringInputName<>"Model",
								Description -> "The model that represents this "<>stringInputName<>".",
								Pattern :> ObjectP[myType]
							}
						}
					},
					Nothing
				],

				If[TrueQ[installObjectOverload],
					{
						Definition -> {ToString[myFunction]<>"["<>Capitalize[stringInputName]<>"Object]", stringInputName<>"Model"},
						Description -> "updates an existing model '"<>stringInputName<>"Model' that contains the information given about the "<>stringInputName<>".",
						Inputs :> {
							IndexMatching[
								{
									InputName -> Capitalize[stringInputName]<>"Object",
									Description -> "The existing "<>ToString[myType]<>" object that should be updated.",
									Widget -> With[{insertMe=myType},
										Widget[Type -> Object, Pattern :> ObjectP[insertMe], PreparedSample -> False, PreparedContainer -> False]
									]
								},
								IndexName -> "Input Data"
							]
						},
						Outputs :> {
							{
								OutputName -> stringInputName<>"Model",
								Description -> "The model that represents this "<>stringInputName<>".",
								Pattern :> ObjectP[myType]
							}
						}
					},
					Nothing
				]
			},
			If[MatchQ[myFunction,UploadSampleModel],
				MoreInformation -> {
					"If Updating the Composition of a Model[Sample], the Compositions of all linked Object[Sample]'s will also be updated. The date in the components of the composition will have the Date of when UploadSampleModel is executed."
				},
				Nothing
			],
			SeeAlso -> {
				"UploadOligomer",
				"UploadProtein",
				"UploadAntibody",
				"UploadCarbohydrate",
				"UploadPolymer",
				"UploadResin",
				"UploadSolidPhaseSupport",
				"UploadLysate",
				"UploadVirus",
				"UploadMammalianCell",
				"UploadBacterialCell",
				"UploadYeastCell",
				"UploadTissue",
				"UploadMaterial",
				"UploadSpecies",
				"UploadProduct",
				"Upload",
				"Download",
				"Inspect"
			},
			Author -> {
				"lige.tonggu"
			}
		}
	];

	(* Create the function signature for the singleton overload. *)
	singletonOverloadSymbol=ToExpression[ToString[myFunction]<>"Singleton"];

	(* Create an input pattern for our listable and singleton functions. *)
	singletonFunctionPattern=Switch[{installNameOverload, installObjectOverload},
		{True, True},
		_String | ObjectP[myType],
		{True, False},
		_String,
		{False, True},
		ObjectP[myType]
	];

	listableFunctionPattern=ListableP[singletonFunctionPattern];

	(* Install the listable overload. *)
	myFunction[myInputs:listableFunctionPattern, myOptions:OptionsPattern[]]:=Module[
		{listedOptions, outputSpecification, cache, simulation, output, gatherTests, safeOptions, safeOptionTests, validLengths, validLengthTests,
			invalidInputs, expandedInputs, expandedOptions, optionName, optionValueList, expandedOptionsWithName, transposedInputsAndOptions,
			results, messages, messageRules, messageRulesGrouped,
			messageRulesWithoutInvalidInput, transposedResults, outputRules, resultRule, packetsToUpload,
			invalidOptionMap, invalidOptions, messageRulesWithoutRequiredOptions, inputObjectCache},

		(* Make sure we're working with a list of options *)
		listedOptions=ToList[myOptions];

		(* Determine the requested return value from the function *)
		outputSpecification=If[!MatchQ[Lookup[listedOptions, Output], _Missing],
			Lookup[listedOptions, Output],
			Result
		];
		output=ToList[outputSpecification];

		(* Determine if we should keep a running list of tests *)
		gatherTests=MemberQ[output, Tests];

		(* Call SafeOptions to make sure all options match pattern *)
		{safeOptions, safeOptionTests}=If[gatherTests,
			SafeOptions[myFunction, listedOptions, Output -> {Result, Tests}, AutoCorrect -> False],
			{SafeOptions[myFunction, listedOptions, AutoCorrect -> False], Null}
		];

		(* Call ValidInputLengthsQ to make sure all options are the right length *)
		{validLengths, validLengthTests}=If[gatherTests,
			ValidInputLengthsQ[myFunction, {ToList[myInputs]}, listedOptions, Output -> {Result, Tests}],
			{ValidInputLengthsQ[myFunction, {ToList[myInputs]}, listedOptions], Null}
		];

		(* If the specified options don't match their patterns return $Failed (or the tests up to this point)  *)
		If[MatchQ[safeOptions, $Failed],
			Return[outputSpecification /. {
				Result -> $Failed,
				Tests -> safeOptionTests,
				Options -> $Failed,
				Preview -> Null
			}]
		];

		(* If option lengths are invalid return $Failed (or the tests up to this point) *)
		If[!validLengths,
			Return[outputSpecification /. {
				Result -> $Failed,
				Tests -> Join[safeOptionTests, validLengthTests],
				Options -> $Failed,
				Preview -> Null
			}]
		];

		(* SafeOptions passed. Use SafeOptions to get the output format. *)
		outputSpecification=Lookup[safeOptions, Output];

		(* Grab the cache and simulation from options *)
		cache=Lookup[safeOptions,Cache,{}];
		simulation=Lookup[safeOptions,Simulation,Null];

		(*-- Otherwise, we're dealing with a listable version. Map over the inputs and options. --*)
		(*-- Basic checks of input and option validity passed. We are ready to map over the inputs and options. --*)
		(* Expand any index-matched options from OptionName\[Rule]A to OptionName\[Rule]{A,A,A,...} so that it's safe to MapThread over pairs of options, inputs when resolving/validating values *)
		{expandedInputs, expandedOptions}=ExpandIndexMatchedInputs[myFunction, {ToList[myInputs]}, listedOptions];

		(* Download all of the objects from our input list without computable fields. *)
		inputObjectCache=Module[{objects, types, typeFields, fullDownloadFields},

			(*all unique objects we are working with*)
			objects=DeleteDuplicates[Cases[ToList[myInputs], ObjectReferenceP[myType], Infinity]];
			(* This is required as the objects may be subtype of myType and we need to download all the fields. This is specifically important for Model[Sample,StockSolution] *)
			types=Download[objects,Type];

			(* fields without computable fields *)
			typeFields=Map[
				(
					# -> {Packet@@Experiment`Private`noComputableFieldsList[#]}
				)&,
				DeleteDuplicates[types]
			];

			fullDownloadFields=types/.typeFields;

			(* need to Flatten here to get a flat list of packets *)
			Experiment`Private`FlattenCachePackets[
				Download[
					objects,
					fullDownloadFields,
					Cache->cache,
					Simulation->simulation
				]
			]
		];

		(* Put the option name inside of the option values list so we can easily MapThread. *)
		expandedOptionsWithName=Function[{option},
			optionName=option[[1]];
			optionValueList=option[[2]];

			(* We are given OptionName\[Rule]OptionValueList. *)
			(* We want {OptionName\[Rule]OptionValue1, OptionName\[Rule]OptionValue2, etc.} *)
			Function[{optionValue},
				optionName -> optionValue
			] /@ optionValueList
		] /@ expandedOptions;

		(* Transpose our inputs and options together. *)
		transposedInputsAndOptions=Transpose[{Sequence @@ expandedInputs, Sequence @@ expandedOptionsWithName}];

		(* We want to get all of the messages thrown by the function while not showing them to the user. *)
		(* Internal`InheritedBlock inherits the DownValues of Message while allowing block-scoped modification. *)
		{results, messages}=Internal`InheritedBlock[{Message, $InMsg=False},
			Transpose[(
				Module[{myMessageList},
					myMessageList={};
					Unprotect[Message];

					(* Set a conditional downvalue for the Message function. *)
					(* Record the message if it has an Error:: or Warning:: head. *)
					Message[msg_, vars___]/;!$InMsg:=Block[{$InMsg=True},
						If[MatchQ[HoldForm[msg], HoldForm[MessageName[Error | Warning, _]]],
							AppendTo[myMessageList, {HoldForm[msg], vars}];
							Message[msg, vars]
						]
					];

					(* Evaluate the singleton function. Return the result along with the messages. *)
					{Quiet[singletonOverloadSymbol[Sequence @@ Append[#, Cache -> inputObjectCache]]], myMessageList}
				]
					&) /@ transposedInputsAndOptions]
		];

		(* Build a map of messages and which inputs they were thrown for. *)
		messageRules=Flatten@Map[
			Function[{inputMessageList},
				Function[{inputMessage},
					ToString[First[inputMessage]] -> Rest[inputMessage]
				] /@ inputMessageList
			],
			messages
		];

		(* Group together our message rules. *)
		messageRulesGrouped=Merge[
			messageRules,
			Transpose
		];

		(* Throw Error::InvalidOption based on the messages that we threw in RunUnitTest. *)
		invalidOptionMap=lookupInvalidOptionMap[myType];

		(* Get the options that are invalid. *)
		invalidOptions=Cases[DeleteDuplicates[Flatten[Function[{messageName},
			(* If we're dealing with "Error::RequiredOptions", only count the options that are Null. *)
			If[MatchQ[messageName, "Error::RequiredOptions"],
				(* Only count the ones that are Null. *)
				Module[{allPossibleOptions},
					allPossibleOptions=Lookup[invalidOptionMap, messageName];

					(* We may have multiple Outputs requested from our result, so Flatten first and pull out the rules to get the options. *)
					(
						If[MemberQ[Lookup[Cases[Flatten[results], _Rule], #, Null], Null],
							#,
							Nothing
						]
							&) /@ allPossibleOptions
				],
				(* ELSE: Just lookup like normal. *)
				Lookup[invalidOptionMap, messageName, Null]
			]
		] /@ Keys[messageRulesGrouped]]], Except[_String | Null]];

		If[Length[invalidOptions] > 0,
			Message[Error::InvalidOption, ToString[invalidOptions]];
		];

		(* If Error::InvalidInput is thrown, message it separately. These error names must be present for the Command Builder to pick up on them. *)
		messageRulesWithoutInvalidInput=If[KeyExistsQ[messageRulesGrouped, "Error::InvalidInput"],
			Message[Error::InvalidInput, ToString[First[messageRulesGrouped["Error::InvalidInput"]]]];
			KeyDrop[messageRulesGrouped, "Error::InvalidInput"],
			messageRulesGrouped
		];

		(* Throw Error::RequiredOptions separately. This is so that we can delete duplicates on the first `1`. *)
		messageRulesWithoutRequiredOptions=If[KeyExistsQ[messageRulesWithoutInvalidInput, "Error::RequiredOptions"],
			Message[
				Error::RequiredOptions,
				(* Flatten all of the options that are required. *)
				ToString[DeleteDuplicates[Flatten[messageRulesWithoutInvalidInput["Error::RequiredOptions"][[1]]]]],

				(* Also delete duplicates for the inputs. *)
				ToString[DeleteDuplicates[Flatten[messageRulesWithoutInvalidInput["Error::RequiredOptions"][[2]]]]]
			];
			KeyDrop[messageRulesWithoutInvalidInput, "Error::RequiredOptions"],
			messageRulesWithoutInvalidInput
		];

		(* Throw the listable versions of the Error and Warning messages. *)
		(
			Module[{messageName, messageContents, messageNameHead, messageNameTag},
				messageName=#[[1]];
				messageContents=#[[2]];

				(* First, get the message name head and tag.*)
				messageNameHead=ToExpression[First[StringCases[messageName, x___~~"::"~~___ :> x]]];
				messageNameTag=First[StringCases[messageName, ___~~"::"~~x___ :> x]];

				(* Ignore Warning::UnknownOption since this is quieted in RunUnitTest but we're catching all messages. *)
				(* Also ignore Error::UnsupportedPolymers *)
				If[!MatchQ[messageName, "Warning::UnknownOption" | "Error::UnsupportedPolymers"],
					(* Throw the listable message. *)
					With[{insertMe1=messageNameHead, insertMe2=messageNameTag}, Message[MessageName[insertMe1, insertMe2], Sequence @@ (ToString[DeleteDuplicates[#]]& /@ messageContents)]];
				];

			]
				&) /@ Normal[messageRulesWithoutRequiredOptions];

		(* Transpose our result (if we have an output in a list form) and return them in the correct format. If we aren't dealing with an output list, just add a level of listing. *)
		transposedResults=If[MatchQ[outputSpecification, _List],
			Transpose[results],
			{results}
		];

		(* Generate the output rules for this output. *)
		outputRules=MapThread[
			(
				Switch[#1,
					Result,
					#1 -> #2,
					Options,
					#1 -> Normal[Merge[Association /@ #2, Identity]],
					Tests,
					#1 -> Flatten[#2],
					_,
					#1 -> #2
				]
					&),
			{ToList[outputSpecification], transposedResults}
		];

		(* Change the result rule to include the object IDs if we're uploading. *)
		resultRule=Result -> If[MemberQ[Keys[outputRules], Result] && !(Length[invalidOptions] > 0 || Length[invalidInputs] > 0),
			(* Lookup our output packets. *)
			packetsToUpload=Flatten[Lookup[outputRules, Result]];

			(* Upload if we're supposed to upload our packets and didn't get a Null result (a failure for one of the packets). *)
			If[Lookup[safeOptions, Upload] && !MemberQ[packetsToUpload, Null],
				Module[{allObjects, filteredObjects},
					(* Get rid of DelayedRules, then upload. *)
					allObjects=Upload[
						(Association @@ #&) /@ ReplaceAll[
							Normal /@ packetsToUpload,
							RuleDelayed -> Rule
						]
					];

					(* Return all objects of our type. *)
					filteredObjects=DeleteDuplicates[Cases[allObjects, ObjectP[myType]]];

					(* If we only have one filtered object, unlist it. *)
					If[Length[filteredObjects] == 1,
						First[filteredObjects],
						filteredObjects
					]
				],
				(* ELSE: Just return our packets. *)
				packetsToUpload
			],
			Null
		];

		(* Return the output in the specification wanted. *)
		outputSpecification /. (outputRules /. (Result -> _) -> (resultRule))
	];

	(* Install the singleton overload. *)
	singletonOverloadSymbol[myInput:singletonFunctionPattern, myOptions:OptionsPattern[]]:=Module[
		{
			listedOptions, safeOptions, safeOptionTests, validLengths, validLengthTests, outputSpecification, output, gatherTests,
			resolvedOptions, optionsWithNFPA, optionsWithExtinctionCoefficient, optionsWithOpticalCompositions, optionsWithCompositions, changePacket, nonChangePacket,
			packetTests, passedQ, evaluationData, optionsRule, previewRule, testsRule, resultRule, fullChangePacket, updateCompositionQ, packetWithoutRuleDelayed,
			additionalChangePackets, appendInput
		},

		(* Make sure we're working with a list of options *)
		listedOptions=ToList[myOptions];

		(* Call SafeOptions to make sure all options match pattern *)
		{safeOptions, safeOptionTests}=SafeOptions[myFunction, listedOptions, Output -> {Result, Tests}, AutoCorrect -> False];

		(* Call ValidInputLengthsQ to make sure all options are the right length *)
		{validLengths, validLengthTests}=ValidInputLengthsQ[myFunction, {myInput}, listedOptions, Output -> {Result, Tests}];

		(* Determine the requested return value from the function *)
		outputSpecification=Lookup[safeOptions, Output];
		output=ToList[outputSpecification];

		(* If the specified options don't match their patterns return $Failed *)
		If[MatchQ[safeOptions, $Failed],
			Return[Lookup[listedOptions, Output] /. {
				Result -> $Failed,
				Tests -> safeOptionTests,
				Options -> $Failed,
				Preview -> Null
			}]
		];

		(* If option lengths are invalid return $Failed *)
		If[!validLengths,
			Return[outputSpecification /. {
				Result -> $Failed,
				Tests -> Join[safeOptionTests, validLengthTests],
				Options -> $Failed,
				Preview -> Null
			}]
		];

		(* Determine if we should keep a running list of tests *)
		gatherTests=MemberQ[output, Tests];

		(* Get our resolved options. *)
		resolvedOptions=myOptionResolver[myType, myInput, safeOptions, listedOptions];

		(* --- Generate our formatted upload packet --- *)

		(* Change any options that aren't in the same format as the field definition. *)

		(* Convert our NFPA option into a valid NFPAP. *)
		(* no idea where Special->Null comes from, somewhere in the option resolver, but did not find the root cause *)
		optionsWithNFPA=Which[
			MatchQ[Lookup[resolvedOptions, NFPA, Null]/.(Rule[Special, Null] -> Rule[Special, {}]), NFPAP],
			ReplaceRule[
				resolvedOptions,
				NFPA -> {
					Health -> Lookup[Lookup[resolvedOptions, NFPA], Health],
					Flammability -> Lookup[Lookup[resolvedOptions, NFPA], Flammability],
					Reactivity -> Lookup[Lookup[resolvedOptions, NFPA], Reactivity],
					Special -> ToList[Lookup[Lookup[resolvedOptions, NFPA], Special]]
				}],
			MatchQ[Lookup[resolvedOptions, NFPA, Null],{
				0 | 1 | 2 | 3 | 4,
				0 | 1 | 2 | 3 | 4,
				0 | 1 | 2 | 3 | 4,
				{(Oxidizer | WaterReactive | Aspyxiant | Corrosive | Acid | Bio |
					Poisonous | Radioactive | Cryogenic | Null) ...}|Null
			}],
			ReplaceRule[
				resolvedOptions,
				NFPA -> {
					Health -> Lookup[resolvedOptions, NFPA][[1]],
					Flammability -> Lookup[resolvedOptions, NFPA][[2]],
					Reactivity -> Lookup[resolvedOptions, NFPA][[3]],
					Special -> ToList[Lookup[resolvedOptions, NFPA][[4]]]
				}],
			True,resolvedOptions
		];

		(* Convert our named multiple field - ExtinctionCoefficient - into its correct format. *)
		optionsWithExtinctionCoefficient=(
			If[SameQ[ExtinctionCoefficients, #[[1]]] && !MatchQ[#[[2]], Null | _Association],
				(* Right now, our extinction coefficient option is in the form {{myWavelength,myExtinctionCoefficient. *)
				(* We need the format to be {<|Wavelength->myWavelength,ExtinctionCoefficient->myExtinctionCoefficient|>..} *)
				#[[1]] -> Function[{myExtinctionCoefficient}, <|Wavelength -> myExtinctionCoefficient[[1]], ExtinctionCoefficient -> myExtinctionCoefficient[[2]]|>] /@ #[[2]],
				#
			]
				&) /@ optionsWithNFPA;

		(*Transfer the OpticalComposition to the Link[] that can be uploaded to Model[Sample] packet*)
		optionsWithOpticalCompositions=(
			If[MatchQ[#[[1]], OpticalComposition] && !MatchQ[#[[2]], Null | {Null}],
				#[[1]] -> Function[{myEntry}, If[MatchQ[myEntry[[2]], Null], myEntry, {myEntry[[1]], Link[myEntry[[2]]]}]] /@ #[[2]],
				#[[1]] -> If[MatchQ[#[[2]], {Null}],
					Null,
					#[[2]]
				]
			]&) /@ optionsWithExtinctionCoefficient;

		(* Convert our indexed multiple field - Composition - into its correct format. *)
		optionsWithCompositions = Map[
			Function[{optionRule},
				Module[{optionSymbol,optionValue},
					(* Split the option into symbol and value *)
					optionSymbol = First[optionRule];
					optionValue = Last[optionRule];

					If[MatchQ[optionSymbol, Composition] && !MatchQ[optionValue, Null | {Null}],
						optionSymbol -> Function[{myEntry},
							Which[
								(* NOTE: If the length is 2 the Composition option must be coming from UploadSampleModel *)
								MatchQ[Length[myEntry], 2] && MatchQ[myEntry[[2]], Null], myEntry,
								MatchQ[Length[myEntry], 2] && !MatchQ[myEntry[[2]], Null], {myEntry[[1]], Link[myEntry[[2]]]},
								MatchQ[Length[myEntry], 3] && MatchQ[myEntry[[2]], Null], myEntry,
								MatchQ[Length[myEntry], 3] && !MatchQ[myEntry[[2]], Null], {myEntry[[1]], Link[myEntry[[2]]], myEntry[[3]]},
								True, myEntry
							]

						] /@ optionValue,
						optionSymbol -> If[MatchQ[optionValue, {Null}], Null, optionValue]
					]
				]
			],
			optionsWithOpticalCompositions
		];

		(*Extract the append option and use as an input (so it is not deleted for not being included in the fields list)*)
		appendInput=If[
			(*If the user provided an append option (key is present), use that*)
			KeyExistsQ[safeOptions, Append],
			Lookup[safeOptions, Append],
			(*If no option was provided, default to False (to replace list as usual)*)
			False];

		(* Convert our options into a change packet. *)
		changePacket=With[{objectPacket=Experiment`Private`fetchPacketFromCache[myInput, Lookup[ToList[myOptions], Cache]]},
			If[MatchQ[objectPacket, PacketP[]],
				generateChangePacket[myType, optionsWithCompositions, appendInput, ExistingPacket -> objectPacket],
				generateChangePacket[myType, optionsWithCompositions, appendInput]
			]
		];

		(* Overwrite the Object key if our object already exists. *)
		fullChangePacket=If[MatchQ[myInput, ObjectP[myType]],
			Append[changePacket, Object -> Download[myInput, Object]],
			Append[changePacket, Object -> CreateID[myType]]
		];

		(* If we are inside of UploadSampleModel, also update any Object[Sample]s that are still linked to the Model[Sample]. *)
		(* NOTE: We only want to do this update if a new Composition was actually passed as an option *)
		(* Composition will be Null if it is not a specified option *)
		updateCompositionQ = !NullQ[Lookup[safeOptions,Composition,Null]];
		additionalChangePackets=If[MatchQ[myFunction, UploadSampleModel] && MatchQ[myInput, ObjectP[myType]] && updateCompositionQ,
			Module[{allSamples, allSamplePackets, datedOptionsWithCompositions},
				(* Get all of the Object[Sample]s still linked to our Model[Sample] that we can modify. *)
				allSamples=Search[Object[Sample], Status != Discarded && Model == myInput];

				(* Download our sample packets. *)
				allSamplePackets=Download[allSamples];

				(* Note: when we update Composition of Model[Sample], all Object[Sample] instances of this model will be updated. *)
				datedOptionsWithCompositions = Map[
					Function[{optionRule},
						Module[{optionSymbol,optionValue,currentTime},
							(* Split the option into symbol and value *)
							optionSymbol = First[optionRule];
							optionValue = Last[optionRule];

							(* Save the current time *)
							currentTime = Now;

							(* Append the time to the end of the composition *)
							If[MatchQ[optionSymbol, Composition] && !MatchQ[optionValue, Null | {Null}],
								optionSymbol -> Map[
									Function[{myEntry},
										{myEntry[[1]], Link[myEntry[[2]]], currentTime}
									],
									optionValue
								],
								optionSymbol -> If[MatchQ[optionValue, {Null}], Null, optionValue]
							]
						]
					],
					optionsWithCompositions
				];

				(* Append the object IDs to it. *)
				(* NOTE: Also never include the Name option since we don't want to change the names of Object[Samples]. *)
				(
					Append[generateChangePacket[Object[Sample], Cases[datedOptionsWithCompositions, Verbatim[Rule][Except[Name], _]], ExistingPacket -> #], Object -> Lookup[#, Object]]
						&) /@ allSamplePackets
			],
			{}
		];

		(* Strip off our change heads (Replace/Append) so that we can pretend that this is a real object so that we can call VOQ on it. *)
		(* This includes all fields to the packet as Null/{} if they weren't included in the change packet. *)
		(* If we had a previously existing packet, we merge that packet with our packet. *)
		nonChangePacket=With[{objectPacket=Experiment`Private`fetchPacketFromCache[myInput, Lookup[ToList[myOptions], Cache]]},
			If[MatchQ[objectPacket, PacketP[]],
				stripChangePacket[fullChangePacket, ExistingPacket -> objectPacket],
				stripChangePacket[Append[fullChangePacket, Type -> myType]]
			]
		];

		(* Get rid of any delayed rules so that we don't double upload. *)
		packetWithoutRuleDelayed=Association[Cases[Normal[nonChangePacket], Except[_RuleDelayed]]];

		(* Call VOQ, catch the messages that are thrown so that we know the corresponding InvalidOptions message to throw. *)
		packetTests=ValidObjectQ`Private`testsForPacket[packetWithoutRuleDelayed];

		(* VOQ passes if we didn't have any messages thrown. *)
		evaluationData=EvaluationData[
			Block[{ECL`$UnitTestMessages=True},
				RunUnitTest[<|"Function" -> packetTests|>, OutputFormat -> SingleBoolean, Verbose -> False]
			]
		];
		passedQ=Lookup[evaluationData, "Result"];

		(* If we didn't pass but also didn't throw any messages, call again with Verbose->Failures. *)
		If[!MatchQ[passedQ, True] && Length[Lookup[evaluationData, "Messages"]] == 0,
			RunUnitTest[<|"Function" -> packetTests|>, Verbose -> Failures],
			Null
		];

		(* --- Generate rules for each possible Output value ---  *)
		(* Prepare the Options result if we were asked to do so *)
		optionsRule=Options -> If[MemberQ[output, Options],
			RemoveHiddenOptions[myFunction, resolvedOptions],
			Null
		];

		(* Prepare the Preview result if we were asked to do so *)
		(* There is no preview for this function. *)
		previewRule=Preview -> Null;

		(* Prepare the Test result if we were asked to do so *)
		testsRule=Tests -> If[MemberQ[output, Tests],
			(* Join all existing tests generated by helper functions with any additional tests *)
			Flatten[Join[safeOptionTests, validLengthTests, packetTests]],
			Null
		];

		(* Prepare the standard result if we were asked for it and we can safely do so *)
		resultRule=Result -> If[MemberQ[output, Result] && TrueQ[passedQ],
			(* We never upload in the singleton overload. This is so that we can bundle in the listable overload. *)
			Append[additionalChangePackets, fullChangePacket],
			Null
		];

		outputSpecification /. {previewRule, optionsRule, testsRule, resultRule}
	];

];


(* ::Subsubsection::Closed:: *)
(*resolveDefaultUploadFunctionOptions*)


(* Helper function to resolve the options to our function. *)
(* Takes in a list of inputs and a list of options, return a list of resolved options. *)
resolveDefaultUploadFunctionOptions[myType_, myName_String, myOptions_, rawOptions_]:=Module[
	{myOptionsAssociation, myOptionsWithName, myFinalizedOptions},

	(* Convert the options to an association. *)
	myOptionsAssociation=Association @@ myOptions;

	(* This option resolver is a little unusual in that we have to AutoFill the options in order to compute *)
	(* either the tests or the results. *)

	(* -- AutoFill based on the information we're given. -- *)
	(* Overwrite the Name option if it is Null. *)
	myOptionsWithName=If[MatchQ[Lookup[myOptionsAssociation, Name], Null],
		Append[myOptionsAssociation, Name -> myName],
		myOptionsAssociation
	];


	(* Make sure that if we have a Name and Synonyms field  that Name is apart of the Synonyms list. *)
	myFinalizedOptions=If[MatchQ[Lookup[myOptionsWithName, Synonyms], Null] || (!MemberQ[Lookup[myOptionsWithName, Synonyms], Lookup[myOptionsWithName, Name]] && MatchQ[Lookup[myOptionsWithName, Name], _String]),
		Append[myOptionsWithName, Synonyms -> (Append[Lookup[myOptionsWithName, Synonyms] /. Null -> {}, Lookup[myOptionsWithName, Name]])],
		myOptionsWithName
	];

	(* Return our options. *)
	Normal[myFinalizedOptions]
];

(* Helper function to resolve the options to our function. *)
(* Takes in a list of inputs and a list of options, return a list of resolved options. *)
resolveDefaultUploadFunctionOptions[myType_, myInput:ObjectP[], myOptions_, rawOptions_]:=Module[
	{objectPacket, fields, resolvedOptions},

	(* Lookup our packet from our cache. *)
	objectPacket=Experiment`Private`fetchPacketFromCache[myInput, Lookup[ToList[myOptions], Cache]];

	(* Get the definition of this type. *)
	fields=Association@Lookup[LookupTypeDefinition[myType], Fields];

	(* For each of our options, see if it exists as a field of the same name in the object. *)
	resolvedOptions=Association@KeyValueMap[
		Function[{fieldSymbol, fieldValue},
			Module[{fieldDefinition, formattedOptionSymbol, formattedFieldValue},
				(* If field does not exist as an option do not include it in the resolved options *)
				If[!KeyExistsQ[myOptions, fieldSymbol],
					Nothing,

					(* If the user has specified this option, use that. *)
					If[KeyExistsQ[rawOptions, fieldSymbol],
						fieldSymbol -> Lookup[rawOptions, fieldSymbol],

						(* ELSE: Get the information about this specific field. *)
						fieldDefinition=Association@Lookup[fields, fieldSymbol];

						(* Strip off all links from our value. *)
						formattedFieldValue=ReplaceAll[fieldValue, link_Link :> RemoveLinkID[link]];

						(* Based on the class of our field, we have to format the values differently. *)
						Switch[Lookup[fieldDefinition, Class],
							Computable,
							Nothing,
							{_Rule..}, (* Named Multiple *)
							fieldSymbol -> ReplaceAll[formattedFieldValue[[All, 2]], {} -> Null],
							_,
							fieldSymbol -> ReplaceAll[formattedFieldValue, {} -> Null]
						]
					]
				]
			]
		],
		Association@objectPacket
	];

	(* Return our resolved options as a list. *)
	Normal[resolvedOptions]
];


(* ::Subsection::Closed:: *)
(* combineEHSFields *)

(* This overload doesn't take in any historical amounts to determine whether it's gone over the required threshold. *)
(* So, if you add one drop of acid into the solution, it will become Acid->True. This overload is only used for option *)
(* resolving in UploadSampleModel/UploadSample/UploadSampleTransfer/ExperimentTransfer to be extra safe since we want the user to tell us if things are okay. *)
combineEHSFields[ehsField_, sourceEHSValue_, destinationEHSValue_]:=Module[{},
	(* Note: If an EHS field gets added to the Object, it must be added to this merger function: *)
	ehsField -> Switch[ehsField,
		(* State has its own hierarchy: Liquid overrule Solid, then Gas if present. *)
		State,
		FirstCase[{Liquid, Solid, Gas, Null}, sourceEHSValue | destinationEHSValue, Null],
		(* CellType has its own hierarchy: Mammalian>Yeast>Bacteria, the same logic in UploadSampleModel *)
		CellType,
		FirstCase[{Mammalian, Yeast, Bacterial}, sourceEHSValue | destinationEHSValue, Null],

		(* BiosafetyLevel has its own hierarchy: *)
		BiosafetyLevel,
		FirstCase[{"BSL-4", "BSL-3", "BSL-2", "BSL-1"}, sourceEHSValue | destinationEHSValue, Null],

		(* double gloved doesn't care about % and just inherits any True if present *)
		DoubleGloveRequired,
		Or@@Map[MatchQ[#,True]&,{sourceEHSValue,destinationEHSValue}],

		(* PipettingMethod has its own hierarchy: *)
		PipettingMethod,
		(* First try to pick out of the hierarchy, from most to least conservative: *)
		FirstCase[
			{
				Model[Method, Pipetting, "id:AEqRl9KqjO4R"], (*Model[Method, Pipetting, "Organic High Viscosity"]*)
				Model[Method, Pipetting, "id:L8kPEjnkBZL4"], (*Model[Method, Pipetting, "Organic"]*)
				Model[Method, Pipetting, "id:4pO6dM5OV9vr"], (*Model[Method, Pipetting, "Organic Low Viscosity"],*)
				Model[Method, Pipetting, "id:xRO9n3BONYkj"], (*Model[Method, Pipetting, "Organic Low Volume"]*)
				Model[Method, Pipetting, "id:R8e1PjpeL6DJ"], (*Model[Method, Pipetting, "Aqueous High Viscosity"]*)
				Model[Method, Pipetting, "id:qdkmxzqkJlw1"], (*Model[Method, Pipetting, "Aqueous"]*)
				Model[Method, Pipetting, "id:54n6evLnXzxG"], (*Model[Method, Pipetting, "Aqueous Low Viscosity"]*)
				Model[Method, Pipetting, "id:wqW9BP7WbvjG"](*Model[Method, Pipetting, "Aqueous Low Volume"]*)
			},
			ObjectP[sourceEHSValue] | ObjectP[destinationEHSValue], (* Note: ObjectP may use Download[] to check an ID vs a Name *)
			(* If we aren't in the ECL defined hierarchy of pipetting methods (we have a custom method), use our custom method. *)
			FirstCase[{sourceEHSValue, destinationEHSValue}, ObjectP[Model[Method, Pipetting]], Null]
		],

		(* Fields gets combined: *)
		IncompatibleMaterials,
		Module[{combinedMaterials},
			combinedMaterials=DeleteDuplicates[Flatten[{sourceEHSValue, destinationEHSValue}]];

			(* If we have more than one, get rid of None: *)
			If[Length[combinedMaterials] > 1,
				Cases[combinedMaterials, Except[None]],
				combinedMaterials
			]
		],

		(* Fields that False wins out over True: *)
		Sterile | DrainDisposal | Anhydrous | AsepticHandling,
		FirstCase[{False, Null, True}, sourceEHSValue | destinationEHSValue, Null],

		(* Fields that True wins out over False|Null: *)
		Expires | Radioactive | Ventilated | Pungent | Flammable | Acid | Base | Pyrophoric | WaterReactive | Fuming | HazardousBan | ExpirationHazard | ParticularlyHazardousSubstance | MSDSRequired | LightSensitive | LiquidHandlerIncompatible | UltrasonicIncompatible,
		FirstCase[{True, False, Null}, sourceEHSValue | destinationEHSValue, Null],

		(* Fields that the Min wins out: *)
		ShelfLife | UnsealedShelfLife,
		(* If we have a Null, go with the value: *)
		If[MemberQ[{sourceEHSValue, destinationEHSValue}, Null | $Failed],
			FirstCase[{sourceEHSValue, destinationEHSValue}, _?NumericQ, Null],
			Min[{sourceEHSValue, destinationEHSValue}]
		],

		(* Fields that get Nulled if there are competing values: *)
		MSDSFile | DOTHazardClass,
		(* If we have a Null, go with the value: *)
		If[MemberQ[{sourceEHSValue, destinationEHSValue}, Null | $Failed],
			FirstCase[{sourceEHSValue, destinationEHSValue}, Except[Null | $Failed], Null],
			Null
		],

		(* Gets combined by index: *)
		NFPA,
		(* If we have a Null, go with the value: *)
		If[MemberQ[{sourceEHSValue, destinationEHSValue}, (Null | $Failed)],
			FirstCase[{sourceEHSValue, destinationEHSValue}, Except[Null | $Failed], Null],
			(* Both fields are not Null, combine: *)
			{
				Health -> Max[Lookup[sourceEHSValue, Health, Null], Lookup[destinationEHSValue, Health, Null]],

				Flammability -> Max[Lookup[sourceEHSValue, Flammability, Null], Lookup[destinationEHSValue, Flammability, Null]],

				Reactivity -> Max[Lookup[sourceEHSValue, Reactivity, Null], Lookup[destinationEHSValue, Reactivity, Null]],

				Special -> With[{listsCombined=DeleteDuplicates[Flatten[{Lookup[sourceEHSValue, Special, {}], Lookup[destinationEHSValue, Special, {}]}]]},
					(* Get rid of Null if we have more than 1 special condition: *)
					If[Length[listsCombined] > 1,
						Cases[listsCombined, Except[Null]],
						listsCombined
					]
				]
			}
		],
		(* Catch all *)
		_,
		sourceEHSValue
	]
];

(* this is an overload to resolve EHS fields based on the composition *)
combineEHSFields[composition:{{CompositionP | Null, ObjectP[] | Null} ...}, ehsFields:{_Symbol..}, amount:(VolumeP | MassP | CountP | Null), cache_]:=Module[
	{usedEHSField, compositionPackets, contributionPackets, density,
		initialContributionPackets, contributionScalingFactor, ehsFieldPercentages, resolvedFields, fieldDefinitions},

	(* we can not resolve storage  *)
	usedEHSField=DeleteCases[ehsFields, StorageCondition];

	(* if we were given an empty sample, fill the fields with Nulls *)
	If[MatchQ[composition, {} | {{Null, Null}}],
		Return[ReplaceRule[# -> Null& /@ usedEHSField, IncompatibleMaterials -> {Null}, Append -> False]]
	];

	(* get the composition with packets fetched from the cache *)
	(* in an ideal world ObjectP[packet] would actually work, but it doesn't so sucks to suck I guess *)
	(* also if we have a Null in the composition then just remove that from this guy *)
	compositionPackets=Map[
		Which[
			MatchQ[#[[2]], PacketP[]],
			{#[[1]], FirstCase[cache, ObjectP[Lookup[#[[2]], Object]]]},
			MatchQ[#[[2]], ObjectP[]],
			{#[[1]], FirstCase[cache, ObjectP[#[[2]]]]},
			NullQ[#[[2]]], Nothing,
			True, #
		]&,
		composition
	];

	(* if we have only one components - just return it's values *)
	If[Length[composition] == 1,
		Return[ # -> Lookup[compositionPackets[[1, 2]], #]& /@ usedEHSField]
	];

	(* approximate density of the sample, we don't need to be super close *)
	density=approximateDensity[compositionPackets];

	(* get contribution of each of the components of the Composition to the sample as a mass percent *)
	initialContributionPackets=Map[Function[{inputPair}, Module[
		{concentration, packet},
		{concentration, packet}=inputPair;
		{
			Switch[concentration,
				Null, 0,
				(* we have mol/l concentration, convert to MassPercent *)
				(_?QuantityQ | _?NumericQ)?ConcentrationQ, UnitConvert[concentration, "Moles" / "Liters"] * Lookup[packet, MolecularWeight] / density,
				(* we have g/l, convert to MassPercent *)
				(_?QuantityQ | _?NumericQ)?MassConcentrationQ, UnitConvert[concentration, "Grams" / "Liters"] / density,
				(* multiply by the density of the component and divide by the density of the sample *)
				(_?QuantityQ | _?NumericQ)?VolumePercentQ, concentration / (100 * VolumePercent) * If[MatchQ[Lookup[packet, Density], DensityP], Lookup[packet, Density], Quantity[0.997`, ("Grams") / ("Milliliters")]] / density,
				(* we already have mass %, great *)
				(_?QuantityQ | _?NumericQ)?MassPercentQ, concentration / (100 * MassPercent),
				(* confluency can not really be converted to mass % so don't add any contribution *)
				(_?QuantityQ | _?NumericQ)?PercentConfluencyQ, 0
			],
			packet
		}]], compositionPackets];

	(* get total contribution scaling factor *)
	(* for cases of {Null,X}.. just give scaling factor 1 so we don't crash *)
	contributionScalingFactor=If[EqualQ[Total[initialContributionPackets[[All, 1]]], 0], 1 , 1 / Total[initialContributionPackets[[All, 1]]]];

	(* get final contribution:packet pairs *)
	(* if we have only Null,X in the composition, give them all equal EHS percentages *)
	contributionPackets=If[MemberQ[compositionPackets[[All, 1]], Except[Null]],
		{#[[1]] * contributionScalingFactor, #[[2]]}& /@ initialContributionPackets,
		{1 / Length[compositionPackets], #[[2]]}& /@ compositionPackets];

	(* construct EHSFieldPercentage based off the composition *)
	ehsFieldPercentages=Map[Function[{field},
		Switch[field,
			(* IncompatibleMaterials are special since they are a list of things rather than a True/False *)
			(* should look like MaterialA->0.2, MaterialB->1 *)
			IncompatibleMaterials,
			field -> Module[{incompatibleMaterialsByComponent, contributionMaterials, mergedValues},
				incompatibleMaterialsByComponent=Map[Lookup[#[[2]], IncompatibleMaterials, {}]&, contributionPackets];
				(*Get a list in a form of {<|Material1->%contribution, Material2-> %Contribution|>, <|Material2->%Contribution..|>}*)
				contributionMaterials=MapThread[Function[{contribution, materials}, Association@Map[# -> contribution&, materials]], {contributionPackets[[All, 1]], incompatibleMaterialsByComponent}];
				(* merge incompatible materials totaling the amount they got *)
				mergedValues=KeyValueMap[#1 -> #2&, Merge[contributionMaterials, Total]]
			],

			(* NFPA is a list of rules, so we need to take care of them separately *)
			(* end result should be {Health->{1}, Reactivity->{1,2},..} *)
			NFPA,
			field -> KeyValueMap[#1 -> #2&, Merge[
				Map[Function[{packet},
					Association@If[NullQ@Lookup[packet, field, {}], {}, Lookup[packet, field, {}]]],
					contributionPackets[[All, 2]]],
				DeleteDuplicates[Join[#]]&]],

			(* single value that is not True/False *)
			(* Should be Value->RangeP[0,1] *)
			_,
			field -> KeyValueMap[#1 -> #2&,
				Merge[
					Map[Function[{tuple}, Lookup[tuple[[2]], field, Null] -> tuple[[1]]],
						contributionPackets],
					Total]]
		]], usedEHSField];

	(* resolve new field values using % from above and logic from another overload *)
	resolvedFields=Map[Function[{field},
		Module[{ehsFieldPercentage},

			ehsFieldPercentage=Lookup[ehsFieldPercentages, field];

			(* Based on these accumulated percentages, figure out what value we are returning*)
			field -> Switch[field,
				(* Solid and Liquid overrule Gas if present. Assume that the sample is liquid if there is more than 10% Liquid in the sample.*)
				State,
				Which[
					And[
						MemberQ[ehsFieldPercentage, Liquid -> GreaterP[0.]],
						Greater[
							Lookup[ehsFieldPercentage, Liquid] / Total[{
								Lookup[ehsFieldPercentage, Liquid, 0.],
								Lookup[ehsFieldPercentage, Solid, 0.],
								Lookup[ehsFieldPercentage, Gas, 0.]
							}],
							0.1`
						]
					],
					Liquid,
					MemberQ[ehsFieldPercentage, Solid -> _],
					Solid,
					MemberQ[ehsFieldPercentage, Gas -> _],
					Gas,
					True,
					Null
				],

				(* Simulate SampleHandling changes.*)
				(* NOTE: This should only be done for simulation purposes as we will ask the operator what the sample looks like after the transfer.*)
				SampleHandling,
				Which[
					MemberQ[ehsFieldPercentage, Slurry -> GreaterP[.25]],
					Slurry,
					MemberQ[ehsFieldPercentage, Viscous -> GreaterP[.25]],
					Viscous,
					MemberQ[ehsFieldPercentage, Paste -> GreaterP[.25]],
					Paste,
					MemberQ[ehsFieldPercentage, Liquid -> GreaterP[.25]],
					Liquid,
					MatchQ[Total[Lookup[ehsFieldPercentage, {Liquid, Slurry, Viscous, Paste}, 0]], GreaterP[.25]],
					Slurry,
					MemberQ[ehsFieldPercentage, Brittle -> _],
					Brittle,
					MemberQ[ehsFieldPercentage, Powder -> _],
					Powder,
					MemberQ[ehsFieldPercentage, Fabric -> _],
					Fabric,
					MemberQ[ehsFieldPercentage, Fixed -> _],
					Fixed,
					True,
					Null
				],

				(* If we have any bit of Mammalian, it's Mammalian if we have any bit of a Mammalian sample. Otherwise, if we have microbial, it's Microbial. *)
				CellType,
				Which[
					MemberQ[ehsFieldPercentage[[All, 1]], NonMicrobialCellTypeP],
						FirstCase[ehsFieldPercentage[[All, 1]], NonMicrobialCellTypeP],
					MemberQ[ehsFieldPercentage[[All, 1]], MicrobialCellTypeP],
						FirstCase[ehsFieldPercentage[[All, 1]], MicrobialCellTypeP],
					True,
						Null
				],

				(* BiosafetyLevel is just a hierarchy and doesn't care about percentages at all:*)
				BiosafetyLevel,
				FirstCase[{"BSL-4", "BSL-3", "BSL-2", "BSL-1"}, Alternatives @@ (ehsFieldPercentage[[All, 1]]), Null],

				(* double gloved doesn't care about % and just inherits any True if present *)
				DoubleGloveRequired,
				FirstCase[ehsFieldPercentage[[All, 1]], True, Null],

				(* PipettingMethod will take the pipetting method of the largest percentage:*)
				PipettingMethod,
				SortBy[ehsFieldPercentage, Last][[-1]][[1]],

				(* Materials are added to the larger list if they comprise more than 5%:*)
				IncompatibleMaterials,
				Module[{combinedMaterials},
					combinedMaterials=DeleteDuplicates[Cases[Flatten[Cases[ehsFieldPercentage, Verbatim[Rule][_, GreaterP[.05]]][[All, 1]]], Except[Null]]];
					(* If we have more than one, get rid of None: *)
					If[Length[combinedMaterials] > 1,
						Cases[combinedMaterials, Except[None]],
						combinedMaterials
					]
				],

				(* Fields that False wins out over True: *)
				Sterile|DrainDisposal|Anhydrous|AsepticHandling,
				Which[
					MemberQ[ehsFieldPercentage,False->_],False,
					MemberQ[ehsFieldPercentage,Null->_],Null,
					True,True
				],

				(* A drop of True will make it True:*)
				Radioactive | HazardousBan | ParticularlyHazardousSubstance | InertHandling,
				FirstCase[{True, False, Null}, Alternatives @@ (ehsFieldPercentage[[All, 1]]), Null],

				(* Cautious 5% Threshold to make it True.*)
				Flammable | Pyrophoric | WaterReactive | ExpirationHazard | MSDSRequired | LightSensitive | GloveBoxIncompatible | GloveBoxBlowerIncompatible,
				If[MemberQ[ehsFieldPercentage, True -> GreaterEqualP[.05]],
					True,
					SortBy[ehsFieldPercentage, Last][[-1]][[1]]
				],

				(* Less Cautious 10% Threshold to make it True.*)
				Expires | Ventilated | Pungent | Acid | Base | Fuming | LiquidHandlerIncompatible | UltrasonicIncompatible,
				If[MemberQ[ehsFieldPercentage, True -> GreaterEqualP[.1]],
					True,
					SortBy[ehsFieldPercentage, Last][[-1]][[1]]
				],

				(* Fields that the Min wins out:*)
				ShelfLife | UnsealedShelfLife | ExpirationDate,
				If[!MemberQ[ehsFieldPercentage[[All, 1]], _?DateObjectQ],
					Null,
					Min[Cases[ehsFieldPercentage[[All, 1]], _?DateObjectQ]]
				],

				(* Fields that get Nulled if there are competing values:*)
				MSDSFile | DOTHazardClass | TransportTemperature,
				If[Length[ehsFieldPercentage] > 1,
					Null,
					FirstOrDefault[FirstOrDefault[ehsFieldPercentage]]
				],

				(* Fields that get Nulled if there are competing values:*)
				NFPA,
				If[AnyTrue[Length[#] & /@ Values[ehsFieldPercentage], MatchQ[GreaterP[1]]],
					Null,
					Map[#[[1]] -> #[[2, 1]]&, ehsFieldPercentage]
				],

				(* Catch all*)
				_,
				SortBy[ehsFieldPercentage, Last][[-1]][[1]]
			]
		]
	], usedEHSField];

	(* do some error-correction *)
	fieldDefinitions=Lookup[LookupTypeDefinition[Model[Molecule]], Fields];
	Map[Function[{field},
		If[
			And[
				KeyExistsQ[resolvedFields, field],
				(* if field does not match it's storage pattern, make it Null *)
				!MatchQ[Lookup[resolvedFields, field], Lookup[Lookup[fieldDefinitions, field], Pattern] | Null]
				(*== If in the future we want to filter safety flags by volume/mass, make this an Or to the conditional above ==*)
				(* if we have less then 100uL/100mg of sample, do not populate certain safety fields *)
				(*And[
						MatchQ[field, (Expires | Ventilated | Pungent | Acid | Base | Fuming | LiquidHandlerIncompatible | UltrasonicIncompatible)],
						MatchQ[amount, (LessEqualP[100*Microliter]|LessEqualP[0.1*Gram])]
					]*)
			],
			field -> Null,
			field -> Lookup[resolvedFields, field]
		]],
		DeleteCases[usedEHSField, IncompatibleMaterials]]
];

(* NOTE: The existing cache is NOT a traditional object cache but has the added field EHSPercentages. *)
(* NOTE: transferAmount and destinationAmount must match. *)
combineEHSFields[ehsField_, sourceObject:ObjectP[], destinationObject:ObjectP[], transferAmount:(MassP | VolumeP), destinationAmount:(MassP | VolumeP), existingCache_List]:=Module[
	{sourcePacket, destinationPacket, sourceEHSValue, destinationEHSValue, destinationEHSPercentages, currentDestinationEHSFieldPercentages,
		amountTransferred, newDestinationEHSFieldPercentages, newDestinationEHSValue},

	(* Get our source and destination objects from our cache. *)
	sourcePacket=FirstCase[existingCache, KeyValuePattern[Object -> Download[sourceObject, Object]]];
	destinationPacket=FirstCase[existingCache, KeyValuePattern[Object -> Download[destinationObject, Object]]];

	(* Get the existing value of the EHS Field from our source and destination packet. *)
	sourceEHSValue=Lookup[sourcePacket, ehsField];
	destinationEHSValue=Lookup[destinationPacket, ehsField];

	(* Get the percentages of destination EHS Fields. We only really care about the destination since the *)
	(* transfer is from the source -> destination. *)
	destinationEHSPercentages=Lookup[destinationPacket, EHSPercentages, {}];

	(* If we don't have any destination percentages, assume that the percentage of the field value is 100%, *)
	(* aka, it's just given to us as the sample currently. *)
	(* NOTE: All of these percentages are RangeP[0,1] and don't have a Percent unit on them. *)
	currentDestinationEHSFieldPercentages=If[!KeyExistsQ[destinationEHSPercentages, ehsField],
		(* NOTE: We flatten out the field IncompatibleMaterials into its own materials. *)
		If[MatchQ[ehsField, IncompatibleMaterials],
			(# -> 1&) /@ ToList[destinationEHSValue],
			{destinationEHSValue -> 1}
		],
		Lookup[destinationEHSPercentages, ehsField]
	];

	(* Update the safety percentages. *)
	(* NOTE: We assume that the parent function passes down these in the same units. *)
	amountTransferred=Which[
		MatchQ[QuantityMagnitude[destinationAmount], 0 | 0.],
		1,

		MatchQ[destinationAmount, VolumeP] && MatchQ[transferAmount, VolumeP],
		N[transferAmount / (transferAmount + destinationAmount)],

		MatchQ[destinationAmount, MassP] && MatchQ[transferAmount, MassP],
		N[transferAmount / (transferAmount + destinationAmount)],

		MatchQ[destinationAmount, VolumeP] && MatchQ[transferAmount, MassP],
		If[MatchQ[Lookup[sourcePacket, Density], DensityP],
			N[(transferAmount / Lookup[sourcePacket, Density]) / ((transferAmount / Lookup[sourcePacket, Density]) + destinationAmount)],
			N[(transferAmount / Quantity[0.997`, ("Grams") / ("Milliliters")]) / ((transferAmount / Quantity[0.997`, ("Grams") / ("Milliliters")]) + destinationAmount)]
		],

		MatchQ[destinationAmount, MassP] && MatchQ[transferAmount, VolumeP],
		If[MatchQ[Lookup[sourcePacket, Density], DensityP],
			N[(transferAmount * Lookup[sourcePacket, Density]) / ((transferAmount * Lookup[sourcePacket, Density]) + destinationAmount)],
			N[(transferAmount * Quantity[0.997`, ("Grams") / ("Milliliters")]) / ((transferAmount * Quantity[0.997`, ("Grams") / ("Milliliters")]) + destinationAmount)]
		],

		True,
		1
	];

	(* If we already have some percentage of sourceEHSValue in our destination, we don't have to append it. *)
	(* NOTE: We flatten out the field IncompatibleMaterials into its own materials. *)
	newDestinationEHSFieldPercentages=If[MatchQ[ehsField, IncompatibleMaterials],
		If[MemberQ[currentDestinationEHSFieldPercentages, Alternatives @@ sourceEHSValue -> _],
			(
				If[MatchQ[#[[1]], Alternatives @@ ToList[sourceEHSValue]],
					#, (* Since the value that we're transferring in is amountTransferred, when you add it to (1-amountTransferred), it stays the same. *)
					#[[1]] -> (#[[2]] * Round[(1 - amountTransferred), 0.001])
				]
					&) /@ currentDestinationEHSFieldPercentages,
			Join[
				(#[[1]] -> (#[[2]] * Round[(1 - amountTransferred), 0.001])&) /@ currentDestinationEHSFieldPercentages,
				(# -> amountTransferred&) /@ ToList[sourceEHSValue]
			]
		],
		If[MemberQ[currentDestinationEHSFieldPercentages, sourceEHSValue -> _],
			(
				If[MatchQ[#[[1]], sourceEHSValue],
					#, (* Since the value that we're transferring in is amountTransferred, when you add it to (1-amountTransferred), it stays the same. *)
					#[[1]] -> (#[[2]] * Round[(1 - amountTransferred), 0.001])
				]
					&) /@ currentDestinationEHSFieldPercentages,
			Append[
				(#[[1]] -> (#[[2]] * Round[(1 - amountTransferred), 0.001])&) /@ currentDestinationEHSFieldPercentages,
				sourceEHSValue -> amountTransferred
			]
		]
	];

	(* Based on these accumulated percentages, figure out the new value of the destination's EHS field. *)
	newDestinationEHSValue=Switch[ehsField,
		(*  State has its own hierarchy: Liquid overrule Solid, then Gas if present. Assume that the sample is liquid if there is more than 10% Liquid in the sample. *)
		State,
		Which[
			And[
				MemberQ[newDestinationEHSFieldPercentages, Liquid -> GreaterP[0.]],
				Greater[
					Lookup[newDestinationEHSFieldPercentages, Liquid] / Total[{
						Lookup[newDestinationEHSFieldPercentages, Liquid, 0.],
						Lookup[newDestinationEHSFieldPercentages, Solid, 0.],
						Lookup[newDestinationEHSFieldPercentages, Gas, 0.]
					}],
					0.1`
				]
			],
			Liquid,
			MemberQ[newDestinationEHSFieldPercentages, Solid -> _],
			Solid,
			MemberQ[newDestinationEHSFieldPercentages, Gas -> _],
			Gas,
			True,
			Null
		],

		(* Simulate SampleHandling changes. *)
		(* NOTE: This should only be done for simulation purposes as we will ask the operator what the sample looks like after the transfer. *)
		SampleHandling,
		Which[
			MemberQ[newDestinationEHSFieldPercentages, Slurry -> GreaterP[.25]],
			Slurry,
			MemberQ[newDestinationEHSFieldPercentages, Viscous -> GreaterP[.25]],
			Viscous,
			MemberQ[newDestinationEHSFieldPercentages, Paste -> GreaterP[.25]],
			Paste,
			MemberQ[newDestinationEHSFieldPercentages, Liquid -> GreaterP[.25]],
			Liquid,
			MatchQ[Total[Lookup[newDestinationEHSFieldPercentages, {Liquid, Slurry, Viscous, Paste}, 0]], GreaterP[.25]],
			Slurry,
			MemberQ[newDestinationEHSFieldPercentages, Brittle -> _],
			Brittle,
			MemberQ[newDestinationEHSFieldPercentages, Powder -> _],
			Powder,
			MemberQ[newDestinationEHSFieldPercentages, Fabric -> _],
			Fabric,
			MemberQ[newDestinationEHSFieldPercentages, Fixed -> _],
			Fixed,
			True,
			Null
		],

		(* If we have any bit of Mammalian sample, it's NonMicrobial. *)
		CellType,
		Which[
			MemberQ[newDestinationEHSFieldPercentages[[All, 1]], NonMicrobialCellTypeP],
				FirstCase[newDestinationEHSFieldPercentages[[All, 1]], NonMicrobialCellTypeP],
			MemberQ[newDestinationEHSFieldPercentages[[All, 1]], MicrobialCellTypeP],
				FirstCase[newDestinationEHSFieldPercentages[[All, 1]], MicrobialCellTypeP],
			True,
				Null
		],

		(* BiosafetyLevel is just a hierarchy and doesn't care about percentages at all: *)
		BiosafetyLevel,
		FirstCase[{"BSL-4", "BSL-3", "BSL-2", "BSL-1"}, Alternatives @@ (newDestinationEHSFieldPercentages[[All, 1]]), Null],

		(* double gloved doesn't care about % and just inherits any True if present *)
		DoubleGloveRequired,
		FirstCase[newDestinationEHSFieldPercentages[[All, 1]], True, Null],

		(* PipettingMethod will take the pipetting method of the largest percentage: *)
		PipettingMethod,
		SortBy[newDestinationEHSFieldPercentages, Last][[-1]][[1]],

		(* Materials are added to the larger list if they comprise more than 5%: *)
		IncompatibleMaterials,
		Module[{combinedMaterials},
			combinedMaterials = DeleteDuplicates[Cases[Flatten[Cases[newDestinationEHSFieldPercentages, Verbatim[Rule][_, GreaterP[.05]]][[All, 1]]], Except[Null]]];
			(* If we have more than one, get rid of None: *)
			If[Length[combinedMaterials] > 1,
				Cases[combinedMaterials, Except[None]],
				combinedMaterials
			]
		],

		(* Fields that False wins out over True: *)
		Sterile|DrainDisposal|Anhydrous| AsepticHandling,
		Which[
			MemberQ[newDestinationEHSFieldPercentages,False->_],False,
			MemberQ[newDestinationEHSFieldPercentages,Null->_],Null,
			True,True
		],

		(* A drop of True will make it True: *)
		Radioactive | HazardousBan | ParticularlyHazardousSubstance | InertHandling,
		FirstCase[{True, False, Null}, Alternatives @@ (newDestinationEHSFieldPercentages[[All, 1]]), Null],

		(* Cautious 5% Threshold to make it True. *)
		Flammable | Pyrophoric | WaterReactive | ExpirationHazard | MSDSRequired | LightSensitive | GloveBoxIncompatible | GloveBoxBlowerIncompatible,
		If[MemberQ[newDestinationEHSFieldPercentages, True -> GreaterEqualP[.05]],
			True,
			SortBy[newDestinationEHSFieldPercentages, Last][[-1]][[1]]
		],

		(* Less Cautious 10% Threshold to make it True. *)
		Expires | Ventilated | Pungent | Acid | Base | Fuming | LiquidHandlerIncompatible | UltrasonicIncompatible,
		If[MemberQ[newDestinationEHSFieldPercentages, True -> GreaterEqualP[.1]],
			True,
			SortBy[newDestinationEHSFieldPercentages, Last][[-1]][[1]]
		],

		(* Fields that the Min wins out: *)
		ShelfLife | UnsealedShelfLife | ExpirationDate,
		If[!MemberQ[newDestinationEHSFieldPercentages[[All, 1]], _?DateObjectQ],
			Null,
			Min[Cases[newDestinationEHSFieldPercentages[[All, 1]], _?DateObjectQ]]
		],

		(* Fields that get Nulled if there are competing values: *)
		MSDSFile | DOTHazardClass | NFPA | TransportTemperature,
		If[Length[newDestinationEHSFieldPercentages] > 1,
			Null,
			FirstOrDefault[FirstOrDefault[newDestinationEHSFieldPercentages]]
		],

		(* Do NOT alter the StorageCondition. *)
		StorageCondition,
		destinationEHSValue,

		(* Catch all *)
		_,
		SortBy[newDestinationEHSFieldPercentages, Last][[-1]][[1]]
	];

	(* Return the new value and the new cache. *)
	{
		newDestinationEHSValue,

		(* Add the new destination packet. *)
		Append[
			(* Remove the old destination packet from the cache. *)
			deleteCachePacket[existingCache, destinationObject],
			Append[
				destinationPacket,
				{
					EHSPercentages -> Append[
						DeleteCases[
							destinationEHSPercentages,
							Verbatim[Rule][ehsField, _]
						],
						ehsField -> newDestinationEHSFieldPercentages
					],
					ehsField -> newDestinationEHSValue
				}
			]
		]
	}
];

(* version to work on all fields at once *)
(* NOTE: The output of this version is different as we need to return not one value but values for all fields. *)
(* NOTE: The existing cache is NOT a traditional object cache but has the added field EHSPercentages. *)
(* NOTE: transferAmount and destinationAmount must match. *)
combineEHSFields[ehsFields_List, sourceObject:ObjectP[], destinationObject:ObjectP[], transferAmount:(MassP | VolumeP), destinationAmount:(MassP | VolumeP), existingCache_List]:=Module[
	{sourcePacket, destinationPacket, destinationEHSPercentages,
		amountTransferred, newDestinationEHSValuesRules, newDestinationEHSPercentagesRules},

	(* Get our source and destination objects from our cache.*)
	sourcePacket=FirstCase[existingCache, KeyValuePattern[Object -> Download[sourceObject, Object]]];
	destinationPacket=FirstCase[existingCache, KeyValuePattern[Object -> Download[destinationObject, Object]]];

	(* NOTE: We assume that the parent function passes down these in the same units.*)
	amountTransferred=Which[
		MatchQ[QuantityMagnitude[destinationAmount], 0 | 0.],
		1,

		MatchQ[destinationAmount, VolumeP] && MatchQ[transferAmount, VolumeP],
		N[transferAmount / (transferAmount + destinationAmount)],

		MatchQ[destinationAmount, MassP] && MatchQ[transferAmount, MassP],
		N[transferAmount / (transferAmount + destinationAmount)],

		MatchQ[destinationAmount, VolumeP] && MatchQ[transferAmount, MassP],
		If[MatchQ[Lookup[sourcePacket, Density], DensityP],
			N[(transferAmount / Lookup[sourcePacket, Density]) / ((transferAmount / Lookup[sourcePacket, Density]) + destinationAmount)],
			N[(transferAmount / Quantity[0.997`, ("Grams") / ("Milliliters")]) / ((transferAmount / Quantity[0.997`, ("Grams") / ("Milliliters")]) + destinationAmount)]
		],

		MatchQ[destinationAmount, MassP] && MatchQ[transferAmount, VolumeP],
		If[MatchQ[Lookup[sourcePacket, Density], DensityP],
			N[(transferAmount * Lookup[sourcePacket, Density]) / ((transferAmount * Lookup[sourcePacket, Density]) + destinationAmount)],
			N[(transferAmount * Quantity[0.997`, ("Grams") / ("Milliliters")]) / ((transferAmount * Quantity[0.997`, ("Grams") / ("Milliliters")]) + destinationAmount)]
		],

		True,
		1
	];

	(* Get the percentages of destination EHS Fields. We only really care about the destination since the*)
	(* transfer is from the source -> destination.*)
	destinationEHSPercentages=Lookup[destinationPacket, EHSPercentages, {}];

	(* Form Field -> Value rules for the new values *)
	{newDestinationEHSValuesRules, newDestinationEHSPercentagesRules}=Transpose[
		Map[
			Function[{field},
				Module[{sourceEHSValue, destinationEHSValue, currentDestinationEHSFieldPercentages, newDestinationEHSFieldPercentages, newDestinationEHSValue},
					(* Get the existing value of the EHS Field from our source and destination packet. *)
					(* NOTE: If SampleHandling is Null, but the sample/model is a liquid, will use Liquid handling. Otherwise adding a liquid to a solid will result in solid handling. *)
					sourceEHSValue = If[
						And[
							MatchQ[Lookup[sourcePacket, Object], ObjectP[{Object[Sample], Model[Sample]}]],
							MatchQ[field, SampleHandling],
							MatchQ[Lookup[sourcePacket, field], Null],
							MatchQ[Lookup[sourcePacket, State], Liquid]
						],
						Liquid,
						Lookup[sourcePacket, field]
					];
					destinationEHSValue = If[
						And[
							MatchQ[Lookup[destinationPacket, Object], ObjectP[{Object[Sample], Model[Sample]}]],
							MatchQ[field, SampleHandling],
							MatchQ[Lookup[destinationPacket, field], Null],
							MatchQ[Lookup[destinationPacket, State], Liquid]
						],
						Liquid,
						Lookup[destinationPacket, field]
					];


					(* If we don't have any destination percentages, assume that the percentage of the field value is 100%,*)
					(* aka, it's just given to us as the sample currently.*)
					(* NOTE: All of these percentages are RangeP[0,1] and don't have a Percent unit on them.*)
					currentDestinationEHSFieldPercentages=If[!KeyExistsQ[destinationEHSPercentages, field],
						(* NOTE : We flatten out the field IncompatibleMaterials into its own materials.*)
						If[MatchQ[field, IncompatibleMaterials],
							(# -> 1&) /@ ToList[destinationEHSValue],
							{destinationEHSValue -> 1}
						],
						Lookup[destinationEHSPercentages, field]
					];

					(* Update the safety percentages.*)

					(* If we already have some percentage of sourceEHSValue in our destination, we don't have to append it.*)
					(* NOTE: We flatten out the field IncompatibleMaterials into its own materials.*)
					newDestinationEHSFieldPercentages=If[MatchQ[field, IncompatibleMaterials],
						If[MemberQ[currentDestinationEHSFieldPercentages, Alternatives @@ sourceEHSValue -> _],
							(
								If[MatchQ[#[[1]], Alternatives @@ ToList[sourceEHSValue]],
									#[[1]] -> #[[2]] + amountTransferred * (1 - #[[2]]),
									#[[1]] -> (#[[2]] * Round[(1 - amountTransferred), 0.001])
								]
									&) /@ currentDestinationEHSFieldPercentages,
							Join[
								(#[[1]] -> (#[[2]] * Round[(1 - amountTransferred), 0.001])&) /@ currentDestinationEHSFieldPercentages,
								(# -> amountTransferred&) /@ ToList[sourceEHSValue]
							]
						],
						If[MemberQ[currentDestinationEHSFieldPercentages, sourceEHSValue -> _],
							(
								If[MatchQ[#[[1]], sourceEHSValue],
									#[[1]] -> #[[2]] + amountTransferred * (1 - #[[2]]),
									#[[1]] -> (#[[2]] * Round[(1 - amountTransferred), 0.001])
								]
									&) /@ currentDestinationEHSFieldPercentages,
							Append[
								(#[[1]] -> (#[[2]] * Round[(1 - amountTransferred), 0.001])&) /@ currentDestinationEHSFieldPercentages,
								sourceEHSValue -> amountTransferred
							]
						]
					];

					(* Based on these accumulated percentages, figure out the new value of the destination's EHS field.*)
					newDestinationEHSValue=Switch[field,
						(* Solid and Liquid overrule Gas if present. Assume that the sample is liquid if there is more than 10% Liquid in the sample.*)
						State,
						Which[
							And[
								MemberQ[newDestinationEHSFieldPercentages, Liquid -> GreaterP[0.]],
								Greater[
									Lookup[newDestinationEHSFieldPercentages, Liquid] / Total[{
										Lookup[newDestinationEHSFieldPercentages, Liquid, 0.],
										Lookup[newDestinationEHSFieldPercentages, Solid, 0.],
										Lookup[newDestinationEHSFieldPercentages, Gas, 0.]
									}],
									0.1`
								]
							],
							Liquid,
							MemberQ[newDestinationEHSFieldPercentages, Solid -> _],
							Solid,
							MemberQ[newDestinationEHSFieldPercentages, Gas -> _],
							Gas,
							True,
							Null
						],

						(* Simulate SampleHandling changes.*)
						(* NOTE: This should only be done for simulation purposes as we will ask the operator what the sample looks like after the transfer.*)
						SampleHandling,
						Which[
							MemberQ[newDestinationEHSFieldPercentages, Slurry -> GreaterP[.25]],
							Slurry,
							MemberQ[newDestinationEHSFieldPercentages, Viscous -> GreaterP[.25]],
							Viscous,
							MemberQ[newDestinationEHSFieldPercentages, Paste -> GreaterP[.25]],
							Paste,
							MemberQ[newDestinationEHSFieldPercentages, Liquid -> GreaterP[.25]],
							Liquid,
							MatchQ[Total[Lookup[newDestinationEHSFieldPercentages, {Liquid, Slurry, Viscous, Paste}, 0]], GreaterP[.25]],
							Slurry,
							MemberQ[newDestinationEHSFieldPercentages, Brittle -> _],
							Brittle,
							MemberQ[newDestinationEHSFieldPercentages, Powder -> _],
							Powder,
							MemberQ[newDestinationEHSFieldPercentages, Fabric -> _],
							Fabric,
							MemberQ[newDestinationEHSFieldPercentages, Fixed -> _],
							Fixed,
							True,
							Null
						],

						(* If we have any bit of NonMicrobial sample, it's NonMicrobial. *)
						CellType,
						Which[
							MemberQ[newDestinationEHSFieldPercentages[[All, 1]], NonMicrobialCellTypeP],
								FirstCase[newDestinationEHSFieldPercentages[[All, 1]], NonMicrobialCellTypeP],
							MemberQ[newDestinationEHSFieldPercentages[[All, 1]], MicrobialCellTypeP],
								FirstCase[newDestinationEHSFieldPercentages[[All, 1]], MicrobialCellTypeP],
							True,
								Null
						],

						(* BiosafetyLevel is just a hierarchyand doesn't care about percentages at all:*)
						BiosafetyLevel,
						FirstCase[{"BSL-4", "BSL-3", "BSL-2", "BSL-1"}, Alternatives @@ (newDestinationEHSFieldPercentages[[All, 1]]), Null],
						
						(* double gloved doesn't care about % and just inherits any True if present *)
						DoubleGloveRequired,
						FirstCase[newDestinationEHSFieldPercentages[[All, 1]], True, Null],

						(* PipettingMethod will take the pipetting method of the largest percentage:*)
						PipettingMethod,
						SortBy[newDestinationEHSFieldPercentages, Last][[-1]][[1]],

						(* Materials are added to the larger list if they comprise more than 5%:*)
						IncompatibleMaterials,
						Module[{combinedMaterials},
							combinedMaterials=DeleteDuplicates[Cases[Flatten[Cases[newDestinationEHSFieldPercentages, Verbatim[Rule][_, GreaterP[.05]]][[All, 1]]], Except[Null]]];
							(* If we have more than one, get rid of None: *)
							If[Length[combinedMaterials] > 1,
								Cases[combinedMaterials, Except[None]],
								combinedMaterials
							]
						],

						(* A drop of False or Null will make it False/Null. If both components are sterile then keep it True *)
						Sterile|DrainDisposal|Anhydrous|AsepticHandling,
						Which[
							MemberQ[newDestinationEHSFieldPercentages,False->_],False,
							MemberQ[newDestinationEHSFieldPercentages,Null->_],Null,
							True,True
						],

						(* A drop of True will make it True:*)
						Radioactive | HazardousBan | ParticularlyHazardousSubstance | InertHandling,
						FirstCase[{True, False, Null}, Alternatives @@ (newDestinationEHSFieldPercentages[[All, 1]]), Null],

						(* Cautious 5% Threshold to make it True.*)
						Flammable | Pyrophoric | WaterReactive | ExpirationHazard | MSDSRequired | LightSensitive | GloveBoxIncompatible | GloveBoxBlowerIncompatible,
						If[MemberQ[newDestinationEHSFieldPercentages, True -> GreaterEqualP[.05]],
							True,
							SortBy[newDestinationEHSFieldPercentages, Last][[-1]][[1]]
						],

						(* Less Cautious 10% Threshold to make it True.*)
						Expires | Ventilated | Pungent | Acid | Base | Fuming | LiquidHandlerIncompatible | UltrasonicIncompatible,
						If[MemberQ[newDestinationEHSFieldPercentages, True -> GreaterEqualP[.1]],
							True,
							SortBy[newDestinationEHSFieldPercentages, Last][[-1]][[1]]
						],

						(* Fields that the Min wins out:*)
						ShelfLife | UnsealedShelfLife | ExpirationDate,
						If[!MemberQ[newDestinationEHSFieldPercentages[[All, 1]], _?DateObjectQ],
							Null,
							Min[Cases[newDestinationEHSFieldPercentages[[All, 1]], _?DateObjectQ]]
						],

						(* Fields that get Nulled if there are competing values:*)
						MSDSFile | DOTHazardClass | NFPA | TransportTemperature,
						If[Length[newDestinationEHSFieldPercentages] > 1,
							Null,
							FirstOrDefault[FirstOrDefault[newDestinationEHSFieldPercentages]]
						],

						(* Do NOT alter the StorageCondition.*)
						StorageCondition,
						destinationEHSValue,

						(* Catch all*)
						_,
						SortBy[newDestinationEHSFieldPercentages, Last][[-1]][[1]]
					];

					{
						Rule[field, newDestinationEHSValue],
						Rule[field, newDestinationEHSFieldPercentages]
					}
				]
			],
			ehsFields
		]
	];

	(* I want this outside of the MapThread and fields should be checked if I am modifying them*)

	(*	 Return the association of new values and the new cache.*)
	{
		newDestinationEHSValuesRules,

		(* Add the new destination packet.*)
		Append[
			(* Remove the old destination packet from the cache.*)
			deleteCachePacket[existingCache, destinationObject],
			Append[
				destinationPacket,
				<|
					EHSPercentages -> Join[
						DeleteCases[
							destinationEHSPercentages,
							Verbatim[Rule][Alternatives @@ ehsFields, _]
						],
						newDestinationEHSPercentagesRules
					],
					Association[newDestinationEHSValuesRules]
				|>
			]
		]
	}
];

(* deleting packet from the cache *)
deleteCachePacket[cache_List, object_]:=Module[{objects, associationFiltered, association},
	(* grab the list of objects that we have in this cache *)
	objects=Lookup[cache, Object];

	(* make an association Object->Packet *)
	association=Association[MapThread[Rule[#1, #2] &, {objects, cache}]];

	(*drop the packet for the object*)
	associationFiltered=KeyDrop[association, Download[object, Object]];

	(*return cache without the packet*)
	Values[associationFiltered]
];

(* approximate density from composition *)
(* overload with 2 volumes passed in *)
approximateDensity[compositionTuples:{{VolumeP, PacketP[] | Null}..}]:=Module[
	{volumes, totalVolume, volumePercents, newTuples},
	volumes = compositionTuples[[All,1]];
	totalVolume = Total[volumes];
	volumePercents = If[totalVolume == 0 Liter,
		ConstantArray[0 VolumePercent, Length[volumes]],
		(# * VolumePercent / totalVolume)& /@ volumes
	];
	newTuples = Transpose@{volumePercents, compositionTuples[[All,2]]};
	approximateDensity[newTuples]
];

(* core overload *)
approximateDensity[compositionTuples:{{CompositionP | Null, PacketP[] | Null}..}]:=Module[{initialList, filteredList, initialContributions, scalingFactor, densities},
	initialList=Map[
		{
			#[[1]],
			Lookup[#[[2]], Density, Quantity[0.997`, "Grams" / "Liters"]],
			#[[2]]
		}&,
		compositionTuples
	];

	(* remove any Nulls and items of low concentration since they don't affect density much *)
	filteredList=DeleteCases[initialList,
		_?(MatchQ[First@#,
			Alternatives[
				Null,
				LessP[Quantity[5.`, "MassPercent"]],
				LessP[Quantity[5.`, "VolumePercent"]],
				LessP[Quantity[0.5`, "Moles" / "Liters"]],
				LessP[Quantity[10.`, "Grams" / "Liters"]],
				(_?QuantityQ | _?NumericQ)?PercentConfluencyQ
			]]&)];

	(* we are doing something shady here - we assume that we have 1kg and 1L of our mixture. This is not true,
	but we will get rid of the units this way and hopefully will be not completely off from the target density *)
	initialContributions=(Switch[#[[1]],
		(_?QuantityQ | _?NumericQ)?ConcentrationQ, UnitConvert[#[[1]], "Moles" / "Liters"] * Lookup[#[[3]], MolecularWeight] * Quantity[1.`, "Liters"] / Quantity[1.`, "Kilograms"],
		(_?QuantityQ | _?NumericQ)?MassConcentrationQ, UnitConvert[#[[1]], "Grams" / "Liters"] * Quantity[1.`, "Liters"] / Quantity[1.`, "Kilograms"],
		(_?QuantityQ | _?NumericQ)?VolumePercentQ, #[[1]] / (100 * VolumePercent) * If[MatchQ[Lookup[#[[3]], Density], DensityP], Lookup[#[[3]], Density], Quantity[0.997`, ("Grams") / ("Milliliters")]] * Quantity[1.`, "Liters"] / Quantity[1.`, "Kilograms"],
		(* we already have mass %, great *)
		(_?QuantityQ | _?NumericQ)?MassPercentQ, #[[1]] / (100 * MassPercent)
	])& /@ filteredList;

	(* make a scaling factor - by how much we need to multiply the # we have to get total of 100% *)
	scalingFactor=If[MatchQ[initialContributions, Null | {EqualP[0]...}], 1 , 1 / Total[initialContributions]];

	(* density of the identity models in use *)
	densities=Map[If[CompatibleUnitQ[Lookup[#, Density], "Grams" / "Liters"], Lookup[#, Density], Quantity[0.997`, ("Grams") / ("Milliliters")]]&, filteredList[[All, 3]]];

	(* return density *)
	If[
		MatchQ[densities, {}] || MatchQ[initialContributions, {EqualP[0]...}],
		Quantity[0.997`, ("Grams") / ("Milliliters")],
		UnitConvert[Total[MapThread[(#1 * scalingFactor * #2)&, {initialContributions, densities}]], "Grams" / "Liters"]]
];

DefineOptions[
	ValidObjectQMessages,
	Options :> {
		OutputOption
	}
];

(* Run VOQ tests, throwing messages instead of failing tests *)
ValidObjectQMessages[myInput_, newPacket:PacketP[], myOptions_, funcOptions:OptionsPattern[]]:=Module[
	{myType, fullChangePacket, originalPacket, nonChangePacket, packetWithoutRuleDelayed, packetTests, voqResult, failedTestSummaries, failedTestDescriptions, passedQ},

	myType=Lookup[newPacket, Type];

	(* Overwrite the Object key if our object already exists. *)
	fullChangePacket=If[MatchQ[myInput, ObjectP[myType]],
		Append[newPacket, Object -> Download[myInput, Object]],
		Append[newPacket, Object -> CreateID[myType]]
	];

	(* Strip off our change heads (Replace/Append) so that we can pretend that this is a real object so that we can call VOQ on it. *)
	(* This includes all fields to the packet as Null/{} if they weren't included in the change packet. *)
	(* If we had a previously existing packet, we merge that packet with our packet. *)

	originalPacket=If[MatchQ[myInput, ObjectP[]],
		Experiment`Private`fetchPacketFromCache[myInput, Lookup[ToList[myOptions], Cache]]
	];

	nonChangePacket=If[MatchQ[originalPacket, PacketP[]],
		stripChangePacket[fullChangePacket, ExistingPacket -> originalPacket],
		stripChangePacket[Append[fullChangePacket, Type -> myType]]
	];

	(* Get rid of any delayed rules so that we don't double upload. *)
	packetWithoutRuleDelayed=Association[Cases[Normal[nonChangePacket], Except[_RuleDelayed]]];

	(* Call VOQ, catch the messages that are thrown so that we know the corresponding InvalidOptions message to throw. *)
	packetTests=ValidObjectQ`Private`testsForPacket[packetWithoutRuleDelayed];

	(* Get the VOQ results *)
	voqResult=Block[{ECL`$UnitTestMessages=True},
		RunUnitTest[<|"Function" -> packetTests|>, OutputFormat -> TestSummary, Verbose -> False]
	];

	(* Get the test summaries for the failed tests *)
	failedTestSummaries=Flatten[Lookup[First[Lookup[voqResult, "Function"]], {ResultFailures, MessageFailures}]];

	(* Get the descriptions from failed tests *)
	failedTestDescriptions=Lookup[First /@ failedTestSummaries, Description];

	(* VOQ passes if we didn't have any messages thrown *)
	passedQ=Lookup[voqResult, "Function"][Passed];

	OptionValue[Output] /. {Result -> {passedQ, failedTestDescriptions}, Tests -> packetTests}
];

(* Authors definition for ExternalUpload`Private`approximateDensity *)
Authors[ExternalUpload`Private`approximateDensity]:={"dima", "steven", "simon.vu"};
