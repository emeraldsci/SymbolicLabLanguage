(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: tharr *)
(* :Date: 2023-02-16 *)

(* ::Section::Closed:: *)
(*ClassifyTransfer*)

(* TODO: add option for controlling confidence interval/threshold *)
DefineOptions[ClassifyTransfer,
  Options :> {UploadOption}
];

ClassifyTransfer[
  object: ObjectP[Object[UnitOperation, Transfer]], ops:OptionsPattern[]
] := First[ClassifyTransfer[{object}, ops], $Failed];

(* singleton non-transfer input --- just return the object without modifying *)
ClassifyTransfer[
  object: ObjectP[Object[UnitOperation]], ops:OptionsPattern[]
] := object;


(* ----- main overload ----- *)
ClassifyTransfer[
  objects: {ObjectP[Object[UnitOperation, Transfer]]..}, ops:OptionsPattern[]
] := Module[
  {safeOps, uploadQ, url, bodyAssociation, response, classificationAssociations, uploadPackets},

  safeOps = SafeOptions[ClassifyTransfer, ToList[ops]];
  uploadQ = Lookup[safeOps, Upload];

  url = If[ProductionQ[],
    "https://tadm.emeraldcloudlab.com/classify",
    "https://tadm-stage.emeraldcloudlab.com/classify"
  ];

  (* create the body that goes into the JSON request *)
  bodyAssociation = <|
    "IDs" -> Download[objects, ID],
    (* if we're on the neutrino database, add this key to allow the app to see the data on this DB *)
    If[StringContainsQ[Global`$ConstellationDomain, "neutrino"],
      "$ConstellationDomain" -> Global`$ConstellationDomain,
      Nothing
    ]
  |>;

  response = HTTPRequestJSON[<|
    "URL" -> url,
    "Method" -> "POST",
    "Headers" -> <|
      "Authorization" -> "Bearer " <> GoLink`Private`stashedJwt
    |>,
    "Body" -> ExportJSON[bodyAssociation]
  |>];

  (* from the response, we need to convert it to a better form *)
  (* specifically the class labels are somewhat unclear, so we can make it better by replacing 0 with Failure and 1 with Success *)
  (* also we need to add labels to the confidences *)
  classificationAssociations = KeyValueMap[convertIDResponse, response];

  (* add replace heads to packets to prepare for upload *)
  uploadPackets = addReplaceHeadsForMultipleFields /@ classificationAssociations;

  If[uploadQ,
    (
      (* add the data to the transfer objects *)
      Map[syncUnitOperationStore, classificationAssociations];
      Upload[uploadPackets]
    ),
    uploadPackets
  ]
];

(* the selective overload that parses out transfer objects and redirects them to the main overload *)
(* once the classified transfers are returned, the original list order is re-constructed *)
(* NOTE: this overload must be behind the primary one for MM 12.0.1 since the downvalues do not get re-ordered correctly *)
(* NOTE: the current version of the TADM classifier only works with the AspirationPressure field which exists only in Transfer https://github.com/emeraldsci/ecl-python/tree/develop/tadm *)
ClassifyTransfer[objects: {ObjectP[Object[UnitOperation]]..}, ops: OptionsPattern[]] := Module[
  {transferPositions, transferObjects, classifiedTransfers},
  (* find the positions of the transfer unit operations in the list *)
  transferPositions = Position[Download[objects, Object], ObjectP[Object[UnitOperation, Transfer]], 1];

  (* part out the transfer unit ops and pass them to the main overload *)
  transferObjects = Extract[objects, transferPositions];
  classifiedTransfers = ClassifyTransfer[transferObjects, ops];

  (* replace the parts of the original input list with the transformed classifications *)
  ReplacePart[objects, Thread[transferPositions -> classifiedTransfers]]
];

convertIDResponse[id_, packet_] := Module[
  {classifications, confidenceLists, prettyClassifications, prettyConfidences},

  classifications = Lookup[packet, "Classifications"];
  confidenceLists = Lookup[packet, "Confidences"];
  prettyClassifications = classifications /. {0. -> Failure, 1. -> Success};

  (* add labels to confidence scores *)
  prettyConfidences = makePrettyConfidences /@ confidenceLists;

  (* return the packet with symbols as keys *)
  <|
    Object -> Object[UnitOperation, Transfer, id],
    AspirationClassifications -> prettyClassifications,
    AspirationClassificationConfidences -> prettyConfidences
  |>
];

(* TODO: figure out where the option controlling of the confidence determination goes *)
makePrettyConfidences[Null] := Null;
makePrettyConfidences[confidences_] := 100 * Max[confidences] * Percent;
(*Thread[{Failure, Success} -> confidences];*)

syncUnitOperationStore[
  KeyValuePattern[{Object -> object_, AspirationClassifications -> classifications_, AspirationClassificationConfidences -> confidences_}]
]:=Module[
  {id, unitOperationPacket, newPacket},
  Block[{$UnitOperationBlobs=False},
    id = Download[object, ID];
    If[KeyExistsQ[ConstellationViewers`Private`$UnitOperationStore, id],
      unitOperationPacket = Lookup[ConstellationViewers`Private`$UnitOperationStore, id];
      newPacket = Join[unitOperationPacket, <|AspirationClassifications -> classifications, AspirationClassificationConfidences -> confidences|>];
      ConstellationViewers`Private`$UnitOperationStore = Join[ConstellationViewers`Private`$UnitOperationStore, <|id -> newPacket|>];
    ];
  ]
];

addReplaceHeadsForMultipleFields[
  <|Object -> object_, AspirationClassifications -> classes_, AspirationClassificationConfidences -> confs_|>
] := <|
  Object -> object,
  Replace[AspirationClassifications] -> classes,
  Replace[AspirationClassificationConfidences] -> confs
|>;
