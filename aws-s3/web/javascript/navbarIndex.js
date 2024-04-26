




const toggleBtn = document.querySelector('.toggle_btn');
const toggleBtnIcon = document.querySelector('.toggle_btn i');
const dropdownMenu = document.querySelector('.dropdown_menu');

toggleBtn.onclick = function () {
    dropdownMenu.classList.toggle('open');
    const isOpen = dropdownMenu.classList.contains('open');

    toggleBtnIcon.className = isOpen
        ? 'fa-solid fa-xmark'
        : 'fa-solid fa-bars';
};

// Agrega este listener para cerrar el menú al hacer clic fuera de él
document.addEventListener('click', function(event) {
  if (!event.target.closest('.navbar')) {
    dropdownMenu.classList.remove('open');
    toggleBtnIcon.classList = 'fa-solid fa-bars';
  }
});
