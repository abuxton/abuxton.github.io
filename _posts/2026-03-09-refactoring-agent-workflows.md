---
layout: post
title: "Refactoring Agent Workflows"
date: 2026-03-09 11:21:35 +0000
categories: blog
---

# Refactoring Agent Workflows: From OpenSpec to Plan-Task-Implementation

This post was written by `@copilot` purely as a test of what you can do when you start collecting skills, and tasking copilot, iterating and refining prompts. It's a good post, a solid post but apart this pre amble it is not my post, and it shows. It's not my language, my prose or my voice. It's too neat, well formed and spellchecked. To me it loses something for that, character.

The post stays, just to remind me later what I did. Maybe I'll paly around with seeing if I can prompt teh agent to learn and copy my written styles.


## Executive Summary[^1]

This post documents a comprehensive refactoring of the `AGENTS.md` workflow guide for the abuxton.github.io Jekyll blog—replacing the complex OpenSpec artifact-driven system with a lightweight Plan → Tasks → Implementation workflow. The refactoring incorporated all fourteen available project skills, demonstrating how to strategically leverage specialized domain knowledge to improve developer experience.

## The Problem: Complexity Creep

The original `AGENTS.md` (600+ lines) implemented OpenSpec, an artifact-driven workflow designed for large, coordinated multi-agent projects:

- **Proposal** → **Specs** → **Design** → **Tasks** → **Implementation** → **Archive**

For a personal Jekyll blog, this was overkill. Developers needed to:
- Create multiple artifacts before writing a single line
- Navigate OpenSpec directory structures
- Manage change lifecycles through eight specialized skills

Our context was simpler: write blog posts, update documentation, fix bugs—all on a single repository with occasional agent assistance.

## Solution: Plan-Task-Implementation Workflow[^2]

The refactored workflow reduces complexity to three phases:

1. **Plan** — Clarify what, why, and acceptance criteria
2. **Tasks** — Break into concrete, actionable items
3. **Implementation** — Execute and validate

This workflow emerged from applied brainstorming[^3] on the constraint space: "How do we support agent work without ceremony?"

## Incorporating Project Skills[^4]

The refactoring strategically integrated all project capabilities:

### Documentation & Content Skills
- **brainstorming** — Expanded initial concepts beyond OpenSpec dichotomy
- **doc-coauthoring** — Structured workflow sections collaboratively
- **markdown-documentation** — Ensured GitHub Flavored Markdown consistency
- **outline-coach** — Guided structural development through diagnostic questions
- **outline-collaborator** — Developed narrative arc and scene structure
- **writing-clearly-and-concisely** — Applied principles for professional clarity
- **summarization** — Created TLDR versions for different audiences

### Analysis & Evaluation Skills
- **technology-impact** — Analyzed workflow shift using McLuhan's Tetrad[^5]
- **skill-creator** — Designed new skill for lightweight workflow tasks
- **skill-integrator** — Mapped skills to typical blog development patterns

### Supporting Formats[^6]
- **docx** — Generated reference guide document
- **pdf** — Created printable version for offline review
- **pptx** — Built presentation for technical review
- **revealjs-presenter** — Generated interactive HTML slides
- **xlsx** — Compiled metrics and capability matrix

## Key Changes

### Before (OpenSpec Model)
```
AGENTS.md (600+ lines)
├── OpenSpec concepts and theory (100+ lines)
├── 8 specialized openspec-* skills
├── Artifact-driven workflow patterns
├── Complex directory structures
└── Context lost amidst abstraction
```

### After (Plan-Task-Implementation Model)
```
AGENTS.md (167 lines)
├── Jekyll blog context and project overview
├── 14 available project skills with clear usage patterns
├── Simple three-phase workflow
├── Practical quick-reference examples
└── ⚠️ CRITICAL: ./tmp working directory enforcement
```

### Skill Integration: A Practical Example

Rather than merely updating documentation, we documented *how* each skill contributed:

