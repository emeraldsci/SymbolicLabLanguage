(* AsynchronousUpload *)
DefineUsage[CallAstra,
    {
        BasicDefinitions -> {
            {"CallAstra[command]", "expr", "issues a command to Astra, and returns the response."}
        },
        Input :> {
            {"command", _, "Mathematica expression recognized by Astra."}
        },
        Output :> {
            {"expr", _, "Mathematica expression returned by Astra."}
        },
        SeeAlso -> {},
        Author -> {"hiren.patel"}
    }];
