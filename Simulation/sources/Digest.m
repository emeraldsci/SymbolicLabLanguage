(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*SimulateDigest*)

(* patterns *)
ProteaseP = Alternatives[
    Trypsin,
    LysC,
    Chymotrypsin,
    GlutamylEndopeptidase,
    AlphaLyticProtease,
    Iodobenzoate,
    Iodosobenzoate,
    StaphylococcalProtease,
    ProlineEndopeptidase,
    PepsinA,
    CyanogenBromide,
    Clostripain,
    ElastaseTrypinChymoTrypsin,
    FormicAcid,
    LysN,
    AspN,
    ArgC
];

(* ------------------ messages ------------------- *)
SimulateDigest::UnequalLengthInputs = "The length of the input expressions (either samples, states, or strands) does not match the length of the proteases.";
SimulateDigest::FatalError = "Uh oh, something went wrong internally. If this issue is reproducible, please file a ticket with the appropriate party, and it will be addressed as soon as possible.";
SimulateDigest::NoPeptides = "No peptides were found in the input state, `1`. Please amend the state to include any peptides you'd like to digest.";
Warning::NullConcentrationsFound = "There were Null concentrations found in the input sample objects. To make a valid State output, the Null is replaced with 1 ArbitraryUnit. This means that the output State expression will not be valid for downstream analyses or simulations like SimulateKinetics.";
SimulateDigest::InvalidInput = "Something was wrong with one or more of the input objects. Please check that the samples have a protein or peptide identity model in the Composition field, and check that the Molecule field of the protein/peptide identity models are populated.";
SimulateDigest::NoProteins = "The input samples did not contain any protein objects, which prevents the digest simulation from proceeding. Please choose new samples to simulate or update the Composition field of the samples.";
SimulateDigest::InvalidIdentityModels = "SimulateDigest will only work correctly on molecules that pass PeptideQ. Please make sure to pass identity models that contain peptides."


(* ------------------ Options -----------------------------------*)
DefineOptions[SimulateDigest,
    Options :> {
        OutputOption
    }
];

