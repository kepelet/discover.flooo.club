import gleam/dict
import gleam/json
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import gleam/uri

import wisp.{type Request}

import lexicons/app/bsky/feed/defs as bsky_feed_defs
import lexicons/app/bsky/feed/generator as bsky_feed_generator

import lexicons/club/flooo/feed/defs as flooo_feed_defs
import lexicons/club/flooo/feed/generator as flooo_feed_generator

import feed/algos.{type FeedError, UnsupportedAlgorithm}
import feed/context.{type Context}

fn get_feed_params(request: Request) -> String {
  request.query
  |> option.to_result(Nil)
  |> result.then(uri.parse_query)
  |> result.then(list.key_find(_, "feed"))
  |> result.unwrap("")
}

pub fn get_feed_skeleton(
  req: Request,
  ctx: Context,
  encoder: fn(bsky_feed_defs.GetFeedSkeleton) -> json.Json,
) -> Result(json.Json, FeedError) {
  case string.split(get_feed_params(req), "/") {
    [_, __, did, collection, rkey] ->
      case collection {
        "app.bsky.feed.generator" | "club.flooo.feed.generator" ->
          case algos.validate(ctx, rkey, did) {
            Ok(result) -> Ok(encoder(result))
            Error(_) -> Error(UnsupportedAlgorithm)
          }
        _ -> Error(UnsupportedAlgorithm)
      }
    _ -> Error(UnsupportedAlgorithm)
  }
}

fn list_feeds() {
  algos.get_feed_by_algo() |> dict.values
}

pub fn describe_feed_generator(
  req: Request,
  ctx: Context,
  encoder: fn(List(flooo_feed_defs.FeedSetup), String) -> json.Json,
) -> Result(json.Json, FeedError) {
  case string.split(req.path, "/") {
    [_, record] ->
      case record {
        "app.bsky.feed.describeFeedGenerator" -> {
          Ok(
            json.object([
              #("did", json.string(ctx.did)),
              #("feeds", list_feeds() |> encoder(bsky_feed_generator.lexicon)),
            ]),
          )
        }
        "club.flooo.feed.describeFeedGenerator" -> {
          Ok(
            json.object([
              #("did", json.string(ctx.did)),
              #("feeds", list_feeds() |> encoder(flooo_feed_generator.lexicon)),
            ]),
          )
        }
        _ -> Error(UnsupportedAlgorithm)
      }
    _ -> Error(UnsupportedAlgorithm)
  }
}

pub fn not_found() {
  [#("message", json.string("Not Found"))]
  |> json.object()
}

pub fn error(error: FeedError) {
  let response =
    json.object([
      #("error", json.string("UnsupportedAlgorithm")),
      #("message", json.string("Unsupported algorithm")),
    ])

  case error {
    UnsupportedAlgorithm -> response
  }
}
