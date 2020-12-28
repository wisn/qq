namespace Qrng {
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;

    operation SampleQuantumRandomNumberGenerator() : Result {
        using (q = Qubit()) {
            H(q);
            return MResetZ(q);
        }
    }

    operation SampleRandomNumberInRange(max : Int) : Int {
        mutable bits = new Result[0];
        for (idxBit in 1..BitSizeI(max)) {
            set bits += [SampleQuantumRandomNumberGenerator()];
        }

        let sample = ResultArrayAsInt(bits);
        if (sample > max) {
            return SampleRandomNumberInRange(max);
        }

        return sample;
    }

    operation Demonstrate() : Unit {
        let max = 50;
        let num = SampleRandomNumberInRange(max);

        Message("Qrng----------------------------");
        Message($"Sampling a random number between 0 and {max}: {num}");
        Message("--------------------------------\n");
    }
}
