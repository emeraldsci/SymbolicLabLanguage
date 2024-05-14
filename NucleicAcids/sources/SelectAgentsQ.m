(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: tharr *)
(* :Date: 2023-04-18 *)


(* global variables *)
NCBIBLASTURL = "https://blast.ncbi.nlm.nih.gov/Blast.cgi";


SelectAgentsQ::NCBIFailure = "Communication to the NCBI server was interrupted for some reason. Please wait and try again.";

(* options *)
DefineOptions[SelectAgentsQ,
  Options :> {
    {Retries -> 3, RangeP[1, 5, 1], "Determines the number of allowed retries in case of an NCBI server error."},
    {OutputFormat -> Boolean, (Boolean | Report), "Specify whether SelectAgentsQ returns a Boolean value or an association containing meta-data about any hits returned from BLAST."}
  }
];

(* PATTERNS *)

allowedInputP = _?(DNAQ[#] || PeptideQ[#] || RNAQ[#] &);


(* overload for samples *)
SelectAgentsQ[sample: ObjectP[{Object[Sample], Model[Sample]}], ops: OptionsPattern[]] := Module[
  {molecules, moleculesToCheck, results, safeOps, outputOption},
  (* download the Molecule field from the sample *)
  molecules = Download[sample, Composition[[All, 2]][Molecule]];

  (* filter out any non dna, rna, or peptide inputs *)
  moleculesToCheck = Cases[molecules, allowedInputP];

  (* pass to main overload *)
  results = SelectAgentsQ[#, ops] & /@ moleculesToCheck;

  (* if we hit an error, be sure to return early *)
  If[results === $Failed,
    Return[$Failed]
  ];

  (* join the results together *)
  (* if the output format is boolean, return False if any are false; if a report is required, combine the associations into a single one *)
  safeOps = SafeOptions[SelectAgentsQ, ToList[ops]];
  outputOption = Lookup[safeOps, OutputFormat];
  mergeSampleResults[results, outputOption]
];

mergeSampleResults[results_, Boolean] := Or @@ results;
mergeSampleResults[results_, Report] := Association[
  Result -> Or @@ (Lookup[results, Result]),
  SelectAgents -> Flatten[Lookup[results, SelectAgents]],
  Hits -> Flatten[Lookup[results, Hits]]
];

(* overload for identity models *)
SelectAgentsQ[identityModel: ObjectP[Model[Molecule]], ops: OptionsPattern[]] := Module[
  {molecule, safeOps, outputOption},
  (* download the molecule field *)
  molecule = Download[identityModel, Molecule];

  (* check if it's an acceptable biomolecule *)
  If[MatchQ[molecule, allowedInputP],
    (* if yes, then pass to main overload *)
    SelectAgentsQ[molecule, ops],
    (* if no, simply return False or a False report *)
    (
      safeOps = SafeOptions[SelectAgentsQ, ToList[ops]];
      outputOption = Lookup[safeOps, OutputFormat];
      If[outputOption === Boolean,
        (* need to pass a list of results, the output option, and the list of hits *)
        returnResults[{False}, outputOption, {}],
        (* if output format is report, then we pass in a list of select agents, output option, then list of hit metadata *)
        returnResults[{}, outputOption, {}]
      ]
    )
  ]
];

(* SelectAgentsQ main definition *)
(* abstract away main helper to make error catching easier to read *)
(* create a global variable that tracks the current retry number *)
$retryNumber = 0;
SelectAgentsQ[molecule_?(DNAQ[#] || PeptideQ[#] || RNAQ[#] &), ops:OptionsPattern[]] := Module[
  {maxRetries, result},

  (* pull out the max number of retries from the options *)
  maxRetries = OptionDefault[OptionValue[Retries]];

  (* run the select agents function and check whether we hit an NCBI error *)
  (* if we did, then we can re-run the function up to the number specified by maxRetries *)
  result = Catch[selectAgentsQ[molecule, ops], "fatalerror"];
  If[result === $Failed,
    (* see if we can retry again by ticking up the current retry number, and re-call the select agents function if another retry is allowed *)
    (
      $retryNumber = $retryNumber + 1;
      If[$retryNumber > maxRetries,
        (* return failed and reset retry number *)
        $retryNumber = 0;
        result,
        (* else, we have more retries to go; re-run the calc *)
        SelectAgentsQ[molecule, ops]
      ]
    ),
    (* result is fine; make sure to reset the retry number and return the result *)
    $retryNumber = 0;
    result
  ]
];

selectAgentsQ[molecule_, ops:OptionsPattern[SelectAgentsQ]] := Module[
  {
    cellText, tempCell, xmlResults, blastHits, searchIDs, booleanTests, idAndStatuses, allResponses, safeOps, outputOption, reportQ
  },

  (* get the options to see if we need to output a report or just a boolean *)
  safeOps = SafeOptions[SelectAgentsQ, ToList[ops]];
  outputOption = Lookup[safeOps, OutputFormat];

  (* post the blast query to the API endpoint; this will start the search, but the results won't be returned right away *)
  cellText = "(1/5) Starting the blast query";
  tempCell = PrintTemporary[Dynamic[cellText]];
  (* since the molecule may be a small peptide, we will check for conotoxins locally so we may return early before blasting *)
  allResponses = Catch[postBlastQuery[molecule], "conotoxin"];

  (* if a conotoxin was found, then allResponses will be a boolean instead of a set of http requests *)
  (* if it is, then return immediately *)
  If[TrueQ[allResponses],
    If[outputOption === Report,
      Return[<|Hits -> <||>, Result -> allResponses, SelectAgents -> {"Conotoxin"}|>],
      Return[allResponses]
    ]
  ];

  (* wait for the dna runs to finish *)
  cellText = "(2/5) Waiting for all blast jobs to finish";
  idAndStatuses = waitForAllBlasts[allResponses];

  failIfNotReady[Lookup[idAndStatuses, "Statuses"]];

  cellText = "(3/5) Job is done, now downloading results";
  searchIDs = Lookup[idAndStatuses, "SearchIDs"];
  xmlResults = Map[downloadBlastResults, searchIDs];

  (* convert the xml object into a useful association *)
  cellText = "(4/5) Retrieving hits from results";
  blastHits = findBlastHitResults /@ xmlResults;

  (* if there are no hits return false, but if there are hits,then make sure the top hit is not dangerous *)
  (* if it is return True, which should be useful for marking whether or not this is a molecule of concern *)
  reportQ = SameQ[outputOption, Report];
  cellText = "(5/5) Detecting any select agents and toxins.";
  booleanTests = Map[dangerousAgentQ[#, reportQ] &, blastHits];

  (* delete the temporary cell in case this function is nested inside other functions to prevent any funny
  Cell[cellText$12432234243] outputs in the MM frontend *)
  NotebookDelete[tempCell];

  (* in the case of a report, include three keys: the boolean result, the blast hits which contain lots of useful
  metadata, and the detected select agents *)
  returnResults[booleanTests, outputOption, blastHits]
];

returnResults[results_, outputOption_, blastHits_] := Module[
  {},
  If[outputOption === Boolean,
    Or @@ Flatten[results],
    <|
      (* if output format is result, the boolean tests actually return the list of select agents detected *)
      Result -> Flatten[results] =!= {},
      Hits -> If[MatchQ[blastHits, _List],
        Flatten[blastHits],
        blastHits
      ],
      SelectAgents -> Flatten[results]
    |>
  ]
];

failIfNotReady[statuses_]:= If[
  Not[MatchQ[statuses, {"READY"..}]],
  Message[SelectAgentsQ::NCBIFailure];
  Throw[$Failed, "fatalerror"]
];

waitForAllBlasts[responses_]:=Module[
  {cellText, searchIDs, remainingTimes, maxWaitTime, statuses},

  (* get the first id and wait time *)
  cellText = "Finding the query IDs and time estimates";
  PrintTemporary[Dynamic[cellText]];
  {searchIDs, remainingTimes} = Transpose[getBlastIDWithRemainingTimeEstimate /@ responses];
  maxWaitTime = Max[remainingTimes];
  (* wait the requested amount of time *)
  cellText = "Got IDs and time estimates. Waiting " <> ToString[maxWaitTime] <> " seconds for request with the longest wait time to finish.";
  Pause[maxWaitTime];

  (* poll the NCBI webserver to see if our jobs are done *)
  (* do this in order; but the order doesn't matter since we wait for all of them to be ready anyway before continuing *)
  cellText = "Wait time is over for the longest job, polling NCBI to find when all the jobs are done is done";
  statuses = waitForReadyStatus[#, 5] & /@ searchIDs;
  <|"Statuses" -> statuses, "SearchIDs" -> searchIDs|>
];


postBlastQuery[strand_?(DNAQ[#] || RNAQ[#] &)] := Module[
  {sequence, subsequenceMap, subsequencesWithDNAHeads, subsequences, subsequenceBatches, dnaRequests, proteinRequests},

  (* get the string sequences from the Strand and join them together *)
  (*
    it's important to join them together b/c the strand object represents the ligated sequence product of the set of
    sequences contained within the Strand definition
  *)
  subsequenceBatches = getSubsequenceBatches[strand];

  (* map over the http requests to submit all the batch jobs *)
  (* pause 1 second between each to align with a request from NCBI to not pepper them with more than 1 request per second *)
  dnaRequests = Map[
    (
      Pause[1];
      HTTPRequest[NCBIBLASTURL, <|
        "Method" -> "POST",
        "Body" -> <|
          "CMD" -> "PUT", "DATABASE" -> "nt", "PROGRAM" -> "blastn", "EXPECT" -> "0.1",
          "USERNAME" -> "blast", "QUERY" -> toFasta[#],
          "HITLIST_SIZE" -> "5"
        |>
      |>]
    )&,
    subsequenceBatches
  ];

  proteinRequests = Map[
    (
      Pause[1];
      HTTPRequest[NCBIBLASTURL, <|
        "Method" -> "POST",
        "Body" -> <|
          "CMD" -> "PUT", "DATABASE" -> "nr", "PROGRAM" -> "blastx", "EXPECT" -> "0.1",
          "USERNAME" -> "blast", "QUERY" -> toFasta[#],
          "HITLIST_SIZE" -> "5"
        |>
      |>]
    )&,
    subsequenceBatches
  ];

  (* read the response from the web request and return a HTTPResponse object *)
  Flatten[{URLRead /@ dnaRequests, URLRead /@ proteinRequests}]
];

(* peptide overload for a blast query; need to use new database *)
postBlastQuery[strand_?PeptideQ] := Module[
  {conotoxinResult, batches, proteinRequests},

  (* test for conotoxins locally b/c the sequence is known and easy to search for *)
  conotoxinResult = detectConotoxin[strand];
  If[conotoxinResult,
    (* throw the result back to the catch statement to return early before blasting *)
    Throw[conotoxinResult, "conotoxin"]
  ];

  batches = getSubsequenceBatches[strand];

  (* map protein http request over batches *)
  proteinRequests = Map[
    (
      (* pause 1 second between api batch requests so that we align with the NCBI policy for requests per second *)
      (* it's not strictly enforced, but their web server is not built to handle several concurrent requests *)
      Pause[1];
      HTTPRequest[NCBIBLASTURL, <|
        "Method" -> "POST",
        "Body" -> <|
          "CMD" -> "PUT", "DATABASE" -> "nr", "PROGRAM" -> "blastp", "EXPECT" -> "0.1",
          "USERNAME" -> "blast", "QUERY" -> toFasta[#],
          "HITLIST_SIZE" -> "5"
        |>
      |>]
    )&,
    batches
  ];
  URLRead /@ proteinRequests
];

getSubsequenceBatches[strand_] := Module[
  {sequence, namedHead, seqLength, subsequenceMap, typedSubsequences, subsequences, batchLength},
  sequence = Strand[StringJoin[strand[Sequences]]];

  (* these hard-coded values come from the recommended searching procedure of the HHS document *)
  (* specifically, it says to only check DNA subsequences of 200 base pairs, which corresponds to sequences of 66 amino acid sequences *)
  (* NOTE: this may change in the future with more updated HHS guidance, so this is worth keeping an eye on *)
  {namedHead, seqLength} = If[MatchQ[strand, _?DNAQ],
    {DNA, 200},
    {Peptide, 66}
  ];

  (* create a set of subsequences of 200 *)
  subsequenceMap = EmeraldSubsequences[sequence, seqLength];
  typedSubsequences = Flatten[Values[subsequenceMap]];
  subsequences = If[typedSubsequences === {},
    Keys[subsequenceMap],
    Replace[typedSubsequences, namedHead[seq_] :> seq, {1}]
  ];

  (* if we're dealing with peptide sequences, we need to convert to a string encoding understood by ncbi *)
  (* if the input is DNA, it's fine b/c it's already in the correct encoding *)
  subsequences = If[namedHead === Peptide,
    convertPeptideEncoding /@ subsequences,
    subsequences
  ];

  (* partition into batches; since each subsequence is at most 200 basepairs, then we can do up to 480 inputs in one
  batch and still be comfortably below the 100000 character request limit *)
  (* to be safe, we make no batches that can be longer than 95000 *)
  batchLength = Floor[95000 / seqLength];
  Partition[subsequences, UpTo[batchLength]]
];

toFasta[sequences_List]:=Module[
  {fastaStrings},
  fastaStrings = MapIndexed[toFasta[#1, #2[[1]]] &, sequences];

  (* riffle newlines and join them together *)
  StringJoin@@Riffle[fastaStrings, "\n"]
];
toFasta[sequence_String, number_Integer]:=">Test" <> ToString[number] <> "\n" <> sequence;


getBlastIDWithRemainingTimeEstimate[httpResponse_] := Module[
  {responseBody, rid, timeRemaining},
  (* get the body from the http response which should be some horribly long string of html elements *)
  responseBody = httpResponse["Body"];

  (* we only want the RID from the response, and the time remaining, which are somewhere in the body *)
  (*  the string pattern for finding the rid is very simple, so we can just strip it from the body text *)
  rid = First[
    StringCases[responseBody, "RID = " ~~ (rid : WordCharacter ..) :> rid],
    $Failed
  ];

  (* same thing with time remaining; note that TOE stands for time of estimate for some reason *)
  timeRemaining = First[
    StringCases[responseBody, "RTOE = " ~~ (time : WordCharacter ..) :> time],
    $Failed
  ];

  (*
    return the request id so we can poll the blast website for updates, and also return the time remaining estimate
    so we can wait an appopriate amount of time before trying to get status updates
  *)
  {rid, ToExpression[timeRemaining]}
];


waitForReadyStatus[rid_, fibNumberWaitTime_] := Module[
  {currentStatus, waitTime},

  currentStatus = Check[
    pollBlastServer[rid],
    Message[SelectAgentsQ::NCBIFailure];
    Throw[$Failed, "fatalerror"],
    {URLRead::invhttp}
  ];

  Switch[currentStatus,
    "READY", currentStatus,
    "WAITING", (
      waitTime = Fibonacci[fibNumberWaitTime];
      PrintTemporary[
      "waiting for " <> ToString@waitTime <> " seconds..."];
      Pause[waitTime];
      waitForReadyStatus[rid, fibNumberWaitTime + 1]
    ),
    (* keep the following lines broken out for future error handling in which we may want to treat Failures differently
    from unknown or anything else *)
    "FAILURE", $Failed,
    "UNKNOWN", $Failed,
    _, $Failed
  ]
];


pollBlastServer[rid_] := Module[
  {pollURL, pollRequest, pollResponse},
  (* set up the get request that we need to parse to see if our results are ready *)
  pollURL = "https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi?CMD=Get&FORMAT_OBJECT=SearchInfo&RID=" <> rid;

  (* make the request object and get the response from the web *)
  pollRequest = HTTPRequest[pollURL];
  pollResponse = URLRead[pollRequest];

  (* parse the body of the response to find the status value and return *)
  First[
    StringCases[pollResponse["Body"], "Status=" ~~ (status : WordCharacter ..) :> status],
    $Failed
  ]
];


downloadBlastResults[rid_] := Module[
  {resultsURL, resultsRequest, resultsResponse, rawBody, notEndOfLine, body},
  (* create the URL from the request ID *)
  (* NOTE: we are getting the XML form of the results so we can easily parse it in mathematica *)
  resultsURL = "https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi?CMD=Get&FORMAT_TYPE=XML&RID=" <> rid;

  (* make the request object *)
  resultsRequest = HTTPRequest[resultsURL];

  (* actually get the info from the website *)
  resultsResponse = URLRead[resultsRequest];

  (* log this on manifold to check what's happening in 12.0.1; there's some super weird XMLParser error *)
  ECL`ManifoldEcho[resultsResponse["Body"], "result from URLRead"];

  (* for some stupid reason MM 12.0.1 can't understand the DTD URL in the header of the XML; very likely is just a Mathematica bug *)
  (* it works on windows 12.0.1 but Linux 12.0.1 doesn't work correctly; but it turns out MM doesn't need the first two lines anyway *)
  rawBody = resultsResponse["Body"];
  notEndOfLine = Except["\n"];
  body = StringReplace[rawBody, StartOfString ~~ notEndOfLine ... ~~ "\n" ~~ notEndOfLine ... ~~ "\n" -> ""];

  (* just return the body as an XMLObject *)
  ImportString[body, "XML"]
];


XMLElementToAssociation[XMLElement[tag_, attribs_, vals_]] := Module[
  {resolvedValues, resolvedAttributes},

  (* recursively convert all elements into associations *)
  resolvedValues = XMLElementToAssociation /@ vals;

  (* ignore the attributes if there are none *)
  (* if the attributes exist, create a key-value pair that will be appended to the output association *)
  resolvedAttributes = If[attribs =!= {},
    "Attributes" -> Association[attribs],
    Nothing
  ];
  <|tag -> If[MatchQ[resolvedValues, {_Association ..}],
    (* if the values are associations themselves, then we want to merge them into the same association, to reduce the number of redundant keys *)
      Merge[
        resolvedValues,
        (* the merge function de-references the list from the input *)
        (* the list comes from the upstream URLRead, and we want to remove it now *)
        If[MatchQ[#, {_}],
          First[#],
          Identity[#]
        ] &
      ],
      resolvedValues
    ],
    (* append the resolved attributes to the end of the association *)
    resolvedAttributes
  |>
];
(* overload that represents the bottom of the recursion stack *)
(* when a value of an XMLElement association is not an XMLElement, then just return itself, which stops the recursion *)
XMLElementToAssociation[str_] := str;


dangerousAgentQ[{}, False] := False;
dangerousAgentQ[{}, True] := {};
dangerousAgentQ[hitLists_, reportQ_] := Module[
  {booleansPerRequest},
  (* there are multiple requests needed to blast; they represent each dna/peptide sequence to test if any are dangerous *)
  (* so we have to find out if each hit result is dangerous in each request *)
  booleansPerRequest = Map[dangerousAgentQPerRequest[#, reportQ] &, hitLists];

  (* make sure everything is a flat list here; NCBI has a nasty habit of adding unnecessary lists around things *)
  Flatten[booleansPerRequest]
];
dangerousAgentQPerRequest[hits_, reportQ_] := Module[
  {hitList, hitDefinition, booleanTests},
  (* there is still one layer of "Hit"->{<|good info|>, <|...|>, ...} that needs to be parsed to get to the association with the info we want *)
  hitList = Lookup[hits, "Hit"];
  (* get the hit definition from the first description, which is just a description *)
  hitDefinition = Flatten[Lookup[First[hitList], "Hit_def"]];

  (* we are going to map the hit definition into the set of select agent q functions *)
  (* that outputs a list of boolean values, and if any one of them is true, then we've found a select agent *)
  booleanTests = Flatten[(#[hitDefinition] &) /@ SelectAgentsQFunctions];
  If[reportQ,
    PickList[selectAgentsList, booleanTests],
    Or @@ booleanTests
  ]
];


findBlastHitResults[xmlOutput_] := Module[
  {blastOutput, blastOutputAssociation, blastIteration},
  (* get the blast output element from the xml output *)
  blastOutput = First[Cases[xmlOutput, XMLElement["BlastOutput", ___], Infinity], $Failed];
  blastOutputAssociation = XMLElementToAssociation[blastOutput];

  (* find the iteration results key from blast output *)
  blastIteration = ToList[Lookup[Lookup[Lookup[blastOutputAssociation, "BlastOutput"], "BlastOutput_iterations"], "Iteration"]];

  Flatten[Lookup[blastIteration, "Iteration_hits"]]
];


(* first iteration of q functions is to check for select agent names in the descriptions *)
SelectAgentsQFunctions := StringContainsQ[#, IgnoreCase -> True] & /@ selectAgentsList;
selectAgentsList = {
  "Abrin",
  "Bacillus cereus Biovar anthracis",
  "Botulinum neurotoxin",
  "Clostridium botulinum" ~~ ___ ~~ "neurotoxin",
  "neurotoxin" ~~ ___ ~~ "Clostridium botulinum",
  "Conotoxin",
  "Coxiella burnetii",
  "Crimean-Congo haemorrhagic fever virus",
  "Diacetoxyscirpenol",
  "Eastern Equine Encephalitis virus",
  "Ebola virus",
  "Francisella tularensis",
  "Lassa fever virus",
  "Lujo virus",
  "Marburg virus",
  "Mpox virus",
  "1918 Influenza virus",
  "Ricin",
  "Rickettsia prowazekii",
  "SARS-CoV",
  "SARS-associated coronavirus",
  "SARS-CoV-2 chimeric",
  "Saxitoxin",
  "Haemorrhagic Fever",
  "Chapare",
  "Guanarito ",
  "Junin ",
  "Machupo ",
  "Sabia ",
  "Staphylococcal enterotoxin",
  "T-2 toxin",
  "Tetrodotoxin",
  "encephalitis complex flavivirus",
  "encephalitis complex flavi-virus",
  "encephalitis complex virus",
  "Kyasanur Forest disease virus",
  "Omsk hemorrhagic fever virus",
  "Variola ",
  "Yersinia pestis",
  "Bacillus anthracis",
  "Brucella abortus",
  "Brucella melitensis",
  "Brucella suis",
  "Burkholderia mallei",
  "Burkholderia pseudomallei",
  "Hendra virus",
  "Nipah virus",
  "Rift Valley fever virus",
  "Venezuelan equine encephalitis virus",
  "African horse sickness virus",
  "African swine fever virus",
  "Avian influenza virus",
  "Classical swine fever virus",
  "Foot-and-mouth disease virus",
  "Goat pox virus",
  "Lumpy skin disease virus",
  "Mycoplasma capricolum",
  "Mycoplasma mycoides",
  "Newcastle disease virus",
  "Peste des petits ruminants virus",
  "Rinderpest virus",
  "Sheep pox virus",
  "Swine vesicular disease virus",
  "Coniothyrium glycines",
  "Phoma glycinicola and Pyrenochaeta glycines",
  "Peronosclerospora philippinensis",
  "Peronosclerospora sacchari",
  "Ralstonia solanacearum",
  "Rathayibacter toxicus",
  "Sclerophthora rayssiae",
  "Synchytrium endobioticum",
  "Xanthomonas oryzae"
};

(* helper that converts ECL peptide sequence encodings to canonical peptide encodings understood by ncbi *)
convertPeptideEncoding[sequence_] := StringReplace[sequence, alternateEncodings];

(* hard code the alternate encodings here to save a download call *)
(* also hardens us against someone changing the alternate encodings on constellation b/c these are the accepted encodings by ncbi *)
(* which is very unlikely to change any time in the next several decades *)
alternateEncodings := {
  "Ala" -> "A", "Glu" -> "E", "Leu" -> "L", "Ser" -> "S", "Arg" -> "R",
  "Gln" -> "Q", "Lys" -> "K", "Thr" -> "T", "Asn" -> "N",
 "Gly" -> "G", "Met" -> "M", "Trp" -> "W", "Asp" -> "D", "His" -> "H",
  "Phe" -> "F", "Tyr" -> "Y", "Cys" -> "C", "Ile" -> "I",
 "Pro" -> "P", "Val" -> "V", "Pyl" -> "O"
};


(* helper that detects conotoxin subsequences within a peptide sequence *)
detectConotoxin[strand_] := Module[
  {sequence, x1Filter, x2Filter, x3Filter, x4Filter, x5Filter, x6Filter, x7Filter, conotoxinPattern},

  (* this function should only receive a strand with a sequence that has been combined together *)
  (* so get the string sequence first *)
  sequence = strand[Sequences][[1]];

  (* create the connotoxin sub-patterns *)
  (* a connotoxin is given by: X1 Cys Cys X2 Pro Ala Cys Gly X3 X4 X5 X6 Cys X7 *)
  (* where the x's represent combined amino acid alternatives that are unique to that position in the sequence *)
  x1Filter = Repeated[LetterCharacter, 3];
  x2Filter = ("Asn" | "His");
  x3Filter = ("Arg" | "Lys");
  x4Filter = ("Asn" | "His" | "Lys" | "Arg" | "Tyr" | "Trp" | "Phe");
  x5Filter = ("Tyr" | "Phe" | "Trp");
  x6Filter = ("Ser" | "Thr" | "Glu" | "Asp" | "Gln" | "Asn");
  x7Filter = (Repeated[LetterCharacter, 3] | EndOfString);

  (* construct the string pattern from the sub patterns defined above *)
  conotoxinPattern = x1Filter ~~ "CysCys" ~~ x2Filter ~~ "ProAlaCysGly" ~~ x3Filter ~~ x4Filter ~~ x5Filter ~~ x6Filter ~~ "Cys" ~~ x7Filter;

  (* test if the sequence contains this pattern *)
  StringContainsQ[sequence, conotoxinPattern]
];


(* ------------------------------------------------------------------------------ *)
(* ----------------------- TESTING HELPERS -------------------------------------- *)
(* ------------------------------------------------------------------------------ *)


testRidRtoeResponse[testID_] := StringJoin[
  "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \
  \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">
  <html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\" lang=\"en\">
  <head>
  <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />
  <meta name=\"jig\" content=\"ncbitoggler ncbiautocomplete\"/>
  <meta name=\"ncbi_app\" content=\"static\" />
  <meta name=\"ncbi_pdid\" content=\"blastformatreq\" />
  <meta name=\"ncbi_stat\" content=\"false\" />
  <meta name=\"ncbi_sessionid\" content=\"219103AB44A9F531_0000SID\" />
  <meta name=\"ncbi_phid\" content=\"219103AB44A9F5310000000000000001\" />
  <title>NCBI Blast</title>
  <body>
  <!--QBlastInfoBegin
      RID = ",
  testID,
  "    RTOE = 1
  QBlastInfoEnd
  </body>
  </html>"
];


testStatusCheckBody[] := StringJoin[
  "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \
  \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\\n<html \
  xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\" \
  lang=\"en\">\\n<head>\\n<meta http-equiv=\"Content-Type\" \
  content=\"text/html; charset=UTF-8\" />\\n<meta name=\"jig\" content=\
  \"ncbitoggler\"/>\\n<meta name=\"ncbitoggler\" \
  content=\"animation:'none'\"/>\\n<title>NCBI Blast:</title>",
  "QBlastInfoBegin
    Status=READY
  QBlastInfoEnd",
  "</html>"
];


(* edit the botulinum neurotoxins hit descriptions to make it "safe" *)
testBlastDownloadWithSafeHits[] := Module[
  {badHitXML},
  badHitXML = testBlastDownloadWithBadHits[];

  (* replace any text for Clostridium botulinum and neurotoxin with safe words and scramble the sequences *)
  StringReplace[badHitXML, {"Clostridium botulinum" -> "Saccharomyces Cerevisae", "neurotoxin" -> "mitochondria", "TT" -> "AG", "CC" -> "TG"}]
];

(* actual blast response containing entries for botulinum neurotoxins *)
testBlastDownloadWithBadHits[] := Module[{},
"<?xml version=\"1.0\"?>\n<!DOCTYPE BlastOutput PUBLIC \
\"-//NCBI//NCBI BlastOutput/EN\" \
\"http://www.ncbi.nlm.nih.gov/dtd/NCBI_BlastOutput.dtd\">\n\
<BlastOutput>\n  <BlastOutput_program>blastn</BlastOutput_program>\n  \
<BlastOutput_version>BLASTN 2.14.0+</BlastOutput_version>\n  \
<BlastOutput_reference>Stephen F. Altschul, Thomas L. Madden, \
Alejandro A. Sch&amp;auml;ffer, Jinghui Zhang, Zheng Zhang, Webb \
Miller, and David J. Lipman (1997), &quot;Gapped BLAST and PSI-BLAST: \
a new generation of protein database search programs&quot;, Nucleic \
Acids Res. 25:3389-3402.</BlastOutput_reference>\n  \
<BlastOutput_db>nt</BlastOutput_db>\n  \
<BlastOutput_query-ID>Query_1879</BlastOutput_query-ID>\n  \
<BlastOutput_query-def>Test1</BlastOutput_query-def>\n  \
<BlastOutput_query-len>198</BlastOutput_query-len>\n  \
<BlastOutput_param>\n    <Parameters>\n      \
<Parameters_expect>0.1</Parameters_expect>\n      \
<Parameters_sc-match>2</Parameters_sc-match>\n      \
<Parameters_sc-mismatch>-3</Parameters_sc-mismatch>\n      \
<Parameters_gap-open>5</Parameters_gap-open>\n      \
<Parameters_gap-extend>2</Parameters_gap-extend>\n      \
<Parameters_filter>L;m;</Parameters_filter>\n    </Parameters>\n  \
</BlastOutput_param>\n<BlastOutput_iterations>\n<Iteration>\n  \
<Iteration_iter-num>1</Iteration_iter-num>\n  \
<Iteration_query-ID>Query_1879</Iteration_query-ID>\n  \
<Iteration_query-def>Test1</Iteration_query-def>\n  \
<Iteration_query-len>198</Iteration_query-len>\n<Iteration_hits>\n\
<Hit>\n  <Hit_num>1</Hit_num>\n  \
<Hit_id>gi|672096651|gb|KF878259.1|</Hit_id>\n  <Hit_def>Clostridium \
botulinum strain 610F neurotoxin type F (boNT) gene, complete \
cds</Hit_def>\n  <Hit_accession>KF878259</Hit_accession>\n  \
<Hit_len>3828</Hit_len>\n  <Hit_hsps>\n    <Hsp>\n      \
<Hsp_num>1</Hsp_num>\n      <Hsp_bit-score>358.353</Hsp_bit-score>\n  \
    <Hsp_score>396</Hsp_score>\n      \
<Hsp_evalue>2.37758e-94</Hsp_evalue>\n      \
<Hsp_query-from>1</Hsp_query-from>\n      \
<Hsp_query-to>198</Hsp_query-to>\n      \
<Hsp_hit-from>1</Hsp_hit-from>\n      <Hsp_hit-to>198</Hsp_hit-to>\n  \
    <Hsp_query-frame>1</Hsp_query-frame>\n      \
<Hsp_hit-frame>1</Hsp_hit-frame>\n      \
<Hsp_identity>198</Hsp_identity>\n      \
<Hsp_positive>198</Hsp_positive>\n      <Hsp_gaps>0</Hsp_gaps>\n      \
<Hsp_align-len>198</Hsp_align-len>\n      \
<Hsp_qseq>\
ATGCCAGTTGCAATAAATAGTTTTAATTATAATGACCCTGTTAATGATGATACAATTTTATACATGCAGA\
TACCATATAAAGAAAAAAGTAAAAAATATTATAAAGCTTTTGAGATTATGCGTAATGTTTGGATAATTCC\
TGAGAGAAATACAATAGGAACGAATCCTAGTGATTTTGATCCACCGGCTTCATTAAAG</Hsp_qseq>\
\n      <Hsp_hseq>\
ATGCCAGTTGCAATAAATAGTTTTAATTATAATGACCCTGTTAATGATGATACAATTTTATACATGCAGA\
TACCATATAAAGAAAAAAGTAAAAAATATTATAAAGCTTTTGAGATTATGCGTAATGTTTGGATAATTCC\
TGAGAGAAATACAATAGGAACGAATCCTAGTGATTTTGATCCACCGGCTTCATTAAAG</Hsp_hseq>\
\n      <Hsp_midline>||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||</Hsp_midline>\n    </Hsp>\n  </Hit_hsps>\n</Hit>\n<Hit>\n  \
<Hit_num>2</Hit_num>\n  <Hit_id>gi|496528630|gb|KC516868.1|</Hit_id>\n\
  <Hit_def>Clostridium botulinum strain IFR 06/001 neurotoxin gene \
cluster region &gt;gi|496528691|gb|KC516869.1| Clostridium botulinum \
strain IFR 06/005 neurotoxin gene cluster region \
&gt;gi|496528742|gb|KC516870.1| Clostridium botulinum strain Craig610 \
neurotoxin gene cluster region &gt;gi|496528848|gb|KC516872.1| \
Clostridium botulinum strain HobbsFT10 neurotoxin gene cluster \
region</Hit_def>\n  <Hit_accession>KC516868</Hit_accession>\n  \
<Hit_len>50000</Hit_len>\n  <Hit_hsps>\n    <Hsp>\n      \
<Hsp_num>1</Hsp_num>\n      <Hsp_bit-score>358.353</Hsp_bit-score>\n  \
    <Hsp_score>396</Hsp_score>\n      \
<Hsp_evalue>2.37758e-94</Hsp_evalue>\n      \
<Hsp_query-from>1</Hsp_query-from>\n      \
<Hsp_query-to>198</Hsp_query-to>\n      \
<Hsp_hit-from>29236</Hsp_hit-from>\n      \
<Hsp_hit-to>29433</Hsp_hit-to>\n      \
<Hsp_query-frame>1</Hsp_query-frame>\n      \
<Hsp_hit-frame>1</Hsp_hit-frame>\n      \
<Hsp_identity>198</Hsp_identity>\n      \
<Hsp_positive>198</Hsp_positive>\n      <Hsp_gaps>0</Hsp_gaps>\n      \
<Hsp_align-len>198</Hsp_align-len>\n      \
<Hsp_qseq>\
ATGCCAGTTGCAATAAATAGTTTTAATTATAATGACCCTGTTAATGATGATACAATTTTATACATGCAGA\
TACCATATAAAGAAAAAAGTAAAAAATATTATAAAGCTTTTGAGATTATGCGTAATGTTTGGATAATTCC\
TGAGAGAAATACAATAGGAACGAATCCTAGTGATTTTGATCCACCGGCTTCATTAAAG</Hsp_qseq>\
\n      <Hsp_hseq>\
ATGCCAGTTGCAATAAATAGTTTTAATTATAATGACCCTGTTAATGATGATACAATTTTATACATGCAGA\
TACCATATAAAGAAAAAAGTAAAAAATATTATAAAGCTTTTGAGATTATGCGTAATGTTTGGATAATTCC\
TGAGAGAAATACAATAGGAACGAATCCTAGTGATTTTGATCCACCGGCTTCATTAAAG</Hsp_hseq>\
\n      <Hsp_midline>||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||<\
/Hsp_midline>\n    </Hsp>\n  </Hit_hsps>\n</Hit>\n<Hit>\n  \
<Hit_num>3</Hit_num>\n  <Hit_id>gi|282160588|gb|GU213226.1|</Hit_id>\n\
  <Hit_def>Clostridium botulinum strain VPI 2382 botulinum neurotoxin \
type F gene, complete cds &gt;gi|282160596|gb|GU213230.1| Clostridium \
botulinum strain KA-173 botulinum neurotoxin type F gene, complete \
cds</Hit_def>\n  <Hit_accession>GU213226</Hit_accession>\n  \
<Hit_len>3828</Hit_len>\n  <Hit_hsps>\n    <Hsp>\n      \
<Hsp_num>1</Hsp_num>\n      <Hsp_bit-score>358.353</Hsp_bit-score>\n  \
    <Hsp_score>396</Hsp_score>\n      \
<Hsp_evalue>2.37758e-94</Hsp_evalue>\n      \
<Hsp_query-from>1</Hsp_query-from>\n      \
<Hsp_query-to>198</Hsp_query-to>\n      \
<Hsp_hit-from>1</Hsp_hit-from>\n      <Hsp_hit-to>198</Hsp_hit-to>\n  \
    <Hsp_query-frame>1</Hsp_query-frame>\n      \
<Hsp_hit-frame>1</Hsp_hit-frame>\n      \
<Hsp_identity>198</Hsp_identity>\n      \
<Hsp_positive>198</Hsp_positive>\n      <Hsp_gaps>0</Hsp_gaps>\n      \
<Hsp_align-len>198</Hsp_align-len>\n      \
<Hsp_qseq>\
ATGCCAGTTGCAATAAATAGTTTTAATTATAATGACCCTGTTAATGATGATACAATTTTATACATGCAGA\
TACCATATAAAGAAAAAAGTAAAAAATATTATAAAGCTTTTGAGATTATGCGTAATGTTTGGATAATTCC\
TGAGAGAAATACAATAGGAACGAATCCTAGTGATTTTGATCCACCGGCTTCATTAAAG</Hsp_qseq>\
\n      <Hsp_hseq>\
ATGCCAGTTGCAATAAATAGTTTTAATTATAATGACCCTGTTAATGATGATACAATTTTATACATGCAGA\
TACCATATAAAGAAAAAAGTAAAAAATATTATAAAGCTTTTGAGATTATGCGTAATGTTTGGATAATTCC\
TGAGAGAAATACAATAGGAACGAATCCTAGTGATTTTGATCCACCGGCTTCATTAAAG</Hsp_hseq>\
\n      <Hsp_midline>||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||<\
/Hsp_midline>\n    </Hsp>\n  </Hit_hsps>\n</Hit>\n<Hit>\n  \
<Hit_num>4</Hit_num>\n  <Hit_id>gi|728867886|gb|CP006903.1|</Hit_id>\n\
  <Hit_def>Clostridium botulinum 202F, complete genome</Hit_def>\n  \
<Hit_accession>CP006903</Hit_accession>\n  <Hit_len>3874462</Hit_len>\
\n  <Hit_hsps>\n    <Hsp>\n      <Hsp_num>1</Hsp_num>\n      \
<Hsp_bit-score>353.845</Hsp_bit-score>\n      \
<Hsp_score>391</Hsp_score>\n      \
<Hsp_evalue>1.01097e-92</Hsp_evalue>\n      \
<Hsp_query-from>1</Hsp_query-from>\n      \
<Hsp_query-to>198</Hsp_query-to>\n      \
<Hsp_hit-from>403534</Hsp_hit-from>\n      \
<Hsp_hit-to>403731</Hsp_hit-to>\n      \
<Hsp_query-frame>1</Hsp_query-frame>\n      \
<Hsp_hit-frame>1</Hsp_hit-frame>\n      \
<Hsp_identity>197</Hsp_identity>\n      \
<Hsp_positive>197</Hsp_positive>\n      <Hsp_gaps>0</Hsp_gaps>\n      \
<Hsp_align-len>198</Hsp_align-len>\n      \
<Hsp_qseq>\
ATGCCAGTTGCAATAAATAGTTTTAATTATAATGACCCTGTTAATGATGATACAATTTTATACATGCAGA\
TACCATATAAAGAAAAAAGTAAAAAATATTATAAAGCTTTTGAGATTATGCGTAATGTTTGGATAATTCC\
TGAGAGAAATACAATAGGAACGAATCCTAGTGATTTTGATCCACCGGCTTCATTAAAG</Hsp_qseq>\
\n      <Hsp_hseq>\
ATGCCAGTTGCAATAAATAGTTTTAATTATAATGACCCTGTTAATGATGATACAATTTTATACATGCAGA\
TACCATATGAAGAAAAAAGTAAAAAATATTATAAAGCTTTTGAGATTATGCGTAATGTTTGGATAATTCC\
TGAGAGAAATACAATAGGAACGAATCCTAGTGATTTTGATCCACCGGCTTCATTAAAG</Hsp_hseq>\
\n      <Hsp_midline>|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| \
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\
</Hsp_midline>\n    </Hsp>\n  </Hit_hsps>\n</Hit>\n<Hit>\n  \
<Hit_num>5</Hit_num>\n  <Hit_id>gi|496528801|gb|KC516871.1|</Hit_id>\n\
  <Hit_def>Clostridium botulinum strain Eklund202F neurotoxin gene \
cluster region</Hit_def>\n  <Hit_accession>KC516871</Hit_accession>\n \
 <Hit_len>49985</Hit_len>\n  <Hit_hsps>\n    <Hsp>\n      \
<Hsp_num>1</Hsp_num>\n      <Hsp_bit-score>353.845</Hsp_bit-score>\n  \
    <Hsp_score>391</Hsp_score>\n      \
<Hsp_evalue>1.01097e-92</Hsp_evalue>\n      \
<Hsp_query-from>1</Hsp_query-from>\n      \
<Hsp_query-to>198</Hsp_query-to>\n      \
<Hsp_hit-from>29236</Hsp_hit-from>\n      \
<Hsp_hit-to>29433</Hsp_hit-to>\n      \
<Hsp_query-frame>1</Hsp_query-frame>\n      \
<Hsp_hit-frame>1</Hsp_hit-frame>\n      \
<Hsp_identity>197</Hsp_identity>\n      \
<Hsp_positive>197</Hsp_positive>\n      <Hsp_gaps>0</Hsp_gaps>\n      \
<Hsp_align-len>198</Hsp_align-len>\n      \
<Hsp_qseq>\
ATGCCAGTTGCAATAAATAGTTTTAATTATAATGACCCTGTTAATGATGATACAATTTTATACATGCAGA\
TACCATATAAAGAAAAAAGTAAAAAATATTATAAAGCTTTTGAGATTATGCGTAATGTTTGGATAATTCC\
TGAGAGAAATACAATAGGAACGAATCCTAGTGATTTTGATCCACCGGCTTCATTAAAG</Hsp_qseq>\
\n      <Hsp_hseq>\
ATGCCAGTTGCAATAAATAGTTTTAATTATAATGACCCTGTTAATGATGATACAATTTTATACATGCAGA\
TACCATATGAAGAAAAAAGTAAAAAATATTATAAAGCTTTTGAGATTATGCGTAATGTTTGGATAATTCC\
TGAGAGAAATACAATAGGAACGAATCCTAGTGATTTTGATCCACCGGCTTCATTAAAG</Hsp_hseq>\
\n      <Hsp_midline>|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| \
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\
</Hsp_midline>\n    </Hsp>\n  </Hit_hsps>\n</Hit>\n</Iteration_hits>\n\
  <Iteration_stat>\n    <Statistics>\n      \
<Statistics_db-num>92598615</Statistics_db-num>\n      \
<Statistics_db-len>1420100882</Statistics_db-len>\n      \
<Statistics_hsp-len>0</Statistics_hsp-len>\n      \
<Statistics_eff-space>0</Statistics_eff-space>\n      \
<Statistics_kappa>0.41</Statistics_kappa>\n      \
<Statistics_lambda>0.625</Statistics_lambda>\n      \
<Statistics_entropy>0.78</Statistics_entropy>\n    </Statistics>\n  \
</Iteration_stat>\n</Iteration>\n</BlastOutput_iterations>\n\
</BlastOutput>\n"
];


testBlastDownloadWithNoHits[] := Module[{},
  "<?xml version=\"1.0\"?>\n<!DOCTYPE BlastOutput PUBLIC \
  \"-//NCBI//NCBI BlastOutput/EN\" \
  \"http://www.ncbi.nlm.nih.gov/dtd/NCBI_BlastOutput.dtd\">\n\
  <BlastOutput>\n  <BlastOutput_program>blastn</BlastOutput_program>\n  \
  <BlastOutput_version>BLASTN 2.14.0+</BlastOutput_version>\n  \
  <BlastOutput_reference>Stephen F. Altschul, Thomas L. Madden, \
  Alejandro A. Sch&amp;auml;ffer, Jinghui Zhang, Zheng Zhang, Webb \
  Miller, and David J. Lipman (1997), &quot;Gapped BLAST and PSI-BLAST: \
  a new generation of protein database search programs&quot;, Nucleic \
  Acids Res. 25:3389-3402.</BlastOutput_reference>\n  \
  <BlastOutput_db>nt</BlastOutput_db>\n  \
  <BlastOutput_query-ID>Query_101717</BlastOutput_query-ID>\n  \
  <BlastOutput_query-def>Test1</BlastOutput_query-def>\n  \
  <BlastOutput_query-len>8</BlastOutput_query-len>\n  \
  <BlastOutput_param>\n    <Parameters>\n      \
  <Parameters_expect>0.1</Parameters_expect>\n      \
  <Parameters_sc-match>2</Parameters_sc-match>\n      \
  <Parameters_sc-mismatch>-3</Parameters_sc-mismatch>\n      \
  <Parameters_gap-open>5</Parameters_gap-open>\n      \
  <Parameters_gap-extend>2</Parameters_gap-extend>\n      \
  <Parameters_filter>L;m;</Parameters_filter>\n    </Parameters>\n  \
  </BlastOutput_param>\n<BlastOutput_iterations>\n<Iteration>\n  \
  <Iteration_iter-num>1</Iteration_iter-num>\n  \
  <Iteration_query-ID>Query_101717</Iteration_query-ID>\n  \
  <Iteration_query-def>Test1</Iteration_query-def>\n  \
  <Iteration_query-len>8</Iteration_query-len>\n<Iteration_hits>\n\
  </Iteration_hits>\n  <Iteration_stat>\n    <Statistics>\n      \
  <Statistics_db-num>92598615</Statistics_db-num>\n      \
  <Statistics_db-len>1420100882</Statistics_db-len>\n      \
  <Statistics_hsp-len>0</Statistics_hsp-len>\n      \
  <Statistics_eff-space>0</Statistics_eff-space>\n      \
  <Statistics_kappa>0.41</Statistics_kappa>\n      \
  <Statistics_lambda>0.625</Statistics_lambda>\n      \
  <Statistics_entropy>0.78</Statistics_entropy>\n    </Statistics>\n  \
  </Iteration_stat>\n</Iteration>\n</BlastOutput_iterations>\n\
  </BlastOutput>\n"
];