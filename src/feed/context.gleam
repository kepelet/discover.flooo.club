import wisp

pub type Context {
  Context(well_known_directory: String, did: String, secret_key_base: String)
}

fn well_known_directory() -> String {
  let assert Ok(priv_directory) = wisp.priv_directory("feed")

  priv_directory <> "/static/.well-known"
}

pub fn init(publisher did: String) -> Context {
  let secret_key_base = wisp.random_string(64)

  Context(well_known_directory: well_known_directory(), did:, secret_key_base:)
}
