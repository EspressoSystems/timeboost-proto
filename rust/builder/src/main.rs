use std::env;

use anyhow::{bail, Result};

fn main() -> Result<()> {
    let mut args = env::args().skip(1);

    let Some(inp) = args.next() else {
        bail!("missing input directory")
    };

    let Some(out) = args.next() else {
        bail!("missing out directory")
    };

    tonic_prost_build::configure()
        .build_server(true)
        .out_dir(out)
        .bytes(".block.Block.payload")
        .bytes(".inclusion.Transaction.encoded_txn")
        .compile_protos(
            &[
                format!("{inp}/inclusion_list.proto"),
                format!("{inp}/block.proto"),
                format!("{inp}/internal.proto"),
                format!("{inp}/forward.proto"),
            ],
            &[inp],
        )?;

    Ok(())
}
