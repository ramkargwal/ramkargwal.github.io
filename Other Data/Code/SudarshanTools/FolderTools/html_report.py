import os
import sys
import webbrowser
from datetime import datetime
from collections import Counter

print("="*50)
print("     FOLDER ANALYSIS REPORT GENERATOR")
print("="*50)

# Check if path is provided via right-click (Context Menu)
if len(sys.argv) > 1:
    folder = sys.argv[1]
    print(f"\n[+] Folder selected via Right-Click: {folder}")
else:
    # Fallback: Agar double-click kiya ho tab yeh poochega
    folder = input("\nPlease enter the folder path you want to scan: ").strip()

# Agar path me extra quotes (") aa jayein, toh unhe hata dega
if folder.startswith('"') and folder.endswith('"'):
    folder = folder[1:-1]
elif folder.startswith("'") and folder.endswith("'"):
    folder = folder[1:-1]

if not os.path.isdir(folder):
    print(f"\n[!] Error: The directory '{folder}' does not exist.")
    input("Press Enter to exit...")  # Screen ko turant band hone se rokne ke liye
    sys.exit(1)

# Variables for tracking
files_data = []
ext_counter = Counter()
total_size = 0
total_files = 0

print("\nScanning folder and sub-folders... Please wait.")

# os.walk se main folder aur sub-folders scan hote hain
for root, dirs, files in os.walk(folder):
    for f in files:
        filepath = os.path.join(root, f)
        try:
            st = os.stat(filepath)
            size = st.st_size
            total_size += size
            total_files += 1
            
            ext = os.path.splitext(f)[1].lower() or "[No Ext]"
            ext_counter[ext] += 1
            
            # Sub-folder ka relative path
            rel_dir = os.path.relpath(root, folder)
            if rel_dir == ".":
                rel_dir = "Main Folder"
                
            files_data.append({
                'name': f,
                'directory': rel_dir,
                'ext': ext,
                'size': size / 1024, # in KB
                'modified': datetime.fromtimestamp(st.st_mtime).strftime("%Y-%m-%d %H:%M")
            })
        except Exception:
            pass

files_data.sort(key=lambda x: x['directory'].lower())

# Desktop par HTML file save karna
desktop = os.path.join(os.path.expanduser("~"), "Desktop")
timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
html_file = os.path.join(desktop, f"Folder_Report_{timestamp}.html")

ext_badges = ""
for ext, cnt in sorted(ext_counter.items(), key=lambda x: x[1], reverse=True):
    ext_badges += f'<span class="badge">{ext} <b>({cnt})</b></span>'

table_rows = ""
for i, data in enumerate(files_data, start=1):
    table_rows += f"""
    <tr>
        <td>{i}</td>
        <td>{data['name']}</td>
        <td class="dir-col">{data['directory']}</td>
        <td>{data['ext']}</td>
        <td class="right">{data['size']:,.1f} KB</td>
        <td class="center">{data['modified']}</td>
    </tr>
    """

html_content = f"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Folder Analysis Report</title>
    <style>
        body {{ font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; margin: 0; padding: 20px; color: #333; }}
        .container {{ max-width: 1200px; margin: 0 auto; background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }}
        h1 {{ text-align: center; color: #2c3e50; margin-top: 0; margin-bottom: 10px; font-size: 24px; }}
        .summary-box {{ display: flex; justify-content: space-between; background: #eaf2f8; padding: 15px; border-radius: 6px; border-left: 5px solid #3498db; margin-bottom: 15px; font-size: 14px; }}
        .badge-container {{ margin-bottom: 15px; font-size: 13px; }}
        .badge {{ display: inline-block; background: #34495e; color: #fff; padding: 3px 8px; border-radius: 12px; margin: 2px; font-size: 12px; }}
        .table-wrapper {{ max-height: 600px; overflow-y: auto; border: 1px solid #ddd; }}
        table {{ width: 100%; border-collapse: collapse; font-size: 13px; }}
        th, td {{ padding: 6px 10px; border-bottom: 1px solid #eee; text-align: left; }}
        th {{ background-color: #2c3e50; color: #fff; position: sticky; top: 0; z-index: 10; }}
        tr:nth-child(even) {{ background-color: #f9f9f9; }}
        tr:hover {{ background-color: #f1f1f1; }}
        .dir-col {{ color: #7f8c8d; font-size: 12px; }}
        .right {{ text-align: right; }}
        .center {{ text-align: center; }}
    </style>
</head>
<body>
<div class="container">
    <h1>Folder & Sub-Folder Analysis Report</h1>
    <div class="summary-box">
        <div><b>Root Directory:</b> {folder}</div>
        <div><b>Total Files:</b> {total_files:,}</div>
        <div><b>Total Size:</b> {total_size / (1024*1024):.2f} MB</div>
        <div><b>Scan Date:</b> {datetime.now().strftime('%d-%m-%Y %I:%M %p')}</div>
    </div>
    <div class="badge-container"><b>File Extensions Found:</b><br>{ext_badges}</div>
    <div class="table-wrapper">
        <table>
            <thead>
                <tr><th width="5%">No.</th><th width="30%">File Name</th><th width="30%">Location (Folder)</th><th width="10%">Ext</th><th width="10%" class="right">Size</th><th width="15%" class="center">Last Modified</th></tr>
            </thead>
            <tbody>{table_rows}</tbody>
        </table>
    </div>
</div>
</body>
</html>
"""

with open(html_file, "w", encoding="utf-8") as f:
    f.write(html_content)

print(f"\n[+] Success! Report saved at: {html_file}")
print("[+] Opening report in your browser...")

webbrowser.open('file://' + os.path.realpath(html_file))

# Agar script double-click se chali thi toh turant band nahi hogi, varna script right-click me jaldi close ho jayegi
if len(sys.argv) == 1:
    print("\n" + "="*50)
    input("Task Completed. Press Enter to close this window...")