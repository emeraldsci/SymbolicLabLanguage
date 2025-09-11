(* ::Package:: *)

(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*Input Messages*)


Warning::SampleStowaways="The input samples to this experiment reside in container(s) `1`, however these containers contain additional samples (`2`) which weren't provided as input. In order to avoid modifying these additional samples, the input samples will be transferred into a new container before beginning the experiment. If this is undesired please re-run the experiment function using the container you wish to run the experiment on as the input.";


(* ::Subsection:: *)
(*General Option Messages*)


Warning::Nonsterile="Some of the specified object (`1`) are non-sterile and will come into contact with your input samples (`2`), which are presently sterile.  If you wish to avoid risking lost of sterilization, please consider using sterile samples in lieu of `2`.";
Error::ImmobileSamples = "Samples in immobile containers cannot be `1` because their containers are fixed in place and cannot be moved to a `2`. Check: `3`";
Error::ConfirmUploadConflict="A protocol cannot be confirmed if Upload is False.";
Error::ConflictingUnitOperationMethodRequirements="The following requirements can only be performed manually: `1`. However, the following requirements can only be performed robotically: `2`. Please resolve this conflict in order to submit a valid protocol.";
Error::ConflictingMethodRequirements="The following requirements can only be performed manually: `1`. However, the following requirements can only be performed robotically: `2`. Please resolve this conflict in order to submit a valid request.";


(* ::Subsection:: *)
(*Instrument Option Messages*)


Warning::InstrumentPrecision="The machine precision of `1` has a resolution of `2`. Therefore, `3` will have to be rounded to `4` to proceed. To avoid automatic rounding, please provide a value that meets the resolution.";


(* ::Subsection:: *)
(*Aliquot Option Messages*)


Error::AliquotRequired="For the following samples (`1`) you've requested Aliquot->False, but these samples are in containers physically incompatible with the instrument. Please set Aliquot->True to allow these samples to be transferred automatically into containers compatible with the instrument.";
Error::InvalidAliquotContainer="AliquotContainer must be compatible with `1`. Please specify one of the following container models: `2`";
Error::ReplicateAliquotsRequired="For the following samples (`1`) you've requested Aliquot->False, but aliquots of these samples will need to be created in order to satisfy the request for `2` replicates. Please either set Aliquot->True, or set NumberOfReplicates->1 to continue.";

Error::ContainerOutMismatchedIndex = "The following ContainerOut specification(s) have the same index specified for multiple different containers: `1`.  Please check the ContainerOut option to ensure different containers do not have the same index.";
Error::ContainerOverOccupied = "The following ContainerOut specification(s) `1` request more position(s) in the destination container(s) (`2`) than the container(s) have (`3`).  This may occur if you specify container indices while also using the NumberOfReplicates option, or if you use a non-empty container.  Please consider splitting these requests into multiple different containers.";


