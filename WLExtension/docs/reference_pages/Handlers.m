DefineUsage[SafeAddHandler,
  {
    BasicDefinitions->
        {
          {"SafeAddHandler[{handlerField,handlerFunction},code]","result","uninstalls any handlers in 'handlerField', installs the 'handlerFunction' in 'handlerField', runs the given 'code', then reinstalls the original handlers in 'handlerField'."}
        },
    Input:>
        {
          {"handlerField",_String,"The handlerField that the handlerFunction is installed in."},
          {"handlerFunction",_,"The function that is installed in the handlerField."}
        },
    Output:>
        {
          {"result",_,"The result of the 'code' that is run after the handler is installed."}
        },
    Sync->Automatic,
    SeeAlso->
        {
          "Internal`AddHandler",
          "Internal`Handlers"
        },
    Author->{"tyler.pabst", "eunbin.go", "thomas", "lige.tonggu"}
  }];