(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Molecule, Carbohydrate], {
	Description->"Model information for a biological macromolecule composed of monosaccharide monomers.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* Seems to be the PDB equivalent for carbohydates. *)
		(* Other interesting databases supported by NCBI: https://unicarb-db.expasy.org/ and https://glyconnect.expasy.org/browser/ *)
		(* https://www.expasy.org/glycomics *)
		GlyTouCanID -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The GlyTouCan IDs for this carbohydrate.",
			Category -> "Molecular Identifiers",
			Abstract -> True
		},
		(* Table of Monoisotopic vs Average mass for monosaccharides: https://web.expasy.org/glycomod/glycomod_masses.html *)
		(* Seems to be the normalized parameter to search on in glycan databases *)
		MonoisotopicMass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Dalton],
			Units -> Dalton,
			Description -> "The monoisotopic, underivatised, uncharged mass of this carbohydrate, calculated from experimental data for individual monosaccarides.",
			Category -> "Physical Properties"
		},
		WURCS -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The Web3 Unique Representation of Carbohydate Structures notation for this carbohydrate.",
			Category -> "Organizational Information",
			Abstract -> True
		}
	}
}];
