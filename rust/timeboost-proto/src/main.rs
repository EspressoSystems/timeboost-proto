use std::error::Error;

fn main() -> Result<(), Box<dyn Error>> {
    tonic_prost_build::configure()
        .build_server(true)
        .out_dir("src/protos")
        .bytes(".block.Block.payload")
        .bytes(".inclusion.Transaction.encoded_txn")
        .compile_protos(
            &[
                "../../inclusion_list.proto",
                "../../block.proto",
                "../../internal.proto",
                "../../forward.proto",
            ],
            &["../../"],
        )?;
    Ok(())
}