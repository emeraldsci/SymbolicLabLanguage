DefineObjectType[Object[UnitTest], {
  Description -> "An object tracking tests of code evaluation tailored to specific functions when evaluated in isolation.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    DateEnqueued -> {
      Format -> Single,
      Class -> Date,
      Pattern :> _DateObject,
      Description -> "The date and time at which a request this unit test was generated.",
      Category -> "Organizational Information"
    },
    DateStarted -> {
      Format -> Single,
      Class -> Date,
      Pattern :> _DateObject,
      Description -> "The date and time the unit tests began running.",
      Category -> "Organizational Information"
    },
    DateCompleted -> {
      Format -> Single,
      Class -> Date,
      Pattern :> _DateObject,
      Description -> "The date and time the unit tests finished running, whether by returning values on all the tests, timing out, or crashing.",
      Category -> "Organizational Information"
    },
    SLLVersion -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The Symbolic Lab Language (SLL) version (branch) of that is loaded into the Mathematica kernel before the unit tests are run.",
      Category -> "Organizational Information"
    },
    SLLCommit -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The SHA-1 hash indicating the Symbolic Lab Language (SLL) commit of the branch that is loaded into the Mathematica kernel before the unit tests are run.",
      Category -> "Organizational Information"
    },
    MathematicaVersion -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The version of Mathematica to load for this Manifold job. If Null, version will default to 13.3.1.",
      Category -> "Organizational Information"
    },
    RunAsUser -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[User],
      Description -> "If computing on the cloud, the user which Manifold should run computations as.",
      Category -> "Organizational Information"
    },
    Email -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "Indicates if an email should be sent after the unit tests are finished running.",
      Category -> "Organizational Information"
    },
    EmailRecipients -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "The email addresses that should be notified when the unit test finishes.",
      Category -> "Organizational Information"
    },
    DeveloperObject -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
      Category -> "Organizational Information",
      Developer -> True
    }
  }
}]