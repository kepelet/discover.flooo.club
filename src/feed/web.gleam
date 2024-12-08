import wisp

import feed/context.{type Context}

pub fn middleware(
  req: wisp.Request,
  ctx: Context,
  next: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  let req = wisp.method_override(req)

  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)
  use <- wisp.serve_static(
    req,
    under: "/.well-known",
    from: ctx.well_known_directory,
  )

  next(req)
}
