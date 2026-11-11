const navMenu = document.querySelector(".navigation-menu");
const menuButton = document.querySelector(".menu-button");

let isPinned = false;

// Expand when hovering over the menu button
menuButton.addEventListener("mouseenter", () => {
    navMenu.classList.add("expanded");
});

// Collapse when leaving the navigation menu, unless pinned
navMenu.addEventListener("mouseleave", () => {
    if (!isPinned) {
        navMenu.classList.remove("expanded");
    }
});

// Toggle pinned state when clicking
menuButton.addEventListener("click", () => {
    isPinned = !isPinned;

    if(isPinned) {
        navMenu.classList.add("expanded");
    }
    else {
        navMenu.classList.remove("expanded");
    }
});

//dashboard and modules

const expandableButtons = document.querySelectorAll(
    ".dashboard-button, .module-button"
);

// Dashboard is pinned by default
let pinnedButton = document.querySelector(".dashboard-button");
let hoveredButton = null;

function updateButtons() {
    expandableButtons.forEach((button) => {
        const isHovered = hoveredButton === button;
        const isPinned = pinnedButton === button;

        // Only the hovered button expands,
        // or the pinned button if nothing is hovered
        const shouldExpand = isHovered ||
            (isPinned && hoveredButton === null);

        button.classList.toggle("expanded", shouldExpand);

        // Pinned appearance remains even when another button is hovered
        button.classList.toggle("pinned", isPinned);
    });
}

expandableButtons.forEach((button) => {

    button.addEventListener("mouseenter", () => {
        hoveredButton = button;
        updateButtons();
    });

    button.addEventListener("mouseleave", () => {
        if (hoveredButton === button) {
            hoveredButton = null;
        }

        updateButtons();
    });

    button.addEventListener("click", () => {
        // Clicking the pinned button does nothing
        if (pinnedButton === button) {
            return;
        }

        // Pin the newly clicked button
        pinnedButton = button;
        updateButtons();
    });
});

// Apply default pinned state on page load
updateButtons();