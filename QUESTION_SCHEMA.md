# Question Schema

## Overview
The application uses a robust, flexible schema to represent DMV practice questions. This schema is designed to be easily mapped to local SQLite database tables via Drift, while supporting future backend sync and various illustration formats.

## JSON Schema Representation

```json
{
  "type": "object",
  "properties": {
    "id": {
      "type": "string",
      "description": "Unique identifier for the question (e.g., UUID)."
    },
    "state": {
      "type": "string",
      "description": "State code (e.g., 'CA' for California). Allows filtering by state."
    },
    "licenseType": {
      "type": "string",
      "description": "Type of license (e.g., 'ClassC', 'Motorcycle', 'CDL')."
    },
    "category": {
      "type": "string",
      "description": "Topic category (e.g., 'Road Rules', 'Traffic Signs', 'Right of Way')."
    },
    "difficulty": {
      "type": "integer",
      "description": "Difficulty level from 1 (easy) to 3 (hard)."
    },
    "question": {
      "type": "string",
      "description": "The main question text."
    },
    "answers": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "id": {
            "type": "string",
            "description": "Unique identifier for the answer option."
          },
          "text": {
            "type": "string",
            "description": "Text of the answer option."
          }
        },
        "required": ["id", "text"]
      },
      "description": "List of possible answer options."
    },
    "correctAnswerId": {
      "type": "string",
      "description": "The ID of the correct answer from the 'answers' array."
    },
    "explanation": {
      "type": "string",
      "description": "Explanation shown after the user answers (whether correct or incorrect)."
    },
    "illustrationAsset": {
      "type": "string",
      "description": "Optional relative path or identifier for the visual asset (e.g., 'assets/illustrations/intersection_01.svg').",
      "nullable": true
    },
    "sourceReference": {
      "type": "string",
      "description": "Internal reference to the DMV handbook or source material for editorial verification (e.g., 'CA Handbook 2024, Page 34')."
    },
    "version": {
      "type": "integer",
      "description": "Version number of the question to handle updates."
    }
  },
  "required": [
    "id",
    "state",
    "licenseType",
    "category",
    "difficulty",
    "question",
    "answers",
    "correctAnswerId",
    "explanation",
    "sourceReference",
    "version"
  ]
}
```

## Considerations
- **Illustrations**: `illustrationAsset` is optional. The UI should gracefully handle questions with or without images. The asset path should be generic enough to allow SVGs, PNGs, WebP, or even Rive files in the future.
- **Originality**: All `question` and `explanation` texts must be original and not copied verbatim from competitors or the DMV handbook to adhere to copyright rules. `sourceReference` is strictly for internal use.
