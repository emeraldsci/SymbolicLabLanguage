

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Report, Certificate, Analysis],{
	(* This object holds fields for information uploaded from a third party certificate of analysis for certified analytical calibrants or standards.*)
	Description->"Image files for where required certified data can be found within an example document of a third-party generated Certificate of Analysis document verifying a material's chemical/physical properties.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(**Certified Data Fields**)
		(* General *)
		LinearityTest -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Image file for where the LinearityTest data can be found within the certificate document of the certified linear regression R^2 value of this material when plotting a series of instrument outputs vs. a series of independent measurement variables or the contents of this container.",
			Category -> "Certification Information"
		},
		(*Fields for Static Light Scattering*)
		PolymerMolecularWeight->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Image file for where the PolymerMolecularWeight data can be found within the certificate document of the certified average molecular weight (Mw) for a polymer batch.",
			Category -> "Certification Information"
		},
		ColloidalStabilityA2->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Image file for where the ColloidalStabilityA2 data can be found within the certificate document of the certified apparent static light scattering second virial coefficient (A2) of the particle when dissolved in water.
			This is determined by a Zimm plot of the analyte in water at multiple concentrations and detector angles using a Multi-Angle Light Scattering (MALS) detector.
			For more information see Object(Report, Literature, \"id:01G6nvDXGowA\").",
			Category -> "Certification Information"
		},
		HydrodynamicRadius->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Image file for where the Hydrodynamic data can be found within the certificate document of the certified hydrodynamic radius of the analyte when dissolved in a standard solvent.",
			Category -> "Certification Information"
		},
		(*Fields for KarlFischerTitration*)
		WaterContent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Image file for where the WaterContent data can be found within the certificate document of the analyte of the sample's batch.",
			Category -> "Certification Information"
		},
		WaterMassRatio -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Image file for where the WaterMassRatio data can be found within an example certificate document of the certified water content of the analyte of the sample's batch in milligrams of water per gram of substance.",
			Category -> "Certification Information"
		},
		(* Fields for spectral calibration *)
		CalibrationWavelengths -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A list of image files for where the CalibrationWavelengths data can be found within an example certificate document measured for specific substances contained in the certified material.",
			Category -> "Certification Information"
		},
		(* Fields for qPCR validation *)
		TwoFoldDiscriminationTest -> {
			Format -> Single,
			Class -> {Link, Link},
			Pattern :> {_Link, Link},
			Relation -> {Object[EmeraldCloudFile], Object[EmeraldCloudFile]},
			Headers -> {"Average 10K Copy Number - 3 Stdev", "Average 5K Copy Number + 3 Stdev"},
			Description -> "Image files for where the TwoFoldDiscriminationTest data can be found within an example certificate document of the certified values for the average copy number of 10 kbp oligomer can be distinguished from the average copy number of 5 kbp oligomer. The value of three standard deviations below the mean of the 10 K copies should be greater than the value of three standard deviations above the 5 K copies.",
			Category -> "Certification Information"
		}
	}
}];