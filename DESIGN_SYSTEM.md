# Design System

## Philosophy
The DMV Practice App utilizes a premium, fast, and modern design system inspired by the Wise design principles. It features bold typography, confident hierarchy, large editorial headings, clean flat surfaces, minimal shadows, generous spacing, expressive color blocking, and pill-shaped interactive controls. The identity focuses on an asphalt/road-learning theme.

## 1. Color Tokens

### Backgrounds
- `backgroundLight`: `#F4F4F2` (Warm off-white / light concrete)
- `surface`: `#FFFFFF`
- `surfaceElevated`: `#FAFAFA`
- `surfaceDark`: `#141716` (Deep asphalt green-black)

### Primary Colors
- `primaryDark`: `#121A16` (Deep asphalt green-black - used for bold headings and main structure)
- `primaryAccent`: `#D1F840` (Reflective safety lime - used for primary buttons and progress highlights)
- `secondaryAccent`: `#2F80ED` (California sky blue - used for active states and secondary links)

### Semantic Colors
- `warning`: `#FFB300` (Road-sign amber)
- `danger`: `#E53935` (Traffic red)
- `success`: `#00C853` (Signal green)
- `info`: `#2F80ED` (Sky blue)

### Text Colors
- `textPrimary`: `#121A16`
- `textSecondary`: `#5A615D`
- `textTertiary`: `#8F9692`
- `textInverse`: `#FFFFFF`

## 2. Typography Scale
Font: `Outfit` (Google Fonts) - highly legible, modern, and expressive.

- `Display Large`: 40px, Bold, -1px letter spacing (Main headings, hero section)
- `Display Medium`: 32px, Bold, -0.5px letter spacing (Screen titles)
- `Display Small`: 28px, Bold, 0px letter spacing
- `Headline Large`: 24px, SemiBold (Card titles)
- `Headline Medium`: 20px, SemiBold
- `Headline Small`: 18px, Medium
- `Body Large`: 16px, Regular, 1.5 line height (Primary reading text)
- `Body Medium`: 14px, Regular, 1.5 line height (Secondary text, descriptions)
- `Body Small`: 12px, Regular (Captions, small labels)
- `Label Large`: 16px, Medium (Button text)
- `Label Medium`: 14px, Medium (Chips, small buttons)

## 3. Spacing Tokens
Uses an 8pt grid system.

- `xs`: 4px
- `sm`: 8px
- `md`: 16px
- `lg`: 24px
- `xl`: 32px
- `2xl`: 48px
- `3xl`: 64px

## 4. Radius System
Generous pill shapes and smooth rounded corners.

- `sm`: 8px (Small inputs, inner cards)
- `md`: 16px (Standard cards, dialogs)
- `lg`: 24px (Large cards, bottom sheets)
- `pill`: 999px (Buttons, chips)

## 5. Component Guidelines

### Buttons
- **Primary Button**: `primaryAccent` background, `primaryDark` text, `pill` radius, no shadow. Hover/press state slightly scales down and darkens color.
- **Secondary Button**: `surfaceDark` background, `surface` text, `pill` radius.
- **Outline Button**: Transparent background, `primaryDark` border 2px, `primaryDark` text.

### Cards
- Clean flat surfaces (`surface`), 1px subtle border (`#E0E0E0`), `md` radius. No generic drop shadows unless used for crucial elevation (like a floating bottom sheet).

### Status Chips
- Pill-shaped.
- Background uses 10% opacity of semantic color. Text uses 100% semantic color.

### Progress Indicators
- Thick tracks (8-12px), rounded caps.
- Background track: `textTertiary` (20% opacity).
- Active track: `primaryAccent`.

### Dialogs & Bottom Sheets
- Large corner radii (`lg` or `24px`).
- Dimmed background overlay (`primaryDark` at 40% opacity).
- Clear, centered typography.

## 6. Iconography
Use clear, bold, geometric stroke icons (e.g., Lucide or Phosphor icons, 2px stroke weight).
