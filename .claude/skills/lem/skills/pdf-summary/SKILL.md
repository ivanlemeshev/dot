---
name: pdf-summary
description: Summarize a large PDF with full material coverage in clear, short English. Use for reports, manuals, specifications, studies, policies, and other long PDF documents.
argument-hint: "[PDF path or URL]"
---

# Summarize a large PDF

Create a Markdown summary file. Use `<source-name>-summary.md` in the workspace unless the user gives an output path. Report the created file in the final response.

Keep the document's material meaning. Match the detail to the source. A large document needs a substantial summary. Do not treat a short summary as a list of headings.

## Choose the language

Use Simplified Technical English for technical, procedural, safety, maintenance, or specification content. Use clear plain English for general, narrative, business, or academic content. Follow the user's requested style when it differs.

Use short active sentences. Use one idea in each sentence. Define necessary terms once. Keep controlled technical terms when a simpler term can change the meaning.

## Read for coverage

First inspect the PDF structure. Identify its title, purpose, audience, sections, appendices, tables, figures, and page count.

Extract text from every page. Use OCR when a page is scanned or its text is missing. Inspect important tables, figures, diagrams, callouts, and pages with poor extraction.

Make a coverage ledger before you write the final summary. Record the material point from every chapter, section, and appendix. Include:

- purpose, scope, and assumptions;
- findings, arguments, and conclusions;
- required actions and procedures;
- decisions, responsibilities, and dates;
- quantities, limits, conditions, and thresholds;
- warnings, risks, exceptions, and dependencies;
- material table, figure, appendix, and reference content.

Read long documents in logical sections. Summarize each section before you merge them. For each chapter, record every material content unit or subheading, its definition, its reasoning, its conditions, and its examples. Keep the ledger until the final coverage check is complete.

## Write the summary

Use the source title as the level-one heading. Use a heading for every chapter or major section. Preserve the source's meaningful internal structure with subheadings. Do not compress a chapter with several material units into one overview. Start each section with its material content. State the document purpose or main conclusion only when it adds material meaning.

Write each material content unit as a self-contained explanation. Include definitions, distinctions, relationships, causes, conditions, procedures, trade-offs, and examples when they change understanding. Keep examples that make an abstract rule concrete. Write exercises as their problem context, constraints, decision process, and material solution details.

Write direct statements about the subject. Remove filler such as "this book explains", "the document presents", "the chapter covers", and similar framing. Explain the facts, reasoning, trade-offs, procedures, and consequences directly. Do not add an introduction, conclusion, recap, or generic lessons unless the source contains material content that requires it.

Preserve exact values, units, dates, names, requirements, and limitations when they are material. State uncertainty as uncertainty. Do not add facts, explanations, recommendations, or causes that the PDF does not support.

Use paragraphs and lists that remain readable in a plain Markdown viewer. Use a table only for compact comparisons or mappings. A table must have clear headers, no more than three columns, short cells, and no wrapped prose. Replace an unreadable table with headings and lists. Cite source pages for material claims when the user asks for citations, when the document is technical or regulated, or when page tracing improves usefulness.

Remove duplicate, decorative, and non-material text. Keep the important detail from every material content unit in every chapter. Do not shorten an explanation merely to make the document brief. If the user asks for both extreme brevity and full detail, retain every material point and say that complete coverage requires a longer summary.

## Check before delivery

Compare the final summary with the coverage ledger. Confirm that every chapter and material content unit has a section. Confirm that every material point appears, is combined with an equivalent point, or is deliberately omitted because it is duplicate or non-material.

Check that no definition, distinction, material explanation, example, warning, exception, requirement, numerical limit, decision process, or conclusion is lost. Check all quoted facts against the PDF. Render the Markdown in a plain viewer. Check that tables, if any, stay readable without horizontal scrolling. Make the final text clear to its intended reader.
