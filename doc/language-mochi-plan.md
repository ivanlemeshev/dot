# Language cards with Mochi

## Goal

Create useful language cards from ChatGPT Web or Codex.

The daily flow stays short:

```text
Useful language material
        |
        v
Create a card from the last answer
        |
        v
Show a short preview
        |
        v
Save the card in Mochi
        |
        v
Review the card in Mochi
```

The system stores words, expressions, chunks, corrections, and grammar
patterns. It prefers natural phrases over isolated words.

## Product choice

Use Mochi instead of Anki.

Mochi provides:

- cloud sync;
- web and mobile access;
- spaced repetition;
- FSRS;
- a REST API;
- card templates;
- dynamic fields;
- text to speech.

Mochi Pro is required for sync, API keys, dynamic fields, and full language
services. The current official price is 5 USD per month when billed yearly.
The pricing page says that yearly billing saves 12 USD per year.

References:

- https://mochi.cards/pricing/
- https://mochi.cards/docs/api/
- https://mochi.cards/docs/reviewing/fsrs/
- https://mochi.cards/docs/templates/dynamic-fields/

## Target architecture

Use one remote MCP server for ChatGPT Web and Codex.

```text
ChatGPT Web ----|
                |---- HTTPS MCP ----> Cloudflare Worker ----> Mochi API
Codex ----------|
```

The plugin does not store the Mochi API key.

The Cloudflare Worker stores the key as a secret.

The first version does not use a local process, Anki, AnkiConnect, a tunnel,
or a local database.

## Cloudflare choice

Use Cloudflare Workers Free for the first version.

The current free limits include:

- 100,000 Worker requests per day;
- 10 milliseconds of CPU time per invocation;
- 128 MB memory;
- 5 million D1 rows read per day;
- 100,000 D1 rows written per day.

The personal workflow uses far fewer requests. The Worker only validates a
request, parses JSON, and calls Mochi. It does not perform heavy computation.

D1 is not needed for version 0.1 because Mochi stores the cards. Add D1 only
if the system later needs a local queue, an operation log, or duplicate state.

References:

- https://developers.cloudflare.com/workers/platform/pricing/
- https://developers.cloudflare.com/workers/platform/limits/

Do not use Fly.io for version 0.1. Fly.io has a free trial but no permanent
free tier. Its trial includes 2 machine hours or 7 days, whichever comes
first. A long-running Worker on Fly.io needs a payment method.

Reference:

- https://www.fly.io/docs/about/free-trial/

## Repository layout

Keep the plugin and the deployed Worker separate.

```text
codex/plugins/language-mochi/
├── plugin.json
├── mcp.json
└── skills/
    └── create-card/
        └── SKILL.md

cloudflare/language-mochi/
├── package.json
├── wrangler.jsonc
└── src/
    └── index.ts
```

The plugin contains public instructions and the public Worker URL.

The Worker source contains no API key.

## Worker tools

Expose these MCP tools:

### `health`

Return the Worker status and the Mochi API status.

### `list_decks`

Return the user's Mochi decks.

### `create_card`

Create one card after user confirmation.

Input:

```json
{
  "language": "English",
  "prompt": "Мне потребовалось время, чтобы привыкнуть к этому.",
  "answer": "It took me a while to get used to it.",
  "example": "It took me a while to get used to working remotely.",
  "notes": "get used to + noun / verb-ing",
  "deck": "English",
  "tags": ["chunk", "grammar"]
}
```

### `find_similar_cards`

Search for a similar card before creation.

Use this tool to reduce accidental duplicates.

## Card format

Use these logical fields:

- `Prompt`: a cue in the user's native language;
- `Answer`: the natural target-language phrase;
- `Example`: one short extra example;
- `Notes`: one short usage or grammar note.

Use one deck per language:

- `English`;
- `Finnish`.

Use tags only when they help:

- `chunk`;
- `phrase`;
- `grammar`;
- `error`.

Do not require source, level, part of speech, or topic fields.

## Card creation flow

The skill creates one useful card from the current conversation.

It follows this order:

1. Identify the target language.
2. Select a useful word, phrase, correction, or construction.
3. Write a native-language prompt.
4. Write a natural target-language answer.
5. Add one example when it improves recall.
6. Add one short note when it prevents an error.
7. Show a preview.
8. Call `create_card` after confirmation.

If the user says `add it directly`, skip the confirmation step.

If the Worker or Mochi is unavailable, return the card as tab-separated text.

## Text to speech

Use Mochi dynamic fields for text to speech.

Create separate templates for English and Finnish because the TTS language is
part of the template configuration.

Do not add an external TTS provider in version 0.1.

Do not store audio files in the Worker.

## Secrets

Configure these secrets in Cloudflare:

```text
MOCHI_API_KEY
MCP_AUTH_TOKEN
```

Set them with:

```bash
npx wrangler secret put MOCHI_API_KEY
npx wrangler secret put MCP_AUTH_TOKEN
```

Never put either value in `plugin.json`, `mcp.json`, `wrangler.jsonc`, source
code, or Git history.

Reference:

- https://developers.cloudflare.com/workers/configuration/secrets/

## Deployment flow

Create the Worker project:

```bash
mkdir -p cloudflare
npm create cloudflare@latest -- cloudflare/language-mochi
cd cloudflare/language-mochi
npx wrangler login
```

Develop locally:

```bash
npx wrangler dev
```

Deploy:

```bash
npx wrangler deploy
```

Cloudflare provides a `workers.dev` URL after deployment.

Reference:

- https://developers.cloudflare.com/workers/get-started/guide/

## Plugin connection

After deployment, set the MCP URL in the plugin manifest:

```json
{
  "$schema": "https://agent-plugins.org/schemas/1.0.0/mcp.schema.json",
  "mcpServers": {
    "language-mochi": {
      "type": "streamable-http",
      "url": "https://language-mochi.<account>.workers.dev/mcp"
    }
  }
}
```

Use the same HTTPS endpoint in ChatGPT Web custom MCP app settings.

ChatGPT Web must support custom MCP apps with write actions for direct card
creation. Current OpenAI documentation lists full write-capable MCP apps for
Business and Enterprise/Edu plans.

Reference:

- https://help.openai.com/en/articles/12584461-developer-mode-and-mcp-apps-in-chatgpt

## Version plan

### Version 0.1

- Mochi Pro;
- Cloudflare Worker;
- remote MCP over HTTPS;
- English and Finnish decks;
- `create_card`;
- `list_decks`;
- duplicate search;
- Mochi dynamic-field TTS;
- bearer-token protection;
- no D1;
- no external TTS;
- no local process.

### Version 0.2

- OAuth or stronger MCP authentication;
- D1 operation log;
- card update and archive tools;
- batch card creation;
- more languages;
- better duplicate detection;
- optional automatic card suggestions.

## Next session

Do these user-only steps:

1. Create or confirm a Mochi Pro account.
2. Create a Mochi API key.
3. Create or confirm a Cloudflare account.
4. Enable the ChatGPT Web custom MCP feature if the current plan supports it.

Do not send the Mochi API key in chat.

Then implement the Worker and the new `language-mochi` plugin in the
repository. Keep the old Anki implementation removed.
