(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentDynamicLightScattering*)

DefineUsage[ExperimentDynamicLightScattering,
  {
    BasicDefinitions->{
      {
        Definition->{"ExperimentDynamicLightScattering[Samples]", "Protocol"},
        Description->"Generates a 'Protocol' object to run a Dynamic Light Scattering (DLS) experiment. DLS can be used to measure the size, polydispersity, thermal stability, and attractive/repulsive interactions of particles in solution. Concomitant static light scattering can be used to measure the molecular weight of particles in solution.",
        Inputs:>{
          IndexMatching[
            {
              InputName->"Samples",
              Description->"The samples to be run in a dynamic light scattering experiment.",
              Widget->
                  Widget[
                    Type->Object,
                    Pattern:>ObjectP[{Object[Sample],Object[Container]}],
                    Dereference->{
                      Object[Container]->Field[Contents[[All, 2]]]
                    }
                  ],
              Expandable->False
            },
            IndexName->"experiment samples"
          ]
        },
        Outputs:>{
          {
            OutputName->"Protocol",
            Description->"A protocol object that describes the dynamic light scattering experiment to be run.",
            Pattern:>ObjectP[Object[Protocol,DynamicLightScattering]]
          }
        }
      }
    },
    MoreInformation->{
    },
    SeeAlso->{
      "ExperimentDynamicLightScatteringOptions",
      "ExperimentDynamicLightScatteringPreview",
      "ValidExperimentDynamicLightScatteringQ",
      "ExperimentThermalShift",
      "ExperimentCountLiquidParticles",
      "ExperimentNephelometry",
      "ExperimentFluorescencePolarization",
      "ExperimentUVMelting"
    },
    Tutorials->{
      "Sample Preparation"
    },
    Author->{"daniel.shlian", "tyler.pabst"}
  }
]