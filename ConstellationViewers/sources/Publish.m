(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection::Closed:: *)
(*Publish*)

(* Publish is the public version of publishing to the web.  It has three major overloads:
  1. A notebook - this generates an html renderable overview of what's in the notebook and who created it
  2. A notebookPage - this generates an html renderable view of the notebook page.
  3. Any other object - this generates an html renderable version of Inspect of the object

  Note that there are another set of PublishX functions in SyncDocumentation that are used to
  publish helpfiles for things.
*)

(* The base url where all of the published objects are found on the web *)
baseUrl = "https://www.emeraldcloudlab.com/documentation/publish/";

(* This keeps track of the linked objects that are seen while walking through the publications
   process.  I generally try to avoid global variables link this, but this was measured to be significantly
  faster than reparsing or building a large tree [5.5 seconds vs 7.5 seconds on a reasonable sized object,
  which adds up considerably when publishing a notebook with many objects.].  If you can come up with a faster
  way to do this, please do so! *)
$linkedObjects = {};

Publish::NotLoggedIn="You cannot publish anything because you are not logged in.  Please Login[] and try again."
Publish::NotOnProduction="You are not running on Production, which means that Publish[] will run, but will not actually publish anything to the web.  Please Login[] to Production and try again."

(* Publish a notebook object - we need to do two things:
   1) Convert the notebook into json for our display on the web
   2) Publish everything inside the notebook
