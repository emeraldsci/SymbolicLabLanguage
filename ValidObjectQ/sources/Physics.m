(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validPhysicsQTests*)

validPhysicsQTests[myPacket:PacketP[Model[Physics]]]:={

(* General fields filled in *)
  NotNullFieldTest[myPacket,
    {
    Name,
    DateCreated,
    Authors
    }
  ],
  Test["DateCreated is in the past:",
    Lookup[myPacket,DateCreated],
    _?(#<=Now&)|Null
  ]
};


(* ::Subsection::Closed:: *)
(*validPhysicsOligomerQTests*)

validPhysicsOligomerQTests[myPacket:PacketP[Model[Physics,Oligomer]]]:=
  Join[
    NotNullFieldTest[
      myPacket,
      {
        Alphabet,
        DegenerateAlphabet,
        WildcardMonomer,
        NullMonomer,
        MonomerMass,
        InitialMass,
        TerminalMass
      }
    ],
    validPolymerAlphabetTests[myPacket]
  ];

(* ::Subsection::Closed:: *)
(*validPhysicsModificationQTests*)

validPhysicsModificationQTests[myPacket:PacketP[Model[Physics,Modification]]]:=Module[
  {
    maxEmissionWavelength=Lookup[myPacket,MaxEmissionWavelength],
    lambdaMax=Lookup[myPacket,LambdaMax]
  },
  {
    NotNullFieldTest[
      myPacket,
      Mass
    ],
    Test["If MaxEmissionWavelength is informed, then LambdaMax should also be informed:",
      If[!MatchQ[maxEmissionWavelength, Null]&&MatchQ[lambdaMax, Null], False, True],
      True
    ]
  }
];

(* ::Subsection::Closed:: *)
(*validPhysicsExtinctionCoefficientsQTests*)

validPhysicsExtinctionCoefficientsQTests[myPacket:PacketP[Model[Physics,ExtinctionCoefficients]]]:=Module[
  {wavelengths=Lookup[myPacket,Wavelengths]},
  {
    NotNullFieldTest[
      myPacket,
      OligomerPhysics
    ],
    Test["Wavelengths are sorted in ascending order:",
      Sort[wavelengths],
      wavelengths
    ]
  }
];

(* ::Subsection::Closed:: *)
(*validPhysicsKineticsQTests*)

validPhysicsKineticsQTests[myPacket:PacketP[Model[Physics,Kinetics]]]:=
    {
      NotNullFieldTest[
        myPacket,
        OligomerPhysics
      ]
    };

(* ::Subsection::Closed:: *)
(*validPhysicsThermodynamicsQTests*)

validPhysicsThermodynamicsQTests[myPacket:PacketP[Model[Physics,Thermodynamics]]]:=
  {
    NotNullFieldTest[
      myPacket, {
      OligomerPhysics,
      StackingEnergy,
      StackingEnthalpy,
      StackingEntropy,
      InitialEnergyCorrection,
      InitialEnthalpyCorrection,
      InitialEntropyCorrection,
      TerminalEnergyCorrection,
      TerminalEnthalpyCorrection,
      TerminalEntropyCorrection,
      SymmetryEnergyCorrection,
      SymmetryEntropyCorrection
    }
    ]
  };

(* ::Subsection::Closed:: *)
(*validElementDataQTests*)

validElementDataQTests[myPacket:PacketP[Model[Physics, ElementData]]] :=
    {
      NotNullFieldTest[myPacket, {Index}],
      Test["If Index is False, Element must be informed; if Index is True, Element must be Null:",
        Lookup[myPacket, {Index, Element}],
        Alternatives[{True, Null}, {False, ElementP}]
      ],
      Test["If Index is False, Abbreviation must be informed; if Index is True, Abbreviation must be Null:",
        Lookup[myPacket, {Index, Abbreviation}],
        Alternatives[{True, Null}, {False, ElementAbbreviationP}]
      ],
      Test["If Index is False, MolarMass must be informed; if Index is True, MolarMass must be Null:",
        Lookup[myPacket, {Index, MolarMass}],
        Alternatives[{True, Null}, {False, _Quantity}]
      ],
      Test["If Index is False, Isotopes must be informed; if Index is True, Isotopes must be empty:",
        Lookup[myPacket, {Index, Isotopes}],
        Alternatives[{True, {}}, {False, {IsotopeP..}}]
      ],
      Test["If Index is False, IsotopeAbundance must be informed; if Index is True, IsotopeAbundance must be empty:",
        Lookup[myPacket, {Index, IsotopeAbundance}],
        Alternatives[{True, {}}, {False, {_Quantity..}}]
      ],
      Test["If Index is False, IsotopeMasses must be informed; if Index is True, IsotopeMasses must be empty:",
        Lookup[myPacket, {Index, IsotopeMasses}],
        Alternatives[{True, {}}, {False, {_Quantity..}}]
      ],
      Test["If Index is False, Group must be informed; if Index is True, Group must be empty:",
        Lookup[myPacket, {Index, Group}],
        Alternatives[{True, Null}, {False, Except[Null]}]
      ],
      Test["If Index is False, Period must be informed; if Index is True, Period must be empty:",
        Lookup[myPacket, {Index, Period}],
        Alternatives[{True, Null}, {False, _Integer}]
      ],
      Test["If Index is True, Data must be informed; if Index is False, Data must be empty:",
        Lookup[myPacket, {Index, Data}],
        Alternatives[{True, {{ElementP, ObjectP[Model[Physics, ElementData]]}..}}, {False, {}}]
      ],
      Test["If Index is True, AbbreviationIndex must be informed; if Index is False, AbbreviationIndex must be empty:",
        Lookup[myPacket, {Index, AbbreviationIndex}],
        Alternatives[{True, {{ElementAbbreviationP, ObjectP[Model[Physics, ElementData]]}..}}, {False, {}}]
      ]
    };

(* ::Subsection::Closed:: *)
(* Test Registration *)

registerValidQTestFunction[Model[Physics],validPhysicsQTests];
registerValidQTestFunction[Model[Physics,Oligomer],validPhysicsOligomerQTests];
registerValidQTestFunction[Model[Physics,Modification],validPhysicsModificationQTests];
registerValidQTestFunction[Model[Physics,ExtinctionCoefficients],validPhysicsExtinctionCoefficientsQTests];
registerValidQTestFunction[Model[Physics,Kinetics],validPhysicsKineticsQTests];
registerValidQTestFunction[Model[Physics,Thermodynamics],validPhysicsThermodynamicsQTests];
registerValidQTestFunction[Model[Physics,ElementData],validElementDataQTests];

(* ::Subsubsection::Closed:: *)
(*ValidPolymerQ*)

validPolymerAlphabetTests[myPacket:PacketP[Model[Physics,Oligomer]]]:=Module[
  {
    alphabet=Lookup[myPacket,Alphabet],
    degenerateAlphabet=Lookup[myPacket,DegenerateAlphabet],
    wildcardMonomer=Lookup[myPacket,WildcardMonomer],
    nullMonomer=Lookup[myPacket,NullMonomer],
    complements=Lookup[myPacket,Complements],
    alternativeEncodings=Lookup[myPacket,AlternativeEncodings],
    alternativeDegenerateEncodings=Lookup[myPacket,AlternativeDegenerateEncodings],
    degenerateAlphabetSymbols,
    combinedAlphabet,
    allSymbols
  },
  degenerateAlphabetSymbols=Union[First/@degenerateAlphabet];
  combinedAlphabet=Join[alphabet,degenerateAlphabetSymbols];
  {
    Test["Alphabet is prefix free, so the Monomers function will work when you need to break up the sequence:",
      unambiguousAlphabet[alphabet],
      True
    ],
    Test["DegenerateAlphabet is prefix free, so the Monomers function will work when you need to break up the sequence:",
      unambiguousAlphabet[degenerateAlphabetSymbols],
      True
    ],
    Test["Alphabet and DegenerateAlphabet combined are prefix free:",
      unambiguousAlphabet[combinedAlphabet],
      True
    ],
    Test["Wildcard exists in the DegenerateAlphabet symbols:",
      MemberQ[(degenerateAlphabetSymbols),(wildcardMonomer)],
      True
    ],
    Test["Wildcard contains all of the monomers in the Alphabet:",
      Sort[Cases[degenerateAlphabet, {wildcardMonomer, x_} :> x]],
      Sort[alphabet]
    ],
    Test["Null monomer exists in the DegenerateAlphabet symbols:",
      MemberQ[(degenerateAlphabetSymbols),(nullMonomer)],
      True
    ],
    Test["Null monomer refers to an empty list:",
      Sort[Cases[degenerateAlphabet, {nullMonomer, x_} :> x]],
      {Null}
    ],
    Test["Complements are all members of the Alphabet or an empty list:",
      Or[
        MatchQ[(complements),{}],
        MatchQ[(complements),{(Alternatives@@(alphabet)|"")...}]
      ],
      True
    ],
    Test["DegenerateAlphabet consists of monomers in the set of the Alphabet:",
      Sort[DeleteCases[Union[Last/@degenerateAlphabet], Null]],
      Sort[alphabet]
    ],
    Test["Each AlternativeEncodings monomers set is in the set of the Alphabet:",
      And @@ (MatchQ[Complement[Union[Last /@ #], alphabet], {}] & /@ alternativeEncodings),
      True
    ],
    Test["Each monomers set in AlternativeEncodings does not contain repeats:",
      Union[Last /@ #] & /@ alternativeEncodings,
      Sort[Last /@ #] & /@ alternativeEncodings
    ],
    Test["Each symbols set in AlternativeEncodings does not contain repeats:",
      Union[First /@ #] & /@ alternativeEncodings,
      Sort[First /@ #] & /@ alternativeEncodings
    ],
    Test["Each AlternativeEncodings symbols set is prefix free:",
      And @@ (unambiguousAlphabet[First /@ #] & /@ alternativeEncodings),
      True
    ],
    Test["Each AlternativeEncodings set is the same size as Alphabet:",
      And @@ (Length[#] === Length[alphabet] & /@ alternativeEncodings),
      True
    ],
    Test["Each AlternativeDegenerateEncodings members set is in the set of the DegenerateAlphabet:",
      And @@ (MatchQ[Complement[Union[Last /@ #], degenerateAlphabetSymbols], {}] & /@ alternativeDegenerateEncodings),
      True
    ],
    Test["Each members set in AlternativeDegenerateEncodings does not contain repeats:",
      Union[Last /@ #] & /@ alternativeDegenerateEncodings,
      Sort[Last /@ #] & /@ alternativeDegenerateEncodings
    ],
    Test["Each symbols set in AlternativeDegenerateEncodings does not contain repeats:",
      Union[First /@ #] & /@ alternativeDegenerateEncodings,
      Sort[First /@ #] & /@ alternativeDegenerateEncodings
    ],
    Test["Each AlternativeDegenerateEncodings symbols set is prefix free:",
      And @@ (unambiguousAlphabet[First /@ #] & /@ alternativeDegenerateEncodings),
      True
    ],
    Test["Each AlternativeDegenerateEncodings set is the same size as DegenerateAlphabet:",
      And @@ (Length[#] === Length[degenerateAlphabetSymbols] & /@ alternativeDegenerateEncodings),
      True
    ],
    Test["Each combined set of AlternativeEncodings and AlternativeDegenerateEncodings is prefix free:",
      And @@ MapThread[unambiguousAlphabet[Join[First /@ #1, First /@ #2]] &, {alternativeEncodings, alternativeDegenerateEncodings}],
      True
    ]
  }
];

(* AS - A helper function to determine if the alphabet is not ambigous specially when using Monomers *)
unambiguousAlphabet[alphabet:{_String..}]:=Module[
	{allDimers,allTrimers,sortedAlphabet},

	(* All possible dimers based on the alphabet *)
	allDimers=Permutations[alphabet,{2}];

	(* All possible trimers based on the alphabet *)
	allTrimers=Permutations[alphabet,{3}];

	(* Reverse the order of the alphabets *)
	sortedAlphabet=Reverse[SortBy[alphabet,StringLength]];

	(** TODO: technically speaking, we need to check all dimers trimers tetramers etc. if they are the same as any of the alphabet. but since this may get cumbersome we just do the StringContainsQ **)
	And[
		(* No duplicates in the alphabet is allowed *)
		DuplicateFreeQ[alphabet],
		(* The joined alphabet is the same as the joined alphabet that is splitted based on sortedAlphabet and then rejoined *)
		StringJoin[alphabet]==StringJoin[StringCases[StringJoin[alphabet], sortedAlphabet]],
		(* The combination of any two monomers can't constitute another monomer *)
		And@@(
			Nor@@StringContainsQ[alphabet,StringJoin[#]]&/@allDimers
		),
		(* The combination of any three monomers can't constitute another monomer *)
		And@@(
			Nor@@StringContainsQ[alphabet,StringJoin[#]]&/@allTrimers
		)
	]
];

(* Required functions for the validPhysicsOligomerQTests *)
(* Adapted from existing tests *)
prefixFreeMonomer[myMonomer_String,myAlphabet:{_String..}]:=Module[{monoCheck},

  (* Check each member of the myAlphabet to see if it starts with the myMonomer *)
  monoCheck=(!StringMatchQ[#,myMonomer~~___])&/@myAlphabet;

  (* Return true if all of the members passed *)
  And@@monoCheck
];

(* Adapted from existing tests *)
prefixFreeAlphabet[myAlphabet:{_String..}]:=Module[{monomerSortedLists,validMonomers},
  (* Generate a list of all rotations of the myAlphabet *)
  monomerSortedLists=Table[RotateRight[myAlphabet,n],{n,0,Length[myAlphabet]-1}];

  (* Now check to see if each myMonomer does not conflict the rest of the set *)
  validMonomers=prefixFreeMonomer[First[#],Rest[#]]&/@monomerSortedLists;

  (* Return true if all Monomers pass *)
  And@@validMonomers
];

checkPairValidity[myAlphabet : {_String..}, myPairs : {_String..}]:=Module[{sortedAlphabet,alphabetPos,pairsPos,linkedPairs,sortedPairs},
  (* Link the pairs to each other *)
  linkedPairs = Transpose@{myAlphabet,myPairs};

  (* Check that none are identical pairs *)
  sortedPairs = Union /@ linkedPairs;

  (* If there are any identical pairs, sortedPairs will become 1D. If any pair does not agree both ways, then the length of the Union-ed sortedPairs will not be half the number of monomers *)
  If[And[Length[Dimensions[sortedPairs]] == 2, MatchQ[2 Length[Union[sortedPairs]], Length[myAlphabet]]],
    True,
    False
  ]
];
