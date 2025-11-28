<footer class="footer text-center py-3">
    <p>© 2025 Silver Care. All Rights Reserved.</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
document.addEventListener("DOMContentLoaded", () => {
    const sidebar = document.getElementById("adminSidebar");
    const toggleBtn = document.querySelector(".admin-sidebar-toggle");
    const overlay = document.getElementById("sidebarOverlay");

    function openSidebar() {
        sidebar.classList.add("active");
        overlay.classList.add("active");
    }

    function closeSidebar() {
        sidebar.classList.remove("active");
        overlay.classList.remove("active");
    }

    toggleBtn.addEventListener("click", () => {
        if (sidebar.classList.contains("active")) {
            closeSidebar();
        } else {
            openSidebar();
        }
    });

    overlay.addEventListener("click", closeSidebar);
});
</script>
</body>
</html>

