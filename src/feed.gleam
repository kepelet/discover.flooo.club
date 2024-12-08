import envoy

import gleam/erlang/process
import gleam/int
import gleam/result

import mist
import wisp
import wisp/wisp_mist

import feed/context
import feed/router

pub fn main() {
  let host = envoy.get("HOST") |> result.unwrap("127.0.0.1")
  let port = envoy.get("PORT") |> result.then(int.parse) |> result.unwrap(3000)

  // TODO: env. secret_key_base too. log level too.
  let publisher = "did:web:discover.flooo.club"

  wisp.configure_logger()

  let ctx = context.init(publisher:)

  let assert Ok(_) =
    wisp_mist.handler(router.handle_request(_, ctx), ctx.secret_key_base)
    |> mist.new
    |> mist.bind(host)
    |> mist.port(port)
    |> mist.start_http

  process.sleep_forever()
}
