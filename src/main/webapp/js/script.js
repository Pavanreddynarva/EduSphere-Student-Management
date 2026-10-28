
document.addEventListener("DOMContentLoaded", () => {
    const searchInput = document.getElementById("studentSearch");
    const table = document.getElementById("studentTable");
    const noResultsRow = document.getElementById("noResultsRow");
    const resultCount = document.getElementById("resultCount");

    const addButton = document.getElementById("addStudentButton");
    const addSection = document.getElementById("addStudentSection");
    const closeButton = document.getElementById("closeAddForm");

    if (!table) return;

    const getStudentRows = () =>
        Array.from(table.querySelectorAll("tbody tr"))
            .filter(row => row.id !== "noResultsRow");

    // Search students.
    function searchStudents() {
        const query = searchInput.value.trim().toLowerCase();
        const rows = getStudentRows();
        let visibleCount = 0;

        rows.forEach(row => {
            const matches =
                row.textContent.toLowerCase().includes(query);

            row.hidden = !matches;

            if (matches) visibleCount++;
        });

        noResultsRow.hidden = visibleCount !== 0;

        resultCount.textContent =
            `Showing ${visibleCount} of ${rows.length} students`;
    }

    if (searchInput) {
        searchInput.addEventListener("input", searchStudents);
    }

    // Dashboard statistics.
    function updateStatistics() {
        const rows = getStudentRows();
        const departments = new Set();
        const marks = [];
        let passing = 0;

        rows.forEach(row => {
            const department = row.cells[2]?.textContent.trim();
            const markText = row.cells[4]?.textContent.trim();
            const mark = Number(markText);

            if (department) departments.add(department);

            if (
                markText !== "" &&
                markText !== "—" &&
                Number.isFinite(mark) &&
                mark >= 0 &&
                mark <= 100
            ) {
                marks.push(mark);
                if (mark >= 40) passing++;
            }
        });

        document.getElementById("departmentCount").textContent =
            departments.size;

        document.getElementById("averageMarks").textContent =
            marks.length
                ? (
                    marks.reduce((sum, mark) => sum + mark, 0) /
                    marks.length
                ).toFixed(1) + "%"
                : "—";

        document.getElementById("passingStudents").textContent =
            marks.length ? passing : "—";
    }

    // Open Add Student form.
    if (addButton && addSection) {
        addButton.addEventListener("click", () => {
            addSection.hidden = false;
            addSection.scrollIntoView({
                behavior: "smooth",
                block: "start"
            });
        });
    }

    // Close Add Student form.
    if (closeButton && addSection) {
        closeButton.addEventListener("click", () => {
            addSection.hidden = true;
        });
    }

    // Validate Add Student form.
    const addForm = document.getElementById("addStudentForm");
    const formMessage = document.getElementById("formMessage");

    if (addForm && formMessage) {
        addForm.addEventListener("submit", event => {
            const marksInput = document.getElementById("marks");
            const phoneInput = document.getElementById("phone");

            const marksValue = marksInput.value.trim();
            const phoneValue = phoneInput.value.trim();

            if (
                marksValue !== "" &&
                (
                    !Number.isFinite(Number(marksValue)) ||
                    Number(marksValue) < 0 ||
                    Number(marksValue) > 100
                )
            ) {
                event.preventDefault();

                formMessage.className = "alert alert-error";
                formMessage.textContent =
                    "Marks must be between 0 and 100.";
                formMessage.hidden = false;
                marksInput.focus();
                return;
            }

            if (
                phoneValue !== "" &&
                !/^[6-9]\d{9}$/.test(phoneValue)
            ) {
                event.preventDefault();

                formMessage.className = "alert alert-error";
                formMessage.textContent =
                    "Enter a valid 10-digit Indian mobile number.";
                formMessage.hidden = false;
                phoneInput.focus();
                return;
            }

            // Valid input is allowed to submit to the server.
            // Do NOT call event.preventDefault() here.
        });
    }

    updateStatistics();
});
