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


const websiteBody = document.querySelector(".website-body");

async function loadPage(page) {
    try {
        // Load HTML
        const response = await fetch(`pages/${page}.html`);

        if (!response.ok) {
            throw new Error(`HTTP ${response.status}`);
        }

        const html = await response.text();
        websiteBody.innerHTML = html;

        // Load CSS
        let pageCSS = document.getElementById("page-css");

        if (!pageCSS) {
            pageCSS = document.createElement("link");
            pageCSS.id = "page-css";
            pageCSS.rel = "stylesheet";
            document.head.appendChild(pageCSS);
        }

        pageCSS.href = `css/${page}.css`;

        // Remove previous page's JavaScript
        const oldScript = document.getElementById("page-script");

        if (oldScript) {
            oldScript.remove();
        }

        // Load new page's JavaScript
        const pageScript = document.createElement("script");
        pageScript.id = "page-script";
        pageScript.src = `js/${page}.js`;

        document.body.appendChild(pageScript);

        console.log(`Successfully loaded: ${page}`);

    } catch (error) {
        console.error(`Failed to load ${page}:`, error);

        websiteBody.innerHTML = `
            <h1>Failed to load ${page}</h1>
            <p>${error.message}</p>
        `;
    }
}

document.querySelector(".dashboard-button").addEventListener("click", () => {
    loadPage("dashboard");
});

document.querySelectorAll(".module-button").forEach((button, index) => {
    button.addEventListener("click", () => {
        loadPage(`mem${index + 1}`);
    });
});

loadPage("dashboard"); 