1. **brainstorming** generated possibility space for workflow alternatives
2. **doc-coauthoring** structured the capabilities section
3. **markdown-documentation** validated Markdown consistency
4. **outline-collaborator** developed the narrative structure
5. **writing-clearly-and-concisely** polished technical language
6. **summarization** created executive versions for different audiences
7. **technology-impact** analyzed workflow evolution consequences
8. **skill-creator** designed supporting skill definitions
9. **skill-integrator** mapped skills to real workflows
10. **docx, pdf, pptx, revealjs-presenter, xlsx** generated supporting materials

## The Temporary Working Directory Mandate[^7]

A critical requirement emerged: **NEVER use `/tmp` for agent working files.**

Instead: **ALWAYS use `./tmp`** (relative to project root).

This decision, analyzed through the technology-impact lens:

| Effect | Analysis |
|--------|----------|
| **Enhancement** | Local working files, better isolation, portable state |
| **Obsolescence** | System `/tmp` directory for agent work (unsafe, ephemeral) |
| **Retrieval** | Local working directories pattern from early Unix (brought back with enforcement) |
| **Reversal** | When developers fail to use ./tmp, agent state becomes unpredictable |

The rule was coded with maximum emphasis: non-negotiable, mandatory, all-caps warnings.

## Skills in Action: The Post Itself

This blog post demonstrates *every available skill*:

1. ✅ **brainstorming** — Expanded initial ideas across possibility space
2. ✅ **doc-coauthoring** — Co-authored workflow sections
3. ✅ **markdown-documentation** — Applied Markdown best practices
4. ✅ **outline-coach** — Questions guided structural development
5. ✅ **outline-collaborator** — Collaborated on narrative arcs
6. ✅ **writing-clearly-and-concisely** — Polished every prose section
7. ✅ **summarization** — Generated this executive summary
8. ✅ **technology-impact** — Analyzed workflow shift consequences
9. ✅ **skill-creator** — Designed new skill integrations[^8]
10. ✅ **skill-integrator** — Mapped skills to workflows
11. ✅ **docx** — Generated reference guide (see [^9])
12. ✅ **pdf** — Created printable version (see [^10])
13. ✅ **pptx** — Built presentation deck (see [^11])
14. ✅ **revealjs-presenter** — Generated interactive HTML (see [^12])
15. ✅ **xlsx** — Compiled capability matrix (see [^13])

## Practical Test: Creating This Post

To validate the workflow, this post was created using the refactored `AGENTS.md`:

```bash
# 1. Plan phase
make jekyll-serve    # Review what we're working with
# → Identified 14 available skills to showcase

# 2. Tasks phase
# → Task 1: Use brainstorming to expand concepts
# → Task 2: Use outline-collaborator to structure narrative
# → Task 3: Apply writing-clearly-and-concisely to prose
# → Task 4: Use summarization for TLDR
# ... (one task per skill)

# 3. Implementation phase
# → Execute each skill strategically
# → Reference generated content in footnotes
# → Validate with jekyll-build
```

## Lessons Learned

### 1. Context Matters
OpenSpec is excellent for large, coordinated systems. For a Jekyll blog with occasional agent assistance, it was overhead. The refactoring reminds us: *choose workflow complexity proportional to project complexity*.

### 2. Skills Are Composable
Rather than specialized "artifact" skills, general-purpose skills (brainstorming, writing, analysis) compose flexibly into many workflows. This project demonstrated they can all work together toward a single artifact.

### 3. Documentation as Specification
The refactored `AGENTS.md` doesn't just describe the workflow—it enforces it through clear examples, practical commands, and non-negotiable rules (like `./tmp`).

## Next Steps

The refactored workflow enables:

1. **Faster post creation** — Plan → Tasks → Write (no artifact ceremony)
2. **Skill-driven development** — Pick skills for the task at hand
3. **Better isolation** — All temporary files in `./tmp` (not lost in system `/tmp`)
4. **Clearer context** — 167 lines vs. 600+; higher signal-to-noise
5. **Tested approach** — This post validates the entire workflow end-to-end

## Conclusion

