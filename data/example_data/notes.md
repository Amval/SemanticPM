# Formats

Timestamps are not used, at least yet.

## Concepts and Resources
ResourceId;Concept;Score; Timestamp (optional)

| Resource_id | url                                                         |
|-------------|-------------------------------------------------------------|
| 1           | https://en.wikipedia.org/wiki/Joseph_Stalin                 |
| 2           | https://en.wikipedia.org/wiki/October_Revolution            |
| 3           | https://en.wikipedia.org/wiki/Red_Army                      |
| 4           | https://en.wikipedia.org/wiki/Great_Purge                   |

For the first iteration, only words that appear exactly in the forum posts.
TODO:
- Capitalist -> Capitalism. Use distance when looking for words.
- Multiword keywords. "Red Army" => "army". partial match? count them somehow?

## Resources Usage (activity log)
StudentId; ResourceId; Timestamp (optional)

If Student hasn't accessed any resources, he is not on the system with this schema.

What if only accessed one resource?

Student has array with used resources. No normalization. Justification:
- Resources could be added but never changed
- There is no other information to them (no duplicity)

## User generated content

PostId;StudentId;Content; Timestamp (optional, here could be more useful) -> message priority
