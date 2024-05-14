(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*BMGCompatiblePlates*)


DefineUsage[BMGCompatiblePlates,
  {
    BasicDefinitions->{
      {"BMGCompatiblePlates[experimentType]","compatiblePlates","memoizes and returns a list of plate Models compatible to BMG Labtech platereaders for the desired 'experimentType'."}
    },
    MoreInformation->{
    },
    Input:>{
      {"experimentType",(Absorbance|AlphaScreen|Fluorescence|Nephelometry),"The desired experiment type to perform on BMG Labtech platereaders."}
    },
    Output:>{
      {"compatiblePlates",{ObjectP[Model[Container,Plate]]..},"A list of compatible plate Models for the desired experiment type."}
    },
    SeeAlso->{
      "BMGCompatiblePlatesP"
    },
    Author->{"dirk.schild", "lei.tian"}
  }
];


(* ::Subsubsection::Closed:: *)
(*BMGCompatiblePlatesP*)


DefineUsage[BMGCompatiblePlatesP,
  {
    BasicDefinitions->{
      {"BMGCompatiblePlatesP[experimentType]","compatiblePlatePattern","converts the list of compatible plates into an Alternatives pattern."}
    },
    MoreInformation->{
    },
    Input:>{
      {"experimentType",(Absorbance|AlphaScreen|Fluorescence|Nephelometry),"The desired experiment type to perform on BMG Labtech platereaders."}
    },
    Output:>{
      {"compatiblePlatePattern",_Alternatives,"The Alternatives pattern of compatible plates for the desired experiment type."}
    },
    SeeAlso->{
      "BMGCompatiblePlates"
    },
    Author->{"dirk.schild", "lei.tian"}
  }
];


