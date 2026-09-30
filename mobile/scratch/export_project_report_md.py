import os
import docx
from docx.oxml.ns import qn
from docx.text.paragraph import Paragraph
from docx.table import Table

def export_docx_to_md(docx_path, output_md_path):
    doc = docx.Document(docx_path)
    body = doc.element.body
    md_lines = []
    
    for element in body:
        tag = element.tag.split('}')[-1]
        if tag == 'p':
            p = Paragraph(element, doc)
            txt = p.text.strip()
            if not txt:
                continue
            
            # Check font styling
            r0 = p.runs[0] if p.runs else None
            is_bold = r0.font.bold if (r0 and r0.font.bold) else False
            size = r0.font.size.pt if (r0 and r0.font.size) else 12
            
            if txt.startswith("CHAPTER ") or txt in ["ACKNOWLEDGEMENT", "ABSTRACT", "INDEX", "REFERENCES"]:
                md_lines.append(f"\n# {txt}\n")
            elif size >= 15 and is_bold:
                md_lines.append(f"\n# {txt}\n")
            elif size >= 13 and is_bold:
                md_lines.append(f"\n## {txt}\n")
            elif is_bold and any(txt.startswith(f"{i}.") for i in range(1, 8)):
                md_lines.append(f"\n### {txt}\n")
            elif p.style.name.startswith("List Bullet"):
                # Check bold prefix
                runs = p.runs
                if len(runs) > 1 and runs[0].font.bold:
                    md_lines.append(f"- **{runs[0].text}**{''.join(r.text for r in runs[1:])}")
                else:
                    md_lines.append(f"- {txt}")
            elif txt.startswith("Figure ") or txt.startswith("Table "):
                md_lines.append(f"\n**{txt}**\n")
            else:
                # Check bold prefix in regular paragraph
                runs = p.runs
                if len(runs) > 1 and runs[0].font.bold:
                    md_lines.append(f"\n**{runs[0].text}**{''.join(r.text for r in runs[1:])}\n")
                else:
                    md_lines.append(f"\n{txt}\n")
                    
        elif tag == 'tbl':
            t = Table(element, doc)
            # Render markdown table
            headers = []
            for row_idx, row in enumerate(t.rows):
                cells_text = [cell.text.strip().replace("\n", " ") for cell in row.cells]
                # Avoid duplicate merged cells in display
                if row_idx == 0:
                    headers = cells_text
                    md_lines.append("\n| " + " | ".join(cells_text) + " |")
                    md_lines.append("| " + " | ".join(["---"] * len(cells_text)) + " |")
                else:
                    md_lines.append("| " + " | ".join(cells_text) + " |")
            md_lines.append("\n")
            
    with open(output_md_path, "w", encoding="utf-8") as f:
        f.write("\n".join(md_lines))
    print(f"Successfully exported {output_md_path}")

if __name__ == "__main__":
    export_docx_to_md(
        r"C:\Projects\ForenShield\mobile\ForenShield_Final_Project_Report.docx",
        r"C:\Projects\ForenShield\mobile\PROJECT_REPORT.md"
    )
