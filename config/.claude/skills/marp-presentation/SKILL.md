---
name: MARP Presentation Skill
description: A skill for converting long-form markdown content into effective MARP slide decks. This skill helps Claude Code understand presentation design principles and MARP-specific syntax to produce slides that support speaking rather than replace it.
license: MIT
---

# MARP Presentation Skill

## Purpose

Convert long-form markdown content into effective MARP slide decks. This skill helps Claude Code understand presentation design principles and MARP-specific syntax to produce slides that support speaking rather than replace it.

---

## Core Principles

### 1. One Idea Per Slide

If a slide needs "and" in the title, it's two slides. Each slide should pass the "glance test"—the audience should grasp the point in 3 seconds.

### 2. Slides Are Prompts, Not Scripts

The slide reminds the speaker what to say. The speaker provides the depth, stories, and nuance. Never put on a slide what should come from the speaker's mouth.

### 3. Speaker Notes Carry the Payload

All the detail, stories, statistics, and elaboration go in speaker notes. The slide is the headline; the notes are the article.

### 4. Progressive Disclosure

Complex ideas build across multiple slides. Don't dump everything at once. Let the audience follow the logic step by step.

### 5. Visual Breathing Room

White space is a feature. Dense slides create cognitive overload. When in doubt, delete.

---

## MARP Syntax Reference

### Front Matter (Required)

```yaml
---
marp: true
theme: default
paginate: true
header: "Header Text"
footer: "Footer Text"
---
```

### Slide Separator

```markdown
---
```

Three dashes create a new slide.

### Speaker Notes

```markdown
<!--
Speaker notes go here.
They don't appear on the slide.
Use for stories, details, transitions.
-->
```

### Directives (Per-Slide Settings)

```markdown
<!-- _class: lead -->      # Centered, large text
<!-- _paginate: false -->  # Hide page number
<!-- _header: '' -->       # Remove header for this slide
<!-- _footer: '' -->       # Remove footer for this slide
<!-- _backgroundColor: #123 -->
<!-- _color: white -->
```

### Fitting Text

```markdown
# <!-- fit --> This Title Scales to Fit
```

### Images

**Background (full slide):**

```markdown
![bg](image.jpg)
```

**Background with opacity:**

```markdown
![bg opacity:0.5](image.jpg)
```

**Background left/right split:**

```markdown
![bg left:40%](image.jpg)

# Content on right
```

**Background tiled:**

```markdown
![bg vertical](image1.jpg)
![bg](image2.jpg)
```

**Inline image:**

```markdown
![width:300px](image.jpg)
```

### Columns (using HTML)

```markdown
<div style="display: flex;">
<div style="flex: 1;">

Left column content

</div>
<div style="flex: 1;">

Right column content

</div>
</div>
```

---

## Slide Patterns

### Pattern: Title Slide

```markdown
---
marp: true
theme: default
paginate: true
footer: "Author | Date"
---

# Presentation Title

## Subtitle or Tagline

**Author Name** | Event | Date

<!--
Welcome, introduce yourself, set context.
-->

---
```

### Pattern: Section Divider

```markdown
---

<!-- _class: lead -->
<!-- _paginate: false -->

# <!-- fit --> Section Title

<!--
Transition statement: "Now let's talk about..."
-->

---
```

### Pattern: Key Point (Minimal)

```markdown
---
# The Core Idea

One sentence that captures it.

<!--
Elaborate here. Tell the story. Give the example.
This is where the real content lives.
-->
---
```

### Pattern: List Slide

```markdown
---

# Three Things to Remember

- First point (brief)
- Second point (brief)
- Third point (brief)

<!--
Expand on each:
1. First point - full explanation
2. Second point - full explanation
3. Third point - full explanation
-->

---
```

### Pattern: Quote

```markdown
---

<!-- _class: lead -->

> "The quote goes here, kept reasonably short."

— Attribution

<!--
Context for the quote. Why it matters.
How it connects to your point.
-->

---
```

### Pattern: Story Setup

```markdown
---

# True Story

**The setup in one line.**

<!--
Tell the full story here:
- What happened
- Why it matters
- The lesson learned
-->

---
```

### Pattern: Before/After or Problem/Solution

```markdown
---

# The Problem

- Pain point one
- Pain point two

<!--
Describe the problem state fully.
-->

---

# The Solution

- Resolution one
- Resolution two

<!--
Describe how this solves it.
-->

---
```

### Pattern: Resource Slide

```markdown
---

# Resources

| Resource | Why |
|----------|-----|
| [Link](url) | One-line description |
| [Link](url) | One-line description |

<!--
Mention which ones you personally recommend and why.
-->

---
```

### Pattern: Closing Slide

```markdown
---

<!-- _class: lead -->

# Thank You

**Contact Info**
- Link 1
- Link 2

<!--
Closing thought, call to action, invitation to connect.
-->

---
```

---

## Design Tips

### Mermaid Diagrams

