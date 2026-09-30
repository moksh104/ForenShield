import win32com.client
import os

word = win32com.client.Dispatch("Word.Application")
word.Visible = False
try:
    doc_path = os.path.abspath(r"C:\Projects\ForenShield\mobile\ForenShield_Final_Project_Report.docx")
    doc = word.Documents.Open(doc_path, ReadOnly=True)
    pages = doc.ComputeStatistics(2) # 2 = wdStatisticPages
    words = doc.ComputeStatistics(0) # 0 = wdStatisticWords
    print(f"Current Word Count: {words}")
    print(f"Current Page Count: {pages}")
    doc.Close(False)
finally:
    word.Quit()
