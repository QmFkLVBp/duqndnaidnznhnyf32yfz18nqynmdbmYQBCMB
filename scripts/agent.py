#!/usr/bin/env python3
import ollama
import subprocess
import sys

def query(prompt):
    response = ollama.chat(model='phi3:mini', messages=[
        {'role': 'system', 'content': 'Ти асистент Death Star OS для пентесту. Відповідай коротко, по-діловому.'},
        {'role': 'user', 'content': prompt}
    ])
    return response['message']['content']

if __name__ == "__main__":
    if len(sys.argv) > 1:
        cmd = " ".join(sys.argv[1:])
        print(query(cmd))
    else:
        print("Вейдер готовий. Дайте команду.")