(* ------------------ identity model overload ------------------------- *)
(* NOTE: for all overloads, I'm suppressing the ability to have SimulateDigest[singletonInput, listOfProteases] because there is an ambiguous meaning,
and it would be best to add the functionality for digesting a single input with many proteases at once rather than index matching the inputs to the proteases *)
SimulateDigest[identityModel: ObjectP[{Model[Molecule, Oligomer], Model[Molecule, Protein]}], protease: ProteaseP, ops: OptionsPattern[]] := Module[
    {output, fixedResults},
    output = SimulateDigest[{identityModel}, {protease}, ops];
    fixedResults = applyFuncToResultOutput[output, First[#, $Failed] &,  ops];
    applyFuncToOutputOption[fixedResults, First[#, $Failed] &, Preview, ops]
];

SimulateDigest[
    identityModels: {ObjectP[{Model[Molecule, Oligomer], Model[Molecule, Protein]}]..}, protease: ProteaseP, ops: OptionsPattern[]
] := SimulateDigest[identityModels, ConstantArray[protease, Length[identityModels]], ops];
SimulateDigest[identityModels: {ObjectP[{Model[Molecule, Oligomer], Model[Molecule, Protein]}]..}, proteases: {ProteaseP..}, ops: OptionsPattern[]] := Module[
    {molecules, strands, badObjects},
    (* download the molecules from the identity models *)
    molecules = Download[identityModels, Molecule];

    (* check for null molecules, and fail if any are found *)
    If[MemberQ[molecules, Null],
        Message[SimulateDigest::InvalidInput];
        Return[$Failed]
    ];

    (* check that our strands contain only peptides *)
    strands = Map[resolveStrandsForChecking, molecules];
    If[Not[MatchQ[strands, {ListableP[_?(PeptideQ)]..}]],
        badObjects = PickList[identityModels, strands, _?(Not[PeptideQ[#]] &)];
        Message[SimulateDigest::InvalidIdentityModels, badObjects];
        Return[$Failed]
    ];

    (* pass the strands into the main function *)
    SimulateDigest[molecules, proteases, ops]
];

(* helper that dereferences strands when the molecule input is a Structure, and leaves all other inputs *)
resolveStrandsForChecking[input_] := If[MatchQ[input, StructureP],
    input[Strands],
    input
];

(* ------------------ structure overload  ------------------------- *)
SimulateDigest[structure: StructureP, protease: ProteaseP, ops: OptionsPattern[]] := Module[
    {output, fixedResults},
    output = SimulateDigest[{structure}, {protease}, ops];
    fixedResults = applyFuncToResultOutput[output, First[#, $Failed] &,  ops];
    applyFuncToOutputOption[fixedResults, First[#, $Failed] &, Preview, ops]
];

SimulateDigest[structures: {StructureP..}, protease: ProteaseP, ops: OptionsPattern[]] := SimulateDigest[structures, ConstantArray[protease, Length[structures]], ops];
SimulateDigest[structures: {StructureP..}, proteases: {ProteaseP..}, ops: OptionsPattern[]] := Module[
    {strands, outputs},
    strands = Map[#[Strands] &, structures];

    If[Length[structures] =!= Length[proteases],
        Message[SimulateDigest::UnequalLengthInputs];
        Return[$Failed]
    ];

    (* safe to map over the set of strands for each structure b/c there are no downloads in the strand overload *)
    outputs = MapThread[SimulateDigest[#1, ConstantArray[#2, Length[#1]]] &, {strands, proteases}];

    (* flatten each of list of strands at level 1, so that each structure yields 1 flat list of strands *)
    Map[Flatten, outputs]
];

(* ------------------ strand overload --------------------------------- *)
SimulateDigest[strand: StrandP, protease: ProteaseP, ops: OptionsPattern[]] := Module[
    {output, fixedResults},
    output = SimulateDigest[{strand}, {protease}, ops];
    fixedResults = applyFuncToResultOutput[output, First[#, $Failed] &,  ops];
    applyFuncToOutputOption[fixedResults, First[#, $Failed] &, Preview, ops]
];

(* helper that applies an input function to only the Result part of the Output *)
(* for instance if Output -> {Result, Tests} then this helper will apply the function to the first element in the output list *)
applyFuncToResultOutput[output_, resultFunc_, ops:OptionsPattern[]] := applyFuncToOutputOption[output, resultFunc, Result, ops];
applyFuncToOutputOption[output_, resultFunc_, actualOutputOption_, ops:OptionsPattern[]] := Module[
    {outputOption, outputPairs},
    outputOption = OptionDefault[OptionValue[SimulateDigest, ops, Output]];
    Which[
        outputOption===actualOutputOption, resultFunc[output],
        MemberQ[outputOption, actualOutputOption],
            outputPairs = Transpose[{outputOption, output}];
            Replace[outputPairs, {{actualOutputOption, out_} :> resultFunc[out], {_, out_} :> out}, {1}],
        True, output
    ]
];


SimulateDigest[strands: {StrandP..}, protease: ProteaseP, ops: OptionsPattern[]] := SimulateDigest[strands, ConstantArray[protease, Length[strands]], ops];
SimulateDigest[strands: {StrandP..}, proteases: {ProteaseP..}, ops: OptionsPattern[]] := Module[
    {
        concs, temporaryStates, outputOption, replacedOption, resolvedOutput, digestedStates,
        fixedResults, previewOutput, partialOutputRules, outputRules
    },

    (* convert to state *)
    concs = ConstantArray[1 Millimolar, Length[strands]];
    temporaryStates = State /@ (Transpose[{strands, concs}]);

    (* get the output option, and check if it is Preview *)
    (* if it is, we have to run in Results mode, get the States back, dereference strands, then plot them *)
    outputOption = OptionDefault[OptionValue[SimulateDigest, ops, Output]];
    replacedOption = ReplaceAll[outputOption, Preview -> Result];

    (* delete duplicates from the option if necessary *)
    resolvedOutput = If[MatchQ[replacedOption, _List],
        DeleteDuplicates[replacedOption],
        replacedOption
    ];

    (* pass to main state overload *)
    digestedStates = SimulateDigest[temporaryStates, proteases, ReplaceRule[ToList[ops], Output->resolvedOutput]];

    (* return early if we sense a list of options *)
    If[MatchQ[digestedStates, {_Rule..}],
        Return[digestedStates]
    ];

    (* dereference the strands from each state *)
    (* only do this to the Result outputs, the second argument maps the dereferencing over each state in the output *)
    fixedResults = applyFuncToResultOutput[digestedStates, Function[states, Map[#[Species] &, states]],  ops];

    (* create the preview from the strands *)
    previewOutput = If[MemberQ[ToList[outputOption], Preview],
        Rasterize /@ getResultOutput[fixedResults],
        Null
    ];

    (* generate output rules to format the output *)
    partialOutputRules = ToList[If[MatchQ[resolvedOutput, _List],
        Thread[resolvedOutput -> fixedResults],
        resolvedOutput -> fixedResults
    ]];
    outputRules = Join[partialOutputRules, {Preview -> previewOutput}];

    outputOption /. outputRules
];

getResultOutput[output_, Result]:=output;
getResultOutput[output_, option_?(MemberQ[#, Result] &)] := SelectFirst[Transpose[{output, option}], MatchQ[#, {Result, _}] &];
getResultOutput[_, _] := Null;


(* ------------------ state overload ---------------------------------- *)
SimulateDigest[state: StateP, protease: ProteaseP, ops: OptionsPattern[]] := Module[
    {output, fixedResults},
    output = SimulateDigest[{state}, {protease}, ops];
    fixedResults = applyFuncToResultOutput[output, First[#, $Failed] &, ops];
    applyFuncToOutputOption[fixedResults, First[#, $Failed] &, Preview, ops]
];

SimulateDigest[states: {StateP..}, protease: ProteaseP, ops: OptionsPattern[]] := SimulateDigest[states, ConstantArray[protease, Length[states]], ops];
SimulateDigest[states: {StateP..}, proteases: {ProteaseP..}, ops: OptionsPattern[]] := handleErrorsAndOutputs[simulateDigestCore, {states, proteases}, ops];

handleErrorsAndOutputs[coreFunction_, functionInputs_, ops: OptionsPattern[SimulateDigest]] := Catch[Module[
    {functionInputsAndOptions, result, testsAndOptions, tests, resolvedOps, outputOption},

    (* combine the options with inputs to insert into main function call *)
    functionInputsAndOptions = Join[functionInputs, ToList[ops]];

    (* evaluate the core function and reap the test results *)
    (* make sure to catch any early exits from errors or option only requests *)
    {result, testsAndOptions} = Reap[
        (* need to separately catch any errors thrown *)
        (* if there ever gets to be too many catch patterns, then we can make a helper that nests them automatically *)
        Catch[coreFunction @@ functionInputsAndOptions, "Error"],
        {"tests", "ResolvedOptions"}
    ];


    (* the tests are in a double nested list so turn them into a flat list *)
    tests = Flatten[First[testsAndOptions, {}]];
    resolvedOps = Flatten[Last[testsAndOptions, {}]];

    (* NOTE: SimulateDigest is hardcoded here, but it wouldn't be hard to generalize this later *)
    (* also simulate digest doesn't have options, so the safe options are the resolved ones *)
    outputOption = Lookup[resolvedOps, Output];

    (* format the output based on either Result, Tests, Preview or Options, or some combo *)
    formatOutput[result, resolvedOps, tests, outputOption]
], "OptionsOnly"];


simulateDigestCore[states: {StateP..}, proteases: {ProteaseP..}, ops:OptionsPattern[SimulateDigest]] := Module[
    {safeOps, outputOption, stateAssociations, resolvedProteases, body, request, response, nonPeptideStates, requestAssociations, peptideStates, url},

    safeOps = SafeOptions[SimulateDigest, ToList[ops]];
    outputOption = Lookup[safeOps, Output];

    returnOptionsEarly[safeOps, outputOption];

    (* sow the safeops as the resolved options for use in companion functions and Output processign *)
    Sow[safeOps, "ResolvedOptions"];

    (* check for index mismatching *)
    messageTest[SimulateDigest::UnequalLengthInputs, {}, "Check that input states/strands are an equal length to the list of input proteases:", Length[states] =!= Length[proteases], outputOption];

    (* format the state json by first converting it to an association *)
    stateAssociations = convertStateToAssociation[#, outputOption] & /@ states;

    (* dereference the nonpeptide states to add them back later *)
    nonPeptideStates = Lookup[stateAssociations, "NonPeptideState"];

    (* drop the nonPeptide states from the association b/c they won't play nice with the request *)
    requestAssociations = KeyDrop["NonPeptideState"] /@ stateAssociations;

    (* resolve the proteases into a string that can be read by the web app *)
    resolvedProteases = resolveProteaseOption /@ proteases;

    (* create the request body that includes the states and the proteases *)
    body = <|"States" -> requestAssociations, "Enzymes" -> resolvedProteases|>;

    (* get the url based on the environment *)
    url = If[ProductionQ[],
        "https://proteomics.emeraldcloudlab.com/digest_state",
        "https://proteomics-stage.emeraldcloudlab.com/digest_state"
    ];

    (* send up the request to aws *)
    request = <|
        "Method" -> "POST",
        "Headers" -> <|
            "Authorization" -> StringJoin["Bearer ", GoLink`Private`stashedJwt],
            "Content-Type" -> "application/json"
        |>,
        "URL" -> url,
        "Body" -> ExportJSON[body]
    |>;

    response = HTTPRequestJSON[request];

    (* panic fail if something went wrong on the backend *)
    (* hopefully this never happens *)
    messageTest[
        SimulateDigest::FatalError,
        {},
        "Check that nothing went wrong during the simulation:",
        MatchQ[response, _HTTPError],
        outputOption
    ];

    (* process the response into a list of state objects and return *)
    peptideStates = processStateResponse[response];

    (* join the peptide-digested states with their inert counterparts *)
    MapThread[Join, {peptideStates, nonPeptideStates}]
];

(* helper that converts a singleton state to an association that can be read by python web app *)
convertStateToAssociation[state_, outputOption_] := Module[
    {peptides, nonPeptides, flattenedPeptides, concentrations, peptideConcs, nonPeptideConcs, nonPeptideState},

    (* pull out the peptides and check that they are in fact strands and not other things *)
    peptides = Select[state[Species], containsPeptidesQ];
    nonPeptides = Select[state[Species], Not[containsPeptidesQ[#]] & ];
    messageTest[
        SimulateDigest::NoPeptides,
        {state},
        "Check that the output state has peptides in it:",
        MatchQ[peptides, {}],
        outputOption
    ];

    (* flatten the named sequences in each peptide into one sequence *)
    (*flattenedPeptides = flattenStrand /@ peptides;*)

    (* get the concentrations from the state *)
    concentrations = state[Quantities];
    peptideConcs = PickList[concentrations, state[Species], _?containsPeptidesQ];
    nonPeptideConcs = PickList[concentrations, state[Species], _?(Not[containsPeptidesQ[#]] &)];
    nonPeptideState = State @@ (Transpose[{nonPeptides, nonPeptideConcs}]);

    (* convert to association and return *)
    <|
        "Strands" -> (ToString[#, InputForm] & /@ peptides),
        "Concentrations" -> (ToString[#, InputForm] & /@ peptideConcs),
        "NonPeptideState" -> nonPeptideState
    |>
];

containsPeptidesQ[strand_] := Module[
    {motifs, peptideCheckList},
    motifs = strand[Motifs];

    (* check each motif to see if it's a peptide *)
    peptideCheckList = PeptideQ /@ motifs;

    (* if there are any peptides, we should return true, else false *)
    Or @@ peptideCheckList
];

flattenStrand[strand_] := Module[
    {flatSequence},
    (* dereference the list of sequences and join them all together *)
    flatSequence = StringJoin[strand[Sequences]];

    (* convert them back to a strand and return *)
    Strand[flatSequence]
];


(* the state response should be a list of associations *)
processStateResponse[response_] := processSingletonStateResponse /@ response;
processSingletonStateResponse[singletonResponse_] := Module[
    {unconvertedStrands, concMagnitudes, unconvertedConcUnits, strands, concentrations},

    (* dereference all useful things from this list *)
    (* NOTE: the strands are flattened b/c they should be single element lists of sequences. Eventually we may support
    named strand digestion, but for now we don't, so it's ok to flatten the list *)
    unconvertedStrands = Flatten[Lookup[singletonResponse, "Strands"]];
    concMagnitudes = Lookup[singletonResponse, "ConcentrationMagnitudes"];
    unconvertedConcUnits = Lookup[singletonResponse, "ConcentrationUnits"];

    (* convert the sequences to SLL 3-letter code form; right now they are in 1-letter code peptide representation *)
    strands = constructStrand /@ unconvertedStrands;

    (* convert the units to something MM legible *)
    concentrations = MapThread[convertConcentration, {concMagnitudes, unconvertedConcUnits}];

    (* construct the state and return *)
    State @@ (Transpose[{strands, concentrations}])
];

constructStrand[strandAssociation_] := Module[
    {motifs},

    motifs = constructMotifs /@ Lookup[strandAssociation, "Motifs"];

    Strand @@ motifs
];

constructMotifs[motifAssociation_] := Module[
    {motifType, unresolvedMotifSequence, motifSequence, motifName},

    (* this is a string of a polymer type, e.g. "Peptide" or "DNA" which we need to convert to a symbol *)
    motifType = Symbol[Lookup[motifAssociation, "MotifType"]];

    (* get the motif sequence; if it's a peptide, we need to convert it to three letter codes *)
    unresolvedMotifSequence = Lookup[motifAssociation, "Sequence"];
    motifSequence = If[motifType === Peptide,
        convertAminoAcidSequence[unresolvedMotifSequence],
        unresolvedMotifSequence
    ];
    motifName = Lookup[motifAssociation, "Name"];
    If[motifName === Null,
        motifType[motifSequence],
        motifType[motifSequence, motifName]
    ]
];


(* ---- overloads that ensure singleton inputs are index-matched ---- *)
SimulateDigest[sampleObject:ObjectP[Object[Sample]], protease:ProteaseP, myOps:OptionsPattern[]]:=Module[
    {output, fixedResults},
    output = SimulateDigest[{sampleObject}, protease, myOps];
    fixedResults = applyFuncToResultOutput[output, First[#, $Failed] &, myOps];
    applyFuncToOutputOption[fixedResults, First[#, $Failed] &, Preview, myOps]
];
SimulateDigest[sampleObjects: {ObjectP[Object[Sample]]..}, protease: ProteaseP, myOps:OptionsPattern[]] := Module[
    {proteases},
    proteases = ConstantArray[protease, Length[sampleObjects]];
    SimulateDigest[sampleObjects, proteases, myOps]
];
SimulateDigest[sampleObject: ObjectP[Object[Sample]], proteases: {ProteaseP..}, myOps:OptionsPattern[]] := Module[
    {sampleObjects},
    sampleObjects = ConstantArray[sampleObject, Length[proteases]];
    SimulateDigest[sampleObjects, proteases, myOps]
];

(* ----------- main code -------------- *)
SimulateDigest[
    sampleObjects:{ObjectP[Object[Sample]]..}, proteases: {ProteaseP..}, myOps:OptionsPattern[]
]:= handleErrorsAndOutputs[simulateDigestSampleCore, {sampleObjects, proteases}, myOps];
simulateDigestSampleCore[sampleObjects:{ObjectP[Object[Sample]]..}, proteases: {ProteaseP..}, myOps:OptionsPattern[SimulateDigest]] := Module[
    {sampleIDs, optionsToReturn, resolvedOps, digestResults, resolvedProteases},

    (* resolve the options first, and figure out if we can shortcut the options early *)
    resolvedOps = resolveDigestOptions[ToList[myOps]];
    optionsToReturn = Normal[KeyDrop[resolvedOps, Protease]];
    returnOptionsEarly[optionsToReturn, Lookup[resolvedOps, Output]];

    (* sow the options for pick up from the companion functions *)
    Sow[optionsToReturn, "ResolvedOptions"];

    (*clump = digest["DigestSimulation", sampleObjects[[1]], Protease -> Lookup[resolvedOps, Protease]];*)
    (*sequences = findSequences[sampleObjects];*)
    sampleIDs = Download[sampleObjects, ID];
    resolvedProteases = resolveProteaseOption /@ proteases;
    digestResults = requestDigestedPeptides[sampleIDs, resolvedProteases, Lookup[resolvedOps, Output]];

    digestResults
];


(* option resolver for digest clump *)
resolveDigestOptions[unresolvedOps_]:=Module[
    {safeOps, unresolvedProtease, resolvedProtease, partiallyResolvedProtease},

    safeOps = SafeOptions[SimulateDigest, unresolvedOps];

    unresolvedProtease = Lookup[safeOps, Protease];
    resolvedProtease = resolveProteaseOption[unresolvedProtease];

    (* place the resolved protease into the list of resolved options *)
    ReplaceRule[safeOps, Protease->resolvedProtease]
];

resolveProteaseOption[unresolvedProtease_]:=Module[
    {},
    (*
        resolve the protease by downloading the name of the model or converting
        the input symbol to a string
    *)
    If[MatchQ[unresolvedProtease, _Model],
        Download[unresolvedProtease, Name],
        partiallyResolvedProtease = Replace[unresolvedProtease, proteaseConversionRules[]];
        ToString[partiallyResolvedProtease]
    ]
];

(* conversion rules for protease names for pointing to external databases *)
(* NOTE: as you can see, people don't tend to agree on naming conventions or even capitalization :) *)
proteaseConversionRules[] := proteaseConversionRules[] = {
    LysC -> "Lys-C",
    GlutamylEndopeptidase -> "glutamyl endopeptidase",
    AlphaLyticProtease -> "Alpha-lytic protease",
    Iodobenzoate -> "2-iodobenzoate",
    Iodosobenzoate -> "iodosobenzoate",
    StaphylococcalProtease -> "staphylococcal protease/D",
    ProlineEndopeptidase -> "proline-endopeptidase/HKR",
    CyanogenBromide -> "cyanogen-bromide",
    Clostripain -> "Clostripain/P",
    ElastaseTrypinChymoTrypsin -> "elastase-trypsin-chymotrypsin",
    FormicAcid -> "Formic_acid",
    LysN -> "Lys-N",
    AspN -> "Asp-N",
    ArgC -> "Arg-C"
};


findSequences[sampleIDs_] := Module[
    {identityModelLists, identityGroupings},

    (* download the identity models *)
    identityModelLists = Quiet[
        Download[sampleID,
            {
                Composition[[All, 2]],
                Composition[[All, 2]][PolymerType],
                Composition[[All, 2]][Molecule]
            }
        ],
        {Download::FieldDoesntExist}
    ];

    (* use a helper function to get the relevant sequences for each sample *)
    Map[findSequencesFromDownloadPayload, identityModelLists]
];


(* helper that gets the digest information from the server response *)
requestDigestedPeptides[sampleIDs_, proteases_, outputOption_] :=Module[
    {
        url, request, response, messages
    },

    (* remember to use different url's based on whether we're on production or stage *)
    url = If[ProductionQ[],
        "https://proteomics.emeraldcloudlab.com/digest",
        "https://proteomics-stage.emeraldcloudlab.com/digest"
    ];

    (* format the request *)
    request = <|
        "Method" -> "POST",
        "Headers" -> <|
            "Authorization" -> StringJoin["Bearer ", GoLink`Private`stashedJwt],
            "Content-Type" -> "application/json"
        |>,
        "URL" -> url,
        "Body" -> ExportJSON[<|
            "IDs" -> sampleIDs,
            "Options" -> {
                "Enzymes" -> proteases
            },
            "$ConstellationDomain" -> Global`$ConstellationDomain
        |>]
    |>;
    (* if sequences is not empty call out to API *)
    response = HTTPRequestJSON[request];

    (* pull out the peptides from the response *)
    messageTest[SimulateDigest::InvalidInput, {}, "Check that the input objects have proteins/peptides with valid Molecule information:", MatchQ[response, _HTTPError], outputOption];

    (* handle any errors that come from the request *)
    (* in this case there are Error and Messages keys, which we will use to surface appropriate SLL messages to users *)
    (* this will likely need to get cleaned up at some point, but for now this is what we have *)
    If[Lookup[response, "Error", False],
        messages = Lookup[response, "Messages"];

        (* create message tests that change behavior based on the output option; if Tests are requested, then we sow some tests and move on *)
        (* if anything else is requested, we surface an error and stop *)
        messageTest[
            SimulateDigest::NoProteins,
            {},
            "Check if sample object has any proteins/peptides to digest:",
            messages === {"Could not retrieve field responses from request to /obj/download.  Constellation response: {\"responses\":null}"},
            outputOption
        ];

        messageTest[SimulateDigest::FatalError, {}, "Check that nothing unexpected happened during the simulation:", True, outputOption];
    ];

    Map[parseDigestResponse[response, #]&, sampleIDs]
];


parseDigestResponse[response_, sampleID_]:=Module[
    {
        idResponse, peptides, strandLists, concentrationMagnitudes, concentrationUnits, concentrations,
        concentrationStrandPairLists
    },

    idResponse = Lookup[response, sampleID, {}];
    peptides = Lookup[idResponse, "peptides", {}];

    (* convert the sequence strings to Strand objects *)
    strandLists = Map[convertAminoAcidSequences, peptides];

    (* pull the concentrations from the response *)
    concentrationMagnitudes = Lookup[idResponse, "concentrations"];
    concentrationUnits = Lookup[idResponse, "concentration units"];

    (* check if there are any null concentrations and throw a warning to let the user know that the State expression will not be valid for further analysis *)
    If[MemberQ[concentrationMagnitudes, Null, Infinity],
        Message[Warning::NullConcentrationsFound];
    ];

    (* convert the unit strings into units and combine with the concentration magnitudes *)
    concentrations = MapThread[convertConcentration[#1, #2] &, {concentrationMagnitudes, concentrationUnits}];


    (* match concentrations to each strand list *)
    (* the concentrations should be index matched to each strand list; create a 2-ple for each strand with {conc, strand} *)
    (* the output of this function should take the structure {{{conc1, strand11}, {conc1, strand12}..}, {{conc2, strand21}..}..} *)
    (* the length should be equal to the number of proteins in the sample. The second index is equal to the number of peptides created during the digest *)
    concentrationStrandPairLists = MapThread[matchConcentrationToStrands[#1, #2] &, {concentrations, strandLists}];

    (* flattened the list of 2-ples to be consistent with the form of a composition and a State *)
    (* to convert to a state, we simply need to apply the State head to the list of 2-ples *)
    State@@Flatten[concentrationStrandPairLists, 1]
];

(* helper that expands the concentrations to the length of the input strands and creates 2-ples for each strand *)
matchConcentrationToStrands[concentration_, strands_] := Module[
    {concArray},
    (* create an array of the same length as the input strands *)
    concArray = ConstantArray[concentration, Length[strands]];

    (* to create a list of 2-ples of {conc, strand} we simply need to transpose the two lists *)
    Transpose[{strands, concArray}]
];

(* helper that converts concentrations from the proteomics endpoint *)
(* in python, the units are stored in lower case and un-pluralized; e.g. "millimole" instead of "Millimoles", *)
(* NOTES
   ---------
    split the unit string into parts; it should be of the form unitString / otherUnitString
    the division and multiplication operations should be parsable by MM, so we need to convert the unit strings to canonical MM units
    in python, we use pint which uses un-capitalized and un-pluralized units, so we need to make those
    also, it is possible to see a power operator in python strings which is **, which needs to get replaced with ^ in MM
*)
(* if a Null magnitude is inputted, then convert it to an ArbitraryUnit so that it can be read in by State *)
convertConcentration[Null, _] := ArbitraryUnit;
convertConcentration[magnitude_, unit_]:=Module[
    {unitTokens, powerConvertedTokens, capitalTokens, pluralTokens},

    (* split the unit string into parts; it should be of the form unitString / otherUnitString *)
    unitTokens = StringSplit[unit];

    (* convert the ** operator to ^ to prepare for MM interpretation *)
    powerConvertedTokens = Replace[unitTokens, "**" -> "^", {1}];

    (* capitalize the tokens; note that capitalize ignores operators like '/' *)
    capitalTokens = Capitalize /@ powerConvertedTokens;

    (* pluralize and wrap the strings in quantity and quotes; note that we don't want to do this for operators *)
    (* we are going to assume that operators aren't going to consist solely of letter characters to determine what needs
    to be wrapped and pluralized which is exactly what the pluralize helper is doing *)
    pluralTokens = pluralizeQuantities /@ capitalTokens;

    (* now the tokens are ready to be interpreted by mathematica, so convert them to MM expressions *)
    (* the magnitudes can be multiplied safely to the converted units and returned *)
    magnitude * ToExpression[StringJoin@@pluralTokens]
];

(* pluralize is a helper that will pluralize letter character strings, and leave all other strings alone *)
pluralizeQuantities[unitString_?(StringMatchQ[#, LetterCharacter..] &)] := If[
    StringContainsQ[unitString, "molar" | "Molar"],
    (* if it contains a molar quantity, don't pluralize it *)
    StringJoin["Quantity[\"", unitString, "\"]"],
    (* no molar quantity means it's ok to pluralize for now *)
    StringJoin["Quantity[\"", unitString, "s\"]"]
];
pluralizeQuantities[otherString_] := otherString;

(* helper to find sequences from SLL identity models *)
findSequencesFromDownloadPayload[modelDownload_List]:=Module[
    {models, polymerTypes, molecules, sequenceLists},

    (* unpack the model download payloads *)
    {models, polymerTypes, molecules} = modelDownload;

    (* map thread over each model to find its sequence *)
    sequenceLists = MapThread[findSequence, {models, polymerTypes, molecules}];

    (* flatten the sequences into one list and return *)
    (* this is because this helper is supposed to represent all the protein
    sequences in one sample, so flattening the list makes sense *)
    Flatten[sequenceLists]
];

(* helper to find sequence for one molecule *)
findSequence[model:ObjectP[Model[Molecule, Protein]], polymerType_, molecule_]:=Module[
    {},
    (* in case that the model is of type protein, then simply return the molecule *)
    (* after dereferencing the first sequence *)
    molecule[Sequences]
];
(* oligomer case: only support peptides for now *)
findSequence[model:ObjectP[Model[Molecule, Oligomer]], Peptide, molecule_]:=Module[
    {},
    molecule[Sequences]
];
(* all other cases, return Nothing, which skips this entry from adding to the seq list *)
findSequence[model_, polymerType_, molecule_]:=Nothing;

(* convert sequence from single letter protein code to 3 letter codes *)
aminoAcidConversions := <|
    "A" -> "Ala",
    "R" -> "Arg",
    "N" -> "Asn",
    "D" -> "Asp",
    "B" -> "Asx",

    "C" -> "Cys",
    "E" -> "Glu",
    "Q" -> "Gln",
    "Z" -> "Glx",
    "G" -> "Gly",

    "H" -> "His",
    "I" -> "Ile",
    "L" -> "Leu",
    "K" -> "Lys",
    "M" -> "Met",

    "F" -> "Phe",
    "P" -> "Pro",
    "S" -> "Ser",
    "T" -> "Thr",
    "W" -> "Trp",

    "Y" -> "Tyr",
    "V" -> "Val"
|>

(*
    helper that converts single char code amino acid strings to three
    letter code amino acid strings
*)
convertAminoAcidSequences[sequences_]:=Map[convertAminoAcidSequenceToStrand, sequences];
convertAminoAcidSequenceToStrand[sequence_String?UpperCaseQ]:=Module[
    {threeLetterAAs},

    (* lookup the mapped 3 letter code from the characters *)
    threeLetterAAs = convertAminoAcidSequence[sequence];

    (* create a strand from the collection of three letter amino acids *)
    Strand[threeLetterAAs]
];
(* helper that just converts the actual sequence, not converting to strand *)
convertAminoAcidSequence[sequence_] := Module[
    {chars},

    chars = Characters[sequence];

    (* lookup the mapped 3 letter code from the characters *)
    StringJoin @@ (Lookup[aminoAcidConversions, chars, "Xaa"])
];


(* ------------------------------------------------------------------------------------------- *)
(*                                COMPANIONS                                                   *)
(* ------------------------------------------------------------------------------------------- *)


digestInputP = Alternatives[
    ListableP[StateP],
    ListableP[ObjectP[Object[Sample]]],
    ListableP[ObjectP[{Model[Molecule, Protein], Model[Molecule, Oligomer]}]],
    ListableP[StrandP],
    ListableP[StructureP]
];
singletonDigestInputP = Alternatives[
    StateP,
    ObjectP[Object[Sample]],
    ObjectP[{Model[Molecule, Protein], Model[Molecule, Oligomer]}],
    StrandP,
    StructureP
];

SimulateDigestPreview[input: singletonDigestInputP, protease: ProteaseP, ops: OptionsPattern[SimulateDigest]] := SimulateDigest[input, protease, Output -> Preview];


(* NOTE: this function doesn't have any options right now outside of the results, but maybe more get added later *)
SimulateDigestOptions[inputs: digestInputP, proteases: ListableP[ProteaseP], ops: OptionsPattern[SimulateDigest]] := SimulateDigest[inputs, proteases, Output -> Options];


DefineOptions[ValidSimulateDigestQ,
    Options :> {
        VerboseOption
    }
]
ValidSimulateDigestQ[inputs: digestInputP, proteases: ListableP[ProteaseP], ops: OptionsPattern[]] := Module[
    {tests, verboseOption},
    tests = SimulateDigest[inputs, proteases, Output -> Tests];

    verboseOption = OptionDefault[OptionValue[Verbose]];

    RunUnitTest[<|"ValidSimulateDigestQ" -> tests|>, Verbose -> verboseOption, OutputFormat -> Boolean]["ValidSimulateDigestQ"]
];


(* -------------------------------- helpers for tests output --------------------------- *)
SetAttributes[messageTest, HoldFirst];
messageTest[messageName_MessageName, messageArgs_List, testDescription_String, messageCondition_, resultOption_] := Module[
    {},

    (* sow any tests if the test option has been invoked *)
    If[ContainsAny[ToList[resultOption], {Tests}],
        Sow[Test[testDescription, Not[messageCondition], True], "tests"];
    ];

    (* if there are other elements of the result, then send messages *)
    If[ToList[resultOption] =!= {Tests},
        If[messageCondition,
            Message[messageName, Sequence@@messageArgs];
            Throw[$Failed, "Error"]
        ]
    ]
];

(* helper that handles option results *)
returnOptionsEarly[resolvedOps_, (* result option *) Options | {Options}] := Throw[resolvedOps, "OptionsOnly"];
returnOptionsEarly[resolvedOps_, output_] := Null;

(* helper that processes output option and returns correct result *)
formatOutput[output_, resolvedOps_, tests_, outputOption_List] := formatOutputForSingletonOption[output, resolvedOps, tests, #] & /@ outputOption;
formatOutput[output_, resolvedOps_, tests_, outputOption_Symbol] := formatOutputForSingletonOption[output, resolvedOps, tests, outputOption];

formatOutputForSingletonOption[output_, resolvedOps_, tests_, Result] := output;
formatOutputForSingletonOption[output_, resolvedOps_, tests_, Options] := resolvedOps;
formatOutputForSingletonOption[output_, resolvedOps_, tests_, Preview] := If[MatchQ[results, ListableP[{StrandP..}]],
    Rasterize /@ output,
    PlotState[output]
];
formatOutputForSingletonOption[output_, resolvedOps_, tests_, Tests] := tests;
