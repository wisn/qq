namespace Util {
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Intrinsic;

    operation Log(messages : String[], separator : String) : Unit {
        mutable msg = "";
        for (i in IndexRange(messages)) {
            if (i > 0) {
                set msg += separator;
            }

            set msg += messages[i];
        }

        Message(msg);
    }
}
