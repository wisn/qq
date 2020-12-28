namespace QQ {
    open Bell;
    open Grover;
    open Qrng;

    @EntryPoint()
    operation Main() : Unit {
        Qrng.Demonstrate();
        Bell.Demonstrate();
        Grover.Demonstrate();
    }
}
