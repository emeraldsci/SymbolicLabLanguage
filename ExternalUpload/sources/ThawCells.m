(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*UploadThawCells*)


(* ::Subsubsection:: *)
(*Options and Messages*)


DefineOptions[UploadThawCellsMethod,
  Options :> {
    IndexMatching[
      IndexMatchingInput -> "Input Data",
      {
        OptionName -> Name,
        Default -> Null,
        AllowNull -> True,
        Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line],
        Description -> "The name of the identity model.",
        Category -> "Organizational Information"
      },
      {
        OptionName -> Instrument,
        Default -> Null,
        AllowNull -> True,
        Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Instrument, CellThaw], Model[Instrument, HeatBlock]}]],
        Description -> "The instrument used to thaw the cells.",
        Category -> "Organizational Information"
      },
      {
        OptionName -> Temperature,
        Default -> Null,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[25 Celsius, 100 Celsius], Units :> Celsius],
        Description -> "The temperature used to thaw the cells. This option can only be set when using a heat block (the temperature is automatically adjusted based on phase change when using an automatic cell thawer).",
        Category -> "Organizational Information"
      }
    ]
  },
  SharedOptions :> {
    ExternalUploadHiddenOptions
  }
];

InstallDefaultUploadFunction[UploadThawCellsMethod, Object[Method, ThawCells]];
InstallValidQFunction[UploadThawCellsMethod, Object[Method, ThawCells]];
InstallOptionsFunction[UploadThawCellsMethod, Object[Method, ThawCells]];