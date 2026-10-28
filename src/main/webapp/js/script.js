
document.addEventListener("DOMContentLoaded", function () {
    const addButton = document.getElementById("addStudentButton");
    const closeButton = document.getElementById("closeAddForm");
    const formSection = document.getElementById("addStudentSection");
    const form = document.getElementById("addStudentForm");
    const searchInput = document.getElementById("studentSearch");
    const table = document.getElementById("studentTable");

    // Open the Add Student form in create mode.
    if (addButton && formSection) {
        addButton.addEventListener("click", function () {
            if (form) {
                form.reset();

                const actionInput = form.querySelector('input[name="action"]');
                const studentIdInput = form.querySelector('input[name="studentId"]');

                if (actionInput) {
                    actionInput.value = "add";
                }

                if (studentIdInput) {
                    studentIdInput.remove();
                }
            }

            const heading = formSection.querySelector(".panel-title");
            const submitButton = form
                ? form.querySelector('button[type="submit"]')
                : null;

            if (heading) {
                heading.textContent = "Add New Student";
            }

            if (submitButton) {
                submitButton.textContent = "Save Student";
            }

            formSection.style.display = "block";
            formSection.scrollIntoView({
                behavior: "smooth",
                block: "start"
            });
        });
    }

    // Close the form.
    if (closeButton && formSection) {
        closeButton.addEventListener("click", function () {
            formSection.style.display = "none";
        });
    }

    // Search students.
    function searchStudents() {
        if (!searchInput || !table) return;

        const query = searchInput.value.trim().toLowerCase();
        const rows = table.querySelectorAll("tbody tr");
        let visibleCount = 0;

        rows.forEach(function (row) {
            if (row.id === "noResultsRow") return;

            const matches = row.textContent.toLowerCase().includes(query);
            row.style.display = matches ? "" : "none";

            if (matches) visibleCount++;
        });

        let noResultsRow = document.getElementById("noSearchResults");

        if (visibleCount === 0 && rows.length > 0) {
            if (!noResultsRow) {
                noResultsRow = document.createElement("tr");
                noResultsRow.id = "noSearchResults";

                const cell = document.createElement("td");
                cell.colSpan = 7;
                cell.className = "empty-state";
                cell.textContent = "No matching students found.";

                noResultsRow.appendChild(cell);
                table.querySelector("tbody").appendChild(noResultsRow);
            }

            noResultsRow.style.display = "";
        } else if (noResultsRow) {
            noResultsRow.style.display = "none";
        }

        const resultCount = document.getElementById("resultCount");
        if (resultCount) {
            resultCount.textContent = visibleCount + " student record(s)";
        }
    }

    if (searchInput) {
        searchInput.addEventListener("input", searchStudents);
    }

    // Validate marks and phone before submitting.
    if (form) {
        form.addEventListener("submit", function (event) {
            const marksInput = form.querySelector('[name="marks"]');
            const phoneInput = form.querySelector('[name="phone"]');

            if (marksInput && marksInput.value.trim() !== "") {
                const marks = Number(marksInput.value);

                if (!Number.isFinite(marks) || marks < 0 || marks > 100) {
                    event.preventDefault();
                    alert("Marks must be between 0 and 100.");
                    marksInput.focus();
                    return;
                }
            }

            if (phoneInput && phoneInput.value.trim() !== "") {
                const phone = phoneInput.value.trim();

                if (!/^[6-9]\d{9}$/.test(phone)) {
                    event.preventDefault();
                    alert("Enter a valid 10-digit Indian mobile number.");
                    phoneInput.focus();
                }
            }
        });
    }
});
