import re


converse = [
    {
        "original": r"(\d+(?:[.,]\d+)?)\s*(l|L|LTS|lts|Lts|LT|Lt|lt)",
        "factor": 1000, 
        "unit": "ml"
    },
    {
        "original": r"(\d+(?:[.,]\d+)?)\s*(cl|Cl|CL|CLTS|CLT|Clts|clts|Clt|clt)",
        "factor": 10,
        "unit": "ml"
    },
    {
        "original": r"(\d+(?:[.,]\d+)?)\s*(kg|Kg|KG)",
        "factor": 1000,
        "unit": "g"
    }
]

def convert_measure(value):
    
    for rule in converse:
        match = re.search(
            rule["original"],
            str(value),
            re.IGNORECASE
        )

        if match:
            number = float(match.group(1).replace(",", "."))
            result = number * rule["factor"]
            return f"{result:g}{rule['unit']}"

    return value