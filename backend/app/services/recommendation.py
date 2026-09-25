def score_color_combo(top_color: str, bottom_color: str):
    top = top_color.lower()
    bottom = bottom_color.lower()

    pairs = {
        "weiss": ["blau", "marine", "beige", "schwarz"],
        "blau": ["weiss", "beige", "schwarz"],
        "marine": ["weiss", "beige"],
        "beige": ["marine", "weiss", "braun"],
        "schwarz": ["weiss", "beige", "grau"],
        "grau": ["schwarz", "weiss", "beige"],
    }

    if top in pairs and bottom in pairs[top]:
        return 0.9
    return 0.7
