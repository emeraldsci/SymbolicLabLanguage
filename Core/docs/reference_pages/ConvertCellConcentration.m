(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

(* ::Subsection::Closed:: *)
(*ConvertCellConcentration*)
DefineUsage[ConvertCellConcentration,
  {
    BasicDefinitions -> {
      {"ConvertCellConcentration[value,targetUnit,conversionObject]", "convertedValue", "Converts the numeric 'value' to 'targetUnit' using the standard curve provided in 'conversionObject'."},
      {"ConvertCellConcentration[values,targetUnits,conversionObjects]", "convertedValues", "Converts the numeric 'values' to 'targetUnits' using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[CellConcentrationUnitsP], "A raw numeric value with CellConcentration units you wish to Convert between Units."},
      {"targetUnit", UnitsP[CellConcentrationUnitsP], "The desired Units for the output."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between the units of Value and targetUnit."},
      {"values", ListableP[UnitsP[CellConcentrationUnitsP]], "An array of raw numeric values with CellConcentration units you wish to Convert between Units."},
      {"targetUnits", ListableP[UnitsP[CellConcentrationUnitsP]], "An array of TargetUnits whose size should match 'values'."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[CellConcentrationUnitsP], "The final 'value' after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[CellConcentrationUnitsP]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "Convert",
      "UnitScale",
      "UnitsQ",
      "CompatibleUnitsQ"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];

(* ::Subsection::Closed:: *)
(*Child Functions*)

(* ::Subsubsection::Closed:: *)
(*OD600ToCellPermL*)
DefineUsage[OD600ToCellPermL,
  {
    BasicDefinitions -> {
      {"OD600ToCellPermL[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to Cell/Milliliter using the standard curve provided in 'conversionObject'."},
      {"OD600ToCellPermL[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to Cell/Milliliter using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[OD600], "A raw numeric value in OD600 you wish to Convert to Cell/Milliliter."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between the units of Value and Cell/Milliliter."},
      {"values", ListableP[UnitsP[OD600]], "An array of raw numeric values in OD600 you wish to Convert to Cell/Milliliter."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[Cell/Milliliter], "The final 'value' in Cell/Milliliter after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[Cell/Milliliter]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "CFUPermLToCellPermL",
      "RelativeNephelometricUnitsToCellPermL",
      "OD600ToCFUPermL"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];
(* ::Subsubsection::Closed:: *)
(*OD600ToCFUPermL*)
DefineUsage[OD600ToCFUPermL,
  {
    BasicDefinitions -> {
      {"OD600ToCFUPermL[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to CFU/Milliliter using the standard curve provided in 'conversionObject'."},
      {"OD600ToCFUPermL[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to CFU/Milliliter using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[OD600], "A raw numeric value in OD600 you wish to Convert to CFU/Milliliter."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between OD600 and CFU/Milliliter."},
      {"values", ListableP[UnitsP[OD600]], "An array of raw numeric values in OD600 you wish to Convert to CFU/Milliliter."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[CFU/Milliliter], "The final 'value' in CFU/Milliliter after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[CFU/Milliliter]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "CellPermLToCFUPermL",
      "RelativeNephelometricUnitsToCFUPermL",
      "OD600ToCellPermL"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];
(* ::Subsubsection::Closed:: *)
(*OD600ToRelativeNephelometricUnit*)
DefineUsage[OD600ToRelativeNephelometricUnit,
  {
    BasicDefinitions -> {
      {"OD600ToRelativeNephelometricUnit[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to RelativeNephelometricUnit using the standard curve provided in 'conversionObject'."},
      {"OD600ToRelativeNephelometricUnit[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to RelativeNephelometricUnit using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[OD600], "A raw numeric value in OD600 you wish to Convert to RelativeNephelometricUnit."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between OD600 and RelativeNephelometricUnit."},
      {"values", ListableP[UnitsP[OD600]], "An array of raw numeric values in OD600 you wish to Convert to RelativeNephelometricUnit."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[RelativeNephelometricUnit], "The final 'value' in RelativeNephelometricUnit after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[RelativeNephelometricUnit]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "CellPermLToRelativeNephelometricUnit",
      "RelativeNephelometricUnitsToRelativeNephelometricUnit",
      "OD600ToCellPermL"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];
(* ::Subsubsection::Closed:: *)
(*OD600ToNephelometricTurbidityUnit*)
DefineUsage[OD600ToNephelometricTurbidityUnit,
  {
    BasicDefinitions -> {
      {"OD600ToNephelometricTurbidityUnit[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to NephelometricTurbidityUnit using the standard curve provided in 'conversionObject'."},
      {"OD600ToNephelometricTurbidityUnit[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to NephelometricTurbidityUnit using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[OD600], "A raw numeric value in OD600 you wish to Convert to NephelometricTurbidityUnit."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between OD600 and NephelometricTurbidityUnit."},
      {"values", ListableP[UnitsP[OD600]], "An array of raw numeric values in OD600 you wish to Convert to NephelometricTurbidityUnit."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[NephelometricTurbidityUnit], "The final 'value' in NephelometricTurbidityUnit after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[NephelometricTurbidityUnit]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "CellPermLToNephelometricTurbidityUnit",
      "RelativeNephelometricUnitToNephelometricTurbidityUnit",
      "OD600ToCellPermL"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];
(* ::Subsubsection::Closed:: *)
(*OD600ToFormazinTurbidityUnit*)
DefineUsage[OD600ToFormazinTurbidityUnit,
  {
    BasicDefinitions -> {
      {"OD600ToFormazinTurbidityUnit[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to FormazinTurbidityUnit using the standard curve provided in 'conversionObject'."},
      {"OD600ToFormazinTurbidityUnit[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to FormazinTurbidityUnit using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[OD600], "A raw numeric value in OD600 you wish to Convert to FormazinTurbidityUnit."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between OD600 and FormazinTurbidityUnit."},
      {"values", ListableP[UnitsP[OD600]], "An array of raw numeric values in OD600 you wish to Convert to FormazinTurbidityUnit."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[FormazinTurbidityUnit], "The final 'value' in FormazinTurbidityUnit after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[FormazinTurbidityUnit]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "CellPermLToFormazinTurbidityUnit",
      "RelativeNephelometricUnitToFormazinTurbidityUnit",
      "OD600ToCellPermL"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];
(* ::Subsubsection::Closed:: *)
(*CellPermLToOD600*)
DefineUsage[CellPermLToOD600,
  {
    BasicDefinitions -> {
      {"CellPermLToOD600[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to OD600 using the standard curve provided in 'conversionObject'."},
      {"CellPermLToOD600[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to OD600 using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[Cell/Milliliter], "A raw numeric value in Cell/Milliliter you wish to Convert to OD600."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between Cell/Milliliter and OD600."},
      {"values", ListableP[UnitsP[Cell/Milliliter]], "An array of raw numeric values in Cell/Milliliter you wish to Convert to OD600."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[OD600], "The final 'value' in OD600 after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[OD600]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "CellPermLToFormazinTurbidityUnit",
      "OD600ToCellPermL",
      "RelativeNephelometricUnitToFormazinTurbidityUnit"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];
(* ::Subsubsection::Closed:: *)
(*CellPermLToCFUPermL*)
DefineUsage[CellPermLToCFUPermL,
  {
    BasicDefinitions -> {
      {"CellPermLToCFUPermL[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to CFU/Milliliter using the standard curve provided in 'conversionObject'."},
      {"CellPermLToCFUPermL[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to CFU/Milliliter using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[Cell/Milliliter], "A raw numeric value in Cell/Milliliter you wish to Convert to CFU/Milliliter."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between Cell/Milliliter and CFU/Milliliter."},
      {"values", ListableP[UnitsP[Cell/Milliliter]], "An array of raw numeric values in Cell/Milliliter you wish to Convert to CFU/Milliliter."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[CFU/Milliliter], "The final 'value' in CFU/Milliliter after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[CFU/Milliliter]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "CellPermLToOD600",
      "OD600ToCFUPermL",
      "RelativeNephelometricUnitToFormazinTurbidityUnit"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];
(* ::Subsubsection::Closed:: *)
(*CellPermLToRelativeNephelometricUnit*)
DefineUsage[CellPermLToRelativeNephelometricUnit,
  {
    BasicDefinitions -> {
      {"CellPermLToRelativeNephelometricUnit[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to RelativeNephelometricUnit using the standard curve provided in 'conversionObject'."},
      {"CellPermLToRelativeNephelometricUnit[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to RelativeNephelometricUnit using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[Cell/Milliliter], "A raw numeric value in Cell/Milliliter you wish to Convert to RelativeNephelometricUnit."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between Cell/Milliliter and RelativeNephelometricUnit."},
      {"values", ListableP[UnitsP[Cell/Milliliter]], "An array of raw numeric values in Cell/Milliliter you wish to Convert to RelativeNephelometricUnit."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[RelativeNephelometricUnit], "The final 'value' in RelativeNephelometricUnit after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[RelativeNephelometricUnit]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "CellPermLToFormazinTurbidityUnit",
      "RelativeNephelometricUnitToCellPermL",
      "RelativeNephelometricUnitToFormazinTurbidityUnit"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];
(* ::Subsubsection::Closed:: *)
(*CellPermLToNephelometricTurbidityUnit*)
DefineUsage[CellPermLToNephelometricTurbidityUnit,
  {
    BasicDefinitions -> {
      {"CellPermLToNephelometricTurbidityUnit[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to NephelometricTurbidityUnit using the standard curve provided in 'conversionObject'."},
      {"CellPermLToNephelometricTurbidityUnit[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to NephelometricTurbidityUnit using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[Cell/Milliliter], "A raw numeric value in Cell/Milliliter you wish to Convert to NephelometricTurbidityUnit."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between Cell/Milliliter and NephelometricTurbidityUnit."},
      {"values", ListableP[UnitsP[Cell/Milliliter]], "An array of raw numeric values in Cell/Milliliter you wish to Convert to NephelometricTurbidityUnit."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[NephelometricTurbidityUnit], "The final 'value' in NephelometricTurbidityUnit after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[NephelometricTurbidityUnit]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "CellPermLToFormazinTurbidityUnit",
      "NephelometricTurbidityUnitToCellPermL",
      "NephelometricTurbidityUnitToFormazinTurbidityUnit"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];
(* ::Subsubsection::Closed:: *)
(*CellPermLToFormazinTurbidityUnit*)
DefineUsage[CellPermLToFormazinTurbidityUnit,
  {
    BasicDefinitions -> {
      {"CellPermLToFormazinTurbidityUnit[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to FormazinTurbidityUnit using the standard curve provided in 'conversionObject'."},
      {"CellPermLToFormazinTurbidityUnit[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to FormazinTurbidityUnit using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[Cell/Milliliter], "A raw numeric value in Cell/Milliliter you wish to Convert to FormazinTurbidityUnit."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between Cell/Milliliter and FormazinTurbidityUnit."},
      {"values", ListableP[UnitsP[Cell/Milliliter]], "An array of raw numeric values in Cell/Milliliter you wish to Convert to FormazinTurbidityUnit."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[FormazinTurbidityUnit], "The final 'value' in FormazinTurbidityUnit after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[FormazinTurbidityUnit]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "CellPermLToFormazinTurbidityUnit",
      "FormazinTurbidityUnitToCellPermL",
      "FormazinTurbidityUnitToCFUPermL"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];
(* ::Subsubsection::Closed:: *)
(*CFUPermLToOD600*)
DefineUsage[CFUPermLToOD600,
  {
    BasicDefinitions -> {
      {"CFUPermLToOD600[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to OD600 using the standard curve provided in 'conversionObject'."},
      {"CFUPermLToOD600[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to OD600 using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[CFU/Milliliter], "A raw numeric value in CFU/Milliliter you wish to Convert to OD600."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between CFU/Milliliter and OD600."},
      {"values", ListableP[UnitsP[CFU/Milliliter]], "An array of raw numeric values in CFU/Milliliter you wish to Convert to OD600."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[OD600], "The final 'value' in OD600 after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[OD600]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "CellPermLToOD600",
      "OD600ToCellPermL",
      "OD600ToCFUPermL"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];
(* ::Subsubsection::Closed:: *)
(*CFUPermLToCellPermL*)
DefineUsage[CFUPermLToCellPermL,
  {
    BasicDefinitions -> {
      {"CFUPermLToCellPermL[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to Cell/Milliliter using the standard curve provided in 'conversionObject'."},
      {"CFUPermLToCellPermL[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to Cell/Milliliter using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[CFU/Milliliter], "A raw numeric value in CFU/Milliliter you wish to Convert to Cell/Milliliter."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between CFU/Milliliter and Cell/Milliliter."},
      {"values", ListableP[UnitsP[CFU/Milliliter]], "An array of raw numeric values in CFU/Milliliter you wish to Convert to Cell/Milliliter."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[Cell/Milliliter], "The final 'value' in Cell/Milliliter after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[Cell/Milliliter]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "CellPermLToOD600",
      "OD600ToCellPermL",
      "CellPermLToCFUPermL"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];
(* ::Subsubsection::Closed:: *)
(*CFUPermLToRelativeNephelometricUnit*)
DefineUsage[CFUPermLToRelativeNephelometricUnit,
  {
    BasicDefinitions -> {
      {"CFUPermLToRelativeNephelometricUnit[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to RelativeNephelometricUnit using the standard curve provided in 'conversionObject'."},
      {"CFUPermLToRelativeNephelometricUnit[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to RelativeNephelometricUnit using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[CFU/Milliliter], "A raw numeric value in CFU/Milliliter you wish to Convert to RelativeNephelometricUnit."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between CFU/Milliliter and RelativeNephelometricUnit."},
      {"values", ListableP[UnitsP[CFU/Milliliter]], "An array of raw numeric values in CFU/Milliliter you wish to Convert to RelativeNephelometricUnit."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[RelativeNephelometricUnit], "The final 'value' in RelativeNephelometricUnit after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[RelativeNephelometricUnit]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "RelativeNephelometricUnitToOD600",
      "OD600ToRelativeNephelometricUnit",
      "RelativeNephelometricUnitToCFUPermL"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];
(* ::Subsubsection::Closed:: *)
(*CFUPermLToNephelometricTurbidityUnit*)
DefineUsage[CFUPermLToNephelometricTurbidityUnit,
  {
    BasicDefinitions -> {
      {"CFUPermLToNephelometricTurbidityUnit[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to NephelometricTurbidityUnit using the standard curve provided in 'conversionObject'."},
      {"CFUPermLToNephelometricTurbidityUnit[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to NephelometricTurbidityUnit using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[CFU/Milliliter], "A raw numeric value in CFU/Milliliter you wish to Convert to NephelometricTurbidityUnit."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between CFU/Milliliter and NephelometricTurbidityUnit."},
      {"values", ListableP[UnitsP[CFU/Milliliter]], "An array of raw numeric values in CFU/Milliliter you wish to Convert to NephelometricTurbidityUnit."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[NephelometricTurbidityUnit], "The final 'value' in NephelometricTurbidityUnit after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[NephelometricTurbidityUnit]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "NephelometricTurbidityUnitToOD600",
      "OD600ToNephelometricTurbidityUnit",
      "NephelometricTurbidityUnitToCFUPermL"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];
(* ::Subsubsection::Closed:: *)
(*CFUPermLToFormazinTurbidityUnit*)
DefineUsage[CFUPermLToFormazinTurbidityUnit,
  {
    BasicDefinitions -> {
      {"CFUPermLToFormazinTurbidityUnit[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to FormazinTurbidityUnit using the standard curve provided in 'conversionObject'."},
      {"CFUPermLToFormazinTurbidityUnit[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to FormazinTurbidityUnit using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[CFU/Milliliter], "A raw numeric value in CFU/Milliliter you wish to Convert to FormazinTurbidityUnit."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between CFU/Milliliter and FormazinTurbidityUnit."},
      {"values", ListableP[UnitsP[CFU/Milliliter]], "An array of raw numeric values in CFU/Milliliter you wish to Convert to FormazinTurbidityUnit."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[FormazinTurbidityUnit], "The final 'value' in FormazinTurbidityUnit after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[FormazinTurbidityUnit]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "FormazinTurbidityUnitToOD600",
      "OD600ToFormazinTurbidityUnit",
      "FormazinTurbidityUnitToCFUPermL"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];
(* ::Subsubsection::Closed:: *)
(*RelativeNephelometricUnitToOD600*)
DefineUsage[RelativeNephelometricUnitToOD600,
  {
    BasicDefinitions -> {
      {"RelativeNephelometricUnitToOD600[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to OD600 using the standard curve provided in 'conversionObject'."},
      {"RelativeNephelometricUnitToOD600[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to OD600 using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[RelativeNephelometricUnit], "A raw numeric value in RelativeNephelometricUnit you wish to Convert to OD600."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between RelativeNephelometricUnit and OD600."},
      {"values", ListableP[UnitsP[RelativeNephelometricUnit]], "An array of raw numeric values in RelativeNephelometricUnit you wish to Convert to OD600."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[OD600], "The final 'value' in OD600 after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[OD600]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "FormazinTurbidityUnitToOD600",
      "OD600ToFormazinTurbidityUnit",
      "OD600ToRelativeNephelometricUnit"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];
(* ::Subsubsection::Closed:: *)
(*RelativeNephelometricUnitToCellPermL*)
DefineUsage[RelativeNephelometricUnitToCellPermL,
  {
    BasicDefinitions -> {
      {"RelativeNephelometricUnitToCellPermL[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to Cell/Milliliter using the standard curve provided in 'conversionObject'."},
      {"RelativeNephelometricUnitToCellPermL[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to Cell/Milliliter using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[RelativeNephelometricUnit], "A raw numeric value in RelativeNephelometricUnit you wish to Convert to Cell/Milliliter."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between RelativeNephelometricUnit and Cell/Milliliter."},
      {"values", ListableP[UnitsP[RelativeNephelometricUnit]], "An array of raw numeric values in RelativeNephelometricUnit you wish to Convert to Cell/Milliliter."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[Cell/Milliliter], "The final 'value' in Cell/Milliliter after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[Cell/Milliliter]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "FormazinTurbidityUnitToCellPermL",
      "CellPermLToFormazinTurbidityUnit",
      "CellPermLToRelativeNephelometricUnit"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];
(* ::Subsubsection::Closed:: *)
(*RelativeNephelometricUnitToCFUPermL*)
DefineUsage[RelativeNephelometricUnitToCFUPermL,
  {
    BasicDefinitions -> {
      {"RelativeNephelometricUnitToCFUPermL[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to CFU/Milliliter using the standard curve provided in 'conversionObject'."},
      {"RelativeNephelometricUnitToCFUPermL[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to CFU/Milliliter using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[RelativeNephelometricUnit], "A raw numeric value in RelativeNephelometricUnit you wish to Convert to CFU/Milliliter."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between RelativeNephelometricUnit and CFU/Milliliter."},
      {"values", ListableP[UnitsP[RelativeNephelometricUnit]], "An array of raw numeric values in RelativeNephelometricUnit you wish to Convert to CFU/Milliliter."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[CFU/Milliliter], "The final 'value' in CFU/Milliliter after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[CFU/Milliliter]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "FormazinTurbidityUnitToCFUPermL",
      "CFUPermLToFormazinTurbidityUnit",
      "CFUPermLToRelativeNephelometricUnit"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];
(* ::Subsubsection::Closed:: *)
(*RelativeNephelometricUnitToNephelometricTurbidityUnit*)
DefineUsage[RelativeNephelometricUnitToNephelometricTurbidityUnit,
  {
    BasicDefinitions -> {
      {"RelativeNephelometricUnitToNephelometricTurbidityUnit[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to NephelometricTurbidityUnit using the standard curve provided in 'conversionObject'."},
      {"RelativeNephelometricUnitToNephelometricTurbidityUnit[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to NephelometricTurbidityUnit using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[RelativeNephelometricUnit], "A raw numeric value in RelativeNephelometricUnit you wish to Convert to NephelometricTurbidityUnit."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between RelativeNephelometricUnit and NephelometricTurbidityUnit."},
      {"values", ListableP[UnitsP[RelativeNephelometricUnit]], "An array of raw numeric values in RelativeNephelometricUnit you wish to Convert to NephelometricTurbidityUnit."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[NephelometricTurbidityUnit], "The final 'value' in NephelometricTurbidityUnit after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[NephelometricTurbidityUnit]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "FormazinTurbidityUnitToNephelometricTurbidityUnit",
      "NephelometricTurbidityUnitToFormazinTurbidityUnit",
      "NephelometricTurbidityUnitToRelativeNephelometricUnit"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];
(* ::Subsubsection::Closed:: *)
(*RelativeNephelometricUnitToFormazinTurbidityUnit*)
DefineUsage[RelativeNephelometricUnitToFormazinTurbidityUnit,
  {
    BasicDefinitions -> {
      {"RelativeNephelometricUnitToFormazinTurbidityUnit[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to FormazinTurbidityUnit using the standard curve provided in 'conversionObject'."},
      {"RelativeNephelometricUnitToFormazinTurbidityUnit[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to FormazinTurbidityUnit using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[RelativeNephelometricUnit], "A raw numeric value in RelativeNephelometricUnit you wish to Convert to FormazinTurbidityUnit."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between RelativeNephelometricUnit and FormazinTurbidityUnit."},
      {"values", ListableP[UnitsP[RelativeNephelometricUnit]], "An array of raw numeric values in RelativeNephelometricUnit you wish to Convert to FormazinTurbidityUnit."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[FormazinTurbidityUnit], "The final 'value' in FormazinTurbidityUnit after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[FormazinTurbidityUnit]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "FormazinTurbidityUnitToRelativeNephelometricUnit",
      "CellPermLToFormazinTurbidityUnit"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];
(* ::Subsubsection::Closed:: *)
(*NephelometricTurbidityUnitToOD600*)
DefineUsage[NephelometricTurbidityUnitToOD600,
  {
    BasicDefinitions -> {
      {"NephelometricTurbidityUnitToOD600[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to OD600 using the standard curve provided in 'conversionObject'."},
      {"NephelometricTurbidityUnitToOD600[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to OD600 using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[NephelometricTurbidityUnit], "A raw numeric value in NephelometricTurbidityUnit you wish to Convert to OD600."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between NephelometricTurbidityUnit and OD600."},
      {"values", ListableP[UnitsP[NephelometricTurbidityUnit]], "An array of raw numeric values in NephelometricTurbidityUnit you wish to Convert to OD600."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[OD600], "The final 'value' in OD600 after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[OD600]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "OD600ToNephelometricTurbidityUnit",
      "CellPermLToOD600"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];
(* ::Subsubsection::Closed:: *)
(*NephelometricTurbidityUnitToCellPermL*)
DefineUsage[NephelometricTurbidityUnitToCellPermL,
  {
    BasicDefinitions -> {
      {"NephelometricTurbidityUnitToCellPermL[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to Cell/Milliliter using the standard curve provided in 'conversionObject'."},
      {"NephelometricTurbidityUnitToCellPermL[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to Cell/Milliliter using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[NephelometricTurbidityUnit], "A raw numeric value in NephelometricTurbidityUnit you wish to Convert to Cell/Milliliter."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between NephelometricTurbidityUnit and Cell/Milliliter."},
      {"values", ListableP[UnitsP[NephelometricTurbidityUnit]], "An array of raw numeric values in NephelometricTurbidityUnit you wish to Convert to Cell/Milliliter."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[Cell/Milliliter], "The final 'value' in Cell/Milliliter after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[Cell/Milliliter]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "CellPermLToNephelometricTurbidityUnit"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];
(* ::Subsubsection::Closed:: *)
(*NephelometricTurbidityUnitToCFUPermL*)
DefineUsage[NephelometricTurbidityUnitToCFUPermL,
  {
    BasicDefinitions -> {
      {"NephelometricTurbidityUnitToCFUPermL[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to CFU/Milliliter using the standard curve provided in 'conversionObject'."},
      {"NephelometricTurbidityUnitToCFUPermL[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to CFU/Milliliter using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[NephelometricTurbidityUnit], "A raw numeric value in NephelometricTurbidityUnit you wish to Convert to CFU/Milliliter."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between NephelometricTurbidityUnit and CFU/Milliliter."},
      {"values", ListableP[UnitsP[NephelometricTurbidityUnit]], "An array of raw numeric values in NephelometricTurbidityUnit you wish to Convert to CFU/Milliliter."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[CFU/Milliliter], "The final 'value' in CFU/Milliliter after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[CFU/Milliliter]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "CFUPermLToNephelometricTurbidityUnit"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];
(* ::Subsubsection::Closed:: *)
(*NephelometricTurbidityUnitToRelativeNephelometricUnit*)
DefineUsage[NephelometricTurbidityUnitToRelativeNephelometricUnit,
  {
    BasicDefinitions -> {
      {"NephelometricTurbidityUnitToRelativeNephelometricUnit[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to RelativeNephelometricUnit using the standard curve provided in 'conversionObject'."},
      {"NephelometricTurbidityUnitToRelativeNephelometricUnit[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to RelativeNephelometricUnit using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[NephelometricTurbidityUnit], "A raw numeric value in NephelometricTurbidityUnit you wish to Convert to RelativeNephelometricUnit."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between NephelometricTurbidityUnit and RelativeNephelometricUnit."},
      {"values", ListableP[UnitsP[NephelometricTurbidityUnit]], "An array of raw numeric values in NephelometricTurbidityUnit you wish to Convert to RelativeNephelometricUnit."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[RelativeNephelometricUnit], "The final 'value' in RelativeNephelometricUnit after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[RelativeNephelometricUnit]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "RelativeNephelometricUnitToNephelometricTurbidityUnit"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];
(* ::Subsubsection::Closed:: *)
(*NephelometricTurbidityUnitToFormazinTurbidityUnit*)
DefineUsage[NephelometricTurbidityUnitToFormazinTurbidityUnit,
  {
    BasicDefinitions -> {
      {"NephelometricTurbidityUnitToFormazinTurbidityUnit[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to FormazinTurbidityUnit using the standard curve provided in 'conversionObject'."},
      {"NephelometricTurbidityUnitToFormazinTurbidityUnit[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to FormazinTurbidityUnit using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[NephelometricTurbidityUnit], "A raw numeric value in NephelometricTurbidityUnit you wish to Convert to FormazinTurbidityUnit."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between NephelometricTurbidityUnit and FormazinTurbidityUnit."},
      {"values", ListableP[UnitsP[NephelometricTurbidityUnit]], "An array of raw numeric values in NephelometricTurbidityUnit you wish to Convert to FormazinTurbidityUnit."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[FormazinTurbidityUnit], "The final 'value' in FormazinTurbidityUnit after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[FormazinTurbidityUnit]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "FormazinTurbidityUnitToNephelometricTurbidityUnit"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];
(* ::Subsubsection::Closed:: *)
(*FormazinTurbidityUnitToOD600*)
DefineUsage[FormazinTurbidityUnitToOD600,
  {
    BasicDefinitions -> {
      {"FormazinTurbidityUnitToOD600[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to OD600 using the standard curve provided in 'conversionObject'."},
      {"FormazinTurbidityUnitToOD600[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to OD600 using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[FormazinTurbidityUnit], "A raw numeric value in FormazinTurbidityUnit you wish to Convert to OD600."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between FormazinTurbidityUnit and OD600."},
      {"values", ListableP[UnitsP[FormazinTurbidityUnit]], "An array of raw numeric values in FormazinTurbidityUnit you wish to Convert to OD600."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[OD600], "The final 'value' in OD600 after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[OD600]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "OD600ToFormazinTurbidityUnit",
      "CellPermLToOD600"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];
(* ::Subsubsection::Closed:: *)
(*FormazinTurbidityUnitToCellPermL*)
DefineUsage[FormazinTurbidityUnitToCellPermL,
  {
    BasicDefinitions -> {
      {"FormazinTurbidityUnitToCellPermL[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to Cell/Milliliter using the standard curve provided in 'conversionObject'."},
      {"FormazinTurbidityUnitToCellPermL[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to Cell/Milliliter using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[FormazinTurbidityUnit], "A raw numeric value in FormazinTurbidityUnit you wish to Convert to Cell/Milliliter."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between FormazinTurbidityUnit and Cell/Milliliter."},
      {"values", ListableP[UnitsP[FormazinTurbidityUnit]], "An array of raw numeric values in FormazinTurbidityUnit you wish to Convert to Cell/Milliliter."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[Cell/Milliliter], "The final 'value' in Cell/Milliliter after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[Cell/Milliliter]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "CellPermLToFormazinTurbidityUnit"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];
(* ::Subsubsection::Closed:: *)
(*FormazinTurbidityUnitToCFUPermL*)
DefineUsage[FormazinTurbidityUnitToCFUPermL,
  {
    BasicDefinitions -> {
      {"FormazinTurbidityUnitToCFUPermL[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to CFU/Milliliter using the standard curve provided in 'conversionObject'."},
      {"FormazinTurbidityUnitToCFUPermL[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to CFU/Milliliter using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[FormazinTurbidityUnit], "A raw numeric value in FormazinTurbidityUnit you wish to Convert to CFU/Milliliter."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between FormazinTurbidityUnit and CFU/Milliliter."},
      {"values", ListableP[UnitsP[FormazinTurbidityUnit]], "An array of raw numeric values in FormazinTurbidityUnit you wish to Convert to CFU/Milliliter."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[CFU/Milliliter], "The final 'value' in CFU/Milliliter after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[CFU/Milliliter]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "CFUPermLToFormazinTurbidityUnit"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];
(* ::Subsubsection::Closed:: *)
(*FormazinTurbidityUnitToRelativeNephelometricUnit*)
DefineUsage[FormazinTurbidityUnitToRelativeNephelometricUnit,
  {
    BasicDefinitions -> {
      {"FormazinTurbidityUnitToRelativeNephelometricUnit[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to RelativeNephelometricUnit using the standard curve provided in 'conversionObject'."},
      {"FormazinTurbidityUnitToRelativeNephelometricUnit[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to RelativeNephelometricUnit using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[FormazinTurbidityUnit], "A raw numeric value in FormazinTurbidityUnit you wish to Convert to RelativeNephelometricUnit."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between FormazinTurbidityUnit and RelativeNephelometricUnit."},
      {"values", ListableP[UnitsP[FormazinTurbidityUnit]], "An array of raw numeric values in FormazinTurbidityUnit you wish to Convert to RelativeNephelometricUnit."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[RelativeNephelometricUnit], "The final 'value' in RelativeNephelometricUnit after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[RelativeNephelometricUnit]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "RelativeNephelometricUnitToFormazinTurbidityUnit"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];
(* ::Subsubsection::Closed:: *)
(*FormazinTurbidityUnitToNephelometricTurbidityUnit*)
DefineUsage[FormazinTurbidityUnitToNephelometricTurbidityUnit,
  {
    BasicDefinitions -> {
      {"FormazinTurbidityUnitToNephelometricTurbidityUnit[value,conversionObject]", "convertedValue", "Converts the numeric 'value' to NephelometricTurbidityUnit using the standard curve provided in 'conversionObject'."},
      {"FormazinTurbidityUnitToNephelometricTurbidityUnit[values,conversionObjects]", "convertedValues", "Converts the numeric 'values' to NephelometricTurbidityUnit using the standard curve provided in 'conversionObjects'."}
    },
    MoreInformation -> {
      "Able to convert multiple values at the same time."
    },
    Input :> {
      {"value", UnitsP[FormazinTurbidityUnit], "A raw numeric value in FormazinTurbidityUnit you wish to Convert to NephelometricTurbidityUnit."},
      {"conversionObject", ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}], "An Object containing the StandardCurve used to Convert between FormazinTurbidityUnit and NephelometricTurbidityUnit."},
      {"values", ListableP[UnitsP[FormazinTurbidityUnit]], "An array of raw numeric values in FormazinTurbidityUnit you wish to Convert to NephelometricTurbidityUnit."},
      {"conversionObjects", ListableP[ObjectP[{Object[Analysis,StandardCurve],Model[Cell]}]], "An array of 'conversionObjects' whose size should match 'values'."}
    },
    Output :> {
      {"convertedValue", UnitsP[NephelometricTurbidityUnit], "The final 'value' in NephelometricTurbidityUnit after the unit conversion."},
      {"convertedValues", ListableP[UnitsP[NephelometricTurbidityUnit]], "Converted version of 'values'."}
    },
    SeeAlso -> {
      "ConvertCellConcentration",
      "NephelometricTurbidityUnitToFormazinTurbidityUnit"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }];