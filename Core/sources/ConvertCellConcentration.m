(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*ConvertCellConcentration*)

(* Define error messages *)
Error::IndexMatchingLengthMismatch="The value input `1`, targetUnit input `2`, and conversionObject input `3`, must all have the same Length.";
Error::NoCompatibleStandardCurveInCellModel = "The Model[Cell], `1`, does not contain a standard curve that can convert `2` to `3`. Please provide a different Cell object that contains a compatible standard curve.";
Error::StandardCurveFitFunctionNotFound="A best fit function could not be found in `1`. Please provide a different Analysis or Cell object that contains a valid standard curve.";
Error::IncompatibleStandardCurve="The standard curve, `1`, converts from `2` to `3`. It cannot be used to convert from `4` to `5`. Please provide a different object that contains compatible StandardDataUnits or convert to a different target unit.";
Warning::MultipleCompatibleStandardCurves="Multiple compatible standard curves, `1`, were found for the model cell, `2`. The most recently created standard curve was used.";
(* Create the pattern that stores the valid cell concentration units  *)
(* NOTE: Due to load order dependencies, this list MUST BE KEPT IN SYNC with CellConcentrationUnitsP... However it has to be defined separately here because the Core Package gets loaded before the Patterns Package *)
cellConcentrationUnitInputPattern = Alternatives @@ (UnitsP /@ Alternatives[OD600, Cell/Milliliter, CFU/Milliliter, RelativeNephelometricUnit, NephelometricTurbidityUnit, FormazinTurbidityUnit]);

(* Singleton Overload *)
ConvertCellConcentration[value:cellConcentrationUnitInputPattern, targetUnit:cellConcentrationUnitInputPattern, conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]] := First[ConvertCellConcentration[{value}, {targetUnit}, {conversionObject}]];

