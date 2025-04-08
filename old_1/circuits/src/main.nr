use dep::std::hash::poseidon2;

fn main(value1: pub Field, value2: pub Field, value3: pub Field) -> pub  Field {
    let commitment = poseidon2::Poseidon2::hash([value1, value2, value3], 3);
    commitment
}


// fn main(x: Field, y: pub Field) -> pub Field {
//     assert(x == y);
//     y
// }
