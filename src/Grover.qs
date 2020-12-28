namespace Grover {
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;

    function NIterations(nQubits : Int) : Int {
        let nItems = 1 <<< nQubits;
        let angle = ArcSin(1. / Sqrt(IntAsDouble(nItems)));
        let nIterations = Round(0.25 * PI() / angle - 0.5);

        return nIterations;
    }

    operation PrepareUniform(inputQubits : Qubit[]) : Unit is Adj + Ctl {
        ApplyToEachCA(H, inputQubits);
    }

    operation ReflectAboutMarked(inputQubits : Qubit[]) : Unit {
        using (outputQubit = Qubit()) {
            within {
                X(outputQubit);
                H(outputQubit);
                ApplyToEachA(X, inputQubits[...2...]);
            } apply {
                Controlled X(inputQubits, outputQubit);
            }
        }
    }

    operation ReflectAboutUniform(inputQubits : Qubit[]) : Unit {
        within {
            Adjoint PrepareUniform(inputQubits);
            PrepareAllOnes(inputQubits);
        } apply {
            ReflectAboutAllOnes(inputQubits);
        }
    }

    operation PrepareAllOnes(inputQubits : Qubit[]) : Unit is Adj + Ctl {
        ApplyToEachCA(X, inputQubits);
    }

    operation ReflectAboutAllOnes(inputQubits : Qubit[]) : Unit is Adj + Ctl {
        Controlled Z(Most(inputQubits), Tail(inputQubits));
    }

    operation SearchForMarkedInput(nQubits : Int) : Result[] {
        using (qubits = Qubit[nQubits]) {
            PrepareUniform(qubits);

            for (idxIteration in 0..NIterations(nQubits) - 1) {
                ReflectAboutMarked(qubits);
                ReflectAboutUniform(qubits);
            }

            return ForEach(MResetZ, qubits);
        }
    }

    operation Demonstrate() : Unit {
        Message("Grover--------------------------");
        let result = SearchForMarkedInput(5);

        mutable msg = "[";
        for (i in IndexRange(result)) {
            if (i > 0) {
                set msg += ", ";
            }

            if (result[i] == Zero) {
                set msg += "Zero";
            } else {
                set msg += "One";
            }
        }
        set msg += "]";

        Message(msg);
        Message("--------------------------------\n");
    }
}
