(* ::Text::*)

(*© 2011-2022 Emerald Cloud Lab,Inc.*)

DefineObjectType[
      Model[Container, PhaseSeparator], {
      Description -> "Model information for a Biotage Phase Separator cartridge, which is used in liquid-liquid extractions.",
      CreatePrivileges -> None,
      Cache -> Session,
      Fields -> {
            CasingMaterial -> {
                  Format -> Single,
                  Class -> Expression,
                  Pattern :> PlasticP,
                  Description -> "The material that composes the exterior of the cartridge which houses the frit.",
                  Category -> "Physical Properties"
            },
            FritThickness -> {
                  Format -> Single,
                  Class -> Real,
                  Pattern :> GreaterP[0*Millimeter],
                  Units -> Millimeter,
                  Description -> "The thickness of the frit through which the organic phase must travel before exiting the cartridge.",
                  Category -> "Physical Properties"
            },
            CartridgeWorkingVolume -> {
                  Format -> Single,
                  Class -> Real,
                  Pattern :> GreaterP[0*Milliliter],
                  Units -> Milliliter,
                  Description -> "The volume of extraction for which this cartridge is specified by the manufacturer.",
                  Category -> "Dimensions & Positions"
            },
            Diameter -> {
                  Format -> Single,
                  Class -> Real,
                  Pattern :> GreaterP[0*Millimeter],
                  Units -> Millimeter,
                  Description -> "The internal diameter of the cartridge body, where the sample resides.",
                  Category -> "Dimensions & Positions"
            },
            ExternalDiameter -> {
                  Format -> Single,
                  Class -> Real,
                  Pattern :> GreaterP[0*Millimeter],
                  Units -> Millimeter,
                  Description -> "The external diameter of the cartridge body, where the sample resides.",
                  Category -> "Dimensions & Positions"
            },
            CartridgeLength -> {
                  Format -> Single,
                  Class -> Real,
                  Pattern :> GreaterP[0*Millimeter],
                  Units -> Millimeter,
                  Description -> "The total length of the cartridge body, excluding the connector at the bottom.",
                  Category -> "Dimensions & Positions"
            },
            ConnectorLength -> {
                  Format -> Single,
                  Class -> Real,
                  Pattern :> GreaterP[0*Millimeter],
                  Units -> Millimeter,
                  Description -> "The distance from the bottom of the cartridge body to the bottom of the connector.",
                  Category -> "Dimensions & Positions"
            },
            Tabbed -> {(*Description needs to be updated if we axe the pressure manifold from this experiment.*)
                  Format -> Single,
                  Class -> Expression,
                  Pattern :> BooleanP,
                  Description -> "Indicates whether there are tabs (which look like a collar) protruding perpendicularly from the top (opening) rim of the cartridge. Cartridges lacking this feature are called TABLESS by Biotage (the manufacturer); such TABLESS cartridges are compatible with the Biotage PRESSURE+ pressure manifold, which is accessed with the Option PhaseSeparatorMethod in ExperimentLiquidLiquidExtraction.",
                  Category -> "Container Specifications"
            },
            TabWidth -> {
                  Format -> Single,
                  Class -> Real,
                  Pattern :> GreaterEqualP[0 Millimeter],
                  Units -> Millimeter,
                  Description -> "The distance from the wall of the cartridge to the exterior edge of the tab protruding from the cartridge rim.",
                  Category -> "Container Specifications"
            },
            MinpH -> {
                  Format -> Single,
                  Class -> Real,
                  Pattern :> RangeP[0, 14],
                  Units -> None,
                  Description -> "The minimum pH to which the cartridge/frit can be exposed without becoming damaged.",
                  Category -> "Compatibility"
            },
            MaxpH -> {
                  Format -> Single,
                  Class -> Real,
                  Pattern :> RangeP[0, 14],
                  Units -> None,
                  Description -> "The maximum pH to which the cartridge/frit can be exposed without becoming damaged.",
                  Category -> "Compatibility"
            },
            ConnectionType -> {
                  Format -> Single,
                  Class -> Expression,
                  Pattern :> ConnectorP,
                  Description -> "Indicates the manner in which the cartridge can be fitted to its receptacle.",
                  Category -> "Compatibility"
            },
            MaxRetentionTime -> { (*Ask: is MaxNumberOfHours conceptualized differently?*)
                  Format -> Single,
                  Class -> Real,
                  Pattern :> GreaterEqualP[0*Hour],
                  Units -> Hour,
                  Description -> "The maximum amount of time the impermeable phase can remain in the cartridge, as set by the manufacturer.",
                  Category -> "Operating Limits"
            },
            MaxPressure -> {
                  Format -> Single,
                  Class -> Real,
                  Pattern :> GreaterP[0*PSI],
                  Units -> PSI,
                  Description -> "The maximum pressure to which the cartridge/frit can be exposed without becoming damaged.",
                  Category -> "Operating Limits"
            },
            MaxFlowRate -> {
                  Format -> Single,
                  Class -> Real,
                  Pattern :> GreaterP[0*(Milliliter/Minute)],
                  Units -> (Milliliter/Minute),
                  Description -> "The maximum flow rate at which the cartridge performs.",
                  Category -> "Operating Limits"
            },
            DeadVolume -> {
                  Format -> Single,
                  Class -> Real,
                  Pattern :> GreaterP[0*Milliliter],
                  Units -> Milliliter,
                  Description -> "The approximate volume of liquid lost during flow-through, measured by putting a known volume of dichloromethane onto the cartridge, measuring the volume of dichloromethane that comes out into the collection container, and subtracting that output volume from the input volume.",
                  Category -> "Operating Limits"
            },
            Parameterizations -> {
                  Format -> Multiple,
                  Class -> Link,
                  Pattern :> _Link,
                  Relation -> Object[Maintenance, ParameterizeContainer][ParameterizationModels],
                  Description -> "The maintenance in which the dimensions, shape, and properties of this type of container model was parameterized.",
                  Category -> "Qualifications & Maintenance"
            },
            VerifiedContainerModel -> {
                  Format -> Single,
                  Class -> Expression,
                  Pattern :> BooleanP,
                  Description -> "Indicates if this container model is parameterized or if it needs to be parameterized and verified by the ECLs team.",
                  Category -> "Qualifications & Maintenance",
                  Developer -> True
            }
      }
}
];