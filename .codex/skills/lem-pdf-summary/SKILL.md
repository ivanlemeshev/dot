---
name: lem-pdf-summary
description: Create detailed, source-structured Markdown notes from a large PDF. Use for reports, manuals, specifications, studies, policies, and other long PDF documents.
---

# Summarize a large PDF

Create detailed Markdown notes. Use `<source-name>-summary.md` in the workspace unless the user gives an output path. Report the created file in the final response.

Keep the document's material meaning and source structure. A large document needs substantial notes. The word “summary” does not require aggressive compression.

## Choose the language

Use Simplified Technical English for technical, procedural, safety, maintenance, or specification content. Use clear plain English for general, narrative, business, or academic content. Follow the user's requested style when it differs.

Use short active sentences. Use one idea in each sentence. Define necessary terms once. Keep controlled technical terms when a simpler term can change the meaning.

## Read for coverage

First inspect the PDF structure. Identify its title, purpose, audience, sections, appendices, tables, figures, and page count.

Extract text from every page. Use OCR when a page is scanned or its text is missing. Inspect important tables, figures, diagrams, callouts, and pages with poor extraction.

Make a coverage ledger before you write the final notes. Record every material source heading and unlabeled content unit. A chapter heading alone does not satisfy a ledger record. Include:

- purpose, scope, and assumptions;
- findings, arguments, and conclusions;
- required actions and procedures;
- decisions, responsibilities, and dates;
- quantities, limits, conditions, and thresholds;
- warnings, risks, exceptions, and dependencies;
- material table, figure, appendix, and reference content.

Read long documents in logical sections. For each chapter, record every material content unit or subheading, its definition, its reasoning, its conditions, and its examples. Keep the ledger until the final coverage check is complete.

## Set the depth

For an instructional book, create detailed study notes. Use about 1,000 words for each 20 pages of material content. Use this target to detect missing detail. Do not add filler to meet it.

Give each material source subheading its own output subheading. Keep related source content together only when it forms one explanation. A 20-page or longer chapter normally has several output subheadings. A chapter overview does not replace the detailed notes.

Use the PDF bookmark hierarchy as a coverage map. Record each source learning unit in the ledger. Record each excluded bookmark and its reason. Keep at least 55 percent of the source learning units as note headings in each chapter. This permits grouping related material. It prevents a chapter overview from replacing the source structure.

Before delivery, run `python scripts/book_coverage.py <pdf-path> <notes-path>` for an instructional book. The command must pass. It checks the book word target and the heading count in each chapter. It does not prove semantic coverage. Complete the ledger check as well.

## Write book learning notes

Start with the book's subject matter. Omit author details, publication details, audience statements, reading advice, preface content, and other metadata unless the user asks for them or they change the subject matter.

Use `# Chapter N: title` for each chapter. Use `##` for its major themes. Use `###` for each atomic concept. Write in simple teaching language. For each core concept, state its meaning, why it matters, a source example or comparison, and its consequence when the source provides them. Use lists for examples, categories, questions, and contrasts. Split dense overview prose into these smaller learning units.

For reports, manuals, and specifications, set the length from the number and complexity of material content units. Do not apply the book target to a document that is concise by design.

## Write the summary

Use the source title as the level-one heading. Use a heading for every chapter or major section. Use a short subheading for every ledger record within a chapter. Use the source subheading when it is clear. If the source has no heading for a material unit, create a descriptive subheading. Preserve source order. Do not add page numbers to headings or text unless the user asks for them. Start each section with its material content.

Write each material content unit as a self-contained explanation. Include its definition, distinctions, relationships, causes, conditions, procedures, trade-offs, and examples when the source gives them. Keep examples that make an abstract rule concrete. Write exercises as their problem context, constraints, decision process, and material solution details.

Write direct statements about the subject. Remove filler such as "this book explains", "the document presents", "the chapter covers", and similar framing. Explain the facts, reasoning, trade-offs, procedures, and consequences directly. Do not add an introduction, conclusion, recap, or generic lessons unless the source contains material content that requires it.

Preserve exact values, units, dates, names, requirements, and limitations when they are material. State uncertainty as uncertainty. Do not add facts, explanations, recommendations, or causes that the PDF does not support.

Use paragraphs and lists that remain readable in a plain Markdown viewer. Use a table only for compact comparisons or mappings. A table must have clear headers, no more than three columns, short cells, and no wrapped prose. Replace an unreadable table with headings and lists. Cite source pages only when the user asks for citations.

Remove duplicate, decorative, and non-material text. Keep the important detail from every material content unit in every chapter. Do not shorten an explanation to make the document brief. For an instructional book, compare the draft length with the book target before delivery. Finish only when the notes let a reader follow each chapter's reasoning without the PDF. If the user asks for both extreme brevity and full detail, retain every material point and say that complete coverage requires a longer summary.

## Check before delivery

Compare the final notes with the coverage ledger. Confirm that every chapter and material content unit has its own section or subheading. Confirm that every material point appears, is combined with an equivalent point, or is deliberately omitted because it is duplicate or non-material.

Check that no definition, distinction, material explanation, example, warning, exception, requirement, numerical limit, decision process, or conclusion is lost. Check all quoted facts against the PDF. Render the Markdown in a plain viewer. Check that tables, if any, stay readable without horizontal scrolling. Make the final text clear to its intended reader.
