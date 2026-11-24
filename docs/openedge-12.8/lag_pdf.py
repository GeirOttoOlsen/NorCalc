"""Build the Norcalc verification report from its Markdown source."""

import re
from html import escape
from pathlib import Path

from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.platypus import PageBreak, Paragraph, SimpleDocTemplate, Table, TableStyle


DIRECTORY = Path(__file__).resolve().parent
INK = colors.HexColor("#172B42")
ACCENT = colors.HexColor("#145B72")
LINK = "https://github.com/GeirOttoOlsen/NorCalc/blob/docs/openedge-12.8-meny/"
INLINE = re.compile(r"\[([^\]]+)\]\(([^)]+)\)|`([^`]+)`|\*\*(.+?)\*\*")


def inline(text):
    result = []
    end = 0
    for match in INLINE.finditer(text):
        result.append(escape(text[end:match.start()]))
        label, target, code, bold = match.groups()
        if target:
            path, _, anchor = target.partition("#")
            file = (DIRECTORY / path).resolve().relative_to(DIRECTORY.parents[1])
            url = LINK + file.as_posix() + ("#" + anchor if anchor else "")
            result.append(f'<link href="{escape(url, quote=True)}" color="#145B72">{escape(label)}</link>')
        elif code:
            result.append(f'<font name="Courier" size="8">{escape(code)}</font>')
        else:
            result.append(f"<b>{escape(bold)}</b>")
        end = match.end()
    result.append(escape(text[end:]))
    return "".join(result)


def footer(canvas, document):
    canvas.setStrokeColor(colors.HexColor("#CCD8E0"))
    canvas.line(45, 42, A4[0] - 45, 42)
    canvas.setFillColor(ACCENT)
    canvas.setFont("Helvetica", 9)
    canvas.drawString(45, 28, "NORCALC  /  OPENEDGE 12.8")
    canvas.drawRightString(A4[0] - 45, 28, str(document.page))


def report():
    styles = getSampleStyleSheet()
    for name in ("Normal", "Title", "Heading2", "Heading3"):
        styles[name].textColor = INK
    styles["Title"].alignment = 0
    styles["Title"].fontSize = 25
    styles["Title"].leading = 30
    styles["Normal"].fontSize = 10
    styles["Normal"].leading = 14
    styles["Normal"].spaceAfter = 8
    styles["Heading2"].textColor = ACCENT
    cell = ParagraphStyle("Cell", parent=styles["Normal"], fontSize=9, leading=12, spaceAfter=0)
    header = ParagraphStyle("Header", parent=cell, fontName="Helvetica-Bold", textColor=colors.white)
    doc = SimpleDocTemplate(
        str(DIRECTORY / "Norcalc-OpenEdge-12.8.pdf"), pagesize=A4,
        leftMargin=45, rightMargin=45, topMargin=44, bottomMargin=59,
        title="Norcalc på OpenEdge 12.8", author="Norcalc-prosjektet",
    )
    story = []
    rows = []
    lines = (DIRECTORY / "README.md").read_text(encoding="utf-8-sig").splitlines()
    for line in [*lines, ""]:
        if line.startswith("|"):
            values = [value.strip() for value in line.strip("|").split("|")]
            if not all(re.fullmatch(r"[-:]+", value) for value in values):
                rows.append([Paragraph(inline(value), cell if rows else header) for value in values])
            continue
        if rows:
            widths = [doc.width * part for part in ([.38, .62] if len(rows[0]) == 2 else [.42, .29, .29])]
            table = Table(rows, colWidths=widths, repeatRows=1, hAlign="LEFT", spaceAfter=10)
            table.setStyle(TableStyle([
                ("BACKGROUND", (0, 0), (-1, 0), ACCENT),
                ("ROWBACKGROUNDS", (0, 1), (-1, -1), [colors.HexColor("#EDF3F6"), colors.white]),
                ("VALIGN", (0, 0), (-1, -1), "TOP"),
                ("TOPPADDING", (0, 0), (-1, -1), 6),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 6),
            ]))
            story.append(table)
            rows = []
        if not line:
            continue
        level = len(line) - len(line.lstrip("#"))
        if level:
            heading = line[level:].strip()
            if heading in {"Migreringsfunn", "Verifisering av 12.8-klienten"}:
                story.append(PageBreak())
            story.append(Paragraph(inline(heading), styles[{1: "Title", 2: "Heading2", 3: "Heading3"}[level]]))
        else:
            story.append(Paragraph(inline(line if not line.startswith("- ") else "• " + line[2:]), styles["Normal"]))
    doc.build(story, onFirstPage=footer, onLaterPages=footer)


if __name__ == "__main__":
    report()
