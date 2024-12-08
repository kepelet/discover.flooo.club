import gleam/option.{type Option}

import lexicons/lexicons.{type Todo}

type DescriptionFacet =
  Todo

type DescriptionFacets =
  List(DescriptionFacet)

type Blob =
  Todo

type LabelUnion =
  Todo

// app.bsky.feed.generator
pub const lexicon = "app.bsky.feed.generator"

pub type FeedGenerator {
  FeedGenerator(
    did: String,
    display_name: String,
    description: Option(String),
    description_facets: Option(DescriptionFacets),
    avatar: Option(Blob),
    accept_interactions: Option(Bool),
    labels: Option(LabelUnion),
    created_at: String,
  )
}
