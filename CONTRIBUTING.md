# 🤝 Contributing to SkillForge

First off, thank you for considering contributing to **SkillForge**! 🎉  
SkillForge is a community-driven learning hub, and every contribution — whether a typo fix, a new roadmap, or a feature improvement — helps learners around the world.

---

## 📌 Before You Start

- **Read the [README](README.md)** to understand the project's vision and structure.
- **Check the [issues tab](https://github.com/manojsatna31/skill-forge-learning/issues)** to see if your contribution is already being discussed.
- **If you're adding a new roadmap**, ensure it follows the **9‑phase structure** used across all existing roadmaps (Python, Java, SQL, DSA).

---

## 🧭 How Can I Contribute?

### 1. 🐛 Report Bugs
- Open an issue with a clear title and description.
- Include steps to reproduce the bug.
- Mention the browser/OS where you encountered it.

### 2. 💡 Suggest Enhancements
- Open an issue with the label `enhancement`.
- Explain **what** you want to add and **why** it would be valuable.
- For new roadmaps, provide a detailed syllabus outline.

### 3. 📝 Improve Existing Roadmaps
- Fix typos, broken links, or unclear explanations.
- Add missing code examples, tasks, or projects.
- Improve formatting and readability.

### 4. 🚀 Add a New Roadmap
> **Important:** All roadmaps must follow the **9‑phase structure**:

| Phase | Title | Purpose |
| :--- | :--- | :--- |
| Phase 1 | Setting Up Your Environment | Prerequisite & installation |
| Phase 2 | Foundations & Core Syntax | Basics, syntax, fundamentals |
| Phase 3 | Core Concepts & Data Structures | Data structures, OOP, relationships |
| Phase 4 | Advanced Concepts & Optimization | Advanced topics, performance |
| Phase 5 | Expert Patterns & Production Systems | Expert-level, design patterns, scaling |
| Phase 6 | Test Your Knowledge | MCQ assessments (3 levels) |
| Phase 7 | Bonus Track – Applied Projects | Real‑world projects |
| Phase 8 | Quick Reference Guide | Cheatsheets, revision |
| Phase 9 | Essential Tools & Ecosystem | Libraries, frameworks, tools |

**New roadmap checklist:**

- [ ] Create a subfolder (e.g., `react-roadmap/`)
- [ ] Use the shared `assets/css/` and `assets/js/` (do not duplicate them)
- [ ] Follow the existing `index.html` structure (phase tabs, sidebar, day content)
- [ ] Include **at least 3 projects** (Phase 1–4 mini‑projects, Phase 5 capstone)
- [ ] Include **MCQ sets** (Intermediate, Expert, Professional – 60 questions each)
- [ ] Include a **Quick Reference Guide** (Phase 8)
- [ ] Include a **Libraries/Tools** section (Phase 9)
- [ ] Add a link to the new roadmap in the landing page (`index.html`)

---

## 🛠️ Development Setup

1. **Fork the repository**
   ```bash
   git clone https://github.com/your-username/skill-forge-learning.git
   cd skill-forge-learning
    ```
2. **Run locally (no build tools needed – it's plain HTML/CSS/JS)**
   * **Open `index.html` in your browser** (or use a local server for better experience).
   * **Navigate through the roadmaps** and start your learning journey!
   * **Optional:** Use VS Code Live Server extension for a smoother experience.

3. **Make your changes in your local fork.**
4. **Test your changes – ensure all pages load and the navigation works.**

---

## 📐 Style Guide
#### HTML
* **Use semantic HTML5 elements (`<header>`, `<section>`, `<nav>`, etc.).**
* **Indent with 4 spaces.**
* **Keep code blocks inside `<div class="code-container">` with `<button class="copy-btn">` for copying.**


#### CSS
* **Do not edit assets/css/style.css (shared styles) unless you're fixing a global issue.**
* **For roadmap‑specific styles, use assets/css/roadmap-style.css.**
* **Follow the existing design system (colors, spacing, fonts) – stick to the #60a5fa blue accent.**

#### JavaScript
* **Do not edit assets/js/script.js (shared functions) unless you're adding a new shared feature.**
* **For roadmap‑specific logic, use assets/js/roadmap-script.js.**
* **Ensure the copyCode() function works on all code blocks.**

---

## 🔄 Pull Request Process
1. **Create a branch with a descriptive name:**
   ```text
   feat/add-javascript-roadmap
   fix/typo-in-python-day-15
   ```

2. **Commit messages should be clear and descriptive:**
   ```text
   ✅ Add: 50-day JavaScript roadmap with React
   🐛 Fix: Broken link in Java Phase 3, Day 42
   📝 Update: Clarify SQL JOIN explanation on Day 9
   ```
3. **Open a Pull Request (PR) against the main branch.**
   * **Describe what you changed and why.**
   * **If you're adding a new roadmap, include a screenshot of the landing page with the new track visible.**

4. **Wait for review – maintainers will review your PR and may suggest changes.**

5. **Once approved, your PR will be merged. 🎉**

---

## 📜 Licensing
By contributing to SkillForge, you agree that your contributions will be licensed under the MIT License (same as the project).

---

## 💬 Need Help?
* **Open a Discussion on GitHub.**
* **Reach out via email: manojsatna31@gmail.com**
* **Join the conversation on the issue tracker.**er.

---

## ✨ Thank You!
Every contribution, big or small, makes SkillForge better for learners everywhere.
You're awesome for helping out! 🙌   

---
## SkillForge – Forge your skills, shape your future. 🚀