import gleam/http/request

import wisp

import feed/context
import feed/encoder
import feed/handler
import feed/web

import gleam/json

pub fn handle_request(req: wisp.Request, ctx: context.Context) {
  use req <- web.middleware(req, ctx)

  case request.path_segments(req) {
    ["club.flooo.feed.getFeedSkeleton"] ->
      case handler.get_feed_skeleton(req, ctx, encoder.feed_skeleton_to_json) {
        Ok(feed_skeleton) ->
          feed_skeleton
          |> json.to_string_tree
          |> wisp.json_response(200)
        Error(error) ->
          handler.error(error)
          |> json.to_string_tree
          |> wisp.json_response(400)
      }

    ["app.bsky.feed.getFeedSkeleton"] ->
      case handler.get_feed_skeleton(req, ctx, encoder.feed_skeleton_to_json) {
        Ok(feed_skeleton) ->
          feed_skeleton
          |> json.to_string_tree
          |> wisp.json_response(200)
        Error(error) ->
          handler.error(error)
          |> json.to_string_tree
          |> wisp.json_response(400)
      }

    ["app.bsky.feed.describeFeedGenerator"] ->
      case
        handler.describe_feed_generator(
          req,
          ctx,
          encoder.describe_feed_generator_to_json,
        )
      {
        Ok(describe_feed_generator) ->
          describe_feed_generator
          |> json.to_string_tree
          |> wisp.json_response(200)
        Error(error) ->
          handler.error(error)
          |> json.to_string_tree
          |> wisp.json_response(400)
      }

    ["club.flooo.feed.describeFeedGenerator"] ->
      case
        handler.describe_feed_generator(
          req,
          ctx,
          encoder.describe_feed_generator_to_json,
        )
      {
        Ok(describe_feed_generator) ->
          describe_feed_generator
          |> json.to_string_tree
          |> wisp.json_response(200)
        Error(error) ->
          handler.error(error)
          |> json.to_string_tree
          |> wisp.json_response(400)
      }

    _ -> handler.not_found() |> json.to_string_tree |> wisp.json_response(404)
  }
}