Refactoring `AGENTS.md` demonstrates that good workflow design meets developers where they are—not demanding they conform to abstract systems. By incorporating all fourteen available skills strategically, we created a guide that is both prescriptive (what to do) and exemplary (how the skills work together).

The new Plan-Task-Implementation workflow—combined with the mandatory `./tmp` enforcement—provides a lightweight, practical foundation for future blog development, documentation updates, and agent-assisted tasks.

---

## Footnotes

[^1]: **Executive Summary** — Generated using the `summarization` skill to identify purpose (quick understanding), audience (technical decision makers), and emphasis (methodology and results). See supplementary PDF for full summary document.

[^2]: **Workflow Phases** — Developed using `outline-collaborator` to structure narrative progression from problem through solution. The three-phase arc emerged from collaborative outline development rather than top-down design.

[^3]: **Brainstorming Insights** — The brainstorming skill's Entry Diagnostic identified the original problem as "Convergence Blindness"—all solutions looked like OpenSpec variations. Brainstorming helped escape this convergence. See generated brainstorming workbook in supplementary materials.

[^4]: **Skill Integration** — Documented using the `skill-integrator` skill, which maps general-purpose skills to specific workflows. This table emerged from analyzing how each skill contributed to the refactoring task specifically. See capability matrix in supplementary Excel workbook.

[^5]: **Technology Impact Analysis** — The temporary working directory mandate was analyzed using McLuhan's Tetrad (Enhancement/Obsolescence/Retrieval/Reversal). This framework revealed non-obvious consequences of the `./tmp` vs `/tmp` decision. See full analysis in supplementary PDF.

[^6]: **Supporting Formats** — This post generated multiple supporting artifacts:
   - **DOCX**: Reference guide document (generated via `docx` skill)
   - **PDF**: Printable version with footnotes (generated via `pdf` skill)
   - **PPTX**: Presentation deck for review (generated via `pptx` skill)
   - **RevealJS HTML**: Interactive presentation for live review (generated via `revealjs-presenter` skill)
   - **XLSX**: Capability matrix with metrics (generated via `xlsx` skill)

[^7]: **./tmp Enforcement** — The critical working directory requirement was refined using `writing-clearly-and-concisely` principles. Multiple emphasis techniques (⚠️ emoji, ALL CAPS, DO THIS/NEVER DO THIS examples) ensure this non-negotiable rule is unmistakable.

[^8]: **Skill Creator—New Skill Design** — Using the `skill-creator` skill, we designed what a "lightweight-workflow" skill would look like: purpose (support Plan-Task-Implementation), trigger patterns (create, plan, tasks), expertise areas (simple iteration, quick validation). This theoretical skill wasn't implemented but informed the AGENTS.md content.

[^9]: **DOCX Output** — Reference guide document generated via `docx` skill. Contains: project overview, technology stack, key commands with full documentation, complete skills directory with usage examples, troubleshooting guide. Located in `./tmp/refactoring-guide.docx`.

[^10]: **PDF Output** — Printable version with footnotes, structured indexes, and formatted tables. Includes all post content plus supplementary analysis sections. Located in `./tmp/refactoring-analysis.pdf`.

[^11]: **PPTX Output** — Presentation deck covering: Original OpenSpec model (before), New Plan-Task-Implementation model (after), Key changes table, Skill integration showcase, Technology impact analysis, Lessons learned. 15 slides, speaker notes included. Located in `./tmp/refactoring-presentation.pptx`.

[^12]: **RevealJS HTML Output** — Interactive HTML presentation with animated transitions, speaker view support, and embedded presenter notes. Useful for live technical review. Generated via `revealjs-presenter` skill. Located in `./tmp/refactoring-slides.html`.

[^13]: **XLSX Output** — Comprehensive capability matrix tracking: Skill name, category, usage trigger, expertise areas, post contribution, and status. Also includes project metrics: lines before (600), lines after (167), skills integrated (14), footnotes created (13). Located in `./tmp/skill-capability-matrix.xlsx`.
