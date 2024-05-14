(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Uploading New Samples Or Models",
	Abstract -> "Collection of function for uploading new models or objects into constellation.",
	Reference -> {
		"Uploading Identity Models" -> {
			{UploadOligomer, "Creates a Constellation object containing the given information about an oligomer."},
			{UploadBacterialCell, "Creates a Constellation object containing the given information about a bacterial strain."},
			{UploadVirus, "Creates a Constellation object containing the given information about a virus."},
			{UploadCapillaryELISACartridge, "Creates a new pre-loaded CapillaryELISACartridgeModel with given analytes."},
			{UploadProtein, "Creates or updates a protein model that contains information given about the specified protein."},
			{UploadReferenceElectrodeModel, "Creates and uploads a new reference electrode model that contains information about the material, working limits and storage conditions."},
			{UploadMolecule, "Creates and uploads a molecule model based on the input information of molecule name, atomic structure, PubChemID or other identifiers."},
			{UploadArrayCard, "Creates a Constellation database object for a microfluidic array card used for quantitative polymerase chain reaction."},
			{UploadStockSolution, "Creates and uploads a new stock solution model that is prepared by combining all samples specified in the input components."},
			{UploadSampleModel, "Creates and uploads a sample model based on the input information of molecular composition, storage condition and environmental and health and safety data."},
			{UploadMammalianCell, "Creates and uploads a model that contains the information about the mammalian source of the primary cells or cell line."},
			{UploadName, "Updates the input object with the specified name and returns the named object."},
			{UploadAntibody, "Creates and uploads a protein molecule model that contains the information about the input antibody."},
			{UploadResin, "Creates and uploads a model that contains the information about the characteristics of the input resin."},
			{UploadArrayCard, "Creates a Constellation database object for a microfluidic array card used for quantitative polymerase chain reaction."},
			{UploadCarbohydrate, "Creates and uploads a carbohydrate model that contains the information abut the input carbohydrate."},
			{UploadColumn, "Creates and uploads a column model that contains information about the input column."},
			{UploadInventory, "Returns an inventory object according to the input specifications to keep the specified prodcut in stock."},
			{UploadProduct, "Returns a product object that contains the product information parsed from the input product URL."}
		},
		"Uploading Physical Parameters"-> {
			{UploadModification, "Creates a new Constellation object referring to a specified chemical modification."}
		},

		"Uploading Sample Properties" -> {
			{DefineAnalytes, "Defines the substances of interest in a mixture consisting of multiple chemicals."},
			{DefineComposition, "Updates an existing sample model with the given chemical composition."},
			{DefineEHSInformation, "Updates an existing sample model with environmental as well as health and safety information."},
			{DefineSolvent, "Updates an existing sample model with its solvent information."}
		},

		"Uploading Experiment Parameters" -> {
			{UploadFractionCollectionMethod, "Returns a list of resolved options when uploading a method Object of fraction collections."},
			{UploadPipettingMethod, "Uploads and returns a method object that contains information on pipetting parameters."},
			{UploadGradientMethod, "Uploads a method Object that contains the information of the gradient used in liquid chromatography experiments."}
		},

		"Uploading Sample Objects" -> {
			{DefineTags, "Uploads informative labels to a given sample Object."}
		},

		"Validating" -> {
			{ValidUploadNameQ, "Checks if the provided objects and names and specified options are valid for calling UploadName function."},
			{ValidUploadChemicalModelQ, "Checks if the validity of calling UploadMolecule on given input."},
			{ValidUploadColumnQ, "Checks if the input is valid for calling UploadColumn."},
			{ValidUploadGradientMethodQ, "Checks if the given inputs would result in a valid chromatography gradient method."},
			{ValidUploadMoleculeQ, "Checks if the input if valid for calling UploadMolecule."},
			{ValidUploadStockSolutionQ, "Checks if the input if valid for calling UploadStockSolution for creates a new model of stock solution."},
			{ValidUploadReferenceElectrodeModelQ, "Checks if the input is valid for calling UploadReferenceElectrodeModel."},
			{ValidUploadFractionCollectionMethodQ, "Checks if the input is valid for calling UploadFractionCollectionMethod."},
			{ValidUploadCapillaryELISACartridgeQ, "Checks if the input is valid for calling UploadCapillaryELISACartridge."},
			{ValidUploadPipettingMethodModelQ, "Returns a boolean if a valid object is generated using UploadingPipettingMethod."}
		},

		"Calculate Options" -> {
			{UploadReferenceElectrodeModelOptions, "Calculates the options which will be sued when creating a new reference electrode model."},
			{UploadNameOptions, "Resolves options for calling UploadName function on input objects and names."},
			{UploadMoleculeOptions, "Returns a list of options as they will be resolved by UploadMolecule."},
			{UploadCompanyServiceOptions, "Returns a list of resolved options when creating a new object for a company synthesizes custom-made samples as a service."},
			{UploadPipettingMethodModelOptions, "Returns a list of resolved options when uploading a method object that contains information on pipetting parameters."},
			{UploadGradientMethodOptions, "Returns a list of resolved options when uploading a method Object that contains the information of the gradient used in liquid chromatography experiments."},
			{UploadColumnOptions, "Returns a list of resolved options when uploading a Column model."},
			{UploadInventoryOptions, "Returns a list of resolved options when uploading an Inventory object to keep the specified Product in stock."},
			{UploadStockSolutionOptions, "Returns a list of resolved options when generating a new stock solution model with the given components, solvent and total volume."},
			{UploadTransportConditionOptions, "Returns a list of resolved options when updating the transport conditions of input samples."},
			{UploadArrayCardOptions, "Returns a list of resolved options for creating a new ArrayCardModel with the pre-dried PrimerPairs and Probes for a quantitative polymerase chain reaction (qPCR) experiment."},
			{UploadFractionCollectionMethodOptions, "Returns a list o resolved options when uploading a fraction collection methond for a given object."}
		},
		"Preview" -> {
			{UploadCapillaryELISACartridgePreview, "Returns a graphical preview for UploadCapillaryELISACartridge call with specified analytes, cartridge type and species."}
		}
	},
	RelatedGuides -> {
		GuideLink["SampleStorage"],
		GuideLink["SampleShipments"],
		GuideLink["LocationTracking"]
	}
]