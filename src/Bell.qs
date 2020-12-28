namespace Bell {
    open Microsoft.Quantum.Intrinsic;

    open Util;

    operation SetQubitState(desired : Result, q1 : Qubit) : Unit {
        if (desired != M(q1)) {
            X(q1);
        }
    }

    operation TestBellState(count : Int, initial : Result) : (Int, Int, Int) {
        mutable agreements = 0;
        mutable numOnes = 0;

        using ((q0, q1) = (Qubit(), Qubit())) {
            for (test in 1..count) {
                SetQubitState(initial, q0);
                SetQubitState(Zero, q1);

                H(q0);
                CNOT(q0, q1);

                let res = M(q0);
                if (res == M(q1)) {
                    set agreements += 1;
                }

                if (res == One) {
                    set numOnes += 1;
                }
            }

            SetQubitState(Zero, q0);
            SetQubitState(Zero, q1);
        }

        let msg = [
            $"Test results: (#{count - numOnes} of 0s,",
            $"#{numOnes} of 1s,",
            $"#{agreements} of agreements)"
        ];
        Util.Log(msg, " ");

        return (count - numOnes, numOnes, agreements);
    }

    operation Demonstrate() : Unit {
        Message("Bell----------------------------");
        let _ = TestBellState(1000, One);
        let _ = TestBellState(1000, Zero);
        Message("--------------------------------\n");
    }
}
