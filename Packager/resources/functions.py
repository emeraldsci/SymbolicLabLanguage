from pyecl.models import Function

class ExperimentSamplePreparation(Function):
	"""
	The allowed input signatures of ExperimentSamplePreparation without optional arguments (kwargs) are:

	``ExperimentSamplePreparation(UnitOperations, **kwargs)`` creates a 'Protocol' object that will perform the sample preparation specified in 'UnitOperations'.

	:param UnitOperations: The unit operations that specify how to perform the sample preparation.
	:param `**kwargs`: optional arguments for ExperimentSamplePreparation.
	:returns: Protocol - The protocol object describing how to perform the requested sample preparation.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentsamplepreparation.
	"""


class ExperimentStockSolution(Function):
	"""
	The allowed input signatures of ExperimentStockSolution without optional arguments (kwargs) are:

	``ExperimentStockSolution(StockSolution, **kwargs)`` generates a 'Protocol' for preparation of the given 'StockSolution' according to its formula and using its preparation parameters as defaults.

	:param StockSolution: The model of stock solution to be prepared during this protocol.
	:param `**kwargs`: optional arguments for ExperimentStockSolution.
	:returns: Protocol - Protocol specifying instructions for preparing the requested stock solution.

	``ExperimentStockSolution(Components,Solvent,TotalVolume, **kwargs)`` creates a 'Protocol' for combining 'Components' and using 'Solvent' to fill to 'TotalVolume' after initial component combination. If necessary, a new stock solution model will be generated using UploadStockSolution with the provided components, Solvent, and total volume.

	:param Components: A list of all samples and amounts to combine for preparation of the stock solution (not including fill-to-volume solvent addition), with each addition in the form {amount, sample}.
	:param Solvent: The solvent used to bring up the volume to the solution's target volume after all other components have been added.
	:param TotalVolume: The total volume of solvent in which the provided components should be dissolved when this stock solution model is prepared.
	:param `**kwargs`: optional arguments for ExperimentStockSolution.
	:returns: Protocol - Protocol specifying instructions for preparing the requested stock solution.

	``ExperimentStockSolution(Components, **kwargs)`` creates a 'Protocol' for combining 'Components' without filling to a particular volume with a solvent. If necessary, a new stock solution model will be created using UploadStockSolution.

	:param Components: A list of all components and amounts to combine for preparation of the stock solution (not including fill-to-volume solvent addition), with each component in the form {amount, component}.
	:param `**kwargs`: optional arguments for ExperimentStockSolution.
	:returns: Protocol - Protocol specifying instructions for preparing the requested stock solution.

	``ExperimentStockSolution(UnitOperations, **kwargs)`` creates a 'Protocol' for stock solution that is prepared by following the specified 'UnitOperations'.

	:param UnitOperations: The order of operations that is to be followed to make a stock solution.
	:param `**kwargs`: optional arguments for ExperimentStockSolution.
	:returns: Protocol - Protocol specifying instructions for preparing the requested stock solution.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentstocksolution.
	"""


class ExperimentAliquot(Function):
	"""
	The allowed input signatures of ExperimentAliquot without optional arguments (kwargs) are:

	``ExperimentAliquot(Sample, AliquotAmount, **kwargs)`` transfers 'Amount' of 'Sample'.

	:param Sample: The sample to be transferred.
	:param AliquotAmount: The sample amount to be transferred.
	:param `**kwargs`: optional arguments for ExperimentAliquot.
	:returns: Protocol - A protocol containing instructions for completion of the requested sample transfer.

	``ExperimentAliquot(Sample, AliquotTargetConcentration, **kwargs)`` dilutes the 'Sample' to match the 'AliquotTargetConcentration'.

	:param Sample: The sample to be transferred.
	:param AliquotTargetConcentration: The sample concentration to target.
	:param `**kwargs`: optional arguments for ExperimentAliquot.
	:returns: Protocol - A protocol containing instructions for completion of the requested sample transfer.

	``ExperimentAliquot(Sample, **kwargs)`` generates a 'Protocol' to perform basic sample transfer, aliquoting, or concentration adjustment for the provided 'Sample'.

	:param Sample: The sample to be transferred.
	:param `**kwargs`: optional arguments for ExperimentAliquot.
	:returns: Protocol - A protocol containing instructions for completion of the requested sample transfer.

	``ExperimentAliquot(SamplePools, Amounts, **kwargs)`` consolidates 'Amounts' of each sample together into 'SamplePools'.

	:param SamplePools: The samples that should be consolidated together into a pool.
	:param Amounts: The amount to be transferred for each sample in each pool.
	:param `**kwargs`: optional arguments for ExperimentAliquot.
	:returns: Protocol - A protocol containing instructions for completion of the requested sample transfer.

	``ExperimentAliquot(SamplePools, TargetConcentrations, **kwargs)`` dilutes 'SamplePools' to match the 'TargetConcentrations'.

	:param SamplePools: The samples that should be consolidated together into a pool.
	:param TargetConcentrations: The sample concentration to target.
	:param `**kwargs`: optional arguments for ExperimentAliquot.
	:returns: Protocol - A protocol containing instructions for completion of the requested sample transfer.

	``ExperimentAliquot(SamplePools, **kwargs)`` generates a 'Protocol' to perform basic sample transfer, aliquoting, or concentration adjustment for the provided 'SamplePools'.

	:param SamplePools: The samples that should be consolidated together into a pool.
	:param `**kwargs`: optional arguments for ExperimentAliquot.
	:returns: Protocol - A protocol containing instructions for completion of the requested sample transfer.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentaliquot.
	"""


class ExperimentTransfer(Function):
	"""
	The allowed input signatures of ExperimentTransfer without optional arguments (kwargs) are:

	``ExperimentTransfer(Sources, Destinations, Amounts, **kwargs)`` creates a 'Protocol' object that will transfer 'Amounts' of each of the 'Sources' to 'Destinations'.

	:param Sources: The samples or locations from which liquid or solid is transferred.
	:param Destinations: The sample or location to which the liquids/solids are transferred.
	:param Amounts: The volumes, masses, or counts of the samples to be transferred.
	:param `**kwargs`: optional arguments for ExperimentTransfer.
	:returns: Protocol - The protocol object(s) describing how to perform the requested transfer.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimenttransfer.
	"""


class ExperimentDilute(Function):
	"""
	The allowed input signatures of ExperimentDilute without optional arguments (kwargs) are:

	``ExperimentDilute(Sample, **kwargs)`` generates a 'Protocol' to perform basic dilution of the provided liquid 'Sample' with some amount of solvent.

	:param Sample: The sample to be diluted.
	:param `**kwargs`: optional arguments for ExperimentDilute.
	:returns: Protocol - A protocol containing instructions for completion of the requested sample dilution.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentdilute.
	"""


class ExperimentSerialDilute(Function):
	"""
	The allowed input signatures of ExperimentSerialDilute without optional arguments (kwargs) are:

	``ExperimentSerialDilute(Samples, **kwargs)`` generates a 'Protocol' to perform a series of dilutions iteratively by mixing samples with diluent, and transferring to another container of diluent.

	:param Samples: The samples to be iteratively diluted.
	:param `**kwargs`: optional arguments for ExperimentSerialDilute.
	:returns: Protocol - A protocol containing instructions for completion of the requested sample serial dilution.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentserialdilute.
	"""


class ExperimentFillToVolume(Function):
	"""
	The allowed input signatures of ExperimentFillToVolume without optional arguments (kwargs) are:

	``ExperimentFillToVolume(Sample, Volume, **kwargs)`` generates a 'Protocol' to fill the container of the specified 'Sample' to the specified 'Volume'. Whereas ExperimentTransfer transfers an known amount into the destination, ExperimentFillToVolume transfers an unknown amount up until it reaches 'Volume'.

	:param Sample: The sample to which solvent should be added.
	:param Volume: The final volume of the container once solvent is added.
	:param `**kwargs`: optional arguments for ExperimentFillToVolume.
	:returns: Protocol - A protocol containing instructions for completion of the requested adding solvent up to a specified volume.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentfilltovolume.
	"""


class ExperimentResuspend(Function):
	"""
	The allowed input signatures of ExperimentResuspend without optional arguments (kwargs) are:

	``ExperimentResuspend(Sample, **kwargs)`` generates a 'Protocol' to perform basic resuspension of the provided solid 'Sample' with some amount of solvent.

	:param Sample: The sample to be resuspended.
	:param `**kwargs`: optional arguments for ExperimentResuspend.
	:returns: Protocol - A protocol containing instructions for completion of the requested sample resuspension.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentresuspend.
	"""


class ExperimentIncubate(Function):
	"""
	The allowed input signatures of ExperimentIncubate without optional arguments (kwargs) are:

	``ExperimentIncubate(Objects, **kwargs)`` creates a 'Protocol' to incubate the provided sample or container 'Objects', with optional mixing while incubating.

	:param Objects: The samples that should be incubated.
	:param `**kwargs`: optional arguments for ExperimentIncubate.
	:returns: Protocol - Protocol generated to incubate the input objects.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentincubate.
	"""


class ExperimentMix(Function):
	"""
	The allowed input signatures of ExperimentMix without optional arguments (kwargs) are:

	``ExperimentMix(Objects, **kwargs)`` creates a 'Protocol' to mix the provided sample or container 'Objects', with optional heating with mixing.

	:param Objects: The samples that should be mixed.
	:param `**kwargs`: optional arguments for ExperimentMix.
	:returns: Protocol - Protocol generated to incubate the input objects.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentmix.
	"""


class ExperimentCentrifuge(Function):
	"""
	The allowed input signatures of ExperimentCentrifuge without optional arguments (kwargs) are:

	``ExperimentCentrifuge(Samples, **kwargs)`` generates a 'Protocol' to subject the provided 'Samples' to greater than gravitational force by rapid spinning.

	:param Samples: The samples or containers to be centrifuged.
	:param `**kwargs`: optional arguments for ExperimentCentrifuge.
	:returns: Protocol - The protocol describing how to centrifuge the samples.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentcentrifuge.
	"""


class ExperimentFilter(Function):
	"""
	The allowed input signatures of ExperimentFilter without optional arguments (kwargs) are:

	``ExperimentFilter(Objects, **kwargs)`` creates a filter 'Protocol' which can use a variety of different techniques to purify 'Objects'.

	:param Objects: The samples or containers whose contents are to be filtered during the protocol.
	:param `**kwargs`: optional arguments for ExperimentFilter.
	:returns: Protocol - The protocol object(s) describing how to run the Filter experiment.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentfilter.
	"""


class ExperimentPellet(Function):
	"""
	The allowed input signatures of ExperimentPellet without optional arguments (kwargs) are:

	``ExperimentPellet(Samples, **kwargs)`` generates a 'Protocol' object to concentrate the denser, insoluble contents of a solution to the bottom of a given container via centrifugation, aspirate off the supernatant, optionally apply a wash solution that can be fed into multiple rounds of pelleting, and optionally add a resuspension solution to rehydrate the pellet.

	:param Samples: The samples that are spun via centrifugation in the attempt to form a pellet.
	:param `**kwargs`: optional arguments for ExperimentPellet.
	:returns: Protocol - A protocol object to concentrate the denser, insoluble contents of a solution to the bottom of a given container and to optionally aspirate the supernatant.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentpellet.
	"""


class ExperimentEvaporate(Function):
	"""
	The allowed input signatures of ExperimentEvaporate without optional arguments (kwargs) are:

	``ExperimentEvaporate(Samples, **kwargs)`` generates a 'Protocol' that will evaporate solvent and condense the 'Samples' through vacuum pressure or nitrogen blow down at elevated temperatures using requested instruments such as rotovaps, speedvacs, or nitrogen blowers.

	:param Samples: The samples or containers holding the samples that will be concentrated by evaporation.
	:param `**kwargs`: optional arguments for ExperimentEvaporate.
	:returns: Protocol - A protocol to concentrate samples by  evaporation.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentevaporate.
	"""


class ExperimentLyophilize(Function):
	"""
	The allowed input signatures of ExperimentLyophilize without optional arguments (kwargs) are:

	``ExperimentLyophilize(Samples, **kwargs)`` generates a 'Protocol' object for freeze drying the provided 'Samples'.

	:param Samples: The samples that will be freeze-dried.
	:param `**kwargs`: optional arguments for ExperimentLyophilize.
	:returns: Protocol - A protocol object for freeze-drying samples.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentlyophilize.
	"""


class ExperimentAutoclave(Function):
	"""
	The allowed input signatures of ExperimentAutoclave without optional arguments (kwargs) are:

	``ExperimentAutoclave(Inputs, **kwargs)`` generates a 'Protocol' object to sterilize 'Inputs' by using an autoclave.

	:param Inputs: The sample(s)/container(s) to be autoclaved.
	:param `**kwargs`: optional arguments for ExperimentAutoclave.
	:returns: Protocol - A protocol object for sterilizing the samples/containers requested by using an autoclave.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentautoclave.
	"""


class ExperimentAcousticLiquidHandling(Function):
	"""
	The allowed input signatures of ExperimentAcousticLiquidHandling without optional arguments (kwargs) are:

	``ExperimentAcousticLiquidHandling(Primitives, **kwargs)`` generates a liquid transfer 'Protocol' to accomplish 'Primitives', which involves one or several steps of transferring the samples specified in 'Primitives'.

	:param Primitives: The liquid transfer to be performed by an acoustic liquid handler.
	:param `**kwargs`: optional arguments for ExperimentAcousticLiquidHandling.
	:returns: Protocol - A protocol containing instructions to perform the requested sample transfer with the acoustic liquid handler.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentacousticliquidhandling.
	"""


class ExperimentDegas(Function):
	"""
	The allowed input signatures of ExperimentDegas without optional arguments (kwargs) are:

	``ExperimentDegas(Samples, **kwargs)`` generates a 'Protocol' which can use a variety of different techniques (freeze-pump-thaw, sparging, or vacuum degassing) to remove dissolved gases from liquid 'Samples'.

	:param Samples: The samples or containers whose contents are to be degassed during the protocol.
	:param `**kwargs`: optional arguments for ExperimentDegas.
	:returns: Protocol - The protocol object(s) describing how to run the Degas experiment.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentdegas.
	"""


class ExperimentFlashFreeze(Function):
	"""
	The allowed input signatures of ExperimentFlashFreeze without optional arguments (kwargs) are:

	``ExperimentFlashFreeze(Objects, **kwargs)`` generates a 'Protocol' which can flash freeze 'Objects' through immersion of sample containers in liquid nitrogen.

	:param Objects: The samples to be flash frozen during the protocol.
	:param `**kwargs`: optional arguments for ExperimentFlashFreeze.
	:returns: Protocol - The protocol object(s) describing how to run the flash freeze experiment.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentflashfreeze.
	"""


class ExperimentAdjustpH(Function):
	"""
	The allowed input signatures of ExperimentAdjustpH without optional arguments (kwargs) are:

	``ExperimentAdjustpH(Samples,TargetpHs, **kwargs)`` generates a 'Protocol' to adjust the pH of the provided 'Samples' to the 'TargetpHs'.

	:param Samples: The samples or containers to be measured.
	:param TargetpHs: The desired pH for each sample.
	:param `**kwargs`: optional arguments for ExperimentAdjustpH.
	:returns: Protocol - The protocol object(s) generated to measure pH of the input objects.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentadjustph.
	"""


class ExperimentMicrowaveDigestion(Function):
	"""
	The allowed input signatures of ExperimentMicrowaveDigestion without optional arguments (kwargs) are:

	``ExperimentMicrowaveDigestion(Samples, **kwargs)`` generates a 'Protocol' for performing microwave digestion on the provided 'Samples'.

	:param Samples: Microwave digestion is used break down organic and inorganic samples into their fully oxidized constituent elements. It is most commonly used to prepare samples for elemental analysis techniques, and employs high temperature conditions in the presence of strongly acidic and oxidizing reagents.
	:param `**kwargs`: optional arguments for ExperimentMicrowaveDigestion.
	:returns: Protocol - A protocol object for performing microwave digestion.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentmicrowavedigestion.
	"""


class ExperimentPrepareReferenceElectrode(Function):
	"""
	The allowed input signatures of ExperimentPrepareReferenceElectrode without optional arguments (kwargs) are:

	``ExperimentPrepareReferenceElectrode(ReferenceElectrodeModel, **kwargs)`` generates a 'Protocol' for the preparation of a reference electrode of the given 'ReferenceElectrodeModel' according to the model information.

	:param ReferenceElectrodeModel: The model of reference electrode to be prepared during this protocol.
	:param `**kwargs`: optional arguments for ExperimentPrepareReferenceElectrode.
	:returns: Protocol - Protocol specifying instructions for preparing the requested reference electrode model.

	``ExperimentPrepareReferenceElectrode(SourceReferenceElectrode, TargetReferenceElectrodeModel, **kwargs)`` generates a 'Protocol' to fill or refresh the reference solution of SourceReferenceElectrode and reset its Model to TargetReferenceElectrodeModel. If the provided SourceReferenceElectrode is a Model, an Object of this Model is selected first and prepared into a reference electrode of the TargetReferenceElectrodeModel.

	:param SourceReferenceElectrode: The reference electrode (or its Model) to be prepared into TargetReferenceElectrodeModel during this protocol.
	:param TargetReferenceElectrodeModel: The model of reference electrode to be prepared during this protocol.
	:param `**kwargs`: optional arguments for ExperimentPrepareReferenceElectrode.
	:returns: Protocol - Protocol specifying instructions for preparing a reference electrode of the requested target reference electrode model.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentpreparereferenceelectrode.
	"""


class ExperimentAssembleCrossFlowFiltrationTubing(Function):
	"""
	The allowed input signatures of ExperimentAssembleCrossFlowFiltrationTubing without optional arguments (kwargs) are:

	``ExperimentAssembleCrossFlowFiltrationTubing(TubingModel, Count, **kwargs)`` generates a new protocol to assemble cross flow filtration tubing.

	:param TubingModel: The cross flow filtration tubing model to be assembled.
	:param Count: The number of tubing objects to assemble.
	:param `**kwargs`: optional arguments for ExperimentAssembleCrossFlowFiltrationTubing.
	:returns: Protocol - The protocol uploaded by this function.

	``ExperimentAssembleCrossFlowFiltrationTubing(TubingModels, Counts, **kwargs)`` generates a new protocol to assemble cross flow filtration tubing.

	:param TubingModels: The cross flow filtration tubing models to be assembled.
	:param Counts: The number of tubing objects to assemble.
	:param `**kwargs`: optional arguments for ExperimentAssembleCrossFlowFiltrationTubing.
	:returns: Protocol - The protocol uploaded by this function.

	``ExperimentAssembleCrossFlowFiltrationTubing(TubingModels, **kwargs)`` generates a new protocol to assemble cross flow filtration tubing.

	:param TubingModels: The cross flow filtration tubing models to be assembled.
	:param `**kwargs`: optional arguments for ExperimentAssembleCrossFlowFiltrationTubing.
	:returns: Protocol - The protocol uploaded by this function.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentassemblecrossflowfiltrationtubing.
	"""


class ExperimentPCR(Function):
	"""
	The allowed input signatures of ExperimentPCR without optional arguments (kwargs) are:

	``ExperimentPCR(Samples, **kwargs)`` creates a 'Protocol' object for running a polymerase chain reaction (PCR) experiment, which uses a thermocycler to amplify target sequences from the 'Samples'.

	:param Samples: The samples containing nucleic acid templates and primer pairs for the amplification of the target sequences.
	:param `**kwargs`: optional arguments for ExperimentPCR.
	:returns: Protocol - The protocol object describing how to run the polymerase chain reaction (PCR) experiment.

	``ExperimentPCR(Samples,PrimerPairs, **kwargs)`` creates a 'Protocol' object for running a polymerase chain reaction (PCR) experiment, which uses a thermocycler to amplify target sequences from the 'Samples' using the 'PrimerPairs'.

	:param Samples: The samples containing nucleic acid templates from which the target sequences will be amplified.
	:param PrimerPairs: The samples containing pairs of oligomer strands designed to bind to the templates and serve as anchors for the polymerase.
	:param `**kwargs`: optional arguments for ExperimentPCR.
	:returns: Protocol - The protocol object describing how to run the polymerase chain reaction (PCR) experiment.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentpcr.
	"""


class ExperimentBioconjugation(Function):
	"""
	The allowed input signatures of ExperimentBioconjugation without optional arguments (kwargs) are:

	``ExperimentBioconjugation(Samples, NewIdentityModels, **kwargs)`` generates a 'Protocol' object to covalently bind 'Samples' through chemical crosslinking to create a sample composed of 'NewIdentityModels'. Bioconjugation reactions are a restricted form of synthesis where conjugations: 1) occur in aqueous solution, 2) occur at atmospheric conditions, 3) are low volume, 4) do not require slow addition of reagents, 5) and do not require reaction monitoring.

	:param Samples: The samples to be chemically linked together.
	:param NewIdentityModels: The models of the resulting conjugated molecule.
	:param `**kwargs`: optional arguments for ExperimentBioconjugation.
	:returns: Protocol - A protocol object that describes the series of transfers and incubations necessary to chemically link the 'Samples' to create conjugated molecules characterized by 'newIdentityModels'.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentbioconjugation.
	"""


class ExperimentDNASynthesis(Function):
	"""
	The allowed input signatures of ExperimentDNASynthesis without optional arguments (kwargs) are:

	``ExperimentDNASynthesis(OligomerModels, **kwargs)`` creates a DNA Synthesis 'Protocol' to synthesize the 'OligomerModels'.

	:param OligomerModels: The oligomer models that will be synthesized.
	:param `**kwargs`: optional arguments for ExperimentDNASynthesis.
	:returns: Protocol - A protocol to synthesize DNA.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentdnasynthesis.
	"""


class ExperimentRNASynthesis(Function):
	"""
	The allowed input signatures of ExperimentRNASynthesis without optional arguments (kwargs) are:

	``ExperimentRNASynthesis(OligomerModels, **kwargs)`` creates a RNA Synthesis 'Protocol' to synthesize the 'OligomerModels'.

	:param OligomerModels: The oligomer models that will be synthesized.
	:param `**kwargs`: optional arguments for ExperimentRNASynthesis.
	:returns: Protocol - A protocol to synthesize RNA.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentrnasynthesis.
	"""


class ExperimentPeptideSynthesis(Function):
	"""
	The allowed input signatures of ExperimentPeptideSynthesis without optional arguments (kwargs) are:

	``ExperimentPeptideSynthesis(OligomerModels, **kwargs)`` uses a oligomer 'OligomerModels' to create a Peptide Synthesis 'Protocol' and associated synthesis cycles methods.

	:param OligomerModels: The oligomer models, sequence, strands or structures for each oligomer sample that will be created by the protocol.
	:param `**kwargs`: optional arguments for ExperimentPeptideSynthesis.
	:returns: Protocol - The protocol object describing how to run the Peptide synthesis experiment.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentpeptidesynthesis.
	"""


class ExperimentPNASynthesis(Function):
	"""
	The allowed input signatures of ExperimentPNASynthesis without optional arguments (kwargs) are:

	``ExperimentPNASynthesis(OligomerModels, **kwargs)`` uses a oligomer 'OligomerModels' to create a Peptide Nucleic Acid (PNA) Synthesis 'Protocol' and associated synthesis cycles methods.

	:param OligomerModels: The oligomer models, sequence, strands or structures for each oligomer sample that will be created by the protocol.
	:param `**kwargs`: optional arguments for ExperimentPNASynthesis.
	:returns: Protocol - The protocol object describing how to run the PNA synthesis experiment.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentpnasynthesis.
	"""


class ExperimentSolidPhaseExtraction(Function):
	"""
	The allowed input signatures of ExperimentSolidPhaseExtraction without optional arguments (kwargs) are:

	``ExperimentSolidPhaseExtraction(Samples, **kwargs)`` generates a 'Protocol' for separating dissolved compounds from 'Samples' according to their physical and chemical properties.

	:param Samples: The samples on which the experiment should act.
	:param `**kwargs`: optional arguments for ExperimentSolidPhaseExtraction.
	:returns: Protocol - The protocol object describing how to run the SolidPhaseExtraction experiment.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentsolidphaseextraction.
	"""


class ExperimentLiquidLiquidExtraction(Function):
	"""
	The allowed input signatures of ExperimentLiquidLiquidExtraction without optional arguments (kwargs) are:

	``ExperimentLiquidLiquidExtraction(Samples, **kwargs)`` creates a 'Protocol' object to separate the aqueous and organic phases of 'Samples' via pipette or phase separator, in order to isolate a target analyte that is more concentrated in either the aqueous or organic phase.

	:param Samples: The samples that contain the target analyte to be isolated via liquid liquid extraction.
	:param `**kwargs`: optional arguments for ExperimentLiquidLiquidExtraction.
	:returns: Protocol - The protocol object(s) describing how to run the liquid liquid experiment.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentliquidliquidextraction.
	"""


class ExperimentFPLC(Function):
	"""
	The allowed input signatures of ExperimentFPLC without optional arguments (kwargs) are:

	``ExperimentFPLC(Samples, **kwargs)`` generates a 'Protocol' to separate 'Samples' via fast protein liquid chromatography.

	:param Samples: The analyte samples which should be injected onto a column and analyzed and/or purified via FPLC.
	:param `**kwargs`: optional arguments for ExperimentFPLC.
	:returns: Protocol - A protocol object that describes the FPLC experiment to be run.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentfplc.
	"""


class ExperimentHPLC(Function):
	"""
	The allowed input signatures of ExperimentHPLC without optional arguments (kwargs) are:

	``ExperimentHPLC(Samples, **kwargs)`` generates a 'Protocol' to separate 'Samples' via high-pressure liquid chromatography (HPLC).

	:param Samples: The analyte samples which should be injected onto a column and analyzed and/or purified via HPLC.
	:param `**kwargs`: optional arguments for ExperimentHPLC.
	:returns: Protocol - A protocol object that describes the HPLC experiment to be run.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimenthplc.
	"""


class ExperimentLCMS(Function):
	"""
	The allowed input signatures of ExperimentLCMS without optional arguments (kwargs) are:

	``ExperimentLCMS(Samples, **kwargs)`` generates a 'Protocol' to separate and analyze 'Samples' via Liquid Chromatography Mass Spectrometry (LCMS).

	:param Samples: The analyte samples which should be separated via column adsorption and analyzed.
	:param `**kwargs`: optional arguments for ExperimentLCMS.
	:returns: Protocol - A protocol object that describes the LCMS experiment to be run.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentlcms.
	"""


class ExperimentSupercriticalFluidChromatography(Function):
	"""
	The allowed input signatures of ExperimentSupercriticalFluidChromatography without optional arguments (kwargs) are:

	``ExperimentSupercriticalFluidChromatography(Samples, **kwargs)`` generates a 'Protocol' to separate and analyze 'Samples' via Supercritical Fluid Chromatography (SFC).

	:param Samples: The analyte samples which should be injected onto a column, separated, and analyzed via SFC.
	:param `**kwargs`: optional arguments for ExperimentSupercriticalFluidChromatography.
	:returns: Protocol - A protocol object that describes the Supercritical Fluid Chromatography experiment to be run.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentsupercriticalfluidchromatography.
	"""


class ExperimentAgaroseGelElectrophoresis(Function):
	"""
	The allowed input signatures of ExperimentAgaroseGelElectrophoresis without optional arguments (kwargs) are:

	``ExperimentAgaroseGelElectrophoresis(Samples, **kwargs)`` generates a 'Protocol' object to conduct electrophoretic size and charged based separation on input 'Samples' by running them through agarose gels.  Experiments can be run analytically to assess composition and purity or preparatively to purify selected bands of material as they run through the gel.

	:param Samples: The samples to be run through an agarose gel and analyzed and/or purified via gel electrophoresis.
	:param `**kwargs`: optional arguments for ExperimentAgaroseGelElectrophoresis.
	:returns: Protocol - A protocol object that describes the agarose gel electrophoresis experiment to be run.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentagarosegelelectrophoresis.
	"""


class ExperimentPAGE(Function):
	"""
	The allowed input signatures of ExperimentPAGE without optional arguments (kwargs) are:

	``ExperimentPAGE(Samples, **kwargs)`` generates a 'Protocol' object for running polyacrylamide gel electrophoresis on 'Samples'.

	:param Samples: The samples to be run through polyacrylamide gel electrophoresis.
	:param `**kwargs`: optional arguments for ExperimentPAGE.
	:returns: Protocol - A protocol object for running polyacrylamide gel electrophoresis on samples.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentpage.
	"""


class ExperimentTotalProteinDetection(Function):
	"""
	The allowed input signatures of ExperimentTotalProteinDetection without optional arguments (kwargs) are:

	``ExperimentTotalProteinDetection(Samples, **kwargs)`` generates a 'Protocol' object for running a capillary electrophoresis-based total protein labeling and detection assay.

	:param Samples: The samples to be run through a capillary electrophoresis-based total protein labeling and detection assay. Proteins present in the input samples are separated by size, labeled with biotin, then treated with a streptavidin-HRP conjugate. The presence of this conjugate is detected by chemiluminescence.
	:param `**kwargs`: optional arguments for ExperimentTotalProteinDetection.
	:returns: Protocol - A protocol object for running a capillary electrophoresis-based total protein labeling and detection assay.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimenttotalproteindetection.
	"""


class ExperimentWestern(Function):
	"""
	The allowed input signatures of ExperimentWestern without optional arguments (kwargs) are:

	``ExperimentWestern(Samples,Antibodies, **kwargs)`` generates a 'Protocol' object for running a western blot using capillary electrophoresis.

	:param Samples: The samples to be run through a capillary electrophoresis-based western blot. Western blot is an analytical method used to detect specific proteins in a tissue-derived mixture.
	:param Antibodies: The PrimaryAntibody or PrimaryAntibodies which will be used along with the SecondaryAntibody to detect the input samples.
	:param `**kwargs`: optional arguments for ExperimentWestern.
	:returns: Protocol - A protocol object for running a capillary electrophoresis-based western blot.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentwestern.
	"""


class ExperimentGasChromatography(Function):
	"""
	The allowed input signatures of ExperimentGasChromatography without optional arguments (kwargs) are:

	``ExperimentGasChromatography(Samples, **kwargs)`` generates a 'Protocol' to analyze 'Samples' using gas chromatography (GC).

	:param Samples: Sample objects to be analyzed using gas chromatography.
	:param `**kwargs`: optional arguments for ExperimentGasChromatography.
	:returns: Protocol - A protocol object that can be used to obtain the gas chromatograms corresponding to the input samples.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentgaschromatography.
	"""


class ExperimentIonChromatography(Function):
	"""
	The allowed input signatures of ExperimentIonChromatography without optional arguments (kwargs) are:

	``ExperimentIonChromatography(Samples, **kwargs)`` generates a 'Protocol' for running an Ion Chromatography experiment to separate charged species from the provided 'Samples'.

	:param Samples: The mixture of analytes which should be injected onto a separation column and analyzed via Ion Chromatography.
	:param `**kwargs`: optional arguments for ExperimentIonChromatography.
	:returns: Protocol - A protocol object that outlines the parameters involved in running Ion Chromatography experiment.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentionchromatography.
	"""


class ExperimentFlashChromatography(Function):
	"""
	The allowed input signatures of ExperimentFlashChromatography without optional arguments (kwargs) are:

	``ExperimentFlashChromatography(Samples, **kwargs)`` generates a 'Protocol' to separate 'Samples' via flash chromatography.

	:param Samples: The analyte samples which should each be loaded into a column and analyzed and/or purified via flash chromatography.
	:param `**kwargs`: optional arguments for ExperimentFlashChromatography.
	:returns: Protocol - A protocol object that describes the flash chromatography experiment to be run.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentflashchromatography.
	"""


class ExperimentCrossFlowFiltration(Function):
	"""
	The allowed input signatures of ExperimentCrossFlowFiltration without optional arguments (kwargs) are:

	``ExperimentCrossFlowFiltration(Samples, **kwargs)`` creates a 'Protocol' to filter the provided sample or container 'Samples' using cross flow filtration.

	:param Samples: The sample or container whose contents are to be filtered during the protocol.
	:param `**kwargs`: optional arguments for ExperimentCrossFlowFiltration.
	:returns: Protocol - Protocol generated to filter the input objects with cross flow filtration.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentcrossflowfiltration.
	"""


class ExperimentDialysis(Function):
	"""
	The allowed input signatures of ExperimentDialysis without optional arguments (kwargs) are:

	``ExperimentDialysis(Objects, **kwargs)`` creates a dialysis 'Protocol' which removes small molecules 'Objects' by diffusion.

	:param Objects: The samples or containers whose contents are to be dialyzed during the protocol.
	:param `**kwargs`: optional arguments for ExperimentDialysis.
	:returns: Protocol - The protocol object(s) describing how to run the Dialysis experiment.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentdialysis.
	"""


