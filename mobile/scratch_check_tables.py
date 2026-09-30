import docx

doc = docx.Document(r'C:\Projects\ForenShield\mobile\ForenShield_Final_Project_Report.docx')

with open(r'C:\Projects\ForenShield\mobile\scratch_table_images.txt', 'w', encoding='utf-8') as out:
    for t_idx, table in enumerate(doc.tables):
        out.write(f"=== Table {t_idx} (rows={len(table.rows)}, cols={len(table.columns)}) ===\n")
        for r_idx, row in enumerate(table.rows):
            for c_idx, cell in enumerate(row.cells):
                drawings = cell._element.xpath('.//w:drawing')
                if drawings:
                    blips = cell._element.xpath('.//a:blip/@r:embed')
                    out.write(f"  Row {r_idx}, Col {c_idx}: drawings={len(drawings)}, blips={blips}\n")
                    out.write(f"    text: {cell.text.strip()[:60]}\n")

print("Done writing scratch_table_images.txt")