(* Listable overload  - CORE *)
ConvertCellConcentration[values:ListableP[cellConcentrationUnitInputPattern], targetUnits:ListableP[cellConcentrationUnitInputPattern], conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := Module[
  {
    longestInputLength,valueList,targetUnitList,conversionObjectList,standardCurveFields,fieldSpec,nestedStandardCurvePackets,standardCurvePackets,
    convertedValues,standardCurveFitFunctionNotFoundErrors,incompatibleStandardCurveErrors, noCompatibleStandardCurveInCellModelErrors,
    multipleCompatibleStandardCurvesWarnings,multipleCompatibleStandardCurvesObjects,actualStandardCurves,
    actualStartingUnits, actualTargetUnits
  },

  (* Get the length of the longest input *)
  longestInputLength = Max[Length[ToList[values]],Length[ToList[targetUnits]],Length[ToList[conversionObjects]]];

  (* Convert any singletons to lists of the longest length *)
  {valueList, targetUnitList, conversionObjectList} = (
    If[MatchQ[#,_List],
      #,
      ConstantArray[#,longestInputLength]
    ]
  )&/@{values, targetUnits, conversionObjects};

  (* Throw an error if the Lengths are mismatched *)
  If[!Equal@@{Length[valueList],Length[targetUnitList],Length[conversionObjectList]},
    Module[{},
      Message[Error::IndexMatchingLengthMismatch,valueList,targetUnitList,conversionObjectList];
      Return[$Failed]
    ]
  ];

  (* Define the fields to download from an Object[Analysis,StandardCurve] *)
  standardCurveFields = Sequence[StandardDataUnits,BestFitFunction,InversePrediction,StandardCurveFit,DateCreated];

  (* Create a field spec to download from the list of conversion objects *)
  fieldSpec = Map[
    Function[{conversionObject},
      (* If the conversion object is an Object[Analysis,Fit], download the fit fields *)
      If[MatchQ[conversionObject,ObjectP[Object[Analysis,StandardCurve]]],
        {Packet[standardCurveFields]},

        (* Otherwise, the conversion object is a Model[Cell] first Download StandardCurves, then the fit fields *)
        {Packet[StandardCurves[standardCurveFields]]}
      ]
    ],
    conversionObjectList
  ];

  (* Now that we know the Lengths are aligned we have to download the standard curves and relevant fields *)
  nestedStandardCurvePackets = Download[List/@conversionObjectList, fieldSpec];

  (* Flatten our download packets *)
  standardCurvePackets = Flatten[nestedStandardCurvePackets,2];

  (* Map over the data and make the conversions *)
  {
    convertedValues,
    standardCurveFitFunctionNotFoundErrors,
    incompatibleStandardCurveErrors,
    noCompatibleStandardCurveInCellModelErrors,
    multipleCompatibleStandardCurvesWarnings,
    multipleCompatibleStandardCurvesObjects,
    actualStandardCurves,
    actualStartingUnits,
    actualTargetUnits
  } = Transpose@MapThread[Function[{value, targetUnit, standardCurvePackets, conversionObject},
    Module[
      {
        standardCurveFitFunctionNotFoundError,incompatibleStandardCurveError,noCompatibleStandardCurveInCellModelError,
        multipleCompatibleStandardCurvesWarning, multipleCompatibleStandardCurves,valueUnits
      },

      (* Initialize error tracking variables *)
      standardCurveFitFunctionNotFoundError = False;
      incompatibleStandardCurveError = False;
      noCompatibleStandardCurveInCellModelError = False;
      multipleCompatibleStandardCurvesWarning = False;
      multipleCompatibleStandardCurves = {};

      (* Check if the units of value and targetUnit are compatible, if so we don't need to use a standard curve *)
      (* Get the units of value *)
      valueUnits = QuantityUnit[value];

      If[CompatibleUnitQ[valueUnits, targetUnit],
        (* If the units are compatible, return *)
        {
          Convert[value, targetUnit],
          standardCurveFitFunctionNotFoundError,
          incompatibleStandardCurveError,
          noCompatibleStandardCurveInCellModelError,
          multipleCompatibleStandardCurvesWarning,
          multipleCompatibleStandardCurves,
          Null,
          Null,
          Null
        },
        (* Otherwise, see if we have a standard curve that can convert *)
        Module[
          {
            validStandardCurvePackets,validStandardCurvePacket,useInversePredictionQ,
            standardXUnit,standardYUnit,fitObject,fitObjectNoLink,bestFitFunction,convertedValue
          },
          (* Initialize a variable used to detect if we are doing inverse prediction *)
          useInversePredictionQ = False;

          (* Determine if there is a standard curves that can convert between the desired units *)
          validStandardCurvePackets = Select[
            ToList[standardCurvePackets],

            (* A packet is valid, if the units match the desired units or the units are reversed but Inverse prediction is True *)
            Function[{standardCurvePacket},
              Module[{possibleUnits,possibleXUnit,possibleYUnit,inversePrediction,fitObject},
                (* Extract the standard data units - we need to compare these to our given and target units *)
                possibleUnits = Lookup[standardCurvePacket,StandardDataUnits,{1,1}];
                {possibleXUnit, possibleYUnit} = If[Length[possibleUnits] == 2,
                  possibleUnits,
                  {1,1}
                ];

                (* Also extract whether this standard curve can be used inversely *)
                {inversePrediction,fitObject} = Lookup[standardCurvePacket, {InversePrediction,StandardCurveFit}];

                (* This packet is valid if either, possibleXUnit matches the units of value and possibleYUnit matches targetUnit *)
                (* OR, inversePrediction == True and fit Object exists and possibleYUnit matches the units of value and possibleXUnit matches targetUnit *)
                Which[
                  And[CompatibleUnitQ[value,possibleXUnit],CompatibleUnitQ[targetUnit,possibleYUnit]],
                  True,
                  And[TrueQ[inversePrediction],MatchQ[fitObject,ObjectP[Object[Analysis,Fit]]],CompatibleUnitQ[targetUnit,possibleXUnit],CompatibleUnitQ[value,possibleYUnit]],
                  Module[{},
                    useInversePredictionQ = True;
                    True
                  ],
                  True,
                  False
                ]
              ]
            ]
          ];

          (* Check for multiple compatible standard curves *)
          If[Length[validStandardCurvePackets] > 1,
            Module[{},
              multipleCompatibleStandardCurvesWarning = True;
              multipleCompatibleStandardCurves = Lookup[validStandardCurvePackets,Object];
            ]
          ];

          (* If there are multiple valid standard curves, choose the one that was created most recently (or default to an empty assoc) *)
          validStandardCurvePacket = If[MatchQ[validStandardCurvePackets,{}],
            Association[],
            First[ReverseSortBy[validStandardCurvePackets,Lookup[#,DateCreated]&]]
          ];

          (* Was a standard curve found with matching units? *)
          Which[
            MatchQ[validStandardCurvePacket,Association[]] && MatchQ[conversionObject,ObjectP[Object[Analysis,StandardCurve]]],
            incompatibleStandardCurveError = True,
            MatchQ[validStandardCurvePacket,Association[]] && MatchQ[conversionObject,ObjectP[Model[Cell]]],
            noCompatibleStandardCurveInCellModelError = True
          ];

          (* Extract the units from the selected packet *)
          {standardXUnit,standardYUnit} = Lookup[validStandardCurvePacket,StandardDataUnits,{1,1}];

          (* Extract the fit object and best fit function - we will use the fit object to do the conversion if we are doing InversePrediction *)
          (* And will use the best fit function otherwise *)
          {bestFitFunction,fitObject} = Lookup[validStandardCurvePacket, {BestFitFunction,StandardCurveFit},Null];

          (* Remove the link from the fit object *)
          fitObjectNoLink = Download[fitObject,Object];

          (* Was a conversion function found and an error not already detected? *)
          If[
            And[
              Or[
                !MatchQ[bestFitFunction, QuantityFunctionP[]], And[useInversePredictionQ, !ObjectReferenceP[fitObjectNoLink]]
              ],
              !incompatibleStandardCurveError,
              !noCompatibleStandardCurveInCellModelError
            ],
            standardCurveFitFunctionNotFoundError = True
          ];

          (* Convert the value to the target unit if no errors were found *)
          convertedValue = Which[
            (* Return $Failed if an error was found *)
            Or[
              standardCurveFitFunctionNotFoundError,
              incompatibleStandardCurveError,
              noCompatibleStandardCurveInCellModelError
            ],
            $Failed,

            (* Use the best fit function if we are not doing inverse prediction *)
            !useInversePredictionQ,
            Convert[bestFitFunction[value],targetUnit],

            (* Otherwise, if we are doing inverse prediction use the fit object *)
            True,
            Mean[Convert[InversePrediction[fitObjectNoLink,value],targetUnit]]
          ];

          (* Return the value, error bools, and actual units *)
          {
            convertedValue,
            standardCurveFitFunctionNotFoundError,
            incompatibleStandardCurveError,
            noCompatibleStandardCurveInCellModelError,
            multipleCompatibleStandardCurvesWarning,
            multipleCompatibleStandardCurves,
            Lookup[validStandardCurvePacket,Object,Null],
            standardXUnit,
            standardYUnit
          }
        ]
      ]
    ]
  ],
    {valueList,targetUnitList,standardCurvePackets,conversionObjectList}
  ];

  (* ---------------- WARNING CHECKING ---------------- *)

  (* Were there multiple compatible standard curves found? *)
  If[!MatchQ[multipleCompatibleStandardCurvesWarnings,{False..}],
    Message[Warning::MultipleCompatibleStandardCurves,
      PickList[multipleCompatibleStandardCurvesObjects,multipleCompatibleStandardCurvesWarnings],
      PickList[conversionObjectList,multipleCompatibleStandardCurvesWarnings]
    ]
  ];

  (* ---------------- ERROR CHECKING ---------------- *)

  (* Was there a StandardCurveNotFound Error? *)
  If[!MatchQ[standardCurveFitFunctionNotFoundErrors,{False..}],
    Message[Error::StandardCurveFitFunctionNotFound, PickList[actualStandardCurves,standardCurveFitFunctionNotFoundErrors]]
  ];

  (* Was there a IncompatibleStandardCurve Error? *)
  If[!MatchQ[incompatibleStandardCurveErrors,{False..}],
    Message[
      Error::IncompatibleStandardCurve,
      PickList[conversionObjectList,incompatibleStandardCurveErrors],
      PickList[actualStartingUnits,incompatibleStandardCurveErrors],
      PickList[actualTargetUnits,incompatibleStandardCurveErrors],
      Units[PickList[valueList,incompatibleStandardCurveErrors]],
      Units[PickList[targetUnitList,incompatibleStandardCurveErrors]]
    ]
  ];

  (* Was there a NoCompatibleStandardCurveInCellModel Error? *)
  If[!MatchQ[noCompatibleStandardCurveInCellModelErrors,{False..}],
    Message[
      Error::NoCompatibleStandardCurveInCellModel,
      PickList[conversionObjectList,noCompatibleStandardCurveInCellModelErrors],
      Units[PickList[valueList,noCompatibleStandardCurveInCellModelErrors]],
      Units[PickList[targetUnitList,noCompatibleStandardCurveInCellModelErrors]]
    ]
  ];

  (* Return the values *)
  convertedValues
];

(* ::Subsection::Closed:: *)
(*ChildFunctions*)

(* ::Subsubsection::Closed:: *)
(*OD600ToCellPermL*)
(* Singleton Overload *)
OD600ToCellPermL[value:UnitsP[OD600],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[OD600ToCellPermL[{value},{conversionObject}]];

(* Listable Overload *)
OD600ToCellPermL[values:ListableP[UnitsP[OD600]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,Cell/Milliliter,conversionObjects];

(* ::Subsubsection::Closed:: *)
(*OD600ToCFUPermL*)
(* Singleton Overload *)
OD600ToCFUPermL[value:UnitsP[OD600],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[OD600ToCFUPermL[{value},{conversionObject}]];

(* Listable Overload *)
OD600ToCFUPermL[values:ListableP[UnitsP[OD600]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,CFU/Milliliter,conversionObjects];
(* ::Subsubsection::Closed:: *)
(*OD600ToRelativeNephelometricUnit*)
(* Singleton Overload *)
OD600ToRelativeNephelometricUnit[value:UnitsP[OD600],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[OD600ToRelativeNephelometricUnit[{value},{conversionObject}]];

(* Listable Overload *)
OD600ToRelativeNephelometricUnit[values:ListableP[UnitsP[OD600]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,RelativeNephelometricUnit,conversionObjects];
(* ::Subsubsection::Closed:: *)
(*OD600ToNephelometricTurbidityUnit*)
(* Singleton Overload *)
OD600ToNephelometricTurbidityUnit[value:UnitsP[OD600],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[OD600ToNephelometricTurbidityUnit[{value},{conversionObject}]];

(* Listable Overload *)
OD600ToNephelometricTurbidityUnit[values:ListableP[UnitsP[OD600]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,NephelometricTurbidityUnit,conversionObjects];
(* ::Subsubsection::Closed:: *)
(*OD600ToFormazinTurbidityUnit*)
(* Singleton Overload *)
OD600ToFormazinTurbidityUnit[value:UnitsP[OD600],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[OD600ToFormazinTurbidityUnit[{value},{conversionObject}]];

(* Listable Overload *)
OD600ToFormazinTurbidityUnit[values:ListableP[UnitsP[OD600]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,FormazinTurbidityUnit,conversionObjects];
(* ::Subsubsection::Closed:: *)
(*CellPermLToOD600*)
(* Singleton Overload *)
CellPermLToOD600[value:UnitsP[Cell/Milliliter],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[CellPermLToOD600[{value},{conversionObject}]];

(* Listable Overload *)
CellPermLToOD600[values:ListableP[UnitsP[Cell/Milliliter]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,OD600,conversionObjects];
(* ::Subsubsection::Closed:: *)
(*CellPermLToCFUPermL*)
(* Singleton Overload *)
CellPermLToCFUPermL[value:UnitsP[Cell/Milliliter],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[CellPermLToCFUPermL[{value},{conversionObject}]];

(* Listable Overload *)
CellPermLToCFUPermL[values:ListableP[UnitsP[Cell/Milliliter]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,CFU/Milliliter,conversionObjects];
(* ::Subsubsection::Closed:: *)
(*CellPermLToRelativeNephelometricUnit*)
(* Singleton Overload *)
CellPermLToRelativeNephelometricUnit[value:UnitsP[Cell/Milliliter],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[CellPermLToRelativeNephelometricUnit[{value},{conversionObject}]];

(* Listable Overload *)
CellPermLToRelativeNephelometricUnit[values:ListableP[UnitsP[Cell/Milliliter]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,RelativeNephelometricUnit,conversionObjects];
(* ::Subsubsection::Closed:: *)
(*CellPermLToNephelometricTurbidityUnit*)
(* Singleton Overload *)
CellPermLToNephelometricTurbidityUnit[value:UnitsP[Cell/Milliliter],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[CellPermLToNephelometricTurbidityUnit[{value},{conversionObject}]];

(* Listable Overload *)
CellPermLToNephelometricTurbidityUnit[values:ListableP[UnitsP[Cell/Milliliter]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,NephelometricTurbidityUnit,conversionObjects];
(* ::Subsubsection::Closed:: *)
(*CellPermLToFormazinTurbidityUnit*)
(* Singleton Overload *)
CellPermLToFormazinTurbidityUnit[value:UnitsP[Cell/Milliliter],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[CellPermLToFormazinTurbidityUnit[{value},{conversionObject}]];

(* Listable Overload *)
CellPermLToFormazinTurbidityUnit[values:ListableP[UnitsP[Cell/Milliliter]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,FormazinTurbidityUnit,conversionObjects];
(* ::Subsubsection::Closed:: *)
(*CFUPermLToOD600*)
(* Singleton Overload *)
CFUPermLToOD600[value:UnitsP[CFU/Milliliter],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[CFUPermLToOD600[{value},{conversionObject}]];

(* Listable Overload *)
CFUPermLToOD600[values:ListableP[UnitsP[CFU/Milliliter]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,OD600,conversionObjects];
(* ::Subsubsection::Closed:: *)
(*CFUPermLToCellPermL*)
(* Singleton Overload *)
CFUPermLToCellPermL[value:UnitsP[CFU/Milliliter],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[CFUPermLToCellPermL[{value},{conversionObject}]];

(* Listable Overload *)
CFUPermLToCellPermL[values:ListableP[UnitsP[CFU/Milliliter]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,Cell/Milliliter,conversionObjects];
(* ::Subsubsection::Closed:: *)
(*CFUPermLToRelativeNephelometricUnit*)
(* Singleton Overload *)
CFUPermLToRelativeNephelometricUnit[value:UnitsP[CFU/Milliliter],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[CFUPermLToRelativeNephelometricUnit[{value},{conversionObject}]];

(* Listable Overload *)
CFUPermLToRelativeNephelometricUnit[values:ListableP[UnitsP[CFU/Milliliter]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,RelativeNephelometricUnit,conversionObjects];
(* ::Subsubsection::Closed:: *)
(*CFUPermLToNephelometricTurbidityUnit*)
(* Singleton Overload *)
CFUPermLToNephelometricTurbidityUnit[value:UnitsP[CFU/Milliliter],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[CFUPermLToNephelometricTurbidityUnit[{value},{conversionObject}]];

(* Listable Overload *)
CFUPermLToNephelometricTurbidityUnit[values:ListableP[UnitsP[CFU/Milliliter]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,NephelometricTurbidityUnit,conversionObjects];
(* ::Subsubsection::Closed:: *)
(*CFUPermLToFormazinTurbidityUnit*)
(* Singleton Overload *)
CFUPermLToFormazinTurbidityUnit[value:UnitsP[CFU/Milliliter],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[CFUPermLToFormazinTurbidityUnit[{value},{conversionObject}]];

(* Listable Overload *)
CFUPermLToFormazinTurbidityUnit[values:ListableP[UnitsP[CFU/Milliliter]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,FormazinTurbidityUnit,conversionObjects];
(* ::Subsubsection::Closed:: *)
(*RelativeNephelometricUnitToOD600*)
(* Singleton Overload *)
RelativeNephelometricUnitToOD600[value:UnitsP[RelativeNephelometricUnit],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[RelativeNephelometricUnitToOD600[{value},{conversionObject}]];

(* Listable Overload *)
RelativeNephelometricUnitToOD600[values:ListableP[UnitsP[RelativeNephelometricUnit]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,OD600,conversionObjects];
(* ::Subsubsection::Closed:: *)
(*RelativeNephelometricUnitToCellPermL*)
(* Singleton Overload *)
RelativeNephelometricUnitToCellPermL[value:UnitsP[RelativeNephelometricUnit],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[RelativeNephelometricUnitToCellPermL[{value},{conversionObject}]];

(* Listable Overload *)
RelativeNephelometricUnitToCellPermL[values:ListableP[UnitsP[RelativeNephelometricUnit]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,Cell/Milliliter,conversionObjects];
(* ::Subsubsection::Closed:: *)
(*RelativeNephelometricUnitToCFUPermL*)
(* Singleton Overload *)
RelativeNephelometricUnitToCFUPermL[value:UnitsP[RelativeNephelometricUnit],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[RelativeNephelometricUnitToCFUPermL[{value},{conversionObject}]];

(* Listable Overload *)
RelativeNephelometricUnitToCFUPermL[values:ListableP[UnitsP[RelativeNephelometricUnit]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,CFU/Milliliter,conversionObjects];

(* ::Subsubsection::Closed:: *)
(*RelativeNephelometricUnitToNephelometricTurbidityUnit*)
(* Singleton Overload *)
RelativeNephelometricUnitToNephelometricTurbidityUnit[value:UnitsP[RelativeNephelometricUnit],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[RelativeNephelometricUnitToNephelometricTurbidityUnit[{value},{conversionObject}]];

(* Listable Overload *)
RelativeNephelometricUnitToNephelometricTurbidityUnit[values:ListableP[UnitsP[RelativeNephelometricUnit]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,NephelometricTurbidityUnit,conversionObjects];

(* ::Subsubsection::Closed:: *)
(*RelativeNephelometricUnitToFormazinTurbidityUnit*)
(* Singleton Overload *)
RelativeNephelometricUnitToFormazinTurbidityUnit[value:UnitsP[RelativeNephelometricUnit],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[RelativeNephelometricUnitToFormazinTurbidityUnit[{value},{conversionObject}]];

(* Listable Overload *)
RelativeNephelometricUnitToFormazinTurbidityUnit[values:ListableP[UnitsP[RelativeNephelometricUnit]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,FormazinTurbidityUnit,conversionObjects];

(* ::Subsubsection::Closed:: *)
(*NephelometricTurbidityUnitToOD600*)
(* Singleton Overload *)
NephelometricTurbidityUnitToOD600[value:UnitsP[NephelometricTurbidityUnit],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[NephelometricTurbidityUnitToOD600[{value},{conversionObject}]];

(* Listable Overload *)
NephelometricTurbidityUnitToOD600[values:ListableP[UnitsP[NephelometricTurbidityUnit]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,OD600,conversionObjects];
(* ::Subsubsection::Closed:: *)
(*NephelometricTurbidityUnitToCellPermL*)
(* Singleton Overload *)
NephelometricTurbidityUnitToCellPermL[value:UnitsP[NephelometricTurbidityUnit],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[NephelometricTurbidityUnitToCellPermL[{value},{conversionObject}]];

(* Listable Overload *)
NephelometricTurbidityUnitToCellPermL[values:ListableP[UnitsP[NephelometricTurbidityUnit]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,Cell/Milliliter,conversionObjects];
(* ::Subsubsection::Closed:: *)
(*NephelometricTurbidityUnitToCFUPermL*)
(* Singleton Overload *)
NephelometricTurbidityUnitToCFUPermL[value:UnitsP[NephelometricTurbidityUnit],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[NephelometricTurbidityUnitToCFUPermL[{value},{conversionObject}]];

(* Listable Overload *)
NephelometricTurbidityUnitToCFUPermL[values:ListableP[UnitsP[NephelometricTurbidityUnit]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,CFU/Milliliter,conversionObjects];
(* ::Subsubsection::Closed:: *)
(*NephelometricTurbidityUnitToRelativeNephelometricUnit*)
(* Singleton Overload *)
NephelometricTurbidityUnitToRelativeNephelometricUnit[value:UnitsP[NephelometricTurbidityUnit],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[NephelometricTurbidityUnitToRelativeNephelometricUnit[{value},{conversionObject}]];

(* Listable Overload *)
NephelometricTurbidityUnitToRelativeNephelometricUnit[values:ListableP[UnitsP[NephelometricTurbidityUnit]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,RelativeNephelometricUnit,conversionObjects];
(* ::Subsubsection::Closed:: *)
(*NephelometricTurbidityUnitToFormazinTurbidityUnit*)
(* Singleton Overload *)
NephelometricTurbidityUnitToFormazinTurbidityUnit[value:UnitsP[NephelometricTurbidityUnit],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[NephelometricTurbidityUnitToFormazinTurbidityUnit[{value},{conversionObject}]];

(* Listable Overload *)
NephelometricTurbidityUnitToFormazinTurbidityUnit[values:ListableP[UnitsP[NephelometricTurbidityUnit]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,FormazinTurbidityUnit,conversionObjects];

(* ::Subsubsection::Closed:: *)
(*FormazinTurbidityUnitToOD600*)
(* Singleton Overload *)
FormazinTurbidityUnitToOD600[value:UnitsP[FormazinTurbidityUnit],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[FormazinTurbidityUnitToOD600[{value},{conversionObject}]];

(* Listable Overload *)
FormazinTurbidityUnitToOD600[values:ListableP[UnitsP[FormazinTurbidityUnit]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,OD600,conversionObjects];
(* ::Subsubsection::Closed:: *)
(*FormazinTurbidityUnitToCellPermL*)
(* Singleton Overload *)
FormazinTurbidityUnitToCellPermL[value:UnitsP[FormazinTurbidityUnit],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[FormazinTurbidityUnitToCellPermL[{value},{conversionObject}]];

(* Listable Overload *)
FormazinTurbidityUnitToCellPermL[values:ListableP[UnitsP[FormazinTurbidityUnit]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,Cell/Milliliter,conversionObjects];
(* ::Subsubsection::Closed:: *)
(*FormazinTurbidityUnitToCFUPermL*)
(* Singleton Overload *)
FormazinTurbidityUnitToCFUPermL[value:UnitsP[FormazinTurbidityUnit],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[FormazinTurbidityUnitToCFUPermL[{value},{conversionObject}]];

(* Listable Overload *)
FormazinTurbidityUnitToCFUPermL[values:ListableP[UnitsP[FormazinTurbidityUnit]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,CFU/Milliliter,conversionObjects];
(* ::Subsubsection::Closed:: *)
(*FormazinTurbidityUnitToRelativeNephelometricUnit*)
(* Singleton Overload *)
FormazinTurbidityUnitToRelativeNephelometricUnit[value:UnitsP[FormazinTurbidityUnit],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[FormazinTurbidityUnitToRelativeNephelometricUnit[{value},{conversionObject}]];

(* Listable Overload *)
FormazinTurbidityUnitToRelativeNephelometricUnit[values:ListableP[UnitsP[FormazinTurbidityUnit]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,RelativeNephelometricUnit,conversionObjects];

(* ::Subsubsection::Closed:: *)
(*FormazinTurbidityUnitToNephelometricTurbidityUnit*)
(* Singleton Overload *)
FormazinTurbidityUnitToNephelometricTurbidityUnit[value:UnitsP[FormazinTurbidityUnit],conversionObject:ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]:=First[FormazinTurbidityUnitToNephelometricTurbidityUnit[{value},{conversionObject}]];

(* Listable Overload *)
FormazinTurbidityUnitToNephelometricTurbidityUnit[values:ListableP[UnitsP[FormazinTurbidityUnit]],conversionObjects:ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]]] := ConvertCellConcentration[values,NephelometricTurbidityUnit,conversionObjects];
