import gleam/json
import gleam/list

import lexicons/app/bsky/feed/defs as bsky_feed_defs
import lexicons/club/flooo/feed/defs as flooo_feed_defs

pub fn feed_skeleton_to_json(
  skeleton: bsky_feed_defs.GetFeedSkeleton,
) -> json.Json {
  let feed =
    list.map(skeleton.feed, fn(entry) {
      [#("post", json.string(entry.post))]
      |> json.object
    })

  json.object([#("feed", json.array(feed, fn(x) { x }))])
}

pub fn describe_feed_generator_to_json(
  feeds: List(flooo_feed_defs.FeedSetup),
  record: String,
) -> json.Json {
  let generate_feed_uri = fn(
    publisher: String,
    record: String,
    shortname: String,
  ) {
    "at://" <> publisher <> "/" <> record <> "/" <> shortname
  }

  feeds
  |> list.map(fn(feed) {
    json.object([
      #(
        "uri",
        json.string(generate_feed_uri(feed.publisher, record, feed.shortname)),
      ),
    ])
  })
  |> json.array(fn(x) { x })
}
