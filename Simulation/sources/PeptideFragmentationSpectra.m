(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(* SimulatePeptideFragmentationSpectra *)


(* ::Subsection:: *)
(* Options Definition *)

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

DefineOptions[SimulatePeptideFragmentationSpectra,
    Options :> {
        {
            OptionName -> Protease,
            Default -> Null,
            AllowNull -> True,
            Description -> "The enzyme that cuts the protein sequence at specific sites according to its known recognition site. By default, this option is Null, such that the fragmentation spectra is simulated for the undigested inputs.",
            Widget -> Widget[
                Type -> Enumeration,
                Pattern :> ProteaseP
            ]
        },
        {
            OptionName -> MaxIsotopes,
            Default -> Automatic,
            AllowNull -> False,
            Description -> "The maximum number of isotope configurations the simulation will generate for each digested fragment. If neither MaxIsotopes nor IsotopeProbabilityCutoff are specified, this resolves to 1. If only IsotopeProbabilityCutoff is specified, this option is unused. If both options are specified, both are used.",
            Widget -> Widget[
                Type -> Number,
                Pattern :> GreaterEqualP[1,1]
            ]
        },
        {
            OptionName -> IsotopeProbabilityCutoff,
            Default -> 0.0 Percent,
            AllowNull -> False,
            Description -> "A threshold that filters out any isotopes with a natural abundance less than the specified value.",
            Widget -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
            ]
        },
        {
            OptionName -> MinCharge,
            Default -> 1,
            AllowNull -> False,
            Description -> "The minimum positive charge that the simulator uses to create the list of possible charge states for each fragment.",
            Widget -> Widget[
                Type -> Number,
                Pattern :> RangeP[1, 5, 1]
            ]
        },
        {
            OptionName -> MaxCharge,
            Default -> 2,
            AllowNull -> False,
            Description -> "The maximum positive charge that the simulator uses to create the list of possible charge states for each fragment.",
            Widget -> Widget[
                Type -> Number,
                Pattern :> RangeP[1, 5, 1]
            ]
        },
        {
            OptionName -> IncludedIons,
            Default -> {YIon, BIon},
            AllowNull -> False,
            (* TODO: Add figure when supported. *)
            Description -> "The type of ion fragments to consider in this simulation. The letter codes (a/c, b/y, c/z) denote the bond breakage site; The most commonly considered ions are the y/b ions, for fragmentation across the peptide bond; a/c ions are fragmentation across the carbon and carbonyl bond; and c/z ions are fragmentation across the carbon and nitrogen bond. a/b/c ions fragments are counted from the N-terminus, and x/y/z ions are counted from the C-terminus.",
            Widget -> Widget[
                Type -> MultiSelect,
                Pattern :> DuplicateFreeListableP[YIon | BIon | AIon | CIon | XIon | ZIon]
            ]
        },
        {
            OptionName -> IncludeLosses,
            Default -> False,
            AllowNull -> False,
            Description -> StringJoin[
                "Indicates if losses from common molecules formed during fragmentation are included in the simulation. ",
                "Ammonia and water are example molecules that dissociate from a fragment ion; ammonia may dissociate from R, K, Q, and N residues, while water may dissociate from S, T, and E residues."
            ],
            Widget -> Widget[Type -> Enumeration, Pattern :> (True | False)]
        },
        {
            OptionName -> IncludePrecursors,
            Default -> False,
            AllowNull -> False,
            Description -> "Indicates if the precursor molecule (the parent ion) is included in the simulated results. This is particularly useful when trying to replicate tandem MS, in which, during the initial fragmentation process, small chemical modifications which add charge to the precursor molecules.",
            Widget -> Widget[Type -> Enumeration, Pattern :> (True | False)]
        },
        OutputOption,
        UploadOption
    }
];


(* ::Subsection:: *)
(* Messages *)

SimulatePeptideFragmentationSpectra::DuplicateSpecies = "Duplicate species detected in state. Combining into single species.";
SimulatePeptideFragmentationSpectra::IsotopeProbabilityCutoff = "IsotopeProbabilityCutoff option used without MaxIsotope option, which defaults to 1. Set the MaxIsotopes option for IsotopeProbabilityOption to have an effect.";
SimulatePeptideFragmentationSpectra::InvalidCharges = "MinCharge cannot be greater than MaxCharge.";
SimulatePeptideFragmentationSpectra::FatalError = "Something went wrong internally. If this issue is reproducible, please file a ticket with the appropriate party, and it will be addressed as soon as possible.";

(* ::Subsection:: *)
(* Object[Sample] definition *)

SimulatePeptideFragmentationSpectra[object:ObjectReferenceP[Object[Sample]], myOps:OptionsPattern[]] := Module[
    {listedResult},
    listedResult = SimulatePeptideFragmentationSpectra[{object}, myOps];
    If[!MatchQ[listedResult, $Failed],
        listedResult[[1]],
        $Failed
    ]
];

