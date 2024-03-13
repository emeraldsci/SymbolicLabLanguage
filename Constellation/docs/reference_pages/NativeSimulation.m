(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineUsage[CreateNativeSimulation,{
  BasicDefinitions->{
    {"CreateNativeSimulation[]", "id", "creates a new simulation cache in Telescope and returns the ID associated with it."},
    {"CreateNativeSimulation[id]", "id", "creates a new simulation cache in Telescope with the given id."}
  },
  Input :> {
    {"id", _String, "Unique identifier for the NativeSimulation."}
  },
  Output:>{
    {"id", Alternatives[_String, $Failed], "The id that will be used to reference the created Simulation. If something went wrong during the operation, returns $Failed."}
  },
  SeeAlso->{
    "ListNativeSimulations",
    "GetNativeSimulation",
    "UpdateNativeSimulation",
    "DeleteNativeSimulation",
    "CloneNativeSimulation"
  },
  Author->{"platform"}
}];

DefineUsage[ListNativeSimulations,{
  BasicDefinitions->{
    {"ListNativeSimulations[]", "simulationInfo", "lists all existing simulation caches in Telescope."}
  },
  Output:>{
    {"simulationInfo", Alternatives[{simulationInfo...},$Failed], "A list of associations each containing an ID and a Name key. If something went wrong during the operation, returns $Failed."}
  },
  SeeAlso->{
    "CreateNativeSimulation",
    "GetNativeSimulation",
    "UpdateNativeSimulation",
    "DeleteNativeSimulation",
    "CloneNativeSimulation"
  },
  Author->{"platform"}
}];

DefineUsage[GetNativeSimulation,{
  BasicDefinitions->{
    {"GetNativeSimulation[id]", "simulationInfo", "gets information about the specified simulation cache in Telescope."}
  },
  Input :> {
    {"id", _String, "The unique cache identifier."}
  },
  Output:>{
    {"simulationInfo", Alternatives[simulationInfo, $Failed], "An associations containing an ID and a Name key. If no simulation exists with the given ID returns $Failed."}
  },
  SeeAlso->{
    "CreateNativeSimulation",
    "ListNativeSimulations",
    "UpdateNativeSimulation",
    "DeleteNativeSimulation",
    "CloneNativeSimulation"
  },
  Author->{"platform"}
}];

DefineUsage[UpdateNativeSimulation,{
  BasicDefinitions->{
    {"UpdateNativeSimulation[id, packets]", "ok", "updates the specified simulation cache in Telescope."}
  },
  Input :> {
    {"id", _String, "The unique cache identifier."},
    {"packets", {PacketP[]...}, "The packets to add to the cache."}
  },
  Output:>{
    {"ok", Alternatives[True, $Failed], "True if the update was successful and $Failed otherwise."}
  },
  MoreInformation -> {
    "If the Telescope cache already contains objects from the packets provided to UpdateNativeSimulation, the objects are overwritten with the new values."
  },
  SeeAlso->{
    "CreateNativeSimulation",
    "ListNativeSimulations",
    "GetNativeSimulation",
    "DeleteNativeSimulation",
    "CloneNativeSimulation"
  },
  Author->{"platform"}
}];

DefineUsage[DeleteNativeSimulation,{
  BasicDefinitions->{
    {"DeleteNativeSimulation[id]", "ok", "deletes the specified simulation cache in Telescope."}
  },
  Input :> {
    {"id", _String, "The unique cache identifier."}
  },
  Output:>{
    {"ok", Alternatives[Null, $Failed], "True if the deletion was successful and $Failed otherwise."}
  },
  SeeAlso->{
    "CreateNativeSimulation",
    "ListNativeSimulations",
    "GetNativeSimulation",
    "UpdateNativeSimulation",
    "CloneNativeSimulation"
  },
  Author->{"platform"}
}];

DefineUsage[CloneNativeSimulation,{
  BasicDefinitions->{
    {"CloneNativeSimulation[id]", "id", "creates a copy of the NativeSimulation with ID, id. Returns the newly created ID of the copy."}
  },
  Input :> {
    {"id", _String, "Unique identifier for the NativeSimulation to be copied."}
  },
  Output:>{
    {"id", Alternatives[_String, $Failed], "The id that will be used to reference the created Simulation. If something went wrong during the operation, returns $Failed."}
  },
  SeeAlso->{
    "CreateNativeSimulation",
    "ListNativeSimulations",
    "GetNativeSimulation",
    "UpdateNativeSimulation",
    "DeleteNativeSimulation"
  },
  Author->{"platform"}
}];