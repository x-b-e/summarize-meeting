## Summarize Meeting

Automatically generate a meeting summary from a meeting transcript using OpenAI's ChapGPT API.

## Usage

Install the gem.

`gem install summarize-meeting`

### Commands

Input a meeting transcript and output a summary.

#### Usage

`summarize-meeting transcript.txt`

#### Options

`-o, --output-file FILE` - Path to the output file. By default, it will be the `${input-file}-summary.txt`
`-k, --openai-key KEY` - The OpenAI API Key. Can also be set via `ENV["OPEN_AI_API_KEY"]`.
`-g, --openai-org ORG` - The OpenAI org id (optional). It can also be set via `ENV["OPEN_AI_ORGANIZATION_ID"]` .

## Example

This is an example summary from a 3,700 word transcript from a 30 minute meeting.

> Summary of the Meeting:
>
> The meeting started with discussions focusing on individual progress reports, where Sean shared updates on profit-related work, consolidating estimates, and improving Hey Kayla by creating a new JSON structure for Chat GPT messages API. Colenso reported finding a bug in the JavaScript Google Maps API and not making progress on push notifications. Meanwhile, Pankaj worked on bulk assign form handling, retaining time zone, and Benjamin faced some issues regarding database connection but eventually resolved the casting and integration issues.
>
> In the open discussion session, the team discussed the confusion over parameters and importing across different branches. Benjamin shared about an open discussion necessary for a feature related to job production plans at ACME. Shirish discussed fixing the cycle time summary query, which used to take up to 6-7 seconds and now takes less than 1 second. Anish added a business unit filter feature to the time card and will work on page titles.
>
> The meeting concluded with Sean hoping to have success with profit stuff before Monday's call.
>
> Attendees:
>
> - Sean
> - Colenso
> - Pankaj
> - Benjamin
> - Shirish
> - Anish
>
> Action Items:
>
> - Sean to continue working on profit-related things before the next call.
> - Colenso to continue working on resolving the bug in the Google Maps API and push notifications.
> - Pankaj to continue working on bulk assign form handling and to keep the time zone option.
> - Benjamin to finalize the release notes for the open discussion at  and to continue working on resolving the database connection issues.
> - Shirish to further improve the query for cycle time summary and reduce the processing time.
> - Anish to improve page titles and add filters for the time card.
>
> Detailed notes:
>
> Sean:
>
> - Reported progress on Prophet-related things
> - Worked on consolidating all effective estimates
> - Worked on improving Hey Kayla by creating a new JSON structure for Chat GPT messages API
>
> Colenso:
>
> - Found a bug in the JavaScript Google Maps API
> - Has not made progress on push notifications yet
>
> Pankaj:
>
> - Worked on bulk assign form handling
> - Allowed the option to retain the time zone
>
> Benjamin:
>
> - Faced difficulty regarding database connection issues in Heroku
> - Resolved casting issues by switching to a different cash store
> - Listed an interesting issue regarding split loads with more than one material transaction during the same trip
> - Mentioned an integration issue with ACME
> - Shared that there is an open discussion at ACME and he needs assistance with the release notes for a feature related to job production plans
>
> Open Discussion:
>
> - The team discussed the confusion over parameters and importing across different branches.
>
> Shirish:
>
> - Discussed fixing the cycle time summary query, which used to take up to 6-7 seconds and now takes less than 1 second
>
> Anish:
>
> - Added a business unit filter feature to the time card
> - Will work on improving page titles

## Credits

This gem was created by XBE.
