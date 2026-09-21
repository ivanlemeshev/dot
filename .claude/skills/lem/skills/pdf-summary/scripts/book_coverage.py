import argparse
import math
import re
from pathlib import Path

from pypdf import PdfReader


CHAPTER_TITLE = re.compile(r"^Chapter\s+(\d+)\b", re.IGNORECASE)
NOTE_CHAPTER = re.compile(r"^#{1,2}\s+(?:Chapter\s+)?(\d+)\b", re.IGNORECASE)
HEADING = re.compile(r"^(#{1,6})\s+")
END_SECTION = re.compile(r"^#{1,2}\s+(?:appendix|index|references)\b", re.IGNORECASE)
BOLD = re.compile(r"\*\*[^*\r\n]+\*\*")
ITALIC = re.compile(r"(?<!\*)\*[^*\r\n]+\*(?!\*)|(?<!_)_[^_\r\n]+_(?!_)")
LIST_ITEM = re.compile(r"(?m)^(?:[-*]|\d+\.)\s+")
TABLE = re.compile(r"(?m)^\|.*\|\r?\n\|[ :|-]+\|")
FENCED_BLOCK = re.compile(r"(?ms)^```[^\r\n]*\r?\n(.*?)^```")
DIAGRAM = re.compile(r"--!?>|->|=>|\+-|\|", re.MULTILINE)


def item_title(item: object) -> str:
    if isinstance(item, dict):
        return str(item.get("/Title", ""))
    return str(getattr(item, "title", ""))


def source_chapters(reader: PdfReader) -> dict[int, int]:
    outline = reader.outline
    chapters: dict[int, int] = {}

    for index, item in enumerate(outline[:-1]):
        match = CHAPTER_TITLE.match(item_title(item))
        children = outline[index + 1]
        if match and isinstance(children, list):
            chapters[int(match.group(1))] = sum(
                bool(item_title(child)) for child in children
            )

    return chapters


def note_chapters(notes: str) -> dict[int, int]:
    chapters: dict[int, int] = {}
    current: int | None = None

    for line in notes.splitlines():
        if END_SECTION.match(line):
            current = None
            continue

        chapter = NOTE_CHAPTER.match(line)
        if chapter:
            current = int(chapter.group(1))
            chapters.setdefault(current, 0)
            continue

        heading = HEADING.match(line)
        if current is not None and heading and len(heading.group(1)) >= 2:
            chapters[current] += 1

    return chapters


def visual_metrics(notes: str) -> dict[str, int]:
    diagrams = sum(bool(DIAGRAM.search(block)) for block in FENCED_BLOCK.findall(notes))
    return {
        "bold": len(BOLD.findall(notes)),
        "italics": len(ITALIC.findall(notes)),
        "list items": len(LIST_ITEM.findall(notes)),
        "tables": len(TABLE.findall(notes)),
        "ASCII diagrams": diagrams,
    }


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Check the structural coverage of instructional-book notes."
    )
    parser.add_argument("pdf", type=Path)
    parser.add_argument("notes", type=Path)
    parser.add_argument("--unit-ratio", type=float, default=0.55)
    parser.add_argument("--min-bold", type=int, default=12)
    parser.add_argument("--min-italics", type=int, default=3)
    parser.add_argument("--min-list-items", type=int, default=12)
    parser.add_argument("--min-tables", type=int, default=2)
    parser.add_argument("--min-diagrams", type=int, default=2)
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    if not 0 < args.unit_ratio <= 1:
        raise ValueError("--unit-ratio must be greater than 0 and at most 1.")

    reader = PdfReader(args.pdf)
    source = source_chapters(reader)
    notes = args.notes.read_text(encoding="utf-8")
    output = note_chapters(notes)
    visuals = visual_metrics(notes)
    failed = False

    print(f"PDF pages: {len(reader.pages)}")

    for number, source_units in source.items():
        minimum_units = math.ceil(source_units * args.unit_ratio)
        note_units = output.get(number, 0)
        passed = note_units >= minimum_units
        failed = failed or not passed
        print(
            f"Chapter {number}: source units={source_units}; "
            f"note headings={note_units}; minimum={minimum_units}; "
            f"{'PASS' if passed else 'FAIL'}"
        )

    minimums = {
        "bold": args.min_bold,
        "italics": args.min_italics,
        "list items": args.min_list_items,
        "tables": args.min_tables,
        "ASCII diagrams": args.min_diagrams,
    }
    for name, minimum in minimums.items():
        actual = visuals[name]
        passed = actual >= minimum
        failed = failed or not passed
        print(f"{name}: actual={actual}; minimum={minimum}; {'PASS' if passed else 'FAIL'}")

    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
