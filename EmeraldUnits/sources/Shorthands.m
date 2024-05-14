(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

OnLoad[
  If[$VersionNumber>=12.2,
    (
      KilocaloriePerMole=Quantity[1, "ThermochemicalKilocalories" / "Moles"];
      CaloriePerMoleKelvin=Quantity[1, "ThermochemicalCalories" / ("Kelvins" * "Moles")];
    ),
    (
      KilocaloriePerMole=Quantity[1, "KilocaloriesThermochemical" / "Moles"];
      CaloriePerMoleKelvin=Quantity[1, "CaloriesThermochemical" / ("Kelvins" * "Moles")];
    )
  ]
];

PerSecond=Quantity[1, "Seconds"^(-1)];


MolarGasConstant=Quantity[1, "MolarGasConstant"];
AvogadroConstant=Quantity[UnitConvert[Quantity[1, "AvogadroNumber"]], 1 / "Moles"];


ByteUnit=Quantity[1, "Bytes"];
Deca=Deka; (* Deka is mathematica's prefix so that one must be used, but Deca is more common in US so redirect *)
