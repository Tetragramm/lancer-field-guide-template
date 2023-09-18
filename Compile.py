import sys
import re
import os

# Title = 'Omission of Terror'
# Title = 'Night Watch on Al-Sorah'
Title = "Field Guide to Field Guides"
if os.path.isfile(f'{Title}.tex'):
    os.system(
        f'lualatex -synctex=1 -interaction=nonstopmode -file-line-error -pdf "{Title}.tex"')
    os.system(
        f'lualatex -synctex=1 -interaction=nonstopmode -file-line-error -pdf "{Title}.tex"')
    os.system(
        f'lualatex -synctex=1 -interaction=nonstopmode -file-line-error -pdf "{Title}.tex"')
else:
    print('No LaTeX file matching saved Title found.')
