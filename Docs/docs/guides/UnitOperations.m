(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Unit Operations",
	Abstract -> "Collection of functions for remotely conducting self-contained sample manipulations in an ECL facility.",
	Reference -> {
		"Sample Preparation" -> {
			{ExperimentSamplePreparation,"Generates a protocol that executes the specified manual or robotic unit operations of sample preparation."},
			{ExperimentManualSamplePreparation,"Generates a protocol that allows for the incubation, mixing, centrifugation, filtration, volume and mass transfers as well as other manual preparation of samples."},
			{ExperimentRoboticSamplePreparation,"Generates a protocol that uses a robotically integrated liquid handler to perform incubation, mixing, centrifugation, filtration, transfer of liquids and other general preparation of samples."},
			{Aliquot, "A detailed set of parameters that describes moving a single source to multiple destinations."},
			{Cover, "A detailed set of parameters that describes covering a sample container with a lid of a specified type."},
			{FillToVolume, "A detailed set of parameters that describe transferring a source into a destination until a desired volume is reached."},
			{Filter, "A detailed set of parameters that describes separating particles bigger than a specific size from a solution via filtering."},
			{Incubate, "A detailed set of parameters that describes incubating and mixing a sample at a specified temperature and shaking rate for a specified amount of time."},
			{LabelContainer, "A detailed set of parameters that labels a container for use in other unit operations."},
			{LabelSample, "A detailed set of parameters that labels a sample in a container for use by other unit operations."},
			{Mix, "A detailed set of parameters that describes mixing a sample using bench-top instrumentation or by pipetting on a micro liquid handling robot."},
			{MoveToMagnet, "A detailed set of parameters that describe subjecting a sample to a magnetic field."},
			{Pellet, "A detailed set of parameters that describes precipitating a sample out of solution by centrifugal spinning."},
			{Placement, "A detailed set of parameters that describe moving an item into a destination."},
			{RemoveFromMagnet, "A detailed set of parameters that describes removing a sample from magnetization."},
			{Resuspend, "A detailed set of parameters that describes bringing a substance into solution by pipetting liquid onto a solidified sample."},
			{SerialDilute, "A detailed set of parameters that describes repeatedly diluting an initial sample with a given buffer to yield a series of samples with decreasing concentration."},
			{Transfer, "A detailed set of parameters that describe transferring a source to a destination."},
			{Wait, "A unit operation that describes a pause in a protocol."},
			{VisualInspection, "A detailed set of parameters that describes how the sample should be inspected visually during a protocol."},
			{Uncover, "A set of instructions that describes removing a lid from a plate."},
			{Centrifuge, "A detailed set of instructions that describes spinning the sample in a centrifuge at a specified intensity for a specified amount of time."}
		},
		"Synthesis" -> {
			{Coupling, "Generates an solid phase synthesis primitive."},
			{Deprotonating, "A detailed set of parameters that describes how a proton is removed from a strand during solid phase synthesis."},
			{Swelling, "A unit operation that describes how resin chains will be solvated in order to expose linker sites used as start points for solid phase synthesis."},
			{Cleaving, "A detailed set of parameters that describe how the synthesized strand is removed from its solid support at the end of solid phase synthesis."},
			{Deprotecting, "A detailed set of parameters that describe how a blocking group is chemically eliminated from a strand during solid phase synthesis."},
			{Washing, "A set of instructions that describe how the previous step's chemicals will be removed from the resin by flowing solvent through it into waste during solid phase synthesis."},
			{Capping, "A set of instructions that describe how a blocking group is chemically copuled to a strand during solid phase synthesis."}
		},
		"Separation Techniques" -> {
			{Filter, "A detailed set of parameters that describes separating particles bigger than a specific size from a solution via filtering."},
			{Pellet, "A detailed set of parameters that describes precipitating a sample out of solution by centrifugal spinning."},
			{MoveToMagnet, "A detailed set of parameters that describe subjecting a sample to a magnetic field."},
			{RemoveFromMagnet, "A detailed set of parameters that describes removing a sample from magnetization."}
		},
		"Spectroscopy Experiments" -> {
			{AbsorbanceIntensity, "A unit operation that measures the absorbance intensity of the given samples, subject to supplied options and configurations."},
			{AbsorbanceKinetics, "A detailed set of parameters that describes measuring the absorbance of the specified samples over a period of time."},
			{AbsorbanceSpectroscopy, "A detailed set of parameters that describes measuring the absorbance of the specified samples at specified wavelength."},
			{ReadPlate, "A detailed set of parameters that describe placing a sample-containing microwell plate into a plate-reader instrument for defined spectroscopic measurements."}
		},
		"Bioassays" -> {
			{Wash, "A unit operation that describes how a part of the biolayer interferometry experiment is carried out."}
		}
	},
	RelatedGuides -> {
		GuideLink["Running Experiments"],
		GuideLink["Validating Experiments"],
		GuideLink["ExperimentTrackingAndManagement"],
		GuideLink["FacilitiesCapabilitiesAndLimitations"],
		GuideLink["PricingFunctions"]
	}
]