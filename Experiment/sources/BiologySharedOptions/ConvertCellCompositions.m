(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: User *)
(* :Date: 2023-05-10 *)

(* NOTE: This function requires that the Composition field is contained within each of the sample packets. *)
(* Input: sample packets with the Composition field. *)
(* Output: sample packets with any non (cell/mL) units converted into (cell/mL) if there is a standard curve, otherwise, *)
(* the cell composition entry is left unconverted. *)


convertCellCompositions[mySamplePackets : {PacketP[Object[Sample]]..}] := Module[
  {cellConcentrationCompatibleP, nonCellConcentrationP, cellConcentrationLookup},

  cellConcentrationCompatibleP = PercentConfluencyP | CellConcentrationP | CFUConcentrationP | OD600P;
  nonCellConcentrationP = PercentConfluencyP | CFUConcentrationP | OD600P;

  (* NOTE: For any composition entries that are in the form {nonCellConcentrationP, ObjectP[]} -> {CellConcentrationP, ObjectP[]}. *)
  cellConcentrationLookup = Module[{allSampleCompositions, cellCompositionsInOtherUnits},
    (* Get all of the composition entries and join them together. *)
    allSampleCompositions = Join[Lookup[mySamplePackets, Composition]];

    (* Get all of the composition entries that are NOT in CellConcentrationP and try to convert them to CellConcentration (Cells/mL). *)
    cellCompositionsInOtherUnits = Cases[Flatten[allSampleCompositions, 1], {nonCellConcentrationP, ObjectP[]}];

    (* If we have any cell compositions in other units, try to convert them to Cells / mL. *)
    If[Length[cellCompositionsInOtherUnits] > 0,
      Module[{convertedConcentrations, convertedSampleCompositions},
        convertedConcentrations = Quiet[ConvertCellConcentration[cellCompositionsInOtherUnits[[All, 1]], Cell / Milliliter, cellCompositionsInOtherUnits[[All, 2]]]];
        convertedSampleCompositions = Transpose[{convertedConcentrations, cellCompositionsInOtherUnits[[All, 2]]}];

        (* NOTE: Don't want to include the replace rule if we weren't able to convert the cell concentration. *)
        MapThread[
          If[MatchQ[#2[[1]], Except[$Failed]],
            #1 -> #2,
            Nothing] &,
          {cellCompositionsInOtherUnits, convertedSampleCompositions}]
      ],
      {}]
  ];

  (* Replace the composition field in each of the sample packets. *)
  Map[
    Function[{samplePacket},
      Append[
        samplePacket,
        Composition -> (Lookup[samplePacket, Composition] /. cellConcentrationLookup)
      ]
    ],
    mySamplePackets
  ]
];

