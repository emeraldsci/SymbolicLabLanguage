

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Report, Certificate, Analysis],{
	(* This object holds fields for information uploaded from a third party certificate of analysis for certified analytical calibrants or standards.*)
	Description->"Information contained in a third-party generated Certificate of Analysis document verifying a material's chemical/physical properties.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		(* Objects Certified *)
		MaterialCertified->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample][Certificates],
			Description->"The material or sample with the properties and batch number contained in the certificate.",
			Category->"General"
		},
		DownstreamSamplesCertified->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample][Certificates],
			Description->"A series of samples transferred from the original sample certified by this document that maintain the same properties.",
			Category->"General"
		},

		(**Certified Data Fields**)
		(*Fields for Static Light Scattering*)
		PolymerMolecularWeight->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kilodalton],
			Units->Kilodalton,
			Description->"The certified average molecular weight (Mw) for a polymer batch.",
			Category->"Certification Information"
		},
		ColloidalStabilityA2->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*(Mole*Milliliter/ Gram^2)],
			Units->(Mole*Milliliter/ Gram^2),
			Description->"The certified apparent static light scattering second virial coefficient (A2) of the particle when dissolved in water.
			This is determined by a Zimm plot of the analyte in water at multiple concentrations and detector angles using a Multi-Angle Light Scattering (MALS) detector.
			For more information see Object(Report, Literature, \"id:01G6nvDXGowA\").",
			Category->"Certification Information"
		},
		HydrodynamicRadius->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Nanometer],
			Units->Nanometer,
			Description->"The certified hydrodynamic radius of the analyte when dissolved in a standard solvent.",
			Category->"Certification Information"
		}
	}
}];