class ExperimentMagneticBeadSeparation(Function):
	"""
	The allowed input signatures of ExperimentMagneticBeadSeparation without optional arguments (kwargs) are:

	``ExperimentMagneticBeadSeparation(Samples, **kwargs)`` creates a 'Protocol' for isolating targets from 'Samples' via magnetic bead separation, which uses a magnetic field to separate superparamagnetic particles from suspensions.

	:param Samples: The crude samples for separation.
	:param `**kwargs`: optional arguments for ExperimentMagneticBeadSeparation.
	:returns: Protocol - The protocol object describing how to run the magnetic bead separation experiment.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentmagneticbeadseparation.
	"""


class ExperimentCapillaryGelElectrophoresisSDS(Function):
	"""
	The allowed input signatures of ExperimentCapillaryGelElectrophoresisSDS without optional arguments (kwargs) are:

	``ExperimentCapillaryGelElectrophoresisSDS(Samples, **kwargs)`` generates a 'Protocol' object for running capillary Gel Electrophoresis-SDS (CESDS) on protein 'Samples'. CESDS is an analytical method used to separate proteins by their molecular weight.

	:param Samples: The samples to be electrophorated through a separating matrix. The recommended final protein concentration (reduced or non-reduced) per sample is 0.2-1.5 mg/mL in 50-200 μL (total of 10 μg - 300 μg protein) for input with less than 50 mM salt.
	:param `**kwargs`: optional arguments for ExperimentCapillaryGelElectrophoresisSDS.
	:returns: Protocol - A protocol object for running a capillary gel electrophoresis SDS experiment.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentcapillarygelelectrophoresissds.
	"""


class ExperimentCapillaryIsoelectricFocusing(Function):
	"""
	The allowed input signatures of ExperimentCapillaryIsoelectricFocusing without optional arguments (kwargs) are:

	``ExperimentCapillaryIsoelectricFocusing(Samples, **kwargs)`` generates a 'Protocol' object for running capillary Isoelectric Focusing (cIEF) on protein 'Samples'. cIEF is an analytical method used to separate proteins by their isoelectric point (pI) over a pH gradient.

	:param Samples: The samples to be analyzed by capillary Isoelectric Focusing (cIEF). The recommended final protein concentration per sample is ~0.2 mg/mL in 50-200 μL (total of 10 μg - 40 μg protein) for input with less than 15 mM salt.
	:param `**kwargs`: optional arguments for ExperimentCapillaryIsoelectricFocusing.
	:returns: Protocol - A protocol object for running a capillary isoelectric focusing experiment.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentcapillaryisoelectricfocusing.
	"""


class ExperimentNMR(Function):
	"""
	The allowed input signatures of ExperimentNMR without optional arguments (kwargs) are:

	``ExperimentNMR(Samples, **kwargs)`` generates a 'Protocol' object for measuring the nuclear magnetic resonance (NMR) spectrum of provided 'Samples'.

	:param Samples: The samples for which a nuclear magnetic resonance spectrum will be obtained.
	:param `**kwargs`: optional arguments for ExperimentNMR.
	:returns: Protocol - A protocol object for measuring the nuclear magnetic resonance of input samples.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentnmr.
	"""


class ExperimentNMR2D(Function):
	"""
	The allowed input signatures of ExperimentNMR2D without optional arguments (kwargs) are:

	``ExperimentNMR2D(Samples, **kwargs)`` generates a 'Protocol' object for measuring the two-dimensional nuclear magnetic resonance (NMR) spectrum of provided 'Samples'.

	:param Samples: The samples for which a two-dimensional nuclear magnetic resonance spectrum will be obtained.
	:param `**kwargs`: optional arguments for ExperimentNMR2D.
	:returns: Protocol - A protocol object for measuring the two-dimensional nuclear magnetic resonance spectra of input samples.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentnmr2d.
	"""


class ExperimentAbsorbanceIntensity(Function):
	"""
	The allowed input signatures of ExperimentAbsorbanceIntensity without optional arguments (kwargs) are:

	``ExperimentAbsorbanceIntensity(Samples, **kwargs)`` generates a 'Protocol' object for measuring absorbance of the 'Samples' at a specific wavelength.

	:param Samples: The samples to be measured.
	:param `**kwargs`: optional arguments for ExperimentAbsorbanceIntensity.
	:returns: Protocol - A protocol object for measuring absorbance of samples at a specific wavelength.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentabsorbanceintensity.
	"""


class ExperimentAbsorbanceSpectroscopy(Function):
	"""
	The allowed input signatures of ExperimentAbsorbanceSpectroscopy without optional arguments (kwargs) are:

	``ExperimentAbsorbanceSpectroscopy(Samples, **kwargs)`` generates a 'Protocol' object for running an assay to measure the absorbance of the 'Samples' at specified wavelengths.

	:param Samples: The samples to be measured.
	:param `**kwargs`: optional arguments for ExperimentAbsorbanceSpectroscopy.
	:returns: Protocol - A protocol object for measuring absorbance of samples.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentabsorbancespectroscopy.
	"""


class ExperimentAbsorbanceKinetics(Function):
	"""
	The allowed input signatures of ExperimentAbsorbanceKinetics without optional arguments (kwargs) are:

	``ExperimentAbsorbanceKinetics(Samples, **kwargs)`` generates a 'Protocol' for measuring absorbance of the provided 'Samples' over a period of time.

	:param Samples: The samples for which to measure absorbance.
	:param `**kwargs`: optional arguments for ExperimentAbsorbanceKinetics.
	:returns: Protocol - The protocol generated to measure absorbance of the provided input.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentabsorbancekinetics.
	"""


class ExperimentIRSpectroscopy(Function):
	"""
	The allowed input signatures of ExperimentIRSpectroscopy without optional arguments (kwargs) are:

	``ExperimentIRSpectroscopy(Objects, **kwargs)`` generates a 'Protocol' to measure Infrared (IR) absorbance of the provided sample or container 'Objects'.

	:param Objects: The samples or container objects to be measured. Container objects must house samples, which are then measured separate from the container.
	:param `**kwargs`: optional arguments for ExperimentIRSpectroscopy.
	:returns: Protocol - The protocol object(s) generated to measure the IR spectra of the input objects.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentirspectroscopy.
	"""


class ExperimentFluorescenceIntensity(Function):
	"""
	The allowed input signatures of ExperimentFluorescenceIntensity without optional arguments (kwargs) are:

	``ExperimentFluorescenceIntensity(Samples, **kwargs)`` generates a 'Protocol' for measuring fluorescence intensity of the provided 'Samples'.

	:param Samples: The samples for which to measure fluorescence intensity.
	:param `**kwargs`: optional arguments for ExperimentFluorescenceIntensity.
	:returns: Protocol - The protocol generated to measure fluorescence intensity of the provided input.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentfluorescenceintensity.
	"""


class ExperimentFluorescenceSpectroscopy(Function):
	"""
	The allowed input signatures of ExperimentFluorescenceSpectroscopy without optional arguments (kwargs) are:

	``ExperimentFluorescenceSpectroscopy(Samples, **kwargs)`` generates a 'Protocol' for measuring fluorescence intensity of the provided 'Samples' over a range of excitation or emission wavelengths.

	:param Samples: The samples for which to measure fluorescence.
	:param `**kwargs`: optional arguments for ExperimentFluorescenceSpectroscopy.
	:returns: Protocol - The protocol generated to measure fluorescence of the provided input.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentfluorescencespectroscopy.
	"""


class ExperimentFluorescenceKinetics(Function):
	"""
	The allowed input signatures of ExperimentFluorescenceKinetics without optional arguments (kwargs) are:

	``ExperimentFluorescenceKinetics(Samples, **kwargs)`` generates a 'Protocol' for measuring fluorescence of the provided 'Samples' over a period of time.

	:param Samples: The samples for which to measure fluorescence.
	:param `**kwargs`: optional arguments for ExperimentFluorescenceKinetics.
	:returns: Protocol - The protocol generated to measure fluorescence of the provided input.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentfluorescencekinetics.
	"""


class ExperimentFluorescencePolarization(Function):
	"""
	The allowed input signatures of ExperimentFluorescencePolarization without optional arguments (kwargs) are:

	``ExperimentFluorescencePolarization(Samples, **kwargs)`` generates a 'Protocol' for measuring fluorescence polarization of the provided 'Samples'.

	:param Samples: The samples for which to measure fluorescence polarization.
	:param `**kwargs`: optional arguments for ExperimentFluorescencePolarization.
	:returns: Protocol - The protocol generated to measure fluorescence polarization of the provided input.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentfluorescencepolarization.
	"""


class ExperimentFluorescencePolarizationKinetics(Function):
	"""
	The allowed input signatures of ExperimentFluorescencePolarizationKinetics without optional arguments (kwargs) are:

	``ExperimentFluorescencePolarizationKinetics(Samples, **kwargs)`` generates a 'Protocol' for measuring fluorescence polarization of the provided 'Samples' over a period of time.

	:param Samples: The samples for which to measure fluorescence.
	:param `**kwargs`: optional arguments for ExperimentFluorescencePolarizationKinetics.
	:returns: Protocol - The protocol generated to measure fluorescence polarization of the provided input.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentfluorescencepolarizationkinetics.
	"""


class ExperimentLuminescenceIntensity(Function):
	"""
	The allowed input signatures of ExperimentLuminescenceIntensity without optional arguments (kwargs) are:

	``ExperimentLuminescenceIntensity(Samples, **kwargs)`` generates a 'Protocol' for measuring luminescence intensity of the provided 'Samples'.

	:param Samples: The samples for which to measure luminescence intensity.
	:param `**kwargs`: optional arguments for ExperimentLuminescenceIntensity.
	:returns: Protocol - The protocol generated to measure luminescence intensity of the provided input.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentluminescenceintensity.
	"""


class ExperimentLuminescenceSpectroscopy(Function):
	"""
	The allowed input signatures of ExperimentLuminescenceSpectroscopy without optional arguments (kwargs) are:

	``ExperimentLuminescenceSpectroscopy(Samples, **kwargs)`` generates a 'Protocol' for measuring luminescence intensity of the provided 'Samples' over a range of emission wavelengths.

	:param Samples: The samples for which to measure luminescence.
	:param `**kwargs`: optional arguments for ExperimentLuminescenceSpectroscopy.
	:returns: Protocol - The protocol generated to measure luminescence of the provided input.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentluminescencespectroscopy.
	"""


class ExperimentLuminescenceKinetics(Function):
	"""
	The allowed input signatures of ExperimentLuminescenceKinetics without optional arguments (kwargs) are:

	``ExperimentLuminescenceKinetics(Samples, **kwargs)`` generates a 'Protocol' for measuring luminescence of the provided 'Samples' over a period of time.

	:param Samples: The samples for which to measure luminescence.
	:param `**kwargs`: optional arguments for ExperimentLuminescenceKinetics.
	:returns: Protocol - The protocol generated to measure luminescence of the provided input.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentluminescencekinetics.
	"""


class ExperimentRamanSpectroscopy(Function):
	"""
	The allowed input signatures of ExperimentRamanSpectroscopy without optional arguments (kwargs) are:

	``ExperimentRamanSpectroscopy(Samples, **kwargs)`` generates a 'Protocol' object for performing Raman Spectroscopy on the provided 'Samples' in the THz and IR region (10 cm-1 to 3800 cm-1).

	:param Samples: Raman Spectroscopy is used to measure the chemical and structural fingerprint of a material. Samples can include solids, liquids, and tablets. Each measurement can be done as a single point or a motion pattern that allows for interrogation of the spatial distribution of constituent components within the sample.
	:param `**kwargs`: optional arguments for ExperimentRamanSpectroscopy.
	:returns: Protocol - A protocol object for performing Raman spectroscopy.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentramanspectroscopy.
	"""


class ExperimentDynamicLightScattering(Function):
	"""
	The allowed input signatures of ExperimentDynamicLightScattering without optional arguments (kwargs) are:

	``ExperimentDynamicLightScattering(Samples, **kwargs)`` Generates a 'Protocol' object to run a Dynamic Light Scattering (DLS) experiment. DLS can be used to measure the size, polydispersity, thermal stability, and attractive/repulsive interactions of particles in solution. Concomitant static light scattering can be used to measure the molecular weight of particles in solution.

	:param Samples: The samples to be run in a dynamic light scattering experiment.
	:param `**kwargs`: optional arguments for ExperimentDynamicLightScattering.
	:returns: Protocol - A protocol object that describes the dynamic light scattering experiment to be run.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentdynamiclightscattering.
	"""


class ExperimentAlphaScreen(Function):
	"""
	The allowed input signatures of ExperimentAlphaScreen without optional arguments (kwargs) are:

	``ExperimentAlphaScreen(Samples, **kwargs)`` generates a 'Protocol' object for AlphaScreen measurement of the 'Samples'. The samples should contain analytes with acceptor and donor AlphaScreen beads. Upon laser excitation at 680nm to the donor AlphaScreen beads, singlet Oxygen is produced and diffused to the acceptor AlphaScreen beads only when the two beads are in close proximity. The acceptor AlphaScreen beads react with the singlet Oxygen and emit light signal at 570nm which is captured by a detector in plate reader. A plate which contains the AlphaScreen beads and analytes loaded can be provided as input and the plate will be excited directly and measured in the plate reader. Alternatively, prepared samples can be provided and transferred to an assay plate for AlphaScreen measurement.

	:param Samples: The samples that have analytes with acceptor and donor beads ready for luminescent AlphaScreen measurement.
	:param `**kwargs`: optional arguments for ExperimentAlphaScreen.
	:returns: Protocol - The protocol generated to describe AlphaScreen measurement of the 'Samples'.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentalphascreen.
	"""


class ExperimentCircularDichroism(Function):
	"""
	The allowed input signatures of ExperimentCircularDichroism without optional arguments (kwargs) are:

	``ExperimentCircularDichroism(Samples, **kwargs)`` generates a 'Protocol' object for measuring the differential absorption of left and right circularly polarized light of the 'Samples'.

	:param Samples: The samples to be measured.
	:param `**kwargs`: optional arguments for ExperimentCircularDichroism.
	:returns: Protocol - A protocol object for measuring circular dichroism of samples.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentcirculardichroism.
	"""


class ExperimentNephelometry(Function):
	"""
	The allowed input signatures of ExperimentNephelometry without optional arguments (kwargs) are:

	``ExperimentNephelometry(Samples, **kwargs)`` generates a 'Protocol' object for measuring scattered light from the provided 'Samples'.

	:param Samples: The samples for which to measure scattered light.
	:param `**kwargs`: optional arguments for ExperimentNephelometry.
	:returns: Protocol - The protocol generated to measure scattered light from the provided input.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentnephelometry.
	"""


class ExperimentNephelometryKinetics(Function):
	"""
	The allowed input signatures of ExperimentNephelometryKinetics without optional arguments (kwargs) are:

	``ExperimentNephelometryKinetics(Samples, **kwargs)`` generates a 'Protocol' for measuring scattered light from the provided 'Samples' over a period of time. Injections into the samples can be specified in order to develop kinetic assays and study solubility. Long term growth curves can be measured for cell cultures.

	:param Samples: The samples for which to measure scattered light.
	:param `**kwargs`: optional arguments for ExperimentNephelometryKinetics.
	:returns: Protocol - The protocol generated to measure scattered light from the provided input.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentnephelometrykinetics.
	"""


class ExperimentMassSpectrometry(Function):
	"""
	The allowed input signatures of ExperimentMassSpectrometry without optional arguments (kwargs) are:

	``ExperimentMassSpectrometry(Samples, **kwargs)`` generates a 'Protocol' object which can be used to determine the molecular weight of compounds by ionizing them and measuring their mass-to-charge ratio (m/z).

	:param Samples: The samples to be analyzed using mass spectrometry.
	:param `**kwargs`: optional arguments for ExperimentMassSpectrometry.
	:returns: Protocol - The protocol objects generated to perform mass spectrometry on the provided samples.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentmassspectrometry.
	"""


class ExperimentGCMS(Function):
	"""
	The allowed input signatures of ExperimentGCMS without optional arguments (kwargs) are:

	``ExperimentGCMS(Samples, **kwargs)`` generates a 'Protocol' to analyze 'Samples' using gas chromatography with mass spectrometry (GC/MS).

	:param Samples: Sample objects to be analyzed using gas chromatography with mass spectrometry.
	:param `**kwargs`: optional arguments for ExperimentGCMS.
	:returns: Protocol - A protocol object that can be used to obtain the gas chromatograms corresponding to the input samples.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentgcms.
	"""


class ExperimentICPMS(Function):
	"""
	The allowed input signatures of ExperimentICPMS without optional arguments (kwargs) are:

	``ExperimentICPMS(Samples, **kwargs)`` generates a 'Protocol' object which can be used to determine the atomic composition of 'Samples' by ionizing them into monoatomic ions via inductively coupled plasma (ICP) and measuring their mass-to-charge ratio (m/z).

	:param Samples: The samples to be ionized and analyzed using ICP-MS, which can be predigested or digested as part of the experiment.
	:param `**kwargs`: optional arguments for ExperimentICPMS.
	:returns: Protocol - The protocol objects generated to perform ICP-MS on the provided samples.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimenticpms.
	"""


class ExperimentTotalProteinQuantification(Function):
	"""
	The allowed input signatures of ExperimentTotalProteinQuantification without optional arguments (kwargs) are:

	``ExperimentTotalProteinQuantification(Samples, **kwargs)`` generates a 'Protocol' object for running an absorbance- or fluorescence-based assay to determine the total protein concentration of input 'Samples'.

	:param Samples: The samples to be run in an absorbance- or fluorescence-based total protein concentration determination assay. The concentration of proteins present in the samples is determined by change in absorbance or fluorescence of a dye at a specific wavelength.
	:param `**kwargs`: optional arguments for ExperimentTotalProteinQuantification.
	:returns: Protocol - A protocol object for running an absorbance- or fluorescence-based assay to determine total protein concentration.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimenttotalproteinquantification.
	"""


class ExperimentqPCR(Function):
	"""
	The allowed input signatures of ExperimentqPCR without optional arguments (kwargs) are:

	``ExperimentqPCR(Samples,PrimerPairs, **kwargs)`` creates a 'Protocol' object for running a quantitative Polymerase Chain Reaction (qPCR) experiment, which uses a thermocycler to amplify and quantify target sequences from the 'Samples' using 'PrimerPairs' and either a fluorescent intercalating dye or fluorescently labeled probes.

	:param Samples: The samples containing nucleic acid templates from which the target sequences will be amplified.
	:param PrimerPairs: The samples containing pairs of oligomer strands designed to bind to the templates and function as anchors for polymerases and transcriptases. Specify multiple pairs for a given sample, along with suitable detection probes via the Probes option, in order to perform multiplexing.
	:param `**kwargs`: optional arguments for ExperimentqPCR.
	:returns: Protocol - The protocol object describing how to run the quantitative polymerase chain reaction (qPCR) experiment.

	``ExperimentqPCR(Samples,ArrayCard, **kwargs)`` creates a 'Protocol' object for running a quantitative polymerase chain reaction (qPCR) experiment, which uses a thermocycler to amplify and quantify target sequences from the 'Samples' using an 'ArrayCard' containing primer pairs and fluorescently labeled probes.

	:param Samples: The samples containing nucleic acid templates from which the target sequences will be amplified.
	:param ArrayCard: The array card containing pairs of oligomer strands designed to bind to the templates and function as anchors for polymerases and transcriptases and detection probes.
	:param `**kwargs`: optional arguments for ExperimentqPCR.
	:returns: Protocol - The protocol object describing how to run the quantitative polymerase chain reaction (qPCR) experiment.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentqpcr.
	"""


class ExperimentBioLayerInterferometry(Function):
	"""
	The allowed input signatures of ExperimentBioLayerInterferometry without optional arguments (kwargs) are:

	``ExperimentBioLayerInterferometry(Samples, **kwargs)`` generates a 'Protocol' object for performing Bio-Layer Interferometry (BLI) on the provided 'Samples'.

	:param Samples: BLI measures the interaction between a solution phase analyte (the input sample) and a bio-layer functionalized probe surface by recording changes in the bio-layer thickness over time. Analytes may include antibodies, antigens, proteins, DNA, RNA, small molecules, cells, viruses, and bacteria. Sample solutions can be homogenous or heterogeneous mixtures, and may be recovered and reused due to the nondesctructive nature of the measurement.
	:param `**kwargs`: optional arguments for ExperimentBioLayerInterferometry.
	:returns: Protocol - A protocol object for performing bio-layer interferometry.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentbiolayerinterferometry.
	"""


class ExperimentUVMelting(Function):
	"""
	The allowed input signatures of ExperimentUVMelting without optional arguments (kwargs) are:

	``ExperimentUVMelting(Samples, **kwargs)`` generates a 'Protocol' object for assessing the dissociation characteristics on the provided 'Samples' during heating and cooling (melting curve analysis) using UV absorbance measurements.

	:param Samples: The samples or containers on which the experiment should act.
	:param `**kwargs`: optional arguments for ExperimentUVMelting.
	:returns: Protocol - The protocol object describing how to run the UVMelting experiment.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentuvmelting.
	"""


class ExperimentDifferentialScanningCalorimetry(Function):
	"""
	The allowed input signatures of ExperimentDifferentialScanningCalorimetry without optional arguments (kwargs) are:

	``ExperimentDifferentialScanningCalorimetry(Samples, **kwargs)`` generates a 'Protocol' object for performing capillary-based differential scanning calorimetry (DSC) on the provided 'Samples' by measuring the heat flux as a function of temperature.

	:param Samples: The samples which will be heated to determine thermodynamic properties. If provided as a list of lists, each group of samples or containers within a single list are combined before the experiment is run.
	:param `**kwargs`: optional arguments for ExperimentDifferentialScanningCalorimetry.
	:returns: Protocol - The protocol object describing how to run the DSC experiment.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentdifferentialscanningcalorimetry.
	"""


class ExperimentThermalShift(Function):
	"""
	The allowed input signatures of ExperimentThermalShift without optional arguments (kwargs) are:

	``ExperimentThermalShift(Samples, **kwargs)`` creates a 'Protocol' object for measuring sample fluorescence during heating and cooling (melting curve analysis) to determine shifts in thermal stability of 'Samples' under varying conditions.

	:param Samples: The samples to be analyzed for thermal stability.
	:param `**kwargs`: optional arguments for ExperimentThermalShift.
	:returns: Protocol - The protocol object(s) describing how to run the thermal shift experiment.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentthermalshift.
	"""


class ExperimentCapillaryELISA(Function):
	"""
	The allowed input signatures of ExperimentCapillaryELISA without optional arguments (kwargs) are:

	``ExperimentCapillaryELISA(Samples, **kwargs)`` creates a 'Protocol' to run capillary Enzyme-Linked Immunosorbent Assay (ELISA) experiment on the provided 'Samples' for the detection of certain analytes.

	:param Samples: The samples to be analyzed using capillary ELISA for the detection and quantification of certain analytes such as peptides, proteins, antibodies and hormones.
	:param `**kwargs`: optional arguments for ExperimentCapillaryELISA.
	:returns: Protocol - A protocol object that describes the capillary ELISA experiment to be run.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentcapillaryelisa.
	"""


class ExperimentELISA(Function):
	"""
	The allowed input signatures of ExperimentELISA without optional arguments (kwargs) are:

	``ExperimentELISA(Samples, **kwargs)`` creates a 'Protocol' to run Enzyme-Linked Immunosorbent Assay (ELISA) experiment on the provided 'Samples' for the detection and quantification of certain analytes.

	:param Samples: The samples to be analyzed using ELISA for the detection and quantification of certain analytes such as peptides, proteins, antibodies and hormones.
	:param `**kwargs`: optional arguments for ExperimentELISA.
	:returns: Protocol - A protocol object that describes the capillary ELISA experiment to be run.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentelisa.
	"""


class ExperimentDNASequencing(Function):
	"""
	The allowed input signatures of ExperimentDNASequencing without optional arguments (kwargs) are:

	``ExperimentDNASequencing(Samples, **kwargs)`` creates a 'Protocol' object for running a Sanger DNA sequencing experiment, which uses fluorescently labeled DNA 'Samples', with a genetic analyzer instrument containing a capillary electrophoresis array to determine the nucleotide sequences from the provided 'Samples'.

	:param Samples: The fluorescently labeled nucleic acid template samples, prepared for Sanger DNA sequencing by capillary electrphoresis to determine the nucleotide sequences.
	:param `**kwargs`: optional arguments for ExperimentDNASequencing.
	:returns: Protocol - The protocol object describing how to run the Sanger DNA sequencing experiment.

	``ExperimentDNASequencing(Samples,Primers, **kwargs)`` creates a 'Protocol' object for running a Sanger DNA sequencing experiment, which uses fluorescent dideoxynucleotide chain-terminating PCR to label provided 'Samples' using provided 'Primers' and then a genetic analyzer instrument with a capillary electrophoresis array to determine the nucleotide sequences from the provided 'Samples'.

	:param Samples: The nucleic acid template samples to be mixed with a Master Mix composed of the polymerase, nucleotides, fluorescently-labeled dideoxynucleotides, primer, and buffer, that will then undergo the chain-terminating polymerase reaction, purification if desired, and Sanger DNA sequencing by capillary electrphoresis to determine the nucleotide sequences.
	:param Primers: The oligomer strand designed to bind to the templates and serve as an anchor for the polymerase in the chain-terminating polymerase reaction.
	:param `**kwargs`: optional arguments for ExperimentDNASequencing.
	:returns: Protocol - The protocol object describing how to run the Sanger DNA sequencing experiment.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentdnasequencing.
	"""


class ExperimentImageCells(Function):
	"""
	The allowed input signatures of ExperimentImageCells without optional arguments (kwargs) are:

	``ExperimentImageCells(Samples, **kwargs)`` generates a 'Protocol' for imaging the provided 'Samples' using a widefield microscope or a high content imager. Samples may be imaged in bright-field, phase contrast, epifluorescence, or confocal fluorescence mode.

	:param Samples: The sample(s) to be imaged.
	:param `**kwargs`: optional arguments for ExperimentImageCells.
	:returns: Protocol - A protocol object or packet that will be used to acquire images(s) of the provided 'Samples'.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentimagecells.
	"""


class ExperimentPowderXRD(Function):
	"""
	The allowed input signatures of ExperimentPowderXRD without optional arguments (kwargs) are:

	``ExperimentPowderXRD(Samples, **kwargs)`` generates a 'Protocol' object for measuring the x-ray diffraction of powder 'Samples'.

	:param Samples: The powder samples to be diffracted with x-rays.
	:param `**kwargs`: optional arguments for ExperimentPowderXRD.
	:returns: Protocol - A protocol object for measuring x-ray diffraction of powder samples.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentpowderxrd.
	"""


class ExperimentGrowCrystal(Function):
	"""
	The allowed input signatures of ExperimentGrowCrystal without optional arguments (kwargs) are:

	``ExperimentGrowCrystal(Samples, **kwargs)`` creates a 'Protocol' object to prepare crystallization plate designed to grow crystals of the provided input 'Samples'. Once the crystallization plate is constructed by pipetting, it is placed in crystal incubator which takes daily images of 'Samples' using visible light, ultraviolet light and polarized light. The best crystals which grow can be passed along to ExperimentXRD to obtain diffraction patterns.

	:param Samples: The sample solutions containing target proteins, peptides, nucleic acids or water soluble small molecules which will be plated in order to grow crystals.
	:param `**kwargs`: optional arguments for ExperimentGrowCrystal.
	:returns: Protocol - A protocol object to prepare a crystallization plate to grow crystals and to set up imaging scheduling to monitor the growth of crystals during the incubation.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentgrowcrystal.
	"""


class ExperimentCountLiquidParticles(Function):
	"""
	The allowed input signatures of ExperimentCountLiquidParticles without optional arguments (kwargs) are:

	``ExperimentCountLiquidParticles(Samples, **kwargs)`` generates a 'Protocol' object to run a high accuracy light obscuration (HIAC) experiment to count liquid particles of different sizes.

	:param Samples: The samples to be flow through the light obscuration detector.
	:param `**kwargs`: optional arguments for ExperimentCountLiquidParticles.
	:returns: Protocol - A protocol object that describes the light obscuration experiment to be run.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentcountliquidparticles.
	"""


class ExperimentCyclicVoltammetry(Function):
	"""
	The allowed input signatures of ExperimentCyclicVoltammetry without optional arguments (kwargs) are:

	``ExperimentCyclicVoltammetry(Objects, **kwargs)`` creates a 'Protocol' to perform the cyclic voltammetry measurements on the provided samples or container 'Objects'. The cyclic voltammetry technique is mostly used to investigate the reduction and oxidation processes of molecular species, the reversibility of a chemical reaction, the diffusion coefficient of an interested analyte, and many other electrochemical behaviors.

	:param Objects: The samples that should be measured. Container objects must house samples.
	:param `**kwargs`: optional arguments for ExperimentCyclicVoltammetry.
	:returns: Protocol - Protocol generated to perform the cyclic voltammetry measurement on the input objects.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentcyclicvoltammetry.
	"""


class ExperimentDynamicFoamAnalysis(Function):
	"""
	The allowed input signatures of ExperimentDynamicFoamAnalysis without optional arguments (kwargs) are:

	``ExperimentDynamicFoamAnalysis(Samples, **kwargs)`` generates a 'Protocol' object for running an experiment to characterize foam generation and decay for 'Samples' over time.

	:param Samples: The samples or containers to be analyzed during the protocol.
	:param `**kwargs`: optional arguments for ExperimentDynamicFoamAnalysis.
	:returns: Protocol - The protocol object(s) describing how to run the dynamic foam analysis experiment.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentdynamicfoamanalysis.
	"""


class ExperimentImageSample(Function):
	"""
	The allowed input signatures of ExperimentImageSample without optional arguments (kwargs) are:

	``ExperimentImageSample(Objects, **kwargs)`` creates a 'Protocol' to photograph the provided sample or container 'Objects'.

	:param Objects: The samples or containers that will be photographed.
	:param `**kwargs`: optional arguments for ExperimentImageSample.
	:returns: Protocol - Protocol generated to photograph the input samples or containers.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentimagesample.
	"""


class ExperimentMeasureConductivity(Function):
	"""
	The allowed input signatures of ExperimentMeasureConductivity without optional arguments (kwargs) are:

	``ExperimentMeasureConductivity(Samples, **kwargs)`` generates a 'Protocol' to measure conductivity of the provided 'Samples'.

	:param Samples: The sample(s) to be measured or container(s) holding the samples which will be measured.
	:param `**kwargs`: optional arguments for ExperimentMeasureConductivity.
	:returns: Protocol - The protocol object(s) or packet that will be used to measure conductivity of the input objects.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentmeasureconductivity.
	"""


class ExperimentMeasureContactAngle(Function):
	"""
	The allowed input signatures of ExperimentMeasureContactAngle without optional arguments (kwargs) are:

	``ExperimentMeasureContactAngle(SolidSamples, WettingLiquids, **kwargs)`` generates a 'Protocol' object for determining the contact angle of 'SolidSamples' with the given 'WettingLiquids'.

	:param SolidSamples: The solid sample, such as fiber or Wilhelmy plate, whose contact angle with a given wetting liquid will be measured during this experiment.
	:param WettingLiquids: The liquid samples that are contacted by the solid samples in order to measure the contact angle between them.
	:param `**kwargs`: optional arguments for ExperimentMeasureContactAngle.
	:returns: Protocol - The protocol object for measuring the contact angle between fiber and wetting liquid.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentmeasurecontactangle.
	"""


class ExperimentMeasureCount(Function):
	"""
	The allowed input signatures of ExperimentMeasureCount without optional arguments (kwargs) are:

	``ExperimentMeasureCount(Objects, **kwargs)`` creates a MeasureCount 'Protocol' which determines the count of 'Objects'.

	:param Objects: The samples or containers whose contents' count will be measured.
	:param `**kwargs`: optional arguments for ExperimentMeasureCount.
	:returns: Protocol - The protocol object(s) describing how to run the MeasureCount experiment.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentmeasurecount.
	"""


class ExperimentMeasureDensity(Function):
	"""
	The allowed input signatures of ExperimentMeasureDensity without optional arguments (kwargs) are:

	``ExperimentMeasureDensity(Objects, **kwargs)`` creates a MeasureDensity 'Protocol' which determine the density of 'Objects'.

	:param Objects: The samples or containers whose contents density will be measured.
	:param `**kwargs`: optional arguments for ExperimentMeasureDensity.
	:returns: Protocol - The protocol object(s) describing how to run the MeasureDensity experiment.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentmeasuredensity.
	"""


class ExperimentMeasureDissolvedOxygen(Function):
	"""
	The allowed input signatures of ExperimentMeasureDissolvedOxygen without optional arguments (kwargs) are:

	``ExperimentMeasureDissolvedOxygen(Samples, **kwargs)`` generates a 'Protocol' to measure the dissolved oxygen of the provided 'Samples'.

	:param Samples: The samples or containers to be measured.
	:param `**kwargs`: optional arguments for ExperimentMeasureDissolvedOxygen.
	:returns: Protocol - The protocol object(s) generated to measure DissolvedOxygen of the input objects.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentmeasuredissolvedoxygen.
	"""


