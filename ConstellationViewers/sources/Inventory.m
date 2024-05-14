DefineOptions[
	PlotInventory,
	Options :> {
		{OutputFormat -> Table, _String | Table, "Determine whether to export the data as a Table or a File."}
	}
];

(* Plot the full inventory dashboard *)
PlotInventory[ops:OptionsPattern[]]:=PlotInventory[Null, ops];

(* Plot the inventory dashboard for a single notebook *)
PlotInventory[notebook:ObjectP[Object, LaboratoryNotebook], ops:OptionsPattern[]]:=PlotInventory[{notebook}, ops];

(* Plot the inventory dashboard for a list of notebooks *)
PlotInventory[notebooks:{(ObjectP[Object, LaboratoryNotebook]|Null)..} | Null, ops:OptionsPattern[]]:=Module[
	{safeOps, outputFormat, inventoryJSON, tableResult},
	(* Grab the options *)
	safeOps=SafeOptions[PlotFavoriteFolder, ToList[ops]];

	(* Figure out the desired output format *)
	outputFormat=Lookup[safeOps, OutputFormat];

	(* Make a call to the dashboard endpoint *)
	inventoryJSON=inventoryDashboardJSON[notebooks, OutputFormat->Association];

	(* Exit early if something went wrong *)
	If[!AssociationQ[inventoryJSON], Return[$Failed]];

	(* Convert the results into a pretty table *)
	tableResult=inventoryTableFromJSON[inventoryJSON];

	(* Print/Export the results as appropriate *)
	Switch[outputFormat,
		Table, TableForm[tableResult, TableHeadings -> {None, {"Inventory Object", "Model", "Amount", "Threshold", "Reorder", "Restockings"}}],
		_String, Export[outputFormat, Prepend[tableResult, {"Inventory Object", "Model", "Amount", "Threshold", "Reorder", "Restockings"}]]
	]
];

(* Plot the inventory dashboard doing a search on name *)
PlotInventory[searchTerm_String, ops:OptionsPattern[]]:=PlotInventory[Null, searchTerm, ops];

(* Plot the inventory dashboard for a single notebook doing a search on name *)
PlotInventory[notebook:ObjectP[Object, LaboratoryNotebook], searchTerm_String, ops:OptionsPattern[]]:=PlotInventory[{notebook}, searchTerm, ops];

(* Plot the inventory dashboard for a list of notebooks, doing a search on name *)
PlotInventory[notebooks:{(ObjectP[Object, LaboratoryNotebook]|Null)..} | Null, searchTerm_String, ops:OptionsPattern[]]:=Module[
	{safeOps, outputFormat, inventoryJSON, tableResult},
	(* Grab the options *)
	safeOps=SafeOptions[PlotInventory, ToList[ops]];

	(* Figure out the desired output format *)
	outputFormat=Lookup[safeOps, OutputFormat];

	(* Make a call to the dashboard endpoint *)
	inventoryJSON=inventoryDashboardJSON[notebooks, searchTerm, OutputFormat->Association];

	(* Exit early if something went wrong *)
	If[!AssociationQ[inventoryJSON], Return[$Failed]];

	(* Convert the results into a pretty table *)
	tableResult=inventoryTableFromJSON[inventoryJSON];

	(* Print/Export the results as appropriate *)
	Switch[outputFormat,
		Table, TableForm[tableResult, TableHeadings -> {None, {"Inventory Object", "Model", "Amount", "Threshold", "Reorder", "Restockings"}}],
		_String, Export[outputFormat, Prepend[tableResult, {"Inventory Object", "Model", "Amount", "Threshold", "Reorder", "Restockings"}]]
	]
];

DefineOptions[
	inventoryDashboardJSON,
	Options :> {
		{OutputFormat -> String, String | Association, "Determine whether to output the result as a String or an Association."}
	}
];

