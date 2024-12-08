import gleam/dict

import lexicons/app/bsky/feed/defs as bsky_feed_defs
import lexicons/club/flooo/feed/defs as flooo_feed_defs

import algos/global

pub type FeedError {
  UnsupportedAlgorithm
}

pub fn get_feed_by_algo() -> flooo_feed_defs.FeedView {
  dict.from_list([#("global", global.feed)])
}

/// bluesky-social/feed-generator validates if at://did:xx:yy (the yy part) equals `FEEDGEN_PUBLISHER_DID` and shows `UnsupportedAlgorithm` when it's not
pub fn validate(
  ctx: flooo_feed_defs.FeedContext,
  algo: String,
  hostname: String,
) -> Result(bsky_feed_defs.GetFeedSkeleton, FeedError) {
  case dict.get(get_feed_by_algo(), algo) {
    Ok(algo) -> {
      case hostname == algo.publisher {
        True -> Ok(algo.handler(ctx))
        False -> Error(UnsupportedAlgorithm)
      }
    }
    Error(_) -> Error(UnsupportedAlgorithm)
  }
}
