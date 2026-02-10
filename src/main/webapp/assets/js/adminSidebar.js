document.addEventListener("DOMContentLoaded", () => {
  const sidebar = document.getElementById("adminSidebar");
  const toggle = document.getElementById("adminSidebarToggle");
  const overlay = document.getElementById("sidebarOverlay");

  if (!sidebar || !toggle || !overlay) return;

  function openSidebar() {
    sidebar.classList.add("active");
    overlay.classList.add("active");
    document.body.classList.add("no-scroll");
  }

  function closeSidebar() {
    sidebar.classList.remove("active");
    overlay.classList.remove("active");
    document.body.classList.remove("no-scroll");
  }

  toggle.addEventListener("click", () => {
    const isOpen = sidebar.classList.contains("active");
    isOpen ? closeSidebar() : openSidebar();
  });

  overlay.addEventListener("click", closeSidebar);

  // Close when resizing back to desktop
  window.addEventListener("resize", () => {
    if (window.innerWidth >= 992) closeSidebar();
  });
});
