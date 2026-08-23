let currentPhase = 'prerequisite';                     // track which phase is active
const activeDayMap = {};                        // store active day per phase so navigation remembers each tab
const phaseSelectedSideBar = {                         // default first day per phase
    phase2: 'phase2DefaultActiveSideBar',
    phase3: 'phase3DefaultActiveSideBar',
    phase4: 'phase4DefaultActiveSideBar',
    phase5: 'phase5DefaultActiveSideBar',
    phase6: 'phase6DefaultActiveSideBar',
    phase7: 'phase7DefaultActiveSideBar',
    phase8: 'phase8DefaultActiveSideBar',
    phase9: 'phase9',
};
// ─── PHASE SWITCHING ──────────────────────────────────────────
// Collect the clickable phase tabs and their matching section containers.
const phaseTabs = document.querySelectorAll('.tab-btn');
const phaseSections = {
    phase1: document.getElementById('phase1'),
    phase2: document.getElementById('phase2'),
    phase3: document.getElementById('phase3'),
    phase4: document.getElementById('phase4'),
    phase5: document.getElementById('phase5'),
    phase6: document.getElementById('phase6'),
    phase7: document.getElementById('phase7'),
    phase8: document.getElementById('phase8'),
    phase9: document.getElementById('phase9'),
};
// Store the heading subtitle for each phase so the page header stays in sync.
const phaseSubtitles = {
    phase1: 'Setting Up Your Environment',
    phase2: 'Foundations &amp; Core Syntax',
    phase3: 'Core Data Structures & Modeling',
    phase4: 'Advanced Concepts &amp; Optimization',
    phase5: 'Expert Patterns & Production Systems',
    phase6: 'Test Your Knowledge',
    phase7: 'Bonus Track – Applied Projects',
    phase8: 'Quick Reference Guide',
    phase9: 'Essential Tools & Ecosystem'
};

(function () {
    'use strict';


    function switchPhase(phaseId) {
        // hide all phase sections
        Object.values(phaseSections).forEach(el => el.classList.remove('active'));
        // show target
        const target = phaseSections[phaseId];
        if (target) target.classList.add('active');
        // update tabs
        phaseTabs.forEach(btn => {
            btn.classList.toggle('active', btn.dataset.phase === phaseId);
        });

        // update header subtitle
        const subtitleEl = document.getElementById('phase-subtitle');
        if (subtitleEl && phaseSubtitles[phaseId]) {
            subtitleEl.innerHTML = phaseSubtitles[phaseId];
        }
        // update current phase and restore its active day
        currentPhase = phaseId;
        restoreActiveDay(phaseId);
    }

    phaseTabs.forEach(btn => {
        btn.addEventListener('click', function (e) {
            switchPhase(this.dataset.phase);
        });
    });

    // ─── DAY SWITCHING ──────────────────────────────────────────
    const dayBtns = document.querySelectorAll('.day-btn');
    const dayContents = document.querySelectorAll('.day-content');

    function switchDay(dayId, clickedBtn) {
        // Hide all day contents in the current phase
        const phaseSection = phaseSections[currentPhase];
        if (phaseSection) {
            phaseSection.querySelectorAll('.day-content').forEach(c => c.classList.remove('active'));
            // Remove active class from all day buttons in this phase
            phaseSection.querySelectorAll('.day-btn').forEach(b => b.classList.remove('active'));
        }

        // Show the target day content
        const target = document.getElementById(dayId);
        if (target) target.classList.add('active');
        if (clickedBtn) clickedBtn.classList.add('active');

        // Save this day as the active day for the current phase
        activeDayMap[currentPhase] = dayId;

        // Re-highlight code inside the newly shown content
        if (target) {
            Prism.highlightAllUnder(target);
        }
    }

    dayBtns.forEach(btn => {
        btn.addEventListener('click', function (e) {
            const dayId = this.dataset.day;
            switchDay(dayId, this);
        });
    });

    // ─── ensure day1 is active on load ──────────────────────────
    const hasActiveDay = Array.from(dayBtns).some(b => b.classList.contains('active'));
    if (!hasActiveDay) {
        const firstBtn = document.querySelector('.day-btn');
        if (firstBtn) {
            firstBtn.classList.add('active');
            const firstDay = document.getElementById(firstBtn.dataset.day);
            if (firstDay) firstDay.classList.add('active');
        }
    }

    function restoreActiveDay(phaseId) {
        // Get the saved day for this phase, or use the first day
        const savedDay = activeDayMap[phaseId] || phaseSelectedSideBar[phaseId];
        if (!savedDay) return;

        // Find the corresponding day button within this phase
        const phaseSection = phaseSections[phaseId];
        if (!phaseSection) return;

        // Find the day button with the matching data-day attribute
        const btn = phaseSection.querySelector(`.day-btn[data-day="${savedDay}"]`);
        if (btn) {
            // Remove active class from all day buttons in this phase
            phaseSection.querySelectorAll('.day-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');

            // Show the corresponding day content
            const dayContent = document.getElementById(savedDay);
            if (dayContent) {
                // Hide all day-content within this phase
                phaseSection.querySelectorAll('.day-content').forEach(c => c.classList.remove('active'));
                dayContent.classList.add('active');
                // Re-highlight code if needed
                Prism.highlightAllUnder(dayContent);
            }
        }
    }

    // ─── COPY BUTTON ─────────────────────────────────────────────
    window.copyCode = async function (button) {
        const container = button.closest('.code-container');
        const code = container.querySelector('code');
        const text = code.innerText;

        try {
            await navigator.clipboard.writeText(text);
            button.innerText = '✓ Copied';
            button.classList.add('copied');
            setTimeout(() => {
                button.innerText = 'Copy';
                button.classList.remove('copied');
            }, 2000);
        } catch (err) {
            console.error('Copy failed:', err);
        }
    };

    // ─── initial highlight ──────────────────────────────────────
    Prism.highlightAll();

})();