class ExperimentMeasureOsmolality(Function):
	"""
	The allowed input signatures of ExperimentMeasureOsmolality without optional arguments (kwargs) are:

	``ExperimentMeasureOsmolality(Objects, **kwargs)`` creates a MeasureOsmolality 'Protocol' which determines the osmolality of 'Objects'. Osmolality is a measure of the concentration of osmotically active species in a solution.

	:param Objects: The samples or containers for whose contents the osmolality will be measured.
	:param `**kwargs`: optional arguments for ExperimentMeasureOsmolality.
	:returns: Protocol - The protocol object(s) describing how to run the MeasureOsmolality experiment.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentmeasureosmolality.
	"""


class ExperimentMeasurepH(Function):
	"""
	The allowed input signatures of ExperimentMeasurepH without optional arguments (kwargs) are:

	``ExperimentMeasurepH(Samples, **kwargs)`` generates a 'Protocol' to measure pH of the provided 'Samples'.

	:param Samples: The samples or containers to be measured.
	:param `**kwargs`: optional arguments for ExperimentMeasurepH.
	:returns: Protocol - The protocol object(s) generated to measure pH of the input objects.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentmeasureph.
	"""


class ExperimentMeasureRefractiveIndex(Function):
	"""
	The allowed input signatures of ExperimentMeasureRefractiveIndex without optional arguments (kwargs) are:

	``ExperimentMeasureRefractiveIndex(Samples, **kwargs)`` generate a 'Protocol' object for measuring the refractive index of input 'sampleIn' at defined temperature.

	:param Samples: The samples or containers whose contents will be measured.
	:param `**kwargs`: optional arguments for ExperimentMeasureRefractiveIndex.
	:returns: Protocol - The protocol object(s) for measuring the refractive index of input 'Samples'.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentmeasurerefractiveindex.
	"""


class ExperimentMeasureSurfaceTension(Function):
	"""
	The allowed input signatures of ExperimentMeasureSurfaceTension without optional arguments (kwargs) are:

	``ExperimentMeasureSurfaceTension(Samples, **kwargs)`` generates a 'Protocol' object for determining the surface tensions of input 'Samples' at varying concentrations.

	:param Samples: The samples to be diluted to varying concentrations and have their surface tensions determined.
	:param `**kwargs`: optional arguments for ExperimentMeasureSurfaceTension.
	:returns: Protocol - The protocol object for measuring the surface tension of input samples at varying concentrations.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentmeasuresurfacetension.
	"""


class ExperimentMeasureViscosity(Function):
	"""
	The allowed input signatures of ExperimentMeasureViscosity without optional arguments (kwargs) are:

	``ExperimentMeasureViscosity(Samples, **kwargs)`` generates a 'Protocol' for measuring the viscosity of the provided 'Samples'.

	:param Samples: The sample(s) for which viscosity measurements should be taken.
	:param `**kwargs`: optional arguments for ExperimentMeasureViscosity.
	:returns: Protocol - A protocol object or packet that will be used to measure the viscosity of the provided 'Sample'.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentmeasureviscosity.
	"""


class ExperimentMeasureVolume(Function):
	"""
	The allowed input signatures of ExperimentMeasureVolume without optional arguments (kwargs) are:

	``ExperimentMeasureVolume(Samples, **kwargs)`` generates a 'Protocol' for measuring the volume of the provided 'Samples'.

	:param Samples: The sample(s) for which volume measurements should be taken.
	:param `**kwargs`: optional arguments for ExperimentMeasureVolume.
	:returns: Protocol - A protocol object or packet that will be used to measure the volume of the provided 'Sample'.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentmeasurevolume.
	"""


class ExperimentMeasureWeight(Function):
	"""
	The allowed input signatures of ExperimentMeasureWeight without optional arguments (kwargs) are:

	``ExperimentMeasureWeight(Items, **kwargs)`` generates a 'Protocol' to weigh the provided sample or container 'Items'.

	:param Items: The samples or containers to be weighed.
	:param `**kwargs`: optional arguments for ExperimentMeasureWeight.
	:returns: Protocol - The protocol object(s) describing how to run the MeasureWeight experiment.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentmeasureweight.
	"""


class ExperimentVisualInspection(Function):
	"""
	The allowed input signatures of ExperimentVisualInspection without optional arguments (kwargs) are:

	``ExperimentVisualInspection(Samples, **kwargs)`` generates a 'Protocol' object for obtaining video recordings of the provided 'Samples' as they are agitated one at a time, in order to detect any visible particulates in the 'Samples'.

	:param Samples: The samples to be inspected or the containers directly storing the samples to be inspected.
	:param `**kwargs`: optional arguments for ExperimentVisualInspection.
	:returns: Protocol - Protocol generated to obtain video recordings of the input sample.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentvisualinspection.
	"""


class ExperimentFreezeCells(Function):
	"""
	The allowed input signatures of ExperimentFreezeCells without optional arguments (kwargs) are:

	``ExperimentFreezeCells(Samples, **kwargs)`` creates a 'Protocol' to freeze the provided 'Samples'.

	:param Samples: The mammalian cell samples whose contents are to be frozen via controlled rate freezing for long-term cryogenic storage.
	:param `**kwargs`: optional arguments for ExperimentFreezeCells.
	:returns: Protocol - Protocol generated to freeze the input samples.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentfreezecells.
	"""


class ExperimentIncubateCells(Function):
	"""
	The allowed input signatures of ExperimentIncubateCells without optional arguments (kwargs) are:

	``ExperimentIncubateCells(Objects, **kwargs)`` creates a 'Protocol' to incubate the provided sample or container 'Objects', with optional shaking while incubating.

	:param Objects: The samples that should be incubated.
	:param `**kwargs`: optional arguments for ExperimentIncubateCells.
	:returns: Protocol - Protocol generated to incubate the input objects.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentincubatecells.
	"""


class ExperimentThawCells(Function):
	"""
	The allowed input signatures of ExperimentThawCells without optional arguments (kwargs) are:

	``ExperimentThawCells(Samples, **kwargs)`` creates a 'Protocol' to thaw the given 'Samples'.

	:param Samples: The samples or containers to be thawed.
	:param `**kwargs`: optional arguments for ExperimentThawCells.
	:returns: Protocol - The protocol object to wash the provided samples.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentthawcells.
	"""


class ExperimentPickColonies(Function):
	"""
	The allowed input signatures of ExperimentPickColonies without optional arguments (kwargs) are:

	``ExperimentPickColonies(Objects, **kwargs)`` creates a 'Protocol' to pick colonies from the provided sample or container 'Objects' and deposit them into a destination container.

	:param Objects: The samples that colonies are picked from.
	:param `**kwargs`: optional arguments for ExperimentPickColonies.
	:returns: Protocol - Protocol generated to pick colonies and deposit them into a container.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentpickcolonies.
	"""


class ExperimentInoculateLiquidMedia(Function):
	"""
	The allowed input signatures of ExperimentInoculateLiquidMedia without optional arguments (kwargs) are:

	``ExperimentInoculateLiquidMedia(Objects, **kwargs)`` creates a 'Protocol' that takes colonies from the provided sample or container 'Objects' and deposit them into liquid media.

	:param Objects: The samples that the colonies are taken from.
	:param `**kwargs`: optional arguments for ExperimentInoculateLiquidMedia.
	:returns: Protocol - Protocol generated to transfer colonies from the input to a liquid media.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentinoculateliquidmedia.
	"""


class ExperimentSpreadCells(Function):
	"""
	The allowed input signatures of ExperimentSpreadCells without optional arguments (kwargs) are:

	``ExperimentSpreadCells(Objects, **kwargs)`` creates a 'Protocol' to transfer suspended cells from the provided sample or container 'Objects' and spread them onto solid media in a destination container.

	:param Objects: The samples that cells are spread from.
	:param `**kwargs`: optional arguments for ExperimentSpreadCells.
	:returns: Protocol - Protocol generated to transfer suspended cells and spread them on solid media in a destination container.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentspreadcells.
	"""


class ExperimentStreakCells(Function):
	"""
	The allowed input signatures of ExperimentStreakCells without optional arguments (kwargs) are:

	``ExperimentStreakCells(Objects, **kwargs)`` creates a 'Protocol' to transfer suspended cells from the provided sample or container 'Objects' and streak them onto solid media in a destination container.

	:param Objects: The samples that cells are streaked from.
	:param `**kwargs`: optional arguments for ExperimentStreakCells.
	:returns: Protocol - Protocol generated to transfer suspended cells and streak them on solid media in a destination container.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/experimentstreakcells.
	"""


class OrderSamples(Function):
	"""
	The allowed input signatures of OrderSamples without optional arguments (kwargs) are:

	``OrderSamples(Objects,Amounts, **kwargs)`` generates a new order transaction to purchase the specified quantity of a given object.

	:param Objects: The objects to be ordered.
	:param Amounts: The quantity or amount to be ordered of each object.
	:param `**kwargs`: optional arguments for OrderSamples.
	:returns: Transactions - A transaction object that tracks the initiated order of samples from a supplier.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/ordersamples.
	"""


class ShipToUser(Function):
	"""
	The allowed input signatures of ShipToUser without optional arguments (kwargs) are:

	``ShipToUser(Sample, **kwargs)`` sends a 'Sample' from an ECL facility to your work location.

	:param Sample: The sample(s) being shipped to the user.
	:param `**kwargs`: optional arguments for ShipToUser.
	:returns: Transaction - The transaction object(s) that tracks the shipping of the samples from ECL to your location.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/shiptouser.
	"""


class ShipToECL(Function):
	"""
	The allowed input signatures of ShipToECL without optional arguments (kwargs) are:

	``ShipToECL(Model, Label, **kwargs)`` send samples and items to ECL. After generating your transaction, you will be able to print ID stickers to label the items and sample containers.

	:param Model: The model being sent to an ECL facility.
	:param Label: The label of the sample's container or item being sent to an ECL facility.
	:param `**kwargs`: optional arguments for ShipToECL.
	:returns: Transaction - A transaction object that tracks the shipping of the samples and items.

	``ShipToECL(Transaction, **kwargs)`` update an existing 'Transaction' to add shipping information (such as tracking number, shipper, date shipped, and expected delivery date).

	:param Transaction: The transaction object being modified.
	:param `**kwargs`: optional arguments for ShipToECL.
	:returns: Transaction - A transaction object that tracks the shipping of the samples.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/shiptoecl.
	"""


class DropShipSamples(Function):
	"""
	The allowed input signatures of DropShipSamples without optional arguments (kwargs) are:

	``DropShipSamples(OrderedItems, OrderNumber, **kwargs)`` generates a 'Transaction' to track the user-initiated shipment of 'OrderedItems' from a third party company to ECL.

	:param OrderedItems: The products or models that a third party company is shipping to ECL on behalf of the user.
	:param OrderNumber: A unique identifier (e.g. Order Number, Confirmation Number, or Transaction Number) associated with the samples that a third party company is shipping to ECL on behalf of the user.
	:param `**kwargs`: optional arguments for DropShipSamples.
	:returns: Transaction - A transaction object that tracks the user-initiated shipment of products from a supplier to ECL.

	``DropShipSamples(Transaction, **kwargs)`` update 'Transaction' to add shipping information (such as tracking number, shipper, date shipped, and expected delivery date) or amount information (such as mass, volume, concentration, and mass concentration) to an existing transaction.

	:param Transaction: The transaction object being modified.
	:param `**kwargs`: optional arguments for DropShipSamples.
	:returns: Transaction - A transaction object that tracks the user-initiated shipment of samples from a supplier to ECL.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/dropshipsamples.
	"""


class CancelTransaction(Function):
	"""
	The allowed input signatures of CancelTransaction without optional arguments (kwargs) are:

	``CancelTransaction(Transaction, **kwargs)`` cancels 'Transaction' if it has not yet advanced to the point where it cannot be canceled.

	:param Transaction: The transaction object to be canceled.
	:param `**kwargs`: optional arguments for CancelTransaction.
	:returns: Transaction - The transaction object that has been canceled.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/canceltransaction.
	"""


class StoreSamples(Function):
	"""
	The allowed input signatures of StoreSamples without optional arguments (kwargs) are:

	``StoreSamples(Sample,Condition, **kwargs)`` directs the ECL to store 'Sample' under the provided 'Condition'.

	:param Sample: Sample to be stored under the provided condition.
	:param Condition: A genre of storage from which storage condition can be determined.
	:param `**kwargs`: optional arguments for StoreSamples.
	:returns: UpdatedSamples - Samples updated to reflect the updated storage condition.

	``StoreSamples(Sample, **kwargs)`` directs the ECL to store 'Sample' based on the DefaultStorageCondition in 'Sample''s model.

	:param Sample: Sample to be stored under the provided condition.
	:param `**kwargs`: optional arguments for StoreSamples.
	:returns: UpdatedSamples - Samples updated to reflect the updated storage condition.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/storesamples.
	"""


class ClearSampleStorageSchedule(Function):
	"""
	The allowed input signatures of ClearSampleStorageSchedule without optional arguments (kwargs) are:

	``ClearSampleStorageSchedule(Sample, **kwargs)`` Erase any entries in 'Sample''s StorageSchedule (if possible), and set StorageCondition to the condition reflected by where the sample is currently located.

	:param Sample: Sample to be cleard of its StorageSchedule.
	:param `**kwargs`: optional arguments for ClearSampleStorageSchedule.
	:returns: UpdatedSamples - Samples updated to reflect the updated storage condition.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/clearsamplestorageschedule.
	"""


class DiscardSamples(Function):
	"""
	The allowed input signatures of DiscardSamples without optional arguments (kwargs) are:

	``DiscardSamples(Objects, **kwargs)`` directs the ECL to permanently dispose of the provided 'Objects' along with their containers or contents as appropriate during the next daily maintenance cycle.

	:param Objects: Samples or Containers to be marked for eventual disposal.
	:param `**kwargs`: optional arguments for DiscardSamples.
	:returns: UpdatedObjects - Samples and containers updated to reflect them being marked for discarding.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/discardsamples.
	"""


class CancelDiscardSamples(Function):
	"""
	The allowed input signatures of CancelDiscardSamples without optional arguments (kwargs) are:

	``CancelDiscardSamples(Objects, **kwargs)`` cancels pending discard requests for 'Objects' to ensure they will not be discarded as part of the regular maintenance schedule.

	:param Objects: Samples or Containers to be marked for eventual disposal.
	:param `**kwargs`: optional arguments for CancelDiscardSamples.
	:returns: UpdatedObjects - Samples and containers updated to reflect them being un-marked for discarding.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/canceldiscardsamples.
	"""


class RestrictSamples(Function):
	"""
	The allowed input signatures of RestrictSamples without optional arguments (kwargs) are:

	``RestrictSamples(Samples, **kwargs)`` marks 'Samples' as restricted from automatic use in any of your team's experiments that request the 'Samples'' models. Samples marked as Restricted can only be used in experiments when specifically provided as input to the experiment functions by a team member.

	:param Samples: Samples to be marked as restricted from automatic use in experiments.
	:param `**kwargs`: optional arguments for RestrictSamples.
	:returns: UpdatedSamples - Samples now restricted from automatic use in experiments.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/restrictsamples.
	"""


class UnrestrictSamples(Function):
	"""
	The allowed input signatures of UnrestrictSamples without optional arguments (kwargs) are:

	``UnrestrictSamples(Samples, **kwargs)`` allows 'Samples' to be automatically utilized in your team's experiments if the models of the 'Samples' are requested.

	:param Samples: Samples to be marked as available for automatic use in experiments.
	:param `**kwargs`: optional arguments for UnrestrictSamples.
	:returns: UpdatedSamples - Samples now available for automatic use in experiments.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/unrestrictsamples.
	"""


class SampleUsage(Function):
	"""
	The allowed input signatures of SampleUsage without optional arguments (kwargs) are:

	``SampleUsage(Primitives, **kwargs)`` creates a 'Table' containing the usage amount, the amount in the user's inventory, and the amount in the public inventory for all samples specified in 'Primitives'.

	:param Primitives: Sample manipulation primitives that include Define, Transfer, Aliquot, Consolidation, Resuspend, and FillToVolume.
	:param `**kwargs`: optional arguments for SampleUsage.
	:returns: Table - A table displaying information of each sample specified in the input primitives, including the usage amount specified in the primitives, the amount of sample in the user's inventory, and the amount of the sample in the public inventory.
	:returns: Associations - A list of associations containing information about each sample specified in the input primitives, including the usage amount specified in the primitives, the amount of sample in the user's inventory, and the amount of the sample in the public inventory (returned if OutputFormat -> Association).

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/sampleusage.
	"""


class Inspect(Function):
	"""
	The allowed input signatures of Inspect without optional arguments (kwargs) are:

	``Inspect(Object, **kwargs)`` displays all of the information stored in the database for 'Object' in a formatted grid with a plot of the object followed by its fields and values.

	:param Object: An object whose database information you want to inspect.
	:param `**kwargs`: optional arguments for Inspect.
	:returns: Table - A formatted version of the input object's database information placed in a grid for display.

	``Inspect(Type, **kwargs)`` displays all of the possible information a given 'Type' could store in a formatted grid with its fields and descriptions of the fields.

	:param Type: A type whose database information you want to inspect.
	:param `**kwargs`: optional arguments for Inspect.
	:returns: Table - A formatted version of the input object's database information placed in a grid for display.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/inspect.
	"""


class EmeraldListLinePlot(Function):
	"""
	The allowed input signatures of EmeraldListLinePlot without optional arguments (kwargs) are:

	``EmeraldListLinePlot(PrimaryData, **kwargs)`` creates a ListLinePlot of 'PrimaryData'.

	:param PrimaryData: Data to plot on primary (left) axis.  Data can have units associated as a QuantityArray, or be raw numerical values.
	:param `**kwargs`: optional arguments for EmeraldListLinePlot.
	:returns: Fig - A ListLinePlot of 'primaryData', which could have a legend and/or could be zoomable.

	``EmeraldListLinePlot(Datasets, **kwargs)`` overlays each dataset in 'Datasets' onto a single figure.

	:param Datasets: List of datasets, where each dataset is data to plot on primary (left) axis.  Data can have units associated as a QuantityArray, or be raw numerical values.
	:param `**kwargs`: optional arguments for EmeraldListLinePlot.
	:returns: Fig - A ListLinePlot showing each dataset in 'datasets' overlaid in a single figure, which could have a legend and/or could be zoomable.

	``EmeraldListLinePlot({{nestedData..}..}, **kwargs)`` overlays all 'primaryData' onto one figure, while associating the innermost data sets to one another through color.

	:param NestedData: Data to plot on primary (left) axis.  Data can have units associated as a QuantityArray, or be raw numerical values.
	:param `**kwargs`: optional arguments for EmeraldListLinePlot.
	:returns: Fig - A ListLinePlot showing each 'nestedData' overlaid in a single figure, where the innermost grouped datasets share the same color.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/emeraldlistlineplot.
	"""


class EmeraldDateListPlot(Function):
	"""
	The allowed input signatures of EmeraldDateListPlot without optional arguments (kwargs) are:

	``EmeraldDateListPlot(PrimaryData, **kwargs)`` creates a DateListPlot of 'PrimaryData'.

	:param PrimaryData: Data to plot on primary (left) axis. Data can have units associated as a QuantityArray, or be raw numerical values.
	:param `**kwargs`: optional arguments for EmeraldDateListPlot.
	:returns: Fig - A DateListPlot, which could have a legend and/or could be zoomable.

	``EmeraldDateListPlot(Datasets, **kwargs)`` overlays each dataset in 'Datasets' onto a single figure.

	:param Datasets: List of datasets, where each dataset is data to plot on primary (left) axis. Data can have units associated as a QuantityArray, or be raw numerical values.
	:param `**kwargs`: optional arguments for EmeraldDateListPlot.
	:returns: Fig - A DateListPlot, which could have a legend and/or could be zoomable.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/emeralddatelistplot.
	"""


class EmeraldBarChart(Function):
	"""
	The allowed input signatures of EmeraldBarChart without optional arguments (kwargs) are:

	``EmeraldBarChart(Dataset, **kwargs)`` creates a bar chart from the provided 'Dataset'.

	:param Dataset: Raw numerical data to plot with EmeraldBarChart.
	:param `**kwargs`: optional arguments for EmeraldBarChart.
	:returns: Chart - A bar chart showing 'dataset'.

	``EmeraldBarChart(Datasets, **kwargs)`` creates a bar chart displaying each dataset in 'Datasets'.

	:param Datasets: List of datasets, where each dataset is raw numerical data to plot with EmeraldBarChart.
	:param `**kwargs`: optional arguments for EmeraldBarChart.
	:returns: Chart - A bar chart showing each dataset in the input 'datasets'.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/emeraldbarchart.
	"""


class EmeraldBoxWhiskerChart(Function):
	"""
	The allowed input signatures of EmeraldBoxWhiskerChart without optional arguments (kwargs) are:

	``EmeraldBoxWhiskerChart(Dataset, **kwargs)`` creates a BoxWhiskerChart from the provided 'Dataset'.

	:param Dataset: List of data points corresponding to box-whisker points. Each data point can be a number or quantity.
	:param `**kwargs`: optional arguments for EmeraldBoxWhiskerChart.
	:returns: Chart - A box-whisker chart showing 'dataset'.

	``EmeraldBoxWhiskerChart(Datasets, **kwargs)`` creates a BoxWhiskerChart displaying each dataset in 'Datasets'.

	:param Datasets: List of datasets, where each dataset is a list of data points corresponding to box-whisker points. Each data point can be a number or quantity.
	:param `**kwargs`: optional arguments for EmeraldBoxWhiskerChart.
	:returns: Chart - A box-whisker chart showing each 'dataset'.

	``EmeraldBoxWhiskerChart(GroupedDatasets, **kwargs)`` creates a BoxWhiskerChart displaying each group of datasets in 'GroupedDatasets'.

	:param GroupedDatasets: A nested list of datasets where each dataset is index-matched within each group, i.e. {{group1-dataset1,group1-dataset2,..},{group2,dataset1,group2-dataset2,..},..}. Each data point can be a number or quantity.
	:param `**kwargs`: optional arguments for EmeraldBoxWhiskerChart.
	:returns: Chart - A box-whisker chart showing each 'dataset'.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/emeraldboxwhiskerchart.
	"""


class EmeraldPieChart(Function):
	"""
	The allowed input signatures of EmeraldPieChart without optional arguments (kwargs) are:

	``EmeraldPieChart(Dataset, **kwargs)`` creates a PieChart of 'Dataset'.

	:param Dataset: List of data points corresponding to pie slice sizes. Each data point can be a number or quantity.
	:param `**kwargs`: optional arguments for EmeraldPieChart.
	:returns: Chart - A pie chart of 'dataset'.

	``EmeraldPieChart(Datasets, **kwargs)`` creates a PieChart displaying each dataset in 'Datasets'.

	:param Datasets: A list of datasets, where each dataset is a list of data points corresponding to pie slice sizes. Each data point can be a number or quantity.
	:param `**kwargs`: optional arguments for EmeraldPieChart.
	:returns: Chart - Pie chart showing each dataset in 'datasets'.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/emeraldpiechart.
	"""


class EmeraldHistogram(Function):
	"""
	The allowed input signatures of EmeraldHistogram without optional arguments (kwargs) are:

	``EmeraldHistogram(Dataset, **kwargs)`` creates a Histogram from the provided 'Dataset'.

	:param Dataset: List of data points to construct a histogram from. Each data point can be a number or quantity.
	:param `**kwargs`: optional arguments for EmeraldHistogram.
	:returns: Chart - A histogram plot of 'dataset'.

	``EmeraldHistogram(Datasets, **kwargs)`` creates a Histogram displaying each dataset in 'Datasets'.

	:param Datasets: List of datasets, where each dataset contains data points to construct histograms from. Each data point can be a number or quantity.
	:param `**kwargs`: optional arguments for EmeraldHistogram.
	:returns: Chart - A histogram plot showing each dataset in 'datasets'.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/emeraldhistogram.
	"""


class EmeraldSmoothHistogram(Function):
	"""
	The allowed input signatures of EmeraldSmoothHistogram without optional arguments (kwargs) are:

	``EmeraldSmoothHistogram(Dataset, **kwargs)`` creates a SmoothHistogram from 'Dataset'.

	:param Dataset: List of data points used to construct the histogram. Each data point can be a number or quantity.
	:param `**kwargs`: optional arguments for EmeraldSmoothHistogram.
	:returns: Chart - A smooth histogram plot of 'dataset'.

	``EmeraldSmoothHistogram(Datasets, **kwargs)`` creates a SmoothHistogram displaying each input dataset in 'Datasets'.

	:param Datasets: List of datasets, where each dataset contains data points used to construct histograms. Each data point can be a number or quantity.
	:param `**kwargs`: optional arguments for EmeraldSmoothHistogram.
	:returns: Chart - A smooth histogram plot of each dataset in 'datasets'.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/emeraldsmoothhistogram.
	"""


class EmeraldHistogram3D(Function):
	"""
	The allowed input signatures of EmeraldHistogram3D without optional arguments (kwargs) are:

	``EmeraldHistogram3D(Dataset, **kwargs)`` creates a Histogram3D from the provided 'Dataset'.

	:param Dataset: List of paired x-y data points.
	:param `**kwargs`: optional arguments for EmeraldHistogram3D.
	:returns: Chart - A 3D histogram of 'dataset'.

	``EmeraldHistogram3D(Datasets, **kwargs)`` creates a Histogram3D displaying each input dataset in 'Datasets'.

	:param Datasets: List of datasets, where each dataset is a list of paired x-y data points.
	:param `**kwargs`: optional arguments for EmeraldHistogram3D.
	:returns: Chart - A 3D histogram showing each dataset in 'datasets'.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/emeraldhistogram3d.
	"""


class EmeraldSmoothHistogram3D(Function):
	"""
	The allowed input signatures of EmeraldSmoothHistogram3D without optional arguments (kwargs) are:

	``EmeraldSmoothHistogram3D(Dataset, **kwargs)`` creates a SmoothHistogram3D from 'Dataset'.

	:param Dataset: List of paired x-y data points.
	:param `**kwargs`: optional arguments for EmeraldSmoothHistogram3D.
	:returns: Chart - A 3D smooth histogram of 'dataset'.

	``EmeraldSmoothHistogram3D({datasets..}, **kwargs)`` creates a SmoothHistogram3D displaying each input dataset in 'datasets'.

	:param Datasets: A list of datasets, where each dataset is a list of paired x-y data points.
	:param `**kwargs`: optional arguments for EmeraldSmoothHistogram3D.
	:returns: Chart - A 3D smooth histogram showing each dataset in 'datasets'.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/emeraldsmoothhistogram3d.
	"""


class EmeraldListContourPlot(Function):
	"""
	The allowed input signatures of EmeraldListContourPlot without optional arguments (kwargs) are:

	``EmeraldListContourPlot(Zvalues, **kwargs)`` creates a ListContourPlot from the input 'Zvalues'.

	:param Zvalues: List of data point z values.
	:param `**kwargs`: optional arguments for EmeraldListContourPlot.
	:returns: Chart - A contour plot of 'zvalues'.

	``EmeraldListContourPlot(Dataset, **kwargs)`` creates a ListContourPlot from the input 'Dataset'.

	:param Dataset: List of data point triplets.
	:param `**kwargs`: optional arguments for EmeraldListContourPlot.
	:returns: Chart - A contour plot of 'dataset'.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/emeraldlistcontourplot.
	"""


class EmeraldListPointPlot3D(Function):
	"""
	The allowed input signatures of EmeraldListPointPlot3D without optional arguments (kwargs) are:

	``EmeraldListPointPlot3D(Dataset, **kwargs)`` creates a ListPointPlot3D of 'Dataset'.

	:param Dataset: List of data point triplets.
	:param `**kwargs`: optional arguments for EmeraldListPointPlot3D.
	:returns: Plot3D - A 3D list plot of 'dataset'.

	``EmeraldListPointPlot3D(Datasets, **kwargs)`` creates a ListPointPlot3D displaying each dataset in 'Datasets'.

	:param Datasets: List of datasets, where each dataset is a list of data point triplets.
	:param `**kwargs`: optional arguments for EmeraldListPointPlot3D.
	:returns: Plot3D - A 3D list plot showing each dataset in 'datasets'.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/emeraldlistpointplot3d.
	"""


class EmeraldListPlot3D(Function):
	"""
	The allowed input signatures of EmeraldListPlot3D without optional arguments (kwargs) are:

	``EmeraldListPlot3D(Dataset, **kwargs)`` creates a 3D list plot of 'Dataset'.

	:param Dataset: List of data point triplets with or without units.
	:param `**kwargs`: optional arguments for EmeraldListPlot3D.
	:returns: 3DPlot - A 3D plot of 'dataset'.

	``EmeraldListPlot3D(Datasets, **kwargs)`` creates a 3D list plot of 'Datasets'.

	:param Datasets: A list of datasets, where each dataset is a list of data point triplets with or without units.
	:param `**kwargs`: optional arguments for EmeraldListPlot3D.
	:returns: 3DPlot - A 3D plot of 'datasets'.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/emeraldlistplot3d.
	"""


class PlotDistribution(Function):
	"""
	The allowed input signatures of PlotDistribution without optional arguments (kwargs) are:

	``PlotDistribution(Dist, **kwargs)`` plots the PDF of the distribution 'Dist' with statistics overlaid.

	:param Dist: A parameterized distribution or numerical sample to plot.
	:param `**kwargs`: optional arguments for PlotDistribution.
	:returns: Fig - A plot of the distribution.

	``PlotDistribution(FitObject, **kwargs)`` plots the best-fit distribution of each fitted parameter in 'FitObject'.

	:param FitObject: An Object[Analysis,Fit] reference containing fitted parameters to plot.
	:param `**kwargs`: optional arguments for PlotDistribution.
	:returns: ParamFig - A 1D or 2D plot of the best-fit parameter distribution.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotdistribution.
	"""


class PlotImage(Function):
	"""
	The allowed input signatures of PlotImage without optional arguments (kwargs) are:

	``PlotImage(Img, **kwargs)`` creates a zoomable view of 'Img' with rulers around the frame.

	:param Img: An image to interact with.
	:param `**kwargs`: optional arguments for PlotImage.
	:returns: Fig - An interactive image that can be zoomed and measured.

	``PlotImage({img ..}, **kwargs)`` overlays each 'img' in a single interactive figure.

	:param Imgs: A list of images to interact with.
	:param `**kwargs`: optional arguments for PlotImage.
	:returns: Fig - An interactive image that can be zoomed and measured.

	``PlotImage(DataObject, **kwargs)`` displays the primary image associated with the data object.

	:param DataObject: An object containing an image that will be made interactive.
	:param `**kwargs`: optional arguments for PlotImage.
	:returns: Fig - An interactive image that can be zoomed and measured.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotimage.
	"""


class PlotTable(Function):
	"""
	The allowed input signatures of PlotTable without optional arguments (kwargs) are:

	``PlotTable(Values, **kwargs)`` displays 'Values' in a grid 'Table' similar to TableForm.

	:param Values: Table data (in the form of a matrix).
	:param `**kwargs`: optional arguments for PlotTable.
	:returns: Table - A formatted table containing the field values from the given objects.

	``PlotTable(Objects,Fields, **kwargs)`` creates a 'Table' containing the values of 'Fields' from 'Objects'.

	:param Objects: Object whose field values will be displayed in the table.
	:param Fields: Fields to display in the table.
	:param `**kwargs`: optional arguments for PlotTable.
	:returns: Table - A formatted table containing the field values from the given objects.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plottable.
	"""


class PlotCloudFile(Function):
	"""
	The allowed input signatures of PlotCloudFile without optional arguments (kwargs) are:

	``PlotCloudFile(CloudFile, **kwargs)`` creates an image or snippet of the file contents of 'CloudFile'.

	:param CloudFile: A single cloud file to plot.
	:param `**kwargs`: optional arguments for PlotCloudFile.
	:returns: Preview - An image or snippet of the file contents.

	``PlotCloudFile(CloudFiles, **kwargs)`` creates a list of images or snippets of the file contents of 'CloudFiles'.

	:param CloudFiles: A list of cloud files to interact with.
	:param `**kwargs`: optional arguments for PlotCloudFile.
	:returns: Previews - An image or snippet of the file contents.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotcloudfile.
	"""


class PlotPeaks(Function):
	"""
	The allowed input signatures of PlotPeaks without optional arguments (kwargs) are:

	``PlotPeaks(PeaksData, **kwargs)`` produces either a piechart or barchart of the peak areas, widths, heights, or purities contained in the provided 'PeaksData' object.

	:param PeaksData: A data or peaks analysis object to be plotted.
	:param `**kwargs`: optional arguments for PlotPeaks.
	:returns: Plot - A graphical representation of peak areas, widths, heights, or purity as either a pie chart or a bar chart.

	``PlotPeaks(PeaksDataA,PeaksDataB, **kwargs)`` produces a normalized barchart of the peak areas, widths, heights, or purities of 'PeaksDataA' normalized against 'PeaksDataB'.

	:param PeaksDataA: A data or peaks analysis object to be plotted.
	:param PeaksDataB: The data or peaks analysis object that 'peaksDataA' will be normalized to.
	:param `**kwargs`: optional arguments for PlotPeaks.
	:returns: Plot - A graphical representation of peak areas, widths, heights, or purity as either a pie chart or a bar chart.

	``PlotPeaks(Purity, **kwargs)`` produces either a piechart or barchart showing the 'Purity' (relative areas) of a set of peaks.

	:param Purity: The 'purity' --- index-matched lists of areas, relative areas, and peak labels --- of the peaks you wish to plot.
	:param `**kwargs`: optional arguments for PlotPeaks.
	:returns: Plot - A graphical representation of peak areas, widths, heights, or purity as either a pie chart or a bar chart.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotpeaks.
	"""


