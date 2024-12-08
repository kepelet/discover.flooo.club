import gleam/erlang/process

import mist
import wisp
import wisp/wisp_mist

import feed/context
import feed/router

pub fn main() {
  let publisher = "did:web:discover.flooo.club"

  wisp.configure_logger()

  let ctx = context.init(publisher:)

  let assert Ok(_) =
    wisp_mist.handler(router.handle_request(_, ctx), ctx.secret_key_base)
    |> mist.new
    |> mist.port(3000)
    |> mist.start_http

  process.sleep_forever()
}
