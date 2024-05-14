SafeAddHandler[{handlerField_String,handler_},code_]:=Module[
  {result,originalHandlers},

  originalHandlers = Lookup[Internal`Handlers[],handlerField];

  Scan[Internal`RemoveHandler[handlerField,#]&,originalHandlers];
  Internal`AddHandler[handlerField,handler];

  result=code;

  Internal`RemoveHandler[handlerField,handler];
  Scan[Internal`AddHandler[handlerField,#]&,originalHandlers];

  result

];

SetAttributes[SafeAddHandler,HoldRest];