class PlotObject(Function):
	"""
	The allowed input signatures of PlotObject without optional arguments (kwargs) are:

	``PlotObject(Object, **kwargs)`` creates a plot of the information in 'Object' using a style determined by the SLL Type of 'Object'.

	:param Object: An object to plot.
	:param `**kwargs`: optional arguments for PlotObject.
	:returns: Fig - A visual display of the input.

	``PlotObject(Type,RawData, **kwargs)`` plots 'RawData' in the appropriate plot style for 'Type'.

	:param Type: An SLL Type to associate with the 'rawData'.
	:param RawData: Data points to plot.
	:param `**kwargs`: optional arguments for PlotObject.
	:returns: Fig - A visual display of the input.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotobject.
	"""


class PlotWaterfall(Function):
	"""
	The allowed input signatures of PlotWaterfall without optional arguments (kwargs) are:

	``PlotWaterfall(StackedData, **kwargs)`` constructs a waterfall plot from 'StackedData', a collection of 2D coordinate pairs stacked in paired list form alongside their Z-coordinate values.

	:param StackedData: A collection of 2D coordinate pairs stacked in paired list form alongside their corresponding Z-coordinate values, e.g. {{Z,{{X,Y}..}}..}. Each set of 2D coordinates corresponds to an independent level in the waterfall, and its paired Z-coordinate value determines its position relative to the other contours.
	:param `**kwargs`: optional arguments for PlotWaterfall.
	:returns: Plot - A 3D figure in which each 2D coordinate list in `stackedData` is visualized as a 2D contour in the waterfall. Each contour in the waterfall is confined to its own 2D plane, with its Z-coordinate determined by either its paired value or by its relative position in `stackedData`.

	``PlotWaterfall(DataObjects, **kwargs)`` constructs a waterfall plot from 'DataObjects', a list of references to data objects that each contain a list of 2D coordinate pairs.

	:param DataObjects: A list of Object[Data] references in the form {ObjectP[Object[Data]]..}. All referenced objects must be of the same type and must possess at least one field containing a set of 2D coordinate pairs.
	:param `**kwargs`: optional arguments for PlotWaterfall.
	:returns: MultiObjPlot - A 3D figure in which the PrimaryData field of each object referenced in `dataObjects` is visualized as a 2D contour in the waterfall. Each contour in the waterfall is confined to its own 2D plane, with its Z-coordinate set in accordance with either the specified LabelField option or the contour's relative position in `dataObjects`.

	``PlotWaterfall(DataObject, **kwargs)`` constructs a waterfall plot from 'DataObject', a single data object reference that contains a paired list of 2D coordinates and their associated Z-coordinate values.

	:param DataObject: A standalone Object[Data] reference of the form ObjectP[Object[Data]]. The referenced object must possess at least one field containing a paired list of 2D coordinate pairs and their associated Z-coordinate values, e.g. {{Z,{{X,Y}..}}..}.
	:param `**kwargs`: optional arguments for PlotWaterfall.
	:returns: ObjPlot - A 3D figure in which each item in the paired-list retrieved from the PrimaryData field of `dataObject` is visualized as a 2D contour in the waterfall. Each contour in the waterfall is confined to its own 2D plane, with its Z-coordinate set in accordance with either the specified LabelField option or the contour's relative position in the paired list of coordinates.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotwaterfall.
	"""


class PlotProtocolTimeline(Function):
	"""
	The allowed input signatures of PlotProtocolTimeline without optional arguments (kwargs) are:

	``PlotProtocolTimeline(Protocol, **kwargs)`` plots the status timeline in 'Protocol'.

	:param Protocol: The protocol, maintenance or qualification object.
	:param `**kwargs`: optional arguments for PlotProtocolTimeline.
	:returns: Timeline - The plot of the changing status.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotprotocoltimeline.
	"""


class PlotAbsorbanceQuantification(Function):
	"""
	The allowed input signatures of PlotAbsorbanceQuantification without optional arguments (kwargs) are:

	``PlotAbsorbanceQuantification(QuantAnalysis, **kwargs)`` generates a line plot of the Object[Data,AbsorbanceSpectroscopy] associated with each item in 'QuantAnalysis'.

	:param QuantAnalysis: One or more Object[Analysis,AbsorbanceQuantification] objects containing Object[Data,AbsorbanceSpectroscopy] to be plotted.
	:param `**kwargs`: optional arguments for PlotAbsorbanceQuantification.
	:returns: Plot - A graphical representation of the spectra.

	``PlotAbsorbanceQuantification(QuantProtocol, **kwargs)`` generates a line plot of the Object[Data,AbsorbanceSpectroscopy] associated with each item in 'QuantProtocol'.

	:param QuantProtocol: One or more protocol[AbsorbanceQuantification] objects containing Object[Data,AbsorbanceSpectroscopy] to be plotted.
	:param `**kwargs`: optional arguments for PlotAbsorbanceQuantification.
	:returns: Plot - A graphical representation of the spectra.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotabsorbancequantification.
	"""


class PlotAbsorbanceSpectroscopy(Function):
	"""
	The allowed input signatures of PlotAbsorbanceSpectroscopy without optional arguments (kwargs) are:

	``PlotAbsorbanceSpectroscopy(SpectroscopyObjects, **kwargs)`` provides a graphical plot of spectra belonging to 'SpectroscopyObjects'.

	:param SpectroscopyObjects: One or more objects containing absorbance spectra.
	:param `**kwargs`: optional arguments for PlotAbsorbanceSpectroscopy.
	:returns: Plot - A graphical representation of the spectra.

	``PlotAbsorbanceSpectroscopy(Spectrum, **kwargs)`` provides a graphical plot of the provided spectrum.

	:param Spectrum: The spectrum you wish to plot.
	:param `**kwargs`: optional arguments for PlotAbsorbanceSpectroscopy.
	:returns: Plot - A graphical representation of the spectrum.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotabsorbancespectroscopy.
	"""


class PlotAlphaScreen(Function):
	"""
	The allowed input signatures of PlotAlphaScreen without optional arguments (kwargs) are:

	``PlotAlphaScreen(AlphaScreenData, **kwargs)`` provides a graphical plot the provided luminescence intensities either in the form of a histogram or a box and whisker plot.

	:param AlphaScreenData: A list of the AlphaScreen data objects whose intensity readings you wish to plot.
	:param `**kwargs`: optional arguments for PlotAlphaScreen.
	:returns: Plot - A graphical representation of the distribution(s) of intensities provided.

	``PlotAlphaScreen(Intensities, **kwargs)`` provides a graphical plot the provided luminescence intensities either in the form of a histogram or a box and whisker plot.

	:param Intensities: The intensity readings you wish to plot.
	:param `**kwargs`: optional arguments for PlotAlphaScreen.
	:returns: Plot - A graphical representation of the distribution(s) of intensities provided.

	``PlotAlphaScreen(AlphaScreenData,SecondaryVariables, **kwargs)`` provides a graphical plot the provided luminescence intensities (in y-axis) against the values of secondary variable (in x-axis) in the form of a scatter plot.

	:param AlphaScreenData: A list of the AlphaScreen data objects whose intensity readings you wish to plot in a scatter plot.
	:param SecondaryVariables: A list of secondary variable whose values are plotted against the AlphaScreen intensity readings in a scatter plot.
	:param `**kwargs`: optional arguments for PlotAlphaScreen.
	:returns: Plot - A graphical representation of the distribution(s) of intensities provided against the secondary variables.

	``PlotAlphaScreen(Intensities,SecondaryVariables, **kwargs)`` provides a graphical plot the provided luminescence intensities (in y-axis) against the values of secondary variable (in x-axis) in the form of a scatter plot.

	:param Intensities: The intensity readings you wish to plot.
	:param SecondaryVariables: A list of secondary variable whose values are plotted against the AlphaScreen intensity readings in a scatter plot.
	:param `**kwargs`: optional arguments for PlotAlphaScreen.
	:returns: Plot - A graphical representation of the distribution(s) of intensities provided against the secondary variables.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotalphascreen.
	"""


class PlotCircularDichroism(Function):
	"""
	The allowed input signatures of PlotCircularDichroism without optional arguments (kwargs) are:

	``PlotCircularDichroism(SpectroscopyObjects, **kwargs)`` provides a graphical plot of spectra belonging to 'SpectroscopyObjects'.

	:param SpectroscopyObjects: One or more objects containing circular dichroism absorbance (ellipticity) spectrum and absorbance spectrum spectra.
	:param `**kwargs`: optional arguments for PlotCircularDichroism.
	:returns: Plot - A graphical representation of the spectra.

	``PlotCircularDichroism(Spectrum, **kwargs)`` provides a graphical plot of the provided spectrum.

	:param Spectrum: The spectrum you wish to plot.
	:param `**kwargs`: optional arguments for PlotCircularDichroism.
	:returns: Plot - A graphical representation of the spectrum.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotcirculardichroism.
	"""


class PlotFluorescenceIntensity(Function):
	"""
	The allowed input signatures of PlotFluorescenceIntensity without optional arguments (kwargs) are:

	``PlotFluorescenceIntensity(FluorescenceData, **kwargs)`` provides a graphical plot of the provided fluorescence intensities from the given data objects either in the form of a histogram or a box and whisker plot.

	:param FluorescenceData: Fluorescence intensity data you wish to plot.
	:param `**kwargs`: optional arguments for PlotFluorescenceIntensity.
	:returns: Plot - A graphical representation of the distribution(s) of intensities provided.

	``PlotFluorescenceIntensity(Intensities, **kwargs)`` provides a graphical plot of the provided fluorescence intensities either in the form of a histogram or a box and whisker plot.

	:param Intensities: Fluorescence intensity data you wish to plot.
	:param `**kwargs`: optional arguments for PlotFluorescenceIntensity.
	:returns: Plot - A graphical representation of the distribution(s) of intensities provided.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotfluorescenceintensity.
	"""


class PlotFluorescenceSpectroscopy(Function):
	"""
	The allowed input signatures of PlotFluorescenceSpectroscopy without optional arguments (kwargs) are:

	``PlotFluorescenceSpectroscopy(FluorescenceSpectroscopyData, **kwargs)`` displays fluorescence intensity vs wavelength 'Plot' for the supplied 'FluorescenceSpectroscopyData'.

	:param FluorescenceSpectroscopyData: Fluorescence spectroscopy data to be plotted.
	:param `**kwargs`: optional arguments for PlotFluorescenceSpectroscopy.
	:returns: Plot - The plot of the spectra.

	``PlotFluorescenceSpectroscopy(Spectra, **kwargs)`` displays fluorescence intensity vs wavelength 'Plot' when given a 'Spectra' as a raw data trace.

	:param Spectra: Spectral data to be plotted.
	:param `**kwargs`: optional arguments for PlotFluorescenceSpectroscopy.
	:returns: Plot - The plot of the spectra.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotfluorescencespectroscopy.
	"""


class PlotLuminescenceSpectroscopy(Function):
	"""
	The allowed input signatures of PlotLuminescenceSpectroscopy without optional arguments (kwargs) are:

	``PlotLuminescenceSpectroscopy(LuminescenceSpectroscopyData, **kwargs)`` displays luminescence intensity vs wavelength for the supplied 'LuminescenceSpectroscopyData'.

	:param LuminescenceSpectroscopyData: One or more Object[Data,LuminescenceSpectroscopy] objects containing emission spectra.
	:param `**kwargs`: optional arguments for PlotLuminescenceSpectroscopy.
	:returns: Plot - A 2D visualization of luminescence intensity as a function of wavelength.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotluminescencespectroscopy.
	"""


class PlotMassSpectrometry(Function):
	"""
	The allowed input signatures of PlotMassSpectrometry without optional arguments (kwargs) are:

	``PlotMassSpectrometry(MassSpectrometryData, **kwargs)`` provides a graphical plot the provided mass spectra.

	:param MassSpectrometryData: The spectra you wish to plot.
	:param `**kwargs`: optional arguments for PlotMassSpectrometry.
	:returns: Plot - A graphical representation of the spectra.

	``PlotMassSpectrometry(Spectra, **kwargs)`` provides a graphical plot the provided mass spectra.

	:param Spectra: The spectra you wish to plot.
	:param `**kwargs`: optional arguments for PlotMassSpectrometry.
	:returns: Plot - A graphical representation of the spectra.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotmassspectrometry.
	"""


class PlotNephelometry(Function):
	"""
	The allowed input signatures of PlotNephelometry without optional arguments (kwargs) are:

	``PlotNephelometry(DataObject, **kwargs)`` displays a plot of the raw relative nephelometric measurement values versus concentration from the supplied 'DataObject'.

	:param DataObject: Nephelometry data that will be plotted.
	:param `**kwargs`: optional arguments for PlotNephelometry.
	:returns: Plot - The plots of the nephelometry data.

	``PlotNephelometry(ProtocolObject, **kwargs)`` plots of the data collected during an ExperimentNephelometry protocol.

	:param ProtocolObject: Protocol object from a completed ExperimentNephelometry.
	:param `**kwargs`: optional arguments for PlotNephelometry.
	:returns: Plots - Graphical representation of the turbidity data collected during ExperimentNephelometry.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotnephelometry.
	"""


class PlotNMR(Function):
	"""
	The allowed input signatures of PlotNMR without optional arguments (kwargs) are:

	``PlotNMR(NMRdata, **kwargs)`` generates a graphical representation of spectra contained in 'NMRdata'.

	:param NMRdata: One or more Object[Data,NMR] objects containing spectra.
	:param `**kwargs`: optional arguments for PlotNMR.
	:returns: Plot - A graphical representation of the spectra.

	``PlotNMR(Spectra, **kwargs)`` generates a graphical representation of the provided 'Spectra'.

	:param Spectra: One or more raw NMR spectra to be plotted.
	:param `**kwargs`: optional arguments for PlotNMR.
	:returns: Plot - A graphical representation of the spectra.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotnmr.
	"""


class PlotNMR2D(Function):
	"""
	The allowed input signatures of PlotNMR2D without optional arguments (kwargs) are:

	``PlotNMR2D(NMR2Ddata, **kwargs)`` provides a graphical plot the provided 'NMR2Ddata' spectra.

	:param NMR2Ddata: The NMR2D data object containing the spectra you wish to plot.
	:param `**kwargs`: optional arguments for PlotNMR2D.
	:returns: Plot - A graphical representation of the spectra.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotnmr2d.
	"""


class PlotIRSpectroscopy(Function):
	"""
	The allowed input signatures of PlotIRSpectroscopy without optional arguments (kwargs) are:

	``PlotIRSpectroscopy(IRData, **kwargs)`` generates a graphical plot of the spectrum stored in the input IR spectroscopy data object.

	:param IRData: IRSpectroscopy object you wish to plot.
	:param `**kwargs`: optional arguments for PlotIRSpectroscopy.
	:returns: Plot - A graphical representation of the spectra.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotirspectroscopy.
	"""


class PlotPowderXRD(Function):
	"""
	The allowed input signatures of PlotPowderXRD without optional arguments (kwargs) are:

	``PlotPowderXRD(PowderXRDData, **kwargs)`` returns a plot of intensity vs 2θ from a supplied 'PowderXRDData' object.

	:param PowderXRDData: Powder X-ray diffraction data you wish to plot.
	:param `**kwargs`: optional arguments for PlotPowderXRD.
	:returns: Plot - The plot of the X-ray diffraction intensity as a function of 2θ.

	``PlotPowderXRD(RawDiffractionData, **kwargs)`` returns a plot of intensity vs 2θ from a supplied 'RawDiffractionData' value.

	:param RawDiffractionData: Raw powder X-ray diffraction data you wish to plot.
	:param `**kwargs`: optional arguments for PlotPowderXRD.
	:returns: Plot - The plot of the X-ray diffraction intensity as a function of 2θ.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotpowderxrd.
	"""


class PlotRamanSpectroscopy(Function):
	"""
	The allowed input signatures of PlotRamanSpectroscopy without optional arguments (kwargs) are:

	``PlotRamanSpectroscopy(RamanSpectroscopyData, **kwargs)`` plots the average collected Raman spectrum, Raman spectra from each sampling point, and the sampling pattern for 'RamanSpectroscopyData'.

	:param RamanSpectroscopyData: The Raman spectroscopy data objects.
	:param `**kwargs`: optional arguments for PlotRamanSpectroscopy.
	:returns: Fig - Figures showing the average of all collected spectra, overlaid spectra, and the sampling patterns used to collect the data.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotramanspectroscopy.
	"""


class PlotBioLayerInterferometry(Function):
	"""
	The allowed input signatures of PlotBioLayerInterferometry without optional arguments (kwargs) are:

	``PlotBioLayerInterferometry(Data, **kwargs)`` plots the data contained in 'Data' as appropriate for the type of assay the data was generated from.

	:param Data: A BioLayerInterferometry data or protocol.
	:param `**kwargs`: optional arguments for PlotBioLayerInterferometry.
	:returns: Figure - A plot or multiple plots displaying the results of the biolayer interferometry assay.

	``PlotBioLayerInterferometry(Protocol, **kwargs)`` plots the data contained in 'Protocol' as appropriate for the type of assay the data was generated from.

	:param Protocol: A BioLayerInterferometry protocol with associated data.
	:param `**kwargs`: optional arguments for PlotBioLayerInterferometry.
	:returns: Figure - A plot or multiple plots displaying the results of the biolayer interferometry assay.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotbiolayerinterferometry.
	"""


class PlotBindingKinetics(Function):
	"""
	The allowed input signatures of PlotBindingKinetics without optional arguments (kwargs) are:

	``PlotBindingKinetics(Analysis, **kwargs)`` plots the association and dissociation data in 'Analysis' with predicted kinetic trajectories overlayed.

	:param Analysis: An analysis object which fitted association and dissociation binding curves.
	:param `**kwargs`: optional arguments for PlotBindingKinetics.
	:returns: Plot - The kinetics predicted trajectories plotted with the experimental data.

	``PlotBindingKinetics(Data, **kwargs)`` plots the association and dissociation curves associated with 'Data' with predicted kinetic trajectories overlayed.

	:param Data: An analysis object which fitted association and dissociation binding curves.
	:param `**kwargs`: optional arguments for PlotBindingKinetics.
	:returns: Plot - The kinetics predicted trajectories plotted with the experimental data.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotbindingkinetics.
	"""


class PlotBindingQuantitation(Function):
	"""
	The allowed input signatures of PlotBindingQuantitation without optional arguments (kwargs) are:

	``PlotBindingQuantitation(AnalysisObject, **kwargs)`` plots the bio-layer thickness during the quantitation step of a bio-layer interferometry assay.

	:param AnalysisObject: An analysis object which contains the standard curve and fitting information.
	:param `**kwargs`: optional arguments for PlotBindingQuantitation.
	:returns: Plot - Plots of the standard curve and fitting of the standards and sample used to derive the standard curve.

	``PlotBindingQuantitation(DataObject, **kwargs)`` plots the bio-layer thickness during the quantitation step of a bio-layer interferometry assay.

	:param DataObject: A data object which contains analysis objects.
	:param `**kwargs`: optional arguments for PlotBindingQuantitation.
	:returns: Plot - Plots of the standard curve and fitting of the standards and sample used to derive the standard curve.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotbindingquantitation.
	"""


class PlotEpitopeBinning(Function):
	"""
	The allowed input signatures of PlotEpitopeBinning without optional arguments (kwargs) are:

	``PlotEpitopeBinning(Analysis, **kwargs)`` creates a 'Plot' with a graph indicating the grouping of samples with respect to their interaction with a particular target in 'Analysis' object.

	:param Analysis: An analysis object which contains interaction strengths and grouped samples.
	:param `**kwargs`: optional arguments for PlotEpitopeBinning.
	:returns: Plot - Graphs indicating the grouping of the samples with respect to their binding to a particular target.

	``PlotEpitopeBinning(Protocol, **kwargs)`` creates a 'Plot' with a graph indicating the grouping of samples with respect to their interaction with a particular target derived from analyzed data related to 'Protocol' object.

	:param Protocol: A protocol object which contains analyzed data with interaction strengths and grouped samples.
	:param `**kwargs`: optional arguments for PlotEpitopeBinning.
	:returns: Plot - Graphs indicating the grouping of the samples with respect to their binding to a particular target.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotepitopebinning.
	"""


class PlotChromatography(Function):
	"""
	The allowed input signatures of PlotChromatography without optional arguments (kwargs) are:

	``PlotChromatography(DataObject, **kwargs)`` provides an interactive plot of the data in the chromatography object.

	:param DataObject: The piece of data that should be analyzed by PlotChromatography.
	:param `**kwargs`: optional arguments for PlotChromatography.
	:returns: Plot - An interactive plot of the chromatograph.

	``PlotChromatography(Chromatograph, **kwargs)`` provides plots for chromatographic data.

	:param Chromatograph: The chromatographic data you wish to plot.
	:param `**kwargs`: optional arguments for PlotChromatography.
	:returns: Plot - An interactive plot of the chromatograph.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotchromatography.
	"""


class PlotChromatographyMassSpectra(Function):
	"""
	The allowed input signatures of PlotChromatographyMassSpectra without optional arguments (kwargs) are:

	``PlotChromatographyMassSpectra(DataObject, **kwargs)`` displays either a 2D (sliced) or 3D (waterfall) plot of the LCMS data in the supplied 'DataObject'.

	:param DataObject: Object(s) containing the LCMS data to be plotted.
	:param `**kwargs`: optional arguments for PlotChromatographyMassSpectra.
	:returns: Plot - Plot(s) of the LCMS data in the input data object(s).

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotchromatographymassspectra.
	"""


class PlotFractions(Function):
	"""
	The allowed input signatures of PlotFractions without optional arguments (kwargs) are:

	``PlotFractions(Analysis, **kwargs)`` plots a Chromatogram with fraction epilogs.

	:param Analysis: An Object[Analysis,Fractions] associated with the chromatogram and fractions to plot.
	:param `**kwargs`: optional arguments for PlotFractions.
	:returns: Plot - A chromatograph plot with fractions highlighted.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotfractions.
	"""


class PlotGradient(Function):
	"""
	The allowed input signatures of PlotGradient without optional arguments (kwargs) are:

	``PlotGradient(GradientObject, **kwargs)`` plots the buffer compositions as a function of time for a 'GradientObject'.

	:param GradientObject: A Object[Method,Gradient] object.
	:param `**kwargs`: optional arguments for PlotGradient.
	:returns: Plot - A ListLinePlot of buffer composition.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotgradient.
	"""


class PlotLadder(Function):
	"""
	The allowed input signatures of PlotLadder without optional arguments (kwargs) are:

	``PlotLadder(Analysis, **kwargs)`` plots the standard peak points in 'ladder' alongside a standard curve fit to either molecular weight (ExpectedSize) or position (ExpectedPosition).

	:param Analysis: An Object[Analysis,Ladder] of the ladder to plot.
	:param `**kwargs`: optional arguments for PlotLadder.
	:returns: Plot - A plot of the standard peak points with a fitted function overlayed, if specified.

	``PlotLadder(Data, **kwargs)`` plots the standard peak points in 'ladder' alongside a standard curve fit to either molecular weight (ExpectedSize) or position (ExpectedPosition).

	:param Data: A list of pairs relating strand length to peak position.
	:param `**kwargs`: optional arguments for PlotLadder.
	:returns: Plot - A plot of the standard peak points with a fitted function overlayed, if specified.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotladder.
	"""


class PlotCrossFlowFiltration(Function):
	"""
	The allowed input signatures of PlotCrossFlowFiltration without optional arguments (kwargs) are:

	``PlotCrossFlowFiltration(DataObject, **kwargs)`` plots the data collected during ExperimentCrossFlowFiltration.

	:param DataObject: Data object from ExperimentCrossFlowFiltration.
	:param `**kwargs`: optional arguments for PlotCrossFlowFiltration.
	:returns: Plots - Graphical representation of the data collected during ExperimentCrossFlowFiltration.

	``PlotCrossFlowFiltration(DataObjects, **kwargs)`` plots the data collected during ExperimentCrossFlowFiltration.

	:param DataObjects: Data object from ExperimentCrossFlowFiltration.
	:param `**kwargs`: optional arguments for PlotCrossFlowFiltration.
	:returns: Plots - Graphical representation of the data collected during ExperimentCrossFlowFiltration.

	``PlotCrossFlowFiltration(ProtocolObject, **kwargs)`` plots the data collected during ExperimentCrossFlowFiltration.

	:param ProtocolObject: Protocol object from a completed ExperimentCrossFlowFiltration.
	:param `**kwargs`: optional arguments for PlotCrossFlowFiltration.
	:returns: Plots - Graphical representation of the data collected during ExperimentCrossFlowFiltration.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotcrossflowfiltration.
	"""


class PlotGating(Function):
	"""
	The allowed input signatures of PlotGating without optional arguments (kwargs) are:

	``PlotGating(GateObject, **kwargs)`` generates a plot from the clustered data in the provided 'GateObject'.

	:param GateObject: An Object or Packet containing or associated with clustered data.
	:param `**kwargs`: optional arguments for PlotGating.
	:returns: Plot - A plot showing the clustered input data associated with 'gateObject'.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotgating.
	"""


class PlotAgarose(Function):
	"""
	The allowed input signatures of PlotAgarose without optional arguments (kwargs) are:

	``PlotAgarose(AgaroseDataObject, **kwargs)`` plots the 'AgaroseDataObject' SampleElectropherogram as a list line plot.

	:param AgaroseDataObject: The Object[Data,AgaroseGelElectrophoresis] object to be plotted.
	:param `**kwargs`: optional arguments for PlotAgarose.
	:returns: Plot - A graphical representation of the data as a list line plot.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotagarose.
	"""


class PlotPAGE(Function):
	"""
	The allowed input signatures of PlotPAGE without optional arguments (kwargs) are:

	``PlotPAGE(PageData, **kwargs)`` returns a pixel intensity plot of the LaneImage of the given 'PageData', with LaneImage across top of plot.

	:param PageData: An image or graphic to plot pixel intensity from.
	:param `**kwargs`: optional arguments for PlotPAGE.
	:returns: Plot - The plot of the luminescence trajectory.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotpage.
	"""


class PlotWestern(Function):
	"""
	The allowed input signatures of PlotWestern without optional arguments (kwargs) are:

	``PlotWestern(Western, **kwargs)`` plots the 'Western' MassSpectrum as a list line plot.

	:param Western: The Object[Data,Western] object to be plotted.
	:param `**kwargs`: optional arguments for PlotWestern.
	:returns: SpectralPlot - A graphical representation of the data as a list line plot.

	``PlotWestern(Spectrum, **kwargs)`` plots the 'Spectrum' as a list line plot.

	:param Spectrum: A graphical representation of the data as a list line plot.
	:param `**kwargs`: optional arguments for PlotWestern.
	:returns: SpectralPlot - A graphical representation of the data as a list line plot.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotwestern.
	"""


class PlotCapillaryGelElectrophoresisSDS(Function):
	"""
	The allowed input signatures of PlotCapillaryGelElectrophoresisSDS without optional arguments (kwargs) are:

	``PlotCapillaryGelElectrophoresisSDS(DataObject, **kwargs)`` generates a graphical plot of the data stored in a CapillaryGelElectrophoresisSDS data object.

	:param DataObject: The CapillaryGelElectrophoresisSDS data to be plotted.
	:param `**kwargs`: optional arguments for PlotCapillaryGelElectrophoresisSDS.
	:returns: Plot - A graphical representation of the protein separation trace.

	``PlotCapillaryGelElectrophoresisSDS(Chromatograph, **kwargs)`` generates a graphical plot of the provided CapillaryGelElectrophoresisSDS data.

	:param Electrophoratogram: The electrophoresis data you wish to plot.
	:param `**kwargs`: optional arguments for PlotCapillaryGelElectrophoresisSDS.
	:returns: Plot - A graphical representation of the protein separation trace.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotcapillarygelelectrophoresissds.
	"""


class PlotCapillaryIsoelectricFocusing(Function):
	"""
	The allowed input signatures of PlotCapillaryIsoelectricFocusing without optional arguments (kwargs) are:

	``PlotCapillaryIsoelectricFocusing(DataObject, **kwargs)`` generates a graphical plot of the data stored in a CapillaryIsoelectricFocusing data object.

	:param DataObject: The CapillaryIsoelectricFocusing data to be plotted.
	:param `**kwargs`: optional arguments for PlotCapillaryIsoelectricFocusing.
	:returns: Plot - A graphical representation of the protein separation trace.

	``PlotCapillaryIsoelectricFocusing(Chromatograph, **kwargs)`` generates a graphical plot of the provided CapillaryIsoelectricFocusing data.

	:param Electrophoratogram: The electrophoresis data you wish to plot.
	:param `**kwargs`: optional arguments for PlotCapillaryIsoelectricFocusing.
	:returns: Plot - A graphical representation of the protein separation trace.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotcapillaryisoelectricfocusing.
	"""


class PlotCapillaryIsoelectricFocusingEvolution(Function):
	"""
	The allowed input signatures of PlotCapillaryIsoelectricFocusingEvolution without optional arguments (kwargs) are:

	``PlotCapillaryIsoelectricFocusingEvolution(DataObject, **kwargs)`` generates a graphical plot of the separation evolution data stored in a CapillaryIsoelectricFocusing data object.

	:param DataObject: The CapillaryIsoelectricFocusing data to be plotted.
	:param `**kwargs`: optional arguments for PlotCapillaryIsoelectricFocusingEvolution.
	:returns: Plot - A graphical representation of the evolution of protein separation in isoelectric focusing over time.

	``PlotCapillaryIsoelectricFocusingEvolution(Chromatograph, **kwargs)`` generates a graphical plot of the provided CapillaryIsoelectricFocusing separation data over time.

	:param Electrophoratogram: The electrophoresis data you wish to plot over time.
	:param `**kwargs`: optional arguments for PlotCapillaryIsoelectricFocusingEvolution.
	:returns: Plot - A graphical representation of the evolution of protein separation in isoelectric focusing over time.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotcapillaryisoelectricfocusingevolution.
	"""


class PlotAbsorbanceKinetics(Function):
	"""
	The allowed input signatures of PlotAbsorbanceKinetics without optional arguments (kwargs) are:

	``PlotAbsorbanceKinetics(SpectroscopyObjects, **kwargs)`` provides a graphical plot of the trajectory stored in the object 'SpectroscopyObjects'.

	:param SpectroscopyObjects: One or more objects containing absorbance spectra.
	:param `**kwargs`: optional arguments for PlotAbsorbanceKinetics.
	:returns: Plot - A graphical representation of the spectra.

	``PlotAbsorbanceKinetics(Spectrum, **kwargs)`` provides a graphical plot of the provided spectrum.

	:param Spectrum: The spectrum you wish to plot.
	:param `**kwargs`: optional arguments for PlotAbsorbanceKinetics.
	:returns: Plot - A graphical representation of the spectrum.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotabsorbancekinetics.
	"""


class PlotFluorescenceKinetics(Function):
	"""
	The allowed input signatures of PlotFluorescenceKinetics without optional arguments (kwargs) are:

	``PlotFluorescenceKinetics(FluorescenceKineticsData, **kwargs)`` displays fluorescence intensity vs time for the supplied 'FluorescenceKineticsData'.

	:param FluorescenceKineticsData: Fluorescence kinetics data you wish to plot.
	:param `**kwargs`: optional arguments for PlotFluorescenceKinetics.
	:returns: Plot - Plot of the Fluorescence trajectory.

	``PlotFluorescenceKinetics(Trajectory, **kwargs)`` displays fluorescence intensity vs time when given a raw data 'Trajectory'.

	:param Trajectory: Raw trajectory data you wish to plot.
	:param `**kwargs`: optional arguments for PlotFluorescenceKinetics.
	:returns: Plot - Plot of the Fluorescence trajectory.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotfluorescencekinetics.
	"""


class PlotLuminescenceKinetics(Function):
	"""
	The allowed input signatures of PlotLuminescenceKinetics without optional arguments (kwargs) are:

	``PlotLuminescenceKinetics(LuminescenceKineticsData, **kwargs)`` displays emission trajectories from the supplied 'LuminescenceKineticsData'.

	:param LuminescenceKineticsData: One or more Object[Data,LuminescenceKinetics] objects containing emission trajectories.
	:param `**kwargs`: optional arguments for PlotLuminescenceKinetics.
	:returns: Plot - The plot of the emission trajectory.

	``PlotLuminescenceKinetics(EmissionTrajectoryData, **kwargs)`` displays luminescence vs time when given a set of raw 'emissionTrajectories'.

	:param EmissionTrajectoryData: One or more sets of 2D coordinate pairs representing luminescence emission trajectories.
	:param `**kwargs`: optional arguments for PlotLuminescenceKinetics.
	:returns: Plot - The plot of the emission trajectory.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotluminescencekinetics.
	"""


