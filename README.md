# Ficdb

 mix boiler.gen.html Fanfics Fandom fandoms url name:unique author description:text image submitter_id:references:veil_users updater_id:references:veil_users --no-schema --no-context

 # Male Slash/Female Slash/Smut/Quest/One-Shot/RevivedFics?
 mix boiler.gen.html Fanfics Genre genres name:unique description:text image submitter_id:references:veil_users updater_id:references:veil_users --no-schema --no-context

 mix boiler.gen.html Fanfics Tag tags name description:text fandom_id:references:fandoms submitter_id:references:veil_users updater_id:references:veil_users
 mix phx.gen.html Fanfics Character characters description:text image name:string fandom_id:references:fandoms submitter_id:references:veil_users updater_id:references:veil_users

 mix boiler.gen.html Fanfics Author authors name:string urls:array:string submitter_id:references:veil_users updater_id:references:veil_users

 mix boiler.gen.html Fanfics Fanfic fanfics name:string description:text word_count:integer is_completed:boolean is_one_shot:boolean status first_chapter_at:utc_datetime last_chapter_at:utc_datetime urls:array:string main_character_id:references:characters author_id:references:authors submitter_id:references:veil_users updater_id:references:veil_users

 mix boiler.gen.html Fanfics Chapter chapters url:string posted_at:utc_datetime reactions:integer fanfic_id:references:fanfics submitter_id:references:veil_users updater_id:references:veil_users
 mix boiler.gen.html Fanfics Review reviews content:string rating:integer fanfic_id:references:fanfics parent_review_id:references:reviews submitter_id:references:veil_users updater_id:references:veil_users

 mix phx.gen.schema Fanfics.FanficsGenres fanfics_genres fanfic_id:references:fanfics fandom_id:references:fandoms submitter_id:references:veil_users updater_id:references:veil_users
 mix phx.gen.schema Fanfics.FanficsTags fanfics_tags tag_id:references:tags fanfic_id:references:fanfics submitter_id:references:veil_users updater_id:references:veil_users
 mix phx.gen.schema Fanfics.FanficsFandoms fanfics_fandoms fandom_id:references:fandoms fanfic_id:references:fanfics submitter_id:references:veil_users updater_id:references:veil_users
 mix phx.gen.schema Fanfics.FanficsBookshelves fanfics_bookshelves bookshelf_id:references:bookshelves fanfic_id:references:fanfics submitter_id:references:veil_users updater_id:references:veil_users

 ## STILL NEED TO RUN
 mix phx.gen.schema Fanfics FanficsRelationships fanfics_relationships relationship_id:references:relationships fanfic_id:references:fanfics submitter_id:references:veil_users updater_id:references:veil_users
 mix phx.gen.schema Fanfics Relationship relationships character_a_id:references:characters character_b_id:references:characters character_c_id:references:characters character_d_id:references:characters character_e_id:references:characters character_f_id:references:characters submitter_id:references:veil_users updater_id:references:veil_users

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

fanfics have many book shelf
book shelf has many fanfics
User has many book shelfs
book shelf has one user

