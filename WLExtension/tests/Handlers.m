DefineTests[SafeAddHandler,{
  Example[
    {Basic,"Returns a pure function that rounds its arguments and then applies MatchQ:"},
    Module[{myMessageList, messageHandler},
      myMessageList = {};

      messageHandler[message_] := Module[{},
        (*Keep track of the messages thrown during evaluation of the test.*)
        AppendTo[myMessageList, HoldForm[message]];
      ];

      Quiet@SafeAddHandler[{"Message", messageHandler}, 1/0];

      Length[myMessageList]
    ],
    1
  ]
}];