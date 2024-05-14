(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: User *)
(* :Date: 2023-05-17 *)


DefineUsage[convertCellCompositions,
  {
    BasicDefinitions -> {
      {"convertCellCompositions[samplePackets]", "list of samplePackets", "convert the units of cell compositions to cell/mL if StandardCurves can be found in corresponding cell model."}
    },
    Input :> {

      {
        "samplePackets", ListableP[PacketP], "A list of sample packets whose units need to be converted."
      }
    },
    Output :> {
      {
        "list of samplePackets", {PacketP..}, "A list of samplePackets whose cell compositions are in cell/mL if StandardCurves can be found in corresponding cell model."
      }
    },
    SeeAlso -> {
      "ExperimentWashCells",
      "ExperimentChangeMedia"
    },
    Author -> {"xu.yi", "jireh.sacramento"}
  }
];