*)
Publish[notebook:ObjectP[Object[LaboratoryNotebook]]] := Module[
  {workDir, uploadResults, publishResults},

  (* Check if you're logged in *)
  If[!Constellation`Private`loggedInQ[],
		Message[Publish::NotLoggedIn];
		Return[$Failed]
	];

  (* Make sure you're on production, as otherwise items won't appear on the web *)
  If[!MatchQ[Global`$ConstellationDomain, Constellation`Private`ConstellationDomain[Production]],
    Message[Publish::NotOnProduction];
  ];

  (* make a directory to work in *)
  workDir = FileNameJoin[{$TemporaryDirectory, "ECL", CreateUUID[]}];

  (* convert object into json and store the artifacts in the workdir *)
  If[MatchQ[$Failed, convertLaboratoryNotebookToJSON[notebook, workDir]], Return[$Failed]];

  (* Upload everytthing to the publication object *)
  uploadResults = Upload[<|
    Type -> Object[Publication, Notebook],
    ReferenceNotebook -> Link[notebook],
    Replace[Assets] -> Link /@ UploadCloudFile[FileNames[All, workDir]]
  |>];

  (* If it failed, return early *)
  If[MatchQ[$Failed, uploadResults], Return[$Failed]];

  (* Now Publish all the objects in the notebook *)
  publishResults = Publish /@ notebook[Pages];

  (* Check if any of the publish results failed *)
  If[MemberQ[publishResults, $Failed], Return[$Failed]];

  (* Mark the notebook as published so we'll republish changes to it *)
  Upload[<|Object -> notebook[Object], Published -> True|>];

  (* and finally return the URL of where the object will be viewable *)
  URL[baseUrl <> "notebook?id=" <> ToString[notebook[ID]]]
];

(* All of the Object[Notebook] subtypes are very similar - just different fields to access
   for the .nb file to publish *)

(* Publish a notebook page object *)
Publish[notebookPage:ObjectP[Object[Notebook, Page]]] := Publish[notebookPage, AssetFile];

(* Publish a notebook script object *)
Publish[notebookScript:ObjectP[Object[Notebook, Script]]] := Publish[notebookScript, TemplateNotebookFile];

(* Publish a notebook function object *)
Publish[notebookFunction:ObjectP[Object[Notebook, Function]]] := Publish[notebookFunction, AssetFile];

(* This is the base function that does the actual work of publishing all of the notebook subtypes *)
Publish[notebookObject:ObjectP[Object[Notebook]], assetField_Symbol] := Module[
  {notebook, notebookDownloadData, notebookMetadata, htmlAssets, packageFileName, packageFileWorkDir, packageFilePath, packageFileCloudFile, allAssets, uploadResults},

  (* Check if you're logged in *)
  If[!Constellation`Private`loggedInQ[],
		Message[Publish::NotLoggedIn];
		Return[$Failed]
	];

  (* Make sure you're on production, as otherwise items won't appear on the web *)
  If[!MatchQ[Global`$ConstellationDomain, Constellation`Private`ConstellationDomain[Production]],
    Message[Publish::NotOnProduction];
  ];

  (* Load the notebook into memory *)
  notebook = ImportCloudFile[notebookObject[assetField]];

  (* Download some metadata about the notebook *)
  notebookDownloadData = Download[notebookObject, {Packet[Name, DisplayName, DateCreated], Packet[Author[FirstName, LastName]], Notebook[Financers[Name]], ID}];
  If[MatchQ[notebookDownloadData, $Failed], Return[$Failed]];

  (* Now shape the data into something reasonable for front end to use *)
  notebookMetadata = notebookDownloadData[[1]];
  notebookMetadata[Author] = notebookDownloadData[[2]];
  notebookMetadata[Financers] = notebookDownloadData[[3]];
  notebookMetadata[LaboratoryNotebook] = notebookDownloadData[[4]];

  (* Convert it to html! *)
  htmlAssets = convertNotebookToJSON[notebook, cellJSONValue[notebookMetadata, $TemporaryDirectory]];

  (* Check that the conversion succeeded *)
  If[MatchQ[$Failed, htmlAssets], Return[$Failed]];

  (* Now create the package file so it can be downloaded via the web *)
  packageFileWorkDir = FileNameJoin[{$TemporaryDirectory, "ECL", CreateUUID[]}];
  CreateDirectory[packageFileWorkDir];

  (* Figure out the right name to use for the file *)
  packageFileName = If[!NullQ[Lookup[notebookMetadata, DisplayName]], Lookup[notebookMetadata, DisplayName], "My notebook page"];

  (* And create the package file *)
  packageFilePath = Export[FileNameJoin[{packageFileWorkDir, packageFileName <> ".m"}], ConvertNotebookToPackageFile[notebookObject], "String"];

  (* Upload it as a cloud file *)
  packageFileCloudFile = UploadCloudFile[packageFilePath];

  (* Assemble all of the assets *)
  allAssets = Join[htmlAssets, {Link[packageFileCloudFile]}];

  (* Create a new publication out of the working directory *)
  uploadResults = Upload[<|
    Type -> Object[Publication, NotebookPage],
    ReferenceNotebookPage -> Link[notebookObject],
    Replace[Assets] -> allAssets,
    Published -> True
  |>];

  (* The upload failed, return early *)
  If[MatchQ[$Failed, uploadResults], Return[$Failed]];

  (* Mark the notebook page as published so we'll republish changes to it *)
  If[MatchQ[Upload[<|Object -> notebookObject[Object], Published -> True|>], $Failed], Return[$Failed]];

  (* Mark the asset files as published so we can access them on the web *)
  If[MemberQ[Upload[Map[<|Object -> #[Object], Published -> True|> &, allAssets]], $Failed], Return[$Failed]];

  (* And return the complete url *)
  URL[baseUrl <> "notebookPage?id=" <> ToString[notebookObject[ID]]]
];

(* Publishing objects to the web - the basic strategy here is we're going to convert the
   object into json values that the react side can ingest.  The one trick is that we need
   to convert any images into something we can add to our published artifact and then
   indicate a link in the json file *)
Publish[object:ObjectP[]] := Module[
  {workDir, objectJson, uploadResults, markAsPublishedResults},

  (* Reset the linked objects that we've seen - see performance note at top of file *)
  $linkedObjects = {};

  (* Check if you're logged in *)
  If[!Constellation`Private`loggedInQ[],
		Message[Publish::NotLoggedIn];
		Return[$Failed]
	];

  (* Make sure you're on production, as otherwise items won't appear on the web *)
  If[!MatchQ[Global`$ConstellationDomain, Constellation`Private`ConstellationDomain[Production]],
    Message[Publish::NotOnProduction];
  ];

  (* make a directory to work in *)
  workDir = FileNameJoin[{$TemporaryDirectory, "ECL", CreateUUID[]}];

  (* convert object into json and store the artifacts in the workdir *)
  objectJson = convertObjectToJSON[object, workDir];

  (* Check that it is valid *)
  If[MatchQ[$Failed, objectJson], Return[$Failed]];

  (* Upload everytthing to the publication object *)
  uploadResults = Upload[<|
    Type -> Object[Publication, Object],
    ReferenceObject -> Link[object],
    Replace[Assets] -> Link /@ UploadCloudFile[FileNames[All, workDir]],
    Replace[LinkedObjects] -> $linkedObjects
  |>];

  (* Clear out linked objects in case someone else needs it *)
  $linkedObjects = {};

  (* Check if the upload succeeded *)
  If[MatchQ[$Failed, uploadResults], Return[$Failed]];

  (* Mark the object, the publication, and publication assets as published so they'll be accessible on the web *)
  markAsPublishedResults = Upload[Map[<|Object -> #, Published -> True|> &, Join[{object[Object], uploadResults}, Download[uploadResults, Assets[Object]]]]];

  (* Check that it succeeded *)
  If[MatchQ[$Failed, markAsPublishedResults], Return[$Failed]];

  (* return the URL of where the object will be viewable *)
  URL[baseUrl <> "object?id=" <> ToString[object[ID]]]
];

(* Unpublishing an object typically requires two things: (a) removing the published
  flag on the object and (b) removing any associated publication objects. *)
Unpublish[object:ObjectP[]]:=Module[
  {uploadResult, matchingPublications},

  (* Start by uploading the published field to False.  This will work regardless of whether
     or not the object has been published before *)
  uploadResult = Upload[<|Object->object, Published->False|>];

  (* Early fail if that didn't work for any reason *)
  If[MatchQ[$Failed, uploadResult], Return[$Failed]];

  (* Now see if there are any matching publications.  We check all the possible types,
     even though we could theoretically figure out which type it should be based on
     type of the object, just to be sure *)
   matchingPublications = Flatten[{
    Search[Object[Publication, Object], ReferenceObject == object],
    Search[Object[Publication, Notebook], ReferenceNotebook == object],
    Search[Object[Publication, NotebookPage], ReferenceNotebookPage == object]
  }];

  (* And if we found any, delete them! *)
  If[Length[matchingPublications] > 0, EraseObject[matchingPublications, Force->True]]
];

(* Converting notebooks to JSON is based on the idea that we can take a notebook,
   read in its cells and boxes, convert those to json, and then have react render
   the notebook at call time.  So 90% of this code is just jsonify the box and
   cell structure of a notebook.  The other 10% is dealing with things that can't
   be jsonify'd (like dynamic images), which we rasterize and link into the json *)
convertNotebookToJSON[notebook_Notebook, notebookMetadata_Association] := Module[
  {workDir, notebookJSON, fullJSON, jsonLocation},

  (* Generate a directory to work in *)
  workDir = FileNameJoin[{$TemporaryDirectory, "ECL", CreateUUID[]}];
  CreateDirectory[workDir];

  (* The notebook structure is basically as series of cells and boxes arranged in a complex
     hierarchy - we're going to recursively parse the cells to generate our json - this will
     generate images in the work dir where necessary. *)
  notebookJSON = <|"RenderedNotebook" -> <|"Type" -> "Notebook", "Value" -> cellJSONValue[notebook[[1]], workDir]|>|>;

  (* Add in the passed metadata *)
  fullJSON = Join[notebookJSON, notebookMetadata];

  (* Write the notebook JSON out *)
  jsonLocation = Export[FileNameJoin[{workDir, "notebook.json"}], ExportAssociationToJSON[fullJSON], "Text"];

  (* Check that the export actually succeeded *)
  If[!MatchQ[jsonLocation, FileNameJoin[{workDir, "notebook.json"}]], Return[$Failed]];

  (* And upload all the assets in the workDir *)
  Link /@ UploadCloudFile[FileNames[All, workDir]]
];

(* Parsing the cells and boxes into json is 90% of the work of publishing the notebook.
   The basic strategy is to go through each cell or box recursively - the vast majority
   we just need to record in the json, but some of them we need to some MM side processing
   before exporting as JSON *)

(* The top level of basically all notebook entries is the Cell, which represents
   a input/output pair of commands *)
cellJSONValue[cell_Cell, workDir_String] := Module[
  {styleOptions},

  (* Grab the style options on the cell - this indicates things like text formatting and sizing *)
  styleOptions = Apply[Association,Select[cell // Rest, MatchQ[Head[#], Rule] &]];

  (* Convert the cell to json based on just a few categories *)
  Which[
    (* If the cell contains a graphics box, then we need to export the whole cell as an image *)
    hasEmbeddedGraphicsBox[cell[[1]]], exportCellToImage[cell, workDir],
    (* If the cell is a simple wrapper (like Cell[BoxData[...]]), then pierce through it to the child because we don't care about it *)
    MatchQ[Length[cell], 1], cellJSONValue[cell[[1]], workDir],
    (* If the cell is a simple pair (like Cell["Hi", Input]), then we can infer the value and type from the two entries *)
    Length[cell] >= 2, <|"Value" -> cellJSONValue[cell[[1]], workDir], "Type" -> ToString[cell[[2]]], "Options" -> styleOptions|>,
    (* And for everything else, just convert it to a string *)
    True, ToString[cell]
  ]
];

(* Determine whether or not the supplied cell or box has an embedded graphics box. *)

(* If it is a graphics box, then return true *)
hasEmbeddedGraphicsBox[cell_GraphicsBox] := True;

(* do not allow piercing through other cells or cell groups (we'd want to just rasterize those directly) *)
hasEmbeddedGraphicsBox[cell_Cell] := False;
hasEmbeddedGraphicsBox[cell_CellGroupdData] := False;

(* For lists, simply or them all *)
hasEmbeddedGraphicsBox[cell_List] := Or @@ (hasEmbeddedGraphicsBox /@ cell);

(* We short circuit Functions (or other things that can run code) so we don't generate warnings
  if there are syntax errors in them *)
hasEmbeddedGraphicsBox[cell_Function] := False;
hasEmbeddedGraphicsBox[cell_RuleDelayed] := False;
hasEmbeddedGraphicsBox[cell_SafeEvaluate] := False;

(* For all other boxes/cells, our behavior depends on how many children the box/cell has *)
hasEmbeddedGraphicsBox[cell_] := Switch[
  Length[cell],
  (* If we have no children, then return false *)
  0, False,
  (* If we have 1 child, then just pierce through *)
  1, hasEmbeddedGraphicsBox[cell[[1]]],
  (* If we have more than one child, then check them all for embedded graphics boxes *)
  _, Or @@ (hasEmbeddedGraphicsBox /@ cell)
];

(* Cell group datas will automatically be checked for embedded graphics boxes, so if we reach
  here they don't have one and we can just pierce through them simply *)
cellJSONValue[cell_CellGroupData, workDir_String] := cellJSONValue[cell[[1]], workDir];

(* Now we're going to write down a bunch of rules on how to convert Cell, Boxes, and literals to json.
   For the vast majority of boxes, we just record their type and recurse on their children and let
   react figure it out, but there's a ton of little conversion rules.  We explicitly lay them out here
   to have a clean list of all the boxes/cells/types we can handle. *)

(* Convert base mathematica types *)

(* Note that for lists we take at most the first 1000 elements for performance reasons.  This makes it so you can actually publish
  things like Model[Sample, "Milli-q water"] which has hundreds of thousands of things in its Objects field. *)
cellJSONValue[lst_List, workDir_String] := Map[cellJSONValue[#, workDir] &, Take[lst, Min[Length[lst], 1000]]];
cellJSONValue[assoc_Association, workDir_String] := Map[cellJSONValue[#, workDir] &, assoc];
cellJSONValue[cell_Rule, workDir_String] := <|"Type" -> "Rule", "Key" -> cellJSONValue[Keys[cell], workDir], "Value" -> cellJSONValue[Values[cell], workDir]|>;
cellJSONValue[cell_String, workDir_String] := <|"Type" -> "String", Value -> cell|>;
cellJSONValue[cell_Symbol, workDir_String] := <|"Type" -> "Symbol", Value -> ToString[cell]|>;
cellJSONValue[cell_Integer, workDir_String] := <|"Type" -> "Integer", Value -> cell|>;
cellJSONValue[cell_Real, workDir_String] := <|"Type" -> "Real", Value -> cell|>;
cellJSONValue[cell_Part, workDir_String] := <|"Type" -> "Part", Value -> ToString[cell]|>;
cellJSONValue[cell_DateObject, workDir_String] := <|"Type" -> "Date", Value -> DateString[cell, {"Hour", ":", "Minute", ":", "Second", " ", "Month", "/", "Day", "/", "Year"}]|>;
cellJSONValue[cell_Function, workDir_String] := <|"Type" -> "Function", Value -> ToString[cell]|>;
cellJSONValue[cell_Slot, workDir_String] := <|"Type" -> "Slot", Value -> ToString[cell]|>;
cellJSONValue[cell_Alternatives, workDir_String] := <|"Type" -> "Alternatives", Value -> cellJSONValue[List @@ cell, workDir]|>;

(* Distributions *)
cellJSONValue[cell_NormalDistribution, workDir_String] := <|"Type" -> "NormalDistribution", Value -> ToString[cell]|>;
cellJSONValue[cell_DataDistribution, workDir_String] := <|"Type" -> "DataDistribution", Value -> ToString[cell]|>;
cellJSONValue[cell_QuantityDistribution, workDir_String] := <|"Type" -> "QuantityDistribution", Value -> ToString[cell]|>;
cellJSONValue[cell_SampleDistribution, workDir_String] := <|"Type" -> "SampleDistribution", Value -> ToString[cell]|>;

(* Simple boxes that we can convert into renderable html *)
cellJSONValue[fraction_FractionBox, workDir_String] := <|"Type" -> "FractionBox", "Value" -> ToString[fraction[[1]]] <> "/" <> ToString[fraction[[2]]]|>;
cellJSONValue[cell_SqrtBox, workDir_String] := <|"Type" -> "Sqrt", "Value" -> cellJSONValue[cell[[1]], workDir]|>;
cellJSONValue[cell_SuperscriptBox, workDir_String] := <|"Type" -> "Superscript", "Value" -> {cellJSONValue[cell[[1]], workDir], cellJSONValue[cell[[2]], workDir]}|>;
cellJSONValue[cell_Power, workDir_String] := <|"Type" -> "Power", "Value" -> {cellJSONValue[cell[[1]], workDir], cellJSONValue[cell[[2]], workDir]}|>;
cellJSONValue[cell_Times, workDir_String] := <|"Type" ->  "Times", "Value" -> {cellJSONValue[cell[[1]], workDir], cellJSONValue[cell[[2]], workDir]}|>;
cellJSONValue[cell_Rational, workDir_String] := <|"Type" -> "Rational", "Value" -> {cellJSONValue[Numerator[cell], workDir], cellJSONValue[Denominator[cell], workDir]}|>;
cellJSONValue[cell_Quantity, workDir_String] := <|"Type" -> "String", "Value" -> ToString[cell]|>;
cellJSONValue[cell_IndependentUnit, workDir_String] := <|"Type" -> "IndependentUnit", "Value" -> cellJSONValue[cell[[1]], workDir]|>;

(* References to objects that we can turn into links.  We do a bit of magic here so we can display the named value
   but allow the FE to link on the id. *)
cellJSONValue[cell_Object, workDir_String] := <|"Type"->Head[cell], "Value" -> ToString[cell], "Options" -> autolinkOptions[cell]|>;
cellJSONValue[cell_Model, workDir_String] := <|"Type"->Head[cell], "Value" -> ToString[cell], "Options" -> autolinkOptions[cell]|>;
cellJSONValue[cell_Link, workDir_String] := <|"Type"->Head[cell], "Value" -> ToString[First[cell]], "Options" -> autolinkOptions[cell]|>;

(* Generate the options for autolinking fields.  The options help the FE know how to render the link *)
autolinkOptions[cell_] := Module[
  {cellId, objectId},

  (* Try to grab the object ID - this may not work if someone for a bunch of reasons *)
  cellId = cell[ID];

  (* Convert it to an object ID if it is one *)
  objectId = If[MatchQ[Head[cellId], String] && StringStartsQ[cellId, "id:"], cellId, Null];

  (* If we got an object Id, add it to the link of objects we've seen *)
  If[!NullQ[objectId], AppendTo[$linkedObjects, Link[Download[cell, Object]]]];

  (* If we got an object Id, add it to the autolinking options - these are basically
     hints to the FE on how to display the link. *)
  If[NullQ[objectId], <||>, <|"ObjectID"->objectId|>]
]

(* Simple container boxes that we pierce to get their children *)
cellJSONValue[cell_BoxData, workDir_String] := <|"Type" -> Head[cell], "Value" -> cellJSONValue[cell[[1]], workDir]|>;
cellJSONValue[cell_TagBox, workDir_String] := <|"Type" -> Head[cell], "Value" -> cellJSONValue[cell[[1]], workDir]|>;
cellJSONValue[cell_TextData, workDir_String] := <|"Type" -> Head[cell], "Value" -> cellJSONValue[cell[[1]], workDir]|>;
cellJSONValue[cell_FormBox, workDir_String] := <|"Type" -> Head[cell], "Value" -> cellJSONValue[cell[[1]], workDir]|>;
cellJSONValue[cell_TooltipBox, workDir_String] := <|"Type" -> Head[cell], "Value" -> cellJSONValue[cell[[1]], workDir]|>;
cellJSONValue[cell_ButtonBox, workDir_String] := <|"Type" -> Head[cell], "Value" -> cellJSONValue[cell[[1]], workDir]|>;
cellJSONValue[cell_PaneBox, workDir_String] := <|"Type" -> Head[cell], "Value" -> cellJSONValue[cell[[1]], workDir]|>;
cellJSONValue[cell_PaneSelectorBox, workDir_String] := <|"Type" -> Head[cell], "Value" -> cellJSONValue[cell[[1]], workDir]|>;
cellJSONValue[cell_SequenceForm, workDir_String] := <|"Type" -> Head[cell], "Value" -> cellJSONValue[cell[[1]], workDir]|>;
cellJSONValue[cell_FrameBox, workDir_String] := <|"Type" -> Head[cell], "Value" -> cellJSONValue[cell[[1]], workDir]|>;
cellJSONValue[cell_ItemBox, workDir_String] := <|"Type" -> Head[cell], "Value" -> cellJSONValue[cell[[1]], workDir]|>;

(* Some the boxes have complex rules for how to render in the FE, which we can record here *)

(* Row Boxes often contain code, which we want to do automatic linking on, so we handle that here.  This is different from
   linking Object/Link/Model heads as the code can be formatted over multiple boxes, etc, so we wrap the entire set of boxes
   with a new head that indicates the full sum of the boxes should be converted to a link.
    There are three things we want to autolink:
    1.  References to functions with helpfiles
    2.  References to specific objects or models
    3.  References to types  *)
cellJSONValue[cell_RowBox, workDir_String] := <|"Type" -> Head[cell], "Value" -> cellJSONValue[autolinkCells[cell[[1]]], workDir]|>;

(* If we've got a list, check if the first entry is either a symbol we know about or Object/Model *)
autolinkCells[cell_List] := Module[
  {firstElement},

  (* Grab the first element *)
  firstElement = First[cell, Null];

  (* If its a symbol with an ECL helpfile, then we want to link it.  We do this by replacing the first
    element with a link *)
  If[hasECLHelpfile[firstElement], Return[Join[{AutoLinkHelpfile[firstElement]}, Rest[cell]]]];

  (* If its a reference to a specific model or object, then we want to link it as well.  We
     do this by marking the whole list as an linkable entity *)
  If[isLinkedObject[cell], Return[autoLinkObject[cell]]];

  (* Otherwise, just return the cell unchanged *)
  cell
];
(* For everything else, just leave it untouched *)
autolinkCells[cell_] := cell;

(* Check if something has an ECL helpfile and so should be linked *)
hasECLHelpfile[symbol_Symbol] := hasECLHelpfile[ToString[symbol]];
hasECLHelpfile[symbol_String] := Module[
  {functionContext, functionPackage, pacletMap},

  (* There's a list of symbols that we never link to the function *)
  If[MemberQ[{"Object", "Model", "Protocol", "Sample"}, symbol], Return[False]];

  (* Find the function context *)
  functionContext = FunctionPackage[Evaluate[ToString[Quiet[Context[symbol]]] <> symbol]];

  (* If the function context is $Failed, then it does not *)
  If[MatchQ[$Failed, functionContext], Return[False]];

  (* Convert the function context to a package *)
  functionPackage = Lookup[PackageMetadata[functionContext], "Name"];

  (* See if it has an entry in the paclet mapping *)
  pacletMap = Lookup[PacletMapping[], "paclet:" <> functionPackage <> "/ref/" <> symbol, Null];

  (* If it has a paclet map entry, then it has a helpfile! *)
  !MatchQ[pacletMap, Null]
];
(* Anything other than a symbol does not have a helpfile *)
hasECLHelpfile[symbol_] := False;

(* Only a list can represent a linked object, and they can look a little funky, like:
  {Object,[,RowBox[{Sample,,,"id:4pO6dM5Xd51M"}],]} *)
isLinkedObject[cell_List] := Module[
  {},

  (* to possibly be an object or model, you need three things:
    1.  Start with Object or Model
    2.  The Second entry is [
    3.  The Last entry is ]*)

  (* First check that has enough entries *)
  If[Length[cell] < 3, Return[False]];

  (* Now check that it starts with the right thing *)
  If[!(MatchQ[First[cell], "Object"] || MatchQ[First[cell], "Model"]), Return[False]];

  (* Now look for the open and closing braces *)
  If[!(MatchQ[cell[[2]], "["] && MatchQ[cell[[Length[cell]]], "]"]), Return[True]];

  (* If you passed all the checks, then congrats, you're a linked object! *)
  True
];

(* This will automatically link both objects and types *)
autoLinkObject[cell_List] := Module[
  {formattedCell, potentialId},

  (* Format the cell, removing all interior RowBoxes.  There's a bunch of ways this can fail,
      in which case we just don't autolink *)
  formattedCell = Quiet[StringJoin[Flatten[Map[Replace[#, RowBox[anyCell_] -> anyCell] &, cell]]]];

  (* extract the potential id *)
  potentialId = Quiet[ToExpression[formattedCell][ID]];

  (* If the ID is a string that starts with id: then we've got a link to an object *)
  If[MatchQ[Head[potentialId], String] && StringStartsQ[potentialId, "id:"],
    Return[AutoLinkObject[formattedCell, "ObjectID" -> potentialId]]];

  (* If that wasn't the case, see if its a type *)
  If[MatchQ[Head[LookupTypeDefinition[formattedCell]], List],
    Return[AutoLinkType[formattedCell]]];

  (* If it was neither of those, then just return the cell unchanged *)
  cell
];

cellJSONValue[cell_AutoLinkObject, workDir_String] := <|"Type" -> Head[cell], "Value" -> cellJSONValue[cell[[1]], workDir], "Options" -> Association@@Rest[cell]|>;

(* TemplateBoxes are wild - they contain an array value as well as a template format which
   is basically a random string that describes how to render them.  We'll record that all
   here and then have to implement rules on the react side to display them based on the
   template format. React will alert to rollbar if it sees a template type it doesn't know. *)
cellJSONValue[cell_TemplateBox, workDir_String] := <|
  "Type" -> "TemplateBox",
  "Value" -> cellJSONValue[cell[[1]], workDir],
  "TemplateFormat" -> cellJSONValue[cell[[2]], workDir]
|>;

(* Style boxes basically contain text along with formatting rules on the font of the text *)
cellJSONValue[cell_StyleBox, workDir_String] := Module[
  {cellValue, styleOptions},

  (* StyleBoxes are annoying, because if the first element is a string, it may contain redundant "'s, so we need to fix that *)
  cellValue = If[
    MatchQ[Head[cell[[1]]], String] && StringStartsQ[cell[[1]], "\""] && StringEndsQ[cell[[1]], "\""],
    ToExpression[cell[[1]]],
    cell[[1]]
  ];

  (* We also need to grab the styling options *)
  styleOptions = Apply[Association, Select[cell // Rest, MatchQ[Head[#], Rule] &]];

  (* Finally, we need to convert some of the styling colors (if they exist) to something javascript likes more *)
  styleOptions[FontColor] = safeConvertStyleColor[styleOptions, FontColor];
  styleOptions[LineColor] = safeConvertStyleColor[styleOptions, LineColor];
  styleOptions[FrontFaceColor] = safeConvertStyleColor[styleOptions, FrontFaceColor];
  styleOptions[GraphicsColor] = safeConvertStyleColor[styleOptions, GraphicsColor];

  (* And return the combined value *)
  <|"Type" -> "StyleBox", "Value" -> cellJSONValue[cellValue, workDir], "Options" -> styleOptions|>
];

(* Grid boxes represent tables, and have style applied to them *)
cellJSONValue[cell_GridBox, workDir_String] := Module[
  {allStyleOptions, styleOptions},

  (* Pull all the style options from the grid box *)
  allStyleOptions = Apply[Association, Select[cell // Rest, MatchQ[Head[#], Rule] &]];

  (* There are a lot, but the only one we implement in this version is the framestyle *)
  styleOptions = If[
    KeyExistsQ[allStyleOptions, FrameStyle], <|FrameStyle -> allStyleOptions[FrameStyle]|>,
    <||>
  ];

  <|"Type" -> "GridBox", "Value" -> cellJSONValue[cell[[1]], workDir], "Options" -> styleOptions|>
];

(* Interpretation boxes represent complex ways of representing objects in multiple formats.  The last non-style optionNames is usually
   a simple image we can use on the web *)
cellJSONValue[cell_InterpretationBox, workDir_String] := <|
  "Type" -> "InterpretationBox",
  "Value" -> cellJSONValue[Last[Select[cell, ! MatchQ[Head[#], Rule] &]], workDir]
|>;

(* These boxes are (on their own) not yet implemented.  We'll skip these in the rendering.
  NOTE: this code is only hit if these are encoutered outside of a CellGroupData cell -
  if we hit them there, we know how to rasterize them and we're fine *)
cellJSONValue[cell_DynamicModuleBox, workDir_String] := <|"Type" -> "DynamicModuleBox", "Value" -> "NotImplemented"|>;
cellJSONValue[cell_Graphics3DBox, workDir_String] := <|"Type" -> "Graphics3DBox", "Value" -> "NotImplemented"|>;
cellJSONValue[cell_TabViewBox, workDir_String] := <|"Type" -> "Graphics3DBox", "Value" -> "NotImpelemented"|>;

(* Images *)
cellJSONValue[cell_GraphicsBox, workDir_String] := exportCellToImage[cell, workDir];
cellJSONValue[cell_Graphics, workDir_String] := exportCellToImage[cell, workDir];
cellJSONValue[cell_Molecule, workDir_String] := exportCellToImage[cell, workDir];
cellJSONValue[cell_State, workDir_String] := exportCellToImage[cell, workDir];
cellJSONValue[cell_Image, workDir_String] := exportCellToImage[cell, workDir];

(* Things that display in a pretty way.  We want to make sure we get the FE version
   rather than the default FullForm or ToString version. *)
cellJSONValue[cell_DNA, workDir_String] := <|"Type" -> "DNA", "Value" -> ToString[cell]|>;
cellJSONValue[cell_LRNA, workDir_String] := <|"Type" -> "LRNA", "Value" -> ToString[cell]|>;
cellJSONValue[cell_RNA, workDir_String] := <|"Type" -> "RNA", "Value" -> ToString[cell]|>;
cellJSONValue[cell_Strand, workDir_String] := exportCellToImage[Rasterize[cell], workDir];
cellJSONValue[cell_Structure, workDir_String] := exportCellToImage[Rasterize[cell], workDir];
cellJSONValue[cell_Reaction, workDir_String] := exportCellToImage[Rasterize[cell], workDir];
cellJSONValue[cell_ReactionMechanism, workDir_String] := exportCellToImage[Rasterize[cell], workDir];
cellJSONValue[cell_Transfer, workDir_String] := exportCellToImage[Rasterize[cell], workDir];
cellJSONValue[cell_Transferred, workDir_String] := exportCellToImage[Rasterize[cell], workDir];
cellJSONValue[cell_Initialized, workDir_String] := exportCellToImage[Rasterize[cell], workDir];
cellJSONValue[cell_SetStorageCondition, workDir_String] := exportCellToImage[Rasterize[cell], workDir];
cellJSONValue[cell_ExperimentStarted, workDir_String] := exportCellToImage[Rasterize[cell], workDir];
cellJSONValue[cell_ExperimentEnded, workDir_String] := exportCellToImage[Rasterize[cell], workDir];
cellJSONValue[cell_AcquiredData, workDir_String] := exportCellToImage[Rasterize[cell], workDir];
cellJSONValue[cell_InformationData, workDir_String] := exportCellToImage[Rasterize[cell], workDir];

(* By default, just record the cell type and go on to the children.  React will alert
   to rollbar if it sees a box type it doesn't know how to handle. *)
cellJSONValue[cell_, workDir_String] := <|"Type" -> ToString[Head[cell]], "Value" -> cellJSONValue[cell[[1]], workDir]|>;

(* Convert colors to something javascript likes a bit more *)
safeConvertStyleColor[styleOptions_Association, key:(_Symbol|_String)] := If[KeyExistsQ[styleOptions, key], convertMMColor[styleOptions[key]], Null];

(* For gray scale colors, conver to the javascript grayscale function *)
convertMMColor[color_GrayLevel] := "grayscale(" <> ToString[First[color]] <> ")";

(* For RGB colors, convert it to the javascript format *)
convertMMColor[color_RGBColor] := "rgb(" <> ToString[Round[color[[1]]*256]] <> "," <> ToString[Round[color[[2]]*256]] <> "," <> ToString[Round[color[[3]]*256]] <> ")";

(* Now we've handled all the boxes and cells and can start to worry about images.  There's two types of images:
  1.  Things that are really images (like a picture of something) - these are fairly easy: they show up in
      GraphicsBox's, and all we have to do is export them.
  2.  Things that are dynamically rendered, and we'd like to convert them to static images.  These are more complex,
      and will be handled by the rasterization process.
*)

(* For a list, just map over all the entries *)
exportCellToImage[cell_List, workDir_String] := Map[exportCellToImage[#, workDir] &, cell];

(* If its a cell group, then try to handle each individual child *)
exportCellToImage[cell_CellGroupData, workDir_String] := Map[cellJSONValue[#, workDir] &, First[cell]];

(* Given a cell, export it to an image in the working directory *)
exportCellToImage[cell_, workDir_String] := Module[
  {convertedImage, identifier},

  (* Export the cell to a jpg - to do this, we need to convert the box to an image *)
  convertedImage = convertBoxToImage[cell];

  (* If it didn't convert to an image, then we can skip it *)
  If[! MatchQ[Image, Head[convertedImage]], Return[Null]];

  (* Create a name for the image - we use the hash so images are automatically deduped.
     This is extremely helpfile for e.g., helpfiles which may have the same image over
    and over *)
  identifier = Hash[convertedImage, "SHA256", "HexString"] <> ".jpg";

  (* Otherwise, write it to disk *)
  Export[FileNameJoin[{workDir, identifier}], convertedImage];

  (* Return the location to look *)
  <|"Type" -> "Image", "Value" -> identifier|>
];

(* For dynamics and complex, interactive images, there is often a graphics cache box which represents
   what is shown on the screen with no user input.  See if we can pull this out here *)

(* For lists we need to find if any of the items in the list include a graphics cache, and then pick the first one *)
retrieveGraphicsCacheBoxFromCell[cell_List] := Module[
  {childGraphicsCaches},

  (* Find all the graphics caches of you're children, and delete nulls *)
  childGraphicsCaches = Select[retrieveGraphicsCacheBoxFromCell /@ cell, !MatchQ[#, Null] &];

  (* If we couldn't find any, then we're just going to have to return null.  But sometimes we can
     find some! *)
  If[Length[childGraphicsCaches] == 0, Null,
    If[Length[childGraphicsCaches] == 1, First[childGraphicsCaches], childGraphicsCaches]
  ]
];

(* Often the graphics caches are the value of a rule, so we need to handle that here *)
retrieveGraphicsCacheBoxFromCell[cell_Rule] := retrieveGraphicsCacheBoxFromCell[Values[cell]];

(* The graphics caches are either raster boxes or compressed data, which we know how to render *)
retrieveGraphicsCacheBoxFromCell[cell_RasterBox] := cell;
retrieveGraphicsCacheBoxFromCell[cell_CompressedData] := cell;

(* By default, just pierce through to the child if one exists *)
retrieveGraphicsCacheBoxFromCell[cell_] := If[Length[cell] > 0, retrieveGraphicsCacheBoxFromCell[List@@cell], Null];

(* Now we have to have a bunch of rules about how to convert various boxes to images.
   The key is that staic images are stored in MM notebooks as compressed data. *)
convertBoxToImage[box_List] := convertBoxToImage /@ box;

(* Cells can be directly rasterized *)
convertBoxToImage[box_Cell] := Rasterize[box];

(* Some of the boxes are just wrappers around other more interesting boxes *)
convertBoxToImage[box_PaneBox] := convertBoxToImage[box[[1]]];
convertBoxToImage[box_GraphicsBox] := convertBoxToImage[box[[1]]];
convertBoxToImage[box_TagBox] := convertBoxToImage[box[[1]]];
convertBoxToImage[box_GridBox] := convertBoxToImage[box[[1]]];
convertBoxToImage[box_TooltipBox] := convertBoxToImage[box[[1]]];
convertBoxToImage[box_ButtonBox] := convertBoxToImage[box[[1]]];
convertBoxToImage[box_StyleBox] := convertBoxToImage[box[[1]]];
convertBoxToImage[box_BoxData] := convertBoxToImage[box[[1]]];

(* The raster box doesn't actually contain the image, but it contains rules about
  displaying the image, so we need to capture these style options. *)
convertBoxToImage[box_RasterBox] := Module[
  {child, styleOptions},

  (* Pull the child of the raster box *)
  child = First[box];

  (* Pull out the style options - these are important because they set the color
  space (e.g., RGB) we use to interprete the compressed data as an image.  If you're
  seeing images that look right, but all the colors are funky, its probably an issue
  here *)
  styleOptions = Apply[Association, Select[box // Rest, MatchQ[Head[#], Rule] &]];

  (* If there is a color space style option, then we need to preserve that, otherwise, simply pierce through to the child *)
  If[MatchQ[Lookup[styleOptions, ColorFunction], RGBColor],
   Image[child, ColorSpace -> "RGB"],
   convertBoxToImage[child]
 ]
];

(* The numeric array is where the image really lives.  Surely I'm kidding you say,
   but no, MM legit stores its images as a numeric array of the RGB (or other
  color space) values in a 2D grid.  What's most amazing is that you can actually just call
  Image[] on the numeric array... *)
convertBoxToImage[box_NumericArray] := Image[box];

(* If you get a CellGroupData, you're in trouble, because these typically indicate
   very complex images (like a dynamic based on an input).  So what we're going to do
   is figure out the input command that generated CellGroupData, rerun that, and then
   rasterize the results.  We do this because you cannot rasterize the Boxes that are
   stored in the notebook *)
convertBoxToImage[box_CellGroupData] := Module[
  {inputCommand, stringStarts},

  (* Build the input command, if you can *)
  inputCommand = buildInputExpressionFromCell[box];
  stringStarts = If[MatchQ[Null, inputCommand], False, StringStartsQ[inputCommand, "Experiment"]];

  (* If you've got a command, then re-run it and rasterize it! *)
  If[
   NullQ[inputCommand] || StringStartsQ[StringReplace[inputCommand, " "->""], "Experiment"],
   Null,
   (* I kid you not - this actually works... *)
   ToExpression["Rasterize[" <> inputCommand <> "]"]
   ]
  ];

(* Some things we can just straight up rasterize - note that molecules look cool
   plotted first *)
convertBoxToImage[box_Molecule] := convertBoxToImage[PlotMolecule[box]];
convertBoxToImage[box_State] := Rasterize[box];
convertBoxToImage[box_Graphics] := Rasterize[box];

(* Otherwise, we're not getting an image out of this guy, so just return the
   box itself back *)
convertBoxToImage[box_] := box;

(* For complex images, we need to figure out the input expression in the cell
   so we can we rerun it and rasterize it.  This bit of code recursively rebuilds
   the input command based on the boxes in the CellGroupData *)

(* The input is always the first entry in the cell group *)
buildInputExpressionFromCell[cell_CellGroupData] := buildInputExpressionFromCell[cell[[1]]];
buildInputExpressionFromCell[cell_List] := buildInputExpressionFromCell[cell[[1]]];

(* If you got a Cell, check if its an input cell *)
buildInputExpressionFromCell[cell_Cell] := If[
  Length[cell] >= 2 && MatchQ["Input", ToString[cell[[2]]]],
  (* If it is, then recursively build the command from the box in the input cell*)
  buildInputExpressionFromBox[cell[[1]]],
  (*otherwise, we're definitely not getting an input command from this cell *)
  Null
];

buildInputExpressionFromCell[cell_Molecule] := ToString[InputForm[cell]];

(* For any other cells, we don't know how to build a input command, so bail *)
buildInputExpressionFromCell[cell_] := Null;

(* Once we've found the Box, we need to actually build the string of the expression *)

(* These are just layout boxes, so ignore them for calculating the command *)
buildInputExpressionFromBox[box_BoxData] := buildInputExpressionFromBox[box[[1]]];
buildInputExpressionFromBox[box_RowBox] := buildInputExpressionFromBox[box[[1]]];

(* An intepretation box has the first element be what is displayed and the second be
   the underlying representation.  For the command we just want the second element *)
buildInputExpressionFromBox[box_InterpretationBox] := buildInputExpressionFromBox[box[[2]]];

(* On lists, just string join the results *)
buildInputExpressionFromBox[box_List] := StringJoin[buildInputExpressionFromBox /@ box];

(* On strings just return the original value *)
buildInputExpressionFromBox[box_String] := box;

(* for everything else, just convert it to a string! *)
buildInputExpressionFromBox[box_] := ToString[InputForm[box]];

(* Sometimes when we get a CellGroupData, the output needs to be rasterized, but not always.
   Its always preferable to not rasterize if you don't have to, because that leaves the output
   as real text, so we check here if we actually have to rasterize the cell *)

(* Just grab the first child box *)
cellGroupNeedsRasterizationQ[cellGroupData_CellGroupData] := boxNeedsRasterizationQ[cellGroupData[[1]]];

(* We only ever rasterize cellGroupData's *)
cellGroupNeedsRasterizationQ[cellGroupData_] := False;

(* We need rasterize a box if any of its children require rasterization *)
boxNeedsRasterizationQ[box_List] := Or @@ (boxNeedsRasterizationQ /@ box);

(* Most of the boxes we just pass through to check the children *)
boxNeedsRasterizationQ[box_Cell] := boxNeedsRasterizationQ[box[[1]]];
boxNeedsRasterizationQ[box_BoxData] := boxNeedsRasterizationQ[box[[1]]];
boxNeedsRasterizationQ[box_TemplateBox] := boxNeedsRasterizationQ[box[[1]]];
boxNeedsRasterizationQ[box_CellGroupData] := boxNeedsRasterizationQ[box[[1]]];
boxNeedsRasterizationQ[box_InterpretationBox] := boxNeedsRasterizationQ[box[[1]]];
boxNeedsRasterizationQ[box_RowBox] := boxNeedsRasterizationQ[box[[1]]];
boxNeedsRasterizationQ[box_ButtonBox] := boxNeedsRasterizationQ[box[[1]]];
boxNeedsRasterizationQ[box_TagBox] := boxNeedsRasterizationQ[box[[1]]];
boxNeedsRasterizationQ[box_FormBox] := boxNeedsRasterizationQ[box[[1]]];
boxNeedsRasterizationQ[box_TagBox] := boxNeedsRasterizationQ[box[[1]]];
boxNeedsRasterizationQ[box_PaneBox] := boxNeedsRasterizationQ[box[[1]]];
boxNeedsRasterizationQ[box_StyleBox] := boxNeedsRasterizationQ[box[[1]]];
boxNeedsRasterizationQ[box_TooltipBox] := boxNeedsRasterizationQ[box[[1]]];
boxNeedsRasterizationQ[box_TabViewBox] := boxNeedsRasterizationQ[box[[1]]];
boxNeedsRasterizationQ[box_PaneSelectorBox] := boxNeedsRasterizationQ[box[[1]]];
boxNeedsRasterizationQ[box_PanelBox] := boxNeedsRasterizationQ[box[[1]]];
boxNeedsRasterizationQ[box_GridBox] := boxNeedsRasterizationQ[box[[1]]];
boxNeedsRasterizationQ[box_ItemBox] := boxNeedsRasterizationQ[box[[1]]];
boxNeedsRasterizationQ[box_FrameBox] := boxNeedsRasterizationQ[box[[1]]];
boxNeedsRasterizationQ[box_ActionMenuBox] := boxNeedsRasterizationQ[box[[1]]];

(* Do rasterize anything dynamic or 3D *)
boxNeedsRasterizationQ[box_DynamicModuleBox] := True;
boxNeedsRasterizationQ[box_DynamicBox] := True;
boxNeedsRasterizationQ[box_Graphics3DBox] := True;
boxNeedsRasterizationQ[box_Molecule] := True;
boxNeedsRasterizationQ[box_Legended] := True;
boxNeedsRasterizationQ[box_Directive] := True;
boxNeedsRasterizationQ[box_GeometricTransformationBox] := True;

(* Don't rasterize any boxes that we know how to handle directly *)
boxNeedsRasterizationQ[box_String] := False;
boxNeedsRasterizationQ[box_Symbol] := False;
boxNeedsRasterizationQ[box_Integer] := False;
boxNeedsRasterizationQ[box_FractionBox] := False;
boxNeedsRasterizationQ[box_SuperscriptBox] := False;
boxNeedsRasterizationQ[box_TextData] := False;
boxNeedsRasterizationQ[box_Rule] := False;

(* Graphics boxes are a little tricky - if they're flat graphics boxes, then we don't want to rasterize
   because we can just use the image in the notebook, but if they contain anything dynamic, like a
  directive, then we need to rasterize them *)
boxNeedsRasterizationQ[box_GraphicsBox] := Or @@ (boxNeedsRasterizationQ /@ box);

(* By default, don't rasterize *)
boxNeedsRasterizationQ[box_] := False;

(* We record the objects that are linked from this publication so we can know
   whether or not to display them as links in the front end *)
isLinkableType[type_String] := MemberQ[{"Link", "Object", "Model"}, type];
isLinkableType[type_] := False;
findLinks[ruleList:{_Rule...}] := If[isLinkableType[Lookup[ruleList, "Type", Null]], Lookup[Lookup[ruleList, "Options", {}], "ObjectID"], findLinks /@ ruleList];
findLinks[lst_List] := findLinks /@ lst;
findLinks[assoc_Association] := findLinks[Normal[assoc]];
findLinks[rule_Rule] := findLinks[Values[rule]];
findLinks[any_] := Null;

(* convert a laboratory notebook into json needed to render the cover page for it *)
convertLaboratoryNotebookToJSON[object:ObjectP[Object[LaboratoryNotebook]], workDir_String] := Module[
  {packet, jsonLocation},

  (* Make sure the workdir folder exists *)
  Quiet[CreateDirectory[workDir], {CreateDirectory::filex,CreateDirectory::eexist}];

  (* Download the laboratory notebook info - we do this in multiple downloads to retain the
    right packet structure.  This is not super efficient, but is a very small amount of time
    relative to the full rendering of the notebook *)
  packet = Download[object, Packet[Name, DateCreated]];
  packet[Authors] = Download[object, Authors[{FirstName, LastName}]];
  packet[Financers] = Download[object, Financers[Name]];
  packet[Pages] = Download[object, Pages[{ID, DisplayName, Author[{FirstName, LastName}], DateCreated}]];
  packet["PublishedDate"] = DateString[{"Month", "/", "Day", "/", "Year"}];

  (* For linking purposes, we need to make sure we have the latest helpfile paclet mapping, so do that! *)
  Usage`Private`ensurePacletMappingUpToDate[];

  (* Write it out! *)
  jsonLocation = Export[FileNameJoin[{workDir, "lab_notebook.json"}], ExportAssociationToJSON[cellJSONValue[packet, workDir]], "Text"];

  (* Check that the json export succeeded *)
  If[!MatchQ[jsonLocation, FileNameJoin[{workDir, "lab_notebook.json"}]], Return[$Failed]];

  (* And end by returning the location *)
  workDir
];

(* convert an object into json in line with the output of inspect *)
convertObjectToJSON[object:ObjectP[], workDir_String] := Module[
  {packet, sortedKeys, nonDeveloperKeys, nonBlacklistedKeys, keysToInclude, typeDefinition, annotatedFieldValues, objectJson, jsonLocation},

  (* Make sure the workdir folder exists *)
  Quiet[CreateDirectory[workDir], {CreateDirectory::filex,CreateDirectory::eexist}];

  (* Download the full object *)
  packet = Download[object];

  (* Pull the type definition - note that we need to get a static type definition
     because if it changes in the future, to make the current data work we need
     the current type definition *)
  typeDefinition = Association /@ Association[Association[LookupTypeDefinition[packet[Type]]][Fields]];

  (* Sort the keys correctly like inspect does *)
  sortedKeys = Keys[sortFields[packet[Type], packet]];

  (* Filter out developer keys *)
  nonDeveloperKeys = Select[sortedKeys, !Lookup[Lookup[typeDefinition, #, Association[]], Developer, False] &];

  (* Filter out the "log" style keys as they are very large and don't add much *)
  nonBlacklistedKeys = Select[nonDeveloperKeys, ! StringEndsQ[ToString[#], "Log"] & ];

  (* Filter out all empty/null fields like inspect does. *)
  keysToInclude = Select[nonBlacklistedKeys, Length[packet[#]] > 0 || (! MatchQ[packet[#], ""] && ! MatchQ[packet[#], {}] && ! MatchQ[packet[#], Null]) &];

  (* For linking purposes, we need to make sure we have the latest helpfile paclet mapping, so do that! *)
  Usage`Private`ensurePacletMappingUpToDate[];

  (* Build an annotated json of the values to display *)
  annotatedFieldValues = AssociationMap[
    <|
      (* We generally prefer named objects, but because the objects field on model can get very large, skip it there *)
      "Value" -> If[MatchQ[ToString[#], "Objects"], cellJSONValue[packet[#], workDir], cellJSONValue[NamedObject[packet[#]], workDir]],
      "Format" -> typeDefinition[#][Format],
      "Description" -> typeDefinition[#][Description],
      "Category" -> typeDefinition[#][Category],
      "Class" -> typeDefinition[#][Class],
      "Headers" -> Lookup[typeDefinition[#], Headers, Null]
    |> &,
    keysToInclude
  ];

  (* The full object json includes the annotated field values as well as some metadata *)
  objectJson = <|
    "Fields" -> annotatedFieldValues,
    "DatePublished" -> DateString[{"Month", "/", "Day", "/", "Year"}],
    "PlotObject" -> cellJSONValue[objectImage[object], workDir]
  |>;

  (* Write it out! *)
  jsonLocation = Export[FileNameJoin[{workDir, "data.json"}], ExportAssociationToJSON[objectJson], "Text"];

  (* Check that the json export succeeded *)
  If[!MatchQ[jsonLocation, FileNameJoin[{workDir, "data.json"}]], Return[$Failed]];

  (* And end by returning the json *)
  objectJson
];

(* Build the header image for the object in the inspect view - most of the time this is
   just the results of PlotObject, if it exists *)
objectImage[object:ObjectP[]] := Module[
  {plotObjectResults},

  (* Try plot object *)
  plotObjectResults = Quiet[PlotObject[object]];

  (* If you got back a symbol, then something bad happened and it likely didn't render properly.
     If you did not, then you can rasterize it! *)
  If[MatchQ[Symbol, Head[plotObjectResults]], Null, Rasterize[plotObjectResults]]
];

(* Convert a notebook (page, script or function) into a .m text file that is human readable *)
ConvertNotebookToPackageFile[notebook:ObjectP[Object[Notebook]]]:=Module[
  {assetFile, notebookCells},
  (* Find the asset file *)
  assetFile = getNotebookAssetFile[notebook];
  (* Import the notebook cells *)
  notebookCells = ImportCloudFile[assetFile];
  (* And convert them! *)
  convertNotebookCellsToPackageFile[notebookCells, assetFile]
];

(* Convert an already downloaded notebook (page, script or function) into a .m text file that is human readable.
Note that the asset file will NOT be redownloaded - this is just for marking how it was created *)
ConvertNotebookToPackageFile[filePath_String, assetFile:ObjectP[Object[EmeraldCloudFile]]]:=Module[
  {cells},
  (* Try to import the cells *)
  cells = Import[filePath];

  (* If it failed, return early - the import command will message appropriately *)
  If[MatchQ[$Failed, cells], Return[$Failed]];

  (* Convert the cells! *)
  convertNotebookCellsToPackageFile[cells, assetFile]
];

(* Implement the conversion here *)
convertNotebookCellsToPackageFile[notebookCells_Notebook, assetFile:ObjectP[Object[EmeraldCloudFile]]]:=Module[
  {stringifiedCells},
  (* Stringify them! *)
  stringifiedCells = stringifyCellOrBlock[notebookCells];
  (* Add the custom import header and return !*)
  "(* CreatedFrom " <> ToString[InputForm[assetFile[Object]]] <> " on " <> DateString[] <> " - please remove this line if you make manual changes to the file. *)\n" <> stringifiedCells
];

(* Get the asset file from a notebook - for functions and pages this is the AssetFile field, while for scripts its the TemplateNotebookFile field *)
getNotebookAssetFile[notebook:(ObjectP[Object[Notebook, Page]] | ObjectP[Object[Notebook, Function]])]:=notebook[AssetFile];
getNotebookAssetFile[notebook:ObjectP[Object[Notebook, Script]]]:=notebook[TemplateNotebookFile];

downloadNotebookAssetFile[notebook:ObjectP[Object[Notebook]]]:=Module[
  {cloudFile, targetPath},

  (* Find the correct cloud file to use *)
  cloudFile = getNotebookAssetFile[notebook];

  (* Create a path to download it to *)
  targetPath = FileNameJoin[{$TemporaryDirectory, ToString[CreateUUID[]]<>".nb"}];

  (* Attempt to download it *)
  Quiet[DownloadCloudFile[cloudFile[Object], targetPath]];

  (* If the file successfully downloaded, return the path, otherwise return null *)
  If[FileExistsQ[targetPath], targetPath, Null]
];

(* Stringify the cells - for lists we just pierce the list *)
stringifyCellOrBlock[lst_List] := stringifyCellOrBlock/@lst;
(* For strings, just return them unchanged *)
stringifyCellOrBlock[str_String] := str;
(* For notebook heads, just add the package marker in the .m file *)
stringifyCellOrBlock[nb_Notebook]:="(* ::Package:: *)\n" <> stringifyCellOrBlock[nb[[1]]];
(* For all cells, we just need to figure out what the cell type is an include that in the .m markers *)
stringifyCellOrBlock[cell_Cell]:=Module[
  {cellType, cellTypeHeader},
  (* Find the type of the cell from the metadata, if it exists *)
  cellType = If[Length[cell]>=2, cell[[2]], Null];
  (* Convert the type into a header marker we can add to the .m file *)
  cellTypeHeader = If[!NullQ[cellType], "\n\n(* ::" <> ToString[cellType] <> ":: *)\n", ""];
  (* Return the children of the cell *)
  cellTypeHeader <> stringifyCellOrBlock[cell[[1]]]
];
(* We're going to ignore all graphics boxes, so this is a helpful pattern to have *)
graphicsBoxTypesP = Alternatives[_TemplateBox, _GraphicsBox,  _Graphics3DBox,  _TagBox,  _InformationData,  _Graphics,  _DynamicBox,  _DynamicModuleBox];
(* Ignore them all! *)
stringifyCellOrBlock[box:graphicsBoxTypesP]:= "";
(* For everything else, if its a literal, just convert it to a string, and if its not, pierce into the child *)
stringifyCellOrBlock[other_] :=If[Length[other]==0, ToString[other], stringifyCellOrBlock[other[[1]]]];

(* Convert a package file to a notebook, attempting to do a "perfect copy" by downloading the backing cloud file *)
ConvertPackageFileToNotebook[filePath_String]:=Module[
  {fileStream, assetFileMatches, targetPath, assetFilePath},
  (* Check if the file exists first *)
  If[!FileExistsQ[filePath], Return[$Failed]];
  (* See if we can do a perfect copy via the asset file - if the .m was written by us, then the first line will be metadata around where to find it.  As the file may be very big, we only read the first line via a stream*)
  fileStream = OpenRead[filePath];
  (* Read just the first line *)
  firstLine = Read[fileStream, Record];
  (* Check if we're able to parse the metadata we need *)
  assetFileMatches = StringCases[firstLine,RegularExpression["CreatedFrom (.*) on"]->"$1"];
  (* Close the stream out *)
  Close[fileStream];
  (* create a path to store the output file *)
  targetPath = FileNameJoin[{$TemporaryDirectory, ToString[CreateUUID[]]<>".nb"}];
  (* If we found a single asset file match, then we're going to attempt to download it. *)
  assetFilePath = If[Length[assetFileMatches]==1, Quiet[DownloadCloudFile[ToExpression[First[assetFileMatches]], targetPath]], Null];
  (* If the file was successfully downloaded, we're done!  Otherwise, we need to import it normally *)
  If[Quiet[FileExistsQ[assetFilePath]], assetFilePath, manuallyConvertPackageFileToNotebook[filePath, targetPath]]
];

(* If the header information did not give us a .nb file that we can directly copy, we'll try to manually create a .nb.  This is definitely more error prone than direct copy of the .nb file, and so should be avoided when possible *)
manuallyConvertPackageFileToNotebook[packageFilePath_String, notebookFilePath_String]:=Module[
  {packageFileText, fixedPackageFileText, packageFileTextLines, packageFileContentString, cellStrings, cells},
  (* Read in the package file *)
  packageFileText=Import[packageFilePath, "Text"];
  (* Fix some of the indentation markers *)
  fixedPackageFileText = StringReplace[packageFileText, (WhitespaceCharacter...)~~"(*IndentingNewLine*)"~~("\n"..)~~(" "...)->"\\[IndentingNewLine]"];
  (* Split the package file into cells by line *)
  packageFileTextLines=StringSplit[fixedPackageFileText, "\n"->"\n"];
  (* Drop the header information *)
  packageFileContentString = StringJoin[Drop[packageFileTextLines, 4]];
  (* Generate the cell string content *)
  cellStrings = StringSplit[packageFileContentString, RegularExpression["\\\n{1,3}\\(\\* ::"]];
  (* Convert them into Cell heads *)
  cells = unstringifyCellOrBox /@ cellStrings;
  (* Write them out as a notebook! *)
  Export[notebookFilePath, Notebook[cells]]
];

(* Undo the .m creation process in stringify cells *)
unstringifyCellOrBox[cellString_String]:=Module[
  {lineParts, lines, cellStyle, contentLines, cellContent, cellBoxes},
  (* Split the cell by new line characters *)
  lineParts = StringSplit[cellString, "\n"->"\n"];
  (* Convert those into actual lines that should appear in the cells *)
  lines = StringJoin /@ Partition[lineParts, UpTo[2]];
  (* Determine the cell style and type from the markers *)
  cellStyle = StringTrim[First[lines], "(* ::"|":: *)\n"];
  (* Pull the content of the cell *)
  contentLines = Rest[lines];
  (* Build the final content of the cell *)
  cellContent = StringJoin[contentLines];
  (* And convert it to cells and boxes *)
  cellBoxes = First @ FrontEndExecute[FrontEnd`UndocumentedTestFEParserPacket[cellContent,False]];
  (* Rebuild the cell Head and return *)
  Cell[If[MatchQ[cellStyle, "Input"|"Output"|"Code"], cellBoxes, cellContent], cellStyle]
];
