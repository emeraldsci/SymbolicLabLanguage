(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Analysis, DynamicLightScatteringLoading], {
    (*Past tense*)
    Description->"Analysis that determined the properly loaded dynamic light scattering samples. Loading of the instrument has a known failure rate that is relatively high on the basis of the instrument. Thresholding analysis was used to demark correlation curves associated with samples that likely failed loading of the instrument vessel rather than a reflection of the samples intrinsic properties.",
    CreatePrivileges->None,
    Cache->Session,
    Fields -> {
        Protocol -> {
            Format -> Single,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Alternatives[
                Object[Protocol,DynamicLightScattering],
                Object[Protocol,ThermalShift]
            ],
            Description -> "The experimental protocol that generated the data analyzed in this object.",
            Category -> "General"
        },
        TimeThreshold->{
            Format -> Single,
            Class -> Real,
            Pattern :> GreaterP[0 Microsecond],
            Units -> Microsecond,
            Description -> "The point in time before which the average correlation data must exceed the CorrelationThreshold for the sample to be considered properly loaded into the capillary.",
            Category -> "General"
        },
        CorrelationThreshold->{
            Format -> Single,
            Class -> Real,
            Pattern :> GreaterP[0],
            Description -> "The value that the average correlation data must exceed before the TimeThreshold for the sample to be considered properly loaded into the capillary.",
            Category -> "General"
        },
        ManuallyIncludedData->{
            Format -> Multiple,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Alternatives[
                Object[Data, DynamicLightScattering],
                Object[Data, MeltingCurve]
                ],
            Description -> "The data objects the analysis author selected to include as properly loaded that override heuristically selected data objects.",
            Category -> "Data Processing"
        },
        ManuallyExcludedData->{
            Format -> Multiple,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Alternatives[
                Object[Data, DynamicLightScattering],
                Object[Data, MeltingCurve]
                ],
            Description -> "The data objects the analysis author selected to exclude as properly loaded that override heuristically selected data objects.",
            Category -> "Data Processing"
        },
        Data->{
            Format -> Multiple,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Alternatives[
                Object[Data, DynamicLightScattering],
                Object[Data, MeltingCurve]
                ],
            Description -> "The data objects whose correlation curves are considered properly loaded based off of heuristic analysis or are explicitly included.",
            Category -> "Analysis & Reports"
        },
        (*Data in Object[Protocol, DynamicLightScattering] and Data in Object[Protocol, ThermalShift]*)
        Samples -> {
	    Format -> Multiple,
            Class -> Link,
       	    Pattern :> _Link,
            Relation->Alternatives[
				Object[Sample]
			],
	    Description -> "For each member of Data, the samples run through the Protocol to generate the Data object.",
            Category -> "Analysis & Reports",
            IndexMatching->Data
	},
        (*Index match for data in Object[Protocol, ThermalShift]*)
        PooledSamples -> {
	    Format -> Multiple,
	    Class -> Expression,
	    Pattern :> {ObjectReferenceP[Object[Sample]]..},
	    Units -> None,
	    Description -> "For each member of Data, the samples gathered into the pools that are mixed together and run through the Protocol to generate the Data object.",
            Category -> "Analysis & Reports",
            IndexMatching->Data
	},
        ExcludedData->{
            Format -> Multiple,
            Class -> Link,
	    Pattern :> _Link,
            Relation -> Alternatives[
                Object[Data, DynamicLightScattering],
                Object[Data, MeltingCurve]
                ],
            Description -> "The data objects whose correlation curves are considered improperly loaded based off of heursitic analysis or are explicitly excluded.",
            Category -> "Analysis & Reports"
        }
    }
}];
