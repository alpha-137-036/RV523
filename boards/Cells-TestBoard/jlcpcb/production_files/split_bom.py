import csv

INPUT_FILE = 'BOM-RV523_CellTestBoard.final.csv'
OUTPUT_FILE = 'BOM-RV523_CellTestBoard.final.split.csv'
MAX_LENGTH = 2048
DESIGNATOR_COLUMN_NAME = 'Designator'
QUANTITY_COLUMN_NAME = 'Quantity'

def split_designator(designator, max_length):
    if len(designator) <= max_length:
        return [designator]
    parts = []
    current = ""
    for item in designator.split(','):
        item = item.strip()
        if len(current) + len(item) + 1 > max_length:
            parts.append(current.strip(', '))
            current = item
        else:
            current += ',' + item if current else item
    if current:
        parts.append(current.strip(', '))
    return parts

with open(INPUT_FILE, newline='', encoding='utf-8') as infile, open(OUTPUT_FILE, 'w', newline='', encoding='utf-8') as outfile:
    reader = csv.DictReader(infile)
    fieldnames = reader.fieldnames
    writer = csv.DictWriter(outfile, fieldnames=fieldnames)
    writer.writeheader()

    for row in reader:
        original = row[DESIGNATOR_COLUMN_NAME]
        parts = split_designator(original, MAX_LENGTH)
        for part in parts:
            new_row = row.copy()
            new_row[DESIGNATOR_COLUMN_NAME] = part
            new_row[QUANTITY_COLUMN_NAME] = str(len(part.split(',')))
            writer.writerow(new_row)

print(f'Split BOM saved to {OUTPUT_FILE}')
