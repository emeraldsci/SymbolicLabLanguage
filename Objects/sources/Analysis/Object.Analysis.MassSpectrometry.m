(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(*
DefineObjectType[Object[Analysis, MassSpectrometry], {
    Description -> "The identification and quantification of various small molecules/proteins observed in a mass spectrum.",
    CreatePrivileges -> None,
    Cache -> Session,
    Fields -> {
        ProteinHits -> {
            Format -> Multiple,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Model[Molecule,Protein],
            Description -> "Matched proteins with sufficiently high similarity scores from MS data when compared to a database of MS data.",
            Category -> "Analysis & Reports"
        },
    	ProteinScores -> {
            Format -> Multiple,
            Class -> Real,
            Pattern :> _?NumericQ,
            Description -> "For each member of ProteinHits, we calculate the total score of all spectral signatures that map to that protein.",
            Category -> "Analysis & Reports"
        },
        PeptideHits -> {
            Format -> Multiple,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Model[Molecule,Protein],
            Description -> "Matched proteins with sufficiently high similarity scores from MS data when compared to a database of MS data.",
            Category -> "Analysis & Reports"
        },
    	PeptideScores -> {
            Format -> Multiple,
            Class -> Real,
            Pattern :> _?NumericQ,
            Description -> "For each member of ProteinHits, we calculate the total score of all spectral signatures that map to that protein.",
            Category -> "Analysis & Reports"
        },

        (* ----- OR we can have a general field ----- *)
        MoleculeHits -> {
            Format -> Multiple,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Model[Molecule],
            Description -> "Matched proteins with sufficiently high similarity scores from MS data when compared to a database of MS data.",
            Category -> "Analysis & Reports"
        },
    	MaximumScores -> {
            Format -> Multiple,
            Class -> Real,
            Pattern :> _?NumericQ,
            Description -> "For each member of ProteinHits, we calculate the maximum score of all spectral signatures that map to that protein.",
            Category -> "Analysis & Reports"
        },
    	Scores -> {_?NumericQ..}, (* for each spectrum above a matching threshold, we store its scoring metric *)
    	UniquePeptides -> {_Strand..}, (* unique peptides from the digestion that were observed in the experiment and map to the candidate protein *)
    	ScoringMethod -> (LogLikelihood|...),

    	(* ---- fragment level details ----- *)
    	ObservedFragmentMasses -> {UnitsP[Dalton]..},
    	TheoreticalFragmentMasses -> {UnitsP[Dalton]..},
    	Fragments -> {_Strand..},
    	DetectedModifications -> {_Molecule..},
    	ModificationMasses -> {UnitsP[Dalton]..},

    	(* organizational fields *)
    	MatchThreshold -> _?NumericQ, (* Threshold that determines which scores and corresponding probabilities are stored in the object *)

    	(* experimental results relevant for plotting *)
    	MassSpectrum -> BigQuantityArray,
    	DataType -> BigQuantityArray
    }
}];
*)