class PlotKineticRates(Function):
	"""
	The allowed input signatures of PlotKineticRates without optional arguments (kwargs) are:

	``PlotKineticRates(KineticsObject, **kwargs)`` plots the rate fitting analysis found in the kinetics analysis 'KineticsObject'.

	:param KineticsObject: The analysis object which is the output of kinetics analysis performed with AnalyzeKinetics.
	:param `**kwargs`: optional arguments for PlotKineticRates.
	:returns: Plot - Plot showing the quality of the rate fitting analysis.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotkineticrates.
	"""


class PlotNephelometryKinetics(Function):
	"""
	The allowed input signatures of PlotNephelometryKinetics without optional arguments (kwargs) are:

	``PlotNephelometryKinetics(DataObject, **kwargs)`` displays a plot of the raw relative nephelometric measurement values versus time from the supplied 'DataObject'. If samples were diluted, a 3D plot can be plotted to display raw relative nephelometric measurement values versus time versus concentration.

	:param DataObject: NephelometryKinetics data that will be plotted.
	:param `**kwargs`: optional arguments for PlotNephelometryKinetics.
	:returns: Plot - The plots of the NephelometryKinetics data.

	``PlotNephelometryKinetics(ProtocolObject, **kwargs)`` plots of the data collected during an ExperimentNephelometryKinetics.

	:param ProtocolObject: Protocol object from a completed ExperimentNephelometryKinetics.
	:param `**kwargs`: optional arguments for PlotNephelometryKinetics.
	:returns: Plots - Graphical representation of the turbidity data collected during ExperimentNephelometryKinetics.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotnephelometrykinetics.
	"""


class PlotTrajectory(Function):
	"""
	The allowed input signatures of PlotTrajectory without optional arguments (kwargs) are:

	``PlotTrajectory(Trajectory, **kwargs)`` plots the concentration of all species in 'Trajectory' versus time.

	:param Trajectory: One or more Object[Simulation,Kinetics] objects or numeric trajectories to plot.
	:param `**kwargs`: optional arguments for PlotTrajectory.
	:returns: Plot - A visualization of the time evolution of species concentrations.

	``PlotTrajectory(Trajectory,Species, **kwargs)`` plots only the concentrations of 'Species'.

	:param Trajectory: One or more Object[Simulation,Kinetics] objects or numeric trajectories to plot.
	:param Species: A list of species to be plotted.
	:param `**kwargs`: optional arguments for PlotTrajectory.
	:returns: Plot - A visualization of the time evolution of species concentrations.

	``PlotTrajectory(Trajectory,Indices, **kwargs)`` plots only the species in 'Trajectory' whose positions match the 'Indices'.

	:param Trajectory: One or more Object[Simulation,Kinetics] objects or numeric trajectories to plot.
	:param Indices: A list of indicies of species to plot.
	:param `**kwargs`: optional arguments for PlotTrajectory.
	:returns: Plot - A visualization of the time evolution of species concentrations.

	``PlotTrajectory(Trajectory,N, **kwargs)`` plots only the 'N' most abundant species. If 'N'<0, plots the 'N' least abundant species.

	:param Trajectory: One or more Object[Simulation,Kinetics] objects or numeric trajectories to plot.
	:param N: The number of species to plot (most abundant if n>0, or least abundant if n<0).
	:param `**kwargs`: optional arguments for PlotTrajectory.
	:returns: Plot - A visualization of the time evolution of species concentrations.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plottrajectory.
	"""


class PlotCellCount(Function):
	"""
	The allowed input signatures of PlotCellCount without optional arguments (kwargs) are:

	``PlotCellCount(CellCounts, **kwargs)`` generates a graphical representation of the number of cells in 'CellCounts'.

	:param CellCounts: One or more Object[Analysis,CellCount] objects or a list of raw cell counts.
	:param `**kwargs`: optional arguments for PlotCellCount.
	:returns: Plot - A graphical representation of 'cellCounts'.

	``PlotCellCount(MicroscopeData, **kwargs)`` generates a graphical representation of the number of cells in 'MicroscopeData'.

	:param MicroscopeData: The Object[Data,Microscope] object to be plotted.
	:param `**kwargs`: optional arguments for PlotCellCount.
	:returns: Plot - A graphical representation of the number of cells in the input data.

	``PlotCellCount(Image, Components, **kwargs)`` generates a graphical representation of the number of cells in 'Image'.

	:param Image: An image from an Object[Data,Microscope].
	:param Components: Components from an image of cells.
	:param `**kwargs`: optional arguments for PlotCellCount.
	:returns: Plot - A graphical representation of the number of cells in the input data.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotcellcount.
	"""


class PlotCellCountSummary(Function):
	"""
	The allowed input signatures of PlotCellCountSummary without optional arguments (kwargs) are:

	``PlotCellCountSummary(CellCount, **kwargs)`` returns a 'Plot' of the cell counts from a 'CellCount' Object or Packet.

	:param CellCount: An Object[Analysis,CellCount] Object or Packet.
	:param `**kwargs`: optional arguments for PlotCellCountSummary.
	:returns: Plot - A plot of the cell count.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotcellcountsummary.
	"""


class PlotMicroscope(Function):
	"""
	The allowed input signatures of PlotMicroscope without optional arguments (kwargs) are:

	``PlotMicroscope(ImageObject, **kwargs)`` creates a graphical display of the images associated with the provided 'ImageObject'.

	:param ImageObject: The Object[Data,Microscope] object to be plotted.
	:param `**kwargs`: optional arguments for PlotMicroscope.
	:returns: Plot - A graphical display of the provided 'imageObject'.

	``PlotMicroscope(CellModels, **kwargs)`` creates a graphical display of the images associated with the provided 'CellModels'.

	:param CellModels: The Model[Sample] that has Microscope images in its ReferenceImages field to be plotted.
	:param `**kwargs`: optional arguments for PlotMicroscope.
	:returns: Plot - A graphical display of the provided 'cellModels'.

	``PlotMicroscope(CellObjects, **kwargs)`` creates a graphical display of the images associated with the provided 'CellObjects'.

	:param CellObjects: The Model[Sample] that has Microscope images in its ReferenceImages field to be plotted.
	:param `**kwargs`: optional arguments for PlotMicroscope.
	:returns: Plot - A graphical display of the provided 'cellModels'.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotmicroscope.
	"""


class PlotMicroscopeOverlay(Function):
	"""
	The allowed input signatures of PlotMicroscopeOverlay without optional arguments (kwargs) are:

	``PlotMicroscopeOverlay(Overlay, **kwargs)`` plots a microscope image within a zoomable frame.

	:param Overlay: An Object[Analysis,MicroscopeOverlay] object.
	:param `**kwargs`: optional arguments for PlotMicroscopeOverlay.
	:returns: Plot - An overlayed false colored image of the different microscope image channels.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotmicroscopeoverlay.
	"""


class PlotProbeConcentration(Function):
	"""
	The allowed input signatures of PlotProbeConcentration without optional arguments (kwargs) are:

	``PlotProbeConcentration(ProbeSimulation, **kwargs)`` plots probe accessibility along the target sequence in the provided 'ProbeSimulation' object.

	:param ProbeSimulation: An Object[Simulation, ProbeSelection] or Object[Simulation, PrimerSet] which contains binding information for selected probes and primers.
	:param `**kwargs`: optional arguments for PlotProbeConcentration.
	:returns: Plot - A plot showing the concentration of correctly bound probes along the target sequence.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotprobeconcentration.
	"""


class PlotReactionMechanism(Function):
	"""
	The allowed input signatures of PlotReactionMechanism without optional arguments (kwargs) are:

	``PlotReactionMechanism(Network, **kwargs)`` converts a reaction 'Network' into a 'Plot' displaying all reactions and rates.

	:param Network: A reaction mechanism to be visualized with a graph.
	:param `**kwargs`: optional arguments for PlotReactionMechanism.
	:returns: Plot - Rendition of the reaction network you input.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotreactionmechanism.
	"""


class PlotState(Function):
	"""
	The allowed input signatures of PlotState without optional arguments (kwargs) are:

	``PlotState(EquilibriumObject, **kwargs)`` constructs a PieChart describing the relative concentrations of each species in 'EquilibriumObject'.

	:param EquilibriumObject: An Object[Simulation,Equilibrium] object containing multiple chemical species.
	:param `**kwargs`: optional arguments for PlotState.
	:returns: Plot - A PieChart of the equilibrium distribution of species concentrations.

	``PlotState(State, **kwargs)`` constructs a PieChart describing the relative concentrations of each species in 'State'.

	:param State: A snapshot of species molecular abundances at a single point in time.
	:param `**kwargs`: optional arguments for PlotState.
	:returns: Plot - A PieChart of the distribution of concentrations of each species in the state.

	``PlotState(Concentrations,Species, **kwargs)`` constructs the PieChart given lists of 'Concentrations' and 'Species'.

	:param Concentrations: A list of molecular abundances.
	:param Species: A list of molecular components.
	:param `**kwargs`: optional arguments for PlotState.
	:returns: Plot - A PieChart of the distribution of concentrations of each species in the state.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotstate.
	"""


class PlotPeptideFragmentationSpectra(Function):
	"""
	The allowed input signatures of PlotPeptideFragmentationSpectra without optional arguments (kwargs) are:

	``PlotPeptideFragmentationSpectra(Simulation, **kwargs)`` generates an interactive 'Plot' representing a mass spectrum 'Simulation' for the sample linked in the simulation object.

	:param Simulation: An Object[Simulation, FragmentationSpectra] that contains the results of a simulated mass spectroscopy experiment for one or more peptides.
	:param `**kwargs`: optional arguments for PlotPeptideFragmentationSpectra.
	:returns: Plot - The interactive plot that contains simulated intensities that can be clicked on to reveal the fragment that the peak represents.

	``PlotPeptideFragmentationSpectra(Spectrum, **kwargs)`` generates an interactive 'Plot' representing a mass 'Spectrum'.

	:param Spectrum: An Object[MassFragmentationSpectrum] that contains the results of a simulated mass spectrometry experiment for a single peptide.
	:param `**kwargs`: optional arguments for PlotPeptideFragmentationSpectra.
	:returns: Plot - The interactive plot that contains simulated intensities that can be clicked on to reveal the fragment that the peak represents.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotpeptidefragmentationspectra.
	"""


class PlotqPCR(Function):
	"""
	The allowed input signatures of PlotqPCR without optional arguments (kwargs) are:

	``PlotqPCR(QPCRData, **kwargs)`` plots the normalized and baseline-subtracted amplification curves from 'QPCRData'.

	:param QPCRData: The quantitative polymerase chain reaction (qPCR) data objects.
	:param `**kwargs`: optional arguments for PlotqPCR.
	:returns: Fig - The quantitative polymerase chain reaction (qPCR) plot.

	``PlotqPCR(MeltingPointAnalysis, **kwargs)`` plots the negative derivative of the melting curve data 'MeltingPointAnalysis'.

	:param MeltingPointAnalysis: The analysis of the melting curve of an Object[Data, qPCR].
	:param `**kwargs`: optional arguments for PlotqPCR.
	:returns: Fig - The negative derivative of the melting curve in an Object[Data, qPCR].

	``PlotqPCR(AmplificationCurveData, **kwargs)`` plots raw 'AmplificationCurveData'.

	:param AmplificationCurveData: The raw data points.
	:param `**kwargs`: optional arguments for PlotqPCR.
	:returns: Fig - The quantitative polymerase chain reaction (qPCR) plot.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotqpcr.
	"""


class PlotCopyNumber(Function):
	"""
	The allowed input signatures of PlotCopyNumber without optional arguments (kwargs) are:

	``PlotCopyNumber(CopyNumbers, **kwargs)`` plots the standard curve and Log10[copy number] from each copy number analysis object in 'CopyNumbers'.

	:param CopyNumbers: One or more copy number analysis objects.
	:param `**kwargs`: optional arguments for PlotCopyNumber.
	:returns: Fig - A line plot of quantification cycle versus copy number.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotcopynumber.
	"""


class PlotQuantificationCycle(Function):
	"""
	The allowed input signatures of PlotQuantificationCycle without optional arguments (kwargs) are:

	``PlotQuantificationCycle(QuantificationCycles, **kwargs)`` plots the normalized and baseline-subtracted amplification curve and quantification cycle from each quantification cycle analysis object in 'QuantificationCycles'.

	:param QuantificationCycles: One or more quantification cycle analysis objects.
	:param `**kwargs`: optional arguments for PlotQuantificationCycle.
	:returns: Fig - The quantification cycle plot.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotquantificationcycle.
	"""


class PlotDigitalPCR(Function):
	"""
	The allowed input signatures of PlotDigitalPCR without optional arguments (kwargs) are:

	``PlotDigitalPCR(Data, **kwargs)`` creates a 'Plot' using fluorescence signal amplitude values for droplets in 'Data'.

	:param Data: The object(s) or packet(s) containing digital PCR raw droplet amplitudes.
	:param `**kwargs`: optional arguments for PlotDigitalPCR.
	:returns: Plot - The figure generated from digital PCR data.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotdigitalpcr.
	"""


class PlotConductivity(Function):
	"""
	The allowed input signatures of PlotConductivity without optional arguments (kwargs) are:

	``PlotConductivity(ConductivityData, **kwargs)`` generates a graphical plot of the data stored in the pH data object.

	:param ConductivityData: The Conductivity Data object(s) you wish to plot.
	:param `**kwargs`: optional arguments for PlotConductivity.
	:returns: Plot - A graphical representation of the spectra.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotconductivity.
	"""


class PlotpH(Function):
	"""
	The allowed input signatures of PlotpH without optional arguments (kwargs) are:

	``PlotpH(PHData, **kwargs)`` generates a graphical plot of the data stored in the pH data object.

	:param PHData: The pH Data object(s) you wish to plot.
	:param `**kwargs`: optional arguments for PlotpH.
	:returns: Plot - A graphical representation of the spectra.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotph.
	"""


class PlotSensor(Function):
	"""
	The allowed input signatures of PlotSensor without optional arguments (kwargs) are:

	``PlotSensor(SensorDataObject, **kwargs)`` plot sensor data from 'SensorDataObject'.

	:param SensorDataObject: Sensor Data object.
	:param `**kwargs`: optional arguments for PlotSensor.
	:returns: Plot - The plot of the sensor data.

	``PlotSensor(Data, **kwargs)`` plot sensor data from raw 'Data'.

	:param Data: A list of {{date,y}..} coordinates.
	:param `**kwargs`: optional arguments for PlotSensor.
	:returns: Plot - The plot of the sensor data.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotsensor.
	"""


class PlotVacuumEvaporation(Function):
	"""
	The allowed input signatures of PlotVacuumEvaporation without optional arguments (kwargs) are:

	``PlotVacuumEvaporation(LyophilizationData, **kwargs)`` provides a date trace 'Plot' for the given 'LyophilizationData'.

	:param LyophilizationData: VacuumEvaporation data object(s) containing the pressure and temperature data to be plotted.
	:param `**kwargs`: optional arguments for PlotVacuumEvaporation.
	:returns: Plot - The plots of the pressure and temperature traces.

	``PlotVacuumEvaporation(PressureTrace,TemperatureTrace, **kwargs)`` provides 'Plot' of the given 'PressureTrace' and 'TemperatureTrace'.

	:param PressureTrace: Pressure trace data from a lyophilization run.
	:param TemperatureTrace: Temperature trace data from a lyophilization run.
	:param `**kwargs`: optional arguments for PlotVacuumEvaporation.
	:returns: Plot - The plots of the pressure and temperature traces.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotvacuumevaporation.
	"""


class PlotVolume(Function):
	"""
	The allowed input signatures of PlotVolume without optional arguments (kwargs) are:

	``PlotVolume(VolumeCheckData, **kwargs)`` provides a graphical plot the provided Volume data's distributions either in the form of a histogram or a box and wisker plot.

	:param VolumeCheckData: The Volume data objects containing the readings you wish to plot.
	:param `**kwargs`: optional arguments for PlotVolume.
	:returns: Plot - A graphical representation of the distribution(s) of intensities provided.

	``PlotVolume(Readings, **kwargs)`` provides a graphical plot the provided Volume data's distributions either in the form of a histogram or a box and wisker plot.

	:param Readings: Volume readings you wish to plot.
	:param `**kwargs`: optional arguments for PlotVolume.
	:returns: Plot - A graphical representation of the distribution(s) of intensities provided.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotvolume.
	"""


class PlotDissolvedOxygen(Function):
	"""
	The allowed input signatures of PlotDissolvedOxygen without optional arguments (kwargs) are:

	``PlotDissolvedOxygen(DissolvedOxygenData, **kwargs)`` generates a graphical plot of the data stored in the dissolved oxygen data object.

	:param DissolvedOxygenData: The DissolvedOxygen Data object(s) you wish to plot.
	:param `**kwargs`: optional arguments for PlotDissolvedOxygen.
	:returns: Plot - A graphical representation of the spectra.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotdissolvedoxygen.
	"""


class PlotSurfaceTension(Function):
	"""
	The allowed input signatures of PlotSurfaceTension without optional arguments (kwargs) are:

	``PlotSurfaceTension(SurfaceTensionData, **kwargs)`` displays surface tension vs dilution factor for the supplied 'SurfaceTensionData'.

	:param SurfaceTensionData: Surface tension data you wish to plot.
	:param `**kwargs`: optional arguments for PlotSurfaceTension.
	:returns: Plot - The surface tension plot.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotsurfacetension.
	"""


class PlotCriticalMicelleConcentration(Function):
	"""
	The allowed input signatures of PlotCriticalMicelleConcentration without optional arguments (kwargs) are:

	``PlotCriticalMicelleConcentration(CriticalMicelleConcentrationAnalysis, **kwargs)`` plots the surface tension points in 'CriticalMicelleConcentrationAnalysis' with premicellar and postmicellar fits overlayed.

	:param CriticalMicelleConcentrationAnalysis: The critical micelle concentration analysis objects.
	:param `**kwargs`: optional arguments for PlotCriticalMicelleConcentration.
	:returns: Plot - The surface tension plot.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotcriticalmicelleconcentration.
	"""


class PlotDynamicFoamAnalysis(Function):
	"""
	The allowed input signatures of PlotDynamicFoamAnalysis without optional arguments (kwargs) are:

	``PlotDynamicFoamAnalysis(DataObject, **kwargs)`` displays plot of the collected foam data from the supplied 'DataObject', including the foam/liquid height and volume over time, the bubble count and bubble size over time, and the foam liquid content over time at each liquid conductivity module sensor.

	:param DataObject: Dynamic foam analysis data that will be plotted.
	:param `**kwargs`: optional arguments for PlotDynamicFoamAnalysis.
	:returns: Plot - The plots of the dynamic foam analysis data.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotdynamicfoamanalysis.
	"""


class PlotAbsorbanceThermodynamics(Function):
	"""
	The allowed input signatures of PlotAbsorbanceThermodynamics without optional arguments (kwargs) are:

	``PlotAbsorbanceThermodynamics(AbsorbanceThermodynamicsObject, **kwargs)`` provides a graphical plot of the melting and/or cooling curves stored in the data object.

	:param AbsorbanceThermodynamicsObject: The data object containing the melting and/or cooling curve data you wish to plot.
	:param `**kwargs`: optional arguments for PlotAbsorbanceThermodynamics.
	:returns: Plot - A graphical representation of the spectra.

	``PlotAbsorbanceThermodynamics(MeltingCurveData, **kwargs)`` provides a graphical plot of the melting curve.

	:param MeltingCurveData: The melting curve you wish to plot.
	:param `**kwargs`: optional arguments for PlotAbsorbanceThermodynamics.
	:returns: Plot - A graphical representation of the spectra.

	``PlotAbsorbanceThermodynamics(MeltingCurveData,CoolingCurveData, **kwargs)`` provides a graphical plot of the melting and cooling curve.

	:param MeltingCurveData: The melting curve you wish to plot.
	:param CoolingCurveData: The cooling curve you wish to plot.
	:param `**kwargs`: optional arguments for PlotAbsorbanceThermodynamics.
	:returns: Plot - A graphical representation of the spectra.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotabsorbancethermodynamics.
	"""


class PlotDifferentialScanningCalorimetry(Function):
	"""
	The allowed input signatures of PlotDifferentialScanningCalorimetry without optional arguments (kwargs) are:

	``PlotDifferentialScanningCalorimetry(DSCData, **kwargs)`` provides a graphical plot the provided 'DSCData' -- differential scanning calorimetry (DSC) spectra.

	:param DSCData: Differential scanning calorimetry data you wish to plot.
	:param `**kwargs`: optional arguments for PlotDifferentialScanningCalorimetry.
	:returns: Plot - The plot of the heating and cooling curves obtained from the provided data.

	``PlotDifferentialScanningCalorimetry(HeatingData, **kwargs)`` provides a graphical plot the provided 'heatingCurves'.

	:param HeatingData: Raw heating or cooling curves to be plotted.
	:param `**kwargs`: optional arguments for PlotDifferentialScanningCalorimetry.
	:returns: Plot - The plot of the heating and cooling curves obtained from the provided data.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotdifferentialscanningcalorimetry.
	"""


class PlotFluorescenceThermodynamics(Function):
	"""
	The allowed input signatures of PlotFluorescenceThermodynamics without optional arguments (kwargs) are:

	``PlotFluorescenceThermodynamics(FluorescenceThermodynamicsObject, **kwargs)`` plots the cooling and melting curves contained by 'FluorescenceThermodynamicsObject'.

	:param FluorescenceThermodynamicsObject: One or more Object[Data,FluorescenceThermodynamics] objects to be plotted.
	:param `**kwargs`: optional arguments for PlotFluorescenceThermodynamics.
	:returns: Plot - A 2D visualization of the melting curve.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotfluorescencethermodynamics.
	"""


class PlotMeltingPoint(Function):
	"""
	The allowed input signatures of PlotMeltingPoint without optional arguments (kwargs) are:

	``PlotMeltingPoint(MeltingObject, **kwargs)`` plots the melting curve and melting temperature that is found in the melting point analysis 'MeltingObject'.

	:param MeltingObject: The analysis object which is the output of melting point analysis performed with AnalyzeMeltingPoint.
	:param `**kwargs`: optional arguments for PlotMeltingPoint.
	:returns: Plot - Plot of melting curves and melting temperatures generated by melting point analysis.

	``PlotMeltingPoint(MeltingObjects, **kwargs)`` plots the melting curves and melting temperatures that are found in the melting point analyses 'MeltingObjects'.

	:param MeltingObjects: The analysis objects which is the output of melting point analysis performed with AnalyzeMeltingPoint.
	:param `**kwargs`: optional arguments for PlotMeltingPoint.
	:returns: Plot - Plot of melting curves and melting temperatures generated by melting point analysis.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotmeltingpoint.
	"""


class PlotThermodynamics(Function):
	"""
	The allowed input signatures of PlotThermodynamics without optional arguments (kwargs) are:

	``PlotThermodynamics(ThermoObject, **kwargs)`` generates a van't Hoff plot using the points and fit generated by thermodynamics analysis in 'ThermoObject'.

	:param ThermoObject: The analysis object which is the output of thermodynamics analysis performed with AnalyzeThermodynamics.
	:param `**kwargs`: optional arguments for PlotThermodynamics.
	:returns: VantHoffPlot - Plot of the van't Hoff fit generated by thermodynamic analysis.

	``PlotThermodynamics(ThermoObjects, **kwargs)`` generates van't Hoff plots using the points and fit generated by thermodynamic analyses in 'ThermoObjects'.

	:param ThermoObjects: The analysis objects which is the output of smoothing analysis performed with AnalyzeThermodynamics.
	:param `**kwargs`: optional arguments for PlotThermodynamics.
	:returns: VantHoffPlots - Plots of the van't Hoff fit generated by thermodynamic analyses.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotthermodynamics.
	"""


class PlotLocation(Function):
	"""
	The allowed input signatures of PlotLocation without optional arguments (kwargs) are:

	``PlotLocation(Obj, **kwargs)`` generates a plot of the location of an item 'Obj' within the ECL facility in which it is located.

	:param Obj: An item whose location within the ECL facility will be plotted.
	:param `**kwargs`: optional arguments for PlotLocation.
	:returns: Plot - A plot of the location of 'obj' within the ECL.

	``PlotLocation(Pos, **kwargs)`` generates a plot of the location of a position 'Pos' in its parent container within the ECL facility.

	:param Pos: A position in an item whose location within the ECL facility will be plotted.
	:param `**kwargs`: optional arguments for PlotLocation.
	:returns: Plot - A plot of the location of 'obj' within the ECL.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotlocation.
	"""


class PlotContents(Function):
	"""
	The allowed input signatures of PlotContents without optional arguments (kwargs) are:

	``PlotContents(Obj, **kwargs)`` generates a plot of an item 'Obj' and its immediate contents.

	:param Obj: An item whose contents will be plotted.
	:param `**kwargs`: optional arguments for PlotContents.
	:returns: Plot - A plot of 'obj' and its contents.

	``PlotContents(Mod, **kwargs)`` generates a plot of the physical layout of a container or instrument model 'Mod'.

	:param Mod: A container or instrument model whose layout will be plotted.
	:param `**kwargs`: optional arguments for PlotContents.
	:returns: Plot - A plot of 'obj' and its contents.

	``PlotContents(Pos, **kwargs)`` generates a plot of the location of a position 'Pos' in its parent container within the ECL facility.

	:param Pos: A position in an item whose contents will be plotted.
	:param `**kwargs`: optional arguments for PlotContents.
	:returns: Plot - A plot of 'obj' and its contents.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotcontents.
	"""


class PlotFit(Function):
	"""
	The allowed input signatures of PlotFit without optional arguments (kwargs) are:

	``PlotFit(Xy, F, **kwargs)`` overlays the fitted function 'F'[x] on the data points 'Xy'.

	:param Xy: List of raw data points that were fit to.
	:param F: The fitted function.
	:param `**kwargs`: optional arguments for PlotFit.
	:returns: Plot - A plot of the fitted function overlaid on the data (possibly with error bars).

	``PlotFit(Fit, **kwargs)`` overlays the fitted function from the 'Fit' object onto the data points used to construct the fit.

	:param Fit: A fit object or packet generated by AnalyzeFit[].
	:param `**kwargs`: optional arguments for PlotFit.
	:returns: Plot - A plot of the fitted function overlaid on the data (possibly with error bars).

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotfit.
	"""


class PlotPrediction(Function):
	"""
	The allowed input signatures of PlotPrediction without optional arguments (kwargs) are:

	``PlotPrediction(FitObject,InputValue, **kwargs)`` this function plots the result of the fitting analysis along with predicted value and distributions.

	:param FitObject: The analysis object which is the output of fit analysis performed with AnalyzeFit.
	:param InputValue: The coordinate value in the dataset that is used for finding the other coordinate prediction from the fit analysis. This is the first coordinate if Direction->Forward or second if Direction->Inverse.
	:param `**kwargs`: optional arguments for PlotPrediction.
	:returns: Fig - The resulting curves of fit analysis, along with dashed lines that show the input value and the prediction from the fit analysis.

	``PlotPrediction(FitObject,X, **kwargs)`` this function plots the result of the fitting analysis along with predicted value and distributions.

	:param FitObject: The analysis object which is the output of fit analysis performed with AnalyzeFit.
	:param X: The value of first entry in the coordinate set that is used for finding the second entry prediction from the fit analysis.
	:param Y: The value of the second entry in the coordinate set that is predicted from the fit analysis.
	:param `**kwargs`: optional arguments for PlotPrediction.
	:returns: Fig - The resulting curves of fit analysis, along with dashed lines that show the input value and the prediction from the fit analysis.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotprediction.
	"""


class PlotSmoothing(Function):
	"""
	The allowed input signatures of PlotSmoothing without optional arguments (kwargs) are:

	``PlotSmoothing(SmoothingObject, **kwargs)`` this function plots the curves available in 'SmoothingObject' which contains curves that are used for smoothing analysis overlaid with the smoothed curves and the local standard deviation of smoothed and original curve difference.

	:param SmoothingObject: The analysis object which is the output of smoothing analysis performed with AnalyzeSmoothing.
	:param `**kwargs`: optional arguments for PlotSmoothing.
	:returns: Plot - The resulting curves of smoothing analysis, including the original curve, smoothed curve, and the local standard deviation of the difference of the two.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotsmoothing.
	"""


class PlotStandardCurve(Function):
	"""
	The allowed input signatures of PlotStandardCurve without optional arguments (kwargs) are:

	``PlotStandardCurve(StandardCurve, **kwargs)`` plots a fitted standard curve alongside the data points it was applied to.

	:param StandardCurve: A standard curve analysis object (generated from AnalyzeStandardCurve) or packet.
	:param `**kwargs`: optional arguments for PlotStandardCurve.
	:returns: Plot - A plot of the fitted standard curve, the data points used to fit it, and the data that the standard was applied to.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotstandardcurve.
	"""


class PlotProtein(Function):
	"""
	The allowed input signatures of PlotProtein without optional arguments (kwargs) are:

	``PlotProtein(Protein, **kwargs)`` generates a ribbon diagram showing the structure of a 'Protein' model.

	:param Protein: A Protein model or object to be visualized.
	:param `**kwargs`: optional arguments for PlotProtein.
	:returns: Structure - A ribbon diagram of the protein structure.

	``PlotProtein(PdbID, **kwargs)`` generates a ribbon diagram showing the protein structure associated with 'PdbID' in the PDB.

	:param PdbID: The PDB ID number of the protein in the PDB database.
	:param `**kwargs`: optional arguments for PlotProtein.
	:returns: Structure - A ribbon diagram of the protein structure.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotprotein.
	"""


class PlotTranscript(Function):
	"""
	The allowed input signatures of PlotTranscript without optional arguments (kwargs) are:

	``PlotTranscript(Trans, **kwargs)`` provides a visualization of any stored structures of model transcripts in the input object.

	:param Trans: Transcript model you wish to visualize.
	:param `**kwargs`: optional arguments for PlotTranscript.
	:returns: Structure - Visualization of the structure of the transcript.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plottranscript.
	"""


class PlotVirus(Function):
	"""
	The allowed input signatures of PlotVirus without optional arguments (kwargs) are:

	``PlotVirus(Virus, **kwargs)`` provides a visualization of any stored image of the 'Virus', usually an electron microscope image, for a model 'Virus'.

	:param Virus: A Model[Sample] which contains the Virus model to visualize.
	:param `**kwargs`: optional arguments for PlotVirus.
	:returns: Plot - Visualization of the image stored for the virus model.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotvirus.
	"""


class PlotDNASequencing(Function):
	"""
	The allowed input signatures of PlotDNASequencing without optional arguments (kwargs) are:

	``PlotDNASequencing(DataObject, **kwargs)`` displays a plot of the raw relative fluorescence versus scan number from the supplied 'DataObject'.

	:param DataObject: DNA sequencing data that will be plotted.
	:param `**kwargs`: optional arguments for PlotDNASequencing.
	:returns: Plot - The plots of the DNA sequencing fluorescence data.

	``PlotDNASequencing(ProtocolObject, **kwargs)`` plots of the data collected during an ExperimentDNASequencing.

	:param ProtocolObject: Protocol object from a completed ExperimentDNASequencing.
	:param `**kwargs`: optional arguments for PlotDNASequencing.
	:returns: Plots - Graphical representation of the sequencing data collected during ExperimentDNASequencing.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotdnasequencing.
	"""


class PlotDNASequencingAnalysis(Function):
	"""
	The allowed input signatures of PlotDNASequencingAnalysis without optional arguments (kwargs) are:

	``PlotDNASequencingAnalysis(SequenceAnalysis, **kwargs)`` plots identified bases and quality values from a DNA sequencing analysis alongside the electropherograms the analysis was conducted on.

	:param SequenceAnalysis: A DNA sequencing analysis object (generated by AnalyzeDNASequencing), packet, or link.
	:param `**kwargs`: optional arguments for PlotDNASequencingAnalysis.
	:returns: Plot - A plot showing electropherogram peaks, the bases assigned to them, and the quality values of the assignments.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotdnasequencinganalysis.
	"""


class PlotELISA(Function):
	"""
	The allowed input signatures of PlotELISA without optional arguments (kwargs) are:

	``PlotELISA(ElisaData, **kwargs)`` displays the absorbance (ELISA), fluorescence (CapillaryELISA with customized cartridges) or analyte concentration (CapillaryELISA with pre-loaded cartridges) vs dilution factors for the supplied 'ElisaData'.

	:param ElisaData: ELISA data you wish to plot.
	:param `**kwargs`: optional arguments for PlotELISA.
	:returns: Plot - The ELISA plot of absorbance, fluorescence or analyte concentration.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotelisa.
	"""


