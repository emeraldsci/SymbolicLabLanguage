(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

NativeSimulation::UnexpectedTelescopeResponse="Got an unexpected response from Telescope. Response: `1`";
NativeSimulation::InternalCacheError="`1`";
NativeSimulation::CacheIDDoesNotExist="`1`";
NativeSimulation::InvalidCacheKind="`1`";
NativeSimulation::InvalidCacheID="`1`";

nativeCacheErrorResponseP=KeyValuePattern[{"Error"->_String,"Message"->_String}];
nativeCacheNativeWarningsResponseP=KeyValuePattern[{"Warnings"->List[KeyValuePattern[{"Name"->_String,"Arguments"->List[_String...]}]...]}];

nativeCacheMetaDataP=KeyValuePattern[{"ID"->_String,"Kind"->_String,"Name"->_String}];

nativeCacheCreateResponseP=nativeCacheMetaDataP;
nativeCacheReadResponseP=nativeCacheMetaDataP;
nativeCacheCloneResponseP=nativeCacheMetaDataP;
nativeCacheListResponseP=KeyValuePattern[{"Caches"->{nativeCacheMetaDataP...}}];
nativeCacheUpdatePacketsResponseP=KeyValuePattern[{"Success"->True}];
nativeCacheDeleteResponseP=nativeCacheUpdatePacketsResponseP;

Authors[CreateNativeSimulation]:= {"platform"};
CreateNativeSimulation[]:=With[
  {
    response=GoCall["NativeCacheCreate",<|"Kind"->"simulation"|>]
  },
  Switch[response,
    nativeCacheCreateResponseP,response["ID"],
    nativeCacheErrorResponseP,handleErrorResponse[response],
    _,Message[NativeSimulation::UnexpectedTelescopeResponse,response];$Failed
  ]
];
CreateNativeSimulation[id_String]:=With[
  {
    response=GoCall["NativeCacheCreate",<|"Kind"->"simulation","ID"->id|>]
  },
  Switch[response,
    nativeCacheCreateResponseP,response["ID"],
    nativeCacheErrorResponseP,handleErrorResponse[response],
    _,Message[NativeSimulation::UnexpectedTelescopeResponse,response];$Failed
  ]
];

Authors[ListNativeSimulations]:= {"platform"};
ListNativeSimulations[]:=With[
  {
    response=GoCall["NativeCacheList"]
  },
  Switch[response,
    nativeCacheListResponseP,formatNativeSimulationList[response["Caches"]],
    nativeCacheErrorResponseP,handleErrorResponse[response],
    _,Message[NativeSimulation::UnexpectedTelescopeResponse,response];$Failed
  ]
];

Authors[GetNativeSimulation]:= {"platform"};
GetNativeSimulation[id_String]:=With[
  {
    response=GoCall["NativeCacheRead",<|"ID"->id|>]
  },
  Switch[response,
    nativeCacheReadResponseP,response/.RuleDelayed[KeyValuePattern[{"ID"->simulationID_}],<|"ID"->simulationID|>],
    nativeCacheErrorResponseP,handleErrorResponse[response],
    _,Message[NativeSimulation::UnexpectedTelescopeResponse,response];$Failed
  ]
];

Authors[UpdateNativeSimulation]:= {"platform"};
UpdateNativeSimulation[id_String,packets:{PacketP[]...}]:=With[
  {
    response=GoCall["NativeCacheUpdatePackets",<|"ID"->id,"Packets"->ToString[GoLink`Private`filterExplicitCache[packets],InputForm]|>]
  },
  Switch[response,
    And[nativeCacheUpdatePacketsResponseP,Except[nativeCacheNativeWarningsResponseP]],True,
    nativeCacheNativeWarningsResponseP,handleWarningResponse[response];True,
    nativeCacheErrorResponseP,handleErrorResponse[response],
    _,Message[NativeSimulation::UnexpectedTelescopeResponse,response];$Failed
  ]
];

Authors[DeleteNativeSimulation]:= {"platform"};
DeleteNativeSimulation[id_String]:=With[
  {
    response=GoCall["NativeCacheDelete",<|"ID"->id|>]
  },
  Switch[response,
    nativeCacheDeleteResponseP,True,
    nativeCacheErrorResponseP,handleErrorResponse[response],
    _,Message[NativeSimulation::UnexpectedTelescopeResponse,response];$Failed
  ]
];

Authors[CloneNativeSimulation]:= {"platform"};
CloneNativeSimulation[id_String]:=With[
  {
    response=GoCall["NativeCacheClone",<|"ID"->id|>]
  },
  Switch[response,
    nativeCacheCloneResponseP,response["ID"],
    nativeCacheErrorResponseP,handleErrorResponse[response],
    _,Message[NativeSimulation::UnexpectedTelescopeResponse,response];$Failed
  ]
];

handleErrorResponse[response:nativeCacheErrorResponseP]:=Switch[response["Error"],
  "InternalCacheError",Message[NativeSimulation::InternalCacheError,response["Message"]];$Failed,
  "CacheIDDoesNotExist",Message[NativeSimulation::CacheIDDoesNotExist,response["Message"]];$Failed,
  "InvalidCacheKind",Message[NativeSimulation::InvalidCacheKind,response["Message"]];$Failed,
  "InvalidCacheID",Message[NativeSimulation::InvalidCacheID,response["Message"]];$Failed,
  _,Message[NativeSimulation::UnexpectedTelescopeResponse,response["Message"]];$Failed
];

handleWarningResponse[response:nativeCacheNativeWarningsResponseP]:=Map[GoLink`Private`messageWarnings,response["Warnings"]];

formatNativeSimulationList[metaData:{nativeCacheMetaDataP...}]:=With[
  {
    (* ignore all non simulation caches *)
    simulationCaches=Select[metaData,MatchQ[Lookup[#,"Kind",Null],"simulation"]&]
  },
  (* remove Kind key from all metaData *)
  simulationCaches /. RuleDelayed[KeyValuePattern[{"ID"->id_}],<|"ID"->id|>]
];