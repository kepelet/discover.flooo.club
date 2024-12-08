import gleam/dict

import feed/context.{type Context}

import lexicons/app/bsky/feed/defs.{type GetFeedSkeleton}

pub type FeedContext =
  Context

pub type FeedSetup {
  FeedSetup(
    shortname: String,
    publisher: String,
    handler: fn(FeedContext) -> GetFeedSkeleton,
  )
}

pub type FeedView =
  dict.Dict(FeedShortName, FeedSetup)

type FeedShortName =
  String