(* Generate the JSON for the dashboard from the constellation endpoint *)
inventoryDashboardJSON[notebooks:{(ObjectP[Object, LaboratoryNotebook]|Null)..} | Null, ops:OptionsPattern[]]:=Module[
	{safeOps, outputFormat, notebookIds, includePublicObjects, response, associationResult},

	(* Grab the options *)
	safeOps=SafeOptions[inventoryDashboardJSON, ToList[ops]];

	(* Figure out the desired output format *)
	outputFormat=Lookup[safeOps, OutputFormat];

	(* Grab the notebook ids - note that passing Null means you want objects with notebook == null, so you have to be a bit clever *)
	notebookIds=If[NullQ[notebooks], {}, Download[Select[notebooks, !NullQ[#]&], ID]];

	(* Check if we should include public objects, which is indicated by having a null in the list of notebooks *)
	includePublicObjects=MemberQ[notebooks, Null];

	(* Call the endpoint *)
	response=ConstellationRequest[<|
		"Path" -> "obj/get-inventory-dashboard",
		"Method" -> "POST",
		"Body" -> <|
			"notebooks" -> notebookIds,
			"include_public_objects" -> includePublicObjects
		|>
	|>];

	(* Return early if something is wrong *)
	If[!AssociationQ[response], Return[$Failed]];

	(* Parse it! *)
	associationResult=parseInventoryDashboardResponse[response];

	(* Return the correct format *)
	If[MatchQ[outputFormat, String], ExportAssociationToJSON[associationResult], associationResult]
];

(* Generate the JSON for the dashboard when searching from the constellation endpoint *)
inventoryDashboardJSON[notebooks:{(ObjectP[Object, LaboratoryNotebook]|Null)..} | Null, searchTerm_String, ops:OptionsPattern[]]:=Module[
	{safeOps, outputFormat, notebookIds, includePublicObjects, response, associationResult},

	(* Grab the options *)
	safeOps=SafeOptions[inventoryDashboardJSON, ToList[ops]];

	(* Figure out the desired output format *)
	outputFormat=Lookup[safeOps, OutputFormat];

	(* Grab the notebook ids - note that passing Null means you want objects with notebook == null, so you have to be a bit clever *)
	notebookIds=If[NullQ[notebooks], {}, Download[Select[notebooks, !NullQ[#]&], ID]];

	(* Check if we should include public objects, which is indicated by having a null in the list of notebooks *)
	includePublicObjects=MemberQ[notebooks, Null];

	(* Call the endpoint *)
	response=ConstellationRequest[<|
		"Path" -> "obj/search-inventory-by-name",
		"Method" -> "POST",
		"Body" -> <|
		  "notebooks" -> notebookIds,
			"name" -> searchTerm,
			"include_public_objects"->includePublicObjects
		|>
	|>];

	(* Return early if something is wrong *)
	If[!AssociationQ[response], Return[$Failed]];

	(* Parse it! *)
	associationResult=parseInventoryDashboardResponse[response];

	(* Return the correct format *)
	If[MatchQ[outputFormat, String], ExportAssociationToJSON[associationResult], associationResult]
];

(* Parse the inventory dashboard - the main thing we have to do is convert the variable units into mathematica objects *)
parseInventoryDashboardResponse[response_Association]:=Module[
	{parsedResponse, results},

	(* Copy over the existing response as we'll replace in place *)
	parsedResponse=response;

	(* Retrieve the results from the response *)
	results=Lookup[response, "results", {}];

	(* Parse the results *)
	parsedResponse[["results"]] = If[MatchQ[Null, results], {}, parseInventoryDashboardResponseResult /@ results];

	(* If we have a list of lists (remaining from site grouping), flatten to a single list of sections.
		 We also have to merge sections with the same model name but different site.
	   When the old spec is completely not supported, this can be removed. *)
	If[
		AllTrue[ListQ]@parsedResponse[["results"]],
		parsedResponse[["results"]] = Flatten[parsedResponse[["results"]]];
		(* Gather equivalent sections by their name *)
		parsedResponse[["results"]] = GatherBy[parsedResponse[["results"]], #[["section_name"]]&];
		(* Merge the rows of equivalent sections together *)
		parsedResponse[["results"]] = Map[Fold[Function[{acc, section}, Module[{newAcc, rows},
			newAcc = acc;
			rows = newAcc[["rows"]];
			rows = Join[rows, section[["rows"]]];
			newAcc[["rows"]] = rows;
			newAcc
		]], #]&, parsedResponse[["results"]]];
	];

	(* return the parsed response *)
	parsedResponse
];

(* Parse an individual result in the inventory dashboard response *)
parseInventoryDashboardResponseResult[resultResponse_Association] := Module[
	{isOldSpec},

	(* Determine if using the old spec (group sections here by site) or new spec (site is a field later on) *)
	isOldSpec = KeyExistsQ[resultResponse, "site"] && KeyExistsQ[resultResponse, "sections"];

	(* If we're using the old spec, convert to the new format while parsing each site *)
	If[isOldSpec,
		Return[parseInventoryDashboardResponseSite[resultResponse]]
	];

	(* Otherwise, each result can be directly parsed as a section *)
	parseInventoryDashboardResponseSection[resultResponse]
];

(* Parse an individual site in the inventory dashboard response, converting old to new spec.
	 When the old spec is completely not supported, this can be removed. *)
parseInventoryDashboardResponseSite[siteResponse_Association]:=Module[
	{parsedSiteResponse, parsedSectionsResponse, siteName, sections, newRows},

	(* Copy over the existing response as we'll replace in place *)
	parsedSiteResponse=siteResponse;

	(* Get the name of the site *)
	siteName = Lookup[siteResponse, "site"];

	(* Retrieve the sections from the site response *)
	sections=Lookup[siteResponse, "sections", {}];

	(* Parse each section properly *)
	parsedSectionsResponse = parseInventoryDashboardResponseSection /@ sections;

	(* Finally, insert the site as a field of each row within the parsed site *)
	parsedSectionsResponse = Function[section, Module[{rows, newSection},
		rows = Function[row, Module[{newRow},
			newRow = row;
			newRow[["site"]] = siteName;
			newRow
		]] /@ Lookup[section, "rows", {}];
		newSection = section;
		newSection[["rows"]] = rows;
		newSection
	]] /@ parsedSectionsResponse;

	(* Return the parsed sections at the proper level of nesting *)
	parsedSectionsResponse
];

(* Parse an individual section in the inventory dashboard response *)
parseInventoryDashboardResponseSection[sectionResponse_Association]:=Module[
	{parsedSectionResponse, rows},

	(* Copy over the existing response as we'll replace in place *)
	parsedSectionResponse=sectionResponse;

	(* If the section has a "name" field, update it to be "section_name" to match new spec
	   When the old spec is completely not supported, this can be removed. *)
	If[KeyExistsQ[parsedSectionResponse, "name"],
		Module[{},
			parsedSectionResponse[["section_name"]] = parsedSectionResponse[["name"]];
			parsedSectionResponse = KeyDrop[parsedSectionResponse, "name"];
		]
	];

	(* Retrieve the rows from the section response *)
	rows=Lookup[sectionResponse, "rows", {}];

	parsedSectionResponse[["rows"]]=parseInventoryDashboardResponseRow /@ rows;

	(* Return the parsed response *)
	parsedSectionResponse
];

(* Parse an individual row in the inventory dashboard response *)
parseInventoryDashboardResponseRow[rowResponse_Association]:=Module[
	{parsedRow, amount, threshold, reorderAmount},

	(* Copy over the existing response as we'll replace in place *)
	parsedRowResponse=rowResponse;

	(* Convert the threshold, amount, and reorder amount to a correctly quantified value *)
	threshold=ToExpression[Lookup[rowResponse, "threshold", Null]];
	amount=ToExpression[Lookup[rowResponse, "amount", Null]];
	reorderAmount=ToExpression[Lookup[Lookup[rowResponse, "reorder", {}], "amount", Null]];

	(* Generate whether or not the current amount should be emphasized - note this should fail off, where if we weren't able to pull either amount its not emphasized *)
	parsedRowResponse[["requires_restocking"]]=Quiet[TrueQ[threshold > amount], Greater::nordq];

	(* Convert the variable unit fields into human readable strings *)
	parsedRowResponse[["threshold"]]=toStringVariableUnit[threshold];
	parsedRowResponse[["amount"]]=toStringVariableUnit[amount];

	(* Also convert the reorder amount, but only if the reorder section exists *)
	If[
		AssociationQ[Lookup[rowResponse, "reorder", Null]],
		parsedRowResponse[["reorder"]][["amount"]]=toStringVariableUnit[reorderAmount]
	];

	(* Return the parsed response *)
	parsedRowResponse
];

(* Convert the inventory JSON into a prettier table form *)
inventoryTableFromJSON[inventoryJSON_Association]:=Module[
	{allSections, allRows},

	(* Collapse all the sections  *)
	allSections=Flatten[Lookup[inventoryJSON, "results", {}]];

	(* Collapse all the rows - ignore section information for now *)
	allRows=Flatten[Map[Lookup[#, "rows", {}] &, allSections]];

	(* Map each row in the dashboard to a row in the table *)
	Map[
		{
			namedObjectReferenceToObject[Lookup[#, "inventory_object", Null]],
			namedObjectReferenceToObject[Lookup[#, "model", {}]],
			Lookup[#, "amount", ""],
			Lookup[#, "threshold", ""],
			reorderString[Lookup[#, "reorder", {}]],
			restockingString[Lookup[#, "restockings", {}], Lookup[#, "requires_restocking", False]]
		} &,
		allRows
	]
];

(* Convert a row response from constellation to the user facing reorder string *)
reorderString[reorderInfo_Association]:=Module[
	{reorderAmount, reorderObject, expirationString},

	(* figure out the reorder amount *)
	reorderAmount=Lookup[reorderInfo, "amount", Null];

	(* figure out the reorder object *)
	reorderObject=Lookup[reorderInfo, "object_to_reorder", Null];

	(* figure out whether or the object expires *)
	expirationString=If[TrueQ[Lookup[reorderInfo, "reorder_when_expired", False]], ", Reorder when expired", ""];

	(* only display anything if you could figure out both the amount and the object - its better to not show it than show something garbled *)
	If[NullQ[reorderAmount] || NullQ[reorderObject], "", StringJoin[reorderAmount, " of ", namedObjectReferenceToObject[reorderObject], expirationString]]
];

(* Convert a row response from constellation to the user facing restocking string *)
restockingString[restockingInfo_Association, requiresRestocking:BooleanP]:=Module[
	{restockingObjects},

	(* find all the restocking objects *)
	restockingObjects=namedObjectReferenceToObject /@ Lookup[restockingInfo, "orders", {}];

	(* If there were restockings return that - if there are no restockings and restockings is required, return pending *)
	If[
		Length[restockingObjects] > 0,
		StringRiffle[restockingObjects, ", "],
		If[TrueQ[requiresRestocking], "Pending", ""]
	]
];

(* Convert variable units to a human readable string, addressing weirdness with unity/unities and excessive decimal places *)
toStringVariableUnit[value_Quantity]:=If[MatchQ[value, UnitsP[Unit]], ToString[Unitless[value]], ToString[NumberForm[UnitScale[value], {Infinity, 1}]]];

(* Convert a object reference association that may or may not have a name to an object *)
namedObjectReferenceToObject[Null]:=Null;
namedObjectReferenceToObject[objectRef_Association]:=Module[
	{name, type, idString},

	(* Grab and convert the type *)
	type=Constellation`Private`stringToType[Lookup[objectRef, "type", ""]];

	(* In some rare cases the type cannot be determined *)
	If[MatchQ[type, $Failed], Return[$Failed]];

	(* Grab the name *)
	name=Lookup[objectRef, "name", ""];

	(* Grab the id *)
	idString=Lookup[objectRef, "id", ""];

	(* if the name exists, use that - if not, use the id *)
	If[!MatchQ[name, ""], ToString[Append[type, name]], ToString[Append[type, idString]]]
];
