import gleam/list
import gleam/option

import lexicons/app/bsky/feed/defs as bsky_feed_defs
import lexicons/club/flooo/feed/defs as flooo_feed_defs

pub const feed = flooo_feed_defs.FeedSetup(
  shortname: "global",
  publisher: "did:web:flooo.club",
  handler: handler,
)

pub fn handler(
  ctx: flooo_feed_defs.FeedContext,
) -> bsky_feed_defs.GetFeedSkeleton {
  query_to_db_or_something(ctx) |> bsky_feed_defs.GetFeedSkeleton(cursor: "")
}

fn query_to_db_or_something(
  _ctx: flooo_feed_defs.FeedContext,
) -> List(bsky_feed_defs.SkeletonFeedPost) {
  let decoder = fn(post) {
    bsky_feed_defs.SkeletonFeedPost(
      post: post,
      reason: option.None,
      feed_context: option.None,
    )
  }

  // normally do query here like ctx.db.select("uri").from("posts").limit(3)
  ["at://did:plc:rcnoen65yit2ys6vtsc43w3z/club.flooo.scrobble/3lcacyjycgc2x"]
  |> list.map(decoder)
}