class PlotFreezeCells(Function):
	"""
	The allowed input signatures of PlotFreezeCells without optional arguments (kwargs) are:

	``PlotFreezeCells(DataObject, **kwargs)`` plots the data collected during an ExperimentFreezeCells.

	:param DataObject: Data object from ExperimentFreezeCells.
	:param `**kwargs`: optional arguments for PlotFreezeCells.
	:returns: Plots - Graphical representation of the data collected for ControlledRateFreezer batches during ExperimentFreezeCells.

	``PlotFreezeCells(ProtocolObject, **kwargs)`` plots the data collected during an ExperimentFreezeCells.

	:param ProtocolObject: Protocol object from a completed ExperimentFreezeCells.
	:param `**kwargs`: optional arguments for PlotFreezeCells.
	:returns: Plots - Graphical representation of the data collected for ControlledRateFreezer batches during ExperimentFreezeCells.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/plotfreezecells.
	"""


class AnalyzeClusters(Function):
	"""
	The allowed input signatures of AnalyzeClusters without optional arguments (kwargs) are:

	``AnalyzeClusters(Data, **kwargs)`` partitions the data points contained in 'Data' into distinct similarity groups.

	:param Data: A rectangular matrix of data points to be partitioned by clustering.
	:param `**kwargs`: optional arguments for AnalyzeClusters.
	:returns: ClusteringObject - A Constellation object that contains both the identified similarity groups and the methodology used to detect them.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzeclusters.
	"""


class AnalyzeFit(Function):
	"""
	The allowed input signatures of AnalyzeFit without optional arguments (kwargs) are:

	``AnalyzeFit(Coordinates, FitType, **kwargs)`` fits a function 'F' of type 'FitType' to the given coordinates.

	:param Coordinates: The set of data points to fit to. Points can be numbers, quantities, distributions, or objects.
	:param FitType: Type of expression to fit, e.g. Polynomial or Exponential, or, a pure function to fit to.
	:param `**kwargs`: optional arguments for AnalyzeFit.
	:returns: F - The function of type 'fitType' that best fits the data 'xy'.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzefit.
	"""


class AnalyzePeaks(Function):
	"""
	The allowed input signatures of AnalyzePeaks without optional arguments (kwargs) are:

	``AnalyzePeaks(DataObject, **kwargs)`` finds peaks in the data from the field of 'DataObject' defined by the ReferenceField option, and computes peak properties such as Position, Height, Width, and Area.

	:param DataObject: Object containing data that will be analyzed for peaks.
	:param `**kwargs`: optional arguments for AnalyzePeaks.
	:returns: AnalysisObject - An analysis object containing information about peaks in the given data, including peak heights and areas.

	``AnalyzePeaks(Protocol, **kwargs)`` finds peaks in all DataObjects linked to the given 'Protocol', and computes peak properties such as Position, Height, Width, and Area.

	:param Protocol: Protocol object containing data that will be analyzed.
	:param `**kwargs`: optional arguments for AnalyzePeaks.
	:returns: AnalysisObject - An analysis object containing information about peaks in the given data, including peak heights and areas.

	``AnalyzePeaks(NumericalData, **kwargs)`` finds peaks in the 'NumericalData', and computes peak properties such as Position, Height, Width, and Area.

	:param NumericalData: A list of two dimensional data points that will be analyzed for peaks.
	:param `**kwargs`: optional arguments for AnalyzePeaks.
	:returns: AnalysisObject - An analysis object containing information about peaks in the given data, including peak heights and areas.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzepeaks.
	"""


class AnalyzeSmoothing(Function):
	"""
	The allowed input signatures of AnalyzeSmoothing without optional arguments (kwargs) are:

	``AnalyzeSmoothing(Data, **kwargs)`` this function takes either a list of data objects or a list of xy coordinates and applies different types of smoothing functions to the datasets in order to reduce the noise and make clear the broader trends in your data.

	:param Data: The input can be a set of data objects, a set of protocol objects, a set of raw data points, or a set of raw coordinates (including quantities and distributions), respectively.
	:param `**kwargs`: optional arguments for AnalyzeSmoothing.
	:returns: Object - The object containing analysis results of smoothing the curves.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzesmoothing.
	"""


class AnalyzeStandardCurve(Function):
	"""
	The allowed input signatures of AnalyzeStandardCurve without optional arguments (kwargs) are:

	``AnalyzeStandardCurve(DataToTransform, RawStandardData, **kwargs)`` fits a standard curve to 'RawStandardData' and applies it to 'DataToTransform', then stores the result in 'Object'.

	:param DataToTransform: Data points to transform using fitted standard curve.
	:param RawStandardData: Existing standard curve, or data points to fit a standard curve to.
	:param `**kwargs`: optional arguments for AnalyzeStandardCurve.
	:returns: Object - The analysis object containing results from fitting and applying standard curves.

	``AnalyzeStandardCurve(RawStandardData, **kwargs)`` fits a standard curve to 'RawStandardData' only, then stores the result in 'Object'.

	:param RawStandardData: Existing standard curve, or data points to fit a standard curve to.
	:param `**kwargs`: optional arguments for AnalyzeStandardCurve.
	:returns: Object - The analysis object containing results from fitted standard curves.

	``AnalyzeStandardCurve(CapillaryELISAProtocol, **kwargs)`` applies standard curve analysis to experimental protocols for which default analysis has been defined.

	:param CapillaryELISAProtocol: The experimental protocol to apply standard analysis to. See input pattern for supported protocol types.
	:param `**kwargs`: optional arguments for AnalyzeStandardCurve.
	:returns: Objects - The analysis object(s) containing results from fitting and applying standard curves.

	``AnalyzeStandardCurve(DataToTransform, StandardCurveObject, **kwargs)`` gets fitted results from 'StandardCurveObject' and applies it to 'DataToTransform', then stores the result in a new 'Object'.

	:param DataToTransform: Data points to transform using fitted standard curve.
	:param StandardCurveObject: Existing analysis object Object[Analysis, StandardCurve]. This object must have ReferenceStandardCurve field Null.
	:param `**kwargs`: optional arguments for AnalyzeStandardCurve.
	:returns: Object - The analysis object containing results from fitting and applying standard curves.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzestandardcurve.
	"""


class AnalyzeDownsampling(Function):
	"""
	The allowed input signatures of AnalyzeDownsampling without optional arguments (kwargs) are:

	``AnalyzeDownsampling(DataObject,Field, **kwargs)`` downsamples and compresses the numerical data in a 'Field' of 'DataObject', storing the downsampled result in 'AnalysisObject'.

	:param DataObject: The data object containing data to be downsampled.
	:param Field: The field in the data object containing two- or three-dimensional data points to be downsampled.
	:param `**kwargs`: optional arguments for AnalyzeDownsampling.
	:returns: AnalysisObject - An analysis object containing the downsampled data.

	``AnalyzeDownsampling(NumericalData, **kwargs)`` downsamples and compresses 'NumericalData', storing the downsampled result in 'Object'.

	:param NumericalData: A list of two- or three-dimensional data points {{x1,y1}..} or {{x1,y1,z1}...}.
	:param `**kwargs`: optional arguments for AnalyzeDownsampling.
	:returns: Object - An analysis object containing the downsampled data.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzedownsampling.
	"""


class AnalyzeMassSpectrumDeconvolution(Function):
	"""
	The allowed input signatures of AnalyzeMassSpectrumDeconvolution without optional arguments (kwargs) are:

	``AnalyzeMassSpectrumDeconvolution(Data, **kwargs)`` denoises and centroids spectral data, and then combines peaks corresponding to analytes of the same elemental composition, but different isotopic compositions, into monoisotopic peaks. Optionally, peaks with known charge states can be shifted to the corresponding single-charged position.

	:param Data: A data object containing mass spectrometry or Liquid Chromatography Mass Spectrometry (LCMS) data.
	:param `**kwargs`: optional arguments for AnalyzeMassSpectrumDeconvolution.
	:returns: Object - The object containing the analysis results of the deconvolution of the mass spectrometry data.

	``AnalyzeMassSpectrumDeconvolution(Protocol, **kwargs)`` denoises and centroids spectral data in the linked objects of the Data field of the 'Protocol', and then combines peaks corresponding to analytes of the same elemental composition, but different isotopic compositions, into monoisotopic peaks. Optionally, peaks with known charge states can be shifted to the corresponding single-charged position.

	:param Protocol: A protocol object with linked data objects containing mass spectrometry or Liquid Chromatography Mass Spectrometry (LCMS) data.
	:param `**kwargs`: optional arguments for AnalyzeMassSpectrumDeconvolution.
	:returns: Object - The object containing the analysis results of the deconvolution of the mass spectrometry data in the protocol object.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzemassspectrumdeconvolution.
	"""


class AnalyzeBindingKinetics(Function):
	"""
	The allowed input signatures of AnalyzeBindingKinetics without optional arguments (kwargs) are:

	``AnalyzeBindingKinetics(AssociationData, DissociationData, **kwargs)`` solves for kinetic association and dissociation rates such that the model described by 'reactions' fits the input 'AssociationData' and 'DissociationData'.

	:param AssociationData: List of QuantityArray from an analyte association step to fit to.
	:param DissociationData: List of QuantityArray from an analyte dissociation step to fit to.
	:param `**kwargs`: optional arguments for AnalyzeBindingKinetics.
	:returns: Object - The object containing analysis results from solving the kinetic rates.

	``AnalyzeBindingKinetics(KineticData, **kwargs)`` fits to the trajectories in the data objects or protocol from ExperimentBioLayerInterferometry.

	:param KineticData: BioLayerInterferometry kinetics data or protocol containing kinetics data fields.
	:param `**kwargs`: optional arguments for AnalyzeBindingKinetics.
	:returns: Object - The object containing analysis results from solving the kinetic rates.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzebindingkinetics.
	"""


class AnalyzeBindingQuantitation(Function):
	"""
	The allowed input signatures of AnalyzeBindingQuantitation without optional arguments (kwargs) are:

	``AnalyzeBindingQuantitation(QuantitationData, **kwargs)`` determines the concentration of the analyte measured in 'QuantitationData'.

	:param QuantitationData: A list of QuantityArrays for analyte detection steps.
	:param `**kwargs`: optional arguments for AnalyzeBindingQuantitation.
	:returns: Object - The object containing analysis results.

	``AnalyzeBindingQuantitation(DataObject, **kwargs)`` determines the concentration of the analyte measured by creating a standard curve by fitting all data with the specified model.

	:param DataObject: BioLayerInterferometry Quantitation data object containing Quantitation data fields.
	:param `**kwargs`: optional arguments for AnalyzeBindingQuantitation.
	:returns: Object - The object containing analysis results.

	``AnalyzeBindingQuantitation(ProtocolObject, **kwargs)`` determines the concentration of the analyte measured by creating a standard curve by fitting all data with the specified model.

	:param ProtocolObject: BioLayerInterferometry Quantitation data or protocol containing Quantitation data fields.
	:param `**kwargs`: optional arguments for AnalyzeBindingQuantitation.
	:returns: Object - The object containing analysis results.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzebindingquantitation.
	"""


class AnalyzeCompensationMatrix(Function):
	"""
	The allowed input signatures of AnalyzeCompensationMatrix without optional arguments (kwargs) are:

	``AnalyzeCompensationMatrix(FlowCytometryProtocol, **kwargs)`` uses the AdjustmentSampleData collected in the provided 'FlowCytometryProtocol' to compute the 'CompensationMatrix' that corrects for fluorophore signal overlap.

	:param FlowCytometryProtocol: A flow cytometry protocol for which CompensationSamplesIncluded is True.
	:param `**kwargs`: optional arguments for AnalyzeCompensationMatrix.
	:returns: CompensationMatrix - An analysis object containing the compensation matrix which corrects for signal overlap between the fluorophores and detectors used in the input protocol.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzecompensationmatrix.
	"""


class AnalyzeDNASequencing(Function):
	"""
	The allowed input signatures of AnalyzeDNASequencing without optional arguments (kwargs) are:

	``AnalyzeDNASequencing(SequencingData, **kwargs)`` conducts base-calling analysis to assign a DNA 'Sequence' to the electropherogram peaks in 'SequencingData'.

	:param SequencingData: DNASequencing data containing four-channel electropherograms to conduct base-calling analysis on.
	:param `**kwargs`: optional arguments for AnalyzeDNASequencing.
	:returns: Sequence - The identified DNA sequence, as well as quality values and/or base probabilities for each predicted nucleobase.

	``AnalyzeDNASequencing(SequencingProtocol, **kwargs)`` conducts base-calling analysis to assign DNA 'Sequences' to all sequencing data present in 'SequencingProtocol'.

	:param SequencingProtocol: A DNASequencing protocol containing one or more DNASequencing data objects.
	:param `**kwargs`: optional arguments for AnalyzeDNASequencing.
	:returns: Sequences - Identified sequences, quality values, and/or base probabilities for each DNASequencing data object in 'protocol'.

	``AnalyzeDNASequencing(XyData, **kwargs)`` conducts base-calling analysis to assign a DNA 'Sequence' to the raw electropherogram traces represented by 'XyData'.

	:param XyData: Four sets of {x,y} data points corresponding to sequencing electropherogram traces of each DNA nucleobase, in the order A, C, T, G.
	:param `**kwargs`: optional arguments for AnalyzeDNASequencing.
	:returns: Sequence - The identified DNA sequence, as well as quality values and/or base probabilities for each predicted nucleobase.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzednasequencing.
	"""


class AnalyzeEpitopeBinning(Function):
	"""
	The allowed input signatures of AnalyzeEpitopeBinning without optional arguments (kwargs) are:

	``AnalyzeEpitopeBinning(DataObject, **kwargs)`` classifies antibodies by their interaction with a given antigen using 'DataObject' collected by biolayer interferometry.

	:param DataObject: BioLayerInterferometry data objects generated from ExperimentBioLayerInterferometry.
	:param `**kwargs`: optional arguments for AnalyzeEpitopeBinning.
	:returns: Object - The object containing quantitative analysis of cross blocking between a given set of antibodies when binding the same antigen.

	``AnalyzeEpitopeBinning(ProtocolObject, **kwargs)`` classifies antibodies by their interaction with a given antigen using data found in 'ProtocolObject' for ExperimentBioLayerInterferometry.

	:param ProtocolObject: BioLayerInterferometry protocol object for an epitope binning experiment.
	:param `**kwargs`: optional arguments for AnalyzeEpitopeBinning.
	:returns: Object - The object containing quantitative analysis of cross blocking between a given set of antibodies when binding the same antigen.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzeepitopebinning.
	"""


class AnalyzeFlowCytometry(Function):
	"""
	The allowed input signatures of AnalyzeFlowCytometry without optional arguments (kwargs) are:

	``AnalyzeFlowCytometry(DataObjects, **kwargs)`` uses clustering analysis to partition the flow cytometry data in 'DataObjects' into clusters of cells, and records the partitioning and cell counts in 'AnalysisObject'.

	:param DataObjects: A flow cytometry data object.
	:param `**kwargs`: optional arguments for AnalyzeFlowCytometry.
	:returns: AnalysisObject - An analysis object containing clustered data and cell counts for the partitioned input flow cytometry data.

	``AnalyzeFlowCytometry(FlowCytometryProtocol, **kwargs)`` uses clustering analysis to partition and count the cells in each flow cytometry data object generated by 'FlowCytometryProtocol', and stores the results in 'AnalysisObjects'.

	:param FlowCytometryProtocol: A completed flow cytometry protocol containing one or more flow cytometry data objects.
	:param `**kwargs`: optional arguments for AnalyzeFlowCytometry.
	:returns: AnalysisObjects - Analysis objects containing clustered data and cell counts for each flow cytometry data object in 'protocol'.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzeflowcytometry.
	"""


class AnalyzeTotalProteinQuantification(Function):
	"""
	The allowed input signatures of AnalyzeTotalProteinQuantification without optional arguments (kwargs) are:

	``AnalyzeTotalProteinQuantification(Protocol, **kwargs)`` calculates the mass concentration of protein present in the input samples of the provided TotalProteinQuantification 'Protocol'. The input protocol is generated by ExperimentTotalProteinQuantification.

	:param Protocol: An Object[Protocol, TotalProteinQuantification] Object whose SamplesIn will have their TotalProteinConcentrations calculated.
	:param `**kwargs`: optional arguments for AnalyzeTotalProteinQuantification.
	:returns: Object - The object containing analysis results from the TotalProteinQuantification protocol.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzetotalproteinquantification.
	"""


class AnalyzeQuantificationCycle(Function):
	"""
	The allowed input signatures of AnalyzeQuantificationCycle without optional arguments (kwargs) are:

	``AnalyzeQuantificationCycle(Protocol, **kwargs)`` calculates the quantification cycle of each applicable amplification curve in the data linked to the provided quantitative polymerase chain reaction (qPCR) 'Protocol'.

	:param Protocol: The quantitative polymerase chain reaction (qPCR) protocol whose data are to be analyzed.
	:param `**kwargs`: optional arguments for AnalyzeQuantificationCycle.
	:returns: Objects - The objects containing quantification cycle analysis results from the quantitative polymerase chain reaction (qPCR) protocol.

	``AnalyzeQuantificationCycle(Data, **kwargs)`` calculates the quantification cycle of each applicable amplification curve in the provided quantitative polymerase chain reaction (qPCR) 'Data'.

	:param Data: The quantitative polymerase chain reaction (qPCR) data to be analyzed.
	:param `**kwargs`: optional arguments for AnalyzeQuantificationCycle.
	:returns: Objects - The objects containing quantification cycle analysis results from the quantitative polymerase chain reaction (qPCR) data.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzequantificationcycle.
	"""


class AnalyzeCopyNumber(Function):
	"""
	The allowed input signatures of AnalyzeCopyNumber without optional arguments (kwargs) are:

	``AnalyzeCopyNumber(QuantificationCycles,StandardCurve, **kwargs)`` calculates the copy number for each of the 'QuantificationCycles' based on a 'StandardCurve' of quantification cycle vs Log10 copy number.

	:param QuantificationCycles: The quantification cycle analysis objects to be analyzed.
	:param StandardCurve: The linear fit analysis object of quantification cycle vs Log10 copy number to be used for analysis. If a new standard curve is needed, copy number and quantification cycle analysis object pairs may be provided for performing a new linear fit.
	:param `**kwargs`: optional arguments for AnalyzeCopyNumber.
	:returns: Objects - The objects containing copy number analysis results.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzecopynumber.
	"""


class AnalyzeParallelLine(Function):
	"""
	The allowed input signatures of AnalyzeParallelLine without optional arguments (kwargs) are:

	``AnalyzeParallelLine(StandardXY, AnalyteXY, **kwargs)`` calculate the relative potency ratio between EC50 values in two dose-response fitted curves.

	:param StandardXY: The set of standard data points to fit to. Points can be numbers, quantities, distributions, or objects.
	:param AnalyteXY: The set of analyte data points to fit to. Points can be numbers, quantities, distributions, or objects.
	:param `**kwargs`: optional arguments for AnalyzeParallelLine.
	:returns: Object - The parallel line object containing analysis results from the fitted curves.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzeparallelline.
	"""


class AnalyzeFractions(Function):
	"""
	The allowed input signatures of AnalyzeFractions without optional arguments (kwargs) are:

	``AnalyzeFractions(ChromData, **kwargs)`` selects fractions from a given chromatograph to be carried forward for further analysis.

	:param ChromData: Chromatography data with collected fractions.
	:param `**kwargs`: optional arguments for AnalyzeFractions.
	:returns: PickedSamples - Set of samples picked from the given collected fractions.

	``AnalyzeFractions(ChromProtocol, **kwargs)`` analyzes all data in the given protocol.

	:param ChromProtocol: Chromatography protocol.
	:param `**kwargs`: optional arguments for AnalyzeFractions.
	:returns: PickedSamples - Set of samples picked from the given collected fractions.

	``AnalyzeFractions(CollectedFracs, **kwargs)`` uses the given set of fractions as a starting point for the analysis, instead of starting by filtering based on peaks.

	:param CollectedFracs: Initial set of collected fractions.
	:param `**kwargs`: optional arguments for AnalyzeFractions.
	:returns: PickedSamples - Set of samples picked from the given collected fractions.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzefractions.
	"""


class AnalyzeComposition(Function):
	"""
	The allowed input signatures of AnalyzeComposition without optional arguments (kwargs) are:

	``AnalyzeComposition(Protocol, **kwargs)`` analyzes the chemical composition of chromatogram peaks in a HPLC protocol.

	:param Protocol: The HPLC protocol that contains the SamplesIn/Standards that will be analyzed.
	:param `**kwargs`: optional arguments for AnalyzeComposition.
	:returns: Object - The analysis object that contains the analyzed compositions of the SamplesIn based on the Standards.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzecomposition.
	"""


class AnalyzeAbsorbanceQuantification(Function):
	"""
	The allowed input signatures of AnalyzeAbsorbanceQuantification without optional arguments (kwargs) are:

	``AnalyzeAbsorbanceQuantification(DataObjs, **kwargs)`` calculates sample concentration using Beer's Law along with absorbance and volume measurements and calculated extinction coefficients.

	:param DataObjs: The data objects to be analyzed.
	:param `**kwargs`: optional arguments for AnalyzeAbsorbanceQuantification.
	:returns: Object - The quantification analyses resulting from finding volume and/or concentration from the samples and data in the quantificationProcess provided.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzeabsorbancequantification.
	"""


class AnalyzeLadder(Function):
	"""
	The allowed input signatures of AnalyzeLadder without optional arguments (kwargs) are:

	``AnalyzeLadder(Peaks, **kwargs)`` fits a standard curve function to molecular size (e.g. oligomer length) from peak position.

	:param Peaks: An Object[Analysis, Peaks] Object whose positions will be used in the standard curve fitting.
	:param `**kwargs`: optional arguments for AnalyzeLadder.
	:returns: Object - The object containing analysis results from fitting the standard curve.

	``AnalyzeLadder(Data, **kwargs)`` fits the standard curve to peak positions taken from the most recent peaks analysis linked to the given data object. Runs AnalyzePeaks if no linked analysis object is found.

	:param Data: A data object that has peaks associated.
	:param `**kwargs`: optional arguments for AnalyzeLadder.
	:returns: Object - The object containing analysis results from fitting the standard curve.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzeladder.
	"""


class AnalyzeCriticalMicelleConcentration(Function):
	"""
	The allowed input signatures of AnalyzeCriticalMicelleConcentration without optional arguments (kwargs) are:

	``AnalyzeCriticalMicelleConcentration(Data, **kwargs)`` calculates the CriticalMicelleConcentration of the TargetMolecule in the samples of the provided SurfaceTension 'Data'. The input data is generated by ExperimentMeasureSurfaceTension.

	:param Data: An Object[Data, SurfaceTension] Object whose SamplesIn will have their TargetMolecule's CriticalMicelleConcentration calculated.
	:param `**kwargs`: optional arguments for AnalyzeCriticalMicelleConcentration.
	:returns: Object - The object containing analysis results from the SurfaceTension Data.

	``AnalyzeCriticalMicelleConcentration(Protocol, **kwargs)`` calculates the CriticalMicelleConcentration of the TargetMolecule in the samples of the provided MeasureSurfaceTension 'Protocol'. The input data is generated by ExperimentMeasureSurfaceTension.

	:param Protocol: An Object[Protocol, MeasureSurfaceTension] Object whose SamplesIn will have their TargetMolecule's CriticalMicelleConcentration calculated.
	:param `**kwargs`: optional arguments for AnalyzeCriticalMicelleConcentration.
	:returns: Object - The object containing analysis results from the SurfaceTension Data.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzecriticalmicelleconcentration.
	"""


class AnalyzeKinetics(Function):
	"""
	The allowed input signatures of AnalyzeKinetics without optional arguments (kwargs) are:

	``AnalyzeKinetics(Trajectories, Reactions, **kwargs)`` solves for kinetic rates such that the model described by 'Reactions' fits the training data 'Trajectories'.

	:param Trajectories: List of trajectories to fit to.
	:param Reactions: Proposed mechanism to fit to.  Must contain at least one unknown symbolic rate.
	:param `**kwargs`: optional arguments for AnalyzeKinetics.
	:returns: Object - The object containing analysis results from solving the kinetic rates.

	``AnalyzeKinetics(KineticData, Reactions, **kwargs)`` fits to the trajectories in the given kinetics data objects or protocol.

	:param KineticData: Kinetics data or protocol containing trajectories.
	:param Reactions: Proposed mechanism to fit to.  Must contain at least one unknown symbolic rate.
	:param `**kwargs`: optional arguments for AnalyzeKinetics.
	:returns: Object - The object containing analysis results from solving the kinetic rates.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzekinetics.
	"""


class AnalyzeThermodynamics(Function):
	"""
	The allowed input signatures of AnalyzeThermodynamics without optional arguments (kwargs) are:

	``AnalyzeThermodynamics({meltingAnalysis..}, **kwargs)`` calculates Gibbs free energy at 37Celsius of a melting reaction using a series of melting curve analyses and a two-state van't Hoff model (bound and unbound).

	:param MeltingAnalysis: A melting point analysis.
	:param `**kwargs`: optional arguments for AnalyzeThermodynamics.
	:returns: Object - The Analysis object containing Gibbs free energy at 37Celsius calculated for the dataset.

	``AnalyzeThermodynamics({thermodynamicData..}, **kwargs)`` calculates the Gibbs free energy from the most recent melting point analysis linked to each given data.

	:param ThermodynamicData: A thermodynamic data that has had a melting point analysis run on it.
	:param `**kwargs`: optional arguments for AnalyzeThermodynamics.
	:returns: Object - The Analysis object containing Gibbs free energy at 37Celsius calculated for the dataset.

	``AnalyzeThermodynamics(ThermodynamicProtocol, **kwargs)`` calculates the Gibbs free energy from the most recent melting point analysis linked to all of the data linked to the given protocol.

	:param ThermodynamicProtocol: An AbsorbanceThermodynamics or FluorescenceThermodynamics protocol whose data has had melting point analysis run on it.
	:param `**kwargs`: optional arguments for AnalyzeThermodynamics.
	:returns: Object - The Analysis object containing Gibbs free energy at 37Celsius calculated for the dataset.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzethermodynamics.
	"""


class AnalyzeMeltingPoint(Function):
	"""
	The allowed input signatures of AnalyzeMeltingPoint without optional arguments (kwargs) are:

	``AnalyzeMeltingPoint(MeltingData, **kwargs)`` calculates melting temperature from melting curves that are stored in 'MeltingData' object.

	:param MeltingData: Thermodynamics data objects that will be analyzed for melting temperature.
	:param `**kwargs`: optional arguments for AnalyzeMeltingPoint.
	:returns: Object - The Analysis object containing melting temperature calculated for the dataset.

	``AnalyzeMeltingPoint(MeltingProtocol, **kwargs)`` calculates melting temperature from melting curves that are stored in 'MeltingProtocol' object.

	:param MeltingProtocol: Protocol objects that contains thermodynamics data objects for melting temperature analysis.
	:param `**kwargs`: optional arguments for AnalyzeMeltingPoint.
	:returns: Object - The Analysis object containing melting temperature calculated for the dataset.

	``AnalyzeMeltingPoint(MeltingRaw, **kwargs)`` calculates melting temperature from raw data points.

	:param MeltingRaw: Raw data points that require melting temperature analysis.
	:param `**kwargs`: optional arguments for AnalyzeMeltingPoint.
	:returns: Object - The Analysis object containing melting temperature calculated for the dataset.

	``AnalyzeMeltingPoint(MeltingDataSet, **kwargs)`` calculates melting temperature from temperature and response data stored in a list of objects 'MeltingDataSet', where each object contain one data point.

	:param MeltingDataSet: Intensity data objects that require melting temperature analysis.
	:param `**kwargs`: optional arguments for AnalyzeMeltingPoint.
	:returns: Object - The Analysis object containing melting temperature calculated for the dataset.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzemeltingpoint.
	"""


class AnalyzeDynamicLightScattering(Function):
	"""
	The allowed input signatures of AnalyzeDynamicLightScattering without optional arguments (kwargs) are:

	``AnalyzeDynamicLightScattering(DynamicLightScatteringData, **kwargs)`` Calculates the key scientific parameters derived from the dynamic light scattering protocol, including Z-average diameter, second virial coefficient (b22), diffusion interation parameter (kD), and Kirkwood Buff integral (G22).

	:param DynamicLightScatteringData: Data containing dynamic light scattering correlation curves to be analyzed.
	:param `**kwargs`: optional arguments for AnalyzeDynamicLightScattering.
	:returns: Object - The object containing analysis for the scientific parameters derived from the dynamic light scattering correlation curves.

	``AnalyzeDynamicLightScattering(DynamicLightScatteringProtocol, **kwargs)`` Analyzes all the data in the given protocol.

	:param DynamicLightScatteringProtocol: Protocol with data objects containing dynamic light scattering correaltion curves to be analyzed.
	:param `**kwargs`: optional arguments for AnalyzeDynamicLightScattering.
	:returns: Object - The object containing the analysis of scientific parameters derived from the dynamic light scattering correlation curves.

	``AnalyzeDynamicLightScattering(MeltingCurveData, **kwargs)`` Calculates the Z-average diameter, polydispersity index, and diffusion coefficient for MeltingCurve data objects generated from Object[Protocol, ThermalShift].

	:param MeltingCurveData: Data containing dynamic light scattering correlation curves to be analyzed.
	:param `**kwargs`: optional arguments for AnalyzeDynamicLightScattering.
	:returns: Object - The object containing analysis for the scientific parameters derived from the dynamic light scattering correlation curves.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzedynamiclightscattering.
	"""


class AnalyzeDynamicLightScatteringLoading(Function):
	"""
	The allowed input signatures of AnalyzeDynamicLightScatteringLoading without optional arguments (kwargs) are:

	``AnalyzeDynamicLightScatteringLoading(DynamicLightScatteringProtocol, **kwargs)`` identifies the dynamic light scattering data objects of the protocol with properly loaded samples during experimentation. Thresholding analysis of correlation curve data is used to heuristically group samples that likely failed loading of the instrument.

	:param DynamicLightScatteringProtocol: Protocol containing dynamic light scattering data to be analyzed.
	:param `**kwargs`: optional arguments for AnalyzeDynamicLightScatteringLoading.
	:returns: Object - The object containing analysis selecting dynamic light scattering data with properly loaded samples.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzedynamiclightscatteringloading.
	"""


class AnalyzeBubbleRadius(Function):
	"""
	The allowed input signatures of AnalyzeBubbleRadius without optional arguments (kwargs) are:

	``AnalyzeBubbleRadius(DataObject, **kwargs)`` computes the distribution of bubble radii at each frame of the RawVideoFile in a DynamicFoamAnalysis 'DataObject'.

	:param DataObject: A DynamicFoamAnalysis data object containing a RawVideoFile of foam bubbles to analyze.
	:param `**kwargs`: optional arguments for AnalyzeBubbleRadius.
	:returns: AnalysisObject - An analysis object containing the distribution of foam bubble radii at each frame of the input video.

	``AnalyzeBubbleRadius(Protocol, **kwargs)`` computes the distribution of bubble radii at each frame of each RawVideoFile found in all data objects generated by 'Protocol'.

	:param Protocol: A DynamicFoamAnalysis protocol containing one or more DynamicFoamAnalysis data objects.
	:param `**kwargs`: optional arguments for AnalyzeBubbleRadius.
	:returns: AnalysisObjects - For each data object in the input protocol containing a RawVideoFile, analysis object(s) containing computed distributions of bubble radii.

	``AnalyzeBubbleRadius(Video, **kwargs)`` computes the distribution of bubble radii at each frame of the input 'Video'.

	:param Video: An EmeraldCloudFile video showing the evolution of foam bubbles over time.
	:param `**kwargs`: optional arguments for AnalyzeBubbleRadius.
	:returns: AnalysisObject - An analysis object containing the distribution of foam bubble radii at each frame of the input video.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzebubbleradius.
	"""


class AnalyzeImageExposure(Function):
	"""
	The allowed input signatures of AnalyzeImageExposure without optional arguments (kwargs) are:

	``AnalyzeImageExposure(ImageData, **kwargs)`` identifies the optimal image from 'ImageData' by calculating pixel gray level statistics. If none of the input images are properly exposed, a new exposure time will be suggested for next image acquisition.

	:param ImageData: A list of exposure times and images to be analyzed.
	:param `**kwargs`: optional arguments for AnalyzeImageExposure.
	:returns: Object - Object(s) containing the best exposed images and the pixel level statistics derived from the input image data.

	``AnalyzeImageExposure(AppearanceColoniesImages, **kwargs)`` identifies the optimal image from 'AppearanceColoniesImages'.  If no optimal image is found, a new exposure time is suggested for next image acquisition.

	:param AppearanceColoniesImages: A list of images representing the physical appearance of a sample that contains bacterial colonies to be analyzed.
	:param `**kwargs`: optional arguments for AnalyzeImageExposure.
	:returns: Object - Object(s) containing the best exposed images and the pixel level statistics derived from the input image data.

	``AnalyzeImageExposure(AppearanceImages, **kwargs)`` identifies the optimal image from 'AppearanceImages'.  If no optimal image is found, an exposure time is suggested.

	:param AppearanceImages: A list of Appearance objects representing the physical appearance of samples to be analyzed.
	:param `**kwargs`: optional arguments for AnalyzeImageExposure.
	:returns: Object - Object(s) containing analysis for the exposure parameters derived from the input image data.

	``AnalyzeImageExposure(PAGEData, **kwargs)`` examines 'PAGEData' to identify the optimally exposed lane image.  If no optimal image is found, an exposure time is suggested.

	:param PAGEData: A list of PAGE data objects to be analyzed.
	:param `**kwargs`: optional arguments for AnalyzeImageExposure.
	:returns: Objects - The objects containing analyses for PAGE images.

	``AnalyzeImageExposure(PAGEProtocol, **kwargs)`` examines all lane or gel images produced by 'PAGEProtocol' to identify optimally exposed gel images.  If no optimal image is found, an exposure time is suggested.

	:param PAGEProtocol: A list of PAGE Protocol objects containing PAGE data objects to be analyzed.
	:param `**kwargs`: optional arguments for AnalyzeImageExposure.
	:returns: Objects - The objects containing analyses for PAGE images.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzeimageexposure.
	"""