```markdown
---
marp: true
header: '<script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"></script>'
---
<div class="mermaid">
sequenceDiagram
    participant Alice
    participant Bob
    Alice->>John: Hello John, how are you?
    loop HealthCheck
        John->>John: Fight against hypochondria
    end
    Note right of John: Rational thoughts <br/>prevail!
    John-->>Alice: Great!
    John->>Bob: How about you?
    Bob-->>John: Jolly good!
</div>
```

### Draw.io Diagrams

1. Save the file to `file-name.drawio`.
2. Ask user to export as SVG and save as `file-name.svg`.
3. Reference the SVG in your markdown (see "Inline image" above).

## Conversion Process

When converting long-form markdown to MARP slides:

### Step 1: Identify Structure

- Find the major sections (H2 headers typically)
- Each major section becomes a section divider slide
- Subsections become content slides

### Step 2: Extract Headlines

- Turn each paragraph's main point into a slide title
- The first sentence often contains the headline
- If a paragraph has multiple points, it's multiple slides

### Step 3: Compress to Bullets

- Full sentences become bullet fragments
- Remove articles, helping verbs, filler
- "You should always make sure to test your code" → "Test your code"

### Step 4: Move Depth to Speaker Notes

- Full paragraphs → speaker notes
- Examples and stories → speaker notes
- Statistics and details → speaker notes
- The slide gets the takeaway; notes get the support

### Step 5: Add Transitions

- Section dividers between major themes
- Speaker notes should include transition phrases
- "Now that we've covered X, let's look at Y..."

### Step 6: Balance the Deck

- Check for runs of text-heavy slides (break them up)
- Check for back-to-back lists (add variety)
- Insert breathing room slides (quotes, images, dividers)

---

## Quality Checklist

Run this check on completed slide decks:

### Per-Slide Checks

- [ ] Title is under 8 words
- [ ] No more than 5 bullets
- [ ] Each bullet under 10 words
- [ ] No full sentences on slide (bullets are fragments)
- [ ] Speaker notes exist and are substantive
- [ ] Only one level of bullet nesting

### Deck-Level Checks

- [ ] Title slide has name, date, event
- [ ] Section dividers between major themes
- [ ] No more than 3 text slides in a row without variety
- [ ] Closing slide with contact info
- [ ] Total slide count reasonable for time (roughly 1-2 min/slide)

### Speaker Notes Checks

- [ ] Every content slide has notes
- [ ] Notes include stories/examples where relevant
- [ ] Transition phrases included
- [ ] Timing notes for long sections

---

## Common Mistakes to Fix

### Mistake: Wall of Text

**Before:**

```markdown
# Career Ownership

You need to take ownership of your career because no one else will do it for you. Your employer provides opportunities but you must drive your own development. This means investing time in learning, building your portfolio, and creating options for yourself. Don't wait for permission to grow.
```

**After:**

```markdown
# Own Your Career

- Your employer provides opportunities
- You drive development
- Build your portfolio
- Create your options

<!--
Full explanation: No one else will do this for you...
[rest of paragraph goes here as notes]
-->
```

### Mistake: Too Many Ideas

**Before:**

```markdown
# Key Lessons

- Be the CEO of your career
- Learn out loud by building and sharing
- Get out of your own way—fear and ego block growth
- Find your community
- Use sandboxes to learn safely
- Bridge technologies intentionally
```

**After:** Split into 6 slides, one per point, with section dividers grouping related concepts.

### Mistake: Missing Speaker Notes

**Problem:** Slide has bullets but no context for the speaker.
**Fix:** Add notes with the full explanation, a story, or an example for each bullet.

### Mistake: Nested Complexity

**Before:**

```markdown
- Main point
  - Sub point A
    - Detail 1
    - Detail 2
  - Sub point B
```

**After:** Flatten to one level or split across slides.

---

## MARP CLI Commands

```bash
# Preview with live reload
npx @marp-team/marp-cli -p slides/presentation.marp.md

# Export to PDF
npx @marp-team/marp-cli slides/presentation.marp.md -o exports/presentation.pdf

# Export to PowerPoint
npx @marp-team/marp-cli slides/presentation.marp.md -o exports/presentation.pptx

# Export to HTML
npx @marp-team/marp-cli slides/presentation.marp.md -o exports/presentation.html

# Watch mode (auto-rebuild on save)
npx @marp-team/marp-cli -w slides/presentation.marp.md
```

---

## Theme Customization

Basic custom styling in front matter:

```yaml
---
theme: gaia
pagination: true
lang: ja
style: |
  h1, h2, h3, h4, h5, h6, p {
    word-break: auto-phrase;
  }
  h1, h2, h3, h4, h5, h6 {
    text-wrap: balance;
  }
  p {
    text-wrap: pretty;
  }
  section {
    justify-content: start;
    font-size: 22px;
  }
  .columns {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 1rem;
  }
---
```

For full custom themes, create a CSS file and reference it:

```yaml
---
marp: true
theme: ./themes/custom.css
---
```
