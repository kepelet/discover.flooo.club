import gleam/option.{type Option}

import lexicons/lexicons.{type Todo}

type ReasonUnion =
  Todo

// app.bsky.feed.defs#skeletonFeedPost
pub type SkeletonFeedPost {
  SkeletonFeedPost(
    post: String,
    reason: Option(ReasonUnion),
    feed_context: Option(String),
  )
}

pub type GetFeedSkeleton {
  GetFeedSkeleton(cursor: String, feed: List(SkeletonFeedPost))
}
