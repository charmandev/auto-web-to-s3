document.addEventListener("DOMContentLoaded", function() {
    const container = document.querySelector('.carousel-inner');
    const prevButton = document.querySelector('.carousel-control-prev');
    const nextButton = document.querySelector('.carousel-control-next');
    let startX, startTranslate, currentTranslate = 0;

    function updateCarousel() {
        container.style.transform = `translateX(${currentTranslate}px)`;
        prevButton.style.display = currentTranslate < 0 ? 'block' : 'none';
        nextButton.style.display = currentTranslate > -(container.offsetWidth * (container.children.length - 1)) ? 'block' : 'none';
    }

    function initializeCarousel() {
        if (!container.classList.contains('initialized')) {
            container.classList.add('initialized');
            addTouchEvents();
            startAutoSlide();
        }
    }

    function addTouchEvents() {
        container.addEventListener('touchstart', (e) => {
            stopAutoSlide();
            startX = e.touches[0].clientX;
            startTranslate = currentTranslate;
        }, { passive: true });

        container.addEventListener('touchmove', (e) => {
            const touch = e.touches[0];
            const difference = touch.clientX - startX;
            const translate = startTranslate + difference;
            container.style.transform = `translateX(${translate}px)`;
            e.preventDefault();
        }, { passive: false });

        container.addEventListener('touchend', (e) => {
            const movedBy = startX - e.changedTouches[0].clientX;
            if (movedBy > 50) {
                currentTranslate -= container.offsetWidth;
            } else if (movedBy < -50) {
                currentTranslate += container.offsetWidth;
            }
            currentTranslate = Math.min(Math.max(currentTranslate, -container.offsetWidth * (container.children.length - 1)), 0);
            updateCarousel();
            startAutoSlide(); // Reiniciar la reproducción automática después de la interacción
        });
    }

    prevButton.addEventListener('click', () => {
        stopAutoSlide(); // Detener al hacer clic y luego actualizar
        if (currentTranslate < 0) {
            currentTranslate += container.offsetWidth;
            updateCarousel();
        }
    });

    nextButton.addEventListener('click', () => {
        stopAutoSlide(); // Detener al hacer clic y luego actualizar
        const maxTranslate = -(container.offsetWidth * (container.children.length - 1));
        if (currentTranslate > maxTranslate) {
            currentTranslate -= container.offsetWidth;
            updateCarousel();
        }
    });

    function disableCarousel() {
        if (container.classList.contains('initialized')) {
            container.classList.remove('initialized');
            container.removeEventListener('touchstart', addTouchEvents);
            container.removeEventListener('touchmove', addTouchEvents);
            container.removeEventListener('touchend', addTouchEvents);
            container.style.transform = 'none';
            clearInterval(autoSlideInterval);
        }
    }

    function toggleCarousel() {
        if (window.matchMedia("(max-width: 768px)").matches) {
            prevButton.style.display = 'block';
            nextButton.style.display = 'block';
            initializeCarousel();
        } else {
            prevButton.style.display = 'none';
            nextButton.style.display = 'none';
            disableCarousel();
        }
    }

    let autoSlideInterval = null;

    function startAutoSlide() {
        if (autoSlideInterval !== null) {
            clearInterval(autoSlideInterval);
        }
        autoSlideInterval = setInterval(() => {
            if (currentTranslate > -(container.offsetWidth * (container.children.length - 1))) {
                currentTranslate -= container.offsetWidth;
                updateCarousel();
            } else {
                currentTranslate = 0; // Reiniciar el carrusel al principio
                updateCarousel();
            }
        }, 5000);
    }

    function stopAutoSlide() {
        clearInterval(autoSlideInterval);
        startAutoSlide(); // Reiniciar el temporizador después de la interacción del usuario
    }

    toggleCarousel();
    window.addEventListener('resize', toggleCarousel);
});
