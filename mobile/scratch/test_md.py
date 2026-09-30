import docx
import os

def docx_to_markdown(docx_path, md_path):
    doc = docx.Document(docx_path)
    lines = []
    
    # Track front matter vs content
    for p in doc.paragraphs:
        txt = p.text.strip()
        if not txt:
            continue
            
        # Determine heading level by font size / bold or style
        r0 = p.runs[0] if p.runs else None
        is_bold = r0.font.bold if r0 else False
        size = r0.font.size.pt if (r0 and r0.font.size) else 12
        
        if txt.startswith("CHAPTER ") or txt in ["ACKNOWLEDGEMENT", "ABSTRACT", "INDEX", "REFERENCES"]:
            lines.append(f"\n# {txt}\n")
        elif (size >= 14 and is_bold) or (txt.startswith(("1.", "2.", "3.", "4.", "5.", "6.", "7.")) and len(txt.split()[0]) <= 5):
            lines.append(f"\n## {txt}\n")
        elif (size >= 12 and is_bold) or (txt.startswith(("1.", "2.", "3.", "4.", "5.", "6.", "7.")) and len(txt.split()[0]) > 5):
            lines.append(f"\n### {txt}\n")
        elif p.style.name.startswith("List Bullet"):
            lines.append(f"- {txt}")
        else:
            lines.append(f"{txt}\n")
            
    # Also include tables
    # For a clean markdown report, let's write out structured text
    # But writing a dedicated builder for PROJECT_REPORT.md ensures exact table formatting!

print("Done")