class AnalyzeMicroscopeOverlay(Function):
	"""
	The allowed input signatures of AnalyzeMicroscopeOverlay without optional arguments (kwargs) are:

	``AnalyzeMicroscopeOverlay(MicroscopeImage, **kwargs)`` overlays microscope image data from multiple fluorescence and phase contrast channels to create a single combined image.

	:param MicroscopeImage: A list of microscope protocol or data objects.
	:param `**kwargs`: optional arguments for AnalyzeMicroscopeOverlay.
	:returns: OverlayObject - Analysis object of overlay with given parameters.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzemicroscopeoverlay.
	"""


class AnalyzeCellCount(Function):
	"""
	The allowed input signatures of AnalyzeCellCount without optional arguments (kwargs) are:

	``AnalyzeCellCount(MicroscopeData, **kwargs)`` counts the number of cells and their area and morphology given a microscope data object according to the type of cells in the aquired image. The function performs adjustment of image specification such as brightness and contrast and performs image segmentation.

	:param MicroscopeData: A list of microscope protocol or data objects.
	:param `**kwargs`: optional arguments for AnalyzeCellCount.
	:returns: CellCountObject - Analysis object for counting the number of cells that contains the information about cell count, cell size, and cell morphology.

	``AnalyzeCellCount(ImageFiles, **kwargs)`` counts the number of cells and measures the cell size and morphology by first adjusting the image specifications such as brightness and contrast and then performing image segmentation.

	:param ImageFiles: A list of microscope images stored in a cloud file or provided as a raw image.
	:param `**kwargs`: optional arguments for AnalyzeCellCount.
	:returns: CellCountObject - Analysis object for counting the number of cells that contains the information about cell count, cell size, and cell morphology.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzecellcount.
	"""


class AnalyzeColonies(Function):
	"""
	The allowed input signatures of AnalyzeColonies without optional arguments (kwargs) are:

	``AnalyzeColonies(MicroscopeData, **kwargs)`` counts the cell colonies or plaques on solid media imaged in 'MicroscopeData' and then classifies and locates the colonies or plaques by desired features, including fluorescence, absorbance, diameter, regularity, circularity, and isolation. The colony analysis may be used to isolate these colonies in fresh media in subsequent protocols such as colony picking.

	:param MicroscopeData: Microscope data objects that contain brightfield images of colonies or plaques on a plate and may also contain absorbance or fluorescence images.
	:param `**kwargs`: optional arguments for AnalyzeColonies.
	:returns: ColoniesAnalysis - Analysis object with the count and properties of all colonies or plaques, including the location, boundary, fluorescence, absorbance, diameter, regularity, circularity, and isolation. It also stores the location and classification of colonies or plaques with desired traits so that they can be picked for additional experimentation.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/analyzecolonies.
	"""


class SimulatePeptideFragmentationSpectra(Function):
	"""
	The allowed input signatures of SimulatePeptideFragmentationSpectra without optional arguments (kwargs) are:

	``SimulatePeptideFragmentationSpectra(Samples, **kwargs)`` finds the set of ions created after fragmenting the proteins and peptides in the composition field of the 'Samples', and also estimates the likelihood of fragmentation for each generated ion.

	:param Samples: A constellation object reference that represents a Sample that physically exists in the lab.
	:param `**kwargs`: optional arguments for SimulatePeptideFragmentationSpectra.
	:returns: Simulations - The Simulation object containing details regarding the set of ions generated during the fragmentation, the likelihood of the generation of the ion, and the parent sequence of the ion.

	``SimulatePeptideFragmentationSpectra(Strands, **kwargs)`` finds the set of ions created after fragmenting the peptide or protein defined by the 'Strand', and also estimates the likelihood of fragmentation for each generated ions.

	:param Strands: A 'Strand' that represents a protein or peptide.
	:param `**kwargs`: optional arguments for SimulatePeptideFragmentationSpectra.
	:returns: Simulations - The Simulation object containing details regarding the set of ions generated during the fragmentation, the likelihood of the generation of the ion, and the parent sequence of the ion.

	``SimulatePeptideFragmentationSpectra(States, **kwargs)`` finds the set of ions created after fragmenting the proteins and peptides in the species field of the 'States', and also estimates the likelihood of fragmentation for each generated ion.

	:param States: A State that represents a sample containing proteins or peptides.
	:param `**kwargs`: optional arguments for SimulatePeptideFragmentationSpectra.
	:returns: Simulations - The Simulation object containing details regarding the set of ions generated during the fragmentation, the likelihood of the generation of the ion, and the parent sequence of the ion.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/simulatepeptidefragmentationspectra.
	"""


class SimulateEquilibrium(Function):
	"""
	The allowed input signatures of SimulateEquilibrium without optional arguments (kwargs) are:

	``SimulateEquilibrium(ReactionModel, InitialCondition, **kwargs)`` computes the equilibrium of the ReactionMechanism 'ReactionModel' starting from initialCondition condition 'InitialCondition'.

	:param ReactionModel: A ReactionMechanism or a list of reactions, where each reaction is a rule with a forward rate, or an equilibrium with forward and backward rates.
	:param InitialCondition: Initial state of the system. All species in 'reactionModel' not specified in 'initialCondition' will be defaulted to 0.
	:param `**kwargs`: optional arguments for SimulateEquilibrium.
	:returns: SimulateEquilibriumObject - Equilibrium simulation object or packet.

	``SimulateEquilibrium(Structures, InitialCondition, **kwargs)`` constructs a ReactionMechanism from 'Structures' under two-state assumption then calculate equilibrium state.

	:param Structures: List of structures folded from the same sequence or results from SimulateFolding.
	:param InitialCondition: Initial state of the system. All species in 'reactionModel' not specified in 'initialCondition' will be defaulted to 0.
	:param `**kwargs`: optional arguments for SimulateEquilibrium.
	:returns: SimulateEquilibriumObject - Equilibrium simulation object or packet.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/simulateequilibrium.
	"""


class SimulateFolding(Function):
	"""
	The allowed input signatures of SimulateFolding without optional arguments (kwargs) are:

	``SimulateFolding(Oligomer, **kwargs)`` predicts potential secondary structure interactions of the provided 'Oligomer' with itself.

	:param Oligomer: Initial sequence, or strand, or structure to fold from.
	:param `**kwargs`: optional arguments for SimulateFolding.
	:returns: FoldingObject - An Object[Simulation, Folding] object or packet describing the folding behavior of 'oligomer'.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/simulatefolding.
	"""


class SimulateHybridization(Function):
	"""
	The allowed input signatures of SimulateHybridization without optional arguments (kwargs) are:

	``SimulateHybridization(Oligomer, **kwargs)`` predicts potential secondary structure interactions of the provided list of 'Oligomer'.

	:param Oligomer: Initial list of sequences, or strands, or structures to hybridize from, or two lists to hybridize between.
	:param `**kwargs`: optional arguments for SimulateHybridization.
	:returns: Hybridization - A list of hybridized structures describing the hybridization behavior of 'oligomer'.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/simulatehybridization.
	"""


class SimulateKinetics(Function):
	"""
	The allowed input signatures of SimulateKinetics without optional arguments (kwargs) are:

	``SimulateKinetics(ReactionModel, InitialCondition, SimulationDuration, **kwargs)`` performs kinetic simulation of reaction network described by 'ReactionModel', starting from initial condition 'InitialCondition', until the time 'SimulationDuration'.

	:param ReactionModel: A model describing the reaction network to simulate.
	:param InitialCondition: Initial state of the system.  Unspecified initial concentrations are set to 0 by default.  If no Units specified, simulator assumes Molar.
	:param SimulationDuration: Length of the time to run the simulation.  If no Units specified, simulator assumes 'simulationDuration' is in seconds.
	:param `**kwargs`: optional arguments for SimulateKinetics.
	:returns: Trajectory - A Trajectory containing the simulated results.

	``SimulateKinetics(InitialCondition, SimulationDuration, **kwargs)`` generates a mechanism from initial condition and then simulates its kinetics until the time 'SimulationDuration'.

	:param InitialCondition: Initial state of the system.  Unspecified initial concentrations are set to 0 by default.  If no Units specified, simulator assumes Molar.
	:param SimulationDuration: Length of the time to run the simulation.  If no Units specified, simulator assumes 'simulationDuration' is in seconds.
	:param `**kwargs`: optional arguments for SimulateKinetics.
	:returns: Trajectory - A Trajectory containing the simulated results.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/simulatekinetics.
	"""


class SimulateMeltingCurve(Function):
	"""
	The allowed input signatures of SimulateMeltingCurve without optional arguments (kwargs) are:

	``SimulateMeltingCurve({{initSpecies,InitConcentration}..}, **kwargs)`` simulates the kinetics of a mechanism generated from a paired set or paired set list of nucleic acids oligomers 'initSpecies' with 'initConcentration' over a range of temperatures specified through options.

	:param SpeciesWithConcentrationPair: Initial species of the system in the form of a sequence, strand or structure and the initial concentration of that species.
	:param `**kwargs`: optional arguments for SimulateMeltingCurve.
	:returns: ThermodynamicCurves - A Simulate Melting Curve Object containing the simulated Melting and Cooling trajectories.

	``SimulateMeltingCurve(Primerset, **kwargs)`` simulates the kinetics of the molecular beacons that are part of this 'Primerset'.

	:param Primerset: A set of oligomer primers design to amplify a particular target in PCR.
	:param `**kwargs`: optional arguments for SimulateMeltingCurve.
	:returns: ThermodynamicCurves - A Simulate Melting Curve Object containing the simulated Melting and Cooling trajectories.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/simulatemeltingcurve.
	"""


class SimulateReactivity(Function):
	"""
	The allowed input signatures of SimulateReactivity without optional arguments (kwargs) are:

	``SimulateReactivity(InitialState, **kwargs)`` generates a putative ReactionMechanism that describes the hybridization behavior of the system of nucleic acids or adds reaction rates to known reaction types from in the nucleic acid.

	:param InitialState: Initial state, or list of initialConditions or species in the system.
	:param `**kwargs`: optional arguments for SimulateReactivity.
	:returns: ReactionMechanism - ReactionMechanism generated from initial state.

	``SimulateReactivity(ReactionMechanism, **kwargs)`` adds reaction rates to known reaction types from in the nucleic acid 'ReactionMechanism'.

	:param ReactionMechanism: ReactionMechanism with implicit reaction rates.
	:param `**kwargs`: optional arguments for SimulateReactivity.
	:returns: ReactionMechanism - ReactionMechanism generated from initial state.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/simulatereactivity.
	"""


class SimulateEnthalpy(Function):
	"""
	The allowed input signatures of SimulateEnthalpy without optional arguments (kwargs) are:

	``SimulateEnthalpy(Reaction, **kwargs)`` computes the change in enthalpy of the given reaction between two nucleic acid oligomers with traditional Nearest Neighbor thermodynamic analysis.

	:param Reaction: A reversible reaction between two nucleic acid structures, from which a change in enthalpy will be computed.
	:param `**kwargs`: optional arguments for SimulateEnthalpy.
	:returns: EnthalpyObject - Enthalpy simulation object or packet.

	``SimulateEnthalpy(ReactantAplusB, **kwargs)`` finds the product of reaction from 'reactantA' + 'reactantB', then computes the change in enthalpy.

	:param ReactantAplusB: Two oligomers added to make a reaction.
	:param `**kwargs`: optional arguments for SimulateEnthalpy.
	:returns: EnthalpyObject - Enthalpy simulation object or packet.

	``SimulateEnthalpy(ReactantEquilibriumProduct, **kwargs)`` infers the type of reaction from the given 'reactant' ⇌ 'product' state and computes the enthalpy for that reaction.

	:param ReactantEquilibriumProduct: A nucleic acid structure participating as a product in a reaction.
	:param `**kwargs`: optional arguments for SimulateEnthalpy.
	:returns: EnthalpyObject - Enthalpy simulation object or packet.

	``SimulateEnthalpy(ReactionMechanism, **kwargs)`` computes the enthalpy from the reaction in the given mechanism.

	:param ReactionMechanism: A simple mechanism contains only one first order or second order reaction.
	:param `**kwargs`: optional arguments for SimulateEnthalpy.
	:returns: EnthalpyObject - Enthalpy simulation object or packet.

	``SimulateEnthalpy(Oligomer, **kwargs)`` considers the hybridization reaction between the given 'Oligomer' and its reverse complement.

	:param Oligomer: An oligomer participating in a hybridization reaction with its reverse complement.
	:param `**kwargs`: optional arguments for SimulateEnthalpy.
	:returns: EnthalpyObject - Enthalpy simulation object or packet.

	``SimulateEnthalpy(Structure, **kwargs)`` considers the melting reaction whereby all of the bonds in the given 'Structure' are melted.

	:param Structure: A nucleic acid structure that will be completely melted.
	:param `**kwargs`: optional arguments for SimulateEnthalpy.
	:returns: EnthalpyObject - Enthalpy simulation object or packet.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/simulateenthalpy.
	"""


class SimulateEntropy(Function):
	"""
	The allowed input signatures of SimulateEntropy without optional arguments (kwargs) are:

	``SimulateEntropy(Reaction, **kwargs)`` computes the change in entropy of the given reaction between two nucleic acid oligomers with traditional Nearest Neighbor thermodynamic analysis.

	:param Reaction: A reversible reaction between two nucleic acid structures, from which a change in entropy will be computed.
	:param `**kwargs`: optional arguments for SimulateEntropy.
	:returns: EntropyObject - Entropy simulation object or packet.

	``SimulateEntropy(ReactantAplusB, **kwargs)`` finds the product of reaction from 'reactantA' + 'reactantB', then computes the change in entropy.

	:param ReactantAplusB: Two oligomers added to make a reaction.
	:param `**kwargs`: optional arguments for SimulateEntropy.
	:returns: EntropyObject - Entropy simulation object or packet.

	``SimulateEntropy(ReactantEquilibriumProduct, **kwargs)`` infers the type of reaction from the given 'reactant' ⇌ 'product' state and computes the entropy for that reaction.

	:param ReactantEquilibriumProduct: A nucleic acid structure participating as a product in a reaction.
	:param `**kwargs`: optional arguments for SimulateEntropy.
	:returns: EntropyObject - Entropy simulation object or packet.

	``SimulateEntropy(ReactionMechanism, **kwargs)`` computes the entropy from the reaction in the given mechanism.

	:param ReactionMechanism: A simple mechanism contains only one first order or second order reaction.
	:param `**kwargs`: optional arguments for SimulateEntropy.
	:returns: EntropyObject - Entropy simulation object or packet.

	``SimulateEntropy(Oligomer, **kwargs)`` considers the hybridization reaction between the given 'Oligomer' and its reverse complement.

	:param Oligomer: An oligomer participating in a hybridization reaction with its reverse complement.
	:param `**kwargs`: optional arguments for SimulateEntropy.
	:returns: EntropyObject - Entropy simulation object or packet.

	``SimulateEntropy(Structure, **kwargs)`` considers the melting reaction whereby all of the bonds in the given 'Structure' are melted.

	:param Structure: A nucleic acid structure that will be completely melted.
	:param `**kwargs`: optional arguments for SimulateEntropy.
	:returns: EntropyObject - Entropy simulation object or packet.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/simulateentropy.
	"""


class SimulateEquilibriumConstant(Function):
	"""
	The allowed input signatures of SimulateEquilibriumConstant without optional arguments (kwargs) are:

	``SimulateEquilibriumConstant(Reaction, Temperature, **kwargs)`` computes the equilibrium constant of the given reaction between two nucleic acid oligomers at the specified concentration with traditional Nearest Neighbor thermodynamic analysis.

	:param Reaction: A reversible reaction between two nucleic acid structures, from which equilibrium constant will be computed.
	:param Temperature: Temperature at which equilibrium constant is computed.
	:param `**kwargs`: optional arguments for SimulateEquilibriumConstant.
	:returns: EquilibriumConstantObject - EquilibriumConstant simulation object or packet.

	``SimulateEquilibriumConstant(ReactantAplusB, Temperature, **kwargs)`` finds the product of reaction from 'reactantA' + 'reactantB', then computes the equilibrium constant.

	:param ReactantAplusB: Two oligomers added to make a reaction.
	:param Temperature: Temperature at which equilibrium constant is computed.
	:param `**kwargs`: optional arguments for SimulateEquilibriumConstant.
	:returns: EquilibriumConstantObject - EquilibriumConstant simulation object or packet.

	``SimulateEquilibriumConstant(ReactantEquilibriumProduct, Temperature, **kwargs)`` infers the type of reaction from the given 'reactant' ⇌ 'product' state and computes the equilibrium constant for that reaction.

	:param ReactantEquilibriumProduct: A nucleic acid structure reactant in equilibrium with a product in a reaction.
	:param Temperature: Temperature at which equilibrium constant is computed.
	:param `**kwargs`: optional arguments for SimulateEquilibriumConstant.
	:returns: EquilibriumConstantObject - EquilibriumConstant simulation object or packet.

	``SimulateEquilibriumConstant(ReactionMechanism, Temperature, **kwargs)`` computes the equilibrium constant from the reaction in the given mechanism.

	:param ReactionMechanism: A simple mechanism contains only one first order or second order reaction.
	:param Temperature: Temperature at which equilibrium constant is computed.
	:param `**kwargs`: optional arguments for SimulateEquilibriumConstant.
	:returns: EquilibriumConstantObject - EquilibriumConstant simulation object or packet.

	``SimulateEquilibriumConstant(Oligomer, Temperature, **kwargs)`` considers the hybridization reaction between the given 'Oligomer' and its reverse complement.

	:param Oligomer: An oligomer participating in a hybridization reaction with its reverse complement.
	:param Temperature: Temperature at which equilibrium constant is computed.
	:param `**kwargs`: optional arguments for SimulateEquilibriumConstant.
	:returns: EquilibriumConstantObject - EquilibriumConstant simulation object or packet.

	``SimulateEquilibriumConstant(Structure, Temperature, **kwargs)`` considers the melting reaction whereby all of the bonds in the given 'Structure' are melted.

	:param Structure: A nucleic acid structure that will be completely melted.
	:param Temperature: Temperature at which equilibrium constant is computed.
	:param `**kwargs`: optional arguments for SimulateEquilibriumConstant.
	:returns: EquilibriumConstantObject - EquilibriumConstant simulation object or packet.

	``SimulateEquilibriumConstant(Enthalpy, Entropy, Temperature, **kwargs)`` computes the equilibrium constant from the given enthalpy and entropy of a reaction.

	:param Enthalpy: Enthalpy of the reaction.
	:param Entropy: Entropy of the reaction.
	:param Temperature: Temperature at which equilibrium constant is computed.
	:param `**kwargs`: optional arguments for SimulateEquilibriumConstant.
	:returns: EquilibriumConstantObject - EquilibriumConstant simulation object or packet.

	``SimulateEquilibriumConstant(FreeEnergy, Temperature, **kwargs)`` computes the equilibrium constant from the given Gibbs free energy of a reaction.

	:param FreeEnergy: Free energy of the reaction.
	:param Temperature: Temperature at which equilibrium constant is computed.
	:param `**kwargs`: optional arguments for SimulateEquilibriumConstant.
	:returns: EquilibriumConstantObject - EquilibriumConstant simulation object or packet.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/simulateequilibriumconstant.
	"""


class SimulateFreeEnergy(Function):
	"""
	The allowed input signatures of SimulateFreeEnergy without optional arguments (kwargs) are:

	``SimulateFreeEnergy(Reaction, Temperature, **kwargs)`` computes the free energy of the given reaction between two nucleic acid oligomers at the specified concentration with traditional Nearest Neighbor thermodynamic analysis.

	:param Reaction: A reversible reaction between two nucleic acid structures, from which a change in Free energy will be computed.
	:param Temperature: Temperature at which free energy is computed.
	:param `**kwargs`: optional arguments for SimulateFreeEnergy.
	:returns: FreeEnergyObject - FreeEnergy simulation object or packet.

	``SimulateFreeEnergy(ReactantAplusB, Temperature, **kwargs)`` finds the product of reaction from 'reactantA' + 'reactantB', then computes the free energy.

	:param ReactantAplusB: Two oligomers added to make a reaction.
	:param Temperature: Temperature at which free energy is computed.
	:param `**kwargs`: optional arguments for SimulateFreeEnergy.
	:returns: FreeEnergyObject - FreeEnergy simulation object or packet.

	``SimulateFreeEnergy(ReactantEquilibriumProduct, Temperature, **kwargs)`` infers the type of reaction from the given 'reactant' ⇌ 'product' state and computes the free energy for that reaction.

	:param ReactantEquilibriumProduct: A nucleic acid structure participating as a product in a reaction.
	:param Temperature: Temperature at which free energy is computed.
	:param `**kwargs`: optional arguments for SimulateFreeEnergy.
	:returns: FreeEnergyObject - FreeEnergy simulation object or packet.

	``SimulateFreeEnergy(ReactionMechanism, Temperature, **kwargs)`` computes the free energy from the reaction in the given mechanism.

	:param ReactionMechanism: A simple mechanism contains only one first order or second order reaction.
	:param Temperature: Temperature at which free energy is computed.
	:param `**kwargs`: optional arguments for SimulateFreeEnergy.
	:returns: FreeEnergyObject - FreeEnergy simulation object or packet.

	``SimulateFreeEnergy(Oligomer, Temperature, **kwargs)`` considers the hybridization reaction between the given 'Oligomer' and its reverse complement.

	:param Oligomer: An oligomer participating in a hybridization reaction with its reverse complement.
	:param Temperature: Temperature at which free energy is computed.
	:param `**kwargs`: optional arguments for SimulateFreeEnergy.
	:returns: FreeEnergyObject - FreeEnergy simulation object or packet.

	``SimulateFreeEnergy(Structure, Temperature, **kwargs)`` considers the melting reaction whereby all of the bonds in the given 'Structure' are melted.

	:param Structure: A nucleic acid structure that will be completely melted.
	:param Temperature: Temperature at which free energy is computed.
	:param `**kwargs`: optional arguments for SimulateFreeEnergy.
	:returns: FreeEnergyObject - FreeEnergy simulation object or packet.

	``SimulateFreeEnergy(Enthalpy, Entropy, Temperature, **kwargs)`` computes the free energy from the given enthalpy and entropy of a reaction.

	:param Enthalpy: Enthalpy of the reaction.
	:param Entropy: Entropy of the reaction.
	:param Temperature: Temperature at which free energy is computed.
	:param `**kwargs`: optional arguments for SimulateFreeEnergy.
	:returns: FreeEnergyObject - FreeEnergy simulation object or packet.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/simulatefreeenergy.
	"""


class SimulateMeltingTemperature(Function):
	"""
	The allowed input signatures of SimulateMeltingTemperature without optional arguments (kwargs) are:

	``SimulateMeltingTemperature(Reaction, Concentration, **kwargs)`` computes the melting temperature of the given reaction between two nucleic acid oligomers at the specified concentration with traditional Nearest Neighbor thermodynamic analysis.

	:param Reaction: A reversible reaction between two nucleic acid structures, from which melting temperature will be computed.
	:param Concentration: Concentration at which melting temperature is computed.
	:param `**kwargs`: optional arguments for SimulateMeltingTemperature.
	:returns: MeltingTemperatureObject - MeltingTemperature simulation object or packet.

	``SimulateMeltingTemperature(ReactantAplusB, Concentration, **kwargs)`` finds the product of reaction from 'reactantA' + 'reactantB', then computes the melting temperature.

	:param ReactantAplusB: Two oligomers added to make a reaction.
	:param Concentration: Concentration at which melting temperature is computed.
	:param `**kwargs`: optional arguments for SimulateMeltingTemperature.
	:returns: MeltingTemperatureObject - MeltingTemperature simulation object or packet.

	``SimulateMeltingTemperature(ReactantEquilibriumProduct, Concentration, **kwargs)`` infers the type of reaction from the given 'reactant' ⇌ 'product' state and computes the melting temperature for that reaction.

	:param ReactantEquilibriumProduct: A nucleic acid structure participating as a product in a reaction.
	:param Concentration: Concentration at which melting temperature is computed.
	:param `**kwargs`: optional arguments for SimulateMeltingTemperature.
	:returns: MeltingTemperatureObject - MeltingTemperature simulation object or packet.

	``SimulateMeltingTemperature(ReactionMechanism, Concentration, **kwargs)`` computes the melting temperature from the reaction in the given mechanism.

	:param ReactionMechanism: A simple mechanism contains only one first order or second order reaction.
	:param Concentration: Concentration at which melting temperature is computed.
	:param `**kwargs`: optional arguments for SimulateMeltingTemperature.
	:returns: MeltingTemperatureObject - MeltingTemperature simulation object or packet.

	``SimulateMeltingTemperature(Oligomer, Concentration, **kwargs)`` considers the hybridization reaction between the given 'Oligomer' and its reverse complement.

	:param Oligomer: An oligomer participating in a hybridization reaction with its reverse complement.
	:param Concentration: Concentration at which melting temperature is computed.
	:param `**kwargs`: optional arguments for SimulateMeltingTemperature.
	:returns: MeltingTemperatureObject - MeltingTemperature simulation object or packet.

	``SimulateMeltingTemperature(Structure, Concentration, **kwargs)`` considers the melting reaction whereby all of the bonds in the given 'Structure' are melted.

	:param Structure: A nucleic acid structure that will be completely melted.
	:param Concentration: Concentration at which melting temperature is computed.
	:param `**kwargs`: optional arguments for SimulateMeltingTemperature.
	:returns: MeltingTemperatureObject - MeltingTemperature simulation object or packet.

	``SimulateMeltingTemperature(Enthalpy, Entropy, Concentration, **kwargs)`` computes the melting temperature from the given enthalpy and entropy of a reaction.

	:param Enthalpy: Enthalpy of the reaction.
	:param Entropy: Entropy of the reaction.
	:param Concentration: Concentration at which melting temperature is computed.
	:param `**kwargs`: optional arguments for SimulateMeltingTemperature.
	:returns: MeltingTemperatureObject - MeltingTemperature simulation object or packet.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/simulatemeltingtemperature.
	"""


class UploadName(Function):
	"""
	The allowed input signatures of UploadName without optional arguments (kwargs) are:

	``UploadName(Objects,Names, **kwargs)`` returns the objects in 'Objects' with their corresponding name in 'Names'.

	:param Objects: Objects which will be named.
	:param Names: Names for each object.
	:param `**kwargs`: optional arguments for UploadName.
	:returns: NamedObjects - Objects with their name.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadname.
	"""


class UploadTransportCondition(Function):
	"""
	The allowed input signatures of UploadTransportCondition without optional arguments (kwargs) are:

	``UploadTransportCondition(Samples,TransportConditions, **kwargs)`` returns the objects in 'Samples' with their corresponding transport conditions in 'TransportConditions'.

	:param Samples: Samples which will have transport conditions uploaded to them.
	:param TransportConditions: Transport Conditions for each sample.
	:param `**kwargs`: optional arguments for UploadTransportCondition.
	:returns: ModifiedSamples - Samples with transport conditions uploaded.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadtransportcondition.
	"""


class DefineAnalytes(Function):
	"""
	The allowed input signatures of DefineAnalytes without optional arguments (kwargs) are:

	``DefineAnalytes(SampleObject, **kwargs)`` updates an existing model 'SampleModel' that contains the information given about the sample.

	:param SampleObject: The existing Object[Sample] object that should be updated.
	:param `**kwargs`: optional arguments for DefineAnalytes.
	:returns: SampleModel - The model that represents this sample.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/defineanalytes.
	"""


class DefineTags(Function):
	"""
	The allowed input signatures of DefineTags without optional arguments (kwargs) are:

	``DefineTags(SampleObject, **kwargs)`` updates an existing model 'SampleModel' that contains the information given about the sample.

	:param SampleObject: The existing Object[Sample] object that should be updated.
	:param `**kwargs`: optional arguments for DefineTags.
	:returns: SampleModel - The model that represents this sample.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/definetags.
	"""


class DefineComposition(Function):
	"""
	The allowed input signatures of DefineComposition without optional arguments (kwargs) are:

	``DefineComposition(SampleObject, **kwargs)`` updates an existing model 'SampleModel' that contains the information given about the sample.

	:param SampleObject: The existing Object[Sample] object that should be updated.
	:param `**kwargs`: optional arguments for DefineComposition.
	:returns: SampleModel - The model that represents this sample.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/definecomposition.
	"""


class DefineSolvent(Function):
	"""
	The allowed input signatures of DefineSolvent without optional arguments (kwargs) are:

	``DefineSolvent(SampleObject, **kwargs)`` updates an existing model 'SampleModel' that contains the information given about the sample.

	:param SampleObject: The existing Object[Sample] object that should be updated.
	:param `**kwargs`: optional arguments for DefineSolvent.
	:returns: SampleModel - The model that represents this sample.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/definesolvent.
	"""


class DefineEHSInformation(Function):
	"""
	The allowed input signatures of DefineEHSInformation without optional arguments (kwargs) are:

	``DefineEHSInformation(SampleObject, **kwargs)`` updates an existing model 'SampleModel' that contains the information given about the sample.

	:param SampleObject: The existing Object[Sample] object that should be updated.
	:param `**kwargs`: optional arguments for DefineEHSInformation.
	:returns: SampleModel - The model that represents this sample.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/defineehsinformation.
	"""


class UploadSampleModel(Function):
	"""
	The allowed input signatures of UploadSampleModel without optional arguments (kwargs) are:

	``UploadSampleModel(Inputs, **kwargs)`` creates/updates a model 'SampleModel' that contains the information given about the sample.

	:param Inputs: The new names and/or existing objects that should be updated with information given about the sample.
	:param `**kwargs`: optional arguments for UploadSampleModel.
	:returns: SampleModel - The model that represents this sample.

	``UploadSampleModel(SampleName, **kwargs)`` returns a new model 'SampleModel' that contains the information given about the sample.

	:param SampleName: The common name of this sample.
	:param `**kwargs`: optional arguments for UploadSampleModel.
	:returns: SampleModel - The model that represents this sample.

	``UploadSampleModel(SampleObject, **kwargs)`` updates an existing model 'SampleModel' that contains the information given about the sample.

	:param SampleObject: The existing Model[Sample] object that should be updated.
	:param `**kwargs`: optional arguments for UploadSampleModel.
	:returns: SampleModel - The model that represents this sample.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadsamplemodel.
	"""


class UploadStockSolution(Function):
	"""
	The allowed input signatures of UploadStockSolution without optional arguments (kwargs) are:

	``UploadStockSolution(Components,Solvent,TotalVolume, **kwargs)`` creates a new 'StockSolutionModel' for combining 'Components' and using 'Solvent' to fill to 'TotalVolume' after initial component combination.

	:param Components: A list of samples and amounts to combine before solvent addition, with each addition in the form {sample, amount}.
	:param Solvent: The solvent used to bring up the volume to the solution's target volume after all other components have been added.
	:param TotalVolume: The total volume of solvent in which the provided components should be dissolved when this stock solution model is prepared.
	:param `**kwargs`: optional arguments for UploadStockSolution.
	:returns: StockSolutionModel - The newly-created stock solution model.

	``UploadStockSolution(Components, **kwargs)`` creates a new 'StockSolutionModel' that is prepared by combining all samples as specified in the 'Components'.

	:param Components: A list of all samples and amounts to combine for preparation of the stock solution, with each addition in the form {sample, amount}.
	:param `**kwargs`: optional arguments for UploadStockSolution.
	:returns: StockSolutionModel - The newly-created stock solution model.

	``UploadStockSolution(TemplateStockSolution, **kwargs)`` creates a new 'StockSolutionModel' using the formula from the 'TemplateStockSolution' and drawing any preparation parameter defaults from the 'TemplateStockSolution'.

	:param TemplateStockSolution: An existing stock solution model from which to use preparation parameters as defaults when creating a new model.
	:param `**kwargs`: optional arguments for UploadStockSolution.
	:returns: StockSolutionModel - The newly-created stock solution model.

	``UploadStockSolution(UnitOperations, **kwargs)`` creates a new 'StockSolutionModel' that is prepared by following the specified 'UnitOperations'.

	:param UnitOperations: The order of operations that is to be followed to make a stock solution.
	:param `**kwargs`: optional arguments for UploadStockSolution.
	:returns: StockSolutionModel - The newly-created stock solution model.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadstocksolution.
	"""


