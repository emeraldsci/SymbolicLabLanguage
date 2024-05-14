(* InitializeAsynchronousUpload *)
DefineUsage[InitializeAsynchronousUpload,
    {
        BasicDefinitions -> {
            {"InitializeAsynchronousUpload[]", "True", "Initializes AsynchronousUpload by lauching an auxiliary Telescope process.  Returns Null if already initialized."}
        },
        Input :> {},
        Output :> {
            {"True", True, "Returns 'True' if AsynchronousUpload was initialized sucessfully."}
        },
        SeeAlso -> {"Upload", "AsynchronousUpload", "AwaitAsynchronousUpload"},
        Author -> {"hiren.patel"}
    }];

(* AsynchronousUpload *)
DefineUsage[AsynchronousUpload,
    {
        BasicDefinitions -> {
            {"AsynchronousUpload[packet]", "True", "asynchronously creates object of 'packet' key Type, or modifies existing object of 'packet' key Object.  If the previous call failed to complete, a message is generated, and a Failure[] object is returned."},
            {"AsynchronousUpload[packets]", "True", "asynchronously creates or modifies the elements of 'packets' sequentially."}
        },
        Input :> {
            {"packet", PacketP[], "An association describing an object to be created or modified."},
            {"packets", {___PacketP[]}, "A list of associations, each describing a database update."}
        },
        Output :> {
            {"True", True, "Returns 'True' if the previous AsynchronousUpload call completed successfully."}
        },
        SeeAlso -> {"Upload", "AwaitAsynchronousUpload"},
        Author -> {"hiren.patel"}
    }];


(* AwaitAsynchronousUpload *)
DefineUsage[AwaitAsynchronousUpload,
    {
        BasicDefinitions -> {
            {"AwaitAsynchronousUpload[]", "True", "waits for any AsynchronousUpload requests to complete before continuing.  If any previous AsynchronousUpload calls failed to complete, a message is generated, and a Failure[] object is returned."}
        },
        Input :> {},
        Output :> {
            {"True", True, "Returns 'True' if all previous AsynchronousUpload calls completed successfully."}
        },
        SeeAlso -> {"Upload", "AsynchronousUpload"},
        Author -> {"hiren.patel"}
    }];