SimulatePeptideFragmentationSpectra[objects:{ObjectReferenceP[Object[Sample]]..}, myOps:OptionsPattern[]] := Module[
    {
        inputIDs,
        myOpsList, myOpsExpanded, myOpsSeparated,
        safeOps, resolvedOptionsForSLL, resolvedOptionsForHTTPRequestJSON,
        safeOpsTests, additionalOptionsTests, allOptionTests,
        outputOptionValue,
        resolvedIsotopeModel, resolvedOpsForSLLWithIsotopeModel,
        body, url, response
    },

    (* Not a real download, since IDs are 'free'. *)
    inputIDs = Download[objects, ID];

    (* Resolve options. *)
    (* The python code can correctly handle index matched options, but we need to format that here. *)
    myOpsList = ToList[myOps];
    myOpsExpanded = expandOptions[myOpsList, inputIDs];
    (* If options are improperly index-matched, this will return $Failed. If $Failed, return $Failed and exit. *)
    If[MatchQ[myOpsExpanded, $Failed], Return[$Failed]];
    (* These are the unresolved options, one list per input. *)
    myOpsSeparated = separateOptions[myOpsExpanded, Length[inputIDs]];

    (* Including Tests in Output option will not generate messages, so call twice, and use AutoCorrect->False for more rigorous testing. *)
    safeOps= Map[SafeOptions[SimulatePeptideFragmentationSpectra, #, Output->Result]&, myOpsSeparated];
    safeOpsTests = Map[SafeOptions[SimulatePeptideFragmentationSpectra, #, Output->Tests, AutoCorrect->False]&, myOpsSeparated];
    {resolvedOptionsForSLL, additionalOptionsTests} = Transpose[MapThread[resolveOptionsForSLL[#1, #2]&, {myOpsSeparated, safeOps}]];
    allOptionTests = MapThread[Join[#1, #2]&, {safeOpsTests, additionalOptionsTests}];

    (* Check if any options failed to resolve. *)
    If[ContainsAny[resolvedOptionsForSLL, {$Failed}], Return[$Failed]];

    (* Check if requested output only contains Tests, and if so, return tests and exit. *)
    (* This saves time and avoids uploading results during ValidQ calls, while still allowing us to check the upload option. *)
    outputOptionValue =  Lookup[resolvedOptionsForSLL, Output];
    If[MatchQ[outputOptionValue, {Tests}],
        Return[allOptionTests]
    ];

    (* Resolve IsotopeModel and append to a copy of resolvedOptionsForSLL. *)
    (* Just use string for key since this is not a user-facing option. *)
    resolvedIsotopeModel = Map[resolveIsotopeModelOption[#]&, myOpsSeparated];
    resolvedOpsForSLLWithIsotopeModel = MapThread[Append[#1, "IsotopeModel"->#2]&, {resolvedOptionsForSLL, resolvedIsotopeModel}];

    (* All of the options are recombined here into a single list of rules. *)
    resolvedOptionsForHTTPRequestJSON = resolveOptionsForHTTPRequestJSON[resolvedOpsForSLLWithIsotopeModel];

    (* Make a useful body for the http request *)
    body = ExportJSON[{
        "IDs" -> inputIDs,
        "Options" -> resolvedOptionsForHTTPRequestJSON,
        "$ConstellationDomain" -> Global`$ConstellationDomain
    }];

    (* Set the URL based on the environment. *)
    url = If[ProductionQ[],
        "https://proteomics.emeraldcloudlab.com/simulate_ms",
        "https://proteomics-stage.emeraldcloudlab.com/simulate_ms"
    ];

    (* Send request to web-app. *)
    response = HTTPRequestJSON[<|
        "Method" -> "POST",
        "Headers" -> <|
            "Authorization" -> StringJoin["Bearer ", GoLink`Private`stashedJwt],
            "Content-Type" -> "application/json"
        |>,
        "URL" -> url,
        "Body" -> body
    |>];

    parseResponse[inputIDs, response, myOpsSeparated, resolvedOptionsForSLL, allOptionTests]

];


(* ::Subsection:: *)
(* Strand[] and State[] definitions *)
(*
Note, strand definitions are assumed to be pure-component digests/fragmentations. To simulate samples, users must use state definitions.
This avoids ambiguity for the list of strands definition, which could have been interpreted as a sample of uniform concentrations, or multiple pure-component samples.
*)

SimulatePeptideFragmentationSpectra[strands:StrandP, myOps:OptionsPattern[]] := Module[
    {listedResult},
    listedResult = SimulatePeptideFragmentationSpectra[{strands}, myOps];
    If[!MatchQ[listedResult, $Failed],
        listedResult[[1]],
        $Failed
    ]
];

SimulatePeptideFragmentationSpectra[strands:{StrandP..}, myOps:OptionsPattern[]] := Module[
    {concs, states},

    (* For non-concentration definition, set everything to 1 Molar. *)
    concs = ConstantArray[Quantity[1.0, Molar], Dimensions[strands]];

    (* Format inputs as a single-component states and pass to main overload. *)
    states = MapThread[State[{#1, #2}]&, {strands, concs}];

    (* Pass to State definition. *)
    SimulatePeptideFragmentationSpectra[states, myOps]
];

(* Definitions with concentration input (using State). *)
SimulatePeptideFragmentationSpectra[state:StateP, myOps:OptionsPattern[]] := Module[
    {listedResult},
    listedResult = SimulatePeptideFragmentationSpectra[{state}, myOps];
    If[!MatchQ[listedResult, $Failed],
        listedResult[[1]],
        $Failed
    ]
];

(* Main Overload for Strands/States. *)
SimulatePeptideFragmentationSpectra[states:{StateP..}, myOps:OptionsPattern[]] := Module[
    {
        myOpsList, myOpsExpanded, myOpsSeparated,
        safeOps, resolvedOptionsForSLL, resolvedIsotopeModel,
        resolvedOpsForSLLWithIsotopeModel, resolvedOptionsForHTTPRequestJSON,
        safeOpsTests, additionalOptionsTests, allOptionTests,
        semiResolvedStates, resolvedStates, strands, concs, strandMW, concsMolar,
        strandsAsStrings, concsAsStrings, body, url, response, reorderedResponse
    },

    (*
    All values in HTTPRequestJSON for this function/endpoint must be lists of plain text.
    Specifically, we need to input a list of lists of strings, NOT a string which contains lists of lists.
    i.e., {{"x", "x"}, {"x", "x"}} NOT "{{x, x}, {x, x}}"
    *)

    (* Resolve options. *)
    (* The python code can correctly handle index matched options, but we need to format that here. *)
    myOpsList = ToList[myOps];
    myOpsExpanded = expandOptions[myOpsList, states];
    (* If options are improperly index-matched, this will return $Failed. If $Failed, return $Failed and exit. *)
    If[MatchQ[myOpsExpanded, $Failed], Return[$Failed]];
    (* These are the unresolved options, one list per input. *)
    myOpsSeparated = separateOptions[myOpsExpanded, Length[states]];

    {safeOps, safeOpsTests} = Transpose[Map[SafeOptions[SimulatePeptideFragmentationSpectra, #, Output->{Result, Tests}]&, myOpsSeparated]];
    {resolvedOptionsForSLL, additionalOptionsTests} = Transpose[MapThread[resolveOptionsForSLL[#1, #2]&, {myOpsSeparated, safeOps}]];
    allOptionTests = MapThread[Join[#1, #2]&, {safeOpsTests, additionalOptionsTests}];

    (* Check if any options failed to resolve. *)
    If[ContainsAny[resolvedOptionsForSLL, {$Failed}], Return[$Failed]];

    (* Resolve IsotopeModel and append to a copy of resolvedOptionsForSLL. *)
    (* Just use string for key since this is not a user-facing option. *)
    resolvedIsotopeModel = Map[resolveIsotopeModelOption[#]&, myOpsSeparated];
    resolvedOpsForSLLWithIsotopeModel = MapThread[Append[#1, "IsotopeModel"->#2]&, {resolvedOptionsForSLL, resolvedIsotopeModel}];

    (* All of the options are recombined here into a single list of rules. *)
    resolvedOptionsForHTTPRequestJSON = resolveOptionsForHTTPRequestJSON[resolvedOpsForSLLWithIsotopeModel];

    (* For non-concentration definition, set everything to 1 Molar. *)
    strands = Map[LookupFromState[#, Species]&, states];
    concs = Map[LookupFromState[#, Quantities]&, states];

    strandMW = Map[MolecularWeight[#]&, strands];
    (*
    This step is not necessary, as States do not allow for a mix between mass/volume and mole/volume in the same state.
    Keeping the code in case of future support for states with mixed concentration units.
    *)
    concsMolar = MapThread[
        If[
            CompatibleUnitQ[#1, Quantity[Molar]],
            UnitConvert[#1, Molar],
            CompatibleUnitQ[#1, Quantity[Gram / Liter]],
            UnitConvert[#1/#2, Molar]
        ]&,
        {concs, strandMW}
    ];

    (* Create new state using standardized concentration units. *)
    (* Then check states for duplicate species. Combine, else results in reponse are lost due to duplicate keys. *)
    semiResolvedStates = Map[State@@#&,
        MapThread[{#1, #2}&, {strands, concsMolar}]
    ];
    resolvedStates = Map[combineDuplicatesInState[#]&, states];

    strandsAsStrings = Map[toStringPreserveQuotes, strands, {2}];
    concsAsStrings = ConstantArray[ToString[Quantity[1.0, Molar]], Dimensions[strands]];

    (* Create the body for the request. *)
    body = <|
        "Strands" -> strandsAsStrings,
        "Options" -> resolvedOptionsForHTTPRequestJSON,
        "Concentrations" -> concsAsStrings,
        "$ConstellationDomain" -> Global`$ConstellationDomain
    |>;

    (* Set the URL based on the environment. *)
    url = If[ProductionQ[],
        "https://proteomics.emeraldcloudlab.com/simulate_ms_strand",
        "https://proteomics-stage.emeraldcloudlab.com/simulate_ms_strand"
    ];

    (* Send request to web-app. *)
    response = HTTPRequestJSON[
        Association[
            "Method" -> "POST",
            "Headers" -> <|
                "Authorization" -> StringJoin["Bearer ", GoLink`Private`stashedJwt],
                "Content-Type" -> "application/json"
            |>,
            "URL" -> url,
            "Body" -> body
        ]
    ];

    (* For Strand case, ensure packet ordering is correct. *)
    If[!MatchQ[Head[response], HTTPError],

        (* Successful Response *)
        reorderedResponse = KeySort[response],

        (* Failed Response *)
        reorderedResponse = response;
    ];

    parseResponse[resolvedStates, reorderedResponse, myOpsSeparated, resolvedOptionsForSLL, allOptionTests]

];


(* ::Subsection:: *)
(* Helper Functions *)

(* Resolve Options *)
expandOptions[myOps_, inputs_] := Module[
    {
        defaultOpsAssoc, myOpsAssoc, inputLength,
        expandedOptions
    },

    (*
      Expanded options must know which options are listed options, or length check can be flaky.
      Automatics which resolve to lists can also be tricky, but there are none of those for this function.
      This function does NOT check if options match their patterns. We will call SafeOptions for that.
    *)

    defaultOpsAssoc = Association[Options[SimulatePeptideFragmentationSpectra]];
    myOpsAssoc = Association[myOps];
    inputLength = Length[inputs];

    expandedOptions = Map[
        (* Options[] returns strings rather than symbols... convert keys to strings when checking defaultOpsAssoc. *)
        Which[

            (* Output and Upload options do not support index matching, and Output can be either listed or non-listed. *)
            MatchQ[#, Output|Upload],
            # -> ConstantArray[myOpsAssoc[#], inputLength],

            (* For Listed Options. *)
            (* Note that Options[] returns option names as strings rather than symbols, hence the use of ToString[]. *)
            MatchQ[defaultOpsAssoc[ToString[#]],  {__}],
            expandOptionsListed[inputs, myOpsAssoc, #],

            (* For Non-listed Options (all other options). *)
            True,
            expandOptionsNonListed[inputs, myOpsAssoc, #]

        ] &,
        Keys[myOpsAssoc]
    ];

    (* If any options were improperly index-matched, return $Failed, else return expanded options. *)
    If[ContainsAny[Flatten[Values[expandedOptions]], {$Failed}],
        $Failed,
        expandedOptions
    ]

];
expandOptionsListed[myInputs_, myOps_, optionName_] := Module[
    {inputLength},

    (* This function assumes none of the options are lists of lists in the singleton case, else this function needs to be refactored. *)
    inputLength = Length[myInputs];
    Which[
        (* Index Matched Listed Option - Return Unchanged. *)
        MatchQ[myOps[optionName], {{__}..}] && MatchQ[Length[myOps[optionName]], inputLength],
        optionName -> myOps[optionName],

        (* Mismatched Lengths - Return $Failed.*)
        MatchQ[myOps[optionName], {{__} ..}] && !MatchQ[Length[myOps[optionName]], inputLength],
        Message[Error::InputLengthMismatch, myInputs, inputLength, optionName, Length[myOps[optionName]]];
        optionName -> ConstantArray[$Failed, inputLength],

        (* Single Listed Option - Expand. *)
        True,
        optionName -> ConstantArray[myOps[optionName], inputLength]
    ]
];
expandOptionsNonListed[myInputs_, myOps_, optionName_] := Module[
    {inputLength},

    inputLength = Length[myInputs];
    Which[
        (*Single Option - Expand. *)
        (* Must check for list head, b/c things like Quantity will have non-zero lengths, and length check below would incorrectly fail. *)
        !MatchQ[myOps[optionName], {__}],
        optionName -> ConstantArray[myOps[optionName], inputLength],

        (* Index Matched option - Return unchanged. *)
        MatchQ[Length[myOps[optionName]], inputLength],
        optionName -> myOps[optionName],

        (* Mismatched Lengths - Return $Failed.*)
        True,
        Message[Error::InputLengthMismatch, myInputs, inputLength, optionName, Length[myOps[optionName]]];
        optionName -> ConstantArray[$Failed, inputLength]
    ]
];

separateOptions[{}, inputLength_] := ConstantArray[{}, inputLength];
separateOptions[expandedOps_, inputLength_] := Module[
    {
        optionKeys, optionValues
    },

    (* Create a single list of options for each input to use with SafeOptions. *)
    optionKeys = ConstantArray[Keys[expandedOps], inputLength];
    optionValues = Transpose[Values[expandedOps]];

    MapThread[#1->#2&, {optionKeys, optionValues}, 2]

];

resolveOptionsForSLL[myOps_, safeOps_] := Module[
    {
        myOpsAssoc, myOpsAssocKeys, safeOpsAssoc, resolvedOpsAssoc,
        unresolvedMaxIsotopes, resolvedMaxIsotopes,
        unresolvedProtease, resolvedProtease,
        unresolvedMinCharge, minChargeValue,
        unresolvedMaxCharge, maxChargeValue,
        chargeTest, additionalTests
    },

    (* Convert safeOps to Assocaition *)
    myOpsAssoc = Association[myOps];
    myOpsAssocKeys = Keys[myOpsAssoc];
    safeOpsAssoc = Association[safeOps];
    resolvedOpsAssoc = Association[];

    (* Protease Options *)
    (* resolve the protease option using the helper in Digest.m *)
    unresolvedProtease = Lookup[safeOpsAssoc, Protease];
    resolvedProtease = resolveProteaseOption[unresolvedProtease];
    resolvedOpsAssoc[Protease] = resolvedProtease;

    (* MaxIsotopes *)
    unresolvedMaxIsotopes = Lookup[safeOpsAssoc, MaxIsotopes];
    resolvedMaxIsotopes = If[MatchQ[unresolvedMaxIsotopes, Automatic],
        (* If Automatic, resolved based on inclusion of IsotopeProbabilityCutoff. *)
        If[ContainsAll[myOpsAssocKeys, {IsotopeProbabilityCutoff}],
            Null, (* MaxIsotopes unused if only IsotopeProbabilityCutoff is specified. *)
            1     (* MaxIsotopes is 1 if neither this nor IsotopeProbabilityCutoff is specified. *)
        ],
        unresolvedMaxIsotopes
    ];
    resolvedOpsAssoc[MaxIsotopes] = resolvedMaxIsotopes;

    (* IsotopeProbabilityCutoff  - Fully resolved by SafeOptions. *)
    resolvedOpsAssoc[IsotopeProbabilityCutoff]  = Lookup[safeOpsAssoc, IsotopeProbabilityCutoff];

    (* Min / MaxCharge *)
    unresolvedMinCharge = Lookup[safeOpsAssoc, MinCharge];
    unresolvedMaxCharge = Lookup[safeOpsAssoc, MaxCharge];
    minChargeValue = unresolvedMinCharge /. {Automatic -> 1};
    maxChargeValue = unresolvedMaxCharge /. {Automatic -> 2};
    Which[
        (* If min charge is less than max charge, do nothing. *)
        minChargeValue <= maxChargeValue,
        Nothing,
        (* If min charge is less than max charge, and MinCharge was not specified manually, set equal to MaxCharge value. *)
        minChargeValue > maxChargeValue && !ContainsAny[myOpsAssocKeys, {MinCharge}],
        minChargeValue = maxChargeValue,
        (* If min charge is less than max charge, and MaxCharge was not specified manually, set equal to MinCharge value. *)
        minChargeValue > maxChargeValue && !ContainsAny[myOpsAssocKeys, {MaxCharge}],
        maxChargeValue = minChargeValue,
        (* If min charge is less than max charge, and both were specified manually, raise message and throw error later on. *)
        True,
        Message[SimulatePeptideFragmentationSpectra::InvalidCharges];
    ];
    resolvedOpsAssoc[MinCharge] = minChargeValue;
    resolvedOpsAssoc[MaxCharge] = maxChargeValue;

    (* Charge Test - MinCharge must be less than or equal to MaxCharge. *)
    chargeTest = Test["The option MinCharge has a value less than or equal to MaxCharge:",
        minChargeValue <= maxChargeValue,
        True
    ];

    (* IncludedIons - Fully resolved by SafeOptions. *)
    resolvedOpsAssoc[IncludedIons] = Lookup[safeOpsAssoc, IncludedIons];

    (* IncludeLosses - Fully resolved by SafeOptions. *)
    resolvedOpsAssoc[IncludeLosses] = Lookup[safeOpsAssoc, IncludeLosses];

    (* IncludePrecursors - Fully resolved by SafeOptions. *)
    resolvedOpsAssoc[IncludePrecursors] = Lookup[safeOpsAssoc, IncludePrecursors];

    (* Output and Upload - Fully resolved by SafeOptions. *)
    resolvedOpsAssoc[Output] = Lookup[safeOpsAssoc, Output];
    resolvedOpsAssoc[Upload] = Lookup[safeOpsAssoc, Upload];

    (* If the additional tests failed, return $Failed. *)
    additionalTests = {chargeTest};
    If[ContainsAny[Map[RunTest[#][Passed]&, additionalTests], {False}],
        Return[{$Failed, additionalTests}];
    ];

    (* Return the resolved options association as a list of rules, and additional options tests. *)
    {Normal[resolvedOpsAssoc], additionalTests}

];

resolveIsotopeModelOption[myOps_] := Module[{myOpsKeys, isotopeModel},
    (*
    Isotope model is an option in pyopenms that we set depending on user specified options. This is not an option the user can specify directly.
    The three options are: 'coarse', 'fine', or 'none'.
        -The coarse option is only impacted by MaxIsotopes, and generates a number of isotopes up to max isotopes,
        with the specific isotopes determined by their relative intensities, which are normalized in python to sum to 1.
        -The fine option is only impacted by IsotopeProbabilityCutoff, and generates all isotopes with a relative intensity
        greater than or equal to the specified value. These intensities are also normalized in python.
        -The none option will generate only one isotope per fragment.
    If only one of the two SLL options (MaxIsotope and IsotopeProbabilityCutoff) is set, we will pick the isotope model accordingly.
    If both SLL options are set, we will use the coarse model, and then filter by probability in SLL, and re-normalize the intensities.
    If neither is set, we will use the none model.

    Note: Using a very low IsotopeProbabilityCutoff with the fine model (i.e., user does not set MaxIsotopes) can potentially generate a very large number of ions.
    *)

    myOpsKeys = Keys[Association[myOps]];

    isotopeModel = Which[
        ContainsAll[myOpsKeys, {MaxIsotopes, IsotopeProbabiltyCutoff}],
        "coarse",
        ContainsAll[myOpsKeys, {MaxIsotopes}],
        "coarse",
        ContainsAll[myOpsKeys, {IsotopeProbabilityCutoff}],
        "fine",
        !ContainsAny[myOpsKeys, {MaxIsotopes, IsotopeProbabiltyCutoff}],
        "none"
    ];

    isotopeModel

];

resolveOptionsForHTTPRequestJSON[resolvedOptionsForSLL_] := Module[
    {
        opsKeys, opsValues,
        resolvedOpsAssoc, requestOpsAssoc,
        resolvedProtease,
        unresolvedMaxIsotopes, resolvedMaxIsotopes,
        unresolvedCutoff, resolvedCutoff,
        resolvedIsotopeModel,
        unresolvedMinCharge, resolvedMinCharge,
        unresolvedMaxCharge, resolvedMaxCharge,
        unresolvedIons, resolvedIons,
        unresolvedIncludeLosses, resolvedIncludeLosses,
        unresolvedIncludePrecursors, resolvedIncludePrecursors
    },

    (* Convert resolvedOptionsForSLL to Assocaition of lists. *)
    opsKeys = Keys[resolvedOptionsForSLL][[1]];
    opsValues = Transpose[Values[resolvedOptionsForSLL]];
    resolvedOpsAssoc = Association[MapThread[#1 -> #2 &, {opsKeys, opsValues}]];
    requestOpsAssoc = Association[];

    (* Protease Options - Already a string. *)
    (* Null protease (i.e., no digest step) must be a symbol, not a string, so replace for that case only. *)
    resolvedProtease = Lookup[resolvedOpsAssoc, Protease] /. {"Null"->Null};
    requestOpsAssoc["Enzymes"] = resolvedProtease;

    (*
      Although we pass both MaxIsotope and IsotopeProbabilityCutoff options into the HTTPRequest, pyopenms 2.7 cannot
      support both options simultaneously, since the former only affects the 'coarse' isotope model and the latter
      only affect the 'fine' isotope model.
      We choose the isotope model based on which combination of options is specified. See note in resolveIsotopeModelOption.
    *)

    (* MaxIsotopes *)
    (*
      If MaxIsotopes is Null, don't add it to resolved ops assoc.
      Could also just choose any value since IsotopeModel will be 'fine', meaning this value will go unused.
    *)
    unresolvedMaxIsotopes = Lookup[resolvedOpsAssoc, MaxIsotopes];
    If[!MatchQ[unresolvedMaxIsotopes, {Null...}],
        resolvedMaxIsotopes = Map[ToString[#]&, unresolvedMaxIsotopes];
        requestOpsAssoc["MaxIsotopes"] = resolvedMaxIsotopes;
    ];

    (* IsotopeProbabilityCutoff *)
    unresolvedCutoff = Lookup[resolvedOpsAssoc, IsotopeProbabilityCutoff];
    resolvedCutoff = Map[ToString[N[QuantityMagnitude[#]/100]]&, unresolvedCutoff];
    requestOpsAssoc["IsotopeProbabilityCutoff"] = resolvedCutoff;

    (* IsotopeModel *)
    (* Already fully resolved / correctly formatted for HTTPRequestJSON. *)
    (* Reminder, this specific key is a string, not a symbol, because it is not user facing.*)
    resolvedIsotopeModel = Lookup[resolvedOpsAssoc, "IsotopeModel"];
    requestOpsAssoc["IsotopeModel"] = resolvedIsotopeModel;

    (* Min / MaxCharge*)
    unresolvedMinCharge = Lookup[resolvedOpsAssoc, MinCharge];
    unresolvedMaxCharge = Lookup[resolvedOpsAssoc, MaxCharge];
    resolvedMinCharge = Map[ToString[#]&, unresolvedMinCharge];
    resolvedMaxCharge = Map[ToString[#]&, unresolvedMaxCharge];
    requestOpsAssoc["MinCharge"] = resolvedMinCharge;
    requestOpsAssoc["MaxCharge"] = resolvedMaxCharge;

    (* IncludedIons *)
    unresolvedIons = Lookup[resolvedOpsAssoc, IncludedIons];
    resolvedIons = Map[ToString[#]&, unresolvedIons, 2];
    requestOpsAssoc["IncludedIons"] = resolvedIons;

    (* IncludeLosses *)
    unresolvedIncludeLosses = Lookup[resolvedOpsAssoc, IncludeLosses];
    resolvedIncludeLosses = unresolvedIncludeLosses /. {True -> "true", False-> "false"};
    requestOpsAssoc["IncludeLosses"] = resolvedIncludeLosses;

    (* IncludePrecursors *)
    unresolvedIncludePrecursors = Lookup[resolvedOpsAssoc, IncludePrecursors];
    resolvedIncludePrecursors = unresolvedIncludePrecursors /. {True -> "true", False-> "false"};
    requestOpsAssoc["IncludePrecursors"] = resolvedIncludePrecursors;

    (* Return the resolved options association as a list of rules. *)
    Normal[requestOpsAssoc]

];

(* Lookup function for State, with a singleton and listable definition. *)
LookupFromState[state:StateP, field_] := state[field];
LookupFromState[states:{StateP..}, field_] := Map[#[field]&, states];

(* Get the positions of duplicate species in a list. *)
positionDuplicates[list_] := GatherBy[Range@Length[list], list[[#]] &];

(* Combines the duplicate species / concentrations into a new state. *)
combineDuplicatesInState[state_] := Module[
    {species, concs, duplicateSpeciesPos, speciesNoDups, totalConcs},

    species = LookupFromState[state, Species];
    concs = LookupFromState[state, Quantities];
    duplicateSpeciesPos = positionDuplicates[species];
    If[!MatchQ[duplicateSpeciesPos, {{_}..}], Message[SimulatePeptideFragmentationSpectra::DuplicateSpecies]];

    speciesNoDups = Map[species[[First[#]]]&, duplicateSpeciesPos];
    totalConcs = Map[Total[concs[[#]]]&, duplicateSpeciesPos];

    State @@ MapThread[{#1, #2} &, {speciesNoDups, totalConcs}]
];

(* Convert Strand to a String, preserving internal quotes as needed for web app. *)
toStringPreserveQuotes[input_] := ToString[input /. x_String :> ("\"" <> x <> "\"")];

(* Sequence To Strand *)
sequenceToStrand[sequence_] := Module[{sequenceThreeLetter},

    (* Convert from single letter codes to three letter codes. Sorted alphabetically by three letter code.*)
    sequenceThreeLetter = Characters[sequence] /. {
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
    };
    Strand[StringJoin[sequenceThreeLetter]]

];

(* Fragments from Ion Labels *)
(* link for understanding peptide fragmentation naming: http://www.matrixscience.com/help/fragmentation_help.html *)
createFragmentsFromLabels[strand_, ionLabels_] := Module[
    {
        buildingBlocks,
        isPrecursor, precursorPositions, precursorLabels,
        ionPositions, ionLabelsFiltered,
        ionFragments, ionCharges, ionLosses,
        precursorFragments, precursorCharges,
        combinedOrdering,
        combinedFragments, reorderedCombinedFragments,
        combinedCharges, reorderedCombinedCharges,
        combinedLosses, reorderedCombinedLosses
    },

    (* Convert the sequence into list of building blocks (i.e., the list of individual amino acids). *)
    buildingBlocks = buildingBlocksFromStrand[strand];

    (* Separate precursor and ion fragments from ion labels and handle separately. *)
    (*
      Save the original indicies of the list so we can join the ion fragments and precursor fragments at their
      original positions for index matching with the ion labels.
    *)
    isPrecursor = Map[StringContainsQ[#, "[M+H]"]&, ionLabels];
    precursorPositions = Flatten[Position[isPrecursor, True]];
    precursorLabels = ionLabels[[precursorPositions]];

    ionPositions = Complement[Range[Length[ionLabels]], precursorPositions];
    ionLabelsFiltered = ionLabels[[ionPositions]];

    (* Create the fragments. *)
    {ionFragments, ionCharges, ionLosses} = createIonFragments[ionLabelsFiltered, buildingBlocks];
    {precursorFragments, precursorCharges} = createPrecursorFragments[precursorLabels, buildingBlocks];

    (* Join ion and precursor fragments at original label positions. *)
    combinedOrdering = Ordering[Join[ionPositions, precursorPositions]];
    combinedFragments = Join[ionFragments, precursorFragments];
    reorderedCombinedFragments = combinedFragments[[combinedOrdering]];

    (* Do the same for charges. *)
    combinedCharges = Join[ionCharges, precursorCharges];
    reorderedCombinedCharges = combinedCharges[[combinedOrdering]];

    (* Do the same for losses, adding Null losses for precursors. *)
    combinedLosses = Join[ionLosses, ConstantArray[Null, Length[precursorPositions]]];
    reorderedCombinedLosses = combinedLosses[[combinedOrdering]];

    (* Return the Ion Fragments as a list of Strands. *)
    {reorderedCombinedFragments, reorderedCombinedCharges, reorderedCombinedLosses}

];

buildingBlocksFromStrand[strand_] := Module[
    {
        subsequences, threeLetterCodesSplit, buildingBlocks
    },

    (* Get subsequences adn split the strings every 3 characters (the characters are still separate). *)
    (* Ex. {"LysArgGlu", "LysArg"} becomes {{{"L", "y", "s"}, {"A", "r", "g"}, {"G", "l", "u"}}, {{"L", "y", "s"}, {"A", "r", "g"}}} *)
    subsequences = strand[Sequences];
    threeLetterCodesSplit= Map[Partition[Characters[#], 3] &, subsequences];

    (* Flatten the list and join the individual characters. The list becomes {"Lys", "Arg", "Glu", "Lys", "Arg"} *)
    buildingBlocks = Map[StringJoin[#]&, Flatten[threeLetterCodesSplit, 1]];

    (* Return the building blocks. *)
    buildingBlocks

];

createIonFragments[ionLabels_, buildingBlocks_] := Module[
    {
        ionLetters, ionNumbers, ionLosses,
        ionChargesStrings, ionCharges, ionFragments
    },

    (* Determine fragment type from string (a,b,c,x,y,z). *)
    ionLetters = Map[StringTake[#, 1] &, ionLabels];

    (* Determine the length of the fragment. *)
    (* First digit character of the ion fragments will always be the fragment length. *)
    ionNumbers = Map[
        ToExpression[ StringCases[#, DigitCharacter ..][[1]] ]&,
        ionLabels
    ];

    (* Check for any fragment losses. *)
    (* Loss fragments will be formatted as <fragLetter><fragNumber>-<loss><charge>. Ex. y12-H2O+++*)
    ionLosses = Map[
        If[StringContainsQ[#, "-"],
            StringDelete[StringSplit[#, "-"][[2]], "+"],
            Null
        ]&,
        ionLabels
    ];

    (* Get the charges. *)
    (* This works for both + and - charges, though pyopenms only generates + charges. *)
    ionChargesStrings = Map[
        StringCases[#, "+" .. | "-" ..][[-1]]&,
        ionLabels
    ];
    ionCharges = Map[
        If[StringContainsQ[#, "+"],
            StringLength[#],
            -StringLength[#]
        ]&,
        ionChargesStrings
    ];

    (* Strand-ify the fragments. *)
    ionFragments = MapThread[
        Which[
            (* a, b, c fragments - Count from N-terminus (left to right). Modifications come last. *)
            MatchQ[#1, "b"],
            Strand[StringJoin[ Take[buildingBlocks, #2] ]],
            MatchQ[#1, "a"], (* Loss of C=O *)
            Strand[
                StringJoin[ Take[buildingBlocks, (#2-1)] ] /. {""->Sequence[]},
                Modification[StringJoin[ buildingBlocks[[-#2]], "-C=O"]]
            ],
            MatchQ[#1, "c"], (* Gain of N-H *)
            Strand[
                StringJoin[ Take[buildingBlocks, (#2-1)] ] /. {""->Sequence[]},
                Modification[StringJoin[buildingBlocks[[-#2]], "+NH"]]
            ],

            (* x, y, z fragments - Count from C-terminus (right to left). Modifications come first.  *)
            MatchQ[#1, "y"],
            Strand[StringJoin[ Take[buildingBlocks, -#2] ]],
            MatchQ[#1, "x"], (* Gain of C=O *)
            Strand[
                Modification[StringJoin[buildingBlocks[[-#2]], "+C=O"]],
                StringJoin[ Take[buildingBlocks, (-#2+1)] ] /. {""->Sequence[]}
            ],
            MatchQ[#1, "z"], (* Loss of N-H *)
            Strand[
                Modification[StringJoin[buildingBlocks[[-#2]], "-NH"]],
                StringJoin[ Take[buildingBlocks, (-#2+1)] ] /. {""->Sequence[]}
            ]
        ] &,
        {ionLetters, ionNumbers}
    ];

    (* Return the fragments and losses. *)
    {ionFragments, ionCharges, ionLosses}
];

createPrecursorFragments[precursorLabels_, buildingBlocks_] := Module[
    {
        pfMolecules, pfChargesStrings, pfCharges, pfFragments
    },

    (* Generate precursor fragments. *)
    (*
      For precursor stuff, Use string split rather than string delete since there are more alphabet characters and also
      + and - characters which are not charges.
    *)

    (* Precursor molecules only have removed groups, so it is safe to split on both + and -. *)
    (* Can also have [M+H]++ as a precursor ion, so return string "None" for that. *)
    (* Ex. {[M+H]-H2O++, [M+H]-NH3++, [M+H]++} becomes {H2O, NH3, None} *)
    pfMolecules = Map[
        If[StringSplit[#, {"[M+H]", "-", "+"}] == {},
            "None",
            StringSplit[#, {"[M+H]", "-", "+"}][[-1]]
        ]&,
        precursorLabels
    ];

    (* Precursor fragments will have a + in the [M+H], but will always end with a letter, number, or ] followed by the charge. *)
    (* Split on various characters and just take the last sequence from the list. *)
    pfChargesStrings = Map[
        StringSplit[#, {DigitCharacter, LetterCharacter, "[", "]"}][[-1]]&,
        precursorLabels
    ];
    pfCharges = Map[
        If[StringContainsQ[#, "+"],
            StringLength[#],
            -StringLength[#]
        ]&,
        pfChargesStrings
    ];

    pfFragments = Map[
        Which[
            (* Precursor modifications happen at the related terminal end, unlike peptides where they happen opposite the retained terminus.  *)
            MatchQ[#, "NH3"], (* Loss of NH3 from N-Terminus. Modifications come first.*)
            Strand[
                Modification[StringJoin[buildingBlocks[[1]], "-NH3"]],
                StringJoin[buildingBlocks[[2;;]]]
            ],
            MatchQ[#1, "H2O"], (* Loss of H2O from C-Terminus. Modifications come Last. *)
            Strand[
                StringJoin[buildingBlocks[[;;-2]]],
                Modification[StringJoin[buildingBlocks[[-1]], "-H2O"]]
            ],
            MatchQ[#, "None"],
            Strand[StringJoin[buildingBlocks]]
        ]&,
        pfMolecules
    ];

    (* Return the precursor fragments. *)
    {pfFragments, pfCharges}

];

(* Format the response packet into SLL Object packets. *)
formatPacket[input_, packet_, unresolvedOps_, resolvedOps_] := Module[
    {
        sequences, strands, subPackets,
        ionsLabelsFiltered, massOverChargesFiltered, intensitiesFiltered,
        intensitiesFilteredAndNormalized,
        ions, charges, losses, masses,
        simPacketID, massSpectraPacketIDs,
        massSpectraPackets, simPacket
    },

    (* Get the sequences, and associated data. *)
    (* Data is in the form: {Sequence -> <|ions -> ..., m/z -> ..., intensities -> ...|>, ... } *)
    sequences = Keys[packet];
    strands = Map[sequenceToStrand[#]&, sequences];
    subPackets = Values[packet];

    (*
      Filter the ions by intensity and re-normalize.
      See note in resolveIsotopeModelOption for why this is not always handled by the python code.
    *)
    {ionsLabelsFiltered, massOverChargesFiltered, intensitiesFiltered} = filterIonsByIntensity[subPackets, resolvedOps];
    intensitiesFilteredAndNormalized = MapThread[normalizeIntensities[#1, #2]&, {ionsLabelsFiltered, intensitiesFiltered}];

    (* Generate strand representations of the ion fragments. *)
    (* Also return fragment charges and any side chain losses. *)
    {ions, charges, losses} = Transpose[MapThread[createFragmentsFromLabels[#1, #2]&, {strands, ionsLabelsFiltered}]];

    (* Calculate mass from mass to charge ratio and charge. *)
    masses = MapThread[(#1*#2)&, {massOverChargesFiltered, charges}];

    (* Create the Simulation and MassSpectra packets and return. *)
    (* Must Create DB ID so that we can create the links. *)
    simPacketID = CreateID[Object[Simulation, FragmentationSpectra]];
    massSpectraPacketIDs = Table[CreateID[Object[MassFragmentationSpectrum]], Length[sequences]];

    massSpectraPackets = MapThread[
        <|
            Object -> #1,
            Reference -> Link[simPacketID, MassFragmentationSpectra],
            Replace[IonLabels] -> #2,
            Replace[Ions] -> #3,
            Replace[Masses] -> Map[(#*Dalton)&, #4],
            Replace[Charges] -> #5,
            Replace[Losses] -> #6,
            Replace[RelativeIntensities] -> #7,
            Replace[MassToChargeRatios] -> Map[(#*Dalton)&, #8]
        |>&,
        {massSpectraPacketIDs, ionsLabelsFiltered, ions, masses, charges, losses, intensitiesFilteredAndNormalized, massOverChargesFiltered}
    ];

    (* The input is either an ObjectID or a State. *)
    simPacket = <|
        Object -> simPacketID,
        (* If input is a state, set InputState field. If it's an object id, set reference field. *)
        If[MatchQ[input, StateP],
            InputState -> input,
            Reference -> Link[Object[Sample, input]]
        ],
        Replace[PrecursorMolecules] -> strands,
        Replace[MassFragmentationSpectra] -> Link[massSpectraPacketIDs, Reference],
        Replace[UnresolvedOptions] -> unresolvedOps,
        Replace[ResolvedOptions] -> resolvedOps
    |>;

    {simPacket, massSpectraPackets}

];

filterIonsByIntensity[subPackets_, resolvedOps_] := Module[
    {
        ionLabels, massOverCharge, intensities,
        minIntensity, filteredIndicies,
        ionsLabelsFiltered, massOverChargesFiltered, intensitiesFiltered
    },

    (* Get the ions, mass-to-charge rations, and intensities from the subPackets. *)
    (* Note that each of these lists of lists are index matched to the sequences *)
    ionLabels = Lookup[subPackets, "ions"];
    massOverCharge = Lookup[subPackets, "m/z"];
    intensities = Lookup[subPackets, "intensities"];

    (*
      Filter the ions by intensity.
      See note in resolveIsotopeModelOption for why this is not always handled by the python code.
    *)
    minIntensity = N[QuantityMagnitude[Lookup[resolvedOps, IsotopeProbabilityCutoff]]/100];
    filteredIndicies = Map[Flatten[Position[#, GreaterEqualP[minIntensity]]]&, intensities];
    ionsLabelsFiltered = MapThread[#1[[#2]]&, {ionLabels, filteredIndicies}];
    massOverChargesFiltered = MapThread[#1[[#2]]&, {massOverCharge, filteredIndicies}];
    intensitiesFiltered = MapThread[#1[[#2]]&, {intensities, filteredIndicies}];

    {ionsLabelsFiltered, massOverChargesFiltered, intensitiesFiltered}

];

normalizeIntensities[ionLabels_, intensities_] := Module[
    {
        ionLabelsSet, duplicateLabelPositions, groupedIntensities,
        normFactorSet, normFactorRules, normFactorArray,
        normalizedIntensities
    },

    ionLabelsSet = DeleteDuplicates[ionLabels];
    duplicateLabelPositions = Map[Flatten[Position[ionLabels, #]] &, ionLabelsSet];
    groupedIntensities = Map[intensities[[#]] &, duplicateLabelPositions];
    normFactorSet = Map[Total, groupedIntensities];
    normFactorRules = MapThread[Rule, {ionLabelsSet, normFactorSet}];
    normFactorArray = ionLabels /. normFactorRules;
    normalizedIntensities = MapThread[#1/#2 &, {intensities, normFactorArray}];

    normalizedIntensities

];

(* Parses the response packets into the requested outputs. *)
parseResponse[input_, response_, unresolvedOps_, resolvedOps_, tests_] := Module[
    {
        unformattedPackets, formattedPackets,
        simulationPacketsFull, massFragSpectrumPacketsFull,
        isUpload, output,
        optionsRule, testsRule, plotTitles, previewRule, resultRule
    },

    (* Check for response error / errors in the response. *)
    If[MatchQ[response, _HTTPError] || Lookup[response, "Error", False],
        Message[SimulatePeptideFragmentationSpectra::FatalError];
        Return[$Failed]
    ];

    (* Format the response into Object Packets. *)
    unformattedPackets = Values[response];
    formattedPackets = MapThread[formatPacket[#1, #2, #3, #4]&, {input, unformattedPackets, unresolvedOps, resolvedOps}];

    (* Grab the packets from the full list of results. Strip the append/replace heads. *)
    simulationPacketsFull = Map[#[[1]]&, formattedPackets];
    simulationPacketsFull = Map[Analysis`Private`stripAppendReplaceKeyHeads[#]&, simulationPacketsFull];
    massFragSpectrumPacketsFull = Map[#[[2]]&, formattedPackets];
    massFragSpectrumPacketsFull = Map[Analysis`Private`stripAppendReplaceKeyHeads[#]&, massFragSpectrumPacketsFull, {2}];

    (* Check if Objects should be uploaded. *)
    (* Upload is same across all inputs, so just check from the first list of resolved options. *)
    isUpload = Lookup[Association@resolvedOps[[1]], Upload];
    If[isUpload,
        (* Since packets are associations, flatten will stop once it hits a 'pure' packet. No need for level specs. *)
        Upload[Flatten@formattedPackets]
    ];

    (* Determine the requested return value from the function *)
    (* Output is same across all inputs, so just check from the first list of resolved options. *)
    (* Create a copy of the requested output to replace with actual output values. *)
    output = Lookup[Association@resolvedOps[[1]], Output];

    (* --- Generate rules for each possible Output value ---  *)
    optionsRule = Options->resolvedOps;
    testsRule = Tests->tests;
    (* Generate plot titles for preview. *)
    plotTitles = Map[ToString, Lookup[simulationPacketsFull, Object]];
    previewRule = Preview->If[MemberQ[ToList[output], Preview],
        (* Because we are working with the packets, we do not do any downloads and can map the plot function. *)
        (*
          Pass in the MassFragmentationSpectrum packets and set Collapse->True, since the plot function will
          not be able to download from non-uploaded objects in the Simulation object.
        *)
        If[Length[simulationPacketsFull] == 1,
            (* Feels like we should need to call First here since we map, but apparently not?? *)
            MapThread[PlotPeptideFragmentationSpectra[#1, Collapse->True, Title->#2]&, {massFragSpectrumPacketsFull, plotTitles}],
            SlideView@MapThread[PlotPeptideFragmentationSpectra[#1, Collapse->True, Title->#2]&, {massFragSpectrumPacketsFull, plotTitles}]
        ]
    ];
    resultRule = Result->If[isUpload,
        Map[First[#][Object]&, formattedPackets],
        Map[Analysis`Private`stripAppendReplaceKeyHeads[#]&, formattedPackets, {2}]
    ];

    (* Return requested stuff. *)
    output = output /. {optionsRule, testsRule, previewRule, resultRule}

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


(* ::Subsection:: *)
(* Companion Functions *)

inputPatternSimulatePeptideFragmentationSpectraP = Alternatives[
    ObjectReferenceP[Object[Sample]],
    {ObjectReferenceP[Object[Sample]]..},
    {StrandP..},
    {{StrandP..}..},
    StrandP,
    StateP,
    {StateP..}
];


(* ::Subsubsection:: *)
(* SimulatePeptideFragmentationSpectraOptions *)

Authors[SimulatePeptideFragmentationSpectraOptions] := {"scicomp", "brian.day"};

SimulatePeptideFragmentationSpectraOptions[in:inputPatternSimulatePeptideFragmentationSpectraP, ops:OptionsPattern[SimulatePeptideFragmentationSpectra]] := Module[
    {listedOptions, noOutputOptions},

    (* Convert options to a list, and remove the Output option before passing to the core function. *)
    listedOptions = ToList[ops];
    noOutputOptions = DeleteCases[listedOptions, Output -> _];
    SimulatePeptideFragmentationSpectra[in, PassOptions[SimulatePeptideFragmentationSpectra, Append[noOutputOptions, Output->Options]]]
];



(* ::Subsubsection:: *)
(* SimulatePeptideFragmentationSpectraPreview *)

Authors[SimulatePeptideFragmentationSpectraPreview] := {"scicomp", "brian.day"};

SimulatePeptideFragmentationSpectraPreview[in:inputPatternSimulatePeptideFragmentationSpectraP, ops:OptionsPattern[SimulatePeptideFragmentationSpectra]] := Module[
    {listedOptions, noOutputOptions},

    (* Convert options to a list, and remove the Output option before passing to the core function. *)
    listedOptions = ToList[ops];
    noOutputOptions = DeleteCases[listedOptions, Output -> _];
    SimulatePeptideFragmentationSpectra[in, PassOptions[SimulatePeptideFragmentationSpectra, Join[noOutputOptions, {Output->Preview, Upload->False}]]]

];


(* ::Subsubsection:: *)
(* ValidSimulatePeptideFragmentationSpectraQ *)

DefineOptions[ValidSimulatePeptideFragmentationSpectraQ,
    Options:>{
        VerboseOption,
        OutputFormatOption
    },
    SharedOptions :> {SimulatePeptideFragmentationSpectra}
];

Authors[ValidSimulatePeptideFragmentationSpectraQ] := {"scicomp", "brian.day"};

ValidSimulatePeptideFragmentationSpectraQ[myInput:inputPatternSimulatePeptideFragmentationSpectraP, myOptions:OptionsPattern[]] := Module[
    {listedObjects, listedOptions, preparedOptions, functionTests, initialTestDescription, allTests, verbose, outputFormat},

    (* Create list of any objects inputs. This will be checked against ValidObjectQ*)
    listedObjects = Cases[ToList[myInput], ObjectP[], All];

    (* Convert all options to list. Remove the Verbose and OutputFormat options. Add Output->Tests. *)
    (* Call the function with the modified options to get a list of tests. *)
    listedOptions = ToList[myOptions];
    (* TODO: How to test output option and also get tests from function? *)
    (* Remove Test from output, add it back in first position, and get First from output? *)
    preparedOptions = Join[Normal[KeyDrop[listedOptions, {Verbose, OutputFormat}]], {Output->Tests}];
    (* Quiet the call to supress any SafeOptions messages. *)
    functionTests = Quiet[SimulatePeptideFragmentationSpectra[myInput, preparedOptions]];

    (* Create initial test description. If ValidQ function is unable to get the tests, this it the only test which will be returned. *)
    initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

    (* Get the tests. *)
    allTests = If[MatchQ[functionTests, $Failed],

        (* True - Failed to get tests, just return initial test.*)
        {Test[initialTestDescription, False, True]},

        (* False - Got tests successfully. *)
        Module[{initialTest,validObjectBooleans,voqWarnings},

            (* Create passing initial test. *)
            initialTest = Test[initialTestDescription, True, True];

            (* Check for invalid objects and create warnings is necessary. *)
            validObjectBooleans = ValidObjectQ[listedObjects, OutputFormat->Boolean];

            If[!MatchQ[listedObjects, {}],
                (* False - Invalid objects in inputs. Create object warning tests and join with other tests. *)
                voqWarnings = MapThread[
                    Warning[ToString[#1,InputForm]<>" is valid (if an object, run ValidObjectQ for more detailed information):",
                        #2,
                        True
                    ]&,
                    {listedObjects,validObjectBooleans}
                ];
                Join[{initialTest},Flatten[functionTests],voqWarnings],

                (* True - Just return the function tests. *)
                Join[{initialTest},Flatten[functionTests]]
            ]
        ]
    ];

    (* Determine the Verbose and OutputFormat options. *)
    {verbose, outputFormat} = OptionDefault[OptionValue[{Verbose, OutputFormat}]];

    (* Run the tests. *)
    RunUnitTest[
        <|"ValidSimulatePeptideFragmentationSpectraQ" -> allTests|>,
        OutputFormat -> outputFormat,
        Verbose -> verbose
    ]["ValidSimulatePeptideFragmentationSpectraQ"]
];