class UploadArrayCard(Function):
	"""
	The allowed input signatures of UploadArrayCard without optional arguments (kwargs) are:

	``UploadArrayCard(PrimerPairs,Probes, **kwargs)`` creates a new 'ArrayCardModel' with the pre-dried 'PrimerPairs' and 'Probes' for a quantitative polymerase chain reaction (qPCR) experiment.

	:param PrimerPairs: The pairs of oligomer strands designed for amplifying nucleic acid targets from the templates, in rows (i.e. A1, A2, ...).
	:param Probes: The target-specific oligomer strands containing reporter-quencher pairs that generate fluorescence during the target amplification, in rows (i.e. A1, A2, ...).
	:param `**kwargs`: optional arguments for UploadArrayCard.
	:returns: ArrayCardModel - The model that represents this array card.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadarraycard.
	"""


class UploadColumn(Function):
	"""
	The allowed input signatures of UploadColumn without optional arguments (kwargs) are:

	``UploadColumn(Inputs, **kwargs)`` creates/updates a model 'ColumnModel' that contains the information given about the column.

	:param Inputs: The new names and/or existing objects that should be updated with information given about the column.
	:param `**kwargs`: optional arguments for UploadColumn.
	:returns: ColumnModel - The model that represents this column.

	``UploadColumn(ColumnName, **kwargs)`` returns a new model 'ColumnModel' that contains the information given about the column.

	:param ColumnName: The common name of this column.
	:param `**kwargs`: optional arguments for UploadColumn.
	:returns: ColumnModel - The model that represents this column.

	``UploadColumn(ColumnObject, **kwargs)`` updates an existing model 'ColumnModel' that contains the information given about the column.

	:param ColumnObject: The existing Model[Item, Column] object that should be updated.
	:param `**kwargs`: optional arguments for UploadColumn.
	:returns: ColumnModel - The model that represents this column.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadcolumn.
	"""


class UploadCapillaryELISACartridge(Function):
	"""
	The allowed input signatures of UploadCapillaryELISACartridge without optional arguments (kwargs) are:

	``UploadCapillaryELISACartridge(Analytes, **kwargs)`` creates a new pre-loaded 'CapillaryELISACartridgeModel' with the specified analytes, cartridge type and species.

	:param Analytes: The targets (e.g., peptides, proteins, antibodies, hormones) detected and quantified in the samples using this pre-loaded capillary ELISA cartridge model through capillary ELISA experiment.
	:param `**kwargs`: optional arguments for UploadCapillaryELISACartridge.
	:returns: CapillaryELISACartridgeModel - The model that represents this pre-loaded capillary ELISA cartridge.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadcapillaryelisacartridge.
	"""


class UploadProduct(Function):
	"""
	The allowed input signatures of UploadProduct without optional arguments (kwargs) are:

	``UploadProduct(ThermoFisherURL, **kwargs)`` returns an object 'ProductObject' that contains the information given about the product from the ThermoFisher product URL.

	:param ThermoFisherURL: The URL of the ThermoFisher product page of this product object.
	:param `**kwargs`: optional arguments for UploadProduct.
	:returns: ProductObject - The object that represents this product.

	``UploadProduct(MilliporeSigmaURL, **kwargs)`` returns an object 'ProductObject' that contains the information given about the product from the MilliporeSigma product URL.

	:param MilliporeSigmaURL: The URL of the MilliporeSigma product page of this product object.
	:param `**kwargs`: optional arguments for UploadProduct.
	:returns: ProductObject - The object that represents this product.

	``UploadProduct(FisherScientificURL, **kwargs)`` returns an object 'ProductObject' that contains the information given about the product from the Fisher Scientific product URL.

	:param FisherScientificURL: The URL of the Fisher Scientific product page of this product object.
	:param `**kwargs`: optional arguments for UploadProduct.
	:returns: ProductObject - The object that represents this product.

	``UploadProduct(, **kwargs)`` returns an object 'ProductObject' that contains the information given about the product.

	:param `**kwargs`: optional arguments for UploadProduct.
	:returns: ProductObject - The object that represents this product.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadproduct.
	"""


class UploadInventory(Function):
	"""
	The allowed input signatures of UploadInventory without optional arguments (kwargs) are:

	``UploadInventory(Product, **kwargs)`` returns an 'Inventory' object specifying how to keep the specified 'Product' in stock.

	:param Product: The product or stock solution to keep in stock.
	:param `**kwargs`: optional arguments for UploadInventory.
	:returns: Inventory - The inventory object specifying how to keep the input product in stock.

	``UploadInventory(ExistingInventory, **kwargs)`` returns the 'Inventory' object updated according to the specified options.

	:param ExistingInventory: The inventory object to be updated.
	:param `**kwargs`: optional arguments for UploadInventory.
	:returns: Inventory - The inventory object updated according to the specified options.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadinventory.
	"""


class UploadCompanySupplier(Function):
	"""
	The allowed input signatures of UploadCompanySupplier without optional arguments (kwargs) are:

	``UploadCompanySupplier(SupplierName, **kwargs)`` returns an object 'SupplierObject' that contains the information given about the supplier.

	:param SupplierName: The name of the supplier.
	:param `**kwargs`: optional arguments for UploadCompanySupplier.
	:returns: SupplierObject - The object that represents this supplier.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadcompanysupplier.
	"""


class UploadCompanyService(Function):
	"""
	The allowed input signatures of UploadCompanyService without optional arguments (kwargs) are:

	``UploadCompanyService(CompanyName, **kwargs)`` creates a new 'CompanyObject' with Name: 'CompanyName' that synthesizes custom-made samples as a service.

	:param CompanyName: The name of the company.
	:param `**kwargs`: optional arguments for UploadCompanyService.
	:returns: CompanyObject - The newly-created company.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadcompanyservice.
	"""


class UploadReferenceElectrodeModel(Function):
	"""
	The allowed input signatures of UploadReferenceElectrodeModel without optional arguments (kwargs) are:

	``UploadReferenceElectrodeModel(, **kwargs)`` creates a new 'ReferenceElectrodeModel' that contains information about the material, working limits, and storage conditions of the reference electrode.

	:param `**kwargs`: optional arguments for UploadReferenceElectrodeModel.
	:returns: ReferenceElectrodeModel - The newly-created reference electrode model.

	``UploadReferenceElectrodeModel(TemplateReferenceElectrodeModel, **kwargs)`` creates a new 'ReferenceElectrodeModel' with electrode-related information provided by options and with remaining parameters drew from the 'TemplateReferenceElectrodeModel'.

	:param TemplateReferenceElectrodeModel: An existing reference electrode model from which related parameters are used as defaults when creating a new reference electrode model. The input template reference electrode model is left unmodified so as to preserve the relationship between the templateReferenceElectrodeModel and its existing objects.
	:param `**kwargs`: optional arguments for UploadReferenceElectrodeModel.
	:returns: ReferenceElectrodeModel - The newly-created reference electrode model.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadreferenceelectrodemodel.
	"""


class UploadMolecule(Function):
	"""
	The allowed input signatures of UploadMolecule without optional arguments (kwargs) are:

	``UploadMolecule(MoleculeName, **kwargs)`` returns a model 'Molecule' that contains the information given about the chemical sample.

	:param MoleculeName: The common name of this molecule.
	:param `**kwargs`: optional arguments for UploadMolecule.
	:returns: Molecule - The model that represents this chemical sample.

	``UploadMolecule(AtomicStructure, **kwargs)`` returns a model 'Molecule' based on the provided options and the structure specified by 'myMolecule'. The molecular structure of 'myMolecule' can be either drawn or explicitly given using the Molecule[".."] function.

	:param AtomicStructure: The molecular structure of the molecule, to be either drawn or explicitly given using the Molecule[".."] function. The molecule will be used as a template when determining default values for unspecified options.
	:param `**kwargs`: optional arguments for UploadMolecule.
	:returns: Molecule - The model that represents this chemical sample.

	``UploadMolecule(PubChem, **kwargs)`` returns a model 'Molecule' that contains the information given about the chemical sample.

	:param PubChem: Enter the PubChem identifier of the chemical to upload, wrapped in a PubChem[...] head. (Ex. PubChem[679] is the ID of DMSO).
	:param `**kwargs`: optional arguments for UploadMolecule.
	:returns: Molecule - The model that represents this chemical sample.

	``UploadMolecule(MoleculeInChI, **kwargs)`` returns a model 'Molecule' that contains the information given about the chemical sample.

	:param MoleculeInChI: The International Chemical Identifier (InChI) of the molecule.
	:param `**kwargs`: optional arguments for UploadMolecule.
	:returns: Molecule - The model that represents this chemical sample.

	``UploadMolecule(MoleculeInChIKey, **kwargs)`` returns a model 'Molecule' that contains the information given about the chemical sample.

	:param MoleculeInChIKey: The International Chemical Identifier (InChI) key of the molecule.
	:param `**kwargs`: optional arguments for UploadMolecule.
	:returns: Molecule - The model that represents this chemical sample.

	``UploadMolecule(MoleculeCAS, **kwargs)`` returns a model 'Molecule' that contains the information given about the chemical sample.

	:param MoleculeCAS: The Chemical Abstracts Service (CAS) number of this chemical.
	:param `**kwargs`: optional arguments for UploadMolecule.
	:returns: Molecule - The model that represents this chemical sample.

	``UploadMolecule(ThermoFisherURL, **kwargs)`` returns a model 'Molecule' that contains the information given about the chemical sample.

	:param ThermoFisherURL: The URL of the ThermoFisher product page of this chemical.
	:param `**kwargs`: optional arguments for UploadMolecule.
	:returns: Molecule - The model that represents this chemical sample.

	``UploadMolecule(MilliporeSigmaURL, **kwargs)`` returns a model 'Molecule' that contains the information given about the chemical sample.

	:param MilliporeSigmaURL: The URL of the MilliporeSigma product page of this chemical.
	:param `**kwargs`: optional arguments for UploadMolecule.
	:returns: Molecule - The model that represents this chemical sample.

	``UploadMolecule(TemplateObject, **kwargs)`` returns a model 'Molecule' based on the provided options and the values found in 'TemplateObject'.

	:param TemplateObject: An object to be used as a template when determining default values for unspecified options.
	:param `**kwargs`: optional arguments for UploadMolecule.
	:returns: Molecule - The model that represents this chemical sample.

	``UploadMolecule(, **kwargs)`` returns a model 'Molecule' that contains the information given about the chemical sample.

	:param `**kwargs`: optional arguments for UploadMolecule.
	:returns: Molecule - The model that represents this chemical sample.

	``UploadMolecule(List, **kwargs)`` returns an index-matched list of 'Molecules' that contains the information given about the chemical sample, based on the given list 'List'.

	:param List: A list of inputs to base the creation of new chemical models on.
	:param `**kwargs`: optional arguments for UploadMolecule.
	:returns: Molecule - The model that represents this chemical sample.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadmolecule.
	"""


class UploadOligomer(Function):
	"""
	The allowed input signatures of UploadOligomer without optional arguments (kwargs) are:

	``UploadOligomer(Inputs, **kwargs)`` creates/updates a model 'OligomerModel' that contains the information given about the oligomer.

	:param Inputs: The new names and/or existing objects that should be updated with information given about the oligomer.
	:param `**kwargs`: optional arguments for UploadOligomer.
	:returns: OligomerModel - The model that represents this oligomer.

	``UploadOligomer(OligomerName, **kwargs)`` returns a new model 'OligomerModel' that contains the information given about the oligomer.

	:param OligomerName: The common name of this oligomer.
	:param `**kwargs`: optional arguments for UploadOligomer.
	:returns: OligomerModel - The model that represents this oligomer.

	``UploadOligomer(OligomerObject, **kwargs)`` updates an existing model 'OligomerModel' that contains the information given about the oligomer.

	:param OligomerObject: The existing Model[Molecule, Oligomer] object that should be updated.
	:param `**kwargs`: optional arguments for UploadOligomer.
	:returns: OligomerModel - The model that represents this oligomer.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadoligomer.
	"""


class UploadProtein(Function):
	"""
	The allowed input signatures of UploadProtein without optional arguments (kwargs) are:

	``UploadProtein(Inputs, **kwargs)`` creates/updates a model 'ProteinModel' that contains the information given about the protein.

	:param Inputs: The new names and/or existing objects that should be updated with information given about the protein.
	:param `**kwargs`: optional arguments for UploadProtein.
	:returns: ProteinModel - The model that represents this protein.

	``UploadProtein(ProteinName, **kwargs)`` returns a new model 'ProteinModel' that contains the information given about the protein.

	:param ProteinName: The common name of this protein.
	:param `**kwargs`: optional arguments for UploadProtein.
	:returns: ProteinModel - The model that represents this protein.

	``UploadProtein(ProteinObject, **kwargs)`` updates an existing model 'ProteinModel' that contains the information given about the protein.

	:param ProteinObject: The existing Model[Molecule, Protein] object that should be updated.
	:param `**kwargs`: optional arguments for UploadProtein.
	:returns: ProteinModel - The model that represents this protein.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadprotein.
	"""


class UploadAntibody(Function):
	"""
	The allowed input signatures of UploadAntibody without optional arguments (kwargs) are:

	``UploadAntibody(Inputs, **kwargs)`` creates/updates a model 'AntibodyModel' that contains the information given about the antibody.

	:param Inputs: The new names and/or existing objects that should be updated with information given about the antibody.
	:param `**kwargs`: optional arguments for UploadAntibody.
	:returns: AntibodyModel - The model that represents this antibody.

	``UploadAntibody(AntibodyName, **kwargs)`` returns a new model 'AntibodyModel' that contains the information given about the antibody.

	:param AntibodyName: The common name of this antibody.
	:param `**kwargs`: optional arguments for UploadAntibody.
	:returns: AntibodyModel - The model that represents this antibody.

	``UploadAntibody(AntibodyObject, **kwargs)`` updates an existing model 'AntibodyModel' that contains the information given about the antibody.

	:param AntibodyObject: The existing Model[Molecule, Protein, Antibody] object that should be updated.
	:param `**kwargs`: optional arguments for UploadAntibody.
	:returns: AntibodyModel - The model that represents this antibody.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadantibody.
	"""


class UploadCarbohydrate(Function):
	"""
	The allowed input signatures of UploadCarbohydrate without optional arguments (kwargs) are:

	``UploadCarbohydrate(Inputs, **kwargs)`` creates/updates a model 'CarbohydrateModel' that contains the information given about the carbohydrate.

	:param Inputs: The new names and/or existing objects that should be updated with information given about the carbohydrate.
	:param `**kwargs`: optional arguments for UploadCarbohydrate.
	:returns: CarbohydrateModel - The model that represents this carbohydrate.

	``UploadCarbohydrate(CarbohydrateName, **kwargs)`` returns a new model 'CarbohydrateModel' that contains the information given about the carbohydrate.

	:param CarbohydrateName: The common name of this carbohydrate.
	:param `**kwargs`: optional arguments for UploadCarbohydrate.
	:returns: CarbohydrateModel - The model that represents this carbohydrate.

	``UploadCarbohydrate(CarbohydrateObject, **kwargs)`` updates an existing model 'CarbohydrateModel' that contains the information given about the carbohydrate.

	:param CarbohydrateObject: The existing Model[Molecule, Carbohydrate] object that should be updated.
	:param `**kwargs`: optional arguments for UploadCarbohydrate.
	:returns: CarbohydrateModel - The model that represents this carbohydrate.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadcarbohydrate.
	"""


class UploadVirus(Function):
	"""
	The allowed input signatures of UploadVirus without optional arguments (kwargs) are:

	``UploadVirus(Inputs, **kwargs)`` creates/updates a model 'VirusModel' that contains the information given about the virus.

	:param Inputs: The new names and/or existing objects that should be updated with information given about the virus.
	:param `**kwargs`: optional arguments for UploadVirus.
	:returns: VirusModel - The model that represents this virus.

	``UploadVirus(VirusName, **kwargs)`` returns a new model 'VirusModel' that contains the information given about the virus.

	:param VirusName: The common name of this virus.
	:param `**kwargs`: optional arguments for UploadVirus.
	:returns: VirusModel - The model that represents this virus.

	``UploadVirus(VirusObject, **kwargs)`` updates an existing model 'VirusModel' that contains the information given about the virus.

	:param VirusObject: The existing Model[Virus] object that should be updated.
	:param `**kwargs`: optional arguments for UploadVirus.
	:returns: VirusModel - The model that represents this virus.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadvirus.
	"""


class UploadMammalianCell(Function):
	"""
	The allowed input signatures of UploadMammalianCell without optional arguments (kwargs) are:

	``UploadMammalianCell(Inputs, **kwargs)`` creates/updates a model 'MammalianModel' that contains the information given about the mammalian.

	:param Inputs: The new names and/or existing objects that should be updated with information given about the mammalian.
	:param `**kwargs`: optional arguments for UploadMammalianCell.
	:returns: MammalianModel - The model that represents this mammalian.

	``UploadMammalianCell(MammalianName, **kwargs)`` returns a new model 'MammalianModel' that contains the information given about the mammalian.

	:param MammalianName: The common name of this mammalian.
	:param `**kwargs`: optional arguments for UploadMammalianCell.
	:returns: MammalianModel - The model that represents this mammalian.

	``UploadMammalianCell(MammalianObject, **kwargs)`` updates an existing model 'MammalianModel' that contains the information given about the mammalian.

	:param MammalianObject: The existing Model[Cell, Mammalian] object that should be updated.
	:param `**kwargs`: optional arguments for UploadMammalianCell.
	:returns: MammalianModel - The model that represents this mammalian.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadmammaliancell.
	"""


class UploadBacterialCell(Function):
	"""
	The allowed input signatures of UploadBacterialCell without optional arguments (kwargs) are:

	``UploadBacterialCell(Inputs, **kwargs)`` creates/updates a model 'BacteriaModel' that contains the information given about the bacteria.

	:param Inputs: The new names and/or existing objects that should be updated with information given about the bacteria.
	:param `**kwargs`: optional arguments for UploadBacterialCell.
	:returns: BacteriaModel - The model that represents this bacteria.

	``UploadBacterialCell(BacteriaName, **kwargs)`` returns a new model 'BacteriaModel' that contains the information given about the bacteria.

	:param BacteriaName: The common name of this bacteria.
	:param `**kwargs`: optional arguments for UploadBacterialCell.
	:returns: BacteriaModel - The model that represents this bacteria.

	``UploadBacterialCell(BacteriaObject, **kwargs)`` updates an existing model 'BacteriaModel' that contains the information given about the bacteria.

	:param BacteriaObject: The existing Model[Cell, Bacteria] object that should be updated.
	:param `**kwargs`: optional arguments for UploadBacterialCell.
	:returns: BacteriaModel - The model that represents this bacteria.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadbacterialcell.
	"""


class UploadYeastCell(Function):
	"""
	The allowed input signatures of UploadYeastCell without optional arguments (kwargs) are:

	``UploadYeastCell(Inputs, **kwargs)`` creates/updates a model 'YeastModel' that contains the information given about the yeast.

	:param Inputs: The new names and/or existing objects that should be updated with information given about the yeast.
	:param `**kwargs`: optional arguments for UploadYeastCell.
	:returns: YeastModel - The model that represents this yeast.

	``UploadYeastCell(YeastName, **kwargs)`` returns a new model 'YeastModel' that contains the information given about the yeast.

	:param YeastName: The common name of this yeast.
	:param `**kwargs`: optional arguments for UploadYeastCell.
	:returns: YeastModel - The model that represents this yeast.

	``UploadYeastCell(YeastObject, **kwargs)`` updates an existing model 'YeastModel' that contains the information given about the yeast.

	:param YeastObject: The existing Model[Cell, Yeast] object that should be updated.
	:param `**kwargs`: optional arguments for UploadYeastCell.
	:returns: YeastModel - The model that represents this yeast.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadyeastcell.
	"""


class UploadTissue(Function):
	"""
	The allowed input signatures of UploadTissue without optional arguments (kwargs) are:

	``UploadTissue(Inputs, **kwargs)`` creates/updates a model 'TissueModel' that contains the information given about the tissue.

	:param Inputs: The new names and/or existing objects that should be updated with information given about the tissue.
	:param `**kwargs`: optional arguments for UploadTissue.
	:returns: TissueModel - The model that represents this tissue.

	``UploadTissue(TissueName, **kwargs)`` returns a new model 'TissueModel' that contains the information given about the tissue.

	:param TissueName: The common name of this tissue.
	:param `**kwargs`: optional arguments for UploadTissue.
	:returns: TissueModel - The model that represents this tissue.

	``UploadTissue(TissueObject, **kwargs)`` updates an existing model 'TissueModel' that contains the information given about the tissue.

	:param TissueObject: The existing Model[Tissue] object that should be updated.
	:param `**kwargs`: optional arguments for UploadTissue.
	:returns: TissueModel - The model that represents this tissue.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadtissue.
	"""


class UploadLysate(Function):
	"""
	The allowed input signatures of UploadLysate without optional arguments (kwargs) are:

	``UploadLysate(Inputs, **kwargs)`` creates/updates a model 'LysateModel' that contains the information given about the lysate.

	:param Inputs: The new names and/or existing objects that should be updated with information given about the lysate.
	:param `**kwargs`: optional arguments for UploadLysate.
	:returns: LysateModel - The model that represents this lysate.

	``UploadLysate(LysateName, **kwargs)`` returns a new model 'LysateModel' that contains the information given about the lysate.

	:param LysateName: The common name of this lysate.
	:param `**kwargs`: optional arguments for UploadLysate.
	:returns: LysateModel - The model that represents this lysate.

	``UploadLysate(LysateObject, **kwargs)`` updates an existing model 'LysateModel' that contains the information given about the lysate.

	:param LysateObject: The existing Model[Lysate] object that should be updated.
	:param `**kwargs`: optional arguments for UploadLysate.
	:returns: LysateModel - The model that represents this lysate.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadlysate.
	"""


class UploadSpecies(Function):
	"""
	The allowed input signatures of UploadSpecies without optional arguments (kwargs) are:

	``UploadSpecies(Inputs, **kwargs)`` creates/updates a model 'SpeciesModel' that contains the information given about the species.

	:param Inputs: The new names and/or existing objects that should be updated with information given about the species.
	:param `**kwargs`: optional arguments for UploadSpecies.
	:returns: SpeciesModel - The model that represents this species.

	``UploadSpecies(SpeciesName, **kwargs)`` returns a new model 'SpeciesModel' that contains the information given about the species.

	:param SpeciesName: The common name of this species.
	:param `**kwargs`: optional arguments for UploadSpecies.
	:returns: SpeciesModel - The model that represents this species.

	``UploadSpecies(SpeciesObject, **kwargs)`` updates an existing model 'SpeciesModel' that contains the information given about the species.

	:param SpeciesObject: The existing Model[Species] object that should be updated.
	:param `**kwargs`: optional arguments for UploadSpecies.
	:returns: SpeciesModel - The model that represents this species.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadspecies.
	"""


class UploadResin(Function):
	"""
	The allowed input signatures of UploadResin without optional arguments (kwargs) are:

	``UploadResin(Inputs, **kwargs)`` creates/updates a model 'ResinModel' that contains the information given about the resin.

	:param Inputs: The new names and/or existing objects that should be updated with information given about the resin.
	:param `**kwargs`: optional arguments for UploadResin.
	:returns: ResinModel - The model that represents this resin.

	``UploadResin(ResinName, **kwargs)`` returns a new model 'ResinModel' that contains the information given about the resin.

	:param ResinName: The common name of this resin.
	:param `**kwargs`: optional arguments for UploadResin.
	:returns: ResinModel - The model that represents this resin.

	``UploadResin(ResinObject, **kwargs)`` updates an existing model 'ResinModel' that contains the information given about the resin.

	:param ResinObject: The existing Model[Resin] object that should be updated.
	:param `**kwargs`: optional arguments for UploadResin.
	:returns: ResinModel - The model that represents this resin.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadresin.
	"""


class UploadSolidPhaseSupport(Function):
	"""
	The allowed input signatures of UploadSolidPhaseSupport without optional arguments (kwargs) are:

	``UploadSolidPhaseSupport(Inputs, **kwargs)`` creates/updates a model 'SolidphasesupportModel' that contains the information given about the solidphasesupport.

	:param Inputs: The new names and/or existing objects that should be updated with information given about the solidphasesupport.
	:param `**kwargs`: optional arguments for UploadSolidPhaseSupport.
	:returns: SolidphasesupportModel - The model that represents this solidphasesupport.

	``UploadSolidPhaseSupport(SolidphasesupportName, **kwargs)`` returns a new model 'SolidphasesupportModel' that contains the information given about the solidphasesupport.

	:param SolidphasesupportName: The common name of this solidphasesupport.
	:param `**kwargs`: optional arguments for UploadSolidPhaseSupport.
	:returns: SolidphasesupportModel - The model that represents this solidphasesupport.

	``UploadSolidPhaseSupport(SolidphasesupportObject, **kwargs)`` updates an existing model 'SolidphasesupportModel' that contains the information given about the solidphasesupport.

	:param SolidphasesupportObject: The existing Model[Resin, SolidPhaseSupport] object that should be updated.
	:param `**kwargs`: optional arguments for UploadSolidPhaseSupport.
	:returns: SolidphasesupportModel - The model that represents this solidphasesupport.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadsolidphasesupport.
	"""


class UploadPolymer(Function):
	"""
	The allowed input signatures of UploadPolymer without optional arguments (kwargs) are:

	``UploadPolymer(Inputs, **kwargs)`` creates/updates a model 'PolymerModel' that contains the information given about the polymer.

	:param Inputs: The new names and/or existing objects that should be updated with information given about the polymer.
	:param `**kwargs`: optional arguments for UploadPolymer.
	:returns: PolymerModel - The model that represents this polymer.

	``UploadPolymer(PolymerName, **kwargs)`` returns a new model 'PolymerModel' that contains the information given about the polymer.

	:param PolymerName: The common name of this polymer.
	:param `**kwargs`: optional arguments for UploadPolymer.
	:returns: PolymerModel - The model that represents this polymer.

	``UploadPolymer(PolymerObject, **kwargs)`` updates an existing model 'PolymerModel' that contains the information given about the polymer.

	:param PolymerObject: The existing Model[Molecule, Polymer] object that should be updated.
	:param `**kwargs`: optional arguments for UploadPolymer.
	:returns: PolymerModel - The model that represents this polymer.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadpolymer.
	"""


class UploadMaterial(Function):
	"""
	The allowed input signatures of UploadMaterial without optional arguments (kwargs) are:

	``UploadMaterial(Inputs, **kwargs)`` creates/updates a model 'MaterialModel' that contains the information given about the material.

	:param Inputs: The new names and/or existing objects that should be updated with information given about the material.
	:param `**kwargs`: optional arguments for UploadMaterial.
	:returns: MaterialModel - The model that represents this material.

	``UploadMaterial(MaterialName, **kwargs)`` returns a new model 'MaterialModel' that contains the information given about the material.

	:param MaterialName: The common name of this material.
	:param `**kwargs`: optional arguments for UploadMaterial.
	:returns: MaterialModel - The model that represents this material.

	``UploadMaterial(MaterialObject, **kwargs)`` updates an existing model 'MaterialModel' that contains the information given about the material.

	:param MaterialObject: The existing Model[Material] object that should be updated.
	:param `**kwargs`: optional arguments for UploadMaterial.
	:returns: MaterialModel - The model that represents this material.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadmaterial.
	"""


class UploadModification(Function):
	"""
	The allowed input signatures of UploadModification without optional arguments (kwargs) are:

	``UploadModification(ModificationName, **kwargs)`` creates a new Model[Physics,Modification] object 'ModificationModel' with the name 'myModificationName'.

	:param ModificationName: The name of the modification to be created.
	:param `**kwargs`: optional arguments for UploadModification.
	:returns: Object - An uploaded Model[Physics,Modification] object that pass the validity checks for its fields.

	``UploadModification(TemplateObject, **kwargs)`` updates the pre-exisiting object 'myModificationObject'.

	:param TemplateObject: The name of the modification to be updated.
	:param `**kwargs`: optional arguments for UploadModification.
	:returns: ModificationModel - An uploaded Model[Physics,Modification] object that pass the validity checks for its fields.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadmodification.
	"""


class UploadGradientMethod(Function):
	"""
	The allowed input signatures of UploadGradientMethod without optional arguments (kwargs) are:

	``UploadGradientMethod(MethodName, **kwargs)`` returns an object 'MethodObject' that contains the information given about the gradient.

	:param MethodName: The name of the gradient method.
	:param `**kwargs`: optional arguments for UploadGradientMethod.
	:returns: MethodObject - The object that represents this gradient.

	``UploadGradientMethod(, **kwargs)`` returns an object 'MethodObject' that contains the information given about the gradient.

	:param `**kwargs`: optional arguments for UploadGradientMethod.
	:returns: MethodObject - The object that represents this gradient.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadgradientmethod.
	"""


class UploadFractionCollectionMethod(Function):
	"""
	The allowed input signatures of UploadFractionCollectionMethod without optional arguments (kwargs) are:

	``UploadFractionCollectionMethod(, **kwargs)`` creates a new 'MethodFractionCollection' based on the provided options.

	:param `**kwargs`: optional arguments for UploadFractionCollectionMethod.
	:returns: MethodFractionCollection - The newly-created fraction collection method.

	``UploadFractionCollectionMethod(TemplateObject, **kwargs)`` creates a new 'MethodFractionCollection' based on the provided options and the values found in the 'TemplateObject'.

	:param ExternalUpload`Private`templateObject: An object to be used as a template when determining default values for unspecified options.
	:param `**kwargs`: optional arguments for UploadFractionCollectionMethod.
	:returns: MethodFractionCollection - The newly-created fraction collection method.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadfractioncollectionmethod.
	"""


class UploadPipettingMethod(Function):
	"""
	The allowed input signatures of UploadPipettingMethod without optional arguments (kwargs) are:

	``UploadPipettingMethod(MethodName, **kwargs)`` returns an object 'MethodObject' that contains the information given about the pipetting parameters.

	:param MethodName: The name of the pipetting method.
	:param `**kwargs`: optional arguments for UploadPipettingMethod.
	:returns: MethodObject - The object that represents this gradient.

	``UploadPipettingMethod(, **kwargs)`` returns an object 'MethodObject' that contains the information given about the pipetting parameters.

	:param `**kwargs`: optional arguments for UploadPipettingMethod.
	:returns: MethodObject - The object that represents this pipetting method.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadpipettingmethod.
	"""


class UploadLiterature(Function):
	"""
	The allowed input signatures of UploadLiterature without optional arguments (kwargs) are:

	``UploadLiterature(PubMedID, **kwargs)`` uploads an Object[Report,Literature] from the given PubMed ID.

	:param PubMedID: The PubMed ID of this piece of literature.
	:param `**kwargs`: optional arguments for UploadLiterature.
	:returns: LiteratureObject - The object that represents this piece of literature.

	``UploadLiterature(EndNoteFile, **kwargs)`` uploads an Object[Report,Literature] from the given EndNote XML file.

	:param EndNoteFile: A path or URL to the EndNote XML file that represents this piece of literature.
	:param `**kwargs`: optional arguments for UploadLiterature.
	:returns: LiteratureObject - The object that represents this piece of literature.

	``UploadLiterature(EndNoteList, **kwargs)`` uploads an Object[Report,Literature] from the imported EndNote information.

	:param EndNoteList: The imported EndNote XML file (in list form) that represents this piece of literature.
	:param `**kwargs`: optional arguments for UploadLiterature.
	:returns: LiteratureObject - The object that represents this piece of literature.

	``UploadLiterature(, **kwargs)`` uploads an Object[Report,Literature].

	:param `**kwargs`: optional arguments for UploadLiterature.
	:returns: LiteratureObject - The object that represents this piece of literature.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadliterature.
	"""


class UploadJournal(Function):
	"""
	The allowed input signatures of UploadJournal without optional arguments (kwargs) are:

	``UploadJournal(JournalName, **kwargs)`` creates a new 'JournalObject' based on the provided 'JournalName' and options.

	:param JournalName: The name of this journal.
	:param `**kwargs`: optional arguments for UploadJournal.
	:returns: JournalObject - The newly-created journal object.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/uploadjournal.
	"""


class Compute(Function):
	"""
	The allowed input signatures of Compute without optional arguments (kwargs) are:

	``Compute(Expression, **kwargs)`` generates a Manifold 'Job' notebook where the statements in 'Expression' make up the contents of the job's template notebook.

	:param Expression: A compound mathematica expression, with individual expressions separated by semicolons, to convert into a template job notebook.
	:param `**kwargs`: optional arguments for Compute.
	:returns: Job - A template job notebook which may enqueue one or more computations to run on a remote, cloud-based SLL kernel.

	``Compute(Page, **kwargs)`` generates a Manifold 'Job' notebook using 'Page' as the job's template notebook.

	:param Page: A notebook page to use as this job's template notebook.
	:param `**kwargs`: optional arguments for Compute.
	:returns: Job - A template job notebook which may enqueue one or more computations to run on a remote, cloud-based SLL kernel.

	All optional parameters (kwargs) can be found in the 'Options' tab of the site: https://www.emeraldcloudlab.com/helpfiles/compute.
	"""
