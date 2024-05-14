

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, MitochondrialIntegrityAssay], {
	Description->"A protocol that detects the loss of the electrochemical potential gradient across the mitochondrial membrane.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		Trypsin -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "Trypsin is used to dissociate adherent cells from the container in which they are being cultured so that they can analyzed using flow cytometry.",
			Category -> "Trypsinization"
		},
		TrypsinVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of trypsin that is used dissociate adherent cells from the container in which they are being cultured.",
			Category -> "Trypsinization"
		},
		Media -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The culture medium in which the cells can survive and grow.",
			Category -> "Trypsinization"
		},
		InactivationVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of media that is used to dilute and stop the trypsinization of cells.",
			Category -> "Trypsinization"
		},
		TrypsinizedVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The total volume of cells and media in the source plate wells after trypsinization.",
			Category -> "Trypsinization"
		},
		FilterVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of cells to transfer from the source wells to the filter plate for washing and staining.",
			Category -> "Filtration"
		},
		NumberOfFilterings -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> _Integer,
			Units -> None,
			Description -> "The number of times to transfer cells from the source plate to the filter plate.",
			Category -> "Filtration"
		},
		ResuspensionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of cells in the filter plate to be mixed and resupended in reaction buffer after staining.",
			Category -> "Filtration"
		},
		Buffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The buffer solution used for dilution, washing, cell suspension and movement as it is isotonic and non-toxic to cells.",
			Category -> "Mitochondrial Staining"
		},
		BufferVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of buffer that is used to wash cells.",
			Category -> "Mitochondrial Staining"
		},
		NumberOfBufferWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> _Integer,
			Units -> None,
			Description -> "The number of times the cells are washed with buffer during staining and flow prep when the cells are to be trypsinized.",
			Category -> "Mitochondrial Staining"
		},
		MitochondrialDetectorDye -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The dye that is used to indicate changes in the mitochondrial membrane potential of cells.",
			Category -> "Mitochondrial Staining"
		},
		MitochondrialDetectorVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of mitochondrial detector dye to add to each well.",
			Category -> "Mitochondrial Staining"
		},
		ReactionBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The buffer solution used for incubation of the cells during staining.",
			Category -> "Mitochondrial Staining"
		},
		StabilizationBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The buffer that is used to preserve the staining of the cells for subsequent analysis.",
			Category -> "Mitochondrial Staining"
		},
		StainingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?TimeQ,
			Units -> Second,
			Description -> "The length of time the cells are incubated with the mitochondrial detector dye reagent.",
			Category -> "Mitochondrial Staining"
		},
		StainingTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "The temperature at which the cells are incubated with the mitochondrial detector dye.",
			Category -> "Mitochondrial Staining"
		},
		WashVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of reaction buffer with which to incubate the cells for staining.",
			Category -> "Mitochondrial Staining"
		},
		NumberOfReactionWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> _Integer,
			Units -> None,
			Description -> "The number of times to wash the stained cells with reaction buffer after staining.",
			Category -> "Mitochondrial Staining"
		},
		FinalVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "Volume to fill the well up with reaction buffer for resuspension of cells after washing and staining.",
			Category -> "Mitochondrial Staining"
		},
		MitochondrialIntegrityAssayProgram -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Program][Protocol],
			Description -> "The program containing detailed instructions for a robotic liquid handler to perform this assay.",
			Category -> "Robotic Liquid Handling"
		},
		AnalysisMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FlowCytometry | Microscopy,
			Description -> "The method (flow cytometry and/or microscopy) by which the stained cells will be analyzed after the staining.  This determines whether additional preparation steps will need to be performed.",
			Category -> "Mitochondrial Staining",
			Abstract -> True
		},
		AnalysisProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, Microscope][StainingProtocol],
			Description -> "The microscope or flow cytometry protocol used to analyze this mitochondrial detector dye stain.",
			Category -> "Experiments & Simulations",
			Abstract -> True
		}
	}
